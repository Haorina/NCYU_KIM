import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/radar_chart.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/result_title.dart';
import '../../user_define_widget/result_most_risk.dart';
import '../../user_define_widget/result_suggestion_lhc.dart';
import '../../main.dart';
import '../../user_define_widget/lhc_result_store_button.dart';

class Result extends StatefulWidget {
  final String? userName;
  const Result({super.key, this.userName});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late String currentUser;
  late bool isGuest;
  int weightRatingPoints = 0;
  double totalBodyPosturePoints = 0;
  double timeRatingPoints = 0;
  int weightHandlingRatingPoints = 0;
  int workConditionRatingPoints = 0;
  int workOrganizationRatingPoints = 0;
  double totalScore = 0;
  bool isSaved = false;

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
      weightRatingPoints = prefs.getInt('WeightRatingPoints') ?? 0;
      totalBodyPosturePoints = prefs.getDouble('TotalBodyPosturePoints') ?? 0.0;
      timeRatingPoints = prefs.getDouble('TimeRatingPoints') ?? 0.0;
      weightHandlingRatingPoints =
          prefs.getInt('WeightHandlingRatingPoints') ?? 0;
      workConditionRatingPoints =
          prefs.getInt('WorkConditionRatingPoints') ?? 0;
      workOrganizationRatingPoints =
          prefs.getInt('WorkOrganizationRatingPoints') ?? 0;
    } else {
      weightRatingPoints =
          prefs.getInt('${widget.userName}_LHC_WeightRatingPoints') ?? 0;
      totalBodyPosturePoints =
          prefs.getDouble('${widget.userName}_LHC_TotalBodyPosturePoints') ?? 0.0;
      timeRatingPoints =
          prefs.getDouble('${widget.userName}_LHC_TimeRatingPoints') ?? 0.0;
      weightHandlingRatingPoints =
          prefs.getInt('${widget.userName}_LHC_WeightHandlingRatingPoints') ?? 0;
      workConditionRatingPoints =
          prefs.getInt('${widget.userName}_LHC_WorkConditionRatingPoints') ?? 0;
      workOrganizationRatingPoints =
          prefs.getInt('${widget.userName}_LHC_WorkOrganizationRatingPoints') ?? 0;
    }

    totalScore =
        timeRatingPoints *
            (weightRatingPoints +
                totalBodyPosturePoints +
                weightHandlingRatingPoints +
                workConditionRatingPoints +
                workOrganizationRatingPoints);
    List<MapEntry<String, num>> scoreEntries = [
      MapEntry("負重評級", weightRatingPoints),
      MapEntry("身體姿勢", totalBodyPosturePoints),
      MapEntry("負荷處理條件", weightHandlingRatingPoints),
      MapEntry("不良工作條件", workConditionRatingPoints),
      MapEntry("工作時間分配", workOrganizationRatingPoints),
    ];

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
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_outlined),
                iconSize: screenWidth * 0.068,
                color: Colors.black,
                onPressed: () async {
                  await clearGuestKeysForLHC();

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
            width: screenWidth,
            color: const Color(0xFFEFEFEF),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.006),
                isGuest ? ProgressBar(
                  currentStep: 7,
                  totalStep: 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ) : SizedBox(height: screenHeight * 0.01),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ResultTitle(
                          resultScore:
                          totalScore != 0
                              ? (totalScore == totalScore.toInt()
                              ? totalScore.toInt()
                              : totalScore)
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
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                spreadRadius: 1,
                                color: Color(0x20000000),
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
                                  workConditionRatingPoints.toDouble(),
                                  workOrganizationRatingPoints.toDouble(),
                                  weightHandlingRatingPoints.toDouble(),
                                  weightRatingPoints.toDouble(),
                                  totalBodyPosturePoints,
                                ],
                                maxScore: [10, 13, 4, 4, 100, 26],
                                labels: [
                                  "時間評級\n${timeRatingPoints.toString().replaceAll(".0", "")}分",
                                  "不良工作條件\n$workConditionRatingPoints分",
                                  "工作時間分配\n$workOrganizationRatingPoints分",
                                  "負荷處理條件\n$weightHandlingRatingPoints分",
                                  "負重評級\n$weightRatingPoints分",
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
                              ? (totalScore / timeRatingPoints)
                              : 0,
                          mostRiskText: maxScoreText,
                          mostRiskScore: maxScore,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ResultSuggestionLHC(
                          userName: currentUser,
                          suggestionName: maxScoreText,
                          totalScore:
                          timeRatingPoints != 0
                              ? (totalScore / timeRatingPoints)
                              : 0,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        LHCResultStoreButton(
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
