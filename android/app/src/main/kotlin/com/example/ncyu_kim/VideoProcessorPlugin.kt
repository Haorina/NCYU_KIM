package com.example.ncyu_kim

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import com.example.ncyu_kim.mediapipelib.VideoProcessor

class VideoProcessorPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var processor: VideoProcessor

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("VideoProcessorPlugin", "Plugin attached to engine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "video_processor")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        val outputDir = File(context.filesDir, "output")
        if (!outputDir.exists()) {
            outputDir.mkdirs()
        }
        // 動態複製模型檔案（若尚未存在）
        val assetManager = context.assets
        val modelFile = File(context.filesDir, "pose_landmarker_full.task")
        if (!modelFile.exists()) {
            assetManager.open("models/pose_landmarker_full.task").use { input ->
                modelFile.outputStream().use { output ->
                    input.copyTo(output)
                }
            }
            Log.d("VideoProcessorPlugin", "Model file copied to ${modelFile.absolutePath}")
        }
        processor = VideoProcessor(context, modelFile.absolutePath, outputDir)
        // 立刻初始化以避免第一次使用時 overhead（但 processVideo 也會 double-check 初始化）
        processor.initialize()
        Log.d("VideoProcessorPlugin", "Processor initialized")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d("VideoProcessorPlugin", "onMethodCall: ${call.method}")
        when (call.method) {
            "ping" -> {
                Log.d("VideoProcessorPlugin", "收到 ping")
                result.success("pong")
            }
            "processVideo" -> {
                val videoPath = call.argument<String>("videoPath")
                Log.d("VideoProcessorPlugin", "processVideo called with videoPath=$videoPath")
                if (videoPath != null) {
                    val videoFile = File(videoPath)
                    if (!videoFile.exists()) {
                        Log.e("VideoProcessorPlugin", "Video file not found at $videoPath")
                        result.error("FILE_NOT_FOUND", "Video file does not exist at $videoPath", null)
                        return
                    }
                    Thread {
                        try {
                            Log.d("VideoProcessorPlugin", "Start processing video in background thread")
                            val resultMap = processor.processVideo(videoFile)
                            Log.d("VideoProcessorPlugin", "Processing finished, resultMap=$resultMap")
                            Handler(Looper.getMainLooper()).post {
                                result.success(resultMap)
                                Log.d("VideoProcessorPlugin", "Result sent back to Flutter")
                            }
                        } catch (e: Exception) {
                            Log.e("VideoProcessorPlugin", "Error while processing video", e)
                            Handler(Looper.getMainLooper()).post {
                                result.error("PROCESS_ERROR", e.message, e.stackTraceToString())
                            }
                        }
                    }.start()
                } else {
                    Log.e("VideoProcessorPlugin", "Invalid argument: videoPath is null")
                    result.error("INVALID_ARG", "Video path is null", null)
                }
            }
            "close" -> {
                Log.d("VideoProcessorPlugin", "Closing processor")
                try {
                    processor.close()
                } catch (e: Exception) {
                    Log.w("VideoProcessorPlugin", "Error while closing processor: ${e.message}")
                }
                result.success(null)
            }
            else -> {
                Log.w("VideoProcessorPlugin", "Method not implemented: ${call.method}")
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("VideoProcessorPlugin", "Plugin detached from engine")
        channel.setMethodCallHandler(null)
        try { processor.close() } catch (e: Exception) { Log.w("VideoProcessorPlugin", "Close error on detach: ${e.message}") }
    }
}
