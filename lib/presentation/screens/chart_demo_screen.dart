// File: lib/presentation/screens/chart_demo_screen.dart
// 2025.07.23 14:56:44 카카오톡 스타일로 완전 리팩토링 + 린터 에러 수정

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 차트 데모 화면
///
/// 다양한 차트 위젯들을 카카오톡 스타일로 보여주는 화면
/// 상단 차트 요약 + 하단 차트 메뉴 리스트 패턴 적용
class ChartDemoScreen extends StatefulWidget {
  const ChartDemoScreen({super.key});

  @override
  State<ChartDemoScreen> createState() => _ChartDemoScreenState();
}

class _ChartDemoScreenState extends State<ChartDemoScreen> {
  // 차트 데이터
  final Map<String, dynamic> _chartData = {
    'totalCharts': 8,
    'favoriteChart': '파이 차트',
    'lastViewed': '2025.07.23',
    'interactiveCharts': 3,
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(child: _buildScreenWithScroll()),
  );

  // 상단 차트 요약 섹션 (카카오톡 스타일)
  Widget _buildChartSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.white.withValues(alpha: 0),
    child: Column(
      children: [
        // 차트 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [AppColors.green, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedAnalytics01,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 차트 데모 타이틀
        Text(
          '차트 데모',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // 차트 정보
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '총 ${_chartData['totalCharts']}개 차트 • 상호작용 ${_chartData['interactiveCharts']}개',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
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

  // 차트 데모 표시
  void _showChartDemo(String chartType) {
    ToastNotification.show(
      context: context,
      message: '$chartType 데모를 확인합니다',
      type: ToastType.info,
    );
  }

  // 데이터 형식 안내
  void _showDataFormat() {
    ToastNotification.show(
      context: context,
      message: 'JSON 데이터 형식 가이드를 확인합니다',
      type: ToastType.info,
    );
  }

  // 사용법 안내
  void _showUsageGuide() {
    ToastNotification.show(
      context: context,
      message: '차트 사용법 가이드를 확인합니다',
      type: ToastType.info,
    );
  }

  /// 스크롤 가능한 화면
  Widget _buildScreenWithScroll() => CustomScrollView(
    slivers: [
      // 상단 차트 요약 섹션
      SliverToBoxAdapter(child: _buildChartSummarySection()),

      // 차트 메뉴 섹션
      SliverToBoxAdapter(child: _buildChartMenuContent()),
    ],
  );

  /// 차트 메뉴 콘텐츠 (스크롤을 위해 ListView에서 Column으로 변경)
  Widget _buildChartMenuContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        // 기본 차트
        _buildMenuGroup('기본 차트', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics01,
            title: '바 차트',
            subtitle: '카테고리별 데이터를 막대로 표시',
            onTap: () => _showChartDemo('BarChart'),
            iconColor: AppColors.green,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics02,
            title: '파이 차트',
            subtitle: '비율을 원형으로 표시, 터치 상호작용',
            onTap: () => _showChartDemo('PieChart'),
            iconColor: AppColors.green,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics02,
            title: '도넛 차트',
            subtitle: '중앙에 구멍이 있는 원형 차트',
            onTap: () => _showChartDemo('DonutChart'),
            iconColor: AppColors.green,
          ),
        ]),

        _buildMenuGroup('트렌드 차트', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedChartUp,
            title: '라인 차트',
            subtitle: '시간에 따른 데이터 변화 추이',
            onTap: () => _showChartDemo('LineChart'),
            iconColor: AppColors.green,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics01,
            title: '히트맵 차트',
            subtitle: '시간/날짜별 활동 패턴 시각화',
            onTap: () => _showChartDemo('HeatmapChart'),
            iconColor: AppColors.green,
          ),
        ]),

        _buildMenuGroup('게이지 차트', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedDashboardSpeed01,
            title: '원형 게이지',
            subtitle: '진행률을 원형으로 표시',
            onTap: () => _showChartDemo('GaugeChart'),
            iconColor: AppColors.green,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedDashboardSpeed02,
            title: '반원 게이지',
            subtitle: '공간 효율적인 반원형 게이지',
            onTap: () => _showChartDemo('SemicircleGaugeChart'),
            iconColor: AppColors.green,
          ),
        ]),

        _buildMenuGroup('고급 차트', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedTarget01,
            title: '레이더 차트',
            subtitle: '다차원 데이터를 거미줄 형태로',
            onTap: () => _showChartDemo('RadarChart'),
            iconColor: AppColors.green,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics01,
            title: '커스텀 차트',
            subtitle: '프로젝트에 특화된 차트 디자인',
            onTap: () => _showChartDemo('CustomChart'),
            iconColor: AppColors.green,
          ),
        ]),

        // 사용 가이드
        _buildMenuGroup('사용 가이드', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedCode,
            title: 'JSON 데이터 형식',
            subtitle: '차트에서 사용하는 표준 데이터 구조',
            onTap: _showDataFormat,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedBookOpen01,
            title: '사용법 안내',
            subtitle: '차트 위젯 사용 시 참고사항',
            onTap: _showUsageGuide,
          ),
        ]),

        // 하단 여백 추가
        const SizedBox(height: 40),
      ],
    ),
  );
}
