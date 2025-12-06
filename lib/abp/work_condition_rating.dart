import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import 'result.dart';

class WorkConditionRating extends StatefulWidget {
  const WorkConditionRating({super.key});

  @override
  State<WorkConditionRating> createState() => _WorkConditionRatingState();
}

class _WorkConditionRatingState extends State<WorkConditionRating> {
  int totalSteps = 0;
  bool partB = false;
  bool partC = false;
  int totalScore = 0;
  int score = 0;
  bool pick1 = true;
  bool pick2 = false;
  bool pick3 = false;
  bool pick4 = false;
  bool pick5 = true;
  bool pick6 = false;
  bool pick7 = false;
  bool pick8 = false;
  bool pick9 = false;
  bool pick10 = false;
  bool pick11 = false;

  Future<void> _loadTotalSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      totalSteps = prefs.getInt("TotalSteps") ?? 0;
      partB = prefs.getBool("Upper") ?? false;
      partC = prefs.getBool("SquatOrKneel") ?? false;
      if (partB && partC) {
        totalScore = 22;
      } else if (partB) {
        totalScore = 18;
      } else if (partC) {
        totalScore = 15;
      } else {
        totalScore = 11;
      }
    });
  }

  Future<void> _saveWorkConditionRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("WorkConditionRatingPoints", score);
    if(pick1) {
      await prefs.setInt("TrunkTwistOrTilt", 1);
    }
    else if(pick2) {
      await prefs.setInt("TrunkTwistOrTilt", 2);
    }
    else if(pick3) {
      await prefs.setInt("TrunkTwistOrTilt", 3);
    }
    await prefs.setBool("HeadTiltedBack", pick4);
    await prefs.setBool("LeanForward", pick6);
    await prefs.setBool("ConfinedSpace", pick7);
    await prefs.setBool("MentalFocus", pick8);
    await prefs.setBool("UnstableFloor", pick9);
    await prefs.setBool("Wet", pick10);
    await prefs.setBool("StrongVibration", pick11);
  }

  @override
  void initState() {
    _loadTotalSteps();
    _saveWorkConditionRatingPoints();
    super.initState();
  }

  void update() {
    score = 0;

    if (pick2) {
      score += 1;
    } else if (pick3) {
      score += 2;
    }
    if (pick4) {
      score += 1;
    }
    if (pick6) {
      score += 2;
    }
    if (pick7) {
      score += 2;
    }
    if (pick8) {
      score += 1;
    }
    if (pick9) {
      score += 1;
    }
    if (pick10) {
      score += 1;
    }
    if (pick11) {
      score += 1;
    }

    if (partB) {
      if (pick4) {
        score += 1;
      }
      if (pick7) {
        score += 2;
      }
      if (pick8) {
        score += 1;
      }
      if (pick9) {
        score += 1;
      }
      if (pick10) {
        score += 1;
      }
      if (pick11) {
        score += 1;
      }
    }

    if (partC) {
      if (pick3) {
        score += 1;
      }
      if (pick7) {
        score += 2;
      }
      if (pick8) {
        score += 1;
      }
    }

    _saveWorkConditionRatingPoints();
  }

  Widget select(
    double screenWidth,
    double screenHeight,
    String titleText,
    String image,
    int buttonNum,
    bool pick1,
    bool pick2,
    bool? pick3,
    List<String> buttonText,
    bool help,
    Function(bool, int?) onChanged,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (help && buttonNum == 2) ...[
                  SizedBox(width: screenWidth * 0.11),
                ],
                if (help && buttonNum == 3) ...[
                  SizedBox(width: screenWidth * 0.2),
                ],
                Text(
                  titleText,
                  style: TextStyle(
                    fontSize: screenWidth * 0.046,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (help && buttonNum == 2) ...[
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
                                height: screenHeight * 0.37,
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
                                          "工作時頭部長時間維持偏離自然中立位置的姿勢，包括過度後仰、嚴重前傾，或長時間轉向一側。這些姿勢會對頸部造成額外的壓力",
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
                                        "ex:\n•抬頭查看高處設備或天花板配線，需要長時\n 間保持頭部過度後仰的姿勢\n•低頭觀察細部工作內容（如針線、雕刻、手\n 機維修），持續維持頸部前彎\n•為了與側邊同事溝通或操作側邊螢幕/工具\n 台，需要長時間保持頭部轉向一側的姿勢",
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
                if (help && buttonNum == 3) ...[
                  SizedBox(width: screenWidth * 0.11),
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
                                height: screenHeight * 0.4,
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
                                          "工作時身體偏離正常直立姿勢，向左右兩側傾斜，或軀幹旋轉的動作(無須精確角度測量，KIM更重視姿勢偏離的頻率和持續時間)",
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
                                        "ex:\n•轉身搬取物品，造成軀幹扭轉\n•為了操作機台或設備，需要長時間保持側身\n 姿勢，造成軀幹側傾\n•搬運不規則或體積較大的物品時，為了平\n 衡，軀幹會向一側傾斜\n•從地面或低矮處撿拾物品時，軀幹會同時彎\n 曲和扭轉",
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
                if (buttonNum == 2) ...[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        onChanged(true, null);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pick1
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.04,
                      ),
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
                        onChanged(false, null);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pick2
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.04,
                      ),
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
                if (buttonNum == 3) ...[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        onChanged(true, 1);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pick1
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.04,
                      ),
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
                  SizedBox(width: screenWidth * 0.1),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        onChanged(true, 2);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pick2
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.04,
                      ),
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
                  SizedBox(width: screenWidth * 0.1),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        onChanged(true, 3);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pick3!
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.04,
                      ),
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
                      buttonText[2],
                      style: TextStyle(
                        fontSize: screenWidth * 0.046,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget otherSelect(
    double screenWidth,
    double screenHeight,
    String titleText,
    bool pick6,
    bool pick7,
    bool pick8,
    bool pick9,
    bool pick10,
    bool pick11,
    List<String> buttonText,
    Function(int) onChanged,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "其他(",
                  style: TextStyle(
                    fontSize: screenWidth * 0.046,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  titleText,
                  style: TextStyle(
                    fontSize: screenWidth * 0.046,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ")",
                  style: TextStyle(
                    fontSize: screenWidth * 0.046,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
            ),
            SizedBox(height: screenHeight * 0.015),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  onChanged(1);
                  update();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    pick6 ? const Color(0XFF6F8FA8) : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.68, screenHeight * 0.056),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                      pick6
                          ? BorderSide(color: Colors.black87, width: 1)
                          : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                buttonText[0],
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              height: screenHeight * 0.065,
              child: Stack(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          onChanged(2);
                          update();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            pick7
                                ? const Color(0XFF6F8FA8)
                                : const Color(0xFFE9E9E9),
                        minimumSize: Size(
                          screenWidth * 0.68,
                          screenHeight * 0.056,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side:
                              pick7
                                  ? BorderSide(color: Colors.black87, width: 1)
                                  : BorderSide.none,
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        buttonText[1],
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * -0.01,
                    left: screenWidth * 0.77,
                    child: IconButton(
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
                              (
                                context,
                                animation,
                                secondaryAnimation,
                              ) => Center(
                                child: Container(
                                  width: screenWidth * 0.85,
                                  height: screenHeight * 0.56,
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
                                            "工作環境對作業人員的活動空間造成限制，導致他們需要長時間保持不自然的姿勢或動作，例如作業人員在搬運、操作或移動時，身體無法自然地伸展四肢或調整姿勢",
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
                                          "ex:\n•地下管道維修，維修人員需要在狹窄的地下\n 管道中進行管線維修工作，管道空間狹小，\n 無法正常站立，需要長時間彎腰或蹲伏作\n 業，且轉身困難\n•飛機底部檢查，檢查人員需要在飛機底部狹\n 小的空間內檢查起落架和機身結構，空間高\n 度不足，需要長時間保持半蹲或爬行的姿\n 勢，並且手臂活動受到限制\n•生產線上的機器維護，作業員需要在擁擠的\n 生產線上進行機器維護，空間狹窄，導致身\n 體難以自由移動，需要頻繁扭轉身體才能完\n 成作業",
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
                              child: ScaleTransition(
                                scale: curved,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              height: screenHeight * 0.065,
              child: Stack(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          onChanged(3);
                          update();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            pick8
                                ? const Color(0XFF6F8FA8)
                                : const Color(0xFFE9E9E9),
                        minimumSize: Size(
                          screenWidth * 0.68,
                          screenHeight * 0.056,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side:
                              pick8
                                  ? BorderSide(color: Colors.black87, width: 1)
                                  : BorderSide.none,
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        buttonText[2],
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * -0.01,
                    left: screenWidth * 0.77,
                    child: IconButton(
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
                              (
                                context,
                                animation,
                                secondaryAnimation,
                              ) => Center(
                                child: Container(
                                  width: screenWidth * 0.85,
                                  height: screenHeight * 0.4,
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
                                            "在工作中需長時間保持高度的心理注意力與專注度",
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
                                          "ex:\n•空中交通管制員需要高度集中注意力，持續\n 監控多個航班的動態，並在短時間內做出正\n 確的決策\n•手術醫師在進行手術時，需要高度的專注力\n 和精確的判斷力，並且需要長時間維持高度\n 的警覺，以應對可能出現的突發狀況\n•品質檢驗員需要仔細檢查產品的每一個細\n 節，以確保產品符合品質標準，任何疏忽都\n 可能導致不合格產品流入市場",
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
                              child: ScaleTransition(
                                scale: curved,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              height: screenHeight * 0.065,
              child: Stack(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          onChanged(4);
                          update();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            pick9
                                ? const Color(0XFF6F8FA8)
                                : const Color(0xFFE9E9E9),
                        minimumSize: Size(
                          screenWidth * 0.68,
                          screenHeight * 0.056,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side:
                              pick9
                                  ? BorderSide(color: Colors.black87, width: 1)
                                  : BorderSide.none,
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        buttonText[3],
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * -0.01,
                    left: screenWidth * 0.77,
                    child: IconButton(
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
                              (
                                context,
                                animation,
                                secondaryAnimation,
                              ) => Center(
                                child: Container(
                                  width: screenWidth * 0.85,
                                  height: screenHeight * 0.4,
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
                                            "工作環境中若地板表面凹凸不平、鬆動、濕滑或有傾斜，會增加身體平衡難度，迫使工作者不自主調整姿勢以維持穩定",
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
                                          "ex:\n•施工現場或倉庫地面有坑洞、裂縫、或散落\n 的砂石，導致地面不平整\n•農業或林業場域，土壤表面不平整，且可能\n 含有水分或泥濘\n•工廠廠房內地面因機械磨損而變得不平整，\n 或有油污導致濕滑\n•戶外作業場地地面有明顯坡度，或存在不穩\n 固的踏面）",
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
                              child: ScaleTransition(
                                scale: curved,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  onChanged(5);
                  update();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    pick10 ? const Color(0XFF6F8FA8) : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.68, screenHeight * 0.056),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                      pick10
                          ? BorderSide(color: Colors.black87, width: 1)
                          : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                buttonText[4],
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              height: screenHeight * 0.065,
              child: Stack(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          onChanged(6);
                          update();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            pick11
                                ? const Color(0XFF6F8FA8)
                                : const Color(0xFFE9E9E9),
                        minimumSize: Size(
                          screenWidth * 0.68,
                          screenHeight * 0.056,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side:
                              pick11
                                  ? BorderSide(color: Colors.black87, width: 1)
                                  : BorderSide.none,
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        buttonText[5],
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * -0.01,
                    left: screenWidth * 0.77,
                    child: IconButton(
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
                              (
                                context,
                                animation,
                                secondaryAnimation,
                              ) => Center(
                                child: Container(
                                  width: screenWidth * 0.85,
                                  height: screenHeight * 0.4,
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
                                            "工作環境中存在強烈的機械震動，這些震動會透過手部、手臂或全身傳遞至作業人員",
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
                                          "ex:\n•作業人員長時間使用電鑽、砂輪機等手\n 持電動工具，手部和手臂會受到強烈且\n 高頻的震動\n•駕駛員長時間駕駛推土機、挖土機等重\n 型機械，全身會受到低頻但持續的震動\n•工人在建築工地使用震動夯實機，需要\n 手扶機具，因此手部和手臂會受到強烈\n 震動",
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
                              child: ScaleTransition(
                                scale: curved,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              "工作條件評級",
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
                  currentStep: partB && partC ? 5 : partB && !partC ? 4 : !partB && partC ? 4 : 3,
                  totalStep: totalSteps,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                      "總分 : ${score.toString().replaceAll(".0", "")} / $totalScore 分",
                  currentScore: score,
                  textSize: screenWidth * 0.038,
                  maxScore: totalScore,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        select(
                          screenWidth,
                          screenHeight,
                          "軀幹扭轉/側傾",
                          "assets/images/distance_body_center.png",
                          3,
                          pick1,
                          pick2,
                          pick3,
                          ["無", "偶爾", "經常"],
                          true,
                          (value1, value2) {
                            setState(() {
                              if (value2 == 1) {
                                pick1 = value1;
                                pick2 = !value1;
                                pick3 = !value1;
                              } else if (value2 == 2) {
                                pick1 = !value1;
                                pick2 = value1;
                                pick3 = !value1;
                              } else if (value2 == 3) {
                                pick1 = !value1;
                                pick2 = !value1;
                                pick3 = value1;
                              }
                              update();
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        select(
                          screenWidth,
                          screenHeight,
                          "頭部後傾/嚴重地前傾/維持轉頭姿勢",
                          "assets/images/distance_body_center.png",
                          2,
                          pick4,
                          pick5,
                          null,
                          ["有", "無"],
                          true,
                          (value1, value2) {
                            setState(() {
                              pick4 = value1;
                              pick5 = !value1;
                              update();
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        otherSelect(
                          screenWidth,
                          screenHeight,
                          "複選",
                          pick6,
                          pick7,
                          pick8,
                          pick9,
                          pick10,
                          pick11,
                          [
                            "軀幹前傾時沒有支撐",
                            "經常處在狹窄空間",
                            "需極度心理專注",
                            "不穩定、不平整地板",
                            "潮濕、冷、極乾、衣服淋濕",
                            "強烈震動",
                          ],
                          (value) {
                            setState(() {
                              if (value == 1) {
                                pick6 = !pick6;
                              } else if (value == 2) {
                                pick7 = !pick7;
                              } else if (value == 3) {
                                pick8 = !pick8;
                              } else if (value == 4) {
                                pick9 = !pick9;
                              } else if (value == 5) {
                                pick10 = !pick10;
                              } else if (value == 6) {
                                pick11 = !pick11;
                              }
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        PONButton(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          havePrevious: false,
                          haveNextPage: true,
                          previousText: "",
                          nextText: "下一步",
                          nextPage: Result(),
                          onTap: () => _saveWorkConditionRatingPoints(),
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
