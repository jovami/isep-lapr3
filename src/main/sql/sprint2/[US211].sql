---------------------------
----------[US211]----------
---------------------------

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE p_adaptar_remarcar_operacao_registo_restricao(v_parcela_agricola_id registo_restricao.parcela_agricola_id%TYPE,
                            v_fator_producao_id registo_restricao.fator_producao_id%TYPE, v_data_inicio registo_restricao.data_inicio%TYPE,
                            v_nova_data_fim registo_restricao.data_fim%TYPE, v_nova_data_inicio registo_restricao.data_inicio%TYPE,
                            v_tipo_operacao VARCHAR, v_tipo_parametro_alterar VARCHAR, v_data_a_comparar DATE)
IS

    EX_ERRO_OPERACAO_JA_REALIZADA   EXCEPTION;
    EX_ERRO_OPERACAO_JA_COMECADA    EXCEPTION;
    EX_ERRO_DATAS                   EXCEPTION;

    temp_data_fim       registo_restricao.data_fim%TYPE;

BEGIN

    SELECT rr.data_fim INTO temp_data_fim
    FROM registo_restricao rr
    WHERE rr.parcela_agricola_id = v_parcela_agricola_id
      AND rr.fator_producao_id = v_fator_producao_id
      AND rr.data_inicio = v_data_inicio;
    
    IF temp_data_fim <  v_data_a_comparar THEN
            RAISE EX_ERRO_OPERACAO_JA_REALIZADA;
    END IF;

    IF v_tipo_operacao LIKE 'UPDATE' THEN
        IF v_tipo_parametro_alterar LIKE 'data inicio' THEN

            IF v_data_inicio <  v_data_a_comparar THEN
                RAISE EX_ERRO_OPERACAO_JA_COMECADA;
            END IF;

            UPDATE registo_restricao rr
            SET rr.data_inicio = v_nova_data_inicio
            WHERE rr.parcela_agricola_id = v_parcela_agricola_id
              AND rr.fator_producao_id = v_fator_producao_id
              AND rr.data_inicio = v_data_inicio;

            DBMS_OUTPUT.PUT_LINE('UPDATED data inicio');
            DBMS_OUTPUT.PUT_LINE('');

        ELSIF v_tipo_parametro_alterar LIKE 'data fim' THEN

            IF v_nova_data_fim < v_data_inicio  THEN
                RAISE EX_ERRO_DATAS;
            END IF;

            UPDATE registo_restricao rr
            SET rr.data_fim = v_nova_data_fim
            WHERE rr.parcela_agricola_id = v_parcela_agricola_id
              AND rr.fator_producao_id = v_fator_producao_id
              AND rr.data_inicio = v_data_inicio;

            DBMS_OUTPUT.PUT_LINE('UPDATED data fim');
            DBMS_OUTPUT.PUT_LINE('');

        END IF;

    END IF;

    IF v_tipo_operacao LIKE 'DELETE' THEN

        IF v_data_inicio <  v_data_a_comparar THEN
                RAISE EX_ERRO_OPERACAO_JA_COMECADA;
        END IF;

        DELETE FROM registo_restricao rr
        WHERE rr.parcela_agricola_id = v_parcela_agricola_id
          AND rr.fator_producao_id = v_fator_producao_id
          AND rr.data_inicio = v_data_inicio;

        DBMS_OUTPUT.PUT_LINE('DELETED');
        DBMS_OUTPUT.PUT_LINE('');

    END IF;


    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            IF v_tipo_operacao LIKE 'UPDATE' THEN
                IF v_tipo_parametro_alterar LIKE 'data inicio' THEN

                    IF v_data_inicio <  v_data_a_comparar THEN
                        RAISE EX_ERRO_OPERACAO_JA_COMECADA;
                    END IF;

                    UPDATE registo_restricao rr
                    SET rr.data_inicio = v_nova_data_inicio
                    WHERE rr.parcela_agricola_id = v_parcela_agricola_id
                      AND rr.fator_producao_id = v_fator_producao_id
                      AND rr.data_inicio = v_data_inicio;

                    DBMS_OUTPUT.PUT_LINE('UPDATED data inicio');
                    DBMS_OUTPUT.PUT_LINE('');

                ELSIF v_tipo_parametro_alterar LIKE 'data fim' THEN

                    IF v_nova_data_fim < v_data_inicio  THEN
                        RAISE EX_ERRO_DATAS;
                    END IF;

                    UPDATE registo_restricao rr
                    SET rr.data_fim = v_nova_data_fim
                    WHERE rr.parcela_agricola_id = v_parcela_agricola_id
                      AND rr.fator_producao_id = v_fator_producao_id
                      AND rr.data_inicio = v_data_inicio;

                    DBMS_OUTPUT.PUT_LINE('UPDATED data fim');
                    DBMS_OUTPUT.PUT_LINE('');

                END IF;

            END IF;

            IF v_tipo_operacao LIKE 'DELETE' THEN

                IF v_data_inicio <  v_data_a_comparar THEN
                        RAISE EX_ERRO_OPERACAO_JA_COMECADA;
                END IF;

                DELETE FROM registo_restricao rr
                WHERE rr.parcela_agricola_id = v_parcela_agricola_id
                  AND rr.fator_producao_id = v_fator_producao_id
                  AND rr.data_inicio = v_data_inicio;

                DBMS_OUTPUT.PUT_LINE('DELETED');
                DBMS_OUTPUT.PUT_LINE('');

            END IF;

        END;
    WHEN EX_ERRO_OPERACAO_JA_REALIZADA THEN
            RAISE_APPLICATION_ERROR(-20011,'A operacao ja foi realizada nao sendo assim possivel cancelar ou atualizar a mesma');
    WHEN EX_ERRO_OPERACAO_JA_COMECADA THEN
            RAISE_APPLICATION_ERROR(-20011,'A operacao ja esta em processo, sendo apenas possivel mudar a sua data de fim');
    WHEN EX_ERRO_DATAS THEN
            RAISE_APPLICATION_ERROR(-20011,'Esta a tentar inserir uma nova data fim da operacao em que a sua data e menor que a data de inicio da operacao ');


