package jovami.handler;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.concurrent.atomic.AtomicInteger;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.shared.UserType;
import jovami.util.Pair;

public class TopNCompaniesHandler {

    private final App app;
    private final HubNetwork mapGraph;
    
    ArrayList<Pair<User,Double>> companiesByOrder = new ArrayList<>();
    
    public TopNCompaniesHandler(){
        app=App.getInstance();
        mapGraph = app.hubNetwork();
    }
    
    private static Comparator <Pair<User,Double>> cmpDist = new Comparator<Pair<User, Double>>() {
        @Override
        public int compare(final Pair<User, Double> o1, final Pair<User, Double> o2) {
            return Double.compare(o1.second(), o2.second());
        }
    };


    public ArrayList<Pair<User,Double>> findCompaniesAverageWeight (){

        ArrayList<Distance> dists = new ArrayList<>();

        for (User user : mapGraph.vertices()) {

            if(user.getUserType()==UserType.COMPANY){

                //paths & dists are being cleared at Algorithms.shortestPaths()
                mapGraph.shortestPaths(user, dists);

                //for each path
                Double average = getAverageAllPaths( dists);

                companiesByOrder.add(new Pair<>(user,average));
                
            }
        }
        orderCompanies();
        return getList();
    }

    private void orderCompanies(){
        if (companiesByOrder.isEmpty())
            throw new ArrayIndexOutOfBoundsException("List with companies and correspondent weights is empty");
        else
            companiesByOrder.sort(cmpDist);
    }

    protected ArrayList<Pair<User,Double>> getList(){
        return new ArrayList<>(companiesByOrder);
    }

    private Double getAverageAllPaths(ArrayList<Distance> dists) 
    {
        AtomicInteger somaForEach = new AtomicInteger(0);

        for (Distance pathsDist: dists) {
            somaForEach.addAndGet(pathsDist.getDistance());
        }

        return somaForEach.doubleValue()/dists.size();
    }
    
    protected ArrayList<Pair<User,Double>> getTopNCompanies(int n){
        ArrayList<Pair<User,Double>> topN = new ArrayList<>();

        if(companiesByOrder.size() < n || n <=0){
            return null;
        }

        int counter=0;

        for (Pair<User,Double> pair : companiesByOrder) {

            topN.add(pair);
            counter++;
            if(counter==n)
                break;
        }
        return topN;

    }


    public boolean printTopNCompanies(int n){
        ArrayList<Pair<User,Double>> topN = getTopNCompanies(n);

        System.out.printf("Top %d companies\n", n);
        if(topN==null){
            System.out.println("There are no companies for the specified parameters");
            return false;
        } 
        int place=1;

        System.out.println();
        System.out.println("||  Top  || Company || Average weight");
        for (Pair<User,Double> pair : topN) {
            System.out.printf("||  %3d  ||   %3s   ||  %.2f\n",place,pair.first().getUserID(),pair.second());           
            place++;
        }

        return true;

    }
}