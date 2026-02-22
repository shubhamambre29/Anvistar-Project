<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Form Debug</title>
    <style>
        body { font-family: Arial; padding: 40px; background: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; }
        h1 { color: #2c3e50; }
        .info { background: #ecf0f1; padding: 15px; border-radius: 5px; margin: 20px 0; font-family: monospace; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #3498db; color: white; }
        .success { background: #d4edda; padding: 15px; border-radius: 5px; color: #155724; }
        .warning { background: #fff3cd; padding: 15px; border-radius: 5px; color: #856404; }
    </style>
</head>
<body>
    <div class="container">
        <h1>DXSure CRM - Form Debug</h1>
        
        <%
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            out.println("<h3>Request Parameters:</h3>");
            out.println("<table>");
            out.println("<tr><th>Parameter</th><th>Value</th></tr>");
            out.println("<tr><td>username</td><td>" + (username != null ? username : "null") + "</td></tr>");
            out.println("<tr><td>password</td><td>" + (password != null ? "***" : "null") + "</td></tr>");
            out.println("<tr><td>Request Method</td><td>" + request.getMethod() + "</td></tr>");
            out.println("</table>");
            
            if ("POST".equals(request.getMethod())) {
                out.println("<div class='warning'>POST request received successfully!</div>");
            }
        %>
        
        <h3>Test the login form:</h3>
        <form method="POST" action="debug.jsp">
            <div style="margin-bottom: 15px;">
                <label>Username:</label><br>
                <input type="text" name="username" value="admin" style="width: 100%; padding: 8px;">
            </div>
            <div style="margin-bottom: 15px;">
                <label>Password:</label><br>
                <input type="password" name="password" value="admin123" style="width: 100%; padding: 8px;">
            </div>
            <button type="submit" style="padding: 10px 30px; background: #3498db; color: white; border: none; border-radius: 5px; cursor: pointer;">Submit Test Form</button>
        </form>
        
        <p style="margin-top: 30px;"><a href="index.jsp">Back to Login</a> | <a href="login-test.jsp">Session Status</a></p>
    </div>
</body>
</html>
