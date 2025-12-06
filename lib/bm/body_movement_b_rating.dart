import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import '../../main.dart';
import 'road_condition_rating.dart';

final Map<String, Map<String, int>> calculateScore = {
  "≤ 50": {"< 10": 3, "10~15": 6, "> 15": 9},
  "51~150": {"< 10": 6, "10~15": 10, "> 15": 15},
  "> 150": {"< 10": 9, "10~15": 14, "> 15": 21},
};

class BodyMovementB extends StatefulWidget {
  const BodyMovementB({super.key, required this.haveTransportation});

  final bool haveTransportation;

  @override
  State<BodyMovementB> createState() => _BodyMovementBState();
}

Future<void> _saveBodyMovementBRatingPoints(int score) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('BodyMovementBRatingPoints', score);
}

class _BodyMovementBState extends State<BodyMovementB> {
  bool _haveTransportSupport = false;
  int _score = 0;
  String _weightText = "≤ 50";
  String _speedText = "< 10";

  Future<void> _loadHaveTransportSupport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _haveTransportSupport = prefs.getBool("HaveTransportSupport") ?? false;
    update();
  }

  @override
  void initState() {
    super.initState();
    _loadHaveTransportSupport();
  }

  void update() {
    setState(() {
      _score = calculateScore[_weightText]![_speedText]!;
      if (_haveTransportSupport) {
        _score = (_score / 2).round();
      }
      _saveBodyMovementBRatingPoints(_score);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double bottomPadding = MediaQuery.paddingOf(context).bottom;

    Widget body(double screenWidth, double screenHeight, double bottomPadding) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: screenWidth * 0.33),
                  Text(
                    "實際負重(含載具)",
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
                                height: screenHeight * 0.43,
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
                                        width: screenWidth * 0.7,
                                        child: Text(
                                          "檢測過程身體實際承擔的物品重量，需包含交通工具重量及其載重\n注意:\n1.以「實際承受的重量」計算，不是物品的標示重量作業中搬運\n2. 無論電動/非電動交通工具皆包含",
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
                                      width: screenWidth * 0.7,
                                      child: Text(
                                        "ex:\n•板車、平台車\n•視線嚴重受阻（如完全黑暗）\n•手推車、拉車\n•擔架\n•手動堆高機\n•具電動助力的推床",
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
                    "assets/images/body_movement_type.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _weightText = "≤ 50";
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _weightText == "≤ 50"
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(screenWidth * 0.25, screenHeight * 0.046),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            _weightText == "≤ 50"
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "≤ 50kg",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  ElevatedButton(
                    onPressed: () {
                      _weightText = "51~150";
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _weightText == "51~150"
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(screenWidth * 0.29, screenHeight * 0.046),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            _weightText == "51~150"
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "51~150kg",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  ElevatedButton(
                    onPressed: () {
                      _weightText = "> 150";
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _weightText == "> 150"
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(screenWidth * 0.25, screenHeight * 0.046),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            _weightText == "> 150"
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "> 150kg",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Text(
                "交通工具速度",
                style: TextStyle(
                  fontSize: screenWidth * 0.044,
                  fontWeight: FontWeight.bold,
                ),
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
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _speedText = "< 10";
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _speedText == "< 10"
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(screenWidth * 0.25, screenHeight * 0.046),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            _speedText == "< 10"
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "< 10km/h",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      _speedText = "10~15";
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _speedText == "10~15"
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(screenWidth * 0.29, screenHeight * 0.046),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            _speedText == "10~15"
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "10~15km/h",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      _speedText = "> 15";
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _speedText == "> 15"
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(screenWidth * 0.25, screenHeight * 0.046),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            _speedText == "> 15"
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "> 15km/h",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.075),
              PONButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                havePrevious: false,
                haveNextPage: true,
                previousText: "",
                nextText: "下一步",
                nextPage: RoadConditionRating(
                  haveTransportation: widget.haveTransportation,
                  weightText: _weightText,
                ),
                onTap: () => _saveBodyMovementBRatingPoints(_score),
              ),
              SizedBox(height: screenHeight * 0.04 - bottomPadding),
            ],
          ),
        ),
      );
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
              "活動評級-B",
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
                  currentStep: 6,
                  totalStep: 9,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                      "總分 : ${_score.toString().replaceAll(".0", "")} / 21 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 21,
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
