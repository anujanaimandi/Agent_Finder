package review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.google.gson.Gson;

import java.io.*;
import java.nio.file.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/upload_review")
public class ReviewUploadServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ReviewUploadServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\review_data.txt";
    private static final Gson gson = new Gson();
    private static final AtomicInteger idCounter = initializeIdCounter();

    private static AtomicInteger initializeIdCounter() {
        try {
            Path path = Paths.get(FILE_PATH);
            if (Files.exists(path)) {
                int maxId = Files.lines(path)
                        .map(line -> {
                            try {
                                return gson.fromJson(line, Review.class);
                            } catch (Exception e) {
                                logger.log(Level.WARNING, "Failed to parse review line: " + line, e);
                                return null;
                            }
                        })
                        .filter(review -> review != null)
                        .mapToInt(Review::getId)
                        .max()
                        .orElse(0);
                return new AtomicInteger(maxId + 1);
            }
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error initializing ID counter", e);
        }
        return new AtomicInteger(1);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try {
            String reviewerName = getRequiredParameter(request, "reviewerName");
            String comment = getRequiredParameter(request, "comment");
            int rating = Integer.parseInt(getRequiredParameter(request, "rating"));

            if (rating < 1 || rating > 5) {
                throw new IllegalArgumentException("Rating must be between 1 and 5.");
            }

            Review review = new Review(
                    idCounter.getAndIncrement(),
                    reviewerName,
                    comment,
                    rating
            );

            String reviewJson = gson.toJson(review);
            Path path = Paths.get(FILE_PATH);

            if (!Files.exists(path.getParent())) {
                Files.createDirectories(path.getParent());
            }

            Files.write(path, (reviewJson + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);

            response.getWriter().write("<script>"
                    + "alert('Review submitted successfully! ID: " + review.getId() + "');"
                    + "window.location.href = './index.jsp';"
                    + "</script>");

        } catch (IllegalArgumentException e) {
            logger.log(Level.WARNING, "Invalid input", e);
            response.getWriter().write("<script>"
                    + "alert('Error: " + e.getMessage().replace("'", "\\'") + "');"
                    + "window.history.back();"
                    + "</script>");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error uploading review", e);
            response.getWriter().write("<script>"
                    + "alert('Error: Failed to submit review');"
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
