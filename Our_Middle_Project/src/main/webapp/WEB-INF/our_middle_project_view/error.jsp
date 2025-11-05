<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오 이런!</title>
</head>
<body>
	<div style="text-align: center;">
		<img src="${pageContext.request.contextPath}/images/omg.jpg"
			alt="Error Image" width="300">

		<h1>오우! 이런! 이런! 당신의 요청은 뭔가 잘못됐습니다!</h1>
		<p>
			에러 코드는... <strong style="color: red; font-weight: bold;">
				<c:choose>
					
					<c:when test="${not empty requestScope.errorMessage}">
                        ${requestScope.errorMessage}
                    </c:when>

					<c:otherwise>
                        ${requestScope['jakarta.servlet.error.status_code']}
                    </c:otherwise>
				</c:choose>
			</strong> 입니다!
		</p>

		<hr>

		<p>
			관리자에게 문의하세요!<br>
			관리자 연락처 : 카톡 tkdcjf5090<br>
			관리자 이메일 : 안알려줄거임<br>
			<br>
			
			<h1>
				적절한 세션이 없다
			</h1>
			<h2>
			 1. 로그아웃 후 뒤로가기 시도  2. URL로 강제로 접속 시도<br>
				이 두 가지는 하지 않는게 좋습니다!
			</h2>
			
		</p>

	</div>
</body>
</html>