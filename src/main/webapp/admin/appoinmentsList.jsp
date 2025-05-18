<%@ page import="com.google.gson.*, java.io.*, java.util.ArrayList, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  final String FILE_PATH = "C:\\Users\\HP\\Documents\\Data\\appointment.txt";
  List<JsonElement> appointments = new ArrayList<>();

  try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
    String line;
    while ((line = reader.readLine()) != null) {
      try {
        JsonElement json = JsonParser.parseString(line);
        appointments.add(json);
      } catch (Exception e) {
        System.err.println("Skipping invalid JSON line: " + line);
      }
    }
  } catch (IOException e) {
    e.printStackTrace();
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not read appointments.");
    return;
  }
%>

<!DOCTYPE html>
<html>
<head>
  <title>Property Consultations | PrimeHomes</title>
  <style>
    .consultation-container {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f5f7fa;
      margin: 0;
      padding: 0;
    }
    .consultation-wrapper {
      max-width: 1000px;
      margin: 30px auto;
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 15px rgba(0,0,0,0.08);
      padding: 30px;
    }
    .consultation-header {
      color: #2c3e50;
      margin-bottom: 25px;
      border-bottom: 1px solid #eee;
      padding-bottom: 10px;
      font-size: 28px;
    }
    .consultation-list {
      padding: 0;
      list-style: none;
    }
    .consultation-card {
      padding: 20px;
      margin-bottom: 15px;
      border-radius: 6px;
      background-color: #f9f9f9;
      border-left: 4px solid #e74c3c;
      transition: all 0.3s ease;
    }
    .consultation-card:hover {
      background-color: #f0f0f0;
      transform: translateX(5px);
    }
    .consultation-client {
      margin: 0 0 10px;
      font-size: 20px;
      color: #2c3e50;
    }
    .consultation-details {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 15px;
      margin-top: 15px;
    }
    .consultation-detail-card {
      background: #ffffff;
      padding: 12px;
      border-radius: 4px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }
    .detail-label {
      color: #34495e;
      display: block;
      margin-bottom: 5px;
      font-size: 14px;
    }
    .detail-value {
      color: #2c3e50;
      font-size: 15px;
    }
    .consultation-actions {
      margin-top: 20px;
      display: flex;
      gap: 12px;
    }
    .action-btn {
      padding: 8px 16px;
      border-radius: 4px;
      font-size: 14px;
      cursor: pointer;
      transition: all 0.2s;
      font-weight: 500;
      border: none;
      color: white;
    }
    .reschedule-action {
      background-color: #3498db;
    }
    .reschedule-action:hover {
      background-color: #2980b9;
      transform: translateY(-2px);
    }
    .cancel-action {
      background-color: #e74c3c;
    }
    .cancel-action:hover {
      background-color: #c0392b;
      transform: translateY(-2px);
    }
    .consultation-timestamp {
      font-size: 13px;
      color: #95a5a6;
      text-align: right;
      margin-top: 15px;
      padding-top: 10px;
      border-top: 1px dashed #ddd;
    }
    .empty-consultations {
      text-align: center;
      padding: 40px 20px;
      color: #7f8c8d;
      font-size: 16px;
    }
    .consultation-notes {
      grid-column: 1 / -1;
    }
  </style>
  <script>
    function confirmReschedule() {
      return confirm("Are you sure you want to reschedule this consultation?");
    }
    function confirmCancel() {
      return confirm("Are you sure you want to cancel this consultation?");
    }
  </script>
