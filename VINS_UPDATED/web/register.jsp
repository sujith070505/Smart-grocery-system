<%@page import="java.sql.*,java.security.MessageDigest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>Smart Grocery Register</title>

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


.left-panel{
    width:50%;
    background: linear-gradient(135deg,#1e3c72,#2a5298);
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


.right-panel{
    width:50%;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f5f7fa;
}


.register-card{
    width:320px;
    padding:35px;
    border-radius:15px;
    background:rgba(255,255,255,0.9);
    box-shadow:0 10px 30px rgba(0,0,0,0.1);
    text-align:center;
}

.register-card h2{
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

.msg{
    margin-top:10px;
    font-size:14px;
}
.success{ color:green; }
.error{ color:red; }
</style>
</head>

<body>


<div class="left-panel">
    <h1>🛒 Smart Grocery</h1>
    <p>
        Join us and start saving money 💰<br>
        Compare prices across stores<br>
        Shop smarter every day!
    </p>
</div>

<div class="right-panel">

<div class="register-card">
<h2>Create Account 📝</h2>

<form method="post">
    <input type="text" name="name" placeholder="Full Name" required>
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password" required>

    <button type="submit">Register</button>
</form>

<p>
    Already have an account?
    <a href="login.jsp">Login</a>
</p>

<%
String name = request.getParameter("name");
String email = request.getParameter("email");
String password = request.getParameter("password");

if(name != null && email != null && password != null){

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try{
         Class.forName("com.mysql.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/grocery",
            "root",
            ""
        );

      
        String checkQuery = "SELECT * FROM users WHERE email=?";
        ps = con.prepareStatement(checkQuery);
        ps.setString(1, email);
        rs = ps.executeQuery();

        if(rs.next()){
%>
            <div class="msg error">
                Email already registered ❌
            </div>
<%
        } else {

          
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());

            byte[] bytes = md.digest();
            StringBuilder sb = new StringBuilder();

            for(byte b : bytes){
                sb.append(String.format("%02x", b));
            }

            String hashedPassword = sb.toString();

        
            String insertQuery = "INSERT INTO users(name,email,password) VALUES (?,?,?)";

            ps = con.prepareStatement(insertQuery);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);

            ps.executeUpdate();
%>
            <div class="msg success">
                Registration Successful ✅ <br>
                <a href="login.jsp">Go to Login</a>
            </div>
<%
        }

    } catch(Exception e){
%>
        <div class="msg error"><%= e.getMessage() %></div>
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