END p_adaptar_remarcar_operacao_registo_restricao;
/

CREATE OR REPLACE PROCEDURE p_adaptar_remarcar_operacao_registo_fertilizacao(v_parcela_agricola_id registo_fertilizacao.parcela_agricola_id%TYPE,
                            v_fator_producao_id registo_fertilizacao.fator_producao_id%TYPE, v_data_fertilizacao registo_fertilizacao.data_fertilizacao%TYPE,
                            v_nova_data_fertilizacao registo_fertilizacao.data_fertilizacao%TYPE,
                            v_nova_quantidade_utilizada_kg registo_fertilizacao.quantidade_utilizada_kg%TYPE,
                            v_nova_tipo_fertilizacao_id registo_fertilizacao.tipo_fertilizacao_id%TYPE,
                            v_tipo_operacao VARCHAR, v_tipo_parametro_alterar VARCHAR, v_data_a_comparar DATE)
IS

    EX_ERRO_OPERACAO_JA_REALIZADA   EXCEPTION;

BEGIN

    IF v_data_fertilizacao <  v_data_a_comparar THEN
        RAISE EX_ERRO_OPERACAO_JA_REALIZADA;
    END IF;

    IF v_tipo_operacao LIKE 'UPDATE' THEN
        IF v_tipo_parametro_alterar LIKE 'data fertilizacao' THEN

            UPDATE registo_fertilizacao rf
            SET rf.data_fertilizacao = v_nova_data_fertilizacao
            WHERE rf.parcela_agricola_id = v_parcela_agricola_id
              AND rf.fator_producao_id = v_fator_producao_id
              AND rf.data_fertilizacao = v_data_fertilizacao;
    
            DBMS_OUTPUT.PUT_LINE('UPDATED data fertilizacaoo');
            DBMS_OUTPUT.PUT_LINE('');

        ELSIF v_tipo_parametro_alterar LIKE 'quantidade utilizada' THEN

            UPDATE registo_fertilizacao rf
            SET rf.quantidade_utilizada_kg = v_nova_quantidade_utilizada_kg
            WHERE rf.parcela_agricola_id = v_parcela_agricola_id
              AND rf.fator_producao_id = v_fator_producao_id
              AND rf.data_fertilizacao = v_data_fertilizacao;
            
            DBMS_OUTPUT.PUT_LINE('UPDATED quantidade utilizada');
            DBMS_OUTPUT.PUT_LINE('');

        ELSIF v_tipo_parametro_alterar LIKE 'tipo fertilizacao' THEN

            UPDATE registo_fertilizacao rf
            SET rf.tipo_fertilizacao_id = v_nova_tipo_fertilizacao_id
            WHERE rf.parcela_agricola_id = v_parcela_agricola_id
              AND rf.fator_producao_id = v_fator_producao_id
              AND rf.data_fertilizacao = v_data_fertilizacao;
            
            DBMS_OUTPUT.PUT_LINE('UPDATED tipo fertilizacao');
            DBMS_OUTPUT.PUT_LINE('');
        END IF;

    END IF;

    IF v_tipo_operacao LIKE 'DELETE' THEN

        DELETE FROM registo_fertilizacao rf
        WHERE rf.parcela_agricola_id = v_parcela_agricola_id
          AND rf.fator_producao_id = v_fator_producao_id
          AND rf.data_fertilizacao = v_data_fertilizacao;
        
        DBMS_OUTPUT.PUT_LINE('DELETED');
        DBMS_OUTPUT.PUT_LINE('');

    END IF;


