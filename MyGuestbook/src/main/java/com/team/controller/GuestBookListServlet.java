package com.team.controller;

import java.io.IOException;
import java.util.List;

import com.team.dao.GuestBookDAO;
import com.team.dto.GuestBookDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/list.do")
public class GuestBookListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        
        GuestBookDAO dao = new GuestBookDAO();
        
        List<GuestBookDTO> list = dao.getGuestBookList();
        
        request.setAttribute("guestbookList", list);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("guestbook.jsp");
        dispatcher.forward(request, response);
    }
}