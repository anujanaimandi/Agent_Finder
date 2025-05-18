<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | RealEstatePro</title>
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
            max-width: 450px;
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

        .login-link {
            margin-top: 1rem;
            text-align: center;
            font-size: 0.9rem;
        }

        .login-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Create Your Account</h2>
    <form action="<%= request.getContextPath() %>/register" method="post">
        <label for="fullName">Full Name</label>
        <input type="text" id="fullName" name="fullName" required>

        <label for="email">Email Address</label>
        <input type="email" id="email" name="email" required>

        <label for="username">Username</label>
        <input type="text" id="username" name="username" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="btn-submit">Register</button>
    </form>
    <div class="login-link">
        Already have an account? <a href="<%= request.getContextPath() %>/user/login.jsp">Login here</a>
    </div>
</div>
</body>
</html>

