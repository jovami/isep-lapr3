#pragma once
#include "sensor_impl.h"
union matrix_value{
    int i;
    unsigned int ui;
};

void export_dailymatrix(union matrix_value matrix[6][3]);

void export_sensor_data(const Sensor *sensors, int num_sensors);
