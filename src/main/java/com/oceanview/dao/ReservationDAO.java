package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.model.RoomType;
import com.oceanview.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // ── Generate unique reservation number ────────────────────────────────────
    public String generateReservationNumber() throws SQLException {
        String prefix = "OVR-" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "-";
        String sql = "SELECT COUNT(*) FROM reservations WHERE reservation_number LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();
            int count = rs.next() ? rs.getInt(1) : 0;
            return prefix + String.format("%03d", count + 1);
        }
    }

    // ── Add new reservation (with guest) ─────────────────────────────────────
    public boolean addReservation(Reservation r, int adminId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        try {
            conn.setAutoCommit(false);

            // 1. Insert guest
            String guestSql = "INSERT INTO guests (guest_name, address, contact_number, email) " +
                              "OUTPUT INSERTED.id VALUES (?, ?, ?, ?)";
            int guestId;
            try (PreparedStatement ps = conn.prepareStatement(guestSql)) {
                ps.setString(1, r.getGuestName());
                ps.setString(2, r.getAddress());
                ps.setString(3, r.getContactNumber());
                ps.setString(4, r.getEmail() != null ? r.getEmail() : "");
                ResultSet rs = ps.executeQuery();
                guestId = rs.next() ? rs.getInt(1) : -1;
                if (guestId == -1) throw new SQLException("Failed to insert guest.");
            }

            // 2. Calculate total amount
            BigDecimal pricePerNight = getRoomTypePrice(r.getRoomType(), conn);
            long nights = java.time.temporal.ChronoUnit.DAYS.between(
                    r.getCheckInDate().toLocalDate(), r.getCheckOutDate().toLocalDate());
            BigDecimal total = pricePerNight.multiply(BigDecimal.valueOf(nights));

            // 3. Insert reservation
            String resSql = "INSERT INTO reservations " +
                "(reservation_number, guest_id, room_type, check_in_date, check_out_date, " +
                "num_guests, special_requests, total_amount, created_by) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(resSql)) {
                ps.setString(1, r.getReservationNumber());
                ps.setInt(2, guestId);
                ps.setString(3, r.getRoomType());
                ps.setDate(4, r.getCheckInDate());
                ps.setDate(5, r.getCheckOutDate());
                ps.setInt(6, r.getNumGuests() > 0 ? r.getNumGuests() : 1);
                ps.setString(7, r.getSpecialRequests());
                ps.setBigDecimal(8, total);
                ps.setInt(9, adminId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    // ── Get single reservation ────────────────────────────────────────────────
    public Reservation getByReservationNumber(String resNum) throws SQLException {
        String sql = "SELECT * FROM vw_reservation_summary WHERE reservation_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, resNum);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ── Get all reservations ──────────────────────────────────────────────────
    public List<Reservation> getAllReservations() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM vw_reservation_summary ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Search reservations ───────────────────────────────────────────────────
    public List<Reservation> searchReservations(String keyword) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM vw_reservation_summary " +
                     "WHERE reservation_number LIKE ? OR guest_name LIKE ? OR contact_number LIKE ? " +
                     "ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k); ps.setString(3, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Update reservation status ─────────────────────────────────────────────
    public boolean updateStatus(String resNum, String status) throws SQLException {
        String sql = "UPDATE reservations SET status = ?, updated_at = GETDATE() WHERE reservation_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, resNum);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Cancel reservation ────────────────────────────────────────────────────
    public boolean cancelReservation(String resNum) throws SQLException {
        return updateStatus(resNum, "Cancelled");
    }

    // ── Today's check-ins ─────────────────────────────────────────────────────
    public List<Reservation> getTodayCheckIns() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM vw_reservation_summary WHERE check_in_date = CAST(GETDATE() AS DATE) " +
                     "AND status = 'Confirmed' ORDER BY guest_name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Today's check-outs ────────────────────────────────────────────────────
    public List<Reservation> getTodayCheckOuts() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM vw_reservation_summary WHERE check_out_date = CAST(GETDATE() AS DATE) " +
                     "AND status = 'Checked-In' ORDER BY guest_name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ── Dashboard stats ───────────────────────────────────────────────────────
    public int getTotalReservations() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status != 'Cancelled'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getTodayCheckInCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE check_in_date = CAST(GETDATE() AS DATE) AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "Confirmed");
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getTodayCheckOutCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE check_out_date = CAST(GETDATE() AS DATE) AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "Checked-In");
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getCurrentGuestsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "Checked-In");
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }



    // ── Room type prices ──────────────────────────────────────────────────────
    public List<RoomType> getAllRoomTypes() throws SQLException {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY price_per_night";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getInt("id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setDescription(rs.getString("description"));
                rt.setPricePerNight(rs.getBigDecimal("price_per_night"));
                rt.setMaxGuests(rs.getInt("max_guests"));
                list.add(rt);
            }
        }
        return list;
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private BigDecimal getRoomTypePrice(String typeName, Connection conn) throws SQLException {
        String sql = "SELECT price_per_night FROM room_types WHERE type_name = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, typeName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBigDecimal("price_per_night");
        }
        return BigDecimal.ZERO;
    }

    private int getCount(String sql) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private Reservation mapRow(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setReservationNumber(rs.getString("reservation_number"));
        r.setGuestName(rs.getString("guest_name"));
        r.setContactNumber(rs.getString("contact_number"));
        r.setEmail(rs.getString("email"));
        r.setAddress(rs.getString("address"));
        r.setRoomType(rs.getString("room_type"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setCheckInDate(rs.getDate("check_in_date"));
        r.setCheckOutDate(rs.getDate("check_out_date"));
        r.setNumNights(rs.getInt("num_nights"));
        r.setNumGuests(rs.getInt("num_guests"));
        r.setStatus(rs.getString("status"));
        r.setTotalAmount(rs.getBigDecimal("total_amount"));
        r.setPaymentStatus(rs.getString("payment_status"));
        r.setSpecialRequests(rs.getString("special_requests"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        try { r.setCreatedByName(rs.getString("created_by_name")); } catch (Exception ignored) {}
        return r;
    }
}
