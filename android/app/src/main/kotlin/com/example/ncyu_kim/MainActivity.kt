package com.example.ncyu_kim
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.example.ncyu_kim.VideoProcessorPlugin  // 引入你的 plugin
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 手動註冊 VideoProcessorPlugin
        flutterEngine.plugins.add(VideoProcessorPlugin())
        // 你可以加這行來確保插件已註冊
        println("FlutterEngine 配置成功，插件已註冊")
    }
}