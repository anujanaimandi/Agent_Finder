package review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/reviews_crud")
public class ReviewCrudServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ReviewCrudServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\review_data.txt";
    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<JsonObject> reviews = new ArrayList<>();
        Path filePath = Paths.get(FILE_PATH);

        logger.log(Level.INFO, "Attempting to read review data from: " + FILE_PATH);

        if (Files.notExists(filePath)) {
            logger.log(Level.WARNING, "Review data file not found at: " + FILE_PATH);
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("admin/reviews_crud.jsp").forward(request, response);
            return;
        }

        try (BufferedReader reader = Files.newBufferedReader(filePath)) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject json = JsonParser.parseString(line.trim()).getAsJsonObject();
                    reviews.add(json);
                } catch (JsonSyntaxException e) {
                    logger.log(Level.WARNING, "Skipping invalid JSON line: " + line, e);
                }
            }
        }

        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("admin/reviews_crud.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
            return;
        }

        switch (action) {
            case "delete":
                handleDelete(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String reviewerName = request.getParameter("reviewerName");
        String comment = request.getParameter("comment");

        if (reviewerName == null || comment == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing review identity parameters");
            return;
        }

        Path path = Paths.get(FILE_PATH);
        List<String> remainingLines = new ArrayList<>();

        try {
            if (Files.exists(path)) {
                List<String> lines = Files.readAllLines(path);
                for (String line : lines) {
                    try {
                        JsonObject review = JsonParser.parseString(line.trim()).getAsJsonObject();
                        if (!(review.get("reviewerName").getAsString().equals(reviewerName)
                                && review.get("comment").getAsString().equals(comment))) {
                            remainingLines.add(gson.toJson(review));
                        }
                    } catch (Exception e) {
                        logger.log(Level.WARNING, "Invalid JSON line skipped during deletion: " + line);
                    }
                }

                Files.write(path, remainingLines, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.CREATE);
            }

            response.sendRedirect(request.getContextPath() + "/reviews_crud");

        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error deleting review", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete review");
        }
    }
}
