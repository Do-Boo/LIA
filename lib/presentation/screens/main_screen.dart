// File: lib/presentation/screens/main_screen.dart
// 2025.07.23 14:56:44 카카오톡 스타일로 완전 리팩토링 - 다른 스크린과 일관성 맞춤

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../data/models/models.dart';
import '../../services/analysis_data_service.dart';
import '../widgets/lia_widgets.dart';

/// 메인 화면 - 관계 분석 시작 및 결과 표시
///
/// 카카오톡 스타일의 심플하고 직관적인 구조로 구성
/// 분석 전: 상단 웰컴 섹션 + 하단 시작 메뉴
/// 분석 후: 상단 결과 요약 + 하단 상세 분석 메뉴
class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.onAnalyzingStateChanged});

  /// 분석 상태 변경 시 호출되는 콜백 함수
  final ValueChanged<bool>? onAnalyzingStateChanged;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 상태 관리
  bool _hasAnalysisData = false;
  bool _isAnalyzing = false;
  int _analysisStep = 0;
  AnalysisData? _analysisData;
  bool _isLoading = true;

  // 입력 상태 관리 (2025.07.24 09:49:45 추가)
  bool _hasConversationInput = false;
  bool _hasReferenceInput = false;

  // 컨트롤러
  final TextEditingController _conversationController = TextEditingController();
  final TextEditingController _referenceController =
      TextEditingController(); // 2025.07.24 09:49:45 참고 내용용 추가

  @override
  void initState() {
    super.initState();
    _loadAnalysisData();

    // 텍스트 입력 상태 감지 (2025.07.24 09:49:45 추가)
    _conversationController.addListener(() {
      final hasInput = _conversationController.text.trim().isNotEmpty;
      if (_hasConversationInput != hasInput) {
        setState(() {
          _hasConversationInput = hasInput;
        });
      }
    });

    _referenceController.addListener(() {
      final hasInput = _referenceController.text.trim().isNotEmpty;
      if (_hasReferenceInput != hasInput) {
        setState(() {
          _hasReferenceInput = hasInput;
        });
      }
    });
  }

  @override
  void dispose() {
    _conversationController.dispose();
    _referenceController.dispose(); // 2025.07.24 09:49:45 추가
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('데이터를 불러오는 중...'),
            ],
          ),
        ),
      );
    }

    if (_isAnalyzing) {
      return _buildAnalyzingScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _hasAnalysisData
            ? _buildAnalysisScreenWithScroll()
            : _buildStartScreenWithScroll(),
      ),
    );
  }

  /// 웰컴 요약 섹션 (카카오톡 스타일)
  Widget _buildWelcomeSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.transparent,
    child: Column(
      children: [
        // LIA 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            HugeIcons.strokeRoundedBrain01,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),

        // 타이틀
        Text(
          'LIA 관계 분석',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // 서브타이틀 정보
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'AI가 대화를 분석하여 관계의 깊이를 알려드려요',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  /// 시작 메뉴 콘텐츠 (2025.07.24 10:31:18 스크롤 최적화)
  Widget _buildStartMenuContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        // 분석 시작하기
        _buildMenuGroup('분석 시작하기', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMessage01,
            title: '대화 내용 입력하기',
            subtitle: _hasConversationInput
                ? '✅ 대화 내용이 입력되었습니다'
                : '카톡, 문자 등 대화 내용을 붙여넣어주세요',
            onTap: _showConversationInput,
            iconColor: _hasConversationInput
                ? AppColors.green
                : AppColors.primary,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedEdit02,
            title: '참고 내용 입력하기',
            subtitle: _hasReferenceInput
                ? '✅ 참고 내용이 입력되었습니다'
                : '오프라인에서 느낀 점, 상황 설명 등 (선택사항)',
            onTap: _showReferenceInput,
            iconColor: _hasReferenceInput
                ? AppColors.green
                : AppColors.textSecondary,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedCloudUpload,
            title: '파일로 업로드하기',
            subtitle: '카카오톡 대화 내보내기, .txt, .csv 파일 지원',
            onTap: _handleFileUpload,
            iconColor: AppColors.blue,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics01,
            title: '샘플 분석 체험하기',
            subtitle: '예시 대화로 분석 결과를 미리 확인해보세요',
            onTap: _startSampleAnalysis,
            iconColor: AppColors.accent,
          ),
        ]),

        // 분석 시작 버튼 (2025.07.24 09:49:45 추가)
        if (_hasConversationInput) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
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
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  // 준비 완료 아이콘
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      HugeIcons.strokeRoundedRocket01,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 제목
                  Text(
                    '분석 준비 완료!',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 설명
                  Text(
                    '대화 내용이 준비되었습니다.\n${_hasReferenceInput ? "참고 내용과 함께 " : ""}AI 분석을 시작해보세요!',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // 분석 시작 버튼
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: '🚀 AI 분석 시작하기',
                      onPressed: _startAnalysis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // 하단 여백 추가 (2025.07.24 10:31:18 스크롤 여유 공간)
        const SizedBox(height: 40),
      ],
    ),
  );

  /// 분석 중 화면
  Widget _buildAnalyzingScreen() {
    final steps = [
      '대화 내용 분석 중...',
      '감정 패턴 파악 중...',
      '상대방 성향 분석 중...',
      '관계 인사이트 생성 중...',
      '맞춤 조언 준비 중...',
    ];

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.accent.withValues(alpha: 0.02),
            AppColors.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // 상단 아이콘과 제목
              Column(
                children: [
                  // 분석 아이콘 애니메이션
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      HugeIcons.strokeRoundedBrain01,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 제목
                  Text(
                    'AI가 관계를 분석하고 있어요',
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // 부제목
                  Text(
                    '잠시만 기다려 주세요. 곧 놀라운 결과를 보여드릴게요!',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const Spacer(),

              // 진행 상태 표시
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 진행 바와 퍼센트
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '분석 진행도',
                                    style: AppTextStyles.body1.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${_analysisStep >= steps.length ? 100 : ((_analysisStep / steps.length) * 100).toInt()}%',
                                    style: AppTextStyles.h3.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _analysisStep >= steps.length
                                          ? AppColors.green
                                          : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // 진행 바
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _analysisStep >= steps.length
                                      ? 1.0
                                      : _analysisStep / steps.length,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: _analysisStep >= steps.length
                                          ? LinearGradient(
                                              colors: [
                                                AppColors.green,
                                                AppColors.green.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ],
                                            )
                                          : AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 현재 단계 표시
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _analysisStep >= steps.length
                            ? AppColors.green.withValues(alpha: 0.1)
                            : AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _analysisStep >= steps.length
                              ? AppColors.green.withValues(alpha: 0.3)
                              : AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          // 로딩 애니메이션 또는 완료 아이콘
                          if (_analysisStep >= steps.length)
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                HugeIcons.strokeRoundedCheckmarkCircle02,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                          else
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          const SizedBox(width: 12),

                          // 현재 단계 텍스트
                          Expanded(
                            child: Text(
                              _analysisStep >= steps.length
                                  ? '✨ 분석 완료! 결과 화면으로 이동 중...'
                                  : _analysisStep > 0 &&
                                        _analysisStep <= steps.length
                                  ? steps[_analysisStep - 1]
                                  : '분석 준비 중...',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.w500,
                                color: _analysisStep >= steps.length
                                    ? AppColors.green
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 단계별 체크리스트
                    Column(
                      children: steps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final step = entry.value;
                        final isCompleted = index < _analysisStep;
                        final isCurrent = index == _analysisStep - 1;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : isCurrent
                                ? AppColors.accent.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              // 상태 아이콘
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? AppColors.primary
                                      : isCurrent
                                      ? AppColors.accent
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isCompleted
                                    ? const Icon(
                                        HugeIcons
                                            .strokeRoundedCheckmarkCircle02,
                                        size: 12,
                                        color: Colors.white,
                                      )
                                    : isCurrent
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),

                              // 단계 텍스트
                              Expanded(
                                child: Text(
                                  step,
                                  style: AppTextStyles.body2.copyWith(
                                    color: isCompleted
                                        ? AppColors.primary
                                        : isCurrent
                                        ? AppColors.accent
                                        : AppColors.textSecondary,
                                    fontWeight: isCurrent
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 하단 팁 메시지
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      HugeIcons.strokeRoundedInformationCircle,
                      size: 20,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '분석이 완료되면 자동으로 결과 화면으로 이동합니다',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// 결과 요약 섹션 (카카오톡 스타일)
  Widget _buildResultSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.white.withValues(alpha: 0),
    child: Column(
      children: [
        // 분석 완료 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.green],
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

        // 완료 타이틀
        Text(
          '분석 완료!',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // 핵심 지표 요약 카드 (2025.07.24 09:49:45 시각적 개선)
        Container(
          width: double.infinity,
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              // 메인 지표들
              Row(
                children: [
                  // 썸 지수
                  Expanded(
                    child: _buildMetricCard(
                      icon: HugeIcons.strokeRoundedHeartAdd,
                      title: '썸 지수',
                      value: '${_analysisData?.someIndex ?? 75}%',
                      color: AppColors.primary,
                      subtitle: _getScoreDescription(
                        _analysisData?.someIndex ?? 75,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 관계성 점수
                  Expanded(
                    child: _buildMetricCard(
                      icon: HugeIcons.strokeRoundedUserMultiple,
                      title: '관계성',
                      value:
                          '${_analysisData?.personalityAnalysis?.compatibilityScore ?? 85}%',
                      color: AppColors.green,
                      subtitle: _getCompatibilityDescription(
                        _analysisData
                                ?.personalityAnalysis
                                ?.compatibilityScore ??
                            85,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 추가 지표들
              Row(
                children: [
                  // 소통 활발도
                  Expanded(
                    child: _buildMetricCard(
                      icon: HugeIcons.strokeRoundedMessage01,
                      title: '소통 활발도',
                      value:
                          '${_analysisData?.emotionData.isNotEmpty == true ? 82 : 70}%',
                      color: AppColors.blue,
                      subtitle: '활발함',
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 감정 긍정도
                  Expanded(
                    child: _buildMetricCard(
                      icon: HugeIcons.strokeRoundedFavourite,
                      title: '감정 긍정도',
                      value:
                          '${_analysisData?.emotionData.isNotEmpty == true ? 82 : 70}%',
                      color: AppColors.accent,
                      subtitle: '긍정적',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // AI 한줄 요약 (2025.07.24 09:49:45 추가)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.yellow.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedBrain01,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 한줄 요약',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.yellow,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getAISummary(),
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // 지표 카드 위젯 (2025.07.24 09:49:45 추가)
  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String subtitle,
  }) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.2)),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        // 아이콘
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 8),

        // 값
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),

        // 제목
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),

        // 설명
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  // 점수별 설명 생성 (2025.07.24 09:49:45 추가)
  String _getScoreDescription(int score) {
    if (score >= 80) return '매우 좋음';
    if (score >= 60) return '좋음';
    if (score >= 40) return '보통';
    return '아쉬움';
  }

  String _getCompatibilityDescription(int score) {
    if (score >= 85) return '찰떡궁합';
    if (score >= 70) return '좋은 관계';
    if (score >= 50) return '무난함';
    return '노력 필요';
  }

  String _getAISummary() {
    final someIndex = _analysisData?.someIndex ?? 75;
    final compatibility =
        _analysisData?.personalityAnalysis?.compatibilityScore ?? 85;

    if (someIndex >= 70 && compatibility >= 80) {
      return '서로에게 관심이 많고 궁합도 좋은 관계예요! 적극적으로 다가가 보세요 💕';
    } else if (someIndex >= 50) {
      return '긍정적인 신호들이 보여요. 조금 더 적극적으로 소통해보세요! 😊';
    } else {
      return '아직 초기 단계인 것 같아요. 천천히 관계를 발전시켜 나가보세요 🌱';
    }
  }

  /// 분석 메뉴 콘텐츠 (2025.07.24 10:31:18 스크롤 최적화)
  Widget _buildAnalysisMenuContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        // 상세 분석 결과
        _buildMenuGroup('상세 분석 결과', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedUserMultiple,
            title: '성격 관계성 분석',
            subtitle: '두 분의 성격을 5가지 요소로 분석하여 관계성 확인',
            onTap: _showPersonalityAnalysis,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedHeartAdd,
            title: '감정 흐름 분석',
            subtitle: '시간에 따른 감정 변화와 주요 이벤트 확인',
            onTap: _showEmotionalFlow,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedClock01,
            title: '메시지 패턴 분석',
            subtitle: '시간대별 메시지 패턴과 소통 스타일 파악',
            onTap: _showMessagePattern,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMessage01,
            title: '대화 주제 분석',
            subtitle: '자주 나누는 대화 주제와 관심사 시각화',
            onTap: _showTopicAnalysis,
          ),
        ]),

        // AI 추천 및 액션
        _buildMenuGroup('AI 추천 및 액션', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedTarget01,
            title: 'AI 추천 액션',
            subtitle: '분석 결과 기반 관계 개선 맞춤 액션 제안',
            onTap: _showAIRecommendations,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedRefresh,
            title: '새로운 분석 시작',
            subtitle: '다른 대화로 새로운 관계 분석 시작하기',
            onTap: _startNewAnalysis,
          ),
        ]),

        // 하단 여백 추가 (2025.07.24 10:31:18 스크롤 여유 공간)
        const SizedBox(height: 40),
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

  // 액션 메서드들
  void _showConversationInput() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildConversationInputModal(),
    );
  }

  Widget _buildConversationInputModal() => Container(
    height: MediaQuery.of(context).size.height * 0.85,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 심플한 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '대화 내용 입력',
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    HugeIcons.strokeRoundedCancel01,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 간단한 설명
          Text(
            '카카오톡이나 문자 대화를 붙여넣어 주세요',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 24),

          // 입력 필드 (더 깔끔하게)
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surface),
              ),
              child: TextField(
                controller: _conversationController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText:
                      '나: 오늘 날씨 정말 좋다!\n상대방: 맞아요~ 산책하기 딱 좋은 날씨네요\n나: 혹시 시간 되시면 같이 산책 어떠세요?\n상대방: 좋아요! 언제 만날까요?',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 간단한 팁
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedBulb,
                  size: 16,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '최근 1-2주 대화 • 이름 대신 "나", "상대방" 사용',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 저장 버튼 (더 심플하게)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _conversationController.text.trim().isNotEmpty
                  ? () => Navigator.pop(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _conversationController.text.trim().isNotEmpty
                    ? AppColors.primary
                    : AppColors.surface,
                foregroundColor: _conversationController.text.trim().isNotEmpty
                    ? Colors.white
                    : AppColors.textSecondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                _conversationController.text.trim().isNotEmpty
                    ? '저장 완료'
                    : '대화 내용을 입력해주세요',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void _handleFileUpload() {
    ToastNotification.show(
      context: context,
      message: '파일 업로드 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  void _startSampleAnalysis() {
    _conversationController.text = '''
나: 오늘 카페에서 만나서 정말 즐거웠어요!
상대방: 저도요! 시간 가는 줄 몰랐네요 ㅎㅎ
나: 다음에도 또 만나요~
상대방: 네! 언제든 연락주세요 😊
나: 혹시 이번 주말에 시간 되시나요?
상대방: 토요일 오후는 괜찮을 것 같아요!
나: 그럼 영화 보러 갈까요?
상대방: 좋아요! 어떤 영화 볼까요?''';

    _referenceController.text = '''
• 카페에서 만났을 때 상대방이 계속 웃어주었어요
• 대화할 때 눈을 자주 마주치고 관심있어 보였어요  
• 헤어질 때 아쉬워하는 표정을 지었어요
• 다음 만남을 적극적으로 제안해주었어요''';

    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _analysisStep = 0;
    });

    widget.onAnalyzingStateChanged?.call(true);

    // 분석 단계별 진행
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _analysisStep = i + 1;
        });
      }
    }

    // 분석 완료 상태 표시 (잠시 완료 화면을 보여줌)
    if (mounted) {
      setState(() {
        _analysisStep = 5; // 모든 단계 완료 표시
      });

      // 완료 상태를 1초간 보여준 후 결과 화면으로 전환
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _hasAnalysisData = true;
        });

        widget.onAnalyzingStateChanged?.call(false);

        ToastNotification.show(
          context: context,
          message: '🎉 분석이 완료되었어요! 결과를 확인해보세요',
          type: ToastType.success,
        );
      }
    }
  }

  void _startNewAnalysis() {
    setState(() {
      _hasAnalysisData = false;
      _conversationController.clear();
    });
    widget.onAnalyzingStateChanged?.call(false);
  }

  // 상세 분석 화면들 (2025.07.25 09:34:23 실제 구현)
  void _showPersonalityAnalysis() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _PersonalityAnalysisScreen(analysisData: _analysisData),
      ),
    );
  }

  void _showEmotionalFlow() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _EmotionalFlowScreen(analysisData: _analysisData),
      ),
    );
  }

  void _showMessagePattern() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _MessagePatternScreen(analysisData: _analysisData),
      ),
    );
  }

  void _showTopicAnalysis() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _TopicAnalysisScreen(analysisData: _analysisData),
      ),
    );
  }

  void _showAIRecommendations() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _AIRecommendationsScreen(analysisData: _analysisData),
      ),
    );
  }

  void _showReferenceInput() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReferenceInputModal(),
    );
  }

  Widget _buildReferenceInputModal() => Container(
    height: MediaQuery.of(context).size.height * 0.85,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 심플한 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '참고 내용 입력',
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    HugeIcons.strokeRoundedCancel01,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 간단한 설명
          Text(
            '오프라인에서 느낀 점이나 상황을 추가해주세요 (선택사항)',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 24),

          // 입력 필드 (더 깔끔하게)
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surface),
              ),
              child: TextField(
                controller: _referenceController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText:
                      '예시:\n• 오늘 카페에서 만났는데 상대방이 많이 웃어주었어요\n• 대화할 때 눈을 자주 마주치고 관심있어 보였어요\n• 헤어질 때 아쉬워하는 표정을 지었어요\n• 다음에 또 만나자고 먼저 제안해주었어요',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 간단한 팁
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedBulb,
                  size: 16,
                  color: AppColors.accent.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '직접 만났을 때 느낌 • 상대방 표정/몸짓 • 특별한 상황',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 저장 버튼 (더 심플하게)
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.textSecondary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      '건너뛰기',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      '저장하기',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  /// 시작 화면 (스크롤 가능) - 2025.07.24 10:31:18 개선
  Widget _buildStartScreenWithScroll() => ColoredBox(
    color: AppColors.background,
    child: CustomScrollView(
      slivers: [
        // 상단 웰컴 섹션
        SliverToBoxAdapter(child: _buildWelcomeSummarySection()),

        // 메뉴 리스트
        SliverToBoxAdapter(child: _buildStartMenuContent()),
      ],
    ),
  );

  /// 분석 완료 화면 (스크롤 가능) - 2025.07.24 10:31:18 개선
  Widget _buildAnalysisScreenWithScroll() => ColoredBox(
    color: AppColors.background,
    child: CustomScrollView(
      slivers: [
        // 상단 결과 요약 섹션
        SliverToBoxAdapter(child: _buildResultSummarySection()),

        // 메뉴 리스트
        SliverToBoxAdapter(child: _buildAnalysisMenuContent()),
      ],
    ),
  );
}

