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

public class PaymentServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String type = request.getParameter("type");
        String activeTab = (type == null) ? "client" : type;

        loadClientPayments(request);
        loadVendorPayments(request);
        loadEmployeePayments(request);
        request.setAttribute("activeTab", activeTab);

        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            request.getRequestDispatcher("/admin/payment_list.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/employee/payment_list.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String type = request.getParameter("type");
        String action = request.getParameter("action");
        
        if ("client".equals(type) && "add".equals(action)) {
            addClientPayment(request, response);
        } else if ("vendor".equals(type) && "add".equals(action)) {
            addVendorPayment(request, response);
        } else if ("employee".equals(type) && "add".equals(action)) {
            addEmployeePayment(request, response);
        }
    }
    
    private void loadClientPayments(HttpServletRequest request) {
        List<String[]> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT cp.client_payment_id, c.client_name, cp.amount, cp.payment_date, cp.payment_method, cp.status FROM client_payments cp JOIN clients c ON cp.client_id = c.client_id ORDER BY cp.client_payment_id DESC");
                while (rs.next()) {
                    list.add(new String[]{
                        String.valueOf(rs.getInt("client_payment_id")),
                        rs.getString("client_name"), rs.getString("amount"),
                        rs.getString("payment_date"), rs.getString("payment_method"), rs.getString("status")
                    });
                }
                rs.close(); stmt.close(); conn.close();
            }
        } catch (Exception e) { e.printStackTrace(); }
        request.setAttribute("clientPayments", list);
    }
    
    private void loadVendorPayments(HttpServletRequest request) {
        List<String[]> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT vp.vendor_payment_id, v.vendor_name, vp.amount, vp.payment_date, vp.invoice_number, vp.status FROM vendor_payments vp JOIN vendors v ON vp.vendor_id = v.vendor_id ORDER BY vp.vendor_payment_id DESC");
                while (rs.next()) {
                    list.add(new String[]{
                        String.valueOf(rs.getInt("vendor_payment_id")),
                        rs.getString("vendor_name"), rs.getString("amount"),
                        rs.getString("payment_date"), rs.getString("invoice_number"), rs.getString("status")
                    });
                }
                rs.close(); stmt.close(); conn.close();
            }
        } catch (Exception e) { e.printStackTrace(); }
        request.setAttribute("vendorPayments", list);
    }
    
    private void loadEmployeePayments(HttpServletRequest request) {
        List<String[]> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT ep.emp_payment_id, u.full_name, ep.amount, ep.payment_date, ep.payment_type, ep.status FROM employee_payments ep JOIN users u ON ep.employee_id = u.user_id ORDER BY ep.emp_payment_id DESC");
                while (rs.next()) {
                    list.add(new String[]{
                        String.valueOf(rs.getInt("emp_payment_id")),
                        rs.getString("full_name"), rs.getString("amount"),
                        rs.getString("payment_date"), rs.getString("payment_type"), rs.getString("status")
                    });
                }
                rs.close(); stmt.close(); conn.close();
            }
        } catch (Exception e) { e.printStackTrace(); }
        request.setAttribute("employeePayments", list);
    }

    private void addClientPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int clientId = Integer.parseInt(request.getParameter("clientId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentMethod = request.getParameter("paymentMethod");
        String description = request.getParameter("description");
        
        HttpSession session = request.getSession();
        int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "INSERT INTO client_payments (client_id, amount, payment_method, description, created_by) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, clientId);
                pstmt.setDouble(2, amount);
                pstmt.setString(3, paymentMethod);
                pstmt.setString(4, description);
                pstmt.setInt(5, userId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Payment recorded successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error recording payment: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("activeTab", "client");
        loadClientPayments(request); loadVendorPayments(request); loadEmployeePayments(request);
        request.getRequestDispatcher("/admin/payment_list.jsp").forward(request, response);
    }

    private void addVendorPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int vendorId = Integer.parseInt(request.getParameter("vendorId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentMethod = request.getParameter("paymentMethod");
        String invoiceNumber = request.getParameter("invoiceNumber");
        String description = request.getParameter("description");
        
        HttpSession session = request.getSession();
        int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "INSERT INTO vendor_payments (vendor_id, amount, payment_method, invoice_number, description, created_by) VALUES (?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, vendorId);
                pstmt.setDouble(2, amount);
                pstmt.setString(3, paymentMethod);
                pstmt.setString(4, invoiceNumber);
                pstmt.setString(5, description);
                pstmt.setInt(6, userId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Vendor payment recorded successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error recording payment: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("activeTab", "vendor");
        loadClientPayments(request); loadVendorPayments(request); loadEmployeePayments(request);
        request.getRequestDispatcher("/admin/payment_list.jsp").forward(request, response);
    }
    
    private void addEmployeePayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentType = request.getParameter("paymentType");
        String description = request.getParameter("description");
        
        HttpSession session = request.getSession();
        int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "INSERT INTO employee_payments (employee_id, amount, payment_type, description, created_by) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, employeeId);
                pstmt.setDouble(2, amount);
                pstmt.setString(3, paymentType);
                pstmt.setString(4, description);
                pstmt.setInt(5, userId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Employee payment recorded successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error recording payment: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("activeTab", "employee");
        loadClientPayments(request); loadVendorPayments(request); loadEmployeePayments(request);
        request.getRequestDispatcher("/admin/payment_list.jsp").forward(request, response);
    }
}
