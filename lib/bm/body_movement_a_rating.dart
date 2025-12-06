import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/progress_bar.dart';
import '../user_define_widget/score_bar.dart';
import '../user_define_widget/previous_or_next_button.dart';
import '../../main.dart';
import 'load_weight_position_rating.dart';

List<String> tableList = [
  "無 / < 3",
  "3~10",
  "11～15",
  "16～20",
  "21～25",
  "26～30",
  "31～35",
  "36～40",
  "> 40",
];

final Map<String, Map<String, Map<String, int>>> tableList1 = {
  "walk": {
    "low": {
      "無 / < 3": 4,
      "3~10": 6,
      "11～15": 8,
      "16～20": 10,
      "21～25": 12,
      "26～30": 14,
      "31～35": 25,
      "36～40": 35,
      "> 40": 100,
    },
    "medium": {
      "無 / < 3": 8,
      "3~10": 10,
      "11～15": 12,
      "16～20": 14,
      "21～25": 16,
      "26～30": 18,
      "31～35": 30,
      "36～40": 40,
      "> 40": 100,
    },
    "high": {
      "無 / < 3": 12,
      "3~10": 14,
      "11～15": 16,
      "16～20": 18,
      "21～25": 20,
      "26～30": 22,
      "31～35": 35,
      "36～40": 50,
      "> 40": 100,
    },
  },
  "slope": {
    "low": {
      "無 / < 3": 10,
      "3~10": 12,
      "11～15": 14,
      "16～20": 16,
      "21～25": 18,
      "26～30": 20,
      "31～35": 35,
      "36～40": 50,
      "> 40": 100,
    },
    "medium": {
      "無 / < 3": 12,
      "3~10": 14,
      "11～15": 16,
      "16～20": 18,
      "21～25": 20,
      "26～30": 22,
      "31～35": 35,
      "36～40": 50,
      "> 40": 100,
    },
    "high": {
      "無 / < 3": 24,
      "3~10": 26,
      "11～15": 28,
      "16～20": 30,
      "21～25": 32,
      "26～30": 34,
      "31～35": 40,
      "36～40": 50,
      "> 40": 100,
    },
  },
  "stair": {
    "low": {
      "無 / < 3": 18,
      "3~10": 20,
      "11～15": 22,
      "16～20": 24,
      "21～25": 26,
      "26～30": 50,
      "31～35": 100,
      "36～40": 100,
      "> 40": 100,
    },
    "medium": {
      "無 / < 3": 24,
      "3~10": 26,
      "11～15": 28,
      "16～20": 30,
      "21～25": 50,
      "26～30": 100,
      "31～35": 100,
      "36～40": 100,
      "> 40": 100,
    },
    "high": {
      "無 / < 3": 30,
      "3~10": 32,
      "11～15": 34,
      "16～20": 50,
      "21～25": 100,
      "26～30": 100,
      "31～35": 100,
      "36～40": 100,
      "> 40": 100,
    },
  },
};

final Map<String, Map<String, int>> tableList2 = {
  "climbStair": {
    "無 / < 3": 24,
    "3~10": 26,
    "11～15": 50,
    "16～20": 100,
    "21～25": 100,
    "26～30": 100,
    "31～35": 100,
    "36～40": 100,
    "> 40": 100,
  },
  "climbSteepStair": {
    "無 / < 3": 30,
    "3~10": 32,
    "11～15": 50,
    "16～20": 100,
    "21～25": 100,
    "26～30": 100,
    "31～35": 100,
    "36～40": 100,
    "> 40": 100,
  },
  "crawl": {
    "無 / < 3": 24,
    "3~10": 26,
    "11～15": 50,
    "16～20": 100,
    "21～25": 100,
    "26～30": 100,
    "31～35": 100,
    "36～40": 100,
    "> 40": 100,
  },
};

class BodyMovementA extends StatefulWidget {
  const BodyMovementA({super.key, required this.haveTransportation});

  final bool haveTransportation;

  @override
  State<BodyMovementA> createState() => _BodyMovementAState();
}

