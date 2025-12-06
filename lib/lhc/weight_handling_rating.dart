import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import 'work_condition_rating.dart';

List<String> weightHandlingList1 = [
  "可使用雙手對稱負重",
  "暫時性的單手或不對稱負重/雙手重量不平均",
  "幾乎以單手負重/不穩定的負重重心",
];

List<String> weightHandlingList2 = ["0", "2", "4"];

Widget title(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "力量傳遞/負重條件",
        style: TextStyle(
          fontSize: screenWidth * 0.044,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget body(double screenWidth, double screenHeight, String text) {
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
            weightHandlingList1.indexOf(text) == 0
                ? DecorationImage(
                  image: AssetImage("assets/images/carry-both.png"),
                  fit: BoxFit.fitHeight,
                )
                : weightHandlingList1.indexOf(text) == 1
                ? DecorationImage(
                  image: AssetImage("assets/images/carry-differ.png"),
                  fit: BoxFit.fitHeight,
                )
                : DecorationImage(
                  image: AssetImage("assets/images/carry-single.png"),
                  fit: BoxFit.fitHeight,
                ),
      ),
    ),
  );
}

class WeightHandlingRating extends StatefulWidget {
  const WeightHandlingRating({super.key});

  @override
  State<WeightHandlingRating> createState() => _WeightHandlingRatingState();
}

class _WeightHandlingRatingState extends State<WeightHandlingRating> {
  String _text = weightHandlingList1[0];
  int _score = int.parse(weightHandlingList2[0]);
  bool pick1 = true;
  bool pick2 = false;
  bool pick3 = false;

  Future<void> _saveWeightHandlingRatingPoints(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("WeightHandlingPoints", _score);
  }

  void update(String value) {
    setState(() {
      int score = int.parse(
        weightHandlingList2[weightHandlingList1.indexOf(value)],
      );
      _text = value;
      _score = score;
      _saveWeightHandlingRatingPoints(score);
    });
  }

  Widget select(double screenWidth, double screenHeight) {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.08,
          child: Stack(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _text = weightHandlingList1[0];
                    pick1 = true;
                    pick2 = false;
                    pick3 = false;
                    update(_text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    pick1
                        ? const Color(0XFF6F8FA8)
                        : const Color(0xFFE9E9E9),
                    minimumSize: Size(screenWidth * 0.87, screenHeight * 0.056),
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
                    "可使用雙手對稱負重",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * -0.008,
                left: screenWidth * 0.85,
                child: IconButton(
                  icon: Image.asset("assets/images/help-circle.png"),
                  iconSize: screenWidth * 0.058,
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
                          height: screenHeight * 0.18,
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
                                    "雙手承擔相同重量，身體左右平衡",
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
                                  "ex:\n•雙手抬箱子，每手承重相等\n•雙手各抬一個同重量的物品",
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
        SizedBox(height: screenHeight * 0.03),
        SizedBox(
          height: screenHeight * 0.08,
          child: Stack(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _text = weightHandlingList1[1];
                    pick1 = false;
                    pick2 = true;
                    pick3 = false;
                    update(_text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    pick2
                        ? const Color(0XFF6F8FA8)
                        : const Color(0xFFE9E9E9),
                    minimumSize: Size(screenWidth * 0.87, screenHeight * 0.056),
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
                    "暫時性的單手或不對稱負重/雙手重量不平均",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * -0.008,
                left: screenWidth * 0.85,
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
                                    "短時間內單手承重，或雙手重量明顯不同",
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
                                  "ex:\n•雙手搬物品但重心偏一側\n•一手提重物、一手扶牆或開門\n•單手提水桶",
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
        SizedBox(height: screenHeight * 0.03),
        SizedBox(
          height: screenHeight * 0.08,
          child: Stack(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _text = weightHandlingList1[2];
                    pick1 = false;
                    pick2 = false;
                    pick3 = true;
                    update(_text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    pick3
                        ? const Color(0XFF6F8FA8)
                        : const Color(0xFFE9E9E9),
                    minimumSize: Size(screenWidth * 0.87, screenHeight * 0.056),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side:
                      pick3
                          ? BorderSide(color: Colors.black87, width: 1)
                          : BorderSide.none,
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "幾乎以單手負重/不穩定的負重重心",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * -0.008,
                left: screenWidth * 0.85,
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
                                    "長時間單手承重，或物品重心難以控制",
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
                                  "ex:\n•長時間單手提重工具箱\n•搬運形狀不規則、重心偏移的物品\n•單手抱持活動的物體(如動物)",
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
              "負荷處理條件",
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
                  currentStep: 4,
                  totalStep: 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                      "總分 : ${_score.toString().replaceAll(".0", "")} / 4 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 4,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    title(context, screenWidth, screenHeight),
                    SizedBox(height: screenHeight * 0.05),
                    body(screenWidth, screenHeight, _text),
                    SizedBox(height: screenHeight * 0.05),
                    select(screenWidth, screenHeight),
                    SizedBox(height: screenHeight * 0.05),
                    PONButton(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      havePrevious: false,
                      haveNextPage: true,
                      previousText: "",
                      nextText: "下一步",
                      nextPage: WorkConditionRating(),
                    ),
                    SizedBox(height: screenHeight * 0.04 - bottomPadding),
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
