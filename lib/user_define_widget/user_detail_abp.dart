import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting_card.dart';
import '../../abp/time_rating.dart';
import '../../abp/back_load_rating.dart';
import '../../abp/shoulder_upper_limb_load_rating.dart';
import '../../abp/lower_limb_load_rating.dart';
import '../../abp/work_condition_rating.dart';
import '../../abp/result.dart';

class UserDetailAbp extends StatefulWidget {
  final String? userName;
  const UserDetailAbp({super.key, this.userName});

  @override
  State<UserDetailAbp> createState() => _UserDetailAbpState();
}

class _UserDetailAbpState extends State<UserDetailAbp> {
  late String currentUser;

  late TextEditingController _timeRatingPointsController;
  late TextEditingController _backLoadRatingPointsController;
  late TextEditingController _shoulderUpperLimbPointsController;
  late TextEditingController _lowerLimbPointsController;
  late TextEditingController _workConditionPointsController;

  bool _hasShoulderUpperLimb = false;
  bool _hasLowerLimb = false;

  @override
  void initState() {
    super.initState();
    currentUser = widget.userName ?? "vJ#CA:F3zP)C]A=V";
    _timeRatingPointsController = TextEditingController();
    _backLoadRatingPointsController = TextEditingController();
    _shoulderUpperLimbPointsController = TextEditingController();
    _lowerLimbPointsController = TextEditingController();
    _workConditionPointsController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _timeRatingPointsController.dispose();
    _backLoadRatingPointsController.dispose();
    _shoulderUpperLimbPointsController.dispose();
    _lowerLimbPointsController.dispose();
    _workConditionPointsController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // 讀取各項分數
      _timeRatingPointsController.text =
          prefs
              .getDouble('${currentUser}_ABP_TimeRatingPoints')
              ?.toString()
              .replaceAll(".0", "") ??
              '0';

      _backLoadRatingPointsController.text =
          prefs
              .getDouble('${currentUser}_ABP_BackLoadRatingPoints')
              ?.toString()
              .replaceAll(".0", "") ??
              '0';

      _shoulderUpperLimbPointsController.text =
          prefs
              .getInt('${currentUser}_ABP_ShoulderUpperLimbLoadRatingPoints')
              ?.toString() ??
              '0';

      _lowerLimbPointsController.text =
          prefs
              .getInt('${currentUser}_ABP_LowerLimbLoadRatingPoints')
              ?.toString() ??
              '0';

      _workConditionPointsController.text =
          prefs
              .getInt('${currentUser}_ABP_WorkConditionRatingPoints')
              ?.toString() ??
              '0';

      // 讀取是否有肩膀上肢和下肢評級
      _hasShoulderUpperLimb = prefs.getBool('${currentUser}_ABP_PartB') ?? false;
      _hasLowerLimb = prefs.getBool('${currentUser}_ABP_PartC') ?? false;
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
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFD9D9D9),
        centerTitle: true,
        title: Text(
          currentUser,
          style: TextStyle(
            fontSize: screenWidth * 0.056,
            fontWeight: FontWeight.w500,
          ),
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
                    SizedBox(height: screenHeight * 0.015),
                    SettingCard(
                      icon: CupertinoIcons.stopwatch_fill,
                      title: '時間評級',
                      subtitle: _timeRatingPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                ABPTimeRating(userName: currentUser),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: Icons.accessibility_new,
                      title: '背部負荷評級',
                      subtitle: _backLoadRatingPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                BackLoadRating(userName: currentUser),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    if (_hasShoulderUpperLimb)
                      SettingCard(
                        icon: Icons.back_hand,
                        title: '肩&上肢負荷評級',
                        subtitle: _shoulderUpperLimbPointsController.text,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ShoulderUpperLimbLoadRating(
                                userName: currentUser,
                              ),
                            ),
                          );
                          await _refreshData();
                        },
                      ),
                    if (_hasLowerLimb)
                      SettingCard(
                        icon: Icons.airline_seat_legroom_reduced_outlined,
                        title: '下肢負荷評級',
                        subtitle: _lowerLimbPointsController.text,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => LowerLimbLoadRating(
                                userName: currentUser,
                              ),
                            ),
                          );
                          await _refreshData();
                        },
                      ),
                    SettingCard(
                      icon: CupertinoIcons.xmark_circle_fill,
                      title: '工作條件評級',
                      subtitle: _workConditionPointsController.text,
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
                    if (_hasShoulderUpperLimb && _hasLowerLimb) ...[
                      SizedBox(height: screenHeight * 0.1),
                    ] else if(_hasShoulderUpperLimb || _hasLowerLimb) ...[
                      SizedBox(height: screenHeight * 0.2),
                    ] else...[
                      SizedBox(height: screenHeight * 0.3),
                    ],
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
