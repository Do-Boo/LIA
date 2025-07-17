// File: lib/presentation/screens/main_screen.dart
// HugeIcons 기반 LIA 관계 분석 대시보드 - Chart Demo 스타일로 개선

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lia/presentation/widgets/specific/charts/bar_chart.dart';
import 'package:lia/presentation/widgets/specific/charts/heatmap_chart.dart';
import 'package:lia/presentation/widgets/specific/charts/line_chart.dart';

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
  bool _hasAnalysisData = true; // 기본값을 true로 설정하여 대시보드 표시
  bool _isAnalyzing = false;
  int _analysisStep = 0;
  AnalysisData? _analysisData;
  bool _isLoading = true;

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

  // Part 1: 시작하기 (대화 내용이 없을 때의 초기 화면)
  Widget _buildStartScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // 헤더 섹션
          _buildStartHeader(),

          const SizedBox(height: 32),
          // 대화 내용 입력 섹션
          _buildConversationInputSection(),

          const SizedBox(height: 32),
          // 파일 업로드 섹션
          _buildFileUploadSection(),

          const SizedBox(height: 32),
          // 분석 시작 버튼
          _buildAnalysisStartButton(),

          const SizedBox(height: 32),
          // 사용 팁 섹션
          _buildUsageTips(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 시작 화면 헤더
  Widget _buildStartHeader() {
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
              const Icon(
                HugeIcons.strokeRoundedHeartAdd,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '안녕하세요! 서현이에요',
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'LIA가 두 분의 관계를 정확하게 분석해 드릴게요.\n대화 내용을 알려주시면 맞춤형 인사이트를 제공해 드려요!',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 대화 내용 입력 섹션
  Widget _buildConversationInputSection() {
    return ComponentCard(
      title: '대화 내용 알려주기',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                HugeIcons.strokeRoundedMessage01,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '카카오톡, 문자 등의 대화 내용을 붙여넣어 주세요',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 대화 내용 입력 필드
          Container(
            height: 200,
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
                    '예시:\n서현: 오늘 날씨 정말 좋다!\n상대방: 맞아요~ 산책하기 딱 좋은 날씨네요\n서현: 혹시 시간 되시면 같이 산책 어떠세요?\n...',
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: AppTextStyles.body2,
            ),
          ),

          const SizedBox(height: 16),

          // 입력 상태 표시
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedEdit02,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                '${_conversationController.text.length}자 입력됨',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (_conversationController.text.isNotEmpty)
                GestureDetector(
                  onTap: () => _conversationController.clear(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedDelete02,
                          size: 14,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '지우기',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // 파일 업로드 섹션
  Widget _buildFileUploadSection() {
    return ComponentCard(
      title: '파일로 업로드하기',
      child: Column(
        children: [
          // 드래그 앤 드롭 영역
          GestureDetector(
            onTap: _handleFileUpload,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cardBorder,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedCloudUpload,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '파일을 선택하거나 여기에 드래그하세요',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '.txt, .csv 파일 지원',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 파일 업로드 안내
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedInformationCircle,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '카카오톡 대화 내보내기, 문자 백업 파일 등을 업로드할 수 있어요',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 분석 시작 버튼
  Widget _buildAnalysisStartButton() {
    final bool canAnalyze = _conversationController.text.trim().isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: _isAnalyzing
          ? _buildAnalyzingProgress()
          : PrimaryButton(
              text: '관계 분석 시작하기',
              onPressed: canAnalyze ? _startAnalysis : null,
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

  // 사용 팁 섹션
  Widget _buildUsageTips() {
    return ComponentCard(
      title: '더 정확한 분석을 위한 팁',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedBulb,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '분석 정확도를 높이는 방법',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            icon: HugeIcons.strokeRoundedMessage01,
            title: '대화량이 많을수록 좋아요',
            description: '최소 20개 이상의 메시지가 있으면 더 정확한 분석이 가능해요',
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            icon: HugeIcons.strokeRoundedCalendar03,
            title: '최근 대화를 포함해 주세요',
            description: '최근 1-2주 내의 대화가 포함되면 현재 관계 상태를 더 잘 파악할 수 있어요',
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            icon: HugeIcons.strokeRoundedUserMultiple,
            title: '개인정보는 자동으로 보호돼요',
            description: '이름, 전화번호 등 개인정보는 분석에서 제외되니 안심하세요',
          ),
        ],
      ),
    );
  }

  // 팁 아이템 위젯
  Widget _buildTipItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Part 2: 분석 대시보드 (Chart Demo 스타일로 개선)
  Widget _buildAnalysisDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // 대시보드 헤더
          _buildDashboardHeader(),

          const SizedBox(height: 32),
          // 1. 종합 분석 요약
          _buildChartDemoSection(
            number: '1',
            title: '종합 분석 요약',
            description: '관계 현황을 한눈에 파악할 수 있는 핵심 지표들을 확인해보세요',
            child: _buildOverallAnalysisContent(),
          ),

          const SizedBox(height: 32),
          // 2. 감정 흐름 분석
          _buildChartDemoSection(
            number: '2',
            title: '감정 흐름 분석',
            description: '시간에 따른 감정 변화와 주요 이벤트를 확인해보세요',
            child: _buildEmotionalFlowContent(),
          ),

          const SizedBox(height: 32),
          // 3. 메시지 시간대별 연락 빈도
          _buildChartDemoSection(
            number: '3',
            title: '메시지 시간대별 연락 빈도',
            description: '언제 가장 활발하게 대화하는지 패턴을 분석해보세요',
            child: _buildMessageFrequencyContent(),
          ),

          const SizedBox(height: 32),
          // 4. 대화 주제 분석
          _buildChartDemoSection(
            number: '4',
            title: '대화 주제 분석',
            description: '어떤 주제로 주로 대화하는지 분포를 확인해보세요',
            child: _buildConversationTopicsContent(),
          ),

          const SizedBox(height: 32),
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

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Chart Demo 스타일 섹션 빌더
  Widget _buildChartDemoSection({
    required String number,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 번호 + 제목
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.charcoal,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 설명
          Text(
            description,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.secondaryText,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

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

  // 1. 종합 분석 요약 콘텐츠
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
                HugeIcons.strokeRoundedHeartAdd,
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

    return Column(
      children: [
        // 감정 변화 차트
        LineChart(
          title: '감정 변화 추이',
          titleIcon: HugeIcons.strokeRoundedHeartAdd,
          data: emotionData
              .map((e) => {'label': e.time, 'value': e.myEmotion.toDouble()})
              .toList(),
          height: 200,
        ),

        const SizedBox(height: 16),

        // 감정 일치도
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedHeartAdd,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '감정 일치도',
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${_calculateEmotionMatch()}%',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 4. 메시지 시간대별 연락 빈도 콘텐츠
  Widget _buildMessageFrequencyContent() {
    return Column(
      children: [
        // 히트맵 차트
        HeatmapChart(
          data: _generateHeatmapData().expand((x) => x).toList(),
          title: '주간 메시지 활동 패턴',
          titleIcon: HugeIcons.strokeRoundedCalendar03,
        ),

        const SizedBox(height: 16),

        // 인사이트 메시지
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
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
                  '가장 활발한 시간대: 오후 7-9시 | 주말 오전에 대화가 많아요',
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

        const SizedBox(height: 24),

        // 메시지 생성 바로가기 버튼
        PrimaryButton(
          text: '이 분석 결과로 메시지 생성하기',
          onPressed: _generateMessageFromAnalysis,
        ),
      ],
    );
  }

  // 차트 범례 위젯
  Widget _buildChartLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
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

  // 감정 일치도 계산
  int _calculateEmotionMatch() {
    if (_analysisData?.emotionData == null) return 0;

    final emotions = _analysisData!.emotionData;
    double totalMatch = 0;

    for (var emotion in emotions) {
      final diff = (emotion.myEmotion - emotion.partnerEmotion).abs();
      totalMatch += (1 - diff);
    }

    return ((totalMatch / emotions.length) * 100).round();
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
      _analysisData = null;
    });

    ToastNotification.show(
      context: context,
      message: '새로운 분석을 시작해보세요!',
      type: ToastType.info,
    );
  }

  // 히트맵 데이터 생성
  List<List<Map<String, dynamic>>> _generateHeatmapData() {
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    final hours = List.generate(24, (i) => i);

    return List.generate(days.length, (dayIndex) {
      return List.generate(hours.length, (hourIndex) {
        // 시뮬레이션 데이터 생성
        double value = 0;

        // 주말 패턴
        if (dayIndex >= 5) {
          if (hourIndex >= 10 && hourIndex <= 22) {
            value = (hourIndex >= 19 && hourIndex <= 21) ? 0.9 : 0.6;
          } else {
            value = 0.1;
          }
        } else {
          // 평일 패턴
          if (hourIndex >= 9 && hourIndex <= 18) {
            value = 0.3; // 업무 시간
          } else if (hourIndex >= 19 && hourIndex <= 22) {
            value = 0.8; // 저녁 시간
          } else {
            value = 0.1;
          }
        }

        return {
          'row': dayIndex,
          'col': hourIndex,
          'value': value,
          'tooltip': '${days[dayIndex]} $hourIndex시: ${(value * 10).toInt()}개',
        };
      });
    });
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
