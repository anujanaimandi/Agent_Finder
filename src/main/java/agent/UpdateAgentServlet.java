package agent;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;
import java.io.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;


@WebServlet("/update_agent")
public class UpdateAgentServlet extends HttpServlet {
    private static final String FILE_PATH = "/Users/timali/Desktop/Data/agent_data.txt";
    private static final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            logParameters(request);

            if (!validateParameters(request)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
                return;
            }

            JsonObject updatedAgent = parseAgentFromRequest(request);
            if (updatedAgent == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid agent data");
                return;
            }

            if (!updateAgentInFile(updatedAgent)) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update agent");
                return;
            }

            response.sendRedirect("./agents_crud");

        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error updating agent: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void logParameters(HttpServletRequest request) {
        System.out.println("Received parameters:");
        request.getParameterMap().forEach((k, v) -> System.out.println(k + "=" + Arrays.toString(v)));
    }

    private boolean validateParameters(HttpServletRequest request) {
        String[] required = {"id", "name", "email", "phoneNumber", "agencyName"};
        for (String param : required) {
            if (request.getParameter(param) == null || request.getParameter(param).isEmpty()) {
                System.err.println("Missing parameter: " + param);
                return false;
            }
        }
        return true;
    }

    private JsonObject parseAgentFromRequest(HttpServletRequest request) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            JsonObject agent = new JsonObject();
            agent.addProperty("id", id);
            agent.addProperty("name", request.getParameter("name").trim());
            agent.addProperty("email", request.getParameter("email").trim());
            agent.addProperty("phoneNumber", request.getParameter("phoneNumber").trim());
            agent.addProperty("agencyName", request.getParameter("agencyName").trim());
            return agent;

        } catch (NumberFormatException e) {
            System.err.println("Invalid ID format: " + e.getMessage());
            return null;
        }
    }

    private boolean updateAgentInFile(JsonObject updatedAgent) {
        Path originalPath = Paths.get(FILE_PATH);
        Path tempPath = Paths.get(FILE_PATH + ".tmp");

        List<String> updatedLines = new ArrayList<>();
        int targetId = updatedAgent.get("id").getAsInt();
        boolean updated = false;

        try (BufferedReader reader = Files.newBufferedReader(originalPath, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                try {
                    JsonObject existing = gson.fromJson(line, JsonObject.class);
                    int id = existing.get("id").getAsInt();

                    if (id == targetId) {
                        updatedLines.add(gson.toJson(updatedAgent));
                        updated = true;
                    } else {
                        updatedLines.add(line);
                    }
                } catch (JsonSyntaxException e) {
                    updatedLines.add(line); // keep bad lines unchanged
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading agent file: " + e.getMessage());
            return false;
        }

        if (!updated) {
            updatedLines.add(gson.toJson(updatedAgent)); // add new if not found
        }

        try (BufferedWriter writer = Files.newBufferedWriter(tempPath,
                StandardCharsets.UTF_8,
                StandardOpenOption.CREATE,
                StandardOpenOption.TRUNCATE_EXISTING)) {
            for (String line : updatedLines) {
                writer.write(line);
                writer.newLine();
            }
            Files.move(tempPath, originalPath, StandardCopyOption.REPLACE_EXISTING);
            return true;

        } catch (IOException e) {
            System.err.println("Error writing updated agent data: " + e.getMessage());
            cleanupTempFile(tempPath);
            return false;
        }
    }

    private void cleanupTempFile(Path tempPath) {
        try {
            Files.deleteIfExists(tempPath);
        } catch (IOException e) {
            System.err.println("Error deleting temp file: " + e.getMessage());
        }
    }

    private void sendError(HttpServletResponse response, int status, String message)
            throws IOException {
        response.setStatus(status);
        response.getWriter().println(message);
        System.err.println(message);
    }
}
