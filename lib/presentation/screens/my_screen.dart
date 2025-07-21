// File: lib/presentation/screens/my_screen.dart
// 2025.07.18 13:27:31 MY 화면 main_screen.dart 스타일로 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// MY 화면
///
/// 프로필 설정, 개인 정보 관리, 앱 설정을 제공하는 화면
/// 18세 서현 페르소나에 맞는 개인화된 설정 및 계정 관리
/// main_screen.dart 스타일로 통일된 디자인 적용
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // 설정 상태 변수들
  bool _notificationEnabled = true;
  bool _pushNotificationEnabled = true;
  bool _emailNotificationEnabled = false;
  bool _darkModeEnabled = false;
  bool _analyticsEnabled = true;

  // 사용자 정보
  final Map<String, dynamic> _userInfo = {
    'name': '서현',
    'email': 'seohyun@example.com',
    'joinDate': '2025.07.01',
    'profileImage': null,
    'mbti': 'ENFP',
    'interests': ['카페', '영화', '여행', '음악'],
    'totalMessages': 127,
    'successRate': 89.5,
    'premium': false,
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

              // 대시보드 헤더
              const DashboardHeader(
                title: '서현이의 프로필',
                subtitle: '나만의 개성을 표현하고 설정을 관리해보세요',
                icon: HugeIcons.strokeRoundedUserCircle,
              ),

              AppSpacing.gapV24,

              // 1. 프로필 정보
              SectionCard(
                number: '1',
                title: '프로필 정보',
                description: '개인 정보와 관심사를 관리하세요',
                child: _buildProfileContent(),
              ),

              AppSpacing.gapV24,

              // 2. 환경설정
              SectionCard(
                number: '2',
                title: '환경설정',
                description: '앱 사용 환경을 개인화하세요',
                child: _buildPreferencesContent(),
              ),

              AppSpacing.gapV24,

              // 3. 알림 설정
              SectionCard(
                number: '3',
                title: '알림 설정',
                description: '원하는 알림만 받도록 설정하세요',
                child: _buildNotificationContent(),
              ),

              AppSpacing.gapV24,

              // 4. 고객 지원 & 계정
              SectionCard(
                number: '4',
                title: '고객 지원 & 계정',
                description: '도움말, 문의하기, 계정 관리',
                child: _buildSupportAndAccountContent(),
              ),

              AppSpacing.gapV40,
            ],
          ),
        ),
      ),
    ),
  );

  // 프로필 컨텐츠 - 카드 그룹 방식으로 개선
  Widget _buildProfileContent() => Column(
    children: [
      // 메인 프로필 카드
      Container(
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
            // 프로필 이미지
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _userInfo['name'][0],
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _userInfo['name'],
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _userInfo['mbti'],
                style: AppTextStyles.cardTitle.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildInterestsChips(),
          ],
        ),
      ),

      const SizedBox(height: 16),

      // 프로필 액션 버튼들
      Row(
        children: [
          Expanded(
            child: _buildActionCard(
              '전체 프로필',
              HugeIcons.strokeRoundedUser,
              AppColors.blue,
              _viewFullProfile,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              '프로필 수정',
              HugeIcons.strokeRoundedEdit01,
              AppColors.green,
              _editFullProfile,
            ),
          ),
        ],
      ),
    ],
  );

  // 관심사 칩들
  Widget _buildInterestsChips() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _userInfo['interests']
        .map<Widget>(
          (interest) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  HugeIcons.strokeRoundedHeartAdd,
                  size: 12,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  interest,
                  style: AppTextStyles.cardDescription.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );

  // 환경설정 컨텐츠 - 그룹 카드 방식으로 개선
  Widget _buildPreferencesContent() => Column(
    children: [
      _buildSettingGroup('앱 설정', AppColors.purple, [
        _buildModernToggleItem(
          '다크 모드',
          '어두운 테마로 변경',
          HugeIcons.strokeRoundedMoon02,
          _darkModeEnabled,
          (value) => setState(() => _darkModeEnabled = value),
          AppColors.purple,
        ),
        _buildModernToggleItem(
          '분석 데이터 수집',
          '서비스 개선을 위한 데이터 수집',
          HugeIcons.strokeRoundedAnalytics01,
          _analyticsEnabled,
          (value) => setState(() => _analyticsEnabled = value),
          AppColors.purple,
        ),
      ]),
      const SizedBox(height: 16),
      _buildSettingGroup('기타 설정', AppColors.orange, [
        _buildModernActionItem(
          '언어 설정',
          '한국어',
          HugeIcons.strokeRoundedTranslate,
          _changeLanguage,
          AppColors.orange,
        ),
        _buildModernActionItem(
          '캐시 삭제',
          '앱 용량 최적화',
          HugeIcons.strokeRoundedDelete01,
          _clearCache,
          AppColors.orange,
        ),
      ]),
    ],
  );

  // 알림 설정 컨텐츠 - 그룹 카드 방식으로 개선
  Widget _buildNotificationContent() =>
      _buildSettingGroup('알림 설정', AppColors.green, [
        _buildModernToggleItem(
          '전체 알림',
          '모든 알림 받기',
          HugeIcons.strokeRoundedNotification01,
          _notificationEnabled,
          (value) => setState(() => _notificationEnabled = value),
          AppColors.green,
        ),
        _buildModernToggleItem(
          '푸시 알림',
          '실시간 알림 받기',
          HugeIcons.strokeRoundedNotification01,
          _pushNotificationEnabled,
          (value) => setState(() => _pushNotificationEnabled = value),
          AppColors.green,
        ),
        _buildModernToggleItem(
          '이메일 알림',
          '중요한 소식을 이메일로',
          HugeIcons.strokeRoundedMail01,
          _emailNotificationEnabled,
          (value) => setState(() => _emailNotificationEnabled = value),
          AppColors.green,
        ),
      ]);

  // 고객 지원 & 계정 컨텐츠 - 카테고리별 그룹으로 개선
  Widget _buildSupportAndAccountContent() => Column(
    children: [
      // 고객 지원 그룹
      _buildSettingGroup('고객 지원', AppColors.blue, [
        _buildModernActionItem(
          '도움말',
          '사용법 및 FAQ',
          HugeIcons.strokeRoundedHelpCircle,
          _showHelp,
          AppColors.blue,
        ),
        _buildModernActionItem(
          '문의하기',
          '1:1 문의 및 피드백',
          HugeIcons.strokeRoundedCustomerSupport,
          _contactSupport,
          AppColors.blue,
        ),
        _buildModernActionItem(
          '앱 평가',
          '앱스토어에서 평가하기',
          HugeIcons.strokeRoundedStar,
          _rateApp,
          AppColors.blue,
        ),
        _buildModernActionItem(
          '공지사항',
          '새로운 소식 확인',
          HugeIcons.strokeRoundedBulb,
          _showNotices,
          AppColors.blue,
        ),
      ]),

      const SizedBox(height: 16),

      // 프리미엄 & 정책 그룹
      _buildSettingGroup('프리미엄 & 정책', AppColors.accent, [
        _buildModernActionItem(
          '프리미엄 업그레이드',
          '더 많은 기능 이용하기',
          HugeIcons.strokeRoundedCrown,
          _upgradePremium,
          AppColors.accent,
        ),
        _buildModernActionItem(
          '개인정보 처리방침',
          '개인정보 보호 정책',
          HugeIcons.strokeRoundedSecurity,
          _showPrivacyPolicy,
          AppColors.accent,
        ),
        _buildModernActionItem(
          '이용약관',
          '서비스 이용 약관',
          Icons.description,
          _showTerms,
          AppColors.accent,
        ),
      ]),

      const SizedBox(height: 20),

      // 계정 관리 액션 버튼
      Row(
        children: [
          Expanded(
            child: _buildDangerActionCard(
              '로그아웃',
              HugeIcons.strokeRoundedLogout01,
              AppColors.orange,
              _logout,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDangerActionCard(
              '계정 삭제',
              HugeIcons.strokeRoundedUserRemove01,
              AppColors.pink,
              _deleteAccount,
            ),
          ),
        ],
      ),
    ],
  );

  // 위험한 액션 카드 (로그아웃, 계정 삭제)
  Widget _buildDangerActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
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

  // 프로필 이미지 편집
  void _editProfileImage() {
    ToastNotification.show(
      context: context,
      message: '프로필 이미지 변경 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 프로필 편집
  void _editProfile(String field) {
    ToastNotification.show(
      context: context,
      message: '$field 수정 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 전체 프로필 보기
  void _viewFullProfile() {
    ToastNotification.show(
      context: context,
      message: '전체 프로필 보기 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 전체 프로필 편집
  void _editFullProfile() {
    ToastNotification.show(
      context: context,
      message: '프로필 수정 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 설정 열기
  void _openSettings() {
    ToastNotification.show(
      context: context,
      message: '고급 설정 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 언어 변경
  void _changeLanguage() {
    ToastNotification.show(
      context: context,
      message: '언어 설정 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 캐시 삭제
  void _clearCache() {
    ToastNotification.show(
      context: context,
      message: '캐시가 삭제되었어요!',
      type: ToastType.success,
    );
  }

  // 도움말 보기
  void _showHelp() {
    ToastNotification.show(
      context: context,
      message: '도움말 페이지로 이동합니다!',
      type: ToastType.info,
    );
  }

  // 고객 지원 문의
  void _contactSupport() {
    ToastNotification.show(
      context: context,
      message: '고객 지원 문의 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 앱 평가
  void _rateApp() {
    ToastNotification.show(
      context: context,
      message: '앱스토어로 이동합니다!',
      type: ToastType.info,
    );
  }

  // 공지사항 보기
  void _showNotices() {
    ToastNotification.show(
      context: context,
      message: '공지사항 페이지로 이동합니다!',
      type: ToastType.info,
    );
  }

  // 프리미엄 업그레이드
  void _upgradePremium() {
    ToastNotification.show(
      context: context,
      message: '프리미엄 업그레이드 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 개인정보 처리방침
  void _showPrivacyPolicy() {
    ToastNotification.show(
      context: context,
      message: '개인정보 처리방침 페이지로 이동합니다!',
      type: ToastType.info,
    );
  }

  // 이용약관
  void _showTerms() {
    ToastNotification.show(
      context: context,
      message: '이용약관 페이지로 이동합니다!',
      type: ToastType.info,
    );
  }

  // 로그아웃
  void _logout() {
    ToastNotification.show(
      context: context,
      message: '로그아웃 되었습니다!',
      type: ToastType.success,
    );
  }

  // 계정 삭제
  void _deleteAccount() {
    ToastNotification.show(
      context: context,
      message: '계정 삭제 기능은 곧 추가될 예정이에요!',
      type: ToastType.info,
    );
  }

  // 설정 그룹 카드
  Widget _buildSettingGroup(String title, Color color, List<Widget> items) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    HugeIcons.strokeRoundedSettings01,
                    size: 18,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: color,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: item,
              ),
            ),
          ],
        ),
      );

  // 모던한 토글 아이템
  Widget _buildModernToggleItem(
    String title,
    String description,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    Color color,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.1)),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              const SizedBox(height: 2),
              Text(description, style: AppTextStyles.cardDescription),
            ],
          ),
        ),
        CustomToggleSwitch(value: value, onChanged: onChanged),
      ],
    ),
  );

  // 모던한 액션 아이템
  Widget _buildModernActionItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.cardDescription),
              ],
            ),
          ),
          Icon(
            HugeIcons.strokeRoundedArrowRight01,
            color: color.withValues(alpha: 0.7),
            size: 18,
          ),
        ],
      ),
    ),
  );

  // 액션 카드
  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
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
}
