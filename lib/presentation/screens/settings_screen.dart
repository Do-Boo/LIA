// File: lib/presentation/screens/settings_screen.dart
// 2025.07.21 17:02:57 설정 전용 화면 생성 - MY 화면에서 분리

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 설정 화면
///
/// 앱의 모든 설정 기능을 카카오톡 스타일로 관리하는 화면
/// MY 화면과 동일한 심플하고 직관적인 인터페이스
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
        style: AppTextStyles.h3.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
        ),
      ),
      centerTitle: true,
    ),
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          // 상단 설정 요약 영역
          SliverToBoxAdapter(child: _buildSettingSummarySection()),

          // 메뉴 리스트 영역
          SliverToBoxAdapter(child: _buildSettingsMenuContent()),
        ],
      ),
    ),
  );

  // 상단 설정 요약 섹션
  Widget _buildSettingSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.transparent,
    child: Column(
      children: [
        // 설정 아이콘
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(
            HugeIcons.strokeRoundedSettings01,
            size: 28,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),

        // 설정 제목
        Text(
          '앱 설정',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // 설정 상태 요약
        Text(
          '알림 ${_notificationEnabled ? "켜짐" : "꺼짐"} • 다크모드 ${_darkModeEnabled ? "켜짐" : "꺼짐"}',
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
        ),
      ],
    ),
  );

  /// 설정 메뉴 콘텐츠 (스크롤을 위해 ListView에서 Column으로 변경)
  Widget _buildSettingsMenuContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      children: [
        // 알림 설정 그룹
        _buildMenuGroup('알림 설정'),
        _buildToggleMenuItem(
          HugeIcons.strokeRoundedNotification01,
          '전체 알림',
          '모든 알림을 받을지 설정합니다',
          _notificationEnabled,
          (value) => setState(() => _notificationEnabled = value),
        ),
        _buildToggleMenuItem(
          HugeIcons.strokeRoundedNotification01,
          '푸시 알림',
          '앱에서 푸시 알림을 받을지 설정합니다',
          _pushNotificationEnabled,
          (value) => setState(() => _pushNotificationEnabled = value),
        ),
        _buildToggleMenuItem(
          HugeIcons.strokeRoundedMail01,
          '이메일 알림',
          '이메일로 중요한 소식을 받을지 설정합니다',
          _emailNotificationEnabled,
          (value) => setState(() => _emailNotificationEnabled = value),
        ),

        const SizedBox(height: 16),

        // 앱 설정 그룹
        _buildMenuGroup('앱 설정'),
        _buildToggleMenuItem(
          HugeIcons.strokeRoundedMoon01,
          '다크 모드',
          '어두운 테마를 사용합니다',
          _darkModeEnabled,
          (value) => setState(() => _darkModeEnabled = value),
        ),
        _buildToggleMenuItem(
          HugeIcons.strokeRoundedAnalytics01,
          '분석 데이터 수집',
          '앱 개선을 위한 익명 데이터를 수집합니다',
          _analyticsEnabled,
          (value) => setState(() => _analyticsEnabled = value),
        ),
        _buildActionMenuItem(
          HugeIcons.strokeRoundedLanguageCircle,
          '언어 설정',
          '앱에서 사용할 언어를 선택하세요',
          _changeLanguage,
        ),
        _buildActionMenuItem(
          HugeIcons.strokeRoundedDelete01,
          '캐시 삭제',
          '저장된 임시 파일을 삭제하여 용량을 확보하세요',
          _clearCache,
        ),

        const SizedBox(height: 16),

        // 지원 그룹
        _buildMenuGroup('지원'),
        _buildActionMenuItem(
          HugeIcons.strokeRoundedHelpCircle,
          '도움말',
          'LIA 사용법과 자주 묻는 질문을 확인하세요',
          _showHelp,
        ),
        _buildActionMenuItem(
          HugeIcons.strokeRoundedMail01,
          '문의하기',
          '궁금한 점이나 문제가 있으면 언제든 연락하세요',
          _contactSupport,
        ),
        _buildActionMenuItem(
          HugeIcons.strokeRoundedStar,
          '앱 평가하기',
          'LIA가 마음에 드신다면 평가를 남겨주세요',
          _rateApp,
        ),

        const SizedBox(height: 16),

        // 계정 그룹
        _buildMenuGroup('계정'),
        _buildActionMenuItem(
          HugeIcons.strokeRoundedCrown,
          'LIA 프리미엄',
          '더 많은 기능을 이용해보세요',
          _upgradePremium,
        ),
        _buildActionMenuItem(
          HugeIcons.strokeRoundedShield01,
          '개인정보 처리방침',
          '개인정보 보호 정책을 확인하세요',
          _showPrivacyPolicy,
        ),
        _buildActionMenuItem(
          HugeIcons.strokeRoundedFile01,
          '서비스 이용 약관',
          '서비스 이용 약관을 확인하세요',
          _showTerms,
        ),

        const SizedBox(height: 24),

        // 위험 구역
        _buildMenuGroup('계정 관리'),
        _buildDangerMenuItem(
          HugeIcons.strokeRoundedLogout01,
          '로그아웃',
          '현재 계정에서 로그아웃합니다',
          AppColors.textPrimary,
          _logout,
        ),
        _buildDangerMenuItem(
          HugeIcons.strokeRoundedUserRemove01,
          '계정 삭제',
          '모든 데이터가 영구적으로 삭제됩니다',
          AppColors.textPrimary,
          _deleteAccount,
        ),

        // 하단 여백 추가
        const SizedBox(height: 40),
      ],
    ),
  );

  // 메뉴 그룹 헤더
  Widget _buildMenuGroup(String title) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Text(
      title,
      style: AppTextStyles.body2.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // 토글 메뉴 아이템
  Widget _buildToggleMenuItem(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    margin: const EdgeInsets.only(bottom: 1),
    child: Row(
      children: [
        Icon(icon, size: 24, color: AppColors.textSecondary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        CustomToggleSwitch(value: value, onChanged: onChanged),
      ],
    ),
  );

  // 액션 메뉴 아이템
  Widget _buildActionMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            HugeIcons.strokeRoundedArrowRight01,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    ),
  );

  // 위험 액션 메뉴 아이템
  Widget _buildDangerMenuItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            HugeIcons.strokeRoundedArrowRight01,
            size: 16,
            color: color.withValues(alpha: 0.7),
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
