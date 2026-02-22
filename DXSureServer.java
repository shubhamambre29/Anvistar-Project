import org.apache.catalina.startup.Tomcat;
import java.io.File;

public class DXSureServer {
    public static void main(String[] args) throws Exception {
        // Create Tomcat instance
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(8080);
        tomcat.setHostname("localhost");
        
        // Set base directory
        String baseDir = System.getProperty("java.io.tmpdir");
        tomcat.setBaseDir(baseDir);
        
        // Add your web application
        String appDir = new File("WebContent").getAbsolutePath();
        tomcat.addWebapp("/DXSure-CRM", appDir);
        
        System.out.println("========================================");
        System.out.println("DXSure CRM - Starting Embedded Server");
        System.out.println("========================================");
        System.out.println("Server: http://localhost:8080/DXSure-CRM");
        System.out.println("Admin:    admin / admin123");
        System.out.println("Employee: employee1 / emp123");
        System.out.println("========================================");
        
        // Start Tomcat
        tomcat.start();
        tomcat.getServer().await();
    }
}
