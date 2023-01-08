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
 * DistanceParserTest
 */
public class DistanceParserTest {

    private DistanceParser parser;
    private App app;

    @BeforeEach
    void setup() {
        MainTest.resetSingleton();
        this.parser = new DistanceParser();
        this.app = App.getInstance();
    }

    @Test
    void parseNothing() {
        final int size = 0;

        this.parser.parse(new LinkedList<>());

        assertEquals(size, this.app.distanceStore().size());
    }

    @Test
    void parseBadLength() {
        var dataSet = Arrays.asList(
            new String[] { "CT43", "CT20", "asdf"   }, // not a number
            new String[] { "CT49", "CT1",  "91.10"  }, // floating point distance
            new String[] { "CT49", "CT1",  "-1271"  }  // negative distance
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

        assertEquals(size, this.app.distanceStore().size());
    }

    @Test
    void parseCorrect() {
        // Extracted from Big file
        var dataSet = Arrays.asList(
                new String[] { "CT39","CT137","9485" },
                new String[] { "CT39","CT74","9842" },
                new String[] { "CT39","CT7","11460" },
                new String[] { "CT39","CT266","12153" },
                new String[] { "CT199","CT72","15846" },
                new String[] { "CT199","CT272","16168" },
                new String[] { "CT199","CT258","16649" },
                new String[] { "CT199","CT187","19324" },
                new String[] { "CT199","CT68","19629" },
                new String[] { "CT198","CT114","6341" },
                new String[] { "CT198","CT3","8615" },
                new String[] { "CT198","CT286","12034" },
                new String[] { "CT198","CT160","17635" },
                new String[] { "CT197","CT323","6123" },
                new String[] { "CT197","CT265","17873" },
                new String[] { "CT197","CT41","25065" },
                new String[] { "CT197","CT292","25469" },
                new String[] { "CT196","CT292","7241" },
                new String[] { "CT196","CT252","7696" },
                new String[] { "CT196","CT104","13910" },
                new String[] { "CT195","CT150","8943" },
                new String[] { "CT195","CT129","9712" },
                new String[] { "CT195","CT35","10631" }
        );

        final int expected1 = dataSet.size();

        this.parser.parse(dataSet);

        assertEquals(expected1, this.app.distanceStore().size());

        // Extracted from Small file
        dataSet = Arrays.asList(
                new String[] { "CT10","CT13","63448" },
                new String[] { "CT10","CT6","67584" },
                new String[] { "CT10","CT1","110848" },
                new String[] { "CT10","CT5","125041" },
                new String[] { "CT12","CT3","50467" },
                new String[] { "CT12","CT1","62877" },
                new String[] { "CT12","CT15","70717" },
                new String[] { "CT11","CT5","62655" },
                new String[] { "CT11","CT13","121584" },
                new String[] { "CT11","CT10","142470" },
                new String[] { "CT14","CT13","89813" },
                new String[] { "CT14","CT7","95957" },
                new String[] { "CT14","CT2","114913" },
                new String[] { "CT14","CT8","207558" },
                new String[] { "CT13","CT7","111686" },
                new String[] { "CT16","CT3","68957" },
                new String[] { "CT16","CT17","79560" },
                new String[] { "CT16","CT12","82996" },
                new String[] { "CT16","CT9","103704" },
                new String[] { "CT16","CT4","110133" },
                new String[] { "CT15","CT3","43598" },
                new String[] { "CT17","CT9","62879" },
                new String[] { "CT17","CT1","69282" },
                new String[] { "CT17","CT6","73828" },
                new String[] { "CT1","CT6","56717" },
                new String[] { "CT2","CT7","65574" },
                new String[] { "CT2","CT8","125105" },
                new String[] { "CT2","CT11","163996" },
                new String[] { "CT4","CT3","157223" },
                new String[] { "CT4","CT9","162527" },
                new String[] { "CT5","CT9","90186" },
                new String[] { "CT5","CT6","100563" },
                new String[] { "CT5","CT17","111134" }
        );

        final int expected2 = expected1 + dataSet.size();

        this.parser.parse(dataSet);
        assertEquals(expected2, this.app.distanceStore().size());



        // duplicate entries
        dataSet = Arrays.asList(
                new String[] { "CT5","CT6","100563" },
                new String[] { "CT5","CT17","111134" }
        );

        this.parser.parse(dataSet);

        // size shouldn't have changed
        assertEquals(expected2, this.app.distanceStore().size());


        // fresh entries
        dataSet = Arrays.asList(
                new String[] { "CT206","CT294","15628" },
                new String[] { "CT65","CT10","23403" }
        );

        final int expected3 = expected2 + dataSet.size();

        this.parser.parse(dataSet);
        // Now it should be different
        assertEquals(expected3, this.app.distanceStore().size());
    }
}
