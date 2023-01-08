---------------------------
----------[US207]----------
---------------------------

-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 1------------------------------------
-----------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;


create or replace PROCEDURE p_ordena_setores_por_quantidade_producao_decrescente(v_utilizador_id utilizador.utilizador_id%TYPE, v_ano caderno_campo.ano%TYPE)
IS

    l_parcela_agricola_id                                        parcela_agricola.parcela_agricola_id%TYPE;
    l_designacao                                                 parcela_agricola.designacao%TYPE;
    l_area_ha                                                    parcela_agricola.area_ha%TYPE;
    l_area_plantada_ha                                           registo_cultura.area_plantada_ha%TYPE;
    l_quantidade_colhida_ton_por_ha                              registo_cultura.quantidade_colhida_ton_por_ha%TYPE;
    l_quantidade_producao_total_nesta_parcela_ton_por_ha         NUMBER(15,4);

    temp_utilizador                  utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador             tipo_utilizador.designacao%TYPE;
    temp_instalacao_agricola_id      instalacao_agricola.instalacao_agricola_id%TYPE;


   CURSOR c_ordena_setores_por_quantidade_producao_decrescente IS
        SELECT pa.parcela_agricola_id, pa.designacao, pa.area_ha ,SUM(rc.area_plantada_ha) AS area_plantada_ha, SUM(rc.quantidade_colhida_ton_por_ha) AS quantidade_colhida_todos_os_produtos_ton,
               SUM(rc.area_plantada_ha * rc.quantidade_colhida_ton_por_ha) AS quantidade_producao_total_nesta_parcela_ton_por_ha
        FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
        INNER JOIN gestor_agricola ga
            ON u.utilizador_id = ga.gestor_agricola_id
                AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
        INNER JOIN instalacao_agricola ia
            ON ga.instalacao_agricola_id = ia.instalacao_agricola_id
        INNER JOIN parcela_agricola pa
            ON ia.instalacao_agricola_id = pa.instalacao_agricola_id
        INNER JOIN registo_cultura rc
            ON pa.parcela_agricola_id = rc.parcela_agricola_id AND rc.caderno_campo_id = (SELECT cc.caderno_campo_id
                                                                                          FROM caderno_campo cc
                                                                                          WHERE cc.ano = v_ano)
        GROUP BY pa.parcela_agricola_id, pa.designacao, pa.area_ha
        ORDER BY quantidade_producao_total_nesta_parcela_ton_por_ha DESC;


     EX_ERRO_TEMP_TIPO_UTILIZADOR EXCEPTION;

BEGIN

    SELECT u.utilizador_id INTO temp_utilizador
    FROM utilizador u
        WHERE u.utilizador_id = v_utilizador_id;

    SELECT tu.designacao INTO temp_tipo_utilizador
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_utilizador_id;


    IF temp_tipo_utilizador LIKE 'gestor agricola' THEN
        SELECT ia.instalacao_agricola_id INTO temp_instalacao_agricola_id
            FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
            INNER JOIN gestor_agricola ga
                ON u.utilizador_id = ga.gestor_agricola_id
                    AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
            INNER JOIN instalacao_agricola ia
                ON ga.instalacao_agricola_id = ia.instalacao_agricola_id
            INNER JOIN parcela_agricola pa
                ON ia.instalacao_agricola_id = pa.instalacao_agricola_id
             INNER JOIN registo_cultura rc
                ON pa.parcela_agricola_id = rc.parcela_agricola_id AND rc.caderno_campo_id = (SELECT cc.caderno_campo_id
                                                                                                FROM caderno_campo cc
                                                                                                WHERE cc.ano = v_ano)
        GROUP BY ia.instalacao_agricola_id;

        OPEN c_ordena_setores_por_quantidade_producao_decrescente;
                LOOP
                    FETCH c_ordena_setores_por_quantidade_producao_decrescente  INTO  l_parcela_agricola_id, l_designacao, l_area_ha,l_area_plantada_ha, l_quantidade_colhida_ton_por_ha, l_quantidade_producao_total_nesta_parcela_ton_por_ha;
                    EXIT WHEN c_ordena_setores_por_quantidade_producao_decrescente%NOTFOUND;
                    dbms_output.put_line('parcela_agricola_id= '|| l_parcela_agricola_id || ' designacao= '|| l_designacao || ' area_ha= '|| l_area_ha
                                        || ' area_plantada_ha= '|| l_area_plantada_ha
                                        || ' quantidade_colhida_ton_por_ha= '|| l_quantidade_colhida_ton_por_ha
                                        || ' quantidade_producao_total_nesta_parcela_ton_por_ha= ' || l_quantidade_producao_total_nesta_parcela_ton_por_ha);


                END LOOP;
        CLOSE c_ordena_setores_por_quantidade_producao_decrescente;
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_utilizador IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
            END IF;

            IF temp_instalacao_agricola_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'A instalacao agricola nao possui um caderno de campo para o ano especificado');
            END IF;
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');



END p_ordena_setores_por_quantidade_producao_decrescente;
/


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
parcela_agricola_id= 1 designacao= Balmada area_ha= 1100.2 area_plantada_ha= 90 quantidade_colhida_ton_por_ha= 190 quantidade_producao_total_nesta_parcela_ton_por_ha= 8600
parcela_agricola_id= 2 designacao= Japa area_ha= 1000.1    area_plantada_ha= 50 quantidade_colhida_ton_por_ha= 190 quantidade_producao_total_nesta_parcela_ton_por_ha= 4800
parcela_agricola_id= 3 designacao= Opat area_ha= 200.5     area_plantada_ha= 20 quantidade_colhida_ton_por_ha= 150 quantidade_producao_total_nesta_parcela_ton_por_ha= 3000
parcela_agricola_id= 4 designacao= Xat area_ha= 500        area_plantada_ha= 10 quantidade_colhida_ton_por_ha= 200 quantidade_producao_total_nesta_parcela_ton_por_ha= 2000
*/
CALL  p_ordena_setores_por_quantidade_producao_decrescente(1,2021);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: O utilizador especificado nao e um gestor agricola
*/
CALL  p_ordena_setores_por_quantidade_producao_decrescente(2,2021);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o utilizador especificado
*/
CALL  p_ordena_setores_por_quantidade_producao_decrescente(12,2021);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: A instalacao agricola nao possui um caderno de campo para o ano especificado
*/
CALL  p_ordena_setores_por_quantidade_producao_decrescente(1,2030);
