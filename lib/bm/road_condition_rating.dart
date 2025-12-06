import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import '../../main.dart';
import 'work_organization_rating.dart';

final Map<String, int> calculateScore = {"≤ 50": 8, "51~150": 12, "> 150": 16};

class RoadConditionRating extends StatefulWidget {
  const RoadConditionRating({
    super.key,
    required this.haveTransportation,
    required this.weightText,
  });

  final bool haveTransportation;
  final String weightText;

  @override
  State<RoadConditionRating> createState() => _RoadConditionRatingState();
}

Future<void> _saveRoadConditionRatingPoints(int score) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('RoadConditionRatingPoints', score);
}

class _RoadConditionRatingState extends State<RoadConditionRating> {
  bool _haveTransportSupport = false;
  int _score = 0;
  bool isSelected = true;
  bool _often = false;

  @override
  void initState() {
    _loadHaveTransportSupport();
    super.initState();
  }

  Future<void> _loadHaveTransportSupport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _haveTransportSupport = prefs.getBool("HaveTransportSupport") ?? false;
    update();
  }

  void update() {
    setState(() {
      if (isSelected) {
        _score = calculateScore[widget.weightText]!;

        if (_often) {
          _score += 8;
        } else {
          _score += 4;
        }
      } else {
        _score = 0;

        if (_often) {
          _score += 8;
        } else {
          _score += 4;
        }
      }

      if (_haveTransportSupport) {
        _score = (_score / 2).round();
      }
      _saveRoadConditionRatingPoints(_score);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double bottomPadding = MediaQuery.paddingOf(context).bottom;

    Widget body(double screenWidth, double screenHeight, double bottomPadding) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: screenWidth * 0.4),
                      Text(
                        "路況受限",
                        style: TextStyle(
                          fontSize: screenWidth * 0.044,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.18),
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
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            pageBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                ) => Center(
                                  child: Container(
                                    width: screenWidth * 0.85,
                                    height: screenHeight * 0.39,
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
                                            width: screenWidth * 0.7,
                                            child: Text(
                                              "多種不利於行動的情況",
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
                                            "ex:\n•泥土地面：行走或操作時腳容易陷入或\n 地面濕滑難行\n•粗糙碎石路：地面佈滿尖銳或不規則碎\n 石，容易導致工具或人員滑倒或失衡\n•坑洞：道路有明顯凹陷或破洞，需小心\n 閃避或繞行\n•黏重土壤：土壤濕黏，拖拉工具或行走\n 時阻力大\n•短暫上升坡道：短距離內需推拉工具或\n 搬運物品上坡，增加操作負荷",
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
                    ],
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
                child: Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Image.asset(
                    "assets/images/body_movement_type.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      isSelected = true;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            isSelected
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "有",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.18),
                  ElevatedButton(
                    onPressed: () {
                      isSelected = false;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isSelected
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            !isSelected
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "無",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: screenWidth * 0.36),
                      Text(
                        "氣候劇烈變化",
                        style: TextStyle(
                          fontSize: screenWidth * 0.044,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.12),
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
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            pageBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                ) => Center(
                                  child: Container(
                                    width: screenWidth * 0.7,
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
                                                width: screenWidth * 0.54,
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
                                            width: screenWidth * 0.6,
                                            child: Text(
                                              "氣候劇烈變化",
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
                                          width: screenWidth * 0.6,
                                          child: Text(
                                            "ex:\n•熱\n•風\n•雪",
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
                    ],
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
                child: Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Image.asset(
                    "assets/images/body_movement_type.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _often = !_often;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !_often
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            !_often
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "稀少、偶爾",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.14),
                  ElevatedButton(
                    onPressed: () {
                      _often = !_often;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _often
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.24,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            _often
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "經常、頻繁",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              PONButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                havePrevious: false,
                haveNextPage: true,
                previousText: "",
                nextText: "下一步",
                nextPage: WorkOrganizationRating(
                  haveTransportation: widget.haveTransportation,
                ),
                onTap: () => _saveRoadConditionRatingPoints(_score),
              ),
              SizedBox(height: screenHeight * 0.03 - bottomPadding),
            ],
          ),
        ),
      );
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
              "路況評級",
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
                ProgressBar(
                  currentStep: 7,
                  totalStep: 9,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                      "總分 : ${_score.toString().replaceAll(".0", "")} / 24 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 24,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),
                body(screenWidth, screenHeight, bottomPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
