import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'homepage/start_test.dart';
import 'general/select_item.dart';
import 'homepage/test_record.dart';
import 'homepage/about.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HomePage());
}

Widget button(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    String text,
    Color bgColor,
    Color textColor,
    Color clickColor,
    Widget nextPage,
    ) {
  return Builder(
    builder:
        (context) => Container(
      width: screenWidth * 0.22,
      height: screenHeight * 0.12,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.06),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 10.0,
            spreadRadius: 1,
            color: const Color(0xFF999999),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          side: BorderSide(color: Colors.black, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          overlayColor: clickColor,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        child:
        text == "開始檢測"
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: screenWidth * 0.015),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: screenWidth * 0.026,
              ),
              textAlign: TextAlign.center,
            ),
            Icon(
              Icons.play_arrow_outlined,
              size: screenWidth * 0.04,
              color: Colors.white,
            ),
          ],
        )
            : Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.026,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      builder:
          (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bgi.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.2),
                  Container(
                    height: screenHeight * 0.2,
                    width: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.15),
                  button(
                    context,
                    screenWidth,
                    screenHeight,
                    "開始檢測",
                    Colors.black,
                    Colors.white,
                    Colors.white,
                    SelectItem(),
                  ),
                  button(
                    context,
                    screenWidth,
                    screenHeight,
                    "檢測紀錄",
                    Colors.white,
                    Colors.black,
                    Colors.black,
                    TestRecord(),
                  ),
                  button(
                    context,
                    screenWidth,
                    screenHeight,
                    "關於",
                    Colors.white,
                    Colors.black,
                    Colors.black,
                    About(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    /*
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bgi.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.2),
              Container(
                height: screenHeight * 0.2,
                width: screenHeight * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.15),
              button(
                context,
                screenWidth,
                screenHeight,
                "開始檢測",
                Colors.black,
                Colors.white,
                Colors.white,
                SelectItem(),
                //StartTest(),
              ),
              button(
                context,
                screenWidth,
                screenHeight,
                "檢測紀錄",
                Colors.white,
                Colors.black,
                Colors.black,
                TestRecord(),
              ),
              button(
                context,
                screenWidth,
                screenHeight,
                "關於",
                Colors.white,
                Colors.black,
                Colors.black,
                About(),
              ),
            ],
          ),
        ),
      ),
    );
    */
  }
}
