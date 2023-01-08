/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#pragma once

/* external */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <sensor_vec.h>
#include <sensor_impl.h>
#include <util.h>

#include "bootstrap.h"
#include "dailymatrix/dailymatrix.h"
#include "menu.h"
#include "menu_aux.h"
#include "sensors/gen_sens_values.h"


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
