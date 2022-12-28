package jovami;

import java.util.LinkedList;
import java.util.List;

import jovami.ui.*;

/**
 * Main
 */
public class Main {

    public static void main(String[] args) {
        /* Init App */
        App.getInstance();

        List<UserStory> uis = new LinkedList<>();
        uis.add(new CSVLoaderUI());             //US301
        uis.add(new IsConnectedUI());           //US302
        uis.add(new TopNCompaniesUI());         //US303
        uis.add(new NearestHubToClientsUI());   //US304
        uis.add(new MinimumDistanceUI());       //US305
        uis.add(new ExpListNProducersUI());
        uis.add(new WateringControllerUI());    //US306

        uis.forEach(ui -> {
            var name = ui.getClass().getSimpleName();

            System.out.printf("%s\n%s\n", name, "=".repeat(name.length()));
            ui.run();
            System.out.println();
        });
    }
}
