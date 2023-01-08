/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sensor_impl.h>
#include <sensor_vec.h>
#include <util.h>

static int extend(sensor_vec *v);

static const float resize_f = 1.5f;

static int
extend(sensor_vec *v)
{
    size_t new_sz = v->max_len*resize_f + 0.5f;
    Sensor *new_data = reallocarray(v->data, new_sz, sizeof(Sensor));

    if (!new_data)
        return VEC_FAIL;
    v->data = new_data;
    v->max_len = new_sz;

    return VEC_SUCCESS;
}

sensor_vec *
vec_init(sensor_vec *v, size_t len)
{
    v->data = arqcp_calloc(len, sizeof(Sensor));
    v->len = 0;
    v->max_len = len;

    /* returns self for ease of use */
    return v;
}

void
vec_free(sensor_vec *v)
{
    size_t i, len = v->len;
    Sensor *data = v->data;

    for (i = 0; i < len; i++)
        sens_free(data+i);
    free(v->data);
    memset(v, 0x00, sizeof(sensor_vec));
}

int
vec_push(sensor_vec *v, const Sensor *sens)
{
    if (v->len >= v->max_len && !extend(v)) {
        fprintf(stderr,
                "vec_push: failed to extend vector size: %s\n",
                strerror(errno));
        return VEC_FAIL;
    }

    /* Ugly :( */
    memcpy(v->data + v->len++, sens, sizeof(Sensor));
    return VEC_SUCCESS;
}

int
vec_remove(sensor_vec *v, size_t pos)
{
    const size_t len = v->len;
    if (pos >= len)
        return VEC_FAIL;

    Sensor *data = v->data;
    sens_free(data+pos);

    size_t i;
    for (i = pos+1; i < len; i++)
        data[i-1] = data[i];
    /* clear previous last sensor, since it has been moved */
    memset(data+(--v->len), 0x00, sizeof(Sensor));

    /* TODO: maybe shrink v->data?? */
    return VEC_SUCCESS;
}

/* EOF */
