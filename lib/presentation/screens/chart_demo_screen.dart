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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIA 차트 데모'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.charcoal,
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: _showLegends
                  ? HugeIcons.strokeRoundedView
                  : HugeIcons.strokeRoundedViewOff,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _showLegends = !_showLegends;
              });
            },
            tooltip: _showLegends ? '범례 숨기기' : '범례 보이기',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '우측 상단 눈 아이콘을 클릭하여 모든 차트의 범례를 켜거나 끌 수 있습니다.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 1. 바 차트 (Bar Chart)
            _buildChartSection(
              title: '1. 바 차트 (Bar Chart)',
              description: '카테고리별 데이터를 막대 형태로 표시',
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

            const SizedBox(height: 32),

            // 2. 도넛 차트 (Donut Chart)
            _buildChartSection(
              title: '2. 도넛 차트 (Donut Chart)',
              description: '중앙에 구멍이 있는 원형 차트로 비율 표시',
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

            const SizedBox(height: 32),

            // 3. 게이지 차트 (Gauge Chart)
            _buildChartSection(
              title: '3. 게이지 차트 (Gauge Chart)',
              description: '진행률이나 수치를 원형 게이지로 표시',
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

            const SizedBox(height: 32),

            // 4. 라인 차트 (Line Chart)
            _buildChartSection(
              title: '4. 라인 차트 (Line Chart)',
              description: '시간에 따른 데이터 변화를 선으로 표시',
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

            const SizedBox(height: 32),

            // 5. 파이 차트 (Pie Chart)
            _buildChartSection(
              title: '5. 파이 차트 (Pie Chart)',
              description: '카테고리별 비율을 원형으로 표시, 터치 상호작용 지원',
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

            const SizedBox(height: 32),

            // 6. 반원 게이지 차트 (Semicircle Gauge Chart)
            _buildChartSection(
              title: '6. 반원 게이지 차트 (Semicircle Gauge Chart)',
              description: '공간 효율적인 반원 형태로 진행률 표시',
              child: SemicircleGaugeChart(
                title: '현재 호감도',
                data: {'label': '호감도', 'value': 75},
                showLegend: _showLegends,
              ),
            ),

            const SizedBox(height: 32),

            // 7. 레이더 차트 (Radar Chart)
            _buildChartSection(
              title: '7. 레이더 차트 (Radar Chart)',
              description: '다차원 데이터를 방사형으로 시각화, 성격 분석에 활용',
              child: RadarChart(
                title: 'MBTI 성격 분석',
                data: {
                  'name': '성격 분석',
                  'data': [
                    {'label': '외향성', 'value': 80},
                    {'label': '감각', 'value': 60},
                    {'label': '사고', 'value': 70},
                    {'label': '판단', 'value': 85},
                    {'label': '개방성', 'value': 75},
                  ],
                },
                showLegend: _showLegends,
              ),
            ),

            const SizedBox(height: 32),

            // 8. 히트맵 차트 (Heatmap Chart)
            _buildChartSection(
              title: '8. 히트맵 차트 (Heatmap Chart)',
              description: '시간대별 활동 패턴을 색상 강도로 표시',
              child: HeatmapChart(
                title: '시간대별 메시지 활동',
                titleIcon: HugeIcons.strokeRoundedCalendar03,
                data: [
                  {'row': 0, 'col': 0, 'value': 5},
                  {'row': 0, 'col': 1, 'value': 8},
                  {'row': 0, 'col': 2, 'value': 12},
                  {'row': 0, 'col': 3, 'value': 15},
                  {'row': 1, 'col': 0, 'value': 7},
                  {'row': 1, 'col': 1, 'value': 10},
                  {'row': 1, 'col': 2, 'value': 18},
                  {'row': 1, 'col': 3, 'value': 20},
                  {'row': 2, 'col': 0, 'value': 6},
                  {'row': 2, 'col': 1, 'value': 12},
                  {'row': 2, 'col': 2, 'value': 22},
                  {'row': 2, 'col': 3, 'value': 25},
                ],
                showLegend: _showLegends,
              ),
            ),

            const SizedBox(height: 32),

            // JSON 데이터 형식 설명
            _buildJsonFormatSection(),

            const SizedBox(height: 32),

            // 사용법 안내
            _buildUsageGuideSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildJsonFormatSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedCode,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'JSON 데이터 형식',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '모든 차트는 JSON 형식의 데이터를 지원합니다:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• 바 차트: [{"label": "월", "value": 12}, ...]',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• 파이 차트: [{"label": "항목", "value": 45, "color": 0xFF6C5CE7, "description": "설명"}, ...]',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• 게이지 차트: {"value": 78, "maxValue": 100, "unit": "%", "primaryColor": 0xFF6C5CE7}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• 히트맵 차트: [{"x": 0, "y": 0, "value": 10, "tooltip": "설명"}, ...]',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageGuideSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedBookOpen01,
                color: AppColors.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '사용법 안내',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildUsageItem('1. 기본 사용법', 'Chart() - 기본 데이터와 범례가 표시됩니다.'),
          _buildUsageItem(
            '2. 제목 설정',
            'Chart(title: "차트 제목") - 차트 상단에 제목이 표시됩니다.',
          ),
          _buildUsageItem(
            '3. 범례 제어',
            'Chart(showLegend: false) - 범례를 숨길 수 있습니다.',
          ),
          _buildUsageItem(
            '4. JSON 데이터',
            'Chart(data: jsonData) - JSON 형식의 데이터를 전달할 수 있습니다.',
          ),
          _buildUsageItem('5. 상호작용', '파이 차트와 히트맵 차트는 터치 상호작용을 지원합니다.'),
        ],
      ),
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
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
