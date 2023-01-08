/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#include <signal.h>
#include <stdio.h>
#include <unistd.h>

#include <sensor_impl.h>
#include <sensor_vec.h>
#include <util.h>

#include "gen_sens_values.h"

static void stop_handler(int);

static const sens_upd_t wrappers[SENS_LAST] = {
    [SENS_TEMP] = &sens_temp_wrapper,
    [SENS_PLUV] = &sens_pluvio_update,
    [SENS_DIR_VNT] = &sens_dir_vnt_wrapper,
    [SENS_VEL_VNT] = &sens_vel_vnt_wrapper,
    [SENS_HUM_ATM] = &sens_humd_atm_update,
    [SENS_HUM_SOL] = &sens_humd_solo_update
};

static int running = 0;

void
stop_handler(int unused)
{
    running = 0;
}

void
gen_sens_values(sensor_vec *pack)
{
    static const struct sigaction loop_action = { .sa_handler = &stop_handler };
    static const struct sigaction stop_action = { .sa_handler = SIG_DFL };

    if (sigaction(SIGINT, &loop_action, NULL) == -1)
        die("gen_sens_values: could not install signal: ");

    static const unsigned int timeout = 3;
    printf("Generation of values will begin in %u seconds\n"
           "If you wish to exit earlier, hit \"Control + C\" on your keyboard\n",
           timeout);
    sleep(timeout);

    running = 1;

    int time = 0;
    while (running) {
        printf("\n--------------------------%d--------------------------\n",
               time+1);

        for (enum SensorType i = 0; i < SENS_LAST; i++) {
            sensor_vec *aux_v = NULL;
            switch (i) {
            case SENS_PLUV:
                aux_v = pack + SENS_TEMP;
                break;
            case SENS_HUM_ATM:
                aux_v = pack + SENS_PLUV;
                break;
            case SENS_HUM_SOL:
                aux_v = pack + SENS_PLUV;
                break;
            case SENS_TEMP: /* no op */
            case SENS_DIR_VNT:
            case SENS_VEL_VNT:
            default:
                break;
            }

            const Sensor *aux = aux_v ? aux_v->data + aux_v->len-1 : NULL;

            const sensor_vec *v = (pack+i);
            Sensor *data = v->data;
            const size_t len = v->len;

            sens_upd_t wrapper = wrappers[i];
            for (size_t j = 0; j < len; j++) {
                Sensor *s = data+j;

                /* NOTE: we only want to generate new values if
                 * time is a multiple of the frequency */
                if ((time % s->frequency) == 0) {
                    wrapper(s, aux);
                    if (i == SENS_TEMP)
                        printf("%s %zu: %hhd\n", strsens(i), j+1,
                               (signed char) s->readings[s->len-1]);
                    else
                        printf("%s %zu: %hu\n", strsens(i), j+1, s->readings[s->len-1]);
                }
            }
        }

        time++;
        sleep(1);
    }

    if (sigaction(SIGINT, &stop_action, NULL) == -1)
        die("gen_sens_values: could not install signal: ");
    putchar('\n');
}

