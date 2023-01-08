/* Copyright (c) 2022 Jovami. All Rights Reserved. */

#include <stdint.h>
#include "menu_aux.h"

static const unsigned short sensor_names[SENS_LAST] = {
    [SENS_TEMP] = 10,
    [SENS_PLUV] = 20,
    [SENS_DIR_VNT] = 30,
    [SENS_VEL_VNT] = 40,
    [SENS_HUM_ATM] = 20,
    [SENS_HUM_SOL] = 10
};


void
sens_freqs(sensor_vec *pack)
{
    puts("Altering sensors frequencies");
    short offset_type = choose_type_sens();
    short offset_sens = choose_sens(pack+offset_type);
    if(offset_sens < 0){
            fputs("There are no sensors related to this type\n",stdout);
            return;
    }
    //sens to be altered
    Sensor *sens= ((pack+offset_type)->data)+offset_sens;

    fputs("New frequency: ",stdout);

    //get new frequency
    long freq = read_int_wrapper();

    //set new frequency
    sens->frequency = freq;

    //new size
    unsigned long sz = freq_to_sz(freq);

    //realloc reading
    sens->readings_size = sz;
    sens->readings = arqcp_realloc(sens->readings,sz, sizeof(*sens->readings));
}

short
choose_type_sens(void)
{
    int opt;
    do
    {
        for (size_t i = 0; i < SENS_LAST; i++)
        {
            fprintf(stdout,"%ld) %s\n",i+1,strsens(i));
        }
        fputs("\nChoose one: ", stdout);
        opt = read_int_wrapper() - 1;

    } while (opt>=SENS_LAST || opt<0);

    return opt;
}


//returns -1 if there are no sensors related to the sens_type specified
short
choose_sens(sensor_vec *type_pack)
{

    int opt;
    if(type_pack->len == 0){
        fputs("There are no sensors related to this type",stdout);
        return -1;
    }

    do{

        print_vec(type_pack);
        fputs("\nChoose one: ",stdout);
        opt = read_int_wrapper() - 1;

    } while (opt > (type_pack->len) || opt<0);

    return opt;
}

void
print_vec(sensor_vec *type_pack)
{
    Sensor *sens = type_pack->data;
    for (size_t i = 0; i < type_pack->len; i++)
    {
        fprintf(stdout, "%ld) %s %ld\n",i+1, strsens((sens+i)->sensor_type),i+1);
    }
}

void
sensor_init(Sensor *sens_add, short n_sens_type)
{
    char *c=NULL;
    size_t t=0;

    intmax_t max_bad_values;

    fputs("\nNumber of Bad Values: ",stdout);
    max_bad_values = read_int(&c,&t);

    while(max_bad_values < 0){
        fputs("\nTry again",stdout);
        max_bad_values = read_int(&c,&t);
    }

    fputs("\nMax Reading Value: ",stdout);
    short limit_max = read_int(&c,&t);

    fputs("\nMin Reading Value: ",stdout);
    short limit_min = read_int(&c,&t);

    fputs("\nFrequency: ",stdout);
    long frequency = read_int(&c,&t);

    while(frequency < 0){
        fputs("\nTry again",stdout);
        max_bad_values = read_int(&c,&t);
    }

    free(c);

    sens_init(
        sens_add,
        n_sens_type,
        sensor_names[n_sens_type],
        limit_max,
        limit_min,
        frequency,
        max_bad_values
    );
}

void
list_sensors(sensor_vec *pack){
    size_t count=1;

    for (size_t j = 0; j < SENS_LAST; j++)
    {
        sensor_vec *type_sens = pack +j;

        for (size_t i = 0; i < type_sens->len; i++)
        {
            fprintf(stdout, "%ld) %s %d\n",count++, strsens(((type_sens->data)+i)->sensor_type),((type_sens->data)+i)->id);
        }
    }
}


void
add_remove_sensors(sensor_vec *pack)
{
    puts("Types of Sensors: ");
    short n_sens_type = choose_type_sens();
    choose_add_remove_opt(pack,n_sens_type);
}

void
choose_add_remove_opt(sensor_vec *pack, short n_sens_type)
{
    int opt;

    fputs(MENU_ADD_STR"\nChoose one: ", stdout);
    opt = read_int_wrapper() - 1 ;
    putchar('\n');

    if (MATCH_ADD_REMOVE(opt)) {
        add_remove(pack,opt,n_sens_type);
    } else if (opt == QUIT) {
        menu(pack);
    } else {
        fprintf(stderr, "error: invalid option: %d\n", opt+1);
    }
}


void
add_remove(sensor_vec *pack, int opt, short n_sens_type)
{
    sensor_vec *type_pack = pack+n_sens_type;
    if (opt == 0)
    {
        Sensor sens_add;
        sensor_init(&sens_add,n_sens_type);
        vec_push(pack+n_sens_type, &sens_add);
        print_success_msg();
    }
    else if (opt==1){
        if(type_pack->len > 1){
            short index=choose_sens(type_pack);
            vec_remove(type_pack,index) ;
            print_success_msg();
        }else{
            fprintf(stdout, "\tWARNING: not possible to remove all sensors\n");
        }
    }
    else{
        print_vec(type_pack);
        choose_add_remove_opt(pack, n_sens_type);
    }
}


/* EOF */
