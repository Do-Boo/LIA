// File: lib/presentation/widgets/specific/navigation/custom_tab_bar.dart
// 2025.07.15 20:09:12 생성 - 18세 서현 페르소나 맞춤 TabBar 위젯

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// LIA 앱에서 사용하는 커스텀 TabBar 위젯입니다.
///
/// body 영역에서 사용하는 심플하고 깔끔한 스타일의 탭 바입니다.
/// 상하단 네비게이션과 차별화되는 미니멀한 디자인을 제공합니다.
///
/// 주요 특징:
/// - 심플한 언더라인 스타일 인디케이터
/// - 깔끔한 텍스트 중심 디자인
/// - 눈에 띄지 않는 서브틀한 색상 사용
/// - 18세 서현 페르소나에 맞는 친근한 텍스트 스타일
///
/// 사용 예시:
/// ```dart
/// CustomTabBar(
///   tabs: [
///     CustomTab(
///       icon: HugeIcons.strokeRoundedHome01,
///       text: "홈",
///     ),
///     CustomTab(
///       icon: HugeIcons.strokeRoundedMessage01,
///       text: "메시지",
///     ),
///   ],
/// )
/// ```
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// 표시할 탭 목록
  final List<CustomTab> tabs;

  /// 탭 바 높이 (기본값: 48)
  final double height;

  /// 탭 바 배경색 (기본값: background)
  final Color? backgroundColor;

  /// 선택된 탭의 텍스트 색상 (기본값: primary)
  final Color selectedTextColor;

  /// 비선택된 탭의 텍스트 색상 (기본값: secondaryText)
  final Color unselectedTextColor;

  /// 인디케이터 색상 (기본값: primary)
  final Color indicatorColor;

  /// 인디케이터 두께 (기본값: 2.0)
  final double indicatorWeight;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.height = 48,
    this.backgroundColor,
    this.selectedTextColor = AppColors.primary,
    this.unselectedTextColor = AppColors.secondaryText,
    this.indicatorColor = AppColors.primary,
    this.indicatorWeight = 2.0,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.0)),
      ),
      child: TabBar(
        tabs: tabs.map((tab) => _buildTab(tab)).toList(),
        labelColor: selectedTextColor,
        unselectedLabelColor: unselectedTextColor,
        labelStyle: AppTextStyles.body.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.body.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: indicatorColor, width: indicatorWeight),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  /// 개별 탭을 생성하는 메서드입니다.
  Widget _buildTab(CustomTab tab) {
    return Tab(
      height: height - 2, // 하단 보더 고려
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (tab.icon != null) ...[
            Icon(
              tab.icon!,
              size: 16,
              // color는 지정하지 않아서 TabBar의 labelColor가 자동 적용됨
            ),
            if (tab.text != null) const SizedBox(width: 6),
          ],
          if (tab.text != null)
            Flexible(
              child: Text(
                tab.text!,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
        ],
      ),
    );
  }
}

/// 개별 탭 정보를 담는 클래스입니다.
class CustomTab {
  /// 탭 아이콘 (선택사항)
  final IconData? icon;

  /// 탭 텍스트 (선택사항)
  final String? text;

  const CustomTab({this.icon, this.text});
}

/// LIA 앱에서 사용하는 사전 정의된 탭 스타일들입니다.
class LiaTabStyles {
  /// 메시지 카테고리 탭들 (텍스트 중심)
  static List<CustomTab> get messageCategories => [
    const CustomTab(text: "인스타 스토리"),
    const CustomTab(text: "읽씹 후 재접근"),
    const CustomTab(text: "단답 답장"),
    const CustomTab(text: "첫 DM"),
  ];

  /// 분석 결과 탭들 (텍스트 중심)
  static List<CustomTab> get analysisTabs => [
    const CustomTab(text: "종합 분석"),
    const CustomTab(text: "감정 흐름"),
    const CustomTab(text: "대화 패턴"),
    const CustomTab(text: "추천 액션"),
  ];

