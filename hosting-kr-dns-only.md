# 호스팅케이알 DNS 레코드만으로 snovaha.com 연결하기

## 🎯 목표
도메인 이전 없이 DNS 레코드 추가만으로 `https://snovaha.com` 연결

## 📋 현재 상황
- 도메인: snovaha.com (호스팅케이알 관리 유지)
- CloudFront: https://d104xm32ar1ns2.cloudfront.net
- 방법: DNS 레코드 추가만으로 연결

## 🔧 호스팅케이알 DNS 설정 방법

### 1단계: SSL 인증서 발급 (AWS에서)

먼저 AWS에서 SSL 인증서를 발급받아야 합니다:

```bash
# AWS Certificate Manager에서 인증서 요청
aws acm request-certificate \
    --region us-east-1 \
    --domain-name snovaha.com \
    --subject-alternative-names "*.snovaha.com" \
    --validation-method DNS
```

### 2단계: 호스팅케이알 관리자 페이지에서 DNS 설정

#### 2-1. 호스팅케이알 로그인
1. **호스팅케이알 관리자 페이지** 접속
2. **나의 서비스 관리** → **도메인 관리**
3. **snovaha.com** 선택
4. **DNS 관리** 또는 **네임서버 관리** 클릭

#### 2-2. SSL 인증서 검증용 CNAME 레코드 추가

AWS에서 제공하는 검증 레코드를 추가:

```
레코드 타입: CNAME
호스트명: _acme-challenge
값: (AWS에서 제공하는 검증 값 - 예: abc123.acm-validations.aws.)
TTL: 300 (5분)
```

#### 2-3. 도메인 연결용 A 레코드 추가

**옵션 1: CNAME 레코드 (더 간단)**
```
레코드 타입: CNAME
호스트명: @ (루트 도메인)
값: d104xm32ar1ns2.cloudfront.net
TTL: 300
```

**옵션 2: A 레코드 (CloudFront IP 직접 연결)**
```
레코드 타입: A
호스트명: @ (루트 도메인)
값: CloudFront IP 주소들 (여러 개 추가)
TTL: 300
```

#### 2-4. www 서브도메인용 CNAME
```
레코드 타입: CNAME
호스트명: www
값: d104xm32ar1ns2.cloudfront.net
TTL: 300
```

### 3단계: CloudFront 설정 업데이트

인증서 발급 완료 후 CloudFront에 커스텀 도메인 추가:

```bash
# 자동 스크립트 실행 (DNS 레코드 추가 버전)
./setup-cloudfront-with-existing-dns.sh
```

## 📱 완전 자동화 스크립트

호스팅케이알에서 DNS 레코드만 추가하면 되는 버전:
