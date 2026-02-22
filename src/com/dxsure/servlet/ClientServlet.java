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

public class ClientServlet extends HttpServlet {
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
            listClients(request, response);
        } else if ("view".equals(action)) {
            viewClient(request, response);
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
            addClient(request, response);
        } else if ("update".equals(action)) {
            updateClient(request, response);
        } else if ("delete".equals(action)) {
            deleteClient(request, response);
        }
    }
    
    private void listClients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<String[]> clients = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                stmt = conn.createStatement();
                String query = "SELECT client_id, client_name, email, phone, company_name, created_date FROM clients WHERE is_active=TRUE ORDER BY client_id DESC";
                rs = stmt.executeQuery(query);
                
                while (rs.next()) {
                    String[] client = {
                        String.valueOf(rs.getInt("client_id")),
                        rs.getString("client_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("company_name"),
                        rs.getString("created_date")
                    };
                    clients.add(client);
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
        
        request.setAttribute("clients", clients);
        
        String role = (String) request.getSession().getAttribute("role");
        if ("admin".equals(role)) {
            request.getRequestDispatcher("client_list.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("../employee/client_list.jsp").forward(request, response);
        }
    }
    
    private void viewClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int clientId = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "SELECT * FROM clients WHERE client_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, clientId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("client", rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("client_details.jsp").forward(request, response);
    }
    
    private void addClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String clientName = request.getParameter("clientName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipCode = request.getParameter("zipCode");
        String companyName = request.getParameter("companyName");
        String industry = request.getParameter("industry");
        
        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("userId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "INSERT INTO clients (client_name, email, phone, address, city, state, zip_code, company_name, industry, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, clientName);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, address);
                pstmt.setString(5, city);
                pstmt.setString(6, state);
                pstmt.setString(7, zipCode);
                pstmt.setString(8, companyName);
                pstmt.setString(9, industry);
                pstmt.setInt(10, userId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Client added successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error adding client: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listClients(request, response);
    }
    
    private void updateClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int clientId = Integer.parseInt(request.getParameter("clientId"));
        String clientName = request.getParameter("clientName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipCode = request.getParameter("zipCode");
        String companyName = request.getParameter("companyName");
        String industry = request.getParameter("industry");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "UPDATE clients SET client_name=?, email=?, phone=?, address=?, city=?, state=?, zip_code=?, company_name=?, industry=? WHERE client_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, clientName);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, address);
                pstmt.setString(5, city);
                pstmt.setString(6, state);
                pstmt.setString(7, zipCode);
                pstmt.setString(8, companyName);
                pstmt.setString(9, industry);
                pstmt.setInt(10, clientId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Client updated successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error updating client: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listClients(request, response);
    }
    
    private void deleteClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int clientId = Integer.parseInt(request.getParameter("clientId"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "UPDATE clients SET is_active=FALSE WHERE client_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, clientId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Client deleted successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting client: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listClients(request, response);
    }
}
