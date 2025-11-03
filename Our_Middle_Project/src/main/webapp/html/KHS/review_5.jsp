<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 게시판5</title>

<!-- 부트스트랩 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>

<!-- 스위트어럴트2 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

<!-- jquery -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>

<!-- axios -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>
	
<style>

*{ box-sizing: border-box; }

html, body {
	margin: 0;
	padding: 0;
}

.review-container {
	width: 100%;
	height: 100vh;
}

.reviewModal {
	display: grid;
	place-items: center;
	width: 100%;
	height: 100%;
	overflow: hidden;
}

.reviewMain {
	border: 1px solid #ececec;
	border-radius: 15px;
	background-color: white;
	width: 35%; min-width: 650px;
	height: 94%;
	overflow: hidden;
	position: relative;
}

.reviewBody {
	display: grid;
	padding: 10px;
	gap: 10px;
	background-color: white;
	width: 100%;
	height: 96%;
	overflow-y: scroll;
}

.reviewBody::-webkit-scrollbar {
  width: 0;
  height: 0;
}

.reviewHeader {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 10px;
	border-bottom: 1px solid #ececec;
	width: 100%;
	height: 6%;
}

.header-left {
	font-weight: 700;
	font-size: 20px;
	width: 12%;
	height: 100%;
}

.header-right {
	width: 9%;
	height: 100%;
}

.modalCloseBtn {
	border: 1px solid #ececec;
	border-radius: 10px;
	width: 100%;
	height: 100%;
}

.reviewCard {
	display: grid;
	gap: 10px;
	padding: 10px;
	border: 1px solid #ececec;
	border-radius: 15px;
	width: 100%;
}

.cardHead {
	display: flex;
	align-items: center;
	gap: 10px;
	width: 100%;
	height: 100%;
}

/* 닉네임은 상황마다 길이가 다르기 때문에 설정하지 않음 */
.nickname {
	display: flex;
	align-items: center; 
	font-weight: 700;
	font-size: 15px;
	height: 100%
}

.starPoint {
	display: flex;
	align-items: center; 
	color: #f7b500;
	font-size: 17px;
	height: 100%;
	transform: translateY(-3px);
}

.date {
	display: flex;
	align-items: center; 
	margin-left: auto; /* 작성일만 우측 정렬 하기 위해서 */
	color: #656565;
	font-size: 12px;
	height: 100%;
}

.cardBody {
	margin-left: 13px;
	width: 98%;
}

.img-content {
	display: flex;
	width: 100%;
	height: 100%;
}

.img-div {
	width: 10%; min-width: 85px;
	height: 29%; min-height: 85px;
	border: 1px solid #ececec;
}

.reviewImg {
	object-fit: cover;  /* 비율유지 꽉채움 */
	display: block; 	/* 하단 여백 제거 */
	margin: 0;
	width: 100%;
	height: 100%;
}

.reviewContent {
	white-space: pre-wrap; /* 텍스트 자동 줄바꿈 */
	margin: 15px;
	width: 100%;
}

.cardFooter {
	display: flex;
	align-items: center; 
	border-left: 2px solid green;
	border-radius: 8px;
	margin-left: 13px;
	padding-left: 10px;
	font-size: 14px;
	width: 98%;
	height: 100%;
}

.reviewWrt {
	align-items: center;
	padding: 10px;
	width: 100%;
	height: 40%;
	overflow: hidden;
	position: absolute;
	left: 0px;
	bottom: 0px;
	background-color: transparent;
}

.wrtBtn-div {
	width: 100%;
	height: 15%;
	display: flex;
    justify-content: flex-end; /* 가로 방향 오른쪽 정렬 */
}

.wrtBtn-div-div {
	width: 10%;
	height: 80%;
}

.wrtBtn {
	width: 100%;
	height: 100%;
	border: 1px solid black;
}

.wrtBody {
	display: flex;
	gap: 10px;
 	width: 100%; 
	height: 85%;
	border: 1px solid black;
	background-color: white;
}

.wrtBody-left {
	padding: 10px;
	width: 40%;
	height: 100%;
}

.starsGroup {
	display: flex;
	gap: 10px;
	width: 100%;
	height: 14%;
	margin-bottom: 10px;
}

.starBtn {
	display: flex;
	background-color: white;
	border-radius: 10px;
	border: 1px solid #ececec;
	align-items: center;     /* 세로 중앙 */
	justify-content: center; /* 가로 중앙 */
	padding: 0;
	width: 13%;
	height: 100%;
}

.upload {
	display: flex;
	align-items: center;
	gap: 10px;
	font-size: 15px;
	width: 100%;
	height: 25%;
	margin-bottom: 10px;
}

.fileBtn {
	border: 1px solid #ececec;
	background: white;
	border-radius: 10px;
	cursor: pointer;
	width: 25%;
	height: 100%;
}

.fileBtn:hover {
	background: #f5f5f5;
}

.fileHint {
	font-size: 12px;
	color: #6b7280;
	width: 60%;
	height: 100%;
}

.fileCount {
	font-size: 12px;
	color: #10b981;
	width: 14%;
	height: 100%;
}

.preview {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 10px;
	border: 1px dashed #e2e8f0;
	border-radius: 12px;
	padding: 10px;
	background: #fafcff;
	width: 100%;
	height: 50%;
}

