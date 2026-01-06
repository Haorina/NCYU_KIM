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
    setState(() {
      _videoPath = prefs.getString('${currentUser}_LHC_VideoPath') ?? '';
      _weightRatingPointsController.text =
          prefs.getInt('${currentUser}_LHC_WeightRatingPoints')?.toString() ?? '0';
      _totalBodyPosturePointsController.text =
          prefs
              .getDouble('${currentUser}_LHC_TotalBodyPosturePoints')
              ?.toString()
              .replaceAll(".0", "") ??
              '0';
      _timeRatingPointsController.text =
          prefs
              .getDouble('${currentUser}_LHC_TimeRatingPoints')
              ?.toString()
              .replaceAll(".0", "") ??
              '0';
      _weightHandlingRatingPointsController.text =
          prefs.getInt('${currentUser}_LHC_WeightHandlingRatingPoints')?.toString() ?? '0';
      _workConditionRatingPointsController.text =
          prefs.getInt('${currentUser}_LHC_WorkConditionRatingPoints')?.toString() ?? '0';
      _workOrganizationRatingPointsController.text =
          prefs.getInt('${currentUser}_LHC_WorkOrganizationRatingPoints')?.toString() ??
              '0';
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
