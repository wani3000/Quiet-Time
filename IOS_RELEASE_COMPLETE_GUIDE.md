# 🚀 말씀묵상 앱 - iOS 출시 완벽 가이드

## 📋 목차

1. [준비 완료 사항](#1-준비-완료-사항)
2. [생성된 파일 목록](#2-생성된-파일-목록)
3. [출시 단계별 체크리스트](#3-출시-단계별-체크리스트)
4. [빠른 시작 가이드](#4-빠른-시작-가이드)
5. [문제 해결](#5-문제-해결)

---

## 1. 준비 완료 사항

### ✅ 기술적 준비

- [x] Flutter 프로젝트 설정 완료
- [x] iOS 번들 ID 설정: `com.versecard.verseCardApp`
- [x] Info.plist 설정 완료
- [x] 프로덕션 환경 설정 (environment: 'prod')
- [x] 앱 아이콘 준비 (모든 크기)
- [x] iOS 릴리즈 빌드 테스트 성공 ✓

### ✅ 문서 및 리소스

- [x] Xcode 서명 문제 해결 가이드
- [x] App Store Connect 설정 가이드
- [x] 스크린샷 촬영 자동화 스크립트
- [x] 개인정보 보호정책 페이지
- [x] 고객 지원 페이지
- [x] 랜딩 페이지

---

## 2. 생성된 파일 목록

### 📁 문서 파일

```
/Users/chulwan/Downloads/말씀묵상앱/
├── APP_STORE_RELEASE_GUIDE.md          # 기본 출시 가이드
├── IOS_RELEASE_COMPLETE_GUIDE.md        # 이 파일 (완벽 가이드)
│
├── docs/
│   ├── XCODE_SIGNING_GUIDE.md          # Xcode 서명 문제 해결
│   ├── APP_STORE_CONNECT_GUIDE.md      # App Store Connect 상세 가이드
│   └── SCREENSHOT_GUIDE.md             # 스크린샷 촬영 가이드
│
├── scripts/
│   └── take_screenshots.sh             # 스크린샷 자동 촬영 스크립트
│
└── web/
    ├── index.html                       # 랜딩 페이지
    ├── privacy.html                     # 개인정보 보호정책
    └── support.html                     # 고객 지원 페이지
```

### 📝 각 파일 설명

| 파일 | 용도 | 언제 사용 |
|-----|------|---------|
| **APP_STORE_RELEASE_GUIDE.md** | 기본 출시 프로세스 | 출시 시작할 때 |
| **XCODE_SIGNING_GUIDE.md** | 서명 오류 해결 | 빌드 에러 발생 시 |
| **APP_STORE_CONNECT_GUIDE.md** | App Store 등록 상세 | 앱 등록 시 |
| **SCREENSHOT_GUIDE.md** | 스크린샷 촬영 방법 | 스크린샷 준비 시 |
| **take_screenshots.sh** | 자동 스크린샷 촬영 | 빠른 스크린샷 필요 시 |
| **privacy.html** | 개인정보 보호정책 | App Store 제출 필수 |
| **support.html** | 고객 지원 | App Store 제출 필수 |
| **index.html** | 마케팅 랜딩 페이지 | 홍보용 (선택) |

---

## 3. 출시 단계별 체크리스트

### 🔵 Phase 1: Xcode 서명 설정 (10분)

```bash
# 1. Xcode 열기
open ios/Runner.xcworkspace
```

**Xcode에서 수행:**
- [ ] 좌측 "Runner" 프로젝트 클릭
- [ ] TARGETS > Runner 선택
- [ ] "Signing & Capabilities" 탭
- [ ] ✅ "Automatically manage signing" 체크
- [ ] Team: Apple Developer 계정 선택
- [ ] Status: "Signing is configured" 확인

**문제 발생 시:**
📖 `docs/XCODE_SIGNING_GUIDE.md` 참고

---

### 🔵 Phase 2: App Store Connect 앱 등록 (30분)

**URL:** https://appstoreconnect.apple.com

#### 2-1. 앱 생성

- [ ] My Apps → "+" → New App
- [ ] Platform: iOS
- [ ] Name: 말씀묵상
- [ ] Language: Korean
- [ ] Bundle ID: com.versecard.verseCardApp
- [ ] SKU: versecard-2025-001

#### 2-2. 앱 정보 입력

**App Information 탭:**
- [ ] Category: Lifestyle (Books)
- [ ] Age Rating: 4+

**Pricing and Availability:**
- [ ] Price: Free

**App Privacy:**
- [ ] Does your app collect data? → No

#### 2-3. 버전 정보 (1.0 Prepare for Submission)

**설명 작성:**
```
매일 새로운 성경 말씀을 아름다운 카드로 만나보세요.

✨ 주요 기능
📖 매일 새로운 말씀 (547개 성경 구절)
🎨 아름다운 디자인
💾 저장 및 공유
📝 묵상 노트
🙏 간편한 사용

하루를 시작하는 영감과 위로를 받아보세요.
```

**키워드:**
```
성경,말씀,묵상,기도,신앙,크리스천,성경구절,카드,말씀카드,QT,큐티
```

**URL 정보:**
- [ ] Privacy Policy URL: `https://versecard.app/privacy.html`
- [ ] Support URL: `https://versecard.app/support.html`

**상세 가이드:**
📖 `docs/APP_STORE_CONNECT_GUIDE.md` 참고

---

### 🔵 Phase 3: 스크린샷 준비 (1-2시간)

#### 옵션 A: 자동 스크립트 (권장)

```bash
# 스크립트 실행
./scripts/take_screenshots.sh
```

#### 옵션 B: 수동 촬영

```bash
# iPhone 15 Pro Max 시뮬레이터로 실행
flutter run -d "iPhone 15 Pro Max"

# Cmd + S 로 스크린샷 촬영
```

**필수 스크린샷:**
- [ ] 6.7" Display (1290 × 2796) - 최소 1개
- [ ] 6.5" Display (1242 × 2688) - 최소 1개

**촬영할 화면:**
1. 홈 화면 (오늘의 말씀)
2. 전체화면 말씀 카드
3. 묵상 리스트
4. 묵상 상세 페이지
5. 공유 화면

**상세 가이드:**
📖 `docs/SCREENSHOT_GUIDE.md` 참고

---

### 🔵 Phase 4: 빌드 및 업로드 (30분)

#### 방법 A: Xcode Archive (권장)

```bash
# 1. Xcode 열기
open ios/Runner.xcworkspace
```

**Xcode에서:**
1. Product → Destination → "Any iOS Device (arm64)"
2. Product → Archive (1-2분 소요)
3. Organizer 창에서 "Distribute App"
4. "App Store Connect" → Upload
5. 자동 서명 선택
6. Upload 완료 대기 (5-10분)

#### 방법 B: Flutter CLI

```bash
# IPA 파일 생성
flutter build ipa

# Transporter 앱으로 업로드
# build/ios/ipa/*.ipa 파일 드래그
```

**확인:**
- [ ] App Store Connect → TestFlight 탭
- [ ] 10-30분 후 빌드 나타남
- [ ] Export Compliance: No

---

### 🔵 Phase 5: TestFlight 테스트 (선택사항, 1-2일)

- [ ] TestFlight 탭에서 빌드 선택
- [ ] 내부 테스터 추가 (본인 이메일)
- [ ] TestFlight 앱으로 기기에서 테스트
- [ ] 주요 기능 테스트
  - 홈 화면 로딩
  - 말씀 카드 표시
  - 묵상 탭 이동
  - 말씀 저장 기능
  - 공유 기능

---

### 🔵 Phase 6: 심사 제출 (10분)

**App Store Connect:**
- [ ] 1.0 버전 페이지로 이동
- [ ] "Build" 섹션에서 빌드 선택
- [ ] 모든 정보 최종 확인
- [ ] "Submit for Review" 클릭

**심사 정보 입력:**
```
Contact Information:
- Name: [이름]
- Phone: +82 10-XXXX-XXXX
- Email: your.email@example.com

Notes:
안녕하세요. 말씀묵상 앱 심사를 부탁드립니다.

이 앱은 성경 말씀을 아름다운 카드로 제공하는 묵상 앱입니다.
사진 라이브러리 권한은 말씀 카드를 저장하기 위해서만 사용됩니다.
개인정보를 수집하지 않으며 모든 데이터는 기기에만 저장됩니다.

감사합니다.
```

---

### 🔵 Phase 7: 심사 대기 (1-5일)

**심사 단계:**
```
Waiting For Review → In Review → Pending Developer Release
```

**심사 기간:**
- 평균: 24-48시간
- 최대: 3-5일

**승인 후:**
- [ ] 수동 출시 선택했다면: "Release This Version" 클릭
- [ ] 자동 출시 선택했다면: 즉시 App Store에 표시

---

## 4. 빠른 시작 가이드

### 🚀 30분 빠른 체크리스트

```bash
# 1. Xcode 서명 (5분)
open ios/Runner.xcworkspace
# → Signing & Capabilities 설정

# 2. 빌드 테스트 (5분)
flutter build ios --release --no-codesign

# 3. App Store Connect 앱 등록 (10분)
# → https://appstoreconnect.apple.com

# 4. Archive 및 업로드 (10분)
# → Xcode: Product → Archive → Distribute
```

---

## 5. 문제 해결

### ❌ 일반적인 문제

#### 문제 1: "No signing certificate found"

**해결:**
```
Xcode → Preferences → Accounts
→ Apple ID 선택
→ "Manage Certificates..."
→ "+" → "Apple Development"
```

📖 상세: `docs/XCODE_SIGNING_GUIDE.md` 섹션 2

---

#### 문제 2: "Bundle identifier cannot be registered"

**해결:**
```
1. Xcode에서 Bundle ID 변경
2. 또는 developer.apple.com에서 App ID 등록
```

📖 상세: `docs/XCODE_SIGNING_GUIDE.md` 섹션 2

---

#### 문제 3: 빌드는 되는데 업로드가 안돼요

**해결:**
```bash
# 1. Xcode 업데이트 확인
# 2. Apple Developer 계정 상태 확인
# 3. 다시 Archive 시도
```

---

#### 문제 4: 스크린샷 크기가 안 맞아요

**해결:**
```bash
# 올바른 시뮬레이터 확인
xcrun simctl list devices | grep "iPhone 15 Pro Max"

# 올바른 시뮬레이터로 실행
flutter run -d "iPhone 15 Pro Max"
```

📖 상세: `docs/SCREENSHOT_GUIDE.md`

---

#### 문제 5: 심사가 거부되었어요

**일반적인 거부 사유:**
1. 스크린샷 문제 → 실제 앱 화면으로 교체
2. 개인정보정책 미비 → privacy.html 확인
3. 기능 불명확 → Notes에 상세 설명 추가

**재제출:**
1. Resolution Center에서 사유 확인
2. 문제 해결
3. "Submit for Review" 다시 클릭

---

## 6. 웹 페이지 호스팅

### GitHub Pages로 호스팅 (무료)

```bash
# 1. GitHub 레포지토리 생성
# 2. web 폴더 내용을 gh-pages 브랜치로 푸시

cd web
git init
git add .
git commit -m "Add landing pages"
git branch -M gh-pages
git remote add origin https://github.com/yourusername/verse-card-app.git
git push -u origin gh-pages

# 3. GitHub → Settings → Pages
# Source: gh-pages 선택
# 완료! https://yourusername.github.io/verse-card-app/
```

**URL 업데이트:**
- Privacy Policy: `https://yourusername.github.io/verse-card-app/privacy.html`
- Support: `https://yourusername.github.io/verse-card-app/support.html`

---

## 7. 출시 후 할 일

### 📊 모니터링

- [ ] App Store Connect → Analytics
- [ ] 다운로드 수 확인
- [ ] 크래시 리포트 확인
- [ ] 사용자 리뷰 확인 및 답변

### 🔄 업데이트 계획

**버전 1.1.0 아이디어:**
- [ ] 알림 기능 (매일 정해진 시간)
- [ ] 위젯 지원
- [ ] 말씀 검색 기능
- [ ] 북마크 기능
- [ ] 배경 이미지 커스터마이징
- [ ] 다크 모드 개선

---

## 8. 연락처 및 지원

### 📧 문의

- **이메일:** support@versecard.app
- **웹사이트:** https://versecard.app

### 📚 유용한 리소스

- [Apple Developer](https://developer.apple.com)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Flutter Docs](https://docs.flutter.dev/deployment/ios)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

---

## 9. 최종 체크리스트

출시 전 마지막 확인:

### 기술적 확인
- [ ] Xcode 서명 설정 완료
- [ ] 릴리즈 빌드 테스트 성공
- [ ] 모든 기능 정상 작동 확인
- [ ] 크래시 없음 확인

### App Store 확인
- [ ] 앱 등록 완료
- [ ] 앱 이름, 설명, 키워드 작성
- [ ] 스크린샷 업로드 (6.7", 6.5")
- [ ] 앱 아이콘 업로드
- [ ] Privacy Policy URL 입력
- [ ] Support URL 입력
- [ ] 빌드 선택 및 업로드
- [ ] 심사 정보 입력

### 최종 확인
- [ ] 개인정보 보호정책 페이지 작동 확인
- [ ] 고객 지원 페이지 작동 확인
- [ ] 모든 링크 작동 확인
- [ ] 이메일 주소 유효성 확인

---

## 🎉 축하합니다!

모든 준비가 완료되었습니다!

**다음 단계:**
1. Xcode에서 서명 설정 (10분)
2. App Store Connect에 앱 등록 (30분)
3. 스크린샷 준비 (1시간)
4. 빌드 업로드 (30분)
5. 심사 제출 (10분)

**예상 출시 시간:** 심사 제출 후 1-5일

---

**"주의 말씀은 내 발에 등이요 내 길에 빛이니이다" - 시편 119:105**

말씀묵상 앱의 성공적인 출시를 기원합니다! 🚀📱✨


