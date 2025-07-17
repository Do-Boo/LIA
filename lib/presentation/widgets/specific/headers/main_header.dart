// File: lib/presentation/widgets/specific/headers/main_header.dart

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';
import '../feedback/pulsating_dot.dart';

/// 🎨 LIA 메인 헤더 위젯
///
/// 서현이의 개성이 담긴 메인 페이지 헤더예요!
/// 개인화된 인사말과 사용자 통계를 보여주는 핵심 위젯이야 💕
///
/// 주요 기능:
/// - 개인화된 인사말 ("안녕, 서현아! 👋")
/// - 실시간 사용자 통계 (생성 메시지, 성공률, 연속 사용일)
/// - 디자인 가이드 접근 버튼
/// - 사용자 프로필 아이콘
/// - 실시간 상태 표시 (PulsatingDot)
///
/// 디자인 특징:
/// - LIA 브랜드 그라데이션 배경
/// - 카드 형태의 둥근 모서리
/// - 그림자 효과로 입체감 연출
/// - 반응형 레이아웃
///
/// 사용 예시:
/// ```dart
/// MainHeader(
///   userName: "서현",
///   userStats: {
///     'messagesGenerated': 127,
///     'successRate': 89.5,
///     'consecutiveDays': 12,
///   },
///   onDesignGuidePressed: () => Navigator.push(...),
///   onProfilePressed: () => Navigator.push(...),
/// )
/// ```
class MainHeader extends StatelessWidget {
  /// 사용자 이름 (기본값: "서현")
  final String userName;

  /// 사용자 통계 데이터
  final Map<String, dynamic> userStats;

  /// 디자인 가이드 버튼 클릭 콜백
  final VoidCallback? onDesignGuidePressed;

  /// 프로필 버튼 클릭 콜백
  final VoidCallback? onProfilePressed;

  /// 헤더 높이 (기본값: null - 자동 크기)
  final double? height;

  /// 추가 패딩 (기본값: EdgeInsets.all(20))
  final EdgeInsets? padding;

  /// 커스텀 그라데이션 (기본값: AppColors.primaryGradient)
  final Gradient? customGradient;

  const MainHeader({
    super.key,
    this.userName = "서현",
    required this.userStats,
    this.onDesignGuidePressed,
    this.onProfilePressed,
    this.height,
    this.padding,
    this.customGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: customGradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단 행: 인사말 + 액션 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 인사말 섹션
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "안녕, $userName아!",
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "오늘도 멋진 메시지 만들어보자!",
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // 액션 버튼들
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 디자인 가이드 접근 버튼
                  if (onDesignGuidePressed != null)
                    IconButton(
                      onPressed: onDesignGuidePressed,
                      icon: const Icon(
                        HugeIcons.strokeRoundedPaintBrush02,
                        color: Colors.white,
                        size: 24,
                      ),
                      tooltip: "디자인 가이드",
                    ),
                  const SizedBox(width: 8),
                  // 실시간 상태 표시
                  const PulsatingDot(),
                  const SizedBox(width: 8),
                  // 프로필 버튼
                  GestureDetector(
                    onTap: onProfilePressed,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        HugeIcons.strokeRoundedUser,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 사용자 통계 요약
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                "생성한 메시지",
                "${userStats['messagesGenerated'] ?? 0}개",
              ),
              _buildStatItem("성공률", "${userStats['successRate'] ?? 0}%"),
              _buildStatItem("연속 사용", "${userStats['consecutiveDays'] ?? 0}일"),
            ],
          ),
        ],
      ),
    );
  }

  /// 📊 통계 아이템 생성
  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.h2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.helper.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
