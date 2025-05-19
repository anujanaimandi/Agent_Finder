<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Upload Product</title>
  <style>
    * {
      box-sizing: border-box;
    }

    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      background-color: #fff;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    form {
      background-color: #f9f9f9;
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 420px;
    }

    h2 {
      text-align: center;
      color: #1976d2;
      margin-bottom: 16px;
      font-size: 22px;
    }

    label {
      display: block;
      margin-bottom: 4px;
      font-weight: 500;
      color: #555;
      font-size: 14px;
    }

    input[type="text"],
    input[type="number"],
    textarea {
      width: 100%;
      padding: 8px;
      margin-bottom: 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
      background-color: #fff;
    }

    textarea {
      resize: vertical;
      height: 60px;
    }

    input[type="submit"] {
      background-color: #1976d2;
      color: #fff;
      border: none;
      padding: 10px;
      border-radius: 6px;
      width: 100%;
      font-size: 14px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover {
      background-color: #125ea8;
    }

    @media (max-height: 700px) {
      html, body {
        align-items: flex-start;
        padding: 16px;
      }

      form {
        margin-top: 20px;
      }
    }
  </style>
</head>
<body>
<form action="<%= request.getContextPath() %>/upload_product" method="post">
  <h2>Upload Property</h2>

  <label for="name">Property Name</label>
  <input type="text" id="name" name="name" required>

  <label for="category">Category</label>
  <input type="text" id="category" name="category" placeholder="e.g. Apartment, Houses, Villas" required>

  <label for="description">Description</label>
  <textarea id="description" name="description" required></textarea>

  <label for="price">Price ($)</label>
  <input type="number" step="0.01" id="price" name="price" required>

  <label for="imageUrl">Image URL</label>
  <input type="text" id="imageUrl" name="imageUrl" placeholder="https://example.com/image.jpg" required>

  <input type="submit" value="Upload Product">
</form>
</body>
</html>

