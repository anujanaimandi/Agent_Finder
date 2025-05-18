<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.JsonObject" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | RealEstatePro</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4361ee;
            --primary-dark: #3a56d4;
            --dark: #1a1a2e;
            --light: #f8f9fa;
            --error: #f72585;
            --border-radius: 10px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Montserrat', sans-serif;
        }

        body {
            background-color: var(--light);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 2rem;
        }

        .form-container {
            background: white;
            padding: 2.5rem 2rem;
            border-radius: var(--border-radius);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 350px;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 1.5rem;
            color: var(--primary);
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: 600;
            margin-bottom: 0.4rem;
            color: var(--dark);
        }

        input {
            padding: 0.6rem 0.8rem;
            margin-bottom: 1.2rem;
            border: 1.5px solid #ccc;
            border-radius: var(--border-radius);
            font-size: 0.95rem;
            transition: border-color 0.2s;
        }

        input:focus {
            border-color: var(--primary);
            outline: none;
        }

        .btn-submit {
            background: var(--primary);
            color: white;
            padding: 0.7rem 1rem;
            border: none;
            font-size: 1rem;
            font-weight: 600;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .btn-submit:hover {
            background: var(--primary-dark);
        }

        .register-link {
            margin-top: 1rem;
            text-align: center;
            font-size: 0.9rem;
        }

        .register-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .error {
            color: var(--error);
            margin-bottom: 1rem;
            text-align: center;
            font-size: 0.9rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Login</h2>
    <form action="<%= request.getContextPath() %>/login" method="post" target="_blank">
        <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Enter your username" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter your password" required>

        <button type="submit" class="btn-submit">Login</button>
    </form>
    <div class="register-link">
        Don't have an account? <a href="<%= request.getContextPath() %>/user/userRegistration.jsp">Register here</a>
    </div>
</div>

<script>
    function validateForm() {
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value.trim();

        if (!username || !password) {
            alert('Both username and password are required');
            return false;
        }
        return true;
    }

    // Prevent form submission from opening in new tab
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        e.preventDefault();
        if (validateForm()) {
            this.submit();
        }
    });
</script>
</body>
</html>
