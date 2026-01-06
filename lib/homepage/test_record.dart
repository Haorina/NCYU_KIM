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

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text(
          '修改使用者名稱',
          style: TextStyle(fontSize: screenWidth * 0.056),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "輸入新名稱"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String newUsername = controller.text.trim();
              if (newUsername.isEmpty || newUsername == oldUsername) {
                Navigator.pop(context); // 名稱無效或未更改，關閉
                return;
              }

              await _updateUsername(oldUsername, newUsername);

              if (context.mounted) {
                Navigator.pop(context); // 關閉對話框
              }
            },
            child: Text('修改', style: TextStyle(color: Colors.blue)),
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

    // 這裡的邏輯會非常複雜，因為您必須複製所有舊的 SharedPreferences 鍵，並用新名字儲存，然後刪除舊鍵。

    // 1. 取得所有舊鍵
    final Set<String> keys = prefs.getKeys();
    final List<String> userKeys =
    keys.where((key) => key.startsWith(oldUsername)).toList();

    // 2. 複製/重命名並儲存所有數據
    for (String oldKey in userKeys) {
      final value = prefs.get(oldKey); // 獲取值（通用方法）
      final newKey = oldKey.replaceFirst(oldUsername, newUsername);

      // 由於 prefs.get() 返回 dynamic，我們需要判斷類型並用對應的 set 方法儲存
      if (value is String) {
        await prefs.setString(newKey, value);
      } else if (value is List<String>) {
        await prefs.setStringList(newKey, value);
      } else if (value is int) {
        await prefs.setInt(newKey, value);
      } else if (value is double) {
        await prefs.setDouble(newKey, value);
      } else if (value is bool) {
        await prefs.setBool(newKey, value);
      }
    }

    // 3. 更新模組使用者列表 (LHC_Users, ABP_Users, BM_Users)
    final List<String> updateLists = ['LHC_Users', 'ABP_Users', 'BM_Users'];
    for (String listKey in updateLists) {
      List<String> userList = prefs.getStringList(listKey) ?? [];
      if (userList.contains(oldUsername)) {
        userList.remove(oldUsername);
        userList.add(newUsername);
        await prefs.setStringList(listKey, userList);
      }
    }

    // 4. 刪除所有舊鍵
    for (String oldKey in userKeys) {
      await prefs.remove(oldKey);
    }

    // 5. 重新載入顯示列表
    await _loadUsers();
  }

  // 刪除使用者紀錄（含各模組分數）
  Future<void> _deleteUser(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = filteredUsers[index]["username"]!;

    // 1️⃣ 刪除該使用者所有 key
    for (String key in prefs.getKeys()) {
      if (key.startsWith('${username}_')) {
        await prefs.remove(key);
      }
    }

    // 2️⃣ 更新 users 清單（目前頁面顯示）
    users.removeWhere((u) => u["username"] == username);
    filteredUsers.removeAt(index);

    // 3️⃣ 分模組更新對應的使用者清單
    final List<String> lhcUsers = prefs.getStringList('LHC_Users') ?? [];
    final List<String> abpUsers = prefs.getStringList('ABP_Users') ?? [];
    final List<String> bmUsers = prefs.getStringList('BM_Users') ?? [];

    lhcUsers.remove(username);
    abpUsers.remove(username);
    bmUsers.remove(username);

    await prefs.setStringList('LHC_Users', lhcUsers);
    await prefs.setStringList('ABP_Users', abpUsers);
    await prefs.setStringList('BM_Users', bmUsers);

    setState(() {});
  }

  void showDeleteDialog(
      BuildContext context,
      int index,
      double screenWidth,
      double screenHeight,
      ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
              await _deleteUser(index);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('刪除', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
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
