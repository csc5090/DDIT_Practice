<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>랭킹</title>

<!-- 부트스트랩 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
<script src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>

<!-- 스위트어럴트2 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
<script src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

<!-- jquery -->
<script src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>

<!-- axios -->
<script src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>

<script src="https://unpkg.com/lucide@latest"></script> <!-- 홈 아이콘 -->
<link rel="stylesheet" href="./css/ranking/ranking_layout.css">
<link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
<link rel="stylesheet" href="./css/fonts.css">
</head>
<body>
<div id="container">

    <!-- 로그인 닉네임 표시 -->
    <div id="nickname">
        <span class="nick"><c:out value="${sessionScope.loginUser.mem_id}" /></span>
        <span class="hi">님 안녕하세요</span>
    </div>

    <!-- 홈 버튼 -->
    <div class="home-button-container">
        <button class="home-button" onclick="goHome()">
            <i data-lucide="home"></i>
        </button>
    </div>

    <!-- 랭킹 메인 -->
    <div id="rankingMain">
        <!-- 화살표 -->
        <button id="prevSlide" class="slide-btn left">◀</button>
        <button id="nextSlide" class="slide-btn right">▶</button>

        <!-- TOP 카드 영역 -->
        <div id="topMain">
            <div id="topwidth500">
                <div id="rankingCardsContainer"></div>
            </div>
        </div>

        <!-- 리스트 영역 -->
        <div id="centerMain">
            <div id="centerWidth500">
                <div id="rankingListContainer"></div>
            </div>
        </div>

        <!-- 하단 버튼 -->
        <div id="bottomMain">
            <div id="navArea-1"><button data-level="eazy">eazy</button></div>
            <div id="navArea-2"><button data-level="normal">normal</button></div>
            <div id="navArea-3"><button data-level="hard">hard</button></div>
            <div id="navArea-4"><button data-level="vs">vs</button></div>
            <div id="navArea-5"><button data-level="total">total</button></div>
        </div>
    </div>
</div>

<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.our_middle_project.dto.UserInfoDTO" %>
<%
    Gson gson = new Gson();
    UserInfoDTO user = (UserInfoDTO) session.getAttribute("loginUser");
    String userJson = gson.toJson(user);
%>

<script type="text/javascript">
    const userDataCase = JSON.parse('<%= userJson %>');
    console.log(userDataCase);

    // 서버에서 랭킹 데이터 가져오기
    axios.get('<%=request.getContextPath()%>/api/ranking')
        .then(res => {
            const rankings = res.data;
            const cardContainer = document.getElementById('rankingCardsContainer');
            const listContainer = document.getElementById('rankingListContainer');

            const levels = ['eazy','normal','hard','vs','total'];

            levels.forEach((level, levelIdx) => {
                const top3 = rankings[level]?.slice(0,3) || [];
                const cardWrapper = document.createElement('div');
                cardWrapper.classList.add('top-level-wrapper');

                // top3 카드 생성
                top3.forEach((user, idx) => {
                    const card = document.createElement('div');
                    card.classList.add('ranking-card');
                    card.innerHTML = `
                        <div class="ranking-column rank-${idx+1}">${idx+1} • TOP ${idx+1}</div>
                        <div class="ranking-column nickname">${user.nickname}</div>
                        <div class="ranking-column userId">${user.mem_id}</div>
                        <div class="ranking-column combo">${user.combo}</div>
                        <div class="ranking-column time">${user.clear_time}</div>
                        <div class="ranking-column score">${user.score}</div>
                    `;
                    cardWrapper.appendChild(card);
                });
                cardContainer.appendChild(cardWrapper);

                // 전체 리스트 생성
                const listWrapper = document.createElement('div');
                listWrapper.id = `rankingList-${levelIdx+1}`;
                const header = document.createElement('div');
                header.classList.add('ranking-item','ranking-header');
                header.innerHTML = `
                    <div class="ranking-column-main-1">순위</div>
                    <div class="ranking-column-main-2">닉네임</div>
                    <div class="ranking-column-main-3">아이디</div>
                    <div class="ranking-column-main-4">콤보</div>
                    <div class="ranking-column-main-5">클리어시간</div>
                    <div class="ranking-column-main-6">최대점수</div>
                `;
                listWrapper.appendChild(header);

                const levelList = rankings[level] || [];
                levelList.forEach((user, idx) => {
                    const item = document.createElement('div');
                    item.classList.add('ranking-item');
                    item.innerHTML = `
                        <div class="ranking-column-main-1">${idx+1}</div>
                        <div class="ranking-column-main-2">${user.nickname}</div>
                        <div class="ranking-column-main-3">${user.mem_id}</div>
                        <div class="ranking-column-main-4">${user.combo}</div>
                        <div class="ranking-column-main-5">${user.clear_time}</div>
                        <div class="ranking-column-main-6">${user.score}</div>
                    `;
                    listWrapper.appendChild(item);
                });

                listContainer.appendChild(listWrapper);
            });
        })
        .catch(err => console.error(err));
</script>

<script src="./js/common.js"></script>
<script src="./js/ranking/ranking_Layout.js"></script>
</body>
</html>
