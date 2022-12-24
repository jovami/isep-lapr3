#pragma once

typedef struct Sensor Sensor;

enum {
    SENS_TEMP,
    SENS_DIR_VNT,
    SENS_VEL_VNT,
    SENS_HUM_ATM,
    SENS_HUM_SOL,
    SENS_PLUV,

    SENS_LAST
    /* NOTE: use SENS_LAST if iterating through sensor types
     * as value to 'terminate' the loop.
     * Otherwise SENS_LAST is useless.
     * -------------------------------
     * E.g:
     *      for (int i = SENS_TEMP; i < SENS_LAST; i++) {
     *          / * code here... * /
     *      }
     */
};

struct Sensor {
    unsigned short id;
    unsigned char sensor_type;
    unsigned short max_limit, min_limit;

    unsigned long frequency;    // em segundos

    unsigned long readings_size;
    unsigned short *readings;
};
