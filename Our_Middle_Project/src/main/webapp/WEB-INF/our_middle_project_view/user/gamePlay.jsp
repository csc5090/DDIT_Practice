<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<link rel="stylesheet" href="./js/lib/bootstrap/css/bootstrap.min.css">
	<script type="text/javascript" src="./js/lib/bootstrap/js/bootstrap.min.js"></script>
	
	<link rel="stylesheet" href="./js/lib/sweetalert2/dist/sweetalert2.min.css">
	<script type="text/javascript" src="./js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

	<link rel="stylesheet" href="./css/game/gameEnding.css">
</head>
<body>

	<div class="bg-dark-subtle w-75 p-3 h-75 d-inline-block">

<i class="bi bi-3-circle-fill"></i>
		<div class="container text-center">
			<div class="row">
				<div class="col bg-danger rounded-5">Column</div>
				<div class="col shadow p-3 mb-5 bg-body-tertiary rounded">Column</div>
				<div class="col text-warning-emphasis bg-primary-subtle">Column</div>
			</div>
		</div>

		<button type="button" class="btn btn-outline-secondary" onclick="clickHandle()">click</button>

	</div>

	<div class="ending-container bg-secondary bg-opacity-75">
	
		<div class="">right</div>
		<div class="">left</div>
	
	</div>

	<!-- Vertically centered modal -->
<div class="modal-dialog modal-dialog-centered">
  ...
</div>

<!-- Vertically centered scrollable modal -->
<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
  ...
</div>

	<script type="text/javascript" src="./js/game/test.js"></script>

</body>
</html>