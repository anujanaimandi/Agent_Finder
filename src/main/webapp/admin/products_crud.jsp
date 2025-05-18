<%@ page import="com.google.gson.*, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonElement" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Management - CRUD Table</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #007bff;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #444;
            text-align: left;
        }

        th {
            background-color: #222;
            color: #fff;
        }

        td img {
            height: 100px;
        }

        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
        }

        .add-btn {
            background-color: #28a745;
            color: white;
            margin-bottom: 15px;
            text-decoration: none;
        }

        .edit-btn {
            background-color: #007bff;
            color: white;
            margin-right: 10px;
            text-decoration: none;
        }

        .delete-btn {
            background-color: #dc3545;
            color: white;
        }

        form {
            display: inline;
        }

        .action-cell {
            white-space: nowrap;
        }
    </style>
</head>
<body>

<h1>Manage Properties</h1>

<a href="property/upload.jsp" class="btn add-btn">Add New Properties</a>

<table>
    <thead>
    <tr>
        <th>Image</th>
        <th>Name</th>
        <th>Category</th>
        <th>Description</th>
        <th>Price</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        List<JsonElement> products = (List<JsonElement>) request.getAttribute("products");
        if (products != null && !products.isEmpty()) {
            for (JsonElement element : products) {
                if (element.isJsonObject()) {
                    JsonObject product = element.getAsJsonObject();
                    int id = product.has("id") ? product.get("id").getAsInt() : -1;
                    String name = product.has("name") ? product.get("name").getAsString() : "No Name";
                    String category = product.has("category") ? product.get("category").getAsString() : "Uncategorized";
                    String description = product.has("description") ? product.get("description").getAsString() : "No description";
                    String imageUrl = product.has("imageUrl") ? product.get("imageUrl").getAsString() : "";
                    double price = product.has("price") ? product.get("price").getAsDouble() : 0.0;
    %>
    <tr>
        <td><% if (!imageUrl.isEmpty()) { %><img src="<%= imageUrl %>" alt="<%= name %>"><% } %></td>
        <td><%= name %></td>
        <td><%= category %></td>
        <td><%= description %></td>
        <td>$<%= String.format("%.2f", price) %></td>
        <td class="action-cell">
            <a href="edit_product?id=<%= id %>" class="btn edit-btn">Edit</a>
            <form action="delete_product" method="post" onsubmit="return confirm('Are you sure you want to delete this product?');">
                <input type="hidden" name="id" value="<%= id %>">
                <input type="hidden" name="_method" value="DELETE">
                <button class="btn delete-btn" type="submit">Delete</button>
            </form>
        </td>
    </tr>
    <%
            }
        }
    } else {
    %>
    <tr>
        <td colspan="6" style="text-align: center;">No products found</td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>

</body>
</html>

