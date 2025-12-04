/**
 * 식단 관리 JavaScript
 * 식단 조회, 추가, 수정, 삭제 기능
 */

// 전역 변수
let currentMealId = null;
let currentMealType = null;

/**
 * 식단 목록 로드
 */
function loadMeals() {
    const selectedDate = document.getElementById('selectedDate').value;
    
    if (!currentRecId || !selectedDate) {
        console.error('필수 파라미터 누락:', { currentRecId, selectedDate });
        return;
    }

    // API 호출
    fetch(`/mealplan/api/date?recId=${currentRecId}&mealDate=${selectedDate}`)
        .then(response => response.json())
        .then(meals => {
            console.log('식단 조회 성공:', meals);
            displayMeals(meals);
            updateTodayStats(meals);
        })
        .catch(error => {
            console.error('식단 조회 실패:', error);
            showError('식단을 불러오는데 실패했습니다.');
        });
}

/**
 * 식단 목록 표시
 */
function displayMeals(meals) {
    // 초기화
    const breakfastContainer = document.getElementById('breakfast-meals');
    const lunchContainer = document.getElementById('lunch-meals');
    const dinnerContainer = document.getElementById('dinner-meals');

    breakfastContainer.innerHTML = getEmptyMessage();
    lunchContainer.innerHTML = getEmptyMessage();
    dinnerContainer.innerHTML = getEmptyMessage();

    // 식사 구분별로 분류
    const mealsByType = {
        '아침': [],
        '점심': [],
        '저녁': []
    };

    meals.forEach(meal => {
        if (mealsByType[meal.mealType]) {
            mealsByType[meal.mealType].push(meal);
        }
    });

    // 각 식사 구분별로 표시
    if (mealsByType['아침'].length > 0) {
        breakfastContainer.innerHTML = mealsByType['아침'].map(meal => createMealItemHTML(meal)).join('');
    }
    if (mealsByType['점심'].length > 0) {
        lunchContainer.innerHTML = mealsByType['점심'].map(meal => createMealItemHTML(meal)).join('');
    }
    if (mealsByType['저녁'].length > 0) {
        dinnerContainer.innerHTML = mealsByType['저녁'].map(meal => createMealItemHTML(meal)).join('');
    }
}

/**
 * 빈 메시지 HTML
 */
function getEmptyMessage() {
    return `
        <div class="empty-meal-message">
            <i class="fas fa-utensils"></i>
            <p>등록된 식단이 없습니다</p>
        </div>
    `;
}

/**
 * 식단 아이템 HTML 생성
 */
function createMealItemHTML(meal) {
    const calories = meal.mealCalories ? `<i class="fas fa-fire"></i> ${meal.mealCalories} kcal` : '칼로리 미입력';
    
    return `
        <div class="meal-item" onclick="showMealDetail(${meal.mealId})" style="cursor: pointer;">
            <div class="meal-item-menu">${meal.mealMenu}</div>
            <div class="meal-item-footer">
                <div class="meal-item-calories">${calories}</div>
                <div class="meal-item-actions" onclick="event.stopPropagation();">
                    <button class="meal-action-btn edit" onclick="editMeal(${meal.mealId})">
                        <i class="fas fa-edit"></i> 수정
                    </button>
                    <button class="meal-action-btn delete" onclick="deleteMeal(${meal.mealId})">
                        <i class="fas fa-trash"></i> 삭제
                    </button>
                </div>
            </div>
        </div>
    `;
}

/**
 * 오늘 통계 업데이트
 */
function updateTodayStats(meals) {
    // 식단 개수
    document.getElementById('todayMealCount').textContent = meals.length;
    
    // 총 칼로리 계산
    const totalCalories = meals.reduce((sum, meal) => sum + (meal.mealCalories || 0), 0);
    document.getElementById('todayTotalCalories').textContent = totalCalories;
}

/**
 * 통계 정보 로드
 */
