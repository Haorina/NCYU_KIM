import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart';
import 'bpr_result.dart';

class BPRVideoAnalysing extends StatefulWidget {
  final String videoPath;
  final bool? reRecord;
  final String? userName;

  const BPRVideoAnalysing({
    super.key,
    this.userName,
    required this.videoPath,
    this.reRecord,
  });

  @override
  State<BPRVideoAnalysing> createState() => _BPRVideoAnalysingState();
}

class _BPRVideoAnalysingState extends State<BPRVideoAnalysing> {
  static const platform = MethodChannel('video_processor');
  // late String _uploadURL; // 沒用到可以註解掉
  late String currentUser;

  static const Map<String, String> poseImageMap = {
    '1': '1',
    '2': '2',
    '3': '3-1',
    '4': '3-2',
    '5': '4-1',
    '6': '4-2',
    '7': '5-1',
    '8': '5-2',
    '9': '5-3',
  };

  @override
  void initState() {
    super.initState();
    currentUser = widget.userName ?? "vJ#CA:F3zP)C]A=V";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      // _testPing(); // 測試完畢可註解掉保持乾淨
      _processVideo(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    }
  }

  /*
  Future<void> _testPing() async {
    try {
      print("Flutter: 呼叫 ping 測試");
      final pong = await platform.invokeMethod('ping');
      print("Flutter: 收到 pong = $pong");
    } catch (e) {
      print("Flutter: ping 測試失敗 ! $e");
    }
  }
  */

  Future<void> _processVideo(double screenWidth, double screenHeight) async {
    try {
      final result = await platform.invokeMethod('processVideo', {'videoPath': widget.videoPath});

      if (result != null && result is Map && result['total_score'] != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BPRResult(
                // 🔥 修正重點：傳遞 userName 與 reRecord 給結果頁
                userName: widget.userName,
                reRecord: widget.reRecord,

                // 以下保持原樣
                twistOrLeanPoints: (result['twistAndLanternal'] ?? 0.0).toDouble(),
                distanceOfBodyCenterPoints: (result['distance of body'] ?? 0.0).toDouble(),
                armLiftPoints: (result['arm raise'] ?? 0.0).toDouble(),
                aboveShoulderPoints: (result['above shoulder'] ?? 0.0).toDouble(),
                bodyPosturePoints: (result['BodyPosturePoint'] ?? 0.0).toDouble(),
                totalBodyPosturePoints: (result['total_score'] ?? 0.0).toDouble(),
                totalAdditionalPoints: (result['Addition Point'] ?? 0.0).toDouble(),
                videoPath: widget.videoPath,
                startPosture: poseImageMap[(result['start'] ?? '').toString()] ?? '1',
                endPosture: poseImageMap[(result['end'] ?? '').toString()] ?? '1',
              ),
            ),
          );
        }
      } else {
        _showErrorToast(screenWidth);
        if (mounted) Navigator.pop(context);
      }
    } on PlatformException {
      _showErrorToast(screenWidth);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // 增加一般的錯誤捕捉
      debugPrint("處理影片發生未知錯誤: $e");
      _showErrorToast(screenWidth);
      if (mounted) Navigator.pop(context);
    }
  }

  void _showErrorToast(double screenWidth) {
    Fluttertoast.showToast(
      msg: "影片處理失敗\n請重新錄製",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: const Color(0xff7392ff),
      fontSize: screenWidth * 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "正在判定，請稍後",
                  style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
                LoadingAnimationWidget.waveDots(
                  color: const Color(0xFF6F8FA8),
                  size: screenWidth * 0.25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}