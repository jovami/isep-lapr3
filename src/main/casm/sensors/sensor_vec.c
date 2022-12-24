#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sensor_new.h>
#include <sensor_vec.h>
#include <util.h>

static unsigned short sens_count = 0;
static const float resize_f = 1.5f;

#define DAYS_SECS       (24UL * 3600UL)
#define freq_to_sz(f)   (DAYS_SECS / (f))

enum {
    VEC_FAIL = 0,
    VEC_SUCCESS = 1,
};

static int
extend(sensor_vec *v)
{
    size_t new_sz = v->max_len*resize_f;
    Sensor *new_data = reallocarray(v->data, new_sz, sizeof(Sensor));

    if (!new_data)
        return VEC_FAIL;
    v->data = new_data;
    v->max_len = new_sz;

    return VEC_SUCCESS;
}

sensor_vec *
vec_init( size_t len, uint8_t type)
{
    sensor_vec *v = arqcp_malloc(1, sizeof(sensor_vec));

    v->type = type;

    v->data = arqcp_calloc(len, sizeof(Sensor));
    v->len = 0;
    v->max_len = len;

    return v;
}

void
vec_free(sensor_vec *v)
{
    size_t i, len = v->len;
    Sensor *data = v->data;

    for (i = 0; i < len; i++)
        free(data->readings);
    free(data);
    free(v);
}

int
vec_push(sensor_vec *v, unsigned short max, unsigned short min, unsigned long freq)
{
    if (v->len >= v->max_len && !extend(v)) {
        fprintf(stderr,
                "vec_push: failed to extend vector size: %s\n",
                strerror(errno));
        return VEC_FAIL;
    } else if (freq > DAYS_SECS) {
        fprintf(stderr,
                "vec_push: frequency larger than maximum allowed (%ld)\n",
                DAYS_SECS);
        return VEC_FAIL;
    }

    const unsigned long sz = freq_to_sz(freq);

    Sensor *s = v->data+v->len++;
    s->id = ++sens_count,
    s->sensor_type = v->type,
    s->max_limit = max,
    s->min_limit = min,
    s->frequency = freq,
    s->readings_size = sz;
    s->readings = arqcp_calloc(sz, sizeof(*s->readings));

    return VEC_SUCCESS;
}

int
vec_remove(sensor_vec *v, size_t pos)
{
    const size_t len = v->len;
    if (pos >= len)
        return VEC_FAIL;

    Sensor *data = v->data;
    free(data[pos].readings);

    size_t i;
    for (i = pos+1; i < len; i++)
        data[i-1] = data[i];
    v->len--;

    return VEC_SUCCESS;
}

/* EOF */
