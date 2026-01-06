import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'general/select_item.dart';
import 'homepage/test_record.dart';
import 'homepage/about.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> clearGuestKeysForLHC() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('Gender');
  await prefs.remove('Weight');
  await prefs.remove('WeightRatingPoints');
  await prefs.remove('TimeLabel');
  await prefs.remove('TimeRatingPoints');
  await prefs.remove('WeightHandlingLabel');
  await prefs.remove('WeightHandlingRatingPoints');
  await prefs.remove('WorkConditionLabel1');
  await prefs.remove('WorkConditionLabel2');
  await prefs.remove('WorkConditionLabel3');
  await prefs.remove('WorkConditionLabel4');
  await prefs.remove('WorkConditionLabel5');
  await prefs.remove('WorkConditionLabel6');
  await prefs.remove('WorkConditionScore1');
  await prefs.remove('WorkConditionScore2');
  await prefs.remove('WorkConditionScore3');
  await prefs.remove('WorkConditionScore4');
  await prefs.remove('WorkConditionScore5');
  await prefs.remove('WorkConditionScore6');
  await prefs.remove('WorkConditionRatingPoints');
  await prefs.remove('WorkOrganizationLabel');
  await prefs.remove('WorkOrganizationRatingPoints');
  await prefs.remove('LHCTotalPoints');
}

Future<void> clearGuestKeysForABP() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('TimeLabel');
  await prefs.remove('TimeRatingPoints');
  await prefs.remove('BackLoadSelect1');
  await prefs.remove('BackLoadSelect2');
  await prefs.remove('BackLoadSelect3');
  await prefs.remove('BackLoadSelect4');
  await prefs.remove('BackLoadSelect5');
  await prefs.remove('BackLoadLabel1');
  await prefs.remove('BackLoadLabel2');
  await prefs.remove('BackLoadLabel3');
  await prefs.remove('BackLoadLabel4');
  await prefs.remove('BackLoadLabel5');
  await prefs.remove('BackLoadCanFree');
  await prefs.remove('BackLoadPick1');
  await prefs.remove('BackLoadPick2');
  await prefs.remove('BackLoadPick3');
  await prefs.remove('BackLoadPick4');
  await prefs.remove('BackLoadPick5');
  await prefs.remove('BackLoadPick6');
  await prefs.remove('BackLoadRatingPoints');
  await prefs.remove('ShoulderUpperLimbLoadSelect1');
  await prefs.remove('ShoulderUpperLimbLoadSelect2');
  await prefs.remove('ShoulderUpperLimbLoadSelect3');
  await prefs.remove('ShoulderUpperLimbLoadLabel1');
  await prefs.remove('ShoulderUpperLimbLoadLabel2');
  await prefs.remove('ShoulderUpperLimbLoadLabel3');
  await prefs.remove('ShoulderUpperLimbLoadRatingPoints');
  await prefs.remove('LowerLimbLoadSelect1');
  await prefs.remove('LowerLimbLoadSelect2');
  await prefs.remove('LowerLimbLoadLabel1');
  await prefs.remove('LowerLimbLoadLabel2');
  await prefs.remove('LowerLimbLoadRatingPoints');
  await prefs.remove('WorkConditionSelect1');
  await prefs.remove('WorkConditionSelect2');
  await prefs.remove('WorkConditionSelect3');
  await prefs.remove('WorkConditionSelect4');
  await prefs.remove('WorkConditionSelect5');
  await prefs.remove('WorkConditionSelect6');
  await prefs.remove('WorkConditionSelect7');
  await prefs.remove('WorkConditionSelect8');
  await prefs.remove('WorkConditionSelect9');
  await prefs.remove('WorkConditionSelect10');
  await prefs.remove('WorkConditionSelect11');
  await prefs.remove('WorkConditionScoreA');
  await prefs.remove('WorkConditionScoreB');
  await prefs.remove('WorkConditionScoreC');
  await prefs.remove('WorkConditionRatingPoints');
  await prefs.remove('PartB');
  await prefs.remove('PartC');
  await prefs.remove('TotalStep');
}

