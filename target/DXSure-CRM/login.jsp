<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Check if already logged in
    if (session.getAttribute("userId") != null) {
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            response.sendRedirect("admin/dashboard.jsp");
        } else {
            response.sendRedirect("employee/dashboard.jsp");
        }
        return;
    }
    
    String error = null;
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    if ("POST".equals(request.getMethod()) && username != null && password != null) {
        if ("admin".equals(username) && "admin123".equals(password)) {
            session.setAttribute("userId", "1");
            session.setAttribute("username", "admin");
            session.setAttribute("role", "admin");
            response.sendRedirect("admin/dashboard.jsp");
            return;
        } else if ("employee1".equals(username) && "emp123".equals(password)) {
            session.setAttribute("userId", "2");
            session.setAttribute("username", "employee1");
            session.setAttribute("role", "employee");
            response.sendRedirect("employee/dashboard.jsp");
            return;
        } else {
            error = "Invalid username or password";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DXSure CRM - Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 10px;
            font-size: 28px;
        }
        .subtitle {
            text-align: center;
            color: #7f8c8d;
            margin-bottom: 30px;
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ecf0f1;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
        }
        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        button:hover {
            transform: translateY(-2px);
        }
        button:active {
            transform: translateY(0);
        }
        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 14px;
        }
        .alert-error {
            background: #fadbd8;
            color: #c0392b;
            border-left: 4px solid #c0392b;
        }
        .alert-success {
            background: #d5f4e6;
            color: #27ae60;
            border-left: 4px solid #27ae60;
        }
        .demo-credentials {
            background: #f0f4ff;
            padding: 15px;
            border-radius: 5px;
            margin-top: 25px;
            border-left: 4px solid #667eea;
        }
        .demo-credentials h3 {
            color: #2c3e50;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .demo-credentials p {
            color: #555;
            font-size: 13px;
            margin: 5px 0;
            font-family: monospace;
        }
        .separator {
            border: none;
            border-top: 1px solid #ecf0f1;
            margin: 25px 0;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>DXSure CRM</h1>
        <p class="subtitle">Digital Software Solution</p>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>
        
        <form method="POST" action="">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required autofocus placeholder="Enter username">
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter password">
            </div>
            
            <button type="submit">Login</button>
        </form>
        
        <div class="separator"></div>
        
        <div class="demo-credentials">
            <h3>🔑 Demo Credentials:</h3>
            <p><strong>Admin:</strong> admin / admin123</p>
            <p><strong>Employee:</strong> employee1 / emp123</p>
        </div>
    </div>
</body>
</html>
