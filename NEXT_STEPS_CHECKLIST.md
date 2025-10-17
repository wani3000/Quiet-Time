# ✅ 말씀묵상 앱 - 출시 체크리스트

## 🎯 현재 진행 상황

### ✅ 완료된 작업

- [x] Flutter 프로젝트 설정
- [x] Info.plist 설정 (암호화, 권한 등)
- [x] 프로덕션 환경 설정
- [x] 앱 아이콘 준비 (15개 크기 모두 완료)
- [x] iOS 릴리즈 빌드 테스트 성공
- [x] 개인정보 보호정책 페이지 작성
- [x] 고객 지원 페이지 작성
- [x] 랜딩 페이지 작성
- [x] 모든 가이드 문서 작성
- [x] 스크린샷 자동화 스크립트 작성
- [x] GitHub Pages 배포 스크립트 작성

---

## 🚀 지금 해야 할 일 (순서대로)

### 1️⃣ Xcode 서명 설정 ⭐ (10분) - **먼저 해야 함!**

```bash
# Xcode 열기 (이미 열려있을 수 있음)
open ios/Runner.xcworkspace
```

**Xcode에서 수행:**

1. 왼쪽 네비게이터에서 **파란색 "Runner" 프로젝트** 클릭
2. 중앙 패널에서 **TARGETS > Runner** 선택
3. 상단 탭에서 **"Signing & Capabilities"** 클릭
4. **Debug와 Release 모두** 설정:
   - ✅ **"Automatically manage signing"** 체크
   - **Team** 드롭다운에서 본인의 Apple Developer 계정 선택
   - **Bundle Identifier**: `com.versecard.verseCardApp` (자동 입력됨)
   - **Status**: "Signing is configured" 표시되면 성공!

**확인 사항:**
- [ ] Debug Signing 완료
- [ ] Release Signing 완료
- [ ] Provisioning Profile 자동 생성됨
- [ ] Team ID: 3Q34V4BH5D 표시됨

**❌ 문제 발생 시:**
```bash
# 가이드 확인
open docs/XCODE_SIGNING_GUIDE.md
```

---

### 2️⃣ GitHub Pages 웹 호스팅 ⭐ (30분) - **필수!**

App Store 제출에 Privacy Policy URL과 Support URL이 **반드시** 필요합니다!

#### 방법 A: 자동 스크립트 (권장)

```bash
./scripts/deploy_github_pages.sh
```

스크립트가 단계별로 안내합니다:
1. GitHub 사용자명 입력
2. 레포지토리 이름 입력
3. GitHub에서 레포지토리 생성
4. 파일 푸시
5. GitHub Pages 설정

#### 방법 B: 수동 배포

```bash
# 1. 임시 디렉토리 생성
cd web
git init
git checkout -b gh-pages

# 2. 커밋
git add .
git commit -m "Initial GitHub Pages deployment"

# 3. GitHub에 새 레포지토리 생성
# https://github.com/new
# Repository name: verse-card-app (또는 원하는 이름)

# 4. 원격 저장소 연결 및 푸시
git remote add origin https://github.com/[USERNAME]/verse-card-app.git
git push -u origin gh-pages

# 5. GitHub Pages 활성화
# https://github.com/[USERNAME]/verse-card-app/settings/pages
# Source: gh-pages 브랜치 선택 → Save
```

**배포 완료 후 URL (메모하세요!):**
```
🌐 Privacy Policy: https://[USERNAME].github.io/verse-card-app/privacy.html
🌐 Support URL: https://[USERNAME].github.io/verse-card-app/support.html
🌐 Landing Page: https://[USERNAME].github.io/verse-card-app/
```

**체크:**
- [ ] GitHub Pages 배포 완료
- [ ] privacy.html 접속 확인
- [ ] support.html 접속 확인
- [ ] URL 복사해서 메모장에 저장

---

### 3️⃣ App Store Connect 앱 등록 (30분)

**URL:** https://appstoreconnect.apple.com

#### 3-1. 새 앱 생성

