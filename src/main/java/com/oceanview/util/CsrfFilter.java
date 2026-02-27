package com.oceanview.util;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class CsrfFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        String method = request.getMethod();
        String path   = request.getServletPath();

        // Only validate CSRF on POST — skip login page
        if ("POST".equalsIgnoreCase(method) && !path.equals("/login")) {
            if (!CsrfUtil.isValid(request)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Invalid or missing CSRF token. Please go back and try again.");
                return;
            }
        }

        // ✅ Always set _csrf token as request attribute for any logged-in user
        // This covers both direct loads AND redirects to the list page
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            request.setAttribute("_csrf", CsrfUtil.getToken(request));
        }

        chain.doFilter(req, res);
    }

    @Override public void init(FilterConfig f) {}
    @Override public void destroy() {}
}