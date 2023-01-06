package jovami.ui;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import jovami.handler.ExpListStatsHandler;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.shared.UserType;
import jovami.model.store.ExpListStore.Restriction;
import jovami.util.io.InputReader;

public class ExpListStatsUi implements UserStory{
    ExpListStatsHandler handler;
    private final List<Restriction> restrictions;
    // Restriction[] restrictions = Restriction.values();


    public ExpListStatsUi(){
        handler = new ExpListStatsHandler();
        this.restrictions = Arrays.asList(Restriction.values());
    }

    @Override
    public void run(){
        //showing statistics to the 4 types

        //for which type expedition list



        ExpList expList;
        do {
            int i = InputReader.showAndSelectIndex(this.restrictions,
                                                   "Types of expedition lists:");
            expList = this.handler.getExpList(this.restrictions.get(i));
        } while (expList == null);



        //client
        User client;
        System.out.println("Calculating stats related to client:");
        do{
            client=handler.getUser(InputReader.readLine("Cient id: "));
        }while(client==null||client.getUserType()!=UserType.CLIENT);
        handler.clientStats(client, expList);


        //producer
        User producer;
        System.out.println("Calculating stats related to producer:");
        do{
            producer=handler.getUser(InputReader.readLine("Producer id: "));
        }while(producer==null || producer.getUserType()!=UserType.PRODUCER);
        handler.producerStats(producer, expList);

        System.out.println("Calculating stats related to hub:");
        //hub
        User hub;
        do{
            hub=handler.getUser(InputReader.readLine("Hub id: "));
        }while(hub==null || hub.getUserType()!=UserType.COMPANY);
        handler.hubStats(hub, expList);


        //bundle
        Bundle bun=null;
        System.out.println("Calculating stats related to bundle:");
        do{
            //pedir o dia
            ArrayList<Bundle> arr;
            do {
                int day=InputReader.readInteger("Day: ");
                arr=expList.getBundleStore().getBundles(day);
                if(arr==null)
                    System.out.println("\t Warning: There are no bundles for day: " + day);
            } while (arr==null);




            //pedir o cliente
            User clientBun;
            do{
                clientBun=handler.getUser(InputReader.readLine("Cient id"));
            }while(clientBun==null||clientBun.getUserType()!=UserType.CLIENT);


        }while(bun==null);
    }



}
