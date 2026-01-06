import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import 'result.dart';

List<String> workOrganizationList1 = ["良好", "受限", "不良"];
List<String> workOrganizationList2 = ["0", "2", "4"];

Widget title(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "工作協調 / 時間分佈",
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
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1.0,
          spreadRadius: 1,
          color: Color(0x60000000),
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            workOrganizationList1.indexOf(text) == 0
                ? "assets/images/time_organ-good.png"
                : workOrganizationList1.indexOf(text) == 1
                ? "assets/images/time_organ-restricted.png"
                : "assets/images/time_organ-bad.png",
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );
}

class WorkOrganizationRating extends StatefulWidget {
  final String? userName;
  const WorkOrganizationRating({super.key, this.userName});

  @override
  State<WorkOrganizationRating> createState() => _WorkOrganizationRatingState();
}

class _WorkOrganizationRatingState extends State<WorkOrganizationRating> {
  String _text = workOrganizationList1[0];
  int _score = int.parse(workOrganizationList2[0]);
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

    _loadWorkOrganizationRatingPoints();
  }

  Future<void> _loadWorkOrganizationRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _text =
          prefs.getString('WorkOrganizationLabel') ?? workOrganizationList1[0];
      _score =
          prefs.getInt('WorkOrganizationRatingPoints') ??
              int.parse(workOrganizationList2[0]);
    } else {
      _text =
          prefs.getString('${widget.userName}_LHC_WorkOrganizationLabel') ?? "";
      _score =
          prefs.getInt('${widget.userName}_LHC_WorkOrganizationRatingPoints') ??
              0;
    }

    update(_text);
  }

  Future<void> _saveWorkOrganizationRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setString('WorkOrganizationLabel', _text);
      await prefs.setInt('WorkOrganizationRatingPoints', _score);
    } else {
      await prefs.setString(
        '${widget.userName}_LHC_WorkOrganizationLabel',
        _text,
      );
      await prefs.setInt(
        '${widget.userName}_LHC_WorkOrganizationRatingPoints',
        _score,
      );
    }
  }

  void update(String value) {
    int score = int.parse(
      workOrganizationList2[workOrganizationList1.indexOf(value)],
    );
    setState(() {
      _text = value;
      _score = score;
    });

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveWorkOrganizationRatingPoints();
    }
  }

  //選項按鈕
  Widget select(double screenWidth, double screenHeight) {
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
                      update(workOrganizationList1[0]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workOrganizationList1.indexOf(_text) == 0
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workOrganizationList1.indexOf(_text) == 0
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workOrganizationList1[0],
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
                                    width: screenWidth * 0.7,
                                    child: Text(
                                      "工作類型很多樣，不會一整天都做同一種很累的工作而一直同部位出力而受",
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
                                  width: screenWidth * 0.7,
                                  child: Text(
                                    "ex:\n•早上搬東西，中午整理資料，下午清潔",
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
                      update(workOrganizationList1[1]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workOrganizationList1.indexOf(_text) == 1
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workOrganizationList1.indexOf(_text) == 1
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workOrganizationList1[1],
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
                                      "工作內容變化不大，但偶爾會有一整天集中做一樣、高強度的工作",
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
                                  width: screenWidth * 0.7,
                                  child: Text(
                                    "ex:\n•大多數時間都在搬較小的貨和點貨，但每\n 禮拜固定一兩天一整天都在搬比較重的東\n 西",
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
                      update(workOrganizationList1[2]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      workOrganizationList1.indexOf(_text) == 2
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.26,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        workOrganizationList1.indexOf(_text) == 2
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      workOrganizationList1[2],
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
                                      "幾乎整天都做同種又重又累的工作，身體沒有休息或變換的機會，造成身體某些部位過度疲勞或受傷",
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
                                  width: screenWidth * 0.7,
                                  child: Text(
                                    "ex:\n•一整天都彎腰搬重物，沒有其他輕鬆的工\n 作可以穿插",
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
              "工作時間分配",
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
                  await clearGuestKeysForLHC();

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
                  currentStep: 6,
                  totalStep: 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
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
                    SizedBox(height: screenHeight * 0.2),
                    SizedBox(
                      width: screenWidth * 0.36,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveWorkOrganizationRatingPoints();

                          if (!isGuest && context.mounted) {
                            Navigator.pop(context);
                          } else {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                      Result(userName: widget.userName),
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
