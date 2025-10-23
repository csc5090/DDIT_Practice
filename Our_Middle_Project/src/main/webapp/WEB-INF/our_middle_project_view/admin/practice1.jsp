<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/CSC/practice1.css">

<title>연습</title>
</head>
<body>
<article class="profile-card">
	<figure>
		<img src="${pageContext.request.contextPath}/images/prtc.jpg" alt="프로필 이미지">
	</figure>
	<h2>CSC</h2>
	<p>웹 백엔드 개발자 지망생</p>
	<button id="follow-btn">팔로우</button>
</article>

<script src="${pageContext.request.contextPath}/js/CSC/practice1.js"></script>

</body>
</html>