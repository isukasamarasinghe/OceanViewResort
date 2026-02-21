<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login – Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .login-footer { text-align:center; margin-top:24px; font-size:.82rem; color:#94a3b8; }
    </style>
</head>
<body class="login-body">

<div class="login-card">
    <div class="login-logo">
        <div class="logo-icon">🌊</div>
        <h1>Ocean View Resort</h1>
        <p>Galle, Sri Lanka &nbsp;·&nbsp; Admin Portal</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">⚠️ ${error}</div>
    <% } %>
    <% if ("loggedout".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success">✅ You have been logged out successfully.</div>
    <% } %>
    <% if ("sessionexpired".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-info">🔒 Your session expired. Please log in again.</div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="form-group">
            <label for="username">Username</label>
            <div class="input-icon">
                <span>👤</span>
                <input type="text" id="username" name="username" placeholder="Enter username" required autofocus>
            </div>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <div class="input-icon">
                <span>🔒</span>
                <input type="password" id="password" name="password" placeholder="Enter password" required>
            </div>
        </div>
        <button type="submit" class="btn btn-primary">🔐 Sign In to Admin Panel</button>
    </form>

    <div class="login-footer">

        <p style="margin-top:6px; color:#64748b;">Ocean View Resort &copy; 2024 – Reservation Management System</p>
    </div>
</div>

</body>
</html>
