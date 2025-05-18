package appointment;


import com.google.gson.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/delete_consultation")
public class DeleteAppointmentServlet extends HttpServlet {

    private static final String FILE_PATH = "C:\\Users\\ACER\\OneDrive\\Desktop\\Data\\appointment.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the appointment ID to delete
        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Appointment ID is required");
            return;
        }

        // Read all appointments
        List<String> appointments = new ArrayList<>();
        boolean found = false;
        Gson gson = new Gson();

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject appointmentObj = JsonParser.parseString(line).getAsJsonObject();
                    String currentId = appointmentObj.get("id").getAsString();
                    if (!currentId.equals(appointmentId)) {
                        appointments.add(line); // Keep appointments that don't match the ID
                    } else {
                        found = true;
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

        // Write back all appointments except the deleted one
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
        out.println("alert('Consultation has been successfully canceled.');");
        out.println("window.location.href = './view_appointments';");
        out.println("</script></head>");
        out.println("<body style='background-color: white;'></body></html>");
    }
}

