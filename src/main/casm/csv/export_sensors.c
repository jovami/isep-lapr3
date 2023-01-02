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
    snprintf(filename, sizeof(filename), "sensors_data_%s.csv", date);
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
    for (enum SensorType i = 0; i < SENS_LAST; i++) {
        const sensor_vec *temp = sensors+i;
        const size_t length = temp->len;

        for (size_t j = 0; j < length; j++) {
            const Sensor *sensor = &temp->data[j];
            const char *sensor_type = strsens(sensor->sensor_type);
            const size_t length1 = sensor->len;
            fprintf(fp, "%s (%ld)", sensor_type,j+1);

            for (size_t k = 0; k < length1; k++) {
                fprintf(fp, ";%hu", sensor->readings[k]);
            }
            fprintf(fp, "\n");
        }
    }
    fclose(fp);
}
