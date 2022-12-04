#include <stdio.h>
#include <string.h>
#include <sensors.h>
#include <sensors_impl.h>

#define MAX(X, Y)   ((X) > (Y) ? (X) : (Y))
#define MIN(X, Y)   ((X) < (Y) ? (X) : (Y))

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

union matrix_value{
    int i;
    unsigned int ui;

};


void print_matrix(union matrix_value matrix[6][3]);

    void
daily_matrix(const char *data_temp, const unsigned short *data_dir_vento, const unsigned char *data_velc_vento,
        const unsigned char *data_humd_atm, const unsigned char *data_humd_solo, const unsigned char *data_pluvio)
{

    union matrix_value matrix[NUM_ROWS][NUM_COLS];
    memset(matrix, 0x00, NUM_ROWS * NUM_COLS * sizeof(**matrix));


    char temp_max, temp_min;
    temp_max = *data_temp;
    temp_min = *data_temp;

    unsigned short dir_vento_max, dir_vento_min;
    dir_vento_max = *data_dir_vento;
    dir_vento_min = *data_dir_vento;

    unsigned char velc_vento_max, velc_vento_min;
    velc_vento_max = *data_velc_vento;
    velc_vento_min = *data_velc_vento;

    unsigned char humd_atm_max, humd_atm_min;
    humd_atm_max = *data_humd_atm;
    humd_atm_min = *data_humd_atm;

    unsigned char humd_solo_max, humd_solo_min;
    humd_solo_max = *data_humd_solo;
    humd_solo_min = *data_humd_solo;

    unsigned char pluvio_max, pluvio_min;
    pluvio_max = *data_pluvio;
    pluvio_min = *data_pluvio;

    //TODO: optimize
    int i;
    for (i = 0; i < CYCLES; i++) {

        matrix[TEMP_ROW][AVG_COL].i += *(data_temp+i);
        matrix[DIR_VENTO_ROW][AVG_COL].ui += *(data_dir_vento+i);
        matrix[VELC_VENTO_ROW][AVG_COL].ui += *(data_velc_vento+i);
        matrix[HUMD_ATM_ROW][AVG_COL].ui += *(data_humd_atm+i);
        matrix[HUMD_SOLO_ROW][AVG_COL].ui += *(data_humd_solo+i);
        matrix[PLUVIO_ROW][AVG_COL].ui += *(data_pluvio+i);

        temp_max = MAX(temp_max, *(data_temp+i));
        temp_min = MIN(temp_min, *(data_temp+i));

        dir_vento_max = MAX(dir_vento_max, *(data_dir_vento+i));
        dir_vento_min = MIN(dir_vento_min, *(data_dir_vento+i));

        velc_vento_max = MAX(velc_vento_max, *(data_velc_vento+i));
        velc_vento_min = MIN(velc_vento_min, *(data_velc_vento+i));

        humd_atm_max = MAX(humd_atm_max, *(data_humd_atm+i));
        humd_atm_min = MIN(humd_atm_min, *(data_humd_atm+i));

        humd_solo_max = MAX(humd_solo_max, *(data_humd_solo+i));
        humd_solo_min = MIN(humd_solo_min, *(data_humd_solo+i));

        pluvio_max = MAX(pluvio_max, *(data_pluvio+i));
        pluvio_min = MIN(pluvio_min, *(data_pluvio+i));
    }

    /* averages */
    matrix[TEMP_ROW][AVG_COL].i /= i;
    matrix[DIR_VENTO_ROW][AVG_COL].ui /= i;
    matrix[VELC_VENTO_ROW][AVG_COL].ui /= i;
    matrix[HUMD_ATM_ROW][AVG_COL].ui /= i;
    matrix[HUMD_SOLO_ROW][AVG_COL].ui /= i;
    matrix[PLUVIO_ROW][AVG_COL].ui /= i;

    matrix[TEMP_ROW][MAX_COL].i = temp_max;
    matrix[TEMP_ROW][MIN_COL].i = temp_min;

    matrix[DIR_VENTO_ROW][MAX_COL].ui = dir_vento_max;
    matrix[DIR_VENTO_ROW][MIN_COL].ui = dir_vento_min;

    matrix[VELC_VENTO_ROW][MAX_COL].ui = velc_vento_max;
    matrix[VELC_VENTO_ROW][MIN_COL].ui = velc_vento_min;

    matrix[HUMD_ATM_ROW][MAX_COL].ui = humd_atm_max;
    matrix[HUMD_ATM_ROW][MIN_COL].ui = humd_atm_min;

    matrix[HUMD_SOLO_ROW][MAX_COL].ui = humd_solo_max;
    matrix[HUMD_SOLO_ROW][MIN_COL].ui = humd_solo_min;

    matrix[PLUVIO_ROW][MAX_COL].ui = pluvio_max;
    matrix[PLUVIO_ROW][MIN_COL].ui = pluvio_min;

    print_matrix(matrix);
}

    void
print_matrix(union matrix_value matrix[NUM_ROWS][NUM_COLS])
{
    const union matrix_value *p = &matrix[0][0];

    puts("\nDaily Matrix");
    puts("============\n");

    /* TODO: make this prettier */
    puts("Tipo de sensor       ||  Average ||  Max  ||  Min  ||");

    for (int i = 0; i < NUM_ROWS * NUM_COLS; i++) { 
        if (!(i % NUM_COLS)){
            if(i)
                putchar('\n');
            switch(i/NUM_COLS){
                case TEMP_ROW:
                    printf("%-22s","Temperatura");
                    break;
                case DIR_VENTO_ROW:
                    printf("%-24s","Direção vento");
                    break;
                case VELC_VENTO_ROW:
                    printf("%-22s","Velocidade vento");
                    break;
                case HUMD_ATM_ROW:
                    printf("%-22s","Humidade de atmosfera");
                    break;
                case HUMD_SOLO_ROW:
                    printf("%-22s","Humidade de solo");
                    break;
                case PLUVIO_ROW:
                    printf("%-22s","Pluviosidade");
                    break;

            }
            //printf("%d",i%NUM_COLS);
        }


        if (i < NUM_COLS)
            printf("%9d", (p+i)->i);
        else
            printf("%9u", (p+i)->ui);
    }
    putchar('\n');
}
