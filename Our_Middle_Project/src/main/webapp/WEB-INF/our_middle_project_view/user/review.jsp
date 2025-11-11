<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div id="iReviewModal" class="reviewModal review-modal-off">
    <div class="bootstrap-env"> 
		<div class="reviewDialog">
            
            <div class="reviewHeader">
				<button id="iCloseModal" class="closeModal" type="button"> 
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-circle" viewBox="0 0 16 16">
					  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
					  <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
					</svg>
				</button>
			</div>
			
            <div id="iReviewToolbar" class="reviewToolbar">
				<button id="iwrtBtn" class="wrtBtn" type="button" aria-expanded="false">
				                    리뷰 작성
				                </button>
			    <button class="sortBtn" data-sort="oldest">최신순</button>
			    <button class="sortBtn" data-sort="newest">오래된 순</button>
			</div>
            
            <div class="bottomBar" id="iBottomBar">
			</div>

			<div class="innerContent">
				<section id="iReviewList" class="reviewList">

					<c:if test="${!empty reviewList}">
						<c:forEach var="r" items="${reviewList}">
							<article class="rv-card" data-board-no="${r.boardNo}" data-mem-no="${r.memNo}" >
								<div class="rv-head">
									<span class="nickname"><c:out value="${r.nickName}" /></span>
									<span class="memId">#<c:out value="${r.memId}" /></span>
									<span class="stars" aria-label="${r.star}점">
									<c:forEach var="i" begin="1" end="5">
											<c:choose>
												<c:when test="${i <= (r.star lt 0 ? 0 : (r.star gt 5 ? 5 : r.star))}">★</c:when>
												<c:otherwise>☆</c:otherwise>
											</c:choose>
										</c:forEach>
									</span>
									
									
									<div class="rv-actions">
									<span class="date"> <c:out
											value="${empty r.updatedDate ? r.createdDate : r.updatedDate}" />
									</span>

									<c:if test="${sessionScope.loginUser.mem_no == r.memNo}">
										<button type="button"
											class="btn btn-outline-info btn-sm ms-auto btn-update-review"
											data-board-no="${r.boardNo}">수정</button>

										<button type="button"
											class="btn btn-outline-danger btn-sm ms-auto btn-delete-review"
											data-board-no="${r.boardNo}">삭제</button>
									</c:if>
									</div>
								</div>

								<div class="rv-body">
									<div class="rv-row">
										<div class="rv-thumb">
											<c:choose>
												<c:when test="${not empty r.thumbUrl}">
													<img src="${pageContext.request.contextPath}${r.thumbUrl}"
														alt="리뷰 이미지">
												</c:when>
												<c:otherwise>
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

												<c:set var="reply" value="${r.adminReplyContent}" />
												<c:set var="prefix1" value="관리자 코멘트:" />
												<c:if test="${fn:startsWith(reply, prefix1)}">
													<c:set var="reply"
														value="${fn:replace(reply, prefix1, '')}" />
												</c:if>
												<c:set var="prefix2" value="자 코멘트:" />
												<c:if test="${fn:startsWith(reply, prefix2)}">
													<c:set var="reply"
														value="${fn:replace(reply, prefix2, '')}" />
												</c:if>
												<c:out value="${fn:trim(reply)}" />
											</p>
										</div>
									</c:if>
								</div>
							</article>
						</c:forEach>
					</c:if>

					<c:if test="${empty reviewList}">
						<div class="rv-card">
							<div class="rv-body">등록된 리뷰가 없습니다.</div>
						</div>
					</c:if>

				</section>
			</div>

            <aside id="iWrtReview" class="wrtReview">
				<form id="iReviewForm">
					<input type="hidden" name="typeNo" value="2">

					<div class="wrtBody wrtBody--new" aria-live="polite">
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
</div>