/* Copyright (c) 2022 Jovami. All Rights Reserved. */

#include <stdio.h>

#include "menu.h"
#include "dailymatrix/dailymatrix.h"
#include "sensors/gen_sens_values.h"
#include "sensor_vec.h"
#include "sensor_impl.h"
#include "bootstrap.h"
#include "util.h"
#include "unistd.h"

/***********************************/

/* FIXME: use the actual functions */
void add_remove_sensors(sensor_vec *pack);
void bar(sensor_vec *pack);
void list_sensors(sensor_vec *pack);
void print_vec(sensor_vec *type_pack);
void choose_add_remove_opt(sensor_vec *pack, short n_sens_type);
void add_remove(sensor_vec *pack, int opt, short n_sens_type);



void bar(sensor_vec *pack)
{
    puts("bar!!");
}



/***********************************/

typedef void (*MenuItem)(sensor_vec *pack);


enum {
    ADD_SENS,
    ALTER_FREQ,
    GENERATE_VALUES,
    DAILY_MATRIX,
    LIST_SENS,


    /* NOTE: do not use */
    MENU_LST
};

enum {
    ADD_SENSOR,
    REMOVE_SENSOR,
    LIST_SENSOR,

    /* NOTE: do not use */
    MENU_LAST
};

#define MENU_OPTS_STR \
    "1) Add/Remove sensors\n" \
    "2) Alter sensor frequencies\n" \
    "3) Generate sensor values\n" \
    "4) Daily matrix and export sensor values\n" \
    "5) List Sensors\n" \
    "0) Quit\n" \

#define MENU_ADD_STR \
    "\n1) Add Sensor\n" \
    "2) Remove Sensor\n" \
    "3) List Sensors\n" \
    "0) Back\n" \

#define MENU_FST    ADD_SENS    
#define QUIT        (MENU_FST-1)
#define MATCH(X)    ((X) >= MENU_FST && (X) < MENU_LST)
#define MENU_FIRST  ADD_SENSOR
#define MATCH_ADD_REMOVE(X)  ((X)>=MENU_FIRST && (X)<MENU_LAST)



__attribute__((__always_inline__))
static inline char getchar_flush(void);


static const MenuItem items[MENU_LST] = {
    &add_remove_sensors,
    &bar,
    &gen_sens_values,
    &daily_matrix,
    &list_sensors,
};


char
getchar_flush(void)
{
    char _, c;
    c = getchar();

    while ((_ = getchar()) != '\n' && _ != EOF)
        ; /* no-op */
    return c;
}

short choose_type_sens()
{
    int opt;

    do
    {
        for (size_t i = 0; i < SENS_LAST; i++)
        {
            fprintf(stdout,"%ld) %s\n",i+1,strsens(i));
        }
        fputs("\nChoose one: ", stdout);
        opt = getchar_flush() - '1';   
    } while (opt>=7 && opt<=0);

    return opt; 
}


short choose_sens(sensor_vec *type_pack)
{
    int opt;
    do{

        print_vec(type_pack);
        fputs("\n0) Back",stdout);
        fputs("\nChoose one: ",stdout);
        opt = getchar_flush() - '0';

    } while (opt >= (type_pack->len) || opt<0);

    return opt;
    
}

void print_vec(sensor_vec *type_pack)
{
    Sensor *sens = type_pack->data;
    for (size_t i = 0; i < type_pack->len; i++)
    {
        fprintf(stdout, "%ld) %s %ld\n",i+1, strsens((sens+i)->sensor_type),i+1);
    }
}
void print_success_msg()
{
    puts("\nOperation Completed With Success!\n");
    sleep(2);
}
static const unsigned short sensor_names[SENS_LAST] = {
    [SENS_TEMP] = 10,
    [SENS_PLUV] = 20,
    [SENS_DIR_VNT] = 30,
    [SENS_VEL_VNT] = 40,
    [SENS_HUM_ATM] = 20,
    [SENS_HUM_SOL] = 10
};

void sensor_init(Sensor *sens_add, short n_sens_type)
{
    puts("Number of Bad Values: ");
        int max_bad_values = getchar_flush();
    puts("Max Reading Value: ");
        int limit_max = getchar_flush();    
    puts("Min Reading Value: ");
        int limit_min = getchar_flush();  
    sens_init(
        sens_add,
        n_sens_type,
        sensor_names[n_sens_type], 
        limit_max,
        limit_min,
        2,
        max_bad_values
    );
}
void list_sensors(sensor_vec *pack){
    size_t count=1;

for (size_t j = 0; j < SENS_LAST; j++)
{
    sensor_vec *type_sens = pack +j;

    for (size_t i = 0; i < type_sens->len; i++)
    {
        fprintf(stdout, "%ld) %s %d\n",count++, strsens(((type_sens->data)+i)->sensor_type),((type_sens->data)+i)->id);
    }
}
sleep(3);
}

void
menu(sensor_vec *pack)
{
    int opt;
    char bad_opt = 0, running = 1;

    do {
        if (!bad_opt) {
            puts("Main menu");
            puts("=========\n");
        }

        /* refresh */
        bad_opt = 0;

        fputs(MENU_OPTS_STR"\nChoose one: ", stdout);
        opt = getchar_flush() - '1';
        putchar('\n');

        if (MATCH(opt)) {
            items[opt](pack);
        } else if (opt == QUIT) {
            running = 0;
        } else {
            bad_opt = 1;
            fprintf(stderr, "error: invalid option: %d\n", opt+1);
        }

        putchar('\n');
    } while (running);
}


void add_remove_sensors(sensor_vec *pack)
{
    puts("Types of Sensors: ");
    short n_sens_type = choose_type_sens();
    choose_add_remove_opt(pack,n_sens_type);
}

void choose_add_remove_opt(sensor_vec *pack, short n_sens_type)
{
    int opt;

    fputs(MENU_ADD_STR"\nChoose one: ", stdout);
        opt = getchar_flush() - '1';
        putchar('\n');

        if (MATCH_ADD_REMOVE(opt)) {
            add_remove(pack,opt,n_sens_type);
        } else if (opt == QUIT) {
            menu(pack);
        } else {
            fprintf(stderr, "error: invalid option: %d\n", opt+1);
        }
}


void add_remove(sensor_vec *pack, int opt, short n_sens_type)  
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
        short index=choose_sens(type_pack);
        if(index!=0){
            vec_remove(type_pack,index) ;
            print_success_msg();
        }
    }
    else{
        print_vec(type_pack);
        sleep(3); 
        choose_add_remove_opt(pack, n_sens_type);  
    }
}



/* EOF */
