#include <stdio.h>

#include <rnd.h>
#include <sensor_vec.h>
#include <sensor_new.h>

#include "dailymatrix/dailymatrix.h"

#define MENU_OPTS_STR \
    "1) WIP\n" \
    "2) WIP\n" \
    "3) Generate sensor values\n" \

enum {
    /* TODO: add remaining entries */
    GENERATE_VALUES = 3
};

__attribute__((__always_inline__))
static inline char getchar_flush(void)
{
    char _, c;
    c = getchar();

    while ((_ = getchar()) != '\n' && _ != EOF)
        ; /* no-op */
    return c;
}

void
menu(void)
{
}

int
main(int argc, char **argv)
{
    unsigned long sizes[SENS_LAST];

    {
        /* FIXME: placeholder */
        for (int i = 0; i < SENS_LAST; i++)
            sizes[i] = 14;
    }


    sensor_vec pack[SENS_LAST];

    int i;
    for (i = 0; i < SENS_LAST; i++) {
        vec_init(pack+i, sizes[i]);
    }

    rnd_init();

    char opt, bad_opt = 0, quit = 0;

    do {
        if (!bad_opt) {
            puts("Main menu");
            puts("=========\n");
        }

        fputs(MENU_OPTS_STR"\nChoose one: ", stdout);
        opt = getchar_flush() - '0';
        putchar('\n');

        switch (opt) {
        case 1:
            /* ... */
            break;
        case 2:
            /* ... */
            break;
        case GENERATE_VALUES:
            /* ... */
            break;
        case 4:
            quit = 1;
        default:
            fprintf(stderr, "error: invalid option: %hhd\n\n", opt);
        }
    } while (!quit);



    /* char data_temp[CYCLES]; */
    /* unsigned short data_dir_vento[CYCLES]; */
    /* unsigned char data_velc_vento[CYCLES]; */
    /* unsigned char data_humd_atm[CYCLES]; */
    /* unsigned char data_humd_solo[CYCLES]; */
    /* unsigned char data_pluvio[CYCLES]; */

    /* rnd_init(); */
    /* gen_sens_values(data_temp,data_dir_vento,data_velc_vento,data_humd_atm,data_humd_solo,data_pluvio); */

    /* daily_matrix(data_temp, data_dir_vento, data_velc_vento, data_humd_atm, data_humd_solo, data_pluvio); */

    for (i = 0; i < SENS_LAST; i++)
        vec_free(pack+i);
    return 0;
}
