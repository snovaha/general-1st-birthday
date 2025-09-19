const express = require('express');
const multer = require('multer');
const AWS = require('aws-sdk');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// CORS 설정
app.use(cors({
    origin: ['http://localhost:3000', 'http://127.0.0.1:3000', 'file://'],
    credentials: true
}));

app.use(express.json());
app.use(express.static('public'));

// AWS S3 설정
const s3 = new AWS.S3({
    region: 'ap-northeast-2'
});

const BUCKET_NAME = '1st-birthday-invitation-20251011';
const CLOUDFRONT_DISTRIBUTION_ID = 'E2Z50QKS64PV0U';

// Multer 설정 (메모리 저장)
const upload = multer({
    storage: multer.memoryStorage(),
    limits: {
        fileSize: 10 * 1024 * 1024, // 10MB 제한
    },
    fileFilter: (req, file, cb) => {
        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        if (allowedTypes.includes(file.mimetype)) {
            cb(null, true);
        } else {
            cb(new Error('지원되지 않는 파일 형식입니다. JPEG, PNG, GIF, WebP만 가능합니다.'));
        }
    }
});

// 이미지 업로드 엔드포인트
app.post('/api/upload-image', upload.single('image'), async (req, res) => {
    try {
        const { imageType } = req.body;
        const file = req.file;

        if (!file) {
            return res.status(400).json({ error: '파일이 업로드되지 않았습니다.' });
        }

        if (!imageType) {
            return res.status(400).json({ error: '이미지 타입이 지정되지 않았습니다.' });
        }

        // 파일 경로 결정
        let s3Key;
        switch (imageType) {
            case 'hero':
                s3Key = 'assets/images/hero.jpg';
                break;
            case 'gallery':
                const galleryIndex = req.body.galleryIndex || '1';
                s3Key = `assets/images/gallery/gallery-${galleryIndex}.jpg`;
                break;
            case 'timeline':
                const timelineIndex = req.body.timelineIndex || '1';
                s3Key = `assets/images/timeline/event-${timelineIndex}.jpg`;
                break;
            default:
                return res.status(400).json({ error: '잘못된 이미지 타입입니다.' });
        }

        // S3에 업로드
        const uploadParams = {
            Bucket: BUCKET_NAME,
            Key: s3Key,
            Body: file.buffer,
            ContentType: file.mimetype,
            CacheControl: 'max-age=31536000' // 1년 캐시
        };

        const result = await s3.upload(uploadParams).promise();

        // CloudFront 캐시 무효화
        const cloudfront = new AWS.CloudFront();
        const invalidationParams = {
            DistributionId: CLOUDFRONT_DISTRIBUTION_ID,
            InvalidationBatch: {
                CallerReference: Date.now().toString(),
                Paths: {
                    Quantity: 1,
                    Items: [`/${s3Key}`]
                }
            }
        };

        await cloudfront.createInvalidation(invalidationParams).promise();

        res.json({
            success: true,
            message: '이미지가 성공적으로 업로드되었습니다.',
            url: result.Location,
            s3Key: s3Key
        });

    } catch (error) {
        console.error('업로드 에러:', error);
        res.status(500).json({ 
            error: '업로드 중 오류가 발생했습니다.', 
            details: error.message 
        });
    }
});

// 컨텐츠 업데이트 엔드포인트
app.post('/api/update-content', async (req, res) => {
    try {
        const { 
            babyName, babyBirthDate, babyGender,
            fatherName, motherName, contact,
            partyDate, partyTime, venue, venueSub, address, mapLink
        } = req.body;

        // 설정 파일 업데이트
        const config = {
            baby: { name: babyName, birthDate: babyBirthDate, gender: babyGender },
            parents: { father: fatherName, mother: motherName, contact: contact },
            party: { date: partyDate, time: partyTime, venue, venueSub, address, mapLink }
        };

        // 로컬에 설정 파일 저장
        const configPath = path.join(__dirname, '../config/site-config.json');
        const configDir = path.dirname(configPath);
        
        if (!fs.existsSync(configDir)) {
            fs.mkdirSync(configDir, { recursive: true });
        }
        
        fs.writeFileSync(configPath, JSON.stringify(config, null, 2));

        // HTML 파일 업데이트 (간단한 템플릿 교체)
        const htmlPath = path.join(__dirname, '../public/index.html');
        let htmlContent = fs.readFileSync(htmlPath, 'utf8');

        // 컨텐츠 교체
        htmlContent = htmlContent
            .replace(/<h2 class="hero-name">.*?<\/h2>/, `<h2 class="hero-name">${babyName}</h2>`)
            .replace(/아빠\s+\S+,\s+엄마\s+\S+\s+올림/, `아빠 ${fatherName}, 엄마 ${motherName} 올림`)
            .replace(/문의:\s*[\d-]+\s*\([^)]+\)/, `문의: ${contact} (${fatherName})`);

        fs.writeFileSync(htmlPath, htmlContent);

        // S3에 업데이트된 HTML 업로드
        const uploadParams = {
            Bucket: BUCKET_NAME,
            Key: 'index.html',
            Body: htmlContent,
            ContentType: 'text/html'
        };

        await s3.upload(uploadParams).promise();

        // CloudFront 캐시 무효화
        const cloudfront = new AWS.CloudFront();
        const invalidationParams = {
            DistributionId: CLOUDFRONT_DISTRIBUTION_ID,
            InvalidationBatch: {
                CallerReference: Date.now().toString(),
                Paths: {
                    Quantity: 1,
                    Items: ['/index.html']
                }
            }
        };

        await cloudfront.createInvalidation(invalidationParams).promise();

        res.json({
            success: true,
            message: '컨텐츠가 성공적으로 업데이트되었습니다.'
        });

    } catch (error) {
        console.error('컨텐츠 업데이트 에러:', error);
        res.status(500).json({ 
            error: '컨텐츠 업데이트 중 오류가 발생했습니다.', 
            details: error.message 
        });
    }
});

// 빠른 배포 엔드포인트
app.post('/api/quick-deploy', async (req, res) => {
    try {
        // CloudFront 전체 캐시 무효화
        const cloudfront = new AWS.CloudFront();
        const invalidationParams = {
            DistributionId: CLOUDFRONT_DISTRIBUTION_ID,
            InvalidationBatch: {
                CallerReference: Date.now().toString(),
                Paths: {
                    Quantity: 1,
                    Items: ['/*']
                }
            }
        };

        const result = await cloudfront.createInvalidation(invalidationParams).promise();

        res.json({
            success: true,
            message: '전체 캐시가 무효화되었습니다.',
            invalidationId: result.Invalidation.Id
        });

    } catch (error) {
        console.error('빠른 배포 에러:', error);
        res.status(500).json({ 
            error: '배포 중 오류가 발생했습니다.', 
            details: error.message 
        });
    }
});

// 서버 상태 확인
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'ok', 
        message: '1st Birthday Admin API Server', 
        timestamp: new Date().toISOString()
    });
});

app.listen(PORT, () => {
    console.log(`🚀 Admin API Server running on http://localhost:${PORT}`);
    console.log(`📊 Health check: http://localhost:${PORT}/api/health`);
});
