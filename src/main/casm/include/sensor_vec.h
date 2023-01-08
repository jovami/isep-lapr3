/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#pragma once

#include <stddef.h>
#include <stdint.h>

#include <sensor_impl.h>

typedef struct sensor_vec sensor_vec;

struct sensor_vec {
    size_t max_len;
    size_t len;
    Sensor *data;
};

enum {
    VEC_FAIL = 0,
    VEC_SUCCESS = 1,
};


/* returns self */
sensor_vec *vec_init(sensor_vec *v, size_t len);
void vec_free(sensor_vec *v);

int vec_push(sensor_vec *v, const Sensor *sens);
int vec_remove(sensor_vec *v, size_t pos);
