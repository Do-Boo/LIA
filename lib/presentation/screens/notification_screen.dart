// File: lib/presentation/screens/notification_screen.dart
// 2025.07.25 22:31:07 카카오톡 스타일 알림 화면을 메뉴 그룹 형태로 리팩토링

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 알림 화면
///
/// 앱 내 알림들을 카카오톡 스타일 메뉴 그룹으로 분류하여 표시하는 화면
/// 상단 요약 + 하단 메뉴 그룹 패턴 적용
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // 알림 통계 데이터
  final Map<String, dynamic> _notificationStats = {
    'totalNotifications': 47,
    'unreadCount': 5,
    'todayCount': 12,
    'lastUpdate': '2025.07.25',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(child: _buildScreenWithScroll()),
  );

  /// 상단 알림 요약 섹션
  Widget _buildNotificationSummarySection() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    color: Colors.transparent,
    child: Column(
      children: [
        // 알림 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            HugeIcons.strokeRoundedNotification01,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),

        // 알림 타이틀
        Text(
          '알림센터',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // 읽지 않은 알림 수
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '읽지 않은 알림 ${_notificationStats['unreadCount']}개 • 오늘 ${_notificationStats['todayCount']}개',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  /// 통계 섹션
  Widget _buildStatsSection() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Row(
      children: [
        Expanded(
          child: _buildStatItem(
            '전체 알림',
            '${_notificationStats['totalNotifications']}개',
          ),
        ),
        Container(width: 1, height: 40, color: AppColors.border),
        Expanded(
          child: _buildStatItem(
            '읽지 않음',
            '${_notificationStats['unreadCount']}개',
          ),
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

  /// 메뉴 그룹 (섹션 헤더)
  Widget _buildMenuGroup(String title, List<Widget> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Text(
          title,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      ...items,
      const SizedBox(height: 16),
    ],
  );

  /// 스크롤 가능한 화면
  Widget _buildScreenWithScroll() => CustomScrollView(
    slivers: [
      // 상단 알림 요약 섹션
      SliverToBoxAdapter(child: _buildNotificationSummarySection()),

      // 통계 섹션
      SliverToBoxAdapter(child: _buildStatsSection()),

      // 메뉴 섹션
      SliverToBoxAdapter(child: _buildMenuContent()),
    ],
  );

  /// 메뉴 콘텐츠
  Widget _buildMenuContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        // 최근 알림
        _buildMenuGroup('최근 알림', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAnalytics01,
            title: '분석 완료',
            subtitle: '김서현님과의 대화 분석이 완료되었습니다 • 5분 전',
            onTap: () => _handleNotificationTap('analysis', '분석 결과를 확인합니다'),
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedBookOpen01,
            title: '새로운 코칭 팁',
            subtitle: '"첫 메시지 보내기" 가이드가 업데이트되었습니다 • 2시간 전',
            onTap: () => _handleNotificationTap('coaching', '코칭센터로 이동합니다'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedMessage01,
            title: 'AI 메시지 생성',
            subtitle: '요청하신 메시지가 성공적으로 생성되었습니다 • 4시간 전',
            onTap: () => _handleNotificationTap('message', 'AI 메시지를 확인합니다'),
            iconColor: AppColors.green,
          ),
        ]),

        // 시스템 알림
        _buildMenuGroup('시스템 알림', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedSystemUpdate01,
            title: '앱 업데이트',
            subtitle: 'LIA 2.1.0 버전이 출시되었습니다 • 1일 전',
            onTap: () => _handleNotificationTap('system', '업데이트를 확인합니다'),
            iconColor: AppColors.info,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedShield01,
            title: '보안 알림',
            subtitle: '새로운 기기에서 로그인이 감지되었습니다 • 2일 전',
            onTap: () => _handleNotificationTap('security', '보안 설정을 확인합니다'),
            iconColor: AppColors.warning,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedSettings01,
            title: '설정 변경',
            subtitle: '알림 설정이 업데이트되었습니다 • 3일 전',
            onTap: () => _handleNotificationTap('settings', '설정을 확인합니다'),
            iconColor: AppColors.textSecondary,
          ),
        ]),

        // 성취 및 레벨업
        _buildMenuGroup('성취 및 레벨업', [
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedTradeUp,
            title: '레벨 업!',
            subtitle: '축하합니다! Advanced 레벨에 도달했습니다 • 2일 전',
            onTap: () => _handleNotificationTap('achievement', '성취 내역을 확인합니다'),
            iconColor: AppColors.warning,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedAward01,
            title: '배지 획득',
            subtitle: '"메시지 마스터" 배지를 획득했습니다 • 1주 전',
            onTap: () => _handleNotificationTap('badge', '배지를 확인합니다'),
            iconColor: AppColors.accent,
          ),
          MenuItemWidget.defualt(
            icon: HugeIcons.strokeRoundedTarget01,
            title: '목표 달성',
            subtitle: '이번 주 메시지 작성 목표를 달성했습니다 • 1주 전',
            onTap: () => _handleNotificationTap('goal', '목표 현황을 확인합니다'),
            iconColor: AppColors.green,
          ),
        ]),

        // 알림 관리
        _buildMenuGroup('알림 관리', [
          MenuItemWidget.simple(
            icon: HugeIcons.strokeRoundedSettings01,
            title: '알림 설정',
            onTap: () => _handleNotificationTap(
              'notification_settings',
              '알림 설정으로 이동합니다',
            ),
            iconColor: AppColors.textSecondary,
          ),
          MenuItemWidget.simple(
            icon: HugeIcons.strokeRoundedDelete01,
            title: '모든 알림 삭제',
            onTap: _showDeleteAllDialog,
            iconColor: AppColors.error,
          ),
          MenuItemWidget.simple(
            icon: HugeIcons.strokeRoundedCheckmarkCircle01,
            title: '모두 읽음 처리',
            onTap: _handleMarkAllAsRead,
            iconColor: AppColors.green,
          ),
        ]),

        // 하단 여백 추가
        const SizedBox(height: 40),
      ],
    ),
  );

  /// 알림 탭 처리
  void _handleNotificationTap(String type, String message) {
    _showToast(message);
  }

  /// 모든 알림 삭제 다이얼로그
  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모든 알림 삭제'),
        content: const Text('모든 알림을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast('모든 알림이 삭제되었습니다');
            },
            child: const Text('삭제', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  /// 모두 읽음 처리
  void _handleMarkAllAsRead() {
    setState(() {
      _notificationStats['unreadCount'] = 0;
    });
    _showToast('모든 알림을 읽음 처리했습니다');
  }

  /// 토스트 메시지 표시
  void _showToast(String message) {
    ToastNotification.show(
      context: context,
      message: message,
      type: ToastType.info,
    );
  }
}
