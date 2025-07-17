// File: lib/presentation/widgets/specific/feedback/toast_notification.dart

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// Toast 알림 타입을 정의하는 열거형
enum ToastType { success, error, info, warning }

/// LIA 브랜드에 맞는 Toast 알림 위젯
///
/// 사용법:
/// ```dart
/// ToastNotification.show(
///   context: context,
///   message: "메시지 전송 완료!",
///   type: ToastType.success,
/// );
/// ```
///
/// 기능:
/// - 4가지 타입 지원 (성공, 오류, 정보, 경고)
/// - 자동 사라짐 (3초 후)
/// - 슬라이드 애니메이션
/// - 18세 서현 페르소나에 맞는 친근한 메시지
class ToastNotification extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback? onDismiss;

  const ToastNotification({
    super.key,
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  });

  @override
  State<ToastNotification> createState() => _ToastNotificationState();

  /// Toast를 화면에 표시하는 정적 메서드
  static void show({
    required BuildContext context,
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: ToastNotification(
            message: message,
            type: type,
            duration: duration,
            onDismiss: () {
              overlayEntry.remove();
              onDismiss?.call();
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _ToastNotificationState extends State<ToastNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    // 자동으로 사라지게 하기
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onDismiss?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildToastContent(),
          ),
        );
      },
    );
  }

  Widget _buildToastContent() {
    final config = _getToastConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: config.gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: config.shadowColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(config.icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.message,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: _dismiss,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  _ToastConfig _getToastConfig() {
    switch (widget.type) {
      case ToastType.success:
        return _ToastConfig(
          gradient: AppColors.successGradient,
          icon: Icons.check_circle_outline,
          shadowColor: AppColors.green,
        );
      case ToastType.error:
        return _ToastConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.error_outline,
          shadowColor: AppColors.error,
        );
      case ToastType.info:
        return _ToastConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.info_outline,
          shadowColor: AppColors.info,
        );
      case ToastType.warning:
        return _ToastConfig(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          icon: Icons.warning_amber_outlined,
          shadowColor: AppColors.yellow,
        );
    }
  }
}

/// Toast 설정을 담는 내부 클래스
class _ToastConfig {
  final Gradient gradient;
  final IconData icon;
  final Color shadowColor;

  _ToastConfig({
    required this.gradient,
    required this.icon,
    required this.shadowColor,
  });
}
