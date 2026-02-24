<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error – Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/WEB-INF/sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar"><h3>⚠️ System Error</h3></div>
        <div class="page-content">
            <div class="card">
                <div class="empty-state">
                    <div class="empty-icon">⚠️</div>
                    <p style="font-size:1.1rem;font-weight:600;margin-bottom:8px;">An error occurred</p>
                    <p class="text-muted">${error}</p>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary" style="margin-top:16px;">
                        ← Return to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
