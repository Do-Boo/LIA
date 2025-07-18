# LIA 프로젝트 유닛 테스트 전략 - 80% 커버리지 달성 계획

## 📋 개요

이 문서는 LIA 프로젝트에서 **80% 코드 커버리지**를 달성하기 위한 종합적인 유닛 테스트 전략을 제시합니다. 5개의 병렬 서브에이전트를 통한 프로젝트 전체 분석을 바탕으로 작성되었습니다.

## 📊 전체 코드 분석 결과

| 디렉토리 | 총 파일 수 | 비즈니스 로직 비중 | 예상 커버리지 | 우선순위 |
|---------|------------|-------------------|---------------|----------|
| **services/** | 1 | 높음 (85%) | 85-90% | 🔴 최우선 |
| **screens/** | 8 | 높음 (80%) | 75-85% | 🔴 최우선 |
| **widgets/specific/** | 15+ | 중간 (70%) | 70-85% | 🟡 중간 |
| **widgets/common/** | 9 | 중간 (65%) | 80-95% | 🟡 중간 |
| **core/** | 2 | 낮음 (95%) | 95%+ | 🟢 낮음 |
| **utils/** | 1 | 높음 (85%) | 85%+ | 🔴 최우선 |

## 🎯 80% 커버리지 달성을 위한 핵심 테스트

### 1단계: 최우선 테스트 (즉시 실행)

#### A. Services 디렉토리 (가장 중요)

**`analysis_data_service_test.dart`** - 65+ 테스트 메서드 필요
- 8개 모델 클래스 완전 테스트
- JSON 직렬화/역직렬화 테스트
- 에러 처리 및 캐싱 로직 테스트
- **예상 커버리지**: 85-90%

**주요 테스트 클래스:**
- `AnalysisDataTest` - 생성자, fromJson, toJson 테스트
- `EmotionDataPointTest` - 데이터 변환 및 차트 변환 테스트
- `AnalysisKeyEventTest` - 이벤트 분류 및 필터링 테스트
- `PersonalityAnalysisTest` - 레이더 차트 데이터 변환 테스트
- `AnalysisMetadataTest` - 메타데이터 처리 테스트
- `EmojiUsageTest` - 이모지 사용량 계산 테스트
- `SentimentScoreTest` - 감정 점수 계산 테스트
- `AnalysisDataServiceTest` - 서비스 로직 및 캐싱 테스트

#### B. Core 비즈니스 로직 화면

**`main_screen_test.dart`** - 25+ 테스트 메서드
- 복잡한 데이터 로딩 및 분석 로직
- 메시지 생성 알고리즘
- 차트 데이터 생성 로직
- 상태 관리 로직 (로딩, 분석 진행)

**`ai_message_screen_test.dart`** - 12+ 테스트 메서드
- AI 메시지 생성 로직
- 톤/카테고리 선택 로직
- 메시지 재생성 및 편집 로직
- 템플릿 및 히스토리 관리

#### C. 핵심 유틸리티

**`custom_modal_test.dart`** - 70+ 테스트 메서드
- 3개 모달 함수 완전 테스트 (`showCustomModal`, `showCustomConfirmModal`, `showMessageConfirmModal`)
- 애니메이션 및 콜백 처리 테스트
- 파라미터 검증 및 기본값 처리
- **예상 커버리지**: 85%+

### 2단계: 중간 우선순위 테스트

#### A. 차트 위젯 (복잡한 계산 로직)

**`bar_chart_test.dart`**
- 데이터 파싱 및 색상 알고리즘
- JSON 변환 로직
- 기본 데이터 생성 로직

**`line_chart_test.dart`**
- 다중 시리즈 처리 로직
- 최솟값/최댓값 계산
- 데이터 포인트 변환

**`donut_chart_test.dart`**
- 퍼센트 계산 로직
- 총합 계산 및 제로 디비전 처리

**`pie_chart_test.dart`**
- 터치 이벤트 처리 로직
- 각도 계산 및 탭 감지

#### B. 폼 위젯 (검증 로직)

**`tag_input_field_test.dart`**
- 태그 중복 방지 로직
- 빈 문자열 처리
- 태그 추가/제거 로직

**`custom_date_picker_test.dart`**
- 날짜 포맷팅 로직
- 한국어 요일 변환
- 도움말 텍스트 생성

**`custom_date_range_picker_test.dart`**
- 기간 계산 로직
- 주/일 변환 계산
- 표시 텍스트 포맷팅

#### C. 공통 위젯 (상태 관리)

**`primary_button_test.dart`**
- 로딩 상태 관리 로직
- 버튼 비활성화 처리
- 콜백 호출 검증

**`secondary_button_test.dart`**
- 버튼 상태 관리 로직
- 로딩 상태 처리
- 이벤트 핸들링

### 3단계: 낮은 우선순위 테스트

#### A. 정적 데이터 검증

**`app_colors_test.dart`**
- 색상 값 일관성 검증
- 중복 색상 확인
- 그라데이션 무결성 테스트

**`app_text_styles_test.dart`**
- 텍스트 스타일 계층 구조 검증
- 폰트 패밀리 일관성 확인
- 크기 및 가중치 검증

## 📈 80% 커버리지 달성 로드맵

### Phase 1: 핵심 로직 (목표: 60% 커버리지)

```
1. analysis_data_service_test.dart  (90% 커버리지)
2. main_screen_test.dart           (85% 커버리지)
3. ai_message_screen_test.dart     (80% 커버리지)
4. custom_modal_test.dart          (85% 커버리지)
```

### Phase 2: 위젯 로직 (목표: 75% 커버리지)

```
5. 차트 위젯 테스트 (4개 파일)    (80% 평균)
6. 폼 위젯 테스트 (3개 파일)      (85% 평균)
7. 공통 위젯 테스트 (2개 파일)    (90% 평균)
```

### Phase 3: 완성도 높이기 (목표: 80%+ 커버리지)

```
8. 나머지 화면 테스트 (5개 파일)   (75% 평균)
9. 정적 데이터 검증 (2개 파일)     (95% 평균)
10. 엣지 케이스 및 에러 처리 보강
```

## 🛠 필요한 테스트 인프라

### Dependencies (pubspec.yaml)

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
  fake_async: ^1.3.0
  test: ^1.21.0
```

### Mock 클래스 생성

```dart
// test/mocks/mocks.dart
import 'package:mockito/annotations.dart';
import 'package:lia/services/analysis_data_service.dart';

@GenerateNiceMocks([
  MockSpec<AnalysisDataService>(),
  MockSpec<BuildContext>(),
  MockSpec<Navigator>(),
  MockSpec<TextEditingController>(),
])
void main() {}
```

### 테스트 파일 구조

```
test/
├── services/
│   └── analysis_data_service_test.dart
├── screens/
│   ├── main_screen_test.dart
│   ├── ai_message_screen_test.dart
│   ├── my_screen_test.dart
│   ├── coaching_center_screen_test.dart
│   ├── analyzed_people_screen_test.dart
│   ├── chart_demo_screen_test.dart
│   ├── design_guide_screen_test.dart
│   └── main_layout_test.dart
├── widgets/
│   ├── common/
│   │   ├── component_card_test.dart
│   │   ├── primary_button_test.dart
│   │   ├── secondary_button_test.dart
│   │   ├── dashed_divider_test.dart
│   │   ├── parameter_card_test.dart
│   │   ├── scenario_card_test.dart
│   │   └── code_copy_card_test.dart
│   └── specific/
│       ├── charts/
│       │   ├── bar_chart_test.dart
│       │   ├── donut_chart_test.dart
│       │   ├── gauge_chart_test.dart
│       │   ├── heatmap_chart_test.dart
│       │   ├── line_chart_test.dart
│       │   ├── pie_chart_test.dart
│       │   ├── radar_chart_test.dart
│       │   └── semicircle_gauge_chart_test.dart
│       ├── feedback/
│       │   ├── generating_progress_test.dart
│       │   ├── heart_spinner_test.dart
│       │   ├── pulsating_dot_test.dart
│       │   ├── skeleton_ui_test.dart
│       │   └── toast_notification_test.dart
│       ├── forms/
│       │   ├── custom_date_picker_test.dart
│       │   ├── custom_date_range_picker_test.dart
│       │   ├── custom_slider_test.dart
│       │   ├── custom_toggle_switch_test.dart
│       │   ├── floating_label_textfield_test.dart
│       │   └── tag_input_field_test.dart
│       ├── headers/
│       │   └── main_header_test.dart
│       ├── navigation/
│       │   ├── bottom_navigation_bar_test.dart
│       │   ├── custom_tab_bar_test.dart
│       │   └── custom_tab_bar_view_test.dart
│       └── virtual_chat_view_test.dart
├── core/
│   ├── app_colors_test.dart
│   └── app_text_styles_test.dart
├── utils/
│   └── custom_modal_test.dart
└── mocks/
    └── mocks.dart
```

## 🎯 예상 결과

### 전체 테스트 메트릭스

- **총 테스트 파일**: 40+ 개
- **총 테스트 메서드**: 400+ 개
- **예상 커버리지**: **82-85%**
- **구현 시간**: 2-3주 (단계별 진행)

### 커버리지 분포

| 카테고리 | 파일 수 | 예상 커버리지 | 기여도 |
|----------|---------|---------------|--------|
| Services | 1 | 90% | 25% |
| Screens | 8 | 80% | 35% |
| Widgets | 30+ | 85% | 30% |
| Core/Utils | 3 | 90% | 10% |

## 📝 테스트 작성 가이드라인

### 1. 테스트 명명 규칙

```dart
// Good
testAnalysisDataFromJson_WithValidData_ReturnsCorrectObject()
testPrimaryButtonTap_WhenLoading_DoesNotCallOnPressed()

// Bad
testAnalysisData()
testButton()
```

### 2. 테스트 구조

```dart
void main() {
  group('AnalysisData', () {
    group('fromJson', () {
      test('should create AnalysisData from valid JSON', () {
        // Arrange
        final json = {'someIndex': 50, 'aiSummary': 'test'};
        
        // Act
        final result = AnalysisData.fromJson(json);
        
        // Assert
        expect(result.someIndex, 50);
        expect(result.aiSummary, 'test');
      });
    });
  });
}
```

### 3. Mock 사용 예시

```dart
void main() {
  late MockAnalysisDataService mockService;
  
  setUp(() {
    mockService = MockAnalysisDataService();
  });
  
  test('should load analysis data successfully', () async {
    // Arrange
    when(mockService.loadSampleData())
        .thenAnswer((_) async => AnalysisData(...));
    
    // Act & Assert
    final result = await mockService.loadSampleData();
    expect(result, isA<AnalysisData>());
  });
}
```

## 🚀 실행 계획

### Week 1: 핵심 로직 테스트
- [ ] `analysis_data_service_test.dart` 완성
- [ ] `main_screen_test.dart` 완성
- [ ] `custom_modal_test.dart` 완성
- [ ] 첫 번째 커버리지 측정 (목표: 60%)

### Week 2: 위젯 로직 테스트
- [ ] 차트 위젯 테스트 완성
- [ ] 폼 위젯 테스트 완성
- [ ] 공통 위젯 테스트 완성
- [ ] 두 번째 커버리지 측정 (목표: 75%)

### Week 3: 완성도 높이기
- [ ] 나머지 화면 테스트 완성
- [ ] 정적 데이터 검증 테스트
- [ ] 엣지 케이스 및 에러 처리 보강
- [ ] 최종 커버리지 측정 (목표: 80%+)

## 🔧 커버리지 측정 명령어

```bash
# 커버리지 측정
flutter test --coverage

# 커버리지 리포트 생성
genhtml coverage/lcov.info -o coverage/html

# 커버리지 리포트 확인
open coverage/html/index.html
```

## 📋 최종 권장사항

1. **Phase 1**부터 시작하여 핵심 비즈니스 로직 우선 테스트
2. **Mockito**를 활용한 의존성 격리
3. **UI 테스트 제외**, 순수 유닛 테스트만 진행
4. **에러 처리 시나리오** 반드시 포함
5. **CI/CD 파이프라인**에 테스트 자동화 통합
6. **커버리지 리포트**를 정기적으로 확인하며 진행
7. **리팩토링과 병행** 진행하여 테스트 가능한 코드 구조로 개선

이 전략을 따르면 **80% 코드 커버리지**를 효율적으로 달성할 수 있으며, 코드 품질과 유지보수성을 크게 향상시킬 수 있습니다.