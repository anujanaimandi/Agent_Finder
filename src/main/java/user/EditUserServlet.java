package user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/edit_user")
public class EditUserServlet extends HttpServlet {
    private static final String FILE_PATH = "C:\\Users\\HP\\Documents\\Data\\user_data.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
            return;
        }

        int userId = Integer.parseInt(userIdParam);
        List<JsonObject> users = readUsersFromFile();

        JsonObject userToEdit = users.stream()
                .filter(u -> u.get("id").getAsInt() == userId)
                .findFirst()
                .orElse(null);

        if (userToEdit == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }

        request.setAttribute("user", userToEdit);
        request.getRequestDispatcher("user/update_user_form.jsp").forward(request, response);
    }

    private List<JsonObject> readUsersFromFile() throws IOException {
        List<JsonObject> users = new ArrayList<>();
        Gson gson = new Gson();
        Path filePath = Paths.get(FILE_PATH);

        if (!Files.exists(filePath)) return users;

        try (BufferedReader reader = Files.newBufferedReader(filePath)) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject user = gson.fromJson(line, JsonObject.class);
                    users.add(user);
                } catch (JsonSyntaxException ignored) {}
            }
        }
        return users;
    }
}


