/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#pragma once

#include <sensor_impl.h>
#include <sensor_vec.h>

union matrix_value{
    int i;
    unsigned int ui;
};

void export_dailymatrix(unsigned short matrix[6][3]);
void export_sensor_data(const sensor_vec *sensors);
