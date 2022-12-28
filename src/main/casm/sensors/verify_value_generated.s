.data
        .equ MINIMUM,4
        .equ SHIFT_GET_SINAL, 15

        #
        # Verifica se o valor gerado não irá implicar uma mudança drástica
        # no ultimo valor gerado.
        #
        # @param value_ref valor de referencia
        # @param generated valor gerado
        # @param delta valor que determina qual sera um delta para um determinado valor gerado
        #      ser considerado uma mudançã drástica
        #
        #
        # char verify_value_generated(unsigned short value_ref, short generated, unsigned char delta);
.text
        .global verify_value_generated

verify_value_generated: # (unsigned short valor_ref, short gerado, unsigned char delta)

        # ret 0 se o valor gerado implica uma variação drástica, caso contrário ret 1

        pushq %rbp
        movq %rsp, %rbp

        #cl é o valor de controlo que no final da função é movido para al
        #instanciar cl a 0
        xorb %cl, %cl

        #caso o valor de referencia seja muito baixo:
        #tratar a verificação de maneira diferente
        cmpw $0, %di
        je too_low

        #obter o falor absoluto de generated
        #verificar se generated tem sinal positivo

        movw %si, %r8w
        shr $SHIFT_GET_SINAL, %r8w
        cmpw $0, %r8w

        je positive

        #se gerado for negativo, fazemos a sua negação
        #obtendo assim o seu valor absoluto
        negw %si

        cmpw $MINIMUM, %si
        jle too_low

positive:

        #nao permite executar a divisao por 0
        cmpb $0,%dl
        je end

        #fazendo valor_ref/delta, obtemos o valor maximo de variação aceitavel
        movw %di, %ax           #reference value
        divb %dl                #valor de referencia / delta

        movzbw %al, %ax

        #comparar o valor maximo de variação com o absoluto de gerado
        cmpw %ax, %si
        jl is_valid

end:
        movb %cl, %al

        movq %rbp, %rsp
        popq %rbp

        ret

too_low:
        cmpw $MINIMUM, %si
        movb $2,%al
        ja end

is_valid:
        movb $1, %cl
        jmp end

