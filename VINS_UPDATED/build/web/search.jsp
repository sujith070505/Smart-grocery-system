<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
if(user == null){
    response.sendRedirect("login.jsp");
    return;
}

String query = request.getParameter("q");
if(query == null) query = "";
query = query.trim();
%>

<!DOCTYPE html>
<html>
<head>
<title>Search Results - Smart Grocery</title>

<style>
body { font-family:'Segoe UI'; background:#f5f7fa; }

/* NAV */
.nav { display:flex; justify-content:space-between; align-items:center; padding:15px 40px; background:#00c853; color:white; }
.nav input { padding:8px; border:none; border-radius:5px; width:250px; }
.products { display:grid; grid-template-columns:repeat(auto-fit,minmax(300px,1fr)); gap:20px; padding:30px; }
.card { background:white; padding:20px; border-radius:15px; box-shadow:0 5px 20px rgba(0,0,0,0.1); }
.price { font-weight:bold; font-size:18px; }
.best { color:#00c853; font-weight:bold; }
</style>

</head>

<body>

<!-- NAV -->
<div class="nav">
    <h2>&#x1F50D; Search: "<%= query %>"</h2>

    <form action="search.jsp">
        <input type="text" name="q" placeholder="Search..." value="<%= query %>">
    </form>

    <div>
        &#x1F464; <%= user %>
        &nbsp;&nbsp;
        <a href="dashboard.jsp" style="color:white;">&#x1F3E0; Home</a>
    </div>
</div>

<!-- RESULTS -->
<div class="products">

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
boolean found = false;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery","root","");

    /* Search by product name OR category */
    String sql = "SELECT * FROM products WHERE name LIKE ? OR category LIKE ?";
    ps = con.prepareStatement(sql);
    String like = "%" + query + "%";
    ps.setString(1, like);
    ps.setString(2, like);

    rs = ps.executeQuery();

    while(rs.next()){
        found = true;

        double bb  = rs.getBigDecimal("bigbasket_price") != null ? rs.getBigDecimal("bigbasket_price").doubleValue() : 0.0;
        double dm  = rs.getBigDecimal("dmart_price")     != null ? rs.getBigDecimal("dmart_price").doubleValue()     : 0.0;
        double bl  = rs.getBigDecimal("blinkit_price")   != null ? rs.getBigDecimal("blinkit_price").doubleValue()   : 0.0;

        double best = Double.MAX_VALUE;
        String platform = "";

        if(bb > 0){ best = bb; platform = "BigBasket"; }
        if(dm > 0 && dm < best){ best = dm; platform = "DMart"; }
        if(bl > 0 && bl < best){ best = bl; platform = "Blinkit"; }
        if(best == Double.MAX_VALUE){ best = 0; platform = "N/A"; }
%>

<div class="card">

    <img src="<%= rs.getString("image") %>" width="100" height="100"
         onerror="this.src='https://placehold.co/100x100/e8f8f0/2ecc71?text=Item'">

    <h3><%= rs.getString("name") %></h3>

    <% if(rs.getString("category") != null && !rs.getString("category").trim().isEmpty()){ %>
    <p style="font-size:12px;color:#27ae60;font-weight:600;text-transform:capitalize;">
        &#x1F4CB; <%= rs.getString("category") %>
    </p>
    <% } %>

    <p>&#x1F6D2; BigBasket: &#x20B9;<%= bb > 0 ? String.format("%.0f",bb) : "---" %></p>
    <p>&#x1F3EA; DMart: &#x20B9;<%= dm > 0 ? String.format("%.0f",dm) : "---" %></p>
    <p>&#x26A1; Blinkit: &#x20B9;<%= bl > 0 ? String.format("%.0f",bl) : "---" %></p>

    <p class="best">&#x1F3AF; Best Price: &#x20B9;<%= best > 0 ? String.format("%.0f",best) : "---" %> (<%= platform %>)</p>

    <a href="<%= rs.getString("link") %>" target="_blank">
        <button>Buy Now</button>
    </a>

    <form style="display:flex;gap:6px;margin-top:8px;" method="post" action="addtocart.jsp">
        <input type="hidden" name="product_id" value="<%= rs.getInt("id") %>">
        <input type="hidden" name="referer" value="search.jsp?q=<%= java.net.URLEncoder.encode(query,"UTF-8") %>">
        <input type="number" name="quantity" value="1" min="1" max="99"
               style="width:55px;padding:7px;border:1px solid #ddd;border-radius:20px;text-align:center;">
        <button type="submit"
                style="flex:1;padding:9px;background:#00c853;color:white;border:none;border-radius:20px;font-weight:700;cursor:pointer;">
            &#x1F6D2; Add to Cart
        </button>
    </form>

</div>

<%
    }

    if(!found){
%>
    <h3 style="padding:20px;">&#x274C; No products found for "<%= query %>"</h3>
<%
    }

} catch(Exception e) {
%>
    <p style="color:red;">Error: <%= e.getMessage() %></p>
<%
} finally {
    try{if(rs!=null) rs.close();}catch(Exception e){}
    try{if(ps!=null) ps.close();}catch(Exception e){}
    try{if(con!=null) con.close();}catch(Exception e){}
}
%>

</div>

</body>
</html>
