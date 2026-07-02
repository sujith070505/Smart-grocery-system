<%@page import="java.sql.*,java.security.MessageDigest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>Smart Grocery Login</title>
<link rel="icon" href="images/grocery.webp">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI', sans-serif;
}

body{
    height:100vh;
    display:flex;
}

/* LEFT PANEL */
.left-panel{
    width:50%;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    color:white;
    display:flex;
    flex-direction:column;
    justify-content:center;
    align-items:center;
    padding:50px;
    text-align:center;
}

.left-panel h1{
    font-size:40px;
    margin-bottom:20px;
}

.left-panel p{
    font-size:18px;
    line-height:1.6;
}

/* RIGHT PANEL */
.right-panel{
    width:50%;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f5f7fa;
}

/* LOGIN CARD */
.login-card{
    width:320px;
    padding:35px;
    border-radius:15px;
    background:rgba(255,255,255,0.9);
    box-shadow:0 10px 30px rgba(0,0,0,0.1);
    text-align:center;
}

.login-card h2{
    margin-bottom:20px;
}

input{
    width:100%;
    padding:12px;
    margin:10px 0;
    border-radius:8px;
    border:1px solid #ccc;
}

button{
    width:100%;
    padding:12px;
    margin-top:10px;
    border:none;
    border-radius:8px;
    background:#2ecc71;
    color:white;
    cursor:pointer;
}

button:hover{
    background:#27ae60;
}

.error{
    color:red;
    margin-top:10px;
}

.success{
    color:green;
    margin-top:10px;
}
</style>
</head>

<body>

<!-- LEFT -->
<div class="left-panel">
    <h1>🛒 Smart Grocery</h1>
    <p>
        Compare prices from top stores.<br>
        Find the best deals instantly.<br>
        Shop smarter & save more 💰
    </p>
</div>

<!-- RIGHT -->
<div class="right-panel">

<div class="login-card">
<h2>Welcome Back 👋</h2>

<form method="post">
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password" required>

    <button type="submit">Login</button>
</form>

<p>
    Don't have an account?
    <a href="register.jsp">Create Account</a>
</p>

<%
String email = request.getParameter("email");
String password = request.getParameter("password");

if(email != null && password != null){

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try{
        // ✅ Load Driver
        Class.forName("com.mysql.jdbc.Driver");

        // ✅ Connect DB
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/grocery","root","");

        // 🔐 HASH PASSWORD (same as register.jsp)
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(password.getBytes());

        byte[] bytes = md.digest();
        StringBuilder sb = new StringBuilder();

        for(byte b : bytes){
            sb.append(String.format("%02x", b));
        }

        String hashedPassword = sb.toString();

        // ✅ SQL CHECK
        String query = "SELECT * FROM users WHERE email=? AND password=?";
        ps = con.prepareStatement(query);

        ps.setString(1, email);
        ps.setString(2, hashedPassword);

        rs = ps.executeQuery();

        if(rs.next()){
            // ✅ SESSION
            session.setAttribute("user", rs.getString("name"));

            // ✅ REDIRECT
            response.sendRedirect("dashboard.jsp");
        } else {
%>
            <div class="error">Invalid Email or Password ❌</div>
<%
        }

    } catch(Exception e){
%>
        <div class="error"><%= e.getMessage() %></div>
<%
    } finally {
        try{ if(rs!=null) rs.close(); } catch(Exception e){}
        try{ if(ps!=null) ps.close(); } catch(Exception e){}
        try{ if(con!=null) con.close(); } catch(Exception e){}
    }
}
%>

</div>
</div>

</body>
</html>