import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget suggestionCardBM(
    double screenWidth,
    double screenHeight,
    List<String> suggestionName,
    num totalScore,
    int index,
    int bodyMovementARatingPoints,
    bool pickWalk,
    bool pickSlope,
    bool pickStair,
    bool pickClimbStair,
    bool pickClimbSteepStair,
    bool pickCrawl,
    int loadWeightPositionRatingPoints,
    bool pickSupport,
    bool pickClose,
    bool pickAway,
    int bodyPostureRatingPoints,
    bool pickOccasionally,
    int bodyMovementConditionPoints,
    int spaceScore,
    int climateScore,
    int bodyMovementBRatingPoints,
    int roadConditionRatingPoints,
    String transportationWeightLabel,
    int workOrganizationPoints,
    String gender,
    bool haveTransportation,
    bool haveTransportSupport,
    bool onlyTransportation,
    ) {
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
            "活動-A",
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
            pickWalk
                ? '負荷相對較低，但需注意控制行走速度在3-5公里/小時內，若需搬運重物應使用推車等輔助工具。長距離移動時應規劃休息'
                : pickSlope
                ? '在傾斜角度>5°的斜坡上建議負重少於10公斤，或使用推車輔助。若傾斜角度>15°，應避免搬運重物，建議採兩人協作或使用機械化設備（如電動推車、輸送帶）'
                : pickStair
                ? '若為普通樓梯時每次負重不超過10公斤，優先使用電梯或升降平台或將重物分成多次搬運。若為陡峭樓梯（35-50°）以上更應嚴格限制負重，並確保有穩固扶手可供支撐'
                : pickClimbStair
                ? '強烈建議避免在攀爬時搬運>3公斤。確保階梯結構穩固且有防墜落措施，且具防滑鞋等。每攀爬5-10公尺設置休息平台、單次攀爬時間不超過5分鐘'
                : pickClimbSteepStair
                ? '必須雙手空出以確保安全，且配備完整的墜落防護設備和攀爬輔助工具。強烈建議改用升降機、吊籠或其他機械化設備取代人工攀爬'
                : '強烈建議提高天花板高度或擴大活動空間。若無法改善，應嚴格限制作業時間，並搭配充分休息。禁止在此姿勢下搬運>3公斤，必要時應使用滑軌、滾輪等輔助設備',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 1) {
    String text = '';

    if (transportationWeightLabel == '≤ 50') {
      text =
      '確保人力交通工具（如手推車、板車）處於良好維護狀態，輪子轉動順暢且有足夠潤滑。長距離推行時應休息5-10分鐘，避免手臂和肩部肌肉持續緊繃';
    } else if (transportationWeightLabel == '51~150') {
      text =
      '確保推車有適當的把手高度和握把。在此速度下應特別注意路徑安全，預留足夠的煞車距離。若總負重超過150公斤，應考慮使用電動輔助推車，或改採兩人協作推行';
    } else {
      text =
      '強烈建議減少總負重<50公斤，並確保路徑平坦且無障礙物。必須配備有效的煞車系統和方向控制裝置。若總負重超過50公斤必須使用電動輔助推車或其他機械化設備。作業時間應嚴格控制，必須休息';
    }

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
            "活動-B",
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
            text,
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
            pickOccasionally
                ? '仍需注意避免在負重狀態下進行軀幹前傾、扭轉或側傾動作。建議調整工作檯面高度或物品擺放位置，減少彎腰和扭轉的需求，或改以移動腳步來改變方向，保持軀幹正直'
                : '強烈建議將物品放置在容易取得的高度和位置，避免頻繁彎腰或扭轉。應使用旋轉檯面、可調整高度的工作台等設備來改善作業姿勢，或考慮引入機械化輔助設備或改採兩人協作方式',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 3) {
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
            "重物重心",
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
            pickSupport
                ? '建議保持此方式，盡量靠近身體，若為揹架 / 雙肩背包，應使重量均勻分散於雙肩和軀幹'
                : pickClose
                ? '建議將負重控制在15公斤以內。若為單肩負重須常更換搬運側或改用雙肩背包或揹架。若為手搬時應保持重物貼近身體，避免手臂過度伸展'
                : '強烈建議改變搬運方式，將重物靠近身體或使用推車等輔助工具。若無法避免，應將負重減少至<10公斤，並縮短搬運距離和時間或採用兩人協作搬運',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 4) {
    String conditionText = '';

    if (spaceScore == 3) {
      conditionText +=
      '活動空間狹窄 / 站立面可動或傾斜 / 沙、石路面:在狹窄空間作業時減少負重，並放慢移動速度。若站立面不穩定或傾斜，應穿著防滑鞋具並使用支撐設備。若在沙、石路面移動時，優先使用有大輪徑、適合不平路面的推車，避免直接手搬重物且應先清理路徑障礙物，確保活動空間暢通';
    } else if (spaceScore == 5) {
      conditionText +=
      '活動空間受阻 / 無攀爬輔助工具 / 荒野: 強烈建議清除活動空間障礙物或增設攀爬輔助工具（如扶手、繩索、階梯）。若在荒野或崎嶇地形作業，應將負重減少至少一半或兩人協作，並使用專業的搬運設備（如越野推車、背架），並事先規劃安全路線和休息點';
    } else {
      conditionText +=
      '活動空間嚴重受阻（侷限空間 or 危險地點）/ 視野受限 / 無休息平台 / 登山 / 呼吸防護設備 / 泥巴路面:強烈建議考慮使用遙控設備、機械手臂或其他自動化方式取代人工作業。若無法避免，必須嚴禁搬運>3公斤，並配備完整的安全防護措施（安全帶、照明設備、通訊裝置、氧氣或呼吸輔助設備）。每15-20分鐘必須撤離至安全區域休息。若為泥巴路面應鋪設防滑墊或改善地面再進行作業';
    }

    conditionText += '\n\n';

    if (climateScore == 4) {
      conditionText +=
      '在高溫環境下應增加補水頻率，每30分鐘至少飲水200-300毫升。在寒冷或強風環境下應穿著保暖防風衣物。建議在氣候不佳時減少高強度作業，並縮短戶外工作時間。作業前應關注氣象預報，做好應對準備';
    } else {
      conditionText +=
      '強烈建議調整作業時段，避開極端氣候時間（如夏季正午、冬季清晨）。必須提供適當的休息設施（如遮陽棚、保暖室），在高溫環境下應預防中暑。在低溫環境下應使用降溫背心、加熱衣物等輔助裝備，並減少負重和作業強度';
    }

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
            conditionText,
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
            "路況",
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
            transportationWeightLabel == '≤ 50'
                ? '選用適合崎嶇路面的大輪徑推車，並放慢推行速度至慢速（<10公里/小時）。短暫上升坡道時應調整身體姿勢，保持軀幹正直，利用腿部力量推進而非彎腰用背部施力'
                : transportationWeightLabel == '51~150'
                ? '建議改善路面條件，如鋪設過渡板、填平坑洞或清除大型障礙物。若無法改善，應使用重型推車或板車，並確保輪胎氣壓充足、輪軸潤滑良好。在上升坡道時應考慮兩人協作推行，若路面為黏重土壤或粗糙碎石，使用電動輔助推車'
                : '強烈建議鋪設堅固平整的臨時道路或使用鋼板、木板等過渡設施。必須使用電動輔助推車（如小型搬運車、堆高機）或絞盤、滑輪等其他輔助裝置。若必須在不良路況下推行，應採用兩人以上協作方式，並將推行距離<20公尺。每推行10-15分鐘必須休息',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 6) {
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
            workOrganizationPoints == 0
                ? '持續保持現有的工作安排，並定期檢視工作內容，確保無過度集中負荷的情況'
                : workOrganizationPoints <= 2
                ? '調整⼯作流程，將高強度作業分散至不同時間段，並在工作中穿插低負荷或不同性質的⼯作，讓肌⾁與關節有充分休息'
                : workOrganizationPoints <= 4
                ? '強烈建議重新設計⼯作排程，將⾼強度⼯作分散⾄多⽇或多時段進⾏'
                : '',
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 7) {
    String transportSuggestion = '';
    if (!haveTransportation) {
      transportSuggestion = '建議配備適當的運輸工具（如手推車、托盤車、電動搬運車），以減少人工搬運的負擔';
    }

    if (!haveTransportSupport) {
      if (transportSuggestion.isNotEmpty) transportSuggestion += '\n\n';
      transportSuggestion += '建議提供運輸支援（如升降平台、輸送帶、吊車），以協助重物或大型物品的移動';
    }

    if (transportSuggestion.isEmpty) {
      transportSuggestion =
      '已配備運輸工具和支援設備，建議：\n▪定期維護和檢查設備\n▪培訓員工正確使用方法\n▪確保設備數量充足\n▪持續評估是否需要升級或添置新設備';
    }

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
            "運輸設備與支援",
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
            transportSuggestion,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
    );
  } else if (index == 8) {
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
                : (totalScore >= 25.0
                ? '對恢復能力較弱者（如年長者、有舊傷者）有生理過載可能性。建議針對這些族群提供更多的休息時間和姿勢變換機會'
                : '生理過載可能性低。偶爾維持此類姿勢不會造成嚴重傷害。但仍需注意累積性負擔')),
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
                ? '▪立即停止高風險作業，並進行工作流程與環境的全面再設計。\n▪引入機械化或自動化設備（如自動搬運系統、輸送帶、升降機）替代人工作業。\n▪嚴格限制作業時間和強度，實施強制休息制度。\n▪配備完整的個人防護裝備（如護腰、護膝、防滑鞋）。\n▪建立嚴格健康監測計畫，定期進行職業健康檢查（建議每月一次）。\n▪對已有症狀的員工進行專業醫療評估，必要時調整或轉換工作內容。\n▪將此類作業列入職業安全衛生優先改善項目。'
                : (totalScore >= 50.0
                ? '▪重新設計工作流程，降低長時間或高強度的負荷。\n▪引入輔助設備（如手推車、升降平台、支撐架）減少人工操作。\n▪實施工作輪換制度，避免單一作業持續過久。\n▪增加休息頻率和時間（建議每小時休息5-10分鐘）。\n▪提供必要的防護裝備（如護腰、護膝）。\n▪加強員工的人體工學訓練和正確作業姿勢教育。\n▪安排專業健康檢查，每季進行一次風險評估。'
                : (totalScore >= 25.0
                ? '▪對恢復能力較弱者（如年長員工、有慢性疾病或疲勞者）適度調整作業方式。\n▪增加休息或工作輪換，避免單一高負荷持續過久。\n▪採用人體工學工具和設備改善作業條件。\n▪安排短暫休息（每小時5-10分鐘）。\n▪提供正確姿勢和作業技巧的培訓。\n▪若持續出現不適，應每月進行評估並逐步改善。'
                : '▪維持現有作業方式，持續注意正確的作業姿勢。\n▪遵循基本的人體工學原則。\n▪定期檢視工作環境與操作流程。\n▪提供基本的健康與安全教育訓練。\n▪建立反饋機制，及時發現和處理潛在問題。')),
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

