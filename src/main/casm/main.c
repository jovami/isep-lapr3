#include <stdio.h>

#include <rnd.h>
#include <sensor_vec.h>
#include <sensor_new.h>

#include "menu.h"

int
main(int argc, char **argv)
{
    unsigned long sizes[SENS_LAST];

    {
        /* FIXME: placeholder */
        for (int i = 0; i < SENS_LAST; i++)
            sizes[i] = 14;
    }


    sensor_vec pack[SENS_LAST];

    int i;
    for (i = 0; i < SENS_LAST; i++) {
        vec_init(pack+i, sizes[i]);
    }

    rnd_init();
    menu(pack);

    /* char data_temp[CYCLES]; */
    /* unsigned short data_dir_vento[CYCLES]; */
    /* unsigned char data_velc_vento[CYCLES]; */
    /* unsigned char data_humd_atm[CYCLES]; */
    /* unsigned char data_humd_solo[CYCLES]; */
    /* unsigned char data_pluvio[CYCLES]; */

    /* rnd_init(); */
    /* gen_sens_values(data_temp,data_dir_vento,data_velc_vento,data_humd_atm,data_humd_solo,data_pluvio); */

    /* daily_matrix(data_temp, data_dir_vento, data_velc_vento, data_humd_atm, data_humd_solo, data_pluvio); */

    for (i = 0; i < SENS_LAST; i++)
        vec_free(pack+i);
    return 0;
}
