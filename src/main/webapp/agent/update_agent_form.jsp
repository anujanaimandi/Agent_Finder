<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="agent.Agent" %>
<%
    Agent agent = (Agent) request.getAttribute("agent");
    if (agent == null) {
        out.println("<p style='color:red;'>Agent not found.</p>");
        return;
    }
%>
<html>
<head>
    <title>Update Agent</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            padding: 40px;
        }
        form {
            width: 400px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }
        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 8px;
            margin-top: 6px;
            box-sizing: border-box;
        }
        button {
            margin-top: 20px;
            padding: 10px 16px;
            background-color: #2a9d8f;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        a {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #333;
        }
    </style>
</head>
<body>
    <form action="update_agent" method="post">
        <h2>Update Agent</h2>

        <input type="hidden" name="id" value="<%= agent.getId() %>" />

        <label for="name">Name:</label>
        <input type="text" name="name" id="name" value="<%= agent.getName() %>" required />

        <label for="email">Email:</label>
        <input type="email" name="email" id="email" value="<%= agent.getEmail() %>" required />

        <label for="phoneNumber">Phone Number:</label>
        <input type="text" name="phoneNumber" id="phoneNumber" value="<%= agent.getPhoneNumber() %>" required />

        <label for="agencyName">Agency Name:</label>
        <input type="text" name="agencyName" id="agencyName" value="<%= agent.getAgencyName() %>" required />

        <button type="submit">Update Agent</button>
        <a href="agents_crud.jsp">Back to List</a>
    </form>
</body>
</html>
