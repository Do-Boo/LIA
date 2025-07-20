
# LIA 프로젝트 리팩토링 계획

이 문서는 LIA 프로젝트의 `lib` 폴더 전체 코드를 분석하고, 코드 품질, 일관성, 유지보수성을 향상시키기 위한 리팩토링 계획을 제안합니다.

## 1. 전반적인 리팩토링 방향

- **일관성 강화**: `main_screen.dart`의 성공적인 UI/UX 패턴(번호가 매겨진 섹션, 일관된 카드 디자인 등)을 다른 화면(`ai_message_screen.dart`, `coaching_center_screen.dart`, `my_screen.dart`)에 확대 적용하여 앱 전체의 사용자 경험을 통일합니다.
- **위젯 재사용성 증대**: 여러 화면에서 중복으로 사용되는 UI 요소(예: 섹션 헤더, 카드 컨테이너)를 공용 위젯으로 추출하여 코드 중복을 줄이고 재사용성을 높입니다.
- **상태 관리 개선**: `StatefulWidget` 내에 혼재된 UI 로직과 비즈니스 로직을 분리하여 가독성과 테스트 용이성을 높입니다. (장기적으로 BLoC, Riverpod 등 상태 관리 라이브러리 도입 고려)
- **네이밍 및 주석 개선**: 파일, 클래스, 변수명의 역할을 명확히 하고, 복잡한 로직에는 `왜`에 초점을 맞춘 주석을 추가하여 코드 이해도를 높입니다.
- **디자인 시스템 정제**: `app_colors.dart`와 `app_text_styles.dart`에 중복되거나 사용되지 않는 스타일을 정리하고, 네이밍을 통일하여 디자인 시스템의 일관성을 강화합니다.

## 2. 파일별 리팩토링 계획

### 📄 `main.dart`
- **(현상)** 라우팅 로직이 `main.dart`에 직접 정의되어 있어 앱 규모가 커질수록 관리가 어려워집니다.
- **(계획)**
    - **라우팅 분리**: 별도의 `app_router.dart` 파일을 생성하여 모든 라우팅 로직을 중앙에서 관리합니다. (GoRouter 패키지 도입 고려)
    - **테마 분리**: `ThemeData` 설정을 별도의 `app_theme.dart` 파일로 분리하여 테마 관련 코드를 체계적으로 관리합니다.

### 📂 `core/`
- **📄 `app_colors.dart`**
    - **(현상)** `charcoal`, `primaryText`, `textPrimary` 등 의미가 중복되는 색상 상수가 존재합니다.
    - **(계획)**
        - **중복 제거**: 의미가 같은 색상 상수를 하나로 통일하고, 가장 명확한 이름(예: `textPrimary`)으로 단일화합니다.
        - **사용처 분석**: 각 색상이 실제 UI에서 어떻게 사용되는지 추적하여 사용되지 않는 색상을 제거하거나, 용도에 맞는 이름으로 변경합니다. (예: `blue`, `green`을 `info`, `success` 등으로 명확화)
- **📄 `app_text_styles.dart`**
    - **(현상)** `body`, `body1`, `body2`, `bodyMedium` 등 유사한 텍스트 스타일이 많아 혼란을 유발합니다.
    - **(계획)**
        - **스타일 통합**: 유사한 스타일을 통합하고, Material Design의 타입 시스템(예: `bodyLarge`, `bodyMedium`, `bodySmall`)을 참고하여 명확한 위계를 가진 타이포그래피 시스템으로 재정의합니다.
        - **네이밍 개선**: `h1`, `h2`와 같은 이름 대신 `headlineLarge`, `headlineMedium` 등 역할 기반의 이름으로 변경하여 가독성을 높입니다.

### 📂 `presentation/screens/`
- **📄 `main_screen.dart`, `ai_message_screen.dart`, `coaching_center_screen.dart`, `my_screen.dart`**
    - **(현상)** 각 화면의 전체적인 레이아웃과 섹션 구성 방식이 다릅니다. `main_screen.dart`의 번호 매겨진 섹션 스타일이 사용자에게 좋은 경험을 제공하고 있습니다.
    - **(계획)**
        - **공용 섹션 위젯 추출**: `_buildChartDemoSection`과 같은 섹션 빌더 위젯을 `common/section_card.dart`와 같은 공용 위젯으로 추출하여 모든 화면에서 재사용합니다.
        - **UI 패턴 통일**: `main_screen.dart`의 대시보드 헤더, 번호 매겨진 섹션 카드 UI 패턴을 다른 주요 화면에 일관되게 적용하여 통일성을 부여합니다.
