<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.AdminUser" %>
<%
    AdminUser currentUser = (AdminUser) session.getAttribute("adminUser");
    String ctx = request.getContextPath();
    String uri = request.getRequestURI();
%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon">🌊</div>
        <div>
            <h2>Ocean View</h2>
            <span>Resort &amp; Hotel, Galle</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section">Main Menu</div>

        <a href="<%=ctx%>/admin/dashboard"
           class="nav-item <%=uri.contains("dashboard")?"active":""%>">
            <span class="nav-icon">📊</span> Dashboard
        </a>

        <a href="<%=ctx%>/admin/reservations?action=add"
           class="nav-item <%=uri.contains("add")?"active":""%>">
            <span class="nav-icon">➕</span> New Reservation
        </a>

        <a href="<%=ctx%>/admin/reservations"
           class="nav-item <%=uri.contains("reservations") && !uri.contains("add")?"active":""%>">
            <span class="nav-icon">📋</span> All Reservations
        </a>

        <div class="nav-section" style="margin-top:12px;">Reports</div>

        <a href="<%=ctx%>/admin/reservations?filter=today"
           class="nav-item">
            <span class="nav-icon">📅</span> Today's Activity
        </a>

        <div class="nav-section" style="margin-top:12px;">Support</div>

        <a href="<%=ctx%>/admin/help"
           class="nav-item <%=uri.contains("help")?"active":""%>">
            <span class="nav-icon">❓</span> Help &amp; Guide
        </a>

        <a href="<%=ctx%>/logout"
           class="nav-item"
           onclick="return confirm('Are you sure you want to log out?')">
            <span class="nav-icon">🚪</span> Logout
        </a>
    </nav>

    <div class="sidebar-user">
        <div class="user-avatar"><%=currentUser != null ? currentUser.getFullName().charAt(0) : "A"%></div>
        <div class="user-info">
            <strong><%=currentUser != null ? currentUser.getFullName() : "Admin"%></strong>
            <span>Administrator</span>
        </div>
    </div>
</aside>
