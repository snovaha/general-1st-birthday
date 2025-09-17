# 호스팅케이알에서 snovaha.com 도메인 직접 연결하기

## 🎯 목표
`https://snovaha.com` 또는 `https://snovaha.com/invitation/woojoo-han`으로 직접 접속

## 📋 현재 상황
- 도메인: snovaha.com (호스팅케이알 관리)
- CloudFront: https://d104xm32ar1ns2.cloudfront.net
- 호스팅케이알 네임서버 설정 중

## 🔧 설정 방법

### 방법 1: CloudFront 커스텀 도메인 (권장)

#### 1-1. AWS Certificate Manager에서 SSL 인증서 발급
```bash
# 인증서 요청 (반드시 us-east-1 리전에서)
aws acm request-certificate \
    --region us-east-1 \
    --domain-name snovaha.com \
    --subject-alternative-names "*.snovaha.com" \
    --validation-method DNS
```

#### 1-2. 호스팅케이알 DNS 설정
1. **호스팅케이알 관리자 페이지** 접속
2. **DNS 관리** 또는 **네임서버 관리** 메뉴
3. **DNS 레코드 추가**:

**SSL 인증서 검증용 CNAME 레코드:**
```
타입: CNAME
이름: _acme-challenge.snovaha.com
값: (AWS에서 제공하는 검증 값)
TTL: 300
```

**도메인 연결용 A 레코드 (별칭):**
```
타입: A (또는 ALIAS)
이름: @ (루트 도메인)
값: CloudFront IP 주소들 또는
별칭 대상: d104xm32ar1ns2.cloudfront.net
TTL: 300
```

**www 서브도메인용 CNAME:**
```
타입: CNAME
이름: www
값: snovaha.com
TTL: 300
```

#### 1-3. CloudFront 배포 업데이트
```bash
# 자동 스크립트 실행
./setup-snovaha-domain.sh
```

### 방법 2: 간단한 HTML 리다이렉트 (빠른 해결책)

#### 2-1. 호스팅케이알 웹호스팅 이용
1. **웹호스팅 서비스** 신청 (기본형도 충분)
2. **파일 매니저**에서 `public_html` 폴더에 업로드:

**index.html:**
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>한우주 돌잔치 초대장</title>
    <meta http-equiv="refresh" content="0;url=https://d104xm32ar1ns2.cloudfront.net">
    <script>
        window.location.href = 'https://d104xm32ar1ns2.cloudfront.net';
    </script>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; text-align: center; padding: 50px; }
        .loading { color: #4a90e2; font-size: 18px; }
    </style>
</head>
<body>
    <div class="loading">
        <h2>한우주 돌잔치 초대장으로 이동 중...</h2>
        <p>자동으로 이동되지 않으면 <a href="https://d104xm32ar1ns2.cloudfront.net">여기를 클릭</a>해주세요.</p>
    </div>
</body>
</html>
```

**invitation/woojoo-han/index.html:**
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>한우주 돌잔치 초대장</title>
    <meta http-equiv="refresh" content="0;url=https://d104xm32ar1ns2.cloudfront.net">
    <script>
        window.location.href = 'https://d104xm32ar1ns2.cloudfront.net';
    </script>
</head>
<body>
    <p>한우주 돌잔치 초대장으로 이동 중...</p>
</body>
</html>
```

### 방법 3: Route 53로 네임서버 변경 (고급)

#### 3-1. AWS Route 53에서 호스팅 영역 생성
```bash
aws route53 create-hosted-zone \
    --name snovaha.com \
    --caller-reference "snovaha-$(date +%s)"
```

#### 3-2. 호스팅케이알에서 네임서버 변경
1. **호스팅케이알 관리자** → **도메인 관리**
2. **네임서버 변경**을 AWS Route 53 네임서버로:
```
ns-xxx.awsdns-xx.com
ns-xxx.awsdns-xx.co.uk
ns-xxx.awsdns-xx.net
ns-xxx.awsdns-xx.org
```

#### 3-3. Route 53에서 A 레코드 설정
```bash
aws route53 change-resource-record-sets \
    --hosted-zone-id ZXXXXXXXXXXXXX \
    --change-batch '{
        "Changes": [{
            "Action": "CREATE",
            "ResourceRecordSet": {
                "Name": "snovaha.com",
                "Type": "A",
                "AliasTarget": {
                    "DNSName": "d104xm32ar1ns2.cloudfront.net",
                    "EvaluateTargetHealth": false,
                    "HostedZoneId": "Z2FDTNDATAQYW2"
                }
            }
        }]
    }'
```

## ⚡ 추천 순서

1. **먼저 시도**: 방법 2 (HTML 리다이렉트) - 30분 내 완료
2. **최종 목표**: 방법 1 (CloudFront 커스텀 도메인) - 안정적
3. **고급 옵션**: 방법 3 (Route 53) - 완전한 통합

## 🎉 완료 후 테스트

- `https://snovaha.com` 접속 테스트
- `https://snovaha.com/invitation/woojoo-han` 접속 테스트
- 모바일에서 접속 테스트
- QR 코드 생성: https://qr-code-generator.com/

## 📞 도움이 필요한 경우

호스팅케이알 고객센터: 1588-2030
- DNS 설정 관련 문의
- 웹호스팅 신청 문의
- 네임서버 변경 문의
