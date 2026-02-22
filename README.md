# DXSure CRM - Digital Software Solution

## Project Overview

DXSure CRM is a comprehensive web-based Customer Relationship Management system designed for IT companies and service providers. It provides complete solution for managing clients, vendors, software requirements, support tickets, and financial operations.

## Technology Stack

- **Backend**: Java (Servlets)
- **Frontend**: JSP, HTML5, CSS3
- **Database**: MySQL
- **Architecture**: MVC (Model-View-Controller)
- **UI Framework**: Bootstrap-compatible CSS

## Features

### 1. **Authentication & Authorization**
- Secure login system with session management
- Role-based access control (Admin/Employee)
- Session timeout (30 minutes)
- Password encryption using MD5

### 2. **Admin Module**
- **User Management**: Create, view, update, delete system users
- **Client Management**: Register and manage client information
- **Vendor Management**: Track registered vendors and vendor details
- **Ticketing System**: Create and manage support tickets
- **Payments Management**: 
  - Client Payments
  - Vendor Payments
  - Employee Payments
- **Petty Cash**: Track and manage petty cash expenses
- **Dashboard**: Analytics and quick access to key operations

### 3. **Employee Module**
- **Client Interaction**: View clients and create enquiries
- **Vendor Handling**: Register vendors and manage vendor payments
- **Tickets**: Create and track support tickets
- **Finance Operations**: Record petty cash and client payments
- **Dashboard**: Quick access to daily tasks

### 4. **Core Database Features**
- Clients database with company information
- Software requirements tracking
- Vendors and vendor management
- Support ticketing with priority levels
- Client enquiries and follow-ups
- Lead management
- Payment tracking (multiple types)
- Petty cash management
- User roles and access control

## Project Structure

```
DXSure-CRM/
├── src/
│   └── com/dxsure/
│       ├── servlet/          # Servlet controllers
│       │   ├── LoginServlet.java
│       │   ├── LogoutServlet.java
│       │   ├── UserServlet.java
│       │   ├── ClientServlet.java
│       │   ├── VendorServlet.java
│       │   ├── TicketServlet.java
│       │   ├── PaymentServlet.java
│       │   └── PettyCashServlet.java
│       └── dao/               # Data Access Objects
│           └── DBConnection.java
├── WebContent/
│   ├── index.jsp              # Login page
│   ├── css/
│   │   └── style.css          # Stylesheet
│   ├── js/
│   │   └── script.js          # JavaScript (optional)
│   ├── admin/                 # Admin pages
│   │   ├── dashboard.jsp
│   │   ├── user_list.jsp
│   │   ├── client_list.jsp
│   │   ├── vendor_list.jsp
│   │   ├── ticket_list.jsp
│   │   ├── payment_list.jsp
│   │   └── pettycash_list.jsp
│   └── employee/              # Employee pages
│       ├── dashboard.jsp
│       ├── client_list.jsp
│       ├── vendor_list.jsp
│       ├── ticket_list.jsp
│       ├── payment_list.jsp
│       └── pettycash_list.jsp
├── database/
│   └── dxsure_schema.sql      # Database schema
└── WebContent/WEB-INF/
    └── web.xml                # Deployment descriptor
```

## Installation & Setup

### Prerequisites
- Java JDK 8 or higher
- Apache Tomcat 8.0+
- MySQL Server 5.7+
- Eclipse IDE or any Java IDE

### Database Setup

1. Open MySQL command line or MySQL Workbench
2. Run the SQL script:
```bash
mysql -u root -p < database/dxsure_schema.sql
```

3. Default database: `dxsure_crm`

### Application Setup

1. Create a Dynamic Web Project in Eclipse
2. Copy all files to the project
3. Configure MySQL JDBC driver in the classpath
4. Update `DBConnection.java` with your MySQL credentials:
```java
private static final String USER = "root";  // Your MySQL user
private static final String PASSWORD = "";   // Your MySQL password
```

5. Deploy to Tomcat server
6. Access application: `http://localhost:8080/DXSure-CRM`

## Default Credentials

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | admin123 |
| Employee | employee1 | emp123 |

## Database Schema

### Key Tables
- **users**: System users with role-based access
- **clients**: Client information and company details
- **vendors**: Vendor registration and details
- **tickets**: Support tickets with priority levels
- **enquiries**: Client enquiries and tracking
- **petty_cash**: Petty cash expense tracking
- **payments**: Multi-type payment management (client, vendor, employee)
- **software_requirements**: Client software needs
- **leads**: Lead management system

## Features Detail

### Client Management
- Complete client profile including contact information
- Company details and industry classification
- Software requirements tracking
- Client payment history
- Enquiry and follow-up management

### Vendor Management
- Vendor registration and profile
- Vendor type classification
- Payment tracking and history
- Invoice management

### Support Ticketing
- Create support tickets with priority levels
- Ticket status tracking (Open, In Progress, Resolved, Closed)
- Automatic ticket number generation
- Client assignment and assignment tracking

### Financial Management
- **Client Payments**: Record and track client payments
- **Vendor Payments**: Manage vendor invoices and payments
- **Employee Payments**: Track employee salary/allowance payments
- **Petty Cash**: Expense tracking with categories

### User Roles & Permissions
| Feature | Admin | Employee |
|---------|-------|----------|
| User Management | ✓ | ✗ |
| Client Management | ✓ | ✓ (View) |
| Vendor Management | ✓ | ✓ |
| Tickets | ✓ | ✓ |
| Payments | ✓ | ✓ |
| Petty Cash | ✓ | ✓ |

## Security Features

1. **Authentication**: Login with username/password
2. **Session Management**: 30-minute session timeout
3. **Password Encryption**: MD5 hashing
4. **Role-Based Access Control**: Admin/Employee separation
5. **Database Connection Pooling**: Efficient resource management

## Future Enhancements

1. Role-based authorization using Servlet Filters
2. Mobile-responsive design improvements
3. Real-time notifications for tickets
4. Integrated email alert system
5. Graphical reports and analytics
6. Advanced search and filtering
7. Bulk import/export features
8. API integration capabilities
9. Audit logging
10. Multi-language support

## API Endpoints

### Authentication
- `POST /login` - User login
- `GET /logout` - User logout

### User Management
- `GET /admin/user` - List users
- `POST /admin/user` - Add/Update/Delete user

### Client Management
- `GET /admin/client` - List clients
- `POST /admin/client` - Add/Update/Delete client

### Vendor Management
- `GET /admin/vendor` - List vendors
- `POST /admin/vendor` - Add/Update/Delete vendor

### Tickets
- `GET /ticket` - List tickets
- `POST /ticket` - Create/Update/Close ticket

### Payments
- `GET /payment?type=client|vendor|employee` - List payments
- `POST /payment` - Record payment

### Petty Cash
- `GET /pettycash` - List petty cash entries
- `POST /pettycash` - Add petty cash entry

## Configuration Files

### web.xml
Defines servlet mappings, welcome files, error pages, and session configuration.

### DBConnection.java
Database connection pool configuration. Update with your MySQL credentials.

## Troubleshooting

### Database Connection Issues
- Verify MySQL server is running
- Check username and password in DBConnection.java
- Ensure database `dxsure_crm` exists

### Login Issues
- Clear browser cache and cookies
- Verify admin user exists in database
- Check MySQL password configuration

### Page Not Found
- Verify servlet mappings in web.xml
- Check file paths and naming conventions
- Ensure JSP files are in correct directories

## Support

For issues or feature requests, please contact the development team.

## License

Copyright © 2026 DXSure CRM. All rights reserved.

## Authors

DXSure Development Team
Digital Software Solution Division
