// File: lib/presentation/screens/analyzed_people_screen.dart

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';
import '../widgets/specific/virtual_chat_view.dart';

/// 분석된 사람 데이터 모델
class AnalyzedPerson {
  AnalyzedPerson({
    required this.id,
    required this.name,
    required this.mbti,
    required this.relationship,
    required this.chatCount,
    this.lastChatDate,
  });
  final String id;
  final String name;
  final String mbti;
  final String relationship;
  final int chatCount;
  final String? lastChatDate;
}

/// 채팅 메시지 데이터 모델
class ChatMessage {
  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });
  final String id;
  final String text;
  final bool isMe;
  final String time;
}

/// 분석된 사람 목록 화면
///
/// 분석했던 사람들의 목록을 보여주고, 각 사람과 가상 채팅을 시작할 수 있습니다.
/// main_screen.dart 스타일로 통일된 디자인이 적용됩니다.
class AnalyzedPeopleScreen extends StatefulWidget {
  const AnalyzedPeopleScreen({super.key});

  @override
  State<AnalyzedPeopleScreen> createState() => _AnalyzedPeopleScreenState();
}

class _AnalyzedPeopleScreenState extends State<AnalyzedPeopleScreen> {
  List<AnalyzedPerson> _analyzedPeople = [];

  @override
  void initState() {
    super.initState();
    _loadAnalyzedPeople();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0,
          vertical: 12,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildDashboardHeader(),
              const SizedBox(height: 24),
              _buildChartDemoSection(
                number: '1',
                title: '가상 채팅',
                description: '분석한 사람들과 가상 채팅을 통해 관계를 시뮬레이션해보세요',
                child: _buildPeopleList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ),
  );

  // 대시보드 헤더 - main_screen.dart 스타일로 통일
  Widget _buildDashboardHeader() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.9),
          AppColors.primary.withValues(alpha: 0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
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
                HugeIcons.strokeRoundedMessageMultiple01,
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
                        '가상 채팅',
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        HugeIcons.strokeRoundedMessage01,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '분석한 사람들과 가상 대화를 나누어 보세요',
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

  // 사람 목록
  Widget _buildPeopleList() {
    if (_analyzedPeople.isEmpty) {
      return _buildEmptyState();
    }

    return Column(children: _analyzedPeople.map(_buildPersonCard).toList());
  }

  // 사람 카드
  Widget _buildPersonCard(AnalyzedPerson person) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: InkWell(
      onTap: () => _startChatWith(person),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                person.name.isNotEmpty ? person.name[0] : '?',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 사람 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${person.mbti} • ${person.relationship}',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '마지막 대화: ${person.lastChatDate ?? "없음"}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // 채팅 횟수
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${person.chatCount}회',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    ),
  );

  // 빈 상태
  Widget _buildEmptyState() => Container(
    padding: const EdgeInsets.all(40),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            HugeIcons.strokeRoundedUserMultiple,
            color: AppColors.primary,
            size: 48,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '분석한 사람이 없습니다',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'AI 메시지 화면에서 먼저 사람을 분석해보세요',
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  // Chart Demo 스타일 섹션 빌더
  Widget _buildChartDemoSection({
    required String number,
    required String title,
    required String description,
    required Widget child,
  }) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 20 : 16),
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
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
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
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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

  // 데이터 로드 함수들
  void _loadAnalyzedPeople() {
    // 임시 데이터 - 실제로는 SharedPreferences나 데이터베이스에서 로드
    setState(() {
      _analyzedPeople = [
        AnalyzedPerson(
          id: '1',
          name: '김민수',
          mbti: 'ENFP',
          relationship: '친한 친구',
          chatCount: 15,
          lastChatDate: '2024-01-15',
        ),
        AnalyzedPerson(
          id: '2',
          name: '이지원',
          mbti: 'ISFJ',
          relationship: '직장 동료',
          chatCount: 8,
          lastChatDate: '2024-01-12',
        ),
        AnalyzedPerson(
          id: '3',
          name: '박서현',
          mbti: 'ENTJ',
          relationship: '대학 동기',
          chatCount: 22,
          lastChatDate: '2024-01-14',
        ),
      ];
    });
  }

  void _startChatWith(AnalyzedPerson person) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VirtualChatView(person: person)),
    );
  }
}
