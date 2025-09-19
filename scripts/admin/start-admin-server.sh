#!/bin/bash

# 1st Birthday Admin Server 시작 스크립트

echo "🚀 1st Birthday Admin Server 시작..."

# 프로젝트 루트로 이동
cd "$(dirname "$0")/../.."

# API 디렉토리로 이동
cd src/api

# .env 파일 존재 확인
if [ ! -f ".env" ]; then
    echo "❌ .env 파일이 없습니다!"
    echo "📝 env.example을 참고하여 .env 파일을 생성해주세요:"
    echo ""
    echo "cp env.example .env"
    echo ""
    echo "그리고 AWS 설정을 입력해주세요:"
    echo "- AWS_ACCESS_KEY_ID"
    echo "- AWS_SECRET_ACCESS_KEY"
    echo ""
    exit 1
fi

# Node.js 의존성 설치
echo "📦 의존성 설치 중..."
if [ ! -d "node_modules" ]; then
    npm install
fi

# 서버 시작
echo "🌐 Admin API 서버 시작 중..."
echo "📋 Admin 페이지: file://$(pwd)/../../admin/index.html"
echo "🔗 API 서버: http://localhost:3001"
echo ""
echo "Ctrl+C로 서버를 종료할 수 있습니다."
echo ""

npm start
