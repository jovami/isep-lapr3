/* Copyright (c) 2022 Jovami. All Rights Reserved. */

#include <stdio.h>

#include "menu.h"
#include "dailymatrix/dailymatrix.h"


/***********************************/

/* FIXME: use the actual functions */
void foo(sensor_vec *pack);
void bar(sensor_vec *pack);
void baz(sensor_vec *pack);
void idk(sensor_vec *pack);

void foo(sensor_vec *pack)
{
    puts("foo!!");
}

void bar(sensor_vec *pack)
{
    puts("bar!!");
}

void baz(sensor_vec *pack)
{
    puts("baz!!");
}

void idk(sensor_vec *pack)
{
    puts("idk!!");
}

/***********************************/

typedef void (*MenuItem)(sensor_vec *pack);


enum {
    ADD_SENS,
    ALTER_FREQ,
    GENERATE_VALUES,
    DAILY_MATRIX,

    /* NOTE: do not use */
    MENU_LST
};

#define MENU_OPTS_STR \
    "1) Add/Remove sensors\n" \
    "2) Alter sensor frequencies\n" \
    "3) Generate sensor values\n" \
    "4) Daily matrix and export sensor values\n" \
    "0) Quit\n" \

#define MENU_FST    ADD_SENS
#define QUIT        (MENU_FST-1)
#define MATCH(X)    ((X) >= MENU_FST && (X) < MENU_LST)


__attribute__((__always_inline__))
static inline char getchar_flush(void);


static const MenuItem items[MENU_LST] = {
    &foo,
    &bar,
    &baz,
    &idk,
};


char
getchar_flush(void)
{
    char _, c;
    c = getchar();

    while ((_ = getchar()) != '\n' && _ != EOF)
        ; /* no-op */
    return c;
}


void
menu(sensor_vec *pack)
{
    int opt;
    char bad_opt = 0, running = 1;

    do {
        if (!bad_opt) {
            puts("Main menu");
            puts("=========\n");
        }

        /* refresh */
        bad_opt = 0;

        fputs(MENU_OPTS_STR"\nChoose one: ", stdout);
        opt = getchar_flush() - '1';
        putchar('\n');

        if (MATCH(opt)) {
            items[opt](pack);
        } else if (opt == QUIT) {
            running = 0;
        } else {
            bad_opt = 1;
            fprintf(stderr, "error: invalid option: %d\n", opt+1);
        }

        putchar('\n');
    } while (running);
}

/* EOF */