EXCEPTION
    WHEN EX_ERRO_OPERACAO_JA_REALIZADA THEN
            RAISE_APPLICATION_ERROR(-20011,'A operacao ja foi realizada nao sendo assim possivel cancelar ou atualizar a mesma');

END p_adaptar_remarcar_operacao_registo_fertilizacao;
/

CREATE OR REPLACE PROCEDURE p_adaptar_remarcar_operacao_registo_colheita(v_parcela_agricola_id registo_colheita.parcela_agricola_id%TYPE,
                            v_produto_id registo_colheita.produto_id%TYPE, v_tipo_cultura_id registo_colheita.tipo_cultura_id%TYPE,
                            v_data_plantacao registo_colheita.data_plantacao%TYPE,
                            v_nova_data_plantacao registo_colheita.data_plantacao%TYPE,
                            v_nova_data_colheita registo_colheita.data_colheita%TYPE,
                            v_tipo_operacao VARCHAR, v_tipo_parametro_alterar VARCHAR, v_data_a_comparar DATE)
IS

    EX_ERRO_OPERACAO_JA_REALIZADA   EXCEPTION;
    EX_ERRO_OPERACAO_JA_COMECADA    EXCEPTION;
    EX_ERRO_DATAS                   EXCEPTION;

    temp_data_colheita       registo_colheita.data_colheita%TYPE;

