#include <stdio.h>

#include "tests.h"

int
main(int argc, char **argv)
{
    puts("Testing all modules...\n");

    puts("Testing US 101...\n");
    rng_gen_run();
    puts("\nUS101 tested with success!!\n");

    puts("\nAll tests succeeded!!");
    return 0;
}
