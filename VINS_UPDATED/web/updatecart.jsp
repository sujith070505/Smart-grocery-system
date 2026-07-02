<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/**
 * updatecart.jsp
 * Updates quantity of a cart row for the logged-in user.
 * Params: cart_id, quantity
 */

String user = (String) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

String cartIdStr = request.getParameter("cart_id");
String qtyStr    = request.getParameter("quantity");

if (cartIdStr == null || qtyStr == null) {
    response.sendRedirect("viewcart.jsp");
    return;
}

int cartId = Integer.parseInt(cartIdStr.trim());
int qty    = Integer.parseInt(qtyStr.trim());
if (qty < 1) qty = 1;

Connection con = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", "");

    // user_id check prevents tampering with other users' rows
    ps = con.prepareStatement(
        "UPDATE cart SET quantity = ? WHERE cart_id = ? AND user_id = ?");
    ps.setInt(1, qty);
    ps.setInt(2, cartId);
    ps.setString(3, user);
    ps.executeUpdate();

} catch (Exception e) {
    // silently continue – cart page will still load
} finally {
    try { if (ps  != null) ps.close();  } catch (Exception ignored) {}
    try { if (con != null) con.close(); } catch (Exception ignored) {}
}

response.sendRedirect("viewcart.jsp");
%>
