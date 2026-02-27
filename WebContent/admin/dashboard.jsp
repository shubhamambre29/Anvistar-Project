<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, com.dxsure.dao.DBConnection" %>
<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // Live counts from database
    int totalUsers = 0, totalClients = 0, totalVendors = 0,
        openTickets = 0, pendingPayments = 0;
    double totalRevenue = 0.0;

    Connection _conn = null;
    try {
        _conn = DBConnection.getConnection();
        if (_conn != null) {
            String[][] queries = {
                {"SELECT COUNT(*) FROM users    WHERE is_active = 1"},
                {"SELECT COUNT(*) FROM clients  WHERE is_active = 1"},
                {"SELECT COUNT(*) FROM vendors  WHERE is_active = 1"},
                {"SELECT COUNT(*) FROM tickets  WHERE status IN ('open','in_progress','pending')"},
                {"SELECT COUNT(*) FROM client_payments WHERE status = 'pending'"},
                {"SELECT COALESCE(SUM(amount),0) FROM client_payments WHERE MONTH(payment_date)=MONTH(CURDATE()) AND YEAR(payment_date)=YEAR(CURDATE())"},
            };
            ResultSet _rs;
            _rs = _conn.createStatement().executeQuery(queries[0][0]); if(_rs.next()) totalUsers      = _rs.getInt(1);
            _rs = _conn.createStatement().executeQuery(queries[1][0]); if(_rs.next()) totalClients    = _rs.getInt(1);
            _rs = _conn.createStatement().executeQuery(queries[2][0]); if(_rs.next()) totalVendors    = _rs.getInt(1);
            _rs = _conn.createStatement().executeQuery(queries[3][0]); if(_rs.next()) openTickets     = _rs.getInt(1);
            _rs = _conn.createStatement().executeQuery(queries[4][0]); if(_rs.next()) pendingPayments = _rs.getInt(1);
            _rs = _conn.createStatement().executeQuery(queries[5][0]); if(_rs.next()) totalRevenue    = _rs.getDouble(1);
        }
    } catch (Exception _e) { /* show 0 on error */ }
    finally { if (_conn != null) try { _conn.close(); } catch (Exception _e) {} }

    // Recent clients
    java.util.List<String[]> recentClients = new java.util.ArrayList<>();
    Connection _c2 = null;
    try {
        _c2 = DBConnection.getConnection();
        if (_c2 != null) {
            ResultSet _r2 = _c2.createStatement().executeQuery(
                "SELECT client_name, email, company_name, created_date FROM clients ORDER BY created_date DESC LIMIT 5");
            while (_r2.next()) recentClients.add(new String[]{_r2.getString(1), _r2.getString(2), _r2.getString(3), _r2.getString(4)});
        }
    } catch (Exception _e) {}
    finally { if (_c2 != null) try { _c2.close(); } catch (Exception _e) {} }

    // Recent tickets
    java.util.List<String[]> recentTickets = new java.util.ArrayList<>();
    Connection _c3 = null;
    try {
        _c3 = DBConnection.getConnection();
        if (_c3 != null) {
            ResultSet _r3 = _c3.createStatement().executeQuery(
                "SELECT ticket_number, title, priority, status, created_date FROM tickets ORDER BY created_date DESC LIMIT 5");
            while (_r3.next()) recentTickets.add(new String[]{_r3.getString(1), _r3.getString(2), _r3.getString(3), _r3.getString(4), _r3.getString(5)});
        }
    } catch (Exception _e) {}
    finally { if (_c3 != null) try { _c3.close(); } catch (Exception _e) {} }

    String fmtRevenue = String.format("%.0f", totalRevenue);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DXSure CRM</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="brand"><img src="../images/logo.svg" alt="DXSure CRM"></div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="../user">Users</a>
        <a href="../client">Clients</a>
        <a href="../vendor">Vendors</a>
        <a href="../payment">Payments</a>
        <a href="../pettycash">Petty Cash</a>
        <a href="../ticket">Tickets</a>
        <div class="user-menu">
            <span>&#9733; Welcome, <strong><%= session.getAttribute("username") %></strong></span>
            <a href="../logout">Logout</a>
        </div>
    </div>
    
    <!-- Page Header -->
    <div class="page-header">
        <h1>Admin Dashboard</h1>
        <p class="subtitle">Manage all operations of DXSure CRM</p>
    </div>
    
    <!-- Dashboard Container -->
    <div class="container">
        <div class="dashboard-container">
            <div class="dashboard-card">
                <h3>Total Users</h3>
                <div class="number"><%= totalUsers %></div>
                <div class="label">Active Users</div>
            </div>
            <div class="dashboard-card">
                <h3>Total Clients</h3>
                <div class="number"><%= totalClients %></div>
                <div class="label">Registered Clients</div>
            </div>
            <div class="dashboard-card">
                <h3>Total Vendors</h3>
                <div class="number"><%= totalVendors %></div>
                <div class="label">Active Vendors</div>
            </div>
            <div class="dashboard-card">
                <h3>Open Tickets</h3>
                <div class="number"><%= openTickets %></div>
                <div class="label">Support Tickets</div>
            </div>
            <div class="dashboard-card">
                <h3>Pending Payments</h3>
                <div class="number"><%= pendingPayments %></div>
                <div class="label">Awaiting Payment</div>
            </div>
            <div class="dashboard-card">
                <h3>Total Revenue</h3>
                <div class="number">&#8377;<%= fmtRevenue %></div>
                <div class="label">This Month</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div style="background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Quick Actions</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem;">
                <a href="../user"      class="btn btn-primary" style="text-align:center;">Manage Users</a>
                <a href="../client"    class="btn btn-success" style="text-align:center;">Manage Clients</a>
                <a href="../vendor"    class="btn btn-info"    style="text-align:center;">Manage Vendors</a>
                <a href="../ticket"    class="btn btn-danger"  style="text-align:center;">View Tickets</a>
                <a href="../payment"   class="btn btn-primary" style="text-align:center;">View Payments</a>
                <a href="../pettycash" class="btn btn-success" style="text-align:center;">Petty Cash</a>
            </div>
        </div>

        <!-- Recent Clients Table -->
        <div class="table-container" style="margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Recent Clients</h2>
            <table>
                <thead>
                    <tr>
                        <th>Client Name</th>
                        <th>Email</th>
                        <th>Company</th>
                        <th>Added On</th>
                    </tr>
                </thead>
                <tbody>
                <% if (recentClients.isEmpty()) { %>
                    <tr><td colspan="4" style="text-align:center;color:#888;">No clients yet</td></tr>
                <% } else { for (String[] c : recentClients) { %>
                    <tr>
                        <td><strong><%= c[0] != null ? c[0] : "-" %></strong></td>
                        <td><%= c[1] != null ? c[1] : "-" %></td>
                        <td><%= c[2] != null ? c[2] : "-" %></td>
                        <td><%= c[3] != null ? c[3].toString().substring(0, Math.min(10, c[3].toString().length())) : "-" %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
            <div style="text-align:right; margin-top:0.75rem;">
                <a href="../client" class="btn btn-info" style="font-size:0.85rem;">View All Clients &rarr;</a>
            </div>
        </div>

        <!-- Recent Tickets Table -->
        <div class="table-container" style="margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Recent Tickets</h2>
            <table>
                <thead>
                    <tr>
                        <th>Ticket #</th>
                        <th>Title</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Created</th>
                    </tr>
                </thead>
                <tbody>
                <% if (recentTickets.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center;color:#888;">No tickets yet</td></tr>
                <% } else { for (String[] t : recentTickets) { 
                    String pColor = "high".equalsIgnoreCase(t[2]) ? "#e74c3c" : "medium".equalsIgnoreCase(t[2]) ? "#f39c12" : "#27ae60";
                    String sColor = "open".equalsIgnoreCase(t[3]) ? "#e74c3c" : "closed".equalsIgnoreCase(t[3]) ? "#27ae60" : "#3498db";
                %>
                    <tr>
                        <td><code><%= t[0] != null ? t[0] : "-" %></code></td>
                        <td><%= t[1] != null ? t[1] : "-" %></td>
                        <td><span style="background:<%= pColor %>;color:#fff;padding:2px 8px;border-radius:12px;font-size:0.8rem;"><%= t[2] != null ? t[2] : "-" %></span></td>
                        <td><span style="background:<%= sColor %>;color:#fff;padding:2px 8px;border-radius:12px;font-size:0.8rem;"><%= t[3] != null ? t[3] : "-" %></span></td>
                        <td><%= t[4] != null ? t[4].toString().substring(0, Math.min(10, t[4].toString().length())) : "-" %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
            <div style="text-align:right; margin-top:0.75rem;">
                <a href="../ticket" class="btn btn-danger" style="font-size:0.85rem;">View All Tickets &rarr;</a>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer>
        <p>&copy; 2026 DXSure CRM. All rights reserved. | Digital Software Solution</p>
    </footer>
</body>
</html>