1. **My Apps** 클릭
2. 좌측 상단 **"+"** → **"New App"**
3. 정보 입력:
   - Platform: **iOS**
   - Name: **말씀묵상**
   - Primary Language: **Korean (한국어)**
   - Bundle ID: **com.versecard.verseCardApp** (드롭다운에서 선택)
   - SKU: **versecard-2025-001** (고유 식별자)
   - User Access: **Full Access**
4. **Create** 클릭

#### 3-2. App Information 작성

**좌측 메뉴에서 "App Information" 클릭**

```
Subtitle: 매일의 성경 말씀 카드
Category: 
  - Primary: Lifestyle
  - Secondary: Books (선택사항)
```

**연령 등급:**
- Edit 클릭 → 모든 질문에 "None" 답변 → 결과: 4+

#### 3-3. Pricing and Availability

```
Price: Free (무료)
Availability: 전 세계 또는 대한민국만
```

#### 3-4. App Privacy

```
질문: Does your app collect data from this app?
답변: No (데이터를 수집하지 않음)
```

#### 3-5. 버전 1.0 정보 입력

**좌측에서 "1.0 Prepare for Submission" 클릭**

**설명:**
```
매일 새로운 성경 말씀을 아름다운 카드로 만나보세요.

바쁜 일상 속에서도 잠깐의 시간을 내어 하나님의 말씀으로 하루를 시작하고, 위로와 힘을 얻으세요.

✨ 주요 기능

📖 매일 새로운 말씀
- 547개의 엄선된 성경 구절
- 창세기부터 요한계시록까지

🎨 아름다운 디자인
- 감동적인 배경 이미지
- 가독성 높은 한글 폰트

💾 저장 및 공유
- 말씀 카드를 이미지로 저장
- SNS로 쉽게 공유

📝 묵상 노트
- 개인적인 묵상 메모 작성
- 과거 말씀 다시 보기

🙏 간편한 사용
- 복잡한 설정 없이 바로 시작
- 오프라인에서도 사용 가능

하루를 시작하는 영감과 위로를 받아보세요.

"주의 말씀은 내 발에 등이요 내 길에 빛이니이다" - 시편 119:105
```

**키워드:**
```
성경,말씀,묵상,기도,신앙,크리스천,성경구절,카드,말씀카드,QT,큐티,기독교,교회
```

**URLs:**
```
Privacy Policy URL: [2단계에서 메모한 Privacy URL]
Support URL: [2단계에서 메모한 Support URL]
Marketing URL (선택): [2단계에서 메모한 Landing Page URL]
```

**연락처 정보:**
```
First Name: [이름]
Last Name: [성]
Phone: +82 10-XXXX-XXXX
Email: your.email@example.com
```

**심사 노트:**
```
안녕하세요. 말씀묵상 앱 심사를 부탁드립니다.

이 앱은 성경 말씀을 아름다운 카드로 제공하는 묵상 앱입니다.

주요 기능:
- 매일 새로운 성경 구절 제공 (총 547개)
- 말씀 카드를 이미지로 저장
- 개인 묵상 메모 작성

사진 라이브러리 권한:
- 사용자가 생성한 말씀 카드를 저장하기 위해서만 사용됩니다.
- 기존 사진을 읽거나 업로드하지 않습니다.

데이터 수집:
- 개인정보를 수집하지 않습니다.
- 모든 데이터는 기기에 로컬로 저장됩니다.

감사합니다.
```

**체크:**
- [ ] 앱 생성 완료
- [ ] App Information 작성
- [ ] Pricing 설정
- [ ] App Privacy 설정
- [ ] 버전 1.0 정보 입력
- [ ] URLs 입력
- [ ] 연락처 정보 입력

**📖 상세 가이드:**
```bash
open docs/APP_STORE_CONNECT_GUIDE.md
```

---

### 4️⃣ 스크린샷 촬영 (1시간)

**필수 크기:**
- 6.7" Display (1290 × 2796) - 최소 1개
- 6.5" Display (1242 × 2688) - 최소 1개

#### 방법 A: 수동 촬영 (권장 - 더 좋은 품질)

