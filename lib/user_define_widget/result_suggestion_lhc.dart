import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget suggestionCard(
    double screenWidth,
    double screenHeight,
    List<String> suggestionName,
    num totalScore,
    int index,
    int loadWeightPoints,
    int weightHandlingPoints,
    double timeRatingPoints,
    int workConditionPoints,
    double twistOrLeanPoints,
    double distanceOfBodyCenterPoints,
    double bodyPosturePoints,
    double armLiftPoints,
    double aboveShoulderPoints,
    ) {
  String bodySuggestion(
      double bodyPosturePoints,
      double twistOrLeanPoints,
      double distanceOfBodyCenterPoints,
      double armLiftPoints,
      double aboveShoulderPoints,
      ) {
    // 身體姿勢建議
    String postureText =
    bodyPosturePoints == 0
        ? '維持此良好姿勢，直立完成整個搬運過程，但仍需注意搬運重量和頻率，避免過度負荷'
        : bodyPosturePoints == 3 || bodyPosturePoints == 5
        ? '建議調整放置物品的位置，使用升降平台、手推車或架子使姿勢能保持直立。若無法避免彎腰或抬舉，每連續搬運20分鐘應進行肩膀、腰部伸展'
        : bodyPosturePoints == 7
        ? '重新設計放置位置，提高至腰部以上。若必須放置在低處，應分段放置（先放中間高度，再放到最終位置），或使用機械輔助設備。也可採用兩人協作搬運方式。每搬運10分鐘應進行腰部伸展'
        : bodyPosturePoints == 9
        ? '強烈建議改變作業方式，使用升降設備、輸送帶或其他機械化裝置來避免此姿勢。或改為「寬站立半蹲」且必須穿著護膝，每搬運5-10分鐘強制休息片刻'
        : bodyPosturePoints == 10
        ? '強烈建議使用升降平台或可調整高度的設備來減少高度差，或分段放置（先放中間高度，再放到最終位置）。也可改為「肩寬站立微傾」且使用輔助設備或兩人協作。每搬運5-10分鐘休息片刻'
        : bodyPosturePoints == 13
        ? '必須立即改善起始和結束高度，改⽤機械輔助完成⾼處作業或低處作業，或調整⾄站立⾼度。若無法避免，可先回到站立再下蹲，並配戴護膝。每搬運5-10分鐘休息片刻'
        : bodyPosturePoints == 15
        ? '必須使用機械化設備（如升降機、堆高機、輸送帶）輔助。若短期內無法改善，可暫時改為 「蹲下取物再起⾝」或「寬站姿半蹲」姿勢。並配備防護用具'
        : bodyPosturePoints == 18
        ? '必須使用機械化設備（如升降機、堆高機、輸送帶）輔助。若緊急情況下必須執行，應使用分段完成高度變化或可先回到站立再下蹲，並配備防護用具。'
        : '必須使用機械化或自動化設備來替代人工搬運。若因特殊原因必須緊急執行，可改採「⾼跪與跪姿輪替」並使⽤機械輔助及⽀撐裝置（如護膝、 坐凳）。';

    // 額外加分項建議
    List<String> additionalSuggestions = [];

    additionalSuggestions.add(
      twistOrLeanPoints > 0
          ? '▪️軀幹扭轉或側傾：先轉身面向目標方向，避免軀幹扭轉或側傾。在搬運過程中，保持肩膀與骨盆在同一方向，透過調整腳步而非軀幹扭轉來改變方向。'
          : '',
    );
    additionalSuggestions.add(
      distanceOfBodyCenterPoints > 0
          ? '▪️負重重心或手遠離身體：搬運時將物品貼近胸腹部，保持負重靠近身體，避免手臂和物品的重心過於遠離身體。若物品較重，應使用搬運帶或支撐工具。'
          : '',
    );
    additionalSuggestions.add(
      armLiftPoints > 0
          ? '▪️手臂抬舉（手位於手肘與肩膀之間）：避免長時間將手臂維持在手肘與肩膀之間的高度，改用輔助工具或使用可調整高度的工作台，減少手臂抬舉的需求。若需抬舉物品，需適時休息並交替使用雙手。'
          : '',
    );
    additionalSuggestions.add(
      aboveShoulderPoints > 0
          ? '▪️手高過肩膀：盡量避免將手長時間高舉過肩膀，應使用梯子、踏台或升降設備將工作高度降至肩膀以下。若必須高舉手臂，保持動作短暫並使用支撐物分擔重量。'
          : '',
    );

    // 只顯示有內容的建議，沒有則不顯示
    String additionalText = additionalSuggestions
        .where((suggestion) => suggestion.isNotEmpty)
        .join('\n');

    return '$postureText${additionalText.isNotEmpty ? '\n\n額外加分項建議：\n$additionalText' : ''}';
  }

  if (index == 0) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.006,
            horizontal: screenWidth * 0.026,
          ),
          width: screenWidth * 0.4,
          height: screenHeight * 0.024,
          decoration: BoxDecoration(
            color: const Color(0xFFC9E6CF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "身體姿勢",
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF33773F),
              height: screenHeight * 0.0005,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            bodySuggestion(
              bodyPosturePoints,
              twistOrLeanPoints,
              distanceOfBodyCenterPoints,
              armLiftPoints,
              aboveShoulderPoints,
            ),
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.006,
            horizontal: screenWidth * 0.026,
          ),
          width: screenWidth * 0.4,
          height: screenHeight * 0.024,
          decoration: BoxDecoration(
            color: const Color(0xFFC9E6CF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "負重評級",
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF33773F),
              height: screenHeight * 0.0005,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            loadWeightPoints > 25
                ? '此負重超過安全搬運範圍。強烈建議減少負重至少⼀半或應依賴兩人協作搬運，並使用輔助設備來完成搬運，或將重物分成多次搬運'
                : loadWeightPoints > 15
                ? '此負重會造成較⼤的肌⾁和關節的負擔。負重建議減少10-15公⽄，或將重物分成多次搬運或使⽤輔助工具來減輕⼯作強度'
                : loadWeightPoints > 6
                ? '建議減少負重 5-10 公⽄，或將重物分成多次搬運。若無法分次搬運，應考慮兩人協作搬運'
                : '此評級較低，少次搬運不會造成嚴重傷害。但仍需注意搬運方式，避免不良姿勢造成過度負擔',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.006,
            horizontal: screenWidth * 0.026,
          ),
          width: screenWidth * 0.4,
          height: screenHeight * 0.024,
          decoration: BoxDecoration(
            color: const Color(0xFFC9E6CF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "負荷處理條件",
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF33773F),
              height: screenHeight * 0.0005,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            weightHandlingPoints == 0
                ? '維持雙手對稱負重的搬運姿勢，無需額外調整'
                : (weightHandlingPoints == 2
                ? '會造成⼀側肌肉和關節的傷害，建議盡量避免長時間單手或不對稱搬運，或考慮使用其他輔助工具來平衡負重'
                : '強烈建議改為雙⼿對稱負重搬運，或使用輔助⼯具來平衡重量，減少單側負擔'),
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 3) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final prefs = snapshot.data!;
        final int score1 =
            prefs.getInt("WorkConditionScore1") ?? 0; // 手/手臂關節是否已到極限
        final int score2 = prefs.getInt("WorkConditionScore2") ?? 0; // 重物是否不易抓握
        final int score3 = prefs.getInt("WorkConditionScore3") ?? 0; // 不良氣候條件
        final int score4 = prefs.getInt("WorkConditionScore4") ?? 0; // 空間條件
        final int score5 = prefs.getInt("WorkConditionScore5") ?? 0; // 額外衣物或裝備
        final int score6 = prefs.getInt("WorkConditionScore6") ?? 0; // 握持/搬運情況

        List<String> conditionSuggestions = [
          '【手/手臂關節是否已到極限】 ${score1 == 0
              ? "可維持現有作業方式，並定期檢查手部姿勢，確保不造成過度負荷"
              : score1 == 1
              ? "應適時休息並搭配伸展運動以減少關節壓⼒。亦可考慮調整⼯具或作業⽅式，減少關節活動範圍的極限使⽤"
              : "應重新設計作業流程並引入輔助設備以降低負 擔。需增加休息間隔，並進⾏適當的關節放鬆與伸展"}',
          '【重物是否不易抓握/需更大的持握力量】${score2 == 0
              ? "重物可輕鬆抓握，建議維持此方式"
              : score2 == 1
              ? "應選擇帶有適合⼿柄的⼯具，並可佩戴防滑⼿套來增強抓握的穩定，以減少握持所需的⼒量"
              : "當重物抓握困難且需過度⽤⼒時，應更換易於抓握的重物設計，或使⽤輔助⼯具。避免長時間持續⽤⼒"}',
          '【有無不良的氣候條件】 ${score3 == 0 ? "維持現有⼯作環境，保持適當通風與舒適度" : "若⼯作環境過熱或過冷，應配置適當防護裝備，如散熱服或防寒衣，改善通風或溫控系統 "}',
          '【空間條件】 ${score4 == 0
              ? "維持現有工作區域，並定期檢查安全性。"
              : score4 == 1
              ? "應優化作業動線，確保有⾜夠活動範圍。若地⾯環境不佳，應盡快修繕或清理"
              : "應重新設計⼯作區域，增加活動空間，並使⽤可調⾼度或輔助設備以改善姿勢。若地⾯地板骯髒、不平整或粗糙地面應立即修繕或清理"}',
          '【有無額外的衣物或裝備 】${score5 == 0 ? "持續使用舒適、不妨礙活動的衣物及裝備。" : "若需穿戴額外防護裝備，建議選擇輕便、透氣材質，以減少重量與熱負擔，並確保活動靈活度。"}',
          '【握持/搬運情況】 ${score6 == 0
              ? "可維持現有搬運方式，並定期檢查姿勢與作業流程，確保不造成累積性負擔。"
              : score6 == 2
              ? "應分次搬運或縮短單次搬運距離。必要時兩人協作搬運，並使用輔助工具，以降低疲勞與關節壓力。"
              : "強烈建議避免單⼈搬運，應使⽤機械或輔助設備完成，並將重物分批搬運，且降低單次搬運的時間與距離"}',
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                vertical: screenHeight * 0.006,
                horizontal: screenWidth * 0.026,
              ),
              width: screenWidth * 0.4,
              height: screenHeight * 0.024,
              decoration: BoxDecoration(
                color: const Color(0xFFC9E6CF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "不良工作條件",
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF33773F),
                  height: screenHeight * 0.0005,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
              child: Text(
                conditionSuggestions.join('\n\n'),
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: const Color(0xFF544D4D),
                ),
              ),
            ),
          ],
        );
      },
    );
  } else if (index == 4) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.006,
            horizontal: screenWidth * 0.026,
          ),
          width: screenWidth * 0.4,
          height: screenHeight * 0.024,
          decoration: BoxDecoration(
            color: const Color(0xFFC9E6CF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "工作時間分配",
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF33773F),
              height: screenHeight * 0.0005,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            timeRatingPoints == 0.0
                ? '持續保持現有的工作安排，並定期檢視工作內容，確保無過度集中負荷的情況。'
                : (timeRatingPoints == 2.0
                ? '調整工作流程，將高強度作業分散至不同時間段，並在工作中穿插低負荷或不同性質的工作，讓肌肉與關節有充分休息。'
                : '強烈建議重新設計工作排程，將高強度工作分散至多日或多時段進行。建議使用輔助工具，或引入輪班制度，並確保員工有充足的休息時間，從而減少長時間承受高強度負荷的風險。'),
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 5) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.006,
            horizontal: screenWidth * 0.026,
          ),
          width: screenWidth * 0.4,
          height: screenHeight * 0.024,
          decoration: BoxDecoration(
            color: const Color(0xFFC9E6CF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "健康疑慮的可能",
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF33773F),
              height: screenHeight * 0.0005,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            totalScore >= 100.0
                ? '生理過載極可能發生，會產生明確的健康傷害。強烈建議立即進行全面性的工作再設計，並進行健康監測追蹤。若短期內無法改善工作條件，應考慮暫停此類作業直到完成改善措施為止'
                : (totalScore >= 50.0
                ? '對一般族群有生理過載可能性。建議重新設計工作流程和環境，減少不良姿勢的持續時間和頻率'
                : (totalScore >= 20.0
                ? '對恢復能力較弱者（如年長者、有舊傷者）有生理過載可能性。建議針對這些族群提供更多的休息時間和姿勢變換機會'
                : '生理過載可能性低。偶爾維持此類姿勢不會造成嚴重傷害。但仍需注意避免累積性負擔')),
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.006,
            horizontal: screenWidth * 0.026,
          ),
          width: screenWidth * 0.4,
          height: screenHeight * 0.024,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4C9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "採取措施",
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4B3003),
              height: screenHeight * 0.0005,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            totalScore >= 100.0
                ? '▪立即停止高風險作業，並進行工作流程與環境的全面再設計。\n▪高風險搬運須由機械化或團隊協作完成，避免單人承擔危險負荷。\n▪強制導入機械輔助設備（如升降平台、輸送帶、堆高機、自動化搬運系統），徹底降低手動操作比例。\n▪將單次搬運重量嚴格控制在安全範圍內（建議男性 <15 公斤、女性 <10 公斤），並將搬運距離縮短至 2 公尺以內。\n▪建立嚴格健康監測計畫，將該類高風險作業列入職業安全衛生優先改善項目，並安排每月健康追蹤，以確保不出現長期或不可逆傷害。\n▪對已有症狀的員工進行專業醫療檢查，必要時調整或轉換其工作內容。'
                : (totalScore >= 50.0
                ? '▪建議重新設計工作流程，降低長時間或高強度的負荷。\n▪降低單次負重或改為分次搬運；每日高強度作業時間建議不超過 2 小時。\n▪增設輔助工具（如手推車、吊具、搬運帶），減少直接手動操作，並安排充分的休息與恢復時間。\n▪提供必要的防護裝備（如支撐背帶、護膝），並安排專業健康檢查，每季進行一次風險評估。\n▪加強員工的人體工學訓練與正確搬運技巧教育。'
                : (totalScore >= 20.0
                ? '▪對恢復能力較弱者（如年長員工、已有慢性疾病或疲勞者）應適度調整作業方式。\n▪增加休息或工作輪換，避免單一高負荷持續過久。\n▪採取基本改善措施，例如使用人體工學工具（符合手型的握柄、推車），並安排短暫休息 （每小時 5–10 分鐘）。\n▪建議調整負重量或搬運頻率，減少單次負荷。\n▪規劃員工訓練，強化正確姿勢與搬運技巧。\n▪若持續出現不適，應每月進行評估，並逐步導入輔助設備以降低風險。'
                : '▪一般無需額外措施。\n▪建議持續維持現有作業方式，並注意正確的搬運姿勢與基本的人體工學原則。\n▪定期檢視工作環境與操作流程，避免潛在風險逐漸累積。')),
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  }
}

