<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Property List</title>
    <style>
        /* Base Styles */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header Styles */
        h2 {
            text-align: center;
            color: #2c3e50;
            font-size: 2.2rem;
            margin: 40px 0 15px;
            position: relative;
        }

        h2:after {
            content: '';
            position: absolute;
            width: 60px;
            height: 3px;
            background: #3a56d4;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
        }

        /* Category Tabs */
        .category-tabs {
            display: flex;
            justify-content: center;
            margin: 40px 0;
            flex-wrap: wrap;
            gap: 10px;
        }

        .category-tab {
            padding: 12px 25px;
            background: #f1f1f1;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            color: #555;
            font-size: 0.95rem;
        }

        .category-tab.active {
            background: #3a56d4;
            color: white;
            box-shadow: 0 5px 15px rgba(58, 86, 212, 0.3);
        }

        .category-tab:hover:not(.active) {
            background: #ddd;
            transform: translateY(-2px);
        }

        /* Product Grid */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            margin: 70px 0;
        }

        @media (max-width: 992px) {
            .product-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .product-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Product Card */
        .product-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.12);
        }

        .product-img {
            width: 100%;
            height: 200px;
            overflow: hidden;
        }

        .product-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .product-card:hover .product-img img {
            transform: scale(1.05);
        }

        .product-info {
            padding: 20px;
        }

        .product-info h3 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 1.2rem;
            display: flex;
            justify-content: space-between;
        }

        .product-info h3 span {
            color: #3a56d4;
            font-weight: 700;
        }

        .product-info p {
            color: #7f8c8d;
            font-size: 0.95rem;
            margin: 0 0 8px 0;
        }

        .product-category {
            display: inline-block;
            background: #f1f1f1;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            color: #555;
            margin-bottom: 10px;
        }

        .no-products {
            text-align: center;
            color: #7f8c8d;
            font-size: 1.1rem;
            grid-column: 1 / -1;
            padding: 40px 0;
        }

        .category-description {
            font-size: 1rem;
            margin-bottom: 0.75rem;
            color: #555;
            text-align: center;
        }

    </style>
</head>
<body>

<jsp:include page="/header.jsp" />


<div class="container">

    <h2>Our Properties</h2>

    <p class="category-description">
        Browse our property listings to find your ideal space. <br>
        From luxury apartments to beachfront homes, we have it all. <br>
    </p>

    <!-- Category Tabs -->
    <div class="category-tabs">
        <button class="category-tab active" data-category="all">All Properties</button>
        <button class="category-tab" data-category="apartment">Apartments</button>
        <button class="category-tab" data-category="house">Houses</button>
        <button class="category-tab" data-category="villa">Villas</button>
        <button class="category-tab" data-category="commercial">Commercial</button>
        <button class="category-tab" data-category="land">Land</button>
    </div>

    <div class="product-grid">
        <%
            List<JsonElement> properties = (List<JsonElement>) request.getAttribute("products");
            if (properties != null && !properties.isEmpty()) {
                for (JsonElement propertyElement : properties) {
                    JsonObject property = propertyElement.getAsJsonObject();
                    String name = property.get("name").getAsString();
                    String description = property.get("description").getAsString();
                    String category = property.get("category").getAsString();
                    String imageUrl = property.get("imageUrl").getAsString();
                    double price = property.get("price").getAsDouble();
        %>
        <div class="product-card">
            <div class="product-img">
                <img src="<%= imageUrl %>" alt="<%= name %>">
            </div>
            <div class="product-info">
                <span class="product-category"><%= category %></span>
                <h3><%= name %> <span>$<%= String.format("%.2f", price) %></span></h3>
                <p><%= description %></p>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <div class="no-products">
            <p>No properties available.</p>
        </div>
        <%
            }
        %>
    </div>
</div>

<script>
    const categoryTabs = document.querySelectorAll('.category-tab');
    const productCards = document.querySelectorAll('.product-card');

    categoryTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // Update active tab
            categoryTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            const selectedCategory = tab.getAttribute('data-category');

            productCards.forEach(card => {
                const categorySpan = card.querySelector('.product-category');
                const propertyCategory = categorySpan ? categorySpan.textContent.trim().toLowerCase() : '';

                if (selectedCategory === 'all' || propertyCategory === selectedCategory) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });
</script>
<jsp:include page="/footer.jsp" />
</body>
</html>

