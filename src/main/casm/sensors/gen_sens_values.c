#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <rnd.h>

#include <rnd.h>
#include <sensors.h>
#include <sensors_impl.h>

int gen_sens_values(char *data_temp,unsigned short *data_dir_vento, unsigned char *data_velc_vento,
                        unsigned char *data_humd_atm, unsigned char *data_humd_solo, unsigned char *data_pluvio){
        int index=0;

        //sensors
        temp tmp1;
        velc_vento velc1;
        dir_vento dir1;
        humd_atm atm1;
        humd_solo solo1;
        pluvio plv1;

        //limit sens values
        sens_value min;
        sens_value max;

        //first values
        sens_value first_value;

        //init all sensors
        min.c = TEMP_LIM_MIN;
        max.c = TEMP_LIM_MAX;
        first_value.c = 30;
        sens_init(&tmp1, MAX_BAD_VALUES, FREQUENCY, min, max, first_value);

        min.us=DIR_VENTO_LIM_MIN;
        max.us = DIR_VENTO_LIM_MAX;
        first_value.us = 70;
        sens_init(&dir1, MAX_BAD_VALUES, FREQUENCY, min,max, first_value);

        min.uc = PLUVIO_LIM_MIN;
        max.uc = PLUVIO_LIM_MAX;
        first_value.uc = 80;
        sens_init(&plv1, MAX_BAD_VALUES, FREQUENCY, min, max, first_value);

        min.uc = VELC_VENTO_LIM_MIN;
        max.uc = VELC_VENTO_LIM_MAX;
        first_value.uc = 50;
        sens_init(&velc1, MAX_BAD_VALUES, FREQUENCY, min, max, first_value);

        min.uc = HUMD_SOLO_LIM_MIN;
        max.uc = HUMD_SOLO_LIM_MAX;
        first_value.uc = 40;
        sens_init(&solo1, MAX_BAD_VALUES, FREQUENCY, min, max, first_value);

        min.uc = HUMD_ATM_LIM_MIN;
        max.uc = HUMD_ATM_LIM_MAX;
        first_value.uc = 30;
        sens_init(&atm1, MAX_BAD_VALUES, FREQUENCY, min, max, first_value);


        char ult_temp ;
        unsigned char ult_pluvio;
        unsigned char ult_hmd_atm;
        unsigned char ult_hmd_solo;
        unsigned short ult_dir_vento;
        unsigned char ult_velc_vento;

        do{


                ult_temp = sens_temp_update(&tmp1);

                ult_pluvio = sens_pluvio_update(&plv1, &tmp1);

                ult_hmd_atm =  sens_humd_atm_update(&atm1, &plv1);

                ult_hmd_solo = sens_humd_solo_update(&solo1, &plv1);

                ult_velc_vento = sens_velc_vento_update(&velc1);

                ult_dir_vento =sens_dir_vento_update(&dir1);

                data_temp[index] = ult_temp;
                data_pluvio[index] = ult_pluvio;
                data_humd_atm[index] = ult_hmd_atm;
                data_humd_solo[index] = ult_hmd_solo;
                data_velc_vento[index] = ult_velc_vento;
                data_dir_vento[index] = ult_dir_vento;

                printf("Temp: %hhd\n", data_temp[index]);
                printf("dir vent: %hhu\n", data_dir_vento[index]);
                printf("Velc_vento: %hhu\n", data_velc_vento[index]);
                printf("Humd_atm: %hhu\n", data_humd_atm[index]);
                printf("Humd_solo: %hhu\n", data_humd_solo[index]);
                printf("Pluvio: %hhu\n", data_pluvio[index]);
                printf("\n--------------------------%d-------------------------------------\n",index+1);


                sleep(TIMER);
                index++;

        }while(index < CYCLES);

        return 0;
}

