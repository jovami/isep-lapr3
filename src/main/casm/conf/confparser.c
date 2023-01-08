/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#include <stdio.h>

#include "confparser.h"
#include "iniparser.h"

#define FREQ_KEY        "frequency"
#define DEFAULT_FREQ    1

static const char *secnames[SENS_LAST] = {
    [SENS_TEMP] = "temp",
    [SENS_PLUV] = "pluvio",
    [SENS_DIR_VNT] = "dir_vento",
    [SENS_VEL_VNT] = "velc_vento",
    [SENS_HUM_ATM] = "humd_atm",
    [SENS_HUM_SOL] = "humd_solo"
};

char
parsefreqs(const char *restrict confname, unsigned long freqs[SENS_LAST])
{
    dictionary *d;
    char buf[30] = {0};

    if (!(d = iniparser_load(confname)))
        return PARSE_FAIL;

    for (enum SensorType i = 0; i < SENS_LAST; i++) {
        int ret = snprintf(buf, sizeof(buf), "%s:%s", secnames[i], FREQ_KEY);
        if (ret < 0 || ret >= sizeof(buf)) {
            fputs("parsefreqs: buf is too small", stderr);
            return PARSE_FAIL;
        }

        freqs[i] = iniparser_getlongint(d, buf, DEFAULT_FREQ);
    }

    iniparser_freedict(d);
    return PARSE_SUC;
}
