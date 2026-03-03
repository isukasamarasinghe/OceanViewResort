<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <div class="main-content">
        <div class="topbar">
            <h3>📊 Dashboard</h3>
            <div class="topbar-actions">
                <span class="text-muted">
                    <fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, dd MMMM yyyy"/>
                </span>
                <a href="${pageContext.request.contextPath}/admin/reservations?action=add" class="btn btn-primary btn-sm">
                    ➕ New Reservation
                </a>
            </div>
        </div>

        <div class="page-content">

            <c:if test="${not empty dbError}">
                <div class="alert alert-danger">⚠️ Database error: ${dbError}</div>
            </c:if>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">📋</div>
                    <div>
                        <div class="stat-value">${totalReservations}</div>
                        <div class="stat-label">Total Reservations</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">🛬</div>
                    <div>
                        <div class="stat-value">${todayCheckIns}</div>
                        <div class="stat-label">Today's Check-Ins</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">🛫</div>
                    <div>
                        <div class="stat-value">${todayCheckOuts}</div>
                        <div class="stat-label">Today's Check-Outs</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon teal">🏨</div>
                    <div>
                        <div class="stat-value">${currentGuests}</div>
                        <div class="stat-label">Current Guests</div>
                    </div>
                </div>
            </div>

            <!-- Today's Check-Ins -->
            <div class="card mb-4">
                <div class="card-header">
                    🛬 Today's Expected Check-Ins
                    <span class="badge badge-confirmed">${fn:length(checkInList)} guests</span>
                </div>
                <div class="table-responsive">
                    <c:choose>
                        <c:when test="${empty checkInList}">
                            <div class="empty-state">
                                <div class="empty-icon">✅</div>
                                <p>No check-ins scheduled for today.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Reservation #</th>
                                        <th>Guest Name</th>
                                        <th>Contact</th>
                                        <th>Room Type</th>
                                        <th>Check-Out</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="res" items="${checkInList}">
                                    <tr>
                                        <td><strong>${res.reservationNumber}</strong></td>
                                        <td>${res.guestName}</td>
                                        <td>${res.contactNumber}</td>
                                        <td>${res.roomType}</td>
                                        <td><fmt:formatDate value="${res.checkOutDate}" pattern="dd MMM yyyy"/></td>
                                        <td><span class="badge badge-confirmed">${res.status}</span></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/reservations?action=checkin&resNum=${res.reservationNumber}"
                                               class="btn btn-success btn-sm"
                                               onclick="return confirm('Mark as Checked-In?')">✅ Check-In</a>
                                            <a href="${pageContext.request.contextPath}/admin/reservations?action=view&resNum=${res.reservationNumber}"
                                               class="btn btn-outline btn-sm">👁</a>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Today's Check-Outs -->
            <div class="card">
                <div class="card-header">
                    🛫 Today's Expected Check-Outs
                    <span class="badge badge-checkedin">${fn:length(checkOutList)} guests</span>
                </div>
                <div class="table-responsive">
                    <c:choose>
                        <c:when test="${empty checkOutList}">
                            <div class="empty-state">
                                <div class="empty-icon">✅</div>
                                <p>No check-outs scheduled for today.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Reservation #</th>
                                        <th>Guest Name</th>
                                        <th>Room Type</th>
                                        <th>Total Bill</th>
                                        <th>Payment</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="res" items="${checkOutList}">
                                    <tr>
                                        <td><strong>${res.reservationNumber}</strong></td>
                                        <td>${res.guestName}</td>
                                        <td>${res.roomType}</td>
                                        <td><strong>LKR <fmt:formatNumber value="${res.totalAmount}" pattern="#,##0.00"/></strong></td>
                                        <td><span class="badge badge-pending">${res.paymentStatus}</span></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/reservations?action=bill&resNum=${res.reservationNumber}"
                                               class="btn btn-warning btn-sm">🧾 Bill</a>
                                            <a href="${pageContext.request.contextPath}/admin/reservations?action=checkout&resNum=${res.reservationNumber}"
                                               class="btn btn-secondary btn-sm"
                                               onclick="return confirm('Mark as Checked-Out?')">🛫 Check-Out</a>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div><!-- /page-content -->
    </div><!-- /main-content -->
</div><!-- /admin-layout -->
</body>
</html>
