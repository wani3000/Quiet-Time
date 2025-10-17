#!/bin/bash

# 📸 말씀묵상 앱 - 스크린샷 자동 촬영 스크립트
# App Store 제출용 스크린샷을 자동으로 촬영합니다.

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 출력 디렉토리
OUTPUT_DIR="screenshots"
DATE=$(date +%Y%m%d_%H%M%S)
SESSION_DIR="${OUTPUT_DIR}/${DATE}"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📱 말씀묵상 앱 - 스크린샷 자동 촬영${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 디렉토리 생성
mkdir -p "${SESSION_DIR}/6.7inch"
mkdir -p "${SESSION_DIR}/6.5inch"
mkdir -p "${SESSION_DIR}/5.5inch"
mkdir -p "${SESSION_DIR}/12.9inch_ipad"

# 디바이스 목록
declare -A DEVICES=(
    ["iPhone 15 Pro Max"]="6.7inch"
    ["iPhone 14 Pro Max"]="6.7inch"
    ["iPhone 14 Plus"]="6.5inch"
    ["iPhone 11 Pro Max"]="6.5inch"
)

# 사용 가능한 시뮬레이터 확인
echo -e "${YELLOW}⏳ 사용 가능한 시뮬레이터 확인 중...${NC}"
xcrun simctl list devices available | grep -E "iPhone (15 Pro Max|14 Pro Max|14 Plus|11 Pro Max)" || {
    echo -e "${RED}❌ 필요한 시뮬레이터를 찾을 수 없습니다.${NC}"
    echo -e "${YELLOW}💡 다음 명령어로 시뮬레이터를 설치하세요:${NC}"
    echo "   Xcode → Settings → Platforms → iOS → + 버튼"
    exit 1
}

# 함수: 시뮬레이터 부팅
boot_simulator() {
    local device_name="$1"
    echo -e "${YELLOW}🚀 시뮬레이터 부팅 중: ${device_name}${NC}"
    
    # 디바이스 UDID 찾기
    local device_udid=$(xcrun simctl list devices available | grep "${device_name}" | head -1 | grep -E -o -i "([0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})")
    
    if [ -z "$device_udid" ]; then
        echo -e "${RED}❌ ${device_name}을(를) 찾을 수 없습니다.${NC}"
        return 1
    fi
    
    # 시뮬레이터 부팅
    xcrun simctl boot "$device_udid" 2>/dev/null || true
    sleep 5
    
    echo "$device_udid"
}

# 함수: 앱 실행
launch_app() {
    local device_udid="$1"
    echo -e "${YELLOW}📱 앱 실행 중...${NC}"
    
    # Flutter 앱 실행 (백그라운드)
    flutter run -d "$device_udid" &
    local flutter_pid=$!
    
    # 앱이 완전히 로드될 때까지 대기
    echo -e "${YELLOW}⏳ 앱 로딩 대기 중 (30초)...${NC}"
    sleep 30
    
    echo "$flutter_pid"
}

# 함수: 스크린샷 촬영
take_screenshot() {
    local device_udid="$1"
    local output_dir="$2"
    local filename="$3"
    local description="$4"
    
    echo -e "${GREEN}📸 촬영: ${description}${NC}"
    
    # 스크린샷 촬영
    xcrun simctl io "$device_udid" screenshot "${output_dir}/${filename}.png"
    
    # 잠시 대기
    sleep 2
}

# 함수: 시뮬레이터 제어 (탭 등)
tap_coordinates() {
    local device_udid="$1"
    local x="$2"
    local y="$3"
    
    xcrun simctl io "$device_udid" tap "$x" "$y"
    sleep 1
}

# 메인 프로세스
main() {
    echo -e "${BLUE}📋 촬영 계획:${NC}"
    echo "  1. 홈 화면 (오늘의 말씀)"
    echo "  2. 말씀 카드 전체화면"
    echo "  3. 묵상 리스트"
    echo "  4. 묵상 상세 페이지"
    echo "  5. 공유 화면"
    echo ""
    
    # iPhone 15 Pro Max (6.7인치)에서 촬영
    local device_name="iPhone 15 Pro Max"
    local device_udid=$(boot_simulator "$device_name")
    
    if [ -z "$device_udid" ]; then
        echo -e "${RED}❌ 시뮬레이터 부팅 실패${NC}"
        exit 1
    fi
    
    # 앱 실행
    local flutter_pid=$(launch_app "$device_udid")
    
    # 스크린샷 촬영 시작
    local output_dir="${SESSION_DIR}/6.7inch"
    
    # 1. 홈 화면
    take_screenshot "$device_udid" "$output_dir" "01_home" "홈 화면 - 오늘의 말씀"
    
    # 2. 말씀 카드 탭 (중앙 카드 클릭)
    echo -e "${YELLOW}🖱️  말씀 카드 클릭...${NC}"
    tap_coordinates "$device_udid" "390" "800"
    sleep 2
    take_screenshot "$device_udid" "$output_dir" "02_fullscreen" "전체화면 말씀 카드"
    
    # 뒤로가기
    tap_coordinates "$device_udid" "50" "100"
    sleep 1
    
    # 3. 묵상 탭으로 이동
    echo -e "${YELLOW}🖱️  묵상 탭 클릭...${NC}"
    tap_coordinates "$device_udid" "540" "2700"  # 하단 네비게이션 바의 묵상 탭
    sleep 2
    take_screenshot "$device_udid" "$output_dir" "03_meditation_list" "묵상 리스트"
    
    # 4. 묵상 아이템 클릭
    echo -e "${YELLOW}🖱️  묵상 아이템 클릭...${NC}"
    tap_coordinates "$device_udid" "390" "600"
    sleep 2
    take_screenshot "$device_udid" "$output_dir" "04_meditation_detail" "묵상 상세 페이지"
    
    # 5. 공유 버튼 (있다면)
    echo -e "${YELLOW}🖱️  공유 버튼 클릭...${NC}"
    tap_coordinates "$device_udid" "600" "150"
    sleep 2
    take_screenshot "$device_udid" "$output_dir" "05_share" "공유 화면"
    
    # Flutter 앱 종료
    echo -e "${YELLOW}🛑 앱 종료 중...${NC}"
    kill $flutter_pid 2>/dev/null || true
    
    # 시뮬레이터 종료
    echo -e "${YELLOW}🛑 시뮬레이터 종료 중...${NC}"
    xcrun simctl shutdown "$device_udid"
    
    echo ""
    echo -e "${GREEN}✅ 스크린샷 촬영 완료!${NC}"
    echo -e "${BLUE}📁 저장 위치: ${SESSION_DIR}${NC}"
    echo ""
    
    # 결과 요약
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📊 촬영 결과${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    ls -lh "${output_dir}" | tail -n +2
    echo ""
    
    # 폴더 열기
    echo -e "${YELLOW}💡 스크린샷 폴더를 여시겠습니까? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        open "${SESSION_DIR}"
    fi
}

# 스크립트 실행
main

echo ""
echo -e "${GREEN}🎉 완료! App Store Connect에 업로드할 준비가 되었습니다.${NC}"
echo ""
echo -e "${YELLOW}💡 다음 단계:${NC}"
echo "  1. 스크린샷 확인 및 편집 (필요시)"
echo "  2. App Store Connect → 스크린샷 업로드"
echo "  3. 6.5인치용 스크린샷도 동일하게 촬영 권장"
echo ""


