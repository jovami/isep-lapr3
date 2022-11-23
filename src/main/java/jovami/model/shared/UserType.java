package jovami.model.shared;

/**
 * UserType
 */
public enum UserType {

    PRODUCER('P'),
    CLIENT('E'),
    COMPANY('P');

    public final char prefix;

    UserType(char s) {
        this.prefix = s;
    }
}
