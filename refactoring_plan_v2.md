
# LIA 프로젝트 리팩토링 계획 v2

이 문서는 LIA 프로젝트의 `lib` 폴더 전체 코드를 재분석하고, 코드 품질, 일관성, 유지보수성을 한 단계 더 향상시키기 위한 구체적인 리팩토링 계획을 제안합니다.

## 1. 핵심 개선 목표

- **코드 중복 완전 제거**: 반복되는 UI 패턴을 공용 위젯으로 추출하여 재사용성을 극대화합니다.
- **디자인 시스템 완성**: 색상, 타이포그래피, 간격 시스템을 최종적으로 다듬어 일관성을 확보합니다.
- **안정적인 아키텍처 구축**: 모델 분리를 완료하고, 상태 관리 및 오류 처리 방식을 개선하여 앱의 안정성을 높입니다.

## 2. 상세 리팩토링 계획

### 📂 `core/` - 디자인 시스템 정제

- **📄 `app_colors.dart`**
    - **(문제점)** `textSecondary`와 `accessibleSecondaryText`의 명도 대비가 여전히 낮아 가독성 문제가 존재하며, `purple`, `orange`, `pink` 등은 차트에서만 제한적으로 사용됩니다.
    - **(개선안)**
        - **가독성 향상**: `textSecondary`와 `accessibleSecondaryText`를 WCAG AA 표준을 충족하는 단일 색상(`0xFF666666`)으로 통합합니다.
        - **중복 제거**: `charcoal`, `primaryText` 별칭을 제거하고 `textPrimary`로 통일합니다.
        - **차트 색상 분리**: `purple`, `orange`, `pink`를 `const List<Color> chartColors`와 같이 차트 전용 팔레트로 분리하여 `AppColors`의 역할을 명확히 합니다.

- **📄 `app_text_styles.dart`**
    - **(문제점)** `body`, `body1`, `body2` 등 유사한 스타일이 여전히 남아있습니다.
    - **(개선안)**
        - **타입 시스템 재정의**: `bodyLarge`(16px), `bodyMedium`(14px), `bodySmall`(12px)과 같이 Material Design을 참고하여 명확한 위계로 스타일을 재정의하고, 불필요한 스타일을 제거합니다.

- **📄 `app_spacing.dart`**
    - **(문제점)** `md2`(20px)와 같이 4px, 8px 배수가 아닌 예외적인 상수가 존재합니다.
    - **(개선안)**
        - **간격 시스템 통일**: 모든 간격 단위를 4px 또는 8px 배수로 통일하여 디자인의 일관성을 강화합니다.

### 📂 `data/` & `services/` - 아키텍처 안정화

- **(문제점)** `analyzed_people_screen.dart`, `ai_message_screen.dart` 등 여러 화면에 모델 클래스가 아직 남아있습니다.
- **(개선안)**
    - **모델 클래스 완전 분리**: `AnalyzedPerson`, `ChatMessage`, `ToneOption`, `CategoryOption` 등 모든 모델 클래스를 `data/models/` 디렉토리로 즉시 이동시킵니다.
- **(문제점)** `AnalysisDataService`의 오류 처리가 `try-catch`와 `print`문으로만 되어 있어 UI 레이어에서 대응하기 어렵습니다.
- **(개선안)**
    - **명시적 오류 처리**: `Result` 타입이나 `Either`를 도입하여 서비스 계층의 모든 메서드가 성공과 실패 케이스를 명확하게 반환하도록 구조를 변경합니다.

### 📂 `presentation/` - UI/UX 통일 및 재사용성 극대화

- **(문제점)** `DashboardHeader`, `SectionCard`, `MenuItemWidget` 등 여러 화면에서 반복적으로 사용되는 UI 패턴이 공용 위젯으로 추출되지 않았습니다.
- **(개선안)**
    - **공용 위젯 추출**: `presentation/widgets/common/` 디렉토리 아래에 `dashboard_header.dart`, `section_card.dart`, `menu_item_widget.dart` 파일을 생성하고, 반복되는 UI 코드를 이 위젯들로 이전합니다.
    - **공용 위젯 적용**: 추출된 공용 위젯을 모든 관련 화면(`main_screen`, `ai_message_screen`, `coaching_center_screen`, `my_screen` 등)에 적용하여 코드 중복을 완전히 제거하고 UI를 통일합니다.
- **(문제점)** `_isAnalyzing` 상태가 `MainLayout`과 `MainScreen`에 중복으로 존재하며, 콜백으로 동기화되어 구조가 복잡합니다.
- **(개선안)**
    - **상태 관리 중앙화**: `Riverpod` 또는 `Provider`를 도입하여 `isAnalyzing`과 같은 앱 전역 상태를 중앙에서 관리합니다. 이를 통해 위젯 간의 강한 의존성을 제거하고 테스트 용이성을 높입니다.
- **(문제점)** "AI 메시지 생성", "분석 히스토리" 등 모든 UI 텍스트가 코드에 하드코딩되어 있습니다.
- **(개선안)**
    - **문자열 리소스 분리**: `l10n` 디렉토리와 `.arb` 파일을 생성하여 모든 문자열을 외부 리소스로 분리합니다. 이는 향후 다국어 지원을 용이하게 하고 텍스트 관리를 중앙화합니다.

## 3. 리팩토링 실행 계획 (v2)

### 🥇 **1단계: 구조 개선 (즉시 실행)**
1.  **모델 클래스 완전 분리**: `analyzed_people_screen.dart`, `ai_message_screen.dart` 등에 남아있는 모든 모델 클래스를 `data/models/`로 이동.
2.  **디자인 시스템 정제**: `app_colors.dart`와 `app_text_styles.dart`의 중복 제거 및 가독성 개선.
3.  **`app_spacing.dart` 통일**: 4px/8px 배수 기반으로 간격 시스템 정리.

### 🥈 **2단계: 공용 위젯화 및 UI 통일 (1주일 내)**
1.  **공용 위젯 생성**: `DashboardHeader`, `SectionCard`, `MenuItemWidget` 위젯을 `common` 디렉토리에 생성.
2.  **공용 위젯 적용**: 모든 화면에 생성된 공용 위젯을 적용하여 중복 코드 제거 및 UI 패턴 통일.
3.  **라우팅 시스템 개선**: `app_router.dart`를 통해 라우팅 로직을 중앙 관리하고, 경로는 상수로 관리.

### 🥉 **3단계: 아키텍처 고도화 (장기적 관점)**
1.  **상태 관리 도입**: `Riverpod` 또는 `Provider`를 도입하여 앱 전역 상태 관리.
2.  **서비스 레이어 개선**: `Result` 타입을 사용한 명시적 오류 처리 도입.
3.  **다국어 지원 준비**: `l10n`을 통한 문자열 리소스 분리.
4.  **차트 위젯 추상화**: `BaseChart` 클래스를 도입하여 차트 관련 코드 중복 제거.

이 계획을 통해 LIA 프로젝트는 더욱 높은 수준의 코드 품질과 유지보수성을 갖추게 될 것입니다.
