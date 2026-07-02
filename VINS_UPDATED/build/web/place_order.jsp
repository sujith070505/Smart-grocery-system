<%@page import="java.sql.*"%>

<%
String user = (String) session.getAttribute("user");

try{
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", ""
    );

    // Create order
    PreparedStatement orderPs = con.prepareStatement(
        "INSERT INTO orders(user_id, total_amount) VALUES (?, ?)",
        Statement.RETURN_GENERATED_KEYS
    );

    orderPs.setString(1, user);
    orderPs.setDouble(2, 0);
    orderPs.executeUpdate();

    ResultSet rs = orderPs.getGeneratedKeys();
    rs.next();
    int orderId = rs.getInt(1);

    // Move cart ? order_items
    PreparedStatement cartPs = con.prepareStatement(
        "SELECT * FROM cart WHERE user_id=?"
    );
    cartPs.setString(1, user);

    ResultSet cartRs = cartPs.executeQuery();

    while(cartRs.next()){
        PreparedStatement itemPs = con.prepareStatement(
            "INSERT INTO order_items(order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)"
        );

        itemPs.setInt(1, orderId);
        itemPs.setInt(2, cartRs.getInt("product_id"));
        itemPs.setInt(3, cartRs.getInt("quantity"));
        itemPs.setDouble(4, 0);

        itemPs.executeUpdate();
    }

    // Clear cart
    PreparedStatement del = con.prepareStatement(
        "DELETE FROM cart WHERE user_id=?"
    );
    del.setString(1, user);
    del.executeUpdate();

    out.println("<h3>Order Placed Successfully!</h3>");
    out.println("<a href='dashboard.jsp'>Go Back</a>");

}catch(Exception e){
    out.println(e);
}
%>