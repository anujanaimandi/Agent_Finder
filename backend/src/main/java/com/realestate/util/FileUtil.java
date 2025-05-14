package com.realestate.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.List;

public class FileUtil {
    private static final String FILE_PATH = "inquiries.txt";

    public static List<String> readLines() throws IOException {
        File file = new File(FILE_PATH);
        if (!file.exists()) file.createNewFile();
        return Files.readAllLines(Paths.get(FILE_PATH));
    }

    public static void writeLines(List<String> lines) throws IOException {
        Files.write(Paths.get(FILE_PATH), lines, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.CREATE);
    }

    public static void appendLine(String line) throws IOException {
        Files.write(Paths.get(FILE_PATH), List.of(line), StandardOpenOption.APPEND, StandardOpenOption.CREATE);
    }
}

