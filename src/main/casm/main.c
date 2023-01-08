/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#include <errno.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

#include <rnd.h>
#include <sensor_impl.h>
#include <sensor_vec.h>
#include <util.h>

#include "bootstrap.h"
#include "conf/confparser.h"
#include "menu.h"

__attribute__((__always_inline__))
static inline size_t getwhilebad(char **tmp_buf, size_t *n);

static void set_sizes_freqs(size_t sizes[SENS_LAST], char loaded_conf, unsigned long freqs[SENS_LAST]);
static void help(void);

size_t
getwhilebad(char **tmp, size_t *n)
{
    /* NOTE: we use ssize_t instead of size_t
     * to disallow the user to get away with typing '-1'
     * and it being valid due to integer carry
     */
    ssize_t val;
    while ((val = read_int(tmp, n)) <= 0)
        fputs("error: invalid number\nTry again: ", stderr);
    return val;
}

void
set_sizes_freqs(size_t sizes[SENS_LAST], char loaded_conf, unsigned long freqs[SENS_LAST])
{
    char *tmp = NULL;
    size_t n = 0;

    size_t i;
    for (i = 0; i < SENS_LAST; i++) {
        fprintf(stdout, "How many sensors of the type \"%s\"? ", strsens(i));
        sizes[i] = getwhilebad(&tmp, &n);

        if (!loaded_conf) {
            fputs("What should the default frequency be? (seconds) ", stdout);
            freqs[i] = getwhilebad(&tmp, &n);
        }
        putchar('\n');
    }
    free(tmp);
}

int
main(int argc, char **argv)
{
    char loaded_conf = 0;
    unsigned long freqs[SENS_LAST];

    int opt, option_index = 0;
    const char *optstr = "hc:";

    static struct option opts[] = {
        { "config", required_argument, 0, 'c' },
        { "help",   no_argument,       0, 'h' },
    };

    while ((opt = getopt_long(argc, argv, optstr, opts, &option_index)) != -1) {
        switch (opt) {
        case 'c':
            loaded_conf = parsefreqs(optarg, freqs);
            break;
        case 'h':
            help();
            exit(EXIT_SUCCESS);
            break;
        default:
            exit(EXIT_FAILURE);
        }
    }

    size_t sizes[SENS_LAST];
    set_sizes_freqs(sizes, loaded_conf, freqs);

    sensor_vec pack[SENS_LAST];

    size_t i;
    for (i = 0; i < SENS_LAST; i++) {
        vec_init(pack+i, sizes[i]);
    }

    rnd_init();
    bootstrap(pack, freqs);
    menu(pack);

    /* cleanup */
    for (i = 0; i < SENS_LAST; i++)
        vec_free(pack+i);
    return 0;
}

void
help(void)
{
    printf("usage: %s [ -c | --config config_file ]\n", PROGNAME);
}
