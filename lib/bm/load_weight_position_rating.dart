import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../../main.dart';
import 'body_posture_rating.dart';

final Map<String, String> findLoadWeight = {
  "無 / < 3": "< 3",
  "3~10": "3~15",
  "11～15": "3~15",
  "16～20": "16~30",
  "21～25": "16~30",
  "26～30": "16~30",
  "31～35": "> 30",
  "36～40": "> 30",
  "> 40": "> 30",
};

final Map<String, Map<String, int>> calculateScore = {
  "pickSupport": {"< 3": 0, "3~15": 0, "16~30": 0, "> 30": 0},
  "pickClose": {"< 3": 0, "3~15": 4, "16~30": 8, "> 30": 12},
  "pickAway": {"< 3": 0, "3~15": 8, "16~30": 12, "> 30": 16},
};

class LoadWeightPosition extends StatefulWidget {
  final bool haveTransportation;
  final String loadWeightText;
  final String? userName;

  const LoadWeightPosition({
    super.key,
    required this.haveTransportation,
    required this.loadWeightText,
    this.userName,
  });

  @override
  State<LoadWeightPosition> createState() => _LoadWeightPositionState();
}

class _LoadWeightPositionState extends State<LoadWeightPosition> {
  String _loadWeightText = "< 3";
  String pickText = "pickSupport";
  bool pickSupport = true;
  bool pickClose = false;
  bool pickAway = false;
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

    _loadLoadWeightPositionRatingPoints();
  }

  Future<void> _loadLoadWeightPositionRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loadWeightText = findLoadWeight[widget.loadWeightText]!;

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      pickText = prefs.getString('PickLoadWeightPositionText') ?? "pickSupport";
      pickSupport = prefs.getBool('PickSupport') ?? true;
      pickClose = prefs.getBool('PickClose') ?? false;
      pickAway = prefs.getBool('PickAway') ?? false;
      totalStep = prefs.getInt('TotalStep') ?? 7;
    } else {
      pickText =
          prefs.getString('${widget.userName}_BM_PickLoadWeightPositionText') ??
              "pickSupport";
      pickSupport = prefs.getBool('${widget.userName}_BM_PickSupport') ?? true;
      pickClose = prefs.getBool('${widget.userName}_BM_PickClose') ?? false;
      pickAway = prefs.getBool('${widget.userName}_BM_PickAway') ?? false;
      totalStep = prefs.getInt('${widget.userName}_BM_TotalStep') ?? 7;
    }

    setState(() {});
    update();
  }

  Future<void> _saveLoadWeightPositionRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setString('PickLoadWeightPositionText', pickText);
      await prefs.setBool('PickSupport', pickSupport);
      await prefs.setBool('PickClose', pickClose);
      await prefs.setBool('PickAway', pickAway);
      await prefs.setInt('LoadWeightPositionRatingPoints', _score);
      await prefs.setInt('TotalStep', totalStep);
    } else {
      await prefs.setString(
        '${currentUser}_BM_PickLoadWeightPositionText',
        pickText,
      );
      await prefs.setBool('${currentUser}_BM_PickSupport', pickSupport);
      await prefs.setBool('${currentUser}_BM_PickClose', pickClose);
      await prefs.setBool('${currentUser}_BM_PickAway', pickAway);
      await prefs.setInt(
        '${currentUser}_BM_LoadWeightPositionRatingPoints',
        _score,
      );
      await prefs.setInt('${currentUser}_BM_TotalStep', totalStep);
    }
  }

  void update() {
    setState(() {
      _score = calculateScore[pickText]![_loadWeightText]!;
    });

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveLoadWeightPositionRatingPoints();
    }
  }

  Widget body(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "重物的重心位置",
            style: TextStyle(
              fontSize: screenWidth * 0.044,
              fontWeight: FontWeight.bold,
            ),
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
                pickSupport
                    ? "assets/images/BMb1.png"
                    : pickClose
                    ? "assets/images/BMb3.png"
                    : "assets/images/BMb2.png",
                fit: BoxFit.contain,
              ),
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
                      pickText = "pickSupport";
                      pickSupport = true;
                      pickClose = false;
                      pickAway = false;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      pickSupport
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.68,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        pickSupport
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "重物靠近身體並有揹架/雙肩背包",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
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
                                      "當搬運超過3公斤的物品時，若重物靠近身體，並搭配揹架、雙肩背包或其他輔助設備，可以將部分重量分散至身體軀幹，減少手臂的負擔。但是揹架的使用仍然會影響身體的姿勢和用力方式",
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
                                    "ex:\n•使用雙肩背包運送重物或輕型設備，重量平\n 均分布於背部\n•在作業現場使用腰掛式或背負式工具袋進行\n 移動作業\n•電信維修員穿戴多口袋工具背心，攜帶電纜\n 剪、測試儀等器具進行檢修",
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
                      pickText = "pickClose";
                      pickSupport = false;
                      pickClose = true;
                      pickAway = false;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      pickClose
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.68,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        pickClose
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "重物靠近身體且用手搬/單肩負重",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
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
                                    width: screenWidth * 0.75,
                                    child: Text(
                                      "當搬運超過3公斤的物品時，身體重心偏離正常的支撐基礎，或需要將身體或手伸展到遠離腳部支撐點的位置進行作業",
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
                                    "ex:\n•越過工作檯面或障礙物將物品搬到另一側\n•身體前傾將重物從底層貨架搬出\n•在狹窄空間中側身或扭轉身體搬運重物\n•搬運體積過大或寬大的物品，導致無法貼近\n 身體，只能雙手外伸抱持或提起",
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
                      pickText = "pickAway";
                      pickSupport = false;
                      pickClose = false;
                      pickAway = true;
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      pickAway
                          ? const Color(0XFF6F8FA8)
                          : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.68,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                        pickAway
                            ? BorderSide(color: Colors.black87, width: 1)
                            : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "重物遠離身體且用手搬",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * -0.008,
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
                            (context, animation, secondaryAnimation) => Center(
                          child: Container(
                            width: screenWidth * 0.85,
                            height: screenHeight * 0.35,
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
                                      "當搬運超過3公斤的物品時，即使重物靠近身體，仍需使用雙手或單肩進行搬運，這會導致身體局部受力增加，並可能造成身體不平衡",
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
                                    "ex:\n•雙手提重物放在腰部或胸前位置長距離搬運\n•將重物從地面提起後緊貼身體移動\n•搬運較小的沙包或水泥袋，貼近身體，但使\n 用單肩扛\n•單肩扛水管、貨物、工具包",
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
          SizedBox(height: screenHeight * 0.15),
          SizedBox(
            width: screenWidth * 0.36,
            child: ElevatedButton(
              onPressed: () async {
                await _saveLoadWeightPositionRatingPoints();

                if (!isGuest && mounted) {
                  Navigator.pop(context);
                } else {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BodyPostureRating(
                          haveTransportation: widget.haveTransportation,
                          loadWeightText: _loadWeightText,
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
              "重物重心評級",
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
                  currentStep: 3,
                  totalStep: totalStep,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
                ScoreBar(
                  labelText:
                  "總分 : ${_score.toString().replaceAll(".0", "")} / 16 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 16,
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
