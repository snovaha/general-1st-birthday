# 🎵 MP4를 MP3로 변환하는 방법

MP4 파일(보통 비디오)에서 오디오만 추출하여 웹사이트 배경음악으로 사용하는 방법을 안내합니다.

## 🛠️ **변환 방법들**

### **방법 1: ffmpeg 사용 (무료, 추천)**

#### **설치**
```bash
# macOS (Homebrew)
brew install ffmpeg

# Windows (Chocolatey)
choco install ffmpeg

# 또는 https://ffmpeg.org/download.html 에서 다운로드
```

#### **변환 명령어**
```bash
# 기본 변환
ffmpeg -i "입력파일.mp4" -q:a 0 -map a "출력파일.mp3"

# 고음질 변환
ffmpeg -i "입력파일.mp4" -acodec libmp3lame -ab 192k "출력파일.mp3"

# 예시
ffmpeg -i "유튜브다운로드.mp4" -q:a 0 -map a "우주생일축하.mp3"
```

### **방법 2: 온라인 변환기 (간편)**

**무료 온라인 도구들:**
- **CloudConvert**: https://cloudconvert.com/mp4-to-mp3
- **Online-Convert**: https://audio.online-convert.com/convert-to-mp3
- **Zamzar**: https://www.zamzar.com/convert/mp4-to-mp3/

**사용법:**
1. 사이트 접속
2. MP4 파일 업로드
3. MP3로 변환 설정
4. 변환 후 다운로드

### **방법 3: VLC Media Player (무료)**

1. **VLC 실행** (없으면 https://www.videolan.org/vlc/ 에서 다운로드)
2. **미디어 > 변환/저장** 클릭
3. **파일** 탭에서 MP4 파일 추가
4. **변환/저장** 버튼 클릭
5. **프로필**에서 "Audio - MP3" 선택
6. **찾아보기**로 저장 위치 지정
7. **시작** 클릭

### **방법 4: 맥 전용 - QuickTime Player**

1. **QuickTime Player**로 MP4 열기
2. **파일 > 내보내기 > 오디오만** 선택
3. MP3 형식으로 저장

## 🎵 **변환 후 업로드**

변환이 완료되면 제공된 스크립트로 쉽게 업로드:

```bash
# MP3 파일 업로드
./scripts/utils/upload-music.sh "변환된음악.mp3"

# 또는 MP4 파일 직접 업로드 (브라우저에서 오디오만 재생)
./scripts/utils/upload-music.sh "원본영상.mp4"

# 배포
cd scripts/aws && ./deploy.sh
```

## ⚙️ **ffmpeg 상세 옵션**

### **음질 설정**
```bash
# 최고 음질 (용량 큼)
ffmpeg -i input.mp4 -acodec libmp3lame -ab 320k output.mp3

# 일반 음질 (권장)
ffmpeg -i input.mp4 -acodec libmp3lame -ab 192k output.mp3

# 압축 음질 (용량 작음)
ffmpeg -i input.mp4 -acodec libmp3lame -ab 128k output.mp3
```

### **시간 자르기**
```bash
# 30초부터 2분간 추출
ffmpeg -i input.mp4 -ss 30 -t 120 -acodec libmp3lame -ab 192k output.mp3

# 1분부터 끝까지
ffmpeg -i input.mp4 -ss 60 -acodec libmp3lame -ab 192k output.mp3
```

### **볼륨 조절**
```bash
# 볼륨 50% 줄이기
ffmpeg -i input.mp4 -af "volume=0.5" -acodec libmp3lame -ab 192k output.mp3

# 볼륨 2배 키우기 (주의: 왜곡 가능)
ffmpeg -i input.mp4 -af "volume=2.0" -acodec libmp3lame -ab 192k output.mp3
```

## 📏 **권장 설정**

### **돌잔치 배경음악용**
- **길이**: 2-3분 (자동 반복됨)
- **음질**: 192kbps (웹용 적당)
- **볼륨**: 적당히 (코드에서 30%로 자동 조절)
- **파일 크기**: 5MB 이하

### **예시 명령어**
```bash
# 돌잔치용 최적화 변환
ffmpeg -i "유튜브영상.mp4" -ss 0 -t 180 -af "volume=0.7" -acodec libmp3lame -ab 192k "우주돌잔치.mp3"
```

## ⚠️ **주의사항**

1. **저작권**: 유튜브 영상의 음악은 대부분 저작권이 있음
2. **개인 사용**: 가족/친구 초대용 개인 사용만 권장
3. **상업적 사용 금지**: 공개적/상업적 사용 시 저작권 문제 발생 가능
4. **음질**: 너무 높은 음질은 로딩 속도 저하 가능

## 🎯 **완성 후 확인**

1. **변환 완료** → MP3 파일 생성
2. **업로드**: `./scripts/utils/upload-music.sh "파일.mp3"`
3. **배포**: `cd scripts/aws && ./deploy.sh`
4. **확인**: https://d104xm32ar1ns2.cloudfront.net/ 접속
5. **우측 상단 🎵 버튼** 클릭하여 음악 재생 테스트
