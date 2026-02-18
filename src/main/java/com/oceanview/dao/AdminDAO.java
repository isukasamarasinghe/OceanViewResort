package com.oceanview.dao;

import com.oceanview.model.AdminUser;
import com.oceanview.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;

public class AdminDAO {

    public AdminUser authenticate(String username, String password) throws SQLException {
        String sql = "SELECT * FROM admin_users WHERE username = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                if (BCrypt.checkpw(password, storedHash)) {
                    AdminUser user = new AdminUser();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));       // ✅ set role
                    user.setActive(rs.getBoolean("is_active"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean changePassword(int adminId, String oldPassword, String newPassword) throws SQLException {
        // Step 1 — Fetch the stored hash for this admin (never compare raw password in SQL)
        String fetchSql = "SELECT password FROM admin_users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(fetchSql)) {

            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) return false; // admin ID not found

            String storedHash = rs.getString("password");

            // Step 2 — Verify the old password matches the stored hash
            if (!BCrypt.checkpw(oldPassword, storedHash)) {
                return false; // old password is wrong
            }
        }

        // Step 3 — Hash the new password before saving it
        String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

        String updateSql = "UPDATE admin_users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {

            ps.setString(1, newHash);
            ps.setInt(2, adminId);
            return ps.executeUpdate() > 0;
        }
    }
}