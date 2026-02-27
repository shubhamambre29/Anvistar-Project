<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
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
    <title>User Management - DXSure CRM</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="brand"><img src="../images/logo.svg" alt="DXSure CRM"></div>
        <a href="/admin/dashboard.jsp">Dashboard</a>
        <a href="../user" style="color: var(--secondary-color);">Users</a>
        <a href="../client">Clients</a>
        <a href="../vendor">Vendors</a>
        <a href="../payment">Payments</a>
        <a href="../pettycash">Petty Cash</a>
        <a href="../ticket">Tickets</a>
        <div class="user-menu">
            <span>Welcome, <%= session.getAttribute("username") %></span>
            <a href="../logout">Logout</a>
        </div>
    </div>
    
    <!-- Page Header -->
    <div class="page-header">
        <h1>User Management</h1>
        <p class="subtitle">Create, view, and manage system users</p>
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
        
        <!-- Add User Button -->
        <div style="margin-bottom: 2rem; text-align: right;">
            <button class="btn btn-success" onclick="document.getElementById('addUserForm').style.display='block';">
                + Add New User
            </button>
        </div>
        
        <!-- Add User Form (Hidden by default) -->
        <div id="addUserForm" style="display: none; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 2rem;">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">Add New User</h2>
            <form method="POST" action="../user">
                <input type="hidden" name="action" value="add">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" required placeholder="Enter username">
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required placeholder="Enter email">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required placeholder="Enter password">
                    </div>
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" required placeholder="Enter full name">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="role">Role</label>
                    <select id="role" name="role" required>
                        <option value="admin">Admin</option>
                        <option value="employee">Employee</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-success">Add User</button>
                <button type="button" class="btn btn-danger" onclick="document.getElementById('addUserForm').style.display='none';">Cancel</button>
            </form>
        </div>
        
        <!-- Users Table -->
        <div class="table-container">
            <h2 style="color: var(--primary-color); margin-bottom: 1.5rem;">All Users</h2>
            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Full Name</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<String[]> users = (List<String[]>) request.getAttribute("users");
                        if (users != null) {
                            for (String[] user : users) {
                    %>
                    <tr>
                        <td><%= user[0] %></td>
                        <td><%= user[1] %></td>
                        <td><%= user[2] %></td>
                        <td><%= user[3] %></td>
                        <td>
                            <span style="background: <%= "admin".equals(user[4]) ? "#e3f2fd" : "#fff3e0" %>; padding: 0.25rem 0.75rem; border-radius: 4px;">
                                <%= user[4] %>
                            </span>
                        </td>
                        <td><span class="status-badge <%= "Active".equals(user[5]) ? "status-open" : "status-closed" %>"><%= user[5] %></span></td>
                        <td>
                            <a href="#" class="btn btn-info" style="font-size: 0.85rem; padding: 0.5rem 0.75rem;">Edit</a>
                            <% if (!"1".equals(user[0])) { %>
                                <form method="POST" action="../user" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="userId" value="<%= user[0] %>">
                                    <button type="submit" class="btn btn-danger" style="font-size: 0.85rem; padding: 0.5rem 0.75rem;" onclick="return confirm('Are you sure?');">Delete</button>
                                </form>
                            <% } %>
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
