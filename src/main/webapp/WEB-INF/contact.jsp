<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Contact Us | RealEstatePro</title>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    :root {
      --primary: #6366f1;
      --primary-light: #e0e7ff;
      --dark: #1e293b;
      --light: #f8fafc;
      --text: #1f2937;
      --text-light: #64748b;
      --border: #e2e8f0;
      --radius: 8px;
    }

    body {
      font-family: 'Montserrat', sans-serif;
      background: var(--light);
      color: var(--text);
      line-height: 1.6;
      margin: 0;
      padding: 0;
    }

    .contact-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem;
    }

    .contact-header {
      text-align: center;
      margin-bottom: 3rem;
    }

    .contact-header h1 {
      font-size: 2.5rem;
      color: var(--primary);
      margin-bottom: 1rem;
    }

    .contact-header p {
      color: var(--text-light);
      max-width: 600px;
      margin: 0 auto;
    }

    .contact-showcase {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 3rem;
      align-items: center;
    }

    .contact-image {
      border-radius: var(--radius);
      overflow: hidden;
      box-shadow: 0 10px 15px rgba(0,0,0,0.1);
    }

    .contact-image img {
      width: 100%;
      height: auto;
      display: block;
    }

    .contact-details {
      background: white;
      padding: 2rem;
      border-radius: var(--radius);
    }

    .contact-details h2 {
      color: var(--primary);
      margin-bottom: 1.5rem;
      font-size: 1.8rem;
    }

    .info-item {
      display: flex;
      align-items: flex-start;
      gap: 1.5rem;
      margin-bottom: 2rem;
    }

    .info-icon {
      background: var(--primary-light);
      color: var(--primary);
      width: 50px;
      height: 50px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      font-size: 1.2rem;
    }

    .info-content h3 {
      margin-bottom: 0.5rem;
      color: var(--dark);
    }

    .info-content p {
      color: var(--text-light);
      margin: 0;
    }

    @media (max-width: 768px) {
      .contact-showcase {
        grid-template-columns: 1fr;
      }

      .contact-header h1 {
        font-size: 2rem;
      }
    }
  </style>
</head>
<body>
<jsp:include page="/header.jsp" />

<div class="contact-container">
  <div class="contact-header">
    <h1>Visit Our Office</h1>
    <p>Our team is ready to assist you with all your real estate needs</p>
  </div>

  <div class="contact-showcase">
    <div class="contact-image">
      <img src="https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Real Estate Office">
    </div>

    <div class="contact-details">
      <h2>Contact Information</h2>

      <div class="info-item">
        <div class="info-icon">
          <i class="fas fa-map-marker-alt"></i>
        </div>
        <div class="info-content">
          <h3>Our Location</h3>
          <p>123 Real Estate Avenue<br>New York, NY 10001</p>
        </div>
      </div>

      <div class="info-item">
        <div class="info-icon">
          <i class="fas fa-phone-alt"></i>
        </div>
        <div class="info-content">
          <h3>Phone Numbers</h3>
          <p>Main: (555) 123-4567<br>Sales: (555) 765-4321</p>
        </div>
      </div>

      <div class="info-item">
        <div class="info-icon">
          <i class="fas fa-envelope"></i>
        </div>
        <div class="info-content">
          <h3>Email Addresses</h3>
          <p>General: info@realestatepro.com<br>Support: help@realestatepro.com</p>
        </div>
      </div>

      <div class="info-item">
        <div class="info-icon">
          <i class="fas fa-clock"></i>
        </div>
        <div class="info-content">
          <h3>Office Hours</h3>
          <p>Monday - Friday: 9AM - 6PM<br>Saturday: 10AM - 4PM</p>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/footer.jsp" />
</body>
</html>
