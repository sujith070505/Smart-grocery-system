package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;

public final class intro_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"en\">\n");
      out.write("\n");
      out.write("<head>\n");
      out.write("<meta charset=\"UTF-8\">\n");
      out.write("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("<title>Smart Grocery</title>\n");
      out.write("<link rel=\"icon\" href=\"images/grocery.webp\">\n");
      out.write("\n");
      out.write("<style>\n");
      out.write("* {\n");
      out.write("    margin: 0;\n");
      out.write("    padding: 0;\n");
      out.write("    box-sizing: border-box;\n");
      out.write("    font-family: 'Segoe UI', sans-serif;\n");
      out.write("}\n");
      out.write("\n");
      out.write("body {\n");
      out.write("    background: #f5f7fa;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* NAVBAR */\n");
      out.write(".nav {\n");
      out.write("    display: flex;\n");
      out.write("    justify-content: space-between;\n");
      out.write("    align-items: center;\n");
      out.write("    padding: 15px 40px;\n");
      out.write("    background: #2ecc71;\n");
      out.write("    color: white;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".nav h1 {\n");
      out.write("    font-size: 22px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".nav input {\n");
      out.write("    padding: 8px;\n");
      out.write("    border-radius: 5px;\n");
      out.write("    border: none;\n");
      out.write("    width: 250px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".nav_button button {\n");
      out.write("    margin-left: 10px;\n");
      out.write("    padding: 8px 15px;\n");
      out.write("    border: none;\n");
      out.write("    border-radius: 5px;\n");
      out.write("    cursor: pointer;\n");
      out.write("    background: white;\n");
      out.write("    color: #2ecc71;\n");
      out.write("    font-weight: bold;\n");
      out.write("    transition: 0.3s;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".nav_button button:hover {\n");
      out.write("    background: #27ae60;\n");
      out.write("    color: white;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* HERO */\n");
      out.write(".save {\n");
      out.write("    height: 300px;\n");
      out.write("    display: flex;\n");
      out.write("    flex-direction: column;\n");
      out.write("    justify-content: center;\n");
      out.write("    align-items: center;\n");
      out.write("    background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)),\n");
      out.write("                url(images/back.jpg);\n");
      out.write("    background-size: cover;\n");
      out.write("    color: white;\n");
      out.write("    text-align: center;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".save h1 {\n");
      out.write("    font-size: 40px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".save button {\n");
      out.write("    margin-top: 15px;\n");
      out.write("    padding: 10px 20px;\n");
      out.write("    background: #2ecc71;\n");
      out.write("    border: none;\n");
      out.write("    border-radius: 5px;\n");
      out.write("    color: white;\n");
      out.write("    cursor: pointer;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* CATEGORY GRID */\n");
      out.write(".categories {\n");
      out.write("    display: grid;\n");
      out.write("    grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));\n");
      out.write("    gap: 15px;\n");
      out.write("    padding: 30px;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* CATEGORY CARD */\n");
      out.write(".category {\n");
      out.write("    background: white;\n");
      out.write("    padding: 15px 10px;\n");
      out.write("    text-align: center;\n");
      out.write("    border-radius: 12px;\n");
      out.write("    box-shadow: 0 4px 12px rgba(0,0,0,0.08);\n");
      out.write("    cursor: pointer;\n");
      out.write("    transition: 0.2s;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".category:hover {\n");
      out.write("    transform: translateY(-5px);\n");
      out.write("}\n");
      out.write("\n");
      out.write(".category a {\n");
      out.write("    text-decoration: none;\n");
      out.write("    color: inherit;\n");
      out.write("    display: block;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".category span {\n");
      out.write("    font-size: 26px;\n");
      out.write("    display: block;\n");
      out.write("    margin-bottom: 5px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".category p {\n");
      out.write("    font-size: 13px;\n");
      out.write("    font-weight: 600;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* PRODUCTS SECTION */\n");
      out.write(".section-title {\n");
      out.write("    padding: 10px 30px 0 30px;\n");
      out.write("    font-size: 22px;\n");
      out.write("    font-weight: 700;\n");
      out.write("    color: #2c3e50;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".products-grid {\n");
      out.write("    display: grid;\n");
      out.write("    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));\n");
      out.write("    gap: 20px;\n");
      out.write("    padding: 20px 30px 40px 30px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".product-card {\n");
      out.write("    background: white;\n");
      out.write("    padding: 18px;\n");
      out.write("    border-radius: 14px;\n");
      out.write("    box-shadow: 0 4px 14px rgba(0,0,0,0.08);\n");
      out.write("    text-align: center;\n");
      out.write("    transition: 0.2s;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".product-card:hover {\n");
      out.write("    transform: translateY(-5px);\n");
      out.write("    box-shadow: 0 8px 24px rgba(0,0,0,0.12);\n");
      out.write("}\n");
      out.write("\n");
      out.write(".product-card img {\n");
      out.write("    width: 100px;\n");
      out.write("    height: 100px;\n");
      out.write("    object-fit: contain;\n");
      out.write("    border-radius: 10px;\n");
      out.write("    margin-bottom: 10px;\n");
      out.write("    border: 3px solid #f5f7fa;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".product-card h3 {\n");
      out.write("    font-size: 15px;\n");
      out.write("    font-weight: 600;\n");
      out.write("    color: #2c3e50;\n");
      out.write("    margin-bottom: 6px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".product-card .category-tag {\n");
      out.write("    display: inline-block;\n");
      out.write("    padding: 3px 10px;\n");
      out.write("    background: #e8f8f0;\n");
      out.write("    color: #27ae60;\n");
      out.write("    border-radius: 20px;\n");
      out.write("    font-size: 11px;\n");
      out.write("    font-weight: 600;\n");
      out.write("    margin-bottom: 8px;\n");
      out.write("    text-transform: capitalize;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".product-card .best-price {\n");
      out.write("    font-size: 16px;\n");
      out.write("    font-weight: 700;\n");
      out.write("    color: #2ecc71;\n");
      out.write("    margin-bottom: 10px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".product-card .login-to-buy {\n");
      out.write("    display: inline-block;\n");
      out.write("    padding: 7px 16px;\n");
      out.write("    background: #2ecc71;\n");
      out.write("    color: white;\n");
      out.write("    border-radius: 20px;\n");
      out.write("    font-size: 13px;\n");
      out.write("    font-weight: 600;\n");
      out.write("    cursor: pointer;\n");
      out.write("    border: none;\n");
      out.write("    transition: 0.2s;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".product-card .login-to-buy:hover {\n");
      out.write("    background: #27ae60;\n");
      out.write("}\n");
      out.write("\n");
      out.write("/* Search no-results */\n");
      out.write(".no-results {\n");
      out.write("    display: none;\n");
      out.write("    text-align: center;\n");
      out.write("    padding: 40px;\n");
      out.write("    color: #7f8c8d;\n");
      out.write("    font-size: 16px;\n");
      out.write("    grid-column: 1 / -1;\n");
      out.write("}\n");
      out.write("</style>\n");
      out.write("</head>\n");
      out.write("\n");
      out.write("<body>\n");
      out.write("\n");
      out.write("<!-- NAVBAR -->\n");
      out.write("<div class=\"nav\">\n");
      out.write("    <h1>🛒 Smart Grocery</h1>\n");
      out.write("    <input type=\"text\" id=\"searchInput\" placeholder=\"Search products...\" onkeyup=\"filterProducts()\">\n");
      out.write("    \n");
      out.write("    <div class=\"nav_button\">\n");
      out.write("        <button onclick=\"goLogin()\">Login/register</button>\n");
      out.write("        <button onclick=\"goAdmin()\">Admin</button>\n");
      out.write("    </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<!-- HERO -->\n");
      out.write("<div class=\"save\">\n");
      out.write("    <h1>Compare Prices &amp; Save Money</h1>\n");
      out.write("    <p>Find best deals instantly</p>\n");
      out.write("    <button onclick=\"goLogin()\">Start Shopping</button>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<!-- CATEGORIES -->\n");
      out.write("<div class=\"categories\">\n");
      out.write("\n");
      out.write("    <div class=\"category\">\n");
      out.write("        <a href=\"#\" onclick=\"goLogin(); return false;\">\n");
      out.write("            <span>🥛</span>\n");
      out.write("            <p>Dairy</p>\n");
      out.write("        </a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"category\">\n");
      out.write("        <a href=\"#\" onclick=\"goLogin(); return false;\">\n");
      out.write("            <span>🍪</span>\n");
      out.write("            <p>Snacks</p>\n");
      out.write("        </a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"category\">\n");
      out.write("        <a href=\"#\" onclick=\"goLogin(); return false;\">\n");
      out.write("            <span>🍚</span>\n");
      out.write("            <p>Staples</p>\n");
      out.write("        </a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"category\">\n");
      out.write("        <a href=\"#\" onclick=\"goLogin(); return false;\">\n");
      out.write("            <span>🌶️</span>\n");
      out.write("            <p>Spices &amp; Condiments</p>\n");
      out.write("        </a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"category\">\n");
      out.write("        <a href=\"#\" onclick=\"goLogin(); return false;\">\n");
      out.write("            <span>🥤</span>\n");
      out.write("            <p>Beverages</p>\n");
      out.write("        </a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"category\">\n");
      out.write("        <a href=\"#\" onclick=\"goLogin(); return false;\">\n");
      out.write("            <span>🧼</span>\n");
      out.write("            <p>Household &amp; Cleaning</p>\n");
      out.write("        </a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<!-- PRODUCTS SECTION — dynamically loaded from DB -->\n");
      out.write("<div class=\"section-title\">🛍️ All Products</div>\n");
      out.write("\n");
      out.write("<div class=\"products-grid\" id=\"productsGrid\">\n");
      out.write("\n");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery", "root", "");
    ps = con.prepareStatement("SELECT * FROM products ORDER BY category, id");
    rs = ps.executeQuery();

    while (rs.next()) {
        String pName     = rs.getString("name");
        String pCategory = rs.getString("category");
        String pImage    = rs.getString("image");

        double bb    = rs.getBigDecimal("bigbasket_price") != null ? rs.getBigDecimal("bigbasket_price").doubleValue() : 0.0;
        double dm    = rs.getBigDecimal("dmart_price")     != null ? rs.getBigDecimal("dmart_price").doubleValue()     : 0.0;
        double blink = rs.getBigDecimal("blinkit_price")   != null ? rs.getBigDecimal("blinkit_price").doubleValue()   : 0.0;

        double bestPrice = Double.MAX_VALUE;
        if (bb    > 0)                      bestPrice = bb;
        if (dm    > 0 && dm    < bestPrice) bestPrice = dm;
        if (blink > 0 && blink < bestPrice) bestPrice = blink;
        if (bestPrice == Double.MAX_VALUE)  bestPrice = 0;

        String categoryDisplay = (pCategory != null && !pCategory.trim().isEmpty()) ? pCategory.trim() : "";
        String dataCategory    = categoryDisplay.toLowerCase();
        String dataName        = pName.toLowerCase();

      out.write("\n");
      out.write("    <div class=\"product-card\"\n");
      out.write("         data-name=\"");
      out.print( dataName );
      out.write("\"\n");
      out.write("         data-category=\"");
      out.print( dataCategory );
      out.write("\">\n");
      out.write("\n");
      out.write("        <img src=\"");
      out.print( pImage );
      out.write("\"\n");
      out.write("             alt=\"");
      out.print( pName );
      out.write("\"\n");
      out.write("             onerror=\"this.src='https://placehold.co/100x100/e8f8f0/2ecc71?text=🛒'\">\n");
      out.write("\n");
      out.write("        <h3>");
      out.print( pName );
      out.write("</h3>\n");
      out.write("\n");
      out.write("        ");
 if (!categoryDisplay.isEmpty()) { 
      out.write("\n");
      out.write("        <div class=\"category-tag\">");
      out.print( categoryDisplay );
      out.write("</div>\n");
      out.write("        ");
 } 
      out.write("\n");
      out.write("\n");
      out.write("        <div class=\"best-price\">\n");
      out.write("            ₹");
      out.print( bestPrice > 0 ? String.format("%.0f", bestPrice) : "—" );
      out.write("\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("        <button class=\"login-to-buy\" onclick=\"goLogin()\">Login to Buy</button>\n");
      out.write("    </div>\n");

    }
} catch (Exception e) {
    out.println("<p style='color:red;padding:20px;'>Error loading products: " + e.getMessage() + "</p>");
} finally {
    try { if (rs  != null) rs.close();  } catch (Exception e) {}
    try { if (ps  != null) ps.close();  } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}

      out.write("\n");
      out.write("\n");
      out.write("    <div class=\"no-results\" id=\"noResults\">❌ No products found matching your search.</div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<!-- SCRIPT -->\n");
      out.write("<script>\n");
      out.write("function goLogin() {\n");
      out.write("    window.location.href = \"login.jsp\";\n");
      out.write("}\n");
      out.write("\n");
      out.write("function goAdmin() {\n");
      out.write("    window.location.href = \"admin.jsp\";\n");
      out.write("}\n");
      out.write("\n");
      out.write("function filterProducts() {\n");
      out.write("    var query = document.getElementById('searchInput').value.toLowerCase().trim();\n");
      out.write("    var cards = document.querySelectorAll('.product-card');\n");
      out.write("    var visible = 0;\n");
      out.write("\n");
      out.write("    cards.forEach(function(card) {\n");
      out.write("        var name     = card.getAttribute('data-name')     || '';\n");
      out.write("        var category = card.getAttribute('data-category') || '';\n");
      out.write("        var match    = name.includes(query) || category.includes(query);\n");
      out.write("        card.style.display = match ? 'block' : 'none';\n");
      out.write("        if (match) visible++;\n");
      out.write("    });\n");
      out.write("\n");
      out.write("    document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';\n");
      out.write("}\n");
      out.write("</script>\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>\n");
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