Widget title(BuildContext context, double screenWidth, double screenHeight) {
  return Row(
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
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
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

class _BodyMovementAState extends State<BodyMovementA> {
  late int totalStep;
  int bodyMovementARatingPoints = 4;
  bool pickWalk = true;
  bool pickSlope = false;
  bool pickStair = false;
  bool pickLow = true;
  bool pickMedium = false;
  bool pickHigh = false;
  bool pickClimbStair = false;
  bool pickClimbSteepStair = false;
  bool pickCrawl = false;
  final ScrollController _controller = ScrollController();
  String _weight = tableList[0];
  int _score = 0;

  @override
  void initState() {
    super.initState();
    totalStep = widget.haveTransportation ? 8 : 6;
  }

  Future<void> _saveBodyMovementARatingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('BodyMovementARatingPoints', bodyMovementARatingPoints);
  }

  int calculateScore(String weight) {
    int score = 0;

    if (pickWalk) {
      if (pickLow) {
        score = tableList1["walk"]!["low"]![weight]!;
      } else if (pickMedium) {
        score = tableList1["walk"]!["medium"]![weight]!;
      } else if (pickHigh) {
        score = tableList1["walk"]!["high"]![weight]!;
      }
    } else if (pickSlope) {
      if (pickLow) {
        score = tableList1["slope"]!["low"]![weight]!;
      } else if (pickMedium) {
        score = tableList1["slope"]!["medium"]![weight]!;
      } else if (pickHigh) {
        score = tableList1["slope"]!["high"]![weight]!;
      }
    } else if (pickStair) {
      if (pickLow) {
        score = tableList1["stair"]!["low"]![weight]!;
      } else if (pickMedium) {
        score = tableList1["stair"]!["medium"]![weight]!;
      } else if (pickHigh) {
        score = tableList1["stair"]!["high"]![weight]!;
      }
    } else if (pickClimbStair) {
      score = tableList2["climbStair"]![weight]!;
    } else if (pickClimbSteepStair) {
      score = tableList2["climbSteepStair"]![weight]!;
    } else if (pickCrawl) {
      score = tableList2["crawl"]![weight]!;
    }

    return score;
  }

  void update(String value) {
    setState(() {
      _weight = value;
      _score = calculateScore(value);
      bodyMovementARatingPoints = _score;
      _saveBodyMovementARatingPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double bottomPadding = MediaQuery.paddingOf(context).bottom;

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
          value: _weight,
          isExpanded: true,
          icon: SizedBox(),
          underline: SizedBox(),
          borderRadius: BorderRadius.circular(10),
          items:
              tableList.map<DropdownMenuItem<String>>((String value) {
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
                              _weight == value
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
            return tableList.map((String value) {
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

    Widget testingWidget(double screenWidth, double screenHeight) {
      return Expanded(
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title(context, screenWidth, screenHeight),
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
                      "$_weight 公斤",
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              select(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.04),
              Text(
                "活動類型",
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
                    "assets/images/body_movement_type.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pickWalk = true;
                      pickSlope = false;
                      pickStair = false;
                      pickClimbStair = false;
                      pickClimbSteepStair = false;
                      pickCrawl = false;
                      pickLow = true;
                      pickMedium = false;
                      pickHigh = false;
                      update(_weight);
                      Future.delayed(Duration(milliseconds: 300), () {
                        _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pickWalk
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.3,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            pickWalk
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "走動",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      pickWalk = false;
                      pickSlope = true;
                      pickStair = false;
                      pickClimbStair = false;
                      pickClimbSteepStair = false;
                      pickCrawl = false;
                      pickLow = true;
                      pickMedium = false;
                      pickHigh = false;
                      update(_weight);
                      Future.delayed(Duration(milliseconds: 300), () {
                        _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pickSlope
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.3,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            pickSlope
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "爬斜坡",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      pickWalk = false;
                      pickSlope = false;
                      pickStair = true;
                      pickClimbStair = false;
                      pickClimbSteepStair = false;
                      pickCrawl = false;
                      pickLow = true;
                      pickMedium = false;
                      pickHigh = false;
                      update(_weight);
                      Future.delayed(Duration(milliseconds: 300), () {
                        _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pickStair
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.3,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            pickStair
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "爬樓梯",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.016),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pickWalk = false;
                      pickSlope = false;
                      pickStair = false;
                      pickClimbStair = true;
                      pickClimbSteepStair = false;
                      pickCrawl = false;
                      update(_weight);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pickClimbStair
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.3,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            pickClimbStair
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "攀爬階梯",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      pickWalk = false;
                      pickSlope = false;
                      pickStair = false;
                      pickClimbStair = false;
                      pickClimbSteepStair = true;
                      pickCrawl = false;
                      update(_weight);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pickClimbSteepStair
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.3,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            pickClimbSteepStair
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "攀爬陡梯",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      pickWalk = false;
                      pickSlope = false;
                      pickStair = false;
                      pickClimbStair = false;
                      pickClimbSteepStair = false;
                      pickCrawl = true;
                      update(_weight);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pickCrawl
                              ? const Color(0XFF6F8FA8)
                              : const Color(0xFFE9E9E9),
                      minimumSize: Size(
                        screenWidth * 0.3,
                        screenHeight * 0.056,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            pickCrawl
                                ? BorderSide(color: Colors.black87, width: 1)
                                : BorderSide.none,
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "爬行/極\n度彎腰走路",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              if (pickWalk || pickSlope || pickStair) ...[
                SizedBox(height: screenHeight * 0.04),
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
                                pickLow = true;
                                pickMedium = false;
                                pickHigh = false;
                                update(_weight);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    pickLow
                                        ? const Color(0XFF8F4B4B)
                                        : const Color(0xFFE9E9E9),
                                minimumSize: Size(
                                  screenWidth * 0.22,
                                  screenHeight * 0.046,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side:
                                      pickLow
                                          ? BorderSide(
                                            color: Colors.black87,
                                            width: 1,
                                          )
                                          : BorderSide.none,
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                "低",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Positioned(
                            top: screenHeight * -0.008,
                            left: screenWidth * 0.19,
                            child: IconButton(
                              icon: Image.asset(
                                "assets/images/help-circle.png",
                              ),
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
                                          width: screenWidth * 0.6,
                                          height: screenHeight * 0.1,
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
                                                      width: screenWidth * 0.445,
                                                      margin: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.03,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top:
                                                            screenHeight *
                                                            0.004,
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.clear,
                                                          color: Colors.white,
                                                          size:
                                                              screenWidth *
                                                              0.06,
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
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    pickWalk ? "走路速度 < 3 公里/小時" : pickSlope ? "傾斜角度 < 5°" : "普通樓梯",
                                                    style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.042,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      decoration:
                                                          TextDecoration.none,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                    SizedBox(width: screenWidth * 0.02),
                    SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.08,
                      child: Stack(
                        children: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                pickLow = false;
                                pickMedium = true;
                                pickHigh = false;
                                update(_weight);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    pickMedium
                                        ? const Color(0XFF8F4B4B)
                                        : const Color(0xFFE9E9E9),
                                minimumSize: Size(
                                  screenWidth * 0.22,
                                  screenHeight * 0.046,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side:
                                      pickMedium
                                          ? BorderSide(
                                            color: Colors.black87,
                                            width: 1,
                                          )
                                          : BorderSide.none,
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                "中",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Positioned(
                            top: screenHeight * -0.008,
                            left: screenWidth * 0.19,
                            child: IconButton(
                              icon: Image.asset(
                                "assets/images/help-circle.png",
                              ),
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
                                          width: screenWidth * 0.6,
                                          height: screenHeight * 0.1,
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
                                                      width: screenWidth * 0.445,
                                                      margin: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.03,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top:
                                                            screenHeight *
                                                            0.004,
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.clear,
                                                          color: Colors.white,
                                                          size:
                                                              screenWidth *
                                                              0.06,
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
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    pickWalk ? "走路速度 3-5 公里/小時" : pickSlope ? "傾斜角度 < 5 - 15°" : "陡峭樓梯(35 - 50°)",
                                                    style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.042,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      decoration:
                                                          TextDecoration.none,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                    SizedBox(width: screenWidth * 0.02),
                    SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.08,
                      child: Stack(
                        children: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                pickLow = false;
                                pickMedium = false;
                                pickHigh = true;
                                update(_weight);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    pickHigh
                                        ? const Color(0XFF8F4B4B)
                                        : const Color(0xFFE9E9E9),
                                minimumSize: Size(
                                  screenWidth * 0.22,
                                  screenHeight * 0.046,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side:
                                      pickHigh
                                          ? BorderSide(
                                            color: Colors.black87,
                                            width: 1,
                                          )
                                          : BorderSide.none,
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                "高",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Positioned(
                            top: screenHeight * -0.008,
                            left: screenWidth * 0.19,
                            child: IconButton(
                              icon: Image.asset(
                                "assets/images/help-circle.png",
                              ),
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
                                          width: screenWidth * 0.6,
                                          height: screenHeight * 0.1,
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
                                                      width: screenWidth * 0.445,
                                                      margin: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.03,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top:
                                                            screenHeight *
                                                            0.004,
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.clear,
                                                          color: Colors.white,
                                                          size:
                                                              screenWidth *
                                                              0.06,
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
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                    pickWalk ? "走路速度 > 5 公里/小時" : pickSlope ? "傾斜角度 > 15°" : "極度陡峭樓梯(> 50°)",
                                                    style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.042,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      decoration:
                                                          TextDecoration.none,
                                                    ),
                                                    textAlign: TextAlign.center,
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
              ],
              SizedBox(height: screenHeight * 0.04),
              PONButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                havePrevious: false,
                haveNextPage: true,
                previousText: "",
                nextText: "下一步",
                nextPage: LoadWeightPosition(
                  haveTransportation: widget.haveTransportation,
                  loadWeightText: _weight,
                ),
                onTap: () => _saveBodyMovementARatingPoints(),
              ),
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
              "活動評級-A",
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
                  currentStep: 2,
                  totalStep: widget.haveTransportation ? 9 : 7,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                ScoreBar(
                  labelText:
                      "總分 : ${bodyMovementARatingPoints.toString().replaceAll(".0", "")} / 100 分",
                  currentScore: bodyMovementARatingPoints,
                  textSize: screenWidth * 0.038,
                  maxScore: 100,
                  barSize: screenWidth * 0.056,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),
                testingWidget(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.043 - bottomPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
