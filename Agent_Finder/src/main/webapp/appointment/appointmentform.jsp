<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex,nofollow" />
    <title>Appointment Form | PrimeHomes</title>

    <!-- Stylesheets -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/font-awesome.min.css" rel="stylesheet">
    <link href="css/global.css" rel="stylesheet">
    <link href="css/index.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans&display=swap" rel="stylesheet">

    <!-- Scripts -->
    <script src="js/bootstrap.bundle.min.js"></script>

    <!-- Inline Styles -->
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #f7f9fc;
            font-family: 'Helvetica Neue', Arial, sans-serif;
        }

        .minimal-appointment-form {
            max-width: 600px;
            margin: 4rem auto;
            padding: 2rem;
            background: #fff;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
            border-radius: 10px;
        }

        .minimal-appointment-form h2 {
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 1.5rem;
            text-align: center;
            font-size: 1.75rem;
        }

        .minimal-form {
            display: grid;
            gap: 1.25rem;
        }

        .minimal-form-group {
            display: flex;
            flex-direction: column;
        }

        .minimal-form-group label {
            margin-bottom: 0.5rem;
            color: #555;
            font-size: 0.95rem;
        }

        .minimal-form-group input,
        .minimal-form-group select,
        .minimal-form-group textarea {
            padding: 0.75rem;
            border: 1px solid #ccd6dd;
            font-size: 1rem;
            border-radius: 6px;
            background: #fefefe;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .minimal-form-group input:focus,
        .minimal-form-group select:focus,
        .minimal-form-group textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.15);
        }

        .minimal-form-group.full-width {
            grid-column: span 2;
        }

        .button-wrapper {
            grid-column: span 2;
            display: flex;
            justify-content: center;
        }

        .minimal-submit-btn {
            padding: 0.75rem 1.5rem;
            background:  #3a56d4;
            color: #fff;
            border: none;
            font-size: 1rem;
            cursor: pointer;
            border-radius: 6px;
            transition: background 0.3s ease, box-shadow 0.3s ease;
            min-width: 160px;
        }

        .minimal-submit-btn:hover {
            background:  #3a56a4;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        @media (min-width: 768px) {
            .minimal-form {
                grid-template-columns: 1fr 1fr;
            }
            .minimal-form-group.full-width {
                grid-column: span 2;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/header.jsp" />


<!-- Dummy navbar_sticky element to avoid JS error -->
<div id="navbar_sticky" class="navbar"></div>

<div class="minimal-appointment-form">
    <h2>Schedule a Consultation</h2>
    <form class="minimal-form" method="post" action="<%= request.getContextPath() %>/submit_appointment">

        <div class="minimal-form-group">
            <label for="first-name">First Name</label>
            <input type="text" id="first-name" name="firstName" required autocomplete="given-name" />
        </div>

        <div class="minimal-form-group">
            <label for="last-name">Last Name</label>
            <input type="text" id="last-name" name="lastName" required autocomplete="family-name" />
        </div>

        <div class="minimal-form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required autocomplete="email" />
        </div>

        <div class="minimal-form-group">
            <label for="phone">Phone</label>
            <input type="tel" id="phone" name="phone" required autocomplete="tel" />
        </div>

        <div class="minimal-form-group">
            <label for="date">Preferred Date</label>
            <input type="date" id="date" name="date" required min="<%= java.time.LocalDate.now() %>" />
        </div>

        <div class="minimal-form-group">
            <label for="time">Preferred Time</label>
            <select id="time" name="time" required>
                <option value="">Select time</option>
                <option value="9-10">9–10 AM</option>
                <option value="10-11">10–11 AM</option>
                <option value="11-12">11–12 PM</option>
                <option value="1-2">1–2 PM</option>
                <option value="2-3">2–3 PM</option>
                <option value="3-4">3–4 PM</option>
            </select>
        </div>

        <div class="minimal-form-group">
            <label for="service">Service Needed</label>
            <select id="service" name="service" required>
                <option value="">Select service</option>
                <option value="buy">Buying</option>
                <option value="sell">Selling</option>
                <option value="rent">Renting</option>
                <option value="valuation">Valuation</option>
            </select>
        </div>

        <div class="minimal-form-group">
            <label for="property-type">Property Type</label>
            <select id="property-type" name="propertyType">
                <option value="">Any type</option>
                <option value="house">House</option>
                <option value="apartment">Apartment</option>
                <option value="land">Land</option>
                <option value="commercial">Commercial</option>
            </select>
        </div>

        <div class="minimal-form-group full-width">
            <label for="notes">Additional Notes</label>
            <textarea id="notes" name="notes" rows="3" placeholder="Please provide any additional information about your needs..."></textarea>
        </div>

        <div class="button-wrapper">
            <button type="submit" class="minimal-submit-btn">Book Appointment</button>
        </div>

    </form>
</div>

<!-- Sticky Navbar Script -->
<script>
    window.onscroll = function() {myFunction()};
    var navbar_sticky = document.getElementById("navbar_sticky");
    var sticky = navbar_sticky.offsetTop;
    var navbar_height = document.querySelector('.navbar').offsetHeight;

    function myFunction() {
        if (window.pageYOffset >= sticky + navbar_height) {
            navbar_sticky.classList.add("sticky");
            document.body.style.paddingTop = navbar_height + 'px';
        } else {
            navbar_sticky.classList.remove("sticky");
            document.body.style.paddingTop = '0';
        }
    }
</script>
<jsp:include page="/footer.jsp" />

</body>
</html>

