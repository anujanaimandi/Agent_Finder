package properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/edit_product")
public class EditProductServlet extends HttpServlet {
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\product_data.txt"; // Updated path for product data

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String productIdParam = request.getParameter("id");
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is required");
                return;
            }

            int productId = Integer.parseInt(productIdParam);
            List<Product> products = readProductsFromFile();

            Product productToEdit = products.stream()
                    .filter(p -> p.getId() == productId)
                    .findFirst()
                    .orElse(null);

            if (productToEdit == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            // Define categories for the product
            List<String> allCategories = Arrays.asList(
                    "Electronics", "Clothing", "Books", "Home & Kitchen", "Beauty"
            );

            request.setAttribute("allCategories", allCategories);
            request.setAttribute("product", productToEdit);
            request.getRequestDispatcher("/property/update_product_form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Product ID format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
            e.printStackTrace();
        }
    }

    private List<Product> readProductsFromFile() throws IOException {
        List<Product> products = new ArrayList<>();
        Gson gson = new Gson();
        Path filePath = Paths.get(FILE_PATH);

        if (!Files.exists(filePath)) {
            return products;
        }

        try (BufferedReader reader = Files.newBufferedReader(filePath)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                try {
                    Product product = gson.fromJson(line, Product.class);
                    if (product != null) {
                        products.add(product);
                    }
                } catch (JsonSyntaxException e) {
                    System.err.println("Skipping invalid JSON: " + line);
                }
            }
        }
        return products;
    }
}
