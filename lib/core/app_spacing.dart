// File: lib/core/app_spacing.dart
// 📏 앱 간격 상수 정의

import 'package:flutter/material.dart';

/// LIA 앱의 간격 시스템을 정의하는 클래스입니다.
///
/// 이 클래스를 통해 앱 전체의 간격을 일관되게 관리할 수 있습니다.
/// 모든 간격은 4px 단위로 정의되어 디자인 시스템의 일관성을 보장합니다.
///
/// 간격 시스템 (4px 기준):
/// - xs: 4px - 최소 간격
/// - sm: 8px - 작은 간격
/// - md: 16px - 기본 간격
/// - lg: 24px - 큰 간격
/// - xl: 32px - 매우 큰 간격
/// - xxl: 40px - 최대 간격
class AppSpacing {
  // ============================================
  // 📏 기본 간격 상수 (Basic Spacing Constants)
  // ============================================

  /// 최소 간격 (4px)
  static const double xs = 4;

  /// 작은 간격 (8px)
  static const double sm = 8;

  /// 기본 간격 (16px)
  static const double md = 16;

  /// 기본 간격 (20px)
  static const double md2 = 20;

  /// 큰 간격 (24px)
  static const double lg = 24;

  /// 매우 큰 간격 (32px)
  static const double xl = 32;

  /// 최대 간격 (40px)
  static const double xxl = 40;

  // ============================================
  // 📐 수직 간격 위젯 (Vertical Spacing Widgets)
  // ============================================

  /// 수직 간격 4px
  static const Widget gapV4 = SizedBox(height: xs);

  /// 수직 간격 8px
  static const Widget gapV8 = SizedBox(height: sm);

  /// 수직 간격 16px
  static const Widget gapV16 = SizedBox(height: md);

  /// 수직 간격 20px
  static const Widget gapV20 = SizedBox(height: md2);

  /// 수직 간격 24px
  static const Widget gapV24 = SizedBox(height: lg);

  /// 수직 간격 32px
  static const Widget gapV32 = SizedBox(height: xl);

  /// 수직 간격 40px
  static const Widget gapV40 = SizedBox(height: xxl);

  // ============================================
  // 📐 수평 간격 위젯 (Horizontal Spacing Widgets)
  // ============================================

  /// 수평 간격 4px
  static const Widget gapH4 = SizedBox(width: xs);

  /// 수평 간격 8px
  static const Widget gapH8 = SizedBox(width: sm);

  /// 수평 간격 16px
  static const Widget gapH16 = SizedBox(width: md);

  /// 수평 간격 20px
  static const Widget gapH20 = SizedBox(width: md2);

  /// 수평 간격 24px
  static const Widget gapH24 = SizedBox(width: lg);

  /// 수평 간격 32px
  static const Widget gapH32 = SizedBox(width: xl);

  /// 수평 간격 40px
  static const Widget gapH40 = SizedBox(width: xxl);

  // ============================================
  // 📦 패딩 상수 (Padding Constants)
  // ============================================