.emptyBox {
	width: 100%;
	height: 100%;
	border-radius: 12px;
	overflow: hidden;
	border: 1px solid #ececec;
	background: #fff;
	display: grid;
	place-items: center;
}

.wrtBody-light {
	gap: 10px;
	width: 59%;
	height: 100%;
}

.textReview {
	display: flex;
	justify-content: center;     /* 가로 중앙정렬 */
    align-items: center;         /* 세로 중앙정렬 */
	width: 100%;
	height: 77%;
}

.wrtReviewContent {
	resize: none;
	width: 95%;
	height: 90%;
	padding: 10px;
	border: 1px solid #ececec;
	border-radius: 12px;
}

.submitBtn-div {
	display: flex;
	justify-content: center;     /* 가로 중앙정렬 */
    align-items: center;         /* 세로 중앙정렬 */
	width: 100%;
	height: 18%;
}

.submitBtn {
	width: 96%;
	height: 80%;
	border: 1px solid #ececec;
	border-radius: 12px;
}

</style>
</head>

<body>
 
  <div class="review-container">
 
    <div id="iReviewModal" class="reviewModal" >

      <div class="reviewMain">
 
        <div class="reviewHeader">
          <div class="header-left">Review</div>
          <div class="header-right">
            <button id="iModalCloseBtn" class="modalCloseBtn" type="button">닫기</button>
          </div>
        </div>
		
		<div class="reviewBody">
		
		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다
	            리뷰를 작성해 봅니다 리뷰를 작성해 봅니다 리뷰를 작성해 봅니다 리뷰를 작성해 봅니다 리뷰를 작성해 봅니다 리뷰를 작성해 봅니다 
	            리뷰를 작성해 봅니다
	            리뷰를 작성해 봅니다
	            리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->

<!--  -->
		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" ></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
    	<div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div">
	            	<img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg">
            	</div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
	      		  <div class="reviewCard">
		    <!-- 작성자, 별점, 작성일 -->
		    <div class="cardHead">
			  <span class="nickname">네온고양이</span>
			  <span class="starPoint">별점5</span>
			  <span class="date">2025-10-30</span>
	        </div>
	      
	        <!-- 리뷰내용 -->
	        <div class="cardBody">
	          <div class="img-content">
	            <div class="img-div"><img class="reviewImg" src="<%=request.getContextPath()%>/images/omg.jpg"></div>
	            <div class="reviewContent">리뷰를 작성해 봅니다</div>
	          </div>
	        </div>
	       
	        <!-- 관리자 답글 -->
	        <div class="cardFooter">
	          <div class="reply">관리자 답변을 달아 봅니다</div>
	        </div>
	      </div> <!-- reviewCard -->
	      
		</div> <!-- reviewBody end -->
		
		<div class="reviewWrt">
		  <div class="wrtBtn-div">
		    <div class="wrtBtn-div-div">
		      <button id="iwrtBtn" class="wrtBtn" type="button">
		        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-chevron-up" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M7.646 4.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1-.708.708L8 5.707 1.354 11.354a.5.5 0 1 1-.708-.708l6-6z" />
                </svg>
		      </button>
		    </div>  
		  </div>
		  
		  <div class="wrtBody">
		    <div class="wrtBody-left">
		    <!-- 별점 입력 -->
		      <div class="starsGroup">
		        <button class="starBtn" type="button" role="radio" data-val="1"> <span>★</span> </button>
				<button class="starBtn" type="button" role="radio" data-val="2"> <span>★</span> </button>
		        <button class="starBtn" type="button" role="radio" data-val="3"> <span>★</span> </button>
		        <button class="starBtn" type="button" role="radio" data-val="4"> <span>★</span> </button>
		        <button class="starBtn" type="button" role="radio" data-val="5"> <span>★</span> </button>
		      </div>
		    
		    <!-- 파일 업로드 -->  
		      <div class="upload">
		        <button id="ifileBtn" class="fileBtn" type="button">파일<br>선택</button>
				<input id="imageInput" type="file" accept="image/*" multiple hidden>
				<div class="fileHint">최대 2장 · JPG/PNG/GIF</div>
				<div class="fileCount" id="ifileCount">0 / 2</div>
		      </div>
		   
		    <!-- 첨부파일 미리보기 -->  
		      <div id="iPreview" class="preview">
		        <div class="emptyBox" data-empty>이미지 없음</div>
		      </div>
		    </div> <!-- wrtBody-left END -->
		    
		    <div class="wrtBody-light">
		    
		    <!-- 리뷰 본문 작성 -->
		      <div class="textReview">
		        <textarea id="iWrtReviewContent" class="wrtReviewContent" maxlength="1000"
		        placeholder="리뷰를 작성해주세요 (최소 10자)&#10;게임/서비스의 장단점, 추천 여부 등을 자유롭게 적어주세요.">
		        </textarea>
		      </div>
		    
		    <!-- 등록 버튼 -->  
		      <div class="submitBtn-div">
		        <button id="sububmitBtn" class="submitBtn" type="button">등록</button>
		      </div>
		    </div> <!-- wrtBody-left END -->
		    
		  </div> <!-- wrtBody END -->
		  
		</div>
		
        </div>
    </div>
  </div>
  
<script>



</script>
</body>
</html>