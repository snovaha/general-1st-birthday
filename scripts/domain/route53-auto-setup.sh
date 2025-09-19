#!/bin/bash

# Route 53으로 이전된 snovaha.com 자동 연결 스크립트
# 사전 요구사항: snovaha.com이 Route 53으로 이전 완료

DOMAIN="snovaha.com"
CLOUDFRONT_DOMAIN="d104xm32ar1ns2.cloudfront.net"
DISTRIBUTION_ID="E2Z50QKS64PV0U"

echo "🌐 Route 53 snovaha.com 자동 연결을 시작합니다..."

# 1. Route 53 호스팅 영역 확인
echo "🔍 Route 53 호스팅 영역 확인 중..."
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='${DOMAIN}.'].Id" --output text | cut -d'/' -f3)

if [ -z "$HOSTED_ZONE_ID" ]; then
    echo "❌ Route 53에서 $DOMAIN 호스팅 영역을 찾을 수 없습니다."
    echo "먼저 도메인을 Route 53으로 이전해주세요."
    exit 1
fi

echo "✅ 호스팅 영역 ID: $HOSTED_ZONE_ID"

# 2. SSL 인증서 요청 (CloudFront용 - us-east-1)
echo "🔒 SSL 인증서 요청 중..."
CERT_ARN=$(aws acm request-certificate \
    --region us-east-1 \
    --domain-name $DOMAIN \
    --subject-alternative-names "www.$DOMAIN" \
    --validation-method DNS \
    --query 'CertificateArn' \
    --output text)

echo "📋 인증서 ARN: $CERT_ARN"

# 3. 인증서 검증 레코드 자동 추가
echo "⏳ 인증서 검증 레코드 생성 중..."
sleep 15

# 검증 레코드 정보 가져오기
VALIDATION_RECORDS=$(aws acm describe-certificate \
    --region us-east-1 \
    --certificate-arn $CERT_ARN \
    --query 'Certificate.DomainValidationOptions[].ResourceRecord' \
    --output json)

# Route 53에 검증 레코드 추가
echo "🔍 DNS 검증 레코드 추가 중..."
for record in $(echo $VALIDATION_RECORDS | jq -c '.[]'); do
    NAME=$(echo $record | jq -r '.Name')
    VALUE=$(echo $record | jq -r '.Value')
    
    aws route53 change-resource-record-sets \
        --hosted-zone-id $HOSTED_ZONE_ID \
        --change-batch "{
            \"Changes\": [{
                \"Action\": \"CREATE\",
                \"ResourceRecordSet\": {
                    \"Name\": \"$NAME\",
                    \"Type\": \"CNAME\",
                    \"TTL\": 300,
                    \"ResourceRecords\": [{
                        \"Value\": \"$VALUE\"
                    }]
                }
            }]
        }"
done

echo "✅ 검증 레코드 추가 완료"

# 4. 인증서 검증 대기
echo "⏳ SSL 인증서 검증 대기 중... (최대 30분)"
aws acm wait certificate-validated --region us-east-1 --certificate-arn $CERT_ARN

echo "✅ SSL 인증서 검증 완료!"

# 5. CloudFront 배포에 사용자 정의 도메인 추가
echo "☁️ CloudFront 배포 업데이트 중..."

# 현재 배포 설정 가져오기
ETAG=$(aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query 'ETag' --output text)

# 배포 설정 업데이트
aws cloudfront get-distribution-config --id $DISTRIBUTION_ID --query 'DistributionConfig' > /tmp/distribution-config.json

# 사용자 정의 도메인과 SSL 인증서 추가
jq --arg domain "$DOMAIN" --arg cert "$CERT_ARN" '
.Aliases = {
    "Quantity": 2,
    "Items": [$domain, ("www." + $domain)]
} |
.ViewerCertificate = {
    "ACMCertificateArn": $cert,
    "SSLSupportMethod": "sni-only",
    "MinimumProtocolVersion": "TLSv1.2_2021",
    "CertificateSource": "acm"
} |
.Comment = "한우주 돌잔치 초대장 - " + $domain + " 연결"
' /tmp/distribution-config.json > /tmp/distribution-config-updated.json

aws cloudfront update-distribution \
    --id $DISTRIBUTION_ID \
    --distribution-config file:///tmp/distribution-config-updated.json \
    --if-match $ETAG

echo "✅ CloudFront 배포 업데이트 완료"

# 6. Route 53에 A 레코드 추가 (CloudFront 별칭)
echo "🌐 Route 53 A 레코드 추가 중..."

aws route53 change-resource-record-sets \
    --hosted-zone-id $HOSTED_ZONE_ID \
    --change-batch "{
        \"Changes\": [
            {
                \"Action\": \"CREATE\",
                \"ResourceRecordSet\": {
                    \"Name\": \"$DOMAIN\",
                    \"Type\": \"A\",
                    \"AliasTarget\": {
                        \"DNSName\": \"$CLOUDFRONT_DOMAIN\",
                        \"EvaluateTargetHealth\": false,
                        \"HostedZoneId\": \"Z2FDTNDATAQYW2\"
                    }
                }
            },
            {
                \"Action\": \"CREATE\",
                \"ResourceRecordSet\": {
                    \"Name\": \"www.$DOMAIN\",
                    \"Type\": \"A\",
                    \"AliasTarget\": {
                        \"DNSName\": \"$CLOUDFRONT_DOMAIN\",
                        \"EvaluateTargetHealth\": false,
                        \"HostedZoneId\": \"Z2FDTNDATAQYW2\"
                    }
                }
            }
        ]
    }"

echo "✅ Route 53 A 레코드 추가 완료"

# 임시 파일 정리
rm -f /tmp/distribution-config.json /tmp/distribution-config-updated.json

echo ""
echo "🎉 자동 연결 완료!"
echo "🌐 새 URL들:"
echo "   - https://$DOMAIN"
echo "   - https://www.$DOMAIN"
echo ""
echo "⏳ 완전 적용까지 15-30분 소요"
echo "📝 DNS 전파까지 최대 48시간 (보통 1-2시간)"
