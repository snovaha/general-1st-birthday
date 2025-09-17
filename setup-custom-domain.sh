#!/bin/bash

# 사용자 정의 도메인 설정 스크립트
# 사전 요구사항: snovaha.com이 Route 53에서 관리되어야 함

DOMAIN="snovaha.com"
SUBDOMAIN="invitation.snovaha.com"
CLOUDFRONT_DOMAIN="d104xm32ar1ns2.cloudfront.net"
REGION="ap-northeast-2"

echo "🌐 사용자 정의 도메인 설정을 시작합니다..."
echo "도메인: $SUBDOMAIN"

# 1. Route 53 호스팅 영역 ID 가져오기
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='${DOMAIN}.'].Id" --output text | cut -d'/' -f3)

if [ -z "$HOSTED_ZONE_ID" ]; then
    echo "❌ Route 53에서 $DOMAIN 호스팅 영역을 찾을 수 없습니다."
    echo "먼저 AWS Route 53에서 도메인을 설정해주세요."
    exit 1
fi

echo "✅ 호스팅 영역 ID: $HOSTED_ZONE_ID"

# 2. SSL 인증서 요청 (us-east-1 리전에서 CloudFront용)
echo "🔒 SSL 인증서 요청 중... (CloudFront용으로 us-east-1 리전)"
CERT_ARN=$(aws acm request-certificate \
    --region us-east-1 \
    --domain-name $SUBDOMAIN \
    --validation-method DNS \
    --query 'CertificateArn' \
    --output text)

echo "📋 인증서 ARN: $CERT_ARN"

# 3. DNS 검증 레코드 생성
echo "⏳ DNS 검증 레코드 정보 가져오는 중..."
sleep 10

VALIDATION_RECORD=$(aws acm describe-certificate \
    --region us-east-1 \
    --certificate-arn $CERT_ARN \
    --query 'Certificate.DomainValidationOptions[0].ResourceRecord' \
    --output json)

VALIDATION_NAME=$(echo $VALIDATION_RECORD | jq -r '.Name')
VALIDATION_VALUE=$(echo $VALIDATION_RECORD | jq -r '.Value')

echo "🔍 검증 레코드 생성 중..."
echo "  이름: $VALIDATION_NAME"
echo "  값: $VALIDATION_VALUE"

# 4. Route 53에 검증 레코드 추가
cat > /tmp/dns-validation.json << EOF
{
    "Changes": [
        {
            "Action": "CREATE",
            "ResourceRecordSet": {
                "Name": "$VALIDATION_NAME",
                "Type": "CNAME",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": "$VALIDATION_VALUE"
                    }
                ]
            }
        }
    ]
}
EOF

aws route53 change-resource-record-sets \
    --hosted-zone-id $HOSTED_ZONE_ID \
    --change-batch file:///tmp/dns-validation.json

echo "✅ DNS 검증 레코드 생성 완료"

# 5. 인증서 검증 대기
echo "⏳ SSL 인증서 검증 대기 중... (최대 30분 소요)"
aws acm wait certificate-validated --region us-east-1 --certificate-arn $CERT_ARN

echo "✅ SSL 인증서 검증 완료!"

# 6. CloudFront 배포에 사용자 정의 도메인 추가
echo "☁️ CloudFront에 사용자 정의 도메인 설정 중..."

# 기존 CloudFront 배포 정보 가져오기
DISTRIBUTION_ID="E2Z50QKS64PV0U"
ETAG=$(aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query 'ETag' --output text)

# 배포 설정 업데이트
aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query 'DistributionConfig' > /tmp/distribution-config.json

# 사용자 정의 도메인과 SSL 인증서 추가
jq --arg domain "$SUBDOMAIN" --arg cert "$CERT_ARN" '
.Aliases.Quantity = 1 |
.Aliases.Items = [$domain] |
.ViewerCertificate = {
    "ACMCertificateArn": $cert,
    "SSLSupportMethod": "sni-only",
    "MinimumProtocolVersion": "TLSv1.2_2021",
    "CertificateSource": "acm"
}' /tmp/distribution-config.json > /tmp/distribution-config-updated.json

aws cloudfront update-distribution \
    --id $DISTRIBUTION_ID \
    --distribution-config file:///tmp/distribution-config-updated.json \
    --if-match $ETAG

echo "✅ CloudFront 배포 업데이트 완료"

# 7. Route 53에 CNAME 레코드 추가
echo "🌐 Route 53에 도메인 레코드 추가 중..."

cat > /tmp/domain-record.json << EOF
{
    "Changes": [
        {
            "Action": "CREATE",
            "ResourceRecordSet": {
                "Name": "$SUBDOMAIN",
                "Type": "CNAME",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": "$CLOUDFRONT_DOMAIN"
                    }
                ]
            }
        }
    ]
}
EOF

aws route53 change-resource-record-sets \
    --hosted-zone-id $HOSTED_ZONE_ID \
    --change-batch file:///tmp/domain-record.json

echo ""
echo "🎉 사용자 정의 도메인 설정 완료!"
echo "🌐 새 URL: https://$SUBDOMAIN"
echo ""
echo "📝 주의사항:"
echo "   - CloudFront 배포 완료까지 15-20분 추가 소요"
echo "   - DNS 전파까지 최대 48시간 소요 (보통 10-30분)"
echo "   - HTTPS로만 접속 가능"
echo ""
echo "🔧 추가 설정:"
echo "   - 웹서버에서 snovaha.com/invitation/woojoo-han -> https://$SUBDOMAIN 리다이렉트 설정"

# 임시 파일 정리
rm -f /tmp/dns-validation.json /tmp/domain-record.json /tmp/distribution-config.json /tmp/distribution-config-updated.json
