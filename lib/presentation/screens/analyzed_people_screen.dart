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
  final int chatCount; // 분석에 사용된 대화 표본 개수
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

/// 분석 히스토리 화면
///
/// 이전에 분석했던 사람들의 결과를 다시 확인할 수 있는 화면입니다.
/// main_screen.dart와 통일된 모던한 디자인 스타일이 적용되었습니다.
///
/// 주요 특징:
/// - DashboardHeader 위젯 사용으로 헤더 통일성 확보
/// - 분석 결과 재확인 기능으로 변경 (가상 채팅 → 히스토리)
/// - 개인별 고유 그라데이션 색상으로 시각적 구분
/// - 분석 키워드와 점수 표시로 한눈에 파악 가능
/// - AppTextStyles 기반 통일된 텍스트 스타일
/// - 빈 상태 화면에 분석 안내 메시지 포함
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
              AppSpacing.gapV20,

              // DashboardHeader 사용으로 통일
              const DashboardHeader(
                title: '분석 히스토리',
                subtitle: '이전에 분석한 사람들의 결과를 다시 확인해보세요',
                icon: HugeIcons.strokeRoundedUserMultiple,
              ),

              AppSpacing.gapV24,

              SectionCard(
                number: '1',
                title: '분석 결과 히스토리',
                description: '분석한 사람들의 결과를 다시 보고 인사이트를 확인하세요',
                icon: HugeIcons.strokeRoundedUserMultiple,
                child: _buildPeopleList(),
              ),

              AppSpacing.gapV32,
            ],
          ),
        ),
      ),
    ),
  );

  // 사람 목록 - 대시보드 카드 스타일로 변경 (사용자 편의성 최우선)
  Widget _buildPeopleList() {
    if (_analyzedPeople.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: _analyzedPeople
          .map(
            (person) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildPersonDashboardCard(person),
            ),
          )
          .toList(),
    );
  }

  // 심플한 사람 카드 - 정보는 유지하되 시각적 복잡성 최소화
  Widget _buildPersonDashboardCard(AnalyzedPerson person) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: _getPersonGradient(person.id)[0].withValues(alpha: 0.15),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단: 심플한 프로필 헤더
        Row(
          children: [
            // 심플한 프로필 아바타
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getPersonGradient(person.id),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  person.name.isNotEmpty ? person.name[0] : '?',
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 기본 정보 - 심플하게
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름
                  Row(
                    children: [
                      Text(
                        person.name,
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 완료 상태를 작은 점으로 표시
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // MBTI와 관계 - 심플하게
                  Row(
                    children: [
                      Text(
                        person.mbti,
                        style: AppTextStyles.cardDescription.copyWith(
                          color: _getPersonGradient(person.id)[0],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '·',
                        style: AppTextStyles.cardDescription.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        person.relationship,
                        style: AppTextStyles.cardDescription.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 공유 버튼 - 우측 상단에 배치
            GestureDetector(
              onTap: () => _shareAnalysis(person),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedShare01,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 분석 키워드 - 심플하게
        Text(
          _getPreviewMessage(person),
          style: AppTextStyles.body1.copyWith(
            color: AppColors.primary,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 16),

        // 심플한 지표들
        Row(
          children: [
            _buildSimpleMetric(
              '표본 ${person.chatCount}개',
              _getPersonGradient(person.id)[0],
            ),
            const SizedBox(width: 16),
            _buildSimpleMetric(
              '점수 ${_getAnalysisScore(person)}점',
              _getScoreColor(person.chatCount),
            ),
            const Spacer(),
            // 결과 보기 버튼
            GestureDetector(
              onTap: () => _viewAnalysisResult(person),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getPersonGradient(person.id)[0],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '결과 보기',
                  style: AppTextStyles.cardDescription.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // 심플한 지표 위젯
  Widget _buildSimpleMetric(String text, Color color) => Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        text,
        style: AppTextStyles.cardDescription.copyWith(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
    ],
  );

  // 빈 상태 - 심플하고 깔끔하게
  Widget _buildEmptyState() => Container(
    padding: const EdgeInsets.all(40),
    child: Column(
      children: [
        // 심플한 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            HugeIcons.strokeRoundedUserMultiple,
            color: AppColors.primary,
            size: 40,
          ),
        ),

        const SizedBox(height: 24),

        // 제목
        Text(
          '아직 분석 기록이 없어요',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // 설명
        Text(
          'AI 메시지에서 대화를 분석하면\n결과를 여기서 확인할 수 있어요',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // 심플한 액션 버튼
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: PrimaryButton(
            text: '분석 시작하기',
            onPressed: () {
              ToastNotification.show(
                context: context,
                message: 'AI 메시지에서 대화를 분석해보세요!',
                type: ToastType.info,
              );
            },
          ),
        ),
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
          chatCount: 15, // 분석 표본 15개
          lastChatDate: '2024-01-15',
        ),
        AnalyzedPerson(
          id: '2',
          name: '이지원',
          mbti: 'ISFJ',
          relationship: '직장 동료',
          chatCount: 8, // 분석 표본 8개
          lastChatDate: '2024-01-12',
        ),
        AnalyzedPerson(
          id: '3',
          name: '박서현',
          mbti: 'ENTJ',
          relationship: '대학 동기',
          chatCount: 22, // 분석 표본 22개
          lastChatDate: '2024-01-14',
        ),
      ];
    });
  }

  void _viewAnalysisResult(AnalyzedPerson person) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VirtualChatView(person: person)),
    );
  }

  // 분석 결과 공유 기능
  void _shareAnalysis(AnalyzedPerson person) {
    ToastNotification.show(
      context: context,
      message: '${person.name}님의 분석 결과를 공유했습니다!',
      type: ToastType.success,
    );
  }

  // 사람별 고유한 그라데이션 색상 생성
  List<Color> _getPersonGradient(String personId) {
    final gradients = [
      [AppColors.primary, AppColors.accent],
      [AppColors.blue, AppColors.primary],
      [AppColors.green, AppColors.blue],
      [AppColors.accent, AppColors.pink],
      [AppColors.orange, AppColors.yellow],
      [AppColors.purple, AppColors.primary],
    ];

    final index = personId.hashCode.abs() % gradients.length;
    return gradients[index];
  }

  // 마지막 채팅 시간 포맷팅
  String _formatLastChatTime(String? lastChatDate) {
    if (lastChatDate == null) return '대화 없음';

    // 간단한 시간 포맷팅 (실제로는 DateTime 파싱 필요)
    final parts = lastChatDate.split('-');
    if (parts.length == 3) {
      final month = parts[1];
      final day = parts[2];
      return '$month/$day';
    }
    return lastChatDate;
  }

  // 분석 날짜 포맷팅
  String _formatAnalysisDate(String? lastChatDate) {
    if (lastChatDate == null) return '분석 날짜 없음';

    final parts = lastChatDate.split('-');
    if (parts.length == 3) {
      final year = parts[0];
      final month = parts[1];
      final day = parts[2];
      return '$year/$month/$day';
    }
    return lastChatDate;
  }

  // 분석 점수 계산 (표본 개수 기준)
  int _getAnalysisScore(AnalyzedPerson person) {
    // 분석 표본 개수를 기반으로 점수 계산
    // 표본이 많을수록 더 정확한 분석이 가능
    if (person.chatCount > 20) {
      return 95; // 충분한 표본으로 높은 신뢰도
    } else if (person.chatCount > 15) {
      return 85; // 양호한 표본 수
    } else if (person.chatCount > 10) {
      return 75; // 적당한 표본 수
    } else if (person.chatCount > 5) {
      return 60; // 기본적인 분석 가능
    } else {
      return 40; // 표본 부족으로 낮은 신뢰도
    }
  }

  // 표본 개수에 따른 색상 반환
  Color _getScoreColor(int sampleCount) {
    if (sampleCount > 20) {
      return AppColors.primary; // 매우 좋음
    } else if (sampleCount > 15) {
      return AppColors.green; // 좋음
    } else if (sampleCount > 10) {
      return AppColors.accent; // 보통
    } else if (sampleCount > 5) {
      return AppColors.blue; // 기본
    } else {
      return AppColors.textSecondary; // 부족
    }
  }

  // 분석 기반 해시태그/키워드 생성
  String _getPreviewMessage(AnalyzedPerson person) {
    // MBTI별 성향 키워드 매핑
    final mbtiKeywords = {
      'ENFP': ['#활발한_대화', '#창의적_아이디어', '#감정표현_풍부'],
      'INFP': ['#진솔한_대화', '#깊은_감정', '#예술적_감성'],
      'ENFJ': ['#따뜻한_관심', '#공감능력_높음', '#리더십_있음'],
      'INFJ': ['#신중한_대화', '#직관적_이해', '#미래지향적'],
      'ENTP': ['#토론_좋아함', '#새로운_아이디어', '#유머감각'],
      'INTP': ['#논리적_사고', '#분석적_성향', '#독창적_관점'],
      'ENTJ': ['#목표지향적', '#효율적_소통', '#리더십'],
      'INTJ': ['#체계적_사고', '#장기계획', '#독립적_성향'],
      'ESFP': ['#즐거운_분위기', '#현재_중심', '#사교적'],
      'ISFP': ['#섬세한_감정', '#예술적_취향', '#평화로운'],
      'ESFJ': ['#배려심_많음', '#사회적_관계', '#협조적'],
      'ISFJ': ['#신뢰할_수_있는', '#세심한_배려', '#안정적'],
      'ESTP': ['#활동적', '#현실적_접근', '#적응력_좋음'],
      'ISTP': ['#실용적_사고', '#문제해결', '#침착함'],
      'ESTJ': ['#체계적_관리', '#책임감_강함', '#현실적'],
      'ISTJ': ['#신중한_판단', '#전통적_가치', '#성실함'],
    };

    // 관계별 추가 키워드
    final relationshipKeywords = {
      '친한 친구': ['#편안한_관계', '#솔직한_대화'],
      '직장 동료': ['#전문적_소통', '#업무_관련'],
      '대학 동기': ['#추억_공유', '#학창시절'],
      '소개팅': ['#첫인상_중요', '#호감도_체크'],
      '썸': ['#미묘한_감정', '#관심_표현'],
      '연인': ['#애정표현', '#일상_공유'],
    };

    // 채팅 빈도별 키워드
    final frequencyKeywords = person.chatCount > 15
        ? ['#자주_대화', '#친밀도_높음']
        : person.chatCount > 5
        ? ['#적당한_소통', '#관심_있음']
        : ['#초기_단계', '#탐색_중'];

    // MBTI 키워드 가져오기
    final mbtiTags = mbtiKeywords[person.mbti] ?? ['#분석_중', '#성향_파악'];

    // 관계 키워드 가져오기
    final relationTags =
        relationshipKeywords[person.relationship] ?? ['#일반적_관계'];

    // 모든 키워드 합치기
    final allTags = [...mbtiTags, ...relationTags, ...frequencyKeywords];

    // 사람 ID를 기반으로 2-3개 키워드 선택
    final selectedTags = <String>[];
    final random = person.id.hashCode.abs();

    // 첫 번째 태그 (MBTI 기반)
    selectedTags.add(mbtiTags[random % mbtiTags.length]);

    // 두 번째 태그 (관계 기반)
    selectedTags.add(relationTags[(random ~/ 2) % relationTags.length]);

    // 세 번째 태그 (빈도 기반) - 50% 확률로 추가
    if (random % 2 == 0) {
      selectedTags.add(
        frequencyKeywords[(random ~/ 3) % frequencyKeywords.length],
      );
    }

    return selectedTags.join(' ');
  }
}
