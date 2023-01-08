/* Copyright (c) 2022 Jovami. All Rights Reserved. */

#pragma once
#include <stdio.h>
#include <stdlib.h>

#include "menu.h"
#include "sensors/gen_sens_values.h"
#include "sensor_vec.h"
#include "sensor_impl.h"
#include "util.h"
#include "menu.h"
#include "unistd.h"


enum {
    ADD_SENSOR,
    REMOVE_SENSOR,
    LIST_SENSOR,

    /* NOTE: do not use */
    MENU_LAST
};

#define MENU_ADD_STR \
    "\n1) Add Sensor\n" \
    "2) Remove Sensor\n" \
    "3) List Sensors\n" \
    "0) Back\n" \

#define MENU_FIRST  ADD_SENSOR
#define MATCH_ADD_REMOVE(X)  ((X)>=MENU_FIRST && (X)<MENU_LAST)


/* menu  */
void choose_add_remove_opt(sensor_vec *pack, short n_sens_type);

void add_remove(sensor_vec *pack, int opt, short n_sens_type);
void list_sensors(sensor_vec *pack);
void sens_freqs(sensor_vec *pack);

/* escolher os sensores */
short choose_sens(sensor_vec *type_pack);
short choose_type_sens();

/* prints */
void print_vec(sensor_vec *type_pack);

/* aux functions */
void add_remove_sensors(sensor_vec *pack);
void sensor_init(Sensor *sens_add, short n_sens_type);
void choose_add_remove_opt(sensor_vec *pack, short n_sens_type);
void add_remove(sensor_vec *pack, int opt, short n_sens_type);

/* EOF */
