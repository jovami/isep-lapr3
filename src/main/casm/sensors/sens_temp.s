.data
        .equ MAXVAR, 10  #0,20 according to client specifications

.text
        .global sens_temp

sens_temp:      #char sens_temp(char ult_temp, char comp_rand)

        pushq %rbp
        movq %rsp, %rbp         #prologue
        
verify:

        movb $MAXVAR, %dl

        pushq %rdi
        pushq %rsi
        pushq %rdx

        andb $0x7f, %dil
        movzbw %dil, %di
        movsbw %sil, %si

        call verify_value_generated
        popq %rdx
        popq %rsi
        popq %rdi

        cmpb $0,%al             #al=0 valor nao aceite
        jne end         

new_value:

        pushq %rdi
        pushq %rsi      
        pushq %rdx
        
        call rnd_next    

        popq %rdx
        popq %rsi
        popq %rdi
  
        movb %al, %sil

        jmp verify


end:
        addb %sil, %dil
keep_end:
        movb %dil, %al

        movq %rbp, %rsp         #epilogue
        popq %rbp

        ret


