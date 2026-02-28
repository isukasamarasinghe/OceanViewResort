package com.oceanview.util;

import com.oceanview.model.AdminUser;

import javax.servlet.http.*;
import java.io.IOException;

public class RoleUtil {

    // Redirect with 403 message if user doesn't have permission
    public static boolean requirePermission(
            HttpServletRequest req,
            HttpServletResponse resp,
            boolean permitted) throws IOException {

        if (!permitted) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You don't have permission to perform this action.");
            return false;
        }
        return true;
    }

    // Get the logged-in user from session safely
    public static AdminUser getCurrentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (AdminUser) session.getAttribute("adminUser");
    }
}