import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final num currentStep;
  final num totalStep;
  final double screenWidth;
  final double screenHeight;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalStep,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.02,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, screenHeight * 0.0066),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.08)),
              child: LinearProgressIndicator(
                value: totalStep != 0 ? currentStep / totalStep : 0,
                valueColor: AlwaysStoppedAnimation(Color(0xFF000000)),
                backgroundColor: Color(0xFFFFFFFF),
                minHeight: screenWidth * 0.016,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(screenWidth * 0.88, 0),
            child: Container(
              width: screenWidth * 0.096,
              height: screenHeight * 0.02,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "${currentStep.toString()} / ${totalStep.toString()}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.03,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
