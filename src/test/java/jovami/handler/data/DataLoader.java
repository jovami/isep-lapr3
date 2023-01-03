package jovami.handler.data;

import java.util.Arrays;
import java.util.List;

public class DataLoader {
    public List<String[]> addDistances() {
        return Arrays.asList(
                new String[]{"CT10", "CT13", "63448"},
                new String[]{"CT10", "CT6", "67584"},
                new String[]{"CT10", "CT1", "110848"},
                new String[]{"CT10", "CT5", "125041"},
                new String[]{"CT12", "CT3", "50467"},
                new String[]{"CT12", "CT1", "62877"},
                new String[]{"CT12", "CT15", "70717"},
                new String[]{"CT11", "CT5", "62655"},
                new String[]{"CT11", "CT13", "121584"},
                new String[]{"CT11", "CT10", "142470"},
                new String[]{"CT14", "CT13", "89813"},
                new String[]{"CT14", "CT7", "95957"},
                new String[]{"CT14", "CT2", "114913"},
                new String[]{"CT14", "CT8", "207558"},
                new String[]{"CT13", "CT7", "111686"},
                new String[]{"CT16", "CT3", "68957"},
                new String[]{"CT16", "CT17", "79560"},
                new String[]{"CT16", "CT12", "82996"},
                new String[]{"CT16", "CT9", "103704"},
                new String[]{"CT16", "CT4", "110133"},
                new String[]{"CT15", "CT3", "43598"},
                new String[]{"CT17", "CT9", "62879"},
                new String[]{"CT17", "CT1", "69282"},
                new String[]{"CT17", "CT6", "73828"},
                new String[]{"CT1", "CT6", "56717"},
                new String[]{"CT2", "CT7", "65574"},
                new String[]{"CT2", "CT8", "125105"},
                new String[]{"CT2", "CT11", "163996"},
                new String[]{"CT4", "CT3", "157223"},
                new String[]{"CT4", "CT9", "162527"},
                new String[]{"CT5", "CT9", "90186"},
                new String[]{"CT5", "CT6", "100563"},
                new String[]{"CT5", "CT17", "111134"}
        );
    }

    public List<String[]> addUsers() {
        return Arrays.asList(
                new String[]{"CT1", "40.6389", "-8.6553", "C1"},
                new String[]{"CT2", "38.0333", "-7.8833", "C2"},
                new String[]{"CT3", "41.5333", "-8.4167", "C3"},
                new String[]{"CT15", "41.7", "-8.8333", "C4"},
                new String[]{"CT16", "41.3002", "-7.7398", "C5"},
                new String[]{"CT12", "41.1495", "-8.6108", "C6"},
                new String[]{"CT7", "38.5667", "-7.9", "C7"},
                new String[]{"CT8", "37.0161", "-7.935", "C8"},
                new String[]{"CT13", "39.2369", "-8.685", "C9"},
                new String[]{"CT14", "38.5243", "-8.8926", "E1"},
                new String[]{"CT11", "39.3167", "-7.4167", "E2"},
                new String[]{"CT5", "39.823", "-7.4931", "E3"},
                new String[]{"CT9", "40.5364", "-7.2683", "E4"},
                new String[]{"CT4", "41.8", "-6.75", "E5"},
                new String[]{"CT17", "40.6667", "-7.9167", "P1"},
                new String[]{"CT6", "40.2111", "-8.4291", "P2"},
                new String[]{"CT10", "39.7444", "-8.8072", "P3"}
        );
    }

