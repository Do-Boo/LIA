// File: lib/presentation/screens/history_screen.dart
// 2025.07.15 22:05:00 히스토리 화면 구현 - Phase 4

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lia/presentation/widgets/specific/charts/bar_chart.dart';
import 'package:lia/presentation/widgets/specific/charts/donut_chart.dart';
import 'package:lia/presentation/widgets/specific/charts/gauge_chart.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../widgets/common/component_card.dart';
import '../widgets/common/primary_button.dart';
import '../widgets/common/secondary_button.dart';
import '../widgets/specific/charts/line_chart.dart';
import '../widgets/specific/feedback/toast_notification.dart';

/// 히스토리 화면
///
/// 메시지 작성 기록, 성과 분석, 통계 대시보드를 제공하는 화면
/// 18세 서현 페르소나에 맞는 성과 추적 및 개선 가이드 제공
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedPeriod = 0; // 0: 전체, 1: 최근 7일, 2: 최근 30일
  int _selectedFilter = 0; // 0: 전체, 1: 성공, 2: 대기, 3: 실패

  // 기간 필터 옵션
  final List<String> _periodOptions = ['전체', '최근 7일', '최근 30일'];

  // 상태 필터 옵션
  final List<FilterOption> _filterOptions = [
    FilterOption(title: '전체', icon: Icons.list, color: AppColors.primaryText),
    FilterOption(
      title: '성공',
      icon: HugeIcons.strokeRoundedCheckmarkCircle01,
      color: AppColors.green,
    ),
    FilterOption(
      title: '대기',
      icon: HugeIcons.strokeRoundedClock01,
      color: AppColors.accent,
    ),
    FilterOption(
      title: '실패',
      icon: HugeIcons.strokeRoundedCancelCircle,
      color: AppColors.error,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilters(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // 헤더 섹션
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedClock01,
                  color: AppColors.accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '히스토리',
                      style: AppTextStyles.mainTitle.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      '내 메시지 성과를 한눈에 확인하기',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatsButton(),
            ],
          ),
          const SizedBox(height: 16),
          _buildQuickStats(),
        ],
      ),
    );
  }

  // 통계 버튼
  Widget _buildStatsButton() {
    return GestureDetector(
      onTap: _showDetailedStats,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedAnalytics01,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              '상세 통계',
              style: AppTextStyles.helper.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 빠른 통계
  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStatItem(
            '총 메시지',
            '127',
            HugeIcons.strokeRoundedMessage01,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatItem(
            '성공률',
            '89.5%',
            HugeIcons.strokeRoundedTarget01,
            AppColors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatItem(
            '평균 답장률',
            '94.2%',
            Icons.reply,
            AppColors.accent,
          ),
        ),
      ],
    );
  }

  // 빠른 통계 아이템
  Widget _buildQuickStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          HugeIcon(icon: icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.helper.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // 필터 섹션
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 기간 필터
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedCalendar01,
                color: AppColors.primaryText,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '기간',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _periodOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String period = entry.value;
                      bool isSelected = index == _selectedPeriod;

                      return GestureDetector(
                        onTap: () => _selectPeriod(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            period,
                            style: AppTextStyles.helper.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryText,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 상태 필터
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedFilter,
                color: AppColors.primaryText,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '상태',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      FilterOption filter = entry.value;
                      bool isSelected = index == _selectedFilter;

                      return GestureDetector(
                        onTap: () => _selectFilter(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? filter.color
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? filter.color
                                  : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HugeIcon(
                                icon: filter.icon,
                                color: isSelected ? Colors.white : filter.color,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                filter.title,
                                style: AppTextStyles.helper.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primaryText,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 메인 컨텐츠
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              _buildPerformanceChart(),
              const SizedBox(height: 16),
              _buildChartsGrid(),
              const SizedBox(height: 16),
              _buildRecentMessages(),
              const SizedBox(height: 16),
              _buildInsights(),
              const SizedBox(height: 16),
              _buildRecommendations(),
            ],
          ),
        ),
      ),
    );
  }

  // 성과 차트 (호감도 변화 추이)
  Widget _buildPerformanceChart() {
    return ComponentCard(
      title: '📈 호감도 변화 추이',
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: LineChart(
              title: "주간 호감도 변화",
              data: [
                LineChartDataPoint(label: "월", value: 65),
                LineChartDataPoint(label: "화", value: 72),
                LineChartDataPoint(label: "수", value: 68),
                LineChartDataPoint(label: "목", value: 78),
                LineChartDataPoint(label: "금", value: 85),
                LineChartDataPoint(label: "토", value: 82),
                LineChartDataPoint(label: "일", value: 88),
              ],
              showLegend: true,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartLegend('호감도', AppColors.primary),
              _buildChartLegend('답장률', AppColors.accent),
              _buildChartLegend('성공률', AppColors.green),
            ],
          ),
        ],
      ),
    );
  }

  // 차트 그리드 (다양한 차트 타입 시연)
  Widget _buildChartsGrid() {
    return Column(
      children: [
        Row(
          children: [
            // 전체 호감도 게이지 차트
            Expanded(
              child: ComponentCard(
                title: '🎯 전체 호감도',
                child: GaugeChart(
                  data: {
                    'value': 88,
                    'maxValue': 100,
                    'unit': '%',
                    'primaryColor': AppColors.primary,
                    'backgroundColor': AppColors.primary.withValues(alpha: 0.1),
                  },
                  title: "현재 호감도",
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 메시지 성공률 도넛 차트
            Expanded(
              child: ComponentCard(title: '🍩 메시지 성공률', child: DonutChart()),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 대화 주제별 통계 막대 차트
        ComponentCard(title: '📊 대화 주제별 성공률', child: BarChart()),
      ],
    );
  }

  // 차트 범례
  Widget _buildChartLegend(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTextStyles.helper.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }

  // 최근 메시지 리스트
  Widget _buildRecentMessages() {
    final messages = _getRecentMessages();

    return ComponentCard(
      title: '💬 최근 메시지',
      child: Column(
        children: messages
            .map((message) => _buildMessageItem(message))
            .toList(),
      ),
    );
  }

  // 메시지 아이템
  Widget _buildMessageItem(MessageHistory message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: message.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: message.status.icon,
                    color: message.status.color,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.recipient,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      message.timestamp,
                      style: AppTextStyles.helper.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: message.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message.status.title,
                  style: AppTextStyles.helper.copyWith(
                    color: message.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message.content, style: AppTextStyles.body),
          ),
          if (message.result != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedAnalytics01,
                  color: AppColors.primaryText,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  message.result!,
                  style: AppTextStyles.helper.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // 인사이트
  Widget _buildInsights() {
    return ComponentCard(
      title: '🔍 인사이트',
      child: Column(
        children: [
          _buildInsightItem(
            '가장 성공적인 시간대',
            '오후 7-9시',
            '이 시간대 메시지 성공률이 95%로 가장 높아요',
            HugeIcons.strokeRoundedClock01,
            AppColors.green,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            '선호하는 메시지 스타일',
            '친근하고 유머러스한 톤',
            '상대방이 가장 잘 반응하는 메시지 스타일이에요',
            HugeIcons.strokeRoundedHappy,
            AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            '개선이 필요한 부분',
            '첫 메시지 응답률',
            '첫 메시지 응답률이 75%로 평균보다 낮아요',
            Icons.trending_up,
            AppColors.accent,
          ),
        ],
      ),
    );
  }

  // 인사이트 아이템
  Widget _buildInsightItem(
    String title,
    String value,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.helper.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.helper.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 추천 사항
  Widget _buildRecommendations() {
    return ComponentCard(
      title: '💡 추천 사항',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedBulb,
                      color: AppColors.accent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'AI가 분석한 개선 포인트',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRecommendationItem(
                  '메시지 타이밍 최적화',
                  '오후 7-9시에 메시지를 보내면 성공률이 20% 높아져요',
                ),
                const SizedBox(height: 12),
                _buildRecommendationItem(
                  '개인화된 메시지 작성',
                  '상대방의 관심사를 더 많이 반영한 메시지를 작성해보세요',
                ),
                const SizedBox(height: 12),
                _buildRecommendationItem(
                  '감정 표현 다양화',
                  '다양한 감정 표현을 통해 메시지에 생동감을 더해보세요',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        onPressed: () => _showAllRecommendations(),
                        text: '전체 보기',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () => _applyRecommendations(),
                        text: '적용하기',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 추천 아이템
  Widget _buildRecommendationItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyles.helper.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 최근 메시지 데이터
  List<MessageHistory> _getRecentMessages() {
    return [
      MessageHistory(
        recipient: '민수',
        content: '오늘 날씨 정말 좋네요! 산책하기 딱 좋은 날씨 같아요 😊',
        timestamp: '2시간 전',
        status: MessageStatus.success,
        result: '5분 만에 답장, 데이트 제안 성공',
      ),
      MessageHistory(
        recipient: '지혜',
        content: '그 카페 정말 분위기 좋더라구요! 다음에 또 가고 싶어요',
        timestamp: '1일 전',
        status: MessageStatus.pending,
        result: null,
      ),
      MessageHistory(
        recipient: '현우',
        content: '요즘 어떻게 지내세요? 바쁘신 것 같던데 몸 조심하세요!',
        timestamp: '3일 전',
        status: MessageStatus.success,
        result: '답장률 100%, 호감도 상승',
      ),
      MessageHistory(
        recipient: '수빈',
        content: '이번 주말에 시간 되시면 영화 보러 가실래요?',
        timestamp: '5일 전',
        status: MessageStatus.failed,
        result: '답장 없음, 다른 접근 필요',
      ),
    ];
  }

  // 기간 선택
  void _selectPeriod(int index) {
    setState(() {
      _selectedPeriod = index;
    });
  }

  // 필터 선택
  void _selectFilter(int index) {
    setState(() {
      _selectedFilter = index;
    });
  }

  // 상세 통계 보기
  void _showDetailedStats() {
    ToastNotification.show(
      context: context,
      message: '상세 통계 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 전체 추천 보기
  void _showAllRecommendations() {
    ToastNotification.show(
      context: context,
      message: '전체 추천 사항을 확인해보세요!',
      type: ToastType.info,
    );
  }

  // 추천 적용
  void _applyRecommendations() {
    ToastNotification.show(
      context: context,
      message: '추천 사항이 적용되었어요! 다음 메시지부터 반영됩니다',
      type: ToastType.success,
    );
  }
}

// 필터 옵션 모델
class FilterOption {
  final String title;
  final IconData icon;
  final Color color;

  FilterOption({required this.title, required this.icon, required this.color});
}

// 메시지 히스토리 모델
class MessageHistory {
  final String recipient;
  final String content;
  final String timestamp;
  final MessageStatus status;
  final String? result;

  MessageHistory({
    required this.recipient,
    required this.content,
    required this.timestamp,
    required this.status,
    this.result,
  });
}

// 메시지 상태 모델
class MessageStatus {
  final String title;
  final IconData icon;
  final Color color;

  MessageStatus({required this.title, required this.icon, required this.color});

  static MessageStatus success = MessageStatus(
    title: '성공',
    icon: HugeIcons.strokeRoundedCheckmarkCircle01,
    color: AppColors.green,
  );

  static MessageStatus pending = MessageStatus(
    title: '대기',
    icon: HugeIcons.strokeRoundedClock01,
    color: AppColors.accent,
  );

  static MessageStatus failed = MessageStatus(
    title: '실패',
    icon: HugeIcons.strokeRoundedCancelCircle,
    color: AppColors.error,
  );
}
