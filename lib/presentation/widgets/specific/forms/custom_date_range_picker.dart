// File: lib/presentation/widgets/specific/forms/custom_date_range_picker.dart

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

/// 날짜 범위 선택을 위한 커스텀 위젯입니다.
///
/// LIA 브랜드에 맞는 디자인으로 시작일과 종료일을 선택할 수 있습니다.
/// 18세 서현 페르소나에 맞는 친근하고 트렌디한 UI를 제공합니다.
class CustomDateRangePicker extends StatefulWidget {
  /// 라벨 텍스트
  final String label;

  /// 선택된 날짜 범위
  final DateTimeRange? selectedRange;

  /// 날짜 범위가 선택되었을 때 호출되는 콜백
  final ValueChanged<DateTimeRange?> onRangeSelected;

  /// 최소 선택 가능 날짜
  final DateTime? firstDate;

  /// 최대 선택 가능 날짜
  final DateTime? lastDate;

  /// 도움말 텍스트
  final String? helpText;

  const CustomDateRangePicker({
    super.key,
    required this.label,
    this.selectedRange,
    required this.onRangeSelected,
    this.firstDate,
    this.lastDate,
    this.helpText,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 12),

        // 날짜 범위 선택 버튼
        GestureDetector(
          onTap: _showDateRangePicker,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.selectedRange != null
                    ? AppColors.primary
                    : AppColors.cardBorder,
                width: widget.selectedRange != null ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // 달력 아이콘
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: widget.selectedRange != null
                        ? AppColors.primaryGradient
                        : LinearGradient(
                            colors: [
                              AppColors.lightGray,
                              AppColors.lightGray.withValues(alpha: 0.8),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.date_range,
                    color: widget.selectedRange != null
                        ? Colors.white
                        : AppColors.secondaryText,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),

                // 날짜 텍스트
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDisplayText(),
                        style: AppTextStyles.body.copyWith(
                          color: widget.selectedRange != null
                              ? AppColors.charcoal
                              : AppColors.secondaryText,
                          fontWeight: widget.selectedRange != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      if (widget.selectedRange != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _getDurationText(),
                          style: AppTextStyles.helper.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 화살표 아이콘
                Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.selectedRange != null
                      ? AppColors.primary
                      : AppColors.secondaryText,
                ),
              ],
            ),
          ),
        ),

        // 도움말 텍스트
        if (widget.helpText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.helpText!,
            style: AppTextStyles.helper.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],

        // 선택된 날짜 정보
        if (widget.selectedRange != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getSelectedRangeInfo(),
                    style: AppTextStyles.helper.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// 날짜 범위 선택기를 표시합니다.
  Future<void> _showDateRangePicker() async {
    final now = DateTime.now();
    final firstDate = widget.firstDate ?? now;
    final lastDate = widget.lastDate ?? DateTime(now.year + 1);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: widget.selectedRange,
      helpText: '기간을 선택해주세요',
      cancelText: '취소',
      confirmText: '확인',
      saveText: '저장',
      errorFormatText: '올바른 날짜를 입력해주세요',
      errorInvalidText: '유효하지 않은 날짜입니다',
      errorInvalidRangeText: '유효하지 않은 기간입니다',
      fieldStartHintText: '시작일',
      fieldEndHintText: '종료일',
      fieldStartLabelText: '시작일',
      fieldEndLabelText: '종료일',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.charcoal,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onRangeSelected(picked);
    }
  }

  /// 표시할 텍스트를 반환합니다.
  String _getDisplayText() {
    if (widget.selectedRange == null) {
      return '날짜 범위를 선택해주세요';
    }

    final start = widget.selectedRange!.start;
    final end = widget.selectedRange!.end;

    return '${_formatDate(start)} ~ ${_formatDate(end)}';
  }

  /// 기간 정보 텍스트를 반환합니다.
  String _getDurationText() {
    if (widget.selectedRange == null) return '';

    final duration = widget.selectedRange!.end.difference(
      widget.selectedRange!.start,
    );
    final days = duration.inDays + 1; // 시작일 포함

    if (days == 1) {
      return '당일';
    } else if (days <= 7) {
      return '$days일';
    } else {
      final weeks = (days / 7).floor();
      final remainingDays = days % 7;
      if (remainingDays == 0) {
        return '$weeks주';
      } else {
        return '$weeks주 $remainingDays일';
      }
    }
  }

  /// 선택된 날짜 범위 정보를 반환합니다.
  String _getSelectedRangeInfo() {
    if (widget.selectedRange == null) return '';

    final duration = _getDurationText();
    return '선택된 기간: $duration';
  }

  /// 날짜를 포맷팅합니다.
  String _formatDate(DateTime date) {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];

    return '${date.month}/${date.day}($weekday)';
  }
}
