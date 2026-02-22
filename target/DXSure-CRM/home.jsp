<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
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
    if ("POST".equals(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username != null && password != null) {
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
                error = "Invalid credentials";
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DXSure CRM Login</title>
    <style>
        body { font-family: Arial; background: linear-gradient(135deg, #667eea, #764ba2); min-height: 100vh; display: flex; align-items: center; justify-content: center; margin: 0; }
        .box { background: white; padding: 40px; border-radius: 8px; width: 400px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); }
        h1 { text-align: center; color: #2c3e50; }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 2px solid #ecf0f1; border-radius: 5px; font-size: 14px; }
        input:focus { outline: none; border-color: #667eea; }
        button { width: 100%; padding: 12px; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; margin-top: 10px; }
        button:hover { opacity: 0.9; }
        .error { background: #fadbd8; color: #c0392b; padding: 10px; border-radius: 5px; margin: 10px 0; }
        .info { background: #f0f4ff; padding: 15px; border-radius: 5px; margin-top: 20px; border-left: 4px solid #667eea; }
        p { margin: 5px 0; font-size: 14px; }
    </style>
</head>
<body>
    <div class="box">
        <h1>DXSure CRM</h1>
        <p style="text-align: center; color: #666;">Digital Software Solution</p>
        
        <% if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>
        
        <form method="POST">
            <input type="text" name="username" placeholder="Username" required autofocus>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        
        <div class="info">
            <strong>Demo Accounts:</strong>
            <p>Admin: admin / admin123</p>
            <p>Employee: employee1 / emp123</p>
        </div>
    </div>
</body>
</html>
