<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String admin = (String) session.getAttribute("admin");
if (admin == null) { response.sendRedirect("admin.jsp"); return; }

// ── Fetch all orders ──────────────────────────────────────────
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

// Parallel arrays for orders
java.util.List<Integer> orderIds    = new java.util.ArrayList<>();
java.util.List<String>  userIds     = new java.util.ArrayList<>();
java.util.List<Double>  totals      = new java.util.ArrayList<>();
java.util.List<String>  orderDates  = new java.util.ArrayList<>();

// Map: orderId → list of "ProductName | qty | price | lineTotal"
java.util.Map<Integer, java.util.List<String[]>> itemsMap =
    new java.util.LinkedHashMap<>();

String dbError = null;
double totalRevenue = 0;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery", "root", "");

    // Orders
    ps = con.prepareStatement(
        "SELECT order_id, user_id, total_amount, order_date " +
        "FROM orders ORDER BY order_date DESC");
    rs = ps.executeQuery();
    while (rs.next()) {
        int oid = rs.getInt("order_id");
        orderIds.add(oid);
        userIds.add(rs.getString("user_id"));
        double t = rs.getDouble("total_amount");
        totals.add(t);
        totalRevenue += t;
        orderDates.add(rs.getTimestamp("order_date").toString());
        itemsMap.put(oid, new java.util.ArrayList<>());
    }
    rs.close(); ps.close();

    // Order items
    ps = con.prepareStatement(
        "SELECT oi.order_id, p.name, oi.quantity, oi.price " +
        "FROM order_items oi " +
        "JOIN products p ON oi.product_id = p.id " +
        "ORDER BY oi.order_id DESC");
    rs = ps.executeQuery();
    while (rs.next()) {
        int oid = rs.getInt("order_id");
        if (itemsMap.containsKey(oid)) {
            double price = rs.getDouble("price");
            int qty = rs.getInt("quantity");
            itemsMap.get(oid).add(new String[]{
                rs.getString("name"),
                String.valueOf(qty),
                String.format("%.0f", price),
                String.format("%.0f", price * qty)
            });
        }
    }
} catch (Exception e) {
    dbError = e.getMessage();
} finally {
    try { if (rs  != null) rs.close();  } catch (Exception ignored) {}
    try { if (ps  != null) ps.close();  } catch (Exception ignored) {}
    try { if (con != null) con.close(); } catch (Exception ignored) {}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>📋 All Orders – Admin | Smart Grocery</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif;}
