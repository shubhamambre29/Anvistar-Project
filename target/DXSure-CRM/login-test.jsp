<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" import="java.security.MessageDigest" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Test</title>
    <style>
        body { font-family: Arial; padding: 40px; }
        .container { max-width: 500px; margin: 0 auto; }
        h1 { color: #2c3e50; }
        .info { background: #ecf0f1; padding: 15px; border-radius: 5px; margin: 20px 0; }
        .code { background: #f8f9fa; padding: 10px; border-left: 3px solid #3498db; margin: 10px 0; font-family: monospace; }
        .success { color: #27ae60; font-weight: bold; }
        .error { color: #e74c3c; }
    </style>
</head>
<body>
    <div class="container">
        <h1>DXSure CRM - Login Test</h1>
        
        <div class="info">
            <h3>Session Information:</h3>
            <%
                String userId = (String) session.getAttribute("userId");
                String username = (String) session.getAttribute("username");
                String role = (String) session.getAttribute("role");
                
                if (userId != null) {
            %>
                <p class="success">✓ You are logged in!</p>
                <div class="code">
                    User ID: <%= userId %><br>
                    Username: <%= username %><br>
                    Role: <%= role %>
                </div>
                <p><a href="admin/dashboard.jsp">Go to Admin Dashboard</a> | <a href="logout.jsp">Logout</a></p>
            <%
                } else {
            %>
                <p class="error">✗ You are not logged in</p>
                <p><a href="index.jsp">Go to Login Page</a></p>
            <%
                }
            %>
        </div>
        
        <div class="info">
            <h3>Test Login Credentials:</h3>
            <div class="code">
                Admin: admin / admin123<br>
                Employee: employee1 / emp123
            </div>
        </div>
        
        <div class="info">
            <h3>MD5 Hash Values:</h3>
            <div class="code">
                admin123 = 0192023a7bbd73250516f069df18b500<br>
                emp123 = 0314ee502c6f4e284128ad14e84e37d5
            </div>
        </div>
    </div>
</body>
</html>
