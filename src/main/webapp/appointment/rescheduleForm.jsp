<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.JsonObject" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reschedule Consultation | PrimeHomes</title>
    <style>
        .reschedule-container {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
        }
        .reschedule-header {
            color: #2c3e50;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #34495e;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .read-only-field {
            padding: 8px;
            background-color: #f5f5f5;
            border-radius: 4px;
            border: 1px solid #eee;
        }
        .form-actions {
            margin-top: 20px;
            text-align: right;
        }
        .update-btn {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .update-btn:hover {
            background-color: #2980b9;
        }
        .error-message {
            color: #e74c3c;
            margin-top: 5px;
            font-size: 13px;
        }
    </style>
</head>
<body>

<div class="reschedule-container">
    <h2 class="reschedule-header">Reschedule Consultation</h2>

    <%
        JsonObject appointment = (JsonObject) request.getAttribute("appointment");
        if (appointment != null) {
            String service = appointment.get("service").getAsString();
            String serviceName = "";
            switch(service) {
                case "buy": serviceName = "Buying Consultation"; break;
                case "sell": serviceName = "Selling Consultation"; break;
                case "rent": serviceName = "Rental Consultation"; break;
                case "valuation": serviceName = "Valuation Service"; break;
                default: serviceName = "Property Consultation";
            }
    %>
    <form id="rescheduleForm" action="update_consultation" method="post" onsubmit="return validateForm()">
        <!-- Hidden fields for non-editable data -->
        <input type="hidden" name="appointmentId" value="<%= appointment.get("id").getAsString() %>">
        <input type="hidden" name="firstName" value="<%= appointment.get("firstName").getAsString() %>">
        <input type="hidden" name="lastName" value="<%= appointment.get("lastName").getAsString() %>">
        <input type="hidden" name="email" value="<%= appointment.get("email").getAsString() %>">
        <input type="hidden" name="phone" value="<%= appointment.get("phone").getAsString() %>">
        <input type="hidden" name="service" value="<%= service %>">
        <input type="hidden" name="propertyType" value="<%= appointment.has("propertyType") ? appointment.get("propertyType").getAsString() : "" %>">

        <!-- Display-only fields -->
        <div class="form-group">
            <label>Client Name</label>
            <div class="read-only-field">
                <%= appointment.get("firstName").getAsString() %> <%= appointment.get("lastName").getAsString() %>
            </div>
        </div>

        <div class="form-group">
            <label>Service Type</label>
            <div class="read-only-field">
                <%= serviceName %>
            </div>
        </div>

        <div class="form-group">
            <label>Property Type</label>
            <div class="read-only-field">
                <%= appointment.has("propertyType") && !appointment.get("propertyType").getAsString().isEmpty()
                        ? appointment.get("propertyType").getAsString() : "Not specified" %>
            </div>
        </div>

        <!-- Editable fields -->
        <div class="form-group">
            <label for="date">New Date *</label>
            <input type="date" id="date" name="date"
                   value="<%= appointment.get("date").getAsString() %>" required
                   min="<%= java.time.LocalDate.now().toString() %>">
            <div id="dateError" class="error-message"></div>
        </div>

        <div class="form-group">
            <label for="time">New Time Slot *</label>
            <select id="time" name="time" required>
                <option value="9-10" <%= "9-10".equals(appointment.get("time").getAsString()) ? "selected" : "" %>>9:00 - 10:00 AM</option>
                <option value="10-11" <%= "10-11".equals(appointment.get("time").getAsString()) ? "selected" : "" %>>10:00 - 11:00 AM</option>
                <option value="11-12" <%= "11-12".equals(appointment.get("time").getAsString()) ? "selected" : "" %>>11:00 AM - 12:00 PM</option>
                <option value="1-2" <%= "1-2".equals(appointment.get("time").getAsString()) ? "selected" : "" %>>1:00 - 2:00 PM</option>
                <option value="2-3" <%= "2-3".equals(appointment.get("time").getAsString()) ? "selected" : "" %>>2:00 - 3:00 PM</option>
                <option value="3-4" <%= "3-4".equals(appointment.get("time").getAsString()) ? "selected" : "" %>>3:00 - 4:00 PM</option>
            </select>
        </div>

        <div class="form-group">
            <label for="notes">Additional Notes</label>
            <textarea id="notes" name="notes" rows="3"><%=
            appointment.has("notes") ? appointment.get("notes").getAsString() : ""
            %></textarea>
        </div>

        <div class="form-actions">
            <button type="submit" class="update-btn">Update Schedule</button>
        </div>
    </form>

    <script>
        function validateForm() {
            const dateInput = document.getElementById('date');
            const dateError = document.getElementById('dateError');
            const selectedDate = new Date(dateInput.value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            if (selectedDate < today) {
                dateError.textContent = "Date cannot be in the past";
                return false;
            }
            dateError.textContent = "";
            return true;
        }
    </script>

    <% } else { %>
    <div class="error-message">
        <p>Appointment details not found. Please try again or contact support.</p>
    </div>
    <% } %>
</div>

</body>
</html>