package properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;

import java.io.*;
import java.nio.file.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/upload_product")
public class ProductUploadServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ProductUploadServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\product_data.txt";
    private static final Gson gson = new Gson();
    private static final AtomicInteger idCounter = initializeIdCounter();

    private static AtomicInteger initializeIdCounter() {
        try {
            Path path = Paths.get(FILE_PATH);
            if (Files.exists(path)) {
                int maxId = Files.lines(path)
                        .map(line -> {
                            try {
                                return gson.fromJson(line, Product.class);
                            } catch (Exception e) {
                                logger.log(Level.WARNING, "Failed to parse product line: " + line, e);
                                return null;
                            }
                        })
                        .filter(p -> p != null)
                        .mapToInt(Product::getId)
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
            String name = getRequiredParameter(request, "name");
            String category = getRequiredParameter(request, "category");
            String description = getRequiredParameter(request, "description");
            double price = Double.parseDouble(getRequiredParameter(request, "price"));
            String imageUrl = getRequiredParameter(request, "imageUrl");

            Product product = new Product(
                    idCounter.getAndIncrement(),
                    name,
                    description,
                    imageUrl,
                    price,
                    category
            );

            String productJson = gson.toJson(product);
            Path path = Paths.get(FILE_PATH);

            if (!Files.exists(path.getParent())) {
                Files.createDirectories(path.getParent());
            }

            Files.write(path, (productJson + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);

            response.getWriter().write("<script>"
                    + "alert('Product uploaded successfully! ID: " + product.getId() + "');"
                    + "window.location.href = './products_crud';"
                    + "</script>");

        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid number format", e);
            response.getWriter().write("<script>"
                    + "alert('Error: Invalid number format');"
                    + "window.history.back();"
                    + "</script>");
        } catch (IllegalArgumentException e) {
            logger.log(Level.WARNING, "Missing required parameter", e);
            response.getWriter().write("<script>"
                    + "alert('Error: " + e.getMessage().replace("'", "\\'") + "');"
                    + "window.history.back();"
                    + "</script>");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error uploading product", e);
            response.getWriter().write("<script>"
                    + "alert('Error: Failed to upload product');"
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


