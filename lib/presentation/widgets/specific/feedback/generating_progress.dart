// File: lib/presentation/widgets/specific/feedback/generating_progress.dart

import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// AI 메시지 생성 진행 상황을 보여주는 위젯입니다.
///
/// 메시지 생성 과정을 단계별로 시각화하여 사용자에게 진행 상황을 알려줍니다.
/// 18세 서현 페르소나에 맞는 친근하고 재미있는 메시지와 애니메이션을 제공합니다.
///
/// 주요 특징:
/// - 4단계 생성 프로세스 시각화
/// - 각 단계별 진행 애니메이션
/// - 재미있는 로딩 메시지
/// - 심장 박동 애니메이션
/// - 단계별 색상 변화
/// - 예상 완료 시간 표시
///
/// 사용 예시:
/// ```dart
/// GeneratingProgress(
///   currentStep: 2,
///   isCompleted: false,
///   onCancel: () => print('생성 취소'),
/// )
/// ```
class GeneratingProgress extends StatefulWidget {
  /// 현재 진행 단계 (0부터 시작)
  final int currentStep;
  
  /// 전체 단계 수
  final int? totalSteps;
  
  /// 각 단계별 텍스트
  final List<String>? stepTexts;
  
  /// 생성 완료 여부
  final bool isCompleted;
  
  /// 취소 버튼 클릭 시 호출되는 콜백
  final VoidCallback? onCancel;
  
  /// 예상 완료 시간 (초)
  final int estimatedSeconds;

  const GeneratingProgress({
    super.key,
    this.currentStep = 0,
    this.totalSteps,
    this.stepTexts,
    this.isCompleted = false,
    this.onCancel,
    this.estimatedSeconds = 15,
  });

  @override
  State<GeneratingProgress> createState() => _GeneratingProgressState();
}

