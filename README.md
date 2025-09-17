# 🎂 돌잔치 초대장 웹사이트

우리 아이의 첫 번째 생일을 축하하는 감성적인 모바일 초대장 웹사이트입니다.

## 🌟 주요 특징

- **모바일 최적화**: 스마트폰에서 최적화된 반응형 디자인
- **따뜻한 디자인**: 부드러운 색상과 여백으로 감성적인 느낌
- **D-Day 카운트다운**: 실시간으로 돌잔치까지 남은 시간 표시
- **부드러운 애니메이션**: 스크롤에 따른 자연스러운 요소 등장
- **7개 섹션**: 완성도 높은 초대장 구성

## 📁 프로젝트 구조

```
/1st-birthday/
├── index.html              # 메인 HTML 파일
├── style.css               # 스타일시트 (모바일 우선)
├── script.js               # JavaScript (카운트다운, 애니메이션)
├── images/                 # 이미지 폴더
├── deploy.sh               # AWS S3 배포 스크립트
├── setup-cloudfront.sh     # CloudFront CDN 설정 스크립트
├── create-placeholder-images.sh  # 플레이스홀더 이미지 생성
└── README.md               # 프로젝트 설명

```

## 🚀 AWS 배포 가이드

### 1단계: AWS 자격 증명 설정

```bash
# AWS CLI 설치 확인
aws --version

# AWS 자격 증명 설정
aws configure
```

다음 정보 입력:
- AWS Access Key ID: (IAM에서 발급받은 키)
- AWS Secret Access Key: (IAM에서 발급받은 시크릿)
- Default region: `ap-northeast-2` (서울)
- Default output format: `json`

### 2단계: 플레이스홀더 이미지 생성 (선택사항)

```bash
# ImageMagick 설치 (Mac)
brew install imagemagick

# 플레이스홀더 이미지 생성
./create-placeholder-images.sh
```

### 3단계: S3에 배포

```bash
# S3 버킷 생성 및 파일 업로드
./deploy.sh
```

실행 후 표시되는 URL로 접속 가능합니다:
- `http://1st-birthday-invitation-20251011.s3-website.ap-northeast-2.amazonaws.com`

### 4단계: CloudFront CDN 설정 (선택사항)

```bash
# CloudFront 배포 생성 (HTTPS, 전 세계 빠른 속도)
./setup-cloudfront.sh
```

## 📱 섹션 구성

1. **Hero**: 아기 사진과 환영 메시지
2. **초대장**: 정중한 초대 문구
3. **날짜**: D-Day 카운트다운과 일정 안내
4. **성장일기**: 1년간의 주요 이벤트 타임라인
5. **돌잔치 안내**: 장소, 시간, 준비사항
6. **갤러리**: 소중한 순간들 사진
7. **오시는 길**: 위치 및 교통 안내

## 🎨 디자인 특징

- **색상**: 오렌지/살구톤 포인트 컬러, 아이보리 배경
- **폰트**: Noto Sans KR (한글 최적화)
- **레이아웃**: 모바일 우선, 카드형 디자인
- **애니메이션**: 부드러운 스크롤 및 요소 등장 효과

## 🔧 기술 스택

- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Styling**: CSS Grid, Flexbox, CSS Animations
- **Hosting**: AWS S3 + CloudFront
- **Features**: Intersection Observer, Smooth Scrolling

## 📝 커스터마이징

### 날짜 변경
`script.js` 파일의 첫 번째 줄에서 날짜 수정:
```javascript
const partyDate = new Date('2025-10-11T12:30:00').getTime();
```

### 내용 변경
`index.html` 파일에서 텍스트 내용 수정 가능

### 이미지 교체
`images/` 폴더에 실제 사진으로 교체

## 🌐 배포 URL

- **S3 직접 접속**: http://1st-birthday-invitation-20251011.s3-website.ap-northeast-2.amazonaws.com
- **CloudFront (HTTPS)**: 설정 후 제공되는 도메인

## 📞 문의

프로젝트 관련 문의나 수정 요청이 있으시면 GitHub Issues를 통해 연락주세요.
