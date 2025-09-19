# 🎵🖼️ 배경음악 & 이미지 업로드 가이드

## 📂 **파일 위치 및 업로드 방법**

### 🎵 **배경음악 업로드**

#### **📍 위치**
```
src/public/assets/audio/
├── background.mp3    (기본 형식)
└── background.ogg    (백업 형식)
```

#### **🔧 업로드 방법**

**방법 1: 직접 파일 복사**
```bash
# 프로젝트 루트에서
cp "내음악.mp3" src/public/assets/audio/background.mp3
```

**방법 2: 파일명 그대로 복사 후 이름 변경**
```bash
# 1. 음악 파일을 audio 폴더에 복사
cp "내가원하는음악.mp3" src/public/assets/audio/

# 2. 파일명을 background.mp3로 변경
mv src/public/assets/audio/내가원하는음악.mp3 src/public/assets/audio/background.mp3
```

#### **🎼 지원 형식**
- **MP3** (권장) - 모든 브라우저 지원
- **OGG** (백업) - 일부 브라우저용
- **WAV** (고음질이지만 파일 크기 큼)

#### **📏 권장 설정**
- **길이**: 2-3분 (무한 반복됨)
- **볼륨**: 중간 정도 (코드에서 30%로 자동 조절)
- **파일 크기**: 5MB 이하 권장

---

### 🖼️ **이미지 업로드**

#### **📍 위치별 가이드**

**🏠 메인 Hero 이미지**
```
src/public/assets/images/hero.jpg
```
- **용도**: 메인 화면 원형 사진
- **권장 크기**: 500x500px 이상 (정사각형)
- **형식**: JPG, PNG

**📷 갤러리 이미지**
```
src/public/assets/images/gallery/
├── gallery-1.jpg
├── gallery-2.jpg
├── gallery-3.jpg
├── gallery-4.jpg
├── gallery-5.jpg
└── gallery-6.jpg
```
- **용도**: "소중한 순간들" 섹션
- **권장 크기**: 400x300px 이상
- **개수**: 6개 (더 늘리려면 HTML 수정 필요)

#### **🔧 이미지 업로드 방법**

**Hero 이미지 교체**
```bash
# 내 아기 사진을 hero.jpg로 복사
cp "내아기사진.jpg" src/public/assets/images/hero.jpg
```

**갤러리 이미지 교체**
```bash
# 갤러리 사진들을 번호순으로 복사
cp "사진1.jpg" src/public/assets/images/gallery/gallery-1.jpg
cp "사진2.jpg" src/public/assets/images/gallery/gallery-2.jpg
cp "사진3.jpg" src/public/assets/images/gallery/gallery-3.jpg
cp "사진4.jpg" src/public/assets/images/gallery/gallery-4.jpg
cp "사진5.jpg" src/public/assets/images/gallery/gallery-5.jpg
cp "사진6.jpg" src/public/assets/images/gallery/gallery-6.jpg
```

**한 번에 여러 이미지 교체 (일괄 처리)**
```bash
# 이미지 파일들이 있는 폴더에서
cd "내이미지폴더"

# 파일명을 gallery-숫자.jpg 형식으로 이름 변경
cp IMG_001.jpg ~/dev/1st-birthday/src/public/assets/images/gallery/gallery-1.jpg
cp IMG_002.jpg ~/dev/1st-birthday/src/public/assets/images/gallery/gallery-2.jpg
# ... 계속
```

---

## 🚀 **업로드 후 배포**

파일을 교체한 후 반드시 배포해야 웹사이트에 반영됩니다:

```bash
# 프로젝트 루트에서
cd scripts/aws
./deploy.sh

# CloudFront 캐시 무효화 (즉시 반영)
cd ../..
aws cloudfront create-invalidation --distribution-id E2Z50QKS64PV0U --paths "/assets/*"
```

---

## 📱 **간편 업로드 스크립트**

편의를 위한 자동화 스크립트를 만들어드렸습니다:

### **🎵 음악 업로드 스크립트**
```bash
# scripts/utils/upload-music.sh
./scripts/utils/upload-music.sh "내음악파일.mp3"
```

### **🖼️ 이미지 업로드 스크립트**
```bash
# Hero 이미지 업로드
./scripts/utils/upload-hero.sh "내아기사진.jpg"

# 갤러리 일괄 업로드 (폴더 지정)
./scripts/utils/upload-gallery.sh "내갤러리폴더/"
```

---

## ⚠️ **주의사항**

### **파일 형식**
- **이미지**: JPG, PNG만 지원
- **음악**: MP3 권장 (OGG 백업)

### **파일 크기**
- **이미지**: 각각 2MB 이하 권장
- **음악**: 5MB 이하 권장

### **파일명 규칙**
- **영문/숫자**만 사용
- **공백 없이** (대신 하이픈 - 사용)
- **특수문자 금지**

### **배포 필수**
- 파일 교체 후 반드시 `./scripts/aws/deploy.sh` 실행
- CloudFront 캐시 무효화로 즉시 반영

---

## 🎯 **빠른 시작 예시**

```bash
# 1. 내 파일들을 준비된 위치에 복사
cp "우주생일축하.mp3" src/public/assets/images/audio/background.mp3
cp "우주첫생일.jpg" src/public/assets/images/hero.jpg

# 2. 갤러리 사진들 복사
cp "생후1개월.jpg" src/public/assets/images/gallery/gallery-1.jpg
cp "생후3개월.jpg" src/public/assets/images/gallery/gallery-2.jpg
cp "생후6개월.jpg" src/public/assets/images/gallery/gallery-3.jpg
# ... 계속

# 3. 배포
cd scripts/aws && ./deploy.sh

# 4. 즉시 반영을 위한 캐시 무효화
cd ../.. && aws cloudfront create-invalidation --distribution-id E2Z50QKS64PV0U --paths "/assets/*"
```

이제 https://d104xm32ar1ns2.cloudfront.net/ 에서 내 음악과 사진들을 확인할 수 있습니다! 🎉
