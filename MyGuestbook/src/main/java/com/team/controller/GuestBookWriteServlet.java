package com.team.controller;

import java.io.IOException;

import com.team.dao.GuestBookDAO;
import com.team.dto.GuestBookDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/write.do")
public class GuestBookWriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
       
        String writer = request.getParameter("writer");
        String pw = request.getParameter("pw");
        String content = request.getParameter("content");
        
        
        GuestBookDTO dto = new GuestBookDTO();
        dto.setWriter(writer);
        dto.setPw(pw);
        dto.setContent(content);
        
       
        GuestBookDAO dao = new GuestBookDAO();
        dao.addGuestBook(dto);
        
        response.sendRedirect("list.do"); 
    }
}