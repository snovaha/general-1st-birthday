# snovaha.com 리다이렉트 설정 가이드

## 🎯 목표
`https://snovaha.com/invitation/woojoo-han` → `https://d104xm32ar1ns2.cloudfront.net`

## 🔧 설정 방법

### 방법 1: Apache 웹서버 (.htaccess)

`snovaha.com/invitation/` 폴더에 `.htaccess` 파일 생성:

```apache
# .htaccess 파일 내용
RewriteEngine On
RewriteRule ^woojoo-han/?$ https://d104xm32ar1ns2.cloudfront.net [R=301,L]
```

### 방법 2: Nginx 웹서버

`nginx.conf` 또는 사이트 설정 파일에 추가:

```nginx
# nginx 설정
location /invitation/woojoo-han {
    return 301 https://d104xm32ar1ns2.cloudfront.net;
}
```

### 방법 3: HTML 페이지 (가장 간단)

`snovaha.com/invitation/woojoo-han/index.html` 파일 생성:

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
    <p>자동으로 이동되지 않으면 <a href="https://d104xm32ar1ns2.cloudfront.net">여기를 클릭</a>해주세요.</p>
</body>
</html>
```

### 방법 4: JavaScript 리다이렉트

기존 `snovaha.com` 페이지에 다음 코드 추가:

```javascript
// URL 확인 후 리다이렉트
if (window.location.pathname === '/invitation/woojoo-han' || 
    window.location.pathname === '/invitation/woojoo-han/') {
    window.location.href = 'https://d104xm32ar1ns2.cloudfront.net';
}
```

## ✅ 권장 순서

1. **가장 쉬운 방법**: HTML 페이지 생성 (방법 3)
2. **웹서버 설정**: Apache/Nginx 리다이렉트 (방법 1, 2)
3. **동적 처리**: JavaScript 리다이렉트 (방법 4)

## 🎉 완료 후 테스트

- `https://snovaha.com/invitation/woojoo-han` 접속
- 자동으로 `https://d104xm32ar1ns2.cloudfront.net`으로 이동하는지 확인
- 모바일에서도 테스트

## 📱 QR 코드 생성

초대장 공유용 QR 코드를 생성하려면:
- URL: `https://snovaha.com/invitation/woojoo-han`
- QR 코드 생성 사이트: https://qr-code-generator.com/
- 카카오톡, 문자로 공유 가능
