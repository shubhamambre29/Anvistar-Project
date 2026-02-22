@echo off
REM DXSure CRM - Startup Script for Windows

echo.
echo ========================================
echo    DXSure CRM - Database Ready
echo ========================================
echo.
echo Database Status:
echo - Server: localhost:3306
echo - Database: dxsure_crm
echo - User: root
echo - Password: root123
echo.
echo Tables Created:
echo   1. users
echo   2. clients
echo   3. vendors
echo   4. tickets
echo   5. enquiries
echo   6. follow_ups
echo   7. leads
echo   8. software_requirements
echo   9. petty_cash
echo   10. payments
echo   11. client_payments
echo   12. vendor_payments
echo   13. employee_payments
echo.
echo ========================================
echo    Deployment Options
echo ========================================
echo.
echo Option 1: Use Apache Tomcat (Recommended)
echo   - Download: https://tomcat.apache.org/download-9.cgi
echo   - Extract to: C:\apache-tomcat-9.0
echo   - Copy this folder to: C:\apache-tomcat-9.0\webapps\DXSure-CRM
echo   - Run: C:\apache-tomcat-9.0\bin\startup.bat
echo   - Access: http://localhost:8080/DXSure-CRM
echo.
echo Option 2: Use Maven (if installed)
echo   - Run: mvn clean tomcat7:run
echo   - Access: http://localhost:8080/DXSure-CRM
echo.
echo Option 3: Use IntelliJ IDEA / Eclipse
echo   - Import as Dynamic Web Project
echo   - Configure Tomcat Server
echo   - Run on Server
echo.
echo ========================================
echo    Login Credentials
echo ========================================
echo.
echo Admin User:
echo   Username: admin
echo   Password: admin123
echo.
echo Employee User:
echo   Username: employee1
echo   Password: emp123
echo.
echo ========================================
echo    Application Ready!
echo ========================================
echo.
pause
