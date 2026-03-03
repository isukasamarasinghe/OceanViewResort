<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Reservations – Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <div class="main-content">
        <div class="topbar">
            <h3>📋 All Reservations</h3>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/admin/reservations?action=add" class="btn btn-primary btn-sm">
                    ➕ New Reservation
                </a>
            </div>
        </div>

        <div class="page-content">

            <c:if test="${param.msg == 'cancelled'}">
                <div class="alert alert-success">✅ Reservation has been cancelled successfully.</div>
            </c:if>
            <c:if test="${param.msg == 'checkedin'}">
                <div class="alert alert-success">✅ Guest checked in successfully.</div>
            </c:if>
            <c:if test="${param.msg == 'checkedout'}">
                <div class="alert alert-success">✅ Guest checked out successfully.</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    Reservation Records
                    <form method="get" action="${pageContext.request.contextPath}/admin/reservations" class="search-bar" style="width:360px;">
                        <input type="text" name="search" placeholder="Search by name, reservation #, phone…"
                               value="${searchKeyword}">
                        <button type="submit" class="btn btn-outline btn-sm">🔍 Search</button>
                        <c:if test="${not empty searchKeyword}">
                            <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-secondary btn-sm">✕ Clear</a>
                        </c:if>
                    </form>
                </div>

                <div class="table-responsive">
                    <c:choose>
                        <c:when test="${empty reservations}">
                            <div class="empty-state">
                                <div class="empty-icon">📋</div>
                                <p style="font-size:1.1rem;font-weight:600;margin-bottom:6px;">No reservations found</p>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${not empty searchKeyword}">No results for "<strong>${searchKeyword}</strong>". Try a different search term.</c:when>
                                        <c:otherwise>No reservations yet. Click "New Reservation" to add one.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Reservation No.</th>
                                        <th>Guest Name</th>
                                        <th>Contact</th>
                                        <th>Room Type</th>
                                        <th>Check-In</th>
                                        <th>Check-Out</th>
                                        <th>Nights</th>
                                        <th>Total (LKR)</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="res" items="${reservations}" varStatus="loop">
                                    <tr>
                                        <td class="text-muted">${loop.index + 1}</td>
                                        <td><strong>${res.reservationNumber}</strong></td>
                                        <td>${res.guestName}</td>
                                        <td>${res.contactNumber}</td>
                                        <td>${res.roomType}</td>
                                        <td><fmt:formatDate value="${res.checkInDate}" pattern="dd MMM yyyy"/></td>
                                        <td><fmt:formatDate value="${res.checkOutDate}" pattern="dd MMM yyyy"/></td>
                                        <td class="text-center">${res.numNights}</td>
                                        <td><strong><fmt:formatNumber value="${res.totalAmount}" pattern="#,##0.00"/></strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${res.status == 'Confirmed'}">
                                                    <span class="badge badge-confirmed">Confirmed</span>
                                                </c:when>
                                                <c:when test="${res.status == 'Checked-In'}">
                                                    <span class="badge badge-checkedin">Checked-In</span>
                                                </c:when>
                                                <c:when test="${res.status == 'Checked-Out'}">
                                                    <span class="badge badge-checkedout">Checked-Out</span>
                                                </c:when>
                                                <c:when test="${res.status == 'Cancelled'}">
                                                    <span class="badge badge-cancelled">Cancelled</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/reservations?action=view&resNum=${res.reservationNumber}"
                                                   class="btn btn-outline btn-sm" title="View Details">👁</a>
                                                <a href="${pageContext.request.contextPath}/admin/reservations?action=bill&resNum=${res.reservationNumber}"
                                                   class="btn btn-warning btn-sm" title="Generate Bill">🧾</a>
                                                <c:if test="${res.status == 'Confirmed'}">
                                                    <a href="${pageContext.request.contextPath}/admin/reservations?action=checkin&resNum=${res.reservationNumber}"
                                                       class="btn btn-success btn-sm"
                                                       onclick="return confirm('Mark as Checked-In?')" title="Check In">✅</a>
                                                    <a href="${pageContext.request.contextPath}/admin/reservations?action=cancel&resNum=${res.reservationNumber}"
                                                       class="btn btn-danger btn-sm"
                                                       onclick="return confirm('Cancel this reservation?')" title="Cancel">✕</a>
                                                </c:if>
                                                <c:if test="${res.status == 'Checked-In'}">
                                                    <a href="${pageContext.request.contextPath}/admin/reservations?action=checkout&resNum=${res.reservationNumber}"
                                                       class="btn btn-secondary btn-sm"
                                                       onclick="return confirm('Mark as Checked-Out?')" title="Check Out">🛫</a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </div>
</div>
</body>
</html>
