# Pretendard 폰트 다운로드 가이드

## 📦 필요한 폰트 파일들

LIA 앱에서 사용하기 위해 다음 Pretendard 폰트 파일들을 다운로드해야 합니다:

```
assets/fonts/
├── Pretendard-Light.ttf      (weight: 300)
├── Pretendard-Regular.ttf    (weight: 400)
├── Pretendard-Medium.ttf     (weight: 500)
├── Pretendard-SemiBold.ttf   (weight: 600)
├── Pretendard-Bold.ttf       (weight: 700)
├── Pretendard-ExtraBold.ttf  (weight: 800)
└── Pretendard-Black.ttf      (weight: 900)
```

## 🔗 다운로드 링크

### 방법 1: GitHub 릴리즈에서 다운로드
1. https://github.com/orioncactus/pretendard/releases/latest 방문
2. `Pretendard.zip` 파일 다운로드
3. 압축 해제 후 `ttf` 폴더에서 필요한 파일들 복사

### 방법 2: CDN에서 직접 다운로드
```bash
# Light (300)
curl -o assets/fonts/Pretendard-Light.ttf https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-Light.ttf

# Regular (400)
curl -o assets/fonts/Pretendard-Regular.ttf https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-Regular.ttf

# Medium (500)
curl -o assets/fonts/Pretendard-Medium.ttf https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-Medium.ttf

# SemiBold (600)
curl -o assets/fonts/Pretendard-SemiBold.ttf https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-SemiBold.ttf

# Bold (700)
curl -o assets/fonts/Pretendard-Bold.ttf https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-Bold.ttf

# ExtraBold (800)
curl -o assets/fonts/Pretendard-ExtraBold.ttf https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-ExtraBold.ttf

# Black (900)
curl -o assets/fonts/Pretendard-Black.ttf https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-Black.ttf
```

## ✅ 설치 확인

폰트 파일들이 올바르게 설치되었는지 확인:

```bash
ls -la assets/fonts/Pretendard-*.ttf
```

예상 출력:
```
-rw-r--r--  1 user  staff  xxxxx  날짜 시간 assets/fonts/Pretendard-Black.ttf
-rw-r--r--  1 user  staff  xxxxx  날짜 시간 assets/fonts/Pretendard-Bold.ttf
-rw-r--r--  1 user  staff  xxxxx  날짜 시간 assets/fonts/Pretendard-ExtraBold.ttf
-rw-r--r--  1 user  staff  xxxxx  날짜 시간 assets/fonts/Pretendard-Light.ttf
-rw-r--r--  1 user  staff  xxxxx  날짜 시간 assets/fonts/Pretendard-Medium.ttf
-rw-r--r--  1 user  staff  xxxxx  날짜 시간 assets/fonts/Pretendard-Regular.ttf
-rw-r--r--  1 user  staff  xxxxx  날짜 시간 assets/fonts/Pretendard-SemiBold.ttf
```

## 🎨 사용법

폰트 설치 후 앱에서 다음과 같이 사용:

```dart
// 섹션 제목
Text(
  "종합 분석 요약",
  style: AppTextStyles.h2, // Pretendard-Bold (700)
)

// 본문 텍스트
Text(
  "분석 결과를 확인해보세요.",
  style: AppTextStyles.body, // NotoSansKR-Regular (400)
)
```

## 📄 라이선스

Pretendard는 SIL 오픈 폰트 라이선스로 배포됩니다. 
글꼴 단독 판매를 제외한 모든 상업적 행위 및 수정, 재배포가 가능합니다.

## 🔗 참고 링크

- [Pretendard 공식 사이트](https://cactus.tistory.com/306)
- [GitHub 저장소](https://github.com/orioncactus/pretendard)
- [라이선스 정보](https://github.com/orioncactus/pretendard/blob/main/LICENSE) 