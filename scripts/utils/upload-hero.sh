#!/bin/bash

# Hero 이미지 업로드 스크립트

if [ $# -eq 0 ]; then
    echo "❌ 사용법: $0 <이미지파일경로>"
    echo "예시: $0 \"내아기사진.jpg\""
    exit 1
fi

IMAGE_FILE="$1"
PROJECT_ROOT="$(dirname "$0")/../.."
IMAGES_DIR="$PROJECT_ROOT/src/public/assets/images"

# 파일 존재 확인
if [ ! -f "$IMAGE_FILE" ]; then
    echo "❌ 파일이 존재하지 않습니다: $IMAGE_FILE"
    exit 1
fi

# 이미지 디렉토리 생성
mkdir -p "$IMAGES_DIR"

# 파일 확장자 확인
EXTENSION="${IMAGE_FILE##*.}"
case "$EXTENSION" in
    jpg|JPG|jpeg|JPEG)
        echo "📸 JPG 이미지를 hero.jpg로 복사합니다..."
        cp "$IMAGE_FILE" "$IMAGES_DIR/hero.jpg"
        ;;
    png|PNG)
        echo "📸 PNG 이미지를 hero.jpg로 복사합니다..."
        cp "$IMAGE_FILE" "$IMAGES_DIR/hero.jpg"
        ;;
    *)
        echo "❌ 지원되지 않는 이미지 형식: $EXTENSION"
        echo "지원 형식: jpg, jpeg, png"
        exit 1
        ;;
esac

echo "✅ Hero 이미지 업로드 완료!"
echo "📁 위치: $IMAGES_DIR/hero.jpg"
echo "🎯 용도: 메인 화면 원형 프로필 사진"
echo ""
echo "🚀 배포하려면 다음 명령어를 실행하세요:"
echo "cd $PROJECT_ROOT/scripts/aws && ./deploy.sh"
