<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill – ${reservation.reservationNumber} – Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <div class="main-content">
        <div class="topbar no-print">
            <h3>🧾 Guest Bill / Invoice</h3>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-secondary btn-sm">← Back</a>
                <button onclick="window.print()" class="btn btn-primary btn-sm">🖨️ Print Bill</button>
            </div>
        </div>

        <div class="page-content">
            <c:choose>
                <c:when test="${empty reservation}">
                    <div class="card empty-state"><p>Reservation not found.</p></div>
                </c:when>
                <c:otherwise>
                <%-- Compute financials in JSP --%>
                <%
                    com.oceanview.model.Reservation r = (com.oceanview.model.Reservation) request.getAttribute("reservation");
                    java.math.BigDecimal pricePerNight = java.math.BigDecimal.ZERO;
                    java.math.BigDecimal roomCharges   = java.math.BigDecimal.ZERO;
                    java.math.BigDecimal taxRate       = new java.math.BigDecimal("0.10");
                    java.math.BigDecimal tax           = java.math.BigDecimal.ZERO;
                    java.math.BigDecimal grandTotal    = java.math.BigDecimal.ZERO;
                    if (r != null && r.getTotalAmount() != null && r.getNumNights() > 0) {
                        // Total amount stored already includes the base (without tax)
                        // Re-derive from total: total = base * 1.1 → base = total / 1.1
                        grandTotal    = r.getTotalAmount();
                        java.math.BigDecimal base = grandTotal.divide(new java.math.BigDecimal("1.10"), 2, java.math.RoundingMode.HALF_UP);
                        roomCharges   = base;
                        tax           = grandTotal.subtract(base);
                        pricePerNight = r.getNumNights() > 0
                            ? base.divide(java.math.BigDecimal.valueOf(r.getNumNights()), 2, java.math.RoundingMode.HALF_UP)
                            : java.math.BigDecimal.ZERO;
                    }
                    pageContext.setAttribute("pricePerNight", pricePerNight);
                    pageContext.setAttribute("roomCharges",   roomCharges);
                    pageContext.setAttribute("tax",           tax);
                    pageContext.setAttribute("grandTotal",    grandTotal);
                %>

                <div class="bill-container">
                    <!-- Bill Header -->
                    <div class="bill-header">
                        <h1>🌊 Ocean View Resort</h1>
                        <p>No. 42, Galle Fort Road, Galle 80000, Sri Lanka</p>
                        <p>📞 +94 91 222 3456 &nbsp;|&nbsp; 📧 info@oceanviewresort.lk &nbsp;|&nbsp; 🌐 www.oceanviewresort.lk</p>
                        <div style="margin-top:16px;background:rgba(255,255,255,.12);border-radius:8px;padding:10px 20px;display:inline-block;">
                            <span style="font-size:1.1rem;font-weight:700;">🧾 GUEST INVOICE</span>
                        </div>
                    </div>

                    <!-- Bill Body -->
                    <div class="bill-body">
                        <!-- Ref numbers & dates -->
                        <div style="display:flex;justify-content:space-between;margin-bottom:20px;">
                            <div>
                                <div style="font-size:.75rem;color:#64748b;font-weight:700;text-transform:uppercase;margin-bottom:3px;">Reservation Number</div>
                                <div style="font-size:1.3rem;font-weight:800;color:#0c1a2e;">${reservation.reservationNumber}</div>
                            </div>
                            <div style="text-align:right;">
                                <div style="font-size:.75rem;color:#64748b;font-weight:700;text-transform:uppercase;margin-bottom:3px;">Invoice Date</div>
                                <div style="font-size:1rem;font-weight:600;">
                                    <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd MMMM yyyy"/>
                                </div>
                            </div>
                        </div>

                        <hr class="divider">

                        <!-- Guest Info -->
                        <div class="bill-info-grid">
                            <div class="bill-info-item">
                                <label>Guest Name</label>
                                <span style="font-weight:600;">${reservation.guestName}</span>
                            </div>
                            <div class="bill-info-item">
                                <label>Contact Number</label>
                                <span>${reservation.contactNumber}</span>
                            </div>
                            <div class="bill-info-item">
                                <label>Email</label>
                                <span>${not empty reservation.email ? reservation.email : '—'}</span>
                            </div>
                            <div class="bill-info-item">
                                <label>Number of Guests</label>
                                <span>${reservation.numGuests}</span>
                            </div>
                            <div class="bill-info-item" style="grid-column:1/-1;">
                                <label>Home Address</label>
                                <span>${reservation.address}</span>
                            </div>
                        </div>

                        <hr class="divider">

                        <!-- Stay Details -->
                        <table class="bill-table">
                            <thead>
                                <tr>
                                    <th>Description</th>
                                    <th>Details</th>
                                    <th style="text-align:right;">Amount (LKR)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <strong>${reservation.roomType} Room</strong><br>
                                        <span style="font-size:.82rem;color:#64748b;">
                                            Check-in: <fmt:formatDate value="${reservation.checkInDate}" pattern="dd MMM yyyy"/>
                                            &nbsp;→&nbsp;
                                            Check-out: <fmt:formatDate value="${reservation.checkOutDate}" pattern="dd MMM yyyy"/>
                                        </span>
                                    </td>
                                    <td>${reservation.numNights} night(s) × LKR <fmt:formatNumber value="${pricePerNight}" pattern="#,##0.00"/>/night</td>
                                    <td style="text-align:right;font-weight:600;">
                                        <fmt:formatNumber value="${roomCharges}" pattern="#,##0.00"/>
                                    </td>
                                </tr>
                                <c:if test="${not empty reservation.specialRequests}">
                                <tr>
                                    <td colspan="2" style="font-size:.82rem;color:#64748b;">Special Requests: ${reservation.specialRequests}</td>
                                    <td style="text-align:right;">—</td>
                                </tr>
                                </c:if>
                            </tbody>
                        </table>

                        <!-- Totals -->
                        <div class="bill-total">
                            <div class="bill-total-row">
                                <span>Subtotal</span>
                                <span>LKR <fmt:formatNumber value="${roomCharges}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="bill-total-row">
                                <span>Government Tax (10%)</span>
                                <span>LKR <fmt:formatNumber value="${tax}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="bill-total-row">
                                <span>Discount</span>
                                <span>LKR 0.00</span>
                            </div>
                            <div class="bill-total-row total">
                                <span>💰 TOTAL AMOUNT DUE</span>
                                <span style="color:#0d9488;">LKR <fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/></span>
                            </div>
                        </div>

                        <div style="margin-top:24px;padding:16px;background:#f0fdf4;border:1.5px solid #86efac;border-radius:8px;font-size:.88rem;">
                            <strong>Payment Status:</strong>
                            <span class="badge badge-${reservation.paymentStatus == 'Paid' ? 'paid' : 'pending'}">${reservation.paymentStatus}</span>
                            &nbsp;|&nbsp; <strong>Reservation Status:</strong> ${reservation.status}
                        </div>
                    </div>

                    <!-- Bill Footer -->
                    <div class="bill-footer">
                        <p><strong>Thank you for choosing Ocean View Resort, Galle!</strong></p>
                        <p style="margin-top:6px;">We hope you had a wonderful stay. Please visit us again. 🌊</p>
                        <p style="margin-top:10px; font-size:.78rem;">This is a computer-generated document. No signature required.</p>
                    </div>
                </div><!-- /bill-container -->

                <!-- Print Action -->
                <div class="text-center mt-3 no-print">
                    <button onclick="window.print()" class="btn btn-primary">🖨️ Print This Invoice</button>
                    <a href="${pageContext.request.contextPath}/admin/reservations?action=view&resNum=${reservation.reservationNumber}"
                       class="btn btn-secondary">← View Reservation</a>
                </div>

                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
