<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
/**
 * placeorder.jsp
 * Converts the user's cart into a confirmed order.
 * Steps: read cart → insert orders → insert order_items → clear cart
 * All inside one transaction.
 */

String user = (String) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

Connection con = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", "");
    con.setAutoCommit(false); // BEGIN TRANSACTION

    // ── 1. Read cart items ────────────────────────────────────
    PreparedStatement fetchCart = con.prepareStatement(
        "SELECT c.product_id, c.quantity, " +
        "       p.bigbasket_price, p.dmart_price, p.blinkit_price " +
        "FROM cart c " +
        "JOIN products p ON c.product_id = p.id " +
        "WHERE c.user_id = ?");
    fetchCart.setString(1, user);
    ResultSet rs = fetchCart.executeQuery();

    java.util.List<Integer> pIds  = new java.util.ArrayList<>();
    java.util.List<Integer> qtys  = new java.util.ArrayList<>();
    java.util.List<Double>  prices = new java.util.ArrayList<>();
    double grandTotal = 0.0;

    while (rs.next()) {
        double bb    = rs.getDouble("bigbasket_price");
        double dm    = rs.getDouble("dmart_price");
        double blink = rs.getDouble("blinkit_price");
        double best  = Double.MAX_VALUE;
        if (bb    > 0 && bb    < best) best = bb;
        if (dm    > 0 && dm    < best) best = dm;
        if (blink > 0 && blink < best) best = blink;
        if (best == Double.MAX_VALUE)   best = 0;

        int qty = rs.getInt("quantity");
        grandTotal += best * qty;

        pIds.add(rs.getInt("product_id"));
        qtys.add(qty);
        prices.add(best);
    }
    rs.close();
    fetchCart.close();

    // ── Guard: empty cart ─────────────────────────────────────
    if (pIds.isEmpty()) {
        con.rollback();
        response.sendRedirect("viewcart.jsp?msg=empty");
        return;
    }

    // ── 2. Insert into orders ─────────────────────────────────
    PreparedStatement insertOrder = con.prepareStatement(
        "INSERT INTO orders (user_id, total_amount) VALUES (?, ?)",
        Statement.RETURN_GENERATED_KEYS);
    insertOrder.setString(1, user);
    insertOrder.setDouble(2, grandTotal);
    insertOrder.executeUpdate();

    ResultSet keys = insertOrder.getGeneratedKeys();
    int orderId = -1;
    if (keys.next()) orderId = keys.getInt(1);
    keys.close();
    insertOrder.close();

    // ── 3. Insert order_items ─────────────────────────────────
    PreparedStatement insertItem = con.prepareStatement(
        "INSERT INTO order_items (order_id, product_id, quantity, price) " +
        "VALUES (?, ?, ?, ?)");
    for (int i = 0; i < pIds.size(); i++) {
        insertItem.setInt(1, orderId);
        insertItem.setInt(2, pIds.get(i));
        insertItem.setInt(3, qtys.get(i));
        insertItem.setDouble(4, prices.get(i));
        insertItem.addBatch();
    }
    insertItem.executeBatch();
    insertItem.close();

    // ── 4. Clear cart ─────────────────────────────────────────
    PreparedStatement clearCart = con.prepareStatement(
        "DELETE FROM cart WHERE user_id = ?");
    clearCart.setString(1, user);
    clearCart.executeUpdate();
    clearCart.close();

    con.commit(); // COMMIT

    // Store for confirmation page
    session.setAttribute("lastOrderId",    orderId);
    session.setAttribute("lastOrderTotal", grandTotal);

    response.sendRedirect("checkout.jsp?status=success");

} catch (Exception e) {
    try { if (con != null) con.rollback(); } catch (Exception ignored) {}
    response.sendRedirect("checkout.jsp?status=error&msg=" +
        java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
} finally {
    try { if (con != null) con.close(); } catch (Exception ignored) {}
}
%>
