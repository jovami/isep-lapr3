/* Copyright (c) 2023 Jovami. All Rights Reserved. */

#include <stdio.h>

#include <rnd.h>
#include <util.h>

extern uint32_t __rnd_gen(uint64_t *, uint64_t);

static uint64_t state = 0;
static uint64_t inc = 0;

#if defined (__unix__) || defined (__APPLE__) || defined (__CYGWIN__)
# define RND_FILE   ("/dev/urandom")
#else
# error "Host OS does not support /dev/urandom or similar"
#endif /* defined (__unix__) || defined (__APPLE__) || defined (__CYGWIN__) */

void
rnd_init(void)
{
    FILE *f;
    uint64_t buf[2];

    if (!(f = fopen(RND_FILE, "r")))
        die("rnd_init: fopen: ");

    if ((fread(buf, sizeof(*buf), LENGTH(buf), f)) != LENGTH(buf)) {
        fclose(f);
        die("rnd_init: failed to initialize state & inc!");
    }

    state = buf[0];
    inc = buf[1];

    fclose(f);
}

uint32_t
rnd_next(void)
{
    return __rnd_gen(&state, inc);
}
