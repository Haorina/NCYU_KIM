import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isSaved = false;

class BMResultStoreButton extends StatelessWidget {
  const BMResultStoreButton({
    super.key,
    required this.nextPage,
    required this.screenWidth,
    required this.screenHeight,
  });

  final Widget? nextPage;
  final double screenWidth;
  final double screenHeight;

  Future<void> _saveUserData(BuildContext context, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList("BM_Users") ?? [];
    if (username == "") {
      await Fluttertoast.showToast(
        msg: "使用者名稱不能為空",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0XFFD9D9D9),
        textColor: Colors.red,
        fontSize: screenWidth * 0.043,
      );
    } else if (!users.contains(username)) {
      users.add(username);
      await prefs.setStringList('BM_Users', users);
      await Fluttertoast.showToast(
        msg: "測驗紀錄已儲存",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: const Color(0xff7392ff),
        fontSize: screenWidth * 0.043,
      );

      isSaved = true;

      if (!context.mounted) {
        return;
      }
    } else if (users.contains(username)) {
      await Fluttertoast.showToast(
        msg: "使用者名稱已存在",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.red,
        fontSize: screenWidth * 0.043,
      );
    }
  }

  Future<void> _showSaveABPUserDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "保存測驗紀錄",
            style: TextStyle(fontSize: screenWidth * 0.043),
          ),
          backgroundColor: const Color(0XFFD9D9D9),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "輸入名字"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "保存",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * 0.038,
                  color: Colors.black87,
                ),
              ),
              onPressed: () async {
                await _saveUserData(context, controller.text);

                if (isSaved) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            TextButton(
              child: Text(
                "取消",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * 0.038,
                  color: Colors.black87,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              await _showSaveABPUserDialog(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.008),
            ),
            child: SizedBox(
              width: screenWidth * 0.28,
              height: screenHeight * 0.026,
              child: Text(
                "儲存紀錄",
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.14),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => nextPage!),
                    (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.008),
            ),
            child: SizedBox(
              width: screenWidth * 0.28,
              height: screenHeight * 0.026,
              child: Text(
                "返回首頁",
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: Colors.white,
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
