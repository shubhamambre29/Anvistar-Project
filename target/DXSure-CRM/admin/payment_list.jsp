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
    <title>Payments - DXSure CRM</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="brand">DXSure CRM</div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="client_list.jsp">Clients</a>
        <a href="vendor_list.jsp">Vendors</a>
        <a href="payment_list.jsp" style="color: var(--secondary-color);">Payments</a>
        <div class="user-menu">
            <span>Welcome, <%= session.getAttribute("username") %></span>
            <a href="../logout">Logout</a>
        </div>
    </div>
    
    <!-- Page Header -->
    <div class="page-header">
        <h1>Payment Management</h1>
        <p class="subtitle">Track and manage client, vendor, and employee payments</p>
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
        
        <!-- Tabs for different payment types -->
        <div style="margin-bottom: 2rem; border-bottom: 2px solid var(--primary-color);">
            <button class="btn btn-primary" onclick="showTab('client')" style="border-radius: 0; margin: 0;">Client Payments</button>
            <button class="btn btn-primary" onclick="showTab('vendor')" style="border-radius: 0; margin: 0;">Vendor Payments</button>
            <button class="btn btn-primary" onclick="showTab('employee')" style="border-radius: 0; margin: 0;">Employee Payments</button>
        </div>
        
        <!-- Client Payments Section -->
        <div id="client-section">
            <div style="margin-bottom: 2rem; text-align: right;">
                <button class="btn btn-success" onclick="document.getElementById('addClientPaymentForm').style.display='block';">
                    + Add Client Payment
                </button>
            </div>
            
            <div id="addClientPaymentForm" style="display: none; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 2rem;">
                <h3 style="color: var(--primary-color); margin-bottom: 1.5rem;">Record Client Payment</h3>
                <form method="POST" action="../payment?type=client">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="type" value="client">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="clientId">Client ID</label>
                            <input type="number" id="clientId" name="clientId" required placeholder="Client ID">
                        </div>
                        <div class="form-group">
                            <label for="amount">Amount</label>
                            <input type="number" id="amount" name="amount" required step="0.01" placeholder="Amount">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="paymentMethod">Payment Method</label>
                            <select id="paymentMethod" name="paymentMethod">
                                <option value="Cash">Cash</option>
                                <option value="Cheque">Cheque</option>
                                <option value="Bank Transfer">Bank Transfer</option>
                                <option value="Card">Card</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group form-row full">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" placeholder="Payment description"></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-success">Record Payment</button>
                    <button type="button" class="btn btn-danger" onclick="document.getElementById('addClientPaymentForm').style.display='none';">Cancel</button>
                </form>
            </div>
            
            <div class="table-container">
                <h3 style="color: var(--primary-color); margin-bottom: 1.5rem;">Client Payments</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Payment ID</th>
                            <th>Client Name</th>
                            <th>Amount</th>
                            <th>Date</th>
                            <th>Method</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<String[]> payments = (List<String[]>) request.getAttribute("payments");
                            if (payments != null) {
                                for (String[] payment : payments) {
                        %>
                        <tr>
                            <td><%= payment[0] %></td>
                            <td><%= payment[1] %></td>
                            <td>₹<%= payment[2] %></td>
                            <td><%= payment[3] %></td>
                            <td><%= payment[4] %></td>
                            <td><span class="status-badge status-<%= payment[5] %>"><%= payment[5].toUpperCase() %></span></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2026 DXSure CRM. All rights reserved.</p>
    </footer>
    
    <script>
        function showTab(tabName) {
            var tab = document.getElementById(tabName + '-section');
            if (tab) {
                tab.style.display = 'block';
            }
        }
    </script>
</body>
</html>
