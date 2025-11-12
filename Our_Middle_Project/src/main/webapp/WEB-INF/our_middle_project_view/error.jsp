<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오 이런! 뭔가... 잘못됐네요!</title>
<style>
    html {
        height: 100%;
        margin: 0;
    }
    
    body {
        background-color: #2c3e50;
        color: #ecf0f1;
        font-family: 'Arial', 'Helvetica', sans-serif;
        line-height: 1.5; /* 줄 간격 살짝 조정 */
        
        /* === Flexbox를 이용한 원페이지 레이아웃 === */
        display: flex;
        flex-direction: column;
        justify-content: center; /* 수직 중앙 정렬 */
        align-items: center;   /* 수평 중앙 정렬 */
        
        height: 100vh;           /* 뷰포트(화면) 전체 높이 */
        margin: 0;
        padding: 20px;           /* 내용이 가장자리에 붙지 않도록 패딩 */
        box-sizing: border-box;  /* 패딩을 높이에 포함 */
        text-align: center;
        
        overflow: hidden;        /* !! 스크롤바 생성 방지 !! */
    }

    /* 공간 확보를 위해 요소간 여백(margin)을 줄입니다. */
    h1, p, .error-code, .contact {
        margin-top: 10px;
        margin-bottom: 10px;
    }

    h1 {
        color: #e74c3c;
        font-size: 2.2em; /* 폰트 크기 살짝 줄임 */
    }

    p {
        font-size: 1.1em; /* 폰트 크기 살짝 줄임 */
        color: #bdc3c7;
    }

    .error-code {
        background-color: #34495e;
        color: #f1c40f;
        font-weight: bold;
        font-size: 1.6em; /* 폰트 크기 살짝 줄임 */
        padding: 10px 20px; /* 패딩 살짝 줄임 */
        border-radius: 8px;
        font-family: 'Courier New', Courier, monospace;
    }

    img {
        max-width: 200px; /* 이미지 크기 줄임 */
        height: auto;
        border-radius: 50%;
        border: 4px solid #34495e;
        margin-bottom: 10px;
    }

    .contact {
        margin-top: 20px; /* 상단 여백 줄임 */
        border-top: 2px solid #34495e;
        padding-top: 15px; /* 상단 패딩 줄임 */
        font-size: 1em;
    }
    
    .contact p {
        margin: 5px 0; /* 연락처 내부 p태그 여백 줄임 */
    }

    .contact a {
        color: #3498db;
        text-decoration: none;
        font-weight: bold;
    }

    .contact a:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>
    <img src="${pageContext.request.contextPath}/images/omg.jpg"
        alt="Error Image">

    <h1>이런! 페이지가 길을 잃었네요.</h1>
    <p>
        저희 개발자가 커피를 쏟았거나... ☕<br>
        아니면 그냥 알 수 없는 우주의 힘이 작용했나 봅니다.
    </p>
    
    <p>무슨 일이 일어났는지 저희도 알아야 하니, <br>아래 코드를 붙잡아서 관리자에게 알려주세요!</p>

    <div class="error-code">
        <strong>
            <c:choose>
                <c:when test="${not empty requestScope.errorMessage}">
                    ${requestScope.errorMessage}
                </c:when>
                <c:otherwise>
                    [${requestScope['jakarta.servlet.error.status_code']}]
                </c:otherwise>
            </c:choose>
        </strong>
    </div>

    <div class="contact"> 
        <p>
            문제가 계속되면, 용감한 저희 관리자에게 연락주세요.<br>
            (아마 지금 열심히 고치고 있을 거예요!)
        </p>
        <p>
            <a href="mailto:admin@example.com">admin@example.com</a>
        </p>
    </div>

</body>
</html>