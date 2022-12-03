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
        uis.add(new CSVLoaderUI());
        uis.add(new IsConnectedUI());
        uis.add(new TopNCompaniesUI());
        uis.add(new NearestHubToClientsUI());
        uis.add(new MinimumDistanceUI());
        uis.add(new WateringControllerUI());

        uis.forEach(ui -> {
            var name = ui.getClass().getSimpleName();

            System.out.printf("%s\n%s\n", name, "=".repeat(name.length()));
            ui.run();
            System.out.println();
        });
    }
}
