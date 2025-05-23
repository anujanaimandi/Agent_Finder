<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>RealEstatePro | Your Dream Property Awaits</title>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    :root {
      --primary: #6366f1;
      --primary-light: #e0e7ff;
      --primary-dark: #4f46e5;
      --dark: #1e293b;
      --light: #f8fafc;
      --lighter: #ffffff;
      --border: #e2e8f0;
      --text: #1f2937;
      --text-light: #64748b;
      --hover-bg: rgba(99, 102, 241, 0.08);
      --radius-sm: 0.375rem;
      --radius-md: 0.5rem;
      --radius-lg: 0.75rem;
      --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.05);
      --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
      --transition: all 0.2s ease-in-out;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Montserrat', sans-serif;
    }

    body {
      background: var(--lighter);
    }

    .header {
      position: sticky;
      top: 0;
      background: var(--lighter);
      z-index: 1000;
      box-shadow: var(--shadow-sm);
      padding: 0.8rem 5%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid var(--border);
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 0.6rem;
      text-decoration: none;
    }

    .logo img {
      height: 42px;
      width: 42px;
    }

    .logo-text {
      font-size: 1.6rem;
      font-weight: 700;
      background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
    }

    .logo-text span {
      color: var(--dark);
    }

    nav.nav-links {
      display: flex;
      gap: 1.8rem;
    }

    nav.nav-links a {
      text-decoration: none;
      font-size: 1rem;
      font-weight: 500;
      color: var(--text);
      transition: var(--transition);
      position: relative;
      padding: 0.5rem 0;
    }

    nav.nav-links a:hover {
      color: var(--primary);
    }

    nav.nav-links a::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      width: 0;
      height: 2px;
      background: var(--primary);
      transition: var(--transition);
    }

    nav.nav-links a:hover::after {
      width: 100%;
    }

    .auth-buttons {
      display: flex;
      align-items: center;
      gap: 0.8rem;
    }

    .btn {
      padding: 0.5rem 1.25rem;
      border-radius: var(--radius-md);
      font-weight: 600;
      font-size: 0.9rem;
      text-decoration: none;
      transition: var(--transition);
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
    }

    .btn-outline {
      border: 2px solid var(--primary);
      background: transparent;
      color: var(--primary);
    }

    .btn-outline:hover {
      background: var(--primary-light);
      transform: translateY(-1px);
    }

    .btn-primary {
      background: var(--primary);
      color: white;
      border: 2px solid var(--primary);
      box-shadow: var(--shadow-sm);
    }

    .btn-primary:hover {
      background: var(--primary-dark);
      transform: translateY(-1px);
      box-shadow: var(--shadow-md);
    }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .user-avatar {
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
    }

    .username {
      font-size: 0.95rem;
      font-weight: 500;
      color: var(--text);
    }

    .logout-btn {
      font-size: 0.8rem;
      padding: 0.35rem 0.7rem;
      border: 1px solid var(--primary);
      background: var(--lighter);
      color: var(--primary);
      border-radius: var(--radius-sm);
      text-decoration: none;
      transition: var(--transition);
      display: inline-flex;
      align-items: center;
      gap: 0.3rem;
    }

    .logout-btn:hover {
      background: var(--primary-light);
      color: var(--primary-dark);
    }

    .mobile-menu-btn {
      display: none;
      font-size: 1.5rem;
      color: var(--dark);
      padding: 0.5rem;
      border-radius: var(--radius-sm);
      transition: var(--transition);
    }

    .mobile-menu-btn:hover {
      background: var(--hover-bg);
    }

    @media (max-width: 992px) {
      nav.nav-links,
      .auth-buttons {
        display: none;
      }

      .mobile-menu-btn {
        display: block;
      }
    }
  </style>
</head>
<body>
<header class="header">
  <a href="index.jsp" class="logo">
    <img src="https://cdn-icons-png.flaticon.com/512/888/888063.png" alt="RealEstatePro Logo">
    <span class="logo-text">RealEstate<span>Pro</span></span>
  </a>

  <nav class="nav-links">
    <a href="<%= request.getContextPath() %>/read_products">Properties</a>
    <a href="<%= request.getContextPath() %>/read_agents">Agent</a>
    <a href="<%= request.getContextPath() %>/read_reviews">Reviews</a>
    <a href="contact.jsp">Contact</a>
  </nav>

  <div class="auth-buttons">
    <% if(session.getAttribute("username") == null) { %>
    <a href="<%= request.getContextPath() %>/user/login.jsp" class="btn btn-outline">
      <i class="fas fa-power-on"></i> Login
    </a>
    <a href="<%= request.getContextPath() %>/user/userRegistration.jsp" class="btn btn-primary">
      <i class="fas fa-user-plus"></i> Register
    </a>
    <% } else {
      String username = session.getAttribute("username").toString();
      String firstLetter = username.substring(0, 1).toUpperCase();
    %>
    <div class="user-profile">
      <div class="user-avatar"><%= firstLetter %></div>
      <span class="username"><%= username %></span>
      <% if(session.getAttribute("userType") != null && session.getAttribute("userType").equals("admin")) { %>
      <a href="adminDashboard.jsp" class="logout-btn"><i class="fas fa-cog"></i></a>
      <% } %>
      <a href="<%= request.getContextPath() %>/logout" class="logout-btn"><i class="fas fa-power-off"></i></a>
    </div>
    <% } %>
  </div>

  <div class="mobile-menu-btn">
    <i class="fas fa-bars"></i>
  </div>
</header>
</body>
</html>
