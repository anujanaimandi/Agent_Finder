<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="properties.Product" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Update Product</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      line-height: 1.6;
    }
    form {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background: #f9f9f9;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    h2 {
      text-align: center;
      color: #333;
    }
    label {
      display: block;
      margin: 15px 0 5px;
      font-weight: bold;
    }
    input[type="text"],
    input[type="number"],
    input[type="file"],
    textarea {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
    }
    textarea {
      height: 100px;
      resize: vertical;
    }
    input[type="submit"] {
      background: #4CAF50;
      color: white;
      padding: 10px 15px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
      margin-top: 20px;
      width: 100%;
    }
    input[type="submit"]:hover {
      background: #45a049;
    }
  </style>
</head>
<body>

<h2>Update Product</h2>

<%
  Product product = (Product) request.getAttribute("product");
%>

<form action="<%= request.getContextPath() %>/update_product" method="post">
  <input type="hidden" name="id" value="<%= product.getId() %>">

  <label for="name">Product Name:</label>
  <input type="text" id="name" name="name" value="<%= product.getName() %>" required>

  <label for="description">Description:</label>
  <textarea id="description" name="description" required><%= product.getDescription() %></textarea>

  <label for="price">Price ($):</label>
  <input type="number" id="price" name="price" step="0.01" min="0" value="<%= product.getPrice() %>" required>

  <label for="imageUrl">Image URL:</label>
  <input type="text" id="imageUrl" name="imageUrl" value="<%= product.getImageUrl() %>" required>

  <label for="category">Category:</label>
  <input type="text" id="category" name="category" value="<%= product.getCategory() %>" required>

  <input type="submit" value="Update Product">
</form>

</body>
</html>
