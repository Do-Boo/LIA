// File: lib/presentation/screens/analyzed_people_screen.dart
// 2025.07.23 14:30:00 카카오톡 스타일로 완전 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 분석된 사람 데이터 모델
class AnalyzedPerson {
  AnalyzedPerson({
    required this.id,
    required this.name,
    required this.mbti,
    required this.relationship,
    required this.chatCount,
    required this.analysisScore,
    required this.analysisDate,
    required this.status,
    required this.keyInsights,
  });
  final String id;
  final String name;
  final String mbti;
  final String relationship;
  final int chatCount;
  final int analysisScore; // 분석 점수 (0-100)
  final String analysisDate;
  final String status; // 'completed', 'pending', 'failed'
  final List<String> keyInsights; // 주요 분석 키워드
}

/// 분석 히스토리 화면
///
/// 이전에 분석했던 사람들의 결과를 다시 확인할 수 있는 화면
/// 카카오톡 스타일의 심플하고 직관적인 구조로 구성
/// 상단 분석 요약 + 하단 히스토리 리스트 패턴 적용
class AnalyzedPeopleScreen extends StatefulWidget {
  const AnalyzedPeopleScreen({super.key});

  @override
  State<AnalyzedPeopleScreen> createState() => _AnalyzedPeopleScreenState();
}

class _AnalyzedPeopleScreenState extends State<AnalyzedPeopleScreen> {
  // 분석 히스토리 데이터
  final Map<String, dynamic> _historyData = {
    'totalAnalyses': 12,
    'completedAnalyses': 10,
    'averageScore': 78,
    'lastAnalysisDate': '2025.07.23',
  };

  List<AnalyzedPerson> _analyzedPeople = [];

  @override
  void initState() {
    super.initState();
    _loadAnalyzedPeople();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(child: _buildScreenWithScroll()),
  );

  // 상단 분석 요약 섹션 (카카오톡 스타일)
  Widget _buildAnalysisSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.transparent,
    child: Column(
      children: [
        // 분석 히스토리 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            HugeIcons.strokeRoundedClock01,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),

        // 히스토리 타이틀
        Text(
          '분석 히스토리',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // 전체 분석 현황
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '총 ${_historyData['totalAnalyses']}명 분석 • 평균 ${_historyData['averageScore']}점',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  // 통계 섹션 (간단한 수치 표시)
  Widget _buildStatsSection() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Row(
      children: [
        Expanded(
          child: _buildStatItem(
            '완료된 분석',
            '${_historyData['completedAnalyses']}개',
          ),
        ),
        Container(width: 1, height: 40, color: AppColors.border),
        Expanded(
          child: _buildStatItem('평균 점수', '${_historyData['averageScore']}점'),
        ),
      ],
    ),
  );

  Widget _buildStatItem(String label, String value) => Column(
    children: [
      Text(
        value,
        style: AppTextStyles.h3.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
    ],
  );

  // 히스토리 아이템 (카카오톡 스타일)
  Widget _buildHistoryItem(AnalyzedPerson person) => Container(
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 1),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: _getPersonGradient(person.id),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            person.name[0],
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            person.name,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getStatusColor(person.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _getStatusText(person.status),
              style: AppTextStyles.caption.copyWith(
                color: _getStatusColor(person.status),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            '${person.mbti} • ${person.relationship} • ${person.chatCount}개 메시지',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (person.keyInsights.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              children: person.keyInsights
                  .take(3)
                  .map(
                    (insight) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        insight,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${person.analysisScore}점',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            person.analysisDate,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
      onTap: () => _showAnalysisDetail(person),
    ),
  );

  // 빈 상태 화면
  Widget _buildEmptyState() => Container(
    padding: const EdgeInsets.all(40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: AppColors.textSecondary,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '아직 분석한 대화가 없어요',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '홈 화면에서 첫 번째 대화 분석을 시작해보세요!\n분석 결과는 여기서 다시 확인할 수 있어요.',
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SecondaryButton(
          onPressed: () => Navigator.of(context).pop(),
          text: '홈으로 가기',
          width: 120,
        ),
      ],
    ),
  );

  // 샘플 데이터 로드
  void _loadAnalyzedPeople() {
    setState(() {
      _analyzedPeople = [
        AnalyzedPerson(
          id: '1',
          name: '민준',
          mbti: 'ENFP',
          relationship: '썸',
          chatCount: 247,
          analysisScore: 85,
          analysisDate: '2025.07.23',
          status: 'completed',
          keyInsights: ['적극적', '유머러스', '관심많음'],
        ),
        AnalyzedPerson(
          id: '2',
          name: '지현',
          mbti: 'INFJ',
          relationship: '친구',
          chatCount: 156,
          analysisScore: 72,
          analysisDate: '2025.07.22',
          status: 'completed',
          keyInsights: ['신중함', '배려심', '감성적'],
        ),
        AnalyzedPerson(
          id: '3',
          name: '태영',
          mbti: 'ESTP',
          relationship: '선배',
          chatCount: 89,
          analysisScore: 91,
          analysisDate: '2025.07.21',
          status: 'completed',
          keyInsights: ['활발함', '솔직함', '리더십'],
        ),
        AnalyzedPerson(
          id: '4',
          name: '수연',
          mbti: 'ISFP',
          relationship: '동료',
          chatCount: 134,
          analysisScore: 68,
          analysisDate: '2025.07.20',
          status: 'pending',
          keyInsights: ['예술적', '섬세함'],
        ),
      ];
    });
  }

  // 개인별 그라데이션 색상 생성
  List<Color> _getPersonGradient(String id) {
    final gradients = [
      [AppColors.primary, AppColors.accent],
      [AppColors.green, AppColors.primary],
      [AppColors.accent, Colors.purple],
      [Colors.orange, AppColors.primary],
      [Colors.teal, AppColors.green],
    ];
    return gradients[id.hashCode % gradients.length];
  }

  // 상태별 색상
  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  // 상태별 텍스트
  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return '완료';
      case 'pending':
        return '분석중';
      case 'failed':
        return '실패';
      default:
        return '알 수 없음';
    }
  }

  // 분석 상세 보기
  void _showAnalysisDetail(AnalyzedPerson person) {
    ToastNotification.show(
      context: context,
      message: '${person.name}님의 상세 분석 결과를 확인합니다',
      type: ToastType.info,
    );
  }

  /// 스크롤 가능한 화면
  Widget _buildScreenWithScroll() => CustomScrollView(
    slivers: [
      // 상단 분석 요약 섹션
      SliverToBoxAdapter(child: _buildAnalysisSummarySection()),

      // 히스토리 리스트 섹션
      if (_analyzedPeople.isEmpty)
        SliverToBoxAdapter(child: _buildEmptyState())
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildHistoryItem(_analyzedPeople[index]),
            childCount: _analyzedPeople.length,
          ),
        ),

      // 하단 여백
      const SliverToBoxAdapter(child: SizedBox(height: 40)),
    ],
  );
}
