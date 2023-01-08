/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#include <stdio.h>

#include <export_csv.h>
#include <sensor_impl.h>
#include <sensor_vec.h>

#include "dailymatrix.h"

#define MAX(X, Y)   ((X) > (Y) ? (X) : (Y))
#define MIN(X, Y)   ((X) < (Y) ? (X) : (Y))

enum {
    AVG_COL,
    MAX_COL,
    MIN_COL,

    COL_LAST
}; /* matrix cols */

#define NUM_ROWS    SENS_LAST
#define NUM_COLS    COL_LAST

__attribute__((__always_inline__))
static inline unsigned short get_max(enum SensorType t, const union SensorValue *old, const union SensorValue *new);
__attribute__((__always_inline__))
static inline unsigned short get_min(enum SensorType t, const union SensorValue *old, const union SensorValue *new);

static void fill_matrix(unsigned short matrix[NUM_ROWS][NUM_COLS], const sensor_vec *pack);
static void print_matrix(unsigned short matrix[NUM_ROWS][NUM_COLS]);

unsigned short
get_max(enum SensorType t, const union SensorValue *old, const union SensorValue *new)
{
    switch (t) {
        case SENS_TEMP:
            return MAX(old->c, new->c);
            break;
        case SENS_DIR_VNT:
            return MAX(old->us, new->us);
            break;
        case SENS_PLUV:     /* FALLTHROUGH */
        case SENS_VEL_VNT:
        case SENS_HUM_ATM:
        case SENS_HUM_SOL:
            return MAX(old->uc, new->uc);
            break;
        default:
            return 0; /* should not happen */
            break;
    }
}

unsigned short
get_min(enum SensorType t, const union SensorValue *old, const union SensorValue *new)
{
    switch (t) {
        case SENS_TEMP:
            return MIN(old->c, new->c);
            break;
        case SENS_DIR_VNT:
            return MIN(old->us, new->us);
            break;
        case SENS_PLUV:     /* FALLTHROUGH */
        case SENS_VEL_VNT:
        case SENS_HUM_ATM:
        case SENS_HUM_SOL:
            return MIN(old->uc, new->uc);
            break;
        default:
            return 0; /* should not happen */
            break;
    }
}

void
daily_matrix(sensor_vec *pack)
{
    unsigned short matrix[NUM_ROWS][NUM_COLS];
    fill_matrix(matrix, pack);
    print_matrix(matrix);

    putchar('\n');

    export_dailymatrix(matrix);
    export_sensor_data(pack);

    putchar('\n');
}

void
fill_matrix(unsigned short matrix[NUM_ROWS][NUM_COLS], const sensor_vec *pack)
{

    for (enum SensorType i = 0; i < SENS_LAST; i++) {
        const sensor_vec *v = pack+i;
        const Sensor *data = v->data;
        const size_t len = v->len;

        unsigned short avg;
        union SensorValue min, max;

        avg = 0;
        min.us = (data+0)->readings[0];
        max = min;

        size_t count = 0;
        for (size_t j = 0; j < len; j++) {
            unsigned short *readings = (data+j)->readings;
            size_t rlen = (data+j)->len;

            for (size_t k = 0; k < rlen; k++) {
                unsigned short val = *(readings + k);
                union SensorValue uval = { .us = val };

                avg += val;
                min.us = get_min(i, &min, &uval);
                max.us = get_max(i, &max, &uval);

                count++;
            }
        }

        unsigned short *m = *(matrix + i);
        m[AVG_COL] = avg / count;
        m[MAX_COL] = max.us;
        m[MIN_COL] = min.us;
    }
}


void
print_matrix(unsigned short matrix[NUM_ROWS][NUM_COLS])
{
    const unsigned short *p = &matrix[0][0];

    puts("\nDaily Matrix");
    puts("============\n");


    puts("Sensor type          ||  Average ||  Max  ||  Min  ||");
    for (size_t i = 0; i < NUM_ROWS * NUM_COLS; i++) {
        if (!(i % NUM_COLS)) {
            if (i != 0)
                putchar('\n');
            printf("%-22s", strsens(i/NUM_COLS));
        }

        if (i < NUM_COLS)
            printf("%9hhd", (signed char) *(p+i));
        else
            printf("%9hu", *(p+i));
    }
    putchar('\n');
}
