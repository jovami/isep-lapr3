package jovami.model.csv;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import jovami.App;
import jovami.model.exceptions.InvalidCSVFileException;
import jovami.model.shared.WateringFrequency;
import jovami.util.Triplet;

/**
 * WateringControllerParser
 */
public class WateringControllerParser implements CSVParser {

    private static final int CYCLES_LINENO = 0;
    private static final int PLOT_DATA_START = CYCLES_LINENO + 1;

    private final String timeFmt;

    public WateringControllerParser() {
        this("H:mm");
    }

    public WateringControllerParser(String timeFormat) {
        this.timeFmt = timeFormat;
    }

    private enum PlotColumns {
        PLOT(0),
        DURATION(1),
        FREQUENCY(2);

        final int col;
        PlotColumns(int col) {
            this.col = col;
        }
    }

	@Override
	public void parse(List<String[]> data)
    throws IndexOutOfBoundsException
    {
        if (data == null || data.isEmpty())
            throw new IllegalArgumentException("Data was empty!!");

        var fmt = DateTimeFormatter.ofPattern(timeFmt);

        List<LocalTime> times;
        try {
            times = Arrays.stream(data.get(CYCLES_LINENO))
                          .map(timeStr -> LocalTime.parse(timeStr, fmt))
                          .toList();
        } catch (DateTimeParseException e) {
            throw new InvalidCSVFileException("CSV File contained an invalid starting time");
        }

        var plotData = this.parsePlotData(data);

        App.getInstance().wateringControllerStore().addController(times, plotData);
	}

    private List<Triplet<String, Integer, WateringFrequency>>
    parsePlotData(List<String[]> data)
    {
        int len = data.size();
        var plotList = new ArrayList<Triplet<String, Integer, WateringFrequency>>(len-1);

        for (int i = PLOT_DATA_START; i < len; i++) {
            var line = data.get(i);

            String plot = line[PlotColumns.PLOT.col];

            int duration;
            try {
                duration = Integer.parseInt(line[PlotColumns.DURATION.col]);
            } catch (NumberFormatException e) {
                throw new InvalidCSVFileException(
                    String.format("File contained and invalid duration for plot %s: %s (line %d)",
                                  plot,
                                  line[PlotColumns.DURATION.col],
                                  i+1)
                );
            }

            WateringFrequency freq;
            try {
                var freqCol = line[PlotColumns.FREQUENCY.col];
                freq = WateringFrequency.getFrequency(freqCol.charAt(0));
            } catch (NullPointerException | IllegalArgumentException e) {
                throw new InvalidCSVFileException(
                    String.format("File contained no known frequency value on line %d", i+1)
                );
            }

            plotList.add(new Triplet<>(plot, duration, freq));
        }

        return plotList;
    }
}
