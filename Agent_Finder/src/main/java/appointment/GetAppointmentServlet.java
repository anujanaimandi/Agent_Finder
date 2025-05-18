package appointment;

import com.google.gson.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/get_consultation")
public class GetAppointmentServlet extends HttpServlet {

    private static final String FILE_PATH = "C:\\Users\\ACER\\OneDrive\\Desktop\\Data\\appointment.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Appointment ID is required");
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject appointmentObj = JsonParser.parseString(line).getAsJsonObject();
                    String currentId = appointmentObj.get("id").getAsString();
                    if (currentId.equals(appointmentId)) {
                        request.setAttribute("appointment", appointmentObj);
                        request.getRequestDispatcher("/appointment/rescheduleForm.jsp").forward(request, response);
                        return;
                    }
                } catch (Exception e) {
                    System.err.println("Skipping invalid JSON line: " + line);
                }
            }
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
        } catch (FileNotFoundException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No appointments found");
        }
    }
}
