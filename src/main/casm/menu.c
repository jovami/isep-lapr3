/* Copyright (c) 2022 Jovami. All Rights Reserved. */

#include "menu.h"
/**********************************/

static const MenuItem items[MENU_LST] = {
    &add_remove_sensors,
    &sens_freqs,
    &gen_sens_values,
    &daily_matrix,
    &list_sensors,
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

void print_success_msg()
{
    puts("\nOperation Completed With Success!\n");
    sleep(1);
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
