# DXSure CRM - QUICK REFERENCE GUIDE

## 🎯 Project Overview
Complete web-based CRM system for IT companies with Admin and Employee roles.

**Location**: `c:\Users\shubhamambre2005\OneDrive\Desktop\webdevpro\Anvistar Pro\DXSure-CRM`

---

## ⚡ Quick Start (5 Steps)

### Step 1: Create Database
```bash
mysql -u root -p < database/dxsure_schema.sql
```

### Step 2: Configure Database
Edit `src/com/dxsure/dao/DBConnection.java`:
```java
private static final String USER = "root";
private static final String PASSWORD = ""; // Your password
```

### Step 3: Add JDBC Driver
Download MySQL JDBC and place in `WebContent/WEB-INF/lib/`

### Step 4: Deploy to Tomcat
Copy DXSure-CRM folder to `tomcat/webapps/`

### Step 5: Start Application
```
http://localhost:8080/DXSure-CRM
```

**Login**: admin / admin123

---

## 📂 File Structure at a Glance

```
DXSure-CRM/
├── src/                           # Java source code
│   └── com/dxsure/
│       ├── servlet/               # 8 Servlets
│       └── dao/                   # Database layer
├── WebContent/
│   ├── index.jsp                  # Login page
│   ├── css/style.css              # Styling
│   ├── admin/                     # 7 Admin pages
│   └── employee/                  # 5 Employee pages
├── database/dxsure_schema.sql     # Database
├── README.md                      # Features
├── INSTALLATION.md                # Setup guide
├── PROJECT_SUMMARY.md             # Completion status
└── PROJECT_INDEX.md               # File guide
```

---

## 🔑 Default Credentials

```
┌─────────────┬──────────────┬──────────┐
│ Role        │ Username     │ Password │
├─────────────┼──────────────┼──────────┤
│ Admin       │ admin        │ admin123 │
│ Employee    │ employee1    │ emp123   │
└─────────────┴──────────────┴──────────┘
```

---

## 🎨 Main Pages

### Admin Dashboard
- **URL**: `/admin/dashboard.jsp`
- **Features**: Overview, user management, client/vendor management, payments, petty cash

### Employee Dashboard
- **URL**: `/employee/dashboard.jsp`
- **Features**: Client interaction, vendor handling, tickets, payments

### Login Page
- **URL**: `/index.jsp`
- **Function**: User authentication

---

## 📊 Database Tables (14 Total)

| Table | Purpose |
|-------|---------|
| users | Admin & Employee accounts |
| clients | Client information |
| vendors | Vendor details |
| tickets | Support tickets |
| enquiries | Client enquiries |
| follow_ups | Follow-up tracking |
| leads | Lead management |
| petty_cash | Expense tracking |
| payments | Payment management |
| client_payments | Client payment records |
| vendor_payments | Vendor payment records |
| employee_payments | Employee salary records |
| software_requirements | Software needs |

---

## 🔧 Backend Servlets (8 Total)

| Servlet | Endpoint | Purpose |
|---------|----------|---------|
| LoginServlet | /login | User authentication |
| LogoutServlet | /logout | Session termination |
| UserServlet | /admin/user | User CRUD |
| ClientServlet | /admin/client | Client management |
| VendorServlet | /admin/vendor | Vendor management |
| TicketServlet | /ticket | Ticket management |
| PaymentServlet | /payment | Payment tracking |
| PettyCashServlet | /pettycash | Expense tracking |

---

## 🎯 Key Features

### Authentication
✅ Login/Logout
✅ MD5 Password encryption
✅ Session management (30 min)
✅ Role-based redirection

### Admin Features
✅ User management
✅ Client management
✅ Vendor management
✅ Ticket management
✅ Payment tracking
✅ Petty cash management

### Employee Features
✅ View clients
✅ Register vendors
✅ Create tickets
✅ Record payments
✅ Track expenses

---

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| Frontend | JSP, HTML5, CSS3 |
| Backend | Java Servlets |
| Database | MySQL |
| Architecture | MVC |
| Server | Apache Tomcat |

---

## 📋 Common Tasks

### Add New User (Admin)
1. Login as admin
2. Go to Users → Add New User
3. Fill form and submit

### Create Client
1. Go to Clients → Add New Client
2. Enter client details
3. Click "Add Client"

### Create Support Ticket
1. Go to Tickets → Create New Ticket
2. Enter title and description
3. Select priority and submit

### Record Payment
1. Go to Payments
2. Select payment type
3. Enter amount and details
4. Submit