  /// 설정 탭들 (아이콘 + 텍스트)
  static List<CustomTab> get settingsTabs => [
    const CustomTab(icon: HugeIcons.strokeRoundedUserCircle, text: "프로필"),
    const CustomTab(icon: HugeIcons.strokeRoundedNotification01, text: "알림"),
    const CustomTab(icon: HugeIcons.strokeRoundedSettings01, text: "설정"),
  ];
}

/// LIA 앱에서 사용하는 사전 정의된 탭 컨텐츠들입니다.
class LiaTabContents {
  /// 메시지 카테고리 컨텐츠들을 반환합니다.
  static List<Widget> getMessageCategoryContents() {
    return [
      _buildCategoryContent(
        "인스타 스토리 답장",
        "썸남의 스토리에 자연스럽게 답장하는 메시지를 만들어드려요! 😊",
        [
          "• 스토리 내용에 맞는 자연스러운 반응",
          "• 관심 표현과 동시에 대화 이어가기",
          "• 너무 티나지 않는 센스있는 답장",
          "• 서현이 나이대에 맞는 트렌디한 표현",
        ],
      ),
      _buildCategoryContent(
        "읽씹 당한 후 재접근",
        "읽씹 당했을 때 자연스럽게 다시 대화를 시작하는 방법이에요! 💪",
        [
          "• 부담스럽지 않은 재접근 메시지",
          "• 새로운 화제로 자연스럽게 전환",
          "• 상황에 맞는 적절한 타이밍 조절",
          "• 상대방이 답장하기 쉬운 오픈 질문",
        ],
      ),
      _buildCategoryContent("단답 답장 받았을 때", "단답으로 답장받았을 때 대화를 이어가는 스킬이에요! 🎯", [
        "• 단답의 의미 파악하고 적절히 대응",
        "• 흥미로운 새 화제로 관심 끌기",
        "• 상대방의 말을 더 끌어내는 질문",
        "• 대화 분위기를 살리는 유머 포인트",
      ]),
      _buildCategoryContent("첫 DM 보내기", "처음 DM을 보낼 때 좋은 첫인상을 남기는 메시지예요! ✨", [
        "• 자연스러운 첫 인사와 자기소개",
        "• 공통 관심사나 연결고리 찾기",
        "• 부담스럽지 않은 대화 시작점",
        "• 상대방이 답장하고 싶어지는 매력적인 메시지",
      ]),
    ];
  }

  /// 분석 결과 컨텐츠들을 반환합니다.
  static List<Widget> getAnalysisContents() {
    return [
      _buildAnalysisContent("종합 분석 결과", "썸남과의 대화를 종합적으로 분석한 결과예요! 📊", [
        "• 전체적인 호감도 점수",
        "• 대화 패턴과 응답 속도 분석",
        "• 관심 주제와 선호도 파악",
        "• 발전 가능성 예측",
      ]),
      _buildAnalysisContent("감정 흐름 분석", "대화 속 감정 변화를 시간순으로 분석해봤어요! 💝", [
        "• 시간대별 감정 변화 그래프",
        "• 긍정/부정 감정 비율",
        "• 특별한 감정 변화 포인트",
        "• 감정 패턴 예측",
      ]),
      _buildAnalysisContent("대화 패턴 분석", "둘만의 대화 스타일과 패턴을 분석해봤어요! 🎭", [
        "• 대화 주도권과 참여도",
        "• 선호하는 대화 주제",
        "• 대화 시간대와 빈도",
        "• 커뮤니케이션 스타일 매칭",
      ]),
      _buildAnalysisContent("추천 액션 플랜", "분석 결과를 바탕으로 한 맞춤 행동 계획이에요! 🚀", [
        "• 다음 단계 추천 액션",
        "• 효과적인 대화 주제 제안",
        "• 타이밍과 접근 방법 가이드",
        "• 관계 발전을 위한 구체적 팁",
      ]),
    ];
  }

  /// 카테고리 컨텐츠를 생성하는 헬퍼 메서드입니다.
  static Widget _buildCategoryContent(
    String title,
    String description,
    List<String> features,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                feature,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.charcoal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 분석 컨텐츠를 생성하는 헬퍼 메서드입니다.
  static Widget _buildAnalysisContent(
    String title,
    String description,
    List<String> features,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                feature,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.charcoal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 