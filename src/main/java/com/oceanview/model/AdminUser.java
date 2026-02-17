package com.oceanview.model;

public class AdminUser {
    private int id;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role;        // ✅ added
    private boolean active;

    public AdminUser() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    // ✅ Convenience helpers used by servlets and JSPs
    public boolean isAdmin()   { return "System Administrator".equals(role); }
    public boolean isManager() { return "Resort Manager".equals(role); }
    public boolean isStaff()   { return "Front Desk Staff".equals(role); }

    // Can add new reservations: admin and manager only
    public boolean canAddReservation()    { return isAdmin() || isManager(); }
    // Can cancel reservations: admin only
    public boolean canCancelReservation() { return isAdmin(); }
    // Can generate bills: admin and manager only
    public boolean canGenerateBill()      { return isAdmin() || isManager(); }
    // Can check in/out: all roles
    public boolean canCheckInOut()        { return true; }
}