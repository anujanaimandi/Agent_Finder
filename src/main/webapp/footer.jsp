<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Footer</title>
  <style>
    .footer {
      background-color: #1a1a2e;
      color: white;
      padding: 2rem 1rem;
      text-align: center;
      margin-top: 3rem;
    }

    .footer-links {
      display: flex;
      justify-content: center;
      gap: 2rem;
      margin-bottom: 1.5rem;
      flex-wrap: wrap;
    }

    .footer-link {
      color: #a1a1aa;
      text-decoration: none;
      transition: color 0.3s ease;
    }

    .footer-link:hover {
      color: #6366f1;
    }

    .footer-social {
      display: flex;
      justify-content: center;
      gap: 1rem;
      margin: 1.5rem 0;
    }

    .footer-social-icon {
      color: white;
      background: rgba(255, 255, 255, 0.1);
      width: 36px;
      height: 36px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
    }

    .footer-social-icon:hover {
      background: #6366f1;
      transform: translateY(-3px);
    }

    .footer-copyright {
      color: #a1a1aa;
      font-size: 0.9rem;
    }
  </style>
  <!-- Font Awesome for social icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<footer class="footer">
  <div class="footer-links">
    <a class="footer-link" href="index.jsp">Properties</a>
    <a class="footer-link" href="<%= request.getContextPath() %>/read_agents">Agents</a>
    <a class="footer-link" href="<%= request.getContextPath() %>/read_reviews">Reviews</a>
    <a class="footer-link" href="inquiryForm.jsp">Contact</a>
    <a class="footer-link" href="about.jsp">About</a>
    <a class="footer-link" href="privacy.jsp">Privacy</a>
  </div>

  <div class="footer-social">
    <a class="footer-social-icon" href="#"><i class="fab fa-facebook-f"></i></a>
    <a class="footer-social-icon" href="#"><i class="fab fa-twitter"></i></a>
    <a class="footer-social-icon" href="#"><i class="fab fa-instagram"></i></a>
    <a class="footer-social-icon" href="#"><i class="fab fa-linkedin-in"></i></a>
  </div>

  <div class="footer-copyright">
    &copy; <%= java.time.Year.now().getValue() %> RealEstatePro. All rights reserved.
  </div>
</footer>
</body>
</html>
