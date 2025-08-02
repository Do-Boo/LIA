# LIA 앱 Supabase 데이터베이스 구성 계획

## 1. 개요

본 문서는 LIA 애플리케이션의 백엔드 데이터베이스를 Supabase로 구성하기 위한 테이블 구조와 설계 계획을 정의합니다. Supabase는 PostgreSQL 기반의 오픈소스 Firebase 대체재로, 확장성 있는 관계형 데이터베이스, 인증, 스토리지, 자동 생성 API 등 백엔드 개발에 필요한 핵심 기능을 제공합니다.

**목표:**
- 사용자의 대화 분석 데이터와 프로필 정보를 안전하고 효율적으로 저장 및 관리합니다.
- 확장 가능한 데이터 구조를 설계하여 향후 기능 추가에 유연하게 대응합니다.
- Supabase의 인증 및 RLS(Row Level Security)를 활용하여 데이터 보안을 강화합니다.

## 2. 테이블 스키마 정의

현재 앱의 데이터 모델(`AnalysisData` 및 하위 모델)은 중첩된 객체 구조를 가지고 있습니다. 이를 Supabase의 관계형 데이터베이스(PostgreSQL)에 맞게 정규화된 테이블 구조로 설계합니다.

### 2.1. `profiles`

- **설명:** 사용자의 프로필 정보를 저장합니다. Supabase의 `auth.users` 테이블과 1:1 관계를 가집니다.
- **컬럼:**
  - `id` (uuid, PK, FK to `auth.users.id`): 사용자 ID
  - `updated_at` (timestamp with time zone): 마지막 업데이트 시각
  - `username` (text): 사용자 이름 (예: 서현)
  - `email` (text, unique): 이메일 주소
  - `mbti` (text): 사용자 MBTI
  - `interests` (text[]): 관심사 목록 (배열)

### 2.2. `analysis_sessions`

- **설명:** 사용자가 요청한 개별 대화 분석 세션을 저장하는 메인 테이블입니다.
- **컬럼:**
  - `id` (uuid, PK, default: `uuid_generate_v4()`): 세션 고유 ID
  - `user_id` (uuid, FK to `auth.users.id`): 분석을 요청한 사용자 ID
  - `partner_name` (text): 대화 상대방 이름
  - `partner_mbti` (text, nullable): 대화 상대방 MBTI
  - `relationship` (text): 상대방과의 관계 (예: 썸, 친구)
  - `ai_summary` (text): AI가 생성한 한 줄 요약
  - `some_index` (integer): 썸 지수 (0-100)
  - `development_possibility` (integer): 발전 가능성 (0-100)
  - `communication_style` (text): 소통 스타일 분석 결과
  - `compatibility_score` (integer): 성격 관계성 점수
  - `created_at` (timestamp with time zone, default: `now()`): 생성 시각

### 2.3. `messages`

- **설명:** 분석된 대화의 각 메시지를 저장합니다.
- **컬럼:**
  - `id` (bigint, PK, generated always as identity): 메시지 고유 ID
  - `session_id` (uuid, FK to `analysis_sessions.id`): 분석 세션 ID
  - `sender` (text): 발신자 ('me' 또는 'partner')
  - `content` (text): 메시지 내용
  - `timestamp` (timestamp with time zone): 메시지 발신 시각

### 2.4. `emotion_data_points`

- **설명:** 시간의 흐름에 따른 감정 변화 데이터를 저장합니다.
- **컬럼:**
  - `id` (bigint, PK, generated always as identity): 데이터 포인트 고유 ID
  - `session_id` (uuid, FK to `analysis_sessions.id`): 분석 세션 ID
  - `time_label` (text): 시간 레이블 (예: '1일차', '14:30')
  - `my_emotion_score` (integer): 나의 감정 점수
  - `partner_emotion_score` (integer): 상대방의 감정 점수
  - `description` (text): 해당 시점의 주요 이벤트 설명

### 2.5. `key_events`

