#pragma once

//external
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

//menu related
#include "bootstrap.h"
#include "menu.h"
#include "menu_aux.h"
#include "dailymatrix/dailymatrix.h"
#include "util.h"

//sensors
#include "sensors/gen_sens_values.h"
#include "sensor_vec.h"
#include "sensor_impl.h"


void print_success_msg();
void menu(sensor_vec *pack);

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


#define MENU_OPTS_STR \
    "1) Add/Remove sensors\n" \
    "2) Alter sensor frequencies\n" \
    "3) Generate sensor values\n" \
    "4) Daily matrix and export sensor values\n" \
    "5) List Sensors\n" \
    "0) Quit\n" \


#define MENU_FST    ADD_SENS    
#define QUIT        (MENU_FST-1)
#define MATCH(X)    ((X) >= MENU_FST && (X) < MENU_LST)

char getchar_flush(void);
