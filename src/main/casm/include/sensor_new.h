#pragma once

#include <stddef.h>
#include <stdint.h>

typedef struct Sensor Sensor;

enum {
    SENS_TEMP,
    SENS_DIR_VNT,
    SENS_VEL_VNT,
    SENS_HUM_ATM,
    SENS_HUM_SOL,
    SENS_PLUV,

    SENS_LAST
    /* NOTE: use SENS_LAST as value to terminate
     * loops if iterating through sensor types.
     * Otherwise SENS_LAST is useless.
     * -------------------------------
     * E.g:
     *      for (int i = 0; i < SENS_LAST; i++) {
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
    size_t len;

    uintmax_t max_bad, cur_bad;
};

/* returns self */
Sensor *sens_init(Sensor *s,
                  unsigned char type,
                  unsigned short max_val,
                  unsigned short min_val,
                  unsigned long freq,
                  uintmax_t max_bad);

void sens_free(Sensor *s);

/* EOF */
