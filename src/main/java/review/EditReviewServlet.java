package review;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/edit_review")
public class EditReviewServlet extends HttpServlet {
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\review_data.txt";
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Review ID is required.");
            return;
        }

        try {
            int reviewId = Integer.parseInt(idParam);
            List<Review> reviews = readReviewsFromFile();

            Review reviewToEdit = reviews.stream()
                    .filter(r -> r.getId() == reviewId)
                    .findFirst()
                    .orElse(null);

            if (reviewToEdit == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Review not found.");
                return;
            }

            request.setAttribute("review", reviewToEdit);
            request.getRequestDispatcher("/review/update_review_form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Review ID format.");
        }
    }

    private List<Review> readReviewsFromFile() throws IOException {
        List<Review> reviews = new ArrayList<>();
        Path filePath = Paths.get(FILE_PATH);

        if (!Files.exists(filePath)) return reviews;

        try (BufferedReader reader = Files.newBufferedReader(filePath)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    try {
                        Review review = gson.fromJson(line, Review.class);
                        if (review != null) {
                            reviews.add(review);
                        }
                    } catch (JsonSyntaxException e) {
                        System.err.println("Skipping invalid JSON: " + line);
                    }
                }
            }
        }

        return reviews;
    }
}
