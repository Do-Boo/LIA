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

  // 프로필 컨텐츠
  Widget _buildProfileContent() => Column(
    children: [
      _buildProfileItem(
        '이름',
        _userInfo['name'],
        HugeIcons.strokeRoundedUser,
        () => _editProfile('name'),
      ),
      const SizedBox(height: 12),
      _buildProfileItem(
        'MBTI',
        _userInfo['mbti'],
        HugeIcons.strokeRoundedBrain,
        () => _editProfile('mbti'),
      ),
      const SizedBox(height: 12),
      _buildInterestsItem(),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: SecondaryButton(onPressed: _viewFullProfile, text: '전체 프로필'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(onPressed: _editFullProfile, text: '프로필 수정'),
          ),
        ],
      ),
    ],
  );

  // 환경설정 컨텐츠
  Widget _buildPreferencesContent() => Column(
    children: [
      _buildToggleItem(
        '다크 모드',
        '어두운 테마로 변경',
        HugeIcons.strokeRoundedMoon02,
        _darkModeEnabled,
        (value) => setState(() => _darkModeEnabled = value),
      ),
      const SizedBox(height: 12),
      _buildToggleItem(
        '분석 데이터 수집',
        '서비스 개선을 위한 데이터 수집',
        HugeIcons.strokeRoundedAnalytics01,
        _analyticsEnabled,
        (value) => setState(() => _analyticsEnabled = value),
      ),
      const SizedBox(height: 12),
      _buildActionItem(
        '언어 설정',
        '한국어',
        HugeIcons.strokeRoundedTranslate,
        _changeLanguage,
      ),
      const SizedBox(height: 12),
      _buildActionItem(
        '캐시 삭제',
        '앱 용량 최적화',
        HugeIcons.strokeRoundedDelete01,
        _clearCache,
      ),
    ],
  );

  // 알림 설정 컨텐츠
  Widget _buildNotificationContent() => Column(
    children: [
      _buildToggleItem(
        '전체 알림',
        '모든 알림 받기',
        HugeIcons.strokeRoundedNotification01,
        _notificationEnabled,
        (value) => setState(() => _notificationEnabled = value),
      ),
      const SizedBox(height: 12),
      _buildToggleItem(
        '푸시 알림',
        '실시간 알림 받기',
        HugeIcons.strokeRoundedNotification01,
        _pushNotificationEnabled,
        (value) => setState(() => _pushNotificationEnabled = value),
      ),
      const SizedBox(height: 12),
      _buildToggleItem(
        '이메일 알림',
        '중요한 소식을 이메일로',
        HugeIcons.strokeRoundedMail01,
        _emailNotificationEnabled,
        (value) => setState(() => _emailNotificationEnabled = value),
      ),
    ],
  );

  // 고객 지원 & 계정 컨텐츠
  Widget _buildSupportAndAccountContent() => Column(
    children: [
      // 고객 지원 섹션
      _buildActionItem(
        '도움말',
        '사용법 및 FAQ',
        HugeIcons.strokeRoundedHelpCircle,
        _showHelp,
      ),
      const SizedBox(height: 12),
      _buildActionItem(
        '문의하기',
        '1:1 문의 및 피드백',
        HugeIcons.strokeRoundedCustomerSupport,
        _contactSupport,
      ),
      const SizedBox(height: 12),
      _buildActionItem(
        '앱 평가',
        '앱스토어에서 평가하기',
        HugeIcons.strokeRoundedStar,
        _rateApp,
      ),
      const SizedBox(height: 12),
      _buildActionItem(
        '공지사항',
        '새로운 소식 확인',
        HugeIcons.strokeRoundedBulb,
        _showNotices,
      ),
      const SizedBox(height: 16),

      // 구분선
      Container(
        height: 1,
        color: AppColors.border,
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      const SizedBox(height: 16),

      // 계정 관리 섹션
      _buildActionItem(
        '프리미엄 업그레이드',
        '더 많은 기능 이용하기',
        HugeIcons.strokeRoundedCrown,
        _upgradePremium,
      ),
      const SizedBox(height: 12),
      _buildActionItem(
        '개인정보 처리방침',
        '개인정보 보호 정책',
        HugeIcons.strokeRoundedSecurity,
        _showPrivacyPolicy,
      ),
      const SizedBox(height: 12),
      _buildActionItem('이용약관', '서비스 이용 약관', Icons.description, _showTerms),
      const SizedBox(height: 16),

      // 계정 액션 버튼
      Row(
        children: [
          Expanded(
            child: SecondaryButton(onPressed: _logout, text: '로그아웃'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SecondaryButton(onPressed: _deleteAccount, text: '계정 삭제'),
          ),
        ],
      ),
    ],
  );

  // 프로필 아이템
  Widget _buildProfileItem(
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.helper.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.secondaryText,
            size: 16,
          ),
        ],
      ),
    ),
  );

  // 관심사 아이템
  Widget _buildInterestsItem() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedHeartAdd,
                color: AppColors.accent,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '관심사',
                style: AppTextStyles.helper.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _editProfile('interests'),
              child: const Icon(
                HugeIcons.strokeRoundedEdit01,
                color: AppColors.secondaryText,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _userInfo['interests']
              .map<Widget>(
                (interest) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    interest,
                    style: AppTextStyles.helper.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );

  // 토글 아이템
  Widget _buildToggleItem(
    String title,
    String description,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.green, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyles.helper.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        CustomToggleSwitch(value: value, onChanged: onChanged),
      ],
    ),
  );

  // 액션 아이템
  Widget _buildActionItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.helper.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.secondaryText,
            size: 16,
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
}
