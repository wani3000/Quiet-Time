# 📸 스크린샷 촬영 가이드

## 자동 촬영 스크립트

### 사용 방법

```bash
# 1. 스크립트에 실행 권한 부여
chmod +x scripts/take_screenshots.sh

# 2. 스크립트 실행
./scripts/take_screenshots.sh
```

### 스크립트 기능

- ✅ iPhone 15 Pro Max (6.7인치) 시뮬레이터 자동 실행
- ✅ 앱 자동 실행
- ✅ 주요 화면 자동 촬영
- ✅ 날짜별 폴더에 자동 저장

### 촬영되는 화면

1. **홈 화면** - 오늘의 말씀 카드
2. **전체화면 말씀** - 말씀 카드 상세보기
3. **묵상 리스트** - 과거 말씀 목록
4. **묵상 상세** - 메모 작성 화면
5. **공유 화면** - 공유 옵션

---

## 수동 촬영 방법

### 방법 1: 시뮬레이터에서 촬영 (권장)

#### 1단계: 시뮬레이터 실행

```bash
# iPhone 15 Pro Max (6.7인치)
flutter run -d "iPhone 15 Pro Max"

# 또는 iPhone 14 Plus (6.5인치)
flutter run -d "iPhone 14 Plus"
```

#### 2단계: 스크린샷 촬영

**macOS에서:**
- `Cmd + S` : 스크린샷 촬영
- 자동으로 바탕화면에 저장됨

**또는 메뉴에서:**
- Device → Screenshot
- File → New Screen Recording (동영상)

#### 3단계: 화면별 촬영

| 순서 | 화면 | 조작 방법 |
|-----|------|---------|
| 1 | 홈 화면 | 앱 실행 직후 |
| 2 | 전체화면 말씀 | 말씀 카드 클릭 |
| 3 | 묵상 리스트 | 하단 "묵상" 탭 클릭 |
| 4 | 묵상 상세 | 묵상 항목 클릭 |
| 5 | 공유 화면 | 공유 버튼 클릭 |

---

### 방법 2: 실제 기기에서 촬영

#### 1단계: 기기 연결 및 앱 실행

```bash
# 기기 확인
flutter devices

# 기기에 앱 설치
flutter run -d [DEVICE_ID]
```

#### 2단계: 스크린샷 촬영

**iPhone에서:**
- iPhone X 이상: 측면 버튼 + 볼륨 업 동시 누르기
- iPhone 8 이하: 홈 버튼 + 전원 버튼 동시 누르기

#### 3단계: Mac으로 전송

**방법 A: AirDrop**
- 사진 앱 → 스크린샷 선택 → 공유 → AirDrop → Mac 선택

**방법 B: iCloud Photos**
- 자동으로 Mac의 사진 앱에 동기화

**방법 C: Image Capture**
```bash
# Image Capture 앱 열기
open -a "Image Capture"
# iPhone 선택 후 사진 가져오기
```

---

## 스크린샷 크기 및 요구사항

### App Store 필수 크기

| 디바이스 | 크기 (픽셀) | 비율 | 필수 여부 |
|---------|-----------|------|---------|
| iPhone 6.7" | 1290 × 2796 | 19.5:9 | ✅ 필수 |
| iPhone 6.5" | 1242 × 2688 | 19.5:9 | ✅ 필수 |
| iPhone 5.5" | 1242 × 2208 | 16:9 | ⚪ 선택 |
| iPad 12.9" | 2048 × 2732 | 4:3 | ⚪ 선택 |
| iPad 11" | 1668 × 2388 | 4:3 | ⚪ 선택 |

### 대응 디바이스

| 크기 | 대응 디바이스 |
|-----|-------------|
| 6.7" | iPhone 15 Pro Max, 15 Plus, 14 Pro Max, 14 Plus, 13 Pro Max, 12 Pro Max |
| 6.5" | iPhone 11 Pro Max, XS Max |
| 5.5" | iPhone 8 Plus, 7 Plus, 6s Plus |

---

## 스크린샷 편집 가이드

### 편집 도구

**무료 도구:**
1. **Preview (미리보기)** - macOS 기본 앱
2. **Screenshots.pro** - 웹 기반
3. **App Store Screenshots** - 웹 기반

**유료 도구:**
1. **Figma** - 디자인 도구
2. **Sketch** - macOS 전용
3. **Adobe Photoshop**

### 편집 체크리스트

- [ ] 상태바 시간을 9:41로 변경 (Apple 표준)
- [ ] 상태바 배터리 100% 표시
- [ ] 화면 가장자리 정리
- [ ] 실제 콘텐츠 사용 (로렘 입숨 제거)
- [ ] 한국어 UI 확인
- [ ] 일관된 테마 유지

---

## 상태바 클린업 (선택사항)

### Xcode에서 상태바 커스터마이징

