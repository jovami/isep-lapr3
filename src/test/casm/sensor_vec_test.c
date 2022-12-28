#include <assert.h>
#include <stdio.h>

#include <sensor_impl.h>
#include <sensor_vec.h>

__attribute__((__always_inline__))
static inline void assert_sensor(const Sensor *s1, const Sensor *s2);

static inline void
assert_sensor(const Sensor *s1, const Sensor *s2)
{
    assert(s1->id == s2->id);
    assert(s1->sensor_type == s2->sensor_type);
    assert(s1->max_limit == s2->max_limit);
    assert(s1->min_limit == s2->min_limit);
    assert(s1->frequency == s2->frequency);
    assert(s1->readings_size == s2->readings_size);
    assert(s1->readings == s2->readings);
    assert(s1->len == s1->len);
    assert(s1->max_bad == s2->max_bad);
    assert(s1->cur_bad == s2->cur_bad);
}


void
sens_vec_run(void)
{
    int i;

    puts("Testing sens_vec functions...\n");

    unsigned long sizes[SENS_LAST];
    for (i = 0; i < SENS_LAST; i++)
        sizes[i] = 14;

    sensor_vec pack[SENS_LAST];
    for (i = 0; i < SENS_LAST; i++)
        vec_init(pack+i, sizes[i]);


    Sensor t1, t2, t3;
    sens_init(&t1, SENS_TEMP, 30, 25, 0, 3600, 4);
    sens_init(&t2, SENS_TEMP, 44, 22, 4, 7200, 1);
    sens_init(&t3, SENS_TEMP, -5, 20, 1, 1400, 10);

    sensor_vec *v = pack+SENS_TEMP;


    {
        puts("Checking vec_push()...");
        assert(vec_push(v, &t1));
        assert(vec_push(v, &t2));
        assert(vec_push(v, &t3));
        putchar('\n');


        puts("Checking v->max_len && v->len...");
        assert(v->max_len >= 3);
        assert(v->len == 3);
        putchar('\n');

        puts("Checking first sensor was inserted in the right place...");
        assert_sensor(v->data+0, &t1);
        putchar('\n');

        puts("Checking second sensor was inserted in the right place...");
        assert_sensor(v->data+1, &t2);
        putchar('\n');

        puts("Checking third sensor was inserted in the right place...");
        assert_sensor(v->data+2, &t3);
        putchar('\n');
    }

    int x;
    size_t len;

    {
        puts("Checking vec_remove() on an invalid position...");

        const Sensor *s1, *s2, *s3;
        s1 = v->data+0;
        s2 = v->data+1;
        s3 = v->data+2;

        len = v->len;
        x = vec_remove(v, 3);
        assert(!x);
        assert(v->len == len);

        putchar('\n');

        puts("Checking no sensors got altered...");
        assert_sensor(v->data+0, s1);
        assert_sensor(v->data+1, s2);
        assert_sensor(v->data+2, s3);
        putchar('\n');
    }

    {
        puts("Checking vec_remove() on a position that causes no shifting...");

        len = v->len;
        x = vec_remove(v, 2);
        assert(x);
        assert(v->len == len-1);

        putchar('\n');

        puts("Checking first sensor remains at index 0...");
        assert_sensor(v->data+0, &t1);
        putchar('\n');

        puts("Checking second sensor remains at index 1...");
        assert_sensor(v->data+1, &t2);
        putchar('\n');
    }

    {
        puts("Checking vec_remove() on a position that causes shifting...");

        len = v->len;
        x = vec_remove(v, 0);
        assert(x);
        assert(v->len == len-1);

        putchar('\n');

        puts("Checking second sensor got moved to index 0...");
        assert_sensor(v->data+0, &t2);
        putchar('\n');
    }

    {
        puts("Checking vec_free()...");

        for (i = 0; i < SENS_LAST; i++)
            vec_free(pack+i);
        assert(v->len == 0);

        putchar('\n');
    }

    puts("All tests passed!");
}
