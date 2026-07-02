<%@page import="java.sql.*"%>

<%
String user = (String) session.getAttribute("user");

if(user == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<h2>Your Cart</h2>

<%
try{
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", ""
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM cart WHERE user_id=?"
    );
    ps.setString(1, user);

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>
        Product ID: <%= rs.getInt("product_id") %> |
        Quantity: <%= rs.getInt("quantity") %> <br>
<%
    }
}catch(Exception e){
    out.println(e);
}
%>

<br>

<form action="place_order.jsp" method="post">
    <button type="submit">Place Order</button>
</form>