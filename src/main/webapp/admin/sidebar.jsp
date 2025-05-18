<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #1e293b;
            --sidebar-hover: #334155;
            --primary: #3b82f6;
            --danger: #ef4444;
            --text-light: #f8fafc;
            --text-muted: #94a3b8;
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f1f5f9;
            color: #1e293b;
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 280px;
            background-color: var(--sidebar-bg);
            color: var(--text-light);
            position: fixed;
            height: 100vh;
            transition: var(--transition);
            z-index: 100;
            box-shadow: 4px 0 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 1rem;
        }

        .sidebar-header h3 {
            font-size: 1.25rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .sidebar-header h3 i {
            color: var(--primary);
        }

        .sidebar-menu {
            list-style: none;
            padding: 0 1rem;
        }

        .sidebar-menu li {
            margin-bottom: 0.25rem;
            position: relative;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            color: var(--text-light);
            text-decoration: none;
            border-radius: 0.5rem;
            transition: var(--transition);
            font-size: 0.95rem;
            gap: 0.75rem;
        }

        .sidebar-menu li a:hover {
            background-color: var(--sidebar-hover);
            transform: translateX(5px);
        }

        .sidebar-menu li a.active {
            background-color: var(--primary);
            font-weight: 500;
        }

        .sidebar-menu li a i {
            width: 24px;
            text-align: center;
            font-size: 1.1rem;
        }

        .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .logout-link a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: var(--danger) !important;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: var(--transition);
        }

        .logout-link a:hover {
            background-color: rgba(239, 68, 68, 0.1);
        }

        .main-content {
            flex: 1;
            margin-left: 280px;
            min-height: 100vh;
            background-color: #ffffff;
            border-radius: 1rem 0 0 0;
            overflow: hidden;
            box-shadow: -5px 0 15px rgba(0, 0, 0, 0.05);
        }

        iframe {
            width: 100%;
            height: 100%;
            min-height: 100vh;
            border: none;
            background-color: #ffffff;
        }

        /* Modern scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        ::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #a1a1a1;
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }
            .sidebar.active {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-shield-alt"></i> Admin Dashboard</h3>
    </div>

    <ul class="sidebar-menu">

        <li><a href="<%= request.getContextPath() %>/users_crud" target="mainFrame"><i class="fas fa-users-cog"></i> User Management</a></li>
        <li><a href="<%= request.getContextPath() %>/agents_crud" target="mainFrame"><i class="fas fa-user-tie"></i> Agent Management</a></li>
        <li><a href="<%= request.getContextPath() %>/products_crud" target="mainFrame"><i class="fas fa-home"></i> Properties Management</a></li>
        <li><a href="<%= request.getContextPath() %>/reviews_crud" target="mainFrame"><i class="fas fa-star"></i> Review Management</a></li>
        <li><a href="<%= request.getContextPath() %>/view_appointments" target="mainFrame"><i class="fas fa-calendar"></i> Appointment Management</a></li>

        <div class="sidebar-footer">
            <div class="logout-link">
                <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-power-off"></i> Logout</a>
            </div>
        </div>
    </ul>
</div>

<!-- Main content area -->
<div class="main-content">
    <iframe name="mainFrame" src="dashboard.jsp" title="Main Content"></iframe>
</div>

</body>
</html>
