<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>404 – Page Not Found</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>body{display:flex;align-items:center;justify-content:center;min-height:100vh;background:#f0f4f8;}</style>
</head>
<body>
    <div style="text-align:center;">
        <div style="font-size:6rem;">🌊</div>
        <h1 style="font-size:3rem;font-weight:900;color:#0c1a2e;margin:12px 0;">404</h1>
        <p style="font-size:1.2rem;color:#64748b;margin-bottom:24px;">Page not found. The page you're looking for doesn't exist.</p>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">← Go to Dashboard</a>
    </div>
</body>
</html>
