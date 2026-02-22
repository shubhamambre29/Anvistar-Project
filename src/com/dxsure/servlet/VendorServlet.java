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

public class VendorServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("../index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || "list".equals(action)) {
            listVendors(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("../index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addVendor(request, response);
        } else if ("update".equals(action)) {
            updateVendor(request, response);
        } else if ("delete".equals(action)) {
            deleteVendor(request, response);
        }
    }
    
    private void listVendors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<String[]> vendors = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                stmt = conn.createStatement();
                String query = "SELECT vendor_id, vendor_name, email, phone, vendor_type, created_date FROM vendors WHERE is_active=TRUE ORDER BY vendor_id DESC";
                rs = stmt.executeQuery(query);
                
                while (rs.next()) {
                    String[] vendor = {
                        String.valueOf(rs.getInt("vendor_id")),
                        rs.getString("vendor_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("vendor_type"),
                        rs.getString("created_date")
                    };
                    vendors.add(vendor);
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
        
        request.setAttribute("vendors", vendors);
        
        String role = (String) request.getSession().getAttribute("role");
        if ("admin".equals(role)) {
            request.getRequestDispatcher("vendor_list.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("../employee/vendor_list.jsp").forward(request, response);
        }
    }
    
    private void addVendor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String vendorName = request.getParameter("vendorName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipCode = request.getParameter("zipCode");
        String vendorType = request.getParameter("vendorType");
        
        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("userId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "INSERT INTO vendors (vendor_name, email, phone, address, city, state, zip_code, vendor_type, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, vendorName);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, address);
                pstmt.setString(5, city);
                pstmt.setString(6, state);
                pstmt.setString(7, zipCode);
                pstmt.setString(8, vendorType);
                pstmt.setInt(9, userId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Vendor added successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error adding vendor: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listVendors(request, response);
    }
    
    private void updateVendor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int vendorId = Integer.parseInt(request.getParameter("vendorId"));
        String vendorName = request.getParameter("vendorName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String vendorType = request.getParameter("vendorType");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "UPDATE vendors SET vendor_name=?, email=?, phone=?, vendor_type=? WHERE vendor_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, vendorName);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, vendorType);
                pstmt.setInt(5, vendorId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Vendor updated successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error updating vendor: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listVendors(request, response);
    }
    
    private void deleteVendor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int vendorId = Integer.parseInt(request.getParameter("vendorId"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "UPDATE vendors SET is_active=FALSE WHERE vendor_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, vendorId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Vendor deleted successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting vendor: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listVendors(request, response);
    }
}
