/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include <rnd.h>
#include <sensors.h>
#include <sensor_impl.h>
#include <util.h>

static char check_len(const Sensor *s);

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

Sensor *
sens_init(Sensor *s,
          unsigned char type,
          unsigned short first_val,
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

    s->readings[s->len++] = first_val;

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

void
sens_temp_update(Sensor *s)
{
    if (!check_len(s))
        return;

    char x, cur = s->readings[s->len-1];
    char min = s->min_limit, max = s->max_limit;

    x = sens_temp(cur, rnd_next());
    uintmax_t cur_bad = s->cur_bad;
    while (x > max || x < min) {
        cur_bad++;
        if (cur_bad > s->max_bad) {
            rnd_init();
            cur_bad = 0;
        }
        x = sens_temp(cur, rnd_next());
    }

    s->cur_bad = cur_bad;
    s->readings[s->len++] = x;
}

void
sens_pluvio_update(Sensor *s, const Sensor *temp)
{
    if (!check_len(s) || !check_len(temp))
        return;

    unsigned char x, cur = s->readings[s->len-1];
    unsigned char min = s->min_limit, max = s->max_limit;

    char ult_temp = temp->readings[temp->len-1];

    x = sens_pluvio(cur, ult_temp, rnd_next());
    uintmax_t cur_bad = s->cur_bad;
    while (x > max || x < min) {
        cur_bad++;
        if (cur_bad > s->max_bad) {
            rnd_init();
            cur_bad = 0;
        }
        x = sens_pluvio(cur, ult_temp, rnd_next());
    }

    s->cur_bad = cur_bad;
    s->readings[s->len++] = x;
}

void
sens_velc_vento_update(Sensor *s)
{
    if (!check_len(s))
        return;

    unsigned char x, cur = s->readings[s->len-1];
    unsigned char min = s->min_limit, max = s->max_limit;

    x = sens_velc_vento(cur, rnd_next());
    uintmax_t cur_bad = s->cur_bad;
    while (x > max || x < min) {
        cur_bad++;
        if (cur_bad > s->max_bad) {
            rnd_init();
            cur_bad = 0;
        }
        x = sens_velc_vento(cur, rnd_next());
    }

    s->cur_bad = cur_bad;
    s->readings[s->len++] = x;
}

void
sens_dir_vento_update(Sensor *s)
{
    if (!check_len(s))
        return;

    unsigned short x, cur = s->readings[s->len-1];
    unsigned short min = s->min_limit, max = s->max_limit;

    x = sens_dir_vento(cur, rnd_next());
    uintmax_t cur_bad = s->cur_bad;
    while (x > max || x < min) {
        cur_bad++;
        if (cur_bad > s->max_bad) {
            rnd_init();
            cur_bad = 0;
        }
        x = sens_dir_vento(cur, rnd_next());
    }

    s->cur_bad = cur_bad;
    s->readings[s->len++] = x;
}

void
sens_humd_atm_update(Sensor *s, const Sensor *pluv)
{
    if (!check_len(s) || !check_len(pluv))
        return;

    unsigned char x, cur = s->readings[s->len-1];
    unsigned char min = s->min_limit, max = s->max_limit;

    unsigned char ult_pluv = pluv->readings[pluv->len-1];

    x = sens_humd_atm(cur, ult_pluv, rnd_next());
    uintmax_t cur_bad = s->cur_bad;
    while (x > max || x < min) {
        cur_bad++;
        if (cur_bad > s->max_bad) {
            rnd_init();
            cur_bad = 0;
        }
        x = sens_humd_atm(cur, ult_pluv, rnd_next());
    }

    s->cur_bad = cur_bad;
    s->readings[s->len++] = x;
}

void
sens_humd_solo_update(Sensor *s, const Sensor *pluv)
{
if (!check_len(s) || !check_len(pluv))
        return;

    unsigned char x, cur = s->readings[s->len-1];
    unsigned char min = s->min_limit, max = s->max_limit;

    unsigned char ult_pluv = pluv->readings[pluv->len-1];

    x = sens_humd_solo(cur, ult_pluv, rnd_next());
    uintmax_t cur_bad = s->cur_bad;
    while (x > max || x < min) {
        cur_bad++;
        if (cur_bad > s->max_bad) {
            rnd_init();
            cur_bad = 0;
        }
        x = sens_humd_solo(cur, ult_pluv, rnd_next());
    }

    s->cur_bad = cur_bad;
    s->readings[s->len++] = x;
}

/* Wrappers (see header file) */
void
sens_temp_wrapper(Sensor *s, const Sensor *dummy)
{
    sens_temp_update(s);
}

void
sens_dir_vnt_wrapper(Sensor *s, const Sensor *dummy)
{
    sens_dir_vento_update(s);
}

void
sens_vel_vnt_wrapper(Sensor *s, const Sensor *dummy)
{
    sens_velc_vento_update(s);
}

/* EOF */
