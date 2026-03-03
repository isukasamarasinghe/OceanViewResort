<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Reservation – Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <div class="main-content">
        <div class="topbar">
            <h3>➕ New Reservation</h3>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-secondary btn-sm">← Back to List</a>
            </div>
        </div>

        <div class="page-content">

            <c:if test="${not empty error}">
                <div class="alert alert-danger">⚠️ ${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    📋 Guest & Booking Information
                    <span style="font-size:.85rem;font-weight:400;color:#64748b;">
                        Reservation No: <strong>${newResNum}</strong>
                    </span>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/reservations" id="reservationForm">
                        <input type="hidden" name="reservationNumber" value="${newResNum}">

                        <!-- Section: Guest Details -->
                        <h4 style="font-size:.9rem;font-weight:700;color:#0369a1;margin-bottom:16px;text-transform:uppercase;letter-spacing:.5px;">👤 Guest Information</h4>
                        <div class="form-grid">
                            <div class="field">
                                <label class="required">Guest Full Name</label>
                                <input type="text" name="guestName" placeholder="e.g. Kasun Perera" required maxlength="100">
                            </div>
                            <div class="field">
                                <label class="required">Contact Number</label>
                                <input type="tel" name="contactNumber" placeholder="e.g. +94 77 123 4567" required maxlength="20">
                            </div>
                            <div class="field">
                                <label>Email Address</label>
                                <input type="email" name="email" placeholder="e.g. guest@email.com" maxlength="100">
                            </div>
                            <div class="field">
                                <label class="required">Number of Guests</label>
                                <select name="numGuests" required>
                                    <option value="1">1 Guest</option>
                                    <option value="2" selected>2 Guests</option>
                                    <option value="3">3 Guests</option>
                                    <option value="4">4 Guests</option>
                                </select>
                            </div>
                            <div class="field" style="grid-column:1/-1;">
                                <label class="required">Home Address</label>
                                <textarea name="address" placeholder="Full home address of the guest" required rows="2"></textarea>
                            </div>
                        </div>

                        <hr class="divider">

                        <!-- Section: Booking Details -->
                        <h4 style="font-size:.9rem;font-weight:700;color:#0369a1;margin-bottom:16px;text-transform:uppercase;letter-spacing:.5px;">🛏️ Booking Details</h4>
                        <div class="form-grid">
                            <div class="field">
                                <label class="required">Room Type</label>
                                <select name="roomType" id="roomType" required onchange="updatePrice()">
                                    <option value="">-- Select Room Type --</option>
                                    <c:forEach var="rt" items="${roomTypes}">
                                        <option value="${rt.typeName}"
                                                data-price="${rt.pricePerNight}"
                                                data-desc="${rt.description}">
                                            ${rt.typeName} – LKR <fmt:formatNumber value="${rt.pricePerNight}" pattern="#,##0"/>/night
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="hint" id="roomDesc" style="color:#0369a1; font-style:italic;"></div>
                            </div>
                            <div class="field">
                                <label>Price Per Night (LKR)</label>
                                <input type="text" id="priceDisplay" readonly style="background:#f8fafc;font-weight:600;" placeholder="Select room type first">
                            </div>
                            <div class="field">
                                <label class="required">Check-In Date</label>
                                <input type="date" name="checkInDate" id="checkInDate" required
                                       min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>"
                                       onchange="calculateTotal()">
                            </div>
                            <div class="field">
                                <label class="required">Check-Out Date</label>
                                <input type="date" name="checkOutDate" id="checkOutDate" required
                                       min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>"
                                       onchange="calculateTotal()">
                            </div>
                        </div>

                        <!-- Computed Summary -->
                        <div id="summaryBox" style="display:none; background:#f0f9ff; border:1.5px solid #bae6fd; border-radius:10px; padding:18px; margin-top:16px;">
                            <h4 style="font-size:.88rem;font-weight:700;color:#0369a1;margin-bottom:10px;">📊 Booking Summary</h4>
                            <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;">
                                <div><label style="font-size:.75rem;color:#64748b;font-weight:600;text-transform:uppercase;">Nights</label>
                                    <div id="summNights" style="font-size:1.3rem;font-weight:700;color:#0c1a2e;"></div></div>
                                <div><label style="font-size:.75rem;color:#64748b;font-weight:600;text-transform:uppercase;">Rate/Night</label>
                                    <div id="summRate" style="font-size:1.3rem;font-weight:700;color:#0c1a2e;"></div></div>
                                <div><label style="font-size:.75rem;color:#64748b;font-weight:600;text-transform:uppercase;">Est. Total (incl. 10% tax)</label>
                                    <div id="summTotal" style="font-size:1.3rem;font-weight:700;color:#0d9488;"></div></div>
                            </div>
                        </div>

                        <div class="field" style="margin-top:16px;">
                            <label>Special Requests</label>
                            <textarea name="specialRequests" placeholder="Early check-in, extra pillows, dietary requirements, etc." rows="3"></textarea>
                        </div>

                        <hr class="divider">

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary" onclick="return validateForm()">
                                ✅ Confirm Reservation
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
let currentPrice = 0;

function updatePrice() {
    const sel = document.getElementById('roomType');
    const opt = sel.options[sel.selectedIndex];
    currentPrice = parseFloat(opt.getAttribute('data-price')) || 0;
    const desc   = opt.getAttribute('data-desc') || '';
    document.getElementById('priceDisplay').value = currentPrice > 0
        ? 'LKR ' + currentPrice.toLocaleString('en-LK', {minimumFractionDigits:2})
        : '';
    document.getElementById('roomDesc').textContent = desc;
    calculateTotal();
}

function calculateTotal() {
    const ci = document.getElementById('checkInDate').value;
    const co = document.getElementById('checkOutDate').value;
    if (!ci || !co || currentPrice === 0) {
        document.getElementById('summaryBox').style.display = 'none';
        return;
    }
    const d1 = new Date(ci), d2 = new Date(co);
    const nights = Math.round((d2 - d1) / 86400000);
    if (nights <= 0) {
        alert('Check-out date must be after check-in date.');
        document.getElementById('checkOutDate').value = '';
        document.getElementById('summaryBox').style.display = 'none';
        return;
    }
    const subtotal = currentPrice * nights;
    const tax      = subtotal * 0.10;
    const total    = subtotal + tax;
    document.getElementById('summNights').textContent  = nights + ' night' + (nights > 1 ? 's' : '');
    document.getElementById('summRate').textContent    = 'LKR ' + currentPrice.toLocaleString('en-LK', {minimumFractionDigits:2});
    document.getElementById('summTotal').textContent   = 'LKR ' + total.toLocaleString('en-LK', {minimumFractionDigits:2});
    document.getElementById('summaryBox').style.display = 'block';
}

function validateForm() {
    const ci = new Date(document.getElementById('checkInDate').value);
    const co = new Date(document.getElementById('checkOutDate').value);
    if (co <= ci) {
        alert('Check-out date must be after check-in date!');
        return false;
    }
    return true;
}
</script>
</body>
</html>
