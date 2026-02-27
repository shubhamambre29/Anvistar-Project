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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif;
            background: linear-gradient(135deg, #0d2d5a 0%, #0f3a6e 45%, #0e4a7a 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        /* Animated glow blobs */
        body::before, body::after {
            content: '';
            position: fixed;
            border-radius: 50%;
            filter: blur(80px);
            opacity: .4;
            animation: blobFloat 8s ease-in-out infinite alternate;
            pointer-events: none;
        }
        body::before {
            width: 520px; height: 520px;
            top: -130px; left: -100px;
            background: radial-gradient(circle, #1a7fd4, #00b4d8);
        }
        body::after {
            width: 420px; height: 420px;
            bottom: -100px; right: -80px;
            background: radial-gradient(circle, #4cb944, #00b4d8);
            animation-delay: 2.5s;
            animation-direction: alternate-reverse;
        }
        @keyframes blobFloat {
            from { transform: translate(0,0) scale(1); }
            to   { transform: translate(28px,28px) scale(1.1); }
        }

        /* Subtle dot-grid overlay */
        body .grid-overlay {
            position: fixed;
            inset: 0;
            background-image:
                radial-gradient(circle, rgba(255,255,255,.07) 1px, transparent 1px);
            background-size: 36px 36px;
            pointer-events: none;
        }

        .login-card {
            background: rgba(255,255,255,.97);
            padding: 3rem 2.8rem 2.5rem;
            border-radius: 20px;
            box-shadow: 0 40px 100px rgba(13,45,90,.45), 0 8px 24px rgba(0,0,0,.18);
            width: 100%;
            max-width: 430px;
            position: relative;
            z-index: 2;
            border-top: 4px solid transparent;
            border-image: linear-gradient(90deg, #1a7fd4, #00b4d8, #4cb944) 1;
            animation: cardIn .55s cubic-bezier(.17,.67,.3,1.2) both;
        }
        @keyframes cardIn {
            from { opacity:0; transform: translateY(40px) scale(.95); }
            to   { opacity:1; transform: translateY(0)    scale(1);   }
        }

        .logo-wrap {
            text-align: center;
            margin-bottom: 2rem;
        }
        .logo-wrap img {
            height: 58px;
            width: auto;
            filter: drop-shadow(0 3px 12px rgba(13,45,90,.18));
        }
        .logo-tagline {
            display: block;
            color: #8099b4;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.16em;
            text-transform: uppercase;
            margin-top: 0.65rem;
        }

        .login-title {
            text-align: center;
            font-size: 1.3rem;
            font-weight: 800;
            color: #0d2d5a;
            margin-bottom: 1.8rem;
        }

        .form-group { margin-bottom: 1.4rem; }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #0d2d5a;
            font-weight: 600;
            font-size: 0.88rem;
            letter-spacing: 0.03em;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 0.82rem 1rem;
            border: 2px solid #cfe0f3;
            border-radius: 8px;
            font-size: 0.97rem;
            font-family: inherit;
            color: #0d2d5a;
            background: #f5faff;
            transition: border-color .25s, box-shadow .25s, background .2s;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #1a7fd4;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(26,127,212,.15);
        }

        .login-btn {
            width: 100%;
            padding: 0.88rem;
            background: linear-gradient(135deg, #1a7fd4 0%, #1255a1 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            letter-spacing: 0.04em;
            box-shadow: 0 6px 22px rgba(26,127,212,.42);
            transition: all .28s cubic-bezier(.4,0,.2,1);
            position: relative;
            overflow: hidden;
        }
        .login-btn::after {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(255,255,255,.12);
            opacity: 0;
            transition: opacity .2s;
        }
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(26,127,212,.55);
        }
        .login-btn:hover::after { opacity: 1; }
        .login-btn:active       { transform: translateY(0); }

        .alert {
            padding: 0.85rem 1rem;
            margin-bottom: 1.2rem;
            border-radius: 8px;
            font-size: 0.88rem;
            font-weight: 500;
            border-left: 4px solid;
        }
        .alert-error {
            background: #fde8e8;
            color: #922b21;
            border-color: #e74c3c;
        }
        .alert-success {
            background: #eaf7e5;
            color: #1d5c17;
            border-color: #4cb944;
        }

        .separator { border:none; border-top:1px solid #e8eef6; margin:1.5rem 0; }

        .demo-credentials {
            background: linear-gradient(135deg, #e8f4fd 0%, #eaf7e5 100%);
            padding: 1rem 1.1rem;
            border-radius: 10px;
            border-left: 4px solid #1a7fd4;
        }
        .demo-credentials h3 {
            color: #0d2d5a;
            font-size: 0.82rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 0.6rem;
        }
        .demo-credentials p {
            color: #3a5a7a;
            font-size: 0.82rem;
            margin: 4px 0;
            font-family: 'Courier New', monospace;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="grid-overlay"></div>
    <div class="login-card">
        <!-- Logo -->
        <div class="logo-wrap">
            <img src="images/logo.svg" alt="DXSure CRM Logo">
            <span class="logo-tagline">Digital Software Solution</span>
        </div>

        <p class="login-title">Sign in to your account</p>

        <% if (error != null) { %>
            <div class="alert alert-error">
                &#9888; <%= error %>
            </div>
        <% } %>

        <form method="POST" action="">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required autofocus placeholder="Enter your username">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password">
            </div>

            <button type="submit" class="login-btn">Sign In &rarr;</button>
        </form>

        <div class="separator"></div>

        <div class="demo-credentials">
            <h3>&#128273; Demo Credentials</h3>
            <p><strong>Admin &nbsp;&nbsp;:</strong> admin / admin123</p>
            <p><strong>Employee:</strong> employee1 / emp123</p>
        </div>
    </div>
</body>
</html>
