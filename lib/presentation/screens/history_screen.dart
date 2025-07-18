// File: lib/presentation/screens/history_screen.dart
// 2025.07.18 13:27:31 히스토리 화면 main_screen.dart 스타일로 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../widgets/common/primary_button.dart';
import '../widgets/specific/feedback/toast_notification.dart';

/// 히스토리 화면
///
/// 분석했던 사람들의 분석 리스트를 제공하는 화면
/// 최대 10명까지 저장되며, 각 분석 결과를 확인할 수 있음
/// 18세 서현 페르소나에 맞는 분석 기록 관리
/// main_screen.dart 스타일로 통일된 디자인 적용
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // 분석 리스트 데이터
  List<AnalysisHistory> _analysisHistory = [];

  @override
  void initState() {
    super.initState();
    _loadAnalysisHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0,
            vertical: 12.0,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // 대시보드 헤더
                _buildDashboardHeader(),

                const SizedBox(height: 24),
                // 1. 분석 리스트
                _buildChartDemoSection(
                  number: '1',
                  title: '분석 기록',
                  description: '지금까지 분석한 사람들의 기록을 확인해보세요',
                  child: _buildAnalysisListContent(),
                ),

                if (_analysisHistory.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  // 2. 분석 통계
                  _buildChartDemoSection(
                    number: '2',
                    title: '분석 통계',
                    description: '전체 분석 결과를 한눈에 확인해보세요',
                    child: _buildAnalysisStatsContent(),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 대시보드 헤더
  Widget _buildDashboardHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.9),
            AppColors.accent.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedClock01,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '분석 기록',
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          HugeIcons.strokeRoundedAnalytics01,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '지금까지 분석한 사람들의 기록',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              _buildNewAnalysisButton(),
            ],
          ),
          const SizedBox(height: 20),
          _buildQuickInfo(),
        ],
      ),
    );
  }

  // 새 분석 버튼
  Widget _buildNewAnalysisButton() {
    return GestureDetector(
      onTap: _startNewAnalysis,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              HugeIcons.strokeRoundedAdd01,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              '새 분석',
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

  // 빠른 정보
  Widget _buildQuickInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '${_analysisHistory.length}',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '분석 완료',
                  style: AppTextStyles.helper.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${10 - _analysisHistory.length}',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '남은 슬롯',
                  style: AppTextStyles.helper.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 개선된 섹션 빌더 - main_screen.dart 스타일
  Widget _buildChartDemoSection({
    required String number,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 20 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width > 600 ? 20 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 개선된 헤더
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    number,
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: MediaQuery.of(context).size.width > 600
                            ? 18
                            : 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: MediaQuery.of(context).size.width > 600
                            ? 13
                            : 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 콘텐츠
          child,
        ],
      ),
    );
  }

  // 분석 리스트 컨텐츠
  Widget _buildAnalysisListContent() {
    if (_analysisHistory.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _analysisHistory.length,
      itemBuilder: (context, index) {
        final analysis = _analysisHistory[index];
        return _buildAnalysisItem(analysis);
      },
    );
  }

  // 빈 상태 위젯
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              HugeIcons.strokeRoundedAnalytics01,
              color: AppColors.accent,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 분석 기록이 없어요',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 분석을 시작해보세요!\n최대 10명까지 저장할 수 있어요',
            style: AppTextStyles.helper.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(onPressed: _startNewAnalysis, text: '첫 분석 시작하기'),
        ],
      ),
    );
  }

  // 분석 통계 컨텐츠
  Widget _buildAnalysisStatsContent() {
    final successCount = _analysisHistory
        .where((a) => a.status == AnalysisStatus.success)
        .length;
    final pendingCount = _analysisHistory
        .where((a) => a.status == AnalysisStatus.pending)
        .length;
    final failedCount = _analysisHistory
        .where((a) => a.status == AnalysisStatus.failed)
        .length;

    return Column(
      children: [
        // 상태별 통계
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '성공',
                successCount.toString(),
                AppColors.green,
                HugeIcons.strokeRoundedCheckmarkCircle01,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '분석 중',
                pendingCount.toString(),
                AppColors.accent,
                HugeIcons.strokeRoundedClock01,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '실패',
                failedCount.toString(),
                AppColors.error,
                HugeIcons.strokeRoundedCancelCircle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 성공률 표시
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.accent.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedTarget01,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '전체 성공률',
                      style: AppTextStyles.helper.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_analysisHistory.isNotEmpty ? ((successCount / _analysisHistory.length) * 100).toInt() : 0}%',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 통계 카드
  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
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

  // 분석 아이템
  Widget _buildAnalysisItem(AnalysisHistory analysis) {
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
                  color: analysis.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    analysis.status.icon,
                    color: analysis.status.color,
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
                      analysis.recipient,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      analysis.timestamp,
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
                  color: analysis.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  analysis.status.title,
                  style: AppTextStyles.helper.copyWith(
                    color: analysis.status.color,
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
            child: Text(analysis.content, style: AppTextStyles.body),
          ),
          if (analysis.result != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  HugeIcons.strokeRoundedAnalytics01,
                  color: AppColors.primaryText,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  analysis.result!,
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

  // 분석 데이터
  List<AnalysisHistory> _getAnalysisHistory() {
    return [
      AnalysisHistory(
        recipient: '민수',
        content: '오늘 날씨 정말 좋네요! 산책하기 딱 좋은 날씨 같아요 😊',
        timestamp: '2시간 전',
        status: AnalysisStatus.success,
        result: '5분 만에 답장, 데이트 제안 성공',
      ),
      AnalysisHistory(
        recipient: '지혜',
        content: '그 카페 정말 분위기 좋더라구요! 다음에 또 가고 싶어요',
        timestamp: '1일 전',
        status: AnalysisStatus.pending,
        result: null,
      ),
      AnalysisHistory(
        recipient: '현우',
        content: '요즘 어떻게 지내세요? 바쁘신 것 같던데 몸 조심하세요!',
        timestamp: '3일 전',
        status: AnalysisStatus.success,
        result: '답장률 100%, 호감도 상승',
      ),
      AnalysisHistory(
        recipient: '수빈',
        content: '이번 주말에 시간 되시면 영화 보러 가실래요?',
        timestamp: '5일 전',
        status: AnalysisStatus.failed,
        result: '답장 없음, 다른 접근 필요',
      ),
    ];
  }

  // 새 분석 시작
  void _startNewAnalysis() {
    ToastNotification.show(
      context: context,
      message: '새 분석을 시작합니다!',
      type: ToastType.info,
    );
    // 실제 분석 로직 호출
    // _performAnalysis();
  }

  // 분석 데이터 로드
  void _loadAnalysisHistory() {
    setState(() {
      _analysisHistory = _getAnalysisHistory();
    });
  }
}

// 분석 상태 모델
class AnalysisStatus {
  final String title;
  final IconData icon;
  final Color color;

  AnalysisStatus({
    required this.title,
    required this.icon,
    required this.color,
  });

  static AnalysisStatus success = AnalysisStatus(
    title: '성공',
    icon: HugeIcons.strokeRoundedCheckmarkCircle01,
    color: AppColors.green,
  );

  static AnalysisStatus pending = AnalysisStatus(
    title: '대기',
    icon: HugeIcons.strokeRoundedClock01,
    color: AppColors.accent,
  );

  static AnalysisStatus failed = AnalysisStatus(
    title: '실패',
    icon: HugeIcons.strokeRoundedCancelCircle,
    color: AppColors.error,
  );
}

// 분석 히스토리 모델
class AnalysisHistory {
  final String recipient;
  final String content;
  final String timestamp;
  final AnalysisStatus status;
  final String? result;

  AnalysisHistory({
    required this.recipient,
    required this.content,
    required this.timestamp,
    required this.status,
    this.result,
  });
}
