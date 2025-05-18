package user;

import com.google.gson.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final String FILE_PATH = "C:\\Users\\HP\\Documents\\Data\\user_data.txt";
    private static final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        JsonObject user = authenticate(username, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.get("username").getAsString());

            if (user.has("role")) {
                session.setAttribute("userType", user.get("role").getAsString());
            }

            // Use relative paths and context path to ensure proper redirection
            if ("admin".equals(username) && "admin0809".equals(password)) {
                response.sendRedirect(request.getContextPath() + "/admin/sidebar.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }

        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }

    private JsonObject authenticate(String username, String password) throws IOException {
        Path path = Paths.get(FILE_PATH);
        if (!Files.exists(path)) return null;

        try (BufferedReader reader = Files.newBufferedReader(path)) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject user = gson.fromJson(line.trim(), JsonObject.class);
                    if (user != null && user.has("username") && user.has("password")) {
                        if (user.get("username").getAsString().equals(username)
                                && user.get("password").getAsString().equals(password)) {
                            return user;
                        }
                    }
                } catch (JsonSyntaxException e) {
                    // Skip malformed JSON lines
                    continue;
                }
            }
        }
        return null;
    }
}