```bash
# iPhone 17 Pro Max로 앱 실행 (6.7" Display)
flutter run -d "iPhone 17 Pro Max"

# 앱이 실행되면 시뮬레이터에서:
# Cmd + S를 눌러 스크린샷 촬영
# 바탕화면에 자동 저장됨
```

**촬영할 화면 (순서대로):**
1. **홈 화면** - 앱 실행 직후 (오늘의 말씀 카드)
2. **전체화면 말씀** - 말씀 카드 클릭
3. **묵상 탭** - 하단 "묵상" 탭 클릭
4. **묵상 리스트** - 과거 말씀 목록
5. **묵상 상세** - 묵상 항목 클릭

**각 크기별로 동일한 화면 촬영:**
```bash
# 6.5" Display용 (iPhone 11 Pro Max가 없으므로 생략 가능)
# 또는 Xcode Simulator에서 다른 기기 선택
```

#### 방법 B: 자동 스크립트 (실험적)

```bash
./scripts/take_screenshots.sh
```

**스크린샷 업로드:**
1. App Store Connect → 1.0 Prepare for Submission
2. 스크린샷 섹션에서 이미지 드래그 앤 드롭
3. 순서 조정 (가장 중요한 화면이 첫 번째)

**체크:**
- [ ] 6.7" 스크린샷 최소 1개 업로드
- [ ] 6.5" 스크린샷 최소 1개 업로드 (선택사항)
- [ ] 스크린샷 순서 확인

**📖 상세 가이드:**
```bash
open docs/SCREENSHOT_GUIDE.md
```

---

### 5️⃣ Xcode Archive 생성 및 업로드 (30분)

**⚠️ 중요: 1단계(Xcode 서명)이 완료되어야 가능합니다!**

#### 5-1. Archive 생성

```bash
# Xcode 열기 (이미 열려있을 수 있음)
open ios/Runner.xcworkspace
```

**Xcode에서:**
1. 메뉴: **Product** → **Destination** → **"Any iOS Device (arm64)"** 선택
2. 메뉴: **Product** → **Archive** 클릭
3. 빌드 시작... (약 1-2분 소요)
4. 완료되면 **Organizer** 창이 자동으로 열림

#### 5-2. App Store Connect에 업로드

**Organizer 창에서:**
1. 방금 생성된 Archive 선택
2. 우측 **"Distribute App"** 버튼 클릭
3. **"App Store Connect"** 선택 → **Next**
4. **"Upload"** 선택 → **Next**
5. Distribution options:
   - ✅ **"Automatically manage signing"** 선택 → **Next**
6. 서명 확인 화면 → **Upload**
7. 업로드 진행... (5-10분 소요)
8. **"Upload Successful"** 메시지 확인!

#### 5-3. App Store Connect에서 확인

**App Store Connect:**
1. **TestFlight** 탭 클릭
2. 10-30분 후 빌드가 나타남 (자동 처리 중)
3. 빌드가 나타나면:
   - **Export Compliance** 정보 입력
   - **"Does your app use encryption?"** → **No**
   - 이미 Info.plist에 설정되어 있어서 자동으로 처리될 수도 있음

**체크:**
- [ ] Archive 생성 완료
- [ ] Upload 성공
- [ ] TestFlight에 빌드 표시됨
- [ ] Export Compliance 완료

---

### 6️⃣ TestFlight 테스트 (선택사항, 1-2일)

**내부 테스터로 본인 기기에서 테스트:**

1. **TestFlight** 탭에서 빌드 선택
2. **"Internal Testing"** 섹션
3. **"+"** 버튼 → 본인 이메일 추가
4. 저장
5. 이메일로 TestFlight 초대 받음
6. TestFlight 앱 다운로드 (App Store에서)
7. 초대 수락 후 앱 설치
8. 실제 기기에서 테스트

**테스트 항목:**
- [ ] 앱이 정상적으로 실행됨
- [ ] 홈 화면에 말씀 카드 표시
- [ ] 묵상 탭 이동
- [ ] 말씀 카드 저장 기능 (사진 권한 요청)
- [ ] 공유 기능
- [ ] 크래시 없음

---

### 7️⃣ 심사 제출 (10분)

**App Store Connect → 1.0 Prepare for Submission:**

