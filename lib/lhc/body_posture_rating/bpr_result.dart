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

  @override
  State<BPRResult> createState() => _BPRResultState();
}

Future<void> _saveBodyPosturePoints(
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("VideoPath", videoPath);
  await prefs.setDouble("TwistOrLeanPoints", twistOrLeanPoints);
  await prefs.setDouble(
    "DistanceOfBodyCenterPoints",
    distanceOfBodyCenterPoints,
  );
  await prefs.setDouble("ArmLiftPoints", armLiftPoints);
  await prefs.setDouble("AboveShoulderPoints", aboveShoulderPoints);
  await prefs.setDouble("BodyPosturePoints", bodyPosturePoints);
  await prefs.setDouble("TotalAdditionalPoints", totalAdditionalPoints);
  await prefs.setDouble("TotalBodyPosturePoints", totalBodyPosturePoints);
  await prefs.setString("StartPosture", startPosture);
  await prefs.setString("EndPosture", endPosture);
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
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 0),
          blurRadius: 1,
          spreadRadius: 1,
          color: const Color(0x10000000),
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

  Future<void> initCameras() async {
    camera = await availableCameras();
    setState(() {
      isInitialized = true;
    });
  }

  void addCounter() {
    //counter.value += 1;
  }

  void _initializeVideoPlayer(String filePath) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('影片初始化失敗: $error')),
          );
          setState(() => _isInitialized = false);
        }
      });
  }

  @override
  void initState() {
    super.initState();
    initCameras();
    _initializeVideoPlayer(widget.videoPath);
    _saveBodyPosturePoints(
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
    counter.value = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
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
                : 1.0, // 預設長寬比為 1:1 避免異常
            child: VideoPlayer(_controller),
          ),
        );
      } else {
        return Text(
          '正在準備中...',
          style: TextStyle(
            fontSize: screenWidth * 0.066,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
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
                  "總分 : ${widget.totalBodyPosturePoints.toString().replaceAll(".0", "")} / 26 分",
                  currentScore: widget.totalBodyPosturePoints,
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
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                            border: Border.all(width: 1, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 1.0,
                                spreadRadius: 1,
                                color: const Color(0x10000000),
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
                                margin: EdgeInsets.only(
                                  bottom: screenHeight * 0.014,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC2C2C2),
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
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: const Color(0x10000000),
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
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC2C2C2),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: screenHeight * 0.026,
                                ),
                                child: SizedBox(
                                  height: screenHeight * 0.16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Image.asset(
                                          "assets/images/A${widget.startPosture}.png",
                                          fit: BoxFit.cover,
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
                                      SizedBox(
                                        child: Image.asset(
                                          "assets/images/A${widget.endPosture}.png",
                                          fit: BoxFit.cover,
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
                        if (widget.twistOrLeanPoints != 0.0 ||
                            widget.distanceOfBodyCenterPoints != 0.0 ||
                            widget.armLiftPoints != 0.0 ||
                            widget.aboveShoulderPoints != 0.0) ...[
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
                        if (widget.twistOrLeanPoints != 0.0) ...[
                          ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (
                                BuildContext context,
                                int value,
                                Widget? child,
                                ) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  additionalPointCardDecoration(
                                    screenWidth,
                                    screenHeight,
                                    counter.value,
                                  ),
                                  additionalPointCard(
                                    screenWidth,
                                    screenHeight,
                                    widget.twistOrLeanPoints < 3
                                        ? "軀幹偶爾扭轉、側傾"
                                        : "軀幹經常扭轉、側傾",
                                    widget.twistOrLeanPoints
                                        .toString()
                                        .replaceAll(".0", ""),
                                    "3",
                                    screenWidth * 0.34,
                                    screenHeight * 0.34,
                                    screenHeight * (-0.1),
                                    screenHeight * 0.2,
                                    "assets/images/leanAndTwist.png",
                                    addCounter,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                        if (widget.distanceOfBodyCenterPoints != 0.0) ...[
                          ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (
                                BuildContext context,
                                int value,
                                Widget? child,
                                ) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  additionalPointCardDecoration(
                                    screenWidth,
                                    screenHeight,
                                    counter.value,
                                  ),
                                  additionalPointCard(
                                    screenWidth,
                                    screenHeight,
                                    widget.distanceOfBodyCenterPoints < 3
                                        ? "物體偶爾遠離身體"
                                        : "物體經常遠離身體",
                                    widget.distanceOfBodyCenterPoints
                                        .toString()
                                        .replaceAll(".0", ""),
                                    "3",
                                    screenWidth * 0.34,
                                    screenHeight * 0.12,
                                    screenHeight * 0.005,
                                    screenHeight * 0.2,
                                    "assets/images/distance_body_center.png",
                                    addCounter,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                        if (widget.armLiftPoints != 0.0) ...[
                          ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (
                                BuildContext context,
                                int value,
                                Widget? child,
                                ) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  additionalPointCardDecoration(
                                    screenWidth,
                                    screenHeight,
                                    counter.value,
                                  ),
                                  additionalPointCard(
                                    screenWidth,
                                    screenHeight,
                                    widget.armLiftPoints < 1
                                        ? "手臂偶爾抬舉"
                                        : "手臂經常抬舉",
                                    widget.armLiftPoints.toString().replaceAll(
                                      ".0",
                                      "",
                                    ),
                                    "1",
                                    screenWidth * 0.34,
                                    screenHeight * 0.12,
                                    screenHeight * 0.005,
                                    screenHeight * 0.2,
                                    "assets/images/arm_lift.png",
                                    addCounter,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                        if (widget.aboveShoulderPoints != 0.0) ...[
                          ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (
                                BuildContext context,
                                int value,
                                Widget? child,
                                ) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  additionalPointCardDecoration(
                                    screenWidth,
                                    screenHeight,
                                    counter.value,
                                  ),
                                  additionalPointCard(
                                    screenWidth,
                                    screenHeight,
                                    widget.aboveShoulderPoints < 2
                                        ? "手偶爾高過肩膀"
                                        : "手經常高過肩膀",
                                    widget.aboveShoulderPoints
                                        .toString()
                                        .replaceAll(".0", ""),
                                    "2",
                                    screenWidth * 0.34,
                                    screenHeight * 0.12,
                                    screenHeight * 0.005,
                                    screenHeight * 0.2,
                                    "assets/images/above_shoulder.png",
                                    addCounter,
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
                            nextPage: TimeRating(),
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