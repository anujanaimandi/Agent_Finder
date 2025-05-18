package user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

@WebServlet("/update_user")
public class UpdateUserServlet extends HttpServlet {
    private static final String FILE_PATH = "C:\\Users\\HP\\Documents\\Data\\user_data.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullName = Optional.ofNullable(request.getParameter("fullName")).orElse("").trim();
            String email = Optional.ofNullable(request.getParameter("email")).orElse("").trim();
            String username = Optional.ofNullable(request.getParameter("username")).orElse("").trim();

            if (fullName.isEmpty() || email.isEmpty() || username.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing user details");
                return;
            }

            List<JsonObject> users = readUsersFromFile();
            JsonObject existingUser = users.stream()
                    .filter(u -> u.get("id").getAsInt() == id)
                    .findFirst()
                    .orElse(null);

            if (existingUser == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }

            String originalPassword = existingUser.get("password").getAsString();

            // Create updated user JSON (preserve password)
            JsonObject updatedUser = new JsonObject();
            updatedUser.addProperty("id", id);
            updatedUser.addProperty("fullName", fullName);
            updatedUser.addProperty("email", email);
            updatedUser.addProperty("username", username);
            updatedUser.addProperty("password", originalPassword); // preserve original

            updateUserInFile(updatedUser, users);

            response.sendRedirect("./users_crud");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
        }
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

    private void updateUserInFile(JsonObject updatedUser, List<JsonObject> users) throws IOException {
        Gson gson = new Gson();
        Path path = Paths.get(FILE_PATH);
        Path tempPath = Paths.get(FILE_PATH + ".tmp");

        try (BufferedWriter writer = Files.newBufferedWriter(tempPath,
                StandardCharsets.UTF_8,
                StandardOpenOption.CREATE,
                StandardOpenOption.TRUNCATE_EXISTING)) {
            for (JsonObject user : users) {
                if (user.get("id").getAsInt() == updatedUser.get("id").getAsInt()) {
                    writer.write(gson.toJson(updatedUser));
                } else {
                    writer.write(gson.toJson(user));
                }
                writer.newLine();
            }
        }

        Files.move(tempPath, path, StandardCopyOption.REPLACE_EXISTING);
    }
}

