// File: lib/presentation/screens/ai_message_screen.dart
// 2025.07.15 22:38:46 AI 메시지 생성 화면 구현

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../widgets/common/component_card.dart';
import '../widgets/common/primary_button.dart';
import '../widgets/common/secondary_button.dart';
import '../widgets/specific/feedback/toast_notification.dart';

/// AI 메시지 생성 화면
///
/// 사용자의 상황과 상대방 정보를 바탕으로 AI가 메시지를 생성하는 화면
/// 18세 서현 페르소나에 맞는 직관적인 메시지 생성 도구
class AIMessageScreen extends StatefulWidget {
  const AIMessageScreen({super.key});

  @override
  State<AIMessageScreen> createState() => _AIMessageScreenState();
}

class _AIMessageScreenState extends State<AIMessageScreen> {
  final TextEditingController _situationController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();

  bool _isGenerating = false;
  String? _generatedMessage;

  // 메시지 타입 선택
  int _selectedType = 0;
  final List<String> _messageTypes = [
    '일상 대화',
    '데이트 제안',
    '답장하기',
    '감정 표현',
    '사과하기',
    '축하하기',
  ];

  @override
  void dispose() {
    _situationController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'AI 메시지 생성',
          style: AppTextStyles.mainTitle.copyWith(color: AppColors.primaryText),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildMessageTypeSelector(),
            const SizedBox(height: 16),
            _buildSituationInput(),
            const SizedBox(height: 16),
            _buildContextInput(),
            const SizedBox(height: 20),
            _buildGenerateButton(),
            if (_generatedMessage != null) ...[
              const SizedBox(height: 20),
              _buildGeneratedMessage(),
            ],
          ],
        ),
      ),
    );
  }

  // 헤더
  Widget _buildHeader() {
    return Container(
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
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
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
                  'AI가 완벽한 메시지를 만들어드려요!',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '상황과 맥락을 알려주시면 맞춤형 메시지를 생성해드릴게요',
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

  // 메시지 타입 선택기
  Widget _buildMessageTypeSelector() {
    return ComponentCard(
      title: '메시지 타입 선택',
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _messageTypes.asMap().entries.map((entry) {
              int index = entry.key;
              String type = entry.value;
              bool isSelected = index == _selectedType;

              return GestureDetector(
                onTap: () => setState(() => _selectedType = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    type,
                    style: AppTextStyles.body.copyWith(
                      color: isSelected ? Colors.white : AppColors.primaryText,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 상황 입력
  Widget _buildSituationInput() {
    return ComponentCard(
      title: '현재 상황',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '어떤 상황에서 메시지를 보내시나요?',
            style: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _situationController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '예: 어제 데이트 후 감사 인사를 하고 싶어요',
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.secondaryText.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  // 맥락 입력
  Widget _buildContextInput() {
    return ComponentCard(
      title: '추가 정보',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상대방과의 관계나 특별한 맥락이 있나요?',
            style: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contextController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '예: 3번째 만남, 상대방이 ENFP 성격, 커피를 좋아함',
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.secondaryText.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  // 생성 버튼
  Widget _buildGenerateButton() {
    return _isGenerating
        ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI가 메시지를 생성하고 있어요...',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          )
        : PrimaryButton(
            text: '메시지 생성하기',
            onPressed: _canGenerate() ? _generateMessage : null,
          );
  }

  // 생성된 메시지
  Widget _buildGeneratedMessage() {
    return ComponentCard(
      title: '생성된 메시지',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              _generatedMessage!,
              style: AppTextStyles.body.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  onPressed: _regenerateMessage,
                  text: '다시 생성',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(onPressed: _copyMessage, text: '복사하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 생성 가능 여부 확인
  bool _canGenerate() {
    return _situationController.text.trim().isNotEmpty;
  }

  // 메시지 생성
  void _generateMessage() async {
    setState(() => _isGenerating = true);

    // 실제로는 AI API 호출
    await Future.delayed(const Duration(seconds: 2));

    // 샘플 메시지 생성
    String sampleMessage = _getSampleMessage();

    setState(() {
      _isGenerating = false;
      _generatedMessage = sampleMessage;
    });
  }

  // 샘플 메시지 반환
  String _getSampleMessage() {
    switch (_selectedType) {
      case 0: // 일상 대화
        return '안녕하세요! 오늘 하루 어떻게 보내셨어요? 날씨가 정말 좋네요 😊';
      case 1: // 데이트 제안
        return '혹시 이번 주말에 시간 되시면 새로 생긴 카페 가볼까요? 분위기 좋다고 하더라고요 ☕';
      case 2: // 답장하기
        return '답장 늦어서 죄송해요! 바빠서 못 봤어요 😅 말씀해주신 내용 정말 흥미롭네요!';
      case 3: // 감정 표현
        return '오늘 정말 즐거웠어요! 덕분에 기분이 많이 좋아졌답니다 💕';
      case 4: // 사과하기
        return '정말 죄송해요. 제가 잘못 생각했나 봐요. 다음에는 더 신중하게 할게요 🙏';
      case 5: // 축하하기
        return '정말 축하드려요! 그동안 노력한 보람이 있네요. 너무 기뻐요! 🎉';
      default:
        return '안녕하세요! 좋은 하루 보내세요 😊';
    }
  }

  // 메시지 재생성
  void _regenerateMessage() {
    _generateMessage();
  }

  // 메시지 복사
  void _copyMessage() {
    // 실제로는 클립보드에 복사
    ToastNotification.show(
      context: context,
      message: '메시지가 복사되었어요!',
      type: ToastType.success,
    );
  }
}
