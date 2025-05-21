<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Agent Directory</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #e0e7ff;
            --primary-dark: #3a56d4;
            --dark: #1e293b;
            --gray: #64748b;
            --light: #f8fafc;
            --white: #ffffff;
            --shadow: 0 2px 8px rgba(67, 97, 238, 0.1);
            --shadow-hover: 0 6px 12px rgba(67, 97, 238, 0.15);
            --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--light);
            color: var(--dark);
            margin: 0;
            padding: 0;
            line-height: 2;
        }

        .agent-container {
            max-width: 1200px;
            margin: 1.5rem auto;
            padding: 0 1rem;
            line-height: 2;
        }

        .agent-header {
            text-align: center;
            margin-bottom: 2rem;
            animation: fadeIn 0.6s ease-out;
            position: relative;
        }

        .become-agent-btn {
            position: absolute;
            top: 0;
            left: 1rem;
            background: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .become-agent-btn:hover {
            background: var(--primary-dark);
            box-shadow: var(--shadow-hover);
            transform: translateY(-2px);
        }

        .become-agent-btn i {
            font-size: 0.9rem;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .agent-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--primary);
            background: linear-gradient(90deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .agent-header p {
            font-size: 0.95rem;
            color: var(--gray);
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.6;
        }

        .agent-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.8rem;
            padding: 0.5rem;
        }

        .agent-card {
            background: var(--white);
            border-radius: 10px;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: 1px solid rgba(67, 97, 238, 0.1);
            overflow: hidden;
            position: relative;
        }

        .agent-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
            border-color: rgba(67, 97, 238, 0.2);
        }

        .agent-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--primary-dark));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease-out;
        }

        .agent-card:hover::before {
            transform: scaleX(1);
        }

        .agent-avatar {
            height: 90px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .agent-avatar::after {
            content: '';
            position: absolute;
            width: 100px;
            height: 100px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            top: -30px;
            right: -30px;
        }

        .agent-avatar .icon {
            font-size: 2.2rem;
            color: var(--white);
            z-index: 2;
            transition: transform 0.3s ease;
        }

        .agent-card:hover .agent-avatar .icon {
            transform: scale(1.1);
        }

        .agent-info {
            padding: 1.2rem;
        }

        .agent-info h3 {
            font-size: 1.15rem;
            font-weight: 700;
            margin: 0 0 0.4rem 0;
            color: var(--dark);
            transition: color 0.3s ease;
        }

        .agent-card:hover .agent-info h3 {
            color: var(--primary);
        }

        .agent-position {
            display: inline-block;
            background: var(--primary-light);
            color: var(--primary);
            padding: 0.25rem 0.8rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .agent-card:hover .agent-position {
            background: var(--primary);
            color: var(--white);
        }

        .agent-details {
            margin-top: 0.6rem;
        }

        .agent-details p {
            margin: 0.6rem 0;
            display: flex;
            align-items: center;
            font-size: 0.85rem;
            transition: transform 0.3s ease;
        }

        .agent-card:hover .agent-details p {
            transform: translateX(3px);
        }

        .agent-details i {
            width: 20px;
            color: var(--primary);
            margin-right: 0.6rem;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .agent-card:hover .agent-details i {
            color: var(--primary-dark);
        }

        .agent-details a {
            color: var(--gray);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .agent-details a:hover {
            color: var(--primary);
        }

        .no-agents {
            text-align: center;
            grid-column: 1/-1;
            padding: 2rem;
            color: var(--gray);
            font-size: 0.95rem;
            animation: fadeIn 0.6s ease-out;
        }

        /* Card entrance animation */
        .agent-card {
            opacity: 0;
            transform: translateY(20px);
            animation: cardEnter 0.6s ease-out forwards;
        }

        @keyframes cardEnter {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Stagger animations */
        .agent-card:nth-child(1) { animation-delay: 0.1s; }
        .agent-card:nth-child(2) { animation-delay: 0.2s; }
        .agent-card:nth-child(3) { animation-delay: 0.3s; }
        .agent-card:nth-child(4) { animation-delay: 0.4s; }
        .agent-card:nth-child(5) { animation-delay: 0.5s; }
        .agent-card:nth-child(6) { animation-delay: 0.6s; }

        @media (max-width: 768px) {
            .agent-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .become-agent-btn {
                position: relative;
                left: auto;
                margin: 0 auto 1rem auto;
                display: inline-flex;
            }

            .agent-header {
                padding-top: 0;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/header.jsp" />

<div class="agent-container">
    <div class="agent-header">
<button class="become-agent-btn" onclick="window.location.href='<%= request.getContextPath() %>/agent/register_agent.jsp'">Become an Agent</button>
            <i class="fas fa-user-plus"></i> Become an Agent
        </button>
        <h2>Meet Our Agents</h2>
        <p>Our professional team is ready to guide you through your real estate journey</p>
    </div>

    <div class="agent-grid">
        <%
            List<JsonElement> agents = (List<JsonElement>) request.getAttribute("agents");
            if (agents != null && !agents.isEmpty()) {
                int index = 0;
                for (JsonElement agentElement : agents) {
                    JsonObject agent = agentElement.getAsJsonObject();
                    String name = agent.get("name").getAsString();
                    String email = agent.get("email").getAsString();
                    String phone = agent.get("phoneNumber").getAsString();
                    String agency = agent.get("agencyName").getAsString();
        %>
        <div class="agent-card" style="animation-delay: <%= index * 0.1 %>s;">
            <div class="agent-avatar">
                <i class="fas fa-user-tie icon"></i>
            </div>
            <div class="agent-info">
                <h3><%= name %></h3>
                <span class="agent-position"><%= agency %></span>
                <div class="agent-details">
                    <p><i class="fas fa-envelope"></i> <a href="mailto:<%= email %>"><%= email %></a></p>
                    <p><i class="fas fa-phone"></i> <a href="tel:<%= phone %>"><%= phone %></a></p>
                </div>
            </div>
        </div>
        <%
                    index++;
                }
            } else {
        %>
        <div class="no-agents">
            <p>Currently no agents available. Please check back later.</p>
        </div>
        <%
            }
        %>
    </div>
</div>

<jsp:include page="/footer.jsp" />
</body>
</html>
