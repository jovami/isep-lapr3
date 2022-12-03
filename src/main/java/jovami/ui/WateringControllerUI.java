package jovami.ui;

import jovami.handler.WateringControllerHandler;
import jovami.util.io.InputReader;

/**
 * WateringControllerUI
 */
public class WateringControllerUI implements UserStory {

    private WateringControllerHandler handler;

    public WateringControllerUI() {
        this.handler = new WateringControllerHandler();
    }

    @Override
    public void run() {
        try {
            if (InputReader.confirm("Load default files?", true))
                this.handler.loadDefault();
            else
                this.handler.loadFile(InputReader.getFile("Insert the path to the watering controller data file:"));
        } catch (Exception e) {
            System.err.println("Aborting...");
            throw new RuntimeException(e);
        }

        System.out.println("Data loaded with success!!");

        var watering = this.handler.currentlyWatering();

        if (!watering.isEmpty()) {
            System.out.println("Plots being watered:");

            System.out.println("Plots || Time left");
            watering.forEach(pair -> {
                System.out.printf("%5s || %dmin\n", pair.first(), pair.second());
            });
        } else {
            System.out.println("No plots are currently being watered.");
        }
    }
}
