package jovami.model.exceptions;

/**
 * InvalidCSVHeader
 */
public class InvalidCSVFileException extends IllegalArgumentException {

    public InvalidCSVFileException() {
        super("The CSV File contained invalid data!!");
    }

    public InvalidCSVFileException(String s) {
        super(s);
    }
}
