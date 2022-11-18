package jovami.model.csv;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import jovami.model.exceptions.InvalidCSVHeaderException;

/**
 * CSVReader
 */
public class CSVReader {

    private final CSVHeader header;

    private final int EXPECTED_COLUMNS;

    private final String DEFAULT_DELIMITER;

    private static final char BOM = '\ufeff';

    public CSVReader(CSVHeader header) {
        this.header = header;
        this.EXPECTED_COLUMNS = header.getColumnCount();
        this.DEFAULT_DELIMITER = header.getDelimiter();
    }

    public List<String[]> readCSV(File dir) {
        List<String[]> info = new ArrayList<>();
        String delimiter = DEFAULT_DELIMITER;

        String line;
        String[] tmp;

        try (var br = new BufferedReader(new FileReader(dir))) {
            maybeSkipBOM(br);
            line = br.readLine();

            if (!isHeader(line)) {
                throw new InvalidCSVHeaderException();
            }

            boolean quotationMarks = checkQuotationMark(br);

            if (quotationMarks)
                delimiter = '"' + delimiter + '"';

            while ((line = br.readLine()) != null) {
                tmp = line.split(delimiter);

                if (tmp.length == EXPECTED_COLUMNS) {
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

    private boolean isHeader(String line) {
        return line.trim()
                   .replaceAll("\"", "")
                   .equalsIgnoreCase(this.header.toString());
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
    private void maybeSkipBOM(Reader reader) throws IOException {
        reader.mark(1);
        char[] buf = new char[1];
        reader.read(buf);

        if (buf[0] != BOM)
            reader.reset();
    }

    /**
     * Check if the CSV File contains quotation marks.
     * Needed because the lines need to be split according to the
     * correct delimiter.
     * @param reader    the {@code BufferedReader} used
     * @throws {@code IOException} if an error occurs while checking for quotes
     */
    private boolean checkQuotationMark(BufferedReader reader) throws IOException {
        final int bigNum = 500;

        reader.mark(bigNum);
        String line = reader.readLine();
        reader.reset();
        return line.matches("^\".*\"$");
    }
}
