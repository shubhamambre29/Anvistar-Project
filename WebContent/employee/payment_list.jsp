<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
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
        <p class="subtitle">Track and manage payments</p>
    </div>
    
    <div class="container">
        <!-- Add Client Payment Button -->
        <div style="margin-bottom: 2rem; text-align: right;">
            <button class="btn btn-success" onclick="document.getElementById('addPaymentForm').style.display='block';">
                + Record Payment
            </button>
        </div>
        
        <!-- Add Payment Form -->
        <div id="addPaymentForm" style="display: none; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Record Payment</h2>
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
                <button type="button" class="btn btn-danger" onclick="document.getElementById('addPaymentForm').style.display='none';">Cancel</button>
            </form>
        </div>
        
        <!-- Payments Table -->
        <div class="table-container">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Recent Payments</h2>
            <table>
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Client/Reference</th>
                        <th>Amount</th>
                        <th>Date</th>
                        <th>Method</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        java.util.List<String[]> payments = (java.util.List<String[]>) request.getAttribute("payments");
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
    
    <footer>
        <p>&copy; 2026 DXSure CRM. All rights reserved.</p>
    </footer>
</body>
</html>
