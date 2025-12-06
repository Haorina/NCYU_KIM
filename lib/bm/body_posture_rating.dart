import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import '../../main.dart';
import 'work_condition_rating.dart';

final Map<String, String> findLoadWeight = {
  "< 3": "0~15",
  "3~15": "0~15",
  "16~30": "16~30",
  "> 30": "> 30",
};

final Map<String, Map<String, int>> calculateScore = {
  "pickOccasionally": {
    "0~15": 2,
    "16~30": 4,
    "> 30": 6,
  },
  "pickOften": {
    "0~15": 4,
    "16~30": 6,
    "> 30": 8,
  },
};

class BodyPostureRating extends StatefulWidget {
  const BodyPostureRating({
    super.key,
    required this.haveTransportation,
    required this.loadWeightText,
  });

  final bool haveTransportation;
  final String loadWeightText;

  @override
  State<BodyPostureRating> createState() => _BodyPostureRatingState();
}

class _BodyPostureRatingState extends State<BodyPostureRating> {
  String _loadWeightText = "0~15";
  int _score = 2;
  String pickText = "pickOccasionally";
  bool pickOccasionally = true;
  bool pickOften = false;

  @override
  void initState() {
    super.initState();
    _loadWeightText = findLoadWeight[widget.loadWeightText]!;
    _score = calculateScore[pickText]![_loadWeightText]!;
  }

  Future<void> _saveBodyPostureRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('BodyPostureRatingPoints', _score);
  }

  void update() {
    setState(() {
      _score = calculateScore[pickText]![_loadWeightText]!;
      _saveBodyPostureRatingPoints();
    });
  }

  Widget body(double screenWidth, double screenHeight, double bottomPadding) {
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
                      MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
                      transitionBuilder: (context, animation, secondaryAnimation, child) {
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
                  "assets/images/body_movement_type.png",
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
                minimumSize: Size(
                  screenWidth * 0.6,
                  screenHeight * 0.056,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                  pickOccasionally
                      ? BorderSide(color: Colors.black87, width: 1)
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
                minimumSize: Size(
                  screenWidth * 0.6,
                  screenHeight * 0.056,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                  pickOften
                      ? BorderSide(color: Colors.black87, width: 1)
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
            SizedBox(height: screenHeight * 0.22 - bottomPadding),
            PONButton(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              havePrevious: false,
              haveNextPage: true,
              previousText: "",
              nextText: "下一步",
              nextPage: WorkConditionRating(
                haveTransportation: widget.haveTransportation,
              ),
              onTap: () => _saveBodyPostureRatingPoints(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double bottomPadding = MediaQuery.paddingOf(context).bottom;

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
                ProgressBar(
                  currentStep: 4,
                  totalStep: widget.haveTransportation ? 9 : 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText: "總分 : ${_score.toString().replaceAll(".0", "")} / 8 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 8,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),
                body(screenWidth, screenHeight, bottomPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
