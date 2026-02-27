package com.oceanview.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CsrfUtil {

    private static final String SESSION_KEY = "CSRF_TOKEN";
    private static final SecureRandom random = new SecureRandom();

    // Generate a token and store it in the session (or return existing one)
    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return "";

        String token = (String) session.getAttribute(SESSION_KEY);
        if (token == null) {
            byte[] bytes = new byte[32];
            random.nextBytes(bytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
            session.setAttribute(SESSION_KEY, token);
        }
        return token;
    }

    // Validate the token from the request against the session
    public static boolean isValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String sessionToken  = (String) session.getAttribute(SESSION_KEY);
        String requestToken  = request.getParameter("_csrf");

        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
