<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>랭킹</title>

<!-- 부트스트랩 -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>
	
	<!-- 스위트어럴트2 -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>
	
	<!-- jquery -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>
	
	<!-- axios -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>

</head>
<body>
	
		<div id="rankingMain">
			
			<div id="topMain">
			
				<div id="topwidth500">
				
					<div id="topwidth100-1">
						
						<div id="rankingTop1-1"> </div>
						<div id="rankingTop2-1"> </div>
						<div id="rankingTop3-1"> </div>
						
					</div>
					
					<div id="topwidth100-2">
						
						<div id="rankingTop1-2"> </div>
						<div id="rankingTop2-2"> </div>
						<div id="rankingTop3-2"> </div>
						
					</div>
					
					<div id="topwidth100-3">
						
						<div id="rankingTop1-3"> </div>
						<div id="rankingTop2-3"> </div>
						<div id="rankingTop3-3"> </div>
						
					</div>
					
					<div id="topwidth100-4">
						
						<div id="rankingTop1-4"> </div>
						<div id="rankingTop2-4"> </div>
						<div id="rankingTop3-4"> </div>
						
					</div>
					
					<div id="topwidth100-5">
						
						<div id="rankingTop1-5"> </div>
						<div id="rankingTop2-5"> </div>
						<div id="rankingTop3-5"> </div>
						
					</div>
					
				</div>
				
			</div>
	
			<div id="centerMain">
				
				<div id="centerWidth500">
				
					<div id="rankingList-1"></div>
					<div id="rankingList-2"></div>
					<div id="rankingList-3"></div>
					<div id="rankingList-4"></div>
					<div id="rankingList-5"></div>	
					
				</div>
					
			</div>
			
			<div id="bottomMain">
				
				<div id="navArea-1"></div>
				<div id="navArea-2"></div>
				<div id="navArea-3"></div>
				<div id="navArea-4"></div>
				<div id="navArea-5"></div>
			
			</div>
			
		</div>

<script type="text/javascript"></script>
</body>
</html>