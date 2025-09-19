#!/bin/bash

# 음악 파일 업로드 스크립트

if [ $# -eq 0 ]; then
    echo "❌ 사용법: $0 <음악파일경로>"
    echo "예시: $0 \"내음악.mp3\""
    exit 1
fi

MUSIC_FILE="$1"
PROJECT_ROOT="$(dirname "$0")/../.."
AUDIO_DIR="$PROJECT_ROOT/src/public/assets/audio"

# 파일 존재 확인
if [ ! -f "$MUSIC_FILE" ]; then
    echo "❌ 파일이 존재하지 않습니다: $MUSIC_FILE"
    exit 1
fi

# 오디오 디렉토리 생성
mkdir -p "$AUDIO_DIR"

# 파일 확장자 확인
EXTENSION="${MUSIC_FILE##*.}"
case "$EXTENSION" in
    mp3|MP3)
        echo "🎵 MP3 파일을 background.mp3로 복사합니다..."
        cp "$MUSIC_FILE" "$AUDIO_DIR/background.mp3"
        ;;
    mp4|MP4)
        echo "🎵 MP4 파일을 background.mp4로 복사합니다..."
        cp "$MUSIC_FILE" "$AUDIO_DIR/background.mp4"
        echo "ℹ️  참고: MP4는 비디오 파일이지만 오디오만 재생됩니다."
        ;;
    ogg|OGG)
        echo "🎵 OGG 파일을 background.ogg로 복사합니다..."
        cp "$MUSIC_FILE" "$AUDIO_DIR/background.ogg"
        ;;
    wav|WAV)
        echo "🎵 WAV 파일을 background.mp3로 복사합니다 (변환 권장)..."
        cp "$MUSIC_FILE" "$AUDIO_DIR/background.mp3"
        ;;
    *)
        echo "❌ 지원되지 않는 파일 형식: $EXTENSION"
        echo "지원 형식: mp3, mp4, ogg, wav"
        exit 1
        ;;
esac

echo "✅ 음악 파일 업로드 완료!"
echo "📁 위치: $AUDIO_DIR/background.mp3"
echo ""
echo "🚀 배포하려면 다음 명령어를 실행하세요:"
echo "cd $PROJECT_ROOT/scripts/aws && ./deploy.sh"
