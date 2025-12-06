import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/radar_chart.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/result_title.dart';
import '../../user_define_widget/result_most_risk.dart';
import '../../user_define_widget/result_suggestion.dart';
import '../../user_define_widget/lhc_result_store_button.dart';
import '../../main.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int loadWeightPoints = 0;
  double totalBodyPosturePoints = 0;
  double timeRatingPoints = 0;
  int weightHandlingPoints = 0;
  int workConditionPoints = 0;
  int workOrganizationPoints = 0;
  double totalScore = 0;
  bool isSaved = false;

  List<num> maxScore = [0, 0, 0];
  List<String> maxScoreText = ["3", "2", "1"];

  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      loadWeightPoints = prefs.getInt("LoadWeightPoints") ?? 4;
      totalBodyPosturePoints = prefs.getDouble("TotalBodyPosturePoints") ?? 0;
      timeRatingPoints = prefs.getDouble("TimeRatingPoints") ?? 1;
      weightHandlingPoints = prefs.getInt("WeightHandlingPoints") ?? 0;
      workConditionPoints = prefs.getInt("WorkConditionPoints") ?? 0;
      workOrganizationPoints = prefs.getInt("WorkOrganizationPoints") ?? 0;
      totalScore =
          timeRatingPoints *
              (loadWeightPoints +
                  totalBodyPosturePoints +
                  weightHandlingPoints +
                  workConditionPoints +
                  workOrganizationPoints);
      List<MapEntry<String, num>> scoreEntries = [
        MapEntry("負重評級", loadWeightPoints),
        MapEntry("身體姿勢", totalBodyPosturePoints),
        MapEntry("負荷處理條件", weightHandlingPoints),
        MapEntry("不良工作條件", workConditionPoints),
        MapEntry("工作時間分配", workOrganizationPoints),
      ];

      scoreEntries.sort((a, b) => b.value.compareTo(a.value));
      maxScore = scoreEntries.take(3).map((entry) => entry.value).toList();
      maxScoreText = scoreEntries.take(3).map((entry) => entry.key).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPoints();
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
                  currentStep: 7,
                  totalStep: 7,
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
                          maxScore: 1470,
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
                          width: screenWidth * 0.91,
                          height: screenHeight * 0.47,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: screenHeight * 0.095,
                              left: screenWidth * 0.135,
                            ),
                            child: CustomPaint(
                              painter: RadarChartPainter(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                currentScore: [
                                  timeRatingPoints,
                                  workConditionPoints.toDouble(),
                                  workOrganizationPoints.toDouble(),
                                  weightHandlingPoints.toDouble(),
                                  loadWeightPoints.toDouble(),
                                  totalBodyPosturePoints,
                                ],
                                maxScore: [10, 13, 4, 4, 100, 26],
                                labels: [
                                  "時間評級\n${timeRatingPoints.toString().replaceAll(".0", "")}分",
                                  "不良工作條件\n${workConditionPoints.toString().replaceAll(".0", "")}分",
                                  "工作時間分配\n${workOrganizationPoints.toString().replaceAll(".0", "")}分",
                                  "負荷處理條件\n${weightHandlingPoints.toString().replaceAll(".0", "")}分",
                                  "負重評級\n${loadWeightPoints.toString().replaceAll(".0", "")}分",
                                  "身體姿勢\n${totalBodyPosturePoints.toString().replaceAll(".0", "")}分",
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ResultMostRisk(
                          totalScore:
                          timeRatingPoints != 0
                              ? (totalScore / timeRatingPoints) ==
                              (totalScore / timeRatingPoints)
                                  .toInt()
                              ? (totalScore / timeRatingPoints).toInt()
                              : (totalScore / timeRatingPoints)
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
                          timeRatingPoints != 0
                              ? (totalScore / timeRatingPoints) ==
                              (totalScore / timeRatingPoints)
                                  .toInt()
                              ? (totalScore / timeRatingPoints).toInt()
                              : (totalScore / timeRatingPoints)
                              : 0,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        LHCResultStoreButton(
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
