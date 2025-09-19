# 🏗️ 1st Birthday Invitation 프로젝트 구조 리팩토링 계획

## 📁 현재 문제점
- 루트 디렉토리에 모든 파일이 섞여있음
- 배포 스크립트, 가이드 문서, 소스코드가 구분되지 않음
- 확장성과 유지보수성 부족
- 관리자 기능 없음

## 🎯 새로운 디렉토리 구조

```
1st-birthday/
├── README.md                           # 프로젝트 전체 설명
├── .env.example                        # 환경변수 템플릿
├── .gitignore                         # Git 무시 파일
├── package.json                       # 의존성 관리 (향후 확장용)
│
├── src/                              # 🎨 프론트엔드 소스
│   ├── public/                       # 정적 웹사이트 (현재 서비스)
│   │   ├── index.html               # 메인 초대장 페이지
│   │   ├── assets/
│   │   │   ├── css/
│   │   │   │   └── style.css        # 스타일시트
│   │   │   ├── js/
│   │   │   │   └── script.js        # JavaScript
│   │   │   └── images/              # 이미지 파일들
│   │   │       ├── hero.jpg
│   │   │       ├── timeline/        # 타임라인 이미지
│   │   │       │   ├── event-1.jpg
│   │   │       │   └── ...
│   │   │       └── gallery/         # 갤러리 이미지
│   │   │           ├── gallery-1.jpg
│   │   │           └── ...
│   │   └── admin/                   # 🔧 관리자 페이지
│   │       ├── index.html           # 관리자 대시보드
│   │       ├── login.html           # 로그인 페이지
│   │       ├── assets/
│   │       │   ├── css/
│   │       │   │   └── admin.css    # 관리자 전용 스타일
│   │       │   └── js/
│   │       │       ├── admin.js     # 관리자 기능
│   │       │       └── upload.js    # 이미지 업로드
│   │       └── config/
│   │           └── settings.json    # 사이트 설정 (이름, 장소 등)
│   │
│   └── templates/                   # 📝 템플릿 파일들
│       ├── invitation-template.html # 초대장 템플릿
│       └── email-template.html     # 이메일 초대장 (향후 확장)
│
├── scripts/                         # 🚀 배포 및 자동화 스크립트
│   ├── aws/                        # AWS 관련 스크립트
│   │   ├── deploy.sh               # S3 배포
│   │   ├── setup-cloudfront.sh     # CloudFront 설정
│   │   ├── setup-ssl.sh           # SSL 인증서 설정
│   │   └── cleanup.sh              # 리소스 정리
│   ├── domain/                     # 도메인 관련 스크립트
│   │   ├── route53-setup.sh        # Route 53 설정
│   │   └── hosting-kr-setup.sh     # 호스팅케이알 설정
│   └── utils/                      # 유틸리티 스크립트
│       ├── create-placeholder-images.sh
│       └── backup.sh               # 백업 스크립트
│
├── docs/                           # 📚 문서
│   ├── deployment/                 # 배포 가이드
│   │   ├── aws-setup.md           # AWS 설정 가이드
│   │   ├── domain-setup.md        # 도메인 연결 가이드
│   │   └── troubleshooting.md     # 문제 해결 가이드
│   ├── user-guide/                # 사용자 가이드
│   │   ├── admin-manual.md        # 관리자 매뉴얼
│   │   └── customization.md       # 커스터마이징 가이드
│   └── api/                       # API 문서 (향후 확장)
│       └── admin-api.md
│
├── config/                         # ⚙️ 설정 파일
│   ├── site-config.json           # 사이트 기본 설정
│   ├── aws-config.json            # AWS 설정
│   └── build-config.json          # 빌드 설정
│
├── tests/                          # 🧪 테스트 파일
│   ├── e2e/                       # E2E 테스트
│   └── unit/                      # 단위 테스트
│
└── .github/                       # 🔄 GitHub Actions (CI/CD)
    └── workflows/
        ├── deploy-staging.yml     # 스테이징 배포
        └── deploy-production.yml  # 프로덕션 배포
```

## 🎯 관리자 페이지 기능 설계

### 📊 대시보드 (admin/index.html)
- 현재 사이트 상태 (방문자 수, 응답률 등)
- 빠른 편집 링크들
- 최근 업데이트 로그

### ⚙️ 컨텐츠 관리
1. **기본 정보 편집**
   - 아기 이름, 생년월일
   - 부모 이름, 연락처
   - 돌잔치 날짜, 시간, 장소

2. **이미지 관리**
   ```
   Hero 이미지: 메인 아기 사진 (280x280)
   타임라인 이미지: 
   - 출생 (event-1.jpg)
   - 백일 (event-2.jpg) 
   - 뒤집기 (event-3.jpg)
   - 앉기 (event-4.jpg)
   - 기어다니기 (event-5.jpg)
   
   갤러리 이미지: gallery-1.jpg ~ gallery-6.jpg
   ```

3. **텍스트 편집**
   - 초대 메시지 수정
   - 타임라인 설명 수정
   - 오시는 길 안내 수정

### 🔧 사이트 설정
- 색상 테마 변경 (남아/여아)
- 레이아웃 옵션
- 소셜 공유 설정

### 📤 배포 관리
- 원클릭 S3 배포
- CloudFront 캐시 무효화
- 백업 및 복원

## 🔄 마이그레이션 계획

### Phase 1: 디렉토리 구조 정리
1. 새 디렉토리 구조 생성
2. 기존 파일들 적절한 위치로 이동
3. 경로 참조 업데이트

### Phase 2: 관리자 페이지 개발
1. 기본 관리자 인터페이스 구축
2. 설정 파일 시스템 구축
3. 이미지 업로드 기능 구현

### Phase 3: 자동화 개선
1. 배포 스크립트 통합
2. CI/CD 파이프라인 구축
3. 모니터링 및 로깅

## 🎨 관리자 페이지 기술 스택

### Frontend
- **HTML5 + CSS3 + Vanilla JavaScript** (기존과 동일)
- **Bootstrap 5** (관리자 UI 프레임워크)
- **Font Awesome** (아이콘)

### Backend (선택사항)
- **Node.js + Express** (간단한 API 서버)
- **또는 완전한 정적 사이트** (JSON 파일 기반)

### Storage
- **JSON 파일** (설정 데이터)
- **S3** (이미지 스토리지)
- **LocalStorage** (임시 데이터)

## 🚀 구현 우선순위

1. **High Priority**
   - 디렉토리 구조 리팩토링
   - 기본 관리자 페이지 (설정 편집)
   - 이미지 업로드 기능

2. **Medium Priority**
   - 고급 관리자 기능
   - 자동 배포 시스템
   - 테마 변경 기능

3. **Low Priority**
   - 사용자 분석
   - 이메일 발송 기능
   - 모바일 관리자 앱

이 구조로 리팩토링하면 확장성도 좋고, 유지보수도 쉬워집니다! 어떻게 생각하시나요?
