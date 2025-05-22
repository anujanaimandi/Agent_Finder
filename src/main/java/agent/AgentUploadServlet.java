package agent;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;


import java.io.*;
import java.nio.file.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/upload_agent")
public class AgentUploadServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AgentUploadServlet.class.getName());
    private static final String FILE_PATH = "/Users/timali/Desktop/Data/agent_data.txt";
    private static final Gson gson = new Gson();
    private static final AtomicInteger idCounter = initializeIdCounter();

    private static AtomicInteger initializeIdCounter() {
        try {
            Path path = Paths.get(FILE_PATH);
            if (Files.exists(path)) {
                int maxId = Files.lines(path)
                        .map(line -> {
                            try {
                                return gson.fromJson(line, Agent.class);
                            } catch (Exception e) {
                                logger.log(Level.WARNING, "Failed to parse agent line: " + line, e);
                                return null;
                            }
                        })
                        .filter(agent -> agent != null)
                        .mapToInt(Agent::getId)
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
            String email = getRequiredParameter(request, "email");
            String phoneNumber = getRequiredParameter(request, "phoneNumber");
            String agencyName = getRequiredParameter(request, "agencyName");

            Agent agent = new Agent(
                    idCounter.getAndIncrement(),
                    name,
                    email,
                    phoneNumber,
                    agencyName
            );

            String agentJson = gson.toJson(agent);
            Path path = Paths.get(FILE_PATH);

            if (!Files.exists(path.getParent())) {
                Files.createDirectories(path.getParent());
            }

            Files.write(path, (agentJson + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);

            response.getWriter().write("<script>"
                    + "alert('Agent registered successfully! ID: " + agent.getId() + "');"
                    + "window.location.href = './read_agents';"
                    + "</script>");

        } catch (IllegalArgumentException e) {
            logger.log(Level.WARNING, "Missing required parameter", e);
            response.getWriter().write("<script>"
                    + "alert('Error: " + e.getMessage().replace("'", "\\'") + "');"
                    + "window.history.back();"
                    + "</script>");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error uploading agent", e);
            response.getWriter().write("<script>"
                    + "alert('Error: Failed to register agent');"
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

