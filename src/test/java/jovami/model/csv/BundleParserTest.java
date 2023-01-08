package jovami.model.csv;

import jovami.App;
import jovami.MainTest;
import jovami.handler.data.TopNCompaniesData;
import jovami.model.exceptions.InvalidCSVFileException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.LinkedList;

import static org.junit.jupiter.api.Assertions.*;

class BundleParserTest {

    private BundleParser parser;
    private App app;

    @BeforeEach
    void setup() {
        MainTest.resetSingleton();
        TopNCompaniesData.loadData();

        this.parser = new BundleParser();
        this.app = App.getInstance();
    }

    @Test
    void parseNothing() {
        final int size = 0;

        this.parser.parse(new LinkedList<>());

        assertEquals(size, this.app.bundleStore().size());
    }

    @Test
    void testParsingWithInvalidUser(){
        var dataSet = Arrays.asList(
                new String[] { "\"C1000\"","1","0","0","0","0","5","2","0","0","0","0","2.5","0"     }, // user does not exist
                new String[] { "\"C31048\"","1","0","5.5","4.5","0","4","0","0","0","1","9","10","0" }, // user does not exist
                new String[] { "\"L3\"","2","10","0","0","0","9","2.5","0","0","4.5","0","0","0"     }, // user does not exist
                new String[] { "\"Y4\"","1","0","0","0","0","0","0","0","0","0","0","0","0"          }, // user does not exist
                new String[] { "\"CC\"","3","0","6.5","9.5","3","0","9.5","0","6","5","7.5","0","5"  }, // user does not exist
                new String[] { "\"F1\"","1","0","7.5","9","2","6","0","8.5","3","3.5","9","1","0"    }, // user does not exist
                new String[] { "\"AA\"","2","0","0","2.5","0","5","7.5","8.5","0","3","0","0","8.5"  }  // user does not exist
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

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(3));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(4));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(5));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(6));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        assertEquals(size, this.app.bundleStore().size());
    }

    @Test
    void testParsingWithInvalidDay(){

        var dataSet = Arrays.asList(
                new String[] { "\"C1\"","-1","0","0","0","0","5","2","0","0","0","0","2.5","0"      }, // negative day
                new String[] { "\"C2\"","aaa","0","5.5","4.5","0","4","0","0","0","1","9","10","0"  }, // aaa value
                new String[] { "\"C3\"","-20","10","0","0","0","9","2.5","0","0","4.5","0","0","0"  }, // negative day
                new String[] { "\"C4\"","-500","0","0","0","0","0","0","0","0","0","0","0","0"      }, // negative day
                new String[] { "\"E1\"","0","0","6.5","9.5","3","0","9.5","0","6","5","7.5","0","5" }  // zero day
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

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(3));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(4));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        assertEquals(size, this.app.bundleStore().size());
    }

    @Test
    void testParsingWithInvalidQuantity(){

        var dataSet = Arrays.asList(
                new String[] { "\"C1\"","1","0","-20","0","0","5","2","0","-30","0","0","2.5","0"       }, // negative quantity values
                new String[] { "\"C2\"","1","-1","5.5","4.5","0","4","0","0","0","1","9","10","0"       }, // negative quantity values
                new String[] { "\"C3\"","2","10","0","0","0","9","-2.5","0","0","4.5","0","0","0"       }, // negative quantity values
                new String[] { "\"C4\"","1","0","aaa","0","0","0","0","0","0","0","0","0","0"           }, // aaa value
                new String[] { "\"E1\"","3","0","6.5","9.5","3","0","-9.5","0","6","5","-7.5","0","-5"  }, // negative quantity values
                new String[] { "\"P1\"","1","0","7.5","9","-2","6","0","8.5","3","3.5","9","1","0"      }, // negative quantity values
                new String[] { "\"P1\"","2","0","0","2.5","0","5","7.5","8.5","0","3","0","0","aaa"     }  // aaa value
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

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(3));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(4));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(5));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        {
            var data = new LinkedList<String[]>();
            data.push(dataSet.get(6));

            assertThrows(InvalidCSVFileException.class, () -> this.parser.parse(data));
        }

        assertEquals(size, this.app.bundleStore().size());
    }

    @Test
    void parseCorrect() {

        //Retrieved from the small bundles file
        var dataSet = Arrays.asList(
                new String[]{"\"C1\"", "1", "0", "20", "0", "0", "5", "2", "0", "30", "0", "0", "2.5", "0"},
                new String[]{"\"C2\"", "1", "1", "5.5", "4.5", "0", "4", "0", "0", "0", "1", "9", "10", "0"},
                new String[]{"\"C3\"", "2", "0", "0", "0", "0", "9", "2.5", "0", "0", "4.5", "0", "0", "0"},
                new String[]{"\"C4\"", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"\"C7\"", "3", "0", "0", "0", "5.5", "0", "0", "3.5", "3", "0", "0", "0", "10"},
                new String[]{"\"E1\"", "3", "0", "6.5", "9.5", "3", "0", "9.5", "0", "6", "5", "7.5", "0", "5"},
                new String[]{"\"P1\"", "1", "0", "7.5", "9", "2", "6", "0", "8.5", "3", "3.5", "9", "1", "0"},
                new String[]{"\"P1\"", "2", "0", "0", "2.5", "0", "5", "7.5", "8.5", "0", "3", "0", "0", "8.5"},
                new String[]{"\"P2\"", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"\"P2\"", "2", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"\"P2\"", "3", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"\"P2\"", "4", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"},
                new String[]{"\"P1\"", "1", "0", "7.5", "9", "2", "6", "0", "8.5", "3", "3.5", "9", "1", "0"},
                new String[]{"\"P1\"", "2", "0", "0", "2.5", "0", "5", "7.5", "8.5", "0", "3", "0", "0", "8.5"}
        );
        this.parser.parse(dataSet);

        /*
         * Assert number of days
         */
        var expected1 = 3;
        var actual1 = this.app.bundleStore().size();
        assertEquals(expected1, actual1);

        /*
         * Assert number of bundles
         */
        var expected2 = 6;
        var actual2 = this.app.bundleStore().getBundles(1).size()
                + this.app.bundleStore().getBundles(2).size()
                + this.app.bundleStore().getBundles(3).size();
        assertEquals(expected2, actual2);

        var freshData = Arrays.asList(
                new String[]{"\"C5\"", "4", "0", "20", "0", "0", "5", "2", "0", "30", "0", "0", "2.5", "0"},
                new String[]{"\"C6\"", "5", "1", "5.5", "4.5", "0", "4", "0", "0", "0", "1", "9", "10", "0"}
        );

        this.parser.parse(freshData);

        /*
         * Assert number of days (Values should change)
         */
        var expected3 = 5;
        var actual3 = this.app.bundleStore().size();
        assertEquals(expected3, actual3);

        /*
         * Assert number of bundles (Values should change)
         */
        var expected4 = 8;
        var actual4 = this.app.bundleStore().getBundles(1).size()
                + this.app.bundleStore().getBundles(2).size()
                + this.app.bundleStore().getBundles(3).size()
                + this.app.bundleStore().getBundles(4).size()
                + this.app.bundleStore().getBundles(5).size();
        assertEquals(expected4, actual4);
    }
}