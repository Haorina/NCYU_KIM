import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/abp_select_item.dart';
import 'shoulder_upper_limb_load_rating.dart';
import 'lower_limb_load_rating.dart';
import 'work_condition_rating.dart';

class BackLoadRating extends StatefulWidget {
  final String? userName;
  const BackLoadRating({super.key, this.userName});

  @override
  State<BackLoadRating> createState() => BackLoadRatingState();
}

class BackLoadRatingState extends State<BackLoadRating> {
  final ScrollController _scrollController = ScrollController();
  bool isSelected1 = false;
  bool isSelected2 = false;
  bool isSelected3 = false;
  bool isSelected4 = false;
  bool isSelected5 = false;
  String selectedTimeRatio1 = "<25";
  String selectedTimeRatio2 = "<25";
  String selectedTimeRatio3 = "<25";
  String selectedTimeRatio4 = "<25";
  String selectedTimeRatio5 = "<25";
  int totalSteps = 4;
  double score = 0;
  bool canFree = false;
  bool pick1 = false;
  bool pick2 = true;
  bool pick3 = false;
  bool pick4 = true;
  bool pick5 = false;
  bool pick6 = true;
  bool partB = false;
  bool partC = false;
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

    _loadBackLoadRatingPoints();
  }

  Future<void> _loadBackLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      isSelected1 = prefs.getBool('BackLoadSelect1') ?? false;
      isSelected2 = prefs.getBool('BackLoadSelect2') ?? false;
      isSelected3 = prefs.getBool('BackLoadSelect3') ?? false;
      isSelected4 = prefs.getBool('BackLoadSelect4') ?? false;
      isSelected5 = prefs.getBool('BackLoadSelect5') ?? false;
      selectedTimeRatio1 = prefs.getString('BackLoadLabel1') ?? "<25";
      selectedTimeRatio2 = prefs.getString('BackLoadLabel2') ?? "<25";
      selectedTimeRatio3 = prefs.getString('BackLoadLabel3') ?? "<25";
      selectedTimeRatio4 = prefs.getString('BackLoadLabel4') ?? "<25";
      selectedTimeRatio5 = prefs.getString('BackLoadLabel5') ?? "<25";
      canFree = prefs.getBool('BackLoadCanFree') ?? false;
      pick1 = prefs.getBool('BackLoadPick1') ?? false;
      pick2 = prefs.getBool('BackLoadPick2') ?? true;
      pick3 = prefs.getBool('BackLoadPick3') ?? false;
      pick4 = prefs.getBool('BackLoadPick4') ?? true;
      pick5 = prefs.getBool('BackLoadPick5') ?? false;
      pick6 = prefs.getBool('BackLoadPick6') ?? true;
      partB = prefs.getBool('PartB') ?? false;
      partC = prefs.getBool('PartC') ?? false;
      totalSteps = prefs.getInt('TotalStep') ?? 4;
    } else {
      isSelected1 =
          prefs.getBool('${widget.userName}_ABP_BackLoadSelect1') ?? false;
      isSelected2 =
          prefs.getBool('${widget.userName}_ABP_BackLoadSelect2') ?? false;
      isSelected3 =
          prefs.getBool('${widget.userName}_ABP_BackLoadSelect3') ?? false;
      isSelected4 =
          prefs.getBool('${widget.userName}_ABP_BackLoadSelect4') ?? false;
      isSelected5 =
          prefs.getBool('${widget.userName}_ABP_BackLoadSelect5') ?? false;
      selectedTimeRatio1 =
          prefs.getString('${widget.userName}_ABP_BackLoadLabel1') ?? "";
      selectedTimeRatio2 =
          prefs.getString('${widget.userName}_ABP_BackLoadLabel2') ?? "";
      selectedTimeRatio3 =
          prefs.getString('${widget.userName}_ABP_BackLoadLabel3') ?? "";
      selectedTimeRatio4 =
          prefs.getString('${widget.userName}_ABP_BackLoadLabel4') ?? "";
      selectedTimeRatio5 =
          prefs.getString('${widget.userName}_ABP_BackLoadLabel5') ?? "";
      canFree =
          prefs.getBool('${widget.userName}_ABP_BackLoadCanFree') ?? false;
      pick1 = prefs.getBool('${widget.userName}_ABP_BackLoadPick1') ?? false;
      pick2 = prefs.getBool('${widget.userName}_ABP_BackLoadPick2') ?? true;
      pick3 = prefs.getBool('${widget.userName}_ABP_BackLoadPick3') ?? false;
      pick4 = prefs.getBool('${widget.userName}_ABP_BackLoadPick4') ?? true;
      pick5 = prefs.getBool('${widget.userName}_ABP_BackLoadPick5') ?? false;
      pick6 = prefs.getBool('${widget.userName}_ABP_BackLoadPick6') ?? true;
      partB = prefs.getBool('${widget.userName}_ABP_PartB') ?? false;
      partC = prefs.getBool('${widget.userName}_ABP_PartC') ?? false;
      totalSteps = prefs.getInt('${widget.userName}_ABP_TotalStep') ?? 0;
    }

    update();
  }

  Future<void> _saveBackLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setBool('BackLoadSelect1', isSelected1);
      await prefs.setBool('BackLoadSelect2', isSelected2);
      await prefs.setBool('BackLoadSelect3', isSelected3);
      await prefs.setBool('BackLoadSelect4', isSelected4);
      await prefs.setBool('BackLoadSelect5', isSelected5);
      await prefs.setString('BackLoadLabel1', selectedTimeRatio1);
      await prefs.setString('BackLoadLabel2', selectedTimeRatio2);
      await prefs.setString('BackLoadLabel3', selectedTimeRatio3);
      await prefs.setString('BackLoadLabel4', selectedTimeRatio4);
      await prefs.setString('BackLoadLabel5', selectedTimeRatio5);
      await prefs.setBool('BackLoadCanFree', canFree);
      await prefs.setBool('BackLoadPick1', pick1);
      await prefs.setBool('BackLoadPick2', pick2);
      await prefs.setBool('BackLoadPick3', pick3);
      await prefs.setBool('BackLoadPick4', pick4);
      await prefs.setBool('BackLoadPick5', pick5);
      await prefs.setBool('BackLoadPick6', pick6);
      await prefs.setDouble('BackLoadRatingPoints', score);
      await prefs.setBool('PartB', partB);
      await prefs.setBool('PartC', partC);
      await prefs.setInt('TotalStep', totalSteps);
    } else {
      await prefs.setBool(
        '${widget.userName}_ABP_BackLoadSelect1',
        isSelected1,
      );
      await prefs.setBool(
        '${widget.userName}_ABP_BackLoadSelect2',
        isSelected2,
      );
      await prefs.setBool(
        '${widget.userName}_ABP_BackLoadSelect3',
        isSelected3,
      );
      await prefs.setBool(
        '${widget.userName}_ABP_BackLoadSelect4',
        isSelected4,
      );
      await prefs.setBool(
        '${widget.userName}_ABP_BackLoadSelect5',
        isSelected5,
      );
      await prefs.setString(
        '${widget.userName}_ABP_BackLoadLabel1',
        selectedTimeRatio1,
      );
      await prefs.setString(
        '${widget.userName}_ABP_BackLoadLabel2',
        selectedTimeRatio2,
      );
      await prefs.setString(
        '${widget.userName}_ABP_BackLoadLabel3',
        selectedTimeRatio3,
      );
      await prefs.setString(
        '${widget.userName}_ABP_BackLoadLabel4',
        selectedTimeRatio4,
      );
      await prefs.setString(
        '${widget.userName}_ABP_BackLoadLabel5',
        selectedTimeRatio5,
      );
      await prefs.setBool('${widget.userName}_ABP_BackLoadCanFree', canFree);
      await prefs.setBool('${widget.userName}_ABP_BackLoadPick1', pick1);
      await prefs.setBool('${widget.userName}_ABP_BackLoadPick2', pick2);
      await prefs.setBool('${widget.userName}_ABP_BackLoadPick3', pick3);
      await prefs.setBool('${widget.userName}_ABP_BackLoadPick4', pick4);
      await prefs.setBool('${widget.userName}_ABP_BackLoadPick5', pick5);
      await prefs.setBool('${widget.userName}_ABP_BackLoadPick6', pick6);
      await prefs.setDouble(
        '${widget.userName}_ABP_BackLoadRatingPoints',
        score,
      );
      await prefs.setBool('${widget.userName}_ABP_PartB', partB);
      await prefs.setBool('${widget.userName}_ABP_PartC', partC);
      await prefs.setInt('${widget.userName}_ABP_TotalStep', totalSteps);
    }
  }

  void update() {
    Map<String, int> selectedTimeRatio1Map = {
      "<25": 2,
      "25-50": 4,
      "51-75": 6,
      ">75": 8,
    };
    Map<String, int> selectedTimeRatio2Map = {
      "<25": 7,
      "25-50": 15,
      "51-75": 22,
      ">75": 30,
    };
    Map<String, int> selectedTimeRatio3Map = {
      "<25": 10,
      "25-50": 20,
      "51-75": 30,
      ">75": 40,
    };
    Map<String, int> selectedTimeRatio4Map = {
      "<25": 3,
      "25-50": 6,
      "51-75": 9,
      ">75": 12,
    };
    Map<String, int> selectedTimeRatio5Map = {
      "<25": 2,
      "25-50": 4,
      "51-75": 6,
      ">75": 8,
    };

    score = 0;

    if (isSelected1) {
      score += selectedTimeRatio1Map[selectedTimeRatio1]!.toDouble();
    }
    if (isSelected2) {
      score += selectedTimeRatio2Map[selectedTimeRatio2]!.toDouble();
    }
    if (isSelected3) {
      score += selectedTimeRatio3Map[selectedTimeRatio3]!.toDouble();
    }
    if (isSelected4) {
      score += selectedTimeRatio4Map[selectedTimeRatio4]!.toDouble();
    }
    if (isSelected5) {
      if (canFree) {
        score += (selectedTimeRatio5Map[selectedTimeRatio5]! / 4);
      } else {
        score += selectedTimeRatio5Map[selectedTimeRatio5]!.toDouble();
      }
    }

    if (pick3 && pick5) {
      partB = true;
      partC = true;
      totalSteps = 6;
    } else if (pick3 && !pick5) {
      partB = true;
      partC = false;
      totalSteps = 5;
    } else if (!pick3 && pick5) {
      partB = false;
      partC = true;
      totalSteps = 5;
    } else {
      partB = false;
      partC = false;
      totalSteps = 4;
    }

    setState(() {});

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveBackLoadRatingPoints();
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

  void updateTimeRatio4(String value, bool isSelected) {
    setState(() {
      isSelected4 = isSelected;
      selectedTimeRatio4 = value;
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
                  // 上方關閉按鈕
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

  Widget select(
      double screenWidth,
      double screenHeight,
      String titleText,
      String image,
      int buttonNum,
      bool pick1,
      bool pick2,
      List<String> buttonText,
      bool help,
      Function(bool) onChanged,
      ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (help) ...[SizedBox(width: screenWidth * 0.15)],
                Text(
                  titleText,
                  style: TextStyle(
                    fontSize: screenWidth * 0.046,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (help) ...[
                  SizedBox(width: screenWidth * 0.06),
                  IconButton(
                    icon: Image.asset("assets/images/help-circle.png"),
                    iconSize: screenWidth * 0.056,
                    color: Colors.black,
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel:
                        MaterialLocalizations.of(
                          context,
                        ).modalBarrierDismissLabel,
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder:
                            (context, animation, secondaryAnimation) => Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.24,
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
                                        width: screenWidth * 0.72,
                                        margin: EdgeInsets.only(
                                          top: screenHeight * 0.008,
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
                                    top: screenHeight * 0.015,
                                    bottom: screenHeight * 0.01,
                                  ),
                                  color: const Color(0XCCEFEFEF),
                                ),
                                Center(
                                  child: SizedBox(
                                    width: screenWidth * 0.75,
                                    child: Text(
                                      "手臂、手腕或肩膀處於不自然或過度用力的姿勢",
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
                                    "ex:\n•手高舉過肩\n•舉手但未過肩、遠離身體無支撐\n•趴下，手在身體下方/前方",
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
                        transitionBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                            ) {
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
                  ),
                ],
              ],
            ),
            Container(
              width: screenWidth * 0.52,
              height: screenHeight * 0.15,
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: Colors.black87),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 1.0,
                    spreadRadius: 1,
                    color: const Color(0xFF999999),
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * 0.01),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      onChanged(true);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    pick1
                        ? const Color(0XFF6F8FA8)
                        : const Color(0xFFE9E9E9),
                    minimumSize: Size(screenWidth * 0.24, screenHeight * 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side:
                      pick1
                          ? BorderSide(color: Colors.black87, width: 1)
                          : BorderSide.none,
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    buttonText[0],
                    style: TextStyle(
                      fontSize: screenWidth * 0.046,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.2),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      onChanged(false);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    pick2
                        ? const Color(0XFF6F8FA8)
                        : const Color(0xFFE9E9E9),
                    minimumSize: Size(screenWidth * 0.24, screenHeight * 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side:
                      pick2
                          ? BorderSide(color: Colors.black87, width: 1)
                          : BorderSide.none,
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    buttonText[1],
                    style: TextStyle(
                      fontSize: screenWidth * 0.046,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    void updateTimeRatio5(String value, bool isSelected) {
      setState(() {
        isSelected5 = isSelected;
        selectedTimeRatio5 = value;
        update();

        if (isSelected5) {
          _scrollController.animateTo(
            screenHeight * 0.4,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            screenHeight * 0.1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }

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
              "背部負荷評級",
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
                  currentStep: 2,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
                ScoreBar(
                  labelText:
                  "總分 : ${score.toString().replaceAll(".0", "")} / 98 分",
                  currentScore: score,
                  textSize: screenWidth * 0.038,
                  maxScore: 98,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isSelected: isSelected1,
                          selectedTimeRatio: selectedTimeRatio1,
                          contentText: "直立站姿、軀幹前傾 < 20°\n(站、蹲、跪姿)",
                          exampleText: "e.g. 銷售人員、\n機器操作員",
                          image: "assets/images/backA1s.png",
                          help: true,
                          icon: helpCustom(
                            screenWidth,
                            screenHeight,
                            screenHeight * 0.3,
                            "直立站姿、軀幹前傾 < 20°\n(站、蹲、跪姿)",
                            "",
                            "assets/images/backA1.png",
                          ),
                          onTimeRatioChanged: updateTimeRatio1,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isSelected: isSelected2,
                          selectedTimeRatio: selectedTimeRatio2,
                          contentText: "軀幹中等前傾(20-60°)、\n向後傾(站、蹲、跪姿)",
                          exampleText: "e.g. 整理輸送帶",
                          image: "assets/images/backA2s.png",
                          help: true,
                          icon: helpCustom(
                            screenWidth,
                            screenHeight,
                            screenHeight * 0.3,
                            "軀幹中等前傾(20-60°)、\n後傾(站、蹲、跪姿)",
                            "",
                            "assets/images/backA2.png",
                          ),

                          onTimeRatioChanged: updateTimeRatio2,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isSelected: isSelected3,
                          selectedTimeRatio: selectedTimeRatio3,
                          contentText: "軀幹嚴重前傾(> 60°)\n（站、蹲、跪姿）",
                          exampleText: "e.g. 鋼筋工人",
                          image: "assets/images/backA3s.png",
                          help: true,
                          icon: helpCustom(
                            screenWidth,
                            screenHeight,
                            screenHeight * 0.3,
                            "軀幹嚴重前傾(> 60°)\n（站、蹲、跪姿）",
                            "",
                            "assets/images/backA3.png",
                          ),

                          onTimeRatioChanged: updateTimeRatio3,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isSelected: isSelected4,
                          selectedTimeRatio: selectedTimeRatio4,
                          contentText: "坐姿無法放鬆",
                          exampleText: "e.g. 顯微鏡、\n       操作起重機",
                          help: true,
                          icon: helpCustom(
                            screenWidth,
                            screenHeight,
                            screenHeight * 0.54,
                            "工作時，作業人員雖採取坐姿，但無法使軀幹靠背放鬆，身體呈現中重度的前傾，並且需要長時間將視線聚焦在工作區域",
                            "ex:\n•作業人員使用顯微鏡或內視鏡進行精細操\n 作，需要長時間保持軀幹前傾，並將視線高度集中在顯微鏡或內視鏡的視野中，導致身體無法放鬆\n•作業人員坐在地板或低矮平台上進行裝配或\n 包裝工作，導致軀幹嚴重前傾，且無法依靠椅背支撐\n•操作人員操作起重機、控制台，需要長時間保持軀幹前傾，難以變換坐姿或放鬆身體\n•辦公人員長時間在辦公桌前工作，身體前傾且缺乏椅背支撐，視線高度專注於文件或電腦螢幕，難以放鬆身體",
                            "",
                          ),
                          image: "assets/images/backA4s.png",
                          onTimeRatioChanged: updateTimeRatio4,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isSelected: isSelected5,
                          selectedTimeRatio: selectedTimeRatio5,
                          contentText: "坐姿可變換",
                          exampleText: "e.g. 辦公室作業",
                          image: "assets/images/backA5s.png",
                          help: true,
                          icon: helpCustom(
                            screenWidth,
                            screenHeight,
                            screenHeight * 0.38,
                            "手臂、手腕或肩膀處於不自然或過度用力的姿勢",
                            "ex:\n•手高舉過肩舉手但未過肩、遠離身體無支撐\n趴下，手在身體下方/前方",
                            "assets/images/backA5.png",
                          ),

                          onTimeRatioChanged: updateTimeRatio5,
                        ),
                        if (isSelected5) ...[
                          SizedBox(height: screenHeight * 0.04),
                          select(
                            screenWidth,
                            screenHeight,
                            "自由站立/走路",
                            "assets/images/backA6.png",
                            2,
                            pick1,
                            pick2,
                            ["可以", "不行"],
                            false,
                                (value) {
                              setState(() {
                                pick1 = value;
                                pick2 = !value;
                                canFree = pick1;
                                update();
                              });
                            },
                          ),
                        ],
                        SizedBox(height: screenHeight * 0.05),
                        select(
                          screenWidth,
                          screenHeight,
                          "上肢不良姿勢",
                          "assets/images/que1.png",
                          2,
                          pick3,
                          pick4,
                          ["是", "否"],
                          true,
                              (value) {
                            setState(() {
                              pick3 = value;
                              pick4 = !value;
                              canFree = pick3;
                              update();
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        select(
                          screenWidth,
                          screenHeight,
                          "有蹲跪姿",
                          "assets/images/que2.png",
                          2,
                          pick5,
                          pick6,
                          ["是", "否"],
                          false,
                              (value) {
                            setState(() {
                              pick5 = value;
                              pick6 = !value;
                              canFree = pick5;
                              update();
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        SizedBox(
                          width: screenWidth * 0.36,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _saveBackLoadRatingPoints();

                              if (!isGuest && context.mounted) {
                                if (!partB) {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                                  await prefs.remove(
                                    '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect1',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect2',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_ShoulderUpperLimbLoadSelect3',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel1',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel2',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_ShoulderUpperLimbLoadLabel3',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_ShoulderUpperLimbLoadRatingPoints',
                                  );
                                }

                                if (!partC) {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                                  await prefs.remove(
                                    '${widget.userName}_ABP_LowerLimbLoadSelect1',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_LowerLimbLoadSelect2',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_LowerLimbLoadLabel1',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_LowerLimbLoadLabel2',
                                  );
                                  await prefs.remove(
                                    '${widget.userName}_ABP_LowerLimbLoadRatingPoints',
                                  );
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              } else {
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                      pick3
                                          ? ShoulderUpperLimbLoadRating(
                                        userName: currentUser,
                                      )
                                          : pick5
                                          ? LowerLimbLoadRating(
                                        userName: currentUser,
                                      )
                                          : WorkConditionRating(
                                        userName: currentUser,
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
                        SizedBox(height: screenHeight * 0.02),
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