    public List<List<String[]>> addDeliveredProducerDay1() {
        return Arrays.asList(
                Arrays.asList(
                        new String[]{"Prod5", "5,0", "P1"},
                        new String[]{"Prod6", "2,0", "P2"},
                        new String[]{"Prod11", "2,5", "P3"}),

                Arrays.asList(
                        new String[]{"Prod2", "5,5", "P1"},
                        new String[]{"Prod3", "4,5", "P1"},
                        new String[]{"Prod5", "4,0", "P2"},
                        new String[]{"Prod9", "1,0", "P1"},
                        new String[]{"Prod10", "9,0", "P1"},
                        new String[]{"Prod11", "10,0", null}),

                Arrays.asList(
                        new String[]{"Prod1", "10,0", null},
                        new String[]{"Prod5", "9,0", null},
                        new String[]{"Prod6", "2,5", "P3"},
                        new String[]{"Prod9", "4,5", null}),

                List.of(),
                List.of(),

                Arrays.asList(
                        new String[]{"Prod3", "8,5", null},
                        new String[]{"Prod10", "9,0", null},
                        new String[]{"Prod11", "9,5", null}),

                List.of(),

                Arrays.asList(
                        new String[]{"Prod6", "2,5", "P3"},
                        new String[]{"Prod9", "7,5", null},
                        new String[]{"Prod12", "6,0", null}),

                Arrays.asList(
                        new String[]{"Prod1", "7,0", "P2"},
                        new String[]{"Prod9", "3,0", "P3"}),

                List.of(),

                Arrays.asList(
                        new String[]{"Prod1", "9,0", null},
                        new String[]{"Prod2", "6,0", "P2"},
                        new String[]{"Prod3", "9,0", null},
                        new String[]{"Prod5", "6,0", null},
                        new String[]{"Prod6", "8,5", null},
                        new String[]{"Prod7", "7,5", "P1"},
                        new String[]{"Prod9", "2,5", "P1"},
                        new String[]{"Prod10", "4,5", null},
                        new String[]{"Prod11", "3,0", null}),

                Arrays.asList(
                        new String[]{"Prod6", "10,0", null},
                        new String[]{"Prod9", "5,0", null},
                        new String[]{"Prod11", "5,5", null}),

                Arrays.asList(
                        new String[]{"Prod1", "6,5", null},
                        new String[]{"Prod3", "6,5", null},
                        new String[]{"Prod5", "1,0", "P1"},
                        new String[]{"Prod10", "1,0", "P3"},
                        new String[]{"Prod11", "5,5", null}),

                Arrays.asList(
                        new String[]{"Prod2", "1,5", "P1"},
                        new String[]{"Prod6", "8,0", null},
                        new String[]{"Prod7", "9,5", null},
                        new String[]{"Prod11", "6,0", null})
        );
    }


    public List<List<String[]>> addDeliveredProducerDay2() {
        return Arrays.asList(
                Arrays.asList(
                        new String[]{"Prod1", "4,5", "P3"},
                        new String[]{"Prod2", "6,0", null},
                        new String[]{"Prod3", "3,5", "P1"},
                        new String[]{"Prod5", "4,0", "P1"},
                        new String[]{"Prod7", "9,0", "P2"},
                        new String[]{"Prod8", "3,0", "P1"},
                        new String[]{"Prod10", "5,5", "P3"},
                        new String[]{"Prod11", "1,5", null}),

                Arrays.asList(
                        new String[]{"Prod1", "9,0", null},
                        new String[]{"Prod2", "7,0", null},
                        new String[]{"Prod4", "1,5", "P1"},
                        new String[]{"Prod5", "6,0", null},
                        new String[]{"Prod7", "5,0", "P3"},
                        new String[]{"Prod9", "5,0", "P1"},
                        new String[]{"Prod10", "10,", null},
                        new String[]{"Prod11", "1,0", "P1"},
                        new String[]{"Prod12", "3,0", "P2"}),

                Arrays.asList(
                        new String[]{"Prod1", "10,", null},
                        new String[]{"Prod7", "6,0", null},
                        new String[]{"Prod9", "7,5", "P3"},
                        new String[]{"Prod11", "2,5", null},
                        new String[]{"Prod12", "3,5", "P2"}),

                Arrays.asList(
                        new String[]{"Prod5", "6,5", null},
                        new String[]{"Prod9", "2,0", "P2"},
                        new String[]{"Prod11", "3,5", null},
                        new String[]{"Prod12", "3,0", null}),

                List.of(),
                List.of(),

                Arrays.asList(
                        new String[]{"Prod1", "6,0", "P3"},
                        new String[]{"Prod3", "8,0", null},
                        new String[]{"Prod6", "7,0", "P2"},
                        new String[]{"Prod7", "3,5", "P2"},
                        new String[]{"Prod8", "7,0", null},
                        new String[]{"Prod9", "1,5", "P2"},
                        new String[]{"Prod10", "2,5", "P3"},
                        new String[]{"Prod11", "3,5", null},
                        new String[]{"Prod12", "4,5", null}),

                List.of(),

                Arrays.asList(
                        new String[]{"Prod1", "10,", null},
                        new String[]{"Prod3", "6,5", null},
                        new String[]{"Prod6", "10,", null},
                        new String[]{"Prod9", "9,5", null},
                        new String[]{"Prod10", "3,5", null},
                        new String[]{"Prod11", "4,5", null}),

                Arrays.asList(
                        new String[]{"Prod4", "4,5", "P2"},
                        new String[]{"Prod8", "3,0", "P1"},
                        new String[]{"Prod10", "9,5", null},
                        new String[]{"Prod11", "2,5", null},
                        new String[]{"Prod12", "3,0", null}),

                Arrays.asList(
                        new String[]{"Prod5", "9,5", null},
                        new String[]{"Prod6", "2,0", "P1"},
                        new String[]{"Prod11", "9,0", null},
                        new String[]{"Prod12", "9,0", null}),

                List.of(),
                List.of(),

                Arrays.asList(
                        new String[]{"Prod1", "8,5", null},
                        new String[]{"Prod2", "5,0", null},
                        new String[]{"Prod4", "3,5", "P3"},
                        new String[]{"Prod6", "5,0", null},
                        new String[]{"Prod7", "1,0", "P1"},
                        new String[]{"Prod8", "9,5", null},
                        new String[]{"Prod11", "1,5", null},
                        new String[]{"Prod12", "2,5", "P1"})
        );
    }

    public List<List<String[]>> addDeliveredProducerDay4() {
        return Arrays.asList(
                Arrays.asList(
                        new String[]{"Prod2", "4,5", null},
                        new String[]{"Prod5", "9,0", null},
                        new String[]{"Prod6", "9,5", null},
                        new String[]{"Prod11", "5,5", null},
                        new String[]{"Prod12", "9,0", null}),

                Arrays.asList(
                        new String[]{"Prod1", "2,5", "P1"},
                        new String[]{"Prod3", "9,0", "P1"},
                        new String[]{"Prod5", "9,0", null}),

                Arrays.asList(
                        new String[]{"Prod1", "1,0", "P1"},
                        new String[]{"Prod5", "2,5", "P1"},
                        new String[]{"Prod6", "7,5", null},
                        new String[]{"Prod10", "4,0", "P1"}),

                List.of(),

                Arrays.asList(
                        new String[]{"Prod5", "2,0", "P2"},
                        new String[]{"Prod6", "1,0", "P1"},
                        new String[]{"Prod12", "4,5", null}),

                Arrays.asList(
                        new String[]{"Prod3", "7,5", null},
                        new String[]{"Prod4", "8,0", "P1"},
                        new String[]{"Prod10", "5,0", null},
                        new String[]{"Prod11", "7,5", null}),

                List.of(),
                List.of(),
                List.of(),

                Arrays.asList(
                        new String[]{"Prod4", "6,5", null},
                        new String[]{"Prod5", "7,5", null},
                        new String[]{"Prod6", "7,0", null},
                        new String[]{"Prod7", "7,0", "P1"},
                        new String[]{"Prod10", "5,5", null}),

                Arrays.asList(
                        new String[]{"Prod3", "7,5", null},
                        new String[]{"Prod7", "3,5", null},
                        new String[]{"Prod9", "6,0", "P1"},
                        new String[]{"Prod11", "3,5", null}),

                Arrays.asList(
                        new String[]{"Prod3", "9,5", null},
                        new String[]{"Prod4", "10,0", null},
                        new String[]{"Prod10", "8,0", null},
                        new String[]{"Prod12", "3,0", null}),

                List.of(),
                List.of()
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
}
