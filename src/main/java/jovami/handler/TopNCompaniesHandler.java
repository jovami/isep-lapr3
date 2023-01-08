package jovami.handler;

import java.util.ArrayList;
import java.util.Comparator;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.shared.UserType;
import jovami.util.Pair;

/**
 * TopNCompaniesHandler
 */
public class TopNCompaniesHandler {

    private final HubNetwork mapGraph;

    /**
     * The Companies by order.
     */
    final ArrayList<Pair<User,Double>> companiesByOrder = new ArrayList<>();

    /**
     * Instantiates a new Top n companies handler.
     */
    public TopNCompaniesHandler(){
        App app = App.getInstance();
        mapGraph = app.hubNetwork();
    }

    private static final Comparator <Pair<User,Double>> cmpDist = Comparator.comparingDouble(Pair::second);


    /**
     * Find companies average weight array list.
     *
     * @return the array list
     */
    public ArrayList<Pair<User,Double>> findCompaniesAverageWeight (){

        ArrayList<Distance> dists = new ArrayList<>();

        for (User user : mapGraph.vertices()) {     // O(V)

            if(user.getUserType()==UserType.COMPANY){

                //paths & dists are being cleared at Algorithms.shortestPaths()
                mapGraph.shortestPaths(user, dists);    // O(V^2)

                //for each path
                Double average = getAverageAllPaths( dists); // O(E)

                companiesByOrder.add(new Pair<>(user,average)); // O(1)

            }
        }
        orderCompanies();   // O(V*logV)
        return getList();   // O(V)
        // Net complexity:  O(V^3)
    }

    private void orderCompanies(){
        if (companiesByOrder.isEmpty())
            throw new ArrayIndexOutOfBoundsException("List with companies and correspondent weights is empty");
        else
            companiesByOrder.sort(cmpDist);     // O(V*logV)
    }

    /**
     * Get list array list.
     *
     * @return the array list
     */
    protected ArrayList<Pair<User,Double>> getList(){
        // O(V)
        return new ArrayList<>(companiesByOrder);
    }

    private Double getAverageAllPaths(ArrayList<Distance> dists)
    {
        int soma = 0;

        for (Distance pathsDist: dists) {       // O(E)
            soma += pathsDist.getDistance();
        }

        // Net complexity: O(E)
        return (double) soma / dists.size();
    }

    /**
     * Get top n companies array list.
     *
     * @param n the n
     * @return the array list
     */
    protected ArrayList<Pair<User,Double>> getTopNCompanies(int n){
        ArrayList<Pair<User,Double>> topN = new ArrayList<>();

        if(companiesByOrder.size() < n || n <=0){
            return null;
        }

        int counter=0;

        for (Pair<User,Double> pair : companiesByOrder) { // O(V)

            topN.add(pair);
            counter++;
            if(counter==n)
                break;
        }

        // Net complexity: O(V)
        return topN;
    }


    /**
     * Print top n companies boolean.
     *
     * @param n the n
     */
    public void printTopNCompanies(int n){
        ArrayList<Pair<User,Double>> topN = getTopNCompanies(n);

        System.out.printf("Top %d companies\n", n);
        if(topN==null){
            System.out.println("There are no companies for the specified parameters");
            return;
        }
        int place=1;

        System.out.println("\n||  Top  || Company || Average weight");
        for (Pair<User,Double> pair : topN) {
            System.out.printf("||  %3d  ||   %3s   ||  %.2f\n",place,pair.first().getUserID(),pair.second());
            place++;
        }

    }
}
