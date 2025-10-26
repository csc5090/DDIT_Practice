<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Good Day, Commander.</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin_layout.css">
    
</head>
<body>
    <div id="admin-wrapper">
        <nav class="sidearea">
            <div class="logo-wrapper">
                <span class="logo-span"> 로고 들어갈 자리 </span>
            </div>
            
            <div class="ul-wrapper">
                <ul class="nav-container">
                    <li class="nav-big-area" data-url="/admin/view/dashboard.do">
                        <div class="bigmenu-container">
                            <span class="span-big"> 대시보드 </span>
                        </div>
                    </li>
                    <li class="nav-big-area">
                        <div class="bigmenu-container">
                            <span class="span-big"> 사용자 </span>
                        </div>
                        <div class="ul-container-none">
                            <ul class="ul-small-container">
                                <li data-url="/admin/view/userList.do"><span class="span-small">목록 조회</span></li>
                                <li data-url="/admin/view/userAuth.do"><span class="span-small">권한 관리</span></li>
                            </ul>
                        </div>
                    </li>
                    <li class="nav-big-area" data-url="/admin/view/chat.do">
						<div class="bigmenu-container">
							<span class="span-big"> 채팅 </span>
						</div>
					</li>
                    <li class="nav-big-area">
						<div class="bigmenu-container">
							<span class="span-big"> 게시판 </span>
						</div>
						<div class="ul-container-none">
							<ul class="ul-small-container">
								<li data-url="/admin/view/noticeManage.do"><span class="span-small"> 공지사항 관리 </span></li>
								<li data-url="/admin/view/postManage.do"><span class="span-small"> 게시물 관리 </span></li>
							</ul>
						</div>
					</li>
                </ul>
            </div>

            <div class="nav-wrapper">
                <div class="bigmenu-container" data-url="/admin/view/settings.do">
                    <span class="span-big"> 설정 </span>
                </div>
            </div>
        </nav>
        
        <main class="main-area">
			
        </main>
    </div>
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/admin/admin_layout.js"></script>
</body>
</html>