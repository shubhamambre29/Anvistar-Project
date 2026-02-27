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

public class TicketServlet extends HttpServlet {
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
            listTickets(request, response);
        } else if ("view".equals(action)) {
            viewTicket(request, response);
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
            addTicket(request, response);
        } else if ("update".equals(action)) {
            updateTicket(request, response);
        } else if ("close".equals(action)) {
            closeTicket(request, response);
        }
    }
    
    private void listTickets(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<String[]> tickets = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                stmt = conn.createStatement();
                String query = "SELECT t.ticket_id, t.ticket_number, t.title, c.client_name, t.priority, t.status, t.created_date FROM tickets t LEFT JOIN clients c ON t.client_id = c.client_id ORDER BY t.ticket_id DESC";
                rs = stmt.executeQuery(query);
                
                while (rs.next()) {
                    String[] ticket = {
                        String.valueOf(rs.getInt("ticket_id")),
                        rs.getString("ticket_number"),
                        rs.getString("title"),
                        rs.getString("client_name"),
                        rs.getString("priority"),
                        rs.getString("status"),
                        rs.getString("created_date")
                    };
                    tickets.add(ticket);
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
        
        request.setAttribute("tickets", tickets);
        
        String role = (String) request.getSession().getAttribute("role");
        if ("admin".equals(role)) {
            request.getRequestDispatcher("/admin/ticket_list.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/employee/ticket_list.jsp").forward(request, response);
        }
    }
    
    private void viewTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int ticketId = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "SELECT * FROM tickets WHERE ticket_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, ticketId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("ticket", rs);
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
        
        request.getRequestDispatcher("ticket_details.jsp").forward(request, response);
    }
    
    private void addTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");
        String clientIdStr = request.getParameter("clientId");
        
        HttpSession session = request.getSession();
        int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                // Generate ticket number
                String ticketNumber = "TKT-" + System.currentTimeMillis();
                
                String query = "INSERT INTO tickets (ticket_number, client_id, title, description, priority, created_by) VALUES (?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, ticketNumber);
                
                if (clientIdStr != null && !clientIdStr.isEmpty()) {
                    pstmt.setInt(2, Integer.parseInt(clientIdStr));
                } else {
                    pstmt.setNull(2, java.sql.Types.INTEGER);
                }
                
                pstmt.setString(3, title);
                pstmt.setString(4, description);
                pstmt.setString(5, priority);
                pstmt.setInt(6, userId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Ticket created successfully - " + ticketNumber);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error creating ticket: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listTickets(request, response);
    }
    
    private void updateTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String assignedToStr = request.getParameter("assignedTo");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "UPDATE tickets SET status=?, priority=?, assigned_to=? WHERE ticket_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, status);
                pstmt.setString(2, priority);
                
                if (assignedToStr != null && !assignedToStr.isEmpty()) {
                    pstmt.setInt(3, Integer.parseInt(assignedToStr));
                } else {
                    pstmt.setNull(3, java.sql.Types.INTEGER);
                }
                
                pstmt.setInt(4, ticketId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Ticket updated successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error updating ticket: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listTickets(request, response);
    }
    
    private void closeTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                String query = "UPDATE tickets SET status='closed', resolved_date=NOW() WHERE ticket_id=?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, ticketId);
                
                pstmt.executeUpdate();
                request.setAttribute("success", "Ticket closed successfully");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error closing ticket: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        listTickets(request, response);
    }
}
