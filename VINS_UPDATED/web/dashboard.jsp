<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
if(user == null){
    response.sendRedirect("login.jsp");
    return;
}

// Cart count for badge
int cartCount = 0;
Connection conBadge = null; PreparedStatement psBadge = null; ResultSet rsBadge = null;
try {
    Class.forName("com.mysql.jdbc.Driver");
    conBadge = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery","root","");
    psBadge  = conBadge.prepareStatement("SELECT COALESCE(SUM(quantity),0) FROM cart WHERE user_id=?");
    psBadge.setString(1, user);
    rsBadge  = psBadge.executeQuery();
    if(rsBadge.next()) cartCount = rsBadge.getInt(1);
} catch(Exception ex){ cartCount = 0; } finally {
    try{if(rsBadge!=null)rsBadge.close();}catch(Exception ex){}
    try{if(psBadge!=null)psBadge.close();}catch(Exception ex){}
    try{if(conBadge!=null)conBadge.close();}catch(Exception ex){}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart Grocery Dashboard</title>
<link rel="icon" href="images/grocery.webp">
<style>
* { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
body { background: #f5f7fa; }

/* NAVBAR — original, unchanged */
.nav { display: flex; justify-content: space-between; align-items: center; padding: 15px 40px; background: #2ecc71; color: white; }
.nav h1 { font-size: 22px; }
.nav input { padding: 8px; border-radius: 5px; border: none; width: 250px; }
.nav_button button { margin-left: 10px; padding: 8px 15px; border: none; border-radius: 5px; cursor: pointer; background: white; color: #2ecc71; font-weight: bold; transition: 0.3s; }
.nav_button button:hover { background: #27ae60; color: white; }

/* Cart button */
.cart-btn { margin-left: 10px; padding: 8px 15px; border: none; border-radius: 5px; cursor: pointer; color: white; font-weight: bold; position: relative; transition: 0.3s; }
.cart-btn:hover { background: #229954; }
.cart-badge { position: absolute; top: -6px; right: -6px; background: #e74c3c; color: white; border-radius: 50%; width: 18px; height: 18px; font-size: 11px; display: flex; align-items: center; justify-content: center; }

/* HERO — unchanged */
.save { height: 300px; display: flex; flex-direction: column; justify-content: center; align-items: center; background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url(images/back.jpg); background-size: cover; color: white; text-align: center; }
.save h1 { font-size: 40px; }
.save button { margin-top: 15px; padding: 10px 20px; background: #2ecc71; border: none; border-radius: 5px; color: white; cursor: pointer; }

/* CATEGORIES — unchanged */
.categories { display: grid; grid-template-columns: repeat(auto-fit, minmax(130px, 1fr)); gap: 15px; padding: 30px; }
.category { background: white; padding: 15px 10px; text-align: center; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); cursor: pointer; transition: 0.2s; }
.category:hover { transform: translateY(-5px); }
.category a { text-decoration: none; color: inherit; display: block; }
.category span { font-size: 26px; display: block; margin-bottom: 5px; }
.category p { font-size: 13px; font-weight: 600; }

/* ALL PRODUCTS SECTION */
.section-title { padding: 10px 30px 0 30px; font-size: 22px; font-weight: 700; color: #2c3e50; }
.products-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; padding: 20px 30px 40px 30px; }
.product-card { background: white; padding: 18px; border-radius: 14px; box-shadow: 0 4px 14px rgba(0,0,0,0.08); text-align: center; transition: 0.2s; }
.product-card:hover { transform: translateY(-5px); box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
.product-card img { width: 100px; height: 100px; object-fit: contain; border-radius: 10px; margin-bottom: 10px; border: 3px solid #f5f7fa; }
.product-card h3 { font-size: 15px; font-weight: 600; color: #2c3e50; margin-bottom: 6px; }
.category-tag { display: inline-block; padding: 3px 10px; background: #e8f8f0; color: #27ae60; border-radius: 20px; font-size: 11px; font-weight: 600; margin-bottom: 8px; text-transform: capitalize; }
.best-price { font-size: 16px; font-weight: 700; color: #2ecc71; margin-bottom: 10px; }
.add-cart-form { display: flex; align-items: center; gap: 6px; margin-top: 8px; justify-content: center; }
.qty-input { width: 55px; padding: 7px; border: 1px solid #ddd; border-radius: 20px; text-align: center; font-size: 13px; }
.add-cart-btn { flex: 1; padding: 9px; background: #2ecc71; color: white; border: none; border-radius: 20px; font-weight: 700; font-size: 13px; cursor: pointer; transition: 0.2s; }
.add-cart-btn:hover { background: #27ae60; }
.no-results { display: none; text-align: center; padding: 40px; color: #7f8c8d; font-size: 16px; grid-column: 1 / -1; }
</style>
</head>

<body>

<!-- NAVBAR -->
<div class="nav">
    <h1>&#x1F6D2; Smart Grocery</h1>
    <input type="text" id="searchInput" placeholder="Search products..." onkeyup="handleSearch(event)">
    <div class="nav_button">
        <a href="viewcart.jsp" style="text-decoration:none;">
            <button class="cart-btn">
                &#x1F6D2; My Cart
                <% if(cartCount > 0){ %><span class="cart-badge"><%= cartCount %></span><% } %>
            </button>
        </a>
        <button onclick="void(0)">&#x1F464; <%= user %></button>
        <button onclick="logoutConfirm()">&#x1F6AA; Logout</button>
    </div>
</div>

<!-- HERO — unchanged -->
<div class="save">
    <h1>Compare Prices &amp; Save Money</h1>
    <p>Find best deals instantly</p>
</div>

<!-- CATEGORIES — unchanged -->
<div class="categories">
    <div class="category"><a href="milk.jsp"><span>&#x1F95B;</span><p>Dairy</p></a></div>
    <div class="category"><a href="snacks.jsp"><span>&#x1F36A;</span><p>Snacks</p></a></div>
    <div class="category"><a href="staples.jsp"><span>&#x1F35A;</span><p>Staples</p></a></div>
    <div class="category"><a href="spices.jsp"><span>&#x1F336;&#xFE0F;</span><p>Spices &amp; Condiments</p></a></div>
    <div class="category"><a href="beverages.jsp"><span>&#x1F964;</span><p>Beverages</p></a></div>
    <div class="category"><a href="cleaning.jsp"><span>&#x1F9FC;</span><p>Household &amp; Cleaning</p></a></div>
</div>

<!-- ALL PRODUCTS — dynamically loaded from DB -->
<div class="section-title">&#x1F6CD;&#xFE0F; All Products</div>
<div class="products-grid" id="productsGrid">

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery","root","");
    ps  = con.prepareStatement("SELECT * FROM products ORDER BY category, id");
    rs  = ps.executeQuery();
    while(rs.next()) {
        String pName     = rs.getString("name");
        String pCategory = rs.getString("category");
        String pImage    = rs.getString("image");
        int    pId       = rs.getInt("id");
        double bb    = rs.getBigDecimal("bigbasket_price") != null ? rs.getBigDecimal("bigbasket_price").doubleValue() : 0.0;
        double dm    = rs.getBigDecimal("dmart_price")     != null ? rs.getBigDecimal("dmart_price").doubleValue()     : 0.0;
        double blink = rs.getBigDecimal("blinkit_price")   != null ? rs.getBigDecimal("blinkit_price").doubleValue()   : 0.0;
        double bestPrice = Double.MAX_VALUE;
        if(bb    > 0)                      bestPrice = bb;
        if(dm    > 0 && dm    < bestPrice) bestPrice = dm;
        if(blink > 0 && blink < bestPrice) bestPrice = blink;
        if(bestPrice == Double.MAX_VALUE)  bestPrice = 0;
        String categoryDisplay = (pCategory != null && !pCategory.trim().isEmpty()) ? pCategory.trim() : "";
%>
    <div class="product-card" data-name="<%= pName.toLowerCase() %>" data-category="<%= categoryDisplay.toLowerCase() %>">
        <img src="<%= pImage %>" alt="<%= pName %>" onerror="this.src='https://placehold.co/100x100/e8f8f0/2ecc71?text=Item'">
        <h3><%= pName %></h3>
        <% if(!categoryDisplay.isEmpty()){ %><div class="category-tag"><%= categoryDisplay %></div><% } %>
        <div class="best-price">&#x20B9;<%= bestPrice > 0 ? String.format("%.0f", bestPrice) : "--" %></div>
        <form class="add-cart-form" method="post" action="addtocart.jsp">
            <input type="hidden" name="product_id" value="<%= pId %>">
            <input type="hidden" name="referer" value="dashboard.jsp">
            <input class="qty-input" type="number" name="quantity" value="1" min="1" max="99">
            <button class="add-cart-btn" type="submit">&#x1F6D2; Add</button>
        </form>
    </div>
<%
    }
} catch(Exception e) {
    out.println("<p style='color:red;padding:20px;'>Error: " + e.getMessage() + "</p>");
} finally {
    try{if(rs!=null)rs.close();}catch(Exception e){}
    try{if(ps!=null)ps.close();}catch(Exception e){}
    try{if(con!=null)con.close();}catch(Exception e){}
}
%>
    <div class="no-results" id="noResults">&#x274C; No products found matching your search.</div>
</div>

<script>
function logoutConfirm() {
    if(confirm('Logout?')) window.location.href = "logout.jsp";
}

function handleSearch(event) {
    if(event.key === 'Enter') {
        var query = document.getElementById('searchInput').value.trim();
        if(query) { window.location.href = 'search.jsp?q=' + encodeURIComponent(query); return; }
    }
    filterProducts();
}

function filterProducts() {
    var query = document.getElementById('searchInput').value.toLowerCase().trim();
    var cards = document.querySelectorAll('.product-card');
    var visible = 0;
    cards.forEach(function(card) {
        var name     = card.getAttribute('data-name')     || '';
        var category = card.getAttribute('data-category') || '';
        var match    = name.includes(query) || category.includes(query);
        card.style.display = match ? 'block' : 'none';
        if(match) visible++;
    });
    document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';
}
</script>

</body>
</html>
