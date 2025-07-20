// File: lib/utils/custom_modal.dart

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../presentation/widgets/common/primary_button.dart';
import '../presentation/widgets/common/secondary_button.dart';

/// 18세 서현 페르소나에 맞는 커스텀 모달 다이얼로그를 표시하는 유틸리티 함수입니다.
///
/// LIA 앱의 브랜드 디자인에 맞는 친근하고 트렌디한 모달을 표시하며,
/// 부드러운 애니메이션과 블러 효과를 제공합니다.
///
/// ## 🎯 서현 페르소나 특징
/// - 친근하고 귀여운 텍스트 스타일
/// - 이모지와 함께하는 감정 표현
/// - 부드러운 핑크 톤의 그라데이션
/// - 트렌디한 둥근 모서리와 그림자
///
/// ## 💡 사용 시나리오
/// - 성공 알림: "완료됐어! 🎉"
/// - 확인 요청: "정말 할래? 🤔"
/// - 오류 알림: "앗, 뭔가 잘못됐어 😅"
/// - 정보 제공: "알아둘게 있어! 💡"
///
/// 사용 예시:
/// ```dart
/// // 기본 알림 모달
/// showCustomModal(
///   context: context,
///   title: '완료됐어! 🎉',
///   content: '메시지가 성공적으로 생성됐어! 이제 복사해서 써봐 ㄱㄱ',
/// )
///
/// // 확인/취소 모달
/// showCustomConfirmModal(
///   context: context,
///   title: '정말 삭제할래? 🗑️',
///   content: '삭제하면 다시 복구할 수 없어! 정말 괜찮아?',
///   confirmText: '응, 삭제해',
///   cancelText: '아니야',
///   onConfirm: () => deleteMessage(),
/// )
/// ```
///
/// @param context BuildContext for showing the modal
/// @param title 모달의 제목 텍스트 (이모지 포함 권장)
/// @param content 모달의 내용 텍스트 (서현이 말투 권장)
/// @param confirmText 확인 버튼 텍스트 (기본: "알겠어!")
/// @return Future<void> 모달이 닫힐 때까지의 Future
Future<void> showCustomModal({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = '확인',
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (BuildContext context) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          // 애니메이션 값을 0.0-1.0 범위로 클램핑하여 안전성 확보
          final clampedValue = value.clamp(0.0, 1.0);

          return BackdropFilter(
            filter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.25 * clampedValue),
              BlendMode.darken,
            ),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              child: Transform.scale(
                scale: 0.85 + (0.15 * clampedValue), // 0.85에서 1.0으로 부드럽게
                child: Opacity(
                  opacity: clampedValue,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 340),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white, // LIA 앱 스타일에 맞는 불투명 흰색 배경
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: -5,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 모달 제목 (이모지 포함)
                        Text(
                          title,
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // 모달 내용 (서현이 말투)
                        Text(
                          content,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.secondaryText,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // 확인 버튼 (PrimaryButton 사용)
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            onPressed: () => Navigator.of(context).pop(),
                            text: confirmText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

/// 확인/취소 선택이 필요한 커스텀 모달 다이얼로그를 표시합니다.
///
/// 18세 서현 페르소나에 맞는 친근한 확인 모달로,
/// 중요한 액션 전에 사용자의 확인을 받을 때 사용합니다.
///
/// ## 💡 사용 시나리오
/// - 삭제 확인: "정말 삭제할래? 🗑️"
/// - 전송 확인: "이 메시지로 보낼까? 💌"
/// - 로그아웃 확인: "정말 로그아웃할래? 👋"
/// - 설정 변경: "이 설정으로 바꿀까? ⚙️"
///
/// @param context BuildContext for showing the modal
/// @param title 모달의 제목 텍스트 (이모지 포함 권장)
/// @param content 모달의 내용 텍스트 (서현이 말투 권장)
/// @param confirmText 확인 버튼 텍스트 (기본: "응, 할래!")
/// @param cancelText 취소 버튼 텍스트 (기본: "아니야")
/// @param onConfirm 확인 버튼 클릭 시 실행될 콜백
/// @param onCancel 취소 버튼 클릭 시 실행될 콜백 (선택사항)
/// @return Future<bool?> 확인 시 true, 취소 시 false, 바깥 터치 시 null
Future<bool?> showCustomConfirmModal({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = '네',
  String cancelText = '아니요',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (BuildContext context) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final clampedValue = value.clamp(0.0, 1.0);

          return BackdropFilter(
            filter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.25 * clampedValue),
              BlendMode.darken,
            ),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              child: Transform.scale(
                scale: 0.85 + (0.15 * clampedValue),
                child: Opacity(
                  opacity: clampedValue,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 340),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white, // LIA 앱 스타일에 맞는 불투명 흰색 배경
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: -5,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 모달 제목
                        Text(
                          title,
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // 모달 내용
                        Text(
                          content,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.secondaryText,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // 버튼 영역 (취소:확인 = 1:1.5 비율)
                        Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  onCancel?.call();
                                },
                                text: cancelText,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: PrimaryButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  onConfirm?.call();
                                },
                                text: confirmText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

/// 메시지 전송 확인용 특별 모달입니다.
///
/// LIA 앱의 핵심 기능인 메시지 전송 전 확인 모달로,
/// 생성된 메시지를 미리보기와 함께 보여줍니다.
///
/// @param context BuildContext for showing the modal
/// @param message 전송할 메시지 내용
/// @param recipientName 받는 사람 이름 (선택사항)
/// @param onSend 전송 버튼 클릭 시 실행될 콜백
/// @return Future<bool?> 전송 시 true, 취소 시 false
Future<bool?> showMessageConfirmModal({
  required BuildContext context,
  required String message,
  String? recipientName,
  VoidCallback? onSend,
}) async {
  final displayName = recipientName ?? '그 사람';

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (BuildContext context) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final clampedValue = value.clamp(0.0, 1.0);

          return BackdropFilter(
            filter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.25 * clampedValue),
              BlendMode.darken,
            ),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              child: Transform.scale(
                scale: 0.85 + (0.15 * clampedValue),
                child: Opacity(
                  opacity: clampedValue,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 360),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white, // LIA 앱 스타일에 맞는 불투명 흰색 배경
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: -5,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 이모지와 제목
                        const Text('💌', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text(
                          '메시지를 보낼까요?',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // 메시지 미리보기
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.05),
                                AppColors.accent.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '"$message"',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16,
                              height: 1.4,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 주의사항
                        Text(
                          '전송 후에는 수정할 수 없습니다',
                          style: AppTextStyles.helper.copyWith(
                            color: AppColors.accent.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        // 버튼 영역
                        Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                text: '취소',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: PrimaryButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  onSend?.call();
                                },
                                text: '보내기',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
