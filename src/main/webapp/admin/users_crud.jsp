<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="java.util.List" %>
<html>
<head>
  <title>User Management</title>
  <style>
    table {
      width: 90%;
      border-collapse: collapse;
      margin: 20px auto;
    }
    th, td {
      padding: 10px;
      border: 1px solid #ccc;
      text-align: left;
    }
    .btn {
      padding: 5px 10px;
      text-decoration: none;
      border-radius: 4px;
      margin-right: 5px;
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
    }
  </style>
</head>
<body>
<h2 style="text-align:center;">User List</h2>
<table>
  <tr>
    <th>ID</th>
    <th>Full Name</th>
    <th>Email</th>
    <th>Username</th>
    <th>Password</th>
    <th>Actions</th>
  </tr>
  <%
    List<JsonElement> users = (List<JsonElement>) request.getAttribute("users");
    if (users != null) {
      for (JsonElement userEl : users) {
        JsonObject user = userEl.getAsJsonObject();
        int id = user.get("id").getAsInt();
        String password = user.has("password") ? user.get("password").getAsString() : "N/A";
  %>
  <tr>
    <td><%= id %></td>
    <td><%= user.get("fullName").getAsString() %></td>
    <td><%= user.get("email").getAsString() %></td>
    <td><%= user.get("username").getAsString() %></td>
    <td>
      ****
      <input type="hidden" name="password_<%= id %>" value="<%= password %>">
    </td>
    <td>
      <a href="edit_user?id=<%= id %>" class="btn btn-update">Update</a>
      <form action="delete_user" method="post" style="display:inline;">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="hidden" name="_method" value="DELETE">
        <button type="submit" class="btn btn-delete"
                onclick="return confirm('Are you sure you want to delete this user?');">
          Delete
        </button>
      </form>
    </td>
  </tr>
  <%
      }
    }
  %>
</table>
</body>
</html>

