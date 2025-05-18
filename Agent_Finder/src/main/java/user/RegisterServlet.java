package user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import java.io.*;
import java.nio.file.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(RegisterServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\HP\\Documents\\Data\\user_data.txt";
    private static final Gson gson = new Gson();
    private static final AtomicInteger idCounter = initializeIdCounter();

    private static AtomicInteger initializeIdCounter() {
        try {
            Path path = Paths.get(FILE_PATH);
            if (Files.exists(path)) {
                int maxId = Files.lines(path)
                        .map(line -> {
                            try {
                                return gson.fromJson(line, User.class);
                            } catch (Exception e) {
                                logger.log(Level.WARNING, "Failed to parse user line: " + line, e);
                                return null;
                            }
                        })
                        .filter(u -> u != null)
                        .mapToInt(User::getId)
                        .max()
                        .orElse(0);
                return new AtomicInteger(maxId + 1);
            }
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error initializing user ID counter", e);
        }
        return new AtomicInteger(1);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try {
            String fullName = getRequiredParameter(request, "fullName");
            String email = getRequiredParameter(request, "email");
            String username = getRequiredParameter(request, "username");
            String password = getRequiredParameter(request, "password");

            User user = new User(
                    idCounter.getAndIncrement(),
                    fullName,
                    email,
                    username,
                    password // You may want to hash this
            );

            String userJson = gson.toJson(user);
            Path path = Paths.get(FILE_PATH);

            if (!Files.exists(path.getParent())) {
                Files.createDirectories(path.getParent());
            }

            Files.write(path, (userJson + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);

            response.getWriter().write("<script>"
                    + "alert('Registration successful!');"
                    + "window.location.href = './user/login.jsp';"
                    + "</script>");

        } catch (IllegalArgumentException e) {
            logger.log(Level.WARNING, "Missing parameter", e);
            response.getWriter().write("<script>"
                    + "alert('Error: " + e.getMessage().replace("'", "\\'") + "');"
                    + "window.history.back();"
                    + "</script>");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during registration", e);
            response.getWriter().write("<script>"
                    + "alert('Error: Failed to register');"
                    + "window.history.back();"
                    + "</script>");
        }
    }

    private String getRequiredParameter(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing required parameter: " + paramName);
        }
        return value.trim();
    }
}

