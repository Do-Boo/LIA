import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

/// 코드 예시를 보여주고 복사 기능을 제공하는 카드 위젯입니다.
///
/// 디자인 가이드에서 사용법 예시를 보여줄 때 사용합니다.
/// 코드를 syntax highlighting과 함께 표시하고,
/// 복사 버튼을 통해 클립보드에 복사할 수 있습니다.
///
/// 사용 예시:
/// ```dart
/// CodeCopyCard(
///   title: "사용 예시",
///   code: '''
/// PrimaryButton(
///   onPressed: () => print("클릭!"),
///   text: "버튼 텍스트",
/// )
///   ''',
/// )
/// ```
class CodeCopyCard extends StatefulWidget {
  /// 카드 제목
  final String title;

  /// 표시할 코드 내용
  final String code;

  /// 코드 언어 (기본값: 'dart')
  final String language;

  /// 카드 배경색 (기본값: AppColors.background)
  final Color? backgroundColor;

  /// 코드 배경색 (기본값: Colors.grey.shade50)
  final Color? codeBackgroundColor;

  const CodeCopyCard({
    super.key,
    required this.title,
    required this.code,
    this.language = 'dart',
    this.backgroundColor,
    this.codeBackgroundColor,
  });

  @override
  State<CodeCopyCard> createState() => _CodeCopyCardState();
}

class _CodeCopyCardState extends State<CodeCopyCard> {
  bool _isCopied = false;

  /// 코드를 클립보드에 복사하는 메서드입니다.
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() {
      _isCopied = true;
    });

    // 2초 후 복사 상태 초기화
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목과 복사 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal,
                ),
              ),
              GestureDetector(
                onTap: _copyToClipboard,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _isCopied
                        ? AppColors.green.withValues(alpha: 0.1)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isCopied
                          ? AppColors.green.withValues(alpha: 0.3)
                          : AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isCopied ? Icons.check : Icons.copy,
                        size: 16,
                        color: _isCopied ? AppColors.green : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isCopied ? '복사됨!' : '복사',
                        style: AppTextStyles.helper.copyWith(
                          color: _isCopied
                              ? AppColors.green
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 코드 영역
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.codeBackgroundColor ?? Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SelectableText(
              widget.code,
              style: AppTextStyles.body.copyWith(
                fontFamily: 'monospace',
                color: AppColors.charcoal,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
