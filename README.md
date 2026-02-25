# 🌊 Ocean View Resort – Reservation Management System

A full Java web application for managing hotel reservations built with:
- **Java Servlets + JSP** (Java EE / Jakarta EE)
- **SQL Server** (via SSMS)
- **Apache Tomcat** (deployment)
- **IntelliJ IDEA** (development)
- **Maven** (build tool)

---

## 📁 Project Structure

```
OceanViewResort/
├── pom.xml                          ← Maven dependencies
├── database_setup.sql               ← Run this in SSMS first!
└── src/main/
    ├── java/com/oceanview/
    │   ├── model/        ← Data classes (Reservation, AdminUser, RoomType)
    │   ├── dao/          ← Database operations (ReservationDAO, AdminDAO)
    │   ├── servlet/      ← HTTP controllers (Login, Dashboard, Reservation, Help)
    │   └── util/         ← DBConnection
    └── webapp/
        ├── css/style.css            ← All styles
        ├── index.jsp                ← Redirects to login
        ├── login.jsp                ← Admin login page
        ├── WEB-INF/
        │   ├── web.xml
        │   └── sidebar.jsp          ← Shared navigation
        └── admin/
            ├── dashboard.jsp
            ├── add-reservation.jsp
            ├── reservations.jsp
            ├── view-reservation.jsp
            ├── bill.jsp
            ├── help.jsp
            └── error.jsp
```

---

## ⚙️ Setup Instructions

### Step 1 — Database Setup (SSMS)

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your SQL Server instance
3. Open `database_setup.sql`
4. Execute the entire script (F5)
5. Verify the `OceanViewResort` database was created with all tables

### Step 2 — Configure Database Connection

Edit `src/main/java/com/oceanview/util/DBConnection.java`:

```java
private static final String SERVER   = "localhost";     // Your SQL Server host
private static final String PORT     = "1433";           // Default SQL Server port
private static final String DATABASE = "OceanViewResort";
private static final String USERNAME = "sa";             // Your SQL username
private static final String PASSWORD = "YourPassword";   // Your SQL password
```

> **Windows Authentication**: If you use Windows Auth instead of SQL Server Auth,
> change the URL to:
> ```java
> private static final String URL =
>     "jdbc:sqlserver://localhost:1433;databaseName=OceanViewResort;"
>     + "integratedSecurity=true;trustServerCertificate=true;";
> ```
> And remove the USERNAME/PASSWORD from `getConnection()`.

### Step 3 — Open in IntelliJ IDEA

1. **File → Open** → Select the `OceanViewResort` folder
2. IntelliJ will detect Maven and import dependencies automatically
3. Wait for Maven sync to complete (check bottom progress bar)

### Step 4 — Configure Tomcat in IntelliJ

1. Go to **Run → Edit Configurations**
2. Click **+** → **Tomcat Server → Local**
3. Set **Application server** to your Tomcat installation
4. Go to **Deployment** tab → Click **+** → **Artifact**
5. Select `OceanViewResort:war exploded`
6. Set **Application context** to `/OceanViewResort`
7. Click **OK**

### Step 5 — Run the Application

1. Click the **▶ Run** button (or Shift+F10)
2. Tomcat will start and open the browser
3. Navigate to: `http://localhost:8080/OceanViewResort`

---

## 🔐 Default Login Credentials

| Username  | Password     | Role                   |
|-----------|--------------|------------------------|
| `admin`   | `admin123`   | System Administrator   |
| `manager` | `manager123` | Resort Manager         |
| `staff`   | `staff123`   | Front Desk Staff       |

> ⚠️ **Change these passwords immediately in production!**

---

## 🏨 Features

| Feature | Description |
|---------|-------------|
| **Admin Login** | Secure session-based authentication |
| **Dashboard** | Stats + today's check-ins/check-outs |
| **New Reservation** | Full guest registration with cost calculator |
| **View Reservation** | Complete booking details |
| **All Reservations** | Searchable list with status management |
| **Check-In/Out** | One-click status updates |
| **Cancel Reservation** | With confirmation prompt |
| **Generate Bill** | Printable invoice with tax calculation |
| **Help Section** | Staff guide for all operations |
| **Session Security** | Auto-expiry after 60 minutes |

---

## 💰 Room Rates

| Room Type   | Rate/Night (LKR) | Max Guests |
|-------------|-----------------|------------|
| Standard    | 8,500           | 2          |
| Deluxe      | 12,500          | 2          |
| Ocean View  | 18,000          | 2          |
| Suite       | 28,000          | 3          |
| Family Room | 15,000          | 4          |

*All rates subject to 10% government tax.*

---

## 🔧 Troubleshooting

**"SQL Server JDBC Driver not found"**
→ Run `mvn clean install` to download dependencies

**"Connection refused" on SQL Server**
→ Enable TCP/IP in SQL Server Configuration Manager
→ Ensure SQL Server Browser service is running
→ Check firewall allows port 1433

**"Login failed for user 'sa'"**
→ Enable SQL Server Authentication in SSMS:
  Right-click server → Properties → Security → SQL Server and Windows Authentication

**Pages show blank/404**
→ Check Application Context is `/OceanViewResort` in Tomcat config
→ Ensure war is deployed (check Tomcat Deployment tab in IntelliJ)
