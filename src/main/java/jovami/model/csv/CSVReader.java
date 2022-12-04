package jovami.model.csv;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import jovami.model.exceptions.InvalidCSVHeaderException;

/**
 * CSVReader
 */
public class CSVReader {

    private static CSVHeader HEADER;

    private static int EXPECTED_COLUMNS;

    private static String DEFAULT_DELIMITER;

    private static final char BOM = '\ufeff';

    private static void setup(CSVHeader header) {
        HEADER = header;
        EXPECTED_COLUMNS = header.getColumnCount();
        DEFAULT_DELIMITER = header.getDelimiter();
    }

    /**
     * Read from resources list.
     *
     * @param bundle the bundle
     * @param header the header
     * @return the list
     * @throws IOException the io exception
     */
    public static List<String[]> readFromResources(String bundle, CSVHeader header)
    throws IOException
    {
        Objects.requireNonNull(bundle);

        InputStream is = CSVHeader.class.getResourceAsStream(bundle);
        if (is == null)
            throw new IOException("Error: could not find the resource file: " + bundle);

        return readCSV(is, header);
    }

    /**
     * Read csv list.
     *
     * @param file   the file
     * @param header the header
     * @return the list
     * @throws FileNotFoundException the file not found exception
     */
    public static List<String[]> readCSV(File file, CSVHeader header)
    throws FileNotFoundException
    {
        Objects.requireNonNull(file);
        return readCSV(new FileInputStream(file), header);
    }

    private static List<String[]> readCSV(InputStream stream, CSVHeader header) {
        setup(header);

        List<String[]> info = new ArrayList<>();
        String delimiter = DEFAULT_DELIMITER;

        String line;
        String[] tmp;

        boolean quotationMarks = false;

        try (var br = new BufferedReader(new InputStreamReader(stream))) {
            maybeSkipBOM(br);

            if (HEADER != CSVHeader.NO_HEADER) {
                line = br.readLine();

                if (!isHeader(line))
                    throw new InvalidCSVHeaderException();
            }

            if (HEADER != CSVHeader.BUNDLES_SMALL)
                quotationMarks = checkQuotationMark(br);

            if (quotationMarks)
                delimiter = '"' + delimiter + '"';

            while ((line = br.readLine()) != null) {
                tmp = line.split(delimiter);

                if (HEADER == CSVHeader.NO_HEADER || tmp.length == EXPECTED_COLUMNS) {
                    // remove " at begining and " at end
                    if(quotationMarks) {
                        tmp[0] = tmp[0].replaceAll("\"", "");
                        tmp[tmp.length - 1] = tmp[tmp.length - 1].replaceAll("\"", "");
                    }
                    info.add(tmp);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file. Aborting...");
        }

        return info;
    }

    private static boolean isHeader(String line) {
        return line.trim().equalsIgnoreCase(HEADER.toString());
    }

    /**
     * Some CSV files start with a BOM (Byte-Order-Mark) character,
     * which messes up with parsing the file
     * This method attempts to circumvent this issue by scanning the
     * first character of the stream being read and resetting the file
     * pointer to the beggining in case it isn't a BOM
     * @param reader READER
     * @throws IOException excep
     */
    private static void maybeSkipBOM(Reader reader) throws IOException {
        final char[] buf = new char[1];

        reader.mark(buf.length);
        reader.read(buf);

        if (buf[0] != BOM)
            reader.reset();
    }

    /**
     * Check if the CSV File contains quotation marks.
     * Needed because the lines need to be split according to the
     * correct delimiter.
     * @param reader    the {@code BufferedReader} used
     * @throws IOException if an error occurs while checking for quotes
     */
    private static boolean checkQuotationMark(BufferedReader reader) throws IOException {
        final int bigNum = 500;
        final char[] buf = new char[bigNum];

        reader.mark(buf.length);
        reader.read(buf);
        reader.reset();

        return (new String(buf)).matches("^\".*\"$");
    }
}
