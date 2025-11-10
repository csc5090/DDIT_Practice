<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰 게시판</title>

<!-- 부트스트랩 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>


<!-- 스위트어럴트2 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

<!-- jquery -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>

<!-- axios -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>

<link rel="stylesheet"
	  href="<%=request.getContextPath()%>/css/review/review.css">
	  
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/review/review.js"></script>  
	
</head>
<body>

	<div class="whiteAll-center">

		<button id="iOpenModal" class="openModal btn btn-outline-dark"
			type="button">Review Board</button>

	</div>

	<div id="iReviewModal" class="reviewModal" hidden>
		<div class="reviewDialog">
			<!-- 헤더 -->
			<div class="reviewHeader">
				<div class="reviewTitle">Review</div>
				<button id="iCloseModal" class="closeModal" type="button">닫기</button>
			</div>

			<!-- 목록 -->
			<div class="innerContent">
				<!-- 여기 -->

				<section id="iReviewList" class="reviewList">

					<c:if test="${!empty reviewList}">
						<c:forEach var="r" items="${reviewList}">
							<article class="card" data-board-no="${r.boardNo}">
								<div class="head">
									<!-- 닉네임 -->
									<span class="nickname"><c:out value="${r.nickName}" /></span>
									<!-- 아이디 -->
									<span class="memId">#<c:out value="${r.memId}" /></span>
									<!-- 별 점 -->
									<span class="stars" aria-label="${r.star}점">
									<c:forEach var="i" begin="1" end="5">
											<c:choose>
												<c:when test="${i <= (r.star lt 0 ? 0 : (r.star gt 5 ? 5 : r.star))}">★</c:when>
												<c:otherwise>☆</c:otherwise>
											</c:choose>
										</c:forEach>
									</span>
									<!-- 작성일 -->
									<span class="date"> <c:out
											value="${empty r.updatedDate ? r.createdDate : r.updatedDate}" />
									</span>

									<%-- ▼▼▼ [삭제 버튼 추가 ▼▼▼ --%>
									<%-- 현재 로그인한 memNo와 글 작성자 memNo가 같을 때만 버튼 표시 --%>
									<c:if test="${sessionScope.loginUser.mem_no == r.memNo}">

										<button type="button"
											class="btn btn-outline-info btn-sm ms-auto btn-update-review"
											data-board-no="${r.boardNo}">수정</button>

										<button type="button"
											class="btn btn-outline-danger btn-sm ms-auto btn-delete-review"
											data-board-no="${r.boardNo}">삭제</button>
									</c:if>
								</div>

								<div class="body">
									<div class="row">
										<div class="thumb">
											<c:choose>
												<c:when test="${not empty r.thumbUrl}">
													<img src="${pageContext.request.contextPath}${r.thumbUrl}"
														alt="리뷰 이미지">
												</c:when>
												<c:otherwise>
													<!-- 이미지 없을 때 문구를 삽입할 수 있다 -->
												</c:otherwise>
											</c:choose>
										</div>
										<div class="text">
											<p class="review-content-text">
												<c:out value="${r.boardContent}" />
											</p>
										</div>
									</div>
									<c:if test="${not empty r.adminReplyContent}">
										<div class="reply">
											<strong style="font-weight: 700; color: #0a84ff;">
												관리자 답변 <span
												style="font-size: 0.9em; color: #656565; font-weight: 500;">
													(<c:out value="${r.adminReplyDate}" />)
											</span>
											</strong>
											<p
												style="margin-top: 5px; margin-bottom: 0; display: block; float: none; clear: both;">



												<%-- 1. 원본 댓글을 'reply' 변수에 저장 --%>
												<c:set var="reply" value="${r.adminReplyContent}" />

												<%-- 2. "관리자 코멘트:" 접두사 제거 --%>
												<c:set var="prefix1" value="관리자 코멘트:" />
												<c:if test="${fn:startsWith(reply, prefix1)}">
													<c:set var="reply"
														value="${fn:replace(reply, prefix1, '')}" />
												</c:if>

												<%-- 3. "자 코멘트:" 접두사 제거 --%>
												<c:set var="prefix2" value="자 코멘트:" />
												<c:if test="${fn:startsWith(reply, prefix2)}">
													<c:set var="reply"
														value="${fn:replace(reply, prefix2, '')}" />
												</c:if>

												<%-- 4. 앞뒤 공백을 제거(fn:trim)한 최종본을 출력 --%>
												<c:out value="${fn:trim(reply)}" />
											</p>
										</div>
									</c:if>
								</div>
							</article>
						</c:forEach>
					</c:if>

					<c:if test="${empty reviewList}">
						<div class="card">
							<div class="body">등록된 리뷰가 없습니다.</div>
						</div>
					</c:if>

				</section>

				<!-- 여기 -->
			</div>
			<!-- DB데이터 불러오기 (select) -->

			<aside id="iWrtReview" class="wrtReview">
				<div class="bottomBar" id="iBottomBar">
					<button id="iwrtBtn" class="wrtBtn btn btn-outline-secondary"
						type="button" aria-expanded="false">
						<!-- 닫힌 상태에서 위쪽을 가리키게(chevron-up) -->
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
							fill="currentColor" class="bi bi-chevron-up" viewBox="0 0 16 16">
                        <path fill-rule="evenodd"
								d="M7.646 4.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1-.708.708L8 5.707 1.354 11.354a.5.5 0 1 1-.708-.708l6-6z" />
                        </svg>
					</button>
				</div>

				<form id="iReviewForm">
					<input type="hidden" name="typeNo" value="2">

					<div class="wrtBody wrtBody--new" aria-live="polite">
						<!-- 좌: 별점 + 파일선택 + 미리보기 -->
						<div class="wrtColLeftNew">
							<div class="rowNew">

								<div id="starsGroup" class="starsNew" role="radiogroup"
									aria-label="별점">
									<button class="starBtn" type="button" role="radio" data-val="1">
										<span>★</span>
									</button>
									<button class="starBtn" type="button" role="radio" data-val="2">
										<span>★</span>
									</button>
									<button class="starBtn" type="button" role="radio"
										aria-checked="false" data-val="3">
										<span>★</span>
									</button>
									<button class="starBtn" type="button" role="radio"
										aria-checked="false" data-val="4">
										<span>★</span>
									</button>
									<button class="starBtn" type="button" role="radio"
										aria-checked="false" data-val="5">
										<span>★</span>
									</button>
								</div>

								<input type="hidden" name="star" value="1">

							</div>

							<div class="rowNew" id="uploaderRow">

								<div class="uploaderNew">
									<button id="fileBtn" class="fileButtonNew" type="button">파일
										선택</button>
									<input id="imageInput" name="image" type="file"
										accept="image/*" multiple hidden>
									<div class="fileHintNew">최대 2장 · JPG/PNG/GIF</div>
									<div class="fileCountNew" id="fileCount">0 / 2</div>
								</div>
							</div>

							<div class="rowNew">

								<div id="previewGrid" class="previewGridNew">
									<div class="emptyBoxNew" data-empty>이미지 없음</div>
								</div>
							</div>
						</div>

						<!-- 우: 본문 + 제출 (넓게) -->
						<div class="wrtColRightNew">
							<div class="rowNew">
								<div class="textareaWrapNew">
									<textarea id="content" name="boardContent" class="textareaNew"
										required maxlength="1000"
										placeholder="리뷰를 작성해주세요 (최소 10자)&#10;게임/서비스의 장단점, 추천 여부 등을 자유롭게 적어주세요."></textarea>
									<div class="counterNew">
										<span id="cnt">0</span>/1000
									</div>
								</div>
							</div>

							<div class="btnRowNew">
								<button id="btnSubmit" name="btnSubmit" class="submitBtnNew"
									type="button" disabled>등록</button>
							</div>
						</div>
					</div>

				</form>


			</aside>
		</div>
	</div>

<script>   
</script>


</body>
</html>
