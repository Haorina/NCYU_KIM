import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/abp_select_item.dart';
import 'lower_limb_load_rating.dart';
import 'work_condition_rating.dart';

class ShoulderUpperLimbLoadRating extends StatefulWidget {
  final String? userName;
  const ShoulderUpperLimbLoadRating({super.key, this.userName});

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
  late String currentUser;
  late bool isGuest;

  @override
  void initState() {
    super.initState();
    currentUser = widget.userName ?? "vJ#CA:F3zP)C]A=V";

    if (widget.userName != null && widget.userName != "vJ#CA:F3zP)C]A=V") {
      isGuest = false;
    } else {
      isGuest = true;
    }

    _loadShoulderUpperLimbLoadRatingPoints();
  }

  Future<void> _loadShoulderUpperLimbLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      isSelected1 = prefs.getBool('ShoulderUpperLimbLoadSelect1') ?? false;
      isSelected2 = prefs.getBool('ShoulderUpperLimbLoadSelect2') ?? false;
      isSelected3 = prefs.getBool('ShoulderUpperLimbLoadSelect3') ?? false;
      selectedTimeRatio1 =
          prefs.getString('ShoulderUpperLimbLoadLabel1') ?? "<25";
      selectedTimeRatio2 =
          prefs.getString('ShoulderUpperLimbLoadLabel2') ?? "<25";
      selectedTimeRatio3 =
          prefs.getString('ShoulderUpperLimbLoadLabel3') ?? "<25";
      partC = prefs.getBool('PartC') ?? false;
      totalSteps = prefs.getInt('TotalStep') ?? 4;
    } else {
      isSelected1 =
          prefs.getBool(
            '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect1',
          ) ??
              false;
      isSelected2 =
          prefs.getBool(
            '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect2',
          ) ??
              false;
      isSelected3 =
          prefs.getBool(
            '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect3',
          ) ??
              false;
      selectedTimeRatio1 =
          prefs.getString(
            '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel1',
          ) ??
              "";
      selectedTimeRatio2 =
          prefs.getString(
            '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel2',
          ) ??
              "";
      selectedTimeRatio3 =
          prefs.getString(
            '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel3',
          ) ??
              "";
      partC = prefs.getBool('${widget.userName}_ABP_PartC') ?? false;
      totalSteps = prefs.getInt('${widget.userName}_ABP_TotalStep') ?? 0;
    }

    update();
  }

  Future<void> _saveShoulderUpperLimbLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setBool('ShoulderUpperLimbLoadSelect1', isSelected1);
      await prefs.setBool('ShoulderUpperLimbLoadSelect2', isSelected2);
      await prefs.setBool('ShoulderUpperLimbLoadSelect3', isSelected3);
      await prefs.setString('ShoulderUpperLimbLoadLabel1', selectedTimeRatio1);
      await prefs.setString('ShoulderUpperLimbLoadLabel2', selectedTimeRatio2);
      await prefs.setString('ShoulderUpperLimbLoadLabel3', selectedTimeRatio3);
      await prefs.setBool('PartC', partC);
      await prefs.setInt('ShoulderUpperLimbLoadRatingPoints', score);
      await prefs.setInt('TotalStep', totalSteps);
    } else {
      await prefs.setBool(
        '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect1',
        isSelected1,
      );
      await prefs.setBool(
        '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect2',
        isSelected2,
      );
      await prefs.setBool(
        '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect3',
        isSelected3,
      );
      await prefs.setString(
        '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel1',
        selectedTimeRatio1,
      );
      await prefs.setString(
        '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel2',
        selectedTimeRatio2,
      );
      await prefs.setString(
        '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel3',
        selectedTimeRatio3,
      );
      await prefs.setBool('${widget.userName}_ABP_PartC', partC);
      await prefs.setInt(
        '${widget.userName}_ABP_ShoulderUpperLimbLoadRatingPoints',
        score,
      );
      await prefs.setInt('${widget.userName}_ABP_TotalStep', totalSteps);
    }
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

    setState(() {});

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveShoulderUpperLimbLoadRatingPoints();
    }
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

  IconButton helpCustom(
      double screenWidth,
      double screenHeight,
      double height,
      String title,
      String content,
      String imagePath,
      ) {
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
              height: height,
              decoration: BoxDecoration(
                color: const Color(0XCC101010),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: screenWidth * 0.06,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFFEFEFEF),
                    margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                  ),
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.75,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  SizedBox(
                    width: screenWidth * 0.75,
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  if (imagePath.trim().isNotEmpty)
                    Image.asset(
                      imagePath,
                      width: screenWidth * 0.6,
                      fit: BoxFit.fitWidth,
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
                onPressed: () async {
                  await clearGuestKeysForABP();

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
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.006),
                isGuest
                    ? ProgressBar(
                  currentStep: 3,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
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
                      isSelected: isSelected1,
                      selectedTimeRatio: selectedTimeRatio1,
                      contentText: "手高舉過肩\n(站、蹲、跪姿)",
                      exampleText: "",
                      image: "assets/images/shoulderB1s.png",
                      help: true,
                      icon: helpCustom(
                        screenWidth,
                        screenHeight,
                        screenHeight * 0.35,
                        "手高舉過肩\n(站、蹲、跪姿)",
                        "",
                        "assets/images/shoulderB1.png",
                      ),
                      onTimeRatioChanged: updateTimeRatio1,
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    AbpSelectItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isSelected: isSelected2,
                      selectedTimeRatio: selectedTimeRatio2,
                      contentText: "舉手但未過肩、\n遠離身體無支撐",
                      exampleText: "e.g. 整理輸送帶",
                      image: "assets/images/shoulderB2s.png",
                      help: true,
                      icon: helpCustom(
                        screenWidth,
                        screenHeight,
                        screenHeight * 0.44,
                        "手臂抬起高度未超過肩膀，但手部遠離身體且無其他支撐",
                        "ex:\n•作業員在輸送帶旁整理物品，需要長時間伸展手臂將物品從輸送帶上取下或放置到指定位置，手臂沒有任何支撐\n•油漆工在粉刷牆面時，需要伸展手臂進行塗刷，手臂需要持續用力，沒有支撐",
                        "assets/images/shoulderB2.png",
                      ),
                      onTimeRatioChanged: updateTimeRatio2,
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    AbpSelectItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isSelected: isSelected3,
                      selectedTimeRatio: selectedTimeRatio3,
                      contentText: "躺下，抬舉手臂\n趴下，手在身體下/前方",
                      exampleText: "e.g. 整理低處",
                      image: "assets/images/shoulderB3s.png",
                      help: true,
                      icon: helpCustom(
                        screenWidth,
                        screenHeight,
                        screenHeight * 0.48,
                        "工作時身體趴伏於地面或作業平面，並且需要使用手臂進行操作，手臂的位置在身體下或前方;或躺下，抬舉手臂進行操作",
                        "ex:\n•汽車維修人員需要趴在地上，將手臂伸到車底進行零件拆裝，手臂需要用力操作工具，並長時間維持這種姿勢\n•地板鋪設人員需要趴在地上，將手臂伸到身體前方進行地板拼接，手臂需要頻繁移動和施力\n•天花板彩繪",
                        "assets/images/shoulderB3.png",
                      ),
                      onTimeRatioChanged: updateTimeRatio3,
                    ),
                    SizedBox(height: screenHeight * 0.15),
                    SizedBox(
                      width: screenWidth * 0.36,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveShoulderUpperLimbLoadRatingPoints();

                          if (!isGuest && context.mounted) {
                            Navigator.pop(context);
                          } else {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                  partC
                                      ? LowerLimbLoadRating(
                                    userName: widget.userName,
                                  )
                                      : WorkConditionRating(
                                    userName: widget.userName,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.036,
                            vertical: screenHeight * 0.01,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isGuest) ...[
                              SizedBox(width: screenWidth * 0.036),
                              Text(
                                "下一步",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.049,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: screenWidth * 0.064,
                              ),
                            ] else ...[
                              Text(
                                "保存",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.049,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
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
