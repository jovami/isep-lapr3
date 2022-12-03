package jovami.ui;

import jovami.handler.TopNCompaniesHandler;
import jovami.util.io.InputReader;

public class TopNCompaniesUI implements UserStory{

    private final TopNCompaniesHandler ctrl;

    public TopNCompaniesUI (){
        ctrl= new TopNCompaniesHandler();
    }

    @Override
    public void run() {

        int topNCompanies = InputReader.readInteger("Top n companies to be found:");
        ctrl.findCompaniesAverageWeight();
        ctrl.printTopNCompanies(topNCompanies);
    }


}
