#include "bootstrap.h"

void
bootstrap(sensor_vec pack[SENS_LAST], unsigned long freqs[SENS_LAST])
{
    Sensor t1,t2, p1, dv1, vv1, ha1, hs1;
    sens_init(&t1,
              SENS_TEMP,
              30,
              TEMP_LIM_MAX,
              TEMP_LIM_MIN,
              freqs[SENS_TEMP],
              MAX_BAD_VALUES);

    sens_init(&t2,
              SENS_TEMP,
              30,
              TEMP_LIM_MAX,
              TEMP_LIM_MIN,
              2,
              MAX_BAD_VALUES);

    sens_init(&p1,
              SENS_PLUV,
              70,
              PLUVIO_LIM_MAX,
              PLUVIO_LIM_MIN,
              freqs[SENS_PLUV],
              MAX_BAD_VALUES);

    sens_init(&dv1,
              SENS_DIR_VNT,
              70,
              DIR_VENTO_LIM_MAX,
              DIR_VENTO_LIM_MIN,
              freqs[SENS_DIR_VNT],
              MAX_BAD_VALUES);

    sens_init(&vv1,
              SENS_VEL_VNT,
              50,
              VELC_VENTO_LIM_MAX,
              VELC_VENTO_LIM_MIN,
              freqs[SENS_VEL_VNT],
              MAX_BAD_VALUES);

    sens_init(&ha1,
              SENS_HUM_ATM,
              30,
              HUMD_ATM_LIM_MAX,
              HUMD_ATM_LIM_MIN,
              freqs[SENS_HUM_ATM],
              MAX_BAD_VALUES);

    sens_init(&hs1,
              SENS_HUM_SOL,
              40,
              HUMD_SOLO_LIM_MAX,
              HUMD_SOLO_LIM_MIN,
              freqs[SENS_HUM_SOL],
              MAX_BAD_VALUES);

    /********************************/

    vec_push(pack+SENS_TEMP,    &t1);
    vec_push(pack+SENS_TEMP,    &t2);
    vec_push(pack+SENS_PLUV,    &p1);
    vec_push(pack+SENS_DIR_VNT, &dv1);
    vec_push(pack+SENS_VEL_VNT, &vv1);
    vec_push(pack+SENS_HUM_ATM, &ha1);
    vec_push(pack+SENS_HUM_SOL, &hs1);
}
