#!/bin/bash

# 🌐 GitHub Pages 배포 스크립트
# 웹 페이지를 GitHub Pages에 자동 배포합니다

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🌐 GitHub Pages 배포 준비${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# GitHub 사용자명 입력
echo -e "${YELLOW}GitHub 사용자명을 입력하세요:${NC}"
read -r github_username

if [ -z "$github_username" ]; then
    echo -e "${RED}❌ GitHub 사용자명이 필요합니다.${NC}"
    exit 1
fi

# 레포지토리 이름 입력
echo -e "${YELLOW}레포지토리 이름을 입력하세요 (기본값: verse-card-app):${NC}"
read -r repo_name
repo_name=${repo_name:-verse-card-app}

echo ""
echo -e "${BLUE}📋 배포 정보:${NC}"
echo -e "  GitHub 사용자: ${GREEN}${github_username}${NC}"
echo -e "  레포지토리: ${GREEN}${repo_name}${NC}"
echo -e "  배포 URL: ${GREEN}https://${github_username}.github.io/${repo_name}/${NC}"
echo ""

# 확인
echo -e "${YELLOW}계속하시겠습니까? (y/n)${NC}"
read -r confirm
if [[ ! "$confirm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${RED}배포가 취소되었습니다.${NC}"
    exit 0
fi

# 임시 디렉토리 생성
TEMP_DIR=$(mktemp -d)
echo -e "${BLUE}📁 임시 디렉토리: ${TEMP_DIR}${NC}"

# web 폴더 복사
echo -e "${YELLOW}📦 웹 파일 복사 중...${NC}"
cp -r web/* "$TEMP_DIR/"

# Git 초기화
cd "$TEMP_DIR"
git init
git checkout -b gh-pages

# Git 사용자 설정 확인
if [ -z "$(git config user.name)" ]; then
    echo -e "${YELLOW}Git 사용자 이름을 입력하세요:${NC}"
    read -r git_name
    git config user.name "$git_name"
fi

if [ -z "$(git config user.email)" ]; then
    echo -e "${YELLOW}Git 이메일을 입력하세요:${NC}"
    read -r git_email
    git config user.email "$git_email"
fi

# 커밋
git add .
git commit -m "Deploy to GitHub Pages - $(date '+%Y-%m-%d %H:%M:%S')"

# 원격 저장소 추가
git remote add origin "https://github.com/${github_username}/${repo_name}.git"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ 준비 완료!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}📝 다음 단계:${NC}"
echo ""
echo -e "${BLUE}1. GitHub에 레포지토리 생성${NC}"
echo "   🔗 https://github.com/new"
echo "   - Repository name: ${repo_name}"
echo "   - Public 선택"
echo "   - 'Create repository' 클릭"
echo ""
echo -e "${BLUE}2. 파일 푸시${NC}"
echo "   다음 디렉토리에서 실행하세요:"
echo "   cd ${TEMP_DIR}"
echo ""
echo "   그 다음 실행:"
echo "   ${GREEN}git push -u origin gh-pages${NC}"
echo ""
echo -e "${BLUE}3. GitHub Pages 설정${NC}"
echo "   🔗 https://github.com/${github_username}/${repo_name}/settings/pages"
echo "   - Source: 'Deploy from a branch' 선택"
echo "   - Branch: 'gh-pages' 선택 → '/(root)' 선택"
echo "   - 'Save' 클릭"
echo ""
echo -e "${BLUE}4. 배포 완료 (약 1-2분 소요)${NC}"
echo "   배포된 사이트:"
echo "   🌐 ${GREEN}https://${github_username}.github.io/${repo_name}/${NC}"
echo ""
echo -e "${BLUE}5. App Store Connect에 URL 입력${NC}"
echo "   - Privacy Policy: https://${github_username}.github.io/${repo_name}/privacy.html"
echo "   - Support URL: https://${github_username}.github.io/${repo_name}/support.html"
echo ""

# 디렉토리 열기
echo -e "${YELLOW}💡 임시 디렉토리를 Finder에서 여시겠습니까? (y/n)${NC}"
read -r open_finder
if [[ "$open_finder" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    open "$TEMP_DIR"
fi

echo ""
echo -e "${GREEN}🎉 GitHub Pages 배포 준비가 완료되었습니다!${NC}"
echo -e "${YELLOW}위의 단계를 따라 진행하세요.${NC}"
echo ""


