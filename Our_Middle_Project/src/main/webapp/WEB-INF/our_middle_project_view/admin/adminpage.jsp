<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Good Day. Commander.</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_layout.css">

</head>
<body>

<div id="admin-wrapper">
	<nav class="sidebar">
	
	</nav>

	<main class="main-content">
		<header class="main-header">
			
		</header>
		
		<section class="content-body">
			<jsp:include page="${viewPage}"/>
		</section>
	</main>

</div>

<script src="${pageContext.request.contextPath}/js/CSC/admin_layout.js"></script>


</body>
</html>