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
    <title>Vendor Management - DXSure CRM</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="brand">DXSure CRM</div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="client_list.jsp">Clients</a>
        <a href="vendor_list.jsp" style="color: var(--secondary-color);">Vendors</a>
        <a href="payment_list.jsp">Payments</a>
        <div class="user-menu">
            <span>Welcome, <%= session.getAttribute("username") %></span>
            <a href="../logout">Logout</a>
        </div>
    </div>
    
    <!-- Page Header -->
    <div class="page-header">
        <h1>Vendor Management</h1>
        <p class="subtitle">Register and manage vendor information</p>
    </div>
    
    <div class="container">
        <!-- Add Vendor Button -->
        <div style="margin-bottom: 2rem; text-align: right;">
            <button class="btn btn-success" onclick="document.getElementById('addVendorForm').style.display='block';">
                + Register New Vendor
            </button>
        </div>
        
        <!-- Add Vendor Form -->
        <div id="addVendorForm" style="display: none; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Register New Vendor</h2>
            <form method="POST" action="../vendor">
                <input type="hidden" name="action" value="add">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="vendorName">Vendor Name</label>
                        <input type="text" id="vendorName" name="vendorName" required placeholder="Vendor name">
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" placeholder="Email address">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" id="phone" name="phone" placeholder="Phone number">
                    </div>
                    <div class="form-group">
                        <label for="vendorType">Vendor Type</label>
                        <input type="text" id="vendorType" name="vendorType" placeholder="Type">
                    </div>
                </div>
                
                <button type="submit" class="btn btn-success">Register Vendor</button>
                <button type="button" class="btn btn-danger" onclick="document.getElementById('addVendorForm').style.display='none';">Cancel</button>
            </form>
        </div>
        
        <!-- Vendors Table -->
        <div class="table-container">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">All Vendors</h2>
            <table>
                <thead>
                    <tr>
                        <th>Vendor ID</th>
                        <th>Vendor Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Type</th>
                        <th>Created Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<String[]> vendors = (List<String[]>) request.getAttribute("vendors");
                        if (vendors != null) {
                            for (String[] vendor : vendors) {
                    %>
                    <tr>
                        <td><%= vendor[0] %></td>
                        <td><strong><%= vendor[1] %></strong></td>
                        <td><%= vendor[2] %></td>
                        <td><%= vendor[3] %></td>
                        <td><%= vendor[4] %></td>
                        <td><%= vendor[5] %></td>
                        <td>
                            <a href="#" class="btn btn-info" style="font-size: 0.85rem; padding: 0.5rem 0.75rem;">View</a>
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
