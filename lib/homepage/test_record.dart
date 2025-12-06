import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestRecord extends StatefulWidget {
  const TestRecord({super.key});

  @override
  State<TestRecord> createState() => _TestRecordState();
}

class _TestRecordState extends State<TestRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "檢測紀錄",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.sp),
        ),
        backgroundColor: const Color(0xFFD9D9D9),
      ),
      body: Container(
        color: const Color(0xFFD9D9D9),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.r),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16.h),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(color: Colors.black),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      const Color(0xFFA9A9A9),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  );
                },
                suggestionsBuilder: (
                  BuildContext context,
                  SearchController controller,
                ) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
