<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>

	<!-- 폰트 -->
	<link rel="stylesheet" href="./css/fonts.css">

	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>
	
	<!-- 스위트어럴트2 -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

	<!-- 주소검색API(다음) -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/login/login.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/login/membership.css">
	
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
				<div class="member-join">회원가입</div>
			</div>
			<button>로그인</button>
		</div>
	
		<div class="bottom-text">Press The Space Bar</div>
		
		<!-- 조승희 내용수정 > 모달창(전부)을 c-login-container 의 자식요소로 변경 20251028 -->
		
		<div id="idModal" class="modal">
			<div class="modal-content">
				<h3>아이디 찾기</h3>
				<input type="text" placeholder="이메일">
				<button>아이디 찾기</button>
				<div class="close-btn">닫기</div>
			</div>
		</div>
		
		<div id="pwModal" class="modal">
			<div class="modal-content">
				<h3>비밀번호 찾기</h3>
				<input type="text" placeholder="아이디">
				<input type="text" placeholder="이메일">
				<button>비밀번호 재설정</button>
				<div class="close-btn">닫기</div>
			</div>
		</div>
		
		<div id="membershipModal" class="mem-modal-off">
			
			<div class="membership-container">
			
				<div id="mem-id-info">
				
					<div class="mem-info-block">
						<div class="mem-icon">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
							</svg>
						</div>
						<div class="mem-input">
							<input type="text" name="userId" placeholder="아이디">
						</div>
					</div>
					
					<div class="mem-info-block">
						<div class="mem-icon">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path fill-rule="evenodd" d="M8 0a4 4 0 0 1 4 4v2.05a2.5 2.5 0 0 1 2 2.45v5a2.5 2.5 0 0 1-2.5 2.5h-7A2.5 2.5 0 0 1 2 13.5v-5a2.5 2.5 0 0 1 2-2.45V4a4 4 0 0 1 4-4M4.5 7A1.5 1.5 0 0 0 3 8.5v5A1.5 1.5 0 0 0 4.5 15h7a1.5 1.5 0 0 0 1.5-1.5v-5A1.5 1.5 0 0 0 11.5 7zM8 1a3 3 0 0 0-3 3v2h6V4a3 3 0 0 0-3-3"/>
							</svg>
						</div>
						<div class="mem-input">
							<input type="password" name="userPw" placeholder="비밀번호">
						</div>
						<div class="mem-icon pw-check">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5s3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5s-3.879-1.168-5.168-2.457A13 13 0 0 1 1.172 8z"/>
								<path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/>
							</svg>
							<!-- <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path d="M13.359 11.238C15.06 9.72 16 8 16 8s-3-5.5-8-5.5a7 7 0 0 0-2.79.588l.77.771A6 6 0 0 1 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755q-.247.248-.517.486z"/>
								<path d="M11.297 9.176a3.5 3.5 0 0 0-4.474-4.474l.823.823a2.5 2.5 0 0 1 2.829 2.829zm-2.943 1.299.822.822a3.5 3.5 0 0 1-4.474-4.474l.823.823a2.5 2.5 0 0 0 2.829 2.829"/>
								<path d="M3.35 5.47q-.27.24-.518.487A13 13 0 0 0 1.172 8l.195.288c.335.48.83 1.12 1.465 1.755C4.121 11.332 5.881 12.5 8 12.5c.716 0 1.39-.133 2.02-.36l.77.772A7 7 0 0 1 8 13.5C3 13.5 0 8 0 8s.939-1.721 2.641-3.238l.708.709zm10.296 8.884-12-12 .708-.708 12 12z"/>
							</svg> -->
						</div>
					</div>
					
					<div class="mem-info-block">
						<div class="mem-icon">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1zm13 2.383-4.708 2.825L15 11.105zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741M1 11.105l4.708-2.897L1 5.383z"/>
							</svg>
						</div>
						<div class="mem-input">
							<input type="text" name="userEmail" placeholder="이메일">
						</div>
					</div>
					
				</div>
				
				<div id="mem-user-info">
				
					<div class="mem-info-block">
						<div class="mem-icon">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
							</svg>
						</div>
						<div class="mem-input">
							<input type="text" name="userName" placeholder="이름">
						</div>
					</div>
					
					<div class="mem-info-block">
						<div class="mem-icon">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path d="M16 8c0 3.866-3.582 7-8 7a9 9 0 0 1-2.347-.306c-.584.296-1.925.864-4.181 1.234-.2.032-.352-.176-.273-.362.354-.836.674-1.95.77-2.966C.744 11.37 0 9.76 0 8c0-3.866 3.582-7 8-7s8 3.134 8 7M5 8a1 1 0 1 0-2 0 1 1 0 0 0 2 0m4 0a1 1 0 1 0-2 0 1 1 0 0 0 2 0m3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2"/>
							</svg>
						</div>
						<div class="mem-input">
							<input type="text" name="userNickName" placeholder="닉네임">
						</div>
					</div>
					
					<div class="mem-info-block">
						<div class="mem-icon">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path d="M11 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1zM5 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2z"/>
								<path d="M8 14a1 1 0 1 0 0-2 1 1 0 0 0 0 2"/>
							</svg>
						</div>
						<div class="mem-input">
							<input type="text" name="usePhone" placeholder="핸드폰번호">
						</div>
					</div>
					
					<div class="mem-info-block">
						<div class="mem-icon">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
								<path d="M14 0H2a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2M1 3.857C1 3.384 1.448 3 2 3h12c.552 0 1 .384 1 .857v10.286c0 .473-.448.857-1 .857H2c-.552 0-1-.384-1-.857z"/>
								<path d="M6.5 7a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2"/>
							</svg>
						</div>
						<div class="mem-input">
							<input type="text" name="userBirth" placeholder="생년월일">
						</div>
					</div>
					
				</div>
			
				<div id="mem-user-gender">
				
					<div class="user-gender">남</div>
					<div class="user-gender">여</div>
					
				</div>
			
				<div id="mem-user-addr">
					<div class="mem-info-block">
						<input id="mem-addr-search" type="button" value="주소 찾기">
					</div>
					<div class="mem-info-block">
						<div class="mem-input">
							<input id="user_postCode" type="text" name="userAddr1" placeholder="우편번호" disabled>
						</div>
					</div>
					<div class="mem-info-block">
						<div class="mem-input">
							<input id="user_addres" type="text" name="userAddr2" placeholder="주소" disabled>
						</div>
					</div>
					<div class="mem-info-block">
						<div class="mem-input">
							<input id="user_exAddr" type="text" name="userAddr3" placeholder="참고항목" disabled>
						</div>
					</div>
					<div class="mem-info-block">
						<div class="mem-input">
							<input id="user_detailAddr" type="text" name="userAddr4" placeholder="상세주소">
						</div>
					</div>
	
				</div>
			
			</div>
			
			<div class="mem-btn-box">
			
				<div class="btnBox-left">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M15 2a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1zM0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm11.5 5.5a.5.5 0 0 1 0 1H5.707l2.147 2.146a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708l3-3a.5.5 0 1 1 .708.708L5.707 7.5z"/>
					</svg>
				</div>
				
				<div class="btnBox-right">
					<input type="button" value="Join">
				</div>
			
			</div>
		
		</div>
		
	</div>
	   
	
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/login/login.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/login/memberJoin.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/login/membershipAddrAPI.js"></script>
  
</body>
</html>