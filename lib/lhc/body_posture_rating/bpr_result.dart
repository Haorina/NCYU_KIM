import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
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
    this.poseChangesFine = const <String>[],
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

  // ✅ 新增：fine 姿勢變化序列（例如：['A1','A3-1',...] 或 ['1','3-1',...]）
  final List<String> poseChangesFine;

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
    List<String> poseChangesFine,
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
  await prefs.setString("${userName}_LHC_PoseChangesFine", jsonEncode(poseChangesFine));
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

  // ✅ 新增：fine 序列
  List<String> _poseChangesFine = <String>[];

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
      final String poseJson = prefs.getString("${prefix}PoseChangesFine") ?? "[]";
      final List<dynamic> raw = jsonDecode(poseJson) as List<dynamic>;
      _poseChangesFine = raw.map((e) => e.toString()).toList();
    });
  }

  // ---------------------------
  // ✅ 姿勢序列：圖檔路徑 + 分數（用 coarse poseScores 估算）
  // 你的序列可能長這樣：A1 / A3-1 / A4-2 ...（前面有 A）
  // 也可能是：1 / 3-1 / 4-2 ...（沒有 A）
  // ---------------------------
  String _normalizeFine(String fine) {
    final s = fine.trim();
    if (s.startsWith('A') || s.startsWith('a')) {
      return s.substring(1);
    }
    return s;
  }

  int _coarseFromFine(String fine) {
    final normalized = _normalizeFine(fine); // "3-1" or "1"
    final parts = normalized.split('-');
    return int.tryParse(parts.first.trim()) ?? 1;
  }

  int _poseScoreFromFineTransition(String fromFine, String toFine) {
    final int a0 = _coarseFromFine(fromFine);
    final int b0 = _coarseFromFine(toFine);
    final int a = a0 <= b0 ? a0 : b0;
    final int b = a0 <= b0 ? b0 : a0;

    const scores = <String, int>{
      '1-1': 0,
      '1-2': 3,
      '1-3': 3,
      '1-4': 7,
      '1-5': 9,
      '2-2': 5,
      '2-3': 5,
      '2-4': 10,
      '2-5': 13,
      '3-3': 5,
      '3-4': 10,
      '3-5': 13,
      '4-4': 15,
      '4-5': 18,
      '5-5': 20,
    };

    return scores["$a-$b"] ?? 0;
  }

  String _poseAsset(String fine) {
    final s = fine.trim();
    if (s.startsWith('A') || s.startsWith('a')) {
      return "assets/images/$s.png";
    }
    return "assets/images/A$s.png";
  }

  Widget _buildPoseSequenceList(double screenWidth, double screenHeight) {
    // 這個 function 只會在需要顯示序列時才被呼叫（外層已判斷）
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: screenWidth * 0.04,
        right: screenWidth * 0.04,
        top: screenHeight * 0.015,
        bottom: screenHeight * 0.015,
      ),
      itemCount: _poseChangesFine.length - 1,
      separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.012),
      itemBuilder: (context, index) {
        final from = _poseChangesFine[index];
        final to = _poseChangesFine[index + 1];
        final score = _poseScoreFromFineTransition(from, to);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.012,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: const Color(0xFFE5E5E5)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: screenWidth * 0.16,
                height: screenWidth * 0.16,
                child: Image.asset(
                  _poseAsset(from),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Icon(Icons.arrow_forward, size: screenWidth * 0.06, color: Colors.black54),
              SizedBox(width: screenWidth * 0.02),
              SizedBox(
                width: screenWidth * 0.16,
                height: screenWidth * 0.16,
                child: Image.asset(
                  _poseAsset(to),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "第 ${index + 1} 段",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$score",
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              Text(
                " 分",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        );
      },
    );
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

    _poseChangesFine = List<String>.from(widget.poseChangesFine);

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
        widget.poseChangesFine,
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

    final bool showPoseSequenceBlock = _poseChangesFine.length > 2;

    Widget buildVideoPreview() {
      if (_isInitialized && _controller.value.isInitialized) {
        return SizedBox(
          width: screenWidth * 0.66,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio > 0 ? _controller.value.aspectRatio : 1.0,
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
                  labelText: "總分 : ${_totalBodyPosturePoints.toString().replaceAll(".0", "")} / 26 分",
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
                        // 影片預覽
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

                        // 最高風險姿勢
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
                                  "最高風險姿勢",
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
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 15),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Colors.black87,
                                            size: screenWidth * 0.08,
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "${(_totalBodyPosturePoints-_totalAdditionalPoints).toString().replaceAll(".0", "")}分",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.05,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
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

                        // ✅ 只有在序列 >= 2 才顯示「姿勢變化序列」整塊
                        if (showPoseSequenceBlock) ...[
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                            width: screenWidth * 0.9,
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
                                    "姿勢變化序列",
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
                                _buildPoseSequenceList(screenWidth, screenHeight),
                              ],
                            ),
                          ),
                        ],

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

                        Builder(
                          builder: (context) {
                            List<Map<String, dynamic>> items = [
                              {
                                "score": _twistOrLeanPoints,
                                "title": _twistOrLeanPoints < 1
                                    ? "軀幹不常扭轉、側傾"
                                    : _twistOrLeanPoints < 2
                                    ? "軀幹偶爾扭轉、側傾"
                                    : _twistOrLeanPoints < 3
                                    ? "軀幹有時扭轉、側傾"
                                    : "軀幹經常扭轉、側傾",
                                "maxScore": "3",
                                "img": "assets/images/leanAndTwist.png",
                                "w_factor": 0.34,
                                "h_factor": 0.34,
                                "top_factor": -0.1,
                                "left_factor": 0.2,
                              },
                              {
                                "score": _distanceOfBodyCenterPoints,
                                "title": _distanceOfBodyCenterPoints < 1
                                    ? "手部不常遠離身體中心"
                                    : _distanceOfBodyCenterPoints < 3
                                    ? "手部偶爾遠離身體中心"
                                    : "手部經常遠離身體中心",
                                "maxScore": "2",
                                "img": "assets/images/distance_body_center.png",
                                "w_factor": 0.33,
                                "h_factor": 0.33,
                                "top_factor": -0.065,
                                "left_factor": 0.22,
                              },
                              {
                                "score": _armLiftPoints,
                                "title": _armLiftPoints == 0
                                    ? "手臂不常抬舉"
                                    : _armLiftPoints < 1
                                    ? "手臂偶爾抬舉"
                                    : "手臂經常抬舉",
                                "maxScore": "3",
                                "img": "assets/images/arm_lift.png",
                                "w_factor": 0.3,
                                "h_factor": 0.3,
                                "top_factor": -0.06,
                                "left_factor": 0.22,
                              },
                              {
                                "score": _aboveShoulderPoints,
                                "title": _aboveShoulderPoints < 1
                                    ? "雙手不常高舉過肩"
                                    : _aboveShoulderPoints < 2
                                    ? "雙手偶爾高舉過肩"
                                    : "雙手經常高舉過肩",
                                "maxScore": "3",
                                "img": "assets/images/above_shoulder.png",
                                "w_factor": 0.34,
                                "h_factor": 0.34,
                                "top_factor": -0.08,
                                "left_factor": 0.19,
                              },
                            ];

                            items.sort((a, b) =>
                                (b['score'] as double).compareTo(a['score'] as double));

                            return Column(
                              children: List.generate(items.length, (index) {
                                final item = items[index];
                                return ValueListenableBuilder<int>(
                                  valueListenable: counter,
                                  builder: (BuildContext context, int value, Widget? child) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
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
