#include <stdio.h>
#include <rnd.h>
#include <sensors.h>

#include "dailymatrix/dailymatrix.h"

int
main(int argc, char **argv)
{
    char data_temp[CYCLES];
    unsigned short data_dir_vento[CYCLES];
    unsigned char data_velc_vento[CYCLES];
    unsigned char data_humd_atm[CYCLES];
    unsigned char data_humd_solo[CYCLES];
    unsigned char data_pluvio[CYCLES];

    rnd_init();
    gen_sens_values(data_temp,data_dir_vento,data_velc_vento,data_humd_atm,data_humd_solo,data_pluvio);

    daily_matrix(data_temp, data_dir_vento, data_velc_vento, data_humd_atm, data_humd_solo, data_pluvio);
    return 0;
}
