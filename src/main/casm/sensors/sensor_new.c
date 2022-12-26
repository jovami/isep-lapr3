#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include <rnd.h>
#include <sensors.h>
#include <sensor_new.h>
#include <util.h>

#define DAYS_SECS       (24UL * 3600UL)
#define freq_to_sz(f)   (DAYS_SECS / (f))

static char check_len(const Sensor *s);
static char bad_value(Sensor *s, unsigned short x);

static unsigned short sens_count = 0;

const char *
strsens(enum SensorType type)
{
    switch (type) {
    case SENS_TEMP:
        return "Temperature";
    case SENS_PLUV:
        return "Pluviosity";
    case SENS_DIR_VNT:
        return "Wind direction";
    case SENS_VEL_VNT:
        return "Wind velocity";
    case SENS_HUM_ATM:
        return "Atmospheric humidity";
    case SENS_HUM_SOL:
        return "Soil humidity";
    default:
        errno = EINVAL;
        return NULL;
    }
}

char
check_len(const Sensor *s)
{
    size_t len;

    if (!(len = s->len)) {
        fputs("check_len: length is zero!\n", stderr);
        return 0;
    } else if (len == s->readings_size) {
        fputs("check_len: readings is full; not generating anything",
              stderr);
        return 0;
    }

    return 1;
}

char
bad_value(Sensor *s, unsigned short x)
{
    if (x > s->max_limit || x < s->min_limit) {
        uintmax_t cur_bad = s->cur_bad + 1;
        if (cur_bad > s->max_bad) {
            rnd_init();
            cur_bad = 0;
        }
        s->cur_bad = cur_bad;
        return 1;
    }

    return 0;
}

Sensor *
sens_init(Sensor *s,
          unsigned char type,
          unsigned short max_val,
          unsigned short min_val,
          unsigned long freq,
          uintmax_t max_bad)
{
    s->id = ++sens_count;
    s->sensor_type = type;

    /* TODO: ensure max_val > min_val */
    s->max_limit = max_val;
    s->min_limit = min_val;

    /* TODO: ensure 0 < freq <= DAYS_SECS */
    s->frequency = freq;

    unsigned long sz = freq_to_sz(freq);
    s->readings_size = sz;
    s->readings = arqcp_calloc(sz, sizeof(*s->readings));
    s->len = 0;

    /* TODO: ensure max_bad is non-zero */
    s->max_bad = max_bad;
    s->cur_bad = 0;

    return s;
}

void
sens_free(Sensor *s)
{
    free(s->readings);
    s->readings = NULL;
}

char
sens_temp_update(Sensor *s)
{
    if (!check_len(s))
        return 0;

    char x, cur = s->readings[s->len-1];
    do {
        x = sens_temp(cur, rnd_next());
    } while (bad_value(s, x));

    s->readings[s->len++] = x;
    return x;
}

unsigned char
sens_pluvio_update(Sensor *s, const Sensor *temp)
{
    if (!check_len(s) || !check_len(temp))
        return 0;

    unsigned char x, cur = s->readings[s->len-1];
    do {
        x = sens_pluvio(cur, temp->readings[temp->len-1], rnd_next());
    } while (bad_value(s, x));

    s->readings[s->len++] = x;
    return x;
}

unsigned char
sens_velc_vento_update(Sensor *s)
{
    if (!check_len(s))
        return 0;

    unsigned char x, cur = s->readings[s->len-1];
    do {
        x = sens_velc_vento(cur, rnd_next());
    } while (bad_value(s, x));

    s->readings[s->len++] = x;
    return x;
}

unsigned short
sens_dir_vento_update(Sensor *s)
{
    if (!check_len(s))
        return 0;

    unsigned short x, cur = s->readings[s->len-1];
    do {
        x = sens_dir_vento(cur, rnd_next());
    } while (bad_value(s, x));

    s->readings[s->len++] = x;
    return x;
}

unsigned char
sens_humd_atm_update(Sensor *s, const Sensor *pluv)
{
    if (!check_len(s) || !check_len(pluv))
        return 0;

    unsigned char x, cur = s->readings[s->len-1];
    do {
        x = sens_pluvio(cur, pluv->readings[pluv->len-1], rnd_next());
    } while (bad_value(s, x));

    s->readings[s->len++] = x;
    return x;
}

unsigned char
sens_humd_solo_update(Sensor *s, const Sensor *pluv)
{
    if (!check_len(s) || !check_len(pluv))
        return 0;

    unsigned char x, cur = s->readings[s->len-1];
    do {
        x = sens_pluvio(cur, pluv->readings[pluv->len-1], rnd_next());
    } while (bad_value(s, x));

    s->readings[s->len++] = x;
    return x;
}

/* EOF */
