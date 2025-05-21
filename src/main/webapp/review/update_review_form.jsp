<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="java.util.List" %>
<%
    List<JsonObject> reviews = (List<JsonObject>) request.getAttribute("reviews");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Reviews | Your Company Name</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-dark: #3a56d4;
            --text: #2b2d42;
            --text-light: #6c757d;
            --light: #f8f9fa;
            --lighter: #fefefe;
            --border: #e9ecef;
            --star-filled: #ffc107;
            --star-empty: #e9ecef;
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            --radius-sm: 8px;
            --radius-md: 12px;
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            color: var(--text);
            background-color: var(--light);
            line-height: 2;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }

        .page-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: var(--text-light);
            font-size: 1rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            border: none;
            gap: 0.5rem;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .review-card {
            background: var(--lighter);
            border-radius: var(--radius-md);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .review-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .avatar {
            width: 2.5rem;
            height: 2.5rem;
            border-radius: 50%;
            background-color: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-weight: 600;
            flex-shrink: 0;
        }

        .reviewer-info {
            display: flex;
            flex-direction: column;
        }

        .reviewer-name {
            font-weight: 600;
            margin: 0;
            font-size: 1rem;
        }

        .review-date {
            color: var(--text-light);
            font-size: 0.8rem;
            margin-top: 0.2rem;
        }

        .review-content {
            margin: 1rem 0;
            flex-grow: 1;
        }

        .review-text {
            font-size: 0.95rem;
            line-height: 1.6;
            color: var(--text);
            margin-bottom: 1rem;
            max-height: 6rem;
            overflow-y: auto;
            padding-right: 0.5rem;
        }

        .review-text::-webkit-scrollbar {
            width: 4px;
        }

        .review-text::-webkit-scrollbar-track {
            background: var(--border);
        }

        .review-text::-webkit-scrollbar-thumb {
            background: var(--primary);
            border-radius: 2px;
        }

        .rating {
            display: flex;
            align-items: center;
            margin-top: auto;
        }

        .stars {
            color: var(--star-filled);
            display: flex;
            gap: 0.1rem;
        }

        .stars .empty {
            color: var(--star-empty);
        }

        .rating-value {
            margin-left: 0.5rem;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 3rem;
            color: var(--text-light);
        }

        .empty-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--border);
        }

        .empty-text {
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1.5rem 1rem;
            }

            .page-title {
                font-size: 1.5rem;
            }

            .reviews-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/header.jsp" />

<main class="container">
    <header class="page-header">
        <h1 class="page-title">Customer Reviews</h1>
        <p class="page-subtitle">Read what our customers say about their experience with our products and services.</p>
    </header>

    <div class="text-center">
        <a href="<%= request.getContextPath() %>/review/review_form.jsp" class="btn btn-primary">
            <i class="fas fa-plus"></i> Write a Review
        </a>
    </div>

    <div class="reviews-grid">
        <%
            if (reviews != null && !reviews.isEmpty()) {
                for (JsonObject review : reviews) {
                    String name = review.get("reviewerName").getAsString();
                    String comment = review.get("comment").getAsString();
                    int rating = review.get("rating").getAsInt();
                    String initials = name.substring(0, 1).toUpperCase();
                    // Assuming you might add date in the future
                    String date = review.has("date") ? review.get("date").getAsString() : "Recently";
        %>
        <article class="review-card">
            <div class="review-header">
                <div class="avatar"><%= initials %></div>
                <div class="reviewer-info">
                    <h3 class="reviewer-name"><%= name %></h3>
                    <span class="review-date"><%= date %></span>
                </div>
            </div>

            <div class="review-content">
                <p class="review-text"><%= comment %></p>
            </div>

            <div class="rating">
                <div class="stars">
                    <%
                        for (int i = 1; i <= 5; i++) {
                            if (i <= rating) {
                    %>
                    <i class="fas fa-star"></i>
                    <%
                    } else {
                    %>
                    <i class="fas fa-star empty"></i>
                    <%
                            }
                        }
                    %>
                </div>

            </div>
        </article>
        <%
            }
        } else {
        %>
        <div class="empty-state">
            <i class="far fa-comment-dots empty-icon"></i>
            <h3 class="empty-text">No reviews yet</h3>
            <p>Be the first to share your experience with us!</p>
        </div>
        <%
            }
        %>
    </div>
</main>

<jsp:include page="/footer.jsp" />
</body>
</html>
