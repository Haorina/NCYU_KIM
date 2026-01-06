import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget suggestionCard(
    double screenWidth,
    double screenHeight,
    List<String> suggestionName,
    double totalScore,
    int index,
    // 背部負荷選項
    bool isUprightStanding,
    String uprightStandingFreq,
    bool isTrunkTiltModerate,
    String trunkTiltModerateFreq,
    bool isSevereTrunkLean,
    String severeTrunkLeanFreq,
    bool isSitNoRelax,
    String sitNoRelaxFreq,
    bool isSitCanChange,
    String sitCanChangeFreq,
    bool canFree,
    // 肩膀上肢選項
    bool isHandAboveShoulder,
    String handAboveShoulderFreq,
    bool isUpperFromBodyWithoutSupport,
    String upperFromBodyWithoutSupportFreq,
    bool isLieDownOrLieProne,
    String lieDownOrLieProneFreq,
    // 下肢負荷選項
    bool isOftenStanding,
    String oftenStandingFreq,
    bool isSquatKneelSit,
    String squatKneelSitFreq,
    // 工作條件選項
    int trunkTwistOrTilt,
    bool isHeadTiltedBack,
    bool isLeanForward,
    bool isConfinedSpace,
    bool isUnstableFloor,
    bool isWet,
    bool isMentalFocus,
    bool isStrongVibration,
    // 其他
    double abpTimeRatingPoints,
    ) {
  String backLoadSuggestion() {
    List<String> suggestions = [];
    // 1. 直立站姿、軀幹前傾 < 20°
    if (isUprightStanding) {
      if (uprightStandingFreq == "<25") {
        suggestions.add("【直立/輕微前傾姿勢】可以維持此姿勢，但仍需注意定時變換姿勢。");
      } else if (uprightStandingFreq == "25-50") {
        suggestions.add("【直立/輕微前傾姿勢】建議在作業過程中適度走動或避免長時間同一姿勢。每工作1小時可休息5-10分鐘。");
      } else if (uprightStandingFreq == "51-75") {
        suggestions.add("【直立/輕微前傾姿勢】建議使用抗疲勞墊等減輕足部壓力，每工作45分鐘應走動或休息5分鐘。");
      } else {
        // >75
        suggestions.add(
          "【直立/輕微前傾姿勢】建議增加坐姿或走動的機會。應提供坐站交替的工作環境（如可升降工作台），並每工作45分鐘休息10分鐘，進行腰背和下肢伸展。",
        );
      }
    }

    // 2. 軀幹中等前傾(20-60°)、向後傾
    if (isTrunkTiltModerate) {
      if (trunkTiltModerateFreq == "<25") {
        suggestions.add("【中度前傾/後傾】短時間內可接受，但應避免重複進行。建議每30分鐘進行簡單伸展。");
      } else if (trunkTiltModerateFreq == "25-50") {
        suggestions.add("【中度前傾/後傾】應調整工作高度或使用輔助工具，減少軀幹前傾角度。每工作20分鐘休息並進行腰背伸展。");
      } else if (trunkTiltModerateFreq == "51-75") {
        suggestions.add(
          "【中度前傾/後傾】必須重新評估工作流程，使用升降設備或調整物品放置高度。建議每工作20分鐘休息並進行伸展運動。",
        );
      } else {
        // >75
        suggestions.add("【中度前傾/後傾】姿勢負荷過高，應立即改善。使用可調式工作台或升降設備，並強制每15分鐘休息一次。");
      }
    }

    // 3. 軀幹嚴重前傾(> 60°)
    if (isSevereTrunkLean) {
      if (severeTrunkLeanFreq == "<25") {
        suggestions.add("【嚴重前傾】應盡量避免此姿勢。若無法避免，每次作業後需充分休息並進行腰背伸展。");
      } else if (severeTrunkLeanFreq == "25-50") {
        suggestions.add("【嚴重前傾】姿勢風險極高，必須重新設計工作流程。使用機械化設備替代人工彎腰作業。");
      } else if (severeTrunkLeanFreq == "51-75") {
        suggestions.add("【嚴重前傾】造成極高背部負荷風險，必須立即改善。應使用自動化或機械化設備替代人工作業。");
      } else {
        // >75
        suggestions.add("【嚴重前傾】極度危險！必須立即停止此類作業。若短期內無法改善，應暫停此類作業直到完成改善措施。");
      }
    }

    // 4. 坐姿無法放鬆
    if (isSitNoRelax) {
      if (sitNoRelaxFreq == "<25") {
        suggestions.add("【坐姿無法放鬆】短時間可接受，但應適度變換坐姿，避免持續前傾超過20分鐘。");
      } else if (sitNoRelaxFreq == "25-50") {
        suggestions.add("【坐姿無法放鬆】建議調整工作台高度和椅子，使軀幹能有靠背支撐。每30分鐘站立活動一次。");
      } else if (sitNoRelaxFreq == "51-75") {
        suggestions.add("【坐姿無法放鬆】必須改善座椅和工作台配置，提供適當的腰部支撐。每20分鐘休息並進行伸展。");
      } else {
        // >75
        suggestions.add(
          "【坐姿無法放鬆】長時間無支撐坐姿會造成嚴重腰背負擔，必須立即改善工作環境，提供符合人體工學的座椅和工作台。",
        );
      }
    }

    // 5. 坐姿可變換
    if (isSitCanChange) {
      String freeSuffix = canFree ? "且可自由站立/走動" : "但無法自由站立/走動";

      if (sitCanChangeFreq == "<25") {
        suggestions.add(
          "【坐姿可變換，$freeSuffix】維持現有良好的工作型態，並確保座椅支持多種坐姿變化（如有扶手、可調整椅背角度）。",
        );
      } else if (sitCanChangeFreq == "25-50") {
        if (canFree) {
          suggestions.add("【坐姿可變換，$freeSuffix】工作型態良好，建議每1小時站立走動5分鐘，保持血液循環。");
        } else {
          suggestions.add("【坐姿可變換，$freeSuffix】建議增加站立或走動的機會，每45分鐘休息一次。");
        }
      } else if (sitCanChangeFreq == "51-75") {
        if (canFree) {
          suggestions.add("【坐姿可變換，$freeSuffix】建議每45分鐘站立走動10分鐘，並進行簡單伸展運動。");
        } else {
          suggestions.add("【坐姿可變換，$freeSuffix】應增加走動機會，考慮使用坐站交替工作台，每30分鐘變換姿勢。");
        }
      } else {
        // >75
        if (canFree) {
          suggestions.add(
            "【坐姿可變換，$freeSuffix】雖可自由活動，但久坐仍有風險。建議每30分鐘站立活動，並使用提醒工具。",
          );
        } else {
          suggestions.add(
            "【坐姿可變換，$freeSuffix】長時間坐姿且無法自由活動，必須改善工作安排，增加站立/走動時間，或使用坐站交替工作台。",
          );
        }
      }
    }

    // 如果沒有任何選項被選中
    if (suggestions.isEmpty) {
      return "請先完成背部負荷評估。";
    }

    return suggestions.join("\n\n");
  }

  // 🟢 新的肩膀上肢建議邏輯：基於選項和時間佔比
  String shoulderUpperLimbSuggestion(
      bool isHandAboveShoulder,
      String handAboveShoulderFreq,
      bool isUpperFromBodyWithoutSupport,
      String upperFromBodyWithoutSupportFreq,
      bool isLieDownOrLieProne,
      String lieDownOrLieProneFreq,
      ) {
    List<String> suggestions = [];

    // 1. 手高舉過肩
    if (isHandAboveShoulder) {
      if (handAboveShoulderFreq == "<25") {
        suggestions.add(
          "【手高舉過肩】建議使用梯子、升降平台或鷹架來提高作業人員位置，減少手臂高舉的需求。若無法避免，應每工作20分鐘放下手臂休息，並進行肩部伸展和放鬆。",
        );
      } else if (handAboveShoulderFreq == "25-50") {
        suggestions.add(
          "【手高舉過肩】使用適當高度的工作平台或輔助設備，將作業高度降至肩部以下。將連續高舉手臂限制在10-15分鐘內。考慮使用手臂支撐架或平衡臂等輔助裝置。",
        );
      } else if (handAboveShoulderFreq == "51-75") {
        suggestions.add(
          "【手高舉過肩】提高作業人員的工作位置或改變作業順序。應將此姿勢的作業時間減少50%，並與其他姿勢的工作交替進行，使連續高舉手臂限制在10-15分鐘內。",
        );
      } else {
        // >75
        suggestions.add(
          "【手高舉過肩】必須用升降設備、機械手臂或其他自動化裝置來替代人工高舉作業。若短期內無法改善，應立即大幅縮減作業時間至每天不超過2小時，並採取嚴格的輪班制度和肩部放鬆。",
        );
      }
    }

    // 2. 舉手但未過肩、遠離身體無支撐
    if (isUpperFromBodyWithoutSupport) {
      if (upperFromBodyWithoutSupportFreq == "<25") {
        suggestions.add(
          "【舉手未過肩、遠離身體無支撐】建議使用前臂支撐墊、工作台或其他支撐設備，讓手臂有依靠點。若無法提供支撐，進行肩部放鬆動作。",
        );
      } else if (upperFromBodyWithoutSupportFreq == "25-50") {
        suggestions.add(
          "【舉手未過肩、遠離身體無支撐】提供手臂或前臂的支撐裝置（如可調整高度的扶手、支撐架）。應將物品擺放位置調整至更靠近身體，減少手臂伸展距離。每工作30分鐘休息5分鐘。",
        );
      } else if (upperFromBodyWithoutSupportFreq == "51-75") {
        suggestions.add(
          "【舉手未過肩、遠離身體無支撐】建議提供充分的手臂支撐設備，或使用輔助工具（如彈簧平衡臂、機械手臂）來減輕肩部負擔。應將作業內容重新分配，與其他姿勢的工作交替進行，每工作30分鐘休息5分鐘。",
        );
      } else {
        // >75
        suggestions.add(
          "【舉手未過肩、遠離身體無支撐】必須提供完整的手臂支撐系統或使用機械化輔助設備。應縮減此姿勢的作業時間50%，並每工作30分鐘休息5分鐘。",
        );
      }
    }

    // 3. 躺下抬舉手臂 / 趴下手在身體下方或前方
    if (isLieDownOrLieProne) {
      if (lieDownOrLieProneFreq == "<25") {
        suggestions.add(
          "【躺下抬舉手臂/趴下手在身體下方或前方】使用適當的工作平台或支撐設備，讓作業人員能以更自然的姿勢工作。若無法避免，應每工作10-15分鐘休息5分鐘，並進行肩頸伸展。",
        );
      } else if (lieDownOrLieProneFreq == "25-50") {
        suggestions.add(
          "【躺下抬舉手臂/趴下手在身體下方或前方】強烈建議使用鏡子、攝影機或其他輔助工具來改善視線和手臂姿勢。應提供舒適的躺板或爬行墊，並確保有適當的手臂支撐。每工作15分鐘應休息。",
        );
      } else if (lieDownOrLieProneFreq == "51-75") {
        suggestions.add(
          "【躺下抬舉手臂/趴下手在身體下方或前方】必須改善工作環境和設備，使用機械化輔助裝置或改變作業順序。應將此姿勢的作業時間減少50%，並每工作15分鐘休息。必須提供充分的身體支撐和防護用具。",
        );
      } else {
        // >75
        suggestions.add(
          "【躺下抬舉手臂/趴下手在身體下方或前方】使用遙控設備、機器人或其他自動化技術來替代人工作業。若無法立即改善，應大幅縮減作業時間至每天不超過2小時，並採取嚴格的輪班制度。",
        );
      }
    }

    // 如果沒有任何選項被選中
    if (suggestions.isEmpty) {
      return "肩膀與上肢姿勢良好，維持現有作業方式即可。";
    }

    return suggestions.join("\n\n");
  }

  String lowerLimbSuggestion(
      bool isOftenStanding,
      String oftenStandingFreq,
      bool isSquatKneelSit,
      String squatKneelSitFreq,
      ) {
    List<String> suggestions = [];

    // 1. 經常站立，僅偶爾走幾步路
    if (isOftenStanding) {
      if (oftenStandingFreq == "<25") {
        suggestions.add(
          "【經常站立，僅偶爾走幾步路】建議使用抗疲勞墊減輕足部壓力，並多走動或變換站姿。每工作45分鐘可坐下休息5分鐘。",
        );
      } else if (oftenStandingFreq == "25-50") {
        suggestions.add(
          "【經常站立，僅偶爾走幾步路】建議提供坐站交替的工作環境，讓作業人員可以選擇坐下工作。應使用抗疲勞墊，並每工作30-45分鐘坐下休息5-10分鐘。",
        );
      } else if (oftenStandingFreq == "51-75") {
        suggestions.add(
          "【經常站立，僅偶爾走幾步路】強烈建議增加走動或坐下的機會。應提供可調整高度的工作台和高腳椅使輪流坐下。每工作30分鐘應休息或變換姿勢。必須使用抗疲勞墊和舒適的鞋具。",
        );
      } else {
        // >75
        suggestions.add(
          "【經常站立，僅偶爾走幾步路】必須提供坐站交替的選擇，採取強制性的休息制度，每工作25-30分鐘必須坐下休息或變換姿勢。建議使用抗疲勞墊、穿著壓力襪。",
        );
      }
    }

    // 2. 蹲、跪、坐姿翹腳
    if (isSquatKneelSit) {
      if (squatKneelSitFreq == "<25") {
        suggestions.add(
          "【蹲、跪、坐姿翹腳】使用護膝墊、跪墊等防護用具，減輕膝蓋負擔。使用低矮座椅或工作台來取代蹲跪姿勢。每維持蹲跪姿勢15分鐘應站起活動，伸展下肢肌肉。",
        );
      } else if (squatKneelSitFreq == "25-50") {
        suggestions.add(
          "【蹲、跪、坐姿翹腳】強烈建議改善作業方式，使用可調整高度的工作平台、滑板車座椅或爬行板來減少蹲跪需求。必須使用專業護膝和跪墊。應將連續蹲跪時間限制在15分鐘內。",
        );
      } else if (squatKneelSitFreq == "51-75") {
        suggestions.add(
          "【蹲、跪、坐姿翹腳】必須提高作業高度或使用機械化輔助設備。應將此姿勢的作業時間減少50%，並與其他姿勢的工作交替，將連續蹲跪時間限制在15分鐘內。",
        );
      } else {
        // >75
        suggestions.add(
          "【蹲、跪、坐姿翹腳】必須使用升降設備、工作台或自動化裝置來避免蹲跪需求。若短期內無法改善，應立即大幅縮減作業時間至每天不超過2小時，採輪班制度。必須提供下肢防護用具。",
        );
      }
    }

    // 如果沒有任何選項被選中
    if (suggestions.isEmpty) {
      return "下肢姿勢良好，維持現有作業方式即可。";
    }

    return suggestions.join("\n\n");
  }

  String workConditionSuggestion(
      int trunkTwistOrTilt, // 0=無, 2=偶爾, 3=經常
      bool isHeadTiltedBack, // 頭部後傾
      bool isLeanForward, // 軀幹前傾沒有支撐
      bool isConfinedSpace, // 狹窄空間
      bool isUnstableFloor, // 不穩定地板
      bool isWet, // 潮濕、冷、極乾
      bool isMentalFocus, // 極度心理專注
      bool isStrongVibration, // 強烈震動
      ) {
    List<String> suggestions = [];

    // 1. 軀幹扭轉/側傾
    if (trunkTwistOrTilt == 2) {
      suggestions.add("【軀幹扭轉/側傾 - 偶爾】偶發性的軀幹扭轉或側傾，較不會發生問題。但仍建議改以移動腳步來改變身體方向。");
    } else if (trunkTwistOrTilt == 3) {
      suggestions.add(
        "【軀幹扭轉/側傾 - 經常】建議將常用物品放置在正前方，避免頻繁扭轉，或改以移動整個身體來改變方向。應使用旋轉平台或滑板來輔助移動。需進行腰部伸展和放鬆。",
      );
    }

    // 2. 頭部後傾/嚴重前傾/維持轉頭姿勢
    if (isHeadTiltedBack) {
      suggestions.add(
        "【頭部後傾/嚴重前傾/維持轉頭姿勢】使用可調整的顯示器、文件架或其他輔助設備調整工作視線高度和角度，使頭部能保持中立位置。應進行頸部伸展。",
      );
    }

    // 3. 軀幹前傾時沒有支撐
    if (isLeanForward) {
      suggestions.add("【軀幹前傾時沒有支撐】強烈建議提供支撐設備，如可以用手撐的工作台邊緣、扶手、或身體可以靠著的牆面或支撐架。");
    }

    // 4. 經常處在狹窄空間
    if (isConfinedSpace) {
      suggestions.add(
        "【經常處在狹窄空間】建議盡可能擴大工作空間，清除不必要的障礙物。若無法改善空間大小，應提供適當的輔助工具，或縮短在狹窄空間內的連續作業時間。適當休息和伸展。",
      );
    }

    // 5. 不穩定、不平整地板
    if (isUnstableFloor) {
      suggestions.add(
        "【不穩定、不平整地板】改善地板條件，鋪設平整的地板或使用防滑墊。應穿著防滑且有良好支撐的鞋具，並在作業時注意腳步穩定，或使用扶手或支撐設備。",
      );
    }

    // 6. 潮濕、冷、極乾、衣服淋濕
    if (isWet) {
      suggestions.add(
        "【潮濕、冷、極乾、衣服淋濕】改善環境的溫濕度控制，提供通風、加熱或除濕設備。應穿著適合環境的防護衣物（如防水衣、保暖衣、手套），並在寒冷環境中縮短作業時間或工作前應進行充分的暖身運動。",
      );
    }

    // 7. 需極度心理專注
    if (isMentalFocus) {
      suggestions.add("【需極度心理專注】避免長時間持續高度專注。應每工作45分鐘休息10分鐘，進行放鬆活動或變換工作內容。");
    }

    // 8. 強烈震動
    if (isStrongVibration) {
      suggestions.add(
        "【強烈震動】使用減震座墊、減震手套或減震鞋墊等防護用具。應選擇震動較小的設備或工具並定期維護。若長時間暴露於震動環境，應每工作45分鐘休息10分鐘。",
      );
    }

    // 如果沒有任何選項被選中
    if (suggestions.isEmpty) {
      return "工作條件良好，維持現有環境即可。";
    }

    return suggestions.join("\n\n");
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
            "背部負荷",
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
            backLoadSuggestion(),
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
            "肩膀上肢負荷",
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
            shoulderUpperLimbSuggestion(
              isHandAboveShoulder,
              handAboveShoulderFreq,
              isUpperFromBodyWithoutSupport,
              upperFromBodyWithoutSupportFreq,
              isLieDownOrLieProne,
              lieDownOrLieProneFreq,
            ),
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
            "下肢負荷",
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
            lowerLimbSuggestion(
              isOftenStanding,
              oftenStandingFreq,
              isSquatKneelSit,
              squatKneelSitFreq,
            ),
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
            "工作條件",
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
            workConditionSuggestion(
              trunkTwistOrTilt,
              isHeadTiltedBack,
              isLeanForward,
              isConfinedSpace,
              isUnstableFloor,
              isWet,
              isMentalFocus,
              isStrongVibration,
            ),
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: const Color(0xFF544D4D),
            ),
          ),
        ),
      ],
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
            abpTimeRatingPoints == 0.0
                ? '仍需注意作業姿勢，避免在這段時間內持續維持同一不良姿勢。建議每30分鐘變換姿勢或進行簡單的伸展活動。'
                : (abpTimeRatingPoints <= 5.0
                ? '建議每工作45-60分鐘休息10-15分鐘，並在休息時進行針對性的伸展運動。應盡可能變換工作姿勢，避免持續維持單一不良姿勢超過30分鐘。'
                : '強烈建議縮減作業時間至少至6小時以下，或採取輪班制度分散工作負荷。必須進行工作再設計，改善作業姿勢或使用機械化輔助設備。'),
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
            totalScore >= 50.0
                ? '姿勢負荷極高，生理過載極可能發生，會產生明確的健康傷害。強烈建議立即進行全面性的工作再設計，並進行健康監測追蹤。'
                : (totalScore >= 25.0
                ? '對一般族群有生理過載可能性。建議重新設計工作流程和環境，減少不良姿勢的持續時間和頻率。'
                : (totalScore >= 10.0
                ? '對恢復能力較弱者（如年長者、有舊傷者）有生理過載可能性。建議針對這些族群提供更多的休息時間和姿勢變換機會。'
                : '生理過載可能性低。偶爾維持此類姿勢不會造成嚴重傷害，但仍需注意避免累積性負擔。')),
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
            totalScore >= 50.0
                ? '▪立即停止高風險作業，並進行工作流程與環境的全面再設計。\n▪導入機械輔助設備（如升降平台、可調式工作台、支撐臂），徹底降低手動操作比例。\n▪建立嚴格健康監測計畫，將該類高風險作業列入職業安全衛生優先改善項目。\n▪對已有症狀的員工進行專業醫療檢查，必要時調整或轉換其工作內容。'
                : (totalScore >= 25.0
                ? '▪建議重新設計工作流程，降低長時間或高強度的不良姿勢負荷。\n▪增設輔助工具（如可調式工作台、護具），並安排充分的休息與恢復時間。\n▪提供必要的防護裝備，並安排專業健康檢查，每季進行一次風險評估。\n▪加強員工的人體工學訓練與正確姿勢教育。'
                : (totalScore >= 10.0
                ? '▪對恢復能力較弱者（如年長員工、已有慢性疾病或疲勞者）應適度調整作業方式。\n▪增加休息或工作輪換，避免單一高負荷持續過久。\n▪採取基本改善措施，例如使用人體工學工具，並安排短暫休息（每小時5-10分鐘）。\n▪規劃員工訓練，強化正確姿勢與作業技巧。'
                : '▪一般無需額外措施。\n▪建議持續維持現有作業方式，並注意正確的姿勢與基本的人體工學原則。\n▪定期檢視工作環境與操作流程，避免潛在風險逐漸累積。')),
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

