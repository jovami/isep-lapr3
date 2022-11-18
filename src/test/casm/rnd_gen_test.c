#include <stdio.h>
#include <stdint.h>
#include <assert.h>

#define MAGIC_NUM   (6364136223846793005ULL)

static uint64_t state = 0;
static uint64_t inc = 0;

extern uint32_t __rnd_gen(uint64_t *, uint64_t);

static uint32_t pcg32_random_r(void);


/* Provided by the professors */
uint32_t
pcg32_random_r(void)
{
    uint64_t oldstate = state;

    state = oldstate * MAGIC_NUM + (inc | 1);

    uint32_t xorshifted = ((oldstate >> 18u) ^ oldstate) >> 27u;
    uint32_t rot = oldstate >> 59u;

    return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}

void
rng_gen_run(void)
{
    const int nr_tests = 10;
    uint64_t _state, _inc;

    puts("Testing __rnd_gen()...");

    /* Round 1 */

    _state = 19391202ULL;
    _inc = 2193021ULL;

    state = _state;
    inc = _inc;

    for (int i = 0; i < nr_tests; i++) {
        assert(__rnd_gen(&_state, _inc) == pcg32_random_r());
        assert(_state == state);
        assert(_inc == inc);
    }

    /* Round 2 */

    _state = 1890410849192390ULL;
    _inc = 91284910801829ULL;

    state = _state;
    inc = _inc;

    for (int i = 0; i < nr_tests; i++) {
        assert(__rnd_gen(&_state, _inc) == pcg32_random_r());
        assert(_state == state);
        assert(_inc == inc);
    }

    puts("All tests passed!");
}
