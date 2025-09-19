#!/bin/bash

# 갤러리 이미지 일괄 업로드 스크립트

if [ $# -eq 0 ]; then
    echo "❌ 사용법: $0 <이미지폴더경로>"
    echo "예시: $0 \"내갤러리폴더/\""
    echo "또는: $0 \"이미지1.jpg\" \"이미지2.jpg\" ..."
    exit 1
fi

PROJECT_ROOT="$(dirname "$0")/../.."
GALLERY_DIR="$PROJECT_ROOT/src/public/assets/images/gallery"

# 갤러리 디렉토리 생성
mkdir -p "$GALLERY_DIR"

# 첫 번째 인자가 폴더인지 확인
if [ -d "$1" ]; then
    FOLDER="$1"
    echo "📁 폴더에서 이미지를 찾는 중: $FOLDER"
    
    # 이미지 파일들을 배열로 수집
    IMAGE_FILES=($(find "$FOLDER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort))
    
    if [ ${#IMAGE_FILES[@]} -eq 0 ]; then
        echo "❌ 폴더에 이미지 파일이 없습니다: $FOLDER"
        exit 1
    fi
    
    echo "📸 발견된 이미지: ${#IMAGE_FILES[@]}개"
    
    # 최대 6개까지만 처리
    MAX_IMAGES=6
    for i in $(seq 0 $((MAX_IMAGES-1))); do
        if [ $i -lt ${#IMAGE_FILES[@]} ]; then
            IMAGE_FILE="${IMAGE_FILES[$i]}"
            TARGET_FILE="$GALLERY_DIR/gallery-$((i+1)).jpg"
            
            echo "📸 복사 중: $(basename "$IMAGE_FILE") -> gallery-$((i+1)).jpg"
            cp "$IMAGE_FILE" "$TARGET_FILE"
        fi
    done
    
else
    # 개별 파일들로 처리
    echo "📸 개별 파일들을 갤러리에 복사합니다..."
    
    INDEX=1
    for IMAGE_FILE in "$@"; do
        if [ ! -f "$IMAGE_FILE" ]; then
            echo "⚠️  파일이 존재하지 않습니다: $IMAGE_FILE"
            continue
        fi
        
        if [ $INDEX -gt 6 ]; then
            echo "⚠️  갤러리는 최대 6개 이미지만 지원합니다."
            break
        fi
        
        # 파일 확장자 확인
        EXTENSION="${IMAGE_FILE##*.}"
        case "$EXTENSION" in
            jpg|JPG|jpeg|JPEG|png|PNG)
                echo "📸 복사 중: $(basename "$IMAGE_FILE") -> gallery-$INDEX.jpg"
                cp "$IMAGE_FILE" "$GALLERY_DIR/gallery-$INDEX.jpg"
                INDEX=$((INDEX+1))
                ;;
            *)
                echo "⚠️  지원되지 않는 형식: $IMAGE_FILE ($EXTENSION)"
                ;;
        esac
    done
fi

echo ""
echo "✅ 갤러리 이미지 업로드 완료!"
echo "📁 위치: $GALLERY_DIR/"
echo "🎯 용도: '소중한 순간들' 섹션"
echo ""
echo "📋 업로드된 파일들:"
ls -la "$GALLERY_DIR/"
echo ""
echo "🚀 배포하려면 다음 명령어를 실행하세요:"
echo "cd $PROJECT_ROOT/scripts/aws && ./deploy.sh"
