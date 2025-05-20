package review;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;

import java.io.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet("/update_review")
public class UpdateReviewServlet extends HttpServlet {
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\review_data.txt";
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

            JsonObject updatedReview = parseReviewFromRequest(request);
            if (updatedReview == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid review data");
                return;
            }

            if (!updateReviewInFile(updatedReview)) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update review");
                return;
            }

            response.sendRedirect("./reviews_crud");

        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error updating review: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void logParameters(HttpServletRequest request) {
        System.out.println("Received parameters:");
        request.getParameterMap().forEach((k, v) -> System.out.println(k + "=" + Arrays.toString(v)));
    }

    private boolean validateParameters(HttpServletRequest request) {
        String[] required = {"id", "reviewerName", "comment", "rating"};
        for (String param : required) {
            if (request.getParameter(param) == null || request.getParameter(param).trim().isEmpty()) {
                System.err.println("Missing parameter: " + param);
                return false;
            }
        }
        return true;
    }

    private JsonObject parseReviewFromRequest(HttpServletRequest request) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int rating = Integer.parseInt(request.getParameter("rating"));

            JsonObject review = new JsonObject();
            review.addProperty("id", id);
            review.addProperty("reviewerName", request.getParameter("reviewerName").trim());
            review.addProperty("comment", request.getParameter("comment").trim());
            review.addProperty("rating", rating);
            return review;

        } catch (NumberFormatException e) {
            System.err.println("Invalid numeric format: " + e.getMessage());
            return null;
        }
    }

    private boolean updateReviewInFile(JsonObject updatedReview) {
        Path originalPath = Paths.get(FILE_PATH);
        Path tempPath = Paths.get(FILE_PATH + ".tmp");

        List<String> updatedLines = new ArrayList<>();
        int targetId = updatedReview.get("id").getAsInt();
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
                        updatedLines.add(gson.toJson(updatedReview));
                        updated = true;
                    } else {
                        updatedLines.add(line);
                    }
                } catch (JsonSyntaxException e) {
                    updatedLines.add(line); // keep bad lines unchanged
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading review file: " + e.getMessage());
            return false;
        }

        if (!updated) {
            updatedLines.add(gson.toJson(updatedReview)); // optionally add if not found
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
            System.err.println("Error writing updated review data: " + e.getMessage());
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
