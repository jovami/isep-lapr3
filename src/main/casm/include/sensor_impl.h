/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#pragma once

#include <stddef.h>
#include <stdint.h>

#define DAYS_SECS       (24UL * 3600UL)
#define freq_to_sz(f)   (DAYS_SECS / (f))

/************** Constants **************/

/* ALL */
#define MAX_BAD_VALUES      10

/* TEMP */
#define TEMP_LIM_MAX        50
#define TEMP_LIM_MIN        -30

/* PLUVIO */
#define PLUVIO_LIM_MAX      150
#define PLUVIO_LIM_MIN      0

/* DIR_VENTO */
#define DIR_VENTO_LIM_MAX   359
#define DIR_VENTO_LIM_MIN   0

/* VELC_VENTO */
#define VELC_VENTO_LIM_MAX  90
#define VELC_VENTO_LIM_MIN  0

/* UMD_SOLO */
#define HUMD_SOLO_LIM_MAX   100
#define HUMD_SOLO_LIM_MIN   0

/* HUMD_ATM */
#define HUMD_ATM_LIM_MAX    65
#define HUMD_ATM_LIM_MIN    0

/***************************************/

typedef struct Sensor Sensor;
typedef void (*sens_upd_t)(Sensor *, const Sensor *);

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

union SensorValue {
    char c;
    unsigned char uc;
    unsigned short us;
};

const char *strsens(enum SensorType type);

/* returns self */
Sensor *sens_init(Sensor *s,
                  unsigned char type,
                  unsigned short first_val,
                  unsigned short max_val,
                  unsigned short min_val,
                  unsigned long freq,
                  uintmax_t max_bad);


void sens_free(Sensor *s);

void sens_temp_update(Sensor *s);
void sens_pluvio_update(Sensor *s, const Sensor *temp);
void sens_velc_vento_update(Sensor *s);
void sens_dir_vento_update(Sensor *s);
void sens_humd_atm_update(Sensor *s, const Sensor *pluv);
void sens_humd_solo_update(Sensor *s, const Sensor *pluv);

/* Wrappers for updates with only 1 param */
void sens_temp_wrapper(Sensor *s, const Sensor *dummy);
void sens_vel_vnt_wrapper(Sensor *s, const Sensor *dummy);
void sens_dir_vnt_wrapper(Sensor *s, const Sensor *dummy);
