// File: lib/presentation/screens/my_screen.dart
// 2025.07.18 13:27:31 MY 화면 main_screen.dart 스타일로 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';
import 'settings_screen.dart'; // Added import for SettingsScreen

/// MY 화면
///
/// 개인 프로필과 사용 통계를 간단하게 확인하는 화면
/// 18세 서현 페르소나에 맞는 심플하고 깔끔한 개인 공간
/// 복잡한 설정 기능은 별도 설정 화면으로 분리
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // 사용자 정보
  final Map<String, dynamic> _userInfo = {
    'name': '서현',
    'email': 'seohyun@example.com',
    'joinDate': '2024.03.15',
    'profileImage': null,
    'mbti': 'ENFP',
    'interests': ['카페', '영화', '여행', '음악'],
    'totalMessages': 247,
    'successRate': 84,
    'analysisCount': 12,
    'level': 'Pro',
  };

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

              // 심플한 헤더
              const DashboardHeader(
                title: '나의 프로필',
                subtitle: '개인 정보와 사용 통계를 확인해보세요',
                icon: HugeIcons.strokeRoundedUserCircle,
              ),

              AppSpacing.gapV24,

              // 메인 프로필 카드
              _buildProfileCard(),

              AppSpacing.gapV20,

              // 사용 통계 카드
              _buildStatsCard(),

              AppSpacing.gapV20,

              // 빠른 액션 버튼들
              _buildQuickActions(),

              AppSpacing.gapV40,
            ],
          ),
        ),
      ),
    ),
  );

  // 심플한 프로필 카드
  Widget _buildProfileCard() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // 프로필 아바타
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _userInfo['name'][0],
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 이름
        Text(
          _userInfo['name'],
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        // 이메일
        Text(
          _userInfo['email'],
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),

        const SizedBox(height: 16),

        // MBTI와 레벨
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                _userInfo['mbti'],
                style: AppTextStyles.cardTitle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    HugeIcons.strokeRoundedStar,
                    size: 16,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_userInfo['level']} 사용자',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 관심사 태그들
        _buildSimpleInterests(),
      ],
    ),
  );

  // 심플한 관심사 표시
  Widget _buildSimpleInterests() => Wrap(
    spacing: 8,
    runSpacing: 8,
    alignment: WrapAlignment.center,
    children: _userInfo['interests']
        .map<Widget>(
          (interest) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '#$interest',
              style: AppTextStyles.cardDescription.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
        .toList(),
  );

  // 사용 통계 카드
  Widget _buildStatsCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.green.withValues(alpha: 0.1)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        // 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedAnalytics01,
                size: 20,
                color: AppColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '나의 LIA 사용 통계',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 지표들
        Row(
          children: [
            Expanded(
              child: _buildSimpleMetric(
                '총 메시지',
                '${_userInfo['totalMessages']}개',
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSimpleMetric(
                '성공률',
                '${_userInfo['successRate']}%',
                AppColors.green,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildSimpleMetric(
                '분석 횟수',
                '${_userInfo['analysisCount']}회',
                AppColors.accent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSimpleMetric(
                '가입일',
                _userInfo['joinDate'],
                AppColors.blue,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // 심플한 지표 위젯
  Widget _buildSimpleMetric(String title, String value, Color color) => Column(
    children: [
      Text(
        value,
        style: AppTextStyles.h2.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: AppTextStyles.cardDescription.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    ],
  );

  // 빠른 액션 버튼들
  Widget _buildQuickActions() => Column(
    children: [
      // 상단 액션들
      Row(
        children: [
          Expanded(
            child: _buildActionButton(
              '프로필 수정',
              HugeIcons.strokeRoundedEdit01,
              AppColors.primary,
              _editProfile,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              '설정',
              HugeIcons.strokeRoundedSettings01,
              AppColors.blue,
              _openSettings,
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      // 하단 액션들
      Row(
        children: [
          Expanded(
            child: _buildActionButton(
              '도움말',
              HugeIcons.strokeRoundedHelpCircle,
              AppColors.green,
              _showHelp,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              '로그아웃',
              HugeIcons.strokeRoundedLogout01,
              AppColors.orange,
              _logout,
            ),
          ),
        ],
      ),
    ],
  );

  // 액션 버튼
  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
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
            title,
            style: AppTextStyles.cardDescription.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  // 액션 메서드들
  void _editProfile() {
    ToastNotification.show(
      context: context,
      message: '프로필 수정 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _showHelp() {
    ToastNotification.show(
      context: context,
      message: '도움말 페이지로 이동합니다!',
      type: ToastType.info,
    );
  }

  void _logout() {
    ToastNotification.show(
      context: context,
      message: '로그아웃 되었습니다!',
      type: ToastType.success,
    );
  }
}
