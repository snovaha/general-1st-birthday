# 📚 1st Birthday Invitation 문서

## 🏗️ 프로젝트 구조

### `/src/` - 소스 코드
- **`src/public/`** - 실제 초대장 웹사이트
  - `index.html` - 메인 초대장 페이지
  - `assets/css/style.css` - 파랑색 테마 스타일
  - `assets/js/script.js` - D-Day 카운트다운 & 애니메이션
  - `assets/images/` - 이미지 파일들
    - `hero.jpg` - 메인 아기 사진
    - `timeline/` - 성장 일기 이미지들
    - `gallery/` - 갤러리 이미지들

- **`src/admin/`** - 관리자 페이지 🎯 **NEW!**
  - `index.html` - 관리자 대시보드
  - `assets/css/admin.css` - 관리자 전용 스타일
  - `assets/js/admin.js` - 관리자 기능

### `/scripts/` - 자동화 스크립트
- **`scripts/aws/`** - AWS 배포 관련
  - `deploy.sh` - S3 배포 (새 구조 지원)
  - `setup-cloudfront-with-existing-dns.sh` - CloudFront + 호스팅케이알 연동
  
- **`scripts/domain/`** - 도메인 설정
  - `route53-auto-setup.sh` - Route 53 완전 자동 설정

- **`scripts/utils/`** - 유틸리티
  - `create-placeholder-images.sh` - 플레이스홀더 이미지 생성

### `/config/` - 설정 파일
- `site-config.json` - 사이트 기본 설정 (아기 이름, 부모 정보, 돌잔치 일정)

### `/docs/` - 문서
- **`docs/deployment/`** - 배포 가이드들
  - `hosting-kr-dns-only.md` - 호스팅케이알 DNS 연동 방법
  - `hosting-kr-simple-guide.md` - 초보자용 단계별 가이드

## 🚀 빠른 시작

### 1. 기본 배포
```bash
# 프로젝트 루트에서
./scripts/aws/deploy.sh
```

### 2. 관리자 페이지 접속
```bash
# 브라우저에서 열기
open src/admin/index.html
```

### 3. 도메인 연결 (호스팅케이알)
```bash
# SSL 인증서 & CloudFront 설정
./scripts/aws/setup-cloudfront-with-existing-dns.sh
```

## 🎨 관리자 페이지 기능

### 대시보드
- D-Day 카운트다운
- 빠른 배포 버튼
- 사이트 상태 확인

### 기본 정보 관리
- 아기 정보 (이름, 생년월일, 성별)
- 부모 정보 (이름, 연락처)
- 돌잔치 정보 (날짜, 시간, 장소)

### 이미지 관리
- **Hero 이미지**: 메인 아기 사진 (280x280px)
- **타임라인 이미지**: 
  - 출생 (event-1.jpg)
  - 백일 (event-2.jpg)
  - 뒤집기 (event-3.jpg)
  - 앉기 (event-4.jpg)
  - 기어다니기 (event-5.jpg)
- **갤러리 이미지**: gallery-1.jpg ~ gallery-6.jpg

### 배포 관리
- S3 원클릭 배포
- CloudFront 캐시 무효화
- 배포 로그 실시간 확인

## 🌐 현재 배포 상태

### URL
- **메인 사이트**: http://1st-birthday-invitation-20251011.s3-website.ap-northeast-2.amazonaws.com
- **CloudFront**: https://d104xm32ar1ns2.cloudfront.net
- **목표 도메인**: https://invitation.snovaha.com (설정 중)

### SSL 인증서
- **상태**: PENDING_VALIDATION ⏳
- **도메인**: invitation.snovaha.com
- **DNS 레코드**: 호스팅케이알에 추가 완료

## 📝 다음 단계

1. ⏳ SSL 인증서 검증 완료 대기 (5-30분)
2. 🔗 CloudFront에 커스텀 도메인 연결
3. 🧪 관리자 페이지 백엔드 연동 (향후)

## 🎯 주요 개선사항

### 디렉토리 리팩토링 완료 ✅
- 체계적인 파일 구조
- 역할별 폴더 분리
- 스크립트 자동화

### 관리자 페이지 추가 ✅
- Bootstrap 5 기반 UI
- 실시간 D-Day 카운트다운
- 이미지 미리보기 & 업로드
- 배포 관리 인터페이스

### 파랑색 테마 적용 ✅
- 남자아이용 색상 스킴
- CSS 변수 시스템
- 호환성 향상
