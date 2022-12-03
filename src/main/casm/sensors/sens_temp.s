.data
        .equ MAXVAR, 5  #0,20 according to client specifications

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
/*
        movb %dil, %r8b
        shr $7,%r8b
        cmpb $0, %r8b
        je last_value_positive             #get absolute value

        negb %dil
        
last_value_positive:
        
        xorb %cl, %cl

        movsbw %dil, %ax
        idiv %dl

        cmpb %sil, %al
        jg not_check

        negb %al
 
        cmpb %sil, %al
        jl not_check   

        movb $1, %cl

not_check:
*/
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
        jo over
        movb %dil, %al

        movq %rbp, %rsp         #epilogue
        popq %rbp

        ret


over:
        subb %sil, %dil
        jmp keep_end
