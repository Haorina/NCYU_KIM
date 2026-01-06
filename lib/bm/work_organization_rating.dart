import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../../main.dart';
import 'result.dart';

class WorkOrganizationRating extends StatefulWidget {
  final bool haveTransportation;
  final String? userName;

  const WorkOrganizationRating({
    super.key,
    required this.haveTransportation,
    this.userName,
  });

  @override
  State<WorkOrganizationRating> createState() => _WorkOrganizationRatingState();
}

class _WorkOrganizationRatingState extends State<WorkOrganizationRating> {
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

    _loadWorkOrganizationRatingPoints();
  }

  Future<void> _loadWorkOrganizationRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      onlyTransportation = prefs.getBool('OnlyTransportation') ?? false;
      _score = prefs.getInt('WorkOrganizationRatingPoints') ?? 0;
      totalStep = prefs.getInt('TotalStep') ?? 7;
    } else {
      onlyTransportation =
          prefs.getBool('${widget.userName}_BM_OnlyTransportation') ?? false;
      _score =
          prefs.getInt('${widget.userName}_BM_WorkOrganizationRatingPoints') ??
              0;
      totalStep = prefs.getInt('${widget.userName}_BM_TotalStep') ?? 7;
    }

    setState(() {});
    update();
  }

  Future<void> _saveWorkOrganizationRatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      await prefs.setBool('OnlyTransportation', onlyTransportation);
      await prefs.setInt('WorkOrganizationRatingPoints', _score);
      await prefs.setInt('TotalStep', totalStep);
    } else {
      await prefs.setBool(
        '${currentUser}_BM_OnlyTransportation',
        onlyTransportation,
      );
      await prefs.setInt(
        '${currentUser}_BM_WorkOrganizationRatingPoints',
        _score,
      );
      await prefs.setInt('${currentUser}_BM_TotalStep', totalStep);
    }
  }

  void update() {
    setState(() {});

    if (widget.userName == null || widget.userName == "vJ#CA:F3zP)C]A=V") {
      _saveWorkOrganizationRatingPoints();
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
                  SizedBox(width: screenWidth * 0.3),
                  Text(
                    "工作協調/時間分佈",
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
                                SizedBox(height: screenHeight * 0.038),
                                Container(
                                  height: screenHeight * 0.001,
                                  margin: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
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
                      offset: const Offset(0, 1),
                      blurRadius: 1.0,
                      spreadRadius: 1,
                      color: const Color(0xFF999999),
                    ),
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                  child: Image.asset(
                    _score == 0
                        ? "assets/images/BMe1.png"
                        : _score == 2
                        ? "assets/images/BMe2.png"
                        : "assets/images/BMe3.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  _score = 0;
                  update();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _score == 0
                      ? const Color(0XFF6F8FA8)
                      : const Color(0xFFE9E9E9),
                  minimumSize: Size(screenWidth * 0.6, screenHeight * 0.056),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side:
                    _score == 0
                        ? const BorderSide(color: Colors.black87, width: 1)
                        : BorderSide.none,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "良好",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  _score = 2;
                  update();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _score == 2
                      ? const Color(0XFF6F8FA8)
                      : const Color(0xFFE9E9E9),
                  minimumSize: Size(screenWidth * 0.6, screenHeight * 0.056),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side:
                    _score == 2
                        ? const BorderSide(color: Colors.black87, width: 1)
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
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  _score = 4;
                  update();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _score == 4
                      ? const Color(0XFF6F8FA8)
                      : const Color(0xFFE9E9E9),
                  minimumSize: Size(screenWidth * 0.6, screenHeight * 0.056),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side:
                    _score == 4
                        ? const BorderSide(color: Colors.black87, width: 1)
                        : BorderSide.none,
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "不良",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.12),
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
                                (context) => Result(
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
              "工作協調評級",
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
                  currentStep:
                  onlyTransportation
                      ? 4
                      : widget.haveTransportation
                      ? 8
                      : 6,
                  totalStep: totalStep,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
                    : SizedBox(height: screenHeight * 0.01),
                ScoreBar(
                  labelText:
                  "總分 : ${_score.toString().replaceAll('.0', '')} / 4 分",
                  currentScore: _score,
                  textSize: screenWidth * 0.038,
                  maxScore: 4,
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