class ResultSuggestionABP extends StatefulWidget {
  final String? userName;
  final List<int> topRiskIndices; // 🟢 新增：前三高風險的索引 (0=背部, 1=肩膀, 2=下肢, 3=工作條件)

  const ResultSuggestionABP({
    super.key,
    required this.suggestionName,
    required this.totalScore,
    required this.screenWidth,
    required this.screenHeight,
    this.userName,
    this.topRiskIndices = const [0, 1, 2], // 預設顯示前三個
  });

  final List<String> suggestionName;
  final double totalScore;
  final double screenWidth;
  final double screenHeight;

  @override
  State<ResultSuggestionABP> createState() => _ResultSuggestionABPState();
}

class _ResultSuggestionABPState extends State<ResultSuggestionABP> {
  double backLoadRatingPoints = 0;
  int shoulderUpperLimbLoadRatingPoints = 0;
  int lowerLimbLoadRatingPoints = 0;
  int abpWorkConditionRatingPoints = 0;
  double abpTimeRatingPoints = 0;
  double totalScore = 0;

  // 前三高風險的數據
  List<int> topRiskIndices = [];
  List<String> mostRiskText = [];
  List<num> mostRiskScore = [];

  bool isLoading = true;

  // 🟢 新增：背部負荷的選項狀態
  bool isUprightStanding = false;
  String uprightStandingFreq = "<25";
  bool isTrunkTiltModerate = false;
  String trunkTiltModerateFreq = "<25";
  bool isSevereTrunkLean = false;
  String severeTrunkLeanFreq = "<25";
  bool isSitNoRelax = false;
  String sitNoRelaxFreq = "<25";
  bool isSitCanChange = false;
  String sitCanChangeFreq = "<25";
  bool canFree = false;