/// 성격 관계성 분석 화면 (2025.07.25 09:34:23)
class _PersonalityAnalysisScreen extends StatelessWidget {
  const _PersonalityAnalysisScreen({required this.analysisData});
  final AnalysisData? analysisData;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        '성격 관계성 분석',
        style: AppTextStyles.h3.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          HugeIcons.strokeRoundedArrowLeft01,
          color: AppColors.textPrimary,
        ),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 전체 궁합도 카드
          _buildCompatibilityCard(),
          const SizedBox(height: 24),

          // MBTI 기반 분석
          _buildMBTISection(),
          const SizedBox(height: 24),

          // 성격 5요소 분석
          _buildBigFiveSection(),
          const SizedBox(height: 24),

          // 관계 개선 포인트
          _buildImprovementSection(),
        ],
      ),
    ),
  );

  Widget _buildCompatibilityCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
    ),
    child: Column(
      children: [
        // 궁합도 점수 (더 크고 임팩트 있게)
        Text(
          '${analysisData?.personalityAnalysis?.compatibilityScore ?? 85}%',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 48,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          '궁합도',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        // 심플한 상태 표시
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            _getCompatibilityLevel(
              analysisData?.personalityAnalysis?.compatibilityScore ?? 85,
            ),
            style: AppTextStyles.body1.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildMBTISection() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedUserCircle,
                size: 24,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'MBTI 기반 분석',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 나와 상대방 MBTI
        Row(
          children: [
            Expanded(
              child: _buildMBTICard('나', 'ENFP', '활동가', AppColors.primary),
            ),
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedHeartAdd,
                size: 20,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMBTICard('상대방', 'ISFJ', '수호자', AppColors.green),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // MBTI 궁합 설명
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENFP ❤️ ISFJ 궁합 분석',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• 외향적인 ENFP와 내향적인 ISFJ는 서로를 보완하는 관계\n'
                '• ENFP의 창의성과 ISFJ의 안정성이 균형을 이룸\n'
                '• 소통 방식의 차이로 오해가 생길 수 있으니 주의 필요',
                style: AppTextStyles.body2.copyWith(color: AppColors.blue),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildMBTICard(
    String label,
    String mbti,
    String nickname,
    Color color,
  ) => Column(
    children: [
      Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        mbti,
        style: AppTextStyles.h1.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        nickname,
        style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
      ),
    ],
  );

  Widget _buildBigFiveSection() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedAnalytics01,
                size: 24,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '성격 5요소 분석',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 성격 5요소 차트
        ..._buildPersonalityTraits(),
      ],
    ),
  );

  List<Widget> _buildPersonalityTraits() {
    final traits = [
      {'name': '외향성', 'my': 85, 'partner': 30, 'color': AppColors.primary},
      {'name': '친화성', 'my': 75, 'partner': 90, 'color': AppColors.green},
      {'name': '성실성', 'my': 60, 'partner': 85, 'color': AppColors.blue},
      {'name': '신경성', 'my': 40, 'partner': 55, 'color': AppColors.warning},
      {'name': '개방성', 'my': 90, 'partner': 45, 'color': AppColors.accent},
    ];

    return traits
        .map(
          (trait) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trait['name']! as String,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // 나의 점수
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '나',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${trait['my']}%',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: trait['color']! as Color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (trait['my']! as int) / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: trait['color']! as Color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 상대방 점수
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '상대방',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${trait['partner']}%',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: (trait['color']! as Color).withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (trait['partner']! as int) / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (trait['color']! as Color).withValues(
                                    alpha: 0.7,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildImprovementSection() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedTarget01,
                size: 24,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '관계 개선 포인트',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 개선 포인트들
        ..._buildImprovementPoints(),
      ],
    ),
  );

  List<Widget> _buildImprovementPoints() {
    final points = [
      {
        'icon': HugeIcons.strokeRoundedMessage01,
        'title': '소통 방식 개선',
        'description': 'ENFP는 직관적으로, ISFJ는 구체적으로 소통하는 경향이 있어요',
        'tip': '상대방의 소통 스타일에 맞춰 구체적인 예시와 함께 대화해보세요',
        'color': AppColors.blue,
      },
      {
        'icon': HugeIcons.strokeRoundedClock01,
        'title': '시간 관리 조율',
        'description': '계획성에서 차이가 나므로 일정 조율이 중요해요',
        'tip': '미리 계획을 세우고 상대방과 공유하여 갈등을 예방하세요',
        'color': AppColors.warning,
      },
      {
        'icon': HugeIcons.strokeRoundedHeartAdd,
        'title': '감정 표현 균형',
        'description': '감정 표현의 강도와 방식에서 차이가 있을 수 있어요',
        'tip': '상대방의 감정 표현 방식을 이해하고 존중해주세요',
        'color': AppColors.accent,
      },
    ];

    return points
        .map(
          (point) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (point['color']! as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (point['color']! as Color).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      point['icon']! as IconData,
                      size: 20,
                      color: point['color']! as Color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      point['title']! as String,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: point['color']! as Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  point['description']! as String,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedBulb,
                        size: 16,
                        color: point['color']! as Color,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          point['tip']! as String,
                          style: AppTextStyles.caption.copyWith(
                            color: point['color']! as Color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  String _getCompatibilityLevel(int score) {
    if (score >= 90) return '완벽한 궁합 💕';
    if (score >= 80) return '찰떡궁합 ✨';
    if (score >= 70) return '좋은 관계 😊';
    if (score >= 60) return '무난한 관계 👍';
    if (score >= 50) return '노력 필요 💪';
    return '많은 노력 필요 🤔';
  }
}

/// 감정 흐름 분석 화면 (2025.07.25 09:34:23)
class _EmotionalFlowScreen extends StatelessWidget {
  const _EmotionalFlowScreen({required this.analysisData});
  final AnalysisData? analysisData;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        '감정 흐름 분석',
        style: AppTextStyles.h3.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          HugeIcons.strokeRoundedArrowLeft01,
          color: AppColors.textPrimary,
        ),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 전체 감정 요약
          _buildEmotionSummary(),
          const SizedBox(height: 24),

          // 시간별 감정 변화 차트
          _buildEmotionChart(),
          const SizedBox(height: 24),

          // 주요 감정 이벤트
          _buildKeyEvents(),
          const SizedBox(height: 24),

          // 감정 패턴 분석
          _buildEmotionPatterns(),
        ],
      ),
    ),
  );

  Widget _buildEmotionSummary() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.accent.withValues(alpha: 0.1)),
    ),
    child: Column(
      children: [
        // 전체 감정 점수 (더 크고 임팩트 있게)
        Text(
          '82%',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
            fontSize: 48,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          '감정 긍정도',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        // 심플한 상태 표시
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            '매우 긍정적인 관계',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildEmotionChart() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.surface),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '감정 변화 차트',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),

        // 간단한 라인 차트
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomPaint(
            size: const Size(double.infinity, 180),
            painter: _EmotionChartPainter(),
          ),
        ),
        const SizedBox(height: 20),

        // 차트 범례 (더 심플하게)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('내 감정', AppColors.primary),
            const SizedBox(width: 24),
            _buildLegendItem('상대방 감정', AppColors.accent),
            const SizedBox(width: 24),
            _buildLegendItem('전체 분위기', AppColors.green),
          ],
        ),
      ],
    ),
  );

  Widget _buildLegendItem(String label, Color color) => Row(
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
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
    ],
  );

  Widget _buildKeyEvents() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedStar,
                size: 24,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '주요 감정 이벤트',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 주요 이벤트들
        ..._buildEventItems(),
      ],
    ),
  );

  List<Widget> _buildEventItems() {
    final events = [
      {
        'time': '오후 2:30',
        'type': 'positive',
        'title': '감정 급상승 📈',
        'description': '"같이 영화 보러 갈까요?" 메시지 이후 양쪽 모두 긍정적 반응',
        'score': '+25%',
        'color': AppColors.green,
      },
      {
        'time': '오후 4:15',
        'type': 'peak',
        'title': '감정 최고점 🎉',
        'description': '만남 약속 확정 후 가장 높은 감정 점수 기록',
        'score': '95%',
        'color': AppColors.accent,
      },
      {
        'time': '오후 6:20',
        'type': 'neutral',
        'title': '안정적 유지 😊',
        'description': '일상적인 대화로 전환, 편안한 분위기 지속',
        'score': '80%',
        'color': AppColors.blue,
      },
      {
        'time': '저녁 8:45',
        'type': 'positive',
        'title': '마무리 긍정 💕',
        'description': '"오늘 정말 즐거웠어요" 메시지로 하루 마무리',
        'score': '+15%',
        'color': AppColors.primary,
      },
    ];

    return events
        .map(
          (event) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 시간 라벨
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    event['time']! as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 이벤트 도트
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: event['color']! as Color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      if (events.last != event)
                        Container(
                          width: 2,
                          height: 40,
                          color: AppColors.surface,
                          margin: const EdgeInsets.only(top: 4),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // 이벤트 내용
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (event['color']! as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (event['color']! as Color).withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              event['title']! as String,
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: event['color']! as Color,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: event['color']! as Color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                event['score']! as String,
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event['description']! as String,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildEmotionPatterns() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedBrain01,
                size: 24,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '감정 패턴 분석',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 패턴 인사이트들
        ..._buildPatternInsights(),
      ],
    ),
  );

  List<Widget> _buildPatternInsights() {
    final insights = [
      {
        'icon': HugeIcons.strokeRoundedArrowUp01,
        'title': '감정 상승 패턴',
        'description': '미래 계획이나 만남 제안 시 감정이 크게 상승하는 패턴',
        'tip': '구체적인 계획을 제안하면 더 긍정적인 반응을 얻을 수 있어요',
        'color': AppColors.green,
      },
      {
        'icon': HugeIcons.strokeRoundedClock01,
        'title': '시간대별 특성',
        'description': '오후 시간대에 가장 활발하고 긍정적인 대화가 이루어짐',
        'tip': '중요한 대화는 오후 2-6시 사이에 하는 것이 효과적이에요',
        'color': AppColors.blue,
      },
      {
        'icon': HugeIcons.strokeRoundedHeartAdd,
        'title': '감정 동조화',
        'description': '서로의 감정이 비슷한 패턴으로 변화하는 높은 동조화 현상',
        'tip': '감정적으로 잘 맞는 관계로, 솔직한 감정 표현이 도움될 거예요',
        'color': AppColors.accent,
      },
    ];

    return insights
        .map(
          (insight) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (insight['color']! as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (insight['color']! as Color).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      insight['icon']! as IconData,
                      size: 20,
                      color: insight['color']! as Color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      insight['title']! as String,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: insight['color']! as Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  insight['description']! as String,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedBulb,
                        size: 16,
                        color: insight['color']! as Color,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          insight['tip']! as String,
                          style: AppTextStyles.caption.copyWith(
                            color: insight['color']! as Color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

/// 감정 차트 페인터 (2025.07.25 09:34:23)
class _EmotionChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // 배경 그리드
    final gridPaint = Paint()
      ..color = AppColors.surface
      ..strokeWidth = 1;

    // 세로 그리드
    for (int i = 0; i <= 6; i++) {
      final x = size.width * i / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // 가로 그리드
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 내 감정 라인 (파란색)
    paint.color = AppColors.primary;
    final myEmotionPath = Path();
    final myPoints = [0.3, 0.4, 0.7, 0.9, 0.8, 0.85, 0.75];
    myEmotionPath.moveTo(0, size.height * (1 - myPoints[0]));
    for (int i = 1; i < myPoints.length; i++) {
      myEmotionPath.lineTo(
        size.width * i / (myPoints.length - 1),
        size.height * (1 - myPoints[i]),
      );
    }
    canvas.drawPath(myEmotionPath, paint);

    // 상대방 감정 라인 (보라색)
    paint.color = AppColors.accent;
    final partnerEmotionPath = Path();
    final partnerPoints = [0.4, 0.5, 0.6, 0.85, 0.9, 0.8, 0.82];
    partnerEmotionPath.moveTo(0, size.height * (1 - partnerPoints[0]));
    for (int i = 1; i < partnerPoints.length; i++) {
      partnerEmotionPath.lineTo(
        size.width * i / (partnerPoints.length - 1),
        size.height * (1 - partnerPoints[i]),
      );
    }
    canvas.drawPath(partnerEmotionPath, paint);

    // 전체 분위기 라인 (초록색)
    paint.color = AppColors.green;
    final overallPath = Path();
    final overallPoints = [0.35, 0.45, 0.65, 0.87, 0.85, 0.82, 0.78];
    overallPath.moveTo(0, size.height * (1 - overallPoints[0]));
    for (int i = 1; i < overallPoints.length; i++) {
      overallPath.lineTo(
        size.width * i / (overallPoints.length - 1),
        size.height * (1 - overallPoints[i]),
      );
    }
    canvas.drawPath(overallPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 메시지 패턴 분석 화면 (2025.07.25 09:34:23)
class _MessagePatternScreen extends StatelessWidget {
  const _MessagePatternScreen({required this.analysisData});
  final AnalysisData? analysisData;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        '메시지 패턴 분석',
        style: AppTextStyles.h3.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          HugeIcons.strokeRoundedArrowLeft01,
          color: AppColors.textPrimary,
        ),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 활동 시간 분석
          _buildActivityTimeCard(),
          const SizedBox(height: 20),

          // 응답 속도 분석
          _buildResponseSpeedCard(),
          const SizedBox(height: 20),

          // 메시지 길이 분석
          _buildMessageLengthCard(),
          const SizedBox(height: 20),

          // 소통 스타일 분석
          _buildCommunicationStyleCard(),
        ],
      ),
    ),
  );

  Widget _buildActivityTimeCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedClock01,
                size: 24,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '활동 시간 분석',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 시간대별 활동도
        Text(
          '가장 활발한 시간대',
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildTimeSlot('오전', '9-12시', 30, AppColors.warning),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimeSlot('오후', '2-6시', 85, AppColors.primary),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimeSlot('저녁', '7-10시', 65, AppColors.accent),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildTimeSlot(
    String period,
    String time,
    int activity,
    Color color,
  ) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Column(
      children: [
        Text(
          period,
          style: AppTextStyles.body2.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          time,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Text(
          '$activity%',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );

  Widget _buildResponseSpeedCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedFlash,
                size: 24,
                color: AppColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '응답 속도 분석',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: _buildResponseMetric(
                '내 평균 응답',
                '3분 12초',
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildResponseMetric('상대방 평균', '1분 45초', AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                HugeIcons.strokeRoundedInformationCircle,
                size: 20,
                color: AppColors.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '상대방이 더 빠른 응답을 보여 적극적인 관심을 나타내고 있어요!',
                  style: AppTextStyles.body2.copyWith(color: AppColors.green),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildResponseMetric(String label, String value, Color color) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.h3.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _buildMessageLengthCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedMessage01,
                size: 24,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '메시지 길이 분석',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 메시지 길이 비교
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 메시지 평균',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '47자',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '상대방 메시지 평균',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '32자',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
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

  Widget _buildCommunicationStyleCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedBrain01,
                size: 24,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '소통 스타일 분석',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 소통 스타일 특성들
        _buildStyleItem('질문형 대화', '70%', '상대방에 대한 관심이 높음', AppColors.primary),
        const SizedBox(height: 12),
        _buildStyleItem('감정 표현', '85%', '솔직하고 따뜻한 감정 표현', AppColors.accent),
        const SizedBox(height: 12),
        _buildStyleItem('유머 사용', '45%', '적절한 유머로 분위기 조성', AppColors.green),
      ],
    ),
  );

  Widget _buildStyleItem(
    String title,
    String score,
    String description,
    Color color,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
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
        Text(
          score,
          style: AppTextStyles.h3.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

/// 대화 주제 분석 화면 (2025.07.25 09:34:23)
class _TopicAnalysisScreen extends StatelessWidget {
  const _TopicAnalysisScreen({required this.analysisData});
  final AnalysisData? analysisData;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        '대화 주제 분석',
        style: AppTextStyles.h3.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          HugeIcons.strokeRoundedArrowLeft01,
          color: AppColors.textPrimary,
        ),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 주요 키워드 워드클라우드
          _buildWordCloudCard(),
          const SizedBox(height: 20),

          // 주제별 빈도 분석
          _buildTopicFrequencyCard(),
          const SizedBox(height: 20),

          // 관심사 매칭
          _buildInterestMatchingCard(),
        ],
      ),
    ),
  );

  Widget _buildWordCloudCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedMessage01,
                size: 24,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '주요 대화 키워드',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 워드클라우드 시뮬레이션 (태그 형태)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildKeywordTag('영화', 45, AppColors.primary),
            _buildKeywordTag('카페', 32, AppColors.accent),
            _buildKeywordTag('음식', 28, AppColors.green),
            _buildKeywordTag('여행', 25, AppColors.blue),
            _buildKeywordTag('취미', 22, AppColors.warning),
            _buildKeywordTag('운동', 18, AppColors.primary),
            _buildKeywordTag('책', 15, AppColors.accent),
            _buildKeywordTag('음악', 12, AppColors.green),
            _buildKeywordTag('게임', 10, AppColors.blue),
          ],
        ),
      ],
    ),
  );

  Widget _buildKeywordTag(String keyword, int frequency, Color color) {
    final fontSize = 12.0 + (frequency / 45 * 8); // 빈도에 따른 크기 조절
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$keyword ($frequency)',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTopicFrequencyCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주제별 대화 빈도',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),

        _buildTopicBar('일상/취미', 40, AppColors.primary),
        const SizedBox(height: 12),
        _buildTopicBar('음식/맛집', 25, AppColors.accent),
        const SizedBox(height: 12),
        _buildTopicBar('영화/문화', 20, AppColors.green),
        const SizedBox(height: 12),
        _buildTopicBar('여행/계획', 15, AppColors.blue),
      ],
    ),
  );

  Widget _buildTopicBar(String topic, int percentage, Color color) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            topic,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '$percentage%',
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        height: 8,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: percentage / 100,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildInterestMatchingCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '공통 관심사 분석',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    HugeIcons.strokeRoundedHeartAdd,
                    size: 24,
                    color: AppColors.green,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '매칭도: 85%',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '영화, 음식, 여행에 대한 공통 관심사가 높아 대화가 자연스럽게 이어지고 있어요!',
                style: AppTextStyles.body2.copyWith(color: AppColors.green),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// AI 추천 액션 화면 (2025.07.25 09:34:23)
