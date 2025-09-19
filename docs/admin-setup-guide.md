# 🔧 Admin 페이지 실제 업로드 기능 설정 가이드

## 📋 **개요**
Admin 페이지에서 실제로 S3에 이미지를 업로드하고 웹사이트에 즉시 반영할 수 있도록 API 서버를 설정하는 가이드입니다.

## 🛠️ **설정 단계**

### **1단계: 환경 설정**

API 디렉토리로 이동하고 환경 파일을 생성합니다:

```bash
cd src/api
cp env.example .env
```

`.env` 파일을 편집하여 AWS 설정을 입력합니다:

```bash
# AWS 설정
AWS_REGION=ap-northeast-2
AWS_ACCESS_KEY_ID=여기에_실제_액세스_키_입력
AWS_SECRET_ACCESS_KEY=여기에_실제_시크릿_키_입력

# S3 설정
S3_BUCKET_NAME=1st-birthday-invitation-20251011

# CloudFront 설정
CLOUDFRONT_DISTRIBUTION_ID=E2Z50QKS64PV0U

# 서버 설정
PORT=3001
NODE_ENV=development
```

### **2단계: 의존성 설치 및 서버 시작**

```bash
# 의존성 설치
npm install

# 서버 시작
npm start
```

또는 편리한 스크립트 사용:

```bash
# 프로젝트 루트에서
./scripts/admin/start-admin-server.sh
```

### **3단계: Admin 페이지 접속**

1. **API 서버가 실행 중인지 확인**: http://localhost:3001/api/health
2. **Admin 페이지 열기**: `src/admin/index.html` 파일을 브라우저에서 직접 열기

## ✨ **새로운 기능들**

### **🖼️ 실시간 이미지 업로드**
- Hero 이미지 선택 시 **즉시 S3에 업로드**
- **CloudFront 캐시 자동 무효화**
- 갤러리 및 타임라인 이미지도 지원

### **📝 컨텐츠 실시간 업데이트**
- 기본 정보 저장 시 **HTML 파일 자동 업데이트**
- **S3에 자동 배포**
- **캐시 무효화**로 즉시 반영

### **🚀 빠른 배포**
- 전체 CloudFront 캐시 무효화
- 배포 상태 실시간 모니터링

## 🔧 **API 엔드포인트**

### **이미지 업로드**
```
POST /api/upload-image
Content-Type: multipart/form-data

Body:
- image: File
- imageType: 'hero' | 'gallery' | 'timeline'
- galleryIndex: string (갤러리용)
- timelineIndex: string (타임라인용)
```

### **컨텐츠 업데이트**
```
POST /api/update-content
Content-Type: application/json

Body: {
  babyName, babyBirthDate, babyGender,
  fatherName, motherName, contact,
  partyDate, partyTime, venue, venueSub, address, mapLink
}
```

### **빠른 배포**
```
POST /api/quick-deploy
Content-Type: application/json
```

## 🚨 **주의사항**

1. **AWS 권한**: S3 및 CloudFront 권한이 필요합니다
2. **CORS 설정**: 브라우저에서 로컬 파일 접근 시 CORS 이슈가 있을 수 있습니다
3. **포트 충돌**: 3001 포트가 사용 중이면 `.env`에서 PORT 변경
4. **네트워크**: AWS API 호출을 위한 인터넷 연결 필요

## 🔍 **문제 해결**

### **업로드 실패**
- AWS 인증 정보 확인
- S3 버킷 권한 확인
- 네트워크 연결 확인

### **CORS 에러**
- 브라우저에서 `--disable-web-security` 플래그로 실행
- 또는 로컬 HTTP 서버 사용

### **캐시 문제**
- CloudFront 무효화 확인
- 브라우저 강력 새로고침 (Ctrl+Shift+R)

## 🎯 **사용법**

1. **API 서버 시작**: `./scripts/admin/start-admin-server.sh`
2. **Admin 페이지 열기**: `src/admin/index.html`
3. **이미지 업로드**: 파일 선택 시 자동 업로드
4. **정보 수정**: 저장 버튼 클릭 시 자동 배포
5. **웹사이트 확인**: 몇 분 후 CloudFront URL에서 확인

## 🔗 **관련 링크**

- **웹사이트**: https://d104xm32ar1ns2.cloudfront.net
- **S3 직접**: http://1st-birthday-invitation-20251011.s3-website.ap-northeast-2.amazonaws.com
- **API 헬스체크**: http://localhost:3001/api/health
