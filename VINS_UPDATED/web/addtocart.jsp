<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/**
 * addtocart.jsp
 * Acts as the "Add to Cart" handler (replaces AddToCartServlet).
 * Called via POST form from any product page.
 * Params: product_id, quantity (optional, default 1)
 */

// ── Session guard ────────────────────────────────────────────
String user = (String) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

// ── Read params ──────────────────────────────────────────────
String productIdStr = request.getParameter("product_id");
String qtyStr       = request.getParameter("quantity");
String referer      = request.getParameter("referer"); // where to go back

if (productIdStr == null || productIdStr.trim().isEmpty()) {
    response.sendRedirect("dashboard.jsp");
    return;
}

int productId = Integer.parseInt(productIdStr.trim());
int quantity  = 1;
try { quantity = Integer.parseInt(qtyStr.trim()); } catch (Exception ex) {}
if (quantity < 1) quantity = 1;

// ── DB: insert or increment ──────────────────────────────────
Connection con = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", "");

    String sql = "INSERT INTO cart (user_id, product_id, quantity) " +
                 "VALUES (?, ?, ?) " +
                 "ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)";
    ps = con.prepareStatement(sql);
    ps.setString(1, user);
    ps.setInt(2, productId);
    ps.setInt(3, quantity);
    ps.executeUpdate();

    // ── Redirect back to the product page with a success flag ─
    String goBack = (referer != null && !referer.trim().isEmpty())
                    ? referer
                    : "dashboard.jsp";
    response.sendRedirect(goBack + (goBack.contains("?") ? "&" : "?") + "cartMsg=added");

} catch (Exception e) {
    response.sendRedirect("dashboard.jsp?cartMsg=error&err=" + e.getMessage());
} finally {
    try { if (ps  != null) ps.close();  } catch (Exception ignored) {}
    try { if (con != null) con.close(); } catch (Exception ignored) {}
}
%>
