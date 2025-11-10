<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>랭킹</title>

   <!-- 부트스트랩 -->
   <link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>
   
   <!-- 스위트어럴트2 -->
   <link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>
   
   <!-- jquery -->
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>
   
   <!-- axios -->
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>

   <script src="https://unpkg.com/lucide@latest"></script><!-- 홈 이모티콘 -->
   <link rel="stylesheet"href="./css/ranking/ranking_layout.css">
   
   <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="./css/fonts.css">
   
<!-- ===================================================================================== -->
</head>
<body>
   <div id="container">
   
   <div id="nickname">
      <span class="nick">
     	 <c:out value="${sessionScope.loginUser.nickname}#${sessionScope.loginUser.mem_id}님" />
      </span>
      <span class="hi">안녕하세요</span>
   </div>
   
      <div class="home-button-container">
             <button class="home-button" onclick="goHome()">
        <i data-lucide="home"></i>
          </button>
      </div>
   
      <div id="rankingMain">
      
         <!-- 왼쪽/오른쪽 화살표 -->
            <button id="prevSlide" class="slide-btn left">◀</button>
            <button id="nextSlide" class="slide-btn right">▶</button>
            
         
         <div id="topMain">
         
            <div id="topwidth500">
            
               <div id="topwidth100-easy">
                  <!-- 이지1등 -->
                  <div id="rankingTop1-1"  class="ranking-card">
                         <div class="ranking-column rank-1">
                            <span class="rank-text">1st • TOP 1</span>
                         </div>
                         <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">9800</div>
                  </div>
                  <!-- 이지2등 -->
                  <div id="rankingTop2-1" class="ranking-card">
                         <div class="ranking-column rank-2">
                            <span class="rank-text">2nd • TOP 2</span>
                         </div>
                         <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">8700</div>
                  </div>
                  <!-- 이지3등 -->
                  <div id="rankingTop3-1" class="ranking-card"> 
                         <div class="ranking-column rank-3">
                            <span class="rank-text">3rd • TOP 3</span>
                         </div>
                         <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">8200</div>
                  </div>
                  
               </div>
               
               <div id="topwidth100-normal">
                  <!-- 노멀1등 -->
                  <div id="rankingTop1-2"  class="ranking-card"> 
                         <div class="ranking-column rank-1">
                            <span class="rank-text">1st • TOP 1</span>
                         </div>
                        <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">9800</div>
                  </div>
                  <!-- 노멀2등 -->
                  <div id="rankingTop2-2" class="ranking-card">
                         <div class="ranking-column rank-2">
                            <span class="rank-text">2nd • TOP 2</span>
                         </div>
                        <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">8700</div>
                  </div>
                  <!-- 노멀3등 -->
                  <div id="rankingTop3-2" class="ranking-card"> 
                         <div class="ranking-column rank-3">
                            <span class="rank-text">3rd • TOP 3</span>
                         </div>
                         <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">8200</div>
                  </div>
                  
               </div>
               
               <div id="topwidth100-hard">
                  <!-- 하드1등 -->
                  <div id="rankingTop1-3"  class="ranking-card"> 
                         <div class="ranking-column rank-1">
                            <span class="rank-text">1st • TOP 1</span>
                         </div>
                         <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">9800</div>
                  </div>
                  <!-- 하드2등 -->
                  <div id="rankingTop2-3" class="ranking-card">
                         <div class="ranking-column rank-2">
                            <span class="rank-text">2nd • TOP 2</span>
                         </div>
                         <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">8700</div>
                  </div>
                  <!-- 하드3등 -->
                  <div id="rankingTop3-3" class="ranking-card"> 
                         <div class="ranking-column rank-3">
                            <span class="rank-text">3rd • TOP 3</span>
                         </div>
                         <div class="ranking-column nickname">
                             <span class="span1">닉네임</span>
                             <span class="span2">user1</span>
                         </div>
                         <div class="ranking-column userId">
                            <span class="span1">아이디</span>
                             <span class="span2">ID1234</span>
                         </div>
                         <div class="ranking-column combo">
                            <span class="span1">콤보</span>
                             <span class="span2">50</span>
                         </div>
                         <div class="ranking-column time">
                            <span class="span1">클리어타임</span>
                             <span class="span2">1분30초</span>
                         </div>
                         <div class="ranking-column score">8200</div>
                  </div>
                  
               </div>
               
               <div id="topwidth100-vs">
                  
                  <div id="rankingTop1-4"  class="ranking-card"> 
                         <div class="ranking-column rank-1">
                            <span class="rank-text">1st • TOP 1</span>
                         </div>
                         <div class="ranking-column nickname">-</div>
                         <div class="ranking-column userId">-</div>
                         <div class="ranking-column combo">-</div>
                         <div class="ranking-column time">-</div>
                         <div class="ranking-column score">-</div>
                  </div>
                  
                  <div id="rankingTop2-4" class="ranking-card">
                         <div class="ranking-column rank-2">
                            <span class="rank-text">2nd • TOP 2</span>
                         </div>
                         <div class="ranking-column nickname">-</div>
                         <div class="ranking-column userId">-</div>
                         <div class="ranking-column combo">-</div>
                         <div class="ranking-column time">-</div>
                         <div class="ranking-column score">-</div>
                  </div>
                  
                  <div id="rankingTop3-4" class="ranking-card"> 
                         <div class="ranking-column rank-3">
                            <span class="rank-text">3rd • TOP 3</span>
                         </div>
                         <div class="ranking-column nickname">-</div>
                         <div class="ranking-column userId">-</div>
                         <div class="ranking-column combo">-</div>
                         <div class="ranking-column time">-</div>
                         <div class="ranking-column score">-</div>
                  </div>
                  
               </div>
               
               <div id="topwidth100-total">
                  
                  <div id="rankingTop1-5"  class="ranking-card"> 
                         <div class="ranking-column rank-1">
                            <span class="rank-text">1st • TOP 1</span>
                         </div>
                         <div class="ranking-column nickname">-</div>
                         <div class="ranking-column userId">-</div>
                         <div class="ranking-column combo">-</div>
                         <div class="ranking-column time">-</div>
                         <div class="ranking-column score">-</div>
                  </div>
                  
                  <div id="rankingTop2-5" class="ranking-card">
                         <div class="ranking-column rank-2">
                            <span class="rank-text">2nd • TOP 2</span>
                         </div>
                         <div class="ranking-column nickname">-</div>
                         <div class="ranking-column userId">-</div>
                         <div class="ranking-column combo">-</div>
                         <div class="ranking-column time">-</div>
                         <div class="ranking-column score">-</div>
                  </div>
                  
                  <div id="rankingTop3-5" class="ranking-card"> 
                         <div class="ranking-column rank-3">
                            <span class="rank-text">3rd • TOP 3</span>
                         </div>
                         <div class="ranking-column nickname">-</div>
                         <div class="ranking-column userId">-</div>
                         <div class="ranking-column combo">-</div>
                         <div class="ranking-column time">-</div>
                         <div class="ranking-column score">-</div>
                  </div>
                  
               </div>
               
            </div>
            
         </div>
   
         <div id="centerMain">
            
            <div id="centerWidth500">
            
               <div id="rankingList-1">ezsy
               
                   <div class="ranking-item ranking-header">
                       <div class="ranking-column-main-1">순위</div>
                       <div class="ranking-column-main-2">닉네임</div>
                       <div class="ranking-column-main-3">아이디</div>
                       <div class="ranking-column-main-4">콤보</div>
                       <div class="ranking-column-main-5">클리어시간</div>
                       <div class="ranking-column-main-6">최대점수</div>
                    </div>
                    
               </div>
               
               <div id="rankingList-2">normal
               
                  <div class="ranking-item ranking-header">
                       <div class="ranking-column-main-1">순위</div>
                       <div class="ranking-column-main-2">닉네임</div>
                       <div class="ranking-column-main-3">아이디</div>
                       <div class="ranking-column-main-4">콤보</div>
                       <div class="ranking-column-main-5">클리어시간</div>
                       <div class="ranking-column-main-6">최대점수</div>
                    </div>
                    
               </div>
               
               <div id="rankingList-3">hard
               
                  <div class="ranking-item ranking-header">
                       <div class="ranking-column-main-1">순위</div>
                       <div class="ranking-column-main-2">닉네임</div>
                       <div class="ranking-column-main-3">아이디</div>
                       <div class="ranking-column-main-4">콤보</div>
                       <div class="ranking-column-main-5">클리어시간</div>
                       <div class="ranking-column-main-6">최대점수</div>
                    </div>
                    
               </div>
               
               
               <div id="rankingList-4" class="coming-soon"></div>
               <div id="rankingList-5" class="coming-soon"></div>
               
            </div>
               
         </div>
         
         <div id="bottomMain">
            
            <div id="navArea-1">
               <button id="btnEasy">easy</button>
            </div>
            <div id="navArea-2">
               <button id="btnNormal">normal</button>
            </div>
            <div id="navArea-3">
               <button id="btnHard">hard</button>
            </div>
            <div id="navArea-4">
               <button id="btnVs">vs</button>
            </div>
            <div id="navArea-5">
               <button id="btnTotal">total</button>
            </div>
         
         </div>
         
      </div>
   </div>   
   
<!-- ==================================================================================== -->
	<%@ page import="com.google.gson.Gson"%>
	<%@ page import="com.our_middle_project.dto.UserInfoDTO"%>

	<%
		Gson gson = new Gson();
		UserInfoDTO user = (UserInfoDTO) session.getAttribute("loginUser");
		String userJson = gson.toJson(user);
	%>

	<script type="text/javascript">
		const userDataCase = JSON.parse('<%=userJson%>');
		const easyRanking = <%=session.getAttribute("easyList")%>;
		const normalRanking = <%=session.getAttribute("normalList")%>;
		const hardRanking = <%=session.getAttribute("hardList")%>;
		
		
		console.log(userDataCase);
		console.log(easyRanking);
		console.log(normalRanking);
		console.log(hardRanking);
	</script>

	<script type="text/javascript" src="./js/common.js"></script>
	<script type="text/javascript" src="./js/ranking/ranking_Layout.js"></script>
</body>
</html>