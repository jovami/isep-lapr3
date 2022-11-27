package jovami.util.io;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Objects;

/**
 * InputReader
 */
public class InputReader {

    public static final String YES_REGEX = "^[yY]";

    public static String readLine(String prompt) {
        Objects.requireNonNull(prompt);

        System.out.printf("%s ", prompt);

        // NOTE: try_resources cannot be used because it would close System.in
        try {
            var br = new BufferedReader(new InputStreamReader(System.in));
            var line = br.readLine();

            System.out.println();

            return line;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean confirm(String prompt) {
        return readLine(prompt + " [y/N]").matches(YES_REGEX);
    }

    public static boolean confirm(String prompt, boolean defaultYes) {
        var line = readLine(prompt + (defaultYes ? " [Y/n]" : "[ y/N]"));

        if (defaultYes && line.trim().isEmpty())
            return true;

        return line.matches(YES_REGEX);
    }

    public static File getFile(String prompt) {
        String path = InputReader.readLine(prompt);

        File f = new File(path);
        if (f == null || !f.isFile() || !f.canRead())
            throw new RuntimeException("File does not exist!! " + (f != null ? f.getPath() : ""));

        return f;
    }
}