  // 🟢 新增：工作條件的選項狀態
  int trunkTwistOrTilt = 0; // 0=無, 2=偶爾, 3=經常
  bool isHeadTiltedBack = false;
  bool isLeanForward = false;
  bool isConfinedSpace = false;
  bool isUnstableFloor = false;
  bool isWet = false;
  bool isMentalFocus = false;
  bool isStrongVibration = false;

  bool isHandAboveShoulder = false;
  String handAboveShoulderFreq = "<25";
  bool isUpperFromBodyWithoutSupport = false;
  String upperFromBodyWithoutSupportFreq = "<25";
  bool isLieDownOrLieProne = false;
  String lieDownOrLieProneFreq = "<25";

  bool isOftenStanding = false;
  String oftenStandingFreq = "<25";
  bool isSquatKneelSit = false;
  String squatKneelSitFreq = "<25";

  bool partB = false;
  bool partC = false;

  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String keyPrefix =
    (widget.userName != null && widget.userName != "vJ#CA:F3zP)C]A=V")
        ? '${widget.userName}_ABP_'
        : '';

    setState(() {
      abpTimeRatingPoints =
          prefs.getDouble('${keyPrefix}TimeRatingPoints') ?? 0;

      // 🟢 讀取背部負荷的選項狀態
      isUprightStanding = prefs.getBool('${keyPrefix}BackLoadSelect1') ?? false;
      uprightStandingFreq =
          prefs.getString('${keyPrefix}BackLoadLabel1') ?? "<25";
      isTrunkTiltModerate =
          prefs.getBool('${keyPrefix}BackLoadSelect2') ?? false;
      trunkTiltModerateFreq =
          prefs.getString('${keyPrefix}BackLoadLabel2') ?? "<25";

      isSevereTrunkLean = prefs.getBool('${keyPrefix}BackLoadSelect3') ?? false;
      severeTrunkLeanFreq =
          prefs.getString('${keyPrefix}BackLoadLabel3') ?? "<25";

      isSitNoRelax = prefs.getBool('${keyPrefix}BackLoadSelect4') ?? false;
      sitNoRelaxFreq = prefs.getString('${keyPrefix}BackLoadLabel4') ?? "<25";

      isSitCanChange = prefs.getBool('${keyPrefix}BackLoadSelect5') ?? false;
      sitCanChangeFreq = prefs.getString('${keyPrefix}BackLoadLabel5') ?? "<25";

      canFree = prefs.getBool('${keyPrefix}BackLoadCanFree') ?? false;

      // 🟢 讀取肩膀上肢的選項狀態
      isHandAboveShoulder =
          prefs.getBool('${keyPrefix}_ShoulderUpperLimbLoadSelect1') ?? false;
      handAboveShoulderFreq =
          prefs.getString('${keyPrefix}ShoulderUpperLimbLoadLabel1') ?? "<25";

      isUpperFromBodyWithoutSupport =
          prefs.getBool('${keyPrefix}_ShoulderUpperLimbLoadSelect2') ?? false;
      upperFromBodyWithoutSupportFreq =
          prefs.getString('${keyPrefix}ShoulderUpperLimbLoadLabel2') ?? "<25";

      isLieDownOrLieProne =
          prefs.getBool('${keyPrefix}_ShoulderUpperLimbLoadSelect3') ?? false;
      lieDownOrLieProneFreq =
          prefs.getString('${keyPrefix}ShoulderUpperLimbLoadLabel3') ?? "<25";

      // 🟢 讀取下肢負荷的選項狀態
      isOftenStanding =
          prefs.getBool('${keyPrefix}LowerLimbLoadSelect1') ?? false;
      oftenStandingFreq =
          prefs.getString('${keyPrefix}LowerLimbLoadLabel1') ?? "<25";

      isSquatKneelSit =
          prefs.getBool('${keyPrefix}LowerLimbLoadSelect2') ?? false;
      squatKneelSitFreq =
          prefs.getString('${keyPrefix}LowerLimbLoadLabel2') ?? "<25";

      partB = prefs.getBool('${keyPrefix}PartB') ?? false;
      partC = prefs.getBool('${keyPrefix}PartC') ?? false;

      // 🟢 讀取工作條件的選項狀態
      bool temp1, temp2, temp3;
      temp1 = prefs.getBool('${keyPrefix}WorkConditionSelect1') ?? false;
      temp2 = prefs.getBool('${keyPrefix}WorkConditionSelect2') ?? false;
      temp3 = prefs.getBool('${keyPrefix}WorkConditionSelect3') ?? false;

      if (temp1) {
        trunkTwistOrTilt = 0;
      } else if (temp2) {
        trunkTwistOrTilt = 2;
      } else if (temp3) {
        trunkTwistOrTilt = 3;
      }

      isHeadTiltedBack =
          prefs.getBool('${keyPrefix}WorkConditionSelect4') ?? false;
      isLeanForward =
          prefs.getBool('${keyPrefix}WorkConditionSelect6') ?? false;
      isConfinedSpace =
          prefs.getBool('${keyPrefix}WorkConditionSelect7') ?? false;
      isUnstableFloor =
          prefs.getBool('${keyPrefix}WorkConditionSelect8') ?? false;
      isWet = prefs.getBool('${keyPrefix}WorkConditionSelect9') ?? false;
      isMentalFocus =
          prefs.getBool('${keyPrefix}WorkConditionSelect10') ?? false;
      isStrongVibration =
          prefs.getBool('${keyPrefix}WorkConditionSelect11') ?? false;

      // 計算總分
      double backLoadRatingPoints =
          prefs.getDouble('${keyPrefix}BackLoadRatingPoints') ?? 0;
      int shoulderUpperLimbLoadRatingPoints =
          prefs.getInt('${keyPrefix}ShoulderUpperLimbLoadRatingPoints') ?? 0;
      int lowerLimbLoadRatingPoints =
          prefs.getInt('${keyPrefix}LowerLimbLoadRatingPoints') ?? 0;
      int abpWorkConditionRatingPoints =
          prefs.getInt('${keyPrefix}WorkConditionRatingPoints') ?? 0;
      totalScore =
          abpTimeRatingPoints *
              (backLoadRatingPoints +
                  shoulderUpperLimbLoadRatingPoints +
                  lowerLimbLoadRatingPoints +
                  abpWorkConditionRatingPoints);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPoints();
    _loadAndCalculate();
  }

  Future<void> _loadAndCalculate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String keyPrefix =
    (widget.userName != null && widget.userName != "vJ#CA:F3zP)C]A=V")
        ? '${widget.userName}_ABP_'
        : '';

    // 讀取各項分數
    double backLoad = prefs.getDouble('${keyPrefix}BackLoadRatingPoints') ?? 0;
    int shoulderLoad =
        prefs.getInt('${keyPrefix}ShoulderUpperLimbLoadRatingPoints') ?? 0;
    int lowerLoad = prefs.getInt('${keyPrefix}LowerLimbLoadRatingPoints') ?? 0;
    int workCondition =
        prefs.getInt('${keyPrefix}WorkConditionRatingPoints') ?? 0;
    double timeRating = prefs.getDouble('${keyPrefix}TimeRatingPoints') ?? 0;

    // 計算前三高風險
    List<Map<String, dynamic>> riskItems = [
      {'name': '背部負荷', 'score': backLoad, 'index': 0},
      if (partB) ...[
        {'name': '肩膀上肢負荷', 'score': shoulderLoad.toDouble(), 'index': 1},
      ],
      if (partC) ...[
        {'name': '下肢負荷', 'score': lowerLoad.toDouble(), 'index': 2},
      ],
      {'name': '工作條件', 'score': workCondition.toDouble(), 'index': 3},
    ];

    // 按分數排序（從高到低）
    riskItems.sort(
          (a, b) => (b['score'] as double).compareTo(a['score'] as double),
    );
    int nonZeroCount =
        riskItems.where((item) => (item['score'] as double) > 0.0).length;

    setState(() {
      backLoadRatingPoints = backLoad;
      shoulderUpperLimbLoadRatingPoints = shoulderLoad;
      lowerLimbLoadRatingPoints = lowerLoad;
      abpWorkConditionRatingPoints = workCondition;
      abpTimeRatingPoints = timeRating;
      totalScore =
          timeRating * (backLoad + shoulderLoad + lowerLoad + workCondition);

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

          // ✅ 改用動態最高三項 + 健康疑慮 + 採取措施
          for (int i in [...topRiskIndices, 5, 6]) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: suggestionCard(
                widget.screenWidth,
                widget.screenHeight,
                widget.suggestionName,
                totalScore,
                i,
                // 背部負荷
                isUprightStanding,
                uprightStandingFreq,
                isTrunkTiltModerate,
                trunkTiltModerateFreq,
                isSevereTrunkLean,
                severeTrunkLeanFreq,
                isSitNoRelax,
                sitNoRelaxFreq,
                isSitCanChange,
                sitCanChangeFreq,
                canFree,
                // 肩膀上肢
                isHandAboveShoulder,
                handAboveShoulderFreq,
                isUpperFromBodyWithoutSupport,
                upperFromBodyWithoutSupportFreq,
                isLieDownOrLieProne,
                lieDownOrLieProneFreq,
                // 下肢負荷
                isOftenStanding,
                oftenStandingFreq,
                isSquatKneelSit,
                squatKneelSitFreq,
                // 工作條件
                trunkTwistOrTilt,
                isHeadTiltedBack,
                isLeanForward,
                isConfinedSpace,
                isUnstableFloor,
                isWet,
                isMentalFocus,
                isStrongVibration,
                // 其他
                abpTimeRatingPoints,
              ),
            ),
            SizedBox(height: widget.screenHeight * 0.027),
          ],
        ],
      ),
    );
  }
}
