import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class BMResultStoreButton extends StatelessWidget {
  const BMResultStoreButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userName,
    required this.nextPage,
  });

  final double screenWidth;
  final double screenHeight;
  final String userName; // 當前使用者
  final Widget nextPage;

  Future<void> _saveBMUserData(BuildContext context, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('BM_Users') ?? <String>[];
    final gender = prefs.getString('Gender') ?? "";
    final pickMale = prefs.getBool('PickMale') ?? false;
    final pickFemale = prefs.getBool('PickFemale') ?? false;
    final timeLabel = prefs.getString('TimeLabel') ?? "";
    final haveTransportation = prefs.getBool('HaveTransportation') ?? false;
    final haveSupport = prefs.getBool('HaveTransportSupport') ?? false;
    final onlyTransportation = prefs.getBool('OnlyTransportation') ?? false;
    final timeRatingPoints = prefs.getDouble('TimeRatingPoints') ?? 0.0;
    final weightLabel = prefs.getString('WeightLabel') ?? "";
    final pickWalk = prefs.getBool('PickWalk') ?? false;
    final pickSlope = prefs.getBool('PickSlope') ?? false;
    final pickStair = prefs.getBool('PickStair') ?? false;
    final pickLow = prefs.getBool('PickLow') ?? false;
    final pickMedium = prefs.getBool('PickMedium') ?? false;
    final pickHigh = prefs.getBool('PickHigh') ?? false;
    final pickClimbStair = prefs.getBool('PickClimbStair') ?? false;
    final pickClimbSteepStair = prefs.getBool('PickClimbSteepStair') ?? false;
    final pickCrawl = prefs.getBool('PickCrawl') ?? false;
    final bodyMovementARatingPoints = prefs.getInt('BodyMovementARatingPoints') ?? 0;
    final pickLoadWeightPositionText = prefs.getString('PickLoadWeightPositionText') ?? "";
    final pickSupport = prefs.getBool('PickSupport') ?? false;
    final pickClose = prefs.getBool('PickClose') ?? false;
    final pickAway = prefs.getBool('PickAway') ?? false;
    final loadWeightPositionRatingPoints = prefs.getInt('LoadWeightPositionRatingPoints') ?? 0;
    final pickText = prefs.getString('PickText') ?? "";
    final pickOccasionally = prefs.getBool('PickOccasionally') ?? false;
    final pickOften = prefs.getBool('PickOften') ?? false;
    final bodyPostureRatingPoints = prefs.getInt('BodyPostureRatingPoints') ?? 0;
    final spaceScore = prefs.getInt('SpaceScore') ?? 0;
    final climateScore = prefs.getInt('ClimateScore') ?? 0;
    final workConditionRatingPoints = prefs.getInt('WorkConditionRatingPoints') ?? 0;
    final transportationWeightLabel = prefs.getString('TransportationWeightLabel') ?? "";
    final speedLabel = prefs.getString('SpeedLabel') ?? "";
    final bodyMovementBRatingPoints = prefs.getInt('BodyMovementBRatingPoints') ?? 0;
    final roadConditionSelect = prefs.getBool('RoadConditionSelect') ?? false;
    final roadConditionOften = prefs.getBool('RoadConditionOften') ?? false;
    final roadConditionRatingPoints = prefs.getInt('RoadConditionRatingPoints') ?? 0;
    final workOrganizationRatingPoints = prefs.getInt('WorkOrganizationRatingPoints') ?? 0;
    final totalStep = prefs.getInt('TotalStep') ?? 0;

    if (username.isEmpty) {
      await Fluttertoast.showToast(
        msg: "使用者名稱不能為空",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: const Color(0XFFD9D9D9),
        textColor: Colors.red,
      );
    } else {
      if (!users.contains(username)) {
        users.add(username);
        await prefs.setStringList('BM_Users', users);
        await prefs.setString('${username}_Gender', gender);
        await prefs.setBool('${username}_BM_PickMale', pickMale);
        await prefs.setBool('${username}_BM_PickFemale', pickFemale);
        await prefs.setString('${username}_BM_TimeLabel', timeLabel);
        await prefs.setBool('${username}_BM_HaveTransportation', haveTransportation);
        await prefs.setBool('${username}_BM_HaveTransportSupport', haveSupport);
        await prefs.setBool('${username}_BM_OnlyTransportation', onlyTransportation);
        await prefs.setDouble('${username}_BM_TimeRatingPoints', timeRatingPoints);
        await prefs.setString('${username}_BM_WeightLabel', weightLabel);
        await prefs.setBool('${username}_BM_PickWalk', pickWalk);
        await prefs.setBool('${username}_BM_PickSlope', pickSlope);
        await prefs.setBool('${username}_BM_PickStair', pickStair);
        await prefs.setBool('${username}_BM_PickLow', pickLow);
        await prefs.setBool('${username}_BM_PickMedium', pickMedium);
        await prefs.setBool('${username}_BM_PickHigh', pickHigh);
        await prefs.setBool('${username}_BM_PickClimbStair', pickClimbStair);
        await prefs.setBool('${username}_BM_PickClimbSteepStair', pickClimbSteepStair);
        await prefs.setBool('${username}_BM_PickCrawl', pickCrawl);
        await prefs.setInt('${username}_BM_BodyMovementARatingPoints', bodyMovementARatingPoints);
        await prefs.setString('${username}_BM_PickLoadWeightPositionText', pickLoadWeightPositionText);
        await prefs.setBool('${username}_BM_PickSupport', pickSupport);
        await prefs.setBool('${username}_BM_PickClose', pickClose);
        await prefs.setBool('${username}_BM_PickAway', pickAway);
        await prefs.setInt('${username}_BM_LoadWeightPositionRatingPoints', loadWeightPositionRatingPoints);
        await prefs.setString('${username}_BM_PickText', pickText);
        await prefs.setBool('${username}_BM_PickOccasionally', pickOccasionally);
        await prefs.setBool('${username}_BM_PickOften', pickOften);
        await prefs.setInt('${username}_BM_BodyPostureRatingPoints', bodyPostureRatingPoints);
        await prefs.setInt('${username}_BM_SpaceScore', spaceScore);
        await prefs.setInt('${username}_BM_ClimateScore', climateScore);
        await prefs.setInt('${username}_BM_WorkConditionRatingPoints', workConditionRatingPoints);
        await prefs.setString('${username}_BM_TransportationWeightLabel', transportationWeightLabel);
        await prefs.setString('${username}_BM_SpeedLabel', speedLabel);
        await prefs.setInt('${username}_BM_BodyMovementBRatingPoints', bodyMovementBRatingPoints);
        await prefs.setBool('${username}_BM_RoadConditionSelect', roadConditionSelect);
        await prefs.setBool('${username}_BM_RoadConditionOften', roadConditionOften);
        await prefs.setInt('${username}_BM_RoadConditionRatingPoints', roadConditionRatingPoints);
        await prefs.setInt('${username}_BM_WorkOrganizationRatingPoints', workOrganizationRatingPoints);
        await prefs.setInt('${username}_BM_TotalStep', totalStep);
        await Fluttertoast.showToast(
          msg: "測驗紀錄已儲存",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.white,
          textColor: const Color(0xff7392ff),
        );
      } else {
        await prefs.setString('${username}_Gender', gender);
        await prefs.setBool('${username}_BM_PickMale', pickMale);
        await prefs.setBool('${username}_BM_PickFemale', pickFemale);
        await prefs.setString('${username}_BM_TimeLabel', timeLabel);
        await prefs.setBool('${username}_BM_HaveTransportation', haveTransportation);
        await prefs.setBool('${username}_BM_HaveTransportSupport', haveSupport);
        await prefs.setBool('${username}_BM_OnlyTransportation', onlyTransportation);
        await prefs.setDouble('${username}_BM_TimeRatingPoints', timeRatingPoints);
        await prefs.setString('${username}_BM_WeightLabel', weightLabel);
        await prefs.setBool('${username}_BM_PickWalk', pickWalk);
        await prefs.setBool('${username}_BM_PickSlope', pickSlope);
        await prefs.setBool('${username}_BM_PickStair', pickStair);
        await prefs.setBool('${username}_BM_PickLow', pickLow);
        await prefs.setBool('${username}_BM_PickMedium', pickMedium);
        await prefs.setBool('${username}_BM_PickHigh', pickHigh);
        await prefs.setBool('${username}_BM_PickClimbStair', pickClimbStair);
        await prefs.setBool('${username}_BM_PickClimbSteepStair', pickClimbSteepStair);
        await prefs.setBool('${username}_BM_PickCrawl', pickCrawl);
        await prefs.setInt('${username}_BM_BodyMovementARatingPoints', bodyMovementARatingPoints);
        await prefs.setString('${username}_BM_PickLoadWeightPositionText', pickLoadWeightPositionText);
        await prefs.setBool('${username}_BM_PickSupport', pickSupport);
        await prefs.setBool('${username}_BM_PickClose', pickClose);
        await prefs.setBool('${username}_BM_PickAway', pickAway);
        await prefs.setInt('${username}_BM_LoadWeightPositionRatingPoints', loadWeightPositionRatingPoints);
        await prefs.setString('${username}_BM_PickText', pickText);
        await prefs.setBool('${username}_BM_PickOccasionally', pickOccasionally);
        await prefs.setBool('${username}_BM_PickOften', pickOften);
        await prefs.setInt('${username}_BM_BodyPostureRatingPoints', bodyPostureRatingPoints);
        await prefs.setInt('${username}_BM_SpaceScore', spaceScore);
        await prefs.setInt('${username}_BM_ClimateScore', climateScore);
        await prefs.setInt('${username}_BM_WorkConditionRatingPoints', workConditionRatingPoints);
        await prefs.setString('${username}_BM_TransportationWeightLabel', transportationWeightLabel);
        await prefs.setString('${username}_BM_SpeedLabel', speedLabel);
        await prefs.setInt('${username}_BM_BodyMovementBRatingPoints', bodyMovementBRatingPoints);
        await prefs.setBool('${username}_BM_RoadConditionSelect', roadConditionSelect);
        await prefs.setBool('${username}_BM_RoadConditionOften', roadConditionOften);
        await prefs.setInt('${username}_BM_RoadConditionRatingPoints', roadConditionRatingPoints);
        await prefs.setInt('${username}_BM_WorkOrganizationRatingPoints', workOrganizationRatingPoints);
        await prefs.setInt('${username}_BM_TotalStep', totalStep);
        await Fluttertoast.showToast(
          msg: "已更新 $username 的檢測紀錄",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      }
    }
  }

  Future<void> _showSaveBMUserDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text(
          "保存測驗紀錄",
          style: TextStyle(fontSize: screenWidth * 0.043),
        ),
        backgroundColor: const Color(0XFFD9D9D9),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "輸入名字"),
        ),
        actions: [
          TextButton(
            child: Text(
              "保存",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenWidth * 0.038,
                color: Colors.black87,
              ),
            ),
            onPressed: () async {
              await _saveBMUserData(context, controller.text.trim());
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              "取消",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenWidth * 0.038,
                color: Colors.black87,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return userName == "vJ#CA:F3zP)C]A=V" ? SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async => await _showSaveBMUserDialog(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.008,
              ),
            ),
            child: SizedBox(
              width: screenWidth * 0.28,
              height: screenHeight * 0.032,
              child: Text(
                "保存紀錄",
                style: TextStyle(
                  fontSize: screenWidth * 0.044,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.14),
          ElevatedButton(
            onPressed: () async {
              await clearGuestKeysForLHC();

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => nextPage),
                      (Route<dynamic> route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.008,
              ),
            ),
            child: SizedBox(
              width: screenWidth * 0.28,
              height: screenHeight * 0.032,
              child: Text(
                "返回首頁",
                style: TextStyle(fontSize: screenWidth * 0.044, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ) : SizedBox();
  }
}
