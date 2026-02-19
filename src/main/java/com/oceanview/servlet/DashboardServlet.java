package com.oceanview.servlet;

import com.oceanview.dao.ReservationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    private final ReservationDAO dao = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req, resp)) return;

        try {
            req.setAttribute("totalReservations",  dao.getTotalReservations());
            req.setAttribute("todayCheckIns",       dao.getTodayCheckInCount());
            req.setAttribute("todayCheckOuts",      dao.getTodayCheckOutCount());
            req.setAttribute("currentGuests",       dao.getCurrentGuestsCount());
            req.setAttribute("checkInList",         dao.getTodayCheckIns());
            req.setAttribute("checkOutList",        dao.getTodayCheckOuts());
        } catch (Exception e) {
            req.setAttribute("dbError", e.getMessage());
        }

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }

    static boolean isLoggedIn(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?msg=sessionexpired");
            return false;
        }
        return true;
    }
}
