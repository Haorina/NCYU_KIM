import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting_card.dart';
import '../../lhc/time_rating.dart';
import '../../lhc/weight_rating.dart';
import '../../lhc/weight_handling_rating.dart';
import '../../lhc/work_condition_rating.dart';
import '../../lhc/work_organization_rating.dart';
import '../../lhc/body_posture_rating/bpr_result.dart';
import '../../lhc/result.dart';
import '../homepage/test_record.dart';

class UserDetailLhc extends StatefulWidget {
  final String? userName;
  const UserDetailLhc({super.key, this.userName});

  @override
  State<UserDetailLhc> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetailLhc> {
  late String currentUser;
  late TextEditingController _weightRatingPointsController;
  late TextEditingController _totalBodyPosturePointsController;
  late TextEditingController _timeRatingPointsController;
  late TextEditingController _weightHandlingRatingPointsController;
  late TextEditingController _workConditionRatingPointsController;
  late TextEditingController _workOrganizationRatingPointsController;
  String _videoPath = "";

  @override
  void initState() {
    super.initState();
    currentUser = widget.userName ?? "vJ#CA:F3zP)C]A=V";
    _weightRatingPointsController = TextEditingController();
    _totalBodyPosturePointsController = TextEditingController();
    _timeRatingPointsController = TextEditingController();
    _weightHandlingRatingPointsController = TextEditingController();
    _workConditionRatingPointsController = TextEditingController();
    _workOrganizationRatingPointsController = TextEditingController();
    _loadUserData();
    _refreshData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 輔助函式：不管原本存什麼型態，都安全地轉成 String，並去掉 .0
    String getValue(String key) {
      Object? value = prefs.get(key); // 使用通用 get
      if (value == null) return '0';

      String strValue = value.toString();
      // 如果是 15.0 這種格式，去掉 .0 變成 15
      if (strValue.endsWith('.0')) {
        return strValue.replaceAll('.0', '');
      }
      return strValue;
    }

    setState(() {
      _videoPath = prefs.getString('${currentUser}_LHC_VideoPath') ?? '';

      // 使用新的通用讀取方式，解決型態錯誤導致顯示 0 的問題
      _weightRatingPointsController.text =
          getValue('${currentUser}_LHC_WeightRatingPoints');

      _totalBodyPosturePointsController.text =
          getValue('${currentUser}_LHC_TotalBodyPosturePoints');

      _timeRatingPointsController.text =
          getValue('${currentUser}_LHC_TimeRatingPoints');

      _weightHandlingRatingPointsController.text =
          getValue('${currentUser}_LHC_WeightHandlingRatingPoints');

      _workConditionRatingPointsController.text =
          getValue('${currentUser}_LHC_WorkConditionRatingPoints');

      _workOrganizationRatingPointsController.text =
          getValue('${currentUser}_LHC_WorkOrganizationRatingPoints');
    });
  }

  Future<void> _refreshData() async {
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFD9D9D9),
        centerTitle: true,
        title: Text(
          currentUser,
          style: TextStyle(fontSize: screenWidth * 0.056, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestRecord(),
              ),
            );
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          image: DecorationImage(
            image: AssetImage("assets/images/bgi.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.015,),
                    SettingCard(
                      icon: CupertinoIcons.cube_box_fill,
                      title: '負重評級',
                      subtitle: _weightRatingPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                WeightRating(userName: currentUser),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: Icons.accessibility_new,
                      title: '身體姿勢',
                      subtitle: _totalBodyPosturePointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BPRResult(
                              userName: currentUser,
                              videoPath: _videoPath,
                              reRecord: false,
                            ),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: CupertinoIcons.stopwatch_fill,
                      title: '時間評級',
                      subtitle: _timeRatingPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TimeRating(userName: currentUser),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: Icons.back_hand,
                      title: '負荷處理條件',
                      subtitle: _weightHandlingRatingPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                WeightHandlingRating(userName: currentUser),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: CupertinoIcons.xmark_circle_fill,
                      title: '不良工作條件',
                      subtitle: _workConditionRatingPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                WorkConditionRating(userName: currentUser),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: Icons.handyman,
                      title: '工作時間分配',
                      subtitle: _workOrganizationRatingPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WorkOrganizationRating(
                              userName: currentUser,
                            ),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: screenWidth * 0.36,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => Result(userName: currentUser),
                            ),
                          );
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
                            Text(
                              "評估結果",
                              style: TextStyle(
                                fontSize: screenWidth * 0.049,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
