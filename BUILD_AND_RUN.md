# DXSure CRM - Build & Run Instructions

## Status
✅ **Database Setup Complete**
- Database: `dxsure_crm` created
- Tables: 13 tables created successfully
- Sample Data: Admin and Employee users loaded
- Connection: Configured in DBConnection.java

## Prerequisites Installed
✅ Java 24.0.1 (JDK installed)
✅ MySQL 8.0 (Running)
✅ Database Password: root123

## Quick Start - Option 1: Using Embedded Server

Since Apache Tomcat is not installed, we'll create an embedded Tomcat server to run the application.

### Step 1: Create Maven Project Structure
Convert the current structure to Maven for easier dependency management and WAR packaging.

### Step 2: Add Dependencies
- Tomcat embedded-core
- MySQL JDBC driver
- Servlet API

### Step 3: Compile & Package
```bash
mvn clean package
```

### Step 4: Run
```bash
mvn tomcat7:run
```

## Quick Start - Option 2: Manual Installation

### Option A: Download & Install Apache Tomcat
1. Download from: https://tomcat.apache.org/download-9.cgi
2. Extract to: C:\apache-tomcat-9.0
3. Copy the DXSure-CRM folder to: C:\apache-tomcat-9.0\webapps
4. Rename to: DXSure-CRM.war (or keep as folder)
5. Run: C:\apache-tomcat-9.0\bin\startup.bat
6. Access: http://localhost:8080/DXSure-CRM

### Option B: Use Docker
```bash
docker run -p 8080:8080 -v C:\...\DXSure-CRM:/usr/local/tomcat/webapps/DXSure-CRM tomcat:9
```

## Login Credentials (After Setup)

### Admin User
- Username: `admin`
- Password: `admin123` (MD5: 0192023a7bbd73250516f069df18b500)

### Employee User  
- Username: `employee1`
- Password: `emp123` (MD5: 0314ee502c6f4e284128ad14e84e37d5)

## Database Connection Details
- Host: localhost:3306
- Database: dxsure_crm
- User: root
- Password: root123

## Next Steps
1. Install Tomcat or use embedded server
2. Deploy application
3. Access via browser
4. Login with credentials above
