package jovami.model.csv;

public enum CSVHeader {
    BUNDLES(22, ",") {
        @Override
        public String toString() {
            return "Clientes-Produtores,Dia,Prod1,Prod2,Prod3,Prod4,Prod5,Prod6,Prod7,Prod8,Prod9,Prod10,Prod11,Prod12,Prod13,Prod14,Prod15,Prod16,Prod17,Prod18,Prod19,Prod20";
        }
    },
    CLIENTS_PROVIDERS(4, ",") {
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

    public int getColumnCount() {
        return this.columns;
    }

    public String getDelimiter() {
        return this.delimiter;
    }

    CSVHeader(int col, String delim) {
        this.columns = col;
        this.delimiter = delim;
    }
}
