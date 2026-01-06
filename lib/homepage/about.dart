import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

Widget expansionTileWidget(String titleText, double screenWidth, double screenHeight) {
  return Theme(
    data: ThemeData().copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      title: Text(
        titleText,
        style: TextStyle(fontWeight: FontWeight.w200, fontSize: screenWidth * 0.053),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            "Some text",
            style: TextStyle(fontSize: screenWidth * 0.052),
          ),
        ),
      ],
    ),
  );
}

class _AboutState extends State<About> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveServerIP(String serverIP, double screenWidth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!serverIP.startsWith("http")) {
      serverIP = "http://$serverIP";
    }
    if (!serverIP.contains(":")) {
      serverIP = "$serverIP:8080";
    }

    await prefs.setString("ServerIP", serverIP);

    Fluttertoast.showToast(
      msg: '已儲存 Server IP: $serverIP',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.blue,
      fontSize: screenWidth * 0.04,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "關於",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.056),
        ),
        backgroundColor: const Color(0xFFD9D9D9),
      ),
      body: Container(
        color: const Color(0xFFD9D9D9),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.01),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
                child: Text(
                  "關於作者",
                  style: TextStyle(
                    fontSize: screenWidth * 0.054,
                    color: const Color(0xFF999999),
                    shadows: [
                      Shadow(
                        offset: Offset(1, 3),
                        blurRadius: 20,
                        color: const Color(0xFF999999),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              expansionTileWidget("作者資訊" /*""*/, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.05),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
                child: Text(
                  "關於 KIM RISK ASSESSMENT APP",
                  style: TextStyle(
                    fontSize: screenWidth * 0.054,
                    color: const Color(0xFF999999),
                    shadows: [
                      Shadow(
                        offset: Offset(1, 3),
                        blurRadius: 20,
                        color: const Color(0xFF999999),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              expansionTileWidget("資料來源" /*""*/, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.05),
              expansionTileWidget("相關技術" /*""*/, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.05),
              expansionTileWidget("問題回報" /*""*/, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.05),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
                child: Text(
                  "Server IP 設定",
                  style: TextStyle(
                    fontSize: screenWidth * 0.054,
                    color: const Color(0xFF999999),
                    shadows: [
                      Shadow(
                        offset: Offset(1, 3),
                        blurRadius: 20,
                        color: const Color(0xFF999999),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: '請輸入 Server IP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.036,
                          vertical: screenHeight * 0.01,
                        ), // 內邊距
                      ),
                      onPressed: () {
                        _saveServerIP(_controller.text, screenWidth);
                      },
                      child: Text('儲存'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