function loadStatistics() {
    if (!currentRecId) return;

    const today = new Date().toISOString().split('T')[0];
    
    // 오늘 총 칼로리
    fetch(`/mealplan/api/calories?recId=${currentRecId}&mealDate=${today}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('todayTotalCalories').textContent = data.totalCalories;
        })
        .catch(error => console.error('칼로리 조회 실패:', error));

    // 이번 주 데이터 (간단 버전)
    const startOfWeek = new Date();
    startOfWeek.setDate(startOfWeek.getDate() - startOfWeek.getDay());
    const startDate = startOfWeek.toISOString().split('T')[0];
    const endDate = today;

    fetch(`/mealplan/api/range?recId=${currentRecId}&startDate=${startDate}&endDate=${endDate}`)
        .then(response => response.json())
        .then(meals => {
            // 주간 평균 칼로리
            const totalCal = meals.reduce((sum, meal) => sum + (meal.mealCalories || 0), 0);
            const avgCal = meals.length > 0 ? Math.round(totalCal / 7) : 0;
            document.getElementById('weekAvgCalories').textContent = avgCal;
        })
        .catch(error => console.error('주간 통계 조회 실패:', error));
}

/**
 * 모달 열기 (추가)
 */
function openAddModal(mealType = '') {
    currentMealId = null;
    currentMealType = mealType;
    
    // 모달 제목 변경
    document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> 식단 추가';
    
    // 폼 초기화
    document.getElementById('mealForm').reset();
    document.getElementById('mealId').value = '';
    document.getElementById('recId').value = currentRecId;
    
    // 현재 선택된 날짜 설정
    const selectedDate = document.getElementById('selectedDate').value;
    document.getElementById('mealDate').value = selectedDate;
    
    // 식사 구분 자동 선택
    if (mealType) {
        document.getElementById('mealType').value = mealType;
    }
    
    // 모달 표시
    document.getElementById('mealModal').classList.add('show');
}

/**
 * 식단 수정
 */
function editMeal(mealId) {
    currentMealId = mealId;
    
    // 식단 정보 조회
    fetch(`/mealplan/api/meal/${mealId}`)
        .then(response => response.json())
        .then(meal => {
            // 모달 제목 변경
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> 식단 수정';
            
            // 폼에 데이터 채우기
            document.getElementById('mealId').value = meal.mealId;
            document.getElementById('recId').value = meal.recId;
            document.getElementById('mealDate').value = meal.mealDate;
            document.getElementById('mealType').value = meal.mealType;
            document.getElementById('mealMenu').value = meal.mealMenu;
            document.getElementById('mealRecipe').value = meal.mealRecipe || '';
            document.getElementById('mealCalories').value = meal.mealCalories || '';
            
            // 모달 표시
            document.getElementById('mealModal').classList.add('show');
        })
        .catch(error => {
            console.error('식단 조회 실패:', error);
            showError('식단 정보를 불러오는데 실패했습니다.');
        });
}

/**
 * 식단 저장 (추가/수정)
 */
function saveMeal() {
    // 폼 데이터 수집
    const mealId = document.getElementById('mealId').value;
    const recId = document.getElementById('recId').value;
    const mealDate = document.getElementById('mealDate').value;
    const mealType = document.getElementById('mealType').value;
    const mealMenu = document.getElementById('mealMenu').value;
    const mealRecipe = document.getElementById('mealRecipe').value;
    const mealCalories = document.getElementById('mealCalories').value;

    // 유효성 검사
    if (!mealDate || !mealType || !mealMenu) {
        showError('필수 항목을 모두 입력해주세요.');
        return;
    }

    // 데이터 구성
    const mealData = {
        recId: parseInt(recId),
        mealDate: mealDate,
        mealType: mealType,
        mealMenu: mealMenu.trim(),
        mealRecipe: mealRecipe ? mealRecipe.trim() : null,
        mealCalories: mealCalories ? parseInt(mealCalories) : null
    };

    // 수정인 경우 mealId 추가
    if (mealId) {
        mealData.mealId = parseInt(mealId);
    }

    // API 호출
    const url = '/mealplan/api/meal';
    const method = mealId ? 'PUT' : 'POST';

    fetch(url, {
        method: method,
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(mealData)
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            showSuccess(result.message || '식단이 저장되었습니다.');
            closeModal();
            loadMeals();
            loadStatistics();
        } else {
            showError(result.message || '식단 저장에 실패했습니다.');
        }
    })
    .catch(error => {
        console.error('식단 저장 실패:', error);
        showError('식단 저장 중 오류가 발생했습니다.');
    });
}

/**
 * 식단 삭제
 */
function deleteMeal(mealId) {
    if (!confirm('이 식단을 삭제하시겠습니까?')) {
        return;
    }

    fetch(`/mealplan/api/meal/${mealId}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            showSuccess(result.message || '식단이 삭제되었습니다.');
            loadMeals();
            loadStatistics();
        } else {
            showError(result.message || '식단 삭제에 실패했습니다.');
        }
    })
    .catch(error => {
        console.error('식단 삭제 실패:', error);
        showError('식단 삭제 중 오류가 발생했습니다.');
    });
}

/**
 * 모달 닫기
 */
function closeModal() {
    document.getElementById('mealModal').classList.remove('show');
    currentMealId = null;
    currentMealType = null;
}

/**
 * 성공 메시지 표시
 */
