<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        username = "";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Review | Your Company Name</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6366f1;
            --primary-light: #e0e7ff;
            --primary-dark: #4f46e5;
            --text: #1e293b;
            --text-light: #64748b;
            --light: #f8fafc;
            --lighter: #ffffff;
            --border: #e2e8f0;
            --border-focus: #a5b4fc;
            --error: #ef4444;
            --success: #10b981;
            --star-filled: #f59e0b;
            --star-empty: #cbd5e1;
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            --shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.1);
            --radius-sm: 0.375rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            --gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
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
            -webkit-font-smoothing: antialiased;
        }

        .container {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2.5rem;
            background: var(--lighter);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            position: relative;
            overflow: hidden;
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 6px;
            background: var(--gradient);
        }

        .page-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text);
            margin-bottom: 0.75rem;
            background: var(--gradient);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: inline-block;
        }

        .page-subtitle {
            color: var(--text-light);
            font-size: 1.125rem;
            max-width: 400px;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 1.75rem;
        }

        label {
            display: block;
            margin-bottom: 0.75rem;
            font-weight: 600;
            color: var(--text);
            font-size: 0.9375rem;
        }

        .input-wrapper {
            position: relative;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 0.875rem 1.25rem;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            font-size: 1rem;
            transition: var(--transition);
            background-color: var(--lighter);
            font-family: inherit;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus {
            outline: none;
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(165, 180, 252, 0.3);
        }

        input[readonly] {
            background-color: var(--light);
            cursor: not-allowed;
            opacity: 0.8;
        }

        textarea {
            min-height: 150px;
            resize: vertical;
            line-height: 1.6;
        }

        .rating-container {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .rating-stars {
            display: flex;
            gap: 0.5rem;
            margin-top: 0.25rem;
        }

        .star {
            font-size: 1.75rem;
            color: var(--star-empty);
            cursor: pointer;
            transition: var(--transition);
        }

        .star:hover,
        .star.active {
            color: var(--star-filled);
            transform: scale(1.1);
        }

        .rating-hint {
            font-size: 0.875rem;
            color: var(--text-light);
            margin-top: 0.25rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 1rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            border: none;
            background: var(--gradient);
            color: white;
            width: 100%;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-md);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(rgba(255,255,255,0.2), rgba(255,255,255,0));
            opacity: 0;
            transition: var(--transition);
        }

        .btn:hover::after {
            opacity: 1;
        }

        .btn i {
            margin-right: 0.75rem;
            font-size: 1.1em;
        }

        .char-counter {
            font-size: 0.75rem;
            color: var(--text-light);
            text-align: right;
            margin-top: 0.25rem;
        }

        @media (max-width: 768px) {
            .container {
                margin: 1rem;
                padding: 1.75rem;
            }

            .page-title {
                font-size: 1.75rem;
            }

            .page-subtitle {
                font-size: 1rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1.5rem;
            }

            .star {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />

    <div class="container">
        <header class="page-header">
            <h1 class="page-title">Share Your Experience</h1>
            <p class="page-subtitle">We value your honest feedback about our products and services</p>
        </header>

        <form action="<%= request.getContextPath() %>/upload_review" method="post" onsubmit="return validateSessionBeforeSubmit()">
            <div class="form-group">
                <label for="reviewerName">Your Name</label>
                <div class="input-wrapper">
                    <input type="text" id="reviewerName" name="reviewerName" value="<%= username %>" readonly />
                </div>
            </div>

            <div class="form-group">
                <label for="comment">Your Review</label>
                <div class="input-wrapper">
                    <textarea id="comment" name="comment" required placeholder="Tell us about your experience... What did you like? What could we improve?"></textarea>
                </div>
                <div class="char-counter"><span id="charCount">0</span>/500</div>
            </div>

            <div class="form-group">
                <label>Your Rating</label>
                <div class="rating-container">
                    <div class="rating-stars" id="starRating">
                        <i class="fas fa-star star" data-rating="1"></i>
                        <i class="fas fa-star star" data-rating="2"></i>
                        <i class="fas fa-star star" data-rating="3"></i>
                        <i class="fas fa-star star" data-rating="4"></i>
                        <i class="fas fa-star star" data-rating="5"></i>
                    </div>
                    <input type="hidden" id="rating" name="rating" required value="" />
                    <p class="rating-hint">Click on the stars to rate your experience (1 = Poor, 5 = Excellent)</p>
                </div>
            </div>

            <button type="submit" class="btn">
                <i class="fas fa-paper-plane"></i> Submit Review
            </button>
        </form>
    </div>

    <jsp:include page="/footer.jsp" />

    <script>
        // Session validation
        function validateSessionBeforeSubmit() {
            var username = "<%= username %>";
            if (!username || username.trim() === "") {
                alert("Please sign in to submit your review. You'll be redirected to the login page.");
                window.location.href = "<%= request.getContextPath() %>/user/login.jsp";
                return false;
            }

            // Validate rating was selected
            const rating = document.getElementById('rating').value;
            if (!rating) {
                alert("Please select a rating by clicking on the stars.");
                return false;
            }

            return true;
        }

        // Star rating functionality
        document.addEventListener('DOMContentLoaded', function() {
            const stars = document.querySelectorAll('.star');
            const ratingInput = document.getElementById('rating');

            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const rating = this.getAttribute('data-rating');
                    ratingInput.value = rating;

                    // Update star display
                    stars.forEach((s, index) => {
                        if (index < rating) {
                            s.classList.add('active');
                        } else {
                            s.classList.remove('active');
                        }
                    });
                });

                // Hover effect
                star.addEventListener('mouseover', function() {
                    const hoverRating = this.getAttribute('data-rating');
                    stars.forEach((s, index) => {
                        if (index < hoverRating) {
                            s.style.color = 'var(--star-filled)';
                        }
                    });
                });

                star.addEventListener('mouseout', function() {
                    const currentRating = ratingInput.value || 0;
                    stars.forEach((s, index) => {
                        if (index >= currentRating) {
                            s.style.color = 'var(--star-empty)';
                        }
                    });
                });
            });

            // Character counter for textarea
            const textarea = document.getElementById('comment');
            const charCount = document.getElementById('charCount');

            textarea.addEventListener('input', function() {
                const count = this.value.length;
                charCount.textContent = count;

                if (count > 500) {
                    this.value = this.value.substring(0, 500);
                    charCount.textContent = 500;
                }
            });
        });
    </script>
</body>
</html>
