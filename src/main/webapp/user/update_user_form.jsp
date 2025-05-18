<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.JsonObject" %>
<%
    JsonObject user = (JsonObject) request.getAttribute("user");
    if (user == null) {
%>
<p style="text-align:center; color:red;">User data not found.</p>
<%
        return;
    }

    int id = user.get("id").getAsInt();
    String fullName = user.get("fullName").getAsString();
    String email = user.get("email").getAsString();
    String username = user.get("username").getAsString();
    String password = user.get("password").getAsString(); // 👈 get password
%>
<html>
<head>
    <title>Edit User</title>
    <style>
        form {
            width: 400px;
            margin: 40px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        label {
            display: block;
            margin-top: 10px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 8px;
            margin-top: 4px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            margin-top: 20px;
            background-color: #457b9d;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        h2 {
            text-align: center;
        }
    </style>
</head>
<body>
<h2>Edit User</h2>
<form action="update_user" method="post">
    <input type="hidden" name="id" value="<%= id %>"/>

    <label for="fullName">Full Name:</label>
    <input type="text" name="fullName" value="<%= fullName %>" required />

    <label for="email">Email:</label>
    <input type="email" name="email" value="<%= email %>" required />

    <label for="username">Username:</label>
    <input type="text" name="username" value="<%= username %>" required />

    <label for="password">Password:</label>
    <input type="password" value="<%= password %>" disabled /> <!-- 👈 Password shown, not editable -->

    <input type="submit" value="Update User" />
</form>
</body>
</html>

