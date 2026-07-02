<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
if(user == null){
    response.sendRedirect("login.jsp");
    return;
}

// ── Cart count for badge ──────────────────────────────────────
int cartCount = 0;
Connection conBadge = null; PreparedStatement psBadge = null; ResultSet rsBadge = null;
try {
    Class.forName("com.mysql.jdbc.Driver");
    conBadge = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery","root","");
    psBadge  = conBadge.prepareStatement("SELECT CAST(COALESCE(SUM(quantity),0) AS UNSIGNED) FROM cart WHERE user_id=?");
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
<title>🥛 Milk Products - Smart Grocery</title>
<style>
* {margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif;}
body {background:#f5f7fa;}

/* NAVBAR */
.nav {display:flex;justify-content:space-between;align-items:center;padding:15px 40px;background:#00c853;color:white;box-shadow:0 2px 10px rgba(0,0,0,0.1);}
.nav h1 {font-size:22px;}
.nav input {padding:8px;border-radius:5px;border:none;width:250px;}
.nav-right {display:flex;align-items:center;gap:15px;}
.username {font-weight:bold;}
.btn {padding:8px 15px;border:none;border-radius:5px;cursor:pointer;background:white;color:#00c853;font-weight:bold;}
.btn:hover {background:#00b248;color:white;}

/* Cart button */
.cart-btn{padding:8px 15px;border:none;border-radius:5px;cursor:pointer;
          background:white;color:#00c853;font-weight:bold;position:relative;}
.cart-btn:hover{background:#00b248;color:white;}
.cart-badge{position:absolute;top:-6px;right:-6px;background:#e74c3c;color:white;
            border-radius:50%;width:18px;height:18px;font-size:11px;
            display:flex;align-items:center;justify-content:center;}

/* HERO */
.hero {height:220px;display:flex;flex-direction:column;justify-content:center;align-items:center;background:linear-gradient(rgba(0,0,0,0.6),rgba(0,0,0,0.4)),url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 600"><rect fill="%23f0f8ff" width="1200" height="600"/></svg>');background-size:cover;color:white;text-align:center;}
.hero h1 {font-size:34px;}
.hero p {font-size:16px;opacity:0.9;}

/* PRODUCTS */
.products {display:grid;grid-template-columns:repeat(auto-fit,minmax(350px,1fr));gap:25px;padding:40px 20px;max-width:1400px;margin:0 auto;}
.product-card {background:white;padding:25px;border-radius:20px;box-shadow:0 10px 30px rgba(0,0,0,0.1);transition:all 0.3s;}
.product-card:hover {transform:translateY(-10px);box-shadow:0 20px 50px rgba(0,0,0,0.15);}
.product-img {width:120px;height:120px;object-fit:contain;border-radius:15px;margin:0 auto 15px;display:block;border:4px solid #f8f9fa;}
.product-name {font-size:20px;font-weight:600;color:#2c3e50;text-align:center;margin-bottom:15px;}

/* PRICE COMPARISON */
.price-table {background:#f8f9fa;border-radius:15px;padding:20px;margin:20px 0;}
.price-row {display:grid;grid-template-columns:1fr 1fr 1fr 80px;gap:10px;margin:10px 0;align-items:center;}
.platform {padding:10px;border-radius:10px;text-align:center;font-weight:600;font-size:16px;}
.platform.bigbasket {background:#2874f0;color:white;}
.platform.dmart {background:#ff6f00;color:white;}
.platform.blinkit {background:#00c853;color:white;}
.price-value {font-weight:bold;font-size:18px;}
.no-price {color:#999;font-style:italic;}

/* BEST DEAL */
.best-deal {background:linear-gradient(135deg,#00c853,#00b248);color:white;padding:15px;border-radius:15px;text-align:center;margin:20px 0;font-size:18px;font-weight:600;box-shadow:0 8px 25px rgba(0,200,83,0.4);}
.best-deal strong {font-size:24px;}

/* BUY BUTTON */
.buy-btn {display:block;width:100%;padding:15px;background:linear-gradient(135deg,#00c853,#00b248);color:white;text-decoration:none;border-radius:25px;font-weight:600;text-align:center;transition:all 0.3s;}
.buy-btn:hover {transform:scale(1.02);box-shadow:0 8px 25px rgba(0,200,83,0.4);}

/* Add to Cart form */
.add-cart-form{display:flex;align-items:center;gap:8px;margin-top:10px;}
.qty-input{width:60px;padding:9px;border:1px solid #ddd;border-radius:20px;
           text-align:center;font-size:14px;}
.add-cart-btn{flex:1;padding:11px;background:#00c853;color:white;border:none;
              border-radius:25px;font-weight:700;font-size:14px;cursor:pointer;
              box-shadow:0 4px 12px rgba(0,200,83,0.35);transition:all 0.25s;}
.add-cart-btn:hover{background:#00b248;transform:scale(1.02);}

.empty {text-align:center;padding:80px;color:#7f8c8d;}

/* Toast */
#cartToast{position:fixed;top:70px;right:20px;z-index:9999;
           background:#2ecc71;color:white;padding:14px 22px;
           border-radius:10px;font-weight:700;font-size:15px;
           box-shadow:0 6px 20px rgba(0,0,0,0.15);}
</style>
</head>
<body>

<%-- Flash toast --%>
<% String cartMsg = request.getParameter("cartMsg"); %>
<% if("added".equals(cartMsg)){ %>
<div id="cartToast">✅ Product added to cart!</div>
<script>setTimeout(function(){var t=document.getElementById('cartToast');if(t)t.style.display='none';},3000);</script>
<% } %>

<!-- NAVBAR -->
<div class="nav">
    <h1><a href="dashboard.jsp" style="color:white;text-decoration:none;">🛒 Smart Grocery</a></h1>
    <input type="text" id="searchInput" placeholder="🔍 Search milk products..." onkeyup="filterProducts()">
    <div class="nav-right">
        👤 <span class="username"><%= user %></span>
        <a href="dashboard.jsp"><button class="btn">🏠 Home</button></a>

        <a href="viewcart.jsp" style="text-decoration:none;">
            <button class="cart-btn">
                🛒 Cart
                <% if(cartCount > 0){ %>
                    <span class="cart-badge"><%= cartCount %></span>
                <% } %>
            </button>
        </a>

        <button class="btn" onclick="logout()">🚪 Logout</button>
    </div>
</div>

<!-- HERO -->
<div class="hero">
    <h1>🥛 Milk & Dairy</h1>
    <p>Compare BigBasket • DMart • Blinkit | Find Best Prices Instantly</p>
</div>

<!-- PRODUCTS -->
<div class="products" id="productsContainer">
<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
int productCount = 0;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery","root","");
    st = con.createStatement();
    rs = st.executeQuery("SELECT * FROM products WHERE category='milk' ORDER BY id DESC");

    while(rs.next()) {
        productCount++;
        double bb    = rs.getBigDecimal("bigbasket_price") != null ? rs.getBigDecimal("bigbasket_price").doubleValue() : 0.0;
        double dm    = rs.getBigDecimal("dmart_price")     != null ? rs.getBigDecimal("dmart_price").doubleValue()     : 0.0;
        double blink = rs.getBigDecimal("blinkit_price")   != null ? rs.getBigDecimal("blinkit_price").doubleValue()   : 0.0;

        double bestPrice = Double.MAX_VALUE;
        String bestPlatform = "";
        if(bb    > 0)                         { bestPrice = bb;    bestPlatform = "BigBasket"; }
        if(dm    > 0 && dm    < bestPrice)    { bestPrice = dm;    bestPlatform = "DMart"; }
        if(blink > 0 && blink < bestPrice)    { bestPrice = blink; bestPlatform = "Blinkit"; }
        if(bestPrice == Double.MAX_VALUE)      { bestPrice = 0;     bestPlatform = "N/A"; }
%>
        <div class="product-card" data-name="<%= rs.getString("name").toLowerCase() %>">
            <img src="<%= rs.getString("image") %>" alt="<%= rs.getString("name") %>" class="product-img"
                 onerror="this.src='https://via.placeholder.com/120x120/f0f8ff/87ceeb?text=🥛'">

            <h3 class="product-name"><%= rs.getString("name") %></h3>

            <div class="price-table">
                <div class="price-row">
                    <div class="platform bigbasket">🛒 BigBasket</div>
                    <div class="price-value <%= bb > 0 ? "" : "no-price" %>">₹<%= bb > 0 ? String.format("%.0f", bb) : "---" %></div>
                    <div class="platform dmart">🏪 DMart</div>
                    <div class="price-value <%= dm > 0 ? "" : "no-price" %>">₹<%= dm > 0 ? String.format("%.0f", dm) : "---" %></div>
                </div>
                <div class="price-row">
                    <div class="platform blinkit">⚡ Blinkit</div>
                    <div class="price-value <%= blink > 0 ? "" : "no-price" %>">₹<%= blink > 0 ? String.format("%.0f", blink) : "---" %></div>
                    <div class="best-deal">
                        🎯 Best: <strong>₹<%= String.format("%.0f", bestPrice) %> (<%= bestPlatform %>)</strong>
                    </div>
                    <div></div>
                </div>
            </div>

            <a href="<%= rs.getString("link") %>" target="_blank" class="buy-btn">
                🛒 Buy at Best Price (₹<%= String.format("%.0f", bestPrice) %>)
            </a>

            <form class="add-cart-form" method="post" action="addtocart.jsp">
                <input type="hidden" name="product_id" value="<%= rs.getInt("id") %>">
                <input type="hidden" name="referer"    value="milk.jsp">
                <input class="qty-input" type="number" name="quantity"
                       value="1" min="1" max="99">
                <button class="add-cart-btn" type="submit">🛒 Add to Cart</button>
            </form>

        </div>
<%
    }
} catch(Exception e) {
%>
    <div class="empty">
        <h3>⚠️ Error Loading Products</h3>
        <p><%= e.getMessage() %></p>
    </div>
<%
} finally {
    try{if(rs!=null) rs.close();}catch(Exception e){}
    try{if(st!=null) st.close();}catch(Exception e){}
    try{if(con!=null) con.close();}catch(Exception e){}
}
%>

<% if(productCount == 0) { %>
    <div class="empty">
        <h3>🥛 No Milk Products Yet</h3>
        <p>Admin will add products soon. Check other categories!</p>
        <a href="dashboard.jsp" class="buy-btn">← Back to Dashboard</a>
    </div>
<% } %>
</div>

<script>
function logout() {
    if(confirm('Logout?')) window.location.href = "logout.jsp";
}
function filterProducts() {
    const query = document.getElementById('searchInput').value.toLowerCase();
    const cards = document.querySelectorAll('.product-card');
    cards.forEach(card => {
        const name = card.getAttribute('data-name');
        card.style.display = name.includes(query) ? 'block' : 'none';
    });
}
</script>

</body>
</html>
