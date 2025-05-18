package properties;

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

@WebServlet("/delete_product")
public class ProductDeleteServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ProductDeleteServlet.class.getName());
    private static final String FILE_PATH = "C:\\Users\\anuja\\OneDrive\\Desktop\\Data\\product_data.txt"; // Updated path for product data
    private static final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if it's a simulated DELETE request
        String method = request.getParameter("_method");
        if ("DELETE".equalsIgnoreCase(method)) {
            doDelete(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            response.getWriter().write("<script>alert('Unsupported POST operation'); window.location.href='product_list.jsp';</script>");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");  // Changed to text/html to send script
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("<script>alert('Missing \'id\' parameter'); window.location.href='product_list.jsp';</script>");
            return;
        }

        int targetId;
        try {
            targetId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("<script>alert('Invalid \'id\' format'); window.location.href='product_list.jsp';</script>");
            return;
        }

        Path path = Paths.get(FILE_PATH);
        if (!Files.exists(path)) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("<script>alert('Product data file not found'); window.location.href='product_list.jsp';</script>");
            return;
        }

        List<String> updatedLines = new ArrayList<>();
        boolean found = false;

        try (BufferedReader reader = Files.newBufferedReader(path)) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject productJson = gson.fromJson(line, JsonObject.class);
                    int productId = productJson.get("id").getAsInt();
                    if (productId != targetId) {
                        updatedLines.add(line);
                    } else {
                        found = true;
                    }
                } catch (JsonSyntaxException | NullPointerException e) {
                    // Preserve unparseable lines to avoid data loss
                    updatedLines.add(line);
                }
            }
        }

        if (!found) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("<script>alert('Product with specified ID not found'); window.location.href='./products_crud';</script>");
            return;
        }

        // Overwrite the file with updated content
        Files.write(path, updatedLines, StandardOpenOption.TRUNCATE_EXISTING);

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("<script>alert('Product deleted successfully'); window.location.href='./products_crud';</script>");
    }
}
