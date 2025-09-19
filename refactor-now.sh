#!/bin/bash

# 1st Birthday 프로젝트 디렉토리 리팩토링 스크립트
# 기존 파일들을 체계적으로 정리

echo "🏗️ 디렉토리 구조 리팩토링을 시작합니다..."

# 새 디렉토리 구조 생성
echo "📁 새 디렉토리 구조 생성 중..."
mkdir -p src/public/assets/{css,js,images/{timeline,gallery}}
mkdir -p src/admin/assets/{css,js}
mkdir -p src/admin/config
mkdir -p scripts/{aws,domain,utils}
mkdir -p docs/{deployment,user-guide}
mkdir -p config
mkdir -p tests

# 기존 파일들 이동
echo "📦 기존 파일들 이동 중..."

# 프론트엔드 파일들
mv index.html src/public/
mv style.css src/public/assets/css/
mv script.js src/public/assets/js/

# 이미지 파일들 분류 이동
mv images/hero.jpg src/public/assets/images/
mv images/event-*.jpg src/public/assets/images/timeline/
mv images/gallery-*.jpg src/public/assets/images/gallery/

# 빈 images 디렉토리 제거
rmdir images 2>/dev/null || echo "images 디렉토리에 추가 파일이 있습니다."

# AWS 스크립트들
mv deploy.sh scripts/aws/
mv setup-cloudfront.sh scripts/aws/
mv setup-cloudfront-with-existing-dns.sh scripts/aws/
mv setup-advanced-security.sh scripts/aws/
mv setup-security.sh scripts/aws/

# 도메인 스크립트들
mv route53-auto-setup.sh scripts/domain/
mv setup-custom-domain.sh scripts/domain/
mv setup-snovaha-domain.sh scripts/domain/

# 유틸리티 스크립트들
mv create-placeholder-images.sh scripts/utils/

# 문서들
mv hosting-kr-*.md docs/deployment/
mv snovaha-redirect-setup.md docs/deployment/
mv project-structure-plan.md docs/

# HTML 파일 경로 수정
echo "🔧 HTML 파일 경로 수정 중..."
sed -i '' 's|href="style.css"|href="assets/css/style.css"|g' src/public/index.html
sed -i '' 's|src="script.js"|src="assets/js/script.js"|g' src/public/index.html
sed -i '' 's|src="images/|src="assets/images/|g' src/public/index.html

# 기본 config 파일 생성
echo "⚙️ 기본 설정 파일 생성 중..."
cat > config/site-config.json << 'EOF'
{
  "baby": {
    "name": "한우주",
    "birthDate": "2024-10-11",
    "gender": "boy"
  },
  "parents": {
    "father": "한흥석",
    "mother": "안보경",
    "contact": "010-1234-5678"
  },
  "party": {
    "date": "2025-10-11",
    "time": "12:30",
    "venue": "호텔나루서울엠갤러리 22층",
    "venueSub": "부아쟁 레스토랑",
    "address": "서울특별시 마포구 마포대로 8",
    "mapLink": "https://naver.me/GvcTFv2T"
  },
  "theme": {
    "colorScheme": "blue",
    "primaryColor": "#4a90e2",
    "secondaryColor": "#357abd"
  },
  "deployment": {
    "s3Bucket": "1st-birthday-invitation-20251011",
    "cloudFrontId": "E2Z50QKS64PV0U",
    "domain": "invitation.snovaha.com"
  }
}
EOF

# 새로운 통합 배포 스크립트 생성
cat > scripts/deploy-all.sh << 'EOF'
#!/bin/bash

# 통합 배포 스크립트
echo "🚀 1st Birthday 통합 배포 시작..."

# 현재 디렉토리 확인
if [ ! -f "config/site-config.json" ]; then
    echo "❌ 프로젝트 루트에서 실행해주세요."
    exit 1
fi

# S3 배포
echo "📤 S3에 업로드 중..."
cd scripts/aws && ./deploy.sh && cd ../..

echo "✅ 배포 완료!"
echo "🌐 접속 URL: https://invitation.snovaha.com"
EOF

chmod +x scripts/deploy-all.sh

# 새 README 생성
cat > README.md << 'EOF'
# 🎂 1st Birthday Invitation

한우주의 첫 번째 생일을 축하하는 모바일 초대장 웹사이트

## 🏗️ 프로젝트 구조

```
1st-birthday/
├── src/public/          # 초대장 웹사이트
├── src/admin/           # 관리자 페이지 (개발 예정)
├── scripts/             # 배포 및 자동화 스크립트
├── docs/                # 문서
└── config/              # 설정 파일
```

## 🚀 빠른 시작

```bash
# 통합 배포
./scripts/deploy-all.sh

# 접속
https://invitation.snovaha.com
```

## 📚 문서

- [AWS 설정 가이드](docs/deployment/)
- [프로젝트 구조 계획](docs/project-structure-plan.md)

## 🎨 커스터마이징

설정 변경: `config/site-config.json`
이미지 교체: `src/public/assets/images/`
EOF

echo "✅ 디렉토리 구조 리팩토링 완료!"
echo ""
echo "📁 새로운 구조:"
echo "├── src/public/          # 초대장 웹사이트"
echo "├── scripts/             # 정리된 스크립트들"
echo "├── config/              # 설정 파일"
echo "└── docs/                # 문서들"
echo ""
echo "🎯 다음 단계: 관리자 페이지 개발"