  /// 전체 패딩 xs (4px)
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);

  /// 전체 패딩 sm (8px)
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);

  /// 전체 패딩 md (16px)
  static const EdgeInsets paddingMD = EdgeInsets.all(md);

  /// 전체 패딩 md2 (20px)
  static const EdgeInsets paddingMD2 = EdgeInsets.all(md2);

  /// 전체 패딩 lg (24px)
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);

  /// 전체 패딩 xl (32px)
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  /// 전체 패딩 xxl (40px)
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  // ============================================
  // 📦 수평 패딩 상수 (Horizontal Padding Constants)
  // ============================================

  /// 수평 패딩 xs (4px)
  static const EdgeInsets paddingHXS = EdgeInsets.symmetric(horizontal: xs);

  /// 수평 패딩 sm (8px)
  static const EdgeInsets paddingHSM = EdgeInsets.symmetric(horizontal: sm);

  /// 수평 패딩 md (16px)
  static const EdgeInsets paddingHMD = EdgeInsets.symmetric(horizontal: md);

  /// 수평 패딩 md2 (20px)
  static const EdgeInsets paddingHMD2 = EdgeInsets.symmetric(horizontal: md2);

  /// 수평 패딩 lg (24px)
  static const EdgeInsets paddingHLG = EdgeInsets.symmetric(horizontal: lg);

  /// 수평 패딩 xl (32px)
  static const EdgeInsets paddingHXL = EdgeInsets.symmetric(horizontal: xl);

  /// 수평 패딩 xxl (40px)
  static const EdgeInsets paddingHXXL = EdgeInsets.symmetric(horizontal: xxl);

  // ============================================
  // 📦 수직 패딩 상수 (Vertical Padding Constants)
  // ============================================

  /// 수직 패딩 xs (4px)
  static const EdgeInsets paddingVXS = EdgeInsets.symmetric(vertical: xs);

  /// 수직 패딩 sm (8px)
  static const EdgeInsets paddingVSM = EdgeInsets.symmetric(vertical: sm);

  /// 수직 패딩 md (16px)
  static const EdgeInsets paddingVMD = EdgeInsets.symmetric(vertical: md);

  /// 수직 패딩 md2 (20px)
  static const EdgeInsets paddingVMD2 = EdgeInsets.symmetric(vertical: md2);

  /// 수직 패딩 lg (24px)
  static const EdgeInsets paddingVLG = EdgeInsets.symmetric(vertical: lg);

  /// 수직 패딩 xl (32px)
  static const EdgeInsets paddingVXL = EdgeInsets.symmetric(vertical: xl);

  /// 수직 패딩 xxl (40px)
  static const EdgeInsets paddingVXXL = EdgeInsets.symmetric(vertical: xxl);

  // ============================================
  // 🔄 마진 상수 (Margin Constants)
  // ============================================

  /// 전체 마진 xs (4px)
  static const EdgeInsets marginXS = EdgeInsets.all(xs);

  /// 전체 마진 sm (8px)
  static const EdgeInsets marginSM = EdgeInsets.all(sm);

  /// 전체 마진 md (16px)
  static const EdgeInsets marginMD = EdgeInsets.all(md);

  /// 전체 마진 md2 (20px)
  static const EdgeInsets marginMD2 = EdgeInsets.all(md2);

  /// 전체 마진 lg (24px)
  static const EdgeInsets marginLG = EdgeInsets.all(lg);

  /// 전체 마진 xl (32px)
  static const EdgeInsets marginXL = EdgeInsets.all(xl);

  /// 전체 마진 xxl (40px)
  static const EdgeInsets marginXXL = EdgeInsets.all(xxl);

  // ============================================
  // 🔄 수평 마진 상수 (Horizontal Margin Constants)
  // ============================================

  /// 수평 마진 xs (4px)
  static const EdgeInsets marginHXS = EdgeInsets.symmetric(horizontal: xs);

  /// 수평 마진 sm (8px)
  static const EdgeInsets marginHSM = EdgeInsets.symmetric(horizontal: sm);

  /// 수평 마진 md (16px)
  static const EdgeInsets marginHMD = EdgeInsets.symmetric(horizontal: md);

  /// 수평 마진 md2 (20px)
  static const EdgeInsets marginHMD2 = EdgeInsets.symmetric(horizontal: md2);

  /// 수평 마진 lg (24px)
  static const EdgeInsets marginHLG = EdgeInsets.symmetric(horizontal: lg);

  /// 수평 마진 xl (32px)
  static const EdgeInsets marginHXL = EdgeInsets.symmetric(horizontal: xl);

  /// 수평 마진 xxl (40px)
  static const EdgeInsets marginHXXL = EdgeInsets.symmetric(horizontal: xxl);

  // ============================================
  // 🔄 수직 마진 상수 (Vertical Margin Constants)
  // ============================================

  /// 수직 마진 xs (4px)
  static const EdgeInsets marginVXS = EdgeInsets.symmetric(vertical: xs);

  /// 수직 마진 sm (8px)
  static const EdgeInsets marginVSM = EdgeInsets.symmetric(vertical: sm);

  /// 수직 마진 md (16px)
  static const EdgeInsets marginVMD = EdgeInsets.symmetric(vertical: md);

  /// 수직 마진 md2 (20px)
  static const EdgeInsets marginVMD2 = EdgeInsets.symmetric(vertical: md2);

  /// 수직 마진 lg (24px)
  static const EdgeInsets marginVLG = EdgeInsets.symmetric(vertical: lg);

  /// 수직 마진 xl (32px)
  static const EdgeInsets marginVXL = EdgeInsets.symmetric(vertical: xl);

  /// 수직 마진 xxl (40px)
  static const EdgeInsets marginVXXL = EdgeInsets.symmetric(vertical: xxl);
}
