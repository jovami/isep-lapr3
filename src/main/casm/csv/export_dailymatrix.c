#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#include <export_csv.h>
#include <util.h>

enum {
    TEMP_ROW,
    DIR_VENTO_ROW,
    VELC_VENTO_ROW,
    HUMD_ATM_ROW,
    HUMD_SOLO_ROW,
    PLUVIO_ROW,
}; /* matrix rows */

enum {
    AVG_COL,
    MAX_COL,
    MIN_COL,
}; /* matrix cols */

#define NUM_ROWS    6
#define NUM_COLS    3

void
export_dailymatrix(unsigned short matrix[NUM_ROWS][NUM_COLS])
{
    const unsigned short *p = &matrix[0][0];
    FILE *fp;

    // Create the filename string in one step using snprintf
    char filename[100];
    char *date = get_date();
    snprintf(filename, sizeof(filename), "daily_matrix_data_%s.csv", date);
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
    fprintf(fp, "Sensor Type;Average;Maximum;Minimum\n");

    for (int i = 0; i < NUM_ROWS * NUM_COLS; i++) {
        if (!(i % NUM_COLS)){
            if(i)
                fprintf(fp, "\n");
            switch(i/NUM_COLS){
                case TEMP_ROW:
                    fprintf(fp, "Temperatura");
                    break;
                case DIR_VENTO_ROW:
                    fprintf(fp, "Direção vento");
                    break;
                case VELC_VENTO_ROW:
                    fprintf(fp, "Velocidade vento");
                    break;
                case HUMD_ATM_ROW:
                    fprintf(fp, "Humidade de atmosfera");
                    break;
                case HUMD_SOLO_ROW:
                    fprintf(fp, "Humidade de solo");
                    break;
                case PLUVIO_ROW:
                    fprintf(fp, "Pluviosidade");
                    break;

            }
        }

        if (i < NUM_COLS)
            fprintf(fp, ";%hhd", (signed char) *(p+i));
        else
            fprintf(fp, ";%hu", *(p+i));
    }
    fclose(fp);

    puts("Daily matrix exported with success!\n");
}

