#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "sensor_vec.h"
#include "util.h"
#include "export_csv.h"
#include "sensor_impl.h"
#include "sensor_impl.h"


void 
export_sensor_data(const sensor_vec *sensors) {
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

    /* Write sensor readings */
    for (size_t i = 0; i < sensors->len; i++) {
        const Sensor *sensor = &sensors->data[i];
        const char *sensor_type = strsens(sensor->sensor_type);
        fprintf(fp, "%s", sensor_type);

        for (size_t j = 0; j < sensor->len; j++) {
            fprintf(fp, "%hu;", sensor->readings[j]);
        }
        fprintf(fp, "\n");
    }
    fclose(fp);
}