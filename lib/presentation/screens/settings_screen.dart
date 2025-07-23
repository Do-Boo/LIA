// File: lib/presentation/screens/settings_screen.dart
// 2025.07.21 17:02:57 설정 전용 화면 생성 - MY 화면에서 분리

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 설정 화면
///
/// 앱의 모든 설정 기능을 체계적으로 관리하는 전용 화면
/// MY 화면에서 분리하여 각 기능의 목적을 명확히 구분
/// 심플하고 직관적인 인터페이스로 사용자 편의성 최우선
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 설정 상태 변수들
  bool _notificationEnabled = true;
  bool _pushNotificationEnabled = true;
  bool _emailNotificationEnabled = false;
  bool _darkModeEnabled = false;
  bool _analyticsEnabled = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          HugeIcons.strokeRoundedArrowLeft01,
          color: AppColors.textPrimary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '설정',
        style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
      ),
      centerTitle: true,
    ),
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
              AppSpacing.gapV24,

              // 1. 알림 설정
              SectionCard(
                number: '1',
                title: '알림 설정',
                description: '원하는 알림만 받도록 설정하세요',
                icon: HugeIcons.strokeRoundedNotification01,
                iconColor: AppColors.primary,
                child: Column(
                  children: [
                    _buildToggleItem(
                      '전체 알림',
                      '모든 알림을 받을지 설정합니다',
                      HugeIcons.strokeRoundedNotification01,
                      _notificationEnabled,
                      (value) => setState(() => _notificationEnabled = value),
                    ),
                    _buildToggleItem(
                      '푸시 알림',
                      '앱에서 푸시 알림을 받을지 설정합니다',
                      HugeIcons.strokeRoundedNotification01,
                      _pushNotificationEnabled,
                      (value) =>
                          setState(() => _pushNotificationEnabled = value),
                    ),
                    _buildToggleItem(
                      '이메일 알림',
                      '이메일로 중요한 소식을 받을지 설정합니다',
                      HugeIcons.strokeRoundedMail01,
                      _emailNotificationEnabled,
                      (value) =>
                          setState(() => _emailNotificationEnabled = value),
                    ),
                  ],
                ),
              ),

              AppSpacing.gapV24,

              // 2. 앱 설정
              SectionCard(
                number: '2',
                title: '앱 설정',
                description: '앱 사용 환경을 개인화하세요',
                icon: HugeIcons.strokeRoundedSettings01,
                iconColor: AppColors.primary,
                child: Column(
                  children: [
                    _buildToggleItem(
                      '다크 모드',
                      '어두운 테마를 사용합니다',
                      HugeIcons.strokeRoundedMoon01,
                      _darkModeEnabled,
                      (value) => setState(() => _darkModeEnabled = value),
                    ),
                    _buildToggleItem(
                      '분석 데이터 수집',
                      '앱 개선을 위한 익명 데이터를 수집합니다',
                      HugeIcons.strokeRoundedAnalytics01,
                      _analyticsEnabled,
                      (value) => setState(() => _analyticsEnabled = value),
                    ),
                    _buildActionItem(
                      '언어 설정',
                      '앱에서 사용할 언어를 선택하세요',
                      HugeIcons.strokeRoundedLanguageCircle,
                      _changeLanguage,
                    ),
                    _buildActionItem(
                      '캐시 삭제',
                      '저장된 임시 파일을 삭제하여 용량을 확보하세요',
                      HugeIcons.strokeRoundedDelete01,
                      _clearCache,
                    ),
                  ],
                ),
              ),

              AppSpacing.gapV24,

              // 3. 고객 지원
              SectionCard(
                number: '3',
                title: '고객 지원',
                description: '도움이 필요하시면 언제든 연락하세요',
                icon: HugeIcons.strokeRoundedCustomerSupport,
                iconColor: AppColors.primary,
                child: Column(
                  children: [
                    _buildActionItem(
                      '도움말',
                      'LIA 사용법과 자주 묻는 질문을 확인하세요',
                      HugeIcons.strokeRoundedHelpCircle,
                      _showHelp,
                    ),
                    _buildActionItem(
                      '문의하기',
                      '궁금한 점이나 문제가 있으면 언제든 연락하세요',
                      HugeIcons.strokeRoundedMail01,
                      _contactSupport,
                    ),
                    _buildActionItem(
                      '앱 평가하기',
                      'LIA가 마음에 드신다면 평가를 남겨주세요',
                      HugeIcons.strokeRoundedStar,
                      _rateApp,
                    ),
                    _buildActionItem(
                      '공지사항',
                      '새로운 소식과 업데이트를 확인하세요',
                      HugeIcons.strokeRoundedNews,
                      _showNotices,
                    ),
                  ],
                ),
              ),

              AppSpacing.gapV24,

              // 4. 계정 및 약관
              SectionCard(
                number: '4',
                title: '계정 및 약관',
                description: '계정 관리와 약관을 확인하세요',
                icon: HugeIcons.strokeRoundedUserAccount,
                iconColor: AppColors.primary,
                child: Column(
                  children: [
                    _buildActionItem(
                      'LIA 프리미엄',
                      '더 많은 기능을 이용해보세요',
                      HugeIcons.strokeRoundedCrown,
                      _upgradePremium,
                    ),
                    _buildActionItem(
                      '개인정보 처리방침',
                      '개인정보 보호 정책을 확인하세요',
                      HugeIcons.strokeRoundedShield01,
                      _showPrivacyPolicy,
                    ),
                    _buildActionItem(
                      '서비스 이용 약관',
                      '서비스 이용 약관을 확인하세요',
                      HugeIcons.strokeRoundedFile01,
                      _showTerms,
                    ),
                  ],
                ),
              ),

              AppSpacing.gapV24,

              // 5. 위험 구역
              SectionCard(
                number: '5',
                title: '위험 구역',
                description: '신중하게 선택해주세요',
                icon: HugeIcons.strokeRoundedAlert01,
                iconColor: AppColors.primary,
                child: Column(
                  children: [
                    _buildDangerActionItem(
                      '로그아웃',
                      '현재 계정에서 로그아웃합니다',
                      HugeIcons.strokeRoundedLogout01,
                      AppColors.orange,
                      _logout,
                    ),
                    _buildDangerActionItem(
                      '계정 삭제',
                      '모든 데이터가 영구적으로 삭제됩니다',
                      HugeIcons.strokeRoundedUserRemove01,
                      AppColors.pink,
                      _deleteAccount,
                    ),
                  ],
                ),
              ),

              AppSpacing.gapV40,
            ],
          ),
        ),
      ),
    ),
  );

  // 설정 그룹 위젯
  Widget _buildSettingsGroup(
    String title,
    String description,
    IconData groupIcon,
    Color color,
    List<Widget> items,
  ) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.1)),
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
        // 그룹 헤더
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(groupIcon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: AppTextStyles.cardDescription.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 설정 아이템들
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: item,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ),
  );

  // 토글 설정 아이템
  Widget _buildToggleItem(
    String title,
    String description,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
    child: Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
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

  // 액션 설정 아이템
  Widget _buildActionItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
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
          const Icon(
            HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    ),
  );

  // 위험 액션 아이템 (로그아웃, 계정 삭제용)
  Widget _buildDangerActionItem(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.cardDescription.copyWith(
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            HugeIcons.strokeRoundedArrowRight01,
            color: color.withValues(alpha: 0.7),
            size: 16,
          ),
        ],
      ),
    ),
  );

  // 위험 구역 (계정 삭제, 로그아웃)
  Widget _buildDangerZone() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.pink.withValues(alpha: 0.2)),
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
        // 위험 구역 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.pink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedAlert01,
                color: AppColors.pink,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '계정 관리',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.pink,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 위험한 액션들
        Row(
          children: [
            Expanded(
              child: _buildDangerButton(
                '로그아웃',
                HugeIcons.strokeRoundedLogout01,
                AppColors.orange,
                _logout,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDangerButton(
                '계정 삭제',
                HugeIcons.strokeRoundedUserRemove01,
                AppColors.pink,
                _deleteAccount,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // 위험한 액션 버튼
  Widget _buildDangerButton(
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
        border: Border.all(color: color.withValues(alpha: 0.3)),
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

  // === 액션 메서드들 ===

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
    Navigator.pop(context); // 설정 화면 닫기
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
