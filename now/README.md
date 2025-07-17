# DateTime MCP Server

현재 날짜와 시간을 가져오는 간단한 MCP (Model Context Protocol) 서버입니다.

## 기능

- `get_current_datetime`: 현재 날짜/시간을 `yyyy.MM.dd HH:mm:ss` 형식으로 반환
- `get_formatted_datetime`: 사용자 정의 형식과 타임존으로 날짜/시간 반환

## 설치

```bash
npm install
```

## 실행

```bash
npm start
```

## 사용 예시

### 기본 형식
```
현재 시간: 2025.05.25 14:30:45
```

### 커스텀 형식
```
format: "yyyy년 MM월 dd일 HH시 mm분"
결과: 2025년 05월 25일 14시 30분
```

## 지원하는 형식 토큰

- `yyyy`: 연도 (4자리)
- `MM`: 월 (2자리)  
- `dd`: 일 (2자리)
- `HH`: 시간 (24시간, 2자리)
- `mm`: 분 (2자리)
- `ss`: 초 (2자리)
