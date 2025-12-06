import 'package:flutter/material.dart';
import '../user_define_widget/score_bar.dart';

class ResultTitle extends StatelessWidget {
  const ResultTitle({
    super.key,
    required this.resultScore,
    required this.screenWidth,
    required this.screenHeight,
    required this.maxScore,
  });

  final num resultScore;
  final num maxScore;
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
      height: screenHeight * 0.24,
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
              "風險等級分數",
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
          ScoreBar(
            currentScore: resultScore,
            textSize: screenWidth * 0.038,
            maxScore: maxScore,
            barSize: screenHeight * 0.016,
            scoreBarWidth: 0.85,
            backgroundColor: const Color(0xFFD9D9D9),
            valueColor:
                resultScore < 20
                    ? const Color(0xFF38A63D)
                    : resultScore < 50
                    ? const Color(0xFFBFFF00)
                    : resultScore < 100
                    ? const Color(0xFFFF753E)
                    : const Color(0xFFF10000),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: screenWidth * 0.046),
                child: Text(
                  resultScore.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: screenHeight * 0.043,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: screenHeight * 0.01,
                  left: screenWidth * 0.04,
                ),
                child: Text(
                  "分",
                  style: TextStyle(
                    fontSize: screenWidth * 0.043,
                    color: const Color(0xFF716464),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: screenHeight * 0.013,
                  left: screenWidth * 0.01,
                ),
                child: IconButton(
                  icon: Image.asset("assets/images/help-circle.png"),
                  iconSize: screenWidth * 0.05,
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
                          (context, animation, secondaryAnimation) => Center(
                        child: Container(
                          width: screenWidth * 0.85,
                          height: screenHeight * 0.29,
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
                                      width: screenWidth * 0.69,
                                      margin: EdgeInsets.only(
                                        left: screenWidth * 0.03,
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
                                  bottom: screenHeight * 0.01,
                                ),
                                color: const Color(0XCCEFEFEF),
                              ),
                              Center(
                                child: SizedBox(
                                  width: screenWidth * 0.75,
                                  child: Image.asset("assets/images/scoreCal.png"),
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
                          child: ScaleTransition(scale: curved, child: child),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          if (resultScore < 20) ...[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: screenHeight * 0.008,
                left: screenWidth * 0.04,
              ),
              child: Text(
                "負荷強度 : 低",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: screenWidth * 0.038,
                  color: const Color(0xFF7A6E6E),
                ),
              ),
            ),
          ] else if (resultScore > 19 && resultScore < 50) ...[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: screenHeight * 0.008,
                left: screenWidth * 0.04,
              ),
              child: Text(
                "負荷強度 : 中",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: screenWidth * 0.038,
                  color: const Color(0xFF7A6E6E),
                ),
              ),
            ),
          ] else if (resultScore > 49 && resultScore < 100) ...[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: screenHeight * 0.008,
                left: screenWidth * 0.04,
              ),
              child: Text(
                "負荷強度 : 中高",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: screenWidth * 0.038,
                  color: const Color(0xFF7A6E6E),
                ),
              ),
            ),
          ] else ...[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: screenHeight * 0.008,
                left: screenWidth * 0.04,
              ),
              child: Text(
                "負荷強度 : 高",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: screenWidth * 0.038,
                  color: const Color(0xFF7A6E6E),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
