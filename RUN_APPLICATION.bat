#!/batch
@echo off
echo ========================================
echo DXSure CRM - Application Starter
echo ========================================
echo.
echo This script will help you set up and run DXSure CRM
echo.
echo Prerequisites needed:
echo 1. MySQL Server (found: YES)
echo 2. Tomcat Server
echo 3. Java JDK (found: YES - version 24.0.1)
echo.
echo Steps to run the application:
echo.
echo STEP 1: Create MySQL Database
echo ==============================
echo Run the following in MySQL:
echo.
echo   mysql -u root -p
echo   (enter your MySQL password)
echo.
echo   Then execute:
echo   source "c:\Users\shubhamambre2005\OneDrive\Desktop\webdevpro\Anvistar Pro\DXSure-CRM\database\dxsure_schema.sql";
echo.
echo STEP 2: Configure Database Connection
echo ======================================
echo Edit: src\com\dxsure\dao\DBConnection.java
echo Update these lines:
echo   private static final String USER = "root";
echo   private static final String PASSWORD = "your_password";
echo.
echo STEP 3: Deploy to Tomcat
echo =========================
echo Copy the DXSure-CRM folder to: [TOMCAT_HOME]/webapps/
echo.
echo STEP 4: Start Tomcat
echo ====================
echo Run: [TOMCAT_HOME]/bin/startup.bat
echo.
echo STEP 5: Access Application
echo ===========================
echo Open browser and go to: http://localhost:8080/DXSure-CRM
echo.
echo STEP 6: Login
echo =============
echo Admin User:
echo   Username: admin
echo   Password: admin123
echo.
echo Employee User:
echo   Username: employee1
echo   Password: emp123
echo.
echo ========================================
echo For more details, see:
echo - README.md
echo - INSTALLATION.md
echo - QUICK_REFERENCE.md
echo ========================================
pause
