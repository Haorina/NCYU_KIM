import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import 'work_organization_rating.dart';


List<String> workConditionList1 = [
  "手/手臂關節已到極限",
  "重物不易抓握/需更大的持握力量",
  "不良的氣候條件",
  "空間條件",
  "額外的衣物或裝備",
  "握持/搬運情況",
];


List<List<String>> workConditionList2 = [
  ["幾乎不", "偶爾", "經常"],
  ["不太", "稍微", "非常"],
  ["無", "有"],
  ["正常", "受限", "不良"],
  ["無", "有"],
  ["正常", "受限", "不良"],
];


List<List<String>> workConditionList3 = [
  ["0", "1", "2"],
  ["0", "1", "2"],
  ["0", "1"],
  ["0", "1", "2"],
  ["0", "1"],
  ["0", "2", "5"],
];


List<List<String>> workConditionList4 = [
  ["unfavorableJoint"],
  ["grab_condition-normal", "grab_condition-hard", "grab_condition-difficult"],
  ["weather-bad"],
  ["spatial-normal", "spatial-restricted", "spatial-bad"],
  ["equipment"],
  [
    "carry_condition-normal",
    "carry_condition-hard",
    "carry_condition-difficult",
  ],
];


Widget title1(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width: screenWidth * 0.28),
      Text(
        workConditionList1[0],
        style: TextStyle(
          fontSize: screenWidth * 0.044,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: screenWidth * 0.1),
      IconButton(
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
                height: screenHeight * 0.3,
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
                          "手部、手腕、肘關節的關節或前臂活動範圍接近或達到生理極限位置，超出舒適的工作範圍",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
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
                        "ex:\n•內旋/外旋極限\n•手臂完全伸直或過度伸展\n•肩內收極限\n•手腕彎曲極限",
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
      ),
    ],
  );
}


Widget title2(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        workConditionList1[1],
        style: TextStyle(
          fontSize: screenWidth * 0.044,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}


Widget title3(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width: screenWidth * 0.31),
      Text(
        workConditionList1[2],
        style: TextStyle(
          fontSize: screenWidth * 0.044,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: screenWidth * 0.1),
      IconButton(
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
                width: screenWidth * 0.75,
                height: screenHeight * 0.1,
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
                            width: screenWidth * 0.59,
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
                        width: screenWidth * 0.65,
                        child: Text(
                          "熱、不舒服的吹風、寒冷、潮濕",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
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
      ),
    ],
  );
}


Widget title4(BuildContext context, double screenWidth, double screenHeight) {
  return Container(
    alignment: Alignment.center,
    child: Text(
      workConditionList1[3],
      style: TextStyle(
        fontSize: screenWidth * 0.044,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}


Widget title5(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width: screenWidth * 0.312),
      Text(
        workConditionList1[4],
        style: TextStyle(
          fontSize: screenWidth * 0.044,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: screenWidth * 0.1),
      IconButton(
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
                width: screenWidth * 0.75,
                height: screenHeight * 0.21,
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
                            width: screenWidth * 0.59,
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
                        width: screenWidth * 0.65,
                        child: Text(
                          "由於防護衣物或裝備增加額外身體負荷",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.65,
                      child: Text(
                        "ex:\n•厚重雨衣、全身防護裝、呼吸防護具、裝備腰帶等",
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
      ),
    ],
  );
}


Widget title6(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        workConditionList1[5],
        style: TextStyle(
          fontSize: screenWidth * 0.044,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}


Widget body1(double screenWidth, double screenHeight) {
  return Container(
    alignment: Alignment.center,
    width: screenWidth * 0.56,
    height: screenHeight * 0.18,
    decoration: BoxDecoration(
      color: const Color(0XFFEFEFEF),
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1.0,
          spreadRadius: 1,
          color: const Color(0x60000000),
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/${workConditionList4[0][0]}.png"),
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );
}


Widget body2(double screenWidth, double screenHeight, String text) {
  return Container(
    alignment: Alignment.center,
    width: screenWidth * 0.56,
    height: screenHeight * 0.18,
    decoration: BoxDecoration(
      color: const Color(0XFFEFEFEF),
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1.0,
          spreadRadius: 1,
          color: const Color(0x60000000),
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        image:
        workConditionList2[1].indexOf(text) == 0
            ? DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[1][0]}.png",
          ),
          fit: BoxFit.fitHeight,
        )
            : workConditionList2[1].indexOf(text) == 1
            ? DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[1][1]}.png",
          ),
          fit: BoxFit.fitHeight,
        )
            : DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[1][2]}.png",
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );
}