class ResultSuggestionLHC extends StatefulWidget {
  const ResultSuggestionLHC({
    super.key,
    this.userName,
    required this.suggestionName,
    required this.totalScore,
    required this.screenWidth,
    required this.screenHeight,
    this.topRiskIndices = const [0, 1, 2],
  });

  final String? userName;
  final List<String> suggestionName;
  final num totalScore;
  final double screenWidth;
  final double screenHeight;
  final List<int> topRiskIndices;

  @override
  State<ResultSuggestionLHC> createState() => _ResultSuggestionLHCState();
}

class _ResultSuggestionLHCState extends State<ResultSuggestionLHC> {
  int weightRatingPoints = 0;
  double totalBodyPosturePoints = 0;
  double bodyPosturePoints = 0;
  double timeRatingPoints = 0;
  int weightHandlingRatingPoints = 0;
  int workConditionRatingPoints = 0;
  int workOrganizationRatingPoints = 0;
  double twistOrLeanPoints = 0;
  double distanceOfBodyCenterPoints = 0;
  double armLiftPoints = 0;
  double aboveShoulderPoints = 0;
  double totalScore = 0;
  bool isLoading = true;
  List<int> topRiskIndices = [];
  late String currentUser;
  late bool isGuest;

  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if(isGuest) {
        weightRatingPoints = prefs.getInt("WeightRatingPoints") ?? 4;
        totalBodyPosturePoints = prefs.getDouble("TotalBodyPosturePoints") ?? 0;
        bodyPosturePoints = prefs.getDouble("BodyPosturePoints") ?? 0;
        timeRatingPoints = prefs.getDouble("TimeRatingPoints") ?? 1;
        weightHandlingRatingPoints =
            prefs.getInt("WeightHandlingRatingPoints") ?? 0;
        workConditionRatingPoints =
            prefs.getInt("WorkConditionRatingPoints") ?? 0;
        workOrganizationRatingPoints =
            prefs.getInt("WorkOrganizationRatingPoints") ?? 0;
        twistOrLeanPoints = prefs.getDouble("TwistOrLeanPoints") ?? 0;
        distanceOfBodyCenterPoints =
            prefs.getDouble("DistanceOfBodyCenterPoints") ?? 0;
        armLiftPoints = prefs.getDouble("ArmLiftPoints") ?? 0;
        aboveShoulderPoints = prefs.getDouble("AboveShoulderPoints") ?? 0;
      }
      else {
        weightRatingPoints = prefs.getInt("${currentUser}_LHC_WeightRatingPoints") ?? 4;
        totalBodyPosturePoints = prefs.getDouble("${currentUser}_LHC_TotalBodyPosturePoints") ?? 0;
        bodyPosturePoints = prefs.getDouble("${currentUser}_LHC_BodyPosturePoints") ?? 0;
        timeRatingPoints = prefs.getDouble("${currentUser}_LHC_TimeRatingPoints") ?? 1;
        weightHandlingRatingPoints =
            prefs.getInt("${currentUser}_LHC_WeightHandlingRatingPoints") ?? 0;
        workConditionRatingPoints =
            prefs.getInt("${currentUser}_LHC_WorkConditionRatingPoints") ?? 0;
        workOrganizationRatingPoints =
            prefs.getInt("${currentUser}_LHC_WorkOrganizationRatingPoints") ?? 0;
        twistOrLeanPoints = prefs.getDouble("${currentUser}_LHC_TwistOrLeanPoints") ?? 0;
        distanceOfBodyCenterPoints =
            prefs.getDouble("${currentUser}_LHC_DistanceOfBodyCenterPoints") ?? 0;
        armLiftPoints = prefs.getDouble("${currentUser}_LHC_ArmLiftPoints") ?? 0;
        aboveShoulderPoints = prefs.getDouble("${currentUser}_LHC_AboveShoulderPoints") ?? 0;
      }

