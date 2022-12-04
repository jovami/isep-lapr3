package jovami.model.csv;

/**
 * The enum Csv header.
 */
public enum CSVHeader {
    /**
     * The No header.
     */
    NO_HEADER(0, ",") {
        @Override
        public String toString() {
            return null;
        }
    },
    /**
     * The Bundles.
     */
    BUNDLES(22, ",") {
        @Override
        public String toString() {
            return "Clientes-Produtores,Dia,Prod1,Prod2,Prod3,Prod4,Prod5,Prod6,Prod7,Prod8,Prod9,Prod10,Prod11,Prod12,Prod13,Prod14,Prod15,Prod16,Prod17,Prod18,Prod19,Prod20";
        }
    },
    /**
     * The Bundles small.
     */
    BUNDLES_SMALL(14, ",") {
        @Override
        public String toString() {
            return "\"Clientes-Produtores\",\"Dia\",\"Prod1\",\"Prod2\",\"Prod3\",\"Prod4\",\"Prod5\",\"Prod6\",\"Prod7\",\"Prod8\",\"Prod9\",\"Prod10\",\"Prod11\",\"Prod12\"";
        }
    },
    USERS(4, ",") {
        @Override
        public String toString() {
            return "Loc id,lat,lng,Clientes-Produtores";
        }
    },
    DISTANCES(3, ",") {
        @Override
        public String toString() {
            return "Loc id 1,Loc id 2, length (m)";
        }
    };


    private final int columns;
    private final String delimiter;

    /**
     * Gets column count.
     *
     * @return the column count
     */
    public int getColumnCount() {
        return this.columns;
    }

    /**
     * Gets delimiter.
     *
     * @return the delimiter
     */
    public String getDelimiter() {
        return this.delimiter;
    }

    CSVHeader(int col, String delim) {
        this.columns = col;
        this.delimiter = delim;
    }
}
