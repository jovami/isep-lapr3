package jovami.ui;

import jovami.handler.ExpListNProducersHandler;
import jovami.model.shared.ExpListPrint;
import jovami.util.io.InputReader;


public class ExpListNProducersUI implements UserStory {


    public ExpListNProducersUI() {
    }

    @Override
    public void run() {
        ExpListNProducersHandler handler = new ExpListNProducersHandler();
        int nProd = InputReader.readInteger("Closest N producers to hub:");

        try {
            var exp = handler.expListNProducers(nProd);
            int maxDay = handler.checkHigherDay(exp);

            int day;
            day = InputReader.readInteger("Day for expedition list:");
            while (day < 1 || day > maxDay){
                System.out.println("The day should be higher than 1 and less than " + (maxDay + 1));
                day = InputReader.readInteger("Day for expedition list:");
            }

            var expList = exp.get(day);
            System.out.println("Day: " + day + " | " + "Closest " + nProd + " producers to the hubs");
            expList.forEach(ExpListPrint::bundlePrint);

        } catch (Exception e) {
            System.err.println("Aborting...");
            throw new RuntimeException(e);
        }
    }


}
