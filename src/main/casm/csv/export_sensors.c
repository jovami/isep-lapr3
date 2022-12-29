#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "util.h"
#include "export_csv.h"
#include "sensor_impl.h"

char *get_date() {
    // Get the current time
    time_t t = time(NULL);
    struct tm tm = *localtime(&t);

    // Allocate a buffer large enough to hold the formatted string
    char *date = arqcp_malloc(11, 1);

    // Format the date string using strftime and add a null terminator
    strftime(date, 11, "%Y-%m-%d", &tm);
    date[10] = '\0';

    return date;
}

void 
export_sensor_data(const Sensor *sensors, int num_sensors) {
    FILE *fp;

    // Create the filename string in one step using snprintf
    char filename[100];
    char *date = get_date();
    snprintf(filename, sizeof(filename), "sensor_data_%s.csv", date);
    free(date);

    fp = fopen(filename, "w"); // Creates an empty file for writing

    /**
    * This if statement is not necessary, but it is a good practice to check
    */
    if (fp == NULL)
    {
        printf("Can't open file %s!", filename);
        exit(1);
    }

    /* Write header row with sensor names */
    fprintf(fp, "Sensor Type");
    for (int i = 0; i < num_sensors; i++) {
        fprintf(fp, ",%s", strsens(sensors[i].sensor_type));
    }
    fprintf(fp, "\n");

    /* Find maximum number of readings among all sensors */
    int max_readings = 0;
    for (int i = 0; i < num_sensors; i++) {
        if (sensors[i].len > max_readings) {
            max_readings = sensors[i].len;
        }
    }

    /* Write rows with sensor readings */
    for (int i = 0; i < max_readings; i++) {
        fprintf(fp, "%d", i);
        for (int j = 0; j < num_sensors; j++) {
            if (i < sensors[j].len) {
                fprintf(fp, ",%hu", sensors[j].readings[i]);
            } else {
                fprintf(fp, ",");   /* Empty cell */
            }
        }
        fprintf(fp, "\n");
    }

    fclose(fp);
}