class ResultSuggestionBM extends StatefulWidget {
  const ResultSuggestionBM({
    super.key,
    required this.suggestionName,
    required this.totalScore,
    required this.screenWidth,
    required this.screenHeight,
    this.userName,
  });

  final String? userName;
  final List<String> suggestionName;
  final num totalScore;
  final double screenWidth;
  final double screenHeight;

  @override
  State<ResultSuggestionBM> createState() => _ResultSuggestionBMState();
}

class _ResultSuggestionBMState extends State<ResultSuggestionBM> {
  double bmTimePoints = 0;
  int bodyMovementARatingPoints = 0;
  bool pickWalk = false;
  bool pickSlope = false;
  bool pickStair = false;
  bool pickClimbStair = false;
  bool pickClimbSteepStair = false;
  bool pickCrawl = false;
  int loadWeightPositionRatingPoints = 0;
  bool pickSupport = false;
  bool pickClose = false;
  bool pickAway = false;
  int bodyPostureRatingPoints = 0;
  int bmWorkConditionRatingPoints = 0;
  int bodyMovementBRatingPoints = 0;
  bool pickOccasionally = false;
  int roadConditionRatingPoints = 0;
  String transportationWeightLabel = '';
  int spaceScore = 0;
  int climateScore = 0;
  int bmWorkOrganizationRatingPoints = 0;
  double bmTotalPoints = 0;
  String bmGender = "male";
  bool haveTransportation = false;
  bool haveTransportSupport = false;
  bool onlyTransportation = false;
  double totalScore = 0;

