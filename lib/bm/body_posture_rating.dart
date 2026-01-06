import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../../main.dart';
import 'work_condition_rating.dart';

final Map<String, String> findLoadWeight = {
  "< 3": "0~15",
  "3~15": "0~15",
  "16~30": "16~30",
  "> 30": "> 30",
};

final Map<String, Map<String, int>> calculateScore = {
  "pickOccasionally": {"0~15": 2, "16~30": 4, "> 30": 6},
  "pickOften": {"0~15": 4, "16~30": 6, "> 30": 8},
};

class BodyPostureRating extends StatefulWidget {
  final bool haveTransportation;
  final String loadWeightText;
  final String? userName;

  const BodyPostureRating({
    super.key,
    required this.haveTransportation,
    required this.loadWeightText,
    this.userName,
  });

  @override
  State<BodyPostureRating> createState() => _BodyPostureRatingState();
}

class _BodyPostureRatingState extends State<BodyPostureRating> {
  String _loadWeightText = "0~15";
  String pickText = "pickOccasionally";
  bool pickOccasionally = true;
  bool pickOften = false;
  int _score = 2;
  int totalStep = 7;
  late String currentUser;
  late bool isGuest;

  @override
  void initState() {
    super.initState();
    currentUser = widget.userName ?? "vJ#CA:F3zP)C]A=V";

    if (widget.userName != null && widget.userName != "vJ#CA:F3zP)C]A=V") {
      isGuest = false;
    } else {
      isGuest = true;
    }

    _loadBodyPostureRatingPoints();
  }

  Future<void> _loadBodyPostureRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loadWeightText = findLoadWeight[widget.loadWeightText]!;

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      pickText = prefs.getString('PickText') ?? "pickOccasionally";
      pickOccasionally = prefs.getBool('PickOccasionally') ?? true;
      pickOften = prefs.getBool('PickOften') ?? false;
      totalStep = prefs.getInt('TotalStep') ?? 7;
    } else {
      pickText =
          prefs.getString('${widget.userName}_BM_PickText') ??
              "pickOccasionally";
      pickOccasionally =
          prefs.getBool('${widget.userName}_BM_PickOccasionally') ?? true;
      pickOften = prefs.getBool('${widget.userName}_BM_PickOften') ?? false;
      totalStep = prefs.getInt('${widget.userName}_BM_TotalStep') ?? 7;
    }

    setState(() {});
    update();
  }

  Future<void> _saveBodyPostureRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setString('PickBodyPostureText', pickText);
      await prefs.setBool('PickOccasionally', pickOccasionally);
      await prefs.setBool('PickOften', pickOften);
      await prefs.setInt('BodyPostureRatingPoints', _score);
      await prefs.setInt('TotalStep', totalStep);
    } else {
      await prefs.setString('${currentUser}_BM_PickBodyPostureText', pickText);
      await prefs.setBool(
        '${currentUser}_BM_PickOccasionally',
        pickOccasionally,
      );
      await prefs.setBool('${currentUser}_BM_PickOften', pickOften);
      await prefs.setInt('${currentUser}_BM_BodyPostureRatingPoints', _score);
      await prefs.setInt('${currentUser}_BM_TotalStep', totalStep);
    }
  }

  void update() {
    setState(() {
      _score = calculateScore[pickText]![_loadWeightText]!;
    });

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveBodyPostureRatingPoints();
    }
  }

  Widget body(double screenWidth, double screenHeight) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: screenWidth * 0.3),
                Text(
                  "前傾/扭轉/側傾軀幹",
                  style: TextStyle(
                    fontSize: screenWidth * 0.044,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: screenWidth * 0.1),
                IconButton(
                  icon: Image.asset("assets/images/help-circle.png"),
                  iconSize: screenWidth * 0.056,
                  color: Colors.black,
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel:
                      MaterialLocalizations.of(
                        context,
                      ).modalBarrierDismissLabel,
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder:
                          (context, animation, secondaryAnimation) => Center(
                        child: Container(
                          width: screenWidth * 0.85,
                          height: screenHeight * 0.32,
                          decoration: BoxDecoration(
                            color: const Color(0XCC101010),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.038,
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.69,
                                      margin: EdgeInsets.only(
                                        top: screenHeight * 0.008,
                                        left: screenWidth * 0.03,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: screenHeight * 0.004,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: screenWidth * 0.06,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: screenHeight * 0.001,
                                margin: EdgeInsets.only(
                                  top: screenHeight * 0.01,
                                  bottom: screenHeight * 0.01,
                                ),
                                color: const Color(0XCCEFEFEF),
                              ),
                              Center(
                                child: SizedBox(
                                  width: screenWidth * 0.75,
                                  child: Text(
                                    "工作時身體偏離正常直立姿勢，向左右兩側傾斜，或上半身往前彎，或軀幹旋轉的動作(無須精確角度測量，KIM更重視姿勢偏離的頻率和持續時間)",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.042,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.75,
                                child: Text(
                                  "ex:\n•轉身搬取物品\n•需側身操作機台\n•搬運時身體往一邊傾斜\n•彎腰撿拾地上的物品",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.038,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      transitionBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                          ) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        );
                        return FadeTransition(
                          opacity: curved,
                          child: ScaleTransition(scale: curved, child: child),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            Container(
              width: screenWidth * 0.52,
              height: screenHeight * 0.15,
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: Colors.black87),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 1.0,
                    spreadRadius: 1,
                    color: const Color(0xFF999999),
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * 0.01),
                child: Image.asset(
                  "assets/images/BMc.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                pickText = "pickOccasionally";
                pickOccasionally = true;
                pickOften = false;
                update();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                pickOccasionally
                    ? const Color(0XFF6F8FA8)
                    : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.6, screenHeight * 0.056),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                  pickOccasionally
                      ? const BorderSide(color: Colors.black87, width: 1)
                      : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                "偶爾",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                pickText = "pickOften";
                pickOccasionally = false;
                pickOften = true;
                update();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                pickOften
                    ? const Color(0XFF6F8FA8)
                    : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.6, screenHeight * 0.056),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                  pickOften
                      ? const BorderSide(color: Colors.black87, width: 1)
                      : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                "頻繁、經常",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.24),
            SizedBox(
              width: screenWidth * 0.36,
              child: ElevatedButton(
                onPressed: () async {
                  await _saveBodyPostureRatingPoints();

                  if (!isGuest && mounted) {
                    Navigator.pop(context);
                  } else {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => WorkConditionRating(
                            haveTransportation: widget.haveTransportation,
                            userName: currentUser,
                          ),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.036,
                    vertical: screenHeight * 0.01,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isGuest) ...[
                      SizedBox(width: screenWidth * 0.036),
                      Text(
                        "下一步",
                        style: TextStyle(
                          fontSize: screenWidth * 0.049,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: screenWidth * 0.064,
                      ),
                    ] else ...[
                      Text(
                        "保存",
                        style: TextStyle(
                          fontSize: screenWidth * 0.049,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

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
              "姿勢評級",
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
                icon: const Icon(Icons.home_outlined),
                iconSize: screenWidth * 0.068,
                color: Colors.black,
                onPressed: () async {
                  await clearGuestKeysForBM();

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          ),
          body: Container(
            color: const Color(0xFFEFEFEF),
            child: Column(
              children: [
                isGuest
                    ? ProgressBar(
                  currentStep: 4,
                  totalStep: totalStep,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
                ScoreBar(
                  labelText:
                  "總分 : ${_score.toString().replaceAll(".0", "")} / 8 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 8,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),
                body(screenWidth, screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
