import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/abp_select_item.dart';
import '../user_define_widget/previous_or_next_button.dart';
import 'shoulder_upper_limb_load_rating.dart';
import 'lower_limb_load_rating.dart';
import 'work_condition_rating.dart';

class BackLoadRating extends StatefulWidget {
  const BackLoadRating({super.key});

  @override
  State<BackLoadRating> createState() => _BackLoadRatingState();
}

class _BackLoadRatingState extends State<BackLoadRating> {
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

  Future<void> _saveBackLoadRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("BackLoadRatingPoints", score);
    await prefs.setBool("UprightStanding", isSelected1);
    await prefs.setString("UprightStanding_Frequency", selectedTimeRatio1);
    await prefs.setBool("TrunkTiltModerate", isSelected2);
    await prefs.setString("TrunkTiltModerate_Frequency", selectedTimeRatio2);
    await prefs.setBool("SevereTrunkLean", isSelected3);
    await prefs.setString("SevereTrunkLean_Frequency", selectedTimeRatio3);
    await prefs.setBool("SitNoRelax", isSelected4);
    await prefs.setString("SitNoRelax_Frequency", selectedTimeRatio4);
    await prefs.setBool("SitCanChange", isSelected5);
    await prefs.setString("SitCanChange_Frequency", selectedTimeRatio5);
    await prefs.setBool("SitChangeCanFree", canFree);
    await prefs.setBool("Upper", pick3);
    await prefs.setBool("SquatOrKneel", pick5);
    await prefs.setInt("TotalSteps", totalSteps);
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
      totalSteps = 6;
    } else if (pick3) {
      totalSteps = 5;
    } else if (pick5) {
      totalSteps = 5;
    } else {
      totalSteps = 4;
    }

    _saveBackLoadRatingPoints();
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

  IconButton help(double screenWidth, double screenHeight) {
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
                  height: screenHeight * 0.5,
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
                            "工作時，作業人員雖採取坐姿，但無法使軀幹靠背放鬆，身體呈現中重度的前傾，並且需要長時間將視線聚焦在工作區域",
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
                          "ex:\n•作業人員使用顯微鏡或內視鏡進行精細操\n 作，需要長時間保持軀幹前傾，並將視線高\n 度集中在顯微鏡或內視鏡的視野中，導致身\n 體無法放鬆\n•作業人員坐在地板或低矮平台上進行裝配或\n 包裝工作，導致軀幹嚴重前傾，且無法依靠\n 椅背支撐\n•操作人員操作起重機、控制台，需要長時間\n 保持軀幹前傾，難以變換坐姿或放鬆身體\n•辦公人員長時間在辦公桌前工作，身體前傾\n 且缺乏椅背支撐，視線高度專注於文件或電\n 腦螢幕，難以放鬆身體",
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
                                height: screenHeight * 0.23,
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
  void initState() {
    _saveBackLoadRatingPoints();
    super.initState();
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
                  currentStep: 2,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
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
                          contentText: "直立站姿、軀幹前傾 < 20°\n(站、蹲、跪姿)",
                          exampleText: "e.g. 銷售人員、機器操作員",
                          image: "assets/images/distance_body_center.png",
                          help: false,
                          onTimeRatioChanged: updateTimeRatio1,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          contentText: "軀幹中等前傾(20-60°)、\n向後傾(站、蹲、跪姿)",
                          exampleText: "e.g. 整理輸送帶",
                          image: "assets/images/distance_body_center.png",
                          help: false,
                          onTimeRatioChanged: updateTimeRatio2,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          contentText: "軀幹嚴重前傾(> 60°)\n（站、蹲、跪姿）",
                          exampleText: "e.g. 鋼筋工人",
                          image: "assets/images/distance_body_center.png",
                          help: false,
                          onTimeRatioChanged: updateTimeRatio3,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          contentText: "坐姿無法放鬆",
                          exampleText: "e.g. 顯微鏡、內視鏡、\n       操作起重機 、坐在地板作業",
                          help: true,
                          icon: help(screenWidth, screenHeight),
                          image: "assets/images/distance_body_center.png",
                          onTimeRatioChanged: updateTimeRatio4,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        AbpSelectItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          contentText: "坐姿可變換",
                          exampleText: "e.g. 辦公室作業",
                          image: "assets/images/distance_body_center.png",
                          help: false,
                          onTimeRatioChanged: updateTimeRatio5,
                        ),
                        if (isSelected5) ...[
                          SizedBox(height: screenHeight * 0.04),
                          select(
                            screenWidth,
                            screenHeight,
                            "自由站立/走路",
                            "assets/images/distance_body_center.png",
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
                          "assets/images/distance_body_center.png",
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
                          "assets/images/distance_body_center.png",
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
                        PONButton(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          havePrevious: false,
                          haveNextPage: true,
                          previousText: "",
                          nextText: "下一步",
                          nextPage:
                              pick3
                                  ? ShoulderUpperLimbLoadRating()
                                  : pick5
                                  ? LowerLimbLoadRating()
                                  : WorkConditionRating(),
                          onTap: () => _saveBackLoadRatingPoints(),
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
