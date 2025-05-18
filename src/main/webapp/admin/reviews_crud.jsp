<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    List<JsonObject> reviews = (List<JsonObject>) request.getAttribute("reviews");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reviews</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4f46e5;
            --primary-light: #e0e7ff;
            --primary-dark: #4338ca;
            --danger: #ef4444;
            --danger-light: #fee2e2;
            --danger-dark: #dc2626;
            --success: #10b981;
            --success-light: #d1fae5;
            --warning: #f59e0b;
            --text: #1f2937;
            --text-light: #6b7280;
            --light: #f9fafb;
            --lighter: #ffffff;
            --border: #e5e7eb;
            --radius-sm: 0.375rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: var(--text);
            background-color: var(--light);
            line-height: 1.5;
            padding: 2rem;
            -webkit-font-smoothing: antialiased;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: var(--lighter);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }

        .header {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary);
        }

        .reviews-table {
            width: 100%;
            border-collapse: collapse;
        }

        .reviews-table th {
            text-align: left;
            padding: 1rem 1.5rem;
            background-color: var(--primary-light);
            color: var(--primary);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }

        .reviews-table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }

        .reviews-table tr:last-child td {
            border-bottom: none;
        }

        .reviews-table tr:hover td {
            background-color: rgba(249, 250, 251, 0.8);
        }

        .comment-cell {
            max-width: 400px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .rating-cell {
            font-weight: 600;
        }

        .rating-stars {
            color: var(--warning);
            margin-right: 0.5rem;
        }

        .actions-cell {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
            font-weight: 500;
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            border: none;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.8125rem;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow-sm);
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: var(--danger-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow-sm);
        }

        .btn-success {
            background-color: var(--success);
            color: white;
        }

        .empty-state {
            padding: 3rem;
            text-align: center;
            color: var(--text-light);
        }

        .empty-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--border);
        }

        .empty-text {
            font-size: 1.125rem;
            margin-bottom: 0.5rem;
        }

        .empty-subtext {
            max-width: 400px;
            margin: 0 auto;
        }

        form {
            margin: 0;
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }

            .header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .reviews-table {
                display: block;
                overflow-x: auto;
            }

            .comment-cell {
                max-width: 200px;
            }
        }

        @media (max-width: 480px) {
            .actions-cell {
                flex-direction: column;
                gap: 0.25rem;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1 class="title">Review Management</h1>
        <div>
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-primary btn-sm">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </div>

    <% if (reviews != null && !reviews.isEmpty()) { %>
    <table class="reviews-table">
        <thead>
        <tr>
            <th>Name</th>
            <th>Comment</th>
            <th>Rating</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (JsonObject review : reviews) {
            int id = review.get("id").getAsInt();
            String name = review.get("reviewerName").getAsString();
            String comment = review.get("comment").getAsString();
            int rating = review.get("rating").getAsInt();
        %>
        <tr>
            <td><%= name %></td>
            <td class="comment-cell" title="<%= comment %>"><%= comment %></td>
            <td class="rating-cell">
                            <span class="rating-stars">
                                <% for (int i = 0; i < 5; i++) { %>
                                    <i class="fas <%= i < rating ? "fa-star" : "fa-star" %>"></i>
                                <% } %>
                            </span>
                <%= rating %>/5
            </td>
            <td class="actions-cell">
                <!-- Update Form -->
                <form method="get" action="<%= request.getContextPath() %>/edit_review">
                    <input type="hidden" name="id" value="<%= id %>" />
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                </form>

                <!-- Delete Form -->
                <form method="post" action="<%= request.getContextPath() %>/delete_review">
                    <input type="hidden" name="id" value="<%= id %>" />
                    <button type="submit" class="btn btn-danger btn-sm">
                        <i class="fas fa-trash-alt"></i> Delete
                    </button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <div class="empty-state">
        <i class="far fa-comment-dots empty-icon"></i>
        <h3 class="empty-text">No Reviews Found</h3>
        <p class="empty-subtext">There are currently no reviews to display.</p>
    </div>
    <% } %>
</div>
</body>
</html>