function showSuccess(message) {
    alert(message);
}

/**
 * 에러 메시지 표시
 */
function showError(message) {
    alert(message);
}

/**
 * 모달 외부 클릭 시 닫기
 */
document.addEventListener('DOMContentLoaded', function() {
    const mealModal = document.getElementById('mealModal');
    if (mealModal) {
        mealModal.addEventListener('click', function(e) {
            if (e.target === mealModal) {
                closeModal();
            }
        });
    }

    const aiRecommendationModal = document.getElementById('aiRecommendationModal');
    if (aiRecommendationModal) {
        aiRecommendationModal.addEventListener('click', function(e) {
            if (e.target === aiRecommendationModal) {
                closeAiRecommendationModal();
            }
        });
    }

    const mealDetailModal = document.getElementById('mealDetailModal');
    if (mealDetailModal) {
        mealDetailModal.addEventListener('click', function(e) {
            if (e.target === mealDetailModal) {
                closeMealDetailModal();
            }
        });
    }
});

/**
 * AI 식단 추천 모달 열기
 */
function openAiRecommendationModal() {
    document.getElementById('aiSpecialNotes').value = ''; // 입력 필드 초기화
    document.getElementById('aiRecommendationResult').style.display = 'none'; // 결과 숨기기
    document.getElementById('aiRecommendationBasis').style.display = 'none'; // 추천 근거 숨기기
    document.getElementById('aiRecommendedMealDetails').innerHTML = ''; // 이전 결과 지우기
    document.getElementById('aiRecommendationModal').classList.add('show');
}

/**
 * AI 식단 추천 모달 닫기
 */
function closeAiRecommendationModal() {
    document.getElementById('aiRecommendationModal').classList.remove('show');
}

/**
 * AI 식단 추천 요청
 */
function getAiRecommendation() {
    const specialNotes = document.getElementById('aiSpecialNotes').value;
    const mealType = document.getElementById('aiMealType').value;
    const recId = currentRecId;

    if (!recId) {
        showError('돌봄 대상자를 선택해야 AI 식단 추천을 받을 수 있습니다.');
        return;
    }
    if (!mealType) {
        showError('식사 종류를 선택해주세요.');
        return;
    }

    const getAiRecommendationBtn = document.getElementById('getAiRecommendationBtn');
    getAiRecommendationBtn.disabled = true;
    getAiRecommendationBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 추천받는 중...';

    document.getElementById('aiRecommendationResult').style.display = 'none';
    document.getElementById('aiRecommendationBasis').style.display = 'none';

    fetch('/mealplan/api/recommend', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ recId: recId, specialNotes: specialNotes, mealType: mealType })
    })
    .then(response => response.json())
    .then(res => {
        if (res.success) {
            const recommendation = res.data.recommendation;
            const basis = res.data.basis;

            if (recommendation.error) {
                showError('AI 추천 실패: ' + recommendation.error);
                return;
            }

            const basisDiv = document.getElementById('aiRecommendationBasis');
            basisDiv.innerHTML = `<i class="fas fa-info-circle"></i> ${basis}`;
            basisDiv.style.display = 'block';

            const resultDiv = document.getElementById('aiRecommendedMealDetails');
            
            // 상세 레시피 HTML 생성
            let recipeHtml = `<h5><i class="fas fa-utensils"></i> ${escapeHtml(recommendation.foodName)}</h5>`;
            
            if (recommendation.ingredients && recommendation.ingredients.length > 0) {
                recipeHtml += '<h6>필요한 재료</h6><ul class="list-unstyled">';
                recommendation.ingredients.forEach(ing => {
                    recipeHtml += `<li>- ${escapeHtml(ing.name)} ${ing.amount ? `(${escapeHtml(ing.amount)})` : ''} ${ing.calories ? `[${ing.calories}kcal]` : ''}</li>`;
                });
                recipeHtml += '</ul>';
            }

            if (recommendation.steps && recommendation.steps.length > 0) {
                recipeHtml += '<h6 class="mt-3">조리 순서</h6><ol>';
                recommendation.steps.forEach(step => {
                    recipeHtml += `<li>${escapeHtml(step.description)}</li>`;
                });
                recipeHtml += '</ol>';
            }

            if (recommendation.tips && recommendation.tips.length > 0) {
                recipeHtml += '<h6 class="mt-3">조리 팁</h6><ul class="list-unstyled">';
                recommendation.tips.forEach(tip => {
                    recipeHtml += `<li>💡 ${escapeHtml(tip)}</li>`;
                });
                recipeHtml += '</ul>';
            }

            resultDiv.innerHTML = recipeHtml;
            
            // 데이터셋에 전체 레시피 정보 저장
            resultDiv.dataset.recipe = JSON.stringify(recommendation);
            
            document.getElementById('aiRecommendationResult').style.display = 'block';
            showSuccess('AI 식단 추천을 받았습니다!');
        } else {
            showError(res.message || 'AI 식단 추천에 실패했습니다.');
        }
    })
    .catch(error => {
        console.error('AI 식단 추천 실패:', error);
        showError('AI 식단 추천 중 오류가 발생했습니다.');
    })
    .finally(() => {
        getAiRecommendationBtn.disabled = false;
        getAiRecommendationBtn.innerHTML = '<i class="fas fa-robot"></i> 추천받기';
    });
}

