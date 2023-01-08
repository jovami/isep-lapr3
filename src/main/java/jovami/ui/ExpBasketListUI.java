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

        try{
            var exp = handler.expBasketsList();
            int maxDay = handler.checkHigherDay(exp);

            int day;
            day = InputReader.readInteger("Day for expedition list:");
            while (day < 1 || day > maxDay){
                System.out.println("The day should be higher than 1 and less than " + (maxDay + 1));
                day = InputReader.readInteger("Day for expedition list:");
            }

            var expList = handler.expBasketsList().get(day);

            expList.forEach(ExpListPrint::bundlePrint);

        }catch (Exception e){
            System.err.println("Aborting...");
            throw new RuntimeException(e);
        }
    }
}
