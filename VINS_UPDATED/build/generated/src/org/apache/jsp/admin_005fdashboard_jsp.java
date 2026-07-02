package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;

public final class admin_005fdashboard_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write('\n');
      out.write('\n');

String admin = (String) session.getAttribute("admin");

if(admin == null){
    response.sendRedirect("admin.jsp");
}

      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<title>Admin Dashboard</title>\n");
      out.write("\n");
      out.write("<style>\n");
      out.write("body{\n");
      out.write("    font-family:sans-serif;\n");
      out.write("    background:#f5f7fa;\n");
      out.write("    padding:20px;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* FORM */\n");
      out.write("form{\n");
      out.write("    background:white;\n");
      out.write("    padding:20px;\n");
      out.write("    border-radius:10px;\n");
      out.write("    margin-bottom:20px;\n");
      out.write("}\n");
      out.write("\n");
      out.write("input{\n");
      out.write("    padding:10px;\n");
      out.write("    margin:5px;\n");
      out.write("    width:180px;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* BUTTON */\n");
      out.write("button{\n");
      out.write("    padding:10px 15px;\n");
      out.write("    background:#2ecc71;\n");
      out.write("    color:white;\n");
      out.write("    border:none;\n");
      out.write("    cursor:pointer;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* TABLE */\n");
      out.write("table{\n");
      out.write("    width:100%;\n");
      out.write("    background:white;\n");
      out.write("    border-collapse:collapse;\n");
      out.write("}\n");
      out.write("\n");
      out.write("table, th, td{\n");
      out.write("    border:1px solid #ccc;\n");
      out.write("}\n");
      out.write("\n");
      out.write("th, td{\n");
      out.write("    padding:10px;\n");
      out.write("    text-align:center;\n");
      out.write("}\n");
      out.write("\n");
      out.write("img{\n");
      out.write("    width:60px;\n");
      out.write("}\n");
      out.write("</style>\n");
      out.write("\n");
      out.write("</head>\n");
      out.write("\n");
      out.write("<body>\n");
      out.write("\n");
      out.write("<h2>Admin Dashboard ?</h2>\n");
      out.write("\n");
      out.write("<!-- ADD PRODUCT -->\n");
      out.write("<form method=\"post\">\n");
      out.write("    <h3>Add Product</h3>\n");
      out.write("\n");
      out.write("    <input type=\"text\" name=\"name\" placeholder=\"Product Name\" required>\n");
      out.write("    <input type=\"text\" name=\"category\" placeholder=\"Category (milk/snacks)\" required>\n");
      out.write("    <input type=\"text\" name=\"price\" placeholder=\"Price\" required>\n");
      out.write("    <input type=\"text\" name=\"image\" placeholder=\"Image path (images/milk.jpg)\" required>\n");
      out.write("    <input type=\"text\" name=\"link\" placeholder=\"Product Link\" required>\n");
      out.write("\n");
      out.write("    <button name=\"add\">Add Product</button>\n");
      out.write("</form>\n");
      out.write("\n");


Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/grocery","root","");

PreparedStatement ps = null;

/* ADD PRODUCT */
if(request.getParameter("add") != null){

    ps = con.prepareStatement(
    "INSERT INTO products(name,category,price,image,link) VALUES (?,?,?,?,?)");

    ps.setString(1, request.getParameter("name"));
    ps.setString(2, request.getParameter("category"));
    ps.setString(3, request.getParameter("price"));
    ps.setString(4, request.getParameter("image"));
    ps.setString(5, request.getParameter("link"));

    ps.executeUpdate();

    out.println("<p style='color:green;'>Product Added ?</p>");
}

/* DELETE PRODUCT */
if(request.getParameter("delete") != null){

    ps = con.prepareStatement("DELETE FROM products WHERE id=?");
    ps.setString(1, request.getParameter("id"));
    ps.executeUpdate();
}

/* UPDATE PRODUCT */
if(request.getParameter("update") != null){

    ps = con.prepareStatement(
    "UPDATE products SET name=?,category=?,price=?,image=?,link=? WHERE id=?");

    ps.setString(1, request.getParameter("name"));
    ps.setString(2, request.getParameter("category"));
    ps.setString(3, request.getParameter("price"));
    ps.setString(4, request.getParameter("image"));
    ps.setString(5, request.getParameter("link"));
    ps.setString(6, request.getParameter("id"));

    ps.executeUpdate();

    out.println("<p style='color:blue;'>Product Updated ?</p>");
}

      out.write("\n");
      out.write("\n");
      out.write("<!-- PRODUCT LIST -->\n");
      out.write("<h3>All Products</h3>\n");
      out.write("\n");
      out.write("<table>\n");
      out.write("<tr>\n");
      out.write("    <th>ID</th>\n");
      out.write("    <th>Name</th>\n");
      out.write("    <th>Category</th>\n");
      out.write("    <th>Price</th>\n");
      out.write("    <th>Image</th>\n");
      out.write("    <th>Link</th>\n");
      out.write("    <th>Action</th>\n");
      out.write("</tr>\n");
      out.write("\n");

Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM products");

while(rs.next()){

      out.write("\n");
      out.write("\n");
      out.write("<form method=\"post\">\n");
      out.write("<tr>\n");
      out.write("\n");
      out.write("<td>\n");
      out.write("    <input type=\"hidden\" name=\"id\" value=\"");
      out.print( rs.getInt("id") );
      out.write("\">\n");
      out.write("    ");
      out.print( rs.getInt("id") );
      out.write("\n");
      out.write("</td>\n");
      out.write("\n");
      out.write("<td><input type=\"text\" name=\"name\" value=\"");
      out.print( rs.getString("name") );
      out.write("\"></td>\n");
      out.write("\n");
      out.write("<td><input type=\"text\" name=\"category\" value=\"");
      out.print( rs.getString("category") );
      out.write("\"></td>\n");
      out.write("\n");
      out.write("<td><input type=\"text\" name=\"price\" value=\"");
      out.print( rs.getString("price") );
      out.write("\"></td>\n");
      out.write("\n");
      out.write("<td>\n");
      out.write("    <img src=\"");
      out.print( rs.getString("image") );
      out.write("\"><br>\n");
      out.write("    <input type=\"text\" name=\"image\" value=\"");
      out.print( rs.getString("image") );
      out.write("\">\n");
      out.write("</td>\n");
      out.write("\n");
      out.write("<td><input type=\"text\" name=\"link\" value=\"");
      out.print( rs.getString("link") );
      out.write("\"></td>\n");
      out.write("\n");
      out.write("<td>\n");
      out.write("    <button name=\"update\">Update</button>\n");
      out.write("    <button name=\"delete\" style=\"background:red;\">Delete</button>\n");
      out.write("</td>\n");
      out.write("\n");
      out.write("</tr>\n");
      out.write("</form>\n");
      out.write("\n");

}

      out.write("\n");
      out.write("\n");
      out.write("</table>\n");
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
