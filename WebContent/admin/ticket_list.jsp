<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket Management - DXSure CRM</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="brand">DXSure CRM</div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="client_list.jsp">Clients</a>
        <a href="vendor_list.jsp">Vendors</a>
        <a href="payment_list.jsp">Payments</a>
        <a href="ticket_list.jsp" style="color: var(--secondary-color);">Tickets</a>
        <div class="user-menu">
            <span>Welcome, <%= session.getAttribute("username") %></span>
            <a href="../logout">Logout</a>
        </div>
    </div>
    
    <!-- Page Header -->
    <div class="page-header">
        <h1>Support Ticketing System</h1>
        <p class="subtitle">Create and manage support tickets</p>
    </div>
    
    <div class="container">
        <% 
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            
            if (success != null) {
        %>
            <div class="alert alert-success"><%= success %></div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>
        
        <!-- Add Ticket Button -->
        <div style="margin-bottom: 2rem; text-align: right;">
            <button class="btn btn-success" onclick="document.getElementById('addTicketForm').style.display='block';">
                + Create New Ticket
            </button>
        </div>
        
        <!-- Add Ticket Form (Hidden by default) -->
        <div id="addTicketForm" style="display: none; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Create New Support Ticket</h2>
            <form method="POST" action="../ticket">
                <input type="hidden" name="action" value="add">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="title">Ticket Title</label>
                        <input type="text" id="title" name="title" required placeholder="Brief description of issue">
                    </div>
                    <div class="form-group">
                        <label for="priority">Priority</label>
                        <select id="priority" name="priority" required>
                            <option value="low">Low</option>
                            <option value="medium" selected>Medium</option>
                            <option value="high">High</option>
                            <option value="urgent">Urgent</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-group form-row full">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" required placeholder="Detailed description of the issue"></textarea>
                </div>
                
                <button type="submit" class="btn btn-success">Create Ticket</button>
                <button type="button" class="btn btn-danger" onclick="document.getElementById('addTicketForm').style.display='none';">Cancel</button>
            </form>
        </div>
        
        <!-- Tickets Table -->
        <div class="table-container">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">All Tickets</h2>
            <table>
                <thead>
                    <tr>
                        <th>Ticket ID</th>
                        <th>Ticket Number</th>
                        <th>Title</th>
                        <th>Client</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Created Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<String[]> tickets = (List<String[]>) request.getAttribute("tickets");
                        if (tickets != null) {
                            for (String[] ticket : tickets) {
                    %>
                    <tr>
                        <td><%= ticket[0] %></td>
                        <td><strong><%= ticket[1] %></strong></td>
                        <td><%= ticket[2] %></td>
                        <td><%= ticket[3] != null ? ticket[3] : "N/A" %></td>
                        <td><span class="priority-<%= ticket[4] %>"><%= ticket[4].toUpperCase() %></span></td>
                        <td><span class="status-badge status-<%= ticket[5] %>"><%= ticket[5].toUpperCase() %></span></td>
                        <td><%= ticket[6] %></td>
                        <td>
                            <a href="#" class="btn btn-info" style="font-size: 0.85rem; padding: 0.5rem 0.75rem;">View</a>
                            <form method="POST" action="../ticket" style="display: inline;">
                                <input type="hidden" name="action" value="close">
                                <input type="hidden" name="ticketId" value="<%= ticket[0] %>">
                                <button type="submit" class="btn btn-primary" style="font-size: 0.85rem; padding: 0.5rem 0.75rem;">Close</button>
                            </form>
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
