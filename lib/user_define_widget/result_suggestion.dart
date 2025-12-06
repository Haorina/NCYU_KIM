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
      double aboveShoulderPoints) {
    // 身體姿勢建議
    String postureText = bodyPosturePoints >= 13
        ? '建議：\n目前姿勢屬於高風險姿勢，易導致椎間盤突出、關節退化或肌腱炎等肌肉骨骼損傷。建議立即停止長時間維持此姿勢及大幅降低負重，並使用機械輔助（如升降機）。必要時重新設計作業流程或工作高度，降低對肌肉骨骼系統構成的顯著過載。以下姿勢變換皆屬於高度風險姿勢，若涉及這些姿勢，請立即改善：\n▪️高處搬運 → 蹲姿/跪姿；微彎腰 → 蹲姿/跪姿：這些姿勢對膝關節與腰椎造成極大壓力，建議避免此類姿勢，改用機械輔助完成高處作業，或調整至站立高度；若無法避免，應限制為短暫動作並配戴護具。\n▪️彎腰 → 彎腰：腰椎持續前彎顯著增加椎間盤突出等肌肉骨骼傷害風險。建議改為「蹲下取物再起身」或「寬站姿半蹲」姿勢，並使用腰背支撐帶或高度可調工作台。\n▪️彎腰 → 蹲姿 / 跪姿：腰部和膝部同時受壓，增加肌肉骨骼損傷風險。建議避免直接轉換，可先回到站立再下蹲，並配戴護膝以分散壓力。\n▪️蹲姿/跪姿 → 蹲姿/跪姿：持續極端膝彎曲會增加膝關節炎與積液風險。建議避免長時間維持此姿勢，改採「高跪與站立輪替」，並使用機械輔助及支撐裝置（如護膝、坐凳）來減輕膝蓋的負擔，必要時調整作業高度或位置以便站立操作。'
        : bodyPosturePoints >= 7
        ? '目前姿勢對身體已造成中度負擔，可能引發中度肌肉疲勞或初期關節炎症狀（如腰痛或膝蓋不適）。建議縮短單次作業的持續時間，降低負重，並引入人體工學輔具。若操作涉及較大幅度的姿勢變換，應適當調整作業方式以降低腰椎、膝蓋及關節的負擔。以下姿勢變換皆屬於中度風險姿勢，若涉及這些姿勢，請參考改善建議：\n▪️站立 → 彎腰：此姿勢增加腰椎前彎負荷，長時間進行可能誘發椎間盤壓力上升及下背痛。建議使用長柄工具或升降平台，減少頻繁彎腰需求。\n▪️站立 → 蹲姿 / 跪姿：此姿勢對膝蓋和下肢負擔較大，長時間維持可能引起關節傷害或肌肉疲勞。建議改為「寬站立半蹲」並配戴膝關節護具，小休息時應起立伸展，必要時調整作業高度。\n▪️高處搬運 → 彎腰；微彎腰 → 彎腰：此姿勢增加了腰椎壓力，建議調整工作台至腰部高度，改為「肩寬站立微傾」姿勢，減少身體彎曲過度的需求，並使用電動升降台減少上肢抬舉。'
        : '目前姿勢屬於低風險姿勢，無需重大調整。為預防累積性疲劳，建議避免長時間維持同一姿勢，並每 30–60 分鐘進行動態伸展（如肩頸旋轉、腰部輕微後仰）。同時建議留意有無關節不適，並適度調整姿勢。';

    // 額外加分項建議
    List<String> additionalSuggestions = [];

    additionalSuggestions.add(
      twistOrLeanPoints > 0
          ? '▪️軀幹扭轉或側傾：建議先轉身面向目標方向，避免軀幹扭轉或側傾。在搬運過程中，保持肩膀與骨盆在同一方向，透過調整腳步而非軀幹扭轉來改變方向。'
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
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            loadWeightPoints > 25
                ? '建議：此負重超過大多數人的安全搬運範圍。強烈建議減少負重至少一半，並避免單人搬運。應依賴兩人協作搬運，並使用輔助設備來完成搬運，或將重物分成多次搬運，這樣能有效降低搬運過程中的風險。'
                : loadWeightPoints > 15
                ? '建議：此負重長時間搬運會造成較大的肌肉和關節的負擔。負重建議減少 10-15 公斤，或將重物分成多次搬運。若無法分次搬運，應由兩人協作搬運。搬運過程可使用輔助工具來減輕工作強度，從而減少肌肉和關節的負擔。'
                : loadWeightPoints > 6
                ? '建議：減少負重 5-10 公斤，或將重物分成多次搬運，避免一次負重過大。若無法分次搬運，應考慮兩人協作搬運，減少每個人的負擔，從而降低對肌肉和關節的傷害風險。'
                : '建議：此負重評級較低，對大多數工作者來說，單次搬運不會造成過大風險。但仍需注意搬運方式，避免不良姿勢造成過度負擔，保持正確的搬運姿勢以減少潛在風險。',
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
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            weightHandlingPoints == 0
                ? '建議：雙手對稱負重是最理想的搬運姿勢，維持現有工作方式，無需額外調整。'
                : (weightHandlingPoints == 2
                ? '建議：單手或不對稱負重會加大對一側肌肉和關節的傷害，建議盡量避免長時間單手或不對稱搬運，若必須使用單手搬運，應考慮使用其他輔助工具來平衡負重。'
                : '建議：負重的壓力集中在單一手臂時，對肌肉和關節的負擔會非常大，容易引發損傷。強烈建議改為雙手對稱負重搬運，或使用輔助工具來平衡負重，減少單側負擔。如果無法改變搬運方式，應考慮減少每次搬運的重量，並適當的休息'),
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
        final int score1 = prefs.getInt("WorkConditionScore1") ?? 0; // 手/手臂關節是否已到極限
        final int score2 = prefs.getInt("WorkConditionScore2") ?? 0; // 重物是否不易抓握
        final int score3 = prefs.getInt("WorkConditionScore3") ?? 0; // 不良氣候條件
        final int score4 = prefs.getInt("WorkConditionScore4") ?? 0; // 空間條件
        final int score5 = prefs.getInt("WorkConditionScore5") ?? 0; // 額外衣物或裝備
        final int score6 = prefs.getInt("WorkConditionScore6") ?? 0; // 握持/搬運情況

        List<String> conditionSuggestions = [
          '手/手臂關節是否已到極限: ${score1 == 0 ? "手/手臂關節幾乎不會到極限，可維持現有作業方式，並定期檢查手部姿勢，確保不造成過度負荷。" : score1 == 1 ? "手/手臂關節偶爾到達極限，應適時休息並搭配伸展運動以減少關節壓力。亦可考慮調整工具或作業方式，減少關節活動範圍的極限使用。" : "手/手臂關節經常處於極限狀態，應重新設計作業流程並引入輔助設備以降低負擔。需增加休息間隔，並進行適當的關節放鬆與伸展。"}',
          '重物是否不易抓握/需更大的持握力量: ${score2 == 0 ? "重物可輕鬆抓握，建議保持雙手對稱搬運，並使用符合人體工學的工具以減少手部負擔。" : score2 == 1 ? "重物稍微難以抓握時，應選擇帶有適合手柄的工具，並可佩戴防滑手套來增強抓握的穩定，以減少握持所需的力量。" : "當重物抓握困難且需過度用力時，應更換易於抓握的重物設計，或使用輔助工具。避免長時間持續用力，並安排適當的休息。"}',
          '有無不良的氣候條件: ${score3 == 0 ? "工作環境氣候條件良好，維持現有工作環境，並保持適當通風與舒適度。" : "若工作環境過熱或過冷，應配置適當防護裝備，如散熱服或防寒衣，改善通風或溫控系統，並規劃適當的休息時間。"}',
          '空間條件: ${score4 == 0 ? "工作空間條件良好，建議維持現有工作區域，並定期檢查安全性。" : score4 == 1 ? "工作空間受限時，應優化作業動線，確保有足夠活動範圍，避免長時間處於受限姿勢。若地面環境不佳，應盡快修繕或清理。" : "工作空間不足或高度受限，應重新設計工作區域，增加活動空間，並使用可調高度或輔助設備以改善姿勢。若地面環境不佳，應立即修繕或清理，確保地面平整與安全。"}',
          '有無額外的衣物或裝備: ${score5 == 0 ? "衣著無額外負擔，建議持續使用舒適、不妨礙活動的工作服。" : "若需穿戴額外防護裝備，建議選擇輕便、透氣材質，以減少重量與熱負擔，並確保活動靈活度。"}',
          '握持/搬運情況: ${score6 == 0 ? "握持/搬運情況正常，可維持現有搬運方式，並定期檢查姿勢與作業流程，確保不造成累積性負擔。" : score6 == 2 ? "當搬運/持握時間偏長（5–10 秒），搬運距離較遠（2–5 公尺）時，應分次搬運或縮短單次搬運距離。必要時兩人協作搬運，並使用輔助工具，以降低疲勞與關節壓力。" : "搬運/持握時間過長（>10 秒），且搬運距離超過 5 公尺，屬於高風險情況。強烈建議避免單人搬運，應使用機械或輔助設備完成，並將重物分批搬運。必要時重新設計作業流程，降低單次搬運的時間與距離，以避免長期過度負荷導致肌肉骨骼損傷。"}',
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
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            timeRatingPoints == 0.0
                ? '建議：目前工作負荷分配均衡，包含多種工作型態，能有效避免長時間集中進行高強度作業。建議持續保持現有的工作安排，並定期檢視工作內容，確保無過度集中負荷的情況。'
                : (timeRatingPoints == 2.0
                ? '建議：工作負荷變化有限，偶爾在一天內集中進行單一高強度工作，可能增加肌肉骨骼傷害的風險。建議調整工作流程，將高強度作業分散至不同時間段，並在工作中穿插低負荷或不同性質的工作，讓肌肉與關節有充分休息。'
                : '建議：工作長時間集中於單一高強度負荷，且經常達到負荷峰值，容易導致肌肉骨骼傷害。強烈建議重新設計工作排程，將高強度工作分散至多日或多時段進行。建議使用輔助工具，或引入輪班制度，並確保員工有充足的休息時間，從而減少長時間承受高強度負荷的風險。'),
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
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036),
          child: Text(
            totalScore >= 100.0
                ? '生理過載極有可能發生，健康風險顯著。容易出現明確的異常(如劇烈疼痛)、明顯功能障礙（如行動受限），甚至導致身體結構性損傷（如肌肉、韌帶或關節變形），此屬不可忽視的病態表現。'
                : (totalScore >= 50.0
                ? '對一般族群已有生理過載的可能性。可能出現異常反應（如肌肉酸痛、關節不適），甚至造成暫時性的功能障礙（如行動受限），大多數情況下屬可逆狀態，無明顯結構性損傷。但若長期忽視，可能進一步演變為職業性肌肉骨骼疾病。'
                : (totalScore >= 20.0
                ? '對恢復能力較弱者（如年長者、已有慢性疾病或疲勞者）可能出現生理過載。可能導致輕度疲勞或低度適應不良（如動作效率下降、注意力不集中），但一般可透過充分休息或短暫調整恢復。'
                : '生理過載的可能性極低，通常不會對健康造成影響。')),
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


class ResultSuggestion extends StatefulWidget {
  const ResultSuggestion({
    super.key,
    required this.suggestionName,
    required this.totalScore,
    required this.screenWidth,
    required this.screenHeight,
  });


  final List<String> suggestionName;
  final num totalScore;
  final double screenWidth;
  final double screenHeight;


  @override
  State<ResultSuggestion> createState() => _ResultSuggestionState();
}


class _ResultSuggestionState extends State<ResultSuggestion> {
  int loadWeightPoints = 0;
  double totalBodyPosturePoints = 0;
  double bodyPosturePoints = 0;
  double timeRatingPoints = 0;
  int weightHandlingPoints = 0;
  int workConditionPoints = 0;
  int workOrganizationPoints = 0;
  double twistOrLeanPoints = 0;
  double distanceOfBodyCenterPoints = 0;
  double armLiftPoints = 0;
  double aboveShoulderPoints = 0;
  double totalScore = 0;
  bool isSaved = false;
  List<num> maxScore = [0, 0, 0];
  List<String> maxScoreText = ["3", "2", "1"];


  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    setState(() {
      loadWeightPoints = prefs.getInt("LoadWeightPoints") ?? 4;
      totalBodyPosturePoints = prefs.getDouble("TotalBodyPosturePoints") ?? 0;
      bodyPosturePoints = prefs.getDouble("BodyPosturePoints") ?? 0;
      timeRatingPoints = prefs.getDouble("TimeRatingPoints") ?? 1;
      weightHandlingPoints = prefs.getInt("WeightHandlingPoints") ?? 0;
      workConditionPoints = prefs.getInt("WorkConditionPoints") ?? 0;
      workOrganizationPoints = prefs.getInt("WorkOrganizationPoints") ?? 0;
      twistOrLeanPoints = prefs.getDouble("TwistOrLeanPoints") ?? 0;
      distanceOfBodyCenterPoints = prefs.getDouble("DistanceOfBodyCenterPoints") ?? 0;
      armLiftPoints = prefs.getDouble("ArmLiftPoints") ?? 0;
      aboveShoulderPoints = prefs.getDouble("AboveShoulderPoints") ?? 0;
      totalScore = timeRatingPoints *
          (loadWeightPoints +
              totalBodyPosturePoints +
              weightHandlingPoints +
              workConditionPoints +
              workOrganizationPoints);
      List<MapEntry<String, num>> scoreEntries = [
        MapEntry("負重評級", loadWeightPoints),
        MapEntry("身體姿勢", totalBodyPosturePoints),
        MapEntry("負荷處理條件", weightHandlingPoints),
        MapEntry("不良工作條件", workConditionPoints),
        MapEntry("工作時間分配", workOrganizationPoints),
      ];


      maxScore = scoreEntries.take(5).map((entry) => entry.value).toList();
      maxScoreText = scoreEntries.take(5).map((entry) => entry.key).toList();
    });
  }


  @override
  void initState() {
    super.initState();
    _loadPoints();
  }


  @override
  Widget build(BuildContext context) {
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
      // 移除固定高度，讓容器根據內容自適應
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
          for (int i = 0; i < 7; i++) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: suggestionCard(
                widget.screenWidth,
                widget.screenHeight,
                widget.suggestionName,
                totalScore,
                i,
                loadWeightPoints,
                weightHandlingPoints,
                timeRatingPoints,
                workConditionPoints,
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

