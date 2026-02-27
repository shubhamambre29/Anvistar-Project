package com.dxsure;

import java.io.File;

import javax.servlet.jsp.JspFactory;

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.Wrapper;
import org.apache.catalina.connector.Connector;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.loader.WebappLoader;
import org.apache.catalina.servlets.DefaultServlet;
import org.apache.catalina.startup.Tomcat;
import org.apache.jasper.runtime.JspFactoryImpl;
import org.apache.jasper.servlet.JspServlet;
import org.apache.tomcat.util.scan.StandardJarScanner;

public class DXSureServer {
    public static void main(String[] args) throws Exception {
        String projectDir = System.getProperty("user.dir");
        File webAppDir = new File(projectDir, "target/DXSure-CRM");
        File tempDir   = new File(projectDir, "tomcat-temp");
        tempDir.mkdirs();

        if (!webAppDir.exists()) {
            System.err.println("ERROR: Web app directory not found: " + webAppDir.getAbsolutePath());
            System.err.println("Run:  mvn package  first.");
            System.exit(1);
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setBaseDir(tempDir.getAbsolutePath());

        Connector connector = new Connector();
        connector.setPort(8888);
        tomcat.setConnector(connector);

        try {
            Context ctx = tomcat.addContext("", webAppDir.getAbsolutePath());

            // delegate=true: parent of WebappClassLoader becomes the TCCL (exec:java ClassRealm)
            // which holds tomcat-embed-el.jar etc. — fixes ClassNotFoundException for EL impl.
            WebappLoader loader = new WebappLoader();
            loader.setDelegate(true);
            ctx.setLoader(loader);

            File workDir = new File(tempDir, "work");
            workDir.mkdirs();
            ((StandardContext) ctx).setWorkDir(workDir.getAbsolutePath());

            StandardJarScanner jarScanner = (StandardJarScanner) ctx.getJarScanner();
            jarScanner.setScanManifest(false);
            jarScanner.setScanAllDirectories(false);

            Tomcat.addDefaultMimeTypeMappings(ctx);
            ctx.addWelcomeFile("index.jsp");

            Wrapper defWrap = Tomcat.addServlet(ctx, "default", new DefaultServlet());
            defWrap.addInitParameter("debug", "0");
            defWrap.addInitParameter("listings", "false");
            defWrap.setLoadOnStartup(1);
            ctx.addServletMappingDecoded("/", "default");

            Wrapper jspWrap = Tomcat.addServlet(ctx, "jsp", new JspServlet());
            jspWrap.addInitParameter("fork", "false");
            jspWrap.addInitParameter("xpoweredBy", "false");
            jspWrap.addInitParameter("scratchdir", workDir.getAbsolutePath());
            jspWrap.setLoadOnStartup(3);
            ctx.addServletMappingDecoded("*.jsp",  "jsp");
            ctx.addServletMappingDecoded("*.jspx", "jsp");

            add(tomcat, ctx, "LoginServlet",     "com.dxsure.servlet.LoginServlet",     "/login");
            add(tomcat, ctx, "LogoutServlet",    "com.dxsure.servlet.LogoutServlet",    "/logout");
            add(tomcat, ctx, "UserServlet",      "com.dxsure.servlet.UserServlet",      "/user");
            add(tomcat, ctx, "ClientServlet",    "com.dxsure.servlet.ClientServlet",    "/client");
            add(tomcat, ctx, "VendorServlet",    "com.dxsure.servlet.VendorServlet",    "/vendor");
            add(tomcat, ctx, "PaymentServlet",   "com.dxsure.servlet.PaymentServlet",   "/payment");
            add(tomcat, ctx, "PettyCashServlet", "com.dxsure.servlet.PettyCashServlet", "/pettycash");
            add(tomcat, ctx, "TicketServlet",    "com.dxsure.servlet.TicketServlet",    "/ticket");

            System.out.println("\n================================================");
            System.out.println("  DXSure CRM - Starting Server");
            System.out.println("================================================");
            System.out.println("  URL  : http://localhost:8888");
            System.out.println("  Path : " + webAppDir.getAbsolutePath());
            System.out.println("  Login: admin / admin123  |  employee1 / emp123");
            System.out.println("================================================\n");

            // Explicitly register the JSP factory so Jasper's Validator can find it.
            // Without this, JspFactory.getDefaultFactory() returns null when Jasper
            // tries to compile JSPs before the JspServlet's init() has had a chance to run.
            if (JspFactory.getDefaultFactory() == null) {
                JspFactory.setDefaultFactory(new JspFactoryImpl());
            }

            // Set the engine's parent classloader to the exec:java ClassRealm (captured here
            // on the main thread where TCCL = exec:java ClassRealm).
            // This propagates down to WebappClassLoader so it can find Tomcat/EL JARs
            // via parent delegation even though they're excluded from WEB-INF/lib.
            tomcat.getEngine().setParentClassLoader(Thread.currentThread().getContextClassLoader());

            tomcat.start();
            System.out.println("Server is RUNNING -> http://localhost:8888");
            tomcat.getServer().await();

        } catch (LifecycleException e) {
            System.err.println("Error starting Tomcat:");
            e.printStackTrace();
            System.exit(1);
        }
    }

    private static void add(Tomcat t, Context ctx, String name, String cls, String pattern) {
        t.addServlet(ctx.getPath(), name, cls);
        ctx.addServletMappingDecoded(pattern, name);
    }
}