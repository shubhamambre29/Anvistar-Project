<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, com.dxsure.dao.DBConnection" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String successMsg = "";
    String errorMsg   = "";

    // Fetch clients for dropdown
    java.util.List<String[]> clientList = new java.util.ArrayList<>();
    Connection _cl = null;
    try {
        _cl = DBConnection.getConnection();
        if (_cl != null) {
            ResultSet _r = _cl.createStatement().executeQuery(
                "SELECT client_id, client_name FROM clients WHERE is_active = 1 ORDER BY client_name");
            while (_r.next()) clientList.add(new String[]{ _r.getString(1), _r.getString(2) });
        }
    } catch (Exception _e) {}
    finally { if (_cl != null) try { _cl.close(); } catch (Exception _e) {} }

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String clientId    = request.getParameter("client_id");
        String subject     = request.getParameter("subject");
        String message     = request.getParameter("message");
        String enquiryType = request.getParameter("enquiry_type");

        if (clientId == null || clientId.isEmpty() || subject == null || subject.isEmpty() || message == null || message.isEmpty()) {
            errorMsg = "Please fill in all required fields.";
        } else {
            Connection _c = null;
            try {
                _c = DBConnection.getConnection();
                if (_c != null) {
                    PreparedStatement ps = _c.prepareStatement(
                        "INSERT INTO enquiries (client_id, enquiry_type, subject, message, status) " +
                        "VALUES (?, ?, ?, ?, 'open')");
                    ps.setInt(1, Integer.parseInt(clientId));
                    ps.setString(2, enquiryType != null ? enquiryType : "General");
                    ps.setString(3, subject);
                    ps.setString(4, message);
                    ps.executeUpdate();
                    successMsg = "Enquiry submitted successfully!";
                } else {
                    errorMsg = "Database connection failed.";
                }
            } catch (Exception _e) {
                errorMsg = "Error saving enquiry: " + _e.getMessage();
            } finally {
                if (_c != null) try { _c.close(); } catch (Exception _e) {}
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Enquiry - DXSure CRM</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .enquiry-card {
            background: white;
            border-radius: 12px;
            padding: 2rem 2.5rem;
            max-width: 680px;
            margin: 2rem auto;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            border-top: 4px solid var(--primary-color, #0f3a6e);
        }
        .enquiry-card h2 {
            color: var(--primary-color, #0f3a6e);
            margin-bottom: 1.5rem;
            font-size: 1.4rem;
        }
        .form-group {
            margin-bottom: 1.2rem;
        }
        .form-group label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.4rem;
            font-size: 0.9rem;
        }
        .form-group select,
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.65rem 0.9rem;
            border: 1.5px solid #d0d5dd;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: inherit;
            color: #333;
            transition: border-color 0.2s;
            box-sizing: border-box;
        }
        .form-group select:focus,
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color, #0f3a6e);
            box-shadow: 0 0 0 3px rgba(15,58,110,0.1);
        }
        .form-group textarea { resize: vertical; min-height: 130px; }
        .priority-row { display: flex; gap: 1rem; }
        .priority-row .form-group { flex: 1; }
        .alert-success {
            background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7;
            border-radius: 8px; padding: 0.8rem 1rem; margin-bottom: 1rem; font-weight: 600;
        }
        .alert-error {
            background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5;
            border-radius: 8px; padding: 0.8rem 1rem; margin-bottom: 1rem; font-weight: 600;
        }
        .form-actions { display: flex; gap: 1rem; margin-top: 1.5rem; }
        .btn-submit {
            background: var(--primary-color, #0f3a6e); color: white;
            border: none; padding: 0.7rem 2rem; border-radius: 8px;
            font-size: 1rem; font-weight: 600; cursor: pointer; transition: background 0.2s;
        }
        .btn-submit:hover { background: #0a2a52; }
        .btn-back {
            background: #f3f4f6; color: #374151; text-decoration: none;
            padding: 0.7rem 1.5rem; border-radius: 8px; font-size: 1rem; font-weight: 600;
            display: inline-flex; align-items: center;
        }
        .btn-back:hover { background: #e5e7eb; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <div class="navbar">
        <div class="brand">DXSure CRM</div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="client_list.jsp" style="color: var(--secondary-color);">Clients</a>
        <a href="vendor_list.jsp">Vendors</a>
        <a href="payment_list.jsp">Payments</a>
        <a href="pettycash_list.jsp">Petty Cash</a>
        <a href="ticket_list.jsp">Tickets</a>
        <div class="user-menu">
            <span>&#9733; Welcome, <strong><%= session.getAttribute("username") %></strong></span>
            <a href="../logout">Logout</a>
        </div>
    </div>

    <!-- Page Header -->
    <div class="page-header">
        <h1>Client Enquiry</h1>
        <p class="subtitle">Submit an enquiry on behalf of a client</p>
    </div>

    <div class="container">
        <div class="enquiry-card">
            <h2>&#128221; New Enquiry</h2>

            <% if (!successMsg.isEmpty()) { %>
                <div class="alert-success">&#10003; <%= successMsg %></div>
            <% } %>
            <% if (!errorMsg.isEmpty()) { %>
                <div class="alert-error">&#9888; <%= errorMsg %></div>
            <% } %>

            <form method="POST" action="enquiry.jsp">
                <div class="form-group">
                    <label for="client_id">Client <span style="color:red">*</span></label>
                    <select id="client_id" name="client_id" required>
                        <option value="">-- Select Client --</option>
                        <% for (String[] c : clientList) { %>
                            <option value="<%= c[0] %>"><%= c[1] %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="subject">Subject <span style="color:red">*</span></label>
                    <input type="text" id="subject" name="subject" placeholder="e.g. Service request, Complaint, Feedback" required>
                </div>

                <div class="form-group">
                    <label for="enquiry_type">Enquiry Type</label>
                    <select id="enquiry_type" name="enquiry_type">
                        <option value="General">General</option>
                        <option value="Service Request">Service Request</option>
                        <option value="Complaint">Complaint</option>
                        <option value="Feedback">Feedback</option>
                        <option value="Billing">Billing</option>
                        <option value="Technical Support">Technical Support</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="message">Message <span style="color:red">*</span></label>
                    <textarea id="message" name="message" placeholder="Describe the enquiry in detail..." required></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">&#128228; Submit Enquiry</button>
                    <a href="client_list.jsp" class="btn-back">&#8592; Back to Clients</a>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 DXSure CRM. All rights reserved.</p>
    </footer>
</body>
</html>
