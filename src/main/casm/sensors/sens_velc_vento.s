.text
        .global sens_velc_vento

sens_velc_vento:      #unsigned char sens_velc_vento(unsigned char ult_velc_vento, char comp_rand)

    pushq %rbp
    movq %rsp, %rbp


    #ult_velc_vento + (valor random positivo ou negativo)
    addb %sil, %dil
    movb %dil, %al

    movq %rbp, %rsp
    popq %rbp

    ret

