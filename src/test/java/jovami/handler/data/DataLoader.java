package jovami.handler.data;

import java.util.Arrays;
import java.util.List;

public class DataLoader {
    public List<List<String[]>> addDeliveredProducerDay1() {
        return Arrays.asList(
                Arrays.asList(
                        new String[] { "Prod5", "5.0", "5.0", "P1" },
                        new String[] { "Prod6", "2.0", "2.0", "P2" },
                        new String[] { "Prod11","2.5", "2.5", "P3" }),
                Arrays.asList(
                        new String[] { "Prod2", "5.5", "5.5", "P1" },
                        new String[] { "Prod3", "4.5", "4.5", "P1" },
                        new String[] { "Prod5", "4.0", "4.0", "P2" },
                        new String[] { "Prod9", "1.0", "1.0", "P1" },
                        new String[] { "Prod10","9.0", "9.0", "P1" },
                        new String[] { "Prod11","10.0", "1.0", "P1" }),
                Arrays.asList(
                        new String[] { "Prod1", "10.0", "7.5", "P2" },
                        new String[] { "Prod5", "9.0", "1.5", "P3" },
                        new String[] { "Prod6", "2.5", "2.5", "P3" },
                        new String[] { "Prod9", "4.5", "3.5", "P3" }),
                List.of(),List.of(),
                Arrays.asList(
                        new String[] { "Prod3", "8.5", "4.5", "P1" },
                        new String[] { "Prod10","9.0", "4.0", "P3" },
                        new String[] { "Prod11","9.5", "0.5", "P3" }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod6", "2.5", "2.5", "P3" },
                        new String[] { "Prod9", "7.5", "2.5", "P1" },
                        new String[] { "Prod12","6.0", "2.5", "P3" }),
                Arrays.asList(
                        new String[] { "Prod1", "7.0", "2.5", "P3" },
                        new String[] { "Prod9", "3.0", "1.0", "P2" }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod1", "0.0", null },
                        new String[] { "Prod2", "6.0", "6.0", "P2" },
                        new String[] { "Prod3", "9.0", "1.5", "P2" },
                        new String[] { "Prod5", "6.0", "1.0", "P1" },
                        new String[] { "Prod6", "8.5", "3.0", "P3" },
                        new String[] { "Prod7", "7.5", "7.5", "P1" },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod11", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod6", "10.0", "0.5", "P2" },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod11", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod1", "0.0", null },
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod11", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod2", "1.5", "1.5", "P1" },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod7", "9.5", "9.0", "P3" },
                        new String[] { "Prod11", "0.0", null }));
    }


    public List<List<String[]>> addDeliveredProducerDay2() {
        return Arrays.asList(
                Arrays.asList(
                        new String[]{"Prod1","4.5","4.5","P3"},
                        new String[]{"Prod2","6.0","2.0","P3"},
                        new String[]{"Prod3","3.5","3.5","P3"},
                        new String[]{"Prod5","4.0","4.0","P1"},
                        new String[]{"Prod7","9.0","9.0","P2"},
                        new String[]{"Prod8","3.0","3.0","P1"},
                        new String[]{"Prod10","5.5","5.5","P3"},
                        new String[]{"Prod11","0.0",null}),

                Arrays.asList(
                        new String[]{"Prod1","9.0","5.0","P3"},
                        new String[]{"Prod2","7.0","0.5","P1"},
                        new String[]{"Prod4","1.5","1.5","P1"},
                        new String[]{"Prod5","6.0","5.0","P2"},
                        new String[]{"Prod7","5.0","4.0","P2"},
                        new String[]{"Prod9","5.0","5.0","P1"},
                        new String[]{"Prod10","10.0","2.0","P3"},
                        new String[]{"Prod11","0.0",null},
                        new String[]{"Prod12","3.0","3.0","P2"}),
                Arrays.asList(
                        new String[]{"Prod1","10.0","3.0","P1"},
                        new String[]{"Prod7","6.0","1.0","P1"},
                        new String[]{"Prod9","7.5","7.5","P3"},
                        new String[]{"Prod11","0.0",null},
                        new String[]{"Prod12","3.5","3.5","P2"}),

                Arrays.asList(
                        new String[]{"Prod5","6.5","0.5","P1"},
                        new String[]{"Prod9","2.0","2.0","P2"},
                        new String[]{"Prod11","0.0",null},
                        new String[]{"Prod12","3.0","2.5","P1"}),

                List.of(),List.of(),

                Arrays.asList(
                        new String[]{"Prod1","0.0",null},
                        new String[]{"Prod3","8.0","2.5","P2"},
                        new String[]{"Prod6","7.0","7.0","P2"},
                        new String[]{"Prod7","0.0",null},
                        new String[]{"Prod8","7.0","6.0","P3"},
                        new String[]{"Prod9","1.5","1.0","P2"},
                        new String[]{"Prod10","0.0",null},
                        new String[]{"Prod11","0.0",null},
                        new String[]{"Prod12","4.5","2.0","P2"}),

                List.of(),

                Arrays.asList(
                        new String[]{"Prod1","0.0",null},
                        new String[]{"Prod3","6.5","1.0","P3"},
                        new String[]{"Prod6","10.0","4.0","P1"},
                        new String[]{"Prod9","9.5","1.0","P3"},
                        new String[]{"Prod10","0.0",null},
                        new String[]{"Prod11","0.0",null}),

                Arrays.asList(
                        new String[]{"Prod4","4.5","4.5","P2"},
                        new String[]{"Prod8","3.0","3.0","P1"},
                        new String[]{"Prod10","0.0",null},
                        new String[]{"Prod11","0.0",null},
                        new String[]{"Prod12","0.0",null}),
                Arrays.asList(
                        new String[]{"Prod5","0.0",null},
                        new String[]{"Prod6","2.0","0.5","P2"},
                        new String[]{"Prod11","0.0",null},
                        new String[]{"Prod12","0.0",null}),

                List.of(),List.of(),

                Arrays.asList(
                        new String[]{"Prod1","0.0",null},
                        new String[]{"Prod2","5.0","0.5","P2"},
                        new String[]{"Prod4","3.5","3.5","P3"},
                        new String[]{"Prod6","0.0",null},
                        new String[]{"Prod7","0.0",null},
                        new String[]{"Prod8","9.5","3.5","P2"},
                        new String[]{"Prod11","0.0",null},
                        new String[]{"Prod12","0.0",null})
        );
    }

    public List<List<String[]>> addDeliveredProducerDay3() {
        return Arrays.asList(
                Arrays.asList(
                        new String[] { "Prod1", "8.0", "7.5", "P3" },
                        new String[] { "Prod3", "9.5", "6.0", "P1" },
                        new String[] { "Prod4", "2.0", "2.0", "P2" },
                        new String[] { "Prod7", "9.5", "6.0", "P2" },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod10", "9.5", "3.0", "P2" },
                        new String[] { "Prod12", "6.0", "2.5", "P1" }),
                Arrays.asList(
                        new String[] { "Prod5", "5.0", "4.0", "P2" },
                        new String[] { "Prod7", "3.0", "3.0", "P3" },
                        new String[] { "Prod10", "8.0", "1.0", "P3" }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod2", "10.0", "1.5", "P1" },
                        new String[] { "Prod4", "8.0", "8.0", "P3" },
                        new String[] { "Prod5", "5.0", "2.5", "P3" },
                        new String[] { "Prod6", "2.5", "2.5", "P1" },
                        new String[] { "Prod8", "4.0", "4.0", "P1" },
                        new String[] { "Prod11", "5.5", "5.5", "P3" }),
                Arrays.asList(
                        new String[] { "Prod1", "8.0", "6.0", "P2" },
                        new String[] { "Prod3", "4.5", "4.5", "P2" },
                        new String[] { "Prod11", "5.5", "1.5", "P2" }),
                Arrays.asList(
                        new String[] { "Prod1", "0.0", null },
                        new String[] { "Prod3", "8.5", "1.5", "P2" },
                        new String[] { "Prod8", "4.5", "4.5", "P2" },
                        new String[] { "Prod10", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod4", "5.5", "2.0", "P2" },
                        new String[] { "Prod7", "3.5", "2.0", "P3" },
                        new String[] { "Prod8", "3.0", "3.0", "P2" },
                        new String[] { "Prod12", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod1", "0.0", null },
                        new String[] { "Prod4", "8.5", "1.5", "P3" },
                        new String[] { "Prod6", "8.5", "7.0", "P3" },
                        new String[] { "Prod8", "10.0", "1.0", "P2" },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod12", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod4", "7.5", "0.5", "P1" },
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod8", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod2", "0.0", null },
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod4", "0.0", null },
                        new String[] { "Prod6", "9.5", "2.0", "P1" },
                        new String[] { "Prod8", "0.0", null },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod12", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod1", "0.0", null },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod11", "5.5", "0.5", "P3" },
                        new String[] { "Prod12", "0.0", null }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod2", "0.0", null },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod7", "6.5", "1.0", "P1" },
                        new String[] { "Prod8", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod1", "0.0", null },
                        new String[] { "Prod4", "0.0", null },
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod11", "0.0", null },
                        new String[] { "Prod12", "0.0", null }));
    }

    public List<List<String[]>> addDeliveredProducerDay4() {
        return Arrays.asList(
                Arrays.asList(
                        new String[] { "Prod2", "4.5", "1.5", "P1" },
                        new String[] { "Prod5", "9.0", "3.5", "P1" },
                        new String[] { "Prod6", "9.5", "1.0", "P1" },
                        new String[] { "Prod11", "0.0", null },
                        new String[] { "Prod12", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod1", "2.5", "2.5", "P1" },
                        new String[] { "Prod3", "9.0", "8.0", "P1" },
                        new String[] { "Prod5", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod1", "1.0", "1.0", "P1" },
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod10", "4.0", "4.0", "P1" }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod12", "0.0", null }),

                Arrays.asList(
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod4", "8.0", "8.0", "P1" },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod11", "0.0", null }),
                List.of(),List.of(),List.of(),
                Arrays.asList(
                        new String[] { "Prod4", "0.0", null },
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod7", "7.0", "7.0", "P1" },
                        new String[] { "Prod10", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod7", "3.5", "1.5", "P1" },
                        new String[] { "Prod9", "6.0", "6.0", "P1" },
                        new String[] { "Prod11", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod4", "0.0", null },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod12", "0.0", null }),
                List.of(),List.of()

        );
    }

    public List<List<String[]>> addDeliveredProducerDay5() {
        return Arrays.asList(
                Arrays.asList(
                        new String[] { "Prod1", "8.0", "8.0", "P1" },
                        new String[] { "Prod2", "7.0", "7.0", "P1" },
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod7", "1.5", "1.5", "P2" },
                        new String[] { "Prod8", "6.0", "6.0", "P1" },
                        new String[] { "Prod10", "3.0", "3.0", "P2" },
                        new String[] { "Prod11", "6.5", "6.5", "P1" },
                        new String[] { "Prod12", "3.5", "3.5", "P2" }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod2", "5.0", "5.0", "P2" },
                        new String[] { "Prod6", "5.0", "5.0", "P1" },
                        new String[] { "Prod7", "4.5", "1.5", "P2" },
                        new String[] { "Prod10", "5.0", "4.0", "P2" },
                        new String[] { "Prod11", "2.5", "2.5", "P1" }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod1", "6.5", "2.0", "P2" },
                        new String[] { "Prod2", "5.0", "1.0", "P1" },
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod4", "6.0", "6.0", "P3" },
                        new String[] { "Prod6", "6.5", "2.0", "P1" },
                        new String[] { "Prod7", "0.0", null },
                        new String[] { "Prod8", "7.0", "7.0", "P1" },
                        new String[] { "Prod9", "7.5", "6.5", "P3" },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod12", "2.5", "2.5", "P2" }),
                Arrays.asList(
                        new String[] { "Prod5", "1.0", "1.0", "P2" },
                        new String[] { "Prod7", "0.0", null },
                        new String[] { "Prod8", "6.0", "4.0", "P3" },
                        new String[] { "Prod11", "2.0", "2.0", "P2" }),
                Arrays.asList(
                        new String[] { "Prod1", "7.0", "0.5", "P1" },
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod8", "7.5", "1.5", "P2" },
                        new String[] { "Prod9", "10.0", "5.0", "P2" },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod11", "9.0", "8.5", "P3" },
                        new String[] { "Prod12", "5.0", "4.5", "P3" }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod1", "0.0", null },
                        new String[] { "Prod2", "6.5", "0.5", "P2" },
                        new String[] { "Prod4", "3.0", "1.5", "P3" },
                        new String[] { "Prod6", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod2", "0.0", null },
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod4", "7.5", "1.0", "P1" },
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod8", "0.0", null },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod11", "4.0", "2.0", "P2" },
                        new String[] { "Prod12", "9.5", "4.0", "P2" }),
                List.of(),
                Arrays.asList(
                        new String[] { "Prod3", "0.0", null },
                        new String[] { "Prod4", "0.0", null },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod7", "0.0", null },
                        new String[] { "Prod9", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod4", "0.0", null },
                        new String[] { "Prod5", "0.0", null },
                        new String[] { "Prod6", "0.0", null },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod10", "0.0", null }),
                Arrays.asList(
                        new String[] { "Prod1", "0.0", null },
                        new String[] { "Prod7", "0.0", null },
                        new String[] { "Prod8", "0.0", null },
                        new String[] { "Prod9", "0.0", null },
                        new String[] { "Prod10", "0.0", null },
                        new String[] { "Prod12", "0.0", null })

        );
    }

    public List<String[]> addBundle() {
        return Arrays.asList(
                new String[]{"C1", "1", "0", "0", "0", "0", "5", "2", "0", "0", "0", "0", "2.5", "0"},
                new String[]{"C2", "1", "0", "5.5", "4.5", "0", "4", "0", "0", "0", "1", "9", "10", "0"},
                new String[]{"C3", "1", "10", "0", "0", "0", "9", "2.5", "0", "0", "4.5", "0", "0", "0"},
                new String[]{"C4", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C5", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C6", "1", "0", "0", "8.5", "0", "0", "0", "0", "0", "0", "9", "9.5", "0"},
                new String[]{"C7", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C8", "1", "0", "0", "0", "0", "0", "2.5", "0", "0", "7.5", "0", "0", "6"},
                new String[]{"C9", "1", "7", "0", "0", "0", "0", "0", "0", "0", "3", "0", "0", "0"},
                new String[]{"C1", "2", "4.5", "6", "3.5", "0", "4", "0", "9", "3", "0", "5.5", "1.5", "0"},
                new String[]{"C2", "2", "9", "7", "0", "1.5", "6", "0", "5", "0", "5", "10", "1", "3"},
                new String[]{"C3", "2", "10", "0", "0", "0", "0", "0", "6", "0", "7.5", "0", "2.5", "3.5"},
                new String[]{"C4", "2", "0", "0", "0", "0", "6.5", "0", "0", "0", "2", "0", "3.5", "3"},
                new String[]{"C5", "2", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C6", "2", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C7", "2", "6", "0", "8", "0", "0", "7", "3.5", "7", "1.5", "2.5", "3.5", "4.5"},
                new String[]{"C8", "2", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C9", "2", "10", "0", "6.5", "0", "0", "10", "0", "0", "9.5", "3.5", "4.5", "0"},
                new String[]{"C1", "3", "8", "0", "9.5", "2", "0", "0", "9.5", "0", "2", "9.5", "0", "6"},
                new String[]{"C2", "3", "0", "0", "0", "0", "5", "0", "3", "0", "0", "8", "0", "0"},
                new String[]{"C3", "3", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C4", "3", "0", "10", "0", "8", "5", "2.5", "0", "4", "0", "0", "5.5", "0"},
                new String[]{"C5", "3", "8", "0", "4.5", "0", "0", "0", "0", "0", "0", "0", "5.5", "0"},
                new String[]{"C6", "3", "8", "0", "8.5", "0", "0", "0", "0", "4.5", "0", "3", "0", "0"},
                new String[]{"C7", "3", "0", "0", "0", "5.5", "0", "0", "3.5", "3", "0", "0", "0", "10"},
                new String[]{"C8", "3", "1", "0", "0", "8.5", "0", "8.5", "0", "10", "9", "0", "0", "5"},
                new String[]{"C9", "3", "0", "0", "0", "7.5", "7.5", "0", "0", "6.5", "0", "0", "0", "0"},
                new String[]{"C1", "4", "0", "4.5", "0", "0", "9", "9.5", "0", "0", "0", "0", "5.5", "9"},
                new String[]{"C2", "4", "2.5", "0", "9", "0", "9", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C3", "4", "1", "0", "0", "0", "2.5", "7.5", "0", "0", "0", "4", "0", "0"},
                new String[]{"C4", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C5", "4", "0", "0", "0", "0", "2", "1", "0", "0", "0", "0", "0", "4.5"},
                new String[]{"C6", "4", "0", "0", "7.5", "8", "0", "0", "0", "0", "0", "5", "7.5", "0"},
                new String[]{"C7", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C8", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C9", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C1", "5", "8", "7", "9", "0", "0", "0", "1.5", "6", "0", "3", "6.5", "3.5"},
                new String[]{"C2", "5", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C3", "5", "0", "5", "0", "0", "0", "5", "4.5", "0", "0", "5", "2.5", "0"},
                new String[]{"C4", "5", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C5", "5", "6.5", "5", "9.5", "6", "0", "6.5", "5", "7", "7.5", "5", "0", "2.5"},
                new String[]{"C6", "5", "0", "0", "0", "0", "1", "0", "4.5", "6", "0", "0", "2", "0"},
                new String[]{"C7", "5", "7", "0", "0", "0", "0.5", "1.5", "0", "7.5", "10", "6", "9", "5"},
                new String[]{"C8", "5", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"C9", "5", "1.5", "6.5", "0", "3", "0", "3.5", "0", "0", "0", "0", "0", "0"},
                new String[]{"E1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"E2", "1", "9", "6", "9", "0", "6", "8.5", "7.5", "0", "2.5", "4.5", "3", "0"},
                new String[]{"E3", "1", "0", "0", "0", "0", "0", "10", "0", "0", "5", "0", "5.5", "0"},
                new String[]{"E4", "1", "6.5", "0", "6.5", "0", "1", "0", "0", "0", "0", "1", "5.5", "0"},
                new String[]{"E5", "1", "0", "1.5", "0", "0", "0", "8", "9.5", "0", "0", "0", "6", "0"},
                new String[]{"E1", "2", "0", "0", "0", "4.5", "0", "0", "0", "3", "0", "9.5", "2.5", "3"},
                new String[]{"E2", "2", "0", "0", "0", "0", "9.5", "2", "0", "0", "0", "0", "9", "9"},
                new String[]{"E3", "2", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"E4", "2", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"E5", "2", "8.5", "5", "0", "3.5", "0", "5", "1", "9.5", "0", "0", "1.5", "2.5"},
                new String[]{"E1", "3", "0", "6.5", "9.5", "3", "0", "9.5", "0", "6", "5", "7.5", "0", "5"},
                new String[]{"E2", "3", "8", "0", "0", "0", "0", "0", "0", "0", "2.5", "0", "5.5", "3.5"},
                new String[]{"E3", "3", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"E4", "3", "0", "1.5", "0", "0", "0", "2", "6.5", "2.5", "0", "0", "0", "0"},
                new String[]{"E5", "3", "1", "0", "0", "4.5", "1", "0", "0", "0", "0", "0", "2.5", "8.5"},
                new String[]{"E1", "4", "0", "0", "0", "6.5", "7.5", "7", "7", "0", "0", "5.5", "0", "0"},
                new String[]{"E2", "4", "0", "0", "7.5", "0", "0", "0", "3.5", "0", "6", "0", "3.5", "0"},
                new String[]{"E3", "4", "0", "0", "9.5", "10", "0", "0", "0", "0", "0", "8", "0", "3"},
                new String[]{"E4", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"E5", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"E1", "5", "0", "2", "7", "7.5", "3", "8.5", "0", "1.5", "8.5", "8", "4", "9.5"},
                new String[]{"E2", "5", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"E3", "5", "0", "0", "7.5", "5.5", "0", "9", "2", "0", "8", "0", "0", "0"},
                new String[]{"E4", "5", "0", "0", "0", "4.5", "3", "4", "0", "0", "5.5", "1", "0", "0"},
                new String[]{"E5", "5", "6", "0", "0", "0", "0", "0", "8.5", "2", "8.5", "10", "0", "1.5"},
                new String[]{"P1", "1", "0", "7.5", "9", "2", "6", "0", "8.5", "3", "3.5", "9", "1", "0"},
                new String[]{"P1", "2", "3", "0", "0", "0", "4.5", "4", "0", "4", "5", "0", "0", "2.5"},
                new String[]{"P1", "3", "0", "1.5", "6", "0", "0", "4.5", "1", "3", "0", "0", "0", "2.5"},
                new String[]{"P1", "4", "3.5", "1.5", "8", "8", "3.5", "1", "8.5", "8.5", "6", "4", "0", "0"},
                new String[]{"P1", "5", "8.5", "8", "0", "1", "0", "7", "0", "4.5", "0", "0", "10", "0"},
                new String[]{"P2", "1", "7.5", "6.5", "1.5", "7", "4", "2.5", "4.5", "3.5", "1", "0", "0", "0"},
                new String[]{"P2", "2", "0", "0", "2.5", "0", "5", "7.5", "8.5", "0", "3", "0", "0", "8.5"},
                new String[]{"P2", "3", "6", "0", "6", "1.5", "4", "0", "6", "8.5", "0", "3", "1.5", "0"},
                new String[]{"P2", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"P2", "5", "2", "5.5", "0", "0", "1", "0", "3", "1.5", "5", "7", "4", "10"},
                new String[]{"P3", "1", "2.5", "2", "0", "0", "1.5", "8", "9", "6", "3.5", "4", "3", "2.5"},
                new String[]{"P3", "2", "9.5", "0", "4.5", "4.5", "0", "0", "0", "0", "8.5", "7.5", "0", "0"},
                new String[]{"P3", "3", "7.5", "0", "0", "8.5", "2.5", "7", "5", "0", "0", "1", "6", "0"},
                new String[]{"P3", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"P3", "5", "0", "0", "0", "7.5", "0", "0", "0", "4", "6.5", "0", "8.5", "4.5"}
        );
    }

    public List<List<String[]>> statsClientExpNoRestrict() {
            return Arrays.asList(
                            Arrays.asList(
                                            new String[] { "C1", "1", "0", "3" },
                                            new String[] { "C2", "0", "1", "2" },
                                            new String[] { "C3", "0", "1", "2" },
                                            new String[] { "C4", "0", "0", "0" },
                                            new String[] { "C5", "0", "0", "0" },
                                            new String[] { "C6", "0", "1", "2" },
                                            new String[] { "C7", "0", "0", "0" },
                                            new String[] { "C8", "0", "1", "2" },
                                            new String[] { "C9", "0", "1", "2" },
                                            new String[] { "E1", "0", "0", "0" },
                                            new String[] { "E2", "0", "1", "3" },
                                            new String[] { "E3", "0", "1", "1" },
                                            new String[] { "E4", "0", "0", "0" },
                                            new String[] { "E5", "0", "1", "2" }),
                            Arrays.asList(
                                            new String[] { "C1", "0", "1", "3" },
                                            new String[] { "C2", "0", "1", "3" },
                                            new String[] { "C3", "0", "1", "3" },
                                            new String[] { "C4", "0", "1", "2" },
                                            new String[] { "C5", "0", "0", "0" },
                                            new String[] { "C6", "0", "0", "0" },
                                            new String[] { "C7", "0", "1", "2" },
                                            new String[] { "C8", "0", "0", "0" },
                                            new String[] { "C9", "0", "1", "2" },
                                            new String[] { "E1", "0", "1", "2" },
                                            new String[] { "E2", "0", "1", "1" },
                                            new String[] { "E3", "0", "0", "0" },
                                            new String[] { "E4", "0", "0", "0" },
                                            new String[] { "E5", "0", "1", "2" }),
                            Arrays.asList(
                                            new String[] { "C1", "0", "1", "3" },
                                            new String[] { "C2", "0", "1", "2" },
                                            new String[] { "C3", "0", "0", "0" },
                                            new String[] { "C4", "0", "1", "2" },
                                            new String[] { "C5", "0", "1", "1" },
                                            new String[] { "C6", "0", "1", "1" },
                                            new String[] { "C7", "0", "1", "2" },
                                            new String[] { "C8", "0", "1", "2" },
                                            new String[] { "C9", "0", "1", "1" },
                                            new String[] { "E1", "0", "1", "1" },
                                            new String[] { "E2", "0", "1", "1" },
                                            new String[] { "E3", "0", "0", "0" },
                                            new String[] { "E4", "0", "1", "1" },
                                            new String[] { "E5", "0", "0", "0" }),
                            Arrays.asList(
                                            new String[] { "C1", "0", "1", "1" },
                                            new String[] { "C2", "0", "1", "1" },
                                            new String[] { "C3", "0", "1", "1" },
                                            new String[] { "C4", "0", "0", "0" },
                                            new String[] { "C5", "0", "0", "0" },
                                            new String[] { "C6", "0", "1", "1" },
                                            new String[] { "C7", "0", "0", "0" },
                                            new String[] { "C8", "0", "0", "0" },
                                            new String[] { "C9", "0", "0", "0" },
                                            new String[] { "E1", "0", "1", "1" },
                                            new String[] { "E2", "0", "1", "1" },
                                            new String[] { "E3", "0", "0", "0" },
                                            new String[] { "E4", "0", "0", "0" },
                                            new String[] { "E5", "0", "0", "0" }),
                            Arrays.asList(
                                            new String[] { "C1", "0", "1", "2" },
                                            new String[] { "C2", "0", "0", "0" },
                                            new String[] { "C3", "0", "1", "2" },
                                            new String[] { "C4", "0", "0", "0" },
                                            new String[] { "C5", "0", "1", "3" },
                                            new String[] { "C6", "0", "1", "2" },
                                            new String[] { "C7", "0", "1", "3" },
                                            new String[] { "C8", "0", "0", "0" },
                                            new String[] { "C9", "0", "1", "2" },
                                            new String[] { "E1", "0", "1", "2" },
                                            new String[] { "E2", "0", "0", "0" },
                                            new String[] { "E3", "0", "0", "0" },
                                            new String[] { "E4", "0", "0", "0" },
                                            new String[] { "E5", "0", "0", "0" }));
    }

    public List<List<String[]>> statsProducerExpNoRestrict() {
            return Arrays.asList(
                            Arrays.asList(
                                            new String[] { "P1", "0", "6", "9", "6", "2" },
                                            new String[] { "P2", "0", "6", "9", "6", "2" },
                                            new String[] { "P3", "0", "7", "10", "7", "2" }),
                            Arrays.asList(
                                            new String[] { "P1", "0", "6", "6", "6", "1" },
                                            new String[] { "P2", "0", "8", "6", "8", "3" },
                                            new String[] { "P3", "0", "6", "5", "6", "1" }),
                            Arrays.asList(
                                            new String[] { "P1", "0", "5", "6", "5", "2" },
                                            new String[] { "P2", "0", "6", "8", "6", "0" },
                                            new String[] { "P3", "0", "6", "7", "6", "1" }),
                            Arrays.asList(
                                            new String[] { "P1", "0", "6", "10", "6", "2" },
                                            new String[] { "P2", "0", "0", "0", "0", "0" },
                                            new String[] { "P3", "0", "0", "0", "0", "0" }),
                            Arrays.asList(
                                            new String[] { "P1", "0", "5", "5", "5", "1" },
                                            new String[] { "P2", "0", "7", "9", "7", "1" },
                                            new String[] { "P3", "0", "4", "5", "4", "0" }));
    }

    public List<List<String[]>> statsHubExpNoRestrict() {
            return Arrays.asList(
                            Arrays.asList(
                                            new String[] { "E4", "4", "3" },
                                            new String[] { "E1", "5", "3" },
                                            new String[] { "E5", "3", "3" },
                                            new String[] { "E2", "1", "3" },
                                            new String[] { "E3", "1", "1" }),
                            Arrays.asList(
                                            new String[] { "E4", "4", "3" },
                                            new String[] { "E1", "5", "3" },
                                            new String[] { "E5", "3", "3" },
                                            new String[] { "E2", "1", "1" },
                                            new String[] { "E3", "1", "0" }),
                            Arrays.asList(
                                            new String[] { "E4", "4", "3" },
                                            new String[] { "E1", "5", "3" },
                                            new String[] { "E5", "3", "2" },
                                            new String[] { "E2", "1", "1" },
                                            new String[] { "E3", "1", "0" }),
                            Arrays.asList(
                                            new String[] { "E4", "4", "1" },
                                            new String[] { "E1", "5", "1" },
                                            new String[] { "E5", "3", "1" },
                                            new String[] { "E2", "1", "1" },
                                            new String[] { "E3", "1", "0" }),
                            Arrays.asList(
                                            new String[] { "E4", "4", "3" },
                                            new String[] { "E1", "5", "3" },
                                            new String[] { "E5", "3", "2" },
                                            new String[] { "E2", "1", "0" },
                                            new String[] { "E3", "1", "0" }));
    }



    public List<List<String[]>> statsBundleExpNoRestrict() {
            return Arrays.asList(
                            Arrays.asList(
                                            new String[] { "C1", "3.0", "0.0", "0.0", "100.00", "3.00" },
                                            new String[] { "C2", "5.0", "1.0", "0.0", "83.33", "2.00" },
                                            new String[] { "C3", "1.0", "3.0", "0.0", "25.00", "2.00" },
                                            new String[] { "C4", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C5", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C6", "0.0", "3.0", "0.0", "0.00", "2.00" },
                                            new String[] { "C7", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C8", "1.0", "2.0", "0.0", "33.33", "2.00" },
                                            new String[] { "C9", "0.0", "2.0", "0.0", "0.00", "2.00" },
                                            new String[] { "E1", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "E2", "2.0", "3.0", "4.0", "22.22", "3.00" },
                                            new String[] { "E3", "0.0", "1.0", "2.0", "0.00", "1.00" },
                                            new String[] { "E4", "0.0", "0.0", "5.0", "0.00", "0.00" },
                                            new String[] { "E5", "1.0", "1.0", "2.0", "25.00", "2.001" }),
                            Arrays.asList(
                                            new String[] { "C1", "6.0", "1.0", "1.0", "75.00", "3.00" },
                                            new String[] { "C2", "3.0", "5.0", "1.0", "33.33", "3.00" },
                                            new String[] { "C3", "2.0", "2.0", "1.0", "40.00", "3.00" },
                                            new String[] { "C4", "1.0", "2.0", "1.0", "25.00", "2.00" },
                                            new String[] { "C5", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C6", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C7", "1.0", "4.0", "4.0", "11.11", "2.00" },
                                            new String[] { "C8", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C9", "0.0", "3.0", "3.0", "0.00", "2.00" },
                                            new String[] { "E1", "2.0", "0.0", "3.0", "40.00", "2.00" },
                                            new String[] { "E2", "0.0", "1.0", "3.0", "0.00", "1.00" },
                                            new String[] { "E3", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "E4", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "E5", "1.0", "2.0", "5.0", "12.50", "2.00 " }),
                            Arrays.asList(
                                            new String[] { "C1", "1.0", "5.0", "1.0", "14.29", "3.00" },
                                            new String[] { "C2", "1.0", "2.0", "0.0", "33.33", "2.00" },
                                            new String[] { "C3", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C4", "4.0", "2.0", "0.0", "66.67", "2.00" },
                                            new String[] { "C5", "1.0", "2.0", "0.0", "33.33", "1.00" },
                                            new String[] { "C6", "1.0", "1.0", "2.0", "25.00", "1.00" },
                                            new String[] { "C7", "1.0", "2.0", "1.0", "25.00", "2.00" },
                                            new String[] { "C8", "0.0", "3.0", "3.0", "0.00", "2.00" },
                                            new String[] { "C9", "0.0", "1.0", "2.0", "0.00", "1.00" },
                                            new String[] { "E1", "0.0", "1.0", "7.0", "0.00", "1.00" },
                                            new String[] { "E2", "0.0", "1.0", "3.0", "0.00", "1.00" },
                                            new String[] { "E3", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "E4", "0.0", "1.0", "3.0", "0.00", "1.00" },
                                            new String[] { "E5", "0.0", "0.0", "5.0", "0.00", "0.00" }),
                            Arrays.asList(
                                            new String[] { "C1", "0.0", "3.0", "2.0", "0.00", "1.00" },
                                            new String[] { "C2", "1.0", "1.0", "1.0", "33.33", "1.00" },
                                            new String[] { "C3", "2.0", "0.0", "2.0", "50.00", "1.00" },
                                            new String[] { "C4", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C5", "0.0", "0.0", "3.0", "0.00", "0.00" },
                                            new String[] { "C6", "1.0", "0.0", "3.0", "25.00", "1.00" },
                                            new String[] { "C7", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C8", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C9", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "E1", "1.0", "0.0", "4.0", "20.00", "1.00" },
                                            new String[] { "E2", "1.0", "1.0", "2.0", "25.00", "1.00" },
                                            new String[] { "E3", "0.0", "0.0", "4.0", "0.00", "0.00" },
                                            new String[] { "E4", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "E5", "0.0", "0.0", "0.0", null, "0.00" }),
                            Arrays.asList(
                                            new String[] { "C1", "7.0", "0.0", "1.0", "87.50", "2.00" },
                                            new String[] { "C2", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C3", "3.0", "2.0", "0.0", "60.00", "2.00" },
                                            new String[] { "C4", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C5", "3.0", "4.0", "3.0", "30.00", "3.00" },
                                            new String[] { "C6", "2.0", "1.0", "1.0", "50.00", "2.00" },
                                            new String[] { "C7", "0.0", "5.0", "3.0", "0.00", "3.00" },
                                            new String[] { "C8", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "C9", "0.0", "2.0", "2.0", "0.00", "2.00" },
                                            new String[] { "E1", "0.0", "3.0", "7.0", "0.00", "2.00" },
                                            new String[] { "E2", "0.0", "0.0", "0.0", null, "0.00" },
                                            new String[] { "E3", "0.0", "0.0", "5.0", "0.00", "0.00" },
                                            new String[] { "E4", "0.0", "0.0", "5.0", "0.00", "0.00" },
                                            new String[] { "E5", "0.0", "0.0", "6.0", "0.00", "0.00" }));
    }

}
