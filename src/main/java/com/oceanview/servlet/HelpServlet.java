package com.oceanview.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/help")
public class HelpServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!DashboardServlet.isLoggedIn(req, resp)) return;
        req.getRequestDispatcher("/admin/help.jsp").forward(req, resp);
    }
}
