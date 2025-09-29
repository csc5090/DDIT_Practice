package com.team.controller;

import java.io.IOException;
import com.team.dao.GuestBookDAO;
import com.team.dto.GuestBookDTO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/edit.do")
public class GuestBookEditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int no = Integer.parseInt(request.getParameter("no"));
        GuestBookDAO dao = new GuestBookDAO();
        GuestBookDTO dto = dao.getGuestBook(no);
        request.setAttribute("dto", dto);
        RequestDispatcher dispatcher = request.getRequestDispatcher("edit_view.jsp");
        dispatcher.forward(request, response);
    }
}