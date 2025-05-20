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

@WebServlet("/read_reviews")
public class ReviewReadServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ReviewReadServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\review_data.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<JsonObject> reviews = new ArrayList<>();
        Path filePath = Paths.get(FILE_PATH);

        logger.log(Level.INFO, "Reading review data from: " + FILE_PATH);

        try {
            if (Files.exists(filePath)) {
                try (BufferedReader reader = Files.newBufferedReader(filePath)) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        if (!line.isEmpty()) {
                            try {
                                JsonObject json = JsonParser.parseString(line).getAsJsonObject();
                                reviews.add(json);
                            } catch (JsonSyntaxException e) {
                                logger.log(Level.WARNING, "Invalid JSON skipped: " + line);
                            }
                        }
                    }
                }
            } else {
                logger.log(Level.WARNING, "Review data file not found");
            }

            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("review/reviews.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error reading reviews", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading reviews");
        }
    }
}
