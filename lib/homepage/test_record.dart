import 'package:flutter/material.dart';
import 'package:ncyu_kim/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_define_widget/user_detail_lhc.dart';
import '../user_define_widget/user_detail_abp.dart';
import '../user_define_widget/user_detail_bm.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TestRecord extends StatefulWidget {
  const TestRecord({super.key});

  @override
  State<TestRecord> createState() => _TestRecordState();
}

class _TestRecordState extends State<TestRecord> {
  List<Map<String, String>> users = [];
  List<Map<String, String>> filteredUsers = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
  //  載入所有使用者清單
  Future<void> _loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final allUsernames =
    {
      ...(prefs.getStringList('LHC_Users') ?? []),
      ...(prefs.getStringList('ABP_Users') ?? []),
      ...(prefs.getStringList('BM_Users') ?? []),
    }.toList();

    final loadedUsers =
    allUsernames.map((username) {
      final gender = prefs.getString('${username}_Gender') ?? "male";
      return {"username": username, "gender": gender};
    }).toList();

    setState(() {
      users = loadedUsers;
      filteredUsers = List.from(users); // 🔹 確保搜尋初始狀態一致
    });
  }

  void _filterUsers(String query) {
    setState(() {
      searchQuery = query.trim().toLowerCase();

      if (searchQuery.isEmpty) {
        // 顯示全部
        filteredUsers = List.from(users);
      } else {
        filteredUsers =
            users.where((user) {
              final name = user["username"]?.toLowerCase() ?? "";
              return name.contains(searchQuery);
            }).toList();
      }
    });
  }

  void _showEditNameDialog(
      BuildContext context,
      int index,
      String oldUsername,
      double screenWidth,
      double screenHeight,
      ) {
    TextEditingController controller = TextEditingController(text: oldUsername);
    String? errorText; // 用來顯示錯誤訊息

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // 使用 StatefulBuilder 來局部更新錯誤訊息
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                '修改使用者名稱',
                style: TextStyle(fontSize: screenWidth * 0.056),
              ),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "輸入新名稱",
                  errorText: errorText, // 顯示錯誤訊息
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    String newUsername = controller.text.trim();

                    // 1. 檢查是否沒變或為空
                    if (newUsername.isEmpty || newUsername == oldUsername) {
                      Navigator.pop(context);
                      return;
                    }

                    // 2. 檢查新名稱是否已存在 (避免資料覆蓋)
                    // 從目前的 users 列表檢查
                    bool isExist = users.any((u) => u['username'] == newUsername);
                    if (isExist) {
                      setStateDialog(() {
                        errorText = "此名稱已存在，請換一個";
                      });
                      return;
                    }

                    // 3. 執行更新
                    // 顯示讀取圈圈或直接關閉
                    Navigator.pop(context); // 先關閉對話框
                    await _updateUsername(oldUsername, newUsername);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('已將 $oldUsername 修改為 $newUsername')),
                      );
                    }
                  },
                  child: const Text('修改', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  // 刪除使用者紀錄（含各模組分數）
  Future<void> _deleteUser(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 注意：這裡要從 filteredUsers 拿名字，因為使用者可能正在搜尋狀態下操作
    String username = filteredUsers[index]["username"]!;

    // 1️⃣ 刪除該使用者所有相關的 key (以 "username_" 開頭的)
    final Set<String> keys = prefs.getKeys();
    String prefix = "${username}_";

    for (String key in keys) {
      if (key.startsWith(prefix)) {
        await prefs.remove(key);
      }
    }

    // 2️⃣ 分模組更新對應的使用者清單 (移除名字)
    final List<String> listKeys = ['LHC_Users', 'ABP_Users', 'BM_Users'];
    for (String listKey in listKeys) {
      List<String> userList = prefs.getStringList(listKey) ?? [];
      if (userList.contains(username)) {
        userList.remove(username);
        await prefs.setStringList(listKey, userList);
      }
    }

    // 3️⃣ 更新 UI 狀態
    setState(() {
      // 從總表中移除
      users.removeWhere((u) => u["username"] == username);

      // 從顯示列表中移除 (使用 removeAt 比較危險，因為搜尋後 index 會變)
      // 建議直接用 username 比對移除
      filteredUsers.removeWhere((u) => u["username"] == username);

      // 如果搜尋框有字，可以考慮重新過濾一次，確保狀態正確
      if (searchQuery.isNotEmpty) {
        _filterUsers(searchQuery);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已刪除 $username 的所有紀錄')),
      );
    }
  }
  // 顯示刪除確認對話框
  void showDeleteDialog(
      BuildContext context,
      int index,
      double screenWidth,
      double screenHeight,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '刪除紀錄',
          style: TextStyle(fontSize: screenWidth * 0.056),
        ),
        content: Text(
          '確定要刪除這筆檢測紀錄嗎？',
          style: TextStyle(fontSize: screenWidth * 0.052),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // 呼叫實際的刪除邏輯
              await _deleteUser(index);

              if (context.mounted) {
                Navigator.pop(context); // 關閉對話框
              }
            },
            child: const Text('刪除', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }
  // 實際執行使用者名稱更新的邏輯
  Future<void> _updateUsername(String oldUsername, String newUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. 取得所有目前的 Key
    final Set<String> allKeys = prefs.getKeys();

    // 定義舊的前綴與新的前綴 (例如: "Alice_" -> "Bob_")
    String oldPrefix = "${oldUsername}_";
    String newPrefix = "${newUsername}_";

    // 2. 遍歷所有 Key，找出屬於該使用者的資料進行搬移
    for (String key in allKeys) {
      // 判斷 Key 是否以 "舊名字_" 開頭
      if (key.startsWith(oldPrefix)) {
        // 取得舊值
        Object? value = prefs.get(key);

        // 產生新 Key (將舊前綴換成新前綴)
        String newKey = key.replaceFirst(oldPrefix, newPrefix);

        // 儲存到新 Key (需要判斷型態)
        await _setValue(prefs, newKey, value);

        // 刪除舊 Key
        await prefs.remove(key);
      }
    }

    // 3. 更新模組使用者清單 (LHC_Users, ABP_Users, BM_Users)
    // 這些清單存的是 ["Alice", "Bob"]，我們需要把裡面的 "Alice" 改成 "Bob"
    final List<String> listKeys = ['LHC_Users', 'ABP_Users', 'BM_Users'];

    for (String listKey in listKeys) {
      List<String> userList = prefs.getStringList(listKey) ?? [];

      if (userList.contains(oldUsername)) {
        int index = userList.indexOf(oldUsername);
        userList[index] = newUsername; // 原地替換，保持順序
        await prefs.setStringList(listKey, userList);
      }
    }

    // 4. 重新載入顯示列表
    await _loadUsers();
  }

  // 輔助函式：根據值的型態寫入 SharedPreferences
  Future<void> _setValue(SharedPreferences prefs, String key, Object? value) async {
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<Object?>) {
      // SharedPreferences 讀出的 List 可能是 List<Object?>，需轉型為 List<String>
      try {
        await prefs.setStringList(key, (value as List).cast<String>());
      } catch (e) {
        debugPrint("Error casting list for key $key: $e");
      }
    }
  }

  // 打開指定使用者的模組紀錄
  Future<void> _openUserRecord(
      BuildContext context,
      String username,
      String module,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    if (module == 'LHC') {
      final hasData = prefs.containsKey('${username}_LHC_TimeRatingPoints');

      if (!hasData) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('LHC：無檢測過，請先到開始檢測')));
        return;
      }

      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailLhc(userName: username),
        ),
      ).then((_) => _loadUsers());
    }

    if (module == 'ABP') {
      final hasData = prefs.containsKey('${username}_ABP_TimeRatingPoints');

      if (!hasData) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ABP：無檢測過，請先到開始檢測')));
        return;
      }

      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UserDetailAbp(userName: username)),
      ).then((_) => _loadUsers());
    }

    if (module == 'BM') {
      final hasData =
      prefs.containsKey('${username}_BM_TimeRatingPoints');

      if (!hasData) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('BM：無檢測過，請先到開始檢測')));
        return;
      }

      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UserDetailBm(userName: username)),
      ).then((_) => _loadUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFD9D9D9),
        title: Text(
          "檢測紀錄",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: screenWidth * 0.056,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFD9D9D9),
        height: screenHeight,
        child: Column(
          children: [
            // 搜尋列
            Padding(
              padding: EdgeInsets.all(10),
              child: SearchBar(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: screenHeight * 0.015),
                ),
                leading: const Icon(Icons.search),
                hintText: "Search",
                hintStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.black),
                ),
                backgroundColor: const WidgetStatePropertyAll(
                  Color(0xFFA9A9A9),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                onChanged: _filterUsers,
              ),
            ),

            // 檢測紀錄列表
            Expanded(
              child:
              filteredUsers.isEmpty
                  ? Center(
                child: Text(
                  searchQuery.isEmpty
                      ? "目前沒有檢測紀錄"
                      : "🔍 查無符合「$searchQuery」的紀錄",
                  style: TextStyle(
                    fontSize: screenWidth * 0.056,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  String username = filteredUsers[index]["username"]!;
                  String gender = filteredUsers[index]["gender"]!;

                  return Slidable(
                    key: Key(username),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            // 呼叫新的對話框來處理名稱修改邏輯
                            // 由於您沒有提供修改邏輯，我將使用一個佔位符函式
                            _showEditNameDialog(
                              context,
                              index,
                              username,
                              screenWidth,
                              screenHeight,
                            );
                          },
                          backgroundColor: Colors.blueGrey, // 不同的顏色區分
                          icon: Icons.edit,
                          label: '修改',
                        ),
                        SlidableAction(
                          onPressed:
                              (_) => showDeleteDialog(
                            context,
                            index,
                            screenWidth,
                            screenHeight,
                          ),
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: '刪除',
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () async {
                        final contextLocal = context;
                        final String username =
                            filteredUsers[index]['username'] ?? '';

                        final choice = await showDialog<String>(
                          context: contextLocal,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                '選擇檢測項目',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.056,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text('LHC'),
                                    onTap:
                                        () => Navigator.pop(
                                      context,
                                      'LHC',
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('ABP'),
                                    onTap:
                                        () => Navigator.pop(
                                      context,
                                      'ABP',
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('BM'),
                                    onTap:
                                        () => Navigator.pop(
                                      context,
                                      'BM',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        if (choice == null) return;

                        if (context.mounted) {
                          await _openUserRecord(
                            context,
                            username,
                            choice,
                          );
                        }
                      },
                      child: Container(
                        color: const Color(0xFFD9D9D9), // 遮掉上陰影
                        child: Container(
                          height: screenHeight * 0.09,
                          margin: EdgeInsets.only(
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03,
                            bottom: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withValues(
                                  alpha: 0.3,
                                ),
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: screenWidth * 0.03),
                              CircleAvatar(
                                backgroundColor: Colors.white38,
                                backgroundImage: AssetImage(
                                  "assets/images/$gender.png",
                                ),
                                radius: 25,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: Text(
                                  username,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.056,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.black54,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
