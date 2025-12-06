import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/radar_chart.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/result_title.dart';
import '../../user_define_widget/result_most_risk.dart';
import '../../user_define_widget/result_suggestion.dart';
import '../../user_define_widget/abp_result_store_button.dart';
import '../../main.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  double timeRatingPoints = 0;
  double backLoadRatingPoints = 0;
  int shoulderUpperLimbLoadRatingPoints = 0;
  int lowerLimbLoadRatingPoints = 0;
  int workConditionRatingPoints = 0;
  double totalScore = 0;
  int totalSteps = 0;
  bool isSaved = false;

  List<num> maxScore = [0, 0, 0];
  List<String> maxScoreText = ["3", "2", "1"];

  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      totalSteps = prefs.getInt("TotalSteps") ?? 0;
      timeRatingPoints = prefs.getDouble("TimeRatingPoints") ?? 0;
      backLoadRatingPoints = prefs.getDouble("BackLoadRatingPoints") ?? 0;
      shoulderUpperLimbLoadRatingPoints =
          prefs.getInt("ShoulderUpperLimbLoadRatingPoints") ?? 0;
      lowerLimbLoadRatingPoints =
          prefs.getInt("LowerLimbLoadRatingPoints") ?? 0;
      workConditionRatingPoints =
          prefs.getInt("WorkConditionRatingPoints") ?? 0;
      totalScore =
          timeRatingPoints *
          (backLoadRatingPoints +
              shoulderUpperLimbLoadRatingPoints +
              lowerLimbLoadRatingPoints +
              workConditionRatingPoints);
      List<MapEntry<String, num>> scoreEntries = [
        MapEntry("時間評級", timeRatingPoints),
        MapEntry("背部負荷評級", backLoadRatingPoints),
        MapEntry("肩&上肢負荷評級", shoulderUpperLimbLoadRatingPoints),
        MapEntry("下肢負荷評級", lowerLimbLoadRatingPoints),
        MapEntry("不良工作條件", workConditionRatingPoints),
      ];

      scoreEntries.sort((a, b) => b.value.compareTo(a.value));
      maxScore = scoreEntries.take(3).map((entry) => entry.value).toList();
      maxScoreText = scoreEntries.take(3).map((entry) => entry.key).toList();
    });
  }

  @override
  void initState() {
    _loadPoints();
    super.initState();
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
              "評估結果",
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
                  currentStep: totalSteps,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ResultTitle(
                          resultScore:
                              totalScore != 0
                                  ? totalScore == totalScore.toInt()
                                      ? totalScore.toInt()
                                      : totalScore
                                  : 0,
                          maxScore: 2600,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Container(
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
                          width: screenWidth * 0.93,
                          height: screenHeight * 0.4,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: screenHeight * 0.075,
                              left: screenWidth * 0.185,
                            ),
                            child: CustomPaint(
                              painter: RadarChartPainter(
                                screenWidth: screenWidth * 0.9,
                                screenHeight: screenHeight,
                                currentScore: [
                                  timeRatingPoints,
                                  backLoadRatingPoints,
                                  shoulderUpperLimbLoadRatingPoints.toDouble(),
                                  lowerLimbLoadRatingPoints.toDouble(),
                                  workConditionRatingPoints.toDouble(),
                                ],
                                maxScore: [
                                  10,
                                  98,
                                  92,
                                  48,
                                  22,
                                ],
                                labels: [
                                  "時間評級\n${timeRatingPoints.toString().replaceAll(".0", "")}分",
                                  "背部負荷評級\n${backLoadRatingPoints.toString().replaceAll(".0", "")}分",
                                  "肩&上肢負荷評級\n${shoulderUpperLimbLoadRatingPoints.toString().replaceAll(".0", "")}分",
                                  "下肢負荷評級\n${lowerLimbLoadRatingPoints.toString().replaceAll(".0", "")}分",
                                  "不良工作條件\n${workConditionRatingPoints.toString().replaceAll(".0", "")}分",
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ResultMostRisk(
                          totalScore:
                              totalScore != 0
                                  ? totalScore == totalScore.toInt()
                                      ? totalScore.toInt()
                                      : totalScore
                                  : 0,
                          mostRiskText: maxScoreText,
                          mostRiskScore: maxScore,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ResultSuggestion(
                          suggestionName: maxScoreText,
                          totalScore:
                              totalScore != 0
                                  ? totalScore == totalScore.toInt()
                                      ? totalScore.toInt()
                                      : totalScore
                                  : 0,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ABPResultStoreButton(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          nextPage: HomePage(),
                        ),
                        SizedBox(height: screenHeight * 0.01),
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
