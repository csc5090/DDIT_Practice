<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오 이런!</title>
</head>
<body>
	<div style="text-align: center;">
		<img src="images/omg.jpg" alt="Error Image" width="300">

		<h1>저런! 당신의 요청은 뭔가 잘못됐습니다!</h1>
		<p>
			에러 코드는... <strong>${requestScope['jakarta.servlet.error.status_code']}</strong>
			입니다! 
		</p>

		<hr>
			
		<p>
		관리자에게 문의하세요!
		관리자 연락처 : 카톡 tkdcjf5090
		</p>
		
	</div>
</body>
</html>