1. **Build** 섹션에서 **"+"** 클릭
2. TestFlight에서 테스트 완료한 빌드 선택
3. **모든 정보 최종 확인:**
   - [ ] 스크린샷 업로드됨
   - [ ] 설명 작성됨
   - [ ] 키워드 입력됨
   - [ ] URLs 입력됨
   - [ ] 빌드 선택됨
   - [ ] 연락처 정보 입력됨

4. **Version Release** 선택:
   - ⭐ **"Manually release this version"** (권장)
     - 승인 후 직접 출시 버튼을 눌러야 함
     - 마케팅 준비 시간 확보 가능
   
   또는
   
   - **"Automatically release this version"**
     - 승인 즉시 자동 출시

5. 우측 상단 **"Submit for Review"** 버튼 클릭
6. 최종 확인 팝업 → **"Submit"** 클릭
7. **제출 완료!** 🎉

**심사 상태:**
```
Waiting For Review (대기 중) 
  ↓ 평균 1-3일
In Review (심사 중)
  ↓ 평균 24-48시간
Pending Developer Release (승인 완료)
  ↓ 수동 출시 선택 시
Ready for Sale (App Store에 출시!)
```

---

## 📊 진행 상황 요약

```
✅ Phase 1: 개발 완료 (100%)
✅ Phase 2: 문서화 완료 (100%)
⏳ Phase 3: 서명 및 빌드 (진행 필요)
⏳ Phase 4: App Store 등록 (진행 필요)
⏳ Phase 5: 심사 제출 (진행 필요)
```

**예상 소요 시간:**
- Xcode 서명: 10분
- GitHub Pages: 30분
- App Store 등록: 30분
- 스크린샷: 1시간
- Archive & Upload: 30분
- 심사 제출: 10분

**총 예상 시간: 약 3시간**

**심사 기간: 1-5일**

---

## 🆘 문제 해결

### 자주 발생하는 문제

**1. "No signing certificate found"**
```bash
open docs/XCODE_SIGNING_GUIDE.md
# 섹션 2 참고
```

**2. Archive 실패**
```bash
# 클린 후 재시도
flutter clean
cd ios
pod install
cd ..
open ios/Runner.xcworkspace
```

**3. 업로드 실패**
- Xcode 최신 버전 확인
- Apple Developer 계정 상태 확인
- 네트워크 연결 확인

**4. GitHub Pages가 작동하지 않음**
- 레포지토리가 Public인지 확인
- Settings → Pages에서 Source가 gh-pages로 설정되었는지 확인
- 5-10분 정도 기다리기 (배포 시간 필요)

---

## 📞 추가 도움

### 가이드 문서
```bash
# 전체 마스터 가이드
open IOS_RELEASE_COMPLETE_GUIDE.md

# Xcode 서명 문제
open docs/XCODE_SIGNING_GUIDE.md

# App Store Connect 상세
open docs/APP_STORE_CONNECT_GUIDE.md

# 스크린샷 가이드
open docs/SCREENSHOT_GUIDE.md
```

### 유용한 링크
- 🔗 [Apple Developer](https://developer.apple.com)
- 🔗 [App Store Connect](https://appstoreconnect.apple.com)
- 🔗 [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

---

## 🎉 출시 후 할 일

**출시 당일:**
- [ ] App Store에서 앱 검색
- [ ] 스크린샷 확인
- [ ] 다운로드 테스트
- [ ] SNS 공지

**첫 주:**
- [ ] 사용자 리뷰 모니터링
- [ ] 크래시 리포트 확인
- [ ] 피드백 수집

**첫 달:**
- [ ] 다운로드 수 확인
- [ ] 업데이트 계획 수립
- [ ] 버전 1.1.0 개발 시작

---

## 💪 화이팅!

**"주의 말씀은 내 발에 등이요 내 길에 빛이니이다" - 시편 119:105**

이제 시작입니다! 위의 단계를 하나씩 따라가면 됩니다.

궁금한 점이 있으면 각 가이드 문서를 참고하세요!

**성공적인 출시를 기원합니다! 🚀📱✨**


