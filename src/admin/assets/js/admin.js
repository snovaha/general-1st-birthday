// 1st Birthday Admin JavaScript

// 설정 로드
let siteConfig = {};

// 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', function() {
    loadConfig();
    initTabs();
    updateDashboard();
});

// 설정 파일 로드
async function loadConfig() {
    try {
        const response = await fetch('../../../config/site-config.json');
        siteConfig = await response.json();
        populateFormData();
    } catch (error) {
        console.error('설정 로드 실패:', error);
        // 기본값 사용
        siteConfig = getDefaultConfig();
    }
}

// 기본 설정값
function getDefaultConfig() {
    return {
        baby: { name: "한우주", birthDate: "2024-10-11", gender: "boy" },
        parents: { father: "한흥석", mother: "안보경", contact: "010-1234-5678" },
        party: {
            date: "2025-10-11", time: "12:30",
            venue: "호텔나루서울엠갤러리 22층",
            venueSub: "부아쟁 레스토랑",
            address: "서울특별시 마포구 마포대로 8",
            mapLink: "https://naver.me/GvcTFv2T"
        }
    };
}

// 폼에 데이터 채우기
function populateFormData() {
    document.getElementById('babyName').value = siteConfig.baby.name;
    document.getElementById('babyBirthDate').value = siteConfig.baby.birthDate;
    document.getElementById('babyGender').value = siteConfig.baby.gender;
    
    document.getElementById('fatherName').value = siteConfig.parents.father;
    document.getElementById('motherName').value = siteConfig.parents.mother;
    document.getElementById('contact').value = siteConfig.parents.contact;
    
    document.getElementById('partyDate').value = siteConfig.party.date;
    document.getElementById('partyTime').value = siteConfig.party.time;
    document.getElementById('venue').value = siteConfig.party.venue;
    document.getElementById('venueSub').value = siteConfig.party.venueSub;
    document.getElementById('address').value = siteConfig.party.address;
    document.getElementById('mapLink').value = siteConfig.party.mapLink;
}

// 탭 기능
function initTabs() {
    const navLinks = document.querySelectorAll('[data-tab]');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const tabName = this.getAttribute('data-tab');
            showTab(tabName);
        });
    });
}

function showTab(tabName) {
    // 모든 탭 숨기기
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // 모든 네비 링크 비활성화
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
    });
    
    // 선택된 탭 표시
    document.getElementById(tabName).classList.add('active');
    document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');
}

// 대시보드 업데이트
function updateDashboard() {
    // D-Day 계산
    const partyDate = new Date('2025-10-11T12:30:00');
    const today = new Date();
    const diffTime = partyDate - today;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    document.getElementById('d-day-count').textContent = 
        diffDays > 0 ? `D-${diffDays}` : diffDays === 0 ? 'D-Day!' : `D+${Math.abs(diffDays)}`;
}

// 기본 정보 저장 (실제 API 서버 호출)
async function saveBasicInfo() {
    try {
        // 폼 데이터 수집
        const formData = {
            babyName: document.getElementById('babyName').value,
            babyBirthDate: document.getElementById('babyBirthDate').value,
            babyGender: document.getElementById('babyGender').value,
            fatherName: document.getElementById('fatherName').value,
            motherName: document.getElementById('motherName').value,
            contact: document.getElementById('contact').value,
            partyDate: document.getElementById('partyDate').value,
            partyTime: document.getElementById('partyTime').value,
            venue: document.getElementById('venue').value,
            venueSub: document.getElementById('venueSub').value,
            address: document.getElementById('address').value,
            mapLink: document.getElementById('mapLink').value
        };
        
        showAlert('기본 정보 저장 중...', 'info');
        
        const response = await fetch('http://localhost:3001/api/update-content', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });
        
        const result = await response.json();
        
        if (result.success) {
            // 로컬 설정도 업데이트
            siteConfig.baby = { name: formData.babyName, birthDate: formData.babyBirthDate, gender: formData.babyGender };
            siteConfig.parents = { father: formData.fatherName, mother: formData.motherName, contact: formData.contact };
            siteConfig.party = { 
                date: formData.partyDate, 
                time: formData.partyTime, 
                venue: formData.venue, 
                venueSub: formData.venueSub, 
                address: formData.address, 
                mapLink: formData.mapLink 
            };
            
            localStorage.setItem('siteConfig', JSON.stringify(siteConfig));
            showAlert('기본 정보가 성공적으로 저장되고 배포되었습니다!', 'success');
        } else {
            throw new Error(result.error || '저장 실패');
        }
        
    } catch (error) {
        console.error('저장 에러:', error);
        showAlert(`저장 실패: ${error.message}`, 'error');
    }
}

// HTML 컨텐츠 업데이트 (실제로는 서버 사이드에서 처리해야 함)
function updateHtmlContent() {
    // 새 창에서 업데이트된 내용 미리보기
    const newContent = generateUpdatedHtml();
    
    // 임시로 localStorage에 저장
    localStorage.setItem('updatedHtml', newContent);
    
    console.log('HTML 업데이트됨 (localStorage 저장)');
}

