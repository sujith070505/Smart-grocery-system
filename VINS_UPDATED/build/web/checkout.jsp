<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String user = (String) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

String status   = request.getParameter("status"); // "success" or "error"
String errorMsg = request.getParameter("msg");

Integer lastOrderId    = (Integer) session.getAttribute("lastOrderId");
Double  lastOrderTotal = (Double)  session.getAttribute("lastOrderTotal");

// Clear session so a page refresh doesn't re-show stale data
session.removeAttribute("lastOrderId");
session.removeAttribute("lastOrderTotal");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Confirmation – Smart Grocery</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif;}
body{background:#f5f7fa;display:flex;flex-direction:column;min-height:100vh;}
.nav{display:flex;justify-content:space-between;align-items:center;
     padding:15px 40px;background:#2ecc71;color:white;}
.nav h1{font-size:22px;}
.btn{padding:8px 15px;border:none;border-radius:5px;cursor:pointer;
     background:white;color:#2ecc71;font-weight:bold;}
.btn:hover{background:#27ae60;color:white;}

.card{max-width:500px;margin:80px auto;background:white;
      border-radius:20px;box-shadow:0 10px 40px rgba(0,0,0,0.1);
      padding:50px;text-align:center;}
.icon{font-size:72px;margin-bottom:20px;}
h2{font-size:26px;color:#2c3e50;margin-bottom:12px;}
p{color:#7f8c8d;font-size:15px;margin-bottom:8px;line-height:1.7;}
.highlight{color:#2ecc71;font-weight:700;font-size:20px;}
.order-id{color:#3498db;font-weight:bold;}

.btn-big{display:inline-block;margin-top:28px;padding:13px 36px;
         background:linear-gradient(135deg,#2ecc71,#27ae60);
         color:white;text-decoration:none;border-radius:25px;
         font-weight:700;font-size:15px;
         box-shadow:0 6px 18px rgba(46,204,113,0.35);}
.btn-big:hover{transform:scale(1.04);}
.btn-err{background:#e74c3c;box-shadow:none;}
.btn-err:hover{background:#c0392b;}
</style>
</head>
<body>

<div class="nav">
    <h1>🛒 Smart Grocery</h1>
    <a href="dashboard.jsp"><button class="btn">🏠 Home</button></a>
</div>

<div class="card">
<% if ("success".equals(status)) { %>

    <div class="icon">✅</div>
    <h2>Order Placed!</h2>
    <p>Thank you, <strong><%= user %></strong>. Your order is confirmed.</p>

    <% if (lastOrderId != null) { %>
        <p>Order ID: <span class="order-id">#<%= lastOrderId %></span></p>
    <% } %>
    <% if (lastOrderTotal != null) { %>
        <p class="highlight">Total: ₹<%= String.format("%.0f", lastOrderTotal) %></p>
    <% } %>

    <p style="margin-top:15px;">Your items will be delivered at the best prices 🎉</p>
    <a href="dashboard.jsp" class="btn-big">🛒 Continue Shopping</a>

<% } else { %>

    <div class="icon">❌</div>
    <h2>Something Went Wrong</h2>
    <p>We could not place your order. Please try again.</p>
    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <p style="color:#e74c3c;font-size:13px;margin-top:8px;"><%= errorMsg %></p>
    <% } %>
    <a href="viewcart.jsp" class="btn-big btn-err">← Back to Cart</a>

<% } %>
</div>

</body>
</html>
