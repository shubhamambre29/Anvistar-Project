# Installation Guide for DXSure CRM

## Prerequisites

Before you begin, ensure you have the following installed:
- Java Development Kit (JDK) 8 or higher
- Apache Tomcat 8.0 or higher
- MySQL Server 5.7 or higher
- A web browser (Chrome, Firefox, Edge, etc.)

## Step 1: Database Setup

### 1.1 Create MySQL Database

```bash
# Open MySQL command line
mysql -u root -p

# Create database
CREATE DATABASE dxsure_crm;

# Use the database
USE dxsure_crm;

# Import the schema
source path/to/database/dxsure_schema.sql;
```

Or use MySQL Workbench to import the `dxsure_schema.sql` file.

### 1.2 Verify Database

```sql
USE dxsure_crm;
SHOW TABLES;
```

You should see the following tables:
- users
- clients
- vendors
- tickets
- enquiries
- follow_ups
- leads
- petty_cash
- payments
- client_payments
- vendor_payments
- employee_payments
- software_requirements

## Step 2: Application Setup

### 2.1 Configure Database Connection

Edit `src/com/dxsure/dao/DBConnection.java`:

```java
private static final String USER = "root";      // Your MySQL username
private static final String PASSWORD = "";      // Your MySQL password
```

### 2.2 Build and Deploy

#### Using Eclipse:
1. Create a new Dynamic Web Project
2. Copy all files from DXSure-CRM folder
3. Right-click project → Build Path → Configure Build Path
4. Add MySQL JDBC driver to classpath
5. Right-click project → Run As → Run on Server
6. Select Apache Tomcat and deploy

#### Using Command Line (with Ant):
```bash
cd DXSure-CRM
ant build
ant deploy -Dserver.home=/path/to/tomcat
```

### 2.3 Add JDBC Driver

Download MySQL JDBC driver: https://dev.mysql.com/downloads/connector/j/

Place the JAR file in:
- `WebContent/WEB-INF/lib/mysql-connector-java-8.0.x.jar`

## Step 3: Start Application

### 3.1 Start Tomcat Server

```bash
# On Windows
catalina.bat start

# On Linux/Mac
./catalina.sh start
```

### 3.2 Access Application

Open your browser and go to:
```
http://localhost:8080/DXSure-CRM
```

### 3.3 Login

Use default credentials:
- **Username**: admin
- **Password**: admin123

## Step 4: Initial Configuration

### 4.1 Create New Users

1. Login as Admin
2. Go to Users → Add New User
3. Create employee accounts as needed

### 4.2 Add Sample Data

1. Add Clients: Admin → Clients → Add New Client
2. Add Vendors: Admin → Vendors → Add New Vendor
3. Create Tickets: Admin/Employee → Tickets → Create New Ticket

## Common Issues & Solutions

### Issue: ClassNotFoundException: com.mysql.jdbc.Driver

**Solution**: 
- Download MySQL JDBC driver
- Place JAR in `WebContent/WEB-INF/lib/`
- Restart Tomcat

### Issue: Access denied for user 'root'@'localhost'

**Solution**:
- Verify MySQL is running
- Check username and password in DBConnection.java
- Verify MySQL user has database privileges

### Issue: Database 'dxsure_crm' doesn't exist

**Solution**:
- Run `dxsure_schema.sql` to create database
- Verify script executed without errors

### Issue: Connection timeout

**Solution**:
- Check MySQL server is running
- Verify database connection parameters
- Check firewall settings

## Performance Optimization

### Database Optimization
```sql
-- Add indexes
CREATE INDEX idx_user_role ON users(role);
CREATE INDEX idx_client_email ON clients(email);
CREATE INDEX idx_ticket_status ON tickets(status);
CREATE INDEX idx_ticket_client ON tickets(client_id);
```

### Connection Pooling
Consider implementing Apache Commons DBCP for connection pooling:
```xml
<!-- Add to web.xml -->
<resource-ref>
    <res-ref-name>jdbc/dxsure</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
</resource-ref>
```

## Backup & Recovery

### Backup Database
```bash
mysqldump -u root -p dxsure_crm > backup_dxsure.sql
```

### Restore Database
```bash
mysql -u root -p dxsure_crm < backup_dxsure.sql
```

## Production Deployment

### Recommendations

1. **Security**
   - Change default admin password
   - Use HTTPS/SSL
   - Implement proper authentication
   - Add CSRF tokens

2. **Database**
   - Use strong MySQL password
   - Enable database encryption
   - Regular backups
   - Enable query logging

3. **Server**
   - Configure Tomcat for production
   - Set appropriate memory limits
   - Enable compression
   - Configure load balancing

4. **Monitoring**
   - Set up error logging
   - Monitor database performance
   - Track user activities
   - Set up alerts

## Support & Troubleshooting

For detailed troubleshooting, refer to:
- README.md - Project overview
- Tomcat logs: `logs/catalina.out`
- MySQL logs: Check MySQL log file location

## Contact

For installation support:
- Email: support@dxsure.com
- Website: www.dxsure.com

---

**Installation Version**: 1.0
**Last Updated**: February 2026
