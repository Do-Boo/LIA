# LIA 프로젝트 `lib` 폴더 구조

이 문서는 LIA 프로젝트의 `lib` 폴더 내 파일 구조와 각 파일의 역할을 설명합니다.

-   **`main.dart`**: 앱의 최상위 진입점으로, `MyApp` 위젯을 실행하고 앱의 기본 테마와 라우팅을 설정합니다.

-   **`core/`**: 앱의 핵심 로직과 디자인 시스템의 기반을 담당하는 파일들이 위치합니다.
    -   **`app_colors.dart`**: 앱 전체에서 사용되는 색상 팔레트와 그라데이션을 정의합니다.
    -   **`app_text_styles.dart`**: 앱의 타이포그래피 시스템과 모든 `TextStyle`을 정의합니다.

-   **`services/`**: 외부 데이터나 서비스와의 연동을 처리합니다.
    -   **`analysis_data_service.dart`**: 샘플 분석 데이터(`analysis_sample.json`)를 로드하고 파싱하는 서비스를 제공합니다.

-   **`utils/`**: 앱 전반에서 사용되는 유틸리티 함수들을 포함합니다.
    -   **`custom_modal.dart`**: 앱의 디자인 시스템에 맞는 커스텀 모달 다이얼로그(알림, 확인)를 표시하는 함수를 제공합니다.

-   **`presentation/`**: 앱의 UI와 관련된 모든 파일을 포함합니다.
    -   **`screens/`**: 앱의 각 화면을 구성하는 메인 위젯 파일들이 위치합니다.
        -   **`main_screen.dart`**: 앱의 메인 대시보드 화면입니다.
        -   **`ai_message_screen.dart`**: AI를 통해 메시지를 생성하는 화면입니다.
        -   **`chart_demo_screen.dart`**: 모든 차트 위젯의 사용 예시를 보여주는 데모 화면입니다.
        -   **`coaching_center_screen.dart`**: 메시지 작성 가이드와 팁을 제공하는 코칭센터 화면입니다.
        -   **`design_guide_screen.dart`**: 앱의 모든 UI 컴포넌트를 보여주는 디자인 시스템 가이드 화면입니다.
        -   **`analyzed_people_screen.dart`**: 분석된 사람들의 목록을 보여주고, 각 사람과 가상 채팅을 시작할 수 있는 화면입니다.
        -   **`main_layout.dart`**: 하단 네비게이션 바를 포함하는 앱의 기본 레이아웃 구조를 정의합니다.
        -   **`my_screen.dart`**: 프로필 및 앱 설정을 관리하는 'MY' 화면입니다.

    -   **`widgets/`**: 화면을 구성하는 재사용 가능한 위젯들이 위치합니다.
        -   **`lia_widgets.dart`**: 앱의 모든 공용 위젯을 한 번에 내보내는(export) barrel 파일로, 위젯 import를 간편하게 해줍니다.
        -   **`common/`**: 여러 화면에서 범용적으로 사용되는 기본 위젯들입니다.
            -   **`code_copy_card.dart`**: 코드 스니펫을 보여주고 복사하는 기능을 제공하는 카드 위젯입니다.
            -   **`component_card.dart`**: 디자인 가이드 등에서 각 UI 컴포넌트를 감싸는 공용 카드입니다.
            -   **`dashed_divider.dart`**: 제목과 내용 사이에 사용되는 점선 구분선입니다.
            -   **`parameter_card.dart`**: 위젯의 매개변수(parameter) 정보를 설명하는 카드입니다.
            -   **`primary_button.dart`**: 앱의 주요 액션을 위한 프라이머리 버튼입니다.
            -   **`scenario_card.dart`**: 위젯의 실제 사용 시나리오를 설명하는 카드입니다.
            -   **`secondary_button.dart`**: 앱의 보조 액션을 위한 세컨더리 버튼입니다.
        -   **`specific/`**: 특정 기능이나 화면에 종속된 위젯들입니다.
            -   **`charts/`**: 데이터 시각화를 위한 다양한 차트 위젯을 포함합니다.
                -   **`bar_chart.dart`**: 막대 차트 위젯입니다.
                -   **`chart_common.dart`**: 모든 차트에서 공용으로 사용하는 `LegendPosition` 열거형을 정의합니다.
                -   **`donut_chart.dart`**: 도넛 차트 위젯입니다.
                -   **`gauge_chart.dart`**: 원형 게이지 차트 위젯입니다.
                -   **`heatmap_chart.dart`**: 히트맵 차트 위젯입니다.
                -   **`line_chart.dart`**: 라인 차트 위젯입니다.
                -   **`pie_chart.dart`**: 파이 차트 위젯입니다.
                -   **`radar_chart.dart`**: 레이더(방사형) 차트 위젯입니다.
                -   **`semicircle_gauge_chart.dart`**: 반원 게이지 차트 위젯입니다.
            -   **`virtual_chat_view.dart`**: 특정 분석된 사람과의 가상 채팅 UI와 로직을 담당하는 위젯입니다.
            -   **`feedback/`**: 사용자에게 상태나 피드백을 제공하는 위젯들입니다.
                -   **`generating_progress.dart`**: AI 메시지 생성 진행 상태를 단계별로 보여줍니다.
                -   **`heart_spinner.dart`**: 하트 모양의 로딩 스피너 애니메이션입니다.
                -   **`pulsating_dot.dart`**: 실시간 상태를 나타내는 맥박 점 애니메이션입니다.
                -   **`skeleton_ui.dart`**: 콘텐츠 로딩 중에 표시되는 스켈레톤 UI입니다.
                -   **`toast_notification.dart`**: 화면 상단에 나타나는 토스트 알림 메시지입니다.
            -   **`forms/`**: 데이터 입력을 위한 폼 관련 위젯들입니다.
                -   **`custom_date_picker.dart`**: 커스텀 디자인의 날짜 선택기입니다.
                -   **`custom_date_range_picker.dart`**: 커스텀 디자인의 날짜 범위 선택기입니다.
                -   **`custom_slider.dart`**: 커스텀 디자인의 슬라이더입니다.
                -   **`custom_toggle_switch.dart`**: 커스텀 디자인의 토글 스위치입니다.
                -   **`floating_label_textfield.dart`**: 플로팅 라벨이 적용된 텍스트 입력 필드입니다.
                -   **`tag_input_field.dart`**: 해시태그처럼 여러 태그를 입력하고 관리하는 필드입니다.
            -   **`headers/`**: 화면 상단에 사용되는 헤더 위젯입니다.
                -   **`main_header.dart`**: 메인 화면의 상단 헤더입니다.
            -   **`navigation/`**: 앱의 네비게이션(화면 이동)과 관련된 위젯들입니다.
                -   **`bottom_navigation_bar.dart`**: 앱의 메인 하단 네비게이션 바입니다.
                -   **`custom_tab_bar.dart`**: 화면 내에서 콘텐츠를 구분하는 탭 바입니다.
                -   **`custom_tab_bar_view.dart`**: `CustomTabBar`와 함께 사용되는 탭 콘텐츠 뷰입니다.
