package properties;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/read_products")
public class ProductReadServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ProductReadServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\product_data.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<JsonElement> products = new ArrayList<>();
        Path filePath = Paths.get(FILE_PATH);

        logger.log(Level.INFO, "Reading product data from: " + FILE_PATH);

        try {
            if (Files.exists(filePath)) {
                try (BufferedReader reader = Files.newBufferedReader(filePath)) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        if (!line.isEmpty()) {
                            try {
                                JsonElement json = JsonParser.parseString(line);
                                products.add(json);
                            } catch (JsonSyntaxException e) {
                                logger.log(Level.WARNING, "Invalid JSON skipped: " + line);
                            }
                        }
                    }
                }
            } else {
                logger.log(Level.WARNING, "Product data file not found");
            }

            request.setAttribute("products", products);
            request.getRequestDispatcher("property/products.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error reading products", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading products");
        }
    }
}

