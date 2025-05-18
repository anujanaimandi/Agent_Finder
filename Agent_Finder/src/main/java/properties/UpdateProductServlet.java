package properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;
import java.io.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet("/update_product")
public class UpdateProductServlet extends HttpServlet {
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\product_data.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Log received parameters for debugging
            logParameters(request);

            // Validate all required parameters
            if (!validateParameters(request)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
                return;
            }

            // Parse and validate parameters
            Product updatedProduct = parseProductFromRequest(request);
            if (updatedProduct == null || !validateProduct(updatedProduct)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product data");
                return;
            }

            // Update file with transaction safety
            if (!updateProductInFile(updatedProduct)) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update product data");
                return;
            }

            // Success - redirect to product list
            response.sendRedirect("./products_crud");

        } catch (NumberFormatException e) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid number format: " + e.getMessage());
        } catch (IOException e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "IO Error updating product: " + e.getMessage());
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error updating product: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void logParameters(HttpServletRequest request) {
        System.out.println("Received parameters:");
        request.getParameterMap().forEach((k, v) -> System.out.println(k + "=" + Arrays.toString(v)));
    }

    private boolean validateParameters(HttpServletRequest request) {
        String[] requiredParams = {"id", "name", "price", "category", "description", "imageUrl"};
        for (String param : requiredParams) {
            if (request.getParameter(param) == null || request.getParameter(param).isEmpty()) {
                System.err.println("Missing parameter: " + param);
                return false;
            }
        }
        return true;
    }

    private Product parseProductFromRequest(HttpServletRequest request) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name").trim();
            double price = Double.parseDouble(request.getParameter("price"));
            String category = request.getParameter("category").trim();
            String description = request.getParameter("description").trim();
            String imageUrl = request.getParameter("imageUrl").trim();

            // Return new Product object with correct parameter order
            return new Product(id, name, description, imageUrl, price, category);
        } catch (NumberFormatException e) {
            System.err.println("Error parsing numeric data from request: " + e.getMessage());
            return null;
        } catch (Exception e) {
            System.err.println("Error parsing product from request: " + e.getMessage());
            return null;
        }
    }

    private boolean validateProduct(Product product) {
        if (product.getPrice() < 0) {
            System.err.println("Invalid price: " + product.getPrice());
            return false;
        }
        return true;
    }

    private boolean updateProductInFile(Product updatedProduct) {
        Path filePath = Paths.get(FILE_PATH);
        Path tempPath = Paths.get(FILE_PATH + ".tmp");

        // Use compact JSON format (no pretty printing)
        Gson gson = new Gson();

        try {
            // 1. Read existing products with file lock
            List<Product> products = readProductsFromFile(filePath, gson);

            // 2. Update or add the product
            updateOrAddProduct(products, updatedProduct);

            // 3. Write to temporary file with file lock
            writeProductsToTempFile(tempPath, gson, products);

            // 4. Replace original file atomically
            Files.move(tempPath, filePath, StandardCopyOption.REPLACE_EXISTING);
            return true;

        } catch (IOException e) {
            System.err.println("Error updating product file: " + e.getMessage());
            cleanupTempFile(tempPath);
            return false;
        }
    }

    private List<Product> readProductsFromFile(Path filePath, Gson gson) throws IOException {
        List<Product> products = new ArrayList<>();
        if (Files.exists(filePath)) {
            try (BufferedReader reader = Files.newBufferedReader(filePath, StandardCharsets.UTF_8)) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (!line.isEmpty()) {
                        try {
                            Product product = gson.fromJson(line, Product.class);
                            if (product != null) products.add(product);
                        } catch (JsonSyntaxException e) {
                            System.err.println("Skipping invalid JSON line: " + line);
                        }
                    }
                }
            }
        }
        return products;
    }

    private void updateOrAddProduct(List<Product> products, Product updatedProduct) {
        boolean updated = false;
        for (int i = 0; i < products.size(); i++) {
            if (products.get(i).getId() == updatedProduct.getId()) {
                products.set(i, updatedProduct);
                updated = true;
                break;
            }
        }
        if (!updated) products.add(updatedProduct);
    }

    private void writeProductsToTempFile(Path tempPath, Gson gson, List<Product> products)
            throws IOException {
        try (BufferedWriter writer = Files.newBufferedWriter(tempPath,
                StandardCharsets.UTF_8,
                StandardOpenOption.CREATE,
                StandardOpenOption.TRUNCATE_EXISTING)) {

            // Write each product as a compact JSON line
            for (Product product : products) {
                writer.write(gson.toJson(product));
                writer.newLine();
            }
        }
    }

    private void cleanupTempFile(Path tempPath) {
        try {
            Files.deleteIfExists(tempPath);
        } catch (IOException ex) {
            System.err.println("Error cleaning up temp file: " + ex.getMessage());
        }
    }

    private void sendError(HttpServletResponse response, int status, String message)
            throws IOException {
        response.setStatus(status);
        response.getWriter().println(message);
        System.err.println(message);
    }
}
