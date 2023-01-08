---------------------------
----------[US210]----------
---------------------------

------------------------------------------------------------------------------------------------
----------------------------------CRITERIOS DE ACEITACAO 1 E 2----------------------------------
------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE p_registar_operacao (v_parcela_agricola_id       parcela_agricola.parcela_agricola_id%TYPE,
                                                v_fator_producao_id         fator_producao.fator_producao_id%TYPE,
                                                v_data_fertilizacao         registo_fertilizacao.data_fertilizacao%TYPE,
                                                v_tipo_fertilizacao         tipo_fertilizacao.tipo_fertilizacao_id%TYPE,
                                                v_quantidade                registo_fertilizacao.quantidade_utilizada_kg%TYPE
                                                )
IS

    l_existe_restricao          INTEGER;   -- verdadeiro se != 0
    EX_ERRO_RESTRICAO_REGISTO   EXCEPTION;
    EX_ERRO_RESTRICOES_REGISTO  EXCEPTION;
    
BEGIN

    SELECT count(*) INTO l_existe_restricao
    FROM registo_restricao R
    WHERE R.parcela_agricola_id = v_parcela_agricola_id
      AND R.data_inicio <= v_data_fertilizacao
      AND R.data_fim >= v_data_fertilizacao
      AND R.fator_producao_id = v_fator_producao_id;

    IF l_existe_restricao > 0 THEN
        IF l_existe_restricao = 1 THEN
             RAISE EX_ERRO_RESTRICAO_REGISTO;
        ELSE
            RAISE EX_ERRO_RESTRICOES_REGISTO;
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

EXCEPTION
    WHEN EX_ERRO_RESTRICAO_REGISTO THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não foi possível registar a operação porque existe 1 restrição!');
    WHEN EX_ERRO_RESTRICOES_REGISTO THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não foi possível registar a operação porque existem ' || l_existe_restricao || ' restrições!');

END p_registar_operacao;
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

INSERT INTO registo_restricao(parcela_agricola_id,fator_producao_id,data_inicio,data_fim)
VALUES(3,2,TO_DATE('02/01/2021 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('10/12/2021 00:00','DD/MM/YYYY HH24:MI'));

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
ERROR at line 63:
ORA-20001: Não foi possível registar a operação porque existem 2 restrições!
*/
CALL p_registar_operacao(3,2, TO_DATE('05/01/2021 00:00','DD/MM/YYYY HH24:MI'), 1, 50);

ROLLBACK TO us210_registar_operacao;

---------------------------------------------------------------------------------------------
-----------------------------------CRITERIO DE ACEITACAO 3-----------------------------------
---------------------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE p_verificar_restricao (v_parcela_agricola_id       parcela_agricola.parcela_agricola_id%TYPE,
                                                    v_fator_producao_id         fator_producao.fator_producao_id%TYPE,
                                                    v_data_fertilizacao         registo_fertilizacao.data_fertilizacao%TYPE
                                                    )
IS
    l_existe_restricao          INTEGER;   -- verdadeiro se != 0

BEGIN

    IF sysdate >= v_data_fertilizacao - 7 THEN
    
        SELECT count(*) INTO l_existe_restricao
        FROM registo_restricao R
        WHERE R.parcela_agricola_id = v_parcela_agricola_id
          AND R.data_inicio <= v_data_fertilizacao
          AND R.data_fim >= v_data_fertilizacao
          AND R.fator_producao_id = v_fator_producao_id;

        IF l_existe_restricao > 0 THEN
            IF l_existe_restricao = 1 THEN
                DBMS_OUTPUT.PUT_LINE('Existe 1 restrição durante esta operação!');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Existem ' || l_existe_restricao || ' restrições durante esta operação!');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Não existem restrições durante esta operação!');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Não se enconta a pelo menos 7 dias da data de fertilização!');
    END IF;

END p_verificar_restricao;
/

SAVEPOINT us210_verificar_restricao;

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Não existem restrições durante esta operação!
*/
CALL p_verificar_restricao(1,1,TO_DATE('03/01/2021 12:00','DD/MM/YYYY HH24:MI'));

INSERT INTO registo_fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
                            VALUES(2,1,TO_DATE('10/01/2021 12:00','DD/MM/YYYY HH24:MI'),50,1);

INSERT INTO registo_restricao(parcela_agricola_id,fator_producao_id,data_inicio,data_fim)
                        VALUES(2,1,TO_DATE('01/01/2021 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('31/12/2021 00:00','DD/MM/YYYY HH24:MI'));

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Existe 1 restrição durante esta operação!
*/
CALL p_verificar_restricao(2,1, TO_DATE('10/01/2021 12:00','DD/MM/YYYY HH24:MI'));

INSERT INTO registo_restricao(parcela_agricola_id,fator_producao_id,data_inicio,data_fim)
                        VALUES(2,1,TO_DATE('05/01/2021 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('10/12/2021 00:00','DD/MM/YYYY HH24:MI'));

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Existem 2 restrições durante esta operação!
*/
CALL p_verificar_restricao(2,1, TO_DATE('10/01/2021 12:00','DD/MM/YYYY HH24:MI'));

ROLLBACK TO us210_verificar_restricao;

---------------------------------------------------------------------------------------------
-----------------------------------CRITERIO DE ACEITACAO 4-----------------------------------
---------------------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE p_obter_restricoes (v_parcela_agricola_id parcela_agricola.parcela_agricola_id%TYPE,
                                                v_data_fertilizacao registo_fertilizacao.data_fertilizacao%TYPE
                                                )
IS
    l_fator_producao_id                 registo_restricao.fator_producao_id%TYPE;
    l_fator_producao_nome_comercial     fator_producao.nome_comercial%TYPE;
    l_data_inicio                       registo_restricao.data_inicio%TYPE;
    l_data_fim                          registo_restricao.data_fim%TYPE;

    CURSOR c_restricoes IS
        SELECT R.fator_producao_id, F.nome_comercial, R.data_inicio, R.data_fim
        FROM registo_restricao R
        INNER JOIN fator_producao F ON R.fator_producao_id = F.fator_producao_id
            WHERE R.parcela_agricola_id = v_parcela_agricola_id
            AND R.data_inicio <= v_data_fertilizacao
            AND R.data_fim >= v_data_fertilizacao;    

BEGIN
        OPEN c_restricoes;
            LOOP
                FETCH c_restricoes INTO l_fator_producao_id, l_fator_producao_nome_comercial, l_data_inicio, l_data_fim;
                EXIT WHEN c_restricoes%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE('Fator de Produção = '|| l_fator_producao_nome_comercial || ' (id = '|| l_fator_producao_id || ')'
                                    || ', Data Início = '|| l_data_inicio
                                    || ', Data Fim = '|| l_data_fim);
            END LOOP;
        CLOSE c_restricoes;
END;
/

SAVEPOINT us210_obter_restricoes;

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Fator de Produção = LYSODIN DRY (id = 2), Data Início = 01-JAN-21, Data Fim = 31-DEC-21
*/
CALL p_obter_restricoes(1, TO_DATE('20/01/2021 00:00','DD/MM/YYYY HH24:MI'));

ROLLBACK TO us210_obter_restricoes;

---------------------------------------------------------------------------------------------
-----------------------------------CRITERIO DE ACEITACAO 5-----------------------------------
---------------------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE p_obter_operacoes (v_parcela_agricola_id parcela_agricola.parcela_agricola_id%TYPE,
                                                v_data_inicio registo_fertilizacao.data_fertilizacao%TYPE,
                                                v_data_fim registo_fertilizacao.data_fertilizacao%TYPE
                                                )
IS
    l_fator_producao_id                 registo_fertilizacao.fator_producao_id%TYPE;
    l_fator_producao_nome_comercial     fator_producao.nome_comercial%TYPE;
    l_data_fertilizacao                 registo_fertilizacao.data_fertilizacao%TYPE;
    l_tipo_fertilizacao_id              registo_fertilizacao.tipo_fertilizacao_id%TYPE;
    l_tipo_fertilizacao_designacao      tipo_fertilizacao.designacao%TYPE;
    l_quantidade_utilizada_kg           registo_fertilizacao.quantidade_utilizada_kg%TYPE;

    CURSOR c_operacoes IS
        SELECT F.fator_producao_id, FP.nome_comercial, F.data_fertilizacao, F.tipo_fertilizacao_id, T.designacao, F.quantidade_utilizada_kg
        FROM registo_fertilizacao F
          INNER JOIN tipo_fertilizacao T ON F.tipo_fertilizacao_id = T.tipo_fertilizacao_id
          INNER JOIN fator_producao FP ON F.fator_producao_id = FP.fator_producao_id
            WHERE F.parcela_agricola_id = v_parcela_agricola_id
                AND F.data_fertilizacao BETWEEN v_data_inicio AND v_data_fim
                ORDER BY F.data_fertilizacao;

BEGIN

    OPEN c_operacoes;
        LOOP
            FETCH c_operacoes INTO l_fator_producao_id, l_fator_producao_nome_comercial, l_data_fertilizacao, l_tipo_fertilizacao_id, l_tipo_fertilizacao_designacao, l_quantidade_utilizada_kg;
            EXIT WHEN c_operacoes%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Fator de Produção = '|| l_fator_producao_nome_comercial || ' (id = '|| l_fator_producao_id || ')'
                                || ', Data Fertilização = '|| l_data_fertilizacao
                                || ', Tipo de Fertilização = '|| l_tipo_fertilizacao_designacao || ' (id = '|| l_tipo_fertilizacao_id || ')'
                                || ', Quantidade = '|| l_quantidade_utilizada_kg || 'kg');
        END LOOP;
END;
/

SAVEPOINT us210_obter_operacoes;

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Fator de Produção = ENERGIZER (id = 1), Data Fertilização = 03-JAN-21, Tipo de Fertilização = aplicacao direta solo (id = 1), Quantidade = 50kg
*/
CALL p_obter_operacoes(1,TO_DATE('01/01/2021 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('31/12/2021 00:00','DD/MM/YYYY HH24:MI'));

ROLLBACK TO us210_obter_operacoes;