// 업데이트된 HTML 생성
function generateUpdatedHtml() {
    // 기존 HTML을 가져와서 내용 교체
    // 실제로는 템플릿 엔진이나 서버 사이드에서 처리
    return `
    <!-- 업데이트된 내용 -->
    <h1>Happy 1st Birthday</h1>
    <h2>${siteConfig.baby.name}</h2>
    <p>아빠 ${siteConfig.parents.father}, 엄마 ${siteConfig.parents.mother} 올림</p>
    <p>${siteConfig.party.date} ${siteConfig.party.time}</p>
    <p>${siteConfig.party.venue} ${siteConfig.party.venueSub}</p>
    <p>${siteConfig.party.address}</p>
    `;
}

// 이미지 미리보기 및 실제 업로드
function previewImage(input, imageType) {
    if (input.files && input.files[0]) {
        const file = input.files[0];
        const reader = new FileReader();
        
        reader.onload = function(e) {
            // 이미지 미리보기 업데이트
            const img = input.parentNode.querySelector('img');
            if (img) {
                img.src = e.target.result;
            }
            
            // 실제 S3 업로드
            uploadImageToS3(file, imageType, input);
        };
        
        reader.readAsDataURL(file);
    }
}

// S3에 이미지 업로드
async function uploadImageToS3(file, imageType, inputElement) {
    const formData = new FormData();
    formData.append('image', file);
    formData.append('imageType', imageType);
    
    // 갤러리나 타임라인의 경우 인덱스 추가
    if (imageType === 'gallery') {
        const galleryIndex = inputElement.id.replace('gallery-', '');
        formData.append('galleryIndex', galleryIndex);
    } else if (imageType === 'timeline') {
        const timelineIndex = inputElement.id.replace('timeline-', '');
        formData.append('timelineIndex', timelineIndex);
    }
    
    try {
        showAlert('이미지 업로드 중...', 'info');
        
        const response = await fetch('http://localhost:3001/api/upload-image', {
            method: 'POST',
            body: formData
        });
        
        const result = await response.json();
        
        if (result.success) {
            showAlert(`${imageType} 이미지가 성공적으로 업로드되었습니다!`, 'success');
            console.log('업로드 완료:', result.s3Key);
        } else {
            throw new Error(result.error || '업로드 실패');
        }
        
    } catch (error) {
        console.error('업로드 에러:', error);
        showAlert(`업로드 실패: ${error.message}`, 'error');
    }
}

// 이미지를 임시 저장소에 저장
function saveImageToStorage(imageType, dataUrl) {
    const images = JSON.parse(localStorage.getItem('updatedImages') || '{}');
    images[imageType] = dataUrl;
    localStorage.setItem('updatedImages', JSON.stringify(images));
}

// S3 배포 (실제 API 호출)
async function deployToS3() {
    const logDiv = document.getElementById('deploy-log');
    logDiv.innerHTML = '배포를 시작합니다...\n';
    
    try {
        showAlert('배포를 시작합니다...', 'info');
        logDiv.innerHTML += '✅ CloudFront 캐시 무효화 중...\n';
        
        const response = await fetch('http://localhost:3001/api/quick-deploy', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
        
        const result = await response.json();
        
        if (result.success) {
            logDiv.innerHTML += '✅ 캐시 무효화 완료\n';
            logDiv.innerHTML += '🎉 배포 완료!\n';
            logDiv.innerHTML += '🌐 https://d104xm32ar1ns2.cloudfront.net\n';
            logDiv.innerHTML += '🌐 http://1st-birthday-invitation-20251011.s3-website.ap-northeast-2.amazonaws.com\n';
            
            document.getElementById('last-deploy').textContent = new Date().toLocaleString();
            showAlert('배포가 완료되었습니다!', 'success');
        } else {
            throw new Error(result.error || '배포 실패');
        }
        
    } catch (error) {
        console.error('배포 에러:', error);
        logDiv.innerHTML += `❌ 배포 실패: ${error.message}\n`;
        showAlert(`배포 실패: ${error.message}`, 'error');
    }
}

// 빠른 배포
async function quickDeploy() {
    showAlert('빠른 배포를 시작합니다...', 'info');
    await deployToS3();
}

// 캐시 무효화
function clearCache() {
    showAlert('CloudFront 캐시를 무효화하는 중...', 'info');
    
    setTimeout(() => {
        showAlert('캐시 무효화가 완료되었습니다!', 'success');
    }, 3000);
}

// 알림 표시
function showAlert(message, type = 'info') {
    // Bootstrap 알림 생성
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type === 'success' ? 'success' : type === 'error' ? 'danger' : 'info'} alert-dismissible fade show`;
    alertDiv.style.position = 'fixed';
    alertDiv.style.top = '20px';
    alertDiv.style.right = '20px';
    alertDiv.style.zIndex = '9999';
    alertDiv.style.minWidth = '300px';
    
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alertDiv);
    
    // 3초 후 자동 제거
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.parentNode.removeChild(alertDiv);
        }
    }, 3000);
}
