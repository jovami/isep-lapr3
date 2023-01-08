/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#pragma once

#include <sensor_impl.h>

enum {
    PARSE_FAIL,
    PARSE_SUC,
};

char parsefreqs(const char *restrict confname, unsigned long freqs[SENS_LAST]);
