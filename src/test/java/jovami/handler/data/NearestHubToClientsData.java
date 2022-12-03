package jovami.handler.data;

import jovami.MainTest;

import java.util.Arrays;

public class NearestHubToClientsData {

    public static void loadData (){

        var userLists = Arrays.asList(

                new String[] { "CT1", "40.6389", "-8.6553", "C1" },
                new String[] { "CT2", "38.0333", "-7.8833", "C2" },
                new String[] { "CT3", "41.5333", "-8.4167", "C3" },
                new String[] { "CT15", "41.7", "-8.8333", "C4" },
                new String[] { "CT16", "41.3002", "-7.7398", "C5" },
                new String[] { "CT12", "41.1495", "-8.6108", "C6" },
                new String[] { "CT7", "38.5667", "-7.9", "C7" },
                new String[] { "CT8", "37.0161", "-7.935", "C8" },
                new String[] { "CT13", "39.2369", "-8.685", "C9" },
                new String[] { "CT14", "38.5243", "-8.8926", "E1" },
                new String[] { "CT11", "39.3167", "-7.4167", "E2" },
                new String[] { "CT5", "39.823", "-7.4931", "E3" },
                new String[] { "CT9", "40.5364", "-7.2683", "E4" },
                new String[] { "CT4", "41.8", "-6.75", "E5" },
                new String[] { "CT17", "40.6667", "-7.9167", "P1" },
                new String[] { "CT6", "40.2111", "-8.4291", "P2" },
                new String[] { "CT10", "39.7444", "-8.8072", "P3" }
        );

        var distanceLists = Arrays.asList(
                new String[]{"CT10","CT13","63448"},
                new String[]{"CT10","CT6","67584"},
                new String[]{"CT10","CT1","110848"},
                new String[]{"CT10","CT5","125041"},
                new String[]{"CT12","CT3","50467"},
                new String[]{"CT12","CT1","62877"},
                new String[]{"CT12","CT15","70717"},
                new String[]{"CT11","CT5","62655"},
                new String[]{"CT11","CT13","121584"},
                new String[]{"CT11","CT10","142470"},
                new String[]{"CT14","CT13","89813"},
                new String[]{"CT14","CT7","95957"},
                new String[]{"CT14","CT2","114913"},
                new String[]{"CT14","CT8","207558"},
                new String[]{"CT13","CT7","111686"},
                new String[]{"CT16","CT3","68957"},
                new String[]{"CT16","CT17","79560"},
                new String[]{"CT16","CT12","82996"},
                new String[]{"CT16","CT9","103704"},
                new String[]{"CT16","CT4","110133"},
                new String[]{"CT15","CT3","43598"},
                new String[]{"CT17","CT9","62879"},
                new String[]{"CT17","CT1","69282"},
                new String[]{"CT17","CT6","73828"},
                new String[]{"CT1","CT6","56717"},
                new String[]{"CT2","CT7","65574"},
                new String[]{"CT2","CT8","125105"},
                new String[]{"CT2","CT11","163996"},
                new String[]{"CT4","CT3","157223"},
                new String[]{"CT4","CT9","162527"},
                new String[]{"CT5","CT9","90186"},
                new String[]{"CT5","CT6","100563"},
                new String[]{"CT5","CT17","111134"}
        );
        MainTest.readUsers(userLists,distanceLists);
        
    }

}
