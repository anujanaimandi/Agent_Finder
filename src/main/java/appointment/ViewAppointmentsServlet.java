package appointment;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;

@WebServlet("/view_appointments")
public class ViewAppointmentsServlet extends HttpServlet {

    private static final String FILE_PATH = "C:\\Users\\ACER\\OneDrive\\Desktop\\Data\\appointment.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Appointment> appointments = new ArrayList<>();
        Gson gson = new Gson();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    Appointment appointment = gson.fromJson(line, Appointment.class);
                    appointments.add(appointment);
                } catch (Exception e) {
                    System.err.println("Skipping invalid appointment line: " + line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error reading appointments");
            return;
        }

        // Sort if requested
        String sortBy = request.getParameter("sortBy");
        if ("date".equalsIgnoreCase(sortBy)) {
            appointments.sort(Comparator.comparing(a -> {
                try {
                    return LocalDate.parse(a.getDate(), formatter);
                } catch (DateTimeParseException e) {
                    return LocalDate.MIN;
                }
            }));
        }

        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/admin/appointmentsList.jsp").forward(request, response);
    }
}

