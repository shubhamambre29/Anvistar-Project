package com.dxsure.servlet;

import java.io.IOException;
import java.io.Serial;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dxsure.dao.DBConnection;

public class LoginServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn != null) {
                String query = "SELECT user_id, username, role FROM users WHERE username = ? AND password = MD5(?) AND is_active = TRUE";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    // User authentication successful
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("user_id"));
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", rs.getString("role"));
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                    
                    String role = rs.getString("role");
                    
                    // Redirect based on role
                    if ("admin".equals(role)) {
                        response.sendRedirect("admin/dashboard.jsp");
                    } else if ("employee".equals(role)) {
                        response.sendRedirect("employee/dashboard.jsp");
                    }
                } else {
                    // Authentication failed
                    request.setAttribute("error", "Invalid Username or Password");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