</head>
<body class="consultation-container">
<div class='consultation-wrapper'>
  <h2 class="consultation-header">Scheduled Property Consultations</h2>

  <% if (appointments.isEmpty()) { %>
  <div class='empty-consultations'>
    <p>No property consultations scheduled yet.</p>
  </div>
  <% } else { %>
  <ul class="consultation-list">
    <% for (JsonElement appointment : appointments) {
      if (appointment.isJsonObject()) {
        JsonObject appointmentObj = appointment.getAsJsonObject();

        String firstName = appointmentObj.has("firstName") ? appointmentObj.get("firstName").getAsString() : "";
        String lastName = appointmentObj.has("lastName") ? appointmentObj.get("lastName").getAsString() : "";
        String email = appointmentObj.has("email") ? appointmentObj.get("email").getAsString() : "";
        String phone = appointmentObj.has("phone") ? appointmentObj.get("phone").getAsString() : "";
        String date = appointmentObj.has("date") ? appointmentObj.get("date").getAsString() : "";
        String time = appointmentObj.has("time") ? appointmentObj.get("time").getAsString() : "";
        String service = appointmentObj.has("service") ? appointmentObj.get("service").getAsString() : "";
        String propertyType = appointmentObj.has("propertyType") ? appointmentObj.get("propertyType").getAsString() : "";
        String notes = appointmentObj.has("notes") ? appointmentObj.get("notes").getAsString() : "";
        String timestamp = appointmentObj.has("timestamp") ? appointmentObj.get("timestamp").getAsString() : "";
        String appointmentId = appointmentObj.has("id") ? appointmentObj.get("id").getAsString() : "";

        // Format service name
        String serviceName = "";
        switch(service) {
          case "buy": serviceName = "Buying Consultation"; break;
          case "sell": serviceName = "Selling Consultation"; break;
          case "rent": serviceName = "Rental Consultation"; break;
          case "valuation": serviceName = "Valuation Service"; break;
          default: serviceName = "Property Consultation";
        }

        // Format time
        String formattedTime = "";
        switch(time) {
          case "9-10": formattedTime = "9:00 - 10:00 AM"; break;
          case "10-11": formattedTime = "10:00 - 11:00 AM"; break;
          case "11-12": formattedTime = "11:00 AM - 12:00 PM"; break;
          case "1-2": formattedTime = "1:00 - 2:00 PM"; break;
          case "2-3": formattedTime = "2:00 - 3:00 PM"; break;
          case "3-4": formattedTime = "3:00 - 4:00 PM"; break;
          default: formattedTime = time;
        }
    %>
    <li class="consultation-card">
      <h3 class="consultation-client"><%= firstName %> <%= lastName %></h3>

      <div class="consultation-details">
        <div class="consultation-detail-card">
          <strong class="detail-label">Service Type</strong>
          <span class="detail-value"><%= serviceName %></span>
        </div>

        <div class="consultation-detail-card">
          <strong class="detail-label">Property Type</strong>
          <span class="detail-value"><%= propertyType.isEmpty() ? "Not specified" : propertyType %></span>
        </div>

        <div class="consultation-detail-card">
          <strong class="detail-label">Date</strong>
          <span class="detail-value"><%= date %></span>
        </div>

        <div class="consultation-detail-card">
          <strong class="detail-label">Time</strong>
          <span class="detail-value"><%= formattedTime %></span>
        </div>

        <div class="consultation-detail-card">
          <strong class="detail-label">Contact</strong>
          <span class="detail-value"><%= phone %></span>
          <span class="detail-value"><%= email %></span>
        </div>

        <% if (!notes.isEmpty()) { %>
        <div class="consultation-detail-card consultation-notes">
          <strong class="detail-label">Client Notes</strong>
          <span class="detail-value"><%= notes %></span>
        </div>
        <% } %>
      </div>

      <div class="consultation-actions">
        <form action='get_consultation' method='get'>
          <input type='hidden' name='appointmentId' value='<%= appointmentId %>'>
          <input type='submit' class='action-btn reschedule-action' value='Reschedule'>
        </form>

        <form action='delete_consultation' method='post' onsubmit="return confirmCancel();">
          <input type='hidden' name='appointmentId' value='<%= appointmentId %>'>
          <input type='submit' class='action-btn cancel-action' value='Cancel'>
        </form>
      </div>

      <div class="consultation-timestamp">
        Scheduled on <%= timestamp %>
      </div>
    </li>
    <% }
    } %>
  </ul>
  <% } %>
</div>
</body>
</html>