<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>동적 to do</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/CSC/practice2.css">
</head>
<body>

<div class="todo-container">
<h1>To Do</h1>
<form id="todo-form">
	<input type="text" id="todo-input" placeholder="새로운 할 일을 입력" required>
	<button type="submit">추가</button>
</form>

<ul id="todo-list"></ul>
</div>

<script src="${pageContext.request.contextPath}/js/CSC/practice2.js"></script>

</body>
</html>