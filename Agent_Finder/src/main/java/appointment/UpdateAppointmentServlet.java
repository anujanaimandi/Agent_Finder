package appointment;

import com.google.gson.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/update_consultation")
public class UpdateAppointmentServlet extends HttpServlet {

    private static final String FILE_PATH = "C:\\Users\\ACER\\OneDrive\\Desktop\\Data\\appointment.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all form parameters
        String appointmentId = request.getParameter("appointmentId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String service = request.getParameter("service");
        String propertyType = request.getParameter("propertyType");
        String notes = request.getParameter("notes");

        // Validate required fields
        if (appointmentId == null || appointmentId.trim().isEmpty() ||
                firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                date == null || date.trim().isEmpty() ||
                time == null || time.trim().isEmpty() ||
                service == null || service.trim().isEmpty()) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All required fields must be filled");
            return;
        }

        // Read all appointments and find the one to update
        List<String> appointments = new ArrayList<>();
        boolean found = false;
        Gson gson = new Gson();
        String updatedAppointmentJson = null;

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject appointmentObj = JsonParser.parseString(line).getAsJsonObject();
                    String currentId = appointmentObj.get("id").getAsString();

                    if (currentId.equals(appointmentId)) {
                        // Update the found appointment
                        appointmentObj.addProperty("firstName", firstName);
                        appointmentObj.addProperty("lastName", lastName);
                        appointmentObj.addProperty("email", email);
                        appointmentObj.addProperty("phone", phone);
                        appointmentObj.addProperty("date", date);
                        appointmentObj.addProperty("time", time);
                        appointmentObj.addProperty("service", service);
                        appointmentObj.addProperty("propertyType", propertyType != null ? propertyType : "");
                        appointmentObj.addProperty("notes", notes != null ? notes : "");
                        appointmentObj.addProperty("timestamp",
                                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

                        updatedAppointmentJson = gson.toJson(appointmentObj);
                        appointments.add(updatedAppointmentJson);
                        found = true;
                    } else {
                        appointments.add(line);
                    }
                } catch (Exception e) {
                    System.err.println("Skipping invalid JSON line: " + line);
                }
            }
        } catch (FileNotFoundException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No appointments found");
            return;
        }

        if (!found) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
            return;
        }

        // Write back all appointments with the updated one
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (String appointment : appointments) {
                writer.write(appointment);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update appointments");
            return;
        }

        // Send success response
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><head><script type='text/javascript'>");
        out.println("alert('Consultation has been successfully updated.');");
        out.println("window.location.href = './view_appointments';");
        out.println("</script></head>");
        out.println("<body style='background-color: white;'></body></html>");
    }
}
