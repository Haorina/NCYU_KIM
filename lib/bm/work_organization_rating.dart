import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import '../../main.dart';
import 'result.dart';

class WorkOrganizationRating extends StatefulWidget {
  const WorkOrganizationRating({super.key, required this.haveTransportation});

  final bool haveTransportation;

  @override
  State<WorkOrganizationRating> createState() => _WorkOrganizationRatingState();
}

class _WorkOrganizationRatingState extends State<WorkOrganizationRating> {
  int _score = 0;

  Future<void> _saveWorkConditionRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('WorkOrganizationRatingPoints', _score);
  }

  void update() {
    setState(() {
      _saveWorkConditionRatingPoints();
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
                  SizedBox(width: screenWidth * 0.3),
                  Text(
                    "工作協調/時間分佈",
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
                            width: screenWidth * 0.75,
                            height: screenHeight * 0.16,
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
                                        width: screenWidth * 0.59,
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
                                    width: screenWidth * 0.65,
                                    child: Text(
                                      "空間或活動的受限(未提及的條件也應根據情況納入考量，罕見的情形可以忽略)",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.042,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
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
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  _score = 0;
                  update();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _score == 0
                      ? const Color(0XFF6F8FA8)
                      : const Color(0xFFE9E9E9),
                  minimumSize: Size(
                    screenWidth * 0.6,
                    screenHeight * 0.056,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side:
                    _score == 0
                        ? BorderSide(color: Colors.black87, width: 1)
                        : BorderSide.none,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "良好",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  _score = 2;
                  update();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _score == 2
                      ? const Color(0XFF6F8FA8)
                      : const Color(0xFFE9E9E9),
                  minimumSize: Size(
                    screenWidth * 0.6,
                    screenHeight * 0.056,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side:
                    _score == 2
                        ? BorderSide(color: Colors.black87, width: 1)
                        : BorderSide.none,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "受限",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  _score = 4;
                  update();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _score == 4
                      ? const Color(0XFF6F8FA8)
                      : const Color(0xFFE9E9E9),
                  minimumSize: Size(
                    screenWidth * 0.6,
                    screenHeight * 0.056,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side:
                    _score == 4
                        ? BorderSide(color: Colors.black87, width: 1)
                        : BorderSide.none,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "不良",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              PONButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                havePrevious: false,
                haveNextPage: true,
                previousText: "",
                nextText: "下一步",
                nextPage: Result(haveTransportation: widget.haveTransportation),
                onTap: () => _saveWorkConditionRatingPoints(),
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
              "工作協調評級",
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
                  currentStep: widget.haveTransportation ? 8 : 6,
                  totalStep: widget.haveTransportation ? 9 : 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText: "總分 : ${_score.toString().replaceAll(".0", "")} / 4 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 4,
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
