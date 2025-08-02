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
      child: CustomScrollView(
        slivers: [
          // 상단 프로필 영역
          SliverToBoxAdapter(child: _buildProfileSection()),

          // 통계 숫자 영역
          SliverToBoxAdapter(child: _buildStatsSection()),

          // 메뉴 리스트 영역
          SliverToBoxAdapter(child: _buildMenuContent()),
        ],
      ),
    ),
  );

  // 상단 프로필 섹션 (카카오톡 스타일)
  Widget _buildProfileSection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.white.withValues(alpha: 0),
    child: Column(
      children: [
        // 프로필 이미지
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColors.charcoal.withValues(alpha: 0.05),
          ),
          child: Center(
            child: Text(
              _userInfo['name'][0],
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 닉네임
        Text(
          _userInfo['name'],
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // 상태 메시지
        SecondaryButton(
          onPressed: () {},
          text: '내 정보 수정',
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ],
    ),
  );

  // 통계 숫자 섹션
  Widget _buildStatsSection() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Row(
      children: [
        Expanded(
          child: _buildStatItem(
            '친구 목록',
            '${_userInfo['analysisCount']} 개',
            () => _showToast('친구 목록 기능은 곧 추가될 예정이에요!'),
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: AppColors.textSecondary.withValues(alpha: 0.2),
        ),
        Expanded(
          child: _buildStatItem(
            '보유 코인',
            '${_userInfo['totalMessages']} 🪙',
            () => _showToast('코인 상점 기능은 곧 추가될 예정이에요!'),
          ),
        ),
      ],
    ),
  );

  // 통계 아이템
  Widget _buildStatItem(String title, String value, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(
                HugeIcons.strokeRoundedArrowRight01,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      );

  /// 메뉴 콘텐츠 (스크롤을 위해 ListView에서 Column으로 변경)
  Widget _buildMenuContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      children: [
        MenuItemWidget.simple(
          icon: HugeIcons.strokeRoundedMegaphone01,
          title: '공지사항',
          onTap: () => _showToast('공지사항 페이지로 이동합니다!'),
        ),
        MenuItemWidget.simple(
          icon: HugeIcons.strokeRoundedCalendar03,
          title: '이벤트',
          onTap: () => _showToast('이벤트 페이지로 이동합니다!'),
        ),
        MenuItemWidget.simple(
          icon: HugeIcons.strokeRoundedHelpCircle,
          title: '자주 묻는 질문',
          onTap: () => _showToast('FAQ 페이지로 이동합니다!'),
        ),
        MenuItemWidget.simple(
          icon: HugeIcons.strokeRoundedCustomerSupport,
          title: '문의하기',
          onTap: () => _showToast('고객센터로 연결됩니다!'),
        ),
        const SizedBox(height: 16),
        MenuItemWidget.simple(
          icon: HugeIcons.strokeRoundedSettings01,
          title: '설정',
          onTap: _openSettings,
        ),

        // 하단 여백 추가
        const SizedBox(height: 40),
      ],
    ),
  );

  // 토스트 메시지 헬퍼
  void _showToast(String message) {
    ToastNotification.show(
      context: context,
      message: message,
      type: ToastType.info,
    );
  }

  // 액션 메서드들
  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }
}
