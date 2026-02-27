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
    <title>Petty Cash Management - DXSure CRM</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="brand"><img src="../images/logo.svg" alt="DXSure CRM"></div>
        <a href="/admin/dashboard.jsp">Dashboard</a>
        <a href="../client">Clients</a>
        <a href="../vendor">Vendors</a>
        <a href="../payment">Payments</a>
        <a href="../pettycash" style="color: var(--secondary-color);">Petty Cash</a>
        <a href="../ticket">Tickets</a>
        <div class="user-menu">
            <span>Welcome, <%= session.getAttribute("username") %></span>
            <a href="../logout">Logout</a>
        </div>
    </div>
    
    <!-- Page Header -->
    <div class="page-header">
        <h1>Petty Cash Management</h1>
        <p class="subtitle">Track and manage petty cash expenses</p>
    </div>
    
    <div class="container">
        <%
            String success = (String) request.getAttribute("success");
            String error   = (String) request.getAttribute("error");
        %>
        <% if (success != null) { %>
        <div class="toast-notification toast-success" id="saveToast">
            <div class="toast-icon-wrap">&#10004;</div>
            <div class="toast-content">
                <div class="toast-title">Saved Successfully!</div>
                <div class="toast-msg"><%= success %></div>
            </div>
            <button class="toast-dismiss" onclick="dismissToast('saveToast')">&#10005;</button>
            <div class="toast-progress" style="animation-duration:4s"></div>
        </div>
        <% } %>
        <% if (error != null) { %>
        <div class="toast-notification toast-error" id="errToast">
            <div class="toast-icon-wrap">&#10008;</div>
            <div class="toast-content">
                <div class="toast-title">Error Occurred</div>
                <div class="toast-msg"><%= error %></div>
            </div>
            <button class="toast-dismiss" onclick="dismissToast('errToast')">&#10005;</button>
            <div class="toast-progress" style="animation-duration:6s"></div>
        </div>
        <% } %>
        <script>
        function dismissToast(id){
            var e=document.getElementById(id);
            if(e){e.classList.add('toast-hide');setTimeout(function(){e.remove();},380);}
        }
        <% if (success != null) { %>setTimeout(function(){dismissToast('saveToast');},4000);<% } %>
        <% if (error   != null) { %>setTimeout(function(){dismissToast('errToast');},6000);<% } %>
        </script>
        
        <!-- Add Petty Cash Button -->
        <div style="margin-bottom: 2rem; text-align: right;">
            <button class="btn btn-success" onclick="document.getElementById('addPettyCashForm').style.display='block';">
                + Add Petty Cash Entry
            </button>
        </div>
        
        <!-- Add Petty Cash Form (Hidden by default) -->
        <div id="addPettyCashForm" style="display: none; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Add Petty Cash Entry</h2>
            <form method="POST" action="../pettycash">
                <input type="hidden" name="action" value="add">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="description">Description</label>
                        <input type="text" id="description" name="description" required placeholder="Expense description">
                    </div>
                    <div class="form-group">
                        <label for="amount">Amount (₹)</label>
                        <input type="number" id="amount" name="amount" required step="0.01" placeholder="Amount">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="category">Category</label>
                        <select id="category" name="category">
                            <option value="Office Supplies">Office Supplies</option>
                            <option value="Transportation">Transportation</option>
                            <option value="Meals">Meals</option>
                            <option value="Utilities">Utilities</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-group form-row full">
                    <label for="notes">Notes</label>
                    <textarea id="notes" name="notes" placeholder="Additional notes"></textarea>
                </div>
                
                <button type="submit" class="btn btn-success">Add Entry</button>
                <button type="button" class="btn btn-danger" onclick="document.getElementById('addPettyCashForm').style.display='none';">Cancel</button>
            </form>
        </div>
        
        <!-- Petty Cash Table -->
        <div class="table-container">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Petty Cash Entries</h2>
            <table>
                <thead>
                    <tr>
                        <th>Entry ID</th>
                        <th>Description</th>
                        <th>Amount</th>
                        <th>Category</th>
                        <th>Date</th>
                        <th>Created By</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<String[]> entries = (List<String[]>) request.getAttribute("pettyCashEntries");
                        if (entries != null) {
                            for (String[] entry : entries) {
                    %>
                    <tr>
                        <td><%= entry[0] %></td>
                        <td><%= entry[1] %></td>
                        <td><strong>₹<%= entry[2] %></strong></td>
                        <td><span class="well well-sm" style="display: inline-block;"><%= entry[3] %></span></td>
                        <td><%= entry[5] %></td>
                        <td><%= entry[4] %></td>
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