BEGIN

    SELECT rc.data_colheita INTO temp_data_colheita
    FROM registo_colheita rc
    WHERE rc.parcela_agricola_id = v_parcela_agricola_id
      AND rc.produto_id = v_produto_id
      AND rc.tipo_cultura_id = v_tipo_cultura_id
      AND rc.data_plantacao = v_data_plantacao;

    IF temp_data_colheita <  v_data_a_comparar THEN
            RAISE EX_ERRO_OPERACAO_JA_REALIZADA;
    END IF;

    IF v_tipo_operacao LIKE 'UPDATE' THEN
        IF v_tipo_parametro_alterar LIKE 'data plantacao' THEN

            IF v_data_plantacao <  v_data_a_comparar THEN
                RAISE EX_ERRO_OPERACAO_JA_COMECADA;
            END IF;

            UPDATE registo_colheita rc
            SET rc.data_plantacao = v_nova_data_plantacao
            WHERE rc.parcela_agricola_id = v_parcela_agricola_id
              AND rc.produto_id = v_produto_id
              AND rc.tipo_cultura_id = v_tipo_cultura_id
              AND rc.data_plantacao = v_data_plantacao;

            DBMS_OUTPUT.PUT_LINE('UPDATED data plantacao');
            DBMS_OUTPUT.PUT_LINE('');

        ELSIF v_tipo_parametro_alterar LIKE 'data colheita' THEN

            IF v_nova_data_colheita < v_data_plantacao  THEN
                RAISE EX_ERRO_DATAS;
            END IF;

            UPDATE registo_colheita rc
            SET rc.data_colheita = v_nova_data_colheita
            WHERE rc.parcela_agricola_id = v_parcela_agricola_id
              AND rc.produto_id = v_produto_id
              AND rc.tipo_cultura_id = v_tipo_cultura_id
              AND rc.data_plantacao = v_data_plantacao;

            DBMS_OUTPUT.PUT_LINE('UPDATED data colheita');
            DBMS_OUTPUT.PUT_LINE('');
        END IF;

    END IF;

    IF v_tipo_operacao LIKE 'DELETE' THEN

        IF v_data_plantacao <  v_data_a_comparar THEN
                RAISE EX_ERRO_OPERACAO_JA_COMECADA;
        END IF;

        DELETE FROM registo_colheita rc
        WHERE rc.parcela_agricola_id = v_parcela_agricola_id
          AND rc.produto_id = v_produto_id
          AND rc.tipo_cultura_id = v_tipo_cultura_id
          AND rc.data_plantacao = v_data_plantacao;
        
        DBMS_OUTPUT.PUT_LINE('DELETED');
        DBMS_OUTPUT.PUT_LINE('');
    END IF;


EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            IF v_tipo_operacao LIKE 'UPDATE' THEN
                IF v_tipo_parametro_alterar LIKE 'data plantacao' THEN

                    IF v_data_plantacao <  v_data_a_comparar THEN
                        RAISE EX_ERRO_OPERACAO_JA_COMECADA;
                    END IF;

                    UPDATE registo_colheita rc
                    SET rc.data_plantacao = v_nova_data_plantacao
                    WHERE rc.parcela_agricola_id = v_parcela_agricola_id
                      AND rc.produto_id = v_produto_id
                      AND rc.tipo_cultura_id = v_tipo_cultura_id
                      AND rc.data_plantacao = v_data_plantacao;

                    DBMS_OUTPUT.PUT_LINE('UPDATED data plantacao');
                    DBMS_OUTPUT.PUT_LINE('');

                ELSIF v_tipo_parametro_alterar LIKE 'data colheita' THEN

                    IF v_nova_data_colheita < v_data_plantacao  THEN
                        RAISE EX_ERRO_DATAS;
                    END IF;

                    UPDATE registo_colheita rc
                    SET rc.data_colheita = v_nova_data_colheita
                    WHERE rc.parcela_agricola_id = v_parcela_agricola_id
                      AND rc.produto_id = v_produto_id
                      AND rc.tipo_cultura_id = v_tipo_cultura_id
                      AND rc.data_plantacao = v_data_plantacao;
                    
                    DBMS_OUTPUT.PUT_LINE('UPDATED data colheita');
                    DBMS_OUTPUT.PUT_LINE('');
                END IF;

            END IF;

            IF v_tipo_operacao LIKE 'DELETE' THEN

                IF v_data_plantacao <  v_data_a_comparar THEN
                        RAISE EX_ERRO_OPERACAO_JA_COMECADA;
                END IF;

                DELETE FROM registo_colheita rc
                WHERE rc.parcela_agricola_id = v_parcela_agricola_id
                  AND rc.produto_id = v_produto_id
                  AND rc.tipo_cultura_id = v_tipo_cultura_id
                  AND rc.data_plantacao = v_data_plantacao;
                
                DBMS_OUTPUT.PUT_LINE('DELETED');
                DBMS_OUTPUT.PUT_LINE('');

            END IF;
        END;
    WHEN EX_ERRO_OPERACAO_JA_REALIZADA THEN
            RAISE_APPLICATION_ERROR(-20011,'A operacao ja foi realizada nao sendo assim possivel cancelar ou atualizar a mesma');
    WHEN EX_ERRO_OPERACAO_JA_COMECADA THEN
            RAISE_APPLICATION_ERROR(-20011,'A operacao ja esta em processo, sendo apenas possivel mudar a sua data de colheita');
    WHEN EX_ERRO_DATAS THEN
            RAISE_APPLICATION_ERROR(-20011,'Esta a tentar inserir uma nova data fim da operacao em que a sua data e menor que a data de inicio da operacao ');


