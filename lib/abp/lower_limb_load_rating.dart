import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/abp_select_item.dart';
import 'work_condition_rating.dart';

class LowerLimbLoadRating extends StatefulWidget {
  final String? userName;
  const LowerLimbLoadRating({super.key, this.userName});

  @override
  State<LowerLimbLoadRating> createState() => _LowerLimbLoadRatingState();
}

class _LowerLimbLoadRatingState extends State<LowerLimbLoadRating> {
  int score = 0;
  int totalSteps = 4;
  bool partB = false;
  bool partC = false;
  bool isSelected1 = false;
  bool isSelected2 = false;
  String selectedTimeRatio1 = "<25";
  String selectedTimeRatio2 = "<25";
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

    _loadLowerLimbLoadRatingPoints();
  }

  Future<void> _loadLowerLimbLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      isSelected1 = prefs.getBool('LowerLimbLoadSelect1') ?? false;
      isSelected2 = prefs.getBool('LowerLimbLoadSelect2') ?? false;
      selectedTimeRatio1 = prefs.getString('LowerLimbLoadLabel1') ?? "<25";
      selectedTimeRatio2 = prefs.getString('LowerLimbLoadLabel2') ?? "<25";
      partB = prefs.getBool('PartB') ?? false;
      partC = prefs.getBool('PartC') ?? false;
      totalSteps = prefs.getInt('TotalStep') ?? 4;
    } else {
      isSelected1 =
          prefs.getBool('${widget.userName}_ABP_LowerLimbLoadSelect1') ?? false;
      isSelected2 =
          prefs.getBool('${widget.userName}_ABP_LowerLimbLoadSelect2') ?? false;
      selectedTimeRatio1 =
          prefs.getString('${widget.userName}_ABP_LowerLimbLoadLabel1') ?? "";
      selectedTimeRatio2 =
          prefs.getString('${widget.userName}_ABP_LowerLimbLoadLabel2') ?? "";
      partB = prefs.getBool('${widget.userName}_ABP_PartB') ?? false;
      partC = prefs.getBool('${widget.userName}_ABP_PartC') ?? false;
      totalSteps = prefs.getInt('${widget.userName}_ABP_TotalStep') ?? 0;
    }

    update();
  }

  Future<void> _saveLowerLimbLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setBool('LowerLimbLoadSelect1', isSelected1);
      await prefs.setBool('LowerLimbLoadSelect2', isSelected2);
      await prefs.setString('LowerLimbLoadLabel1', selectedTimeRatio1);
      await prefs.setString('LowerLimbLoadLabel2', selectedTimeRatio2);
      await prefs.setInt('LowerLimbLoadRatingPoints', score);
      await prefs.setBool('PartB', partB);
      await prefs.setBool('PartC', partC);
      await prefs.setInt('TotalStep', totalSteps);
    } else {
      await prefs.setBool(
        '${widget.userName}_ABP_LowerLimbLoadSelect1',
        isSelected1,
      );
      await prefs.setBool(
        '${widget.userName}_ABP_LowerLimbLoadSelect2',
        isSelected2,
      );
      await prefs.setString(
        '${widget.userName}_ABP_LowerLimbLoadLabel1',
        selectedTimeRatio1,
      );
      await prefs.setString(
        '${widget.userName}_ABP_LowerLimbLoadLabel2',
        selectedTimeRatio2,
      );
      await prefs.setInt(
        '${widget.userName}_ABP_LowerLimbLoadRatingPoints',
        score,
      );
      await prefs.setBool('${widget.userName}_ABP_PartB', partB);
      await prefs.setBool('${widget.userName}_ABP_PartC', partC);
      await prefs.setInt('${widget.userName}_ABP_TotalStep', totalSteps);
    }
  }

  void update() {
    Map<String, int> map1 = {"<25": 2, "25-50": 4, "51-75": 6, ">75": 8};
    Map<String, int> map2 = {"<25": 10, "25-50": 20, "51-75": 30, ">75": 40};
    score = 0;

    if (isSelected1) {
      score += map1[selectedTimeRatio1]!;
    }
    if (isSelected2) {
      score += map2[selectedTimeRatio2]!;
    }

    setState(() {});

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveLowerLimbLoadRatingPoints();
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
              "下肢負荷評級",
              style: TextStyle(
                fontSize: screenWidth * 0.056,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
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
                  currentStep: partB ? 4 : 3,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
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
                  children: [
                    SizedBox(height: screenHeight * 0.035),
                    AbpSelectItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isSelected: isSelected1,
                      selectedTimeRatio: selectedTimeRatio1,
                      contentText: "經常站立，僅偶爾走幾步路",
                      exampleText: "e.g. 銷售人員、\n       機器操作員",
                      image: "assets/images/lowerC1s.png",
                      help: true,
                      icon: helpCustom(
                        screenWidth,
                        screenHeight,
                        screenHeight * 0.35,
                        "經常站立，僅偶爾走幾步路",
                        "",
                        "assets/images/lowerC1.png",
                      ),
                      onTimeRatioChanged: updateTimeRatio1,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    AbpSelectItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isSelected: isSelected2,
                      selectedTimeRatio: selectedTimeRatio2,
                      contentText: "蹲、跪、坐姿翹腳",
                      exampleText: "e.g. 工地、室內裝修、\n       鋪管工人、收割、\n       鋪地磚",
                      image: "assets/images/lowerC2s.png",
                      help: true,
                      icon: helpCustom(
                        screenWidth,
                        screenHeight,
                        screenHeight * 0.25,
                        "蹲、跪、坐姿翹腳",
                        "",
                        "assets/images/loweC2r.png",
                      ),
                      onTimeRatioChanged: updateTimeRatio2,
                    ),
                    SizedBox(height: screenHeight * 0.3),
                    SizedBox(
                      width: screenWidth * 0.36,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveLowerLimbLoadRatingPoints();

                          if (!isGuest && context.mounted) {
                            Navigator.pop(context);
                          } else {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => WorkConditionRating(
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
