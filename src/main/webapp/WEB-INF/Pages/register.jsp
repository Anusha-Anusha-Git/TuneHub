<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register | TuneHub</title>
    <style>
        body { font-family: Arial; background:#f4f4f4; }
        .box {
            width: 350px;
            margin: 80px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
        }
        input, select { 
        width:100%; padding:10px; margin:8px 0; box-sizing:border-box; border:1px solid #ccc; border-radius:5px; }
        button { 
        width:100%; padding:10px; background:black; color:white; border:none; border-radius:5px; cursor:pointer; }
        button:hover { 
        background:#333; }
        .error { 
        color:red; font-size:0.9em; }
    </style>
</head>
<body>

<div class="box">
    <h2>Create Account</h2>

    <form action="RegisterController" method="post">

        <input type="text" name="name" placeholder="Full Name" required />

        <input type="email" name="email" placeholder="Email" required />

        <input type="password" name="password" placeholder="Password" required />

        <select name="role">
            <option value="user">User</option>
            <option value="admin">Admin</option>
        </select>

        <button type="submit">Register</button>
    </form>

    <p>Already have an account? <a href="LoginController">Login</a></p>
</div>

</body>
</html>