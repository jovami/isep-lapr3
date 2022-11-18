#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include <util.h>


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