/**
 * AI 추천 식단을 식단 등록 폼에 적용
 */
function applyAiRecommendation() {
    const resultDiv = document.getElementById('aiRecommendedMealDetails');
    if (!resultDiv.dataset.recipe) {
        showError('적용할 레시피 정보가 없습니다.');
        return;
    }

    const recipeData = JSON.parse(resultDiv.dataset.recipe);
    const mealType = document.getElementById('aiMealType').value;

    // 칼로리 자동 합산
    let totalCalories = 0;
    if (recipeData.totalCalories) {
        totalCalories = parseInt(recipeData.totalCalories) || 0;
    } else if (recipeData.ingredients && recipeData.ingredients.length > 0) {
        totalCalories = recipeData.ingredients.reduce((sum, ing) => sum + (parseInt(ing.calories) || 0), 0);
    }

    // 레시피 텍스트 생성
    let recipeText = '';
    if (recipeData.ingredients && recipeData.ingredients.length > 0) {
        recipeText += '필요한 재료:\n';
        recipeData.ingredients.forEach(ing => {
            recipeText += `- ${ing.name} ${ing.amount ? `(${ing.amount})` : ''}\n`;
        });
        recipeText += '\n';
    }
    if (recipeData.steps && recipeData.steps.length > 0) {
        recipeText += '조리 순서:\n';
        recipeData.steps.forEach(step => {
            recipeText += `${step.stepNumber}. ${step.description}\n`;
        });
        recipeText += '\n';
    }
    if (recipeData.tips && recipeData.tips.length > 0) {
        recipeText += '조리 팁:\n';
        recipeData.tips.forEach(tip => {
            recipeText += `- ${tip}\n`;
        });
    }

    // 식단 추가 모달 열고 데이터 채우기
    openAddModal(mealType);
    
    document.getElementById('mealMenu').value = recipeData.foodName || '';
    document.getElementById('mealCalories').value = totalCalories > 0 ? totalCalories : '';
    document.getElementById('mealRecipe').value = recipeText.trim();
    
    closeAiRecommendationModal();
    showSuccess('AI 추천 식단이 식단 추가 폼에 적용되었습니다.');
}

/**
 * 식단 상세 정보 모달 표시
 */
function showMealDetail(mealId) {
    // 식단 정보 조회
    fetch(`/mealplan/api/meal/${mealId}`)
        .then(response => response.json())
        .then(meal => {
            // 모달 내용 채우기
            document.getElementById('detailMealMenu').textContent = meal.mealMenu || '메뉴 없음';
            document.getElementById('detailMealType').textContent = meal.mealType || '';
            document.getElementById('detailMealDate').textContent = meal.mealDate || '';
            document.getElementById('detailMealCalories').textContent = meal.mealCalories ? `${meal.mealCalories} kcal` : '칼로리 미입력';
            
            // 레시피 표시
            const recipeContent = document.getElementById('detailMealRecipe');
            if (meal.mealRecipe && meal.mealRecipe.trim() !== '') {
                recipeContent.innerHTML = `<pre style="white-space: pre-wrap; font-family: inherit; margin: 0; padding: 15px; background: #f8f9fa; border-radius: 8px; line-height: 1.6;">${escapeHtml(meal.mealRecipe)}</pre>`;
            } else {
                recipeContent.innerHTML = '<p style="color: #999; font-style: italic; text-align: center; padding: 20px;">등록된 레시피가 없습니다.</p>';
            }
            
            // 모달 표시
            document.getElementById('mealDetailModal').classList.add('show');
        })
        .catch(error => {
            console.error('식단 조회 실패:', error);
            showError('식단 정보를 불러오는데 실패했습니다.');
        });
}

/**
 * 식단 상세 모달 닫기
 */
function closeMealDetailModal() {
    document.getElementById('mealDetailModal').classList.remove('show');
}

/**
 * HTML 이스케이프 함수
 */
function escapeHtml(text) {
    if (text == null) return '';
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
}
