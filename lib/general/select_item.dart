import 'package:flutter/material.dart';
import '../lhc/weight_rating.dart';
import '../abp/time_rating.dart';
import '../bm/time_rating.dart';

Map<String, String> iconText1 = {
  "LHC": "人工抬舉、握持、搬運超過３公斤的重物，包含將重物搬起後往上下左右移動、抱在手上走動或原地不動等",
  "ABP": "不良的身體姿勢（背部、肩&上肢、下肢），一次性動作≥1分鐘，重複性每次動作≥10秒",
  "MHO": "1.單調制式、重複動作、上肢出力動作\n2.操作小物件(<3公斤)、使用小工具，或用手操控機器\n3.通常是靜態站立、坐姿",
  "BM": "評估因在工作場所的執行需身體移動、活動的作業，造成的身體負荷",
  "BF": "1.處理大型物件、移動人等\n2.經由手部施力，但此力量會傳遞到肩、背、下肢\n3.需極大施力，無法在坐姿執行",
  "PP":
  "1.顧名思義，使用搬運工具做【推】與【拉】的作業\n2.推or拉】高過頭的輸送帶上的重物（單方向性）\n3.【推or拉】起重機吊起的重物（多方向性)",
};

Map<String, String> iconText2 = {
  "LHC": "常見作業種類：\n上下貨、移動托盤貨物、搬抬時無升降輔助設備、照顧病人/小孩",
  "ABP": "常見作業種類：\n鋪磚、鋼筋綁紮、焊接、包裝生產線、天花板作業、建築裝潢、顯微鏡、微創手術、管道間工作、船底作業",
  "MHO": "常見作業種類：\n零件組裝、焊接、縫紉、整理、剪裁、按壓、移動、包裝、出納\n操作顯微鏡、移液器、樂器等",
  "BM": "常見作業種類：\n搬抬傢俱/病人、攀爬旋轉梯、渠道中移動、在建築工地中移動、鍋爐維修、水電維修、騎自行車/人力車",
  "BF":
  "常見作業種類：\n修整鑄件、轉動閘閥、絞車滑輪作業、板手/撬棍等工具作業、氣動鑽/電鋸等電動工具、連結列車、拆除混凝土、窗戶安裝、病患移動、擰緊大型物件、用力擊打、鏟、滾輪軌道上推動物品而鮮少身體移動、船隻停泊",
  "PP": "",
};

class SelectItem extends StatelessWidget {
  const SelectItem({super.key});

  Widget onTapWidget(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      String titleText,
      String iconTitleText,
      String image,
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
            height: screenHeight * 0.18,
            margin: EdgeInsets.only(
              top: screenHeight * 0.012,
              left: screenWidth * 0.12,
              right: screenWidth * 0.12,
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
            child: SizedBox(
              width: screenWidth,
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.024,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.006,
                        horizontal: screenWidth * 0.1,
                      ),
                      child: Text(
                        titleText,
                        style: TextStyle(
                          fontSize: screenHeight * 0.024,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.02,
                    left: screenWidth * 0.66,
                    child: InkWell(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel:
                          MaterialLocalizations.of(
                            context,
                          ).modalBarrierDismissLabel,
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (
                              context,
                              animation,
                              secondaryAnimation,
                              ) => Center(
                            child: Container(
                              width: screenWidth * 0.85,
                              height: screenHeight * 0.265,
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
                                            top: screenHeight * 0.008,
                                            left: screenWidth * 0.03,
                                          ),
                                          child: Text(
                                            iconTitleText,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.045,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                              TextDecoration.none,
                                            ),
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
                                    margin: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.01,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0XCCFFFFFF),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: screenWidth * 0.05,
                                      right: screenWidth * 0.05,
                                      bottom: screenHeight * 0.01,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: screenWidth,
                                          child: Text(
                                            iconText1[titleText]!,
                                            style: TextStyle(
                                              fontSize:
                                              screenWidth * 0.04,
                                              fontWeight:
                                              FontWeight.w500,
                                              color: Colors.white,
                                              decoration:
                                              TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                        if (iconText2[titleText] !=
                                            "") ...[
                                          SizedBox(
                                            width: screenWidth,
                                            child: Text(
                                              "\n${iconText2[titleText]!}",
                                              style: TextStyle(
                                                fontSize:
                                                screenWidth * 0.035,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                decoration:
                                                TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
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
                              child: ScaleTransition(
                                scale: curved,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                      child: Image.asset("assets/images/help-circle.png"),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.014,
                    left: screenWidth * 0.35,
                    child: Container(
                      height: screenHeight * 0.16,
                      width: screenWidth * 0.32,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
              "選擇檢測項目",
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
                onTapWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  "LHC",
                  "Lifting-Holding-Carrying",
                  "assets/images/carry-differ.png",
                  WeightRating(),
                ),
                SizedBox(height: screenHeight * 0.036),
                onTapWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  "ABP",
                  "Awkward-Body-Postures",
                  "assets/images/ABP.png",
                  ABPTimeRating(),
                ),
                SizedBox(height: screenHeight * 0.036),
                onTapWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  "BM",
                  "Body-Movement",
                  "assets/images/BM.png",
                  BMTimeRating(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
