// File: lib/presentation/screens/chart_demo_screen.dart

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/lia_widgets.dart';

/// 모든 차트 위젯을 데모하는 화면
///
/// 통일된 차트 인터페이스를 보여주며, 각 차트의 JSON 데이터 형식,
/// 범례 온/오프 기능, title 파라미터 등을 데모합니다.
class ChartDemoScreen extends StatefulWidget {
  const ChartDemoScreen({super.key});

  @override
  State<ChartDemoScreen> createState() => _ChartDemoScreenState();
}

class _ChartDemoScreenState extends State<ChartDemoScreen> {
  bool _showLegends = true;

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0,
            vertical: 12,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpacing.gapV24,

                // 대시보드 헤더
                DashboardHeader(
                  title: 'LIA 차트 데모',
                  subtitle: '다양한 차트 위젯의 사용법과 JSON 데이터 형식을 확인하세요',
                  icon: HugeIcons.strokeRoundedAnalytics01,
                  actions: [
                    DashboardAction(
                      title: _showLegends ? '범례 숨기기' : '범례 보이기',
                      icon: _showLegends
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOff,
                      onTap: () {
                        setState(() {
                          _showLegends = !_showLegends;
                        });
                      },
                    ),
                  ],
                ),

                AppSpacing.gapV24,

                // 범례 토글 설명
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedInformationCircle,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      AppSpacing.gapH8,
                      Expanded(
                        child: Text(
                          '상단 헤더의 범례 토글 버튼으로 모든 차트의 범례를 켜거나 끌 수 있습니다.',
                          style: AppTextStyles.cardDescription.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.gapV24,

                // 1. 바 차트 (Bar Chart)
                SectionCard(
                  number: '1',
                  title: '바 차트 (Bar Chart)',
                  description: '카테고리별 데이터를 막대 형태로 표시',
                  useNumberBadge: true,
                  child: BarChart(
                    title: '일별 메시지 작성 수',
                    data: [
                      {'label': '월', 'value': 12},
                      {'label': '화', 'value': 19},
                      {'label': '수', 'value': 15},
                      {'label': '목', 'value': 25},
                      {'label': '금', 'value': 22},
                      {'label': '토', 'value': 18},
                      {'label': '일', 'value': 8},
                    ],
                    showLegend: _showLegends,
                  ),
                ),

                AppSpacing.gapV24,

                // 2. 도넛 차트 (Donut Chart)
                SectionCard(
                  number: '2',
                  title: '도넛 차트 (Donut Chart)',
                  description: '중앙에 구멍이 있는 원형 차트로 비율 표시',
                  useNumberBadge: true,
                  child: DonutChart(
                    title: '메시지 반응 분석',
                    data: [
                      {'label': '즉시 답장', 'value': 45, 'color': 0xFF6C5CE7},
                      {'label': '늦은 답장', 'value': 30, 'color': 0xFFFF6B6B},
                      {'label': '읽음 무시', 'value': 15, 'color': 0xFFFFD93D},
                      {'label': '미확인', 'value': 10, 'color': 0xFF6BCF7F},
                    ],
                    showLegend: _showLegends,
                  ),
                ),

                AppSpacing.gapV24,

                // 3. 게이지 차트 (Gauge Chart)
                SectionCard(
                  number: '3',
                  title: '게이지 차트 (Gauge Chart)',
                  description: '진행률이나 수치를 원형 게이지로 표시',
                  useNumberBadge: true,
                  child: GaugeChart(
                    title: '전체 호감도 점수',
                    data: {
                      'value': 78,
                      'maxValue': 100,
                      'unit': '%',
                      'primaryColor': 0xFF6C5CE7,
                      'backgroundColor': 0xFFEEEEEE,
                    },
                    showLegend: _showLegends,
                  ),
                ),

                AppSpacing.gapV24,

                // 4. 라인 차트 (Line Chart)
                SectionCard(
                  number: '4',
                  title: '라인 차트 (Line Chart)',
                  description: '시간에 따른 데이터 변화를 선으로 표시',
                  useNumberBadge: true,
                  child: LineChart(
                    title: '주간 호감도 변화',
                    data: [
                      {'label': '월', 'value': 65},
                      {'label': '화', 'value': 72},
                      {'label': '수', 'value': 78},
                      {'label': '목', 'value': 85},
                      {'label': '금', 'value': 90},
                      {'label': '토', 'value': 88},
                      {'label': '일', 'value': 92},
                    ],
                    showLegend: _showLegends,
                  ),
                ),

                AppSpacing.gapV24,

                // 5. 파이 차트 (Pie Chart)
                SectionCard(
                  number: '5',
                  title: '파이 차트 (Pie Chart)',
                  description: '카테고리별 비율을 원형으로 표시, 터치 상호작용 지원',
                  useNumberBadge: true,
                  child: PieChart(
                    title: '메시지 스타일 분석',
                    data: [
                      {
                        'label': '센스있는 답장',
                        'value': 45,
                        'color': 0xFF6C5CE7,
                        'description': '센스있는 답장은 상대방의 호감을 사는 가장 효과적인 방법이에요.',
                      },
                      {
                        'label': '유머러스한 농담',
                        'value': 30,
                        'color': 0xFFFF6B6B,
                        'description': '유머러스한 농담은 대화 분위기를 가볍게 만들어줘요.',
                      },
                      {
                        'label': '진솔한 질문',
                        'value': 15,
                        'color': 0xFFFFD93D,
                        'description': '진솔한 질문은 깊은 관계를 만드는 데 도움이 돼요.',
                      },
                      {
                        'label': '기타',
                        'value': 10,
                        'color': 0xFF6BCF7F,
                        'description': '다양한 스타일을 시도하고 있네요!',
                      },
                    ],
                    showLegend: _showLegends,
                  ),
                ),

                AppSpacing.gapV24,

                // 6. 반원 게이지 차트 (Semicircle Gauge Chart)
                SectionCard(
                  number: '6',
                  title: '반원 게이지 차트 (Semicircle Gauge Chart)',
                  description: '공간 효율적인 반원 형태로 진행률 표시',
                  useNumberBadge: true,
                  child: SemicircleGaugeChart(
                    title: '현재 호감도',
                    data: {'label': '호감도', 'value': 75},
                    showLegend: _showLegends,
                  ),
                ),

                AppSpacing.gapV24,

                // 7. 레이더 차트 (Radar Chart)
                SectionCard(
                  number: '7',
                  title: '레이더 차트 (Radar Chart)',
                  description: '다차원 데이터를 방사형으로 시각화, 성격 분석에 활용',
                  useNumberBadge: true,
                  child: const RadarChart(
                    title: 'MBTI 성격 분석',
                    data: [
                      {'label': '외향성', 'value': 80},
                      {'label': '감각', 'value': 60},
                      {'label': '사고', 'value': 70},
                      {'label': '판단', 'value': 85},
                      {'label': '개방성', 'value': 75},
                    ],
                    showLegend: false,
                  ),
                ),

                AppSpacing.gapV24,

                // 8. 히트맵 차트 (Heatmap Chart)
                SectionCard(
                  number: '8',
                  title: '히트맵 차트 (Heatmap Chart)',
                  description: '시간대별 활동 패턴을 색상 강도로 표시',
                  useNumberBadge: true,
                  child: const HeatmapChart(
                    title: '시간대별 메시지 활동',
                    titleIcon: HugeIcons.strokeRoundedCalendar03,
                    data: [
                      [0, 1, 1, 0, 0, 0, 0],
                      [1, 1, 2, 1, 0, 0, 0],
                      [2, 3, 2, 1, 0, 0, 1],
                      [1, 2, 3, 2, 1, 0, 1],
                      [0, 1, 2, 3, 2, 1, 0],
                      [0, 0, 1, 2, 2, 1, 0],
                      [0, 0, 0, 1, 1, 1, 0],
                    ],
                    showLegend: false,
                  ),
                ),

                AppSpacing.gapV24,

                // JSON 데이터 형식 안내
                SectionCard(
                  number: '9',
                  title: 'JSON 데이터 형식',
                  description: '차트에서 사용하는 표준 JSON 데이터 구조',
                  useNumberBadge: true,
                  icon: HugeIcons.strokeRoundedCode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCodeExample(
                        '기본 데이터 형식',
                        '''[{"label": "월", "value": 12}, {"label": "화", "value": 19}]''',
                      ),
                      AppSpacing.gapV16,
                      _buildCodeExample(
                        '색상 포함 데이터',
                        '''[{"label": "즉시 답장", "value": 45, "color": 0xFF6C5CE7}]''',
                      ),
                      AppSpacing.gapV16,
                      _buildCodeExample(
                        '게이지 차트 데이터',
                        '''{"value": 78, "maxValue": 100, "unit": "%"}''',
                      ),
                    ],
                  ),
                ),

