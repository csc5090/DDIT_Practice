<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

	<!-- 폰트 -->
	<link rel="stylesheet" href="./css/fonts.css">

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

	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/myPage/myPage.css">

</head>
<body>


	<div class="main-header">
		<div class="logo">MyLogo</div>
		<div class="header-menu">
			<div>게임하러가기</div>
			<div>게시판가기</div>
			<div>로그아웃</div>
		</div>
	</div>

	<div class="container">

		<!-- 왼쪽: 랭킹정보 -->
		<div class="panel left-panel">
			<div class="panel-header">
				<span>랭킹정보</span>
			</div>
			<div class="panel-content">
				<div class="level-info">
					<div class="game-card">
						<h3>상 (Hard)</h3>
						<div class="game-info-row">
							<span>일자</span><span>2025-11-05</span>
						</div>
						<div class="game-info-row">
							<span>점수</span><span>8200</span>
						</div>
						<div class="game-info-row">
							<span>클리어타임</span><span>05:10</span>
						</div>
						<div class="game-info-row">
							<span>콤보</span><span>78</span>
						</div>
						<div class="game-info-row">
							<span>등수</span><span>12위</span>
						</div>
					</div>
					<div class="game-card">
						<h3>중 (Normal)</h3>
						<div class="game-info-row">
							<span>일자</span><span>2025-11-06</span>
						</div>
						<div class="game-info-row">
							<span>점수</span><span>8900</span>
						</div>
						<div class="game-info-row">
							<span>클리어타임</span><span>04:25</span>
						</div>
						<div class="game-info-row">
							<span>콤보</span><span>95</span>
						</div>
						<div class="game-info-row">
							<span>등수</span><span>8위</span>
						</div>
					</div>
					<div class="game-card">
						<h3>하 (Easy)</h3>
						<div class="game-info-row">
							<span>일자</span><span>2025-11-07</span>
						</div>
						<div class="game-info-row">
							<span>점수</span><span>9600</span>
						</div>
						<div class="game-info-row">
							<span>클리어타임</span><span>03:22</span>
						</div>
						<div class="game-info-row">
							<span>콤보</span><span>130</span>
						</div>
						<div class="game-info-row">
							<span>등수</span><span>3위</span>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- 중앙: 최근 30게임 -->
		<!-- 중앙: 최근 30게임 -->
		<div class="panel middle-panel">
			<div class="panel-header">
				<span>게임정보</span>
			</div>
			<div class="panel-content">
				<div class="recent-title">최근 30게임 정보</div>
				<div class="recent-header">
					<div>번호</div>
					<div>난이도</div>
					<div>일자</div>
					<div>점수</div>
					<div>클리어타임</div>
					<div>콤보</div>
				</div>
				<div class="recent-games">
					<!-- 30개 항목 -->
					<div class="recent-row">
						<div>1</div>
						<div>하</div>
						<div>2025-11-01</div>
						<div>9000</div>
						<div>04:10</div>
						<div>75</div>
					</div>
					<div class="recent-row">
						<div>2</div>
						<div>중</div>
						<div>2025-11-01</div>
						<div>8500</div>
						<div>04:50</div>
						<div>60</div>
					</div>
					<div class="recent-row">
						<div>3</div>
						<div>상</div>
						<div>2025-11-02</div>
						<div>7800</div>
						<div>05:20</div>
						<div>50</div>
					</div>
					<div class="recent-row">
						<div>4</div>
						<div>하</div>
						<div>2025-11-02</div>
						<div>9100</div>
						<div>03:50</div>
						<div>80</div>
					</div>
					<div class="recent-row">
						<div>5</div>
						<div>중</div>
						<div>2025-11-03</div>
						<div>8600</div>
						<div>04:30</div>
						<div>65</div>
					</div>
					<div class="recent-row">
						<div>6</div>
						<div>상</div>
						<div>2025-11-03</div>
						<div>7900</div>
						<div>05:10</div>
						<div>55</div>
					</div>
					<div class="recent-row">
						<div>7</div>
						<div>하</div>
						<div>2025-11-04</div>
						<div>9200</div>
						<div>03:45</div>
						<div>85</div>
					</div>
					<div class="recent-row">
						<div>8</div>
						<div>중</div>
						<div>2025-11-04</div>
						<div>8700</div>
						<div>04:20</div>
						<div>70</div>
					</div>
					<div class="recent-row">
						<div>9</div>
						<div>상</div>
						<div>2025-11-05</div>
						<div>8000</div>
						<div>05:05</div>
						<div>60</div>
					</div>
					<div class="recent-row">
						<div>10</div>
						<div>하</div>
						<div>2025-11-05</div>
						<div>9300</div>
						<div>03:40</div>
						<div>90</div>
					</div>
					<div class="recent-row">
						<div>11</div>
						<div>중</div>
						<div>2025-11-06</div>
						<div>8800</div>
						<div>04:15</div>
						<div>68</div>
					</div>
					<div class="recent-row">
						<div>12</div>
						<div>상</div>
						<div>2025-11-06</div>
						<div>8100</div>
						<div>05:00</div>
						<div>58</div>
					</div>
					<div class="recent-row">
						<div>13</div>
						<div>하</div>
						<div>2025-11-07</div>
						<div>9400</div>
						<div>03:35</div>
						<div>95</div>
					</div>
					<div class="recent-row">
						<div>14</div>
						<div>중</div>
						<div>2025-11-07</div>
						<div>8900</div>
						<div>04:05</div>
						<div>72</div>
					</div>
					<div class="recent-row">
						<div>15</div>
						<div>상</div>
						<div>2025-11-08</div>
						<div>8200</div>
						<div>05:10</div>
						<div>60</div>
					</div>
					<div class="recent-row">
						<div>16</div>
						<div>하</div>
						<div>2025-11-08</div>
						<div>9500</div>
						<div>03:30</div>
						<div>100</div>
					</div>
					<div class="recent-row">
						<div>17</div>
						<div>중</div>
						<div>2025-11-09</div>
						<div>8700</div>
						<div>04:25</div>
						<div>70</div>
					</div>
					<div class="recent-row">
						<div>18</div>
						<div>상</div>
						<div>2025-11-09</div>
						<div>8300</div>
						<div>05:05</div>
						<div>62</div>
					</div>
					<div class="recent-row">
						<div>19</div>
						<div>하</div>
						<div>2025-11-10</div>
						<div>9600</div>
						<div>03:25</div>
						<div>105</div>
					</div>
					<div class="recent-row">
						<div>20</div>
						<div>중</div>
						<div>2025-11-10</div>
						<div>8800</div>
						<div>04:00</div>
						<div>75</div>
					</div>
					<div class="recent-row">
						<div>21</div>
						<div>상</div>
						<div>2025-11-11</div>
						<div>8400</div>
						<div>05:15</div>
						<div>64</div>
					</div>
					<div class="recent-row">
						<div>22</div>
						<div>하</div>
						<div>2025-11-11</div>
						<div>9700</div>
						<div>03:20</div>
						<div>110</div>
					</div>
					<div class="recent-row">
						<div>23</div>
						<div>중</div>
						<div>2025-11-12</div>
						<div>8900</div>
						<div>04:10</div>
						<div>78</div>
					</div>
					<div class="recent-row">
						<div>24</div>
						<div>상</div>
						<div>2025-11-12</div>
						<div>8500</div>
						<div>05:05</div>
						<div>66</div>
					</div>
					<div class="recent-row">
						<div>25</div>
						<div>하</div>
						<div>2025-11-13</div>
						<div>9800</div>
						<div>03:15</div>
						<div>115</div>
					</div>
					<div class="recent-row">
						<div>26</div>
						<div>중</div>
						<div>2025-11-13</div>
						<div>8900</div>
						<div>04:00</div>
						<div>80</div>
					</div>
					<div class="recent-row">
						<div>27</div>
						<div>상</div>
						<div>2025-11-14</div>
						<div>8600</div>
						<div>05:20</div>
						<div>70</div>
					</div>
					<div class="recent-row">
						<div>28</div>
						<div>하</div>
						<div>2025-11-14</div>
						<div>9900</div>
						<div>03:10</div>
						<div>120</div>
					</div>
					<div class="recent-row">
						<div>29</div>
						<div>중</div>
						<div>2025-11-15</div>
						<div>9000</div>
						<div>04:05</div>
						<div>82</div>
					</div>
					<div class="recent-row">
						<div>30</div>
						<div>상</div>
						<div>2025-11-15</div>
						<div>8700</div>
						<div>05:10</div>
						<div>68</div>
					</div>
				</div>
			</div>
		</div>


		<!-- 오른쪽: 나의 정보 -->
		<div class="panel right-panel">
			<div class="panel-header">
				<span>나의 정보</span>
			</div>
			<div class="panel-content">
				<div class="my-info-content">

					<!-- 1번 그룹: 계정 정보 -->
					<div class="info-group">
						<div class="group-row">
							<div class="group-col">
								<div class="info-item">
									<label>아이디</label><input type="text" value="myUserID" readonly>
								</div>
								<div class="info-item">
									<label>닉네임</label><input type="text" value="홍길동">
								</div>
							</div>
							<div class="group-col">
								<div class="info-item">
									<label>비밀번호 변경</label><input type="password"
										value="password123">
								</div>
								<div class="info-item">
									<label>비밀번호 변경 확인</label><input type="password"
										placeholder="새 비밀번호 입력">
								</div>
							</div>
						</div>
					</div>

					<!-- 2번 그룹: 개인정보 -->
					<div class="info-group">
						<div class="group-row">
							<div class="group-col">
								<div class="info-item">
									<label>실제 이름</label><input type="text" value="홍길동">
								</div>
								<div class="info-item">
									<label>성별</label><input type="text" value="남성">
								</div>
							</div>
							<div class="group-col">
								<div class="info-item">
									<label>생일</label><input type="date" value="1995-05-10">
								</div>
							</div>
						</div>
					</div>

					<!-- 3번 그룹: 연락처 -->
					<div class="info-group">
						<div class="group-row">
							<div class="group-col">
								<div class="info-item">
									<label>핸드폰번호</label><input type="tel" value="010-1234-5678">
								</div>
							</div>
							<div class="group-col">
								<div class="info-item">
									<label>메일</label><input type="email" value="user@example.com">
								</div>
							</div>
						</div>
					</div>

					<!-- 4번 그룹: 주소 -->
					<div class="info-group">
						<div class="group-row">
							<div class="group-col">
								<div class="info-item">
									<label>우편번호</label><input type="text" value="12345">
								</div>
								<div class="info-item">
									<label>주소1</label><input type="text" value="서울특별시 강남구">
								</div>
							</div>
							<div class="group-col">
								<div class="info-item">
									<label>주소2</label><input type="text" value="101동 202호">
								</div>
							</div>
						</div>
					</div>

					<!-- 5번 그룹: 가입 정보 -->
					<div class="info-group">
						<div class="group-row">
							<div class="group-col">
								<div class="info-item">
									<label>가입일자</label><input type="date" value="2023-01-01"
										readonly>
								</div>
							</div>
						</div>
					</div>

				</div>

				<div class="info-footer">
					<button type="button">정보저장</button>
				</div>
			</div>
		</div>

	</div>
	<!-- container 끝 -->

</body>
</html>