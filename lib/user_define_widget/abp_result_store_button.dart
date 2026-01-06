import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class ABPResultStoreButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String userName;
  final Widget nextPage;

  const ABPResultStoreButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userName,
    required this.nextPage,
  });

  Future<void> _saveABPUserData(BuildContext context, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('ABP_Users') ?? <String>[];
    final timeLabel = prefs.getString('TimeLabel') ?? "";
    final timeRatingPoints = prefs.getDouble('TimeRatingPoints') ?? 0.0;
    final backLoadSelect1 = prefs.getBool('BackLoadSelect1') ?? false;
    final backLoadSelect2 = prefs.getBool('BackLoadSelect2') ?? false;
    final backLoadSelect3 = prefs.getBool('BackLoadSelect3') ?? false;
    final backLoadSelect4 = prefs.getBool('BackLoadSelect4') ?? false;
    final backLoadSelect5 = prefs.getBool('BackLoadSelect5') ?? false;
    final backLoadLabel1 = prefs.getString('BackLoadLabel1') ?? "";
    final backLoadLabel2 = prefs.getString('BackLoadLabel2') ?? "";
    final backLoadLabel3 = prefs.getString('BackLoadLabel3') ?? "";
    final backLoadLabel4 = prefs.getString('BackLoadLabel4') ?? "";
    final backLoadLabel5 = prefs.getString('BackLoadLabel5') ?? "";
    final backLoadCanFree = prefs.getBool('BackLoadCanFree') ?? false;
    final backLoadPick1 = prefs.getBool('BackLoadPick1') ?? false;
    final backLoadPick2 = prefs.getBool('BackLoadPick2') ?? false;
    final backLoadPick3 = prefs.getBool('BackLoadPick3') ?? false;
    final backLoadPick4 = prefs.getBool('BackLoadPick4') ?? false;
    final backLoadPick5 = prefs.getBool('BackLoadPick5') ?? false;
    final backLoadPick6 = prefs.getBool('BackLoadPick6') ?? false;
    final backLoadRatingPoints = prefs.getDouble('BackLoadRatingPoints') ?? 0.0;
    final shoulderUpperLimbLoadSelect1 = prefs.getBool('ShoulderUpperLimbLoadSelect1') ?? false;
    final shoulderUpperLimbLoadSelect2 = prefs.getBool('ShoulderUpperLimbLoadSelect2') ?? false;
    final shoulderUpperLimbLoadSelect3 = prefs.getBool('ShoulderUpperLimbLoadSelect3') ?? false;
    final shoulderUpperLimbLoadLabel1 = prefs.getString('ShoulderUpperLimbLoadLabel1') ?? "";
    final shoulderUpperLimbLoadLabel2 = prefs.getString('ShoulderUpperLimbLoadLabel2') ?? "";
    final shoulderUpperLimbLoadLabel3 = prefs.getString('ShoulderUpperLimbLoadLabel3') ?? "";
    final shoulderUpperLimbLoadRatingPoints = prefs.getInt('ShoulderUpperLimbLoadRatingPoints') ?? 0;
    final lowerLimbLoadSelect1 = prefs.getBool('LowerLimbLoadSelect1') ?? false;
    final lowerLimbLoadSelect2 = prefs.getBool('LowerLimbLoadSelect2') ?? false;
    final lowerLimbLoadLabel1 = prefs.getString('LowerLimbLoadLabel1') ?? "";
    final lowerLimbLoadLabel2 = prefs.getString('LowerLimbLoadLabel2') ?? "";
    final lowerLimbLoadRatingPoints = prefs.getInt('LowerLimbLoadRatingPoints') ?? 0;
    final workConditionSelect1 = prefs.getBool('WorkConditionSelect1') ?? false;
    final workConditionSelect2 = prefs.getBool('WorkConditionSelect2') ?? false;
    final workConditionSelect3 = prefs.getBool('WorkConditionSelect3') ?? false;
    final workConditionSelect4 = prefs.getBool('WorkConditionSelect4') ?? false;
    final workConditionSelect5 = prefs.getBool('WorkConditionSelect5') ?? false;
    final workConditionSelect6 = prefs.getBool('WorkConditionSelect6') ?? false;
    final workConditionSelect7 = prefs.getBool('WorkConditionSelect7') ?? false;
    final workConditionSelect8 = prefs.getBool('WorkConditionSelect8') ?? false;
    final workConditionSelect9 = prefs.getBool('WorkConditionSelect9') ?? false;
    final workConditionSelect10 = prefs.getBool('WorkConditionSelect10') ?? false;
    final workConditionSelect11 = prefs.getBool('WorkConditionSelect11') ?? false;
    final workConditionRatingPoints = prefs.getInt('WorkConditionRatingPoints') ?? 0;
    final partB = prefs.getBool('PartB') ?? false;
    final partC = prefs.getBool('PartC') ?? false;
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
        await prefs.setStringList('ABP_Users', users);
        await prefs.setString('${username}_ABP_TimeLabel', timeLabel);
        await prefs.setDouble('${username}_ABP_TimeRatingPoints', timeRatingPoints);
        await prefs.setBool('${username}_ABP_BackLoadSelect1', backLoadSelect1);
        await prefs.setBool('${username}_ABP_BackLoadSelect2', backLoadSelect2);
        await prefs.setBool('${username}_ABP_BackLoadSelect3', backLoadSelect3);
        await prefs.setBool('${username}_ABP_BackLoadSelect4', backLoadSelect4);
        await prefs.setBool('${username}_ABP_BackLoadSelect5', backLoadSelect5);
        await prefs.setString('${username}_ABP_BackLoadLabel1', backLoadLabel1);
        await prefs.setString('${username}_ABP_BackLoadLabel2', backLoadLabel2);
        await prefs.setString('${username}_ABP_BackLoadLabel3', backLoadLabel3);
        await prefs.setString('${username}_ABP_BackLoadLabel4', backLoadLabel4);
        await prefs.setString('${username}_ABP_BackLoadLabel5', backLoadLabel5);
        await prefs.setBool('${username}_ABP_BackLoadCanFree', backLoadCanFree);
        await prefs.setBool('${username}_ABP_BackLoadPick1', backLoadPick1);
        await prefs.setBool('${username}_ABP_BackLoadPick2', backLoadPick2);
        await prefs.setBool('${username}_ABP_BackLoadPick3', backLoadPick3);
        await prefs.setBool('${username}_ABP_BackLoadPick4', backLoadPick4);
        await prefs.setBool('${username}_ABP_BackLoadPick5', backLoadPick5);
        await prefs.setBool('${username}_ABP_BackLoadPick6', backLoadPick6);
        await prefs.setDouble('${username}_ABP_BackLoadRatingPoints', backLoadRatingPoints);
        await prefs.setBool('${username}_ABP_ShoulderUpperLimbLoadSelect1', shoulderUpperLimbLoadSelect1);
        await prefs.setBool('${username}_ABP_ShoulderUpperLimbLoadSelect2', shoulderUpperLimbLoadSelect2);
        await prefs.setBool('${username}_ABP_ShoulderUpperLimbLoadSelect3', shoulderUpperLimbLoadSelect3);
        await prefs.setString('${username}_ABP_ShoulderUpperLimbLoadLabel1', shoulderUpperLimbLoadLabel1);
        await prefs.setString('${username}_ABP_ShoulderUpperLimbLoadLabel2', shoulderUpperLimbLoadLabel2);
        await prefs.setString('${username}_ABP_ShoulderUpperLimbLoadLabel3', shoulderUpperLimbLoadLabel3);
        await prefs.setInt('${username}_ABP_ShoulderUpperLimbLoadRatingPoints', shoulderUpperLimbLoadRatingPoints);
        await prefs.setBool('${username}_ABP_LowerLimbLoadSelect1', lowerLimbLoadSelect1);
        await prefs.setBool('${username}_ABP_LowerLimbLoadSelect2', lowerLimbLoadSelect2);
        await prefs.setString('${username}_ABP_LowerLimbLoadLabel1', lowerLimbLoadLabel1);
        await prefs.setString('${username}_ABP_LowerLimbLoadLabel2', lowerLimbLoadLabel2);
        await prefs.setInt('${username}_ABP_LowerLimbLoadRatingPoints', lowerLimbLoadRatingPoints);
        await prefs.setBool('${username}_ABP_WorkConditionSelect1', workConditionSelect1);
        await prefs.setBool('${username}_ABP_WorkConditionSelect2', workConditionSelect2);
        await prefs.setBool('${username}_ABP_WorkConditionSelect3', workConditionSelect3);
        await prefs.setBool('${username}_ABP_WorkConditionSelect4', workConditionSelect4);
        await prefs.setBool('${username}_ABP_WorkConditionSelect5', workConditionSelect5);
        await prefs.setBool('${username}_ABP_WorkConditionSelect6', workConditionSelect6);
        await prefs.setBool('${username}_ABP_WorkConditionSelect7', workConditionSelect7);
        await prefs.setBool('${username}_ABP_WorkConditionSelect8', workConditionSelect8);
        await prefs.setBool('${username}_ABP_WorkConditionSelect9', workConditionSelect9);
        await prefs.setBool('${username}_ABP_WorkConditionSelect10', workConditionSelect10);
        await prefs.setBool('${username}_ABP_WorkConditionSelect11', workConditionSelect11);
        await prefs.setInt('${username}_ABP_WorkConditionRatingPoints', workConditionRatingPoints);
        await prefs.setBool('${username}_ABP_PartB', partB);
        await prefs.setBool('${username}_ABP_PartC', partC);
        await prefs.setInt('${username}_ABP_TotalStep', totalStep);
        await Fluttertoast.showToast(
          msg: "測驗紀錄已儲存",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.white,
          textColor: const Color(0xff7392ff),
        );
      } else {
        await prefs.setString('${username}_ABP_TimeLabel', timeLabel);
        await prefs.setDouble('${username}_ABP_TimeRatingPoints', timeRatingPoints);
        await prefs.setBool('${username}_ABP_BackLoadSelect1', backLoadSelect1);
        await prefs.setBool('${username}_ABP_BackLoadSelect2', backLoadSelect2);
        await prefs.setBool('${username}_ABP_BackLoadSelect3', backLoadSelect3);
        await prefs.setBool('${username}_ABP_BackLoadSelect4', backLoadSelect4);
        await prefs.setBool('${username}_ABP_BackLoadSelect5', backLoadSelect5);
        await prefs.setString('${username}_ABP_BackLoadLabel1', backLoadLabel1);
        await prefs.setString('${username}_ABP_BackLoadLabel2', backLoadLabel2);
        await prefs.setString('${username}_ABP_BackLoadLabel3', backLoadLabel3);
        await prefs.setString('${username}_ABP_BackLoadLabel4', backLoadLabel4);
        await prefs.setString('${username}_ABP_BackLoadLabel5', backLoadLabel5);
        await prefs.setBool('${username}_ABP_BackLoadCanFree', backLoadCanFree);
        await prefs.setBool('${username}_ABP_BackLoadPick1', backLoadPick1);
        await prefs.setBool('${username}_ABP_BackLoadPick2', backLoadPick2);
        await prefs.setBool('${username}_ABP_BackLoadPick3', backLoadPick3);
        await prefs.setBool('${username}_ABP_BackLoadPick4', backLoadPick4);
        await prefs.setBool('${username}_ABP_BackLoadPick5', backLoadPick5);
        await prefs.setBool('${username}_ABP_BackLoadPick6', backLoadPick6);
        await prefs.setDouble('${username}_ABP_BackLoadRatingPoints', backLoadRatingPoints);
        await prefs.setBool('${username}_ABP_ShoulderUpperLimbLoadSelect1', shoulderUpperLimbLoadSelect1);
        await prefs.setBool('${username}_ABP_ShoulderUpperLimbLoadSelect2', shoulderUpperLimbLoadSelect2);
        await prefs.setBool('${username}_ABP_ShoulderUpperLimbLoadSelect3', shoulderUpperLimbLoadSelect3);
        await prefs.setString('${username}_ABP_ShoulderUpperLimbLoadLabel1', shoulderUpperLimbLoadLabel1);
        await prefs.setString('${username}_ABP_ShoulderUpperLimbLoadLabel2', shoulderUpperLimbLoadLabel2);
        await prefs.setString('${username}_ABP_ShoulderUpperLimbLoadLabel3', shoulderUpperLimbLoadLabel3);
        await prefs.setInt('${username}_ABP_ShoulderUpperLimbLoadRatingPoints', shoulderUpperLimbLoadRatingPoints);
        await prefs.setBool('${username}_ABP_LowerLimbLoadSelect1', lowerLimbLoadSelect1);
        await prefs.setBool('${username}_ABP_LowerLimbLoadSelect2', lowerLimbLoadSelect2);
        await prefs.setString('${username}_ABP_LowerLimbLoadLabel1', lowerLimbLoadLabel1);
        await prefs.setString('${username}_ABP_LowerLimbLoadLabel2', lowerLimbLoadLabel2);
        await prefs.setInt('${username}_ABP_LowerLimbLoadRatingPoints', lowerLimbLoadRatingPoints);
        await prefs.setBool('${username}_ABP_WorkConditionSelect1', workConditionSelect1);
        await prefs.setBool('${username}_ABP_WorkConditionSelect2', workConditionSelect2);
        await prefs.setBool('${username}_ABP_WorkConditionSelect3', workConditionSelect3);
        await prefs.setBool('${username}_ABP_WorkConditionSelect4', workConditionSelect4);
        await prefs.setBool('${username}_ABP_WorkConditionSelect5', workConditionSelect5);
        await prefs.setBool('${username}_ABP_WorkConditionSelect6', workConditionSelect6);
        await prefs.setBool('${username}_ABP_WorkConditionSelect7', workConditionSelect7);
        await prefs.setBool('${username}_ABP_WorkConditionSelect8', workConditionSelect8);
        await prefs.setBool('${username}_ABP_WorkConditionSelect9', workConditionSelect9);
        await prefs.setBool('${username}_ABP_WorkConditionSelect10', workConditionSelect10);
        await prefs.setBool('${username}_ABP_WorkConditionSelect11', workConditionSelect11);
        await prefs.setInt('${username}_ABP_WorkConditionRatingPoints', workConditionRatingPoints);
        await prefs.setBool('${username}_ABP_PartB', partB);
        await prefs.setBool('${username}_ABP_PartC', partC);
        await prefs.setInt('${username}_ABP_TotalStep', totalStep);
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

  Future<void> _showSaveABPUserDialog(BuildContext context) async {
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
              await _saveABPUserData(context, controller.text.trim());
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
            onPressed: () async => await _showSaveABPUserDialog(context),
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
