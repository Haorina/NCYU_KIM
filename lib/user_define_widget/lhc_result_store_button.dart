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

    // 🔥 修正關鍵：定義讀取來源的前綴
    // 因為資料目前存在訪客 ID (userName) 底下，讀取時必須加上前綴
    final String sourceLHCPrefix = "${userName}_LHC_";
    final String sourceUserPrefix = "${userName}_";

    // --- 1. 從目前的訪客帳號讀取暫存資料 ---
    final String gender = prefs.getString("${sourceUserPrefix}Gender") ?? "";
    // 注意：部分欄位可能沒有 LHC 前綴，需依照你原本存入的方式讀取
    // 這裡假設 Weight 是帶有 LHC 前綴的 (參照你下方的寫入邏輯)
    final String weight = prefs.getString("${sourceLHCPrefix}Weight") ?? "";

    final int weightRatingPoints = prefs.getInt("${sourceLHCPrefix}WeightRatingPoints") ?? 0;
    final String videoPath = prefs.getString("${sourceLHCPrefix}VideoPath") ?? "";

    final double twistOrLeanPoints = prefs.getDouble("${sourceLHCPrefix}TwistOrLeanPoints") ?? 0.0;
    final double distanceOfBodyCenterPoints = prefs.getDouble("${sourceLHCPrefix}DistanceOfBodyCenterPoints") ?? 0.0;
    final double armLiftPoints = prefs.getDouble("${sourceLHCPrefix}ArmLiftPoints") ?? 0.0;
    final double aboveShoulderPoints = prefs.getDouble("${sourceLHCPrefix}AboveShoulderPoints") ?? 0.0;
    final double bodyPosturePoints = prefs.getDouble("${sourceLHCPrefix}BodyPosturePoints") ?? 0.0;
    final double totalAdditionalPoints = prefs.getDouble("${sourceLHCPrefix}TotalAdditionalPoints") ?? 0.0;

    // 🔥 這是你原本變成 0 的欄位，現在加上前綴就能讀到了
    final double totalBodyPosturePoints = prefs.getDouble("${sourceLHCPrefix}TotalBodyPosturePoints") ?? 0.0;

    final String startPosture = prefs.getString("${sourceLHCPrefix}StartPosture") ?? "";
    final String endPosture = prefs.getString("${sourceLHCPrefix}EndPosture") ?? "";

    final String timeLabel = prefs.getString('${sourceLHCPrefix}TimeLabel') ?? "";
    final double timeRatingPoints = prefs.getDouble('${sourceLHCPrefix}TimeRatingPoints') ?? 0.0;

    final String weightHandlingLabel = prefs.getString('${sourceLHCPrefix}WeightHandlingLabel') ?? "";
    final int weightHandlingRatingPoints = prefs.getInt('${sourceLHCPrefix}WeightHandlingRatingPoints') ?? 0;

    final String workConditionLabel1 = prefs.getString('${sourceLHCPrefix}WorkConditionLabel1') ?? "";
    final String workConditionLabel2 = prefs.getString('${sourceLHCPrefix}WorkConditionLabel2') ?? "";
    final String workConditionLabel3 = prefs.getString('${sourceLHCPrefix}WorkConditionLabel3') ?? "";
    final String workConditionLabel4 = prefs.getString('${sourceLHCPrefix}WorkConditionLabel4') ?? "";
    final String workConditionLabel5 = prefs.getString('${sourceLHCPrefix}WorkConditionLabel5') ?? "";
    final String workConditionLabel6 = prefs.getString('${sourceLHCPrefix}WorkConditionLabel6') ?? "";

    final int workConditionScore1 = prefs.getInt('${sourceLHCPrefix}WorkConditionScore1') ?? 0;
    final int workConditionScore2 = prefs.getInt('${sourceLHCPrefix}WorkConditionScore2') ?? 0;
    final int workConditionScore3 = prefs.getInt('${sourceLHCPrefix}WorkConditionScore3') ?? 0;
    final int workConditionScore4 = prefs.getInt('${sourceLHCPrefix}WorkConditionScore4') ?? 0;
    final int workConditionScore5 = prefs.getInt('${sourceLHCPrefix}WorkConditionScore5') ?? 0;
    final int workConditionScore6 = prefs.getInt('${sourceLHCPrefix}WorkConditionScore6') ?? 0;

    final int workConditionRatingPoints = prefs.getInt('${sourceLHCPrefix}WorkConditionRatingPoints') ?? 0;

    final String workOrganizationLabel = prefs.getString('${sourceLHCPrefix}WorkOrganizationLabel') ?? "";
    final int workOrganizationRatingPoints = prefs.getInt('${sourceLHCPrefix}WorkOrganizationRatingPoints') ?? 0;

    // --- 2. 驗證與寫入新帳號 ---
    if (newUsername.isEmpty) {
      await Fluttertoast.showToast(
        msg: "使用者名稱不能為空",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: const Color(0XFFD9D9D9),
        textColor: Colors.red,
      );
    } else {
      // 判斷是否為新使用者，如果是，加入列表
      if (!users.contains(newUsername)) {
        users.add(newUsername);
        await prefs.setStringList('LHC_Users', users);
      }

      // 不管是新舊使用者，都執行寫入 (覆蓋資料)
      // 使用 newUsername 作為新的 Key 前綴
      await prefs.setString('${newUsername}_Gender', gender);
      await prefs.setString('${newUsername}_LHC_Weight', weight);
      await prefs.setInt('${newUsername}_LHC_WeightRatingPoints', weightRatingPoints);
      await prefs.setString('${newUsername}_LHC_VideoPath', videoPath);
      await prefs.setDouble('${newUsername}_LHC_TwistOrLeanPoints', twistOrLeanPoints);
      await prefs.setDouble('${newUsername}_LHC_DistanceOfBodyCenterPoints', distanceOfBodyCenterPoints);
      await prefs.setDouble('${newUsername}_LHC_ArmLiftPoints', armLiftPoints);
      await prefs.setDouble('${newUsername}_LHC_AboveShoulderPoints', aboveShoulderPoints);
      await prefs.setDouble('${newUsername}_LHC_BodyPosturePoints', bodyPosturePoints);
      await prefs.setDouble('${newUsername}_LHC_TotalAdditionalPoints', totalAdditionalPoints);

      // 🔥 這裡寫入的就會是上面讀到的正確數值，不再是 0.0
      await prefs.setDouble('${newUsername}_LHC_TotalBodyPosturePoints', totalBodyPosturePoints);

      await prefs.setString('${newUsername}_LHC_StartPosture', startPosture);
      await prefs.setString('${newUsername}_LHC_EndPosture', endPosture);
      await prefs.setString('${newUsername}_LHC_TimeLabel', timeLabel);
      await prefs.setDouble('${newUsername}_LHC_TimeRatingPoints', timeRatingPoints);
      await prefs.setString('${newUsername}_LHC_WeightHandlingLabel', weightHandlingLabel);
      await prefs.setInt('${newUsername}_LHC_WeightHandlingRatingPoints', weightHandlingRatingPoints);

      await prefs.setString('${newUsername}_LHC_WorkConditionLabel1', workConditionLabel1);
      await prefs.setString('${newUsername}_LHC_WorkConditionLabel2', workConditionLabel2);
      await prefs.setString('${newUsername}_LHC_WorkConditionLabel3', workConditionLabel3);
      await prefs.setString('${newUsername}_LHC_WorkConditionLabel4', workConditionLabel4);
      await prefs.setString('${newUsername}_LHC_WorkConditionLabel5', workConditionLabel5);
      await prefs.setString('${newUsername}_LHC_WorkConditionLabel6', workConditionLabel6);

      await prefs.setInt('${newUsername}_LHC_WorkConditionScore1', workConditionScore1);
      await prefs.setInt('${newUsername}_LHC_WorkConditionScore2', workConditionScore2);
      await prefs.setInt('${newUsername}_LHC_WorkConditionScore3', workConditionScore3);
      await prefs.setInt('${newUsername}_LHC_WorkConditionScore4', workConditionScore4);
      await prefs.setInt('${newUsername}_LHC_WorkConditionScore5', workConditionScore5);
      await prefs.setInt('${newUsername}_LHC_WorkConditionScore6', workConditionScore6);

      await prefs.setInt('${newUsername}_LHC_WorkConditionRatingPoints', workConditionRatingPoints);
      await prefs.setString('${newUsername}_LHC_WorkOrganizationLabel', workOrganizationLabel);
      await prefs.setInt('${newUsername}_LHC_WorkOrganizationRatingPoints', workOrganizationRatingPoints);

      // 顯示成功訊息
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
    // 檢查是否為訪客 ID (這裡的邏輯是你原本的)
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