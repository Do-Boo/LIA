// File: lib/presentation/widgets/specific/virtual_chat_view.dart
// 2025.07.23 14:35:00 디버깅 완료 - ChatMessage 클래스 정의 및 오류 수정

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../screens/analyzed_people_screen.dart';

/// 채팅 메시지 데이터 모델
class ChatMessage {
  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.type = 'text',
  });

  final String id;
  final String text;
  final bool isMe;
  final String time;
  final String type; // 'text', 'image', 'file' 등 확장 가능
}

/// 가상 채팅 뷰 위젯
///
/// 특정 분석된 사람과의 가상 채팅을 담당하는 위젯입니다.
/// 실시간 채팅 인터페이스와 AI 응답 시뮬레이션을 제공합니다.
class VirtualChatView extends StatefulWidget {
  const VirtualChatView({required this.person, super.key});
  final AnalyzedPerson person;

  @override
  State<VirtualChatView> createState() => _VirtualChatViewState();
}

class _VirtualChatViewState extends State<VirtualChatView> {
  List<ChatMessage> _chatMessages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Column(
        children: [
          // 채팅 헤더
          _buildChatHeader(),
          // 채팅 메시지 리스트
          Expanded(child: _buildChatMessages()),
          // 메시지 입력 영역
          _buildMessageInput(),
        ],
      ),
    ),
  );

  // 채팅 헤더
  Widget _buildChatHeader() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.person.name.isNotEmpty ? widget.person.name[0] : '?',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
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
                widget.person.name,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${widget.person.mbti} • ${widget.person.relationship}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _showPersonInfo,
          icon: const Icon(
            HugeIcons.strokeRoundedInformationCircle,
            color: AppColors.textSecondary,
            size: 24,
          ),
        ),
      ],
    ),
  );

  // 채팅 메시지 리스트
  Widget _buildChatMessages() {
    if (_chatMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedMessageMultiple01,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '대화를 시작해보세요!',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.person.name}님과 가상 대화를 나누어 보세요',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _chatScrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _chatMessages.length,
      itemBuilder: (context, index) =>
          _buildChatMessageItem(_chatMessages[index]),
    );
  }

  // 채팅 메시지 아이템
  Widget _buildChatMessageItem(ChatMessage message) {
    final isMe = message.isMe;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  widget.person.name.isNotEmpty ? widget.person.name[0] : '?',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : Colors.grey[100],
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isMe
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
              ),
              child: Text(
                message.text,
                style: AppTextStyles.body2.copyWith(
                  color: isMe ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          if (!isMe) ...[
            const SizedBox(width: 8),
            Text(
              message.time,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (isMe) ...[
            const SizedBox(width: 8),
            Text(
              message.time,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 메시지 입력 영역
  Widget _buildMessageInput() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: '메시지를 입력하세요...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: IconButton(
            onPressed: _sendMessage,
            icon: const Icon(
              HugeIcons.strokeRoundedSent,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    ),
  );

  // 데이터 로드 함수들
  void _loadChatHistory() {
    // 임시 데이터 - 실제로는 저장된 채팅 기록을 로드
    setState(() {
      _chatMessages = [
        ChatMessage(
          id: '1',
          text: '안녕! 오늘 어떻게 지냈어?',
          isMe: true,
          time: '14:30',
        ),
        ChatMessage(
          id: '2',
          text: '안녕! 오늘 회사에서 프로젝트 발표가 있어서 좀 바빴어. 너는 어때?',
          isMe: false,
          time: '14:32',
        ),
      ];
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      isMe: true,
      time:
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    setState(() {
      _chatMessages.add(message);
      _messageController.clear();
    });

    // AI 응답 시뮬레이션
    Future.delayed(const Duration(seconds: 1), _generateAIResponse);

    // 스크롤을 맨 아래로
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _generateAIResponse() {
    // MBTI 기반 AI 응답 시뮬레이션
    final responses = _getPersonalizedResponses();
    final response = responses[DateTime.now().millisecond % responses.length];

    final aiMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: response,
      isMe: false,
      time:
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    setState(() {
      _chatMessages.add(aiMessage);
    });

    // 스크롤을 맨 아래로
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // MBTI 기반 개인화된 응답 생성
  List<String> _getPersonalizedResponses() {
    final mbti = widget.person.mbti.toUpperCase();

    // MBTI별 응답 패턴 차별화
    if (mbti.startsWith('E')) {
      // 외향형 - 활발하고 에너지 넘치는 응답
      return [
        '와! 정말 대단해! 더 자세히 얘기해줘!',
        '그렇구나! 나도 비슷한 경험이 있어서 완전 공감돼!',
        '오늘 정말 바쁜 하루였겠다! 고생했어!',
        '프로젝트 발표라니! 어떤 반응이었어?',
        '와 진짜? 그래서 어떻게 됐는데?',
      ];
    } else {
      // 내향형 - 차분하고 사려깊은 응답
      return [
        '그렇구나. 정말 수고했어.',
        '오늘 하루도 고생 많았네.',
        '그런 일이 있었구나. 어떤 기분이었어?',
        '힘들었겠다. 잘 해냈네.',
        '그래도 무사히 끝나서 다행이야.',
      ];
    }
  }

  void _showPersonInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.person.name} 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MBTI: ${widget.person.mbti}'),
            const SizedBox(height: 8),
            Text('관계: ${widget.person.relationship}'),
            const SizedBox(height: 8),
            Text('총 대화 횟수: ${widget.person.chatCount}회'),
            const SizedBox(height: 8),
            Text('분석 점수: ${widget.person.analysisScore}/100'),
            const SizedBox(height: 8),
            Text('분석 날짜: ${widget.person.analysisDate}'),
            if (widget.person.keyInsights.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('주요 특징: ${widget.person.keyInsights.join(', ')}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
