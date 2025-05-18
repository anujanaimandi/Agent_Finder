package com.realestate.repository;

import com.realestate.model.Inquiry;
import com.realestate.util.FileUtil;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class InquiryRepository {
    public List<Inquiry> findAll() {
        try {
            List<String> lines = FileUtil.readLines();
            return lines.stream().map(this::fromLine).collect(Collectors.toList());
        } catch (IOException e) {
            return new ArrayList<>();
        }
    }

    public void save(Inquiry inquiry) {
        try {
            FileUtil.appendLine(toLine(inquiry));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void overwriteAll(List<Inquiry> inquiries) {
        List<String> lines = inquiries.stream().map(this::toLine).collect(Collectors.toList());
        try {
            FileUtil.writeLines(lines);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String toLine(Inquiry i) {
        return i.getId() + "," + i.getType() + "," + i.getSubject() + "," + i.getClientName() + "," + i.getClientEmail() + "," + i.getMessage().replace(",", "[comma]") +
                "," + i.getStatus() + "," + i.getReply().replace(",", "[comma]");
    }

    private Inquiry fromLine(String line) {
        String[] parts = line.split(",", -1);
        return new Inquiry(
                Integer.parseInt(parts[0]),
                parts[1],
                parts.length > 2 ? parts[2] : "",
                parts.length > 3 ? parts[3].replace("[comma]", ",") : "",
                parts.length > 4 ? parts[4] : "",
                parts.length > 5 ? parts[5].replace("[comma]", ",") : "",
                parts.length > 6 ? parts[6] : "",
                parts.length > 7 ? parts[7].replace("[comma]", ",") : ""
        );
    }
}
