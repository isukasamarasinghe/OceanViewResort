-- ============================================================
-- Ocean View Resort - Database Setup Script
-- Run this in SQL Server Management Studio (SSMS)
-- ============================================================

-- Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'OceanViewResort')
BEGIN
    CREATE DATABASE OceanViewResort;
END
GO

USE OceanViewResort;
GO

-- ============================================================
-- Admin Users Table
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='admin_users' AND xtype='U')
BEGIN
    CREATE TABLE admin_users (
        id          INT IDENTITY(1,1) PRIMARY KEY,
        username    VARCHAR(50)  NOT NULL UNIQUE,
        password    VARCHAR(255) NOT NULL,  -- Store hashed passwords in production
        full_name   VARCHAR(100) NOT NULL,
        email       VARCHAR(100),
        created_at  DATETIME DEFAULT GETDATE(),
        is_active   BIT DEFAULT 1
    );
END
GO

-- ============================================================
-- Room Types Table
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='room_types' AND xtype='U')
BEGIN
    CREATE TABLE room_types (
        id              INT IDENTITY(1,1) PRIMARY KEY,
        type_name       VARCHAR(50)    NOT NULL UNIQUE,
        description     VARCHAR(255),
        price_per_night DECIMAL(10, 2) NOT NULL,
        max_guests      INT DEFAULT 2
    );
END
GO

-- ============================================================
-- Rooms Table
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rooms' AND xtype='U')
BEGIN
    CREATE TABLE rooms (
        id              INT IDENTITY(1,1) PRIMARY KEY,
        room_number     VARCHAR(10)  NOT NULL UNIQUE,
        room_type_id    INT NOT NULL,
        floor           INT,
        status          VARCHAR(20) DEFAULT 'Available', -- Available, Occupied, Maintenance
        FOREIGN KEY (room_type_id) REFERENCES room_types(id)
    );
END
GO

-- ============================================================
-- Guests Table
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='guests' AND xtype='U')
BEGIN
    CREATE TABLE guests (
        id              INT IDENTITY(1,1) PRIMARY KEY,
        guest_name      VARCHAR(100) NOT NULL,
        address         VARCHAR(255) NOT NULL,
        contact_number  VARCHAR(20)  NOT NULL,
        email           VARCHAR(100),
        id_type         VARCHAR(50),
        id_number       VARCHAR(50),
        created_at      DATETIME DEFAULT GETDATE()
    );
END
GO

-- ============================================================
-- Reservations Table
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='reservations' AND xtype='U')
BEGIN
    CREATE TABLE reservations (
        id                  INT IDENTITY(1,1) PRIMARY KEY,
        reservation_number  VARCHAR(20)    NOT NULL UNIQUE,
        guest_id            INT            NOT NULL,
        room_type           VARCHAR(50)    NOT NULL,
        room_number         VARCHAR(10),
        check_in_date       DATE           NOT NULL,
        check_out_date      DATE           NOT NULL,
        num_guests          INT DEFAULT 1,
        special_requests    VARCHAR(500),
        status              VARCHAR(20) DEFAULT 'Confirmed', -- Confirmed, Checked-In, Checked-Out, Cancelled
        total_amount        DECIMAL(10, 2),
        amount_paid         DECIMAL(10, 2) DEFAULT 0,
        payment_status      VARCHAR(20) DEFAULT 'Pending',  -- Pending, Partial, Paid
        created_by          INT,
        created_at          DATETIME DEFAULT GETDATE(),
        updated_at          DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (guest_id) REFERENCES guests(id),
        FOREIGN KEY (created_by) REFERENCES admin_users(id)
    );
END
GO

