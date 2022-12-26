#include <errno.h>
#include <stdlib.h>

#include <sensor_new.h>
#include <util.h>

#define DAYS_SECS       (24UL * 3600UL)
#define freq_to_sz(f)   (DAYS_SECS / (f))

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