class _AIRecommendationsScreen extends StatelessWidget {
  const _AIRecommendationsScreen({required this.analysisData});
  final AnalysisData? analysisData;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'AI 추천 액션',
        style: AppTextStyles.h3.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          HugeIcons.strokeRoundedArrowLeft01,
          color: AppColors.textPrimary,
        ),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 즉시 실행 추천
          _buildImmediateActionsCard(),
          const SizedBox(height: 20),

          // 관계 발전 단계별 추천
          _buildStageRecommendationsCard(),
          const SizedBox(height: 20),

          // 대화 주제 추천
          _buildTopicSuggestionsCard(),
        ],
      ),
    ),
  );

  Widget _buildImmediateActionsCard() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '추천 액션',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),

        _buildActionItem(
          '영화 추천하기',
          '공통 관심사인 영화에 대해 구체적인 추천을 해보세요',
          '높음',
          AppColors.textPrimary,
        ),
        const SizedBox(height: 16),
        _buildActionItem(
          '주말 계획 제안',
          '상대방이 적극적으로 반응하는 미래 계획을 제안해보세요',
          '높음',
          AppColors.textPrimary,
        ),
      ],
    ),
  );

  Widget _buildActionItem(
    String title,
    String description,
    String priority,
    Color textColor,
  ) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                priority,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    ),
  );

  Widget _buildStageRecommendationsCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '관계 발전 단계별 추천',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),

        _buildStageItem('현재 단계', '친밀한 친구', '85%', AppColors.green, true),
        const SizedBox(height: 16),
        _buildStageItem('다음 단계', '특별한 관계', '진행 중', AppColors.primary, false),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '다음 단계로 발전하려면',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• 더 개인적이고 깊은 대화 시도\n'
                '• 오프라인 만남 빈도 증가\n'
                '• 감정적 지지와 공감대 형성',
                style: AppTextStyles.body2.copyWith(color: AppColors.blue),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildStageItem(
    String label,
    String stage,
    String progress,
    Color color,
    bool isCompleted,
  ) => Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: isCompleted ? color : color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              stage,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      Text(
        progress,
        style: AppTextStyles.body2.copyWith(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    ],
  );

  Widget _buildTopicSuggestionsCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '추천 대화 주제',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),

        _buildTopicSuggestion(
          '🍕 새로운 맛집 탐방',
          '음식에 대한 관심이 높으니 새로운 맛집을 함께 찾아보는 건 어떨까요?',
          AppColors.accent,
        ),
        const SizedBox(height: 12),
        _buildTopicSuggestion(
          '🌍 여행 계획 세우기',
          '여행 이야기에 긍정적 반응을 보이니 구체적인 여행 계획을 제안해보세요',
          AppColors.blue,
        ),
        const SizedBox(height: 12),
        _buildTopicSuggestion(
          '🎨 취미 공유하기',
          '서로의 취미에 대해 더 깊이 알아보고 함께 할 수 있는 활동을 찾아보세요',
          AppColors.green,
        ),
      ],
    ),
  );

  Widget _buildTopicSuggestion(String title, String description, Color color) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
}
