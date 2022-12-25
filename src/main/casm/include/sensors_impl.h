#pragma once

#include <stdint.h>

typedef struct generic_sensor temp;
typedef struct generic_sensor velc_vento;
typedef struct generic_sensor dir_vento;
typedef struct generic_sensor humd_atm;
typedef struct generic_sensor humd_solo;
typedef struct generic_sensor pluvio;

typedef union sens_value sens_value;

union sens_value {
    char c;
    unsigned char uc;
    unsigned short us;
};


struct generic_sensor {
    uintmax_t max_bad_values;
    uintmax_t current_bad_values;
    uint16_t frequency;
    sens_value current, lim_min, lim_max;
};


void sens_init(struct generic_sensor *sens, uintmax_t max_bad,
               uint16_t frequency, sens_value lim_min, sens_value lim_max, sens_value first_value);



char sens_temp_update(temp *p);
unsigned char sens_velc_vento_update(velc_vento *p);
unsigned short sens_dir_vento_update(dir_vento *p);
unsigned char sens_humd_atm_update(humd_atm *p, pluvio *pluv);
unsigned char sens_humd_solo_update(humd_solo *p, pluvio *pluv);
unsigned char sens_pluvio_update(pluvio *p, temp *tp);




