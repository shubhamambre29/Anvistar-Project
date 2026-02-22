# DXSure CRM - Startup Script for PowerShell

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    DXSure CRM - Database Ready       " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Database Status:" -ForegroundColor Yellow
Write-Host "  - Server: localhost:3306"
Write-Host "  - Database: dxsure_crm"
Write-Host "  - User: root"
Write-Host "  - Password: root123"
Write-Host ""

Write-Host "Tables Created:" -ForegroundColor Yellow
$tables = @(
    "users", "clients", "vendors", "tickets", "enquiries",
    "follow_ups", "leads", "software_requirements", "petty_cash",
    "payments", "client_payments", "vendor_payments", "employee_payments"
)
$tables | ForEach-Object { Write-Host "   - $_" }
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Deployment Options                " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Option 1: Apache Tomcat (Recommended)" -ForegroundColor Green
Write-Host "  1. Download: https://tomcat.apache.org/download-9.cgi"
Write-Host "  2. Extract to: C:\apache-tomcat-9.0"
Write-Host "  3. Copy this folder to webapps:"
Write-Host "     Copy-Item -Path '$(Get-Location)' -Destination 'C:\apache-tomcat-9.0\webapps\DXSure-CRM' -Recurse"
Write-Host "  4. Run: C:\apache-tomcat-9.0\bin\startup.bat"
Write-Host "  5. Access: http://localhost:8080/DXSure-CRM"
Write-Host ""

Write-Host "Option 2: Maven" -ForegroundColor Green
Write-Host "  1. Install Maven (if not already installed)"
Write-Host "  2. Run: mvn clean tomcat7:run"
Write-Host "  3. Access: http://localhost:8080/DXSure-CRM"
Write-Host ""

Write-Host "Option 3: IDE (IntelliJ IDEA / Eclipse)" -ForegroundColor Green
Write-Host "  1. Import as Dynamic Web Project"
Write-Host "  2. Configure Tomcat Server"
Write-Host "  3. Run on Server"
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Login Credentials                 " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Admin User:" -ForegroundColor Yellow
Write-Host "  Username: admin"
Write-Host "  Password: admin123"
Write-Host ""

Write-Host "Employee User:" -ForegroundColor Yellow
Write-Host "  Username: employee1"
Write-Host "  Password: emp123"
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "    Application Ready for Deployment! " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Download and install Apache Tomcat 9.0"
Write-Host "  2. Deploy the DXSure-CRM folder to webapps"
Write-Host "  3. Start Tomcat"
Write-Host "  4. Open: http://localhost:8080/DXSure-CRM"
Write-Host "  5. Login with admin/admin123"
Write-Host ""
