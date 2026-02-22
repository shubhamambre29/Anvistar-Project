-- DXSure CRM Database Schema
-- MySQL Database Script

CREATE DATABASE IF NOT EXISTS dxsure_crm;
USE dxsure_crm;

-- Users Table (Admin and Employees)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'employee') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Clients Table
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    company_name VARCHAR(150),
    industry VARCHAR(100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Software Requirements Table
CREATE TABLE software_requirements (
    req_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    requirement_name VARCHAR(200) NOT NULL,
    description TEXT,
    estimated_cost DECIMAL(10, 2),
    status ENUM('pending', 'in_progress', 'completed') DEFAULT 'pending',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Vendors Table
CREATE TABLE vendors (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_name VARCHAR(150) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    vendor_type VARCHAR(100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Tickets Table (Support Ticketing System)
CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    client_id INT,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    status ENUM('open', 'in_progress', 'resolved', 'closed') DEFAULT 'open',
    assigned_to INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_date DATETIME,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Client Enquiries Table
CREATE TABLE enquiries (
    enquiry_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    enquiry_type VARCHAR(100),
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('open', 'in_progress', 'resolved') DEFAULT 'open',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_to INT,
    resolved_date DATETIME,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);

-- Follow-ups Table
CREATE TABLE follow_ups (
    followup_id INT PRIMARY KEY AUTO_INCREMENT,
    enquiry_id INT NOT NULL,
    notes TEXT NOT NULL,
    followup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (enquiry_id) REFERENCES enquiries(enquiry_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Leads Table
CREATE TABLE leads (
    lead_id INT PRIMARY KEY AUTO_INCREMENT,
    lead_name VARCHAR(150) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    company VARCHAR(150),
    source VARCHAR(100),
    status ENUM('new', 'contacted', 'qualified', 'converted', 'rejected') DEFAULT 'new',
    assigned_to INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Petty Cash Table
CREATE TABLE petty_cash (
    petty_id INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(200) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100),
    created_by INT NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Payments Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_type ENUM('client_payment', 'vendor_payment', 'employee_payment') NOT NULL,
    reference_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    status ENUM('pending', 'completed', 'failed') DEFAULT 'completed',
    notes TEXT,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Client Payments Table
CREATE TABLE client_payments (
    client_payment_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    description VARCHAR(200),
    status ENUM('pending', 'received', 'failed') DEFAULT 'received',
    created_by INT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Vendor Payments Table
CREATE TABLE vendor_payments (
    vendor_payment_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    invoice_number VARCHAR(50),
    description VARCHAR(200),
    status ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
    created_by INT,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Employee Payments Table
CREATE TABLE employee_payments (
    emp_payment_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_type VARCHAR(50),
    description VARCHAR(200),
    status ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
    created_by INT,
    FOREIGN KEY (employee_id) REFERENCES users(user_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Insert default admin user
INSERT INTO users (username, password, email, full_name, role) 
VALUES ('admin', MD5('admin123'), 'admin@dxsure.com', 'Administrator', 'admin');

-- Insert sample employee user
INSERT INTO users (username, password, email, full_name, role) 
VALUES ('employee1', MD5('emp123'), 'employee1@dxsure.com', 'John Doe', 'employee');

-- Create indexes for better query performance
CREATE INDEX idx_user_role ON users(role);
CREATE INDEX idx_client_email ON clients(email);
CREATE INDEX idx_ticket_status ON tickets(status);
CREATE INDEX idx_ticket_client ON tickets(client_id);
CREATE INDEX idx_enquiry_status ON enquiries(status);
CREATE INDEX idx_payment_type ON payments(payment_type);
