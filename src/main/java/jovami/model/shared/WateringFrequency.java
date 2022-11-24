package jovami.model.shared;

public enum WateringFrequency {
    EVERYDAY(0),
    ODD_DAYS(1),
    EVEN_DAYS(2);

    /* TODO: change name */
    public final int i;

    WateringFrequency(int i) {
        this.i = i;
    }
}
