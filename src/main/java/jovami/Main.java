package jovami;

import java.util.LinkedList;
import java.util.List;

import jovami.ui.*;

/**
 * Main
 */
public class Main {

    public static void main(String[] args) {
        /* Init App */
        App.getInstance();

        List<Runnable> uis = new LinkedList<>();
        uis.add(new CSVLoaderUI());

        uis.forEach(ui -> {
            // TODO: make this prettier
            System.out.printf("<----- %s ----->\n", ui.getClass().getSimpleName());
            ui.run();
            System.out.println();
        });
    }
}
