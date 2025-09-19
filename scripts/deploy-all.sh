#!/bin/bash

# 통합 배포 스크립트
echo "🚀 1st Birthday 통합 배포 시작..."

# 현재 디렉토리 확인
if [ ! -f "config/site-config.json" ]; then
    echo "❌ 프로젝트 루트에서 실행해주세요."
    exit 1
fi

# S3 배포
echo "📤 S3에 업로드 중..."
cd scripts/aws && ./deploy.sh && cd ../..

echo "✅ 배포 완료!"
echo "🌐 접속 URL: https://invitation.snovaha.com"