body{background:#f0f2f5;}

/* NAVBAR */
.nav{display:flex;justify-content:space-between;align-items:center;
     padding:15px 40px;background:#2c3e50;color:white;}
.nav h1{font-size:22px;}
.nav-right{display:flex;gap:10px;}
.btn{padding:8px 15px;border:none;border-radius:5px;cursor:pointer;
     background:#2ecc71;color:white;font-weight:bold;}
.btn:hover{background:#27ae60;}
.btn-red{background:#e74c3c;}
.btn-red:hover{background:#c0392b;}

/* CONTAINER */
.container{max-width:1100px;margin:40px auto;padding:0 20px;}
.page-title{font-size:26px;font-weight:700;color:#2c3e50;margin-bottom:6px;}
.subtitle{color:#7f8c8d;margin-bottom:28px;}

/* STATS */
.stats{display:flex;gap:20px;flex-wrap:wrap;margin-bottom:28px;}
.stat-card{background:white;padding:20px 28px;border-radius:12px;
           box-shadow:0 3px 12px rgba(0,0,0,0.07);flex:1;min-width:150px;
           border-left:4px solid #2ecc71;}
.stat-card .lbl{font-size:13px;color:#7f8c8d;margin-bottom:5px;}
.stat-card .val{font-size:26px;font-weight:700;color:#2c3e50;}

/* ORDER CARD */
.order-card{background:white;border-radius:14px;margin-bottom:22px;
            box-shadow:0 4px 18px rgba(0,0,0,0.07);overflow:hidden;}
.order-hdr{display:flex;justify-content:space-between;align-items:center;
           flex-wrap:wrap;gap:10px;
           padding:15px 22px;background:#f8f9fa;
           border-bottom:2px solid #ecf0f1;}
.oid{font-size:16px;font-weight:700;color:#2c3e50;}
.ouser{color:#3498db;font-weight:600;}
.odate{color:#7f8c8d;font-size:13px;}
.ototal{font-size:17px;font-weight:700;color:#e74c3c;}

/* ITEMS TABLE */
.tbl{width:100%;border-collapse:collapse;}
.tbl th{background:#ecf0f1;padding:11px 18px;text-align:left;
        font-size:13px;color:#555;}
.tbl td{padding:12px 18px;border-bottom:1px solid #f5f5f5;font-size:14px;}
.tbl tr:last-child td{border-bottom:none;}
.tbl tr:hover td{background:#fafeff;}

/* EMPTY / ALERT */
.empty{text-align:center;padding:80px;color:#7f8c8d;}
.empty .ico{font-size:56px;display:block;margin-bottom:15px;}
.alert{padding:14px 20px;border-radius:8px;margin-bottom:20px;
       font-weight:600;background:#fde8e8;color:#c0392b;
       border:1px solid #f5c6c6;}
</style>
</head>
<body>

<div class="nav">
    <h1>⚙️ Smart Grocery – Admin</h1>
    <div class="nav-right">
        <a href="admin_dashboard.jsp"><button class="btn">📦 Products</button></a>
        <button class="btn btn-red"
                onclick="if(confirm('Logout?')) window.location.href='logout.jsp'">
            🚪 Logout
        </button>
    </div>
</div>

<div class="container">
    <div class="page-title">📋 All Customer Orders</div>
    <div class="subtitle">Every order placed by users, with full product details.</div>

    <% if (dbError != null) { %>
        <div class="alert">⚠️ Database error: <%= dbError %></div>
    <% } %>

    <!-- STATS BAR -->
    <div class="stats">
        <div class="stat-card">
            <div class="lbl">Total Orders</div>
            <div class="val"><%= orderIds.size() %></div>
        </div>
        <div class="stat-card" style="border-left-color:#3498db;">
            <div class="lbl">Total Revenue</div>
            <div class="val">₹<%= String.format("%.0f", totalRevenue) %></div>
        </div>
        <div class="stat-card" style="border-left-color:#e67e22;">
            <div class="lbl">Logged-in Admin</div>
            <div class="val" style="font-size:18px;"><%= admin %></div>
        </div>
    </div>

    <% if (orderIds.isEmpty()) { %>
        <div class="empty">
            <span class="ico">📭</span>
            <h3>No orders placed yet</h3>
            <p>Once users place orders, they will appear here.</p>
        </div>
    <% } else {
        for (int i = 0; i < orderIds.size(); i++) {
            int oid = orderIds.get(i);
            java.util.List<String[]> items = itemsMap.get(oid);
    %>
        <div class="order-card">
            <div class="order-hdr">
                <span class="oid">Order #<%= oid %></span>
                <span class="ouser">👤 <%= userIds.get(i) %></span>
                <span class="odate">🕐 <%= orderDates.get(i) %></span>
                <span class="ototal">₹<%= String.format("%.0f", totals.get(i)) %></span>
            </div>

            <% if (items == null || items.isEmpty()) { %>
                <p style="padding:14px 22px;color:#95a5a6;">No item details.</p>
            <% } else { %>
            <table class="tbl">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Product Name</th>
                        <th>Unit Price</th>
                        <th>Quantity</th>
                        <th>Line Total</th>
                    </tr>
                </thead>
                <tbody>
                <% int idx = 1;
                   for (String[] it : items) { %>
                    <tr>
                        <td><%= idx++ %></td>
                        <td><strong><%= it[0] %></strong></td>
                        <td>₹<%= it[2] %></td>
                        <td><%= it[1] %></td>
                        <td>₹<%= it[3] %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    <% } } %>
</div>

</body>
</html>
