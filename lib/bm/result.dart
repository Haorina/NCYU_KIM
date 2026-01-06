import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/radar_chart.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/result_title.dart';
import '../../user_define_widget/result_most_risk.dart';
import '../../user_define_widget/result_suggestion_bm.dart';
import '../../user_define_widget/bm_result_store_button.dart';
import '../../main.dart';

class Result extends StatefulWidget {
  final bool haveTransportation;
  final String? userName;

  const Result({super.key, required this.haveTransportation, this.userName});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String gender = "male";
  double timeRatingPoints = 0;
  int bodyMovementARatingPoints = 0;
  int loadWeightPositionRatingPoints = 0;
  int bodyPostureRatingPoints = 0;
  int workConditionRatingPoints = 0;
  int bodyMovementBRatingPoints = 0;
  int roadConditionRatingPoints = 0;
  int workOrganizationRatingPoints = 0;
  double totalScore = 0;
  bool onlyTransportation = false;
  int totalSteps = 0;
  late String currentUser;
  late bool isGuest;

  List<num> maxScore = [0, 0, 0];
  List<String> maxScoreText = ["3", "2", "1"];

  @override
  void initState() {
    super.initState();
    currentUser = widget.userName ?? "vJ#CA:F3zP)C]A=V";

    if (widget.userName != null && widget.userName != "vJ#CA:F3zP)C]A=V") {
      isGuest = false;
    } else {
      isGuest = true;
    }

    _loadResultPoints();
  }

