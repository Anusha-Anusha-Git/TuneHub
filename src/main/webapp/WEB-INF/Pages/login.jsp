<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login | TuneUp</title>
    <style>
        body { font-family: Arial; background:#f4f4f4; }
        .box {
            width: 350px;
            margin: 100px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
        }
        input {
         width:100%; padding:10px; margin:10px 0; box-sizing:border-box; border:1px solid #ccc; border-radius:5px; }
        button {
         width:100%; padding:10px; background:#222; color:white; border:none; border-radius:5px; cursor:pointer; }
        button:hover { 
        background:#444; }
        .error { 
        color:red; font-size:0.9em; }
        .success { 
        color:green; font-size:0.9em; }
    </style>
</head>
<body>

<div class="box">
    <h2>Login</h2>

    <form action="LoginController" method="post">

        <input type="email" name="email" placeholder="Email" required />

        <input type="password" name="password" placeholder="Password" required />

        <button  type="submit">Login</button>
    </form>

    <p class="error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </p>

    <p>New user? <a href="RegisterController">Register</a></p>
</div>

</body>
</html>
