#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