Widget body3(double screenWidth, double screenHeight) {
  return Container(
    alignment: Alignment.center,
    width: screenWidth * 0.56,
    height: screenHeight * 0.18,
    decoration: BoxDecoration(
      color: const Color(0XFFEFEFEF),
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1.0,
          spreadRadius: 1,
          color: const Color(0x60000000),
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/${workConditionList4[2][0]}.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
    ),
  );
}


Widget body4(double screenWidth, double screenHeight, String text) {
  return Container(
    alignment: Alignment.center,
    width: screenWidth * 0.56,
    height: screenHeight * 0.18,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1.0,
          spreadRadius: 1,
          color: const Color(0x60000000),
        ),
      ],
    ),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        image:
        workConditionList2[3].indexOf(text) == 0
            ? DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[3][0]}.png",
          ),
          fit: BoxFit.fitHeight,
        )
            : workConditionList2[3].indexOf(text) == 1
            ? DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[3][1]}.png",
          ),
          fit: BoxFit.fitHeight,
        )
            : DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[3][2]}.png",
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );
}


Widget body5(double screenWidth, double screenHeight) {
  return Container(
    alignment: Alignment.center,
    width: screenWidth * 0.56,
    height: screenHeight * 0.18,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1.0,
          spreadRadius: 1,
          color: const Color(0x60000000),
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/${workConditionList4[4][0]}.png"),
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );
}


Widget body6(double screenWidth, double screenHeight, String text) {
  return Container(
    alignment: Alignment.center,
    width: screenWidth * 0.56,
    height: screenHeight * 0.18,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1.0,
          spreadRadius: 1,
          color: const Color(0x60000000),
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        image:
        workConditionList2[5].indexOf(text) == 0
            ? DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[5][0]}.png",
          ),
          fit: BoxFit.fitHeight,
        )
            : workConditionList2[5].indexOf(text) == 1
            ? DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[5][1]}.png",
          ),
          fit: BoxFit.fitHeight,
        )
            : DecorationImage(
          image: AssetImage(
            "assets/images/${workConditionList4[5][2]}.png",
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );
}


class WorkConditionRating extends StatefulWidget {
  const WorkConditionRating({super.key});


  @override
  State<WorkConditionRating> createState() => _WorkConditionRatingState();
}


class _WorkConditionRatingState extends State<WorkConditionRating> {
  String _text1 = workConditionList2[0][0];
  String _text2 = workConditionList2[1][0];
  String _text3 = workConditionList2[2][0];
  String _text4 = workConditionList2[3][0];
  String _text5 = workConditionList2[4][0];
  String _text6 = workConditionList2[5][0];
  int _score1 = int.parse(workConditionList3[0][0]);
  int _score2 = int.parse(workConditionList3[1][0]);
  int _score3 = int.parse(workConditionList3[2][0]);
  int _score4 = int.parse(workConditionList3[3][0]);
  int _score5 = int.parse(workConditionList3[4][0]);
  int _score6 = int.parse(workConditionList3[5][0]);
  int _totalScore = 0;


  Future<void> _saveWorkConditionRatingPoints(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("WorkConditionPoints", score);
    await prefs.setInt("WorkConditionScore1", _score1);
    await prefs.setInt("WorkConditionScore2", _score2);
    await prefs.setInt("WorkConditionScore3", _score3);
    await prefs.setInt("WorkConditionScore4", _score4);
    await prefs.setInt("WorkConditionScore5", _score5);
    await prefs.setInt("WorkConditionScore6", _score6);
  }


  void update1(String value) {
    setState(() {
      int score = int.parse(
        workConditionList3[0][workConditionList2[0].indexOf(value)],
      );
      _text1 = value;
      _score1 = score;
      _totalScore = _score1 + _score2 + _score3 + _score4 + _score5 + _score6;
      _saveWorkConditionRatingPoints(_totalScore);
    });
  }


  void update2(String value) {
    setState(() {
      int score = int.parse(
        workConditionList3[1][workConditionList2[1].indexOf(value)],
      );
      _text2 = value;
      _score2 = score;
      _totalScore = _score1 + _score2 + _score3 + _score4 + _score5 + _score6;
      _saveWorkConditionRatingPoints(_totalScore);
    });
  }


  void update3(String value) {
    setState(() {
      int score = int.parse(
        workConditionList3[2][workConditionList2[2].indexOf(value)],
      );
      _text3 = value;
      _score3 = score;
      _totalScore = _score1 + _score2 + _score3 + _score4 + _score5 + _score6;
      _saveWorkConditionRatingPoints(_totalScore);
    });
  }


