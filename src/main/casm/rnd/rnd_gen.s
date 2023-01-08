# Copyright (c) 2023 Jovami. All Rights Reserved.

    .text

    .globl  __rnd_gen
    .type   __rnd_gen, @function
__rnd_gen:
    pushq   %rbp
    movq    %rsp, %rbp

    movq    (%rdi), %rcx    # oldstate

    ## update state ##
    movabsq $6364136223846793005, %rax
    mulq    %rcx

    orq     $1, %rsi
    leaq    (%rax, %rsi,), %rax
    movq    %rax, (%rdi)
    ## update state ##

    movq    %rcx, %rax      # copy of oldstate

    shrq    $18, %rax
    xorq    %rcx, %rax
    shrq    $27, %rax

    # xorshifted in %eax

    shrq    $59, %rcx       # rot

    movl    %eax, %edx

    shrl    %cl, %eax
    negl    %ecx
    andl    $31, %ecx
    shll    %cl, %edx

    orl     %edx, %eax

    popq    %rbp
    ret
