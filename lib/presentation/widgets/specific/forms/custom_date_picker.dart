// File: lib/presentation/widgets/specific/forms/custom_date_picker.dart

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// LIA 브랜드에 맞는 커스텀 Date Picker 위젯
///
/// 사용법:
/// ```dart
/// CustomDatePicker(
///   label: "언제 만날까?",
///   selectedDate: DateTime.now(),
///   onDateSelected: (date) {
///     print('선택된 날짜: $date');
///   },
/// )
/// ```
///
/// 기능:
/// - 18세 서현 페르소나에 맞는 친근한 라벨
/// - LIA 브랜드 색상 적용
/// - 부드러운 애니메이션 효과
/// - 터치 피드백
class CustomDatePicker extends StatefulWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  const CustomDatePicker({
    super.key,
    required this.label,
    this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    if (!widget.enabled) return;

    setState(() => _isPressed = true);
    _animationController.forward();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.charcoal,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    _animationController.reverse();
    setState(() => _isPressed = false);

    if (picked != null && picked != widget.selectedDate) {
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildDatePickerContent(),
        );
      },
    );
  }

  Widget _buildDatePickerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨
        Text(
          widget.label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 8),

        // 날짜 선택 버튼
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: widget.enabled
                  ? (_isPressed
                        ? AppColors.accentGradient
                        : AppColors.primaryGradient)
                  : null,
              color: widget.enabled ? null : AppColors.lightGray,
              borderRadius: BorderRadius.circular(16),
              boxShadow: widget.enabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
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
                  child: Icon(
                    Icons.calendar_today,
                    color: widget.enabled
                        ? Colors.white
                        : AppColors.secondaryText,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.selectedDate != null
                        ? _formatDate(widget.selectedDate!)
                        : '날짜를 선택해주세요',
                    style: AppTextStyles.body.copyWith(
                      color: widget.enabled
                          ? Colors.white
                          : AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.enabled
                      ? Colors.white
                      : AppColors.secondaryText,
                  size: 24,
                ),
              ],
            ),
          ),
        ),

        // 도움말 텍스트
        if (widget.selectedDate != null) ...[
          const SizedBox(height: 8),
          Text(
            _getHelpText(),
            style: AppTextStyles.helper.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];

    return '${date.year}년 ${date.month}월 ${date.day}일 ($weekday)';
  }

  String _getHelpText() {
    if (widget.selectedDate == null) return '';

    final now = DateTime.now();
    final difference = widget.selectedDate!
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (difference == 0) {
      return '오늘이네! 완전 좋은데? 😊';
    } else if (difference == 1) {
      return '내일이구나! 설레는데? 💕';
    } else if (difference > 1 && difference <= 7) {
      return '이번 주네! 기대돼 ✨';
    } else if (difference > 7) {
      return '아직 좀 남았네! 그때까지 기다려야지 😌';
    } else {
      return '이미 지난 날짜네! 다른 날로 해볼까? 🤔';
    }
  }
}
