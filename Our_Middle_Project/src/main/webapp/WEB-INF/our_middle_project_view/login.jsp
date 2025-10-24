<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>

	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>
	
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/login/login.css">
	
</head>
<body>
	
	<div class="c-login-container">
	
	<div class="c-login-box">
		<h2>로그인</h2>
		<input type="text" placeholder="아이디" >
		<input type="password" placeholder="비밀번호">
		<div class="div-links">
			<div class="find-id">아이디 찾기</div>
			<div class="find-pw">비밀번호 찾기</div>
			<div>회원가입</div>
		</div>
		<button>로그인</button>
	</div>
	
	<div class="bottom-text">Press the spacebar</div></div>
	   
	<div id="idModal" class="modal">
		<div class="modal-content">
			<h3>아이디 찾기</h3>
			<input type="text" placeholder="이메일">
			<button>아이디 찾기</button>
			<div class="close-btn" onclick="closeModal('idModal')">닫기</div>
		</div>
	</div>
	
	<div id="pwModal" class="modal">
		<div class="modal-content">
			<h3>비밀번호 찾기</h3>
			<input type="text" placeholder="아이디">
			<input type="text" placeholder="이메일">
			<button>비밀번호 재설정</button>
			<div class="close-btn" onclick="closeModal('pwModal')">닫기</div>
		</div>
	</div> 
	 
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/login/login.js"></script>
  
</body>
</html>