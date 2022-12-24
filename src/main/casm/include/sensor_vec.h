#pragma once

#include <stddef.h>
#include <stdint.h>

#include <sensor_new.h>

typedef struct sensor_vec sensor_vec;

struct sensor_vec {
    size_t max_len;
    size_t len;
    Sensor *data;
    uint8_t type;
};

sensor_vec *vec_init(size_t len, uint8_t type);
void vec_free(sensor_vec *v);

int vec_push(sensor_vec *v, unsigned short max, unsigned short min, unsigned long freq);
int vec_remove(sensor_vec *v, size_t pos);
