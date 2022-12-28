#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include <rnd.h>
#include <sensor_impl.h>
#include <sensor_vec.h>
#include <util.h>

#include "bootstrap.h"
#include "menu.h"

static ssize_t read_int(char **tmp_buf, size_t *n);
static void setnumsensors(size_t sizes[SENS_LAST]);

ssize_t
read_int(char **bufp, size_t *n)
{
    ssize_t d, len;

    if ((len = getline(bufp, n, stdin)) == -1)
        die("read_int: failed to read input: ");

    char *line = *bufp;
    line[len-1] = '\0';

    if (sscanf(line, "%zd", &d) <= 0 || d <= 0) {
        errno = EINVAL;
        return 0;
    }

    return d;
}

void
setnumsensors(size_t sizes[SENS_LAST])
{
    /* NOTE: we use ssize_t instead of size_t
     * to disallow the user to get away with typing '-1'
     * and it being valid due to integer carry
     */
    ssize_t amt;

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
    unsigned long freqs[SENS_LAST];
    {
        /* NOTE: temporary */
        for (size_t i = 0; i < SENS_LAST; i++)
            freqs[i] = 1;
    }

    size_t sizes[SENS_LAST];
    setnumsensors(sizes);

#if defined (_JOVAMI_DEBUG)
    puts("====DEBUG====");
    for (size_t __i = 0; __i < SENS_LAST; __i++)
        printf("%s: %zu\n", strsens(__i), sizes[__i]);
    puts("=============\n");
#endif /* defined (_JOVAMI_DEBUG) */

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
