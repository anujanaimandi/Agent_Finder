package user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/delete_user")
public class UserDeleteServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(UserDeleteServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\HP\\Documents\\Data\\user_data.txt"; // Path to your user data file
    private static final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Simulate DELETE
        String method = request.getParameter("_method");
        if ("DELETE".equalsIgnoreCase(method)) {
            doDelete(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            response.getWriter().write("<script>alert('Unsupported operation'); window.location.href='./users_crud';</script>");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("<script>alert('Missing user ID'); window.location.href='./users_crud';</script>");
            return;
        }

        int targetId;
        try {
            targetId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("<script>alert('Invalid ID format'); window.location.href='./users_crud';</script>");
            return;
        }

        Path path = Paths.get(FILE_PATH);
        if (!Files.exists(path)) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("<script>alert('User data file not found'); window.location.href='./users_crud';</script>");
            return;
        }

        List<String> updatedLines = new ArrayList<>();
        boolean found = false;

        try (BufferedReader reader = Files.newBufferedReader(path)) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject userJson = gson.fromJson(line, JsonObject.class);
                    int userId = userJson.get("id").getAsInt();
                    if (userId != targetId) {
                        updatedLines.add(line);
                    } else {
                        found = true;
                    }
                } catch (JsonSyntaxException | NullPointerException e) {
                    updatedLines.add(line); // Keep bad lines intact
                }
            }
        }

        if (!found) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("<script>alert('User not found'); window.location.href='./users_crud';</script>");
            return;
        }

        Files.write(path, updatedLines, StandardOpenOption.TRUNCATE_EXISTING);
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("<script>alert('User deleted successfully'); window.location.href='./users_crud';</script>");
    }
}

