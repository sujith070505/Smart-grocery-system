<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

// ── Cart count for badge ──────────────────────────────────────
int cartCount = 0;

// ── Fetch cart items ──────────────────────────────────────────
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

// We'll build display data in simple parallel arrays (no import needed)
java.util.List<Integer> cartIds    = new java.util.ArrayList<>();
java.util.List<Integer> productIds = new java.util.ArrayList<>();
java.util.List<String>  names      = new java.util.ArrayList<>();
java.util.List<String>  images     = new java.util.ArrayList<>();
java.util.List<Double>  bestPrices = new java.util.ArrayList<>();
java.util.List<Integer> quantities = new java.util.ArrayList<>();
java.util.List<Double>  lineTotals = new java.util.ArrayList<>();
double grandTotal = 0.0;
String dbError = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", "");

    ps = con.prepareStatement(
        "SELECT c.cart_id, c.product_id, c.quantity, " +
        "       p.name, p.image, " +
        "       p.bigbasket_price, p.dmart_price, p.blinkit_price " +
        "FROM cart c " +
        "JOIN products p ON c.product_id = p.id " +
        "WHERE c.user_id = ? ORDER BY c.cart_id DESC");
    ps.setString(1, user);
    rs = ps.executeQuery();

    while (rs.next()) {
        double bb    = (rs.getBigDecimal("bigbasket_price") != null ? rs.getBigDecimal("bigbasket_price").doubleValue() : 0.0);
        double dm    = (rs.getBigDecimal("dmart_price") != null ? rs.getBigDecimal("dmart_price").doubleValue() : 0.0);
        double blink = (rs.getBigDecimal("blinkit_price") != null ? rs.getBigDecimal("blinkit_price").doubleValue() : 0.0);
        double best  = Double.MAX_VALUE;
        if (bb    > 0 && bb    < best) best = bb;
        if (dm    > 0 && dm    < best) best = dm;
        if (blink > 0 && blink < best) best = blink;
        if (best == Double.MAX_VALUE)   best = 0;

        int qty      = rs.getInt("quantity");
        double lt    = best * qty;
        grandTotal  += lt;
        cartCount   += qty;

        cartIds.add(rs.getInt("cart_id"));
        productIds.add(rs.getInt("product_id"));
        names.add(rs.getString("name"));
        images.add(rs.getString("image"));
        bestPrices.add(best);
        quantities.add(qty);
        lineTotals.add(lt);
    }
} catch (Exception e) {
    dbError = e.getMessage();
} finally {
    try { if (rs  != null) rs.close();  } catch (Exception ignored) {}
    try { if (ps  != null) ps.close();  } catch (Exception ignored) {}
    try { if (con != null) con.close(); } catch (Exception ignored) {}
}

