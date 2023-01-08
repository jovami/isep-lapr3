package jovami.util.io;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Objects;

/**
 * InputReader
 */
public class InputReader {

    /**
     * The constant YES_REGEX.
     */
    public static final String YES_REGEX = "^[yY]";

    /**
     * Read line string.
     *
     * @param prompt the prompt
     * @return the string
     */
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

    /**
     * Read integer int.
     *
     * @param prompt the prompt
     * @return the int
     */
    public static int readInteger(String prompt) {
        do {
            try {
                return Integer.parseInt(readLine(prompt));
            } catch (NumberFormatException e){
                System.out.println("\n\tCan't load characters that don't correspond to integers\n");
            }
        } while(true);
    }

    /**
     * Confirm boolean.
     *
     * @param prompt the prompt
     * @return the boolean
     */
    public static boolean confirm(String prompt) {
        return readLine(prompt + " [y/N]").matches(YES_REGEX);
    }

    /**
     * Confirm boolean.
     *
     * @param prompt     the prompt
     * @param defaultYes the default yes
     * @return the boolean
     */
    public static boolean confirm(String prompt, boolean defaultYes) {
        var line = readLine(prompt + (defaultYes ? " [Y/n]" : "[ y/N]"));

        if (defaultYes && line.trim().isEmpty())
            return true;

        return line.matches(YES_REGEX);
    }

    /**
     * Gets file.
     *
     * @param prompt the prompt
     * @return the file
     */
    public static File getFile(String prompt) {
        String path = InputReader.readLine(prompt);

        File f = new File(Objects.requireNonNull(path));
        if (!f.isFile() || !f.canRead())
            throw new RuntimeException("File does not exist!! " + f.getPath());

        return f;
    }

    public static <E> int showAndSelectIndex(List<E> list, String header) {
        showList(list, header);
        return selectIndex(list);
    }

    public static <E> void showList(List<E> list, String header) {
        System.out.printf("%s\n\n", header);

        int index = 0;
        for (E e : list)
            System.out.printf("%d) %s\n", ++index, e);
        System.out.println();
    }

    private static <E> int selectIndex(List<E> list) {
        int value;
        final int len = list.size();

        do {
            value = readInteger("Type your option:");
        } while (value < 1 || value > len);

        return value - 1;
    }
}
