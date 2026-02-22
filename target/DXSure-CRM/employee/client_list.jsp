<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("userId") == null || !"employee".equals(session.getAttribute("role"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Management - DXSure CRM</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="brand">DXSure CRM</div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="client_list.jsp" style="color: var(--secondary-color);">Clients</a>
        <a href="vendor_list.jsp">Vendors</a>
        <a href="payment_list.jsp">Payments</a>
        <div class="user-menu">
            <span>Welcome, <%= session.getAttribute("username") %></span>
            <a href="../logout">Logout</a>
        </div>
    </div>
    
    <!-- Page Header -->
    <div class="page-header">
        <h1>Client Management</h1>
        <p class="subtitle">View and manage client information</p>
    </div>
    
    <div class="container">
        <!-- Clients Table -->
        <div class="table-container">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">All Clients</h2>
            <table>
                <thead>
                    <tr>
                        <th>Client ID</th>
                        <th>Client Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Company</th>
                        <th>Created Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<String[]> clients = (List<String[]>) request.getAttribute("clients");
                        if (clients != null) {
                            for (String[] client : clients) {
                    %>
                    <tr>
                        <td><%= client[0] %></td>
                        <td><strong><%= client[1] %></strong></td>
                        <td><%= client[2] %></td>
                        <td><%= client[3] %></td>
                        <td><%= client[4] %></td>
                        <td><%= client[5] %></td>
                        <td>
                            <a href="#" class="btn btn-info" style="font-size: 0.85rem; padding: 0.5rem 0.75rem;">View</a>
                            <a href="enquiry.jsp" class="btn btn-success" style="font-size: 0.85rem; padding: 0.5rem 0.75rem;">Enquiry</a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2026 DXSure CRM. All rights reserved.</p>
    </footer>
</body>
</html>
