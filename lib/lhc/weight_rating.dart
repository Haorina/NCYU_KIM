import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:ncyu_kim/lhc/body_posture_rating/bpr_video_recording.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../../main.dart';

class WeightRating extends StatefulWidget {
  const WeightRating({super.key});

  @override
  State<WeightRating> createState() => _WeightRatingState();
}

Future<void> _saveLHCWeightRatingPoints(
  int lhcLoadWeightPoints,
  String gender,
  String weight,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('LoadWeightPoints', lhcLoadWeightPoints);
  await prefs.setString('Gender', gender);
  await prefs.setString('Weight', weight);
}

Future<void> initCameras(BuildContext context) async {
  final camera = await availableCameras();

  if (context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LHCVideoRecording(camera: camera),
      ),
    );
  }
}

class _WeightRatingState extends State<WeightRating> {
  int lhcLoadWeightPoints = 4;
  String gender = "male";
  String weight = "3～5";
  bool pickMale = true;
  bool pickFemale = false;

  final List<String> weightTexts = [
    "3～5",
    "6～10",
    "11～15",
    "16～20",
    "21～25",
    "26～30",
    "31～35",
    "36～40",
    "> 40",
  ];

  int calculateWeight(String gender, String weight) {
    Map<String, Map<String, int>> weightPoints = {
      "male": {
        "3～5": 4,
        "6～10": 6,
        "11～15": 8,
        "16～20": 11,
        "21～25": 15,
        "26～30": 25,
        "31～35": 35,
        "36～40": 75,
        "> 40": 100,
      },
      "female": {
        "3～5": 6,
        "6～10": 9,
        "11～15": 12,
        "16～20": 25,
        "21～25": 75,
        "26～30": 85,
        "31～35": 100,
        "36～40": 100,
        "> 40": 100,
      },
    };

    return weightPoints[gender]![weight] ?? 4;
  }

  void update() {
    setState(() {
      lhcLoadWeightPoints = calculateWeight(gender, weight);
    });

    _saveLHCWeightRatingPoints(lhcLoadWeightPoints, gender, weight);
  }

  @override
  void initState() {
    update();
    super.initState();
  }

  Widget testingWidget(double screenWidth, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.02),
        Text(
          "生理性別",
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
              "assets/images/$gender.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                gender = "male";
                pickMale = true;
                pickFemale = false;
                update();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    pickMale
                        ? const Color(0XFF6F8FA8)
                        : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.24, screenHeight * 0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                      pickMale
                          ? BorderSide(color: Colors.black87, width: 1)
                          : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                "男",
                style: TextStyle(
                  fontSize: screenWidth * 0.046,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.2),
            ElevatedButton(
              onPressed: () {
                gender = "female";
                pickMale = false;
                pickFemale = true;
                update();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    pickFemale
                        ? const Color(0XFF6F8FA8)
                        : const Color(0xFFE9E9E9),
                minimumSize: Size(screenWidth * 0.24, screenHeight * 0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                      pickFemale
                          ? BorderSide(color: Colors.black87, width: 1)
                          : BorderSide.none,
                ),
                elevation: 5,
              ),
              child: Text(
                "女",
                style: TextStyle(
                  fontSize: screenWidth * 0.046,
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
            SizedBox(width: screenWidth * 0.41),
            Text(
              "實際負重",
              style: TextStyle(
                fontSize: screenWidth * 0.044,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: screenWidth * 0.2),
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
                          height: screenHeight * 0.36,
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
                                    "檢測過程身體實際承擔的物品重量",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.042,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  width: screenWidth * 0.75,
                                  child: Text(
                                    "注意:\n1.以「實際承受的重量」計算，不是物品的標示重量\n2.若兩人一同搬運重物，每人約負荷60%重量(為了控制與協調，應假設超過50%)",
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
                                  "ex:\n•推車載物總重50公斤，但只需推動力約10\n 公斤 → 實際負重10公斤兩人合力搬運\n 100公斤物品 → 每人實際負重約50公斤",
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
          child: Center(
            child: Container(
              alignment: Alignment.center,
              width: screenWidth * 0.32,
              height: screenHeight * 0.066,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 1.0,
                    spreadRadius: 1,
                    color: const Color(0xFF999999),
                  ),
                ],
              ),
              child: Text(
                "$weight 公斤",
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Container(
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
            value: weight,
            isExpanded: true,
            icon: SizedBox(),
            underline: SizedBox(),
            borderRadius: BorderRadius.circular(10),
            items:
            weightTexts.map<DropdownMenuItem<String>>((String value) {
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
                        weight == value
                            ? Colors.grey.shade300
                            : Colors.transparent,
                        border:
                        value == "> 40"
                            ? null
                            : Border(
                          bottom: BorderSide(
                            color: Colors.black54,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        "$value 公斤",
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
              return weightTexts.map((String value) {
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
              weight = value!;
              update();
            },
          ),
        ),
        SizedBox(height: screenHeight * 0.08),
        SizedBox(
          width: screenWidth * 0.36,
          child: ElevatedButton(
            onPressed: () {
              _saveLHCWeightRatingPoints(lhcLoadWeightPoints, gender, weight);
              initCameras(context);
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
              ), // 內邊距
            ),
            child: Row(
              children: [
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
              ],
            ),
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
              "負重評級",
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
                  currentStep: 1,
                  totalStep: 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                      "總分 : ${lhcLoadWeightPoints.toString().replaceAll(".0", "")} / 100 分",
                  currentScore: lhcLoadWeightPoints,
                  textSize: screenWidth * 0.038,
                  maxScore: 100,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                testingWidget(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.042 - bottomPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