END p_adaptar_remarcar_operacao_registo_colheita;
/

CREATE OR REPLACE PROCEDURE p_adaptar_remarcar_operacao_registo_rega(v_parcela_agricola_id registo_rega.parcela_agricola_id%TYPE,
                            v_produto_id registo_rega.produto_id%TYPE, v_tipo_cultura_id registo_rega.tipo_cultura_id%TYPE,
                            v_data_plantacao registo_rega.data_plantacao%TYPE, v_data_realizacao registo_rega.data_realizacao%TYPE,
                            v_nova_data_realizacao registo_rega.data_realizacao%TYPE,
                            v_novo_tipo_sistema_id registo_rega.tipo_sistema_id%TYPE,
                            v_novo_tipo_rega_id registo_rega.tipo_rega_id%TYPE,
                            v_nova_quantidade_rega registo_rega.quantidade_rega%TYPE,
                            v_novo_tempo_rega_mm registo_rega.tempo_rega_mm%TYPE,
                            v_tipo_operacao VARCHAR, v_tipo_parametro_alterar VARCHAR,
                            v_data_a_comparar DATE)
IS

    EX_ERRO_OPERACAO_JA_REALIZADA   EXCEPTION;

BEGIN

    IF v_data_realizacao <  v_data_a_comparar THEN
        RAISE EX_ERRO_OPERACAO_JA_REALIZADA;
    END IF;

    IF v_tipo_operacao LIKE 'UPDATE' THEN
        IF v_tipo_parametro_alterar LIKE 'data realizacao' THEN

            UPDATE registo_rega rr
            SET rr.data_realizacao = v_nova_data_realizacao
            WHERE rr.parcela_agricola_id = v_parcela_agricola_id
              AND rr.produto_id = v_produto_id
              AND rr.tipo_cultura_id = v_tipo_cultura_id
              AND rr.data_plantacao = v_data_plantacao
              AND rr.data_realizacao = v_data_realizacao;
    
            DBMS_OUTPUT.PUT_LINE('UPDATED data realizacao');
            DBMS_OUTPUT.PUT_LINE('');

        ELSIF v_tipo_parametro_alterar LIKE 'tipo sistema' THEN

            UPDATE registo_rega rr
            SET rr.tipo_sistema_id = v_novo_tipo_sistema_id
            WHERE rr.parcela_agricola_id = v_parcela_agricola_id
              AND rr.produto_id = v_produto_id
              AND rr.tipo_cultura_id = v_tipo_cultura_id
              AND rr.data_plantacao = v_data_plantacao
              AND rr.data_realizacao = v_data_realizacao;

            DBMS_OUTPUT.PUT_LINE('UPDATED tipo sistema');
            DBMS_OUTPUT.PUT_LINE('');

        ELSIF v_tipo_parametro_alterar LIKE 'tipo rega' THEN

            UPDATE registo_rega rr
            SET rr.tipo_rega_id = v_novo_tipo_rega_id
            WHERE rr.parcela_agricola_id = v_parcela_agricola_id
              AND rr.produto_id = v_produto_id
              AND rr.tipo_cultura_id = v_tipo_cultura_id
              AND rr.data_plantacao = v_data_plantacao
              AND rr.data_realizacao = v_data_realizacao;
            
            DBMS_OUTPUT.PUT_LINE('UPDATED tipo rega');
            DBMS_OUTPUT.PUT_LINE('');

        ELSIF v_tipo_parametro_alterar LIKE 'quantidade rega' THEN

            UPDATE registo_rega rr
            SET rr.quantidade_rega = v_nova_quantidade_rega
            WHERE rr.parcela_agricola_id = v_parcela_agricola_id
              AND rr.produto_id = v_produto_id
              AND rr.tipo_cultura_id = v_tipo_cultura_id
              AND rr.data_plantacao = v_data_plantacao
              AND rr.data_realizacao = v_data_realizacao;

            DBMS_OUTPUT.PUT_LINE('UPDATED quantidade rega');
            DBMS_OUTPUT.PUT_LINE('');

        ELSIF v_tipo_parametro_alterar LIKE 'tempo rega' THEN

            UPDATE registo_rega rr
            SET rr.tempo_rega_mm = v_novo_tempo_rega_mm
            WHERE rr.parcela_agricola_id = v_parcela_agricola_id
              AND rr.produto_id = v_produto_id
              AND rr.tipo_cultura_id = v_tipo_cultura_id
              AND rr.data_plantacao = v_data_plantacao
              AND rr.data_realizacao = v_data_realizacao;

            DBMS_OUTPUT.PUT_LINE('UPDATED tempo rega');
            DBMS_OUTPUT.PUT_LINE('');

        END IF;

    END IF;

    IF v_tipo_operacao LIKE 'DELETE' THEN

        DELETE FROM registo_rega rr
        WHERE rr.parcela_agricola_id = v_parcela_agricola_id
          AND rr.produto_id = v_produto_id
          AND rr.tipo_cultura_id = v_tipo_cultura_id
          AND rr.data_plantacao = v_data_plantacao
          AND rr.data_realizacao = v_data_realizacao;
        
        DBMS_OUTPUT.PUT_LINE('DELETED');
        DBMS_OUTPUT.PUT_LINE('');
    END IF;


