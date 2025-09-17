#!/bin/bash

# snovaha.com 도메인으로 초대장 설정
# 이 스크립트는 CloudFront에 사용자 정의 도메인을 추가합니다

DOMAIN="snovaha.com"
SUBDOMAIN="snovaha.com"
CLOUDFRONT_DOMAIN="d104xm32ar1ns2.cloudfront.net"
DISTRIBUTION_ID="E2Z50QKS64PV0U"

echo "🌐 snovaha.com 도메인 설정을 시작합니다..."
echo "목표 URL: https://snovaha.com/invitation/woojoo-han"

# 1. SSL 인증서 확인 (기존 snovaha.com 인증서 사용)
echo "🔍 기존 SSL 인증서 확인 중..."

# snovaha.com에 대한 기존 인증서 찾기
CERT_ARN=$(aws acm list-certificates --region us-east-1 \
    --query "CertificateSummaryList[?DomainName=='snovaha.com' || DomainName=='*.snovaha.com'].CertificateArn" \
    --output text | head -1)

if [ -z "$CERT_ARN" ]; then
    echo "⚠️  기존 snovaha.com SSL 인증서를 찾을 수 없습니다."
    echo "새 인증서를 요청합니다..."
    
    # 새 인증서 요청
    CERT_ARN=$(aws acm request-certificate \
        --region us-east-1 \
        --domain-name "snovaha.com" \
        --subject-alternative-names "*.snovaha.com" \
        --validation-method DNS \
        --query 'CertificateArn' \
        --output text)
    
    echo "📋 새 인증서 ARN: $CERT_ARN"
    echo "⚠️  DNS 검증이 필요합니다. Route 53에서 검증 레코드를 추가해주세요."
else
    echo "✅ 기존 인증서 발견: $CERT_ARN"
fi

# 2. CloudFront 배포 설정 업데이트
echo "☁️ CloudFront 배포 업데이트 중..."

# 현재 배포 설정 가져오기
ETAG=$(aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query 'ETag' --output text)

# 배포 설정을 JSON 파일로 저장
aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query 'DistributionConfig' > /tmp/distribution-config.json

# 사용자 정의 도메인과 SSL 인증서 추가
cat > /tmp/update-config.jq << 'EOF'
{
  "Aliases": {
    "Quantity": 1,
    "Items": ["snovaha.com"]
  },
  "ViewerCertificate": {
    "ACMCertificateArn": $cert_arn,
    "SSLSupportMethod": "sni-only",
    "MinimumProtocolVersion": "TLSv1.2_2021",
    "CertificateSource": "acm"
  },
  "DefaultCacheBehavior": (. | .DefaultCacheBehavior | .ViewerProtocolPolicy = "redirect-to-https"),
  "Comment": "한우주 돌잔치 초대장 - snovaha.com 연결"
} as $updates | . * $updates
EOF

jq --arg cert_arn "$CERT_ARN" -f /tmp/update-config.jq /tmp/distribution-config.json > /tmp/distribution-config-updated.json

# CloudFront 배포 업데이트
aws cloudfront update-distribution \
    --id $DISTRIBUTION_ID \
    --distribution-config file:///tmp/distribution-config-updated.json \
    --if-match $ETAG

echo "✅ CloudFront 배포 업데이트 완료"

# 3. Route 53 설정 안내
echo ""
echo "🌐 Route 53 DNS 설정이 필요합니다:"
echo ""
echo "1. AWS Route 53 콘솔로 이동: https://console.aws.amazon.com/route53/"
echo "2. snovaha.com 호스팅 영역 선택"
echo "3. 다음 레코드 추가:"
echo ""
echo "   레코드 이름: snovaha.com (루트 도메인)"
echo "   레코드 타입: A"
echo "   별칭: 예"
echo "   별칭 대상: CloudFront 배포 ($CLOUDFRONT_DOMAIN)"
echo ""
echo "또는 CLI로 설정:"
echo ""
echo "HOSTED_ZONE_ID=\$(aws route53 list-hosted-zones --query \"HostedZones[?Name=='snovaha.com.'].Id\" --output text | cut -d'/' -f3)"
echo ""
echo "aws route53 change-resource-record-sets --hosted-zone-id \$HOSTED_ZONE_ID --change-batch '{
    \"Changes\": [
        {
            \"Action\": \"UPSERT\",
            \"ResourceRecordSet\": {
                \"Name\": \"snovaha.com\",
                \"Type\": \"A\",
                \"AliasTarget\": {
                    \"DNSName\": \"'$CLOUDFRONT_DOMAIN'\",
                    \"EvaluateTargetHealth\": false,
                    \"HostedZoneId\": \"Z2FDTNDATAQYW2\"
                }
            }
        }
    ]
}'"

echo ""
echo "4. 웹서버에 리다이렉트 설정:"
echo ""
echo "   snovaha.com/invitation/woojoo-han → https://snovaha.com (루트로 리다이렉트)"
echo ""
echo "📝 완료 후 접속 URL:"
echo "   https://snovaha.com (메인 도메인)"
echo "   https://snovaha.com/invitation/woojoo-han (리다이렉트 설정 후)"

# 임시 파일 정리
rm -f /tmp/distribution-config.json /tmp/distribution-config-updated.json /tmp/update-config.jq

echo ""
echo "⏳ 배포 완료까지 15-20분 소요됩니다."
