<%@page import="java.sql.*"%>

<%
String user = (String) session.getAttribute("user");

if(user == null){
    response.sendRedirect("login.jsp");
    return;
}

int productId = Integer.parseInt(request.getParameter("product_id"));

try{
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", ""
    );

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO cart(user_id, product_id, quantity) VALUES (?, ?, 1)"
    );
    ps.setString(1, user);
    ps.setInt(2, productId);
    ps.executeUpdate();

    response.sendRedirect("view_cart.jsp");

}catch(Exception e){
    out.println(e);
}
%>