EXCEPTION
    WHEN EX_ERRO_OPERACAO_JA_REALIZADA THEN
            RAISE_APPLICATION_ERROR(-20011,'A operacao ja foi realizada nao sendo assim possivel cancelar ou atualizar a mesma');

END p_adaptar_remarcar_operacao_registo_rega;
/

SAVEPOINT us_211_adaptar_remarcar;


------------------ADAPTAR/REMACAR RESTRICOES-----------------
-------------------------------------------------------------

INSERT INTO registo_restricao(parcela_agricola_id,fator_producao_id,data_inicio,data_fim)
                            VALUES(4,3,TO_DATE('01/12/2023 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('31/12/2023 00:00','DD/MM/YYYY HH24:MI'));

SELECT * FROM registo_restricao;

---ALTERAR A DATA DE INICIO---
CALL p_adaptar_remarcar_operacao_registo_restricao(4,3,TO_DATE('01/12/2023 00:00','DD/MM/YYYY HH24:MI'),
                                                    NULL,TO_DATE('01/11/2023 00:00','DD/MM/YYYY HH24:MI'),
                                                    'UPDATE','data inicio',CURRENT_TIMESTAMP);

SELECT * FROM registo_restricao;

---ALTERAR A DATA DE FIM---
CALL p_adaptar_remarcar_operacao_registo_restricao(4,3,TO_DATE('01/11/2023 00:00','DD/MM/YYYY HH24:MI'),
                                                    TO_DATE('20/12/2023 00:00','DD/MM/YYYY HH24:MI'),NULL,
                                                    'UPDATE','data fim',CURRENT_TIMESTAMP);

SELECT * FROM registo_restricao;

---DELETE---
CALL p_adaptar_remarcar_operacao_registo_restricao(4,3,TO_DATE('01/11/2023 00:00','DD/MM/YYYY HH24:MI'),
                                                    NULL,NULL,
                                                    'DELETE',NULL,CURRENT_TIMESTAMP);

SELECT * FROM registo_restricao;


------------------ADAPTAR/REMACAR FERTILIZACOES--------------
-------------------------------------------------------------

INSERT INTO registo_fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
                                VALUES
                                (4,3,TO_DATE('12/12/2023 18:00','DD/MM/YYYY HH24:MI'),50,1);

SELECT * FROM registo_fertilizacao;

---ALTERAR DATA DE FERTILIZACAO---
CALL p_adaptar_remarcar_operacao_registo_fertilizacao(4,3,TO_DATE('12/12/2023 18:00','DD/MM/YYYY HH24:MI'),
                                                        TO_DATE('13/11/2023 18:00','DD/MM/YYYY HH24:MI'),
                                                        NULL,
                                                        NULL,
                                                        'UPDATE','data fertilizacao',CURRENT_TIMESTAMP);

SELECT * FROM registo_fertilizacao;

---ALTERAR QUANTIDADE UTILIZADA KG---
CALL p_adaptar_remarcar_operacao_registo_fertilizacao(4,3,TO_DATE('13/11/2023 18:00','DD/MM/YYYY HH24:MI'),
                                                        NULL,
                                                        343,
                                                        NULL,
                                                        'UPDATE','quantidade utilizada',CURRENT_TIMESTAMP);

SELECT * FROM registo_fertilizacao;

---ALTERAR TIPO FERTILIZACAO---
CALL p_adaptar_remarcar_operacao_registo_fertilizacao(4,3,TO_DATE('13/11/2023 18:00','DD/MM/YYYY HH24:MI'),
                                                        NULL,
                                                        NULL,
                                                        2,
                                                        'UPDATE','tipo fertilizacao',CURRENT_TIMESTAMP);

SELECT * FROM registo_fertilizacao;

---DELETE---
CALL p_adaptar_remarcar_operacao_registo_fertilizacao(4,3,TO_DATE('13/11/2023 18:00','DD/MM/YYYY HH24:MI'),
                                                        NULL,
                                                        NULL,
                                                        NULL,
                                                        'DELETE',NULL,CURRENT_TIMESTAMP);

SELECT * FROM registo_fertilizacao;


------------------ADAPTAR/REMACAR COLHEITAS------------------
-------------------------------------------------------------

INSERT INTO registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
                             area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)
                            VALUES 
                            (2,2,1,TO_DATE('04/12/2023 12:00','DD/MM/YYYY HH24:MI'),30,TO_DATE('21/12/2023 12:00','DD/MM/YYYY HH24:MI'),100);

SELECT * FROM registo_colheita;

---ALTERAR DATA PLANTACAO---
CALL p_adaptar_remarcar_operacao_registo_colheita(2,2,1,TO_DATE('04/12/2023 12:00','DD/MM/YYYY HH24:MI'),
                                                    TO_DATE('05/12/2023 12:00','DD/MM/YYYY HH24:MI'),
                                                    NULL,
                                                    'UPDATE','data plantacao',CURRENT_TIMESTAMP);

SELECT * FROM registo_colheita;

---ALTERAR DATA COLHEITA---
CALL p_adaptar_remarcar_operacao_registo_colheita(2,2,1,TO_DATE('05/12/2023 12:00','DD/MM/YYYY HH24:MI'),
                                                    NULL,
                                                    TO_DATE('30/12/2023 12:00','DD/MM/YYYY HH24:MI'),
                                                    'UPDATE','data colheita',CURRENT_TIMESTAMP);

SELECT * FROM registo_colheita;

---DELETE---
CALL p_adaptar_remarcar_operacao_registo_colheita(2,2,1,TO_DATE('05/12/2023 12:00','DD/MM/YYYY HH24:MI'),
                                                    NULL,
                                                    NULL,
                                                    'DELETE',NULL,CURRENT_TIMESTAMP);

SELECT * FROM registo_colheita;


------------------ADAPTAR/REMACAR REGAS----------------------
-------------------------------------------------------------
INSERT INTO registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
                             area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)
                            VALUES 
                            (1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),30,TO_DATE('04/12/2024 10:00','DD/MM/YYYY HH24:MI'),100);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
                         data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
                         VALUES
                         (1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),
                          TO_DATE('08/01/2024 12:00','DD/MM/YYYY HH24:MI'),100,30,3,2);

