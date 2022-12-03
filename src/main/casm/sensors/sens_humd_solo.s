.data
        .equ MAXVAR, 5  # maxvar < (ult_value * 0,20), according to client specifications
        .equ DECLIVE, 5 


.text
        .global sens_humd_solo

sens_humd_solo:      #unsigned char sens_humd_atm(unsigned char ult_hmd_atm, unsigned char ult_pluvio ,char comp_rand)

        pushq %rbp
        movq %rsp, %rbp         #prologue

        
get_delta:

        #sens_humd_atm = (ult_humd_atm)+((ult_pluvio/DECLIVE)) + comp_rand

        #(sil/declive)+ comp_rand
        movb $DECLIVE, %r9b
        movzbw %sil, %ax
        div %r9b

        addb %al, %dl
        #%dl val_modificacao
        
        # ult pluvio == 0 implcia não haver variações drásticas
        cmpb $0, %sil
        jne end


verify:
        pushq %rdi
        pushq %rsi
        pushq %rdx
        
        movzbw %dil, %di
        movsbw %dl, %si       #valor_modificacao
        movb $MAXVAR, %dl       

        #dil -> ultimo valor
        #sil -> comp_rand
        #dl -> delta

        call verify_value_generated
        

        popq %rdx
        popq %rsi
        popq %rdi

        cmpb $0, %al    #al == 0, valor nao aceite
        jne end

new_value:

        pushq %rdi
        pushq %rsi      
        pushq %rdx
        
        call rnd_next    

        popq %rdx
        popq %rsi
        popq %rdi
  
        movb %al, %dl

        jmp get_delta

end:
        addb %dl, %dil          #ult_hmd_solo + valor_modificação
        movb %dil, %al

        movq %rbp, %rsp         #epilogue
        popq %rbp

        ret

