import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../../main.dart';
import 'body_movement_b_rating.dart';
import 'work_organization_rating.dart';

class WorkConditionRating extends StatefulWidget {
  final bool haveTransportation;
  final String? userName;

  const WorkConditionRating({
    super.key,
    required this.haveTransportation,
    this.userName,
  });

  @override
  State<WorkConditionRating> createState() => _WorkConditionRatingState();
}

class _WorkConditionRatingState extends State<WorkConditionRating> {
  int _spaceScore = 3;
  int _climateScore = 4;
  int _totalScore = 0;
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

    _loadWorkConditionRatingPoints();
  }

  Future<void> _loadWorkConditionRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _spaceScore = prefs.getInt('SpaceScore') ?? 3;
      _climateScore = prefs.getInt('ClimateScore') ?? 4;
      totalStep = prefs.getInt('TotalStep') ?? 7;
    } else {
      _spaceScore = prefs.getInt('${widget.userName}_BM_SpaceScore') ?? 3;
      _climateScore = prefs.getInt('${widget.userName}_BM_ClimateScore') ?? 4;
      totalStep = prefs.getInt('${widget.userName}_BM_TotalStep') ?? 7;
    }

    setState(() {});
    update();
  }

  Future<void> _saveWorkConditionRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setInt('SpaceScore', _spaceScore);
      await prefs.setInt('ClimateScore', _climateScore);
      await prefs.setInt('WorkConditionRatingPoints', _totalScore);
      await prefs.setInt('TotalStep', totalStep);
    } else {
      await prefs.setInt('${currentUser}_BM_SpaceScore', _spaceScore);
      await prefs.setInt('${currentUser}_BM_ClimateScore', _climateScore);
      await prefs.setInt(
        '${currentUser}_BM_WorkConditionRatingPoints',
        _totalScore,
      );
      await prefs.setInt('${currentUser}_BM_TotalStep', totalStep);
    }
  }

  void update() {
    setState(() {
      _totalScore = _spaceScore + _climateScore;
    });

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveWorkConditionRatingPoints();
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
                  SizedBox(width: screenWidth * 0.4),
                  Text(
                    "活動空間",
                    style: TextStyle(
                      fontSize: screenWidth * 0.044,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.14),
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
                            width: screenWidth * 0.75,
                            height: screenHeight * 0.16,
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
                                    width: screenWidth * 0.65,
                                    child: Text(
                                      "空間或活動的受限(未提及的條件也應根據情況納入考量，罕見的情形可以忽略)",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.042,
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
                    _spaceScore == 3
                        ? "assets/images/BMd1.png"
                        : _spaceScore == 5
                        ? "assets/images/BMd2.png"
                        : "assets/images/BMd3.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
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
                              _spaceScore = 3;
                              update();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              _spaceScore == 3
                                  ? const Color(0XFF6F8FA8)
                                  : const Color(0xFFE9E9E9),
                              minimumSize: Size(
                                screenWidth * 0.26,
                                screenHeight * 0.046,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side:
                                _spaceScore == 3
                                    ? BorderSide(
                                  color: Colors.black87,
                                  width: 1,
                                )
                                    : BorderSide.none,
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              "受限",
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
                                    height: screenHeight * 0.34,
                                    decoration: BoxDecoration(
                                      color: const Color(0XCC101010),
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
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
                                                    size:
                                                    screenWidth * 0.06,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop();
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
                                              "活動空間狹窄，例如需進入小空間內工作，或站立處不穩（會傾斜或移動），但尚可進出或活動",
                                              style: TextStyle(
                                                fontSize:
                                                screenWidth * 0.042,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                decoration:
                                                TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.75,
                                          child: Text(
                                            "ex:\n•狹窄空間（e.g. 防墜安全籠、貨車\n 後車廂）\n•站立處不穩定（如傾斜平台、會移動的\n 地面）\n•沙地、石頭路（行走困難但非完全無法\n 行動）",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.038,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              decoration:
                                              TextDecoration.none,
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
                  SizedBox(width: screenWidth * 0.016),
                  SizedBox(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.08,
                    child: Stack(
                      children: [
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _spaceScore = 5;
                              update();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              _spaceScore == 5
                                  ? const Color(0XFF6F8FA8)
                                  : const Color(0xFFE9E9E9),
                              minimumSize: Size(
                                screenWidth * 0.26,
                                screenHeight * 0.046,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side:
                                _spaceScore == 5
                                    ? BorderSide(
                                  color: Colors.black87,
                                  width: 1,
                                )
                                    : BorderSide.none,
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              "嚴重受限",
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
                                    height: screenHeight * 0.26,
                                    decoration: BoxDecoration(
                                      color: const Color(0XCC101010),
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.038,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: screenWidth * 0.68,
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
                                                    size:
                                                    screenWidth * 0.06,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop();
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
                                              "活動空間嚴重受阻，幾乎無法使用輔助工具或正常行動，需特殊方式（爬、匍匐）移動",
                                              style: TextStyle(
                                                fontSize:
                                                screenWidth * 0.042,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                decoration:
                                                TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.75,
                                          child: Text(
                                            "ex:\n•進出困難的狹窄空間\n•爬行移動（像管道、洞穴）\n•在野外荒地、灌木叢中行動受阻）",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.038,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              decoration:
                                              TextDecoration.none,
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
                  SizedBox(width: screenWidth * 0.016),
                  SizedBox(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.08,
                    child: Stack(
                      children: [
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _spaceScore = 15;
                              update();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              _spaceScore == 15
                                  ? const Color(0XFF6F8FA8)
                                  : const Color(0xFFE9E9E9),
                              minimumSize: Size(
                                screenWidth * 0.26,
                                screenHeight * 0.046,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side:
                                _spaceScore == 15
                                    ? BorderSide(
                                  color: Colors.black87,
                                  width: 1,
                                )
                                    : BorderSide.none,
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              "危急",
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
                                    height: screenHeight * 0.37,
                                    decoration: BoxDecoration(
                                      color: const Color(0XCC101010),
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.038,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: screenWidth * 0.68,
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
                                                    size:
                                                    screenWidth * 0.06,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop();
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
                                              "活動空間極端受限且同時伴隨高度危險，如身處危險地點、視野障礙、缺乏呼吸設備等",
                                              style: TextStyle(
                                                fontSize:
                                                screenWidth * 0.042,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                decoration:
                                                TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.75,
                                          child: Text(
                                            "ex:\n•受困於密閉空間或危險地點（如地底、\n 煙霧中）\n•視線嚴重受阻（如完全黑暗）\n•無休息平臺、無支撐點登山\n•呼吸裝備缺乏但需在有害氣體環境中作\n 業\n•泥巴路面容易滑倒",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.038,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              decoration:
                                              TextDecoration.none,
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
              ),
              SizedBox(height: screenHeight * 0.04),
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
                  SizedBox(width: screenWidth * 0.14),
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
                            width: screenWidth * 0.75,
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
                                        width: screenWidth * 0.59,
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
                                    width: screenWidth * 0.65,
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
                                  width: screenWidth * 0.65,
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
                            child: ScaleTransition(scale: curved, child: child),
                          );
                        },
                      );
                    },
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
                    _climateScore == 4
                        ? "assets/images/BMd45.png"
                        : "assets/images/BMd45.png",
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
                      _climateScore = 4;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _climateScore == 4
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.3,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        _climateScore == 4
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
                  SizedBox(width: screenWidth * 0.1),
                  ElevatedButton(
                    onPressed: () {
                      _climateScore = 8;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _climateScore == 8
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.3,
                        screenHeight * 0.046,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        _climateScore == 8
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
              SizedBox(height: screenHeight * 0.06),
              SizedBox(
                width: screenWidth * 0.36,
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveWorkConditionRatingPoints();

                    if (!isGuest && context.mounted) {
                      Navigator.pop(context);
                    } else {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                            !widget.haveTransportation
                                ? WorkOrganizationRating(
                              haveTransportation:
                              widget.haveTransportation,
                              userName: currentUser,
                            )
                                : BodyMovementB(
                              haveTransportation:
                              widget.haveTransportation,
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
                icon: const Icon(Icons.home_outlined),
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
                  currentStep: 5,
                  totalStep: totalStep,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
                ScoreBar(
                  labelText:
                  "總分 : ${_totalScore.toString().replaceAll('.0', '')} / 23 分",
                  currentScore: _totalScore,
                  textSize: screenWidth * 0.038,
                  maxScore: 23,
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
