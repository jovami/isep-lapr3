package jovami.ui;

import jovami.handler.IsConnectedHandler;
import jovami.ui.UserStory;

public class IsConnectedUI implements UserStory {

    private IsConnectedHandler handler;

    public IsConnectedUI() {
        this.handler = new IsConnectedHandler();
    }

    @Override
    public void run() {
        var transitiveClosure = handler.minReachability();

        if (transitiveClosure.isPresent()){
            System.out.println("The loaded graph is connected !!");
            System.out.println("Minimum needed connections for any client/producer to contact another: " + transitiveClosure.get());
        }else{
            System.out.println("The loaded graph is not connected !!");
        }
    }
}