Future<void> clearGuestKeysForBM() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('Gender');
  await prefs.remove('PickMale');
  await prefs.remove('PickFemale');
  await prefs.remove('TimeLabel');
  await prefs.remove('HaveTransportation');
  await prefs.remove('HaveTransportSupport');
  await prefs.remove('OnlyTransportation');
  await prefs.remove('TimeRatingPoints');
  await prefs.remove('WeightLabel');
  await prefs.remove('PickWalk');
  await prefs.remove('PickSlope');
  await prefs.remove('PickStair');
  await prefs.remove('PickLow');
  await prefs.remove('PickMedium');
  await prefs.remove('PickHigh');
  await prefs.remove('PickClimbStair');
  await prefs.remove('PickClimbSteepStair');
  await prefs.remove('PickCrawl');
  await prefs.remove('BodyMovementARatingPoints');
  await prefs.remove('PickLoadWeightPositionText');
  await prefs.remove('PickSupport');
  await prefs.remove('PickClose');
  await prefs.remove('PickAway');
  await prefs.remove('LoadWeightPositionRatingPoints');
  await prefs.remove('PickBodyPostureText');
  await prefs.remove('PickOccasionally');
  await prefs.remove('PickOften');
  await prefs.remove('BodyPostureRatingPoints');
  await prefs.remove('SpaceScore');
  await prefs.remove('ClimateScore');
  await prefs.remove('WorkConditionRatingPoints');
  await prefs.remove('WorkOrganizationRatingPoints');
  await prefs.remove('TransportationWeightLabel');
  await prefs.remove('SpeedLabel');
  await prefs.remove('BodyMovementBRatingPoints');
  await prefs.remove('RoadConditionSelect');
  await prefs.remove('RoadConditionOften');
  await prefs.remove('RoadConditionRatingPoints');
  await prefs.remove('TotalStep');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HomePage());
}

Widget button(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    String text,
    Color bgColor,
    Color textColor,
    Color clickColor,
    Widget nextPage,
    ) {
  return Builder(
    builder:
        (context) => Container(
      width: screenWidth * 0.22,
      height: screenHeight * 0.12,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.06),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 10.0,
            spreadRadius: 1,
            color: const Color(0xFF999999),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          side: BorderSide(color: Colors.black, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          overlayColor: clickColor,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        child:
        text == "開始檢測"
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: screenWidth * 0.016),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: screenWidth * 0.026,
              ),
              textAlign: TextAlign.center,
            ),
            Icon(
              Icons.play_arrow_outlined,
              size: screenWidth * 0.04,
              color: Colors.white,
            ),
          ],
        )
            : Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.026,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 這些 MediaQuery 可以保留，也可以之後改用 ScreenUtil().screenWidth
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    // 2. 這裡是用 ScreenUtilInit 包裹 MaterialApp 的關鍵修正
    return ScreenUtilInit(
      // 請填入你設計稿的尺寸 (例如 Figma 上的寬高)，常見是 360x690 或 375x812
      designSize: const Size(360, 690),
      minTextAdapt: true, // 這就是報錯說沒有初始化的參數
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // 確保這裡的 home 接收的是 builder 傳下來的 child (可選，或直接放 Scaffold)
          // 但為了確保 ScreenUtil 在整個 App 生效，通常把 Scaffold 放這裡
          home: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              body: Container(
                width: screenWidth, // 之後建議改用 1.sw
                height: screenHeight, // 之後建議改用 1.sh
                decoration: const BoxDecoration( // 建議加上 const 優化效能
                  image: DecorationImage(
                    image: AssetImage("assets/images/bgi.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.2),
                    Container(
                      height: screenHeight * 0.2,
                      width: screenHeight * 0.2,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.15),
                    // 這裡是你原本的按鈕邏輯
                    button(
                      context,
                      screenWidth,
                      screenHeight,
                      "開始檢測",
                      Colors.black,
                      Colors.white,
                      Colors.white,
                      SelectItem(),
                    ),
                    button(
                      context,
                      screenWidth,
                      screenHeight,
                      "檢測紀錄",
                      Colors.white,
                      Colors.black,
                      Colors.black,
                      TestRecord(),
                    ),
                    button(
                      context,
                      screenWidth,
                      screenHeight,
                      "關於",
                      Colors.white,
                      Colors.black,
                      Colors.black,
                      About(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
