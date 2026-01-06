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

// 存檔邏輯 (保持不變)
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
    width: screenWidth * 0.77,
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

  // 🔥 1. 新增變數：用來儲存顯示用的分數
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

  // 🔥 2. 新增函式：從 SharedPreferences 載入舊資料
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
      // 如果需要影片路徑也可以覆蓋，但通常從外部傳入的比較準
      // _videoPath = prefs.getString("${prefix}VideoPath") ?? widget.videoPath;
    });
  }

  @override
  void initState() {
    super.initState();

    // 🔥 3. 初始化變數：預設使用傳入的參數
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

    // 如果不是重新錄製 (也就是從選單點進來的 review 模式)，則載入舊資料
    if (widget.reRecord == false) {
      _loadSavedData();
    } else {
      // 只有在 reRecord 不是 false (即新錄製) 時才存檔
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
                  // 🔥 4. 修改 UI：使用 _totalBodyPosturePoints
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
                                      // 🔥 5. 修改 UI：使用 _startPosture
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
                                      SizedBox(
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.black87,
                                          size: screenWidth * 0.08,
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.026),
                                      // 🔥 6. 修改 UI：使用 _endPosture
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

                        // 🔥 7. 修改判斷邏輯：使用 local variables
                        if (_twistOrLeanPoints != 0.0 ||
                            _distanceOfBodyCenterPoints != 0.0 ||
                            _armLiftPoints != 0.0 ||
                            _aboveShoulderPoints != 0.0) ...[
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
                        ],

                        // 🔥 8. 下方的卡片全部換成 _twistOrLeanPoints 等變數
                        if (_twistOrLeanPoints != 0.0) ...[
                          ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (BuildContext context, int value, Widget? child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  additionalPointCardDecoration(screenWidth, screenHeight, 0),
                                  additionalPointCard(
                                    screenWidth, screenHeight,
                                    _twistOrLeanPoints < 3 ? "軀幹偶爾扭轉、側傾" : "軀幹經常扭轉、側傾",
                                    _twistOrLeanPoints.toString().replaceAll(".0", ""),
                                    "3", screenWidth * 0.34, screenHeight * 0.34, screenHeight * (-0.1), screenHeight * 0.2,
                                    "assets/images/leanAndTwist.png", addCounter,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],

                        if (_distanceOfBodyCenterPoints != 0.0) ...[
                          ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (BuildContext context, int value, Widget? child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  additionalPointCardDecoration(screenWidth, screenHeight, 1),
                                  additionalPointCard(
                                    screenWidth, screenHeight,
                                    "手部遠離身體中心",
                                    _distanceOfBodyCenterPoints.toString().replaceAll(".0", ""),
                                    "2", screenWidth * 0.33, screenHeight * 0.33, screenHeight * (-0.085), screenHeight * 0.2,
                                    "assets/images/distance_body_center.png", addCounter,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],

                        if (_armLiftPoints != 0.0) ...[
                          ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (BuildContext context, int value, Widget? child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  additionalPointCardDecoration(screenWidth, screenHeight, 2),
                                  additionalPointCard(
                                    screenWidth, screenHeight,
                                    "手臂抬舉",
                                    _armLiftPoints.toString().replaceAll(".0", ""),
                                    "3", screenWidth * 0.3, screenHeight * 0.3, screenHeight * (-0.06), screenHeight * 0.22,
                                    "assets/images/arm_lift.png", addCounter,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],

                        if (_aboveShoulderPoints != 0.0) ...[
                          ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (BuildContext context, int value, Widget? child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  additionalPointCardDecoration(screenWidth, screenHeight, 3),
                                  additionalPointCard(
                                    screenWidth, screenHeight,
                                    "雙手高舉過肩",
                                    _aboveShoulderPoints.toString().replaceAll(".0", ""),
                                    "3", screenWidth * 0.34, screenHeight * 0.34, screenHeight * (-0.09), screenHeight * 0.17,
                                    "assets/images/above_shoulder.png", addCounter,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],

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