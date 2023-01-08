.data
        .equ MAXVAR, 5  # maxvar < (ult_value * 0,20), according to client specifications
        .equ DECLIVE, 30
        .equ UNIDADE, 100

        # temp(30) -> 100(1)
        # X        ->   25(0,25)

.text
        .global sens_pluvio

sens_pluvio:      #unsigned char sens_pluvio(unsigned char ult_pluvio, char ult_temp, char comp_rand)

        pushq %rbp
        movq %rsp, %rbp

get_delta:

        #sens_pluvio = (ult_pluvio)+((DECLIVE/ult_temp)) + comp_rand

        #(DECLIVE/ult_temp)+ comp_rand
        cmpb $0, %sil
        je ult_pluvio_zero           # if temp = 0, can't divide by 0                # if temp = 0, can't divide by 0

        movb $DECLIVE, %al
        cmpb $0, %dl
        je add_one
        cbtw
        idiv %dl

cont:
        addb %sil, %al
        addb %dl, %al


        movw $UNIDADE, %ax
        movb %sil, %r9b
        div %r9b


        addb %al, %dl
        #%dl val_modificacao

verify_ult_pluvio:
        xorb %al, %al

        cmpb $0, %dil
        jne ult_pluvio_zero

        # ult pluvio == 0, delta < 0, pluv = 0


ult_pluvio_zero:
        cmpb $0, %dl
        jl end_ret

        addb %dl,%dil
        movb %dil, %al

end_ret:

        movq %rbp, %rsp         #epilogue
        popq %rbp

        ret

add_one:
        addb $1, %dl
        jmp cont

