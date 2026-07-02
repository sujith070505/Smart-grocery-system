package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.security.MessageDigest;

public final class login_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<title>Smart Grocery Login</title>\n");
      out.write("<link rel=\"icon\" href=\"images/grocery.webp\">\n");
      out.write("\n");
      out.write("<style>\n");
      out.write("*{\n");
      out.write("    margin:0;\n");
      out.write("    padding:0;\n");
      out.write("    box-sizing:border-box;\n");
      out.write("    font-family:'Segoe UI', sans-serif;\n");
      out.write("}\n");
      out.write("\n");
      out.write("body{\n");
      out.write("    height:100vh;\n");
      out.write("    display:flex;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* LEFT PANEL */\n");
      out.write(".left-panel{\n");
      out.write("    width:50%;\n");
      out.write("    background:linear-gradient(135deg,#1e3c72,#2a5298);\n");
      out.write("    color:white;\n");
      out.write("    display:flex;\n");
      out.write("    flex-direction:column;\n");
      out.write("    justify-content:center;\n");
      out.write("    align-items:center;\n");
      out.write("    padding:50px;\n");
      out.write("    text-align:center;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".left-panel h1{\n");
      out.write("    font-size:40px;\n");
      out.write("    margin-bottom:20px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".left-panel p{\n");
      out.write("    font-size:18px;\n");
      out.write("    line-height:1.6;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* RIGHT PANEL */\n");
      out.write(".right-panel{\n");
      out.write("    width:50%;\n");
      out.write("    display:flex;\n");
      out.write("    justify-content:center;\n");
      out.write("    align-items:center;\n");
      out.write("    background:#f5f7fa;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* LOGIN CARD */\n");
      out.write(".login-card{\n");
      out.write("    width:320px;\n");
      out.write("    padding:35px;\n");
      out.write("    border-radius:15px;\n");
      out.write("    background:rgba(255,255,255,0.9);\n");
      out.write("    box-shadow:0 10px 30px rgba(0,0,0,0.1);\n");
      out.write("    text-align:center;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".login-card h2{\n");
      out.write("    margin-bottom:20px;\n");
      out.write("}\n");
      out.write("\n");
      out.write("input{\n");
      out.write("    width:100%;\n");
      out.write("    padding:12px;\n");
      out.write("    margin:10px 0;\n");
      out.write("    border-radius:8px;\n");
      out.write("    border:1px solid #ccc;\n");
      out.write("}\n");
      out.write("\n");
      out.write("button{\n");
      out.write("    width:100%;\n");
      out.write("    padding:12px;\n");
      out.write("    margin-top:10px;\n");
      out.write("    border:none;\n");
      out.write("    border-radius:8px;\n");
      out.write("    background:#2ecc71;\n");
      out.write("    color:white;\n");
      out.write("    cursor:pointer;\n");
      out.write("}\n");
      out.write("\n");
      out.write("button:hover{\n");
      out.write("    background:#27ae60;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".error{\n");
      out.write("    color:red;\n");
      out.write("    margin-top:10px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".success{\n");
      out.write("    color:green;\n");
      out.write("    margin-top:10px;\n");
      out.write("}\n");
      out.write("</style>\n");
      out.write("</head>\n");
      out.write("\n");
      out.write("<body>\n");
      out.write("\n");
      out.write("<!-- LEFT -->\n");
      out.write("<div class=\"left-panel\">\n");
      out.write("    <h1>🛒 Smart Grocery</h1>\n");
      out.write("    <p>\n");
      out.write("        Compare prices from top stores.<br>\n");
      out.write("        Find the best deals instantly.<br>\n");
      out.write("        Shop smarter & save more 💰\n");
      out.write("    </p>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<!-- RIGHT -->\n");
      out.write("<div class=\"right-panel\">\n");
      out.write("\n");
      out.write("<div class=\"login-card\">\n");
      out.write("<h2>Welcome Back 👋</h2>\n");
      out.write("\n");
      out.write("<form method=\"post\">\n");
      out.write("    <input type=\"email\" name=\"email\" placeholder=\"Email\" required>\n");
      out.write("    <input type=\"password\" name=\"password\" placeholder=\"Password\" required>\n");
      out.write("\n");
      out.write("    <button type=\"submit\">Login</button>\n");
      out.write("</form>\n");
      out.write("\n");
      out.write("<p>\n");
      out.write("    Don't have an account?\n");
      out.write("    <a href=\"register.jsp\">Create Account</a>\n");
      out.write("</p>\n");
      out.write("\n");

String email = request.getParameter("email");
String password = request.getParameter("password");

if(email != null && password != null){

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try{
        // ✅ Load Driver
        Class.forName("com.mysql.jdbc.Driver");

        // ✅ Connect DB
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/grocery","root","");

        // 🔐 HASH PASSWORD (same as register.jsp)
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(password.getBytes());

        byte[] bytes = md.digest();
        StringBuilder sb = new StringBuilder();

        for(byte b : bytes){
            sb.append(String.format("%02x", b));
        }

        String hashedPassword = sb.toString();

        // ✅ SQL CHECK
        String query = "SELECT * FROM users WHERE email=? AND password=?";
        ps = con.prepareStatement(query);

        ps.setString(1, email);
        ps.setString(2, hashedPassword);

        rs = ps.executeQuery();

        if(rs.next()){
            // ✅ SESSION
            session.setAttribute("user", rs.getString("name"));

            // ✅ REDIRECT
            response.sendRedirect("dashboard.jsp");
        } else {

      out.write("\n");
      out.write("            <div class=\"error\">Invalid Email or Password ❌</div>\n");

        }

    } catch(Exception e){

      out.write("\n");
      out.write("        <div class=\"error\">");
      out.print( e.getMessage() );
      out.write("</div>\n");

    } finally {
        try{ if(rs!=null) rs.close(); } catch(Exception e){}
        try{ if(ps!=null) ps.close(); } catch(Exception e){}
        try{ if(con!=null) con.close(); } catch(Exception e){}
    }
}

      out.write("\n");
      out.write("\n");
      out.write("</div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
