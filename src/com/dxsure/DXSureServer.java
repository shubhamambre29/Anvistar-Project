package com.dxsure;

import java.io.File;

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.startup.Tomcat;

public class DXSureServer {
    public static void main(String[] args) throws Exception {
        String baseDir = new File(".").getAbsolutePath();
        String warPath = baseDir + File.separator + "target" + File.separator + "dxsure-crm-1.0.0.war";
        
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(8080);
        tomcat.setBaseDir(baseDir + File.separator + "tomcat-temp");
        
        try {
            // Add web app from WAR file
            Context ctx = tomcat.addWebapp("", new File(warPath).getAbsolutePath());
            ctx.setReloadable(true);
            
            System.out.println("\n================================================");
            System.out.println("  DXSure CRM - Starting Server");
            System.out.println("================================================");
            System.out.println("🚀 Server starting on: http://localhost:8080");
            System.out.println("📦 WAR File: " + warPath);
            System.out.println("");
            System.out.println("Login Credentials:");
            System.out.println("  Admin    - Username: admin, Password: admin123");
            System.out.println("  Employee - Username: employee1, Password: emp123");
            System.out.println("================================================\n");
            
            tomcat.start();
            
            System.out.println("✅ Server is RUNNING!");
            System.out.println("🌐 Access at: http://localhost:8080\n");
            
            tomcat.getServer().await();
            
        } catch (LifecycleException e) {
            System.err.println("❌ Error starting Tomcat:");
            e.printStackTrace();
            System.exit(1);
        } catch (Exception e) {
            System.err.println("❌ Unexpected error:");
            e.printStackTrace();
            System.exit(1);
        }
    }
}
