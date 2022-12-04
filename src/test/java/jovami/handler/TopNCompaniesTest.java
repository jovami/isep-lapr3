package jovami.handler;
import jovami.MainTest;
import jovami.handler.data.TopNCompaniesData;
import jovami.model.User;
import jovami.util.Pair;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import java.util.Arrays;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;


public class TopNCompaniesTest {
    TopNCompaniesHandler handler ;

    @BeforeEach
    public void setup(){
        
        MainTest.resetSingleton();
        TopNCompaniesData.loadData();
        new CSVLoaderHandler().populateNetwork();
        handler = new TopNCompaniesHandler();
        handler.findCompaniesAverageWeight();
        
    }
    @Test
    public void testGet(){
        var companies = Arrays.asList("E3","E4","E2","E1","E5");
        var weights = Arrays.asList(187639.47d,199083.00d,203407.06d,249698.29d,288307.65d);
        var list = handler.getList();
        
        int i = 0;
        for (Pair<User,Double> company :list) {
            assertEquals(company.first().getUserID(),companies.get(i));
            assertEquals(company.second(),weights.get(i),0.1d);
            i++;
        }

    }

    @Test
    public void testGetTopN(){
        var companies = Arrays.asList("E3","E4","E2");
        var weights = Arrays.asList(187639.47d,199083.00d,203407.06d);

        int n = 3;
        int i = 0;
        for (Pair<User,Double> company : handler.getTopNCompanies(n)) {
            assertEquals(company.first().getUserID(),companies.get(i));
            assertEquals(company.second(),weights.get(i),0.1d);
            i++;
        }

    }
    
    @Test
    public void testGetTopNzero(){
        int n = 0;
        assertNull(handler.getTopNCompanies(n));

    }

    @Test
    public void testGetTopNNeg(){
        int n = -3;
        assertNull(handler.getTopNCompanies(n));

    }

    @Test
    public void testGetTopNBiggerThanListSize(){
        int n = 10;
        assertNull(handler.getTopNCompanies(n));
    }


}
