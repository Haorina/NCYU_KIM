import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class LHCResultStoreButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String userName; // 這是目前的名稱 (通常是訪客 ID)
  final Widget nextPage;

  const LHCResultStoreButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userName,
    required this.nextPage,
  });

  Future<void> _saveLHCUserData(BuildContext context, String newUsername) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('LHC_Users') ?? <String>[];

    // 🔥 強大的萬能讀取小幫手 (定義在函式內部)
    // 邏輯：優先找標準格式 -> 其次找只有 ID 的 -> 最後找原始 Key -> 都沒有回傳預設值

    double getSmartDouble(String key) {
      return prefs.getDouble("${userName}_LHC_$key") ??   // 1. 標準格式
          prefs.getDouble("${userName}_$key") ??       // 2. 漏加 LHC
          prefs.getDouble(key) ??                      // 3. 完全沒加前綴
          0.0;
    }

    int getSmartInt(String key) {
      return prefs.getInt("${userName}_LHC_$key") ??
          prefs.getInt("${userName}_$key") ??
          prefs.getInt(key) ??
          0;
    }

    String getSmartString(String key) {
      return prefs.getString("${userName}_LHC_$key") ??
          prefs.getString("${userName}_$key") ??
          prefs.getString(key) ??
          "";
    }

    // --- 1. 讀取資料 (使用小幫手，自動抓取最有可能的數值) ---

    // 基本資料
    final String gender = getSmartString("Gender");
    final String weight = getSmartString("Weight");

    // 負重評級
    final int weightRatingPoints = getSmartInt("WeightRatingPoints");

    // 身體姿勢 (BPR)
    final String videoPath = getSmartString("VideoPath");
    final double twistOrLeanPoints = getSmartDouble("TwistOrLeanPoints");
    final double distanceOfBodyCenterPoints = getSmartDouble("DistanceOfBodyCenterPoints");
    final double armLiftPoints = getSmartDouble("ArmLiftPoints");
    final double aboveShoulderPoints = getSmartDouble("AboveShoulderPoints");
    final double bodyPosturePoints = getSmartDouble("BodyPosturePoints");
    final double totalAdditionalPoints = getSmartDouble("TotalAdditionalPoints");
    final double totalBodyPosturePoints = getSmartDouble("TotalBodyPosturePoints");
    final String startPosture = getSmartString("StartPosture");
    final String endPosture = getSmartString("EndPosture");

    // 時間評級
    final String timeLabel = getSmartString("TimeLabel");
    final double timeRatingPoints = getSmartDouble("TimeRatingPoints");

    // 負荷處理
    final String weightHandlingLabel = getSmartString("WeightHandlingLabel");
    final int weightHandlingRatingPoints = getSmartInt("WeightHandlingRatingPoints");

    // 不良工作條件
    final String workConditionLabel1 = getSmartString("WorkConditionLabel1");
    final String workConditionLabel2 = getSmartString("WorkConditionLabel2");
    final String workConditionLabel3 = getSmartString("WorkConditionLabel3");
    final String workConditionLabel4 = getSmartString("WorkConditionLabel4");
    final String workConditionLabel5 = getSmartString("WorkConditionLabel5");
    final String workConditionLabel6 = getSmartString("WorkConditionLabel6");

    final int workConditionScore1 = getSmartInt("WorkConditionScore1");
    final int workConditionScore2 = getSmartInt("WorkConditionScore2");
    final int workConditionScore3 = getSmartInt("WorkConditionScore3");
    final int workConditionScore4 = getSmartInt("WorkConditionScore4");
    final int workConditionScore5 = getSmartInt("WorkConditionScore5");
    final int workConditionScore6 = getSmartInt("WorkConditionScore6");
    final int workConditionRatingPoints = getSmartInt("WorkConditionRatingPoints");

    // 工作組織
    final String workOrganizationLabel = getSmartString("WorkOrganizationLabel");
    final int workOrganizationRatingPoints = getSmartInt("WorkOrganizationRatingPoints");


    // --- 2. 寫入到新使用者的 Key (這裡保持嚴謹，存入標準格式) ---
    if (newUsername.isEmpty) {
      await Fluttertoast.showToast(
        msg: "使用者名稱不能為空",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: const Color(0XFFD9D9D9),
        textColor: Colors.red,
      );
    } else {
      if (!users.contains(newUsername)) {
        users.add(newUsername);
        await prefs.setStringList('LHC_Users', users);
      }

      // 使用 newUsername 寫入標準格式
      final String targetPrefix = "${newUsername}_LHC_";

      await prefs.setString('${newUsername}_Gender', gender);
      await prefs.setString('${targetPrefix}Weight', weight); // 統一存入 LHC 下

      await prefs.setInt('${targetPrefix}WeightRatingPoints', weightRatingPoints);

      await prefs.setString('${targetPrefix}VideoPath', videoPath);
      await prefs.setDouble('${targetPrefix}TwistOrLeanPoints', twistOrLeanPoints);
      await prefs.setDouble('${targetPrefix}DistanceOfBodyCenterPoints', distanceOfBodyCenterPoints);
      await prefs.setDouble('${targetPrefix}ArmLiftPoints', armLiftPoints);
      await prefs.setDouble('${targetPrefix}AboveShoulderPoints', aboveShoulderPoints);
      await prefs.setDouble('${targetPrefix}BodyPosturePoints', bodyPosturePoints);
      await prefs.setDouble('${targetPrefix}TotalAdditionalPoints', totalAdditionalPoints);
      await prefs.setDouble('${targetPrefix}TotalBodyPosturePoints', totalBodyPosturePoints);
      await prefs.setString('${targetPrefix}StartPosture', startPosture);
      await prefs.setString('${targetPrefix}EndPosture', endPosture);

      await prefs.setString('${targetPrefix}TimeLabel', timeLabel);
      await prefs.setDouble('${targetPrefix}TimeRatingPoints', timeRatingPoints);

      await prefs.setString('${targetPrefix}WeightHandlingLabel', weightHandlingLabel);
      await prefs.setInt('${targetPrefix}WeightHandlingRatingPoints', weightHandlingRatingPoints);

      await prefs.setString('${targetPrefix}WorkConditionLabel1', workConditionLabel1);
      await prefs.setString('${targetPrefix}WorkConditionLabel2', workConditionLabel2);
      await prefs.setString('${targetPrefix}WorkConditionLabel3', workConditionLabel3);
      await prefs.setString('${targetPrefix}WorkConditionLabel4', workConditionLabel4);
      await prefs.setString('${targetPrefix}WorkConditionLabel5', workConditionLabel5);
      await prefs.setString('${targetPrefix}WorkConditionLabel6', workConditionLabel6);

      await prefs.setInt('${targetPrefix}WorkConditionScore1', workConditionScore1);
      await prefs.setInt('${targetPrefix}WorkConditionScore2', workConditionScore2);
      await prefs.setInt('${targetPrefix}WorkConditionScore3', workConditionScore3);
      await prefs.setInt('${targetPrefix}WorkConditionScore4', workConditionScore4);
      await prefs.setInt('${targetPrefix}WorkConditionScore5', workConditionScore5);
      await prefs.setInt('${targetPrefix}WorkConditionScore6', workConditionScore6);

      await prefs.setInt('${targetPrefix}WorkConditionRatingPoints', workConditionRatingPoints);

      await prefs.setString('${targetPrefix}WorkOrganizationLabel', workOrganizationLabel);
      await prefs.setInt('${targetPrefix}WorkOrganizationRatingPoints', workOrganizationRatingPoints);

      await Fluttertoast.showToast(
        msg: "已保存 $newUsername 的檢測紀錄",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: const Color(0xff7392ff),
      );
    }
  }

  Future<void> _showSaveLHCUserDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
    return userName == "vJ#CA:F3zP)C]A=V"
        ? SizedBox(
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
                style: TextStyle(
                    fontSize: screenWidth * 0.044, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    )
        : SizedBox();
  }
}