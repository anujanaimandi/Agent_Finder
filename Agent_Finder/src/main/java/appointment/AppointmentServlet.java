package appointment;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@WebServlet("/submit_appointment")
public class AppointmentServlet extends HttpServlet {

    private static final String FILE_PATH = "C:\\Users\\ACER\\OneDrive\\Desktop\\Data\\appointment.txt"; // Update this path

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Generate unique ID for the appointment
        String appointmentId = UUID.randomUUID().toString();

        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String service = request.getParameter("service");
        String propertyType = request.getParameter("propertyType");
        String notes = request.getParameter("notes");

        // Validate input
        if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                date == null || date.trim().isEmpty() ||
                time == null || time.trim().isEmpty() ||
                service == null || service.trim().isEmpty()) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Required fields are missing.");
            return;
        }

        // Create timestamp
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        // Create an Appointment object with generated ID
        Appointment appointment = new Appointment(
                appointmentId,
                firstName,
                lastName,
                email,
                phone,
                date,
                time,
                service,
                propertyType,
                notes,
                timestamp
        );

        // Convert to JSON
        Gson gson = new Gson();
        String appointmentJson = gson.toJson(appointment);

        // Save to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(appointmentJson);
            writer.newLine();
            System.out.println("Appointment saved with ID: " + appointmentId);
        } catch (IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save appointment.");
            return;
        }

        // Send success response with appointment ID
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><head><script type='text/javascript'>");
        out.println("alert('Your consultation has been successfully scheduled!');");
        out.println("window.location.href = 'index.jsp?id=" + appointmentId + "';");
        out.println("</script></head>");
        out.println("<body style='background-color: white;'></body></html>");
    }
}
