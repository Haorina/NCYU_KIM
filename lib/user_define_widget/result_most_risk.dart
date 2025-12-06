import 'package:flutter/material.dart';
import '../user_define_widget/score_bar.dart';

class ResultMostRisk extends StatelessWidget {
  const ResultMostRisk({
    super.key,
    required this.totalScore,
    required this.mostRiskText,
    required this.mostRiskScore,
    required this.screenWidth,
    required this.screenHeight,
  });

  final num totalScore;
  final List<String> mostRiskText;
  final List<num> mostRiskScore;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.white),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 1.0,
            spreadRadius: 1,
            color: const Color(0x10000000),
          ),
        ],
      ),
      width: screenWidth * 0.9,
      height: screenHeight * 0.3,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              top: screenHeight * 0.01,
              left: screenWidth * 0.04,
              bottom: screenHeight * 0.01,
            ),
            child: Text(
              "最高風險評級(不含時間評級)",
              style: TextStyle(
                fontSize: screenWidth * 0.043,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.001,
            margin: EdgeInsets.only(bottom: screenHeight * 0.01),
            decoration: BoxDecoration(color: const Color(0xFFC2C2C2)),
          ),
          for (int i = 0; i < 3; i++) ...[
            SizedBox(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: screenWidth * 0.04),
                    child: Text(
                      totalScore != 0
                          ? "${mostRiskText[i]} ${(mostRiskScore[i] / totalScore * 100).toInt()}%"
                          : "${mostRiskText[i]} ${0}%",
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ScoreBar(
                    currentScore: mostRiskScore[i],
                    textSize: screenWidth * 0.038,
                    maxScore: totalScore,
                    barSize: screenHeight * 0.01,
                    scoreBarWidth: 0.85,
                    backgroundColor: const Color(0xFFD9D9D9),
                    valueColor:
                        i == 0
                            ? const Color(0xFFF10000)
                            : i == 1
                            ? const Color(0xFFFF753E)
                            : const Color(0xFFFFD500),

                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
