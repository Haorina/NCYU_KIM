import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../../main.dart';
import 'work_organization_rating.dart';

final Map<String, int> calculateScore = {"≤ 50": 8, "51~150": 12, "> 150": 16};

class RoadConditionRating extends StatefulWidget {
  final String? userName;
  const RoadConditionRating({
    super.key,
    required this.haveTransportation,
    required this.weightText,
    this.userName,
  });

  final bool haveTransportation;
  final String weightText;

  @override
  State<RoadConditionRating> createState() => _RoadConditionRatingState();
}

class _RoadConditionRatingState extends State<RoadConditionRating> {
  bool isSelected = true;
  bool _often = false;
  bool haveTransportationSupport = false;
  bool onlyTransportation = false;
  int _score = 0;
  int totalStep = 7;
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

    _loadRoadConditionRatingPoints();
  }

  Future<void> _loadRoadConditionRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      isSelected = prefs.getBool('RoadConditionSelect') ?? true;
      _often = prefs.getBool('RoadConditionOften') ?? false;
      haveTransportationSupport =
          prefs.getBool('HaveTransportationSupport') ?? false;
      onlyTransportation = prefs.getBool('OnlyTransportation') ?? false;
      totalStep = prefs.getInt('TotalStep') ?? 7;
    } else {
      isSelected =
          prefs.getBool('${widget.userName}_BM_RoadConditionSelect') ?? true;
      _often =
          prefs.getBool('${widget.userName}_BM_RoadConditionOften') ?? false;
      haveTransportationSupport =
          prefs.getBool('${widget.userName}_BM_HaveTransportationSupport') ??
              false;
      onlyTransportation =
          prefs.getBool('${widget.userName}_BM_OnlyTransportation') ?? false;
      totalStep = prefs.getInt('${widget.userName}_BM_TotalStep') ?? 7;
    }

    setState(() {});
    update();
  }

  Future<void> _saveRoadConditionRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setBool('RoadConditionSelect', isSelected);
      await prefs.setBool('RoadConditionOften', _often);
      await prefs.setInt('RoadConditionRatingPoints', _score);
      await prefs.setInt('TotalStep', totalStep);
    } else {
      await prefs.setBool('${currentUser}_BM_RoadConditionSelect', isSelected);
      await prefs.setBool('${currentUser}_BM_RoadConditionOften', _often);
      await prefs.setInt('${currentUser}_BM_RoadConditionRatingPoints', _score);
      await prefs.setInt('${currentUser}_BM_TotalStep', totalStep);
    }
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

      if (haveTransportationSupport) {
        _score = (_score / 2).round();
      }
    });
    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveRoadConditionRatingPoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    Widget body(double screenWidth, double screenHeight) {
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
                                        width: screenWidth * 0.75,
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
                                      width: screenWidth * 0.75,
                                      child: Text(
                                        "ex:\n•泥土地面：行走或操作時腳容易陷入或地面濕\n 滑難行\n•粗糙碎石路：地面佈滿尖銳或不規則碎石，容\n 易導致工具或人員滑倒或失衡\n•坑洞：道路有明顯凹陷或破洞，需小心閃避或\n 繞行\n•黏重土壤：土壤濕黏，拖拉工具或行走時阻力\n 大\n•短暫上升坡道：短距離內需推拉工具或搬運物\n 品上坡，增加操作負荷",
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
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                  child: Image.asset(
                    isSelected
                        ? "assets/images/BMf12.png"
                        : "assets/images/BMf12.png",
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
                    "assets/images/BM34.png",
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
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                width: screenWidth * 0.36,
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveRoadConditionRatingPoints();

                    if (!isGuest && context.mounted) {
                      Navigator.pop(context);
                    } else {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WorkOrganizationRating(
                              haveTransportation: widget.haveTransportation,
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
                onPressed: () async {
                  await clearGuestKeysForBM();

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
                isGuest
                    ? ProgressBar(
                  currentStep: onlyTransportation ? 3 : 7,
                  totalStep: totalStep,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
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
                body(screenWidth, screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
