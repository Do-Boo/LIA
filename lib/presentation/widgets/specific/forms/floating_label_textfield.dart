// File: lib/presentation/widgets/specific/forms/floating_label_textfield.dart

import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';

/// LIA 앱의 플로팅 라벨 텍스트 입력 필드입니다.
///
/// 18세 서현 페르소나에 맞는 부드럽고 친근한 디자인의 텍스트 필드로,
/// Material Design의 플로팅 라벨 패턴을 구현했습니다.
///
/// ## 🎯 사용 시나리오
/// - **프로필 입력**: "내 이름", "나이", "MBTI"
/// - **상대방 정보**: "그 사람 이름", "어떤 성격이야?"
/// - **메시지 입력**: "어떤 상황이야?", "뭐라고 보낼까?"
/// - **검색**: "메시지 검색", "키워드 입력"
/// - **설정**: "닉네임 변경", "상태메시지"
///
/// ## 🎨 디자인 특징
/// - **배경**: 순백색 배경에 부드러운 그림자
/// - **테두리**: 포커스 시 핑크 테두리 (2px)
/// - **라벨**: 회색에서 핑크로 색상 변화
/// - **모서리**: 16px 둥근 모서리
/// - **패딩**: 좌우 20px, 상하 16px
/// - **애니메이션**: 부드러운 라벨 이동 효과
///
/// ## 💡 사용법
/// ```dart
/// // 기본 사용법
/// FloatingLabelTextField(
///   label: '내 이름 입력해줘',
/// )
///
/// // 실제 LIA 앱에서의 사용 예시
/// class ProfileForm extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         FloatingLabelTextField(
///           label: '내 이름이 뭐야?',
///         ),
///         SizedBox(height: 16),
///         FloatingLabelTextField(
///           label: 'MBTI 알려줘 (예: ENFP)',
///         ),
///         SizedBox(height: 16),
///         FloatingLabelTextField(
///           label: '내 매력포인트는?',
///         ),
///       ],
///     );
///   }
/// }
///
/// // 컨트롤러와 함께 사용
/// class MessageInputWidget extends StatefulWidget {
///   @override
///   _MessageInputWidgetState createState() => _MessageInputWidgetState();
/// }
///
/// class _MessageInputWidgetState extends State<MessageInputWidget> {
///   final TextEditingController _controller = TextEditingController();
///
///   @override
///   Widget build(BuildContext context) {
///     return FloatingLabelTextField(
///       label: '어떤 상황인지 알려줘',
///       controller: _controller, // 향후 추가 예정
///     );
///   }
/// }
///
/// // 다른 페이지에서 import해서 사용
/// import 'package:lia/presentation/widgets/lia_widgets.dart';
///
/// FloatingLabelTextField(label: '뭐라고 할까?') // 바로 사용 가능
/// ```
///
/// ## 🎭 서현 페르소나 라벨 예시
/// - "내 이름이 뭐야?"
/// - "MBTI 알려줘!"
/// - "그 사람 어떤 스타일이야?"
/// - "지금 상황 설명해줘"
/// - "어떤 느낌으로 보낼까?"
/// - "내 매력포인트는?"
/// - "취미가 뭐야?"
///
/// ## 📱 접근성
/// - **라벨링**: 스크린 리더 지원
/// - **포커스**: 키보드 네비게이션 지원
/// - **색상 대비**: WCAG AA 기준 충족
/// - **터치 영역**: 최소 48dp 높이 보장
///
/// ## 🚫 주의사항
/// - 현재 controller 파라미터 미지원 (향후 추가 예정)
/// - validation 기능 미포함
/// - 멀티라인 텍스트 미지원
/// - 아이콘 추가 기능 없음
///
/// ## 🔮 향후 개선 계획
/// - TextEditingController 지원 추가
/// - validation 기능 추가
/// - 접두사/접미사 아이콘 지원
/// - 에러 상태 표시 기능
/// - 멀티라인 텍스트 지원
/// - 입력 타입 지정 (이메일, 전화번호 등)
///
/// @param label 플로팅 라벨에 표시될 텍스트 (서현 페르소나 말투 권장)
/// @param controller 텍스트 입력을 제어하는 컨트롤러
/// @param keyboardType 키보드 타입 (숫자, 이메일 등)
class FloatingLabelTextField extends StatelessWidget {
  /// 플로팅 라벨에 표시될 텍스트입니다.
  /// 포커스 상태에 따라 위치가 변경됩니다.
  final String label;

  /// 텍스트 입력을 제어하는 컨트롤러입니다.
  final TextEditingController? controller;

  /// 키보드 타입을 지정합니다.
  final TextInputType? keyboardType;

  const FloatingLabelTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
