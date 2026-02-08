import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../../user_define_widget/previous_or_next_button.dart';
import 'bpr_video_recording.dart';
import '../time_rating.dart';

final ValueNotifier<int> counter = ValueNotifier(0);

class BPRResult extends StatefulWidget {
  const BPRResult({
    super.key,
    required this.videoPath,
    this.twistOrLeanPoints = 0.0,
    this.distanceOfBodyCenterPoints = 0.0,
    this.armLiftPoints = 0.0,
    this.aboveShoulderPoints = 0.0,
    this.bodyPosturePoints = 0.0,
    this.totalBodyPosturePoints = 0.0,
    this.totalAdditionalPoints = 0.0,
    this.startPosture = "",
    this.endPosture = "",
    this.userName,
    this.reRecord,
  });

  final String videoPath;
  final double twistOrLeanPoints;
  final double distanceOfBodyCenterPoints;
  final double armLiftPoints;
  final double aboveShoulderPoints;
  final double bodyPosturePoints;
  final double totalAdditionalPoints;
  final double totalBodyPosturePoints;
  final String startPosture;
  final String endPosture;
  final String? userName;
  final bool? reRecord;

  @override
  State<BPRResult> createState() => _BPRResultState();
}

// 存檔邏輯
Future<void> _saveBodyPosturePoints(
    String? userName,
    String videoPath,
    double twistOrLeanPoints,
    double distanceOfBodyCenterPoints,
    double armLiftPoints,
    double aboveShoulderPoints,
    double bodyPosturePoints,
    double totalAdditionalPoints,
    double totalBodyPosturePoints,
    String startPosture,
    String endPosture,
    ) async {
  if (userName == null || userName.isEmpty) return;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("${userName}_LHC_VideoPath", videoPath);
  await prefs.setDouble("${userName}_LHC_TwistOrLeanPoints", twistOrLeanPoints);
  await prefs.setDouble("${userName}_LHC_DistanceOfBodyCenterPoints", distanceOfBodyCenterPoints);
  await prefs.setDouble("${userName}_LHC_ArmLiftPoints", armLiftPoints);
  await prefs.setDouble("${userName}_LHC_AboveShoulderPoints", aboveShoulderPoints);
  await prefs.setDouble("${userName}_LHC_BodyPosturePoints", bodyPosturePoints);
  await prefs.setDouble("${userName}_LHC_TotalAdditionalPoints", totalAdditionalPoints);
  await prefs.setDouble("${userName}_LHC_TotalBodyPosturePoints", totalBodyPosturePoints);
  await prefs.setString("${userName}_LHC_StartPosture", startPosture);
  await prefs.setString("${userName}_LHC_EndPosture", endPosture);
}

Widget square(double width, double height) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: const Color(0xFFB4B4B4),
    ),
  );
}

Widget circle(
    double outerRadius,
    double innerRadius,
    Color outerColor,
    Color innerColor,
    ) {
  return Container(
    width: outerRadius,
    height: outerRadius,
    decoration: BoxDecoration(
      color: innerColor,
      shape: BoxShape.circle,
      border: Border.all(color: outerColor, width: outerRadius - innerRadius),
    ),
  );
}

Widget additionalPointCardDecoration(
    double screenWidth,
    double screenHeight,
    int counter,
    ) {
  return SizedBox(
    width: screenWidth * 0.1,
    height: screenHeight * 0.16,
    child: Stack(
      children: [
        for (int i = 0; i < 6; i++) ...[
          Positioned(
            top: i * screenHeight * 0.016,
            left: screenWidth * 0.022,
            child: square(screenWidth * 0.008, screenHeight * 0.01),
          ),
        ],
        for (int i = 0; i < 6; i++) ...[
          Positioned(
            top: screenHeight * 0.1 + i * screenHeight * 0.016,
            left: screenWidth * 0.022,
            child: square(screenWidth * 0.008, screenHeight * 0.01),
          ),
        ],
        Positioned(
          top: screenHeight * 0.07,
          child: circle(
            screenHeight * 0.024,
            screenHeight * 0.02,
            const Color(0xFF7A6D6D),
            counter % 2 == 0 ? const Color(0xFFA8D5CF) : Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget additionalPointCard(
    double screenWidth,
    double screenHeight,
    String titleText,
    String scoreText,
    String maxScore,
    double imgWidth,
    double imgHeight,
    double imgOffsetTop,
    double imgOffsetLeft,
    String img,
    VoidCallback addCounterCallback,
    ) {
  addCounterCallback();
  return Container(
    width: screenWidth * 0.771,
    height: screenHeight * 0.13,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1, color: Colors.white),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, 0),
          blurRadius: 1,
          spreadRadius: 1,
          color: Color(0x10000000),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          top: screenHeight * 0.046,
          left: screenWidth * 0.5,
          child: circle(
            screenHeight * 0.126,
            screenHeight * 0.126,
            const Color(0xFFECECEC),
            const Color(0xFFECECEC),
          ),
        ),
        Positioned(
          top: screenHeight * 0.018,
          left: screenWidth * 0.06,
          child: Text(
            titleText,
            style: TextStyle(
              fontSize: screenWidth * 0.042,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          top: screenHeight * 0.056,
          left: screenWidth * 0.076,
          child: Text(
            "+$scoreText scores",
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0XFF767676),
            ),
          ),
        ),
        Positioned(
          top: imgOffsetTop,
          left: imgOffsetLeft,
          child: SizedBox(
            width: imgWidth,
            height: imgHeight,
            child: Image.asset(img),
          ),
        ),
      ],
    ),
  );
}

class _BPRResultState extends State<BPRResult> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  late List<CameraDescription> camera;
  bool isInitialized = false;

  late double _twistOrLeanPoints;
  late double _distanceOfBodyCenterPoints;
  late double _armLiftPoints;
  late double _aboveShoulderPoints;
  late double _bodyPosturePoints;
  late double _totalBodyPosturePoints;
  late double _totalAdditionalPoints;
  late String _startPosture;
  late String _endPosture;
  late String _videoPath;

  Future<void> initCameras() async {
    try {
      camera = await availableCameras();
      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("相機初始化失敗: $e");
    }
  }

  void addCounter() {}

  void _initializeVideoPlayer(String filePath) {
    if (filePath.isEmpty || !File(filePath).existsSync()) {
      debugPrint("影片檔案不存在: $filePath");
      return;
    }

    _controller = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _controller.setLooping(true);
            _controller.setVolume(0);
            _controller.play();
          });
        }
      }).catchError((error) {
        if (mounted) {
          debugPrint('影片初始化失敗: $error');
          setState(() => _isInitialized = false);
        }
      });
  }

  Future<void> _loadSavedData() async {
    if (widget.userName == null) return;

    final prefs = await SharedPreferences.getInstance();
    final String prefix = "${widget.userName}_LHC_";

    setState(() {
      _twistOrLeanPoints = prefs.getDouble("${prefix}TwistOrLeanPoints") ?? 0.0;
      _distanceOfBodyCenterPoints = prefs.getDouble("${prefix}DistanceOfBodyCenterPoints") ?? 0.0;
      _armLiftPoints = prefs.getDouble("${prefix}ArmLiftPoints") ?? 0.0;
      _aboveShoulderPoints = prefs.getDouble("${prefix}AboveShoulderPoints") ?? 0.0;
      _bodyPosturePoints = prefs.getDouble("${prefix}BodyPosturePoints") ?? 0.0;
      _totalBodyPosturePoints = prefs.getDouble("${prefix}TotalBodyPosturePoints") ?? 0.0;
      _totalAdditionalPoints = prefs.getDouble("${prefix}TotalAdditionalPoints") ?? 0.0;
      _startPosture = prefs.getString("${prefix}StartPosture") ?? "";
      _endPosture = prefs.getString("${prefix}EndPosture") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();

    _twistOrLeanPoints = widget.twistOrLeanPoints;
    _distanceOfBodyCenterPoints = widget.distanceOfBodyCenterPoints;
    _armLiftPoints = widget.armLiftPoints;
    _aboveShoulderPoints = widget.aboveShoulderPoints;
    _bodyPosturePoints = widget.bodyPosturePoints;
    _totalBodyPosturePoints = widget.totalBodyPosturePoints;
    _totalAdditionalPoints = widget.totalAdditionalPoints;
    _startPosture = widget.startPosture;
    _endPosture = widget.endPosture;
    _videoPath = widget.videoPath;

    initCameras();
    _initializeVideoPlayer(_videoPath);

    if (widget.reRecord == false) {
      _loadSavedData();
    } else {
      _saveBodyPosturePoints(
        widget.userName,
        widget.videoPath,
        widget.twistOrLeanPoints,
        widget.distanceOfBodyCenterPoints,
        widget.armLiftPoints,
        widget.aboveShoulderPoints,
        widget.bodyPosturePoints,
        widget.totalAdditionalPoints,
        widget.totalBodyPosturePoints,
        widget.startPosture,
        widget.endPosture,
      );
    }

    counter.value = 0;
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    Widget buildVideoPreview() {
      if (_isInitialized && _controller.value.isInitialized) {
        return SizedBox(
          width: screenWidth * 0.66,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio > 0
                ? _controller.value.aspectRatio
                : 1.0,
            child: VideoPlayer(_controller),
          ),
        );
      } else {
        return Container(
          height: 100,
          alignment: Alignment.center,
          child: Text(
            '無法預覽影片\n(請確認檔案是否存在)',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w300,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            title: Text(
              "身體姿勢評級",
              style: TextStyle(
                fontSize: screenWidth * 0.056,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(Icons.home_outlined),
                iconSize: screenWidth * 0.068,
                color: Colors.black,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
          body: Container(
            color: const Color(0xFFEFEFEF),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.006),
                ProgressBar(
                  currentStep: 2,
                  totalStep: 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                  "總分 : ${_totalBodyPosturePoints.toString().replaceAll(".0", "")} / 26 分",
                  currentScore: _totalBodyPosturePoints,
                  textSize: screenWidth * 0.038,
                  maxScore: 26,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth * 0.8,
                          margin: EdgeInsets.only(top: screenHeight * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(screenWidth * 0.02),
                            border: Border.all(width: 1, color: Colors.white),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 1.0,
                                spreadRadius: 1,
                                color: Color(0x10000000),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                  top: screenHeight * 0.012,
                                  left: screenWidth * 0.056,
                                  bottom: screenHeight * 0.012,
                                ),
                                child: Text(
                                  "影片預覽",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.048,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                height: screenHeight * 0.001,
                                margin: EdgeInsets.only(bottom: screenHeight * 0.014),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC2C2C2),
                                ),
                              ),
                              buildVideoPreview(),
                              SizedBox(height: screenHeight * 0.014),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.26,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.white),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: Color(0x10000000),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                  top: screenHeight * 0.012,
                                  left: screenWidth * 0.056,
                                  bottom: screenHeight * 0.012,
                                ),
                                child: Text(
                                  "姿勢變化",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.048,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                height: screenHeight * 0.001,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC2C2C2),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: screenHeight * 0.026),
                                child: SizedBox(
                                  height: screenHeight * 0.16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_startPosture.isNotEmpty)
                                        SizedBox(
                                          child: Image.asset(
                                            "assets/images/A$_startPosture.png",
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image),
                                          ),
                                        ),
                                      SizedBox(width: screenWidth * 0.026),

                                      // --- 修改的部分開始 ---
                                      Column(
                                        mainAxisSize: MainAxisSize.min, // 重要：讓 Column 高度只包住內容，避免撐開整列
                                        children: [
                                          SizedBox(height: 15),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Colors.black87,
                                            size: screenWidth * 0.08,
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "${_totalBodyPosturePoints.toString().replaceAll(".0", "")}分", // 這裡填入你的數字變數
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.05, // 建議設定字體大小
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // --- 修改的部分結束 ---

                                      SizedBox(width: screenWidth * 0.026),
                                      if (_endPosture.isNotEmpty)
                                        SizedBox(
                                          child: Image.asset(
                                            "assets/images/A$_endPosture.png",
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // 額外加分項標題
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                            left: screenWidth * 0.12,
                            bottom: screenHeight * 0.008,
                          ),
                          child: Text(
                            "額外加分項",
                            style: TextStyle(
                              fontSize: screenWidth * 0.048,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        // 動態列表生成 (包含排序功能)
                        Builder(
                          builder: (context) {
                            // 1. 定義所有項目的資料結構
                            List<Map<String, dynamic>> items = [
                              {
                                "score": _twistOrLeanPoints,
                                "title":
                                _twistOrLeanPoints < 1 ? "軀幹不常扭轉、側傾" :
                                _twistOrLeanPoints < 2 ? "軀幹偶爾扭轉、側傾":
                                _twistOrLeanPoints < 3 ? "軀幹有時扭轉、側傾":"軀幹經常扭轉、側傾",
                                "maxScore": "3",
                                "img": "assets/images/leanAndTwist.png",
                                // 參數對應: imgWidth, imgHeight, imgOffsetTop, imgOffsetLeft (係數 x screenWidth 或 screenHeight)
                                "w_factor": 0.34,
                                "h_factor": 0.34,
                                "top_factor": -0.1,
                                "left_factor": 0.2,
                              },
                              {
                                "score": _distanceOfBodyCenterPoints,
                                "title":
                                _distanceOfBodyCenterPoints< 1 ? "手部不常遠離身體中心" :
                                _distanceOfBodyCenterPoints < 3 ? "手部偶爾遠離身體中心":"手部經常遠離身體中心",
                                "maxScore": "2",
                                "img": "assets/images/distance_body_center.png",
                                "w_factor": 0.33,
                                "h_factor": 0.33,
                                "top_factor": -0.065,
                                "left_factor": 0.22,
                              },
                              {
                                "score": _armLiftPoints,
                                "title":
                                _armLiftPoints == 0 ? "手臂不常抬舉" :
                                _armLiftPoints < 1 ? "手臂偶爾抬舉":"手臂經常抬舉",
                                "maxScore": "3",
                                "img": "assets/images/arm_lift.png",
                                "w_factor": 0.3,
                                "h_factor": 0.3,
                                "top_factor": -0.06,
                                "left_factor": 0.22,
                              },
                              {
                                "score": _aboveShoulderPoints,
                                "title":
                                _aboveShoulderPoints< 1 ? "雙手不常高舉過肩" :
                                _aboveShoulderPoints < 2 ? "雙手偶爾高舉過肩":"雙手經常高舉過肩",
                                "maxScore": "3",
                                "img": "assets/images/above_shoulder.png",
                                "w_factor": 0.34,
                                "h_factor": 0.34,
                                "top_factor": -0.08,
                                "left_factor": 0.19,
                              },
                            ];

                            // 2. 進行排序：分數高的排前面 (降冪排序)
                            items.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));

                            // 3. 遍歷列表生成 UI
                            return Column(
                              children: List.generate(items.length, (index) {
                                final item = items[index];
                                return ValueListenableBuilder<int>(
                                  valueListenable: counter,
                                  builder: (BuildContext context, int value, Widget? child) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // 傳入 index 確保左側裝飾的顏色交替規律
                                        additionalPointCardDecoration(screenWidth, screenHeight, index),
                                        additionalPointCard(
                                          screenWidth,
                                          screenHeight,
                                          item['title'],
                                          (item['score'] as double).toString().replaceAll(".0", ""),
                                          item['maxScore'],
                                          screenWidth * (item['w_factor'] as double),
                                          screenHeight * (item['h_factor'] as double),
                                          screenHeight * (item['top_factor'] as double),
                                          screenHeight * (item['left_factor'] as double),
                                          item['img'],
                                          addCounter,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                            );
                          },
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        if (isInitialized) ...[
                          PONButton(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            havePrevious: true,
                            haveNextPage: true,
                            previousText: "再錄製一次",
                            nextText: "下一步",
                            previousPage: LHCVideoRecording(camera: camera),
                            nextPage: TimeRating(userName: widget.userName),
                          ),
                        ],
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}