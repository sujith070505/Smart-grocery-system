<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/**
 * removefromcart.jsp
 * Deletes one cart row belonging to the logged-in user.
 * Param: cart_id
 */

String user = (String) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

String cartIdStr = request.getParameter("cart_id");
if (cartIdStr == null || cartIdStr.trim().isEmpty()) {
    response.sendRedirect("viewcart.jsp");
    return;
}

int cartId = Integer.parseInt(cartIdStr.trim());

Connection con = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", "");

    ps = con.prepareStatement(
        "DELETE FROM cart WHERE cart_id = ? AND user_id = ?");
    ps.setInt(1, cartId);
    ps.setString(2, user);
    ps.executeUpdate();

} catch (Exception e) {
    // silently continue
} finally {
    try { if (ps  != null) ps.close();  } catch (Exception ignored) {}
    try { if (con != null) con.close(); } catch (Exception ignored) {}
}

response.sendRedirect("viewcart.jsp");
%>