  Future<void> _loadResultPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      gender = prefs.getString("Gender") ?? "male";
      timeRatingPoints = prefs.getDouble("TimeRatingPoints") ?? 0;
      bodyMovementARatingPoints =
          prefs.getInt("BodyMovementARatingPoints") ?? 0;
      loadWeightPositionRatingPoints =
          prefs.getInt("LoadWeightPositionRatingPoints") ?? 0;
      bodyPostureRatingPoints = prefs.getInt("BodyPostureRatingPoints") ?? 0;
      workConditionRatingPoints =
          prefs.getInt("WorkConditionRatingPoints") ?? 0;
      bodyMovementBRatingPoints =
          prefs.getInt("BodyMovementBRatingPoints") ?? 0;
      roadConditionRatingPoints =
          prefs.getInt("RoadConditionRatingPoints") ?? 0;
      workOrganizationRatingPoints =
          prefs.getInt("WorkOrganizationRatingPoints") ?? 0;
      onlyTransportation = prefs.getBool("OnlyTransportation") ?? false;
      totalSteps = prefs.getInt("TotalStep") ?? 0;
    } else {
      gender = prefs.getString("${widget.userName}_Gender") ?? "";
      timeRatingPoints =
          prefs.getDouble("${widget.userName}_BM_TimeRatingPoints") ?? 0;
      bodyMovementARatingPoints =
          prefs.getInt("${widget.userName}_BM_BodyMovementARatingPoints") ?? 0;
      loadWeightPositionRatingPoints =
          prefs.getInt(
            "${widget.userName}_BM_LoadWeightPositionRatingPoints",
          ) ??
              0;
      bodyPostureRatingPoints =
          prefs.getInt("${widget.userName}_BM_BodyPostureRatingPoints") ?? 0;
      workConditionRatingPoints =
          prefs.getInt("${widget.userName}_BM_WorkConditionRatingPoints") ?? 0;
      bodyMovementBRatingPoints =
          prefs.getInt("${widget.userName}_BM_BodyMovementBRatingPoints") ?? 0;
      roadConditionRatingPoints =
          prefs.getInt("${widget.userName}_BM_RoadConditionRatingPoints") ?? 0;
      workOrganizationRatingPoints =
          prefs.getInt("${widget.userName}_BM_WorkOrganizationRatingPoints") ??
              0;
      onlyTransportation =
          prefs.getBool("${widget.userName}_BM_OnlyTransportation") ?? false;
      totalSteps = prefs.getInt("${widget.userName}_BM_TotalStep") ?? 0;
    }

    if (onlyTransportation) {
      totalScore =
          timeRatingPoints *
              (bodyMovementBRatingPoints +
                  roadConditionRatingPoints +
                  workOrganizationRatingPoints);
    } else if (widget.haveTransportation) {
      totalScore =
          timeRatingPoints *
              (bodyMovementARatingPoints +
                  loadWeightPositionRatingPoints +
                  bodyPostureRatingPoints +
                  workConditionRatingPoints +
                  bodyMovementBRatingPoints +
                  roadConditionRatingPoints +
                  workOrganizationRatingPoints);
    } else {
      totalScore =
          timeRatingPoints *
              (bodyMovementARatingPoints +
                  loadWeightPositionRatingPoints +
                  bodyPostureRatingPoints +
                  workConditionRatingPoints +
                  workOrganizationRatingPoints);
    }

    if (gender == "Female") {
      totalScore *= 1.3;
    }

    if (onlyTransportation) {
      List<MapEntry<String, num>> scoreEntries = [
        MapEntry("活動評級-B", bodyMovementBRatingPoints),
        MapEntry("路況評級", roadConditionRatingPoints),
        MapEntry("工作時間分配", workOrganizationRatingPoints),
      ];

      scoreEntries.sort((a, b) => b.value.compareTo(a.value));
      maxScore = scoreEntries.take(3).map((entry) => entry.value).toList();
      maxScoreText = scoreEntries.take(3).map((entry) => entry.key).toList();
    } else if (widget.haveTransportation) {
      List<MapEntry<String, num>> scoreEntries = [
        MapEntry("活動評級-A", bodyMovementARatingPoints),
        MapEntry('活動評級-B', bodyMovementBRatingPoints),
        MapEntry('身體姿勢', bodyPostureRatingPoints),
        MapEntry("重物重心評級", loadWeightPositionRatingPoints),
        MapEntry("不良工作條件", workConditionRatingPoints),
        MapEntry("路況評級", roadConditionRatingPoints),
        MapEntry("工作時間分配", workOrganizationRatingPoints),
      ];

      scoreEntries.sort((a, b) => b.value.compareTo(a.value));
      maxScore = scoreEntries.take(3).map((entry) => entry.value).toList();
      maxScoreText = scoreEntries.take(3).map((entry) => entry.key).toList();
    } else {
      List<MapEntry<String, num>> scoreEntries = [
        MapEntry("活動評級-A", bodyMovementARatingPoints),
        MapEntry('身體姿勢', bodyPostureRatingPoints),
        MapEntry("重物重心評級", loadWeightPositionRatingPoints),
        MapEntry("不良工作條件", workConditionRatingPoints),
        MapEntry("工作時間分配", workOrganizationRatingPoints),
      ];

      scoreEntries.sort((a, b) => b.value.compareTo(a.value));
      maxScore = scoreEntries.take(3).map((entry) => entry.value).toList();
      maxScoreText = scoreEntries.take(3).map((entry) => entry.key).toList();
    }

    setState(() {});
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
            width: screenWidth,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.006),
                isGuest
                    ? ProgressBar(
                  currentStep: totalSteps,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
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
                          width: screenWidth * 0.94,
                          height: screenHeight * 0.435,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: screenHeight * 0.075,
                              left:
                              totalSteps == 9
                                  ? screenWidth * 0.18
                                  : screenWidth * 0.195,
                            ),
                            child: CustomPaint(
                              painter: RadarChartPainter(
                                screenWidth: screenWidth * 0.9,
                                screenHeight: screenHeight,
                                currentScore: [
                                  if (onlyTransportation) ...[
                                    timeRatingPoints,
                                    bodyMovementBRatingPoints.toDouble(),
                                    roadConditionRatingPoints.toDouble(),
                                    workOrganizationRatingPoints.toDouble(),
                                  ] else if (widget.haveTransportation) ...[
                                    timeRatingPoints,
                                    bodyMovementARatingPoints.toDouble(),
                                    loadWeightPositionRatingPoints.toDouble(),
                                    bodyPostureRatingPoints.toDouble(),
                                    workConditionRatingPoints.toDouble(),
                                    bodyMovementBRatingPoints.toDouble(),
                                    roadConditionRatingPoints.toDouble(),
                                    workOrganizationRatingPoints.toDouble(),
                                  ] else ...[
                                    timeRatingPoints,
                                    bodyMovementARatingPoints.toDouble(),
                                    loadWeightPositionRatingPoints.toDouble(),
                                    bodyPostureRatingPoints.toDouble(),
                                    workConditionRatingPoints.toDouble(),
                                    workOrganizationRatingPoints.toDouble(),
                                  ],
                                ],
                                maxScore: [
                                  10,
                                  if (!onlyTransportation) ...[100],
                                  if (!onlyTransportation) ...[16],
                                  if (!onlyTransportation) ...[8],
                                  if (!onlyTransportation) ...[23],
                                  if (widget.haveTransportation) ...[21],
                                  if (widget.haveTransportation) ...[24],
                                  4,
                                ],
                                labels: [
                                  "時間評級\n${timeRatingPoints.toString().replaceAll(".0", "")}分",
                                  if (!onlyTransportation) ...[
                                    "活動評級-A\n${bodyMovementARatingPoints.toString().replaceAll(".0", "")}分",
                                  ],
                                  if (!onlyTransportation) ...[
                                    "重物重心評級\n${loadWeightPositionRatingPoints.toString().replaceAll(".0", "")}分",
                                  ],
                                  if (!onlyTransportation) ...[
                                    "身體姿勢\n${bodyPostureRatingPoints.toString().replaceAll(".0", "")}分",
                                  ],
                                  if (!onlyTransportation) ...[
                                    "不良工作條件\n${workConditionRatingPoints.toString().replaceAll(".0", "")}分",
                                  ],
                                  if (widget.haveTransportation) ...[
                                    "活動評級-B\n${bodyMovementBRatingPoints.toString().replaceAll(".0", "")}分",
                                  ],
                                  if (widget.haveTransportation) ...[
                                    "路況評級\n${roadConditionRatingPoints.toString().replaceAll(".0", "")}分",
                                  ],
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
                        ResultSuggestionBM(
                          suggestionName: maxScoreText,
                          totalScore:
                          totalScore == totalScore.toInt()
                              ? totalScore.toInt()
                              : totalScore,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          userName: widget.userName,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        BMResultStoreButton(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          nextPage: HomePage(),
                          userName: currentUser,
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
