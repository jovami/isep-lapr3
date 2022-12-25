#pragma once

#include <stddef.h>

typedef struct test_case test_case;

struct test_case {
    const char *restrict name;
    void (*test)(void);
};

/* US101 */
void rng_gen_run(void);

/* US110 */
void sens_vec_run(void);




/* test cases */
const test_case tests[] = {
    { .name = "US101", .test = &rng_gen_run     },
    { .name = "US110", .test = &sens_vec_run    },

    /* sentinel */
    { NULL, NULL }
};