String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>🛒 My Cart – Smart Grocery</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif;}
body{background:#f5f7fa;}

/* NAVBAR */
.nav{display:flex;justify-content:space-between;align-items:center;
     padding:15px 40px;background:#2ecc71;color:white;
     box-shadow:0 2px 10px rgba(0,0,0,0.1);}
.nav h1{font-size:22px;}
.nav-right{display:flex;align-items:center;gap:15px;}
.btn{padding:8px 15px;border:none;border-radius:5px;cursor:pointer;
     background:white;color:#2ecc71;font-weight:bold;}
.btn:hover{background:#27ae60;color:white;}

/* MAIN */
.container{max-width:950px;margin:40px auto;padding:0 20px;}
h2{margin-bottom:25px;color:#2c3e50;font-size:26px;}

/* TABLE */
.cart-table{width:100%;border-collapse:collapse;background:white;
            border-radius:14px;overflow:hidden;
            box-shadow:0 4px 20px rgba(0,0,0,0.08);}
.cart-table th{background:#2ecc71;color:white;padding:14px 16px;
               text-align:left;font-size:14px;}
.cart-table td{padding:14px 16px;border-bottom:1px solid #f0f0f0;
               vertical-align:middle;font-size:14px;}
.cart-table tr:last-child td{border-bottom:none;}
.cart-table img{width:55px;height:55px;object-fit:cover;
                border-radius:8px;border:2px solid #e9ecef;}

/* QTY FORM */
.qty-form{display:inline-flex;align-items:center;gap:6px;}
.qty-input{width:55px;padding:7px;border:1px solid #ccc;
           border-radius:6px;text-align:center;font-size:14px;}
.update-btn{padding:7px 13px;background:#3498db;color:white;
            border:none;border-radius:6px;cursor:pointer;}
.update-btn:hover{background:#2980b9;}

/* REMOVE */
.remove-btn{padding:7px 13px;background:#e74c3c;color:white;
            border:none;border-radius:6px;cursor:pointer;}
.remove-btn:hover{background:#c0392b;}

/* TOTALS */
.totals-row td{font-weight:bold;background:#f8f9fa;font-size:15px;}
.grand-total{color:#e74c3c;font-size:20px;font-weight:800;}

/* ACTION BAR */
.action-bar{display:flex;justify-content:space-between;align-items:center;
            margin-top:30px;flex-wrap:wrap;gap:15px;}
.continue-btn{padding:12px 28px;background:#95a5a6;color:white;border:none;
              border-radius:25px;font-size:15px;cursor:pointer;font-weight:600;}
.continue-btn:hover{background:#7f8c8d;}
.place-btn{padding:14px 36px;
           background:linear-gradient(135deg,#2ecc71,#27ae60);
           color:white;border:none;border-radius:25px;font-size:16px;
           cursor:pointer;font-weight:700;
           box-shadow:0 6px 20px rgba(46,204,113,0.4);}
.place-btn:hover{transform:scale(1.03);}

/* EMPTY */
.empty-state{text-align:center;padding:80px 20px;color:#7f8c8d;}
.empty-state .icon{font-size:64px;display:block;margin-bottom:15px;}

/* ALERTS */
.alert{padding:14px 20px;border-radius:8px;margin-bottom:20px;font-weight:600;}
.alert-red {background:#fde8e8;color:#c0392b;border:1px solid #f5c6c6;}
.alert-blue{background:#eaf6ff;color:#2980b9;border:1px solid #bee3f8;}
</style>
</head>
<body>

<!-- NAVBAR -->
<div class="nav">
    <h1><a href="dashboard.jsp" style="color:white;text-decoration:none;">🛒 Smart Grocery</a></h1>
    <div class="nav-right">
        👤 <strong><%= user %></strong>
        <a href="dashboard.jsp"><button class="btn">🏠 Home</button></a>
        <button class="btn" onclick="if(confirm('Logout?')) window.location.href='logout.jsp'">🚪 Logout</button>
    </div>
</div>

<!-- CONTENT -->
<div class="container">
    <h2>🛒 My Cart</h2>

    <% if (dbError != null) { %>
        <div class="alert alert-red">⚠️ Database error: <%= dbError %></div>
    <% } %>

    <% if ("empty".equals(msg)) { %>
        <div class="alert alert-blue">ℹ️ Your cart is empty. Add products first!</div>
    <% } %>

    <% if (cartIds.isEmpty()) { %>
        <!-- EMPTY STATE -->
        <div class="empty-state">
            <span class="icon">🛒</span>
            <h3>Your cart is empty</h3>
            <p>Browse categories and add products you like.</p>
            <br>
            <button class="place-btn" onclick="window.location.href='dashboard.jsp'">
                🏠 Go to Dashboard
            </button>
        </div>

    <% } else { %>
        <!-- CART TABLE -->
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Product</th>
                    <th>Best Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Remove</th>
                </tr>
            </thead>
            <tbody>
            <% for (int i = 0; i < cartIds.size(); i++) { %>
                <tr>
                    <td>
                        <img src="<%= images.get(i) %>"
                             alt="<%= names.get(i) %>"
                             onerror="this.src='https://via.placeholder.com/55x55/f0f8ff/87ceeb?text=🛒'">
                    </td>
                    <td><strong><%= names.get(i) %></strong></td>
                    <td>₹<%= String.format("%.0f", bestPrices.get(i)) %></td>
                    <td>
                        <form class="qty-form" method="post" action="updatecart.jsp">
                            <input type="hidden" name="cart_id" value="<%= cartIds.get(i) %>">
                            <input class="qty-input" type="number" name="quantity"
                                   value="<%= quantities.get(i) %>" min="1" max="99">
                            <button class="update-btn" type="submit">✔</button>
                        </form>
                    </td>
                    <td><strong>₹<%= String.format("%.0f", lineTotals.get(i)) %></strong></td>
                    <td>
                        <form method="post" action="removefromcart.jsp"
                              onsubmit="return confirm('Remove this item?')">
                            <input type="hidden" name="cart_id" value="<%= cartIds.get(i) %>">
                            <button class="remove-btn" type="submit">🗑 Remove</button>
                        </form>
                    </td>
                </tr>
            <% } %>
                <!-- GRAND TOTAL ROW -->
                <tr class="totals-row">
                    <td colspan="4" style="text-align:right;padding-right:20px;">
                        Grand Total:
                    </td>
                    <td colspan="2" class="grand-total">
                        ₹<%= String.format("%.0f", grandTotal) %>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- ACTION BUTTONS -->
        <div class="action-bar">
            <button class="continue-btn" onclick="window.location.href='dashboard.jsp'">
                ← Continue Shopping
            </button>
            <form method="post" action="placeorder.jsp"
                  onsubmit="return confirm('Place order for ₹<%= String.format("%.0f", grandTotal) %>?')">
                <button class="place-btn" type="submit">
                    ✅ Place Order (₹<%= String.format("%.0f", grandTotal) %>)
                </button>
            </form>
        </div>
    <% } %>
</div>

</body>
</html>
