package agent;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/edit_agent")
public class EditAgentServlet extends HttpServlet {
    private static final String FILE_PATH = "/Users/timali/Desktop/Data/agent_data.txt";
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Agent ID is required.");
            return;
        }

        try {
            int agentId = Integer.parseInt(idParam);
            List<Agent> agents = readAgentsFromFile();

            Agent agentToEdit = agents.stream()
                    .filter(a -> a.getId() == agentId)
                    .findFirst()
                    .orElse(null);

            if (agentToEdit == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Agent not found.");
                return;
            }

            request.setAttribute("agent", agentToEdit);
            request.getRequestDispatcher("/agent/update_agent_form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Agent ID format.");
        }
    }

    private List<Agent> readAgentsFromFile() throws IOException {
        List<Agent> agents = new ArrayList<>();
        Path filePath = Paths.get(FILE_PATH);

        if (!Files.exists(filePath)) return agents;

        try (BufferedReader reader = Files.newBufferedReader(filePath)) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    try {
                        Agent agent = gson.fromJson(line, Agent.class);
                        if (agent != null) {
                            agents.add(agent);
                        }
                    } catch (JsonSyntaxException e) {
                        System.err.println("Skipping invalid JSON: " + line);
                    }
                }
            }
        }

        return agents;
    }
}

