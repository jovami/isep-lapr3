#import <stdio.h>
#import <stdlib.h>

#import "export_csv.h"

enum {
    TEMP_ROW,
    DIR_VENTO_ROW,
    VELC_VENTO_ROW,
    HUMD_ATM_ROW,
    HUMD_SOLO_ROW,
    PLUVIO_ROW,
}; /* matrix rows */

void export_dailymatrix(int matrix[6][3], char *filename)
{
    int row, column;
    FILE *fp;
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
    //TODO: optimize this for loop
    for (row = 0; row < 6; row++)
    {
        switch(row){
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

        for (column = 0; column < 3; column++)
        {
            fprintf(fp, "%d", matrix[row][column]);
            if (column < 2) // Prevents a ";" at the end of each line
                fprintf(fp, ";");
        }
        fprintf(fp, "\n");
    }
    fclose(fp);
}

