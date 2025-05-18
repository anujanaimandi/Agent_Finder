<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Agent Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            margin-top: 30px;
            color: #2c3e50;
        }

        table {
            width: 90%;
            border-collapse: collapse;
            margin: 30px auto;
            background-color: white;
            box-shadow: 0 5px 10px rgba(0,0,0,0.05);
        }

        th, td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #3a56d4;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .btn {
            padding: 5px 12px;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 5px;
            font-size: 0.9rem;
        }

        .btn-delete {
            background-color: #e63946;
            color: white;
            border: none;
            cursor: pointer;
        }

        .btn-update {
            background-color: #457b9d;
            color: white;
            border: none;
            cursor: pointer;
        }

        form {
            display: inline;
        }
    </style>
</head>
<body>

<h2>Agent List</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Agency</th>
        <th>Actions</th>
    </tr>
    <%
        List<JsonElement> agents = (List<JsonElement>) request.getAttribute("agents");
        if (agents != null && !agents.isEmpty()) {
            for (JsonElement agentEl : agents) {
                JsonObject agent = agentEl.getAsJsonObject();

                int id = agent.has("id") ? agent.get("id").getAsInt() : -1;
                String name = agent.has("name") ? agent.get("name").getAsString() : "N/A";
                String email = agent.has("email") ? agent.get("email").getAsString() : "N/A";
                String phone = agent.has("phoneNumber") ? agent.get("phoneNumber").getAsString() : "N/A";
                String agency = agent.has("agencyName") ? agent.get("agencyName").getAsString() : "N/A";
    %>
    <tr>
        <td><%= id %></td>
        <td><%= name %></td>
        <td><%= email %></td>
        <td><%= phone %></td>
        <td><%= agency %></td>
        <td>
            <!-- Update button -->
            <a href="edit_agent?id=<%= id %>" class="btn btn-update">Update</a>

            <!-- Delete form -->
            <form action="delete_agent" method="post" onsubmit="return confirm('Are you sure you want to delete this agent?');">
                <input type="hidden" name="id" value="<%= id %>">
                <!-- Uncomment below if delete servlet uses _method=DELETE style -->
                <!-- <input type="hidden" name="_method" value="DELETE"> -->
                <button type="submit" class="btn btn-delete">Delete</button>
            </form>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="6" style="text-align: center; color: #999;">No agents available.</td>
    </tr>
    <% } %>
</table>

</body>
</html>

