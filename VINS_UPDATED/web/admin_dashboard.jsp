<%@page import="java.sql.*"%>
<%@page import="java.net.URLEncoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
// 1. SESSION SECURITY
String admin = (String) session.getAttribute("admin");
if(admin == null){
    response.sendRedirect("admin.jsp");
    return;
}

// 2. DATABASE OPERATIONS (CRUD)
Connection con = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery","root","");
    
    // ADD PRODUCT
    if(request.getParameter("add") != null){
        ps = con.prepareStatement("INSERT INTO products(name,category,bigbasket_price,dmart_price,blinkit_price,image,link) VALUES (?,?,?,?,?,?,?)");
        ps.setString(1, request.getParameter("name"));
        ps.setString(2, request.getParameter("category"));
        ps.setDouble(3, Double.parseDouble(request.getParameter("bigbasket_price")));
        ps.setDouble(4, Double.parseDouble(request.getParameter("dmart_price")));
        ps.setDouble(5, Double.parseDouble(request.getParameter("blinkit_price")));
        ps.setString(6, request.getParameter("image"));
        ps.setString(7, request.getParameter("link"));
        ps.executeUpdate();
        response.sendRedirect("admin_dashboard.jsp?success=added");
        return;
    }
    
    // UPDATE PRODUCT
    if(request.getParameter("update") != null){
        ps = con.prepareStatement("UPDATE products SET name=?, category=?, bigbasket_price=?, dmart_price=?, blinkit_price=?, image=?, link=? WHERE id=?");
        ps.setString(1, request.getParameter("name"));
        ps.setString(2, request.getParameter("category"));
        ps.setDouble(3, Double.parseDouble(request.getParameter("bigbasket_price")));
        ps.setDouble(4, Double.parseDouble(request.getParameter("dmart_price")));
        ps.setDouble(5, Double.parseDouble(request.getParameter("blinkit_price")));
        ps.setString(6, request.getParameter("image"));
        ps.setString(7, request.getParameter("link"));
        ps.setInt(8, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        response.sendRedirect("admin_dashboard.jsp?success=updated");
        return;
    }
    
    // DELETE PRODUCT
    if(request.getParameter("delete") != null){
        ps = con.prepareStatement("DELETE FROM products WHERE id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("id")));
        ps.executeUpdate();
        response.sendRedirect("admin_dashboard.jsp?success=deleted");
        return;
    }
    
} catch(Exception e) {
    // Correctly encoding the error message for the URL
    response.sendRedirect("admin_dashboard.jsp?error=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
    return;
} finally {
    if(ps!=null) try{ps.close();}catch(Exception e){}
    if(con!=null) try{con.close();}catch(Exception e){}
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Smart Grocery</title>
    <style>
        * {margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif;}
        body {background:#f5f7fa; padding:20px;}
        .container {max-width:1400px; margin:0 auto;}

        /* WELCOME BAR */
        .welcome-bar {
            background:linear-gradient(135deg,#00c853,#00b248);
            color:white; padding:25px; border-radius:20px; margin-bottom:30px;
            display:flex; justify-content:space-between; align-items:center;
            box-shadow:0 10px 30px rgba(0,200,83,0.3);
        }

        /* FORM STYLING */
        form.add-form {
            background:white; padding:30px; border-radius:20px; margin-bottom:35px;
            box-shadow:0 10px 30px rgba(0,0,0,0.05);
        }
        input, select {
            padding:12px; margin:5px; border:1px solid #ddd; border-radius:8px;
        }
        .price-inputs { display: flex; gap: 10px; margin: 10px 0; }
        .price-inputs input { flex: 1; }

        /* TABLE STYLING */
        table { width:100%; background:white; border-radius:15px; border-collapse: collapse; overflow:hidden; box-shadow:0 10px 30px rgba(0,0,0,0.05); }
        th { background:#f8f9fa; padding:15px; text-align:left; color:#666; font-size:14px; border-bottom:2px solid #eee; }
        td { padding:15px; border-bottom:1px solid #eee; }
        
        .platform-badge { padding:5px 10px; border-radius:15px; color:white; font-size:12px; font-weight:bold; }
        .bb-badge {background:#2874f0;} .dm-badge {background:#ff6f00;} .bl-badge {background:#00c853;}

        /* BUTTONS */
        .btn { padding:10px 20px; border:none; border-radius:8px; cursor:pointer; font-weight:bold; transition:0.3s; }
        .btn-add { background:#00c853; color:white; }
        .btn-edit { background:#2196f3; color:white; }
        .btn-save { background:#4caf50; color:white; display:none; }
        .btn-delete { background:#f44336; color:white; }
        
        /* MODE TOGGLE */
        .edit-mode { display:none; width:100%; }
        .alert { padding:15px; border-radius:10px; margin-bottom:20px; text-align:center; font-weight:bold; }
        .alert-success { background:#d4edda; color:#155724; }
        .alert-danger { background:#f8d7da; color:#721c24; }
    </style>
</head>
<body>

<div class="container">
    <div class="welcome-bar">
        <h2>🛒 Admin Panel</h2>
        <div style="display:flex;align-items:center;gap:15px;">
                👋 Welcome, <strong><%= admin %></strong>
                <a href="admin_orders.jsp" style="background:#9b59b6;color:white;padding:8px 18px;border-radius:6px;text-decoration:none;font-weight:bold;">📋 View Orders</a>
                <a href="logout.jsp" style="color:white;font-weight:bold;">🚪 Logout</a>
            </div>
    </div>

    <%-- Feedback Messages --%>
    <% if(request.getParameter("success") != null) { %>
        <div class="alert alert-success">Operation Successful!</div>
    <% } %>
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger">Error: <%= request.getParameter("error") %></div>
    <% } %>

    <form method="post" class="add-form">
        <h3>➕ Add Product</h3>
        <input type="text" name="name" placeholder="Product Name" required style="width:300px;">
        <select name="category" required>
            <option value="milk">Milk</option>
            <option value="snacks">Snacks</option>
            <option value="staples">Staples</option>
            <option value="spices">Spices</option>
            <option value="beverages">Beverages</option>
            <option value="cleaning">Cleaning</option>
        </select>
        <div class="price-inputs">
            <input type="number" name="bigbasket_price" placeholder="BigBasket Price" step="0.01" required>
            <input type="number" name="dmart_price" placeholder="DMart Price" step="0.01" required>
            <input type="number" name="blinkit_price" placeholder="Blinkit Price" step="0.01" required>
        </div>
        <input type="text" name="image" placeholder="Image URL" required style="width:45%;">
        <input type="url" name="link" placeholder="Buy Link" required style="width:45%;">
        <button type="submit" name="add" class="btn btn-add">Add to Catalog</button>
    </form>

    <table>
        <thead>
            <tr>
                <th>ID</th><th>Name</th><th>Category</th><th>Prices (BB/DM/BL)</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
        try {
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery","root","");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM products ORDER BY id DESC");
            while(rs.next()) {
        %>
            <tr>
                <form method="post">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <td><%= rs.getInt("id") %></td>
                    
                    <%-- Name Column --%>
                    <td>
                        <span class="view-mode"><%= rs.getString("name") %></span>
                        <input type="text" name="name" value="<%= rs.getString("name") %>" class="edit-mode">
                    </td>

                    <%-- Category Column --%>
                    <td>
                        <span class="view-mode"><%= rs.getString("category") %></span>
                        <select name="category" class="edit-mode">
                            <option value="milk" <%="milk".equals(rs.getString("category"))?"selected":""%>>Milk</option>
                            <option value="snacks" <%="snacks".equals(rs.getString("category"))?"selected":""%>>Snacks</option>
                            <option value="staples" <%="staples".equals(rs.getString("category"))?"selected":""%>>Staples</option>
                            <option value="spices" <%="spices".equals(rs.getString("category"))?"selected":""%>>Spices</option>
                            <option value="beverages" <%="beverages".equals(rs.getString("category"))?"selected":""%>>Beverages</option>
                            <option value="cleaning" <%="cleaning".equals(rs.getString("category"))?"selected":""%>>Cleaning</option>
                        </select>
                    </td>

                    <%-- Prices Column --%>
                    <td>
                        <div class="view-mode">
                            <span class="platform-badge bb-badge">₹<%= rs.getDouble("bigbasket_price") %></span>
                            <span class="platform-badge dm-badge">₹<%= rs.getDouble("dmart_price") %></span>
                            <span class="platform-badge bl-badge">₹<%= rs.getDouble("blinkit_price") %></span>
                        </div>
                        <div class="edit-mode">
                            <input type="number" name="bigbasket_price" value="<%= rs.getDouble("bigbasket_price") %>" step="0.01" style="width:60px;">
                            <input type="number" name="dmart_price" value="<%= rs.getDouble("dmart_price") %>" step="0.01" style="width:60px;">
                            <input type="number" name="blinkit_price" value="<%= rs.getDouble("blinkit_price") %>" step="0.01" style="width:60px;">
                        </div>
                    </td>

                    <%-- Image/Link hidden during view, visible during edit for updates --%>
                    <input type="hidden" name="image" value="<%= rs.getString("image") %>" class="edit-mode" style="display:none;">
                    <input type="hidden" name="link" value="<%= rs.getString("link") %>" class="edit-mode" style="display:none;">

                    <td>
                        <button type="button" class="btn btn-edit" onclick="enableEdit(this)">Edit</button>
                        <button type="submit" name="update" class="btn btn-save">Save</button>
                        <button type="submit" name="delete" class="btn btn-delete" onclick="return confirm('Delete this product?')">Delete</button>
                    </td>
                </form>
            </tr>
        <%
            }
            con.close();
        } catch(Exception e) { out.println(e.getMessage()); }
        %>
        </tbody>
    </table>
</div>

<script>
    function enableEdit(btn) {
        const row = btn.closest('tr');
        // Hide all view spans
        row.querySelectorAll('.view-mode').forEach(el => el.style.display = 'none');
        // Show all edit inputs
        row.querySelectorAll('.edit-mode').forEach(el => {
            if(el.tagName === 'INPUT' && el.type === 'hidden') {
                el.type = 'text'; // Show hidden image/link fields during edit
                el.style.display = 'block';
            } else {
                el.style.display = 'inline-block';
            }
        });
        // Toggle Buttons
        btn.style.display = 'none';
        row.querySelector('.btn-save').style.display = 'inline-block';
    }
</script>

</body>
</html>