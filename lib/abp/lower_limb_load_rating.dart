import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import '../user_define_widget/abp_select_item.dart';
import 'work_condition_rating.dart';

class LowerLimbLoadRating extends StatefulWidget {
  const LowerLimbLoadRating({super.key});

  @override
  State<LowerLimbLoadRating> createState() => _LowerLimbLoadRatingState();
}

class _LowerLimbLoadRatingState extends State<LowerLimbLoadRating> {
  int score = 0;
  int totalSteps = 0;
  bool partB = false;
  bool isSelected1 = false;
  bool isSelected2 = false;
  String selectedTimeRatio1 = "<25";
  String selectedTimeRatio2 = "<25";

  Future<void> _loadTotalSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      totalSteps = prefs.getInt("TotalSteps") ?? 1;
      partB = prefs.getBool("Upper") ?? false;
    });
  }

  Future<void> _saveLowerLimbLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("LowerLimbLoadRatingPoints", score);
    await prefs.setBool("StandFrequently", isSelected1);
    await prefs.setString("StandFrequently_Frequency", selectedTimeRatio1);
    await prefs.setBool("SittingWithLeg", isSelected2);
    await prefs.setString("SittingWithLeg_Frequency", selectedTimeRatio2);
  }

  @override
  void initState() {
    _loadTotalSteps();
    _saveLowerLimbLoadRatingPoints();
    super.initState();
  }

  void update() {
    Map<String, int> selectedTimeRatio1Map = {
      "<25": 2,
      "25-50": 4,
      "51-75": 6,
      ">75": 8,
    };
    Map<String, int> selectedTimeRatio2Map = {
      "<25": 10,
      "25-50": 20,
      "51-75": 30,
      ">75": 40,
    };

    score = 0;

    if (isSelected1) {
      score += selectedTimeRatio1Map[selectedTimeRatio1]!;
    }
    if (isSelected2) {
      score += selectedTimeRatio2Map[selectedTimeRatio2]!;
    }

    _saveLowerLimbLoadRatingPoints();
  }

  void updateTimeRatio1(String value, bool isSelected) {
    setState(() {
      isSelected1 = isSelected;
      selectedTimeRatio1 = value;
      update();
    });
  }

  void updateTimeRatio2(String value, bool isSelected) {
    setState(() {
      isSelected2 = isSelected;
      selectedTimeRatio2 = value;
      update();
    });
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
              "下肢負荷評級",
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
                  currentStep: partB ? 4 : 3,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                      "總分 : ${score.toString().replaceAll(".0", "")} / 48 分",
                  currentScore: score,
                  textSize: screenWidth * 0.038,
                  maxScore: 48,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.035),
                    AbpSelectItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      contentText: "經常站立，僅偶爾走幾步路",
                      exampleText: "e.g. 銷售人員、機器操作員",
                      image: "assets/images/distance_body_center.png",
                      help: false,
                      onTimeRatioChanged: updateTimeRatio1,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    AbpSelectItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      contentText: "蹲、跪、坐姿翹腳",
                      exampleText: "e.g. 工地、室內裝修、水電工、\n       鋪管工人、焊接、收割、\n       鋪地磚",
                      image: "assets/images/distance_body_center.png",
                      help: false,
                      onTimeRatioChanged: updateTimeRatio2,
                    ),
                    SizedBox(height: screenHeight * 0.3),
                    PONButton(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      havePrevious: false,
                      haveNextPage: true,
                      previousText: "",
                      nextText: "下一步",
                      nextPage: WorkConditionRating(),
                      onTap: () => _saveLowerLimbLoadRatingPoints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
