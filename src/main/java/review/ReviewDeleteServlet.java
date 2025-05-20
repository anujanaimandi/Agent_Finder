package review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.logging.Logger;

@WebServlet("/delete_review")
public class ReviewDeleteServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ReviewDeleteServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\review_data.txt";
    private static final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Optional: simulate DELETE via POST
        String method = request.getParameter("_method");
        if ("DELETE".equalsIgnoreCase(method)) {
            doDelete(request, response);
        } else {
            doDelete(request, response); // default behavior
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("<script>alert('Missing review ID'); window.location.href='./reviews_crud';</script>");
            return;
        }

        int reviewId;
        try {
            reviewId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("<script>alert('Invalid review ID'); window.location.href='./reviews_crud';</script>");
            return;
        }

        Path path = Paths.get(FILE_PATH);
        if (!Files.exists(path)) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("<script>alert('Review data file not found'); window.location.href='./reviews_crud';</script>");
            return;
        }

        List<String> updatedLines = new ArrayList<>();
        boolean found = false;

        try (BufferedReader reader = Files.newBufferedReader(path)) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject reviewJson = gson.fromJson(line, JsonObject.class);
                    int id = reviewJson.get("id").getAsInt();
                    if (id != reviewId) {
                        updatedLines.add(line);
                    } else {
                        found = true;
                    }
                } catch (JsonSyntaxException | NullPointerException e) {
                    updatedLines.add(line); // Keep malformed lines
                }
            }
        }

        if (!found) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("<script>alert('Review not found'); window.location.href='./reviews_crud';</script>");
            return;
        }

        Files.write(path, updatedLines, StandardOpenOption.TRUNCATE_EXISTING);

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("<script>alert('Review deleted successfully'); window.location.href='./reviews_crud';</script>");
    }
}