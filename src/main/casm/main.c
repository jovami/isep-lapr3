#include <errno.h>
#include <stdio.h>

#include <rnd.h>
#include <sensor_vec.h>
#include <sensor_new.h>
#include <stdlib.h>

#include "menu.h"
#include "util.h"

static long read_int(char **tmp_buf, size_t *n);
static void sensor_ammounts(unsigned long sizes[SENS_LAST]);


long
read_int(char **tmp_buf, size_t *n)
{
    long d;

    ssize_t len = 0;

    if ((len = getline(tmp_buf, n, stdin)) == -1)
        die("read_int: failed to read input: ");

    char *line = *tmp_buf;
    line[len-1] = '\0';

    if (sscanf(line, "%ld", &d) <= 0) {
        errno = EINVAL;
        return 0;
    }

    if (d == 0)
        errno = EINVAL;
    return d;
}


void
sensor_ammounts(unsigned long sizes[SENS_LAST])
{
    int i;
    long amt;

    char *tmp;
    size_t n = 0;

    for (i = 0; i < SENS_LAST; i++) {
        fprintf(stdout, "How many sensors of the type \"%s\"? ", strsens(i));

        amt = read_int(&tmp, &n);

        while (amt <= 0) {
            fputs("error: invalid number\nTry again: ", stdout);
            amt = read_int(&tmp, &n);
        }

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

    sensor_vec pack[SENS_LAST];

    int i;
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
