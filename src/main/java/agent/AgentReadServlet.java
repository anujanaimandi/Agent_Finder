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

@WebServlet("/read_agents")
public class AgentReadServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AgentReadServlet.class.getName());
    private static final String FILE_PATH = "/Users/timali/Desktop/Data/agent_data.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<JsonElement> agents = new ArrayList<>();
        Path filePath = Paths.get(FILE_PATH);

        logger.log(Level.INFO, "Reading agent data from: " + FILE_PATH);

        try {
            if (Files.exists(filePath)) {
                try (BufferedReader reader = Files.newBufferedReader(filePath)) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        if (!line.isEmpty()) {
                            try {
                                JsonElement json = JsonParser.parseString(line);
                                agents.add(json);
                            } catch (JsonSyntaxException e) {
                                logger.log(Level.WARNING, "Invalid JSON skipped: " + line);
                            }
                        }
                    }
                }
            } else {
                logger.log(Level.WARNING, "Agent data file not found");
            }

            request.setAttribute("agents", agents);
            request.getRequestDispatcher("agent/agents.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error reading agents", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading agents");
        }
    }
}