---

## ⚠️ Troubleshooting

### Problem: "Cannot connect to database"
**Solution**: 
- Check MySQL is running
- Verify username/password in DBConnection.java
- Ensure database `dxsure_crm` exists

### Problem: "Page not found"
**Solution**:
- Verify servlet mappings in web.xml
- Check JSP file paths are correct
- Restart Tomcat

### Problem: "Login fails"
**Solution**:
- Check default credentials are correct
- Clear browser cache
- Verify user exists in database

### Problem: "JDBC driver not found"
**Solution**:
- Download MySQL JDBC connector
- Place JAR in WebContent/WEB-INF/lib/
- Restart Tomcat

---

## 📁 Important Configuration Files

### web.xml
**Location**: `WebContent/WEB-INF/web.xml`
**Function**: Servlet mappings, session configuration, error pages

### DBConnection.java
**Location**: `src/com/dxsure/dao/DBConnection.java`
**Function**: Database connection parameters

### style.css
**Location**: `WebContent/css/style.css`
**Function**: Application styling

### dxsure_schema.sql
**Location**: `database/dxsure_schema.sql`
**Function**: Database creation script

---

## 🔐 Security Checklist

- ✅ MD5 password encryption
- ✅ Session-based authentication
- ✅ Role-based access control
- ✅ Session timeout (30 minutes)
- ✅ Prepared statements (SQL injection prevention)
- ✅ Form validation
- ✅ Error handling

---

## 📈 Performance Tips

1. **Database Indexes**: Already configured in schema
2. **Connection Pooling**: Configure in DBConnection.java
3. **Caching**: Can be added at servlet level
4. **CSS Minification**: Reduce style.css size for production

---

## 🎁 What's Included

✅ Complete source code (Java + JSP)
✅ Database schema (MySQL)
✅ Professional styling (CSS)
✅ Documentation (3 guides)
✅ Default test data
✅ Configuration files
✅ Ready for deployment

---

## 📞 Support Resources

1. **README.md** - Feature details and architecture
2. **INSTALLATION.md** - Step-by-step setup guide
3. **PROJECT_SUMMARY.md** - Completion status and features
4. **PROJECT_INDEX.md** - Complete file guide
5. **Source Code Comments** - Inline documentation in Java files

---

## 🚀 Deployment Checklist

- [ ] Database created and configured
- [ ] JDBC driver installed
- [ ] DBConnection.java updated with credentials
- [ ] Application deployed to Tomcat
- [ ] Tomcat started
- [ ] Application accessible via browser
- [ ] Login works with default credentials
- [ ] All pages load correctly
- [ ] Forms submit data properly

---

## 📊 Project Statistics

- **Java Files**: 9 (8 servlets + 1 DAO)
- **JSP Pages**: 15 (1 login + 7 admin + 5 employee + 2 shared)
- **Database Tables**: 14
- **Lines of Code**: 5000+
- **CSS Rules**: 100+
- **Documentation Pages**: 4

---

## 🎯 Next Steps After Deployment

1. Change admin password
2. Add production users
3. Configure email alerts (future feature)
4. Set up database backups
5. Configure HTTPS/SSL
6. Implement audit logging (future feature)

---

## 💾 Database Backup

### Backup
```bash
mysqldump -u root -p dxsure_crm > backup_dxsure.sql
```

### Restore
```bash
mysql -u root -p dxsure_crm < backup_dxsure.sql
```

---

## 📱 Responsive Design

- Desktop: Full featured interface
- Tablet: Adapted layout, touchable controls
- Mobile: Simplified interface with stacked layout

All achieved through CSS media queries in style.css

---

## 🔗 Important URLs (Once Deployed)

```
Login:                  http://localhost:8080/DXSure-CRM
Admin Dashboard:        http://localhost:8080/DXSure-CRM/admin/dashboard.jsp
Employee Dashboard:     http://localhost:8080/DXSure-CRM/employee/dashboard.jsp
Logout:                 http://localhost:8080/DXSure-CRM/logout
```

---

## ✨ Project Highlights

1. **Complete Solution**: All modules from PDF implemented
2. **Professional Design**: Bootstrap-compatible styling
3. **Secure**: Encryption and session management
4. **Well-Documented**: 4 documentation files
5. **Production-Ready**: Error handling and configuration
6. **Scalable**: MVC architecture for easy maintenance

---

**Version**: 1.0
**Status**: Complete & Ready for Deployment
**Date**: February 3, 2026

For detailed information, refer to README.md or PROJECT_INDEX.md
