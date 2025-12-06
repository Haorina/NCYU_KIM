package com.example.ncyu_kim.mediapipelib

import android.content.Context
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.util.Log
import android.graphics.Bitmap
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarker
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarker.PoseLandmarkerOptions
import java.io.File
import java.io.FileInputStream
import java.time.LocalDateTime
import kotlin.math.max
import kotlin.math.sqrt

class VideoProcessor(
    private val context: Context,
    private val modelPath: String = "models/pose_landmarker_full.task",
    private val outputDir: File
) {
    private var landmarker: PoseLandmarker? = null
    private val is3d = true

    // 與 Python 對齊："" -> 0
    private val poseMapping = linkedMapOf(
        "" to 0,
        "A1" to 1, "A2" to 2, "A3-1" to 3, "A3-2" to 4, "A4-1" to 5,
        "A4-2" to 6, "A5-1" to 7, "A5-2" to 8, "A5-3" to 9
    )

    // 與 Python 對齊：0 -> 1
    private val fineToCoarse = mapOf(
        0 to 1,
        1 to 1, 2 to 2, 3 to 3, 4 to 3, 5 to 4, 6 to 4, 7 to 5, 8 to 5, 9 to 5
    )
    private val coarseToRepFine = mapOf(
        1 to 1, 2 to 2, 3 to 3, 4 to 5, 5 to 7
    )
    private val coarseName = mapOf(
        1 to "A1", 2 to "A2", 3 to "A3", 4 to "A4", 5 to "A5"
    )
    private val poseScores = mapOf(
        Pair(1, 1) to 0, Pair(1, 2) to 3, Pair(1, 3) to 3, Pair(1, 4) to 7, Pair(1, 5) to 9,
        Pair(2, 2) to 5, Pair(2, 3) to 5, Pair(2, 4) to 10, Pair(2, 5) to 13,
        Pair(3, 3) to 5, Pair(3, 4) to 10, Pair(3, 5) to 13,
        Pair(4, 4) to 15, Pair(4, 5) to 18, Pair(5, 5) to 20
    )

    private val poseLabelReverse = poseMapping.entries.associate { (k, v) -> v to k }

    fun initialize() {
        if (landmarker != null) return
        Log.d("VideoProcessor", "Initializing PoseLandmarker with model=$modelPath")
        val baseOptions = BaseOptions.builder().setModelAssetPath(modelPath).build()
        val options = PoseLandmarkerOptions.builder()
            .setBaseOptions(baseOptions)
            .setRunningMode(RunningMode.VIDEO)
            .build()
        try {
            landmarker = PoseLandmarker.createFromOptions(context, options)
            Log.d("VideoProcessor", "PoseLandmarker initialized successfully")
        } catch (e: Exception) {
            Log.e("VideoProcessor", "Failed to initialize PoseLandmarker", e)
            throw e
        }
    }

    fun close() {
        landmarker?.close()
        landmarker = null
        Log.d("VideoProcessor", "PoseLandmarker closed")
    }

    fun processVideo(videoFile: File): LinkedHashMap<String, Any?> {
        // 若尚未初始化（直接呼叫 processor 時），則初始化
        if (landmarker == null) {
            initialize()
        }
        val lm = landmarker ?: throw IllegalStateException("landmarker is null after initialize()")

        val retriever = MediaMetadataRetriever()
        try {
            if (!videoFile.exists()) {
                Log.e("VideoProcessor", "Video file does not exist: ${videoFile.absolutePath}")
                throw IllegalArgumentException("Video file not found: ${videoFile.absolutePath}")
            }
            if (videoFile.length() == 0L) {
                Log.e("VideoProcessor", "Video file is empty: ${videoFile.absolutePath}")
                throw IllegalArgumentException("Video file is empty: ${videoFile.absolutePath}")
            }

            // setDataSource 多重嘗試（提升魯棒性）
            var setOk = false
            try {
                retriever.setDataSource(videoFile.absolutePath)
                setOk = true
                Log.d("VideoProcessor", "setDataSource using absolutePath succeeded")
            } catch (e: Exception) {
                Log.w("VideoProcessor", "setDataSource absolutePath failed, will try FileDescriptor/Uri. err=${e.message}")
            }
            if (!setOk) {
                try {
                    FileInputStream(videoFile).use { fis ->
                        retriever.setDataSource(fis.fd)
                    }
                    setOk = true
                    Log.d("VideoProcessor", "setDataSource using FileDescriptor succeeded")
                } catch (e: Exception) {
                    Log.w("VideoProcessor", "setDataSource FileDescriptor failed: ${e.message}")
                }
            }
            if (!setOk) {
                try {
                    val uri = Uri.fromFile(videoFile)
                    retriever.setDataSource(context, uri)
                    setOk = true
                    Log.d("VideoProcessor", "setDataSource using Context+Uri succeeded")
                } catch (e: Exception) {
                    Log.w("VideoProcessor", "setDataSource context+uri failed: ${e.message}")
                }
            }
            if (!setOk) {
                try {
                    retriever.setDataSource("file://${videoFile.absolutePath}")
                    setOk = true
                    Log.d("VideoProcessor", "setDataSource using file:// absPath succeeded")
                } catch (e: Exception) {
                    Log.w("VideoProcessor", "setDataSource file:// failed: ${e.message}")
                }
            }
            if (!setOk) {
                Log.e("VideoProcessor", "All setDataSource attempts failed for ${videoFile.absolutePath}")
                throw RuntimeException("setDataSource failed for ${videoFile.absolutePath}")
            }

            val durationMs = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0L
            val fps = getFrameRate(retriever).toInt().coerceAtLeast(1)
            val frameCount = if (durationMs > 0L) (durationMs.toDouble() / 1000.0 * fps.toDouble()).toInt() else 0
            Log.d("VideoProcessor", "Processing video: path=${videoFile.absolutePath}, duration=$durationMs ms, fps=$fps, frameCount=$frameCount")

            val labels = mutableListOf<Int?>()
            val aArray = mutableListOf<Boolean>()
            val bArray = mutableListOf<Boolean>()
            val cArray = mutableListOf<Boolean>()
            val dArray = mutableListOf<Boolean>()
            var landmarkFrames = 0

            val effectiveFrameCount = if (frameCount > 0) frameCount else {
                val altFrameCount = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_FRAME_COUNT)?.toIntOrNull() ?: 0
                if (altFrameCount > 0) altFrameCount else {
                    val fallback = if (durationMs > 0L) ((durationMs.toDouble() / 1000.0) * 30.0).toInt() else 0
                    max(1, fallback)
                }
            }

            // --- 主迴圈：逐幀抽樣並偵測 ---
            for (frameIndex in 0 until effectiveFrameCount) {
                val timeUs = (frameIndex.toDouble() * 1_000_000.0 / fps.toDouble()).toLong()
                var bitmap: Bitmap? = null
                try {
                    // OPTION_CLOSEST 比較靠近指定時間點（可與 OPTION_CLOSEST_SYNC 做比較）
                    bitmap = retriever.getFrameAtTime(timeUs, MediaMetadataRetriever.OPTION_CLOSEST)
                    if (bitmap == null) {
                        Log.w("VideoProcessor", "Failed to extract frame at index=$frameIndex, timeUs=$timeUs")
                        // 與 Python 一致：每幀都要有 labels（預設 0），A/B/C/D 補 False
                        labels.add(0)
                        aArray.add(false); bArray.add(false); cArray.add(false); dArray.add(false)
                        continue
                    }

                    val mpImage = BitmapImageBuilder(bitmap).build()

                    // *** 與 Python 對齊：使用 wall-clock timestamp
                    val timestampMs = System.currentTimeMillis()
                    val result = lm.detectForVideo(mpImage, timestampMs)

                    val poseResult = PoseResult(result)
                    val analyzer = ResultAnalyzer(poseResult)

                    // 與 Python 一致：不論 landmarks 是否存在，先取 label 並把對應 int 加入 labels（default 0）
                    val labelStr = analyzer.getLhcLabel(is3d)
                    val labelInt = poseMapping[labelStr] ?: 0
                    labels.add(labelInt)

                    if (result.landmarks().isNotEmpty()) {
                        landmarkFrames++
                        aArray.add(analyzer.checkIfTrunkIsTwistedOrLateralInclination(is3d))
                        bArray.add(analyzer.checkIfHandsAtADistance(is3d))
                        cArray.add(analyzer.checkIfArmsRaised(is3d))
                        dArray.add(analyzer.checkIfHandsAboveShoulder(is3d))
                        Log.d("VideoProcessor", "Frame $frameIndex: label=$labelStr, a=${aArray.last()}, b=${bArray.last()}, c=${cArray.last()}, d=${dArray.last()}")
                    } else {
                        aArray.add(false); bArray.add(false); cArray.add(false); dArray.add(false)
                        Log.d("VideoProcessor", "Frame $frameIndex: No landmarks detected, labelInt=$labelInt")
                    }
                } catch (e: Exception) {
                    Log.w("VideoProcessor", "Exception processing frame $frameIndex: ${e.message}")
                    labels.add(0)
                    aArray.add(false); bArray.add(false); cArray.add(false); dArray.add(false)
                } finally {
                    try { bitmap?.recycle() } catch (e: Exception) { Log.w("VideoProcessor","bitmap.recycle() failed: ${e.message}") }
                }
            }

            // --- 與 Python 等價的後處理（時序濾波與收斂） ---
            var totalFrames = labels.size
            val checkPersonInScreen = if (totalFrames > 0) (landmarkFrames.toDouble() / totalFrames.toDouble() < 0.5) else true
            if (checkPersonInScreen) {
                // 不 early-return，僅記錄（與 Python 行為對齊）
                Log.w("VideoProcessor", "Insufficient person detection: landmarkFrames=$landmarkFrames, totalFrames=$totalFrames")
            }

            val coarseLabels = labels.map { fineToCoarse[it ?: 1] ?: 1 }
            val csv = max(1, fps * 3)

            fun getCon(coarseLabel: Int): Int = when (coarseLabel) {
                1 -> 20
                2 -> 10
                3 -> 15
                4 -> 10
                5 -> 5
                else -> 1
            }

            fun majorityFineLabel(startIdx: Int, endIdxExclusive: Int, coarse: Int): Int {
                if (startIdx >= labels.size) {
                    Log.w("VideoProcessor", "Invalid startIdx=$startIdx for majorityFineLabel")
                    return coarseToRepFine[coarse] ?: 1
                }
                val end = endIdxExclusive.coerceAtMost(labels.size)
                val seq = labels.subList(startIdx, end)
                    .filter { it != null && fineToCoarse[it] == coarse }
                    .map { it!! }
                if (seq.isEmpty()) {
                    Log.w("VideoProcessor", "Empty sequence for majorityFineLabel: startIdx=$startIdx, endIdx=$end")
                    return coarseToRepFine[coarse] ?: 1
                }
                val cnt = seq.groupingBy { it }.eachCount()
                val result = cnt.entries.sortedWith(compareByDescending<Map.Entry<Int, Int>> { it.value }.thenBy { it.key }).first().key
                Log.d("VideoProcessor", "majorityFineLabel: startIdx=$startIdx, endIdx=$end, coarse=$coarse, result=$result")
                return result
            }

            val labelChangesCoarse = mutableListOf<Int>()
            val labelChangesFine = mutableListOf<Int>()

            var currentCoarse = coarseLabels[0]
            var con = getCon(currentCoarse)
            var consecutiveCount = 0
            var segmentStart = 0
            var previousCoarse: Int? = null
            var previousCount = 0
            var previousFine: Int? = null
            var isFirst = false

            for (i in coarseLabels.indices) {
                val cl = coarseLabels[i]
                if (cl == currentCoarse) {
                    consecutiveCount++
                } else if (consecutiveCount < con) {
                    for (j in 1..consecutiveCount) {
                        val idx = i - j
                        if (idx >= 0) {
                            aArray[idx] = false
                            bArray[idx] = false
                            cArray[idx] = false
                            dArray[idx] = false
                            labels[idx] = null
                            totalFrames--
                        }
                    }
                    currentCoarse = cl
                    con = getCon(currentCoarse)
                    consecutiveCount = 1
                    segmentStart = i
                } else {
                    val fineRep = majorityFineLabel(segmentStart, i, currentCoarse)
                    if (!isFirst) {
                        previousCoarse = currentCoarse
                        previousCount = consecutiveCount
                        previousFine = fineRep
                        isFirst = true
                    } else if (currentCoarse == previousCoarse) {
                        previousCount += consecutiveCount
                    } else {
                        labelChangesCoarse.add(previousCoarse!!)
                        labelChangesFine.add(previousFine!!)
                        var tmp = previousCount
                        while (tmp >= csv) {
                            labelChangesCoarse.add(previousCoarse!!)
                            labelChangesFine.add(previousFine!!)
                            tmp -= csv
                        }
                        previousCoarse = currentCoarse
                        previousCount = consecutiveCount
                        previousFine = fineRep
                    }
                    currentCoarse = cl
                    con = getCon(currentCoarse)
                    consecutiveCount = 1
                    segmentStart = i
                }
                if (i == coarseLabels.lastIndex) {
                    if (consecutiveCount < con) {
                        for (j in segmentStart until coarseLabels.size) {
                            aArray[j] = false
                            bArray[j] = false
                            cArray[j] = false
                            dArray[j] = false
                            labels[j] = null
                            totalFrames--
                        }
                        if (isFirst) {
                            labelChangesCoarse.add(previousCoarse!!)
                            labelChangesFine.add(previousFine!!)
                            var tmp = previousCount
                            while (tmp >= csv) {
                                labelChangesCoarse.add(previousCoarse!!)
                                labelChangesFine.add(previousFine!!)
                                tmp -= csv
                            }
                        }
                    } else {
                        val fineRepEnd = majorityFineLabel(segmentStart, i + 1, currentCoarse)
                        if (!isFirst) {
                            labelChangesCoarse.add(currentCoarse)
                            labelChangesFine.add(fineRepEnd)
                            var tmp = consecutiveCount
                            while (tmp >= csv) {
                                labelChangesCoarse.add(currentCoarse)
                                labelChangesFine.add(fineRepEnd)
                                tmp -= csv
                            }
                        } else {
                            if (previousCoarse == currentCoarse) {
                                val totalLen = previousCount + consecutiveCount
                                labelChangesCoarse.add(previousCoarse!!)
                                labelChangesFine.add(previousFine!!)
                                var tmp = totalLen
                                while (tmp >= csv) {
                                    labelChangesCoarse.add(previousCoarse!!)
                                    labelChangesFine.add(previousFine!!)
                                    tmp -= csv
                                }
                            } else {
                                labelChangesCoarse.add(previousCoarse!!)
                                labelChangesFine.add(previousFine!!)
                                var tmp = previousCount
                                while (tmp >= csv) {
                                    labelChangesCoarse.add(previousCoarse!!)
                                    labelChangesFine.add(previousFine!!)
                                    tmp -= csv
                                }
                                labelChangesCoarse.add(currentCoarse)
                                labelChangesFine.add(fineRepEnd)
                                var tmp2 = consecutiveCount
                                while (tmp2 >= csv) {
                                    labelChangesCoarse.add(currentCoarse)
                                    labelChangesFine.add(fineRepEnd)
                                    tmp2 -= csv
                                }
                            }
                        }
                    }
                }
            }

            Log.d("VideoProcessor", "labelChangesCoarse=$labelChangesCoarse, labelChangesFine=$labelChangesFine")

            var bestPair: Pair<Int, Int>? = null
            var maxScore = 0
            if (labelChangesCoarse.size >= 2) {
                for (i in 0 until labelChangesCoarse.size - 1) {
                    val pair1 = Pair(labelChangesCoarse[i], labelChangesCoarse[i + 1])
                    val pair2 = Pair(labelChangesCoarse[i + 1], labelChangesCoarse[i])
                    val score = maxOf(poseScores[pair1] ?: 0, poseScores[pair2] ?: 0)
                    if (score > maxScore) {
                        maxScore = score
                        bestPair = pair1
                    }
                }
            } else if (labelChangesCoarse.size == 1) {
                bestPair = Pair(labelChangesCoarse[0], labelChangesCoarse[0])
                maxScore = poseScores[bestPair] ?: 0
            }

            fun getFrequencyScore(ratio: Double, none: Double, occasional: Double, frequent: Double): Double {
                val result = when {
                    ratio < 1.0 / 9.0 -> none
                    ratio < 1.0 / 3.0 -> occasional
                    else -> frequent
                }
                Log.d("VideoProcessor", "getFrequencyScore: ratio=$ratio, none=$none, occasional=$occasional, frequent=$frequent, result=$result")
                return result
            }

            val totalFramesF = totalFrames.coerceAtLeast(1).toDouble()
            val aRatio = aArray.count { it }.toDouble() / totalFramesF
            val bRatio = bArray.count { it }.toDouble() / totalFramesF
            val cRatio = cArray.count { it }.toDouble() / totalFramesF
            val dRatio = dArray.count { it }.toDouble() / totalFramesF
            Log.d("VideoProcessor", "Ratios: aRatio=$aRatio, bRatio=$bRatio, cRatio=$cRatio, dRatio=$dRatio")

            val aScore = getFrequencyScore(aRatio, 0.0, 1.0, 3.0)
            val bScore = getFrequencyScore(bRatio, 0.0, 1.0, 3.0)
            val cScore = getFrequencyScore(cRatio, 0.0, 0.5, 1.0)
            val dScore = getFrequencyScore(dRatio, 0.0, 1.0, 2.0)
            Log.d("VideoProcessor", "Scores: aScore=$aScore, bScore=$bScore, cScore=$cScore, dScore=$dScore")

            var extraScore = aScore + bScore + cScore + dScore
            if (extraScore > 6.0) extraScore = 6.0

            val totalScore = maxScore.toDouble() + extraScore

            val fStart = bestPair?.first?.let { coarseToRepFine[it] } ?: 0
            val fEnd = bestPair?.second?.let { coarseToRepFine[it] } ?: 0
            val worstChangeFinePair = if (bestPair != null) {
                listOf(poseLabelReverse[fStart] ?: "A$fStart", poseLabelReverse[fEnd] ?: "A$fEnd")
            } else null

            Log.d("VideoProcessor", "Final result: maxScore=$maxScore, extraScore=$extraScore, totalScore=$totalScore, bestPair=$bestPair")

            return linkedMapOf(
                "totalFrame" to totalFrames,
                "BodyPosturePoint" to maxScore,
                "Addition Point" to extraScore,
                "twistAndLanternal" to aScore,
                "distance of body" to bScore,
                "arm raise" to cScore,
                "above shoulder" to dScore,
                "total_score" to totalScore,
                "start" to fStart,
                "end" to fEnd,
                "start_name" to bestPair?.first?.let { coarseName[it] },
                "end_name" to bestPair?.second?.let { coarseName[it] },
                "pose_changes_coarse" to labelChangesCoarse.map { coarseName[it] ?: "" },
                "pose_changes_fine" to labelChangesFine.map { poseLabelReverse[it] ?: "" },
                "worst_change_fine" to worstChangeFinePair,
                "checkPersonInScreen" to checkPersonInScreen,
                "timeStamp" to LocalDateTime.now().toString().replace(":", "-").replace(".", "-")
            )
        } catch (e: Exception) {
            Log.e("VideoProcessor", "Error processing video", e)
            throw e
        } finally {
            try { close() } catch (e: Exception) { Log.w("VideoProcessor", "close() error: ${e.message}") }
            try { retriever.release() } catch (e: Exception) { Log.w("VideoProcessor", "retriever.release() error: ${e.message}") }
        }
    }

    private fun getFrameRate(retriever: MediaMetadataRetriever): Double {
        val fpsFromCapture = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_CAPTURE_FRAMERATE)?.toDoubleOrNull()
        val fps = fpsFromCapture ?: retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_FRAME_COUNT)
            ?.toDoubleOrNull()?.let { frameCount ->
                val durationMs = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0L
                if (durationMs > 0L) (frameCount * 1000.0 / durationMs.toDouble()) else 30.0
            } ?: 30.0
        Log.d("VideoProcessor", "Calculated FPS: $fps")
        return fps
    }
}
