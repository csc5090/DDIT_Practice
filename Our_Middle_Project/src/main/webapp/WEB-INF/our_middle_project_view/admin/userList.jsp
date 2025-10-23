<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="container-fluid">
	<h3>회원 관리</h3>
	
	<div class="row mb-3">
		<input type="text" id="searchInput" clas="form-control" placeholder="아이디, 닉네임으로 검색">
	</div>
	<div class="col-md-2">
		<button id="searchBtn" class="btn btn-primary">검색</button>
	</div>
</div>

<table class="table table-hover">
	<thead>
		<tr>
			<th>회원번호</th>
			<th>아이디</th>
			<th>닉네임</th>
			<th>가입일</th>
			<th>상태</th>
			<th>관리</th>
		</tr>
	</thead>
	<tbody id="user-table-body">
	
	</tbody>
</table>

<script src="${pageContext.request.contextPath}/js/CSC/user-management.js"></script>