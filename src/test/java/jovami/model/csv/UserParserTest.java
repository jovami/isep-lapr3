package jovami.model.csv;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.Arrays;
import java.util.LinkedList;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jovami.App;
import jovami.MainTest;
import jovami.model.exceptions.InvalidCSVFileException;

/**
 * UserParserTest
 */
public class UserParserTest {

    private UserParser parser;
    private App app;

    @BeforeEach
    void setup() {
        MainTest.resetSingleton();
        this.parser = new UserParser();
        this.app = App.getInstance();
    }

    @Test
    void parseNothing() {
        final int size = 0;

        this.parser.parse(new LinkedList<>());

        assertEquals(size, this.app.userStore().size());
    }

    @Test
    void parseBadLatitude() {
        var dataSet = Arrays.asList(
            new String[] { "CT43", "failed", "24.100", "C125" }, // not a number
            new String[] { "CT49", "12,000", "21.001", "E114" }, // uses comma rather than a decimal point
            new String[] { "CT30", "92.000", "-110.1", "P201" }, // -90° <= latitude <= 90°
            new String[] { "CT10", "-192.1", "-110.1", "P201" }  // -90° <= latitude <= 90°
        );

        final int size = 0;

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(0));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(1));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(2));

            assertThrows(IllegalArgumentException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(3));

            assertThrows(IllegalArgumentException.class, () -> this.parser.parse(data));
        }

        assertEquals(size, this.app.userStore().size());
    }

    @Test
    void parseBadLongitude() {
        var dataSet = Arrays.asList(
            new String[] { "CT34", "0.0112", "bad_xx", "P219" }, // not a number
            new String[] { "CT50", "21.001", "0,1101", "E10"  }, // uses comma rather than a decimal point
            new String[] { "CT20", "89.000", "-360.2", "P10"  }, // -180° <= latitude <= 180°
            new String[] { "CT11", "-82.10", "181.01", "C15"  }  // -180° <= latitude <= 180°
        );

        final int size = 0;

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(0));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(1));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(2));

            assertThrows(IllegalArgumentException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(3));

            assertThrows(IllegalArgumentException.class, () -> this.parser.parse(data));
        }

        assertEquals(size, this.app.userStore().size());
    }

    @Test
    void parseBadUserType() {
        var dataSet = Arrays.asList(
                new String[] { "CT43","39.1167","-7.2833","X125"    },
                new String[] { "CT315","39.65","-7.6667","Y124"     },
                new String[] { "CT59","41.6889","-7.665","Z120"     },
                new String[] { "CT97","39.2844","-7.6444","127"     },
                new String[] { "CT295","41.6075","-7.31","q1"       },
                new String[] { "CT156","39.7478","-8.9322","a55"    },
                new String[] { "CT58","38.8056","-7.4547","Z80"     },
                new String[] { "CT290","41.0997","-8.6403","Xx110"  },
                new String[] { "CT250","41.3428","-8.4775","V173"   }
        );

        final int size = 0;

        dataSet.forEach(line -> {
            var data = new LinkedList<String[]>();
            data.push(line);

            assertThrows(IllegalArgumentException.class, () -> this.parser.parse(data));
        });

        assertEquals(size, this.app.userStore().size());
    }

    @Test
    void parseCorrect() {
        // Extracted from Big file
        var dataSet = Arrays.asList(
                new String[] { "CT207","41.9111","-8.5597","P45" },
                new String[] { "CT68","40.5167","-7.9","C167" },
                new String[] { "CT83","37.6976","-8.0819","E5" },
                new String[] { "CT171","38.65","-8.9833","E6" },
                new String[] { "CT136","41.4333","-8.4167","C89" },
                new String[] { "CT133","41.445","-8.2908","E7" },
                new String[] { "CT301","39.6833","-8.15","P42" },
                new String[] { "CT51","38.1307","-6.9761","P52" },
                new String[] { "CT102","41.01","-8.64","P15" },
                new String[] { "CT274","41.0167","-7.7833","E8" },
                new String[] { "CT213","40.9831","-7.3894","C2" },
                new String[] { "CT81","40.9","-7.9333","E9" },
                new String[] { "CT285","41.3374","-8.5596","P16" },
                new String[] { "CT184","41.4","-7.45","C108" },
                new String[] { "CT309","41.1333","-8.6167","C137" },
                new String[] { "CT283","39.4583","-8.2461","P29" },
                new String[] { "CT316","41.65","-8.4333","E10" },
                new String[] { "CT28","38.75","-9.2333","C116" },
                new String[] { "CT286","40.6114","-8.4673","C67" },
                new String[] { "CT112","40.9254","-8.5428","E11" },
                new String[] { "CT98","38.15","-7.8833","E12" },
                new String[] { "CT88","41.7399","-7.4707","E13" },
                new String[] { "CT143","37.144","-8.0235","P8" },
                new String[] { "CT144","38.8309","-9.1684","C63" },
                new String[] { "CT42","38.7229","-7.9843","C95" },
                new String[] { "CT157","39.3942","-7.3772","C41" },
                new String[] { "CT29","41.2728","-8.0825","C78" }
        );

        final int expected1 = dataSet.size();

        this.parser.parse(dataSet);

        assertEquals(expected1, this.app.userStore().size());

        // Extracted from Small file
        dataSet = Arrays.asList(
                new String[] { "CT1","40.6389","-8.6553","C1" },
                new String[] { "CT2","38.0333","-7.8833","C2" },
                new String[] { "CT3","41.5333","-8.4167","C3" },
                new String[] { "CT15","41.7","-8.8333","C4" },
                new String[] { "CT16","41.3002","-7.7398","C5" },
                new String[] { "CT12","41.1495","-8.6108","C6" },
                new String[] { "CT7","38.5667","-7.9","C7" },
                new String[] { "CT8","37.0161","-7.935","C8" },
                new String[] { "CT13","39.2369","-8.685","C9" },
                new String[] { "CT14","38.5243","-8.8926","E1" },
                new String[] { "CT11","39.3167","-7.4167","E2" },
                new String[] { "CT5","39.823","-7.4931","E3" },
                new String[] { "CT9","40.5364","-7.2683","E4" },
                new String[] { "CT4","41.8","-6.75","E5" },
                new String[] { "CT17","40.6667","-7.9167","P1" },
                new String[] { "CT6","40.2111","-8.4291","P2" },
                new String[] { "CT10","39.7444","-8.8072","P3" }
        );

        final int expected2 = expected1 + dataSet.size();

        this.parser.parse(dataSet);
        assertEquals(expected2, this.app.userStore().size());



        // duplicate entries
        dataSet = Arrays.asList(
                new String[] { "CT6","40.2111","-8.4291","P2" },
                new String[] { "CT10","39.7444","-8.8072","P3" }
        );

        this.parser.parse(dataSet);

        // size shouldn't have changed
        assertEquals(expected2, this.app.userStore().size());


        // fresh entries
        dataSet = Arrays.asList(
                new String[] { "CT46","41.4039","-8.769","C73" },
                new String[] { "CT159","41.2077","-8.6674","E90" }

        );

        final int expected3 = expected2 + dataSet.size();

        this.parser.parse(dataSet);
        // Now it should be different
        assertEquals(expected3, this.app.userStore().size());
    }
}
