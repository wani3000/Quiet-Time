# 📱 말씀묵상 앱

> 매일 새로운 성경 말씀을 아름다운 카드로 만나보세요

## 📖 소개

말씀묵상 앱은 바쁜 일상 속에서도 하나님의 말씀으로 하루를 시작할 수 있도록 돕는 iOS 앱입니다.

### ✨ 주요 기능

- **📖 매일의 말씀**: 547개의 엄선된 성경 구절
- **🎨 아름다운 디자인**: 감동적인 배경 이미지와 깔끔한 타이포그래피
- **💾 저장 & 공유**: 말씀 카드를 이미지로 저장하고 SNS로 공유
- **📝 묵상 노트**: 개인적인 묵상 메모 작성
- **🔒 개인정보 보호**: 모든 데이터는 기기에만 저장

## 🚀 빠른 시작

### 개발 환경 설정

```bash
# 의존성 설치
flutter pub get

# iOS 앱 실행
flutter run -d iPhone

# 빌드
flutter build ios --release
```

## 📂 프로젝트 구조

```
lib/
├── core/              # 핵심 기능 (라우터, 테마, 유틸)
├── data/              # 데이터 (성경 말씀 DB)
├── features/          # 주요 기능별 폴더
│   ├── home/         # 홈 화면
│   ├── meditation/   # 묵상 기능
│   └── paywall/      # 페이월 (미사용)
└── services/          # 서비스 (설정, 메모)
```

## 🛠️ 기술 스택

- **Framework**: Flutter 3.35.3
- **State Management**: Riverpod 2.6.1
- **Navigation**: GoRouter 14.8.1
- **Local Storage**: SharedPreferences 2.5.3
- **Image Handling**: Image 4.2.0, ImageGallerySaver 2.0.3

## 📱 iOS 출시 가이드

### 🎯 시작하기

**가장 중요한 파일:**
```bash
NEXT_STEPS_CHECKLIST.md  # ⭐ 여기서 시작!
```

### 📚 상세 가이드

| 가이드 | 용도 |
|--------|------|
| `IOS_RELEASE_COMPLETE_GUIDE.md` | 전체 출시 프로세스 |
| `docs/XCODE_SIGNING_GUIDE.md` | Xcode 서명 문제 해결 |
| `docs/APP_STORE_CONNECT_GUIDE.md` | App Store 등록 상세 |
| `docs/SCREENSHOT_GUIDE.md` | 스크린샷 촬영 방법 |

### 🔧 유용한 스크립트

```bash
# 스크린샷 자동 촬영
./scripts/take_screenshots.sh

# GitHub Pages 배포
./scripts/deploy_github_pages.sh
```

### ✅ 출시 체크리스트

- [ ] Xcode 서명 설정
- [ ] GitHub Pages 웹 호스팅
- [ ] App Store Connect 앱 등록
- [ ] 스크린샷 촬영 및 업로드
- [ ] Archive 생성 및 업로드
- [ ] 심사 제출

**상세 단계:** `NEXT_STEPS_CHECKLIST.md` 참고

## 🌐 웹 페이지

- **개인정보 보호정책**: `web/privacy.html`
- **고객 지원**: `web/support.html`
- **랜딩 페이지**: `web/index.html`

**호스팅:** GitHub Pages 사용 권장

```bash
./scripts/deploy_github_pages.sh
```

## 📊 앱 정보

```yaml
앱 이름: 말씀묵상
번들 ID: com.versecard.verseCardApp
버전: 1.0.0 (Build 1)
플랫폼: iOS 12.0+
카테고리: Lifestyle / Books
언어: 한국어
```

## 🔐 개인정보 보호

말씀묵상 앱은:
- ❌ 개인정보를 수집하지 않습니다
- ❌ 서버로 데이터를 전송하지 않습니다
- ✅ 모든 데이터는 기기에만 저장됩니다
- ✅ 오프라인에서 완전히 작동합니다

자세한 내용: `web/privacy.html`

## 🤝 기여

이 프로젝트는 개인 프로젝트입니다. 버그 제보나 제안 사항이 있으시면 이슈를 등록해주세요.

## 📝 라이선스

Copyright © 2025 말씀묵상. All rights reserved.

## 📞 연락처

- **이메일**: support@versecard.app
- **웹사이트**: https://versecard.app

## 🎉 다음 단계

출시를 준비 중이라면:

```bash
# 1. 체크리스트 확인
open NEXT_STEPS_CHECKLIST.md

# 2. 전체 가이드 확인
open IOS_RELEASE_COMPLETE_GUIDE.md

# 3. Xcode 열기
open ios/Runner.xcworkspace
```

---

**"주의 말씀은 내 발에 등이요 내 길에 빛이니이다" - 시편 119:105**

성공적인 출시를 기원합니다! 🙏✨


