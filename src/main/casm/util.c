/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <util.h>


__attribute__((__always_inline__))
static inline int __check_overflow(size_t n, size_t m);

inline int
__check_overflow(size_t m, size_t n)
{
    /* NOTE: taken from musl libc
     * ⬝https://github.com/bminor/musl/blob/master/src/malloc/calloc.c
     */
    return n && m > (size_t) -1/n;
}


void
die(const char *restrict fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);

    if (*fmt && fmt[strlen(fmt)-1] == ' ')
        perror(NULL);
    else
        fputc('\n', stderr);

    exit(EXIT_FAILURE);
}

void *
arqcp_calloc(size_t nmemb, size_t size)
{
    void *p;

    if (!(p = calloc(nmemb, size)))
        die("arqcp_calloc: ");
    return p;
}

void *
arqcp_malloc(size_t nmemb, size_t size)
{
    void *p;

    if (__check_overflow(nmemb, size))
        die("arqcp_malloc: overflow detected with params %zu and %zu",
                nmemb, size);
    else if (!(p = malloc(nmemb * size)))
        die("arqcp_malloc: ");

    return p;
}

void *
arqcp_realloc(void *ptr, size_t nmemb, size_t size)
{
    void *p;

    if (!(p = reallocarray(ptr, nmemb, size)))
        die("arqcp_realloc: ");

    return p;
}

ssize_t read_int_wrapper(void){
    char *c =NULL;
    size_t i = 0;
    ssize_t ret = read_int(&c, &i);

    free(c);
    return ret;
}

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

char
*get_date(void) {
    // Get the current time
    time_t t = time(NULL);
    struct tm tm = *localtime(&t);

    // Allocate a buffer large enough to hold the formatted string
    char *date = arqcp_malloc(11, 1);

    // Format the date string using strftime and add a null terminator
    strftime(date, 11, "%Y-%m-%d", &tm);
    date[10] = '\0';

    return date;
}
