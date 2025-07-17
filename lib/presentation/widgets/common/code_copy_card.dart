// File: lib/presentation/widgets/common/code_copy_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

/// 코드를 표시하고 복사할 수 있는 카드 위젯입니다.
///
/// 18세 서현 페르소나를 위한 친근한 코드 복사 경험을 제공하며,
/// 개발자들이 위젯 사용법을 쉽게 복사해서 사용할 수 있도록 도와줍니다.
///
/// ## 🎯 사용 시나리오
/// - **위젯 사용법**: 각 위젯의 코드 예시 표시
/// - **import 구문**: 필요한 import 문 복사
/// - **전체 예시**: 완전한 사용 예시 코드
/// - **설정 코드**: 초기 설정 코드 공유
///
/// ## 🎨 디자인 특징
/// - **다크 테마**: 코드 에디터 스타일의 어두운 배경
/// - **신택스 하이라이팅**: 코드 가독성 향상
/// - **복사 버튼**: 우상단의 직관적인 복사 아이콘
/// - **피드백**: 복사 완료 시 스낵바 표시
/// - **스크롤**: 긴 코드도 스크롤로 확인 가능
///
/// ## 💡 사용법
/// ```dart
/// CodeCopyCard(
///   title: 'PrimaryButton 사용법',
///   code: '''PrimaryButton(
///   onPressed: () {
///     print('버튼 클릭!');
///   },
///   text: '메시지 ㄱㄱ',
/// )''',
/// )
/// ```
class CodeCopyCard extends StatelessWidget {
  /// 코드 블록의 제목입니다.
  final String title;
  
  /// 표시하고 복사할 코드 내용입니다.
  final String code;
  
  /// 코드 설명 (옵션)입니다.
  final String? description;

  const CodeCopyCard({
    super.key,
    required this.title,
    required this.code,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // VS Code 다크 테마 색상
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (제목과 복사 버튼)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D30),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.code,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.helper.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(context),
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.white70,
                    size: 20,
                  ),
                  tooltip: '코드 복사',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),
          
          // 설명 (있는 경우)
          if (description != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF252526),
              child: Text(
                description!,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          
          // 코드 내용
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                code,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 13,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 코드를 클립보드에 복사하고 피드백을 제공합니다.
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.green,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '코드 복사 완료! 이제 붙여넣기해서 써봐 ㄱㄱ',
              style: AppTextStyles.helper.copyWith(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2D2D30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 