<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- [중요!] 톰캣 11 기준, jakarta 태그 라이브러리! --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>방명록</title>
<style>
    body { font-family: sans-serif; width: 800px; margin: 0 auto; }
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
    form { border: 1px solid #ccc; padding: 15px; margin-bottom: 20px; border-radius: 8px; }
</style>
</head>
<body>

    <h2>방명록 남기기</h2>
    
    <%--  새로운 방명록을 작성하는 폼(form). 'write.do' 서블릿으로 요청을 보냄. --%>
    <form action="write.do" method="post">
        작성자: <input type="text" name="writer" size="10">
        비밀번호: <input type="password" name="pw" size="10"> <br><br>
        <textarea name="content" rows="5" cols="80" placeholder="방명록 내용 작성"></textarea> <br>
        <input type="submit" value="기록하기">
    </form>
    
    <hr>
    
    <h2>방명록 목록</h2>
    <table>
        <thead>
            <tr>
                <th width="5%">번호</th>
                <th width="50%">내용</th>
                <th width="15%">작성자</th>
                <th width="20%">작성일</th>
                <th width="10%">관리</th>
            </tr>
        </thead>
        <tbody>
            <%-- 서블릿이 "guestbookList"라는 이름으로 넘겨준 목록을, c:forEach로 반복해서 보여줌. --%>
            <c:forEach var="dto" items="${guestbookList}">
                <tr>
                    <td>${dto.no}</td>
                    <td>${dto.content}</td>
                    <td>${dto.writer}</td>
                    <td>${dto.regDate}</td>
                    <td>
                        <%-- 각 글마다, 수정과 삭제 페이지로 이동하는 링크를 만들어 줌. 글 번호(no)를 함께 보내는 게 중요! --%>
                        <a href="edit.do?no=${dto.no}">수정</a>
                        <a href="delete.do?no=${dto.no}">삭제</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</body>
</html>