**ios/Runner/Info.plist에 추가:**
```xml
<key>UIStatusBarStyle</key>
<string>UIStatusBarStyleLightContent</string>
<key>UIViewControllerBasedStatusBarAppearance</key>
<false/>
```

### 시뮬레이터 상태바 클린

**명령어:**
```bash
# 상태바를 9:41, 100% 배터리로 설정
xcrun simctl status_bar booted override --time "9:41" --batteryLevel 100 --batteryState charged --wifiBars 3 --cellularBars 4

# 원래대로 복원
xcrun simctl status_bar booted clear
```

---

## 스크린샷 자동화 (고급)

### Fastlane Snapshot 사용

#### 1. Fastlane 설치

```bash
# Homebrew로 설치
brew install fastlane

# 또는 RubyGems로 설치
sudo gem install fastlane
```

#### 2. Fastlane 초기화

```bash
cd ios
fastlane init
```

#### 3. Snapfile 설정

**ios/fastlane/Snapfile:**
```ruby
devices([
  "iPhone 15 Pro Max",
  "iPhone 14 Plus"
])

languages([
  "ko"
])

scheme("Runner")

output_directory("../screenshots")

clear_previous_screenshots(true)

reinstall_app(true)
```

#### 4. UI 테스트 작성

**ios/RunnerUITests/RunnerUITests.swift:**
```swift
import XCTest

class RunnerUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    func testScreenshots() {
        let app = XCUIApplication()
        
        // 1. 홈 화면
        snapshot("01_Home")
        sleep(2)
        
        // 2. 말씀 카드 클릭
        app.images.element(boundBy: 0).tap()
        snapshot("02_Fullscreen")
        sleep(2)
        
        // 3. 묵상 탭
        app.tabBars.buttons["묵상"].tap()
        snapshot("03_Meditation_List")
        sleep(2)
        
        // 4. 묵상 상세
        app.tables.cells.element(boundBy: 0).tap()
        snapshot("04_Meditation_Detail")
    }
}
```

#### 5. 스크린샷 촬영 실행

```bash
fastlane snapshot
```

---

## 촬영 후 체크리스트

### 기본 확인

- [ ] 모든 필수 화면 촬영 완료 (5개)
- [ ] 6.7인치용 스크린샷 (최소 1개)
- [ ] 6.5인치용 스크린샷 (최소 1개)
- [ ] 파일 크기 확인 (각 8MB 이하)
- [ ] 파일 형식: PNG 또는 JPG

### 품질 확인

- [ ] 화면이 선명함 (압축 없음)
- [ ] 실제 콘텐츠 사용
- [ ] 텍스트 가독성 확인
- [ ] UI 요소가 잘 보임
- [ ] 로딩 인디케이터 없음

### 콘텐츠 확인

- [ ] 저작권 있는 이미지 미포함
- [ ] 개인정보 미포함
- [ ] 테스트 데이터 미포함
- [ ] 적절한 콘텐츠 (성경 말씀)

---

## 스크린샷 순서 최적화

### App Store 표시 순서

사용자는 첫 3개 스크린샷을 스크롤 없이 볼 수 있습니다.

**권장 순서:**

1. **🏠 홈 화면** (가장 매력적인 화면)
   - 오늘의 말씀 카드
   - 깔끔한 디자인 강조

2. **📖 전체화면 말씀** (핵심 기능)
   - 아름다운 배경 이미지
   - 큰 텍스트로 가독성 강조

3. **📝 묵상 리스트** (기능 설명)
   - 과거 말씀 보기 기능
   - 날짜별 정리

4. **✍️ 묵상 상세** (추가 기능)
   - 개인 메모 작성 기능

5. **📤 공유** (소셜 기능)
   - SNS 공유 기능

---

## 문제 해결

### Q1: 시뮬레이터가 느려요
**A:** 
```bash
# 시뮬레이터 재시작
killall Simulator
# Derived Data 삭제
rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

### Q2: 스크린샷 크기가 맞지 않아요
**A:** 올바른 시뮬레이터를 사용하고 있는지 확인하세요.
```bash
# 시뮬레이터 크기 확인
xcrun simctl list devices | grep "iPhone 15 Pro Max"
```

### Q3: 화면이 잘려요
**A:** Safe Area를 고려한 UI 디자인인지 확인하세요.

### Q4: 자동 스크립트가 작동하지 않아요
**A:** 
```bash
# 권한 확인
ls -la scripts/take_screenshots.sh
# 권한 부여
chmod +x scripts/take_screenshots.sh
```

---

## 참고 자료

- 📘 [Apple 스크린샷 가이드](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications)
- 📘 [App Store Marketing Guidelines](https://developer.apple.com/app-store/marketing/guidelines/)
- 🎬 [WWDC: App Store Product Page](https://developer.apple.com/videos/)

---

**완벽한 스크린샷으로 앱의 첫인상을 만드세요!** 📸✨


