#pragma once

#include <stddef.h>
#include <stdint.h>


/************** Constants **************/

/* ALL */
#define FREQUENCY 2
#define INITIAL_BAD_VALUES 0
#define TIMER 2
#define CYCLES 15
#define MAX_BAD_VALUES 10

/* TEMP */
#define TEMP_LIM_MAX 50
#define TEMP_LIM_MIN -30

/* PLUVIO */
#define PLUVIO_LIM_MAX 150
#define PLUVIO_LIM_MIN 0

/* DIR_VENTO */
#define DIR_VENTO_LIM_MAX 359
#define DIR_VENTO_LIM_MIN 0

/* VELC_VENTO */
#define VELC_VENTO_LIM_MAX 90
#define VELC_VENTO_LIM_MIN 0

/* UMD_SOLO */
#define HUMD_SOLO_LIM_MAX 100
#define HUMD_SOLO_LIM_MIN 0

/* HUMD_ATM */
#define HUMD_ATM_LIM_MAX 65
#define HUMD_ATM_LIM_MIN 0

/***************************************/

typedef struct Sensor Sensor;

enum SensorType {
    SENS_TEMP,
    SENS_PLUV,
    SENS_DIR_VNT,
    SENS_VEL_VNT,
    SENS_HUM_ATM,
    SENS_HUM_SOL,

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


const char *strsens(enum SensorType type);

/* returns self */
Sensor *sens_init(Sensor *s,
                  unsigned char type,
                  unsigned short max_val,
                  unsigned short min_val,
                  unsigned long freq,
                  uintmax_t max_bad);

void sens_free(Sensor *s);

char sens_temp_update(Sensor *s);
unsigned char sens_pluvio_update(Sensor *s, const Sensor *temp);

unsigned char sens_velc_vento_update(Sensor *s);
unsigned short sens_dir_vento_update(Sensor *s);

unsigned char sens_humd_atm_update(Sensor *s, const Sensor *pluv);
unsigned char sens_humd_solo_update(Sensor *s, const Sensor *pluv);

/* EOF */
