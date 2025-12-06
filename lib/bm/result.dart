import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/radar_chart.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/result_title.dart';
import '../../user_define_widget/result_most_risk.dart';
import '../../user_define_widget/result_suggestion.dart';
import '../../user_define_widget/bm_result_store_button.dart';
import '../../main.dart';

class Result extends StatefulWidget {
  final bool haveTransportation;

  const Result({super.key, required this.haveTransportation});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  double timeRatingPoints = 0;
  int bodyMovementARatingPoints = 0;
  int loadWeightPositionRatingPoints = 0;
  int bodyPostureRatingPoints = 0;
  int workConditionRatingPoints = 0;
  int bodyMovementBRatingPoints = 0;
  int roadConditionRatingPoints = 0;
  int workOrganizationRatingPoints = 0;
  double totalScore = 0;
  int totalSteps = 0;
  bool isSaved = false;

  List<num> maxScore = [0, 0, 0];
  List<String> maxScoreText = ["3", "2", "1"];

  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      totalSteps = prefs.getInt("TotalSteps") ?? 0;
      timeRatingPoints = prefs.getDouble("TimeRatingPoints") ?? 1;
      bodyMovementARatingPoints =
          prefs.getInt("BodyMovementARatingPoints") ?? 4;
      loadWeightPositionRatingPoints =
          prefs.getInt("LoadWeightPositionRatingPoints") ?? 0;
      bodyPostureRatingPoints = prefs.getInt("BodyPostureRatingPoints") ?? 2;
      workConditionRatingPoints =
          prefs.getInt("WorkConditionRatingPoints") ?? 7;
      bodyMovementBRatingPoints =
          prefs.getInt("BodyMovementBRatingPoints") ?? 0;
      roadConditionRatingPoints =
          prefs.getInt("RoadConditionRatingPoints") ?? 0;
      workOrganizationRatingPoints =
          prefs.getInt("WorkOrganizationRatingPoints") ?? 0;
      totalScore =
          timeRatingPoints *
          (bodyMovementARatingPoints +
              loadWeightPositionRatingPoints +
              bodyPostureRatingPoints +
              workConditionRatingPoints +
              bodyMovementBRatingPoints +
              roadConditionRatingPoints +
              workOrganizationRatingPoints);
      List<MapEntry<String, num>> scoreEntries = [
        MapEntry("時間評級", timeRatingPoints),
        MapEntry("活動評級-A", bodyMovementARatingPoints),
        MapEntry("重物重心評級", loadWeightPositionRatingPoints),
        MapEntry("身體姿勢", bodyPostureRatingPoints),
        MapEntry("不良工作條件", workConditionRatingPoints),
        MapEntry("活動評級-B", bodyMovementBRatingPoints),
        MapEntry("路況評級", roadConditionRatingPoints),
        MapEntry("工作時間分配", workOrganizationRatingPoints),
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
                              totalScore == totalScore.toInt()
                                  ? totalScore.toInt()
                                  : totalScore,
                          maxScore: 1960,
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
                          height: screenHeight * 0.435,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: screenHeight * 0.075,
                              left: screenWidth * 0.175,
                            ),
                            child: CustomPaint(
                              painter: RadarChartPainter(
                                screenWidth: screenWidth * 0.9,
                                screenHeight: screenHeight,
                                currentScore: [
                                  timeRatingPoints,
                                  bodyMovementARatingPoints.toDouble(),
                                  loadWeightPositionRatingPoints.toDouble(),
                                  bodyPostureRatingPoints.toDouble(),
                                  workConditionRatingPoints.toDouble(),
                                  bodyMovementBRatingPoints.toDouble(),
                                  roadConditionRatingPoints.toDouble(),
                                  workOrganizationRatingPoints.toDouble(),
                                ],
                                maxScore: [
                                  10,
                                  100,
                                  16,
                                  8,
                                  23,
                                  21,
                                  24,
                                  4,
                                ],
                                labels: [
                                  "時間評級\n${timeRatingPoints.toString().replaceAll(".0", "")}分",
                                  "活動評級-A\n${bodyMovementARatingPoints.toString().replaceAll(".0", "")}分",
                                  "重物重心評級\n${loadWeightPositionRatingPoints.toString().replaceAll(".0", "")}分",
                                  "身體姿勢\n${bodyPostureRatingPoints.toString().replaceAll(".0", "")}分",
                                  "不良工作條件\n${workConditionRatingPoints.toString().replaceAll(".0", "")}分",
                                  "活動評級-B\n${bodyMovementBRatingPoints.toString().replaceAll(".0", "")}分",
                                  "路況評級\n${roadConditionRatingPoints.toString().replaceAll(".0", "")}分",
                                  "工作時間分配\n${workOrganizationRatingPoints.toString().replaceAll(".0", "")}分",
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ResultMostRisk(
                          totalScore:
                              totalScore == totalScore.toInt()
                                  ? totalScore.toInt()
                                  : totalScore,
                          mostRiskText: maxScoreText,
                          mostRiskScore: maxScore,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ResultSuggestion(
                          suggestionName: maxScoreText,
                          totalScore:
                              totalScore == totalScore.toInt()
                                  ? totalScore.toInt()
                                  : totalScore,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        BMResultStoreButton(
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
