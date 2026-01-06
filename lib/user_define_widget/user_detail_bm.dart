import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting_card.dart';
import '../../bm/time_rating.dart';
import '../../bm/body_movement_a_rating.dart';
import '../../bm/body_movement_b_rating.dart';
import '../../bm/load_weight_position_rating.dart';
import '../../bm/body_posture_rating.dart';
import '../../bm/work_condition_rating.dart';
import '../../bm/road_condition_rating.dart';
import '../../bm/work_organization_rating.dart';
import '../../bm/result.dart';

class UserDetailBm extends StatefulWidget {
  final String? userName;
  const UserDetailBm({super.key, this.userName});

  @override
  State<UserDetailBm> createState() => _UserDetailBmState();
}

class _UserDetailBmState extends State<UserDetailBm> {
  late TextEditingController _timeRatingPointsController;
  late TextEditingController _bodyMovementAPointsController;
  late TextEditingController _loadWeightPositionPointsController;
  late TextEditingController _bodyPosturePointsController;
  late TextEditingController _workConditionPointsController;
  late TextEditingController _bodyMovementBPointsController;
  late TextEditingController _roadConditionPointsController;
  late TextEditingController _workOrganizationPointsController;
  String loadWeightText = "無 / < 3";
  String transportationWeightLabel = "≤ 50";
  bool _haveTransportation = false;
  bool _onlyTransportation = false;
  late String currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.userName ?? "vJ#CA:F3zP)C]A=V";
    _timeRatingPointsController = TextEditingController();
    _bodyMovementAPointsController = TextEditingController();
    _loadWeightPositionPointsController = TextEditingController();
    _bodyPosturePointsController = TextEditingController();
    _workConditionPointsController = TextEditingController();
    _bodyMovementBPointsController = TextEditingController();
    _roadConditionPointsController = TextEditingController();
    _workOrganizationPointsController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _timeRatingPointsController.dispose();
    _bodyMovementAPointsController.dispose();
    _loadWeightPositionPointsController.dispose();
    _bodyPosturePointsController.dispose();
    _workConditionPointsController.dispose();
    _bodyMovementBPointsController.dispose();
    _roadConditionPointsController.dispose();
    _workOrganizationPointsController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // 讀取各項分數
      _timeRatingPointsController.text =
          prefs
              .getDouble('${currentUser}_BM_TimeRatingPoints')
              ?.toString()
              .replaceAll(".0", "") ??
              '0';

      _bodyMovementAPointsController.text =
          prefs
              .getInt('${currentUser}_BM_BodyMovementARatingPoints')
              ?.toString() ??
              '0';

      _loadWeightPositionPointsController.text =
          prefs
              .getInt('${currentUser}_BM_LoadWeightPositionRatingPoints')
              ?.toString() ??
              '0';

      _bodyPosturePointsController.text =
          prefs.getInt('${currentUser}_BM_BodyPostureRatingPoints')?.toString() ??
              '0';

      _workConditionPointsController.text =
          prefs
              .getInt('${currentUser}_BM_WorkConditionRatingPoints')
              ?.toString() ??
              '0';

      _bodyMovementBPointsController.text =
          prefs
              .getInt('${currentUser}_BM_BodyMovementBRatingPoints')
              ?.toString() ??
              '0';

      _roadConditionPointsController.text =
          prefs
              .getInt('${currentUser}_BM_RoadConditionRatingPoints')
              ?.toString() ??
              '0';

      _workOrganizationPointsController.text =
          prefs
              .getInt('${currentUser}_BM_WorkOrganizationRatingPoints')
              ?.toString() ??
              '0';
      loadWeightText = prefs.getString('${currentUser}_BM_WeightLabel') ?? "";
      transportationWeightLabel =
          prefs.getString('${currentUser}_BM_TransportationWeightLabel') ?? "";
      // 讀取是否有交通工具
      _haveTransportation =
          prefs.getBool('${currentUser}_BM_HaveTransportation') ?? false;
      _onlyTransportation =
          prefs.getBool('${currentUser}_BM_OnlyTransportation') ?? false;
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
                                BMTimeRating(userName: currentUser),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    if (!_onlyTransportation) ...[
                      SettingCard(
                        icon: Icons.directions_run,
                        title: '活動評級-A',
                        subtitle: _bodyMovementAPointsController.text,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BodyMovementA(
                                haveTransportation: _haveTransportation,
                                userName: currentUser,
                              ),
                            ),
                          );
                          await _refreshData();
                        },
                      ),
                    ],
                    if (!_onlyTransportation) ...[
                      SettingCard(
                        icon: CupertinoIcons.cube_box_fill,
                        title: '重物重心評級',
                        subtitle: _loadWeightPositionPointsController.text,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => LoadWeightPosition(
                                haveTransportation: _haveTransportation,
                                loadWeightText: loadWeightText,
                                userName: currentUser,
                              ),
                            ),
                          );
                          await _refreshData();
                        },
                      ),
                    ],
                    if (!_onlyTransportation) ...[
                      SettingCard(
                        icon: Icons.accessibility_new,
                        title: '身體姿勢',
                        subtitle: _bodyPosturePointsController.text,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BodyPostureRating(
                                haveTransportation: _haveTransportation,
                                loadWeightText: loadWeightText,
                                userName: currentUser,
                              ),
                            ),
                          );
                          await _refreshData();
                        },
                      ),
                    ],
                    if (!_onlyTransportation) ...[
                      SettingCard(
                        icon: CupertinoIcons.xmark_circle_fill,
                        title: '不良工作條件',
                        subtitle: _workConditionPointsController.text,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WorkConditionRating(
                                haveTransportation: _haveTransportation,
                                userName: currentUser,
                              ),
                            ),
                          );
                          await _refreshData();
                        },
                      ),
                    ],
                    if (_haveTransportation || _onlyTransportation) ...[
                      SettingCard(
                        icon: Icons.directions_bike,
                        title: '活動評級-B',
                        subtitle: _bodyMovementBPointsController.text,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BodyMovementB(
                                haveTransportation: _haveTransportation,
                                userName: currentUser,
                              ),
                            ),
                          );
                          await _refreshData();
                        },
                      ),
                      if (_haveTransportation || _onlyTransportation) ...[
                        SettingCard(
                          icon: Icons.terrain,
                          title: '路況評級',
                          subtitle: _roadConditionPointsController.text,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RoadConditionRating(
                                  haveTransportation: _haveTransportation,
                                  weightText: transportationWeightLabel,
                                  userName: currentUser,
                                ),
                              ),
                            );
                            await _refreshData();
                          },
                        ),
                      ],
                    ],
                    SettingCard(
                      icon: Icons.handyman,
                      title: '工作時間分配',
                      subtitle: _workOrganizationPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WorkOrganizationRating(
                              haveTransportation: _haveTransportation,
                              userName: currentUser,
                            ),
                          ),
                        );
                        await _refreshData();
                      },
                    ),
                    if (_onlyTransportation) ...[
                      SizedBox(height: screenHeight * 0.22),
                    ] else if (_haveTransportation) ...[
                      SizedBox(height: screenHeight * 0.02),
                    ] else ...[
                      SizedBox(height: screenHeight * 0.02),
                    ],
                    SizedBox(
                      width: screenWidth * 0.36,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => Result(
                                userName: currentUser,
                                haveTransportation: _haveTransportation,
                              ),
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
                    if (_haveTransportation) ...[
                      SizedBox(height: screenHeight * 0.02),
                    ]
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