SELECT * FROM registo_rega;

---ALTERAR DATA REALIZACAO---
CALL p_adaptar_remarcar_operacao_registo_rega(1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),
                                              TO_DATE('08/01/2024 12:00','DD/MM/YYYY HH24:MI'),
                                              TO_DATE('15/01/2024 12:00','DD/MM/YYYY HH24:MI'),
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              'UPDATE','data realizacao',CURRENT_TIMESTAMP);

SELECT * FROM registo_rega;

---ALTERAR TIPO DE SISTEMA---
CALL p_adaptar_remarcar_operacao_registo_rega(1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),
                                              TO_DATE('15/01/2024 12:00','DD/MM/YYYY HH24:MI'),
                                              NULL,
                                              1,
                                              NULL,
                                              NULL,
                                              NULL,
                                              'UPDATE','tipo sistema',CURRENT_TIMESTAMP);

SELECT * FROM registo_rega;

---ALTERAR TIPO DE REGA---
CALL p_adaptar_remarcar_operacao_registo_rega(1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),
                                              TO_DATE('15/01/2024 12:00','DD/MM/YYYY HH24:MI'),
                                              NULL,
                                              NULL,
                                              2,
                                              NULL,
                                              NULL,
                                              'UPDATE','tipo rega',CURRENT_TIMESTAMP);

