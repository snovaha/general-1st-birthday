#!/bin/bash

# 플레이스홀더 이미지 생성 스크립트
# ImageMagick이 설치되어 있어야 합니다: brew install imagemagick

echo "🖼️  플레이스홀더 이미지 생성 중..."

# ImageMagick 설치 확인
if ! command -v convert &> /dev/null; then
    echo "⚠️  ImageMagick이 설치되지 않았습니다."
    echo "다음 명령어로 설치해주세요: brew install imagemagick"
    exit 1
fi

# images 폴더 생성 (이미 있으면 무시)
mkdir -p images

# 색상 정의
ORANGE="#f4a261"
PEACH="#e76f51"
CREAM="#fef7f0"

# Hero 이미지 (280x280 원형)
convert -size 280x280 xc:"$ORANGE" \
    -fill "$PEACH" -draw "circle 140,140 140,70" \
    -fill white -gravity center -pointsize 24 -annotate +0+0 "우리 아이\n첫 생일" \
    images/hero.jpg

# 타임라인 이미지들 (120x120)
convert -size 120x120 xc:"$CREAM" \
    -fill "$ORANGE" -gravity center -pointsize 14 -annotate +0-10 "출생" \
    -fill "$PEACH" -pointsize 12 -annotate +0+10 "2024.10.11" \
    images/event-1.jpg

convert -size 120x120 xc:"$CREAM" \
    -fill "$ORANGE" -gravity center -pointsize 14 -annotate +0-10 "백일" \
    -fill "$PEACH" -pointsize 12 -annotate +0+10 "2024.12.15" \
    images/event-2.jpg

convert -size 120x120 xc:"$CREAM" \
    -fill "$ORANGE" -gravity center -pointsize 14 -annotate +0-10 "뒤집기" \
    -fill "$PEACH" -pointsize 12 -annotate +0+10 "2025.03.20" \
    images/event-3.jpg

convert -size 120x120 xc:"$CREAM" \
    -fill "$ORANGE" -gravity center -pointsize 14 -annotate +0-10 "앉기" \
    -fill "$PEACH" -pointsize 12 -annotate +0+10 "2025.07.10" \
    images/event-4.jpg

convert -size 120x120 xc:"$CREAM" \
    -fill "$ORANGE" -gravity center -pointsize 14 -annotate +0-10 "기어다니기" \
    -fill "$PEACH" -pointsize 12 -annotate +0+10 "2025.09.05" \
    images/event-5.jpg

# 갤러리 이미지들 (정사각형)
for i in {1..6}; do
    convert -size 200x200 xc:"$CREAM" \
        -fill "$ORANGE" -gravity center -pointsize 16 -annotate +0-10 "갤러리" \
        -fill "$PEACH" -pointsize 14 -annotate +0+10 "사진 $i" \
        images/gallery-$i.jpg
done

echo "✅ 플레이스홀더 이미지 생성 완료!"
echo "📁 images/ 폴더에 다음 파일들이 생성되었습니다:"
ls -la images/
