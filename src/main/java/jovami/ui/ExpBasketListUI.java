package jovami.ui;

import jovami.handler.ExpBasketListHandler;
import jovami.model.shared.ExpListPrint;
import jovami.util.io.InputReader;

public class ExpBasketListUI implements UserStory {

    private final ExpBasketListHandler handler;


    public ExpBasketListUI() {
        this.handler = new ExpBasketListHandler();
    }

    @Override
    public void run() {
        int day = InputReader.readInteger("Day for expedition list:");

        try{
            var expList = handler.expBasketsList().get(day);

            expList.forEach(ExpListPrint::bundlePrint);

        }catch (Exception e){
            System.err.println("Aborting...");
            throw new RuntimeException(e);
        }
    }
}
