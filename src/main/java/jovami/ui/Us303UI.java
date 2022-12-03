package jovami.ui;

import jovami.handler.TopNCompaniesHandler;
import jovami.util.io.InputReader;

public class Us303UI implements UserStory{

    private final TopNCompaniesHandler ctrl;

    public Us303UI (){
        ctrl= new TopNCompaniesHandler();
    }

    @Override
    public void run() {

        int topNCompanies = InputReader.readInteger("Top n companies to be found:");
        ctrl.findCompaniesAverageWeight();
        ctrl.printTopNCompanies(topNCompanies);
    }


}
