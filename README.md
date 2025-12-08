# AI 돌봄 시스템

![AI 돌봄 시스템 메인 화면](https://github.com/user-attachments/assets/04073ef8-756f-456b-bc3f-e5f0c354cb16)


돌봄 대상자(**노인, 임산부, 장애인 등**)를 위한 **맞춤형 케어 서비스**를 제공하는 사용자용 웹 애플리케이션입니다. AI와 실시간 기술을 활용하여 사용자에게 직관적이고 유용한 기능을 제공합니다.

---

## 👥 팀원

| 이름 (포지션) | 담당 업무 | 이메일 |
| :---: | :---: | :---: |
| 구민우 |시스템 설계/ 통합, DB설계, 프로젝트 총괄 |rnalsdn100@naver.com|
| 김우성 |프론트엔드, 백엔드 개발, Admin 모듈 총괄|rladntjd011@naver.com|
| 정승혁 |프론트엔드, 백엔드 개발, cctv개발|5397jsh@gmail.com|
| 신창영 |프론트엔드, 백엔드 개발, AI개발, 프론트 총괄|toyoaki900@gmail.com|

---

## 📝 프로젝트 문서 (Notion)

**더 자세한 문서와 진행 상황은 아래 Notion 링크에서 확인하실 수 있습니다.**

[AI 돌봄 시스템 Notion 문서](https://www.notion.so/261ba18e862980dfb9a9e85f5abd380f)

---

## 🏗️ 시스템 아키텍처

![시스템 아키텍처 다이어그램](https://github.com/user-attachments/assets/554e8c42-2a0e-4124-9623-fddb9cb9fae2)

---

## 🗃️ ERD (Entity-Relationship Diagram)

![ERD 다이어그램](https://github.com/user-attachments/assets/8c39130d-e997-4130-bc01-c44184e536d2)

---

## 🛠️ Tech Stack

### 프론트엔드 (Frontend)

| 기술 | 버전/라이브러리 | 설명 |
| :--- | :--- | :--- |
| **HTML5** | - | 웹 페이지의 의미론적 구조를 정의. |
| **CSS3** | - | 모던 디자인 및 **반응형 레이아웃** 구현 (Flexbox, CSS 변수, 미디어 쿼리 등 사용). |
| **JavaScript** | ES6+ | 스크롤 효과, 모바일 메뉴 등 **동적인 사용자 인터페이스**와 상호작용 구현. |
| **Bootstrap** | 5.3.2 | **반응형 그리드 시스템** 및 표준 UI 컴포넌트(버튼, 폼 등)를 위한 CSS 프레임워크. |
| **Font Awesome** | 6.4.0 | 서비스 아이콘 등 다양한 시각적 아이콘 표현. |
| **AOS** | 2.3.4 | 스크롤 시 콘텐츠가 부드럽게 나타나는 **애니메이션 효과** 구현. |

### 백엔드 (Backend)

| 기술 | 설명 |
| :--- | :--- |
| **Java** | 서버 사이드 **비즈니스 로직**을 처리하는 핵심 프로그래밍 언어. |
| **JSP & JSTL** | Java 코드를 통해 **동적으로 HTML 페이지**를 생성하며, JSTL을 사용하여 코드의 가독성과 유지보수성 향상. |
| **Spring Framework** | 애플리케이션의 전체적인 구조를 담당하는 백엔드 프레임워크. **MVC 패턴**을 통해 뷰(JSP)와 비즈니스 로직을 연결. |

## 💡 주요 기능

### 1. AI 챗봇 (음성 비서)

* **자연어 질의응답:** 일정, 식단, 날씨 등 다양한 정보에 대한 **AI 답변** 제공.
* **음성 제어 (STT/TTS):** 음성으로 **질문**하고 **음성 답변** 청취 가능.
* **시스템 연동:** 챗봇 추천 **식단을 시스템에 바로 등록**하는 기능.

### 2. 스마트 지도 및 위치 서비스

* **내 지도:** 자주 가는 장소 (**병원, 공원** 등) **저장 및 관리**.
* **AI 장소 추천:** 요청 기반 최적의 장소 (**산책 코스** 등) **AI 추천**.
* **실시간 위치 추적:** WebSocket을 이용한 **대상자 현재 위치 실시간 표시**.
* **산책 코스:** 지도상의 장소를 연결하여 **목적별 코스 생성 및 관리**.

### 3. 메인 대시보드

* **핵심 정보 요약:** **건강 상태, 오늘의 식단, 시간표** 등 주요 정보 **한눈에 파악**.
* **미니 캘린더:** **월별 일정** 시각적 확인 및 마우스 오버 시 상세 내용 제공.
* **건강 데이터 시각화:** **심박수, 혈압** 등 최신 건강 데이터를 **프로그레스 바로 직관적 표시**.

### 4. 실시간 위험 감지 및 알림

* **CCTV 연동:** 백엔드 영상 분석을 통한 **낙상, 배회 등 이상 행동 감지**.
* **즉시 경보 알림:** 위험 발생 시 WebSocket으로 **경고 배너 즉시 표시** 및 신속 대응 지원.

### 5. 담당 요양사 정보

* **요양사 프로필:** 배정된 요양사의 **경력, 전문 분야, 자격증** 등 **상세 정보 조회**.
* **AI 매칭 안내:** 담당 요양사 부재 시 **AI가 최적 요양사 추천 및 배정** 예정 안내.

---

## 🎥 시연 영상

**준비중**
![AI 돌봄 시스템 메인 화면](https://github.com/user-attachments/assets/04073ef8-756f-456b-bc3f-e5f0c354cb16)

---

## 🖼️ 화면 구성

<details>
<summary><strong>🚪 접속 및 메인 (처음 접속, 메인, AI 챗봇)</strong></summary>
<br/>

### 처음 접속 화면
![처음 접속 화면](https://github.com/user-attachments/assets/5e6744c9-b59f-4985-80d5-41073034e62b)

### 메인 화면
![메인 화면](https://github.com/user-attachments/assets/04073ef8-756f-456b-bc3f-e5f0c354cb16)

### AI 챗봇
![AI 챗봇 화면](https://github.com/user-attachments/assets/01013f3d-e04d-4104-b5e9-c3238268bf11)


</details>

<details>
<summary><strong>🔐 로그인 / 회원가입</strong></summary>
<br/>

### 로그인
![로그인 화면](https://github.com/user-attachments/assets/b04c8adb-c466-408e-a9c7-02235b84a0bb)

### 회원가입
![회원가입 화면](https://github.com/user-attachments/assets/67b3fec0-cbef-4ab7-97ef-e24ac48da64a)

</details>

<details>
<summary><strong>🗓️ 일정 및 대상자 등록</strong></summary>
<br/>

### 일정 관리
![일정 관리 화면](https://github.com/user-attachments/assets/2be5abd3-559a-4a71-bb01-ec328165a014)

### 돌봄 대상자 등록 화면

#### 처음 고객이 로그인 후의 화면
![처음 고객 로그인 후 화면](https://github.com/user-attachments/assets/6fa180e2-9636-43e3-8709-2fead42fbba7)

#### 돌봄 대상자 등록
![돌봄 대상자 등록 화면](https://github.com/user-attachments/assets/b6096fe1-9576-408f-965a-f499677d0a28)

</details>

<details>
<summary><strong>📝 돌봄 대상자 상세 및 건강 정보</strong></summary>
<br/>

### 돌봄 대상자 상세 정보 전체 화면
![돌봄 대상자 상세 정보 전체 화면](https://github.com/user-attachments/assets/67e421f5-cda3-4a1c-a8da-bb2fb246feda)

### 돌봄 대상자 상세 정보
![테블릿용 돌봄 대상자 화면](https://github.com/user-attachments/assets/225c4aa0-3be8-4764-9c56-8206cbb8cb18)

### 테블릿 URL로 돌봄 대상자가 사용할 수 있는 화면
![테블릿용 돌봄 대상자 화면](https://github.com/user-attachments/assets/5fb52949-3b4c-4af3-825f-3dd5eb0422e9)
돌봄 대상자 상세정보에서 휴대폰이나 테블릿으로 URL혹은 QR코드로 돌봄대상자가 로그인 없이 쉽게 접속이 가능



### 돌봄 대상자 실시간 건강 정보
![돌봄 대상자 실시간 건강 정보 화면](https://github.com/user-attachments/assets/9d7647dc-542f-4764-a304-dcf2920e3cf8)

</details>

<details>
<summary><strong>📍 장소 및 식단 관리</strong></summary>
<br/>

### 장소
![장소 화면](https://github.com/user-attachments/assets/248be130-bff9-4102-9488-061ef635e3b2)

### 식단

#### AI 식단 관리
![AI 식단 관리 이미지](https://github.com/user-attachments/assets/387eace6-f7c5-45b9-ab02-9243d0be9f20)

#### AI 식단 안정검사
![AI 식단 안정검사 이미지](https://github.com/user-attachments/assets/28550501-3a43-484c-8efe-9321fd9ab935)

#### AI 식단 메뉴
![AI 식단 메뉴 이미지](https://github.com/user-attachments/assets/95d8b184-9504-4451-9942-3092142a0519)

#### 칼로리 분석
![칼로리 분석 이미지](https://github.com/user-attachments/assets/c58c0907-6f39-4be9-8e0b-d332ceaf7655)

</details>

<details>
<summary><strong>📹 CCTV, 요양사, 돌봄 영상</strong></summary>
<br/>

### CCTV
![CCTV 화면](https://github.com/user-attachments/assets/399750ea-246e-4d6d-837b-c6c497644f7f)

### 요양사
![요양사 화면](https://github.com/user-attachments/assets/f48d9eba-4ed3-4042-adb3-964847151cdf)

### 돌봄 영상
![돌봄 영상 화면](https://github.com/user-attachments/assets/39e83f43-3f61-471b-b3cc-d242ad146df8)

</details>

---

## 👑 Admin 화면

<details>
<summary><strong>🛠️ 관리자 대시보드 및 기능 보기</strong></summary>
<br/>

#### 메인 대시보드
![Admin 메인 대시보드 이미지](https://github.com/user-attachments/assets/0c59021e-2fdd-4691-aece-b517ee6f9ba0)

#### 알림 관리
![Admin 알림 관리 이미지](https://github.com/user-attachments/assets/1efeb586-ae15-45bf-8a31-81a9708b9223)

#### 요양사 AI 매칭
![Admin 요양사 AI 매칭 이미지](https://github.com/user-attachments/assets/ed19a6bb-0dc9-4476-be0c-537a24147466)

</details>