                AppSpacing.gapV24,

                // 사용법 안내
                SectionCard(
                  number: '10',
                  title: '사용법 안내',
                  description: '차트 위젯 사용 시 참고사항',
                  useNumberBadge: true,
                  icon: HugeIcons.strokeRoundedBookOpen01,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUsageItem(
                        '1. 범례 제어',
                        'showLegend: true/false - 차트별로 범례 표시 여부를 설정할 수 있습니다.',
                      ),
                      _buildUsageItem(
                        '2. 차트 제목',
                        'title: "제목" - 모든 차트에 title 파라미터로 제목을 설정할 수 있습니다.',
                      ),
                      _buildUsageItem(
                        '3. 반응형 크기',
                        '차트들은 Container 너비에 따라 자동으로 크기가 조절됩니다.',
                      ),
                      _buildUsageItem(
                        '4. JSON 데이터',
                        'Chart(data: jsonData) - JSON 형식의 데이터를 전달할 수 있습니다.',
                      ),
                      _buildUsageItem(
                        '5. 상호작용',
                        '파이 차트와 히트맵 차트는 터치 상호작용을 지원합니다.',
                      ),
                    ],
                  ),
                ),

                AppSpacing.gapV32,
              ],
            ),
          ),
        ),
      ),
    );

  Widget _buildCodeExample(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapV8,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Text(
            code,
            style: AppTextStyles.cardDescription.copyWith(
              fontFamily: 'monospace',
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsageItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.accent,
                    fontSize: 14,
                  ),
                ),
                AppSpacing.gapV4,
                Text(
                  description,
                  style: AppTextStyles.cardDescription,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
