import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/radar_chart.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/result_title.dart';
import '../../user_define_widget/result_most_risk.dart';
import '../../user_define_widget/result_suggestion_abp.dart';
import '../../user_define_widget/abp_result_store_button.dart';
import '../../main.dart';

class Result extends StatefulWidget {
  final String? userName;
  const Result({super.key, this.userName});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  double timeRatingPoints = 0;
  double backLoadRatingPoints = 0;
  int shoulderUpperLimbLoadRatingPoints = 0;
  int lowerLimbLoadRatingPoints = 0;
  int workConditionRatingPoints = 0;
  bool partB = false;
  bool partC = false;
  double totalScore = 0;
  int totalSteps = 0;
  int count = 0;
  bool isSaved = false;
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
      timeRatingPoints = prefs.getDouble('TimeRatingPoints') ?? 0.0;
      backLoadRatingPoints = prefs.getDouble('BackLoadRatingPoints') ?? 0.0;
      shoulderUpperLimbLoadRatingPoints =
          prefs.getInt('ShoulderUpperLimbLoadRatingPoints') ?? 0;
      lowerLimbLoadRatingPoints =
          prefs.getInt('LowerLimbLoadRatingPoints') ?? 0;
      workConditionRatingPoints =
          prefs.getInt('WorkConditionRatingPoints') ?? 0;
      partB = prefs.getBool('PartB') ?? false;
      partC = prefs.getBool('PartC') ?? false;
      totalSteps = prefs.getInt('TotalStep') ?? 0;
    } else {
      timeRatingPoints =
          prefs.getDouble('${widget.userName}_ABP_TimeRatingPoints') ?? 0.0;
      backLoadRatingPoints =
          prefs.getDouble('${widget.userName}_ABP_BackLoadRatingPoints') ?? 0.0;
      shoulderUpperLimbLoadRatingPoints =
          prefs.getInt(
            '${widget.userName}_ABP_ShoulderUpperLimbLoadRatingPoints',
          ) ??
              0;
      lowerLimbLoadRatingPoints =
          prefs.getInt('${widget.userName}_ABP_LowerLimbLoadRatingPoints') ?? 0;
      workConditionRatingPoints =
          prefs.getInt('${widget.userName}_ABP_WorkConditionRatingPoints') ?? 0;
      partB = prefs.getBool('${widget.userName}_ABP_PartB') ?? false;
      partC = prefs.getBool('${widget.userName}_ABP_PartC') ?? false;
      totalSteps = prefs.getInt('${widget.userName}_ABP_TotalStep') ?? 0;
    }

    // 動態生成分數清單
    List<MapEntry<String, num>> scoreEntries = [
      MapEntry("背部負荷評級", backLoadRatingPoints),
      if (partB) MapEntry("肩&上肢負荷評級", shoulderUpperLimbLoadRatingPoints),
      if (partC) MapEntry("下肢負荷評級", lowerLimbLoadRatingPoints),
      MapEntry("不良工作條件", workConditionRatingPoints),
    ];

    if (partB && partC) {
      count = 5;
    } else if (partB || partC) {
      count = 4;
    } else {
      count = 3;
    }

    // 計算總分
    totalScore =
        timeRatingPoints *
            (backLoadRatingPoints +
                (partB ? shoulderUpperLimbLoadRatingPoints : 0) +
                (partC ? lowerLimbLoadRatingPoints : 0) +
                workConditionRatingPoints);

    // 排序找出前三名
    scoreEntries.sort((a, b) => b.value.compareTo(a.value));
    maxScore = scoreEntries.take(3).map((entry) => entry.value).toList();
    maxScoreText = scoreEntries.take(3).map((entry) => entry.key).toList();
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
                  await clearGuestKeysForABP();

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
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
                              top:
                              count == 4
                                  ? screenHeight * 0.058
                                  : count == 3
                                  ? screenHeight * 0.1
                                  : screenHeight * 0.075,
                              left: screenWidth * 0.185,
                            ),
                            child: CustomPaint(
                              painter: RadarChartPainter(
                                screenWidth: screenWidth * 0.9,
                                screenHeight: screenHeight,
                                currentScore: [
                                  timeRatingPoints,
                                  backLoadRatingPoints,
                                  if (partB) ...[
                                    shoulderUpperLimbLoadRatingPoints
                                        .toDouble(),
                                  ],
                                  if (partC) ...[
                                    lowerLimbLoadRatingPoints.toDouble(),
                                  ],
                                  workConditionRatingPoints.toDouble(),
                                ],
                                labels: [
                                  "時間評級\n${timeRatingPoints.toString().replaceAll(".0", "")}分",
                                  "背部負荷評級\n${backLoadRatingPoints.toString().replaceAll(".0", "")}分",
                                  if (partB) ...[
                                    "肩&上肢負荷評級\n${shoulderUpperLimbLoadRatingPoints.toString().replaceAll(".0", "")}分",
                                  ],
                                  if (partC) ...[
                                    "下肢負荷評級\n${lowerLimbLoadRatingPoints.toString().replaceAll(".0", "")}分",
                                  ],
                                  "不良工作條件\n${workConditionRatingPoints.toString().replaceAll(".0", "")}分",
                                ],
                                maxScore: [
                                  10,
                                  98,
                                  if (partB) ...[92],
                                  if (partC) ...[48],
                                  22,
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
                        ResultSuggestionABP(
                          suggestionName: maxScoreText,
                          totalScore: totalScore.toDouble(), // 🟢 直接轉換
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          userName: widget.userName,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ABPResultStoreButton(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          userName: currentUser,
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
