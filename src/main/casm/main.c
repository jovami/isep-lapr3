#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include <rnd.h>
#include <sensor_new.h>
#include <sensor_vec.h>
#include <util.h>

#include "menu.h"

static long read_int(char **tmp_buf, size_t *n);
static void sensor_ammounts(unsigned long sizes[SENS_LAST]);


long
read_int(char **bufp, size_t *n)
{
    long d;
    ssize_t len;

    if ((len = getline(bufp, n, stdin)) == -1)
        die("read_int: failed to read input: ");

    char *line = *bufp;
    line[len-1] = '\0';

    if (sscanf(line, "%ld", &d) <= 0 || d <= 0) {
        errno = EINVAL;
        return 0;
    }

    return d;
}


void
sensor_ammounts(unsigned long sizes[SENS_LAST])
{
    /* NOTE: we use signed long to disallow the
     * user to get away with typing '-1'
     * and it being valid due to integer carry
     */
    signed long amt;

    char *tmp = NULL;
    size_t n = 0;

    size_t i;
    for (i = 0; i < SENS_LAST; i++) {
        fprintf(stdout, "How many sensors of the type \"%s\"? ", strsens(i));

        while ((amt = read_int(&tmp, &n)) <= 0)
            fputs("error: invalid number\nTry again: ", stdout);
        sizes[i] = amt;
    }
    free(tmp);
    putchar('\n');
}

int
main(int argc, char **argv)
{
    /* TODO parse argv */
    unsigned long sizes[SENS_LAST];
    sensor_ammounts(sizes);

#if defined (_JOVAMI_DEBUG)
    puts("====DEBUG====");
    for (size_t __i = 0; __i < SENS_LAST; __i++)
        printf("%s: %lu\n", strsens(__i), sizes[__i]);
    puts("=============\n");
#endif /* defined (_JOVAMI_DEBUG) */

    sensor_vec pack[SENS_LAST];

    size_t i;
    for (i = 0; i < SENS_LAST; i++) {
        vec_init(pack+i, sizes[i]);
    }

    rnd_init();
    menu(pack);

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
