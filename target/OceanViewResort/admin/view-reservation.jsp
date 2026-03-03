<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Details – Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <div class="main-content">
        <div class="topbar">
            <h3>👁 Reservation Details</h3>
            <div class="topbar-actions no-print">
                <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-secondary btn-sm">← Back</a>
                <c:if test="${not empty reservation}">
                    <a href="${pageContext.request.contextPath}/admin/reservations?action=bill&resNum=${reservation.reservationNumber}"
                       class="btn btn-warning btn-sm">🧾 Generate Bill</a>
                </c:if>
            </div>
        </div>

        <div class="page-content">
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success">✅ Reservation <strong>${reservation.reservationNumber}</strong> created successfully!</div>
            </c:if>

            <c:choose>
                <c:when test="${empty reservation}">
                    <div class="card">
                        <div class="empty-state">
                            <div class="empty-icon">🔍</div>
                            <p>Reservation not found.</p>
                            <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-primary" style="margin-top:12px;">Back to Reservations</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Header Card -->
                    <div class="card mb-4">
                        <div style="background:linear-gradient(135deg,#0c1a2e,#0369a1);padding:24px 28px;border-radius:12px 12px 0 0;color:#fff;display:flex;justify-content:space-between;align-items:center;">
                            <div>
                                <p style="opacity:.7;font-size:.85rem;margin-bottom:4px;">Reservation Number</p>
                                <h2 style="font-size:1.6rem;font-weight:800;">${reservation.reservationNumber}</h2>
                            </div>
                            <div style="text-align:right;">
                                <c:choose>
                                    <c:when test="${reservation.status == 'Confirmed'}"><span class="badge" style="background:rgba(255,255,255,.15);color:#fff;font-size:.9rem;padding:8px 16px;">✅ Confirmed</span></c:when>
                                    <c:when test="${reservation.status == 'Checked-In'}"><span class="badge" style="background:rgba(21,128,61,.4);color:#bbf7d0;font-size:.9rem;padding:8px 16px;">🏨 Checked-In</span></c:when>
                                    <c:when test="${reservation.status == 'Checked-Out'}"><span class="badge" style="background:rgba(255,255,255,.1);color:#e2e8f0;font-size:.9rem;padding:8px 16px;">🛫 Checked-Out</span></c:when>
                                    <c:when test="${reservation.status == 'Cancelled'}"><span class="badge" style="background:rgba(220,38,38,.3);color:#fca5a5;font-size:.9rem;padding:8px 16px;">✕ Cancelled</span></c:when>
                                </c:choose>
                                <div style="margin-top:8px;opacity:.7;font-size:.82rem;">
                                    Booked: <fmt:formatDate value="${reservation.createdAt}" pattern="dd MMM yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>

                        <div class="detail-grid">
                            <div class="detail-item">
                                <label>👤 Guest Name</label>
                                <span style="font-weight:600;">${reservation.guestName}</span>
                            </div>
                            <div class="detail-item">
                                <label>📞 Contact Number</label>
                                <span>${reservation.contactNumber}</span>
                            </div>
                            <div class="detail-item">
                                <label>📧 Email Address</label>
                                <span>${not empty reservation.email ? reservation.email : '—'}</span>
                            </div>
                            <div class="detail-item">
                                <label>👥 Number of Guests</label>
                                <span>${reservation.numGuests}</span>
                            </div>
                            <div class="detail-item" style="grid-column:1/-1;">
                                <label>🏠 Home Address</label>
                                <span>${reservation.address}</span>
                            </div>
                        </div>

                        <div style="background:#f0f9ff;padding:20px 24px;display:grid;grid-template-columns:1fr 1fr 1fr 1fr;gap:16px;border-top:1px solid #e0f2fe;">
                            <div>
                                <p style="font-size:.75rem;font-weight:700;color:#0369a1;text-transform:uppercase;letter-spacing:.5px;margin-bottom:4px;">🛏️ Room Type</p>
                                <p style="font-weight:700;font-size:1.05rem;">${reservation.roomType}</p>
                            </div>
                            <div>
                                <p style="font-size:.75rem;font-weight:700;color:#0369a1;text-transform:uppercase;letter-spacing:.5px;margin-bottom:4px;">📅 Check-In</p>
                                <p style="font-weight:700;font-size:1.05rem;"><fmt:formatDate value="${reservation.checkInDate}" pattern="dd MMM yyyy"/></p>
                            </div>
                            <div>
                                <p style="font-size:.75rem;font-weight:700;color:#0369a1;text-transform:uppercase;letter-spacing:.5px;margin-bottom:4px;">📅 Check-Out</p>
                                <p style="font-weight:700;font-size:1.05rem;"><fmt:formatDate value="${reservation.checkOutDate}" pattern="dd MMM yyyy"/></p>
                            </div>
                            <div>
                                <p style="font-size:.75rem;font-weight:700;color:#0369a1;text-transform:uppercase;letter-spacing:.5px;margin-bottom:4px;">🌙 Nights</p>
                                <p style="font-weight:700;font-size:1.05rem;">${reservation.numNights} night(s)</p>
                            </div>
                        </div>

                        <div style="padding:20px 24px;display:flex;justify-content:space-between;align-items:center;border-top:1px solid #e2e8f0;">
                            <div>
                                <p class="text-muted">Special Requests</p>
                                <p>${not empty reservation.specialRequests ? reservation.specialRequests : 'None'}</p>
                            </div>
                            <div style="text-align:right;">
                                <p class="text-muted">Total Amount</p>
                                <p style="font-size:1.5rem;font-weight:800;color:#0d9488;">
                                    LKR <fmt:formatNumber value="${reservation.totalAmount}" pattern="#,##0.00"/>
                                </p>
                                <span class="badge badge-pending">${reservation.paymentStatus}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="d-flex gap-3 no-print">
                        <a href="${pageContext.request.contextPath}/admin/reservations?action=bill&resNum=${reservation.reservationNumber}"
                           class="btn btn-warning">🧾 Generate & Print Bill</a>
                        <c:if test="${reservation.status == 'Confirmed'}">
                            <a href="${pageContext.request.contextPath}/admin/reservations?action=checkin&resNum=${reservation.reservationNumber}"
                               class="btn btn-success" onclick="return confirm('Mark as Checked-In?')">✅ Check-In Guest</a>
                            <a href="${pageContext.request.contextPath}/admin/reservations?action=cancel&resNum=${reservation.reservationNumber}"
                               class="btn btn-danger" onclick="return confirm('Cancel this reservation?')">✕ Cancel Reservation</a>
                        </c:if>
                        <c:if test="${reservation.status == 'Checked-In'}">
                            <a href="${pageContext.request.contextPath}/admin/reservations?action=checkout&resNum=${reservation.reservationNumber}"
                               class="btn btn-secondary" onclick="return confirm('Mark as Checked-Out?')">🛫 Check-Out Guest</a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
