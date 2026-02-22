package com.dxsure.servlet;

import java.io.IOException;
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

public class PettyCashServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || "list".equals(action)) {
            listPettyCash(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addPettyCash(request, response);
        }
    }
    
    private void listPettyCash(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<String[]> entries = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                stmt = conn.createStatement();
                String query = "SELECT petty_id, description, amount, category, created_by, created_date FROM petty_cash ORDER BY petty_id DESC";
                rs = stmt.executeQuery(query);
                
                while (rs.next()) {
                    String[] entry = {
                        String.valueOf(rs.getInt("petty_id")),
                        rs.getString("description"),
                        rs.getString("amount"),
                        rs.getString("category"),
                        rs.getString("created_by"),
                        rs.getString("created_date")
                    };
                    entries.add(entry);
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
        
        request.setAttribute("pettyCashEntries", entries);
        
        String role = (String) request.getSession().getAttribute("role");
        if ("admin".equals(role)) {
            request.getRequestDispatcher("admin/pettycash_list.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("employee/pettycash_list.jsp").forward(request, response);
        }
    }
    
    private void addPettyCash(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String category = request.getParameter("category");
        String notes = request.getParameter("notes");
        
        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("userId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "INSERT INTO petty_cash (description, amount, category, created_by, notes) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, description);
                pstmt.setDouble(2, amount);
                pstmt.setString(3, category);
                pstmt.setInt(4, userId);
                pstmt.setString(5, notes);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Petty cash entry added successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error adding petty cash entry: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listPettyCash(request, response);
    }
}
