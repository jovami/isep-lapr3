#include <stdio.h>

#include "tests.h"

int
main(int argc, char **argv)
{
    puts("Testing all modules...\n");

    const test_case *t;
    for (t = tests; t->test; t++) {
        printf("Testing %s...\n\n", t->name);
        t->test();
        printf("\n%s tested with success!!\n\n", t->name);
    }

    puts("All tests succeeded!!");
    return 0;
}
