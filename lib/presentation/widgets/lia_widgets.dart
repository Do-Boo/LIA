// File: lib/presentation/widgets/lia_widgets.dart

/// LIA 앱의 모든 위젯을 한 번에 import할 수 있는 barrel 파일입니다.
///
/// 18세 서현 페르소나를 위한 트렌디하고 친근한 UI 컴포넌트들을 제공합니다.
/// 이 파일 하나만 import하면 모든 LIA 위젯을 사용할 수 있습니다.
///
/// ## 🚀 빠른 시작
/// ```dart
/// import 'package:lia/presentation/widgets/lia_widgets.dart';
///
/// // 모든 위젯 바로 사용 가능!
/// PrimaryButton(onPressed: () {}, text: '메시지 ㄱㄱ')
/// SecondaryButton(onPressed: () {}, text: '나중에')
/// FloatingLabelTextField(label: '내 이름이 뭐야?')
/// GaugeChart() // 호감도 차트
/// ```
///
/// ## 📦 포함된 위젯 카테고리
///
/// ### 🔘 버튼 (Common Buttons)
/// - **PrimaryButton**: 주요 액션용 핑크 그라데이션 버튼
/// - **SecondaryButton**: 보조 액션용 회색 버튼
///
/// ### 📊 차트 (Charts)
/// - **GaugeChart**: 호감도/진행률 표시용 원형 차트
/// - **DonutChart**: 카테고리별 분포 표시용 도넛 차트
/// - **BarChart**: 비교 데이터 표시용 막대 차트
/// - **LineChart**: 시간별 변화 추이 표시용 라인 차트
/// - **SemicircleGaugeChart**: 공간 효율적인 반원 게이지 차트
/// - **PieChart**: 원형 비율 표시용 파이 차트
/// - **RadarChart**: 다차원 데이터 표시용 레이더 차트
/// - **HeatmapChart**: 시간/날짜별 활동 패턴 표시용 히트맵 차트
///
/// ### 📝 폼 입력 (Form Inputs)
/// - **FloatingLabelTextField**: 플로팅 라벨 텍스트 입력 필드
/// - **TagInputField**: 태그 입력 및 관리 필드
/// - **CustomSlider**: 커스텀 디자인 슬라이더
/// - **CustomToggleSwitch**: 토글 스위치
///
/// ### 🎨 피드백 (Feedback)
/// - **GeneratingProgress**: 메시지 생성 중 진행 표시
/// - **HeartSpinner**: 하트 모양 로딩 스피너
/// - **PulsatingDot**: 맥박 효과 점 표시
/// - **SkeletonUI**: 로딩 중 스켈레톤 UI
///
/// ### 🧩 공통 컴포넌트 (Common Components)
/// - **ComponentCard**: 위젯 표시용 카드
/// - **DashedDivider**: 점선 구분선
/// - **MenuItemWidget**: 카카오톡 스타일 및 심플 스타일 메뉴 아이템
///
/// ### 🚀 네비게이션 (Navigation)
/// - **BottomNavigationBar**: 하단 네비게이션 바
///
/// ## 💡 사용 팁
/// 1. **한 번만 import**: 이 파일 하나로 모든 위젯 사용
/// 2. **코드 자동완성**: IDE에서 위젯 이름 타이핑하면 자동완성
/// 3. **문서 참고**: 각 위젯의 상세한 사용법은 해당 파일의 주석 참고
/// 4. **서현 페르소나**: 텍스트는 18세 서현 말투로 작성 권장
///
/// ## 🎯 실제 사용 예시
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:lia/presentation/widgets/lia_widgets.dart';
///
/// class MessageGenerationScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('메시지 만들기')),
///       body: Padding(
///         padding: EdgeInsets.all(16),
///         child: Column(
///           children: [
///             // 상황 입력
///             FloatingLabelTextField(
///               label: '어떤 상황인지 알려줘',
///             ),
///             SizedBox(height: 16),
///
///             // 호감도 표시
///             GaugeChart(),
///             SizedBox(height: 16),
///
///             // 버튼들
///             Row(
///               children: [
///                 Expanded(
///                   child: SecondaryButton(
///                     onPressed: () => Navigator.pop(context),
///                     text: '아니야',
///                   ),
///                 ),
///                 SizedBox(width: 12),
///                 Expanded(
///                   flex: 2,
///                   child: PrimaryButton(
///                     onPressed: () => generateMessage(),
///                     text: '메시지 ㄱㄱ',
///                   ),
///                 ),
///               ],
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```

library;

// 🎨 Core (색상과 텍스트 스타일도 함께 제공)
export '../../core/app_colors.dart';
export '../../core/app_spacing.dart';
export '../../core/app_text_styles.dart';
// 🎭 Modal Functions (18세 서현 페르소나 모달 시스템)
export '../../utils/custom_modal.dart';
export 'common/code_copy_card.dart';
// 🧩 Common Components
export 'common/component_card.dart';
export 'common/dashboard_header.dart';
export 'common/dashed_divider.dart';
export 'common/menu_item.dart';
export 'common/parameter_card.dart';
// 🔘 Common Buttons
export 'common/primary_button.dart';
export 'common/scenario_card.dart';
export 'common/secondary_button.dart';
export 'common/section_card.dart';
export 'specific/charts/bar_chart.dart' hide LegendPosition;
export 'specific/charts/donut_chart.dart' hide LegendPosition;
// 📊 Charts
export 'specific/charts/gauge_chart.dart' hide LegendPosition;
export 'specific/charts/heatmap_chart.dart' hide LegendPosition;
export 'specific/charts/line_chart.dart' hide LegendPosition;
export 'specific/charts/pie_chart.dart' hide LegendPosition;
export 'specific/charts/radar_chart.dart' hide LegendPosition;
export 'specific/charts/semicircle_gauge_chart.dart';
// 🎨 Feedback Components
export 'specific/feedback/generating_progress.dart';
export 'specific/feedback/heart_spinner.dart';
export 'specific/feedback/pulsating_dot.dart';
export 'specific/feedback/skeleton_ui.dart';
export 'specific/feedback/toast_notification.dart';
export 'specific/forms/custom_slider.dart';
export 'specific/forms/custom_toggle_switch.dart';
// 📝 Form Inputs
export 'specific/forms/floating_label_textfield.dart';
export 'specific/forms/tag_input_field.dart';
// 🚀 Navigation
export 'specific/navigation/bottom_navigation_bar.dart';
