package agent;


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

@WebServlet("/delete_agent")
public class AgentDeleteServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AgentDeleteServlet.class.getName());
    private static final String FILE_PATH = "/Users/timali/Desktop/Data/agent_data.txt";
    private static final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Optional: Simulate DELETE via POST (if needed)
        String method = request.getParameter("_method");
        if ("DELETE".equalsIgnoreCase(method)) {
            doDelete(request, response);
        } else {
            doDelete(request, response); // default for form submission
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("<script>alert('Missing agent ID'); window.location.href='./agents_crud.jsp';</script>");
            return;
        }

        int targetId;
        try {
            targetId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("<script>alert('Invalid agent ID format'); window.location.href='./agents_crud.jsp';</script>");
            return;
        }

        Path path = Paths.get(FILE_PATH);
        if (!Files.exists(path)) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("<script>alert('Agent data file not found'); window.location.href='./agents_crud.jsp';</script>");
            return;
        }

        List<String> updatedLines = new ArrayList<>();
        boolean found = false;

        try (BufferedReader reader = Files.newBufferedReader(path)) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    JsonObject agentJson = gson.fromJson(line, JsonObject.class);
                    int agentId = agentJson.get("id").getAsInt();
                    if (agentId != targetId) {
                        updatedLines.add(line);
                    } else {

                        found = true;
                    }
                } catch (JsonSyntaxException | NullPointerException e) {
                    updatedLines.add(line); // preserve unparseable lines
                }
            }
        }

        if (!found) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("<script>alert('Agent with the specified ID not found'); window.location.href='./agents_crud';</script>");
            return;
        }

        Files.write(path, updatedLines, StandardOpenOption.TRUNCATE_EXISTING);

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("<script>alert('Agent deleted successfully'); window.location.href='./agents_crud';</script>");
    }
}
