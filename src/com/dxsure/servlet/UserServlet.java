package com.dxsure.servlet;

import java.io.IOException;
import java.io.Serial;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.dxsure.dao.DBConnection;

public class UserServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || "list".equals(action)) {
            listUsers(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<String[]> users = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                stmt = conn.createStatement();
                String query = "SELECT user_id, username, email, full_name, role, is_active FROM users ORDER BY user_id";
                rs = stmt.executeQuery(query);
                
                while (rs.next()) {
                    String[] user = {
                        String.valueOf(rs.getInt("user_id")),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("full_name"),
                        rs.getString("role"),
                        rs.getBoolean("is_active") ? "Active" : "Inactive"
                    };
                    users.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("user_list.jsp").forward(request, response);
    }
    
    private void addUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "INSERT INTO users (username, password, email, full_name, role) VALUES (?, MD5(?), ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.setString(3, email);
                pstmt.setString(4, fullName);
                pstmt.setString(5, role);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "User added successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error adding user: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listUsers(request, response);
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String isActive = request.getParameter("isActive");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "UPDATE users SET email=?, full_name=?, role=?, is_active=? WHERE user_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, email);
                pstmt.setString(2, fullName);
                pstmt.setString(3, role);
                pstmt.setBoolean(4, "on".equals(isActive));
                pstmt.setInt(5, userId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "User updated successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error updating user: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listUsers(request, response);
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "DELETE FROM users WHERE user_id=? AND user_id!=1";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, userId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "User deleted successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting user: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listUsers(request, response);
    }
}
