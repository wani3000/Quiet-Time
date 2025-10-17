# 📱 App Store Connect 설정 완벽 가이드

## 목차
1. [App Store Connect 앱 등록](#1-app-store-connect-앱-등록)
2. [앱 정보 작성](#2-앱-정보-작성)
3. [스크린샷 및 미리보기](#3-스크린샷-및-미리보기)
4. [앱 심사 정보](#4-앱-심사-정보)
5. [가격 및 배포](#5-가격-및-배포)
6. [빌드 업로드](#6-빌드-업로드)
7. [TestFlight 테스트](#7-testflight-테스트)
8. [심사 제출](#8-심사-제출)

---

## 1. App Store Connect 앱 등록

### 1-1. 앱 생성

1. **App Store Connect 접속**
   - 🔗 https://appstoreconnect.apple.com
   - Apple Developer 계정으로 로그인

2. **새 앱 생성**
   - 좌측 메뉴에서 **"My Apps"** 클릭
   - 우측 상단 **"+"** 버튼 → **"New App"** 선택

3. **기본 정보 입력**

   **말씀묵상 앱 권장 설정:**
   ```
   Platform: ✅ iOS
   Name: 말씀묵상
   Primary Language: Korean (한국어)
   Bundle ID: com.versecard.verseCardApp (드롭다운에서 선택)
   SKU: versecard-2025-001
   User Access: Full Access (기본값)
   ```

   > **중요:** Bundle ID는 Xcode에서 사용한 것과 동일해야 합니다!

4. **생성 완료**
   - "Create" 버튼 클릭
   - 앱이 생성되면 자동으로 앱 상세 페이지로 이동

---

## 2. 앱 정보 작성

### 2-1. 일반 정보 (General Information)

**App Store에서 "App Information" 탭 클릭**

#### 기본 정보

| 항목 | 값 | 설명 |
|-----|-----|------|
| **Name** | 말씀묵상 | App Store에 표시될 이름 (30자 제한) |
| **Subtitle** | 매일의 성경 말씀 카드 | 짧은 설명 (30자 제한) |
| **Bundle ID** | com.versecard.verseCardApp | 자동 입력됨 |
| **SKU** | versecard-2025-001 | 내부 참조용 고유 ID |

#### 카테고리

```
Primary Category: Lifestyle
Secondary Category: Books (선택사항)
```

**다른 카테고리 옵션:**
- Reference (참고 자료)
- Education (교육)
- Productivity (생산성)

#### 콘텐츠 권한

- **Content Rights**: ✅ "Does not contain, show, or access third-party content"
  (제3자 콘텐츠를 포함하거나 표시하거나 액세스하지 않음)

#### 연령 등급

"Edit" 버튼 클릭하여 질문에 답변:

**말씀묵상 앱 권장 답변:**
```
Cartoon or Fantasy Violence: None
Realistic Violence: None
Sexual Content or Nudity: None
Profanity or Crude Humor: None
Alcohol, Tobacco, or Drug Use: None
Mature/Suggestive Themes: None
Horror/Fear Themes: None
Medical/Treatment Information: None
Gambling: None
Unrestricted Web Access: None
Gambling and Contests: None

→ 결과: 4+ (모든 연령)
```

---

### 2-2. 가격 및 가용성 (Pricing and Availability)

**좌측 메뉴에서 "Pricing and Availability" 클릭**

#### 가격 설정

```
Price: Free (무료)
또는
Price: ₩1,200 (유료로 하려면 해당 금액 선택)
```

**권장:** 초기 출시는 무료로 시작, 추후 인앱 구매 추가

#### 가용성 (Availability)

- **전 세계 출시:**
  - "Make this app available in all territories" 선택

- **특정 국가만:**
  - "Select territories manually" 선택
  - 대한민국만 선택 (또는 원하는 국가)

#### Pre-Order (사전 주문)

- 일반적으로 사용하지 않음

---

## 3. 스크린샷 및 미리보기

### 3-1. 필수 스크린샷 크기

**좌측 메뉴에서 "1.0 Prepare for Submission" 클릭**

#### iPhone 스크린샷 (필수)

| 디바이스 | 크기 (픽셀) | 최소/최대 개수 |
|---------|-----------|--------------|
| **6.7" Display** | 1290 × 2796 | 최소 1개, 최대 10개 |
| **6.5" Display** | 1242 × 2688 | 최소 1개, 최대 10개 |
| 5.5" Display | 1242 × 2208 | 선택사항 |

> **중요:** 6.7"와 6.5" 둘 다 필수입니다!

#### iPad 스크린샷 (선택사항)

| 디바이스 | 크기 (픽셀) |
|---------|-----------|
| 12.9" iPad Pro | 2048 × 2732 |
| 11" iPad Pro | 1668 × 2388 |

---

### 3-2. 스크린샷 순서 및 내용 권장

**말씀묵상 앱 스크린샷 구성:**

1. **메인 화면** - 오늘의 말씀 카드 (가장 매력적인 화면)
2. **전체화면 말씀** - 말씀 카드 전체 보기
3. **묵상 리스트** - 과거 말씀 목록
4. **묵상 상세** - 메모 작성 화면
5. **공유 기능** - 카드 저장/공유 기능 강조

**스크린샷 팁:**
- ✅ 실제 콘텐츠 사용 (샘플 데이터)
- ✅ 밝고 깔끔한 화면
- ✅ 한국어 인터페이스
- ❌ 상태바에 배터리/시간 표시 (일관성 유지)

---

### 3-3. App Preview Video (선택사항)

**권장하지만 필수는 아님**

- 길이: 15-30초
- 형식: .mov, .mp4
- 크기: 6.7" Display용 1290 × 2796
- 내용: 앱의 주요 기능 빠르게 시연

---

## 4. 앱 설명 작성

### 4-1. Description (설명)

**최대 4,000자**

**말씀묵상 앱 설명 예시:**

```markdown
매일 새로운 성경 말씀을 아름다운 카드로 만나보세요.

바쁜 일상 속에서도 잠깐의 시간을 내어 하나님의 말씀으로 하루를 시작하고, 위로와 힘을 얻으세요. 말씀묵상 앱은 엄선된 성경 구절과 감동적인 배경 이미지를 통해 쉽고 아름답게 말씀을 묵상할 수 있도록 도와줍니다.

✨ 주요 기능

📖 매일 새로운 말씀
- 547개의 엄선된 성경 구절
- 창세기부터 요한계시록까지 전체 성경에서 선별
- 날짜별로 자동 배정되는 오늘의 말씀

🎨 아름다운 디자인
- 감동적인 배경 이미지와 함께
- 가독성 높은 한글 폰트 (Pretendard)
- 깔끔하고 현대적인 UI/UX

💾 저장 및 공유
- 말씀 카드를 이미지로 저장
- SNS로 쉽게 공유
- 친구들과 은혜로운 말씀 나누기

📝 묵상 노트
- 개인적인 묵상 메모 작성
- 과거 말씀 다시 보기
- 나만의 영적 일기

🙏 간편한 사용
- 복잡한 설정 없이 바로 시작
- 직관적인 인터페이스
- 오프라인에서도 사용 가능

------

이런 분들께 추천합니다:

✓ 매일 성경 말씀으로 하루를 시작하고 싶은 분
✓ 간편하게 말씀을 묵상하고 싶은 분
✓ 아름다운 말씀 카드를 만들고 싶은 분
✓ 영적 성장을 위한 도구를 찾는 분
✓ 친구나 가족과 말씀을 나누고 싶은 분

------

말씀묵상 앱과 함께 매일 하나님의 말씀으로 채워지는 삶을 경험하세요.

"주의 말씀은 내 발에 등이요 내 길에 빛이니이다" - 시편 119:105
```

---

### 4-2. Keywords (키워드)

**최대 100자 (쉼표로 구분)**

**말씀묵상 앱 키워드 예시:**
```
성경,말씀,묵상,기도,신앙,크리스천,성경구절,카드,말씀카드,QT,큐티,기독교,교회,찬양,은혜,감사,위로,희망
```

**키워드 선택 팁:**
- ✅ 앱 기능 관련 키워드
- ✅ 검색될 만한 단어
- ✅ 경쟁 앱이 사용하는 키워드 분석
- ❌ 브랜드명, 중복 키워드 피하기

---

### 4-3. Promotional Text (홍보 문구)

**최대 170자 (업데이트 없이 변경 가능)**

```
🎉 새로운 기능 업데이트!
더욱 빨라진 성능과 개선된 사용자 경험을 만나보세요.
매일 말씀과 함께하는 은혜로운 하루를 시작하세요.
```

---

### 4-4. Support URL (지원 URL)

**필수 입력**

옵션:
1. 개인 웹사이트 (있으면)
2. GitHub 페이지
3. 간단한 랜딩 페이지

```
예시: https://versecard.app/support
또는: https://github.com/yourusername/verse-card-app
```

---

### 4-5. Marketing URL (마케팅 URL)

**선택사항**

```
예시: https://versecard.app
```

---

## 5. 개인정보 보호 정책

### 5-1. Privacy Policy URL

**필수 입력**

```
예시: https://versecard.app/privacy
```

> 다음 섹션에서 개인정보 보호정책 HTML 파일을 제공합니다.

---

### 5-2. App Privacy (앱 개인정보)

**좌측 메뉴에서 "App Privacy" 클릭**

#### 말씀묵상 앱의 개인정보 수집 현황:

**질문: "Does your app collect data from this app?"**

**답변 옵션:**

**옵션 A: 데이터를 전혀 수집하지 않는 경우**
```
→ No, this app does not collect data from this app

설명: 
- 사용자 계정 없음
- 서버에 데이터 저장 안 함
- 로컬 저장만 사용 (SharedPreferences)
```

**옵션 B: 사진 접근만 하는 경우**
```
→ Yes, this app collects data from this app

Data Types:
- Photos or Videos: 수집하지 않음 (저장 권한만 사용)
- Usage Data: 수집하지 않음

설명:
- 사진 라이브러리에 말씀 카드를 저장하기 위한 권한만 요청
- 사진을 읽거나 업로드하지 않음
```

**권장:** 옵션 A (데이터 수집 안 함)

---

## 6. 앱 심사 정보 (App Review Information)

### 6-1. 연락처 정보

```
First Name: [이름]
Last Name: [성]
Phone Number: +82 10-XXXX-XXXX
Email: your.email@example.com
```

---

### 6-2. Demo Account (데모 계정)

**질문: "Does your app require signing in?"**

```
→ No (말씀묵상 앱은 로그인 불필요)
```

로그인이 필요한 앱이라면:
```
Username: demo@example.com
Password: TestPassword123!
Notes: 데모 계정 관련 추가 설명
```

---

### 6-3. Notes (참고 사항)

**심사자에게 전달할 메시지**

```
안녕하세요. 말씀묵상 앱 심사를 부탁드립니다.

이 앱은 성경 말씀을 아름다운 카드 형태로 제공하는 묵상 앱입니다.

주요 기능:
- 매일 새로운 성경 구절 제공 (총 547개)
- 말씀 카드를 이미지로 저장 (사진 라이브러리 접근 권한 필요)
- 개인 묵상 메모 작성 (로컬 저장)

사진 라이브러리 권한:
- 사용자가 생성한 말씀 카드를 기기에 저장하기 위해서만 사용됩니다.
- 기존 사진을 읽거나 업로드하지 않습니다.

데이터 수집:
- 사용자 데이터를 수집하거나 서버로 전송하지 않습니다.
- 모든 데이터는 기기에 로컬로 저장됩니다.

테스트 방법:
1. 앱 실행 시 오늘의 말씀 카드가 자동으로 표시됩니다.
2. 하단 네비게이션에서 "묵상" 탭을 눌러 과거 말씀을 확인할 수 있습니다.
3. 말씀 카드를 길게 눌러 저장 또는 공유할 수 있습니다.

감사합니다.
```

---

### 6-4. Attachment (첨부 파일)

**선택사항**

- 데모 비디오 (YouTube 링크)
- PDF 사용 가이드
- 특별 지침 문서

---

## 7. 버전 정보 (Version Information)

### 7-1. Version Release

**질문: "How would you like to release this version?"**

```
옵션 1: Manually release this version (수동 출시)
→ 심사 승인 후 직접 "Release" 버튼을 눌러야 출시됨 (권장)

옵션 2: Automatically release this version (자동 출시)
→ 심사 승인되면 즉시 App Store에 출시됨

옵션 3: Automatically release after another app is approved
→ 다른 앱 승인 후 자동 출시
```

**권장:** 수동 출시 (처음에는 준비 시간 필요)

---

### 7-2. What's New (업데이트 내용)

**버전 1.0.0:**
```
말씀묵상 앱 출시 🎉

• 547개의 엄선된 성경 말씀 제공
• 아름다운 배경 이미지와 함께하는 말씀 카드
• 말씀 카드 저장 및 공유 기능
• 개인 묵상 노트 작성
• 날짜별 말씀 보기

매일 하나님의 말씀으로 채워지는 삶을 시작하세요!
```

---

## 8. 빌드 선택 및 제출

### 8-1. Build 선택

1. **"Build" 섹션에서 "+" 버튼 클릭**
2. **TestFlight에서 테스트 완료한 빌드 선택**
3. **Export Compliance 정보 입력:**
   ```
   Does your app use encryption? → No
   (이미 Info.plist에 ITSAppUsesNonExemptEncryption: false 설정됨)
   ```

---

### 8-2. 최종 확인 체크리스트

- [ ] 앱 이름, 부제, 설명 작성 완료
- [ ] 스크린샷 6.7" 최소 1개 업로드
- [ ] 스크린샷 6.5" 최소 1개 업로드
- [ ] 앱 아이콘 1024x1024 업로드 (자동)
- [ ] 카테고리 선택 완료
- [ ] 연령 등급 완료 (4+)
- [ ] 개인정보 보호정책 URL 입력
- [ ] Support URL 입력
- [ ] App Privacy 정보 입력
- [ ] 연락처 정보 입력
- [ ] 빌드 선택 완료
- [ ] Version Release 옵션 선택

---

### 8-3. 심사 제출

1. **우측 상단 "Submit for Review" 버튼 클릭**
2. **최종 확인 팝업에서 "Submit" 클릭**
3. **제출 완료!**

---

## 9. 심사 프로세스

### 9-1. 심사 단계

```
1. Waiting For Review (대기 중)
   ↓ 평균 1-3일

2. In Review (심사 중)
   ↓ 평균 24-48시간

3. Pending Developer Release (승인 완료, 출시 대기)
   → 수동 출시 선택 시
   
   또는
   
   Ready for Sale (App Store에 출시됨)
   → 자동 출시 선택 시
```

### 9-2. 심사 거부 시 대응

**일반적인 거부 사유:**

1. **스크린샷 문제**
   - 해결: 실제 앱 화면으로 교체

2. **개인정보 보호정책 미비**
   - 해결: 명확한 정책 페이지 제공

3. **앱 기능 불명확**
   - 해결: Notes에 상세한 사용 방법 추가

4. **권한 설명 부족**
   - 해결: Info.plist의 권한 설명 더 명확하게 작성

**거부 후 재제출:**
1. Resolution Center에서 거부 사유 확인
2. 문제 수정
3. "Submit for Review" 다시 클릭

---

## 10. 출시 후 관리

### 10-1. Analytics (분석)

App Store Connect → Analytics에서 확인 가능:
- 다운로드 수
- 업데이트 횟수
- 노출 수 (Impressions)
- 제품 페이지 조회수
- 설치 전환율

### 10-2. Reviews (리뷰 관리)

- 사용자 리뷰에 답변하기
- 별점 트렌드 모니터링
- 피드백 기반 업데이트 계획

### 10-3. 업데이트 배포

1. 코드 수정
2. `pubspec.yaml`에서 버전 증가
   ```yaml
   version: 1.0.1+2  # version+build
   ```
3. 새 빌드 업로드
4. App Store Connect에서 새 버전 생성
5. "What's New" 작성
6. 심사 제출

---

## 11. 자주 묻는 질문

### Q1: 심사에 얼마나 걸리나요?
**A:** 평균 24-48시간이지만, 첫 번째 앱이나 주요 업데이트는 2-5일 걸릴 수 있습니다.

### Q2: 심사 중에 빌드를 변경할 수 있나요?
**A:** 아니요. 심사를 취소하고 새 빌드로 다시 제출해야 합니다.

### Q3: 가격을 나중에 변경할 수 있나요?
**A:** 네, Pricing and Availability에서 언제든지 변경 가능합니다.

### Q4: 특정 국가에서만 앱을 출시할 수 있나요?
**A:** 네, Availability 섹션에서 국가를 선택할 수 있습니다.

### Q5: 앱 이름을 변경하려면?
**A:** 새 버전 제출 시 변경 가능하지만, 심사가 필요합니다.

---

## 12. 유용한 링크

- 📘 [App Store Connect 헬프](https://help.apple.com/app-store-connect/)
- 📘 [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- 📘 [App Store 마케팅 가이드](https://developer.apple.com/app-store/marketing/guidelines/)
- 🎬 [WWDC Videos](https://developer.apple.com/videos/)

---

**이 가이드를 따라 말씀묵상 앱을 성공적으로 출시하세요!** 🚀

궁금한 점이 있으면 언제든 문의하세요!


