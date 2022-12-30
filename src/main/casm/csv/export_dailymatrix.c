#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#include "export_csv.h"
#include "util.h"

#define NUM_ROWS    6
#define NUM_COLS    3

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

void    
export_dailymatrix(union matrix_value matrix[NUM_ROWS][NUM_COLS])
{
    const union matrix_value *p = &matrix[0][0];
    FILE *fp;

    char filename[100] = "dailymatrix";
    strcat(filename, get_date());
    strcat(filename, ".csv");

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
            fprintf(fp, "%d", (p+i)->i);
        else
            fprintf(fp, "%u", (p+i)->ui);
    }
    fclose(fp);
}