- **설명:** 대화에서 발생한 긍정적/부정적 주요 이벤트를 저장합니다.
- **컬럼:**
  - `id` (bigint, PK, generated always as identity): 이벤트 고유 ID
  - `session_id` (uuid, FK to `analysis_sessions.id`): 분석 세션 ID
  - `time_label` (text): 시간 레이블
  - `event_title` (text): 이벤트 제목
  - `event_type` (text): 이벤트 타입 ('positive' 또는 'negative')
  - `description` (text): 이벤트 상세 설명

### 2.6. `recommended_topics`

- **설명:** AI가 추천하는 대화 주제를 저장합니다.
- **컬럼:**
  - `id` (bigint, PK, generated always as identity): 주제 고유 ID
  - `session_id` (uuid, FK to `analysis_sessions.id`): 분석 세션 ID
  - `topic` (text): 추천 주제 내용

### 2.7. `improvement_tips`

- **설명:** AI가 제안하는 관계 개선 팁을 저장합니다.
- **컬럼:**
  - `id` (bigint, PK, generated always as identity): 팁 고유 ID
  - `session_id` (uuid, FK to `analysis_sessions.id`): 분석 세션 ID
  - `tip` (text): 개선 팁 내용

## 3. 데이터 모델과 테이블 매핑

기존 Flutter 앱의 Dart 모델 클래스는 Supabase 테이블과 다음과 같이 매핑됩니다.

- `AnalysisData` -> `analysis_sessions` 테이블의 주요 데이터와 1:N 관계를 가지는 다른 테이블들의 조합으로 변환됩니다.
- `PersonalityAnalysis` -> `analysis_sessions` 테이블의 `compatibility_score` 등으로 통합됩니다.
- `EmotionDataPoint` -> `emotion_data_points` 테이블
- `AnalysisKeyEvent` -> `key_events` 테이블
- `recommendedTopics` (List<String>) -> `recommended_topics` 테이블
- `improvementTips` (List<String>) -> `improvement_tips` 테이블

## 4. 구현 단계

1.  **Supabase 프로젝트 설정**: Supabase 대시보드에서 새 프로젝트를 생성하고 API 키와 URL을 확보합니다.
2.  **Flutter 의존성 추가**: `pubspec.yaml` 파일에 `supabase_flutter` 패키지를 추가합니다.
3.  **테이블 생성**: Supabase 대시보드의 SQL Editor를 사용하여 위 스키마에 정의된 테이블들을 생성합니다.
4.  **Flutter 앱 초기화**: `main.dart`에서 Supabase 클라이언트를 초기화합니다.
5.  **데이터 서비스 구현**:
    - `SupabaseService` 클래스를 생성하여 각 테이블에 대한 CRUD(Create, Read, Update, Delete) 로직을 구현합니다.
    - `getAnalysisSession`, `createAnalysisSession` 등의 함수를 비동기로 구현합니다.
6.  **기존 로직 리팩토링**:
    - `AnalysisDataService`가 로컬 JSON 파일을 읽는 대신 `SupabaseService`를 호출하도록 수정합니다.
    - 분석 시작 시, 대화 내용을 `SupabaseService`를 통해 백엔드로 전송하고, 분석 결과를 받아와 각 테이블에 저장하는 로직을 구현합니다.
7.  **보안 정책(RLS) 설정**:
    - 각 테이블에 대해 RLS(Row Level Security) 정책을 활성화합니다.
    - 사용자는 자신의 `user_id`와 일치하는 데이터에만 접근(SELECT, INSERT, UPDATE, DELETE)할 수 있도록 정책을 설정합니다.

## 5. 고려사항

- **데이터 보안**: RLS 정책을 반드시 활성화하여 사용자 데이터가 서로 격리되도록 해야 합니다. 민감한 정보는 암호화하여 저장하는 것을 고려합니다.
- **성능**: 데이터 조회 성능 향상을 위해 `user_id` 및 `session_id`와 같이 자주 사용되는 FK 컬럼에 인덱스를 생성합니다.
- **초기 데이터**: `assets/data/analysis_sample.json`의 내용은 개발 및 테스트용 초기 데이터로 Supabase DB에 삽입할 수 있습니다.