      totalScore =
          timeRatingPoints *
              (weightRatingPoints +
                  totalBodyPosturePoints +
                  weightHandlingRatingPoints +
                  workConditionRatingPoints +
                  workOrganizationRatingPoints);
    });

    // 🟢 各項評級分數整理與排序
    List<Map<String, dynamic>> riskItems = [
      {'index': 0, 'name': '身體姿勢', 'score': totalBodyPosturePoints},
      {'index': 1, 'name': '負重評級', 'score': weightRatingPoints.toDouble()},
      {'index': 2, 'name': '負荷處理條件', 'score': weightHandlingRatingPoints.toDouble()},
      {'index': 3, 'name': '不良工作條件', 'score': workConditionRatingPoints.toDouble()},
      {
        'index': 4,
        'name': '工作時間分配',
        'score': workOrganizationRatingPoints.toDouble(),
      },
    ];
    // 排序（由高到低）
    riskItems.sort(
          (a, b) => (b['score'] as double).compareTo(a['score'] as double),
    );
    int nonZeroCount =
        riskItems.where((item) => (item['score'] as double) > 0.0).length;

    setState(() {
      topRiskIndices =
          riskItems
              .take(nonZeroCount)
              .map((item) => item['index'] as int)
              .toList();

      if(topRiskIndices.length > 3) {
        topRiskIndices =
            riskItems
                .take(3)
                .map((item) => item['index'] as int)
                .toList();
      }

      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = widget.userName ?? "vJ#CA:F3zP)C]A=V";

    if (widget.userName != null && widget.userName != "vJ#CA:F3zP)C]A=V") {
      isGuest = false;
    } else {
      isGuest = true;
    }

    _loadPoints();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.white),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 1.0,
            spreadRadius: 1,
            color: const Color(0x10000000),
          ),
        ],
      ),
      width: widget.screenWidth * 0.9,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              top: widget.screenHeight * 0.01,
              left: widget.screenWidth * 0.04,
              bottom: widget.screenHeight * 0.01,
            ),
            child: Text(
              "各項建議",
              style: TextStyle(
                fontSize: widget.screenWidth * 0.043,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            height: widget.screenHeight * 0.001,
            margin: EdgeInsets.only(bottom: widget.screenHeight * 0.01),
            decoration: const BoxDecoration(color: Color(0xFFC2C2C2)),
          ),

          //改成前三高 + 健康疑慮 + 採取措施
          for (int i in [...topRiskIndices, 5, 6]) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: suggestionCard(
                widget.screenWidth,
                widget.screenHeight,
                widget.suggestionName,
                totalScore,
                i,
                weightRatingPoints,
                weightHandlingRatingPoints,
                timeRatingPoints,
                workConditionRatingPoints,
                twistOrLeanPoints,
                distanceOfBodyCenterPoints,
                bodyPosturePoints,
                armLiftPoints,
                aboveShoulderPoints,
              ),
            ),
            SizedBox(height: widget.screenHeight * 0.027),
          ],
        ],
      ),
    );
  }
}
