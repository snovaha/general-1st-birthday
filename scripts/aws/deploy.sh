#!/bin/bash

# 돌잔치 초대장 AWS S3 배포 스크립트
# 사용법: ./deploy.sh

BUCKET_NAME="1st-birthday-invitation-20251011"
REGION="ap-northeast-2"

echo "🚀 돌잔치 초대장 웹사이트 배포를 시작합니다..."

# 1. S3 버킷 생성 (이미 있으면 무시됩니다)
echo "📦 S3 버킷 확인 중..."
aws s3 mb s3://$BUCKET_NAME --region $REGION 2>/dev/null || echo "버킷이 이미 존재합니다."

# 2. 정적 웹사이트 호스팅 설정
echo "🌐 정적 웹사이트 호스팅 설정 중..."
aws s3 website s3://$BUCKET_NAME --index-document index.html --error-document index.html

# 3. 프로젝트 루트로 이동 (스크립트가 scripts/aws/에서 실행될 때)
cd "$(dirname "$0")/../.."

# 4. 파일 업로드 (HTML, CSS, JS)
echo "📤 파일 업로드 중..."
aws s3 cp src/public/index.html s3://$BUCKET_NAME/ --content-type "text/html"
aws s3 cp src/public/assets/css/style.css s3://$BUCKET_NAME/assets/css/style.css --content-type "text/css"
aws s3 cp src/public/assets/js/script.js s3://$BUCKET_NAME/assets/js/script.js --content-type "application/javascript"

# 5. assets 폴더 전체 업로드
echo "🖼️  에셋 파일 업로드 중..."
if [ -d "src/public/assets" ]; then
    aws s3 sync src/public/assets/ s3://$BUCKET_NAME/assets/ --delete
fi

# 5. 퍼블릭 읽기 권한 설정
echo "🔓 퍼블릭 읽기 권한 설정 중..."
aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::'$BUCKET_NAME'/*"
        }
    ]
}'

# 6. 웹사이트 URL 출력
echo ""
echo "✅ 배포 완료!"
echo "🌐 웹사이트 URL: http://$BUCKET_NAME.s3-website.$REGION.amazonaws.com"
echo ""
echo "📝 추가 설정:"
echo "   - CloudFront를 통한 CDN 설정 권장"
echo "   - 사용자 정의 도메인 연결 가능"
echo "   - HTTPS 인증서 설정 가능"
