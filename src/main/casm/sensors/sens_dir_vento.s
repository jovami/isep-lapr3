.data
        .equ MAXVAR, 5          #valo que permitirá saber a variação maxima aceite entre medicoes consecutivas
        .equ DIVIDING, 2        #valor que vai divdir a comp_rand ate ter um valor aceitavel para fazer a mudanca

        .equ MAX_VALUE, 359     #valor max retornado por este sensor
        .equ MIN_VALUE, 0       #valor min retornado por este sensor


.text
        .global sens_dir_vento

sens_dir_vento:      #unsigned short sens_dir_vento(unsgined short ult_dir_vento, short comp_rand) 

        pushq %rbp
        movq %rsp, %rbp         #prologue 

        #handling low values
        cmpw $4, %di
        jb too_low
        cmpw $356, %di
        ja too_high
        
verify:
        pushq %rdi
        pushq %rsi
        
        movb $MAXVAR, %dl       

        #di -> ultimo valor
        #si -> comp_rand
        #dl -> delta

        call verify_value_generated     #não permite variações drásticas

        popq %rsi
        popq %rdi

        cmpb $0, %al                    #al == 0, valor nao aceite
        je new_value

values_min_max:

        # ult valor + valor gerado
        movw %di, %ax          
        addw %si, %ax           

        # valores obtidos estão de acordo com o max e minimo -> (max: 359, min: 0)
        cmpw $MAX_VALUE, %ax            
        jbe end

        cmpw $MIN_VALUE, %ax
        jae end  

new_value:

        #dividing previous value
        movw $DIVIDING, %r8w

        movw %si, %ax
        cwd

        #divisoes consecutivas por DIVIDING, ate encontrar um valor aceite
        idivw %r8w        
        movw %ax, %si

        jmp verify

end:
        movq %rbp, %rsp         #epilogue
        popq %rbp

        ret

too_low:             #TODO controlo de valores muito pequenos
        movw $352, %ax
        jmp end
too_high:
        movw $6, %ax
        jmp end


        
