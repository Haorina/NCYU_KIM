import 'package:flutter/material.dart';
import '../general/select_item.dart';

class StartTest extends StatelessWidget {
  const StartTest({super.key});

  Widget onTapWidget(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      String text,
      Widget nextPage,
      ) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
            );
          },
          child: Container(
            height: screenHeight * 0.08,
            margin: EdgeInsets.only(
              top: screenHeight * 0.02,
              left: screenWidth * 0.06,
              right: screenWidth * 0.06,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.black87),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 1.0,
                  spreadRadius: 1,
                  color: const Color(0xFF999999),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showSelectDialog(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      String text,
      ) {
    return Builder(
      builder:
          (context) => InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
              backgroundColor: const Color(0xFFD9D9D9),
              title: Text(
                "選擇檢測項目",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * 0.056,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: screenHeight * 0.26,
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    onTapWidget(
                      context,
                      screenWidth,
                      screenHeight,
                      "快速選擇",
                      SelectItem(),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    onTapWidget(
                      context,
                      screenWidth,
                      screenHeight,
                      "選擇項目",
                      SelectItem(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    '返回',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.0426,
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
        },
        child: Container(
          height: screenHeight * 0.076,
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: screenHeight * 0.012,
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.058,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget addNewTest(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      ) {
    return Builder(
      builder:
          (context) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectItem()),
          );
        },
        child: Container(
          height: screenHeight * 0.076,
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: screenHeight * 0.012,
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "新增檢測",
            style: TextStyle(
              fontSize: screenWidth * 0.058,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      color: const Color(0xFFD9D9D9),
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "新增檢測 / 選擇紀錄",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenWidth * 0.056,
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFFD9D9D9),
          ),
          body: Container(
            color: const Color(0xFFD9D9D9),
            height: screenHeight,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                /*暫時先不用*/
                //showSelectDialog(context, screenWidth, screenHeight, "新增檢測"),
                addNewTest(context, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.012,
                  ),
                  child: Text(
                    "選擇使用者",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 3),
                          blurRadius: 14.0,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
