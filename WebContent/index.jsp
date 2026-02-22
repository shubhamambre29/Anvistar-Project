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
    // Redirect to login page
    response.sendRedirect("login.jsp");
%>
