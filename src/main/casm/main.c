#include <stdio.h>
#include <rnd.h>
#include <sensors.h>

int
main(int argc, char **argv)
{ 
    char data_temp[CICLES];
    unsigned short data_dir_vento[CICLES];
    unsigned char data_velc_vento[CICLES];
    unsigned char data_humd_atm[CICLES];
    unsigned char data_humd_solo[CICLES];
    unsigned char data_pluvio[CICLES];

    rnd_init();
    puts("Hello, World!");
    gen_sens_values(data_temp,data_dir_vento,data_velc_vento,data_humd_atm,data_humd_solo,data_pluvio);
    return 0;
}
