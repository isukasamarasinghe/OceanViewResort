<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Guide – Ocean View Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/WEB-INF/sidebar.jsp"/>

    <div class="main-content">
        <div class="topbar">
            <h3>❓ Help & System Guide</h3>
        </div>

        <div class="page-content">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">

                <!-- Getting Started -->
                <div class="card">
                    <div class="card-header">🚀 Getting Started</div>
                    <div class="card-body">
                        <div class="help-section">
                            <div class="help-step">
                                <div class="step-num">1</div>
                                <div><strong>Login</strong><br>Access the system using your admin username and password. Contact the system administrator if you need credentials.</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">2</div>
                                <div><strong>Dashboard</strong><br>Your home screen shows today's check-ins, check-outs, and key statistics at a glance.</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">3</div>
                                <div><strong>Navigation</strong><br>Use the sidebar on the left to navigate between different sections of the system.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- New Reservation -->
                <div class="card">
                    <div class="card-header">➕ Creating a New Reservation</div>
                    <div class="card-body">
                        <div class="help-section">
                            <div class="help-step">
                                <div class="step-num">1</div>
                                <div>Click <strong>"New Reservation"</strong> in the sidebar or top button.</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">2</div>
                                <div>Fill in <strong>Guest Information</strong>: full name, contact number, email, home address, and number of guests.</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">3</div>
                                <div>Select the <strong>Room Type</strong>. The price per night will auto-fill. Available types: Standard, Deluxe, Ocean View, Suite, Family Room.</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">4</div>
                                <div>Enter <strong>Check-In</strong> and <strong>Check-Out</strong> dates. The system will automatically calculate the total cost including 10% tax.</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">5</div>
                                <div>Add any <strong>Special Requests</strong> (early check-in, dietary needs, etc.) and click <strong>"Confirm Reservation"</strong>.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Managing Reservations -->
                <div class="card">
                    <div class="card-header">📋 Managing Reservations</div>
                    <div class="card-body">
                        <div class="help-section">
                            <h3 style="font-size:.9rem;">🔍 Searching</h3>
                            <p style="font-size:.9rem;color:#374151;margin-bottom:16px;">Use the search box on the Reservations page to find bookings by guest name, reservation number, or phone number.</p>

                            <h3 style="font-size:.9rem;">✅ Check-In Process</h3>
                            <p style="font-size:.9rem;color:#374151;margin-bottom:16px;">Find the guest's reservation → Click the green ✅ Check-In button. The status changes to "Checked-In".</p>

                            <h3 style="font-size:.9rem;">🛫 Check-Out Process</h3>
                            <p style="font-size:.9rem;color:#374151;margin-bottom:16px;">Generate and print the bill → Collect payment → Click 🛫 Check-Out to update status to "Checked-Out".</p>

                            <h3 style="font-size:.9rem;">✕ Cancelling a Reservation</h3>
                            <p style="font-size:.9rem;color:#374151;">Only <em>Confirmed</em> reservations can be cancelled. Click the red ✕ button and confirm the action.</p>
                        </div>
                    </div>
                </div>

                <!-- Billing -->
                <div class="card">
                    <div class="card-header">🧾 Generating Bills</div>
                    <div class="card-body">
                        <div class="help-section">
                            <div class="help-step">
                                <div class="step-num">1</div>
                                <div>Open a reservation (from the list or dashboard).</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">2</div>
                                <div>Click <strong>"Generate Bill"</strong> or the 🧾 icon.</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">3</div>
                                <div>Review the invoice which includes: room charges, 10% government tax, and total amount due.</div>
                            </div>
                            <div class="help-step">
                                <div class="step-num">4</div>
                                <div>Click <strong>"Print This Invoice"</strong> to print or save as PDF. Sidebar and navigation are hidden automatically when printing.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Room Types -->
                <div class="card">
                    <div class="card-header">🛏️ Room Types & Rates</div>
                    <div class="card-body">
                        <table style="width:100%;font-size:.9rem;border-collapse:collapse;">
                            <thead>
                                <tr style="background:#f8fafc;">
                                    <th style="padding:10px;text-align:left;border-bottom:1px solid #e2e8f0;">Room Type</th>
                                    <th style="padding:10px;text-align:left;border-bottom:1px solid #e2e8f0;">Rate/Night</th>
                                    <th style="padding:10px;text-align:left;border-bottom:1px solid #e2e8f0;">Max Guests</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr><td style="padding:10px;border-bottom:1px solid #f1f5f9;">Standard</td><td style="padding:10px;border-bottom:1px solid #f1f5f9;">LKR 8,500</td><td style="padding:10px;border-bottom:1px solid #f1f5f9;">2</td></tr>
                                <tr><td style="padding:10px;border-bottom:1px solid #f1f5f9;">Deluxe</td><td style="padding:10px;border-bottom:1px solid #f1f5f9;">LKR 12,500</td><td style="padding:10px;border-bottom:1px solid #f1f5f9;">2</td></tr>
                                <tr><td style="padding:10px;border-bottom:1px solid #f1f5f9;">Ocean View</td><td style="padding:10px;border-bottom:1px solid #f1f5f9;">LKR 18,000</td><td style="padding:10px;border-bottom:1px solid #f1f5f9;">2</td></tr>
                                <tr><td style="padding:10px;border-bottom:1px solid #f1f5f9;">Suite</td><td style="padding:10px;border-bottom:1px solid #f1f5f9;">LKR 28,000</td><td style="padding:10px;border-bottom:1px solid #f1f5f9;">3</td></tr>
                                <tr><td style="padding:10px;">Family Room</td><td style="padding:10px;">LKR 15,000</td><td style="padding:10px;">4</td></tr>
                            </tbody>
                        </table>
                        <p class="text-muted" style="margin-top:12px;">All rates exclude 10% government tax. Rates are subject to change.</p>
                    </div>
                </div>

                <!-- Tips -->
                <div class="card">
                    <div class="card-header">💡 Tips & Best Practices</div>
                    <div class="card-body">
                        <div class="help-step">
                            <div class="step-num">💡</div>
                            <div>Always verify guest ID documents before confirming check-in.</div>
                        </div>
                        <div class="help-step">
                            <div class="step-num">💡</div>
                            <div>Print the bill <em>before</em> checking out the guest to ensure all charges are correct.</div>
                        </div>
                        <div class="help-step">
                            <div class="step-num">💡</div>
                            <div>Use the Dashboard to quickly see who is checking in/out today without searching.</div>
                        </div>
                        <div class="help-step">
                            <div class="step-num">💡</div>
                            <div>Log out when leaving the desk to keep guest data secure.</div>
                        </div>
                        <div class="help-step">
                            <div class="step-num">💡</div>
                            <div>Contact your system administrator to reset your password or for technical issues.</div>
                        </div>
                    </div>
                </div>

            </div><!-- /grid -->

            <div class="card mt-3" style="margin-top:24px;">
                <div class="card-body text-center">
                    <p style="font-size:1rem;font-weight:600;margin-bottom:6px;">🌊 Ocean View Resort Reservation System</p>
                    <p class="text-muted">For technical support, contact: <strong>it@oceanviewresort.lk</strong> | Version 1.0.0</p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
