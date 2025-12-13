package com.example.ncyu_kim.mediapipelib

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.util.Log
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.framework.image.MPImage
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarker
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarker.PoseLandmarkerOptions
import java.io.BufferedWriter
import java.io.File
import java.io.FileInputStream
import java.io.FileWriter
import java.time.LocalDateTime
import kotlin.math.max

class VideoProcessor(
    private val context: Context,
    private val modelPath: String = "models/pose_landmarker_full.task",
    private val outputDir: File
) {
    private var landmarker: PoseLandmarker? = null

    // 與 Python 對齊：未知/空字串 -> 0
    private val poseMapping = linkedMapOf(
        "" to 0,
        "A1" to 1, "A2" to 2, "A3-1" to 3, "A3-2" to 4, "A4-1" to 5,
        "A4-2" to 6, "A5-1" to 7, "A5-2" to 8, "A5-3" to 9
    )
    private val poseLabelReverse = poseMapping.entries.associate { (k, v) -> v to k }

    // Python: fine_to_coarse
    private val fineToCoarse = mapOf(
        1 to 1, 2 to 2, 3 to 3, 4 to 3, 5 to 4, 6 to 4, 7 to 5, 8 to 5, 9 to 5
    )
    private val coarseToRepFine = mapOf(1 to 1, 2 to 2, 3 to 3, 4 to 5, 5 to 7)
    private val coarseName = mapOf(1 to "A1", 2 to "A2", 3 to "A3", 4 to "A4", 5 to "A5")

    // Python: pose_scores
    private val poseScores = mapOf(
        Pair(1, 1) to 0,  Pair(1, 2) to 3,  Pair(1, 3) to 3,  Pair(1, 4) to 7,  Pair(1, 5) to 9,
        Pair(2, 2) to 5,  Pair(2, 3) to 5,  Pair(2, 4) to 10, Pair(2, 5) to 13,
        Pair(3, 3) to 5,  Pair(3, 4) to 10, Pair(3, 5) to 13,
        Pair(4, 4) to 15, Pair(4, 5) to 18,
        Pair(5, 5) to 20
    )

    fun initialize() {
        if (landmarker != null) return
        Log.d("VideoProcessor", "Initializing PoseLandmarker with model=$modelPath")
        val baseOptions = BaseOptions.builder().setModelAssetPath(modelPath).build()
        val options = PoseLandmarkerOptions.builder()
            .setBaseOptions(baseOptions)
            .setRunningMode(RunningMode.VIDEO)
            .build()
        landmarker = PoseLandmarker.createFromOptions(context, options)
        Log.d("VideoProcessor", "PoseLandmarker initialized successfully")
    }

    fun close() {
        landmarker?.close()
        landmarker = null
        Log.d("VideoProcessor", "PoseLandmarker closed")
    }

    fun processVideo(videoFile: File): LinkedHashMap<String, Any?> {
        var checkPersonInScreen = false // Python: 預設 False（只有 exception 才 True）

        if (landmarker == null) initialize()
        val lm = landmarker ?: throw IllegalStateException("landmarker is null after initialize()")
        val retriever = MediaMetadataRetriever()

        val landmarksFile = File(outputDir, "${videoFile.nameWithoutExtension}_landmarks.txt")
        val abcdFile = File(outputDir, "${videoFile.nameWithoutExtension}_abcd.txt")
        var landmarksWriter: BufferedWriter? = null
        var abcdWriter: BufferedWriter? = null

        try {
            landmarksWriter = BufferedWriter(FileWriter(landmarksFile))
            abcdWriter = BufferedWriter(FileWriter(abcdFile))

            landmarksWriter.write("=== 3D Pose Landmarks (MediaPipe World Coordinates) ===\n")
            landmarksWriter.write("Video: ${videoFile.name}\n")
            landmarksWriter.write("Generated: ${LocalDateTime.now()}\n\n")

            abcdWriter.write("=== REBA 加分項 ABCD 逐幀紀錄 ===\n")
            abcdWriter.write("Video: ${videoFile.name}\n")
            abcdWriter.write("A=軀幹扭轉或側彎, B=手臂遠離身體, C=手臂舉高, D=手高於肩膀\n\n")

            if (!videoFile.exists()) throw IllegalArgumentException("Video file not found: ${videoFile.absolutePath}")
            if (videoFile.length() == 0L) throw IllegalArgumentException("Video file is empty: ${videoFile.absolutePath}")

            // setDataSource 多重嘗試
            var setOk = false
            try { retriever.setDataSource(videoFile.absolutePath); setOk = true } catch (_: Exception) {}
            if (!setOk) try { FileInputStream(videoFile).use { retriever.setDataSource(it.fd) }; setOk = true } catch (_: Exception) {}
            if (!setOk) try { retriever.setDataSource(context, Uri.fromFile(videoFile)); setOk = true } catch (_: Exception) {}
            if (!setOk) try { retriever.setDataSource("file://${videoFile.absolutePath}"); setOk = true } catch (_: Exception) {}
            if (!setOk) throw RuntimeException("All setDataSource attempts failed")

            val durationMs = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0L
            val fps = getFrameRate(retriever).toInt().coerceAtLeast(1)

            val frameCount = if (durationMs > 0L) (durationMs.toDouble() / 1000.0 * fps.toDouble()).toInt() else 0
            val effectiveFrameCount = if (frameCount > 0) frameCount else {
                val alt = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_FRAME_COUNT)?.toIntOrNull() ?: 0
                if (alt > 0) alt else max(1, (durationMs.toDouble() / 1000.0 * 30.0).toInt())
            }

            val labels = mutableListOf<Int?>()
            val aArray = mutableListOf<Boolean>()
            val bArray = mutableListOf<Boolean>()
            val cArray = mutableListOf<Boolean>()
            val dArray = mutableListOf<Boolean>()

            // ==================== 主迴圈 ====================
            for (frameIndex in 0 until effectiveFrameCount) {
                val timeUs = (frameIndex.toDouble() * 1_000_000.0 / fps.toDouble()).toLong()
                var bitmap: Bitmap? = null

                try {
                    bitmap = retriever.getFrameAtTime(timeUs, MediaMetadataRetriever.OPTION_CLOSEST)
                    if (bitmap == null) {
                        labels.add(0)
                        aArray.add(false); bArray.add(false); cArray.add(false); dArray.add(false)
                        landmarksWriter.write("Frame $frameIndex: No frame extracted\n\n")
                        abcdWriter.write("Frame $frameIndex: No frame extracted\n")
                        continue
                    }

                    val argb8888Frame = if (bitmap.config == Bitmap.Config.ARGB_8888) bitmap
                    else bitmap.copy(Bitmap.Config.ARGB_8888, false)

                    val mpImage: MPImage = BitmapImageBuilder(argb8888Frame).build()

                    if (argb8888Frame != bitmap) bitmap.recycle()

                    val timestampMs = System.currentTimeMillis()
                    val result = lm.detectForVideo(mpImage, timestampMs)

                    val poseResult = PoseResult(result)
                    val analyzer = ResultAnalyzer(poseResult)

                    val labelStr = analyzer.getLhcLabel()
                    val labelInt = poseMapping[labelStr] ?: 0
                    labels.add(labelInt)

                    landmarksWriter.write("Frame $frameIndex (Label: $labelStr):\n")

                    if (result.landmarks().isNotEmpty()) {
                        val a = analyzer.checkIfTrunkIsTwistedOrLateralInclination()
                        val b = analyzer.checkIfHandsAtADistance()
                        val c = analyzer.checkIfArmsRaised()
                        val d = analyzer.checkIfHandsAboveShoulder()
                        aArray.add(a); bArray.add(b); cArray.add(c); dArray.add(d)

                        abcdWriter.write("Frame $frameIndex: A=$a, B=$b, C=$c, D=$d\n")

                        val positions = poseResult.getAllKptPositions()
                        positions.forEachIndexed { idx, pos ->
                            val name = KPT_LIST.getOrNull(idx) ?: "unknown_$idx"
                            val x = pos.getOrNull(0) ?: 0.0
                            val y = pos.getOrNull(1) ?: 0.0
                            val z = pos.getOrNull(2) ?: 0.0
                            landmarksWriter.write("$name: x=%.6f, y=%.6f, z=%.6f\n".format(x, y, z))
                        }
                    } else {
                        aArray.add(false); bArray.add(false); cArray.add(false); dArray.add(false)
                        abcdWriter.write("Frame $frameIndex: No person detected\n")
                        landmarksWriter.write("No landmarks detected\n")
                    }

                    landmarksWriter.write("\n")
                } catch (e: Exception) {
                    Log.w("VideoProcessor", "Exception frame $frameIndex: ${e.message}")
                    labels.add(0)
                    aArray.add(false); bArray.add(false); cArray.add(false); dArray.add(false)
                    landmarksWriter.write("Frame $frameIndex: Error - ${e.message}\n\n")
                    abcdWriter.write("Frame $frameIndex: Error processing\n")
                } finally {
                    bitmap?.recycle()
                }
            }

            // ==================== 後處理（照你原本 Kotlin 的濾波流程；它已對齊 Python） ====================
            var totalFrames = labels.size

            // Python: 不在正常流程更新 checkPersonInScreen；保持 false
            // (你若未來要做「人是否入鏡」判斷，再另外加，不然兩端會不一致)

            val coarseLabels = labels.map { it?.let { fineToCoarse[it] ?: 1 } ?: 1 }
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
                if (startIdx >= labels.size) return coarseToRepFine[coarse] ?: 1
                val end = endIdxExclusive.coerceAtMost(labels.size)
                val seq = labels.subList(startIdx, end)
                    .filter { it != null && fineToCoarse[it] == coarse }
                    .map { it!! }
                if (seq.isEmpty()) return coarseToRepFine[coarse] ?: 1
                val cnt = seq.groupingBy { it }.eachCount()
                return cnt.entries.sortedWith(compareByDescending<Map.Entry<Int, Int>> { it.value }.thenBy { it.key }).first().key
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
                            aArray[idx] = false; bArray[idx] = false; cArray[idx] = false; dArray[idx] = false
                            labels[idx] = null; totalFrames--
                        }
                    }
                    currentCoarse = cl; con = getCon(currentCoarse); consecutiveCount = 1; segmentStart = i
                } else {
                    val fineRep = majorityFineLabel(segmentStart, i, currentCoarse)
                    if (!isFirst) {
                        previousCoarse = currentCoarse; previousCount = consecutiveCount; previousFine = fineRep; isFirst = true
                    } else if (currentCoarse == previousCoarse) {
                        previousCount += consecutiveCount
                    } else {
                        labelChangesCoarse.add(previousCoarse!!); labelChangesFine.add(previousFine!!)
                        var tmp = previousCount
                        while (tmp >= csv) { labelChangesCoarse.add(previousCoarse!!); labelChangesFine.add(previousFine!!); tmp -= csv }
                        previousCoarse = currentCoarse; previousCount = consecutiveCount; previousFine = fineRep
                    }
                    currentCoarse = cl; con = getCon(currentCoarse); consecutiveCount = 1; segmentStart = i
                }

                if (i == coarseLabels.lastIndex) {
                    if (consecutiveCount < con) {
                        for (j in segmentStart until coarseLabels.size) {
                            aArray[j] = false; bArray[j] = false; cArray[j] = false; dArray[j] = false
                            labels[j] = null; totalFrames--
                        }
                        if (isFirst) {
                            labelChangesCoarse.add(previousCoarse!!); labelChangesFine.add(previousFine!!)
                            var tmp = previousCount
                            while (tmp >= csv) { labelChangesCoarse.add(previousCoarse!!); labelChangesFine.add(previousFine!!); tmp -= csv }
                        }
                    } else {
                        val fineRepEnd = majorityFineLabel(segmentStart, i + 1, currentCoarse)
                        if (!isFirst) {
                            labelChangesCoarse.add(currentCoarse); labelChangesFine.add(fineRepEnd)
                            var tmp = consecutiveCount
                            while (tmp >= csv) { labelChangesCoarse.add(currentCoarse); labelChangesFine.add(fineRepEnd); tmp -= csv }
                        } else {
                            if (previousCoarse == currentCoarse) {
                                val totalLen = previousCount + consecutiveCount
                                labelChangesCoarse.add(previousCoarse!!); labelChangesFine.add(previousFine!!)
                                var tmp = totalLen
                                while (tmp >= csv) { labelChangesCoarse.add(previousCoarse!!); labelChangesFine.add(previousFine!!); tmp -= csv }
                            } else {
                                labelChangesCoarse.add(previousCoarse!!); labelChangesFine.add(previousFine!!)
                                var tmp = previousCount
                                while (tmp >= csv) { labelChangesCoarse.add(previousCoarse!!); labelChangesFine.add(previousFine!!); tmp -= csv }
                                labelChangesCoarse.add(currentCoarse); labelChangesFine.add(fineRepEnd)
                                var tmp2 = consecutiveCount
                                while (tmp2 >= csv) { labelChangesCoarse.add(currentCoarse); labelChangesFine.add(fineRepEnd); tmp2 -= csv }
                            }
                        }
                    }
                }
            }

            var bestPair: Pair<Int, Int>? = null
            var maxScore = 0
            if (labelChangesCoarse.size >= 2) {
                for (i in 0 until labelChangesCoarse.size - 1) {
                    val pair1 = Pair(labelChangesCoarse[i], labelChangesCoarse[i + 1])
                    val pair2 = Pair(labelChangesCoarse[i + 1], labelChangesCoarse[i])
                    val score = maxOf(poseScores[pair1] ?: 0, poseScores[pair2] ?: 0)
                    if (score > maxScore) { maxScore = score; bestPair = pair1 }
                }
            } else if (labelChangesCoarse.size == 1) {
                bestPair = Pair(labelChangesCoarse[0], labelChangesCoarse[0])
                maxScore = poseScores[bestPair] ?: 0
            }

            fun getFrequencyScore(ratio: Double, none: Double, occasional: Double, frequent: Double): Double {
                return when {
                    ratio < 1.0 / 9.0 -> none
                    ratio < 1.0 / 3.0 -> occasional
                    else -> frequent
                }
            }

            val totalFramesF = totalFrames.coerceAtLeast(1).toDouble()
            val aRatio = aArray.count { it }.toDouble() / totalFramesF
            val bRatio = bArray.count { it }.toDouble() / totalFramesF
            val cRatio = cArray.count { it }.toDouble() / totalFramesF
            val dRatio = dArray.count { it }.toDouble() / totalFramesF

            val aScore = getFrequencyScore(aRatio, 0.0, 1.0, 3.0)
            val bScore = getFrequencyScore(bRatio, 0.0, 1.0, 3.0)
            val cScore = getFrequencyScore(cRatio, 0.0, 0.5, 1.0)
            val dScore = getFrequencyScore(dRatio, 0.0, 1.0, 2.0)

            var extraScore = aScore + bScore + cScore + dScore
            if (extraScore > 6.0) extraScore = 6.0

            val totalScore = maxScore.toDouble() + extraScore

            val fStart = bestPair?.first?.let { coarseToRepFine[it] } ?: 0
            val fEnd = bestPair?.second?.let { coarseToRepFine[it] } ?: 0

            val worstChangeFinePair = bestPair?.let {
                listOf(poseLabelReverse[fStart] ?: "A$fStart", poseLabelReverse[fEnd] ?: "A$fEnd")
            }

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
                "timeStamp" to LocalDateTime.now().toString().replace(":", "-").replace(".", "-"),
                "landmarks_file" to landmarksFile.absolutePath,
                "abcd_file" to abcdFile.absolutePath
            )
        } catch (e: Exception) {
            Log.e("VideoProcessor", "Error processing video", e)
            checkPersonInScreen = true // Python: exception => True
            throw e
        } finally {
            try { close() } catch (_: Exception) {}
            try { retriever.release() } catch (_: Exception) {}
            try { landmarksWriter?.close() } catch (_: Exception) {}
            try { abcdWriter?.close() } catch (_: Exception) {}
        }
    }

    private fun getFrameRate(retriever: MediaMetadataRetriever): Double {
        val fpsFromCapture = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_CAPTURE_FRAMERATE)?.toDoubleOrNull()
        return fpsFromCapture ?: retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_FRAME_COUNT)
            ?.toDoubleOrNull()?.let { frameCount ->
                val durationMs = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0L
                if (durationMs > 0L) (frameCount * 1000.0 / durationMs.toDouble()) else 30.0
            } ?: 30.0
    }
}