class _GeneratingProgressState extends State<GeneratingProgress>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _progressController;
  late AnimationController _pulseController;
  
  late Animation<double> _heartAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  
  /// 생성 단계 정보
  static const List<GenerationStep> _steps = [
    GenerationStep(
      title: '상대방 분석 중...',
      description: 'MBTI와 성격을 파악하고 있어요',
      emoji: '🧠',
      color: Color(0xFF8B5CF6),
      messages: [
        '상대방이 어떤 사람인지 알아보는 중...',
        'MBTI 특성을 분석하고 있어요',
        '성격 패턴을 파악 중이에요',
      ],
    ),
    GenerationStep(
      title: '상황 파악 중...',
      description: '선택한 상황에 맞는 컨텍스트를 만들어요',
      emoji: '🎯',
      color: Color(0xFF10B981),
      messages: [
        '어떤 상황인지 정확히 파악하는 중...',
        '최적의 타이밍을 계산하고 있어요',
        '상황에 맞는 톤을 설정 중이에요',
      ],
    ),
    GenerationStep(
      title: '감정 조합 중...',
      description: '선택한 감정들을 자연스럽게 섞어요',
      emoji: '💫',
      color: Color(0xFFFF70A6),
      messages: [
        '감정을 완벽하게 조합하는 중...',
        '자연스러운 어투를 만들고 있어요',
        '18세 감성에 맞게 조절 중이에요',
      ],
    ),
    GenerationStep(
      title: '메시지 완성 중...',
      description: '최종 메시지를 다듬고 있어요',
      emoji: '✨',
      color: Color(0xFFFFA500),
      messages: [
        '완벽한 메시지를 만들고 있어요',
        '마지막 터치를 추가하는 중...',
        '곧 완성될 거예요!',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // 심장 박동 애니메이션
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _heartAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));
    
    // 진행 바 애니메이션
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));
    
    // 펄스 애니메이션
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // 애니메이션 시작
    _heartController.repeat(reverse: true);
    _pulseController.repeat();
    _updateProgress();
  }

  @override
  void didUpdateWidget(GeneratingProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _updateProgress();
    }
  }

  void _updateProgress() {
    final totalSteps = widget.totalSteps ?? _steps.length;
    final progress = widget.isCompleted ? 1.0 : (widget.currentStep + 1) / totalSteps;
    _progressController.animateTo(progress);
  }

  @override
  void dispose() {
    _heartController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.primary.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 헤더
          _buildHeader(),
          const SizedBox(height: 32),
          
          // 진행 바
          _buildProgressBar(),
          const SizedBox(height: 24),
          
          // 현재 단계 표시
          _buildCurrentStep(),
          const SizedBox(height: 24),
          
          // 단계 목록
          _buildStepsList(),
          const SizedBox(height: 24),
          
          // 하단 정보
          _buildFooter(),
        ],
      ),
    );
  }

  /// 헤더 섹션
  Widget _buildHeader() {
    return Row(
      children: [
        // 심장 박동 아이콘
        AnimatedBuilder(
          animation: _heartAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _heartAnimation.value,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        
        // 제목과 설명
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI가 완벽한 메시지를 만들고 있어요!',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '잠깐만 기다려줘! 곧 끝날거야 💕',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.charcoal.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        
        // 취소 버튼
        if (widget.onCancel != null) ...[
          GestureDetector(
            onTap: widget.onCancel,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.close,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// 진행 바
  Widget _buildProgressBar() {
    return Column(
      children: [
        // 진행률 텍스트
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '진행률',
              style: AppTextStyles.helper.copyWith(
                color: AppColors.charcoal.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '${((widget.currentStep + 1) / _steps.length * 100).toInt()}%',
              style: AppTextStyles.helper.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 진행 바
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 현재 단계 표시
  Widget _buildCurrentStep() {
    if (widget.isCompleted) {
      return _buildCompletedState();
    }
    
    final currentStepData = widget.currentStep < _steps.length ? _steps[widget.currentStep] : _steps.last;
    final stepText = widget.stepTexts != null && widget.currentStep < widget.stepTexts!.length 
        ? widget.stepTexts![widget.currentStep] 
        : currentStepData.title;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: currentStepData.color.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: currentStepData.color.withValues(alpha: 0.1 + _pulseAnimation.value * 0.1),
                blurRadius: 12 + _pulseAnimation.value * 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 이모지와 제목
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentStepData.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        currentStepData.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stepText,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.charcoal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentStepData.description,
                          style: AppTextStyles.helper.copyWith(
                            color: AppColors.charcoal.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 로딩 메시지
              _buildLoadingMessage(currentStepData),
            ],
          ),
        );
      },
    );
  }

  /// 로딩 메시지
  Widget _buildLoadingMessage(GenerationStep step) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: step.color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // 로딩 인디케이터
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(step.color),
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 12),
          
          // 메시지
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                step.messages[widget.currentStep % step.messages.length],
                key: ValueKey(widget.currentStep),
                style: AppTextStyles.helper.copyWith(
                  color: step.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 완료 상태
  Widget _buildCompletedState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.1),
            Colors.green.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '메시지 완성! 🎉',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '완벽한 메시지가 준비됐어요!',
                  style: AppTextStyles.helper.copyWith(
                    color: Colors.green.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 단계 목록
  Widget _buildStepsList() {
    return Column(
      children: _steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = index < widget.currentStep || widget.isCompleted;
        final isCurrent = index == widget.currentStep && !widget.isCompleted;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // 단계 인디케이터
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? step.color
                      : isCurrent
                          ? step.color.withValues(alpha: 0.3)
                          : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isCurrent ? step.color : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              
              // 단계 정보
              Expanded(
                child: Text(
                  step.title.replaceAll('...', ''),
                  style: AppTextStyles.helper.copyWith(
                    color: isCompleted || isCurrent
                        ? AppColors.charcoal
                        : Colors.grey[500],
                    fontWeight: isCompleted || isCurrent
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 하단 정보
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time,
              color: Colors.grey[500],
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '예상 시간: ${widget.estimatedSeconds}초',
              style: AppTextStyles.helper.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'AI 생성 중',
              style: AppTextStyles.helper.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 생성 단계 데이터 클래스
class GenerationStep {
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final List<String> messages;

  const GenerationStep({
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    required this.messages,
  });
} 