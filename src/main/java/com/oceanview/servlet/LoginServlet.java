package com.oceanview.servlet;

import com.oceanview.dao.AdminDAO;
import com.oceanview.model.AdminUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if ("/logout".equals(req.getServletPath())) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/login?msg=loggedout");
            return;
        }

        // Already logged in → redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            AdminUser user = adminDAO.authenticate(username, password);
            if (user != null) {

                // ✅ Fix session fixation — invalidate old session, create fresh one
                HttpSession oldSession = req.getSession(false);
                if (oldSession != null) oldSession.invalidate();

                HttpSession session = req.getSession(true); //
                session.setAttribute("adminUser", user);
                session.setMaxInactiveInterval(60 * 60); // 1 hour
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                req.setAttribute("error", "Invalid username or password. Please try again.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "System error: " + e.getMessage() + ". Please check database connection.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }}