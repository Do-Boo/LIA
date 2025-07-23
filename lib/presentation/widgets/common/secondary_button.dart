// File: lib/presentation/widgets/common/secondary_button.dart

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

/// 앱의 보조 액션을 위한 세컨더리 버튼입니다.
/// 밝은 회색 배경을 사용합니다.
///
/// UI/UX 개선 사항 (2025.07.15 21:16:00):
/// - 패딩 축소: 28px → 20px (horizontal), 14px → 12px (vertical)
/// - 그림자 효과 간소화
/// - 모바일 친화적 크기 조정
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  });
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.charcoal.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        hoverColor: const Color(0xFFE9ECEF),
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondaryText,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
      ),
    ),
  );
}
