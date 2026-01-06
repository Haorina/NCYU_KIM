import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class LHCResultStoreButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String userName;
  final Widget nextPage;

  const LHCResultStoreButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userName,
    required this.nextPage,
  });

  Future<void> _saveLHCUserData(BuildContext context, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('LHC_Users') ?? <String>[];
    final String gender = prefs.getString("Gender") ?? "";
    final String weight = prefs.getString("Weight") ?? "";
    final int weightRatingPoints = prefs.getInt("WeightRatingPoints") ?? 0;
    final String videoPath = prefs.getString("VideoPath") ?? "";
    final double twistOrLeanPoints =
        prefs.getDouble("TwistOrLeanPoints") ?? 0.0;
    final double distanceOfBodyCenterPoints =
        prefs.getDouble("DistanceOfBodyCenterPoints") ?? 0.0;
    final double armLiftPoints = prefs.getDouble("ArmLiftPoints") ?? 0.0;
    final double aboveShoulderPoints =
        prefs.getDouble("AboveShoulderPoints") ?? 0.0;
    final double bodyPosturePoints =
        prefs.getDouble("BodyPosturePoints") ?? 0.0;
    final double totalAdditionalPoints =
        prefs.getDouble("TotalAdditionalPoints") ?? 0.0;
    final double totalBodyPosturePoints =
        prefs.getDouble("TotalBodyPosturePoints") ?? 0.0;
    final String startPosture = prefs.getString("StartPosture") ?? "";
    final String endPosture = prefs.getString("EndPosture") ?? "";
    final String timeLabel = prefs.getString('TimeLabel') ?? "";
    final double timeRatingPoints = prefs.getDouble('TimeRatingPoints') ?? 0.0;
    final String weightHandlingLabel =
        prefs.getString('WeightHandlingLabel') ?? "";
    final int weightHandlingRatingPoints =
        prefs.getInt('WeightHandlingRatingPoints') ?? 0;
    final String workConditionLabel1 =
        prefs.getString('WorkConditionLabel1') ?? "";
    final String workConditionLabel2 =
        prefs.getString('WorkConditionLabel2') ?? "";
    final String workConditionLabel3 =
        prefs.getString('WorkConditionLabel3') ?? "";
    final String workConditionLabel4 =
        prefs.getString('WorkConditionLabel4') ?? "";
    final String workConditionLabel5 =
        prefs.getString('WorkConditionLabel5') ?? "";
    final String workConditionLabel6 =
        prefs.getString('WorkConditionLabel6') ?? "";
    final int workConditionScore1 = prefs.getInt('WorkConditionScore1') ?? 0;
    final int workConditionScore2 = prefs.getInt('WorkConditionScore2') ?? 0;
    final int workConditionScore3 = prefs.getInt('WorkConditionScore3') ?? 0;
    final int workConditionScore4 = prefs.getInt('WorkConditionScore4') ?? 0;
    final int workConditionScore5 = prefs.getInt('WorkConditionScore5') ?? 0;
    final int workConditionScore6 = prefs.getInt('WorkConditionScore6') ?? 0;
    final int workConditionRatingPoints =
        prefs.getInt('WorkConditionRatingPoints') ?? 0;
    final String workOrganizationLabel =
        prefs.getString('WorkOrganizationLabel') ?? "";
    final int workOrganizationRatingPoints =
        prefs.getInt('WorkOrganizationRatingPoints') ?? 0;

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
        await prefs.setStringList('LHC_Users', users);
        await prefs.setString('${username}_Gender', gender);
        await prefs.setString('${username}_LHC_Weight', weight);
        await prefs.setInt('${username}_LHC_WeightRatingPoints', weightRatingPoints);
        await prefs.setString('${username}_LHC_VideoPath', videoPath);
        await prefs.setDouble('${username}_LHC_TwistOrLeanPoints', twistOrLeanPoints);
        await prefs.setDouble('${username}_LHC_DistanceOfBodyCenterPoints', distanceOfBodyCenterPoints);
        await prefs.setDouble('${username}_LHC_ArmLiftPoints', armLiftPoints);
        await prefs.setDouble('${username}_LHC_AboveShoulderPoints', aboveShoulderPoints);
        await prefs.setDouble('${username}_LHC_BodyPosturePoints', bodyPosturePoints);
        await prefs.setDouble('${username}_LHC_TotalAdditionalPoints', totalAdditionalPoints);
        await prefs.setDouble('${username}_LHC_TotalBodyPosturePoints', totalBodyPosturePoints);
        await prefs.setString('${username}_LHC_StartPosture', startPosture);
        await prefs.setString('${username}_LHC_EndPosture', endPosture);
        await prefs.setString('${username}_LHC_TimeLabel', timeLabel);
        await prefs.setDouble('${username}_LHC_TimeRatingPoints', timeRatingPoints);
        await prefs.setString(
          '${username}_LHC_WeightHandlingLabel',
          weightHandlingLabel,
        );
        await prefs.setInt(
          '${username}_LHC_WeightHandlingRatingPoints',
          weightHandlingRatingPoints,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel1',
          workConditionLabel1,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel2',
          workConditionLabel2,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel3',
          workConditionLabel3,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel4',
          workConditionLabel4,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel5',
          workConditionLabel5,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel6',
          workConditionLabel6,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore1',
          workConditionScore1,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore2',
          workConditionScore2,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore3',
          workConditionScore3,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore4',
          workConditionScore4,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore5',
          workConditionScore5,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore6',
          workConditionScore6,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionRatingPoints',
          workConditionRatingPoints,
        );
        await prefs.setString(
          '${username}_LHC_WorkOrganizationLabel',
          workOrganizationLabel,
        );
        await prefs.setInt(
          '${username}_LHC_WorkOrganizationRatingPoints',
          workOrganizationRatingPoints,
        );
        await Fluttertoast.showToast(
          msg: "測驗紀錄已儲存",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.white,
          textColor: const Color(0xff7392ff),
        );
      } else {
        await prefs.setString('${username}_Gender', gender);
        await prefs.setString('${username}_LHC_Weight', weight);
        await prefs.setInt('${username}_LHC_WeightRatingPoints', weightRatingPoints);
        await prefs.setString('${username}_LHC_VideoPath', videoPath);
        await prefs.setDouble('${username}_LHC_TwistOrLeanPoints', twistOrLeanPoints);
        await prefs.setDouble('${username}_LHC_DistanceOfBodyCenterPoints', distanceOfBodyCenterPoints);
        await prefs.setDouble('${username}_LHC_ArmLiftPoints', armLiftPoints);
        await prefs.setDouble('${username}_LHC_AboveShoulderPoints', aboveShoulderPoints);
        await prefs.setDouble('${username}_LHC_BodyPosturePoints', bodyPosturePoints);
        await prefs.setDouble('${username}_LHC_TotalAdditionalPoints', totalAdditionalPoints);
        await prefs.setDouble('${username}_LHC_TotalBodyPosturePoints', totalBodyPosturePoints);
        await prefs.setString('${username}_LHC_StartPosture', startPosture);
        await prefs.setString('${username}_LHC_EndPosture', endPosture);
        await prefs.setString('${username}_LHC_TimeLabel', timeLabel);
        await prefs.setDouble('${username}_LHC_TimeRatingPoints', timeRatingPoints);
        await prefs.setString(
          '${username}_LHC_WeightHandlingLabel',
          weightHandlingLabel,
        );
        await prefs.setInt(
          '${username}_LHC_WeightHandlingRatingPoints',
          weightHandlingRatingPoints,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel1',
          workConditionLabel1,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel2',
          workConditionLabel2,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel3',
          workConditionLabel3,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel4',
          workConditionLabel4,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel5',
          workConditionLabel5,
        );
        await prefs.setString(
          '${username}_LHC_WorkConditionLabel6',
          workConditionLabel6,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore1',
          workConditionScore1,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore2',
          workConditionScore2,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore3',
          workConditionScore3,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore4',
          workConditionScore4,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore5',
          workConditionScore5,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionScore6',
          workConditionScore6,
        );
        await prefs.setInt(
          '${username}_LHC_WorkConditionRatingPoints',
          workConditionRatingPoints,
        );
        await prefs.setString(
          '${username}_LHC_WorkOrganizationLabel',
          workOrganizationLabel,
        );
        await prefs.setInt(
          '${username}_LHC_WorkOrganizationRatingPoints',
          workOrganizationRatingPoints,
        );
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

  Future<void> _showSaveLHCUserDialog(BuildContext context) async {
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
              await _saveLHCUserData(context, controller.text.trim());
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
            onPressed: () async => await _showSaveLHCUserDialog(context),
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
