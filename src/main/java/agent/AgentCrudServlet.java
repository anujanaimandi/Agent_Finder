package agent;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/agents_crud")
public class AgentCrudServlet  extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AgentCrudServlet.class.getName());

    private static final String FILE_PATH = "/Users/timali/Desktop/Data/agent_data.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<JsonElement> agents = new ArrayList<>();
        Gson gson = new Gson();

        logger.log(Level.INFO, "Attempting to read agent data from: " + FILE_PATH);

        try {
            Path filePath = Paths.get(FILE_PATH);

            if (Files.notExists(filePath)) {
                logger.log(Level.WARNING, "Agent data file not found at: " + FILE_PATH);
                request.setAttribute("agents", new ArrayList<JsonElement>());
                request.getRequestDispatcher("admin/agents_crud.jsp").forward(request, response);
                return;
            }

            try (BufferedReader reader = Files.newBufferedReader(filePath)) {
                String line;
                while ((line = reader.readLine()) != null) {
                    try {
                        JsonElement json = JsonParser.parseString(line.trim());
                        agents.add(json);
                    } catch (JsonSyntaxException e) {
                        logger.log(Level.WARNING, "Skipping invalid JSON line: " + line, e);
                    }
                }
            }

            request.setAttribute("agents", agents);
            request.getRequestDispatcher("admin/agents_crud.jsp").forward(request, response);

        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error reading agent data", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to read agent data");
        }
    }


}