- **📄 `analyzed_people_screen.dart`**
    - **(현상)** 데이터 모델(`AnalyzedPerson`, `ChatMessage`)이 화면 파일 내에 직접 정의되어 있습니다.
    - **(계획)**
        - **모델 분리**: `models/` 디렉토리를 생성하고, `analyzed_person.dart`, `chat_message.dart` 파일로 모델 클래스를 분리하여 계층 구조를 개선합니다.
- **📄 `design_guide_screen.dart`**
    - **(현상)** 위젯별로 데모를 위한 `Card` 위젯이 반복적으로 사용되고 있습니다.
    - **(계획)**
        - **`ComponentCard` 재사용**: `common/component_card.dart`를 적극 활용하여 코드 중복을 줄이고, 디자인 가이드의 일관성을 높입니다.
        - **`code_copy_card.dart` 위치 이동**: `specific` 폴더에 있는 `code_copy_card.dart`는 여러 곳에서 재사용될 수 있으므로 `common` 폴더로 이동합니다.

### 📂 `presentation/widgets/`
- **📄 `lia_widgets.dart` (Barrel File)**
    - **(현상)** `export` 경로가 일부 누락되거나, 불필요한 위젯이 포함될 수 있습니다.
    - **(계획)**
        - **내보내기 최적화**: `lib` 폴더 전체를 분석하여 모든 공용 위젯이 `lia_widgets.dart`를 통해 `export` 되도록 경로를 최적화하고, 내부에서만 사용되는 위젯은 제외합니다.
- **📂 `common/`**
    - **(계획)**
        - **`SectionCard` 추가**: `main_screen.dart`의 `_buildChartDemoSection`을 기반으로 하는 공용 `SectionCard` 위젯을 추가합니다.
        - **`DashboardHeader` 추가**: `main_screen.dart`의 `_buildDashboardHeader`를 기반으로 하는 공용 `DashboardHeader` 위젯을 추가하여 다른 화면에서도 재사용할 수 있도록 합니다.
- **📂 `specific/`**
    - **(현상)** `code_copy_card.dart`가 `specific`에 위치해 있습니다.
    - **(계획)**
        - **`code_copy_card.dart` 이동**: 해당 파일은 범용적으로 사용될 수 있으므로 `common` 폴더로 이동합니다.

### 📂 `services/`
- **📄 `analysis_data_service.dart`**
    - **(현상)** 데이터 모델 클래스(`AnalysisData`, `EmotionDataPoint` 등)가 서비스 파일 내에 함께 정의되어 있습니다.
    - **(계획)**
        - **모델 분리**: `models/` 디렉토리를 생성하고, 각 데이터 모델을 별도의 파일로 분리하여 서비스 로직과 데이터 구조를 명확히 분리합니다.

## 3. 리팩토링 실행 단계

1. **1단계 (구조 개선)**:
    - `models/` 디렉토리 생성 및 데이터 모델 클래스 파일 분리 (`analyzed_people_screen.dart`, `analysis_data_service.dart`).
    - `code_copy_card.dart`를 `common` 폴더로 이동.
    - 라우팅 및 테마 로직을 별도 파일로 분리 (`app_router.dart`, `app_theme.dart`).

2. **2단계 (공용 위젯 추출)**:
    - `main_screen.dart`의 UI 패턴을 기반으로 `SectionCard`, `DashboardHeader` 등 공용 위젯을 `common` 폴더에 생성.

3. **3단계 (UI 일관성 적용)**:
    - `ai_message_screen.dart`, `coaching_center_screen.dart`, `my_screen.dart`에 새로 만든 공용 위젯을 적용하여 UI를 통일.

4. **4단계 (디자인 시스템 정제)**:
    - `app_colors.dart`와 `app_text_styles.dart`의 중복을 제거하고 네이밍을 개선.

5. **5단계 (최종 검토 및 최적화)**:
    - `lia_widgets.dart`의 `export` 목록을 최종 검토.
    - 전체 코드에 대해 `flutter analyze`를 실행하고 경고 및 제안 사항 수정.

이 계획을 통해 LIA 프로젝트의 코드 베이스를 더욱 견고하고 확장 가능하게 만들 수 있을 것으로 기대합니다.
