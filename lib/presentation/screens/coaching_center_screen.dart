// File: lib/presentation/screens/coaching_center_screen.dart
// 2025.07.23 14:25:00 카카오톡 스타일로 완전 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 코칭센터 화면
///
/// AI 메시지 작성 가이드, 팁, 상황별 템플릿을 제공하는 화면
/// 카카오톡 스타일의 심플하고 직관적인 구조로 구성
/// 상단 요약 + 하단 메뉴 리스트 패턴 적용
class CoachingCenterScreen extends StatefulWidget {
  const CoachingCenterScreen({super.key});

  @override
  State<CoachingCenterScreen> createState() => _CoachingCenterScreenState();
}

class _CoachingCenterScreenState extends State<CoachingCenterScreen> {
  // 코칭 데이터
  final Map<String, dynamic> _coachingData = {
    'totalTips': 127,
    'completedLessons': 8,
    'successRate': 89,
    'level': 'Advanced',
    'lastUpdate': '2025.07.23',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(child: _buildScreenWithScroll()),
  );

  // 상단 코칭 요약 섹션 (카카오톡 스타일)
  Widget _buildCoachingSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.transparent,
    child: Column(
      children: [
        // 코칭 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            HugeIcons.strokeRoundedBookOpen01,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),

        // 코칭센터 타이틀
        Text(
          'AI 코칭센터',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // 현재 레벨 및 상태
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_coachingData['level']} 레벨 • 성공률 ${_coachingData['successRate']}%',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  // 통계 섹션 (간단한 수치 표시)
  Widget _buildStatsSection() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Row(
      children: [
        Expanded(
          child: _buildStatItem('학습한 팁', '${_coachingData['totalTips']}개'),
        ),
        Container(width: 1, height: 40, color: AppColors.border),
        Expanded(
          child: _buildStatItem(
            '완료한 레슨',
            '${_coachingData['completedLessons']}개',
          ),
        ),
      ],
    ),
  );

  Widget _buildStatItem(String label, String value) => Column(
    children: [
      Text(
        value,
        style: AppTextStyles.h3.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
    ],
  );

  // 메뉴 그룹 (섹션 헤더)
  Widget _buildMenuGroup(String title, List<Widget> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Text(
          title,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      ...items,
      const SizedBox(height: 16),
    ],
  );

  /// 스크롤 가능한 화면
  Widget _buildScreenWithScroll() => CustomScrollView(
    slivers: [
      // 상단 코칭 요약 섹션
      SliverToBoxAdapter(child: _buildCoachingSummarySection()),

      // 메뉴 섹션
      SliverToBoxAdapter(child: _buildMenuContent()),
    ],
  );

  /// 메뉴 콘텐츠 (스크롤을 위해 ListView에서 Column으로 변경)
  Widget _buildMenuContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        // 기본 메시지 작성법
        _buildMenuGroup('기본 메시지 작성법', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMessage01,
            title: '첫 메시지 보내기',
            subtitle: '처음 대화를 시작하는 방법',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMessage01,
            title: '일상 대화 이어가기',
            subtitle: '자연스럽게 대화를 지속하는 팁',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedHeartAdd,
            title: '관심 표현하기',
            subtitle: '호감을 은근히 드러내는 방법',
            onTap: () {},
          ),
        ]),

        // 상황별 메시지
        _buildMenuGroup('상황별 메시지', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedCalendar01,
            title: '데이트 제안하기',
            subtitle: '자연스러운 만남 제안 방법',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: Icons.reply,
            title: '답장하기',
            subtitle: '상대방 메시지에 적절히 반응하기',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedGift,
            title: '축하 메시지',
            subtitle: '생일, 기념일 등 특별한 날 메시지',
            onTap: () {},
          ),
        ]),

        // 감정 표현
        _buildMenuGroup('감정 표현', [
          MenuItemWidget.defualt(
            icon: Icons.sentiment_satisfied,
            title: '기쁨 표현하기',
            subtitle: '즐거운 감정을 자연스럽게 전달',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedSad01,
            title: '위로 메시지',
            subtitle: '상대방이 힘들 때 보내는 메시지',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedFavourite,
            title: '애정 표현',
            subtitle: '좋아하는 마음을 표현하는 방법',
            onTap: () {},
          ),
        ]),

        // 고급 팁
        _buildMenuGroup('고급 팁', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedTarget01,
            title: 'MBTI별 소통법',
            subtitle: '성격 유형에 맞는 대화 스타일',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedChartUp,
            title: '호감도 높이기',
            subtitle: '상대방의 관심을 끄는 전략',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedBrain01,
            title: '심리학 활용법',
            subtitle: '연애 심리를 활용한 메시지 작성',
            onTap: () {},
          ),
        ]),

        // 분석 및 피드백
        _buildMenuGroup('분석 및 피드백', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics01,
            title: '내 대화 분석',
            subtitle: '지금까지의 대화 패턴 분석',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedBookmark02,
            title: '성공 사례 모음',
            subtitle: '실제 성공한 메시지 예시들',
            onTap: () {},
          ),
          MenuItemWidget.defualt(
            icon: Icons.help_outline,
            title: '자주 묻는 질문',
            subtitle: '코칭 관련 FAQ 및 해결책',
            onTap: () {},
          ),
        ]),

        // 하단 여백 추가
        const SizedBox(height: 40),
      ],
    ),
  );
}
