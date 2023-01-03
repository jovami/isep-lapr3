---------------------------
----------[US210]----------
---------------------------

------------------------------------------------------------------------------------------------
----------------------------------CRITERIOS DE ACEITACAO 1 E 2----------------------------------
------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE p_registar_operacao (
    v_parcela_agricola_id IN parcela_agricola.parcela_agricola_id%TYPE,
    v_fator_producao_id IN fator_producao.fator_producao_id%TYPE,
    v_data_fertilizacao IN registo_fertilizacao.data_fertilizacao%TYPE,
    v_tipo_fertilizacao IN tipo_fertilizacao.tipo_fertilizacao_id%TYPE,
    v_quantidade IN registo_fertilizacao.quantidade_utilizada_kg%TYPE
)
IS 
    l_existe_restricao INTEGER;   -- verdadeiro se != 0
BEGIN
    SELECT count(*) INTO l_existe_restricao
    FROM registo_restricao R
    WHERE R.parcela_agricola_id = v_parcela_agricola_id
    AND R.data_inicio <= v_data_fertilizacao
    AND R.data_fim >= v_data_fertilizacao
    AND R.fator_producao_id = v_fator_producao_id;

    IF l_existe_restricao > 0 THEN
        IF l_existe_restricao = 1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Não foi possível registar a operação porque existe 1 restrição!'); 
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Não foi possível registar a operação porque existem ' || l_existe_restricao || ' restrições!'); 
        END IF;
    END IF;
    
    INSERT INTO registo_fertilizacao(parcela_agricola_id, fator_producao_id, data_fertilizacao, tipo_fertilizacao_id, quantidade_utilizada_kg)
    VALUES(v_parcela_agricola_id, v_fator_producao_id, v_data_fertilizacao, v_tipo_fertilizacao, v_quantidade);
    DBMS_OUTPUT.PUT_LINE('Operação registada com sucesso!');
    DBMS_OUTPUT.PUT_LINE('Parcela Agrícola = '|| v_parcela_agricola_id 
                        || ', Fator de Produção = '|| v_fator_producao_id 
                        || ', Data de Fertilização = '|| v_data_fertilizacao 
                        || ', Tipo de Fertilização = '|| v_tipo_fertilizacao 
                        || ', Quantidade = '|| v_quantidade || 'kg');
END;
/

SAVEPOINT us210_registar_operacao;

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Operação registada com sucesso!
Parcela Agrícola= 1, Fator de Produção= 1, Data de Fertilização= 05-JAN-21, Tipo de Fertilização= 1, Quantidade= 50kg
*/
CALL p_registar_operacao(1,1, TO_DATE('05/01/2021 00:00','DD/MM/YYYY HH24:MI'), 1, 50);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
ERROR at line 54:
ORA-20001: Não foi possível registar a operação porque existe 1 restrição!
*/
CALL p_registar_operacao(1,2, TO_DATE('05/01/2021 00:00','DD/MM/YYYY HH24:MI'), 1, 50);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
ERROR at line 63:
ORA-20001: Não foi possível registar a operação porque existe 1 restrição!
*/
CALL p_registar_operacao(3,2, TO_DATE('05/01/2021 00:00','DD/MM/YYYY HH24:MI'), 1, 50);

ROLLBACK TO us210_registar_operacao;


