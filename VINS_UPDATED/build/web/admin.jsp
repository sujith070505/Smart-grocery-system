<%@page import="java.sql.*,java.security.MessageDigest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Login</title>

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
    justify-content:center;
    align-items:center;
    background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
}

/* CARD */
.card{
    width:320px;
    padding:35px;
    border-radius:15px;
    background:#1e1e2f;
    box-shadow:0 15px 40px rgba(0,0,0,0.5);
    text-align:center;
    color:white;
}

.card h2{
    margin-bottom:20px;
}

/* INPUT */
.input-box{
    margin:15px 0;
}

.input-box input{
    width:100%;
    padding:12px;
    border-radius:8px;
    border:none;
    background:#2c2c3c;
    color:white;
}

/* BUTTON */
button{
    width:100%;
    padding:12px;
    margin-top:10px;
    border:none;
    border-radius:8px;
    background:#00c853;
    color:white;
    cursor:pointer;
}

button:hover{
    background:#00b248;
}

.error{
    color:#ff5252;
    margin-top:10px;
}
</style>

</head>

<body>

<div class="card">

<h2>Admin Access 🔐</h2>

<form method="post">
    <div class="input-box">
        <input type="text" name="username" placeholder="Username" required>
    </div>

    <div class="input-box">
        <input type="password" name="password" placeholder="Password" required>
    </div>

    <button type="submit">Login</button>
</form>

<%
String user = request.getParameter("username");
String pass = request.getParameter("password");

if(user != null && pass != null){

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try{
         Class.forName("com.mysql.jdbc.Driver");

        con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/grocery","root","");
        
        String query = "SELECT * FROM admin WHERE username=? AND password=?";
        ps = con.prepareStatement(query);

        ps.setString(1, user);
        ps.setString(2, pass);

        rs = ps.executeQuery();

        if(rs.next()){
            session.setAttribute("admin", user);
            response.sendRedirect("admin_dashboard.jsp");
        } else {
%>
    <div class="error">Invalid Login ?</div>
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

</body>
</html>