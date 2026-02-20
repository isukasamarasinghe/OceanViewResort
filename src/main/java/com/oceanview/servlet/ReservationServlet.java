package com.oceanview.servlet;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.AdminUser;
import com.oceanview.model.Reservation;
import com.oceanview.util.RoleUtil;
import com.oceanview.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/reservations")
public class ReservationServlet extends HttpServlet {

    private final ReservationDAO dao = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!DashboardServlet.isLoggedIn(req, resp)) return;
        AdminUser admin = RoleUtil.getCurrentUser(req);

        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    // ✅ Staff cannot add reservations
                    if (!RoleUtil.requirePermission(req, resp, admin.canAddReservation())) return;
                    req.setAttribute("roomTypes", dao.getAllRoomTypes());
                    req.setAttribute("newResNum", dao.generateReservationNumber());
                    req.getRequestDispatcher("/admin/add-reservation.jsp").forward(req, resp);
                    break;

                case "view":
                    String resNum = req.getParameter("resNum");
                    req.setAttribute("reservation", dao.getByReservationNumber(resNum));
                    req.getRequestDispatcher("/admin/view-reservation.jsp").forward(req, resp);
                    break;

                case "bill":
                    // ✅ Staff cannot generate bills
                    if (!RoleUtil.requirePermission(req, resp, admin.canGenerateBill())) return;
                    String billResNum = req.getParameter("resNum");
                    req.setAttribute("reservation", dao.getByReservationNumber(billResNum));
                    req.getRequestDispatcher("/admin/bill.jsp").forward(req, resp);
                    break;

                default: // "list"
                    String keyword = req.getParameter("search");
                    List<Reservation> list;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        list = dao.searchReservations(keyword.trim());
                        req.setAttribute("searchKeyword", keyword);
                    } else {
                        list = dao.getAllReservations();
                    }
                    req.setAttribute("reservations", list);
                    req.getRequestDispatcher("/admin/reservations.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/admin/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!DashboardServlet.isLoggedIn(req, resp)) return;
        AdminUser admin = RoleUtil.getCurrentUser(req);

        String action = req.getParameter("action");
        if (action == null) action = "create";

        try {
            switch (action) {
                case "checkin":
                    // ✅ All roles can check in
                    dao.updateStatus(req.getParameter("resNum"), "Checked-In");
                    resp.sendRedirect(req.getContextPath() + "/admin/reservations?msg=checkedin");
                    break;

                case "checkout":
                    // ✅ All roles can check out
                    dao.updateStatus(req.getParameter("resNum"), "Checked-Out");
                    resp.sendRedirect(req.getContextPath() + "/admin/reservations?msg=checkedout");
                    break;

                case "cancel":
                    // ✅ Only admin can cancel
                    if (!RoleUtil.requirePermission(req, resp, admin.canCancelReservation())) return;
                    dao.cancelReservation(req.getParameter("resNum"));
                    resp.sendRedirect(req.getContextPath() + "/admin/reservations?msg=cancelled");
                    break;

                default: // create new reservation
                    if (!RoleUtil.requirePermission(req, resp, admin.canAddReservation())) return;

                    // ✅ Server-side validation
                    String guestName    = req.getParameter("guestName");
                    String contactNum   = req.getParameter("contactNumber");
                    String email        = req.getParameter("email");
                    String address      = req.getParameter("address");
                    String roomType     = req.getParameter("roomType");
                    String checkInDate  = req.getParameter("checkInDate");
                    String checkOutDate = req.getParameter("checkOutDate");
                    String numGuests    = req.getParameter("numGuests");

                    List<String> errors = ValidationUtil.validateReservation(
                            guestName, contactNum, email, address,
                            roomType, checkInDate, checkOutDate, numGuests);

                    if (!errors.isEmpty()) {
                        // Send errors back to the form — preserve entered values
                        req.setAttribute("errors",       errors);
                        req.setAttribute("roomTypes",    dao.getAllRoomTypes());
                        req.setAttribute("newResNum",    req.getParameter("reservationNumber"));
                        req.setAttribute("v_guestName",  guestName);
                        req.setAttribute("v_contact",    contactNum);
                        req.setAttribute("v_email",      email);
                        req.setAttribute("v_address",    address);
                        req.setAttribute("v_roomType",   roomType);
                        req.setAttribute("v_checkIn",    checkInDate);
                        req.setAttribute("v_checkOut",   checkOutDate);
                        req.setAttribute("v_numGuests",  numGuests);
                        req.getRequestDispatcher("/admin/add-reservation.jsp").forward(req, resp);
                        return;
                    }

                    Reservation r = new Reservation();
                    r.setReservationNumber(req.getParameter("reservationNumber"));
                    r.setGuestName(guestName);
                    r.setAddress(address);
                    r.setContactNumber(contactNum);
                    r.setEmail(email);
                    r.setRoomType(roomType);
                    r.setCheckInDate(Date.valueOf(checkInDate));
                    r.setCheckOutDate(Date.valueOf(checkOutDate));
                    r.setNumGuests(numGuests != null && !numGuests.isEmpty() ? Integer.parseInt(numGuests) : 1);
                    r.setSpecialRequests(req.getParameter("specialRequests"));

                    boolean success = dao.addReservation(r, admin.getId());
                    if (success) {
                        resp.sendRedirect(req.getContextPath()
                                + "/admin/reservations?action=view&resNum=" + r.getReservationNumber()
                                + "&msg=added");
                    } else {
                        req.setAttribute("error", "Failed to save reservation. Please try again.");
                        req.setAttribute("roomTypes", dao.getAllRoomTypes());
                        req.getRequestDispatcher("/admin/add-reservation.jsp").forward(req, resp);
                    }
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error saving reservation: " + e.getMessage());
            try { req.setAttribute("roomTypes", dao.getAllRoomTypes()); } catch (Exception ignored) {}
            req.getRequestDispatcher("/admin/add-reservation.jsp").forward(req, resp);
        }
    }
}