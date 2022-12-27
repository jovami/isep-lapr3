package jovami.model.csv;

import jovami.App;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.Product;
import jovami.model.exceptions.InvalidCSVFileException;
import jovami.model.store.BundleStore;
import jovami.model.store.ProductStore;
import jovami.model.store.StockStore;
import jovami.model.store.UserStore;

import java.util.List;


/**
 * BundleParser is responsible for parsing CSV data related to bundles and adding
 * the resulting bundles or product stock updates to the relevant stores.
 */
public class BundleParser implements CSVParser {
    private final App app;
    private final ProductStore productStore;
    private final StockStore stockStore;
    private final BundleStore bundleStore;
    private final UserStore userStore;

    // Constants for throwing exceptions with pre-initialized messages
    private static final InvalidCSVFileException INVALID_USER_EXCEPTION = new InvalidCSVFileException("The provided CSV File contains an invalid user!!");
    private static final InvalidCSVFileException INVALID_DAY_EXCEPTION = new InvalidCSVFileException("The provided CSV File contains an invalid day!!");

    private enum BundleColumns {
        USER_ID(0),
        DAY(1),
        FIRST_PROD(2);

        private final int col;
        BundleColumns(int col) {
            this.col = col;
        }
    }

    /**
     * Instantiates a new Bundle parser.
     */
    public BundleParser() {
        this.app = App.getInstance();
        this.productStore = app.productStore();
        this.stockStore = app.stockStore();
        this.bundleStore = app.bundleStore();
        this.userStore = app.userStore();
    }

    /**
     * Time complexity: O(l * p) where l is the number of lines in the CSV data and p is the number of products in each line.
     */
    @Override
    public void parse(List<String[]> data) {
        var len = data.get(0).length;
        int numberOfProducts = len-BundleColumns.FIRST_PROD.col;
        String[] product = new String[numberOfProducts];

        // add all products to app.productStore()
        // O(p); p => number of products
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= numberOfProducts; i++){
            sb.setLength(0);
            product[i-1] = sb.append("Prod").append(i).toString();
            productStore.addProduct(new Product(product[i-1]));
        }

        // O(l*p); l => each line of the file, p => number of products in each line
        data.forEach(line -> {
            var optUser = userStore.getUserByID(line[BundleColumns.USER_ID.col].replaceAll("\"", ""));

            // checks if user is present
            User user = optUser.orElseThrow(() -> INVALID_USER_EXCEPTION);
            int day;
            try {
                day = Integer.parseInt(line[BundleColumns.DAY.col]);
            } catch (NumberFormatException e) {
                throw INVALID_DAY_EXCEPTION;
            }

            switch (user.getUserType()) {
                // O(p); p => number of products
                case PRODUCER -> parseProducerLine(line, product,len,user,day);
                // O(p); p => number of products
                case CLIENT -> parseClientLine(line, product, len, user, day);
            }
        });
        System.out.println();
    }

    private void parseProducerLine(String[] line, String[] product, int len, User user, int day) {
        stockStore.addProducer(user);
        var stock = stockStore.getStock(user);

        // O(p); p => number of products
        for (int i = BundleParser.BundleColumns.FIRST_PROD.col; i < len; i++) {
            float quantity = Float.parseFloat(line[i]);
            int productIndex = i - BundleParser.BundleColumns.FIRST_PROD.col;

            if (quantity != 0)
                stock.addProductStock(productStore.getProduct(product[productIndex]), quantity, day);
        }
    }

    private void parseClientLine(String[] line, String[] product, int len, User user, int day) {
        var bundle = new Bundle(user, day);

        // O(p); p => number of products
        for (int i = BundleParser.BundleColumns.FIRST_PROD.col; i < len; i++) {
            float quantity = Float.parseFloat(line[i]);
            int productIndex = i - BundleParser.BundleColumns.FIRST_PROD.col;

            if (quantity != 0)
                bundle.addNewOrder(productStore.getProduct(product[productIndex]), quantity);
        }
        bundleStore.addBundle(bundle);
    }
}
