package jovami.ui;

import jovami.handler.NearestHubToClientsHandler;

/**
 * US304
 */
public class NearestHubToClientsUI implements UserStory {

    private final NearestHubToClientsHandler handler;

    public NearestHubToClientsUI() {
        this.handler = new NearestHubToClientsHandler();
    }

    @Override
    public void run() {
        System.out.println("Computing nearest Hub for each customer.");
        System.out.println("Please Wait...");

        try{
            var nearestHubs = handler.findNearestHubs();

            nearestHubs.forEach(a -> System.out.println("Client: " + a.first().getUserID()
                                                        + " | Nearest Hub: " + a.second().getUserID()
                                                        + " | Distance: " + a.third().getDistance()
                                                        + "m"));
        }catch (Exception e){
            System.err.println("Aborting...");
            throw new RuntimeException(e);
        }
    }
}