  void update4(String value) {
    setState(() {
      int score = int.parse(
        workConditionList3[3][workConditionList2[3].indexOf(value)],
      );
      _text4 = value;
      _score4 = score;
      _totalScore = _score1 + _score2 + _score3 + _score4 + _score5 + _score6;
      _saveWorkConditionRatingPoints(_totalScore);
    });
  }


  void update5(String value) {
    setState(() {
      int score = int.parse(
        workConditionList3[4][workConditionList2[4].indexOf(value)],
      );
      _text5 = value;
      _score5 = score;
      _totalScore = _score1 + _score2 + _score3 + _score4 + _score5 + _score6;
      _saveWorkConditionRatingPoints(_totalScore);
    });
  }


  void update6(String value) {
    setState(() {
      int score = int.parse(
        workConditionList3[5][workConditionList2[5].indexOf(value)],
      );
      _text6 = value;
      _score6 = score;
      _totalScore = _score1 + _score2 + _score3 + _score4 + _score5 + _score6;
      _saveWorkConditionRatingPoints(_totalScore);
    });
  }


  Widget select1(double screenWidth, double screenHeight) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 3; i++) ...[
            if (i != 0) ...[SizedBox(width: screenWidth * 0.024)],
            ElevatedButton(
              onPressed: () {
                update1(workConditionList2[0][i]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                workConditionList2[0].indexOf(_text1) == i
                    ? const Color(0XFF6F8FA8)
                    : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.26, screenHeight * 0.046),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                  workConditionList2[0].indexOf(_text1) == i
                      ? BorderSide(color: Colors.black87, width: 1)
                      : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                workConditionList2[0][i],
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.024),
          ],
        ],
      ),
    );
  }


  Widget select2(double screenWidth, double screenHeight) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              update2(workConditionList2[1][0]);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
              workConditionList2[1].indexOf(_text2) == 0
                  ? const Color(0XFF6F8FA8)
                  : const Color(0xFFE9E9E9),
              minimumSize: Size(screenWidth * 0.26, screenHeight * 0.046),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side:
                workConditionList2[1].indexOf(_text2) == 0
                    ? BorderSide(color: Colors.black87, width: 1)
                    : BorderSide.none,
              ),
              elevation: 5,
            ),
            child: Text(
              workConditionList2[1][0],
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.024),
          SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.08,
            child: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      update2(workConditionList2[1][1]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workConditionList2[1].indexOf(_text2) == 1
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workConditionList2[1].indexOf(_text2) == 1
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workConditionList2[1][1],
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
                  left: screenWidth * 0.2,
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
                            (context, animation, secondaryAnimation) => Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.3,
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
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      "需要額外注意或用力，但基本上能安全抓握",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.7,
                                  child: Text(
                                    "ex:\n•搬運平滑但乾燥的紙箱\n•戴手套工作材質影響摩擦力等\n•物品沒有專門設計的握把、握持位置不符\n 合人體工學\n•需要出力握緊但不會滑脫的物品",
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
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.024),
          SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.08,
            child: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      update2(workConditionList2[1][2]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workConditionList2[1].indexOf(_text2) == 2
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workConditionList2[1].indexOf(_text2) == 2
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workConditionList2[1][2],
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
                  left: screenWidth * 0.2,
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
                            (context, animation, secondaryAnimation) => Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.32,
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
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      "抓握不穩定嚴重影響操作，或容易滑脫/受傷，或滑/軟/尖銳的邊緣，或無/不適當的握柄",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.7,
                                  child: Text(
                                    "ex:\n•搬運濕滑或油膩的重物\n•抓取有尖銳邊緣的金屬板\n•握持軟塌塌、會變形的材料包\n•戴不防滑手套操作\n•握把破損或設計不良的工具",
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget select3(double screenWidth, double screenHeight) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 2; i++) ...[
            SizedBox(width: screenWidth * 0.06),
            ElevatedButton(
              onPressed: () {
                update3(workConditionList2[2][i]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                workConditionList2[2].indexOf(_text3) == i
                    ? const Color(0XFF6F8FA8)
                    : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.26, screenHeight * 0.046),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                  workConditionList2[2].indexOf(_text3) == i
                      ? BorderSide(color: Colors.black87, width: 1)
                      : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                workConditionList2[2][i],
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.06),
          ],
        ],
      ),
    );
  }


  Widget select4(double screenWidth, double screenHeight) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              update4(workConditionList2[3][0]);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
              workConditionList2[3].indexOf(_text4) == 0
                  ? const Color(0XFF6F8FA8)
                  : const Color(0xFFE9E9E9),
              minimumSize: Size(screenWidth * 0.26, screenHeight * 0.046),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side:
                workConditionList2[3].indexOf(_text4) == 0
                    ? BorderSide(color: Colors.black87, width: 1)
                    : BorderSide.none,
              ),
              elevation: 5,
            ),
            child: Text(
              workConditionList2[3][0],
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.024),
          SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.08,
            child: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      update4(workConditionList2[3][1]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workConditionList2[3].indexOf(_text4) == 1
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workConditionList2[3].indexOf(_text4) == 1
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workConditionList2[3][1],
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
                  left: screenWidth * 0.2,
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
                            (context, animation, secondaryAnimation) => Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.2,
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
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      "工作空間 ＜ 1.5m²，或地板中度骯髒、輕度不平整，或輕微傾斜(不超過5°)，或輕度穩定度受限，或重物需放置精確",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
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
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.024),
          SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.08,
            child: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      update4(workConditionList2[3][2]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workConditionList2[3].indexOf(_text4) == 2
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workConditionList2[3].indexOf(_text4) == 2
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workConditionList2[3][2],
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
                  left: screenWidth * 0.2,
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
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      "活動的自由度嚴重受限、可活動的高度不足，或工作空間侷限，或地板非常骯髒、不平整或粗糙地面，如碎石、小坑洞，傾斜5-10°，或穩定度受限，重物需放置非常精確",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget select5(double screenWidth, double screenHeight) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 2; i++) ...[
            SizedBox(width: screenWidth * 0.06),
            ElevatedButton(
              onPressed: () {
                update5(workConditionList2[4][i]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                workConditionList2[4].indexOf(_text5) == i
                    ? const Color(0XFF6F8FA8)
                    : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.26, screenHeight * 0.046),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                  workConditionList2[4].indexOf(_text5) == i
                      ? BorderSide(color: Colors.black87, width: 1)
                      : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                workConditionList2[4][i],
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.06),
          ],
        ],
      ),
    );
  }


  Widget select6(double screenWidth, double screenHeight) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.08,
            child: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      update6(workConditionList2[5][0]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workConditionList2[5].indexOf(_text6) == 0
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workConditionList2[5].indexOf(_text6) == 0
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workConditionList2[5][0],
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
                  left: screenWidth * 0.2,
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
                            (context, animation, secondaryAnimation) => Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.13,
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
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      "每次搬運/持握持續 < 5秒，搬運距離 < 2公尺",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
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
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.024),
          SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.08,
            child: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      update6(workConditionList2[5][1]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workConditionList2[5].indexOf(_text6) == 1
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workConditionList2[5].indexOf(_text6) == 1
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workConditionList2[5][1],
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
                  left: screenWidth * 0.2,
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
                            (context, animation, secondaryAnimation) => Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.13,
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
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      "每次搬運/持握持續5-10秒，搬運距離2-5公尺",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
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
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.024),
          SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.08,
            child: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      update6(workConditionList2[5][2]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workConditionList2[5].indexOf(_text6) == 2
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workConditionList2[5].indexOf(_text6) == 2
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workConditionList2[5][2],
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
                  left: screenWidth * 0.2,
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
                            (context, animation, secondaryAnimation) => Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.13,
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
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      "每次搬運/持握持續 > 10秒，搬運距離 > 5公尺",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double bottomPadding = MediaQuery.paddingOf(context).bottom;


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
              "不良工作條件",
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
                  currentStep: 5,
                  totalStep: 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                  "總分 : ${_totalScore.toString().replaceAll(".0", "")} / 13 分",
                  currentScore: _totalScore,
                  textSize: screenWidth * 0.038,
                  maxScore: 13,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        title1(context, screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.02),
                        body1(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.03),
                        select1(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.05),
                        title2(context, screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.03),
                        body2(screenWidth, screenHeight, _text2),
                        SizedBox(height: screenHeight * 0.02),
                        select2(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.05),
                        title3(context, screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.02),
                        body3(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.03),
                        select3(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.05),
                        title4(context, screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.03),
                        body4(screenWidth, screenHeight, _text4),
                        SizedBox(height: screenHeight * 0.02),
                        select4(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.05),
                        title5(context, screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.03),
                        body5(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.02),
                        select5(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.05),
                        title6(context, screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.03),
                        body6(screenWidth, screenHeight, _text6),
                        SizedBox(height: screenHeight * 0.02),
                        select6(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.06),
                        PONButton(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          havePrevious: false,
                          haveNextPage: true,
                          previousText: "",
                          nextText: "下一步",
                          nextPage: WorkOrganizationRating(),
                        ),
                        SizedBox(height: screenHeight * 0.06 - bottomPadding),
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
