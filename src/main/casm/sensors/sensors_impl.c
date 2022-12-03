#include <sensors_impl.h>
#include <sensors.h>
#include <rnd.h>
#include <stdio.h>

void
sens_init(struct generic_sensor *sens, uintmax_t max_bad, uint16_t frequency, sens_value lim_min, sens_value lim_max,sens_value first_value)
{
    sens->max_bad_values = max_bad;
    sens->current_bad_values = 0;

    sens->frequency = frequency;

    sens->lim_max = lim_max;
    sens->lim_min = lim_min;
    sens->current = first_value;
}

char sens_temp_update(temp *sens)
{
    char x = sens_temp(sens->current.c, rnd_next());
    while(x > sens->lim_max.c || x < sens->lim_min.c){
        sens->current_bad_values++;
        if(sens->current_bad_values >= sens->max_bad_values){
            rnd_init();
            sens->current_bad_values=0;
        }
        x = sens_temp(sens->current.c, rnd_next());
    }

    sens->current.c = x;

    return x;
}

unsigned char sens_velc_vento_update(velc_vento *sens)
{
    unsigned char x = sens_velc_vento(sens->current.uc, rnd_next());
    while(x > sens->lim_max.uc || x < sens->lim_min.uc){
        sens->current_bad_values++;
        if(sens->current_bad_values >= sens->max_bad_values){
            rnd_init();
            sens->current_bad_values=0;
        }
        x = sens_velc_vento(sens->current.uc, rnd_next());
    }
    
    
    sens->current.uc = x;
    return x;
}

unsigned short
sens_dir_vento_update(dir_vento *sens)
{
    unsigned short x = sens_dir_vento(sens->current.us, rnd_next());
    while(x > sens->lim_max.us || x < sens->lim_min.us){
        sens->current_bad_values++;
        if(sens->current_bad_values >= sens->max_bad_values){
            rnd_init();
            sens->current_bad_values=0;
        }
        x = sens_dir_vento(sens->current.us, rnd_next());
    }
    
    
    sens->current.us = x;
    return x;
}

unsigned char
sens_humd_atm_update(humd_atm *sens, pluvio *pluv)
{
    unsigned char x = sens_humd_atm(sens->current.uc, pluv->current.uc, rnd_next());
    while(x > sens->lim_max.uc || x < sens->lim_min.uc){
        sens->current_bad_values++;
        if(sens->current_bad_values >= sens->max_bad_values){
            rnd_init();
            sens->current_bad_values=0;
        }
        x = sens_humd_atm(sens->current.uc, pluv->current.uc, rnd_next());
    }
    

    sens->current.uc = x;
    return x;
}

unsigned char
sens_humd_solo_update(humd_solo *sens, pluvio *pluv)
{
    unsigned char x = sens_humd_solo(sens->current.uc, pluv->current.uc, rnd_next());
    while(x > sens->lim_max.uc || x < sens->lim_min.uc){
        sens->current_bad_values++;
        if(sens->current_bad_values >= sens->max_bad_values){
            rnd_init();
            sens->current_bad_values=0;
        }
        x = sens_humd_solo(sens->current.uc, pluv->current.uc, rnd_next());
    }
    

    sens->current.uc = x;
    return x;
}

unsigned char
sens_pluvio_update(pluvio *sens, temp *tp)
{
    unsigned char x = sens_pluvio(sens->current.uc, tp->current.c, rnd_next());
    while (x > sens->lim_max.uc || x < sens->lim_min.uc){
        sens->current_bad_values++;
        if(sens->current_bad_values >= sens->max_bad_values){
            rnd_init();
            sens->current_bad_values=0;
        }
        x = sens_pluvio(sens->current.uc, tp->current.c, rnd_next());
    }


    sens->current.uc = x;
    return x;
}