  // 前三高風險的數據
  List<int> topRiskIndices = [];
  List<String> mostRiskText = [];
  List<num> mostRiskScore = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String keyPrefix =
    (widget.userName != null && widget.userName != "vJ#CA:F3zP)C]A=V")
        ? '${widget.userName}_BM_'
        : '';

    setState(() {
      bmTimePoints = prefs.getDouble("${keyPrefix}TimeRatingPoints") ?? 1.0;
      bodyMovementARatingPoints =
          prefs.getInt("${keyPrefix}BodyMovementARatingPoints") ?? 0;
      pickWalk = prefs.getBool("${keyPrefix}PickWalk") ?? false;
      pickSlope = prefs.getBool("${keyPrefix}PickSlope") ?? false;
      pickStair = prefs.getBool("${keyPrefix}PickStair") ?? false;
      pickClimbStair = prefs.getBool("${keyPrefix}PickClimbStair") ?? false;
      pickClimbSteepStair =
          prefs.getBool("${keyPrefix}PickClimbSteepStair") ?? false;
      pickCrawl = prefs.getBool("${keyPrefix}PickCrawl") ?? false;
      loadWeightPositionRatingPoints =
          prefs.getInt("${keyPrefix}LoadWeightPositionRatingPoints") ?? 0;
      pickSupport = prefs.getBool("${keyPrefix}PickSupport") ?? false;
      pickClose = prefs.getBool("${keyPrefix}PickClose") ?? false;
      pickAway = prefs.getBool("${keyPrefix}PickAway") ?? false;
      bodyPostureRatingPoints =
          prefs.getInt("${keyPrefix}BodyPostureRatingPoints") ?? 0;
      pickOccasionally = prefs.getBool("${keyPrefix}PickOccasionally") ?? false;
      bmWorkConditionRatingPoints =
          prefs.getInt("${keyPrefix}WorkConditionRatingPoints") ?? 0;
      bodyMovementBRatingPoints =
          prefs.getInt("${keyPrefix}BodyMovementBRatingPoints") ?? 0;
      roadConditionRatingPoints =
          prefs.getInt("${keyPrefix}RoadConditionRatingPoints") ?? 0;
      transportationWeightLabel =
          prefs.getString("${keyPrefix}TransportationWeightLabel") ?? "";
      spaceScore = prefs.getInt("${keyPrefix}SpaceScore") ?? 0;
      climateScore = prefs.getInt("${keyPrefix}ClimateScore") ?? 0;
      bmWorkOrganizationRatingPoints =
          prefs.getInt("${keyPrefix}WorkOrganizationRatingPoints") ?? 0;
      bmGender = prefs.getString("${widget.userName}_Gender") ?? "male";
      haveTransportation =
          prefs.getBool("${keyPrefix}HaveTransportation") ?? false;
      haveTransportSupport =
          prefs.getBool("${keyPrefix}HaveTransportSupport") ?? false;
      onlyTransportation =
          prefs.getBool("${keyPrefix}OnlyTransportation") ?? false;

      // 計算前三高風險
      List<Map<String, dynamic>> riskItems = [
        {
          'name': '活動-A',
          'score': bodyMovementARatingPoints.toDouble(),
          'index': 0,
        },
        {
          'name': '活動-B',
          'score': bodyMovementBRatingPoints.toDouble(),
          'index': 1,
        },
        {
          'name': '身體姿勢',
          'score': bodyPostureRatingPoints.toDouble(),
          'index': 2,
        },
        {
          'name': '重物重心',
          'score': loadWeightPositionRatingPoints.toDouble(),
          'index': 3,
        },
        if (!onlyTransportation) ...[
          {
            'name': '不良工作條件',
            'score': bmWorkConditionRatingPoints.toDouble(),
            'index': 4,
          },
        ],
        if (haveTransportation) ...[
          {
            'name': '路況',
            'score': roadConditionRatingPoints.toDouble(),
            'index': 5,
          },
        ],
        {
          'name': '工作時間分配',
          'score': bmWorkOrganizationRatingPoints.toDouble(),
          'index': 6,
        },
      ];

      // 按分數排序（從高到低）
      riskItems.sort(
            (a, b) => (b['score'] as double).compareTo(a['score'] as double),
      );
      int nonZeroCount =
          riskItems.where((item) => (item['score'] as double) > 0.0).length;

      // 更新前三高的數據
      topRiskIndices =
          riskItems
              .take(nonZeroCount)
              .map((item) => item['index'] as int)
              .toList();

      if (topRiskIndices.length > 3) {
        topRiskIndices =
            riskItems.take(3).map((item) => item['index'] as int).toList();
      }

      isLoading = false;

      if (onlyTransportation) {
        bmTotalPoints =
            bmTimePoints *
                (bodyMovementBRatingPoints +
                    roadConditionRatingPoints +
                    bmWorkOrganizationRatingPoints);
      } else if (haveTransportation) {
        bmTotalPoints =
            bmTotalPoints *
                (bodyMovementARatingPoints +
                    loadWeightPositionRatingPoints +
                    bodyPostureRatingPoints +
                    bmWorkConditionRatingPoints +
                    bodyMovementBRatingPoints +
                    roadConditionRatingPoints +
                    bmWorkOrganizationRatingPoints);
      } else {
        bmTotalPoints =
            bmTotalPoints *
                (bodyMovementARatingPoints +
                    loadWeightPositionRatingPoints +
                    bodyPostureRatingPoints +
                    bmWorkConditionRatingPoints +
                    bmWorkOrganizationRatingPoints);
      }

      if (bmGender == "Female") {
        bmTotalPoints *= 1.3;
      }
    });
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
          for (int i in [...topRiskIndices, 7, 8]) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: suggestionCardBM(
                widget.screenWidth,
                widget.screenHeight,
                widget.suggestionName,
                totalScore,
                i,
                bodyMovementARatingPoints,
                pickWalk,
                pickSlope,
                pickStair,
                pickClimbStair,
                pickClimbSteepStair,
                pickCrawl,
                loadWeightPositionRatingPoints,
                pickSupport,
                pickClose,
                pickAway,
                bodyPostureRatingPoints,
                pickOccasionally,
                bmWorkConditionRatingPoints,
                bodyMovementBRatingPoints,
                spaceScore,
                climateScore,
                roadConditionRatingPoints,
                transportationWeightLabel,
                bmWorkOrganizationRatingPoints,
                bmGender,
                haveTransportation,
                haveTransportSupport,
                onlyTransportation,
              ),
            ),
            SizedBox(height: widget.screenHeight * 0.027),
          ],
        ],
      ),
    );
  }
}
