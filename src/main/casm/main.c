#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include <rnd.h>
#include <sensor_impl.h>
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

    {
        /* FIXME: do this in a better way */
        Sensor t1, p1, dv1, vv1, ha1, hs1;
        sens_init(&t1,
                  SENS_TEMP,
                  30,
                  TEMP_LIM_MAX,
                  TEMP_LIM_MIN,
                  2,
                  MAX_BAD_VALUES);
        sens_init(&p1,
                  SENS_PLUV,
                  70,
                  PLUVIO_LIM_MAX,
                  PLUVIO_LIM_MIN,
                  1,
                  MAX_BAD_VALUES);
        sens_init(&dv1,
                  SENS_DIR_VNT,
                  70,
                  DIR_VENTO_LIM_MAX,
                  DIR_VENTO_LIM_MIN,
                  2,
                  MAX_BAD_VALUES);
        sens_init(&vv1,
                  SENS_VEL_VNT,
                  50,
                  VELC_VENTO_LIM_MAX,
                  VELC_VENTO_LIM_MIN,
                  1,
                  MAX_BAD_VALUES);
        sens_init(&ha1,
                  SENS_HUM_ATM,
                  30,
                  HUMD_ATM_LIM_MAX,
                  HUMD_ATM_LIM_MIN,
                  2,
                  MAX_BAD_VALUES);
        sens_init(&hs1,
                  SENS_HUM_SOL,
                  40,
                  HUMD_SOLO_LIM_MAX,
                  HUMD_SOLO_LIM_MIN,
                  1,
                  MAX_BAD_VALUES);

        vec_push(pack+SENS_TEMP, &t1);
        vec_push(pack+SENS_PLUV, &p1);
        vec_push(pack+SENS_DIR_VNT, &dv1);
        vec_push(pack+SENS_VEL_VNT, &vv1);
        vec_push(pack+SENS_HUM_ATM, &ha1);
        vec_push(pack+SENS_HUM_SOL, &hs1);
    }

    rnd_init();
    menu(pack);

    /* daily_matrix(data_temp, data_dir_vento, data_velc_vento, data_humd_atm, data_humd_solo, data_pluvio); */

    for (i = 0; i < SENS_LAST; i++)
        vec_free(pack+i);
    return 0;
}
