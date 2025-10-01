<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>방명록 수정하기</title>
</head>
<body>
	<h2>방명록 수정</h2>
	<form action="update.do" method="post">
		<%-- [주석] 수정할 글의 번호는 눈에 보이지 않게 숨겨서(hidden) 함께 보내야 함! --%>
		<input type="hidden" name="no" value="${dto.no}"> 작성자: <input
			type="text" name="writer" value="${dto.writer}"><br>
		비밀번호: <input type="password" name="pw"><br>
		<textarea name="content" rows="5" cols="50">${dto.content}</textarea>
		<br> <input type="submit" value="수정 완료">
	</form>
</body>
</html>