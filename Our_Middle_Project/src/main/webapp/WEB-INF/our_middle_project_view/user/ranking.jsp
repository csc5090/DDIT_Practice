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


<link rel="stylesheet"href="./css/ranking/ranking_layout.css">



</head>
<body>
	
		<div id="rankingMain">
			
			<div id="topMain">
			
				<div id="topwidth500">
				
					<div id="topwidth100-eazy">
						
						<div id="rankingTop1-1">1위🥇 </div>
						<div id="rankingTop2-1">2위🥈 </div>
						<div id="rankingTop3-1">3위🥉 </div>
						
					</div>
					
					<div id="topwidth100-normal">
						
						<div id="rankingTop1-2">1위🥇 </div>
						<div id="rankingTop2-2">2위🥈 </div>
						<div id="rankingTop3-2">3위🥉 </div>
						
					</div>
					
					<div id="topwidth100-hard">
						
						<div id="rankingTop1-3">1위🥇 </div>
						<div id="rankingTop2-3">2위🥈 </div>
						<div id="rankingTop3-3">3위🥉 </div>
						
					</div>
					
					<div id="topwidth100-vs">
						
						<div id="rankingTop1-4">1위🥇 </div>
						<div id="rankingTop2-4">2위🥈 </div>
						<div id="rankingTop3-4">3위🥉 </div>
						
					</div>
					
					<div id="topwidth100-total">
						
						<div id="rankingTop1-5">1위🥇 </div>
						<div id="rankingTop2-5">2위🥈 </div>
						<div id="rankingTop3-5">3위🥉 </div>
						
					</div>
					
				</div>
				
			</div>
	
			<div id="centerMain">
				
				<div id="centerWidth500">
				
					<div id="rankingList-1">eazy</div>
					<div id="rankingList-2">normal</div>
					<div id="rankingList-3">hard</div>
					<div id="rankingList-4">vs</div>
					<div id="rankingList-5">total</div>	
					
				</div>
					
			</div>
			
			<div id="bottomMain">
				
				<div id="navArea-1">
					<button id="btnEazy">eazy</button>
				</div>
				<div id="navArea-2">
					<button id="btnNormal">normal</button>
				</div>
				<div id="navArea-3">
					<button id="btnHard">hard</button>
				</div>
				<div id="navArea-4">
					<button id="btnVs">vs</button>
				</div>
				<div id="navArea-5">
					<button id="btnTotal">total</button>
				</div>
			
			</div>
			
		</div>
		
<script type="text/javascript" src="./js/ranking/ranking_Layout.js"></script>
</body>
</html>