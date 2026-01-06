import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../user_define_widget/score_bar.dart';
import 'back_load_rating.dart';

List<String> timeList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

class ABPTimeRating extends StatefulWidget {
  final String? userName;

  const ABPTimeRating({super.key, this.userName});

  @override
  State<ABPTimeRating> createState() => _ABPTimeRatingState();
}

Widget title(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width: screenWidth * 0.34),
      Text(
        "從事此作業時間",
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
                          "每天從事本項作業共...分鐘",
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
                        "ex:\n•每天早上搬運2小時，下午3小時:300(分\n 鐘)",
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

Widget body(double screenWidth, double screenHeight, String times) {
  return Container(
    alignment: Alignment.center,
    width: screenWidth * 0.36,
    height: screenHeight * 0.08,
    decoration: BoxDecoration(
      color: const Color(0XFFD9D9D9),
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, -1),
          blurRadius: 1.0,
          spreadRadius: 1,
          color: const Color(0x60000000),
        ),
      ],
    ),
    child: Text(
      "$times 小時",
      style: TextStyle(
        fontSize: screenWidth * 0.046,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
  );
}

class _ABPTimeRatingState extends State<ABPTimeRating> {
  String _times = timeList[0];
  double _score = double.parse(timeList[0]);
  int _totalStep = 4;
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

    _loadTimeRatingPoints();
  }

  Future<void> _loadTimeRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _times = prefs.getString('TimeLabel') ?? timeList[0];
      _score = prefs.getDouble('TimeRatingPoints') ?? double.parse(timeList[0]);
      _totalStep = prefs.getInt('TotalStep') ?? 4;
    } else {
      _times = prefs.getString('${widget.userName}_ABP_TimeLabel') ?? "";
      _score =
          prefs.getDouble('${widget.userName}_ABP_TimeRatingPoints') ?? 0.0;
      _totalStep = prefs.getInt('${widget.userName}_ABP_TotalStep') ?? 0;
    }

    update(_times);
  }

  Future<void> _saveTimeRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setString('TimeLabel', _times);
      await prefs.setDouble('TimeRatingPoints', _score);
      await prefs.setInt('TotalStep', _totalStep);
    } else {
      await prefs.setString('${currentUser}_ABP_TimeLabel', _times);
      await prefs.setDouble('${currentUser}_ABP_TimeRatingPoints', _score);
      await prefs.setInt('${currentUser}_ABP_TotalStep', _totalStep);
    }
  }

  void update(String value) {
    double score = double.parse(value);
    setState(() {
      _times = value;
      _score = score;
    });

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveTimeRatingPoints();
    }
  }

  Widget select(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.32,
      height: screenHeight * 0.04,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0XFFE9E9E9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0x60000000),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: _times,
        isExpanded: true,
        icon: SizedBox(),
        underline: SizedBox(),
        borderRadius: BorderRadius.circular(10),
        items:
        timeList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color:
                    _times == value
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    border:
                    value == "10"
                        ? null
                        : Border(
                      bottom: BorderSide(
                        color: Colors.black54,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    "$value 小時",
                    style: TextStyle(
                      fontSize: screenWidth * 0.036,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return timeList.map((String value) {
            return Row(
              children: [
                SizedBox(width: screenWidth * 0.108),
                Text(
                  "選擇",
                  style: TextStyle(
                    fontSize: screenWidth * 0.046,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Icon(Icons.expand_more),
              ],
            );
          }).toList();
        },
        onChanged: (value) {
          update(value!);
        },
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
              "時間評級",
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
                  currentStep: 1,
                  totalStep: _totalStep,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
                ScoreBar(
                  labelText:
                  "總分 : ${_score.toString().replaceAll(".0", "")} / 10 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 10,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    title(context, screenWidth, screenHeight),
                    SizedBox(height: screenHeight * 0.02),
                    body(screenWidth, screenHeight, _times),
                    SizedBox(height: screenHeight * 0.06),
                    select(screenWidth, screenHeight),
                    SizedBox(height: screenHeight * 0.42 - bottomPadding),
                    SizedBox(
                      width: screenWidth * 0.36,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveTimeRatingPoints();

                          if (!isGuest && context.mounted) {
                            Navigator.pop(context);
                          } else {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BackLoadRating(
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
