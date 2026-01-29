# TestFlight 업로드 가이드 (1.0.1+12)

테스트용 기능 제거 후 업로드용 체크리스트입니다.

## ✅ 제거된 항목 (이번 업데이트)

- **테스트 알림 보내기** 버튼 및 `showTestNotification()` 제거
- **1월 1일 가데이터**: 이전에 1월 1일로 저장된 설치일은 자동으로 오늘 기준으로 초기화

## 📦 버전

- **1.0.1+12** (pubspec 반영됨)

---

## 1. Xcode에서 Archive 생성

```bash
open ios/Runner.xcworkspace
```

1. **Product** → **Destination** → **Any iOS Device (arm64)** 선택
2. **Product** → **Archive** 클릭
3. 빌드 완료 후 **Organizer** 창에서 해당 Archive 선택

---

## 2. App Store Connect 업로드

**Organizer**에서:

1. **Distribute App** 클릭
2. **App Store Connect** → Next
3. **Upload** → Next
4. **Automatically manage signing** 선택 → Next
5. **Upload** 실행
6. 완료 후 **Upload Successful** 확인

---

## 3. App Store Connect에서 처리

1. [App Store Connect](https://appstoreconnect.apple.com) → 해당 앱 → **TestFlight** 탭
2. 10–30분 내 새 빌드 **1.0.1 (12)** 표시 확인
3. 빌드 선택 후 **Export Compliance**:
   - **Does your app use encryption?** → **No**
4. 필요 시 **내부 테스트** 그룹에 빌드 추가

---

## 4. 빌드 실패 시 (iOS Platform Not Installed 등)

1. **Xcode** → **Settings (⌘,)** → **Platforms**
2. **iOS 26.2** 확인 후, 필요 시 제거 후 재설치
3. Xcode 완전 종료(⌘Q) 후 재실행
4. **Product** → **Clean Build Folder (⌘⇧K)** 후 Archive 재시도

---

## 5. Flutter 로컬 빌드 검증 (선택)

```bash
flutter clean && flutter pub get
cd ios && pod install && cd ..
flutter build ios --release
```

실기기 연결 시 `flutter run --release` 로 설치 테스트 가능.
