// File: lib/presentation/screens/main_screen.dart
// HugeIcons 기반 LIA 관계 분석 대시보드 - Chart Demo 스타일로 개선

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lia/presentation/widgets/specific/charts/bar_chart.dart';
import 'package:lia/presentation/widgets/specific/charts/chart_common.dart';
import 'package:lia/presentation/widgets/specific/charts/line_chart.dart';
import 'package:lia/presentation/widgets/specific/charts/radar_chart.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../services/analysis_data_service.dart';
import '../widgets/common/component_card.dart';
import '../widgets/common/primary_button.dart';
import '../widgets/common/secondary_button.dart';
import '../widgets/specific/feedback/generating_progress.dart';
import '../widgets/specific/feedback/toast_notification.dart';

/// LIA 관계 분석 대시보드 - Chart Demo 스타일로 개선
///
/// 주요 개선사항:
/// 1. flutter_staggered_animations 제거 → 단순한 세로 스크롤
/// 2. ComponentCard → Chart Demo 스타일 Container + BoxShadow
/// 3. 일관된 32px 간격, 20px 패딩
/// 4. 번호 + 제목 + 설명 + 위젯 명확한 계층구조
/// 5. SemicircleGaugeChart 적용
/// 6. 파이 차트 크기 증가 및 범례 개선
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 상태 관리 변수들
  bool _hasAnalysisData = false; // 기본값을 false로 설정하여 시작 화면을 먼저 표시
  bool _isAnalyzing = false;
  int _analysisStep = 0;
  AnalysisData? _analysisData;
  bool _isLoading = true;
  bool _showFileUpload = false; // 파일 업로드 섹션 표시 여부

  // 컨트롤러들
  final TextEditingController _conversationController = TextEditingController();
  final FocusNode _conversationFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadAnalysisData();
  }

  @override
  void dispose() {
    _conversationController.dispose();
    _conversationFocus.dispose();
    super.dispose();
  }

  // 분석 데이터 로드
  Future<void> _loadAnalysisData() async {
    try {
      final data = await AnalysisDataService.loadSampleData();
      setState(() {
        _analysisData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // 에러 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? _buildLoadingScreen()
          : _hasAnalysisData
          ? _buildAnalysisDashboard()
          : _buildStartScreen(),
    );
  }

  // 로딩 화면
  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('분석 데이터를 불러오는 중...'),
        ],
      ),
    );
  }

  // Part 1: 개선된 시작 화면 - 모바일 우선 디자인
  Widget _buildStartScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 40.0 : 20.0,
          vertical: 16.0,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600, // 최대 너비 제한으로 큰 화면에서도 읽기 좋게
            minHeight:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                100, // 네비게이션 바 고려
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // 개선된 히어로 헤더
              _buildHeroHeader(),

              const SizedBox(height: 20),
              // 퀵 스타트 카드 (간단한 입력)
              _buildQuickStartCard(),

              const SizedBox(height: 12),
              // 파일 업로드 옵션 (접을 수 있는 형태)
              _buildFileUploadOption(),

              const SizedBox(height: 20),
              // 분석 시작 버튼
              _buildAnalysisStartButton(),

              const SizedBox(height: 12),
              // 간단한 도움말
              _buildSimpleHelp(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 개선된 히어로 헤더 - 간결하고 임팩트 있는 디자인
  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 이모지 + 인사말
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('💕', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Text(
                '안녕, 서현아!',
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 가치 제안
          Text(
            '대화 내용만 알려주면\n관계 분석 결과를 바로 받아볼 수 있어!',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 퀵 스타트 카드 - 간단하고 직관적인 입력
  Widget _buildQuickStartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목과 아이콘
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedMessage01,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '대화 내용 입력하기',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '카톡, 문자 등 대화 내용을 붙여넣어주세요',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 개선된 입력 필드 - 높이 줄이고 확장 가능하게
          GestureDetector(
            onTap: () => _conversationFocus.requestFocus(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height:
                  _conversationFocus.hasFocus ||
                      _conversationController.text.isNotEmpty
                  ? 120
                  : 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _conversationFocus.hasFocus
                      ? AppColors.primary
                      : AppColors.cardBorder,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _conversationController,
                focusNode: _conversationFocus,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText:
                      '서현: 오늘 날씨 정말 좋다!\n상대방: 맞아요~ 산책하기 딱 좋은 날씨네요\n서현: 혹시 시간 되시면 같이 산책 어떠세요?',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyles.body2.copyWith(fontSize: 14),
              ),
            ),
          ),

          // 입력 상태 및 액션
          if (_conversationController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedCheckmarkCircle02,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_conversationController.text.length}자 입력됨',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _conversationController.clear();
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '지우기',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // 파일 업로드 옵션 - 접을 수 있는 형태
  Widget _buildFileUploadOption() {
    return GestureDetector(
      onTap: () => setState(() => _showFileUpload = !_showFileUpload),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _showFileUpload
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _showFileUpload
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // 토글 헤더
            Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedCloudUpload,
                  size: 20,
                  color: _showFileUpload
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '또는 파일로 업로드하기',
                    style: AppTextStyles.body1.copyWith(
                      color: _showFileUpload
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: _showFileUpload
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _showFileUpload ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    HugeIcons.strokeRoundedArrowDown01,
                    size: 16,
                    color: _showFileUpload
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            // 접을 수 있는 내용
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _showFileUpload
                  ? Column(
                      children: [
                        const SizedBox(height: 16),
                        // 파일 업로드 영역
                        GestureDetector(
                          onTap: _handleFileUpload,
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  HugeIcons.strokeRoundedUpload04,
                                  size: 24,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '파일 선택하기',
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '카카오톡 대화 내보내기, .txt, .csv 파일 지원',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // 간단한 도움말
  Widget _buildSimpleHelp() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            HugeIcons.strokeRoundedInformationCircle,
            size: 20,
            color: AppColors.accent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '최소 10개 이상의 메시지가 있으면 더 정확한 분석이 가능해요',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.accent,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 개선된 분석 시작 버튼 - 모바일 친화적
  Widget _buildAnalysisStartButton() {
    final bool canAnalyze = _conversationController.text.trim().isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: _isAnalyzing
          ? _buildAnalyzingProgress()
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: canAnalyze
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: PrimaryButton(
                text: canAnalyze ? '✨ 관계 분석 시작하기' : '대화 내용을 입력해주세요',
                onPressed: canAnalyze ? _startAnalysis : null,
              ),
            ),
    );
  }

  // 분석 진행 상태 표시
  Widget _buildAnalyzingProgress() {
    final List<String> steps = [
      '대화 내용 분석 중...',
      '감정 패턴 파악 중...',
      '상대방 성향 분석 중...',
      '관계 인사이트 생성 중...',
      '맞춤 조언 준비 중...',
    ];

    return ComponentCard(
      title: '분석 진행 중',
      child: Column(
        children: [
          GeneratingProgress(
            currentStep: _analysisStep,
            totalSteps: steps.length,
            stepTexts: steps,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                HugeIcons.strokeRoundedBrain,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'AI가 열심히 분석하고 있어요! 잠시만 기다려 주세요',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Part 2: 개선된 분석 대시보드 - 모바일 우선 디자인
  Widget _buildAnalysisDashboard() {
    return SafeArea(
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
              // 핵심 요약 섹션
              _buildSummarySection(),

              const SizedBox(height: 24),
              // 1. 성격 호환성 분석
              _buildChartDemoSection(
                number: '1',
                title: '성격 호환성 분석',
                description: '두 분의 성격을 5가지 요소로 분석하여 호환성을 확인해보세요',
                child: _buildPersonalityCompatibilityContent(),
              ),

              const SizedBox(height: 24),
              // 2. 감정 흐름 분석
              _buildChartDemoSection(
                number: '2',
                title: '감정 흐름 분석',
                description: '시간에 따른 감정 변화와 주요 이벤트를 확인해보세요',
                child: _buildEmotionalFlowContent(),
              ),

              const SizedBox(height: 24),
              // 3. 메시지 시간대별 연락 빈도
              _buildChartDemoSection(
                number: '3',
                title: '메시지 시간대별 연락 빈도',
                description: '언제 가장 활발하게 대화하는지 패턴을 분석해보세요',
                child: _buildMessageFrequencyContent(),
              ),

              const SizedBox(height: 24),
              // 4. 대화 주제 분석
              _buildChartDemoSection(
                number: '4',
                title: '대화 주제 분석',
                description: '어떤 주제로 주로 대화하는지 분포를 확인해보세요',
                child: _buildConversationTopicsContent(),
              ),

              const SizedBox(height: 24),
              // 5. AI 추천 액션 플랜
              _buildChartDemoSection(
                number: '5',
                title: 'AI 추천 액션 플랜',
                description: '관계 개선을 위한 구체적인 조언과 추천 전략을 확인해보세요',
                child: _buildActionPlanContent(),
              ),

              const SizedBox(height: 32),
              // 새로운 분석 버튼
              _buildNewAnalysisButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 개선된 섹션 빌더 - 모바일 최적화
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
          color: AppColors.primary.withValues(alpha: 0.1),
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
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
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

  // 대시보드 헤더
  Widget _buildDashboardHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  HugeIcons.strokeRoundedAnalytics01,
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
                          '관계 분석 완료!',
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          HugeIcons.strokeRoundedParty,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '두 분의 대화를 분석해서 맞춤 인사이트를 준비했어요',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 핵심 요약 섹션 - 한눈에 보는 핵심 지표
  Widget _buildSummarySection() {
    if (_analysisData == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 상단 제목
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedAnalytics01,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '핵심 분석 결과',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '가장 중요한 3가지 지표를 확인해보세요',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 핵심 지표 3개
          Row(
            children: [
              // 썸 지수
              Expanded(
                child: _buildSummaryMetric(
                  icon: HugeIcons.strokeRoundedCardiogram02,
                  title: '썸 지수',
                  value: '${_analysisData!.someIndex}%',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              // 호환성 점수
              Expanded(
                child: _buildSummaryMetric(
                  icon: HugeIcons.strokeRoundedCheckList,
                  title: '호환성',
                  value: _analysisData!.personalityAnalysis != null
                      ? '${_analysisData!.personalityAnalysis!.compatibilityScore}%'
                      : '85%',
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              // 발전 가능성
              Expanded(
                child: _buildSummaryMetric(
                  icon: HugeIcons.strokeRoundedChartUp,
                  title: '발전 가능성',
                  value: '${_analysisData!.developmentPossibility}%',
                  color: AppColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 다음 액션 제안
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedIdea,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '다음 단계: 성격 호환성을 확인하고 맞춤형 대화 주제를 준비해보세요!',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 요약 지표 위젯
  Widget _buildSummaryMetric({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 18,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 1. 성격 호환성 분석 콘텐츠
  Widget _buildPersonalityCompatibilityContent() {
    if (_analysisData?.personalityAnalysis == null) {
      return _buildDefaultPersonalityContent();
    }

    final personality = _analysisData!.personalityAnalysis!;

    return Column(
      children: [
        // 호환성 점수 표시
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.accent.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedCheckList,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '호환성 점수',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${personality.compatibilityScore}',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '%',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getCompatibilityMessage(
                            personality.compatibilityScore,
                          ),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 레이더 차트 - 성격 비교
        const RadarChart(
          title: 'MBTI 성격 비교',
          titleIcon: HugeIcons.strokeRoundedUser,
          size: 280,
          showLegend: true,
          legendPosition: LegendPosition.bottomCenter,
          data: [
            {
              'name': '나',
              'data': [
                {'label': '외향성', 'value': 75},
                {'label': '개방성', 'value': 80},
                {'label': '성실성', 'value': 65},
                {'label': '친화성', 'value': 90},
                {'label': '사고', 'value': 70},
              ],
              'color': 0xFFFF70A6,
            },
            {
              'name': '상대방',
              'data': [
                {'label': '외향성', 'value': 60},
                {'label': '개방성', 'value': 85},
                {'label': '성실성', 'value': 80},
                {'label': '친화성', 'value': 75},
                {'label': '사고', 'value': 65},
              ],
              'color': 0xFF7B68EE,
            },
          ],
        ),

        const SizedBox(height: 20),

        // 강점과 개선점
        Column(
          children: [
            // 강점
            _buildPersonalityInsight(
              title: '관계의 강점',
              icon: HugeIcons.strokeRoundedThumbsUp,
              items: personality.strengths,
              color: AppColors.green,
            ),
            const SizedBox(height: 16),
            // 개선점
            _buildPersonalityInsight(
              title: '개선 포인트',
              icon: HugeIcons.strokeRoundedIdea,
              items: personality.improvements,
              color: AppColors.accent,
            ),
          ],
        ),
      ],
    );
  }

  // 기본 성격 분석 콘텐츠 (데이터가 없을 때)
  Widget _buildDefaultPersonalityContent() {
    return const RadarChart(
      title: '성격 5요소 분석',
      titleIcon: HugeIcons.strokeRoundedUser,
      size: 280,
      showLegend: false,
      data: [
        {'label': '외향성', 'value': 75},
        {'label': '개방성', 'value': 80},
        {'label': '성실성', 'value': 65},
        {'label': '친화성', 'value': 90},
        {'label': '감정안정성', 'value': 70},
      ],
    );
  }

  // 성격 인사이트 카드
  Widget _buildPersonalityInsight({
    required String title,
    required IconData icon,
    required List<String> items,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16), // 12 → 16으로 증가
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color), // 16 → 20으로 증가
              const SizedBox(width: 8), // 6 → 8로 증가
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    // body2 → body1로 변경
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 15, // 13 → 15로 증가
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // 8 → 12로 증가
          ...items
              .take(2)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6), // 4 → 6으로 증가
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 5, // 4 → 5로 증가
                        height: 5, // 4 → 5로 증가
                        margin: const EdgeInsets.only(top: 7), // 6 → 7로 조정
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(
                            2.5,
                          ), // 2 → 2.5로 조정
                        ),
                      ),
                      const SizedBox(width: 8), // 6 → 8로 증가
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.body2.copyWith(
                            // caption → body2로 변경
                            color: AppColors.textSecondary,
                            fontSize: 13, // 11 → 13으로 증가
                            height: 1.4, // 1.3 → 1.4로 조정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  // 호환성 점수 메시지
  String _getCompatibilityMessage(int score) {
    if (score >= 80) return '환상적인 조합!';
    if (score >= 70) return '좋은 궁합이에요';
    if (score >= 60) return '무난한 관계';
    return '노력이 필요해요';
  }

  // 1. 종합 분석 요약 콘텐츠 (사용안함)
  Widget _buildOverallAnalysisContent() {
    if (_analysisData == null) return const SizedBox.shrink();

    return Column(
      children: [
        // 썸 지수 - 숫자 표기 (단독 배치)
        _buildHeartBasedSomeIndex(),

        const SizedBox(height: 24),

        // AI 분석 요약
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedBrain,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI 분석 요약',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _analysisData!.aiSummary,
                style: AppTextStyles.body2.copyWith(height: 1.5),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 분석 메타데이터 표시
        _buildAnalysisMetadata(),
      ],
    );
  }

  // 썸 지수 - 숫자 표기
  Widget _buildHeartBasedSomeIndex() {
    final someIndex = _analysisData!.someIndex;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                HugeIcons.strokeRoundedCardiogram02,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '썸 지수',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 숫자 표기
          Column(
            children: [
              Text(
                '$someIndex',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '%',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 상태 메시지
          Text(
            _getSomeIndexMessage(someIndex),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 분석 메타데이터 표시
  Widget _buildAnalysisMetadata() {
    if (_analysisData?.metadata == null) return const SizedBox.shrink();

    final metadata = _analysisData!.metadata;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics01,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                '분석 정보',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetadataItem('총 메시지', '${metadata.totalMessages}개'),
              const SizedBox(width: 20),
              _buildMetadataItem('분석 기간', metadata.conversationPeriod),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMetadataItem(
                '답장률',
                '${metadata.responseRate.toStringAsFixed(1)}%',
              ),
              const SizedBox(width: 20),
              _buildMetadataItem('평균 답장 시간', metadata.averageResponseTime),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '주요 키워드: ${metadata.topKeywords.join(', ')}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // 메타데이터 아이템
  Widget _buildMetadataItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // 3. 감정 흐름 분석 콘텐츠
  Widget _buildEmotionalFlowContent() {
    if (_analysisData == null) return const SizedBox.shrink();

    return Column(
      children: [
        // 라인 차트 기반 감정 상태 시각화
        _buildEmotionLineVisualization(),

        const SizedBox(height: 20),

        // 주요 이벤트 마커들
        Column(
          children: _analysisData!.keyEvents
              .map((event) => _buildEventMarker(event))
              .toList(),
        ),
      ],
    );
  }

  // 라인 차트 기반 감정 상태 시각화
  Widget _buildEmotionLineVisualization() {
    final emotionData = _analysisData!.emotionData;

    return LineChart(
      title: '감정 변화 추이',
      titleIcon: HugeIcons.strokeRoundedCardiogram02,
      data: emotionData
          .map((e) => {'label': e.time, 'value': e.myEmotion.toDouble()})
          .toList(),
      height: 200,
      showLegend: false,
    );
  }

  // 4. 메시지 시간대별 연락 빈도 콘텐츠
  Widget _buildMessageFrequencyContent() {
    return Column(
      children: [
        // 라인 차트
        LineChart(
          data: _generateMessageFrequencyData(),
          title: '시간대별 메시지 빈도',
          titleIcon: HugeIcons.strokeRoundedCalendar03,
          height: 320,
          showLegend: true,
        ),

        const SizedBox(height: 16),

        // 인사이트 메시지
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedBulb,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '가장 활발한 시간대: 오후 7-9시 | 내가 더 많은 메시지를 보내는 시간대예요',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 4. 대화 주제 분석 콘텐츠 (막대 차트로 상위 5개 주제 순위 표시)
  Widget _buildConversationTopicsContent() {
    return Column(
      children: [
        // 막대 차트 - 상위 5개 대화 주제 순위
        const BarChart(
          title: '대화 주제 순위 TOP 5',
          titleIcon: HugeIcons.strokeRoundedAnalytics01,
          showLegend: false,
          data: [
            {'label': '카페 데이트', 'value': 85},
            {'label': '취미 공유', 'value': 72},
            {'label': '일상 대화', 'value': 68},
            {'label': '음식 이야기', 'value': 55},
            {'label': '영화/드라마', 'value': 42},
          ],
        ),

        const SizedBox(height: 16),

        // 인사이트 메시지
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedArrowUpRight02,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '카페 데이트 주제가 1위! 실제 데이트 제안을 해보세요',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 6. AI 추천 액션 플랜 콘텐츠
  Widget _buildActionPlanContent() {
    if (_analysisData == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 추천 대화 주제
        _buildActionSection(
          title: '추천 대화 주제',
          items: _analysisData!.recommendedTopics,
          icon: HugeIcons.strokeRoundedMessage01,
        ),

        const SizedBox(height: 20),

        // 관계 개선 팁
        _buildActionSection(
          title: '관계 개선을 위한 조언',
          items: _analysisData!.improvementTips,
          icon: HugeIcons.strokeRoundedIdea,
        ),

        const SizedBox(height: 20),

        // 개선된 메시지 생성 CTA
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.accent.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      HugeIcons.strokeRoundedMagicWand02,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '맞춤 메시지 생성',
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '분석 결과를 바탕으로 완벽한 메시지를 만들어드려요',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: '✨ 메시지 생성하기',
                  onPressed: _generateMessageFromAnalysis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  // 썸 지수 메시지 생성
  String _getSomeIndexMessage(int someIndex) {
    if (someIndex >= 80) {
      return '완전 좋은 분위기! 고백해도 될 것 같아요';
    } else if (someIndex >= 60) {
      return '썸 타는 중! 조금 더 적극적으로 다가가보세요';
    } else if (someIndex >= 40) {
      return '관심은 있는 것 같아요. 천천히 다가가보세요';
    } else if (someIndex >= 20) {
      return '아직 시작 단계예요. 더 많은 대화가 필요해요';
    } else {
      return '관계 발전이 필요해요. 공통 관심사를 찾아보세요';
    }
  }


  // 이벤트 마커 위젯
  Widget _buildEventMarker(AnalysisKeyEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: event.isPositive
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: event.isPositive
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                event.isPositive
                    ? HugeIcons.strokeRoundedChartUp
                    : HugeIcons.strokeRoundedChartDown,
                size: 16,
                color: event.isPositive ? AppColors.primary : AppColors.error,
              ),
              const SizedBox(width: 8),
              Text(
                event.event,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                event.time,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (event.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              event.description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 액션 섹션 위젯
  Widget _buildActionSection({
    required String title,
    required List<String> items,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.body2.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 새로운 분석 버튼
  Widget _buildNewAnalysisButton() {
    return SecondaryButton(text: '새로운 대화 분석하기', onPressed: _startNewAnalysis);
  }

  // 파일 업로드 핸들러
  void _handleFileUpload() {
    // TODO: 파일 선택 및 업로드 로직 구현
    ToastNotification.show(
      context: context,
      message: '파일 업로드 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 분석 시작 핸들러
  void _startAnalysis() async {
    if (_conversationController.text.trim().isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _analysisStep = 0;
    });

    // 분석 단계별 진행 시뮬레이션
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _analysisStep = i + 1;
        });
      }
    }

    // 분석 완료
    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _hasAnalysisData = true;
      });

      ToastNotification.show(
        context: context,
        message: '분석이 완료되었어요! 결과를 확인해보세요',
        type: ToastType.success,
      );
    }
  }

  // 분석 결과 기반 메시지 생성
  void _generateMessageFromAnalysis() {
    // TODO: 분석 결과를 바탕으로 메시지 생성 화면으로 이동
    ToastNotification.show(
      context: context,
      message: '분석 결과를 바탕으로 완벽한 메시지를 생성해드릴게요!',
      type: ToastType.info,
    );
  }

  // 새로운 분석 시작
  void _startNewAnalysis() {
    setState(() {
      _hasAnalysisData = false;
      _conversationController.clear();
    });

    ToastNotification.show(
      context: context,
      message: '새로운 분석을 시작해보세요!',
      type: ToastType.info,
    );
  }

  // 라인 차트용 메시지 빈도 데이터 생성
  List<Map<String, dynamic>> _generateMessageFrequencyData() {
    return [
      {
        'name': '내 메시지',
        'data': List.generate(24, (hour) {
          // 시간대별 내 메시지 개수 시뮬레이션
          double myMessages = 0;
          if (hour >= 7 && hour <= 9) {
            myMessages = 3 + (hour - 7) * 2; // 아침 시간 증가
          } else if (hour >= 12 && hour <= 14) {
            myMessages = 5 + (hour - 12) * 1.5; // 점심 시간
          } else if (hour >= 18 && hour <= 22) {
            myMessages = 8 + (hour - 18) * 2; // 저녁 시간 활발
          } else if (hour >= 23 || hour <= 1) {
            myMessages = 2; // 늦은 밤
          } else {
            myMessages = 1; // 기본값
          }
          
          return {
            'label': '$hour시',
            'value': myMessages,
          };
        }),
        'color': AppColors.primary.toARGB32(),
      },
      {
        'name': '상대 메시지',
        'data': List.generate(24, (hour) {
          // 시간대별 상대방 메시지 개수 시뮬레이션
          double partnerMessages = 0;
          if (hour >= 8 && hour <= 10) {
            partnerMessages = 2 + (hour - 8) * 1.5; // 아침 시간
          } else if (hour >= 13 && hour <= 15) {
            partnerMessages = 4 + (hour - 13) * 1; // 점심 시간
          } else if (hour >= 19 && hour <= 21) {
            partnerMessages = 6 + (hour - 19) * 2.5; // 저녁 시간
          } else if (hour >= 22 || hour <= 2) {
            partnerMessages = 1.5; // 늦은 밤
          } else {
            partnerMessages = 0.5; // 기본값
          }
          
          return {
            'label': '$hour시',
            'value': partnerMessages,
          };
        }),
        'color': AppColors.accent.toARGB32(),
      },
    ];
  }
}

// 반 하트 클리퍼
class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
