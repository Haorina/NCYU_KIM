import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import '../user_define_widget/abp_select_item.dart';
import 'lower_limb_load_rating.dart';
import 'work_condition_rating.dart';

class ShoulderUpperLimbLoadRating extends StatefulWidget {
  const ShoulderUpperLimbLoadRating({super.key});

  @override
  State<ShoulderUpperLimbLoadRating> createState() =>
      _ShoulderUpperLimbLoadRatingState();
}

class _ShoulderUpperLimbLoadRatingState
    extends State<ShoulderUpperLimbLoadRating> {
  int score = 0;
  int totalSteps = 0;
  bool partC = false;
  bool isSelected1 = false;
  bool isSelected2 = false;
  bool isSelected3 = false;
  String selectedTimeRatio1 = "<25";
  String selectedTimeRatio2 = "<25";
  String selectedTimeRatio3 = "<25";

  Future<void> _loadTotalSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      totalSteps = prefs.getInt("TotalSteps") ?? 0;
      partC = prefs.getBool("SquatOrKneel") ?? false;
    });
  }

  Future<void> _saveShoulderUpperLimbLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("ShoulderUpperLimbLoadRatingPoints", score);
    await prefs.setBool("HandAboveShoulder", isSelected1);
    await prefs.setString("HandAboveShoulder_Frequency", selectedTimeRatio1);
    await prefs.setBool("UpperFromBodyWithoutSupport", isSelected2);
    await prefs.setString("UpperFromBodyWithoutSupport_Frequency", selectedTimeRatio2);
    await prefs.setBool("LieDownOrLieProne", isSelected3);
    await prefs.setString("LieDownOrLieProne_Frequency", selectedTimeRatio3);
  }

  @override
  void initState() {
    _loadTotalSteps();
    _saveShoulderUpperLimbLoadRatingPoints();
    super.initState();
  }

  void update() {
    Map<String, int> selectedTimeRatio1Map = {
      "<25": 10,
      "25-50": 20,
      "51-75": 30,
      ">75": 40,
    };
    Map<String, int> selectedTimeRatio2Map = {
      "<25": 6,
      "25-50": 12,
      "51-75": 18,
      ">75": 24,
    };
    Map<String, int> selectedTimeRatio3Map = {
      "<25": 7,
      "25-50": 14,
      "51-75": 21,
      ">75": 28,
    };

    score = 0;

    if (isSelected1) {
      score += selectedTimeRatio1Map[selectedTimeRatio1]!;
    }
    if (isSelected2) {
      score += selectedTimeRatio2Map[selectedTimeRatio2]!;
    }
    if (isSelected3) {
      score += selectedTimeRatio3Map[selectedTimeRatio3]!;
    }

    _saveShoulderUpperLimbLoadRatingPoints();
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

  void updateTimeRatio3(String value, bool isSelected) {
    setState(() {
      isSelected3 = isSelected;
      selectedTimeRatio3 = value;
      update();
    });
  }

  IconButton help1(double screenWidth, double screenHeight) {
    return IconButton(
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
              height: screenHeight * 0.36,
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
                        "手臂抬起高度未超過肩膀，但手部遠離身體且無其他支撐",
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
                      "ex:\n•作業員在輸送帶旁整理物品，需要長時間伸\n 展手臂將物品從輸送帶上取下或放置到指定\n 位置，手臂沒有任何支撐\n•油漆工在粉刷牆面時，需要伸展手臂進行塗\n 刷，手臂需要持續用力，沒有支撐\n•組裝人員在工作檯上組裝零件，需要伸展手\n 臂操作工具或取放零件，手臂長時間處於懸\n 空狀態",
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
    );
  }

  IconButton help2(double screenWidth, double screenHeight) {
    return IconButton(
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
              height: screenHeight * 0.42,
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
                        "工作時身體趴伏於地面或作業平面，並且需要使用手臂進行操作，手臂的位置在身體下方或前方;或躺下，抬舉手臂進行操作",
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
                      "ex:\n•汽車維修人員需要趴在地上，將手臂伸到車\n 底進行零件拆裝，手臂需要用力操作工具，\n 並長時間維持這種姿勢\n•地板鋪設人員需要趴在地上，將手臂伸到身\n 體前方進行地板拼接，手臂需要頻繁移動和\n 施力\n•管線工人在地面下方安裝或維修管線，需趴\n 伏並用手操作工具\n•天花板彩繪",
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
    );
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
              "肩&上肢負荷評級",
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
                  currentStep: 3,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                      "總分 : ${score.toString().replaceAll(".0", "")} / 92 分",
                  currentScore: score,
                  textSize: screenWidth * 0.038,
                  maxScore: 92,
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
                      contentText: "手高舉過肩\n(站、蹲、跪姿)",
                      exampleText: "e.g. 工地、室內裝修 、\n       電路通風系統安裝",
                      image: "assets/images/distance_body_center.png",
                      help: false,
                      onTimeRatioChanged: updateTimeRatio1,
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    AbpSelectItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      contentText: "舉手但未過肩、\n遠離身體無支撐",
                      exampleText: "e.g. 整理輸送帶",
                      image: "assets/images/distance_body_center.png",
                      help: true,
                      icon: help1(screenWidth, screenHeight),
                      onTimeRatioChanged: updateTimeRatio2,
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    AbpSelectItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      contentText: "躺下，抬舉手臂\n趴下，手在身體下方/前方",
                      exampleText: "e.g. 整理低處",
                      image: "assets/images/distance_body_center.png",
                      help: true,
                      icon: help2(screenWidth, screenHeight),
                      onTimeRatioChanged: updateTimeRatio3,
                    ),
                    SizedBox(height: screenHeight * 0.15),
                    PONButton(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      havePrevious: false,
                      haveNextPage: true,
                      previousText: "",
                      nextText: "下一步",
                      nextPage:
                          partC ? LowerLimbLoadRating() : WorkConditionRating(),
                      onTap: () => _saveShoulderUpperLimbLoadRatingPoints(),
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
