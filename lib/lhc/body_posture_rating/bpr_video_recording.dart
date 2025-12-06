import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'bpr_video_analysing.dart';
import '../../user_define_widget/progress_bar.dart';
import '../../main.dart';

class LHCVideoRecording extends StatefulWidget {
  final List<CameraDescription> camera;

  const LHCVideoRecording({super.key, required this.camera});

  @override
  State<LHCVideoRecording> createState() => _LHCVideoRecordingState();
}

class VideoSelection {
  Future<void> pickVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BPRVideoAnalysing(videoPath: video.path),
          ),
        );
      }
    }
  }
}

class _LHCVideoRecordingState extends State<LHCVideoRecording> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCameraIdx = 0;
  bool _isRecording = false;
  final VideoSelection _videoSelector = VideoSelection();

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera[selectedCameraIdx],
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> toggleRecording(BuildContext context) async {
    if (_isRecording) {
      final file = await _controller.stopVideoRecording();
      final tempDir = await getTemporaryDirectory(); // ✅ 改這裡
      final videoPath = '${tempDir.path}/${DateTime.now().toIso8601String()}.mp4';
      await file.saveTo(videoPath);

// 等待檔案穩定
      await Future.delayed(const Duration(milliseconds: 300));

      await Gal.putVideo(videoPath, album: "KIM_VID");

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BPRVideoAnalysing(videoPath: videoPath),
          ),
        );
      }

    } else {
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  void onSwitchCamera() {
    selectedCameraIdx = (selectedCameraIdx == 0) ? 1 : 0;

    _controller = CameraController(
      widget.camera[selectedCameraIdx],
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('攝影機切換失敗: $e')),
        );
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    double bottomPadding = MediaQuery.paddingOf(context).bottom;

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        return Container(
          color: const Color(0xFFEFEFEF),
          child: SafeArea(
            top: true,
            bottom: true,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: screenWidth * 0.086),
                    Text(
                      "姿勢拍攝",
                      style: TextStyle(
                        fontSize: screenWidth * 0.056,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Image.asset("assets/images/help-circle.png"),
                      iconSize: screenWidth * 0.056,
                      color: Colors.black,
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel:
                          MaterialLocalizations.of(
                            context,
                          ).modalBarrierDismissLabel,
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (
                              context,
                              animation,
                              secondaryAnimation,
                              ) => Center(
                            child: Container(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.15,
                              decoration: BoxDecoration(
                                color: const Color(0XCC101010),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.038,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: screenWidth * 0.44,
                                          margin: EdgeInsets.only(
                                            top: screenHeight * 0.008,
                                            left: screenWidth * 0.03,
                                          ),
                                          child: Text(
                                            "拍攝建議",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.045,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                              TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: screenHeight * 0.004,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                              size: screenWidth * 0.06,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: screenHeight * 0.001,
                                    margin: EdgeInsets.only(
                                      top: screenHeight * 0.01,
                                      bottom: screenHeight * 0.02,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0XCCFFFFFF),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "拍攝角度建議為側面\n人體請全程入境",
                                      style: TextStyle(
                                        fontSize:
                                        screenWidth * 0.04,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        decoration:
                                        TextDecoration.none,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          transitionBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                              ) {
                            final curved = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            );
                            return FadeTransition(
                              opacity: curved,
                              child: ScaleTransition(
                                scale: curved,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFEFEFEF),
                actions: [
                  IconButton(
                    icon: Icon(Icons.home_outlined),
                    iconSize: screenWidth * 0.068,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
              body:
              snapshot.connectionState == ConnectionState.done &&
                  _controller.value.isInitialized
                  ? Container(
                color: const Color(0xFFEFEFEF),
                child: Column(
                  children: [
                    ProgressBar(
                      currentStep: 2,
                      totalStep: 7,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Expanded(
                      child: SizedBox(
                        width: screenWidth,
                        child: CameraPreview(_controller),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.018),
                    Row(
                      children: [
                        SizedBox(width: screenWidth * 0.058),
                        IconButton(
                          icon: Icon(
                            Icons.photo_library,
                            size: screenWidth * 0.12,
                            color: Colors.black,
                          ),
                          onPressed:
                              () => _videoSelector.pickVideo(context),
                        ),
                        SizedBox(width: screenWidth * 0.2),
                        Center(
                          child: GestureDetector(
                            onTap: () => toggleRecording(context),
                            child: Container(
                              width: screenWidth * 0.18,
                              height: screenHeight * 0.076,
                              decoration: BoxDecoration(
                                color:
                                _isRecording
                                    ? Colors.red
                                    : Colors.black87,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isRecording ? Icons.stop : Icons.videocam,
                                color: const Color(0xFFEFEFEF),
                                size: screenWidth * 0.12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.19),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.arrow_2_circlepath,
                            size: screenWidth * 0.12,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            await _controller.dispose();
                            onSwitchCamera();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "鏡頭準備中...",
                      style: TextStyle(
                        fontSize: screenWidth * 0.066,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    LoadingAnimationWidget.waveDots(
                      color: const Color(0xff808080),
                      size: screenWidth * 0.25,
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