-- ============================================================
-- Billing Table
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='billing' AND xtype='U')
BEGIN
    CREATE TABLE billing (
        id                  INT IDENTITY(1,1) PRIMARY KEY,
        reservation_id      INT            NOT NULL,
        bill_number         VARCHAR(20)    NOT NULL UNIQUE,
        room_charges        DECIMAL(10, 2) DEFAULT 0,
        tax_amount          DECIMAL(10, 2) DEFAULT 0,
        discount_amount     DECIMAL(10, 2) DEFAULT 0,
        total_amount        DECIMAL(10, 2) NOT NULL,
        payment_method      VARCHAR(50),   -- Cash, Card, Bank Transfer
        payment_date        DATETIME,
        notes               VARCHAR(500),
        generated_by        INT,
        generated_at        DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (reservation_id) REFERENCES reservations(id),
        FOREIGN KEY (generated_by) REFERENCES admin_users(id)
    );
END
GO

-- ============================================================
-- Seed Data - Room Types
-- ============================================================
IF NOT EXISTS (SELECT * FROM room_types WHERE type_name = 'Standard')
BEGIN
    INSERT INTO room_types (type_name, description, price_per_night, max_guests) VALUES
    ('Standard',    'Comfortable room with garden view, queen bed, AC, TV, Wi-Fi',          8500.00,  2),
    ('Deluxe',      'Spacious room with partial ocean view, king bed, AC, TV, minibar',     12500.00, 2),
    ('Ocean View',  'Premium room with full ocean view, king bed, AC, TV, minibar, balcony',18000.00, 2),
    ('Suite',       'Luxury suite with panoramic ocean view, living area, jacuzzi',         28000.00, 3),
    ('Family Room', 'Large family room with 2 bedrooms, garden view, AC, TV, Wi-Fi',        15000.00, 4);
END
GO

-- ============================================================
-- Seed Data - Rooms
-- ============================================================
IF NOT EXISTS (SELECT * FROM rooms WHERE room_number = '101')
BEGIN
    INSERT INTO rooms (room_number, room_type_id, floor, status) VALUES
    -- Floor 1 - Standard
    ('101', 1, 1, 'Available'), ('102', 1, 1, 'Available'), ('103', 1, 1, 'Available'),
    ('104', 1, 1, 'Available'), ('105', 2, 1, 'Available'),
    -- Floor 2 - Deluxe
    ('201', 2, 2, 'Available'), ('202', 2, 2, 'Available'), ('203', 2, 2, 'Available'),
    ('204', 3, 2, 'Available'), ('205', 3, 2, 'Available'),
    -- Floor 3 - Ocean View & Suites
    ('301', 3, 3, 'Available'), ('302', 3, 3, 'Available'), ('303', 4, 3, 'Available'),
    ('304', 4, 3, 'Available'),
    -- Family Rooms
    ('401', 5, 4, 'Available'), ('402', 5, 4, 'Available');
END
GO

-- ============================================================
-- Seed Data - Admin User
-- Default: admin / admin123 (change in production!)
-- ============================================================
IF NOT EXISTS (SELECT * FROM admin_users WHERE username = 'admin')
BEGIN
    INSERT INTO admin_users (username, password, full_name, email) VALUES
    ('admin',   'admin123',   'System Administrator', 'admin@oceanviewresort.lk'),
    ('manager', 'manager123', 'Resort Manager',       'manager@oceanviewresort.lk'),
    ('staff',   'staff123',   'Front Desk Staff',     'staff@oceanviewresort.lk');
END
GO

-- ============================================================
-- Useful Views
-- ============================================================

-- Reservation Summary View
IF OBJECT_ID('vw_reservation_summary', 'V') IS NOT NULL
    DROP VIEW vw_reservation_summary;
GO

CREATE VIEW vw_reservation_summary AS
SELECT
    r.id,
    r.reservation_number,
    g.guest_name,
    g.contact_number,
    g.email,
    g.address,
    r.room_type,
    r.room_number,
    r.check_in_date,
    r.check_out_date,
    DATEDIFF(day, r.check_in_date, r.check_out_date) AS num_nights,
    r.num_guests,
    r.status,
    r.total_amount,
    r.payment_status,
    r.special_requests,
    r.created_at,
    a.full_name AS created_by_name
FROM reservations r
INNER JOIN guests g ON r.guest_id = g.id
LEFT JOIN admin_users a ON r.created_by = a.id;
GO

PRINT 'Ocean View Resort database setup completed successfully!';
GO
