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

@WebServlet("/products_crud")
public class ProductsCrudServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ProductsCrudServlet.class.getName());

    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\product_data.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<JsonElement> products = new ArrayList<>();
        Gson gson = new Gson();

        logger.log(Level.INFO, "Attempting to read product data from: " + FILE_PATH);

        try {
            Path filePath = Paths.get(FILE_PATH);

            if (Files.notExists(filePath)) {
                logger.log(Level.WARNING, "Product data file not found at: " + FILE_PATH);
                request.setAttribute("products", new ArrayList<JsonElement>());
                request.getRequestDispatcher("/products_crud.jsp").forward(request, response);
                return;
            }

            try (BufferedReader reader = Files.newBufferedReader(filePath)) {
                String line;
                while ((line = reader.readLine()) != null) {
                    try {
                        JsonElement json = JsonParser.parseString(line.trim());
                        products.add(json);
                    } catch (JsonSyntaxException e) {
                        logger.log(Level.WARNING, "Skipping invalid JSON line: " + line, e);
                    }
                }
            }

            request.setAttribute("products", products);
            request.getRequestDispatcher("admin/products_crud.jsp").forward(request, response);

        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error reading product data", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to read product data");
        }
    }
}