SELECT * FROM registo_rega;

---ALTERAR QUANTIDADE DE REGA---
CALL p_adaptar_remarcar_operacao_registo_rega(1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),
                                              TO_DATE('15/01/2024 12:00','DD/MM/YYYY HH24:MI'),
                                              NULL,
                                              NULL,
                                              NULL,
                                              232,
                                              NULL,
                                              'UPDATE','quantidade rega',CURRENT_TIMESTAMP);

SELECT * FROM registo_rega;

---ALTERAR TEMPO DE REGA---
CALL p_adaptar_remarcar_operacao_registo_rega(1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),
                                              TO_DATE('15/01/2024 12:00','DD/MM/YYYY HH24:MI'),
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              25,
                                              'UPDATE','tempo rega',CURRENT_TIMESTAMP);

SELECT * FROM registo_rega;

---DELETE---
CALL p_adaptar_remarcar_operacao_registo_rega(1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),
                                              TO_DATE('15/01/2024 12:00','DD/MM/YYYY HH24:MI'),
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              'DELETE',NULL,CURRENT_TIMESTAMP);

SELECT * FROM registo_rega;


CALL p_adaptar_remarcar_operacao_registo_colheita(1,1,1,TO_DATE('04/01/2024 10:00','DD/MM/YYYY HH24:MI'),
                                                    NULL,
                                                    NULL,
                                                    'DELETE',NULL,CURRENT_TIMESTAMP);

ROLLBACK TO us_211_adaptar_remarcar;