<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
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
        <div class="brand">DXSure CRM</div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="user_list.jsp">Users</a>
        <a href="client_list.jsp">Clients</a>
        <a href="vendor_list.jsp">Vendors</a>
        <a href="payment_list.jsp">Payments</a>
        <a href="pettycash_list.jsp">Petty Cash</a>
        <a href="ticket_list.jsp">Tickets</a>
        <div class="user-menu">
            <span>Welcome, <%= session.getAttribute("username") %></span>
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
                <div class="number">12</div>
                <div class="label">Active Users</div>
            </div>
            
            <div class="dashboard-card">
                <h3>Total Clients</h3>
                <div class="number">28</div>
                <div class="label">Registered Clients</div>
            </div>
            
            <div class="dashboard-card">
                <h3>Total Vendors</h3>
                <div class="number">15</div>
                <div class="label">Active Vendors</div>
            </div>
            
            <div class="dashboard-card">
                <h3>Open Tickets</h3>
                <div class="number">8</div>
                <div class="label">Support Tickets</div>
            </div>
            
            <div class="dashboard-card">
                <h3>Pending Payments</h3>
                <div class="number">5</div>
                <div class="label">Awaiting Payment</div>
            </div>
            
            <div class="dashboard-card">
                <h3>Total Revenue</h3>
                <div class="number">₹2.5L</div>
                <div class="label">This Month</div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div style="background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Quick Actions</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem;">
                <a href="user_list.jsp" class="btn btn-primary" style="text-align: center;">Manage Users</a>
                <a href="client_list.jsp" class="btn btn-success" style="text-align: center;">Manage Clients</a>
                <a href="vendor_list.jsp" class="btn btn-info" style="text-align: center;">Manage Vendors</a>
                <a href="ticket_list.jsp" class="btn btn-danger" style="text-align: center;">View Tickets</a>
                <a href="payment_list.jsp" class="btn btn-primary" style="text-align: center;">View Payments</a>
                <a href="pettycash_list.jsp" class="btn btn-success" style="text-align: center;">Petty Cash</a>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer>
        <p>&copy; 2026 DXSure CRM. All rights reserved. | Digital Software Solution</p>
    </footer>
</body>
</html>
