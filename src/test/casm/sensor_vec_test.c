#include <assert.h>
#include <stdio.h>
#include <string.h>

#include <sensor_vec.h>
#include <sensor_new.h>


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


    Sensor t1;
    sens_init(&t1, SENS_TEMP, 25, 0, 3600, 4);

    sensor_vec *v = pack+SENS_TEMP;
    vec_push(v, &t1);

    vec_push(v, sens_init(&t1, SENS_TEMP, 22, 4, 7200, 1));
    vec_push(v, sens_init(&t1, SENS_TEMP, 20, 1, 1400, 10));


    {
        puts("Checking v->max_len && v->len");

        assert(v->max_len >= 3);
        assert(v->len == 3);

        putchar('\n');
    }

    {
        puts("Checking first sensor was inserted in the right place...");

        assert(v->data[0].readings);
        assert(v->data[0].max_limit == 25);
        assert(v->data[0].min_limit == 0);
        assert(v->data[0].frequency == 3600);
        assert(v->data[0].max_bad == 4);

        putchar('\n');
    }

    {
        puts("Checking second sensor was inserted in the right place...");

        assert(v->data[1].readings);
        assert(v->data[1].max_limit == 22);
        assert(v->data[1].min_limit == 4);
        assert(v->data[1].frequency == 7200);
        assert(v->data[1].max_bad == 1);

        putchar('\n');
    }

    {
        puts("Checking third sensor was inserted in the right place...");

        assert(v->data[2].readings);
        assert(v->data[2].max_limit == 20);
        assert(v->data[2].min_limit == 1);
        assert(v->data[2].frequency == 1400);
        assert(v->data[2].max_bad == 10);

        putchar('\n');
    }

    int x;
    size_t len;

    {
        puts("Checking vec_remove() on an invalid position...");

        len = v->len;
        x = vec_remove(v, 3);
        assert(!x);
        assert(v->len == len);

        putchar('\n');
    }

    {
        puts("Checking vec_remove() on a position that causes no shifting...");

        len = v->len;
        x = vec_remove(v, 2);
        assert(x);
        assert(v->len == len-1);

        putchar('\n');
        {
            puts("Checking first sensor remains in the index 0...");

            assert(v->data[0].readings);
            assert(v->data[0].max_limit == 25);
            assert(v->data[0].min_limit == 0);
            assert(v->data[0].frequency == 3600);
            assert(v->data[0].max_bad == 4);

            putchar('\n');
        }

        {
            puts("Checking second sensor remains in the index 1...");

            assert(v->data[1].readings);
            assert(v->data[1].max_limit == 22);
            assert(v->data[1].min_limit == 4);
            assert(v->data[1].frequency == 7200);
            assert(v->data[1].max_bad == 1);

            putchar('\n');
        }
    }

    {
        puts("Checking vec_remove() on a position that causes shifting...");

        len = v->len;
        x = vec_remove(v, 0);
        assert(x);
        assert(v->len == len-1);

        putchar('\n');

        {
            puts("Checking third sensor got moved to index 0...");

            assert(v->data[0].readings);
            assert(v->data[0].max_limit == 22);
            assert(v->data[0].min_limit == 4);
            assert(v->data[0].frequency == 7200);
            assert(v->data[0].max_bad == 1);

            putchar('\n');
        }
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
