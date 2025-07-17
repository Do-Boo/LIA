// File: lib/presentation/widgets/specific/forms/tag_input_field.dart

import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

/// 태그를 추가하고 관리할 수 있는 입력 필드입니다.
///
/// 사용자가 텍스트를 입력하고 엔터를 누르면 태그가 추가되며,
/// 추가된 태그들은 그라데이션 배경의 칩 형태로 표시됩니다.
/// 각 태그는 개별적으로 삭제할 수 있습니다.
///
/// 주요 특징:
/// - 동적 태그 추가/삭제 기능
/// - 그라데이션 배경의 태그 칩
/// - 터치 피드백이 있는 삭제 버튼
/// - 플로팅 라벨이 있는 입력 필드
/// - 태그별 그림자 효과
///
/// 사용 예시:
/// ```dart
/// TagInputField()  // 기본 관심사 태그 입력 필드
/// ```
///
/// 기본 태그:
/// - "여행"
/// - "음식"
/// - "영화"
class TagInputField extends StatefulWidget {
  const TagInputField({super.key});

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  /// 현재 추가된 태그들의 목록입니다.
  final List<String> _tags = ["여행", "음식", "영화"];
  
  /// 텍스트 입력을 제어하는 컨트롤러입니다.
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 새로운 태그를 추가하는 메서드입니다.
  ///
  /// 입력된 텍스트가 비어있지 않고 중복되지 않는 경우에만 태그를 추가하며,
  /// 추가 후 입력 필드를 초기화합니다.
  ///
  /// @param tag 추가할 태그 텍스트
  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _controller.clear();
      });
    }
  }

  /// 기존 태그를 삭제하는 메서드입니다.
  ///
  /// @param tag 삭제할 태그 텍스트
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 태그 입력 필드
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "관심사 뭐야?",
              labelStyle: TextStyle(color: Colors.grey.shade600),
              floatingLabelStyle: const TextStyle(color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                onPressed: () => _addTag(_controller.text.trim()),
              ),
            ),
            onSubmitted: _addTag,
          ),
        ),
        const SizedBox(height: 16),
        // 태그 목록
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _removeTag(tag),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }
} 