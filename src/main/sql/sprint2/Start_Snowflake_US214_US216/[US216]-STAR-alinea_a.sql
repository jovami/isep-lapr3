---------------------------
----------[US216]----------
---------------------------

-----------------------------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 4------------------------------------------------------
-----------------------------------------ALINEA a----------------------------------------------------------------
----------------Analisar a evolução das vendas mensais por tipo de cultura e hub?--------------------------------

SET SERVEROUTPUT ON;


create or replace PROCEDURE p_analisar_vendas_mensais_por_tipo_cultura_e_hub(v_designacao_tc  produto.designacao_tc%TYPE, v_designacao_th hub.designacao_th%TYPE) 
IS
    
    l_ano                              tempo.ano%TYPE;
    l_mes_nome                         tempo.mes_nome%TYPE; 
    l_sum_venda_milhares_euros         producao_venda.venda_milhares_euros%TYPE;
    
    temp_v_designacao_tc               produto.designacao_tc%TYPE;
    temp_v_designacao_th               hub.designacao_th%TYPE;
    
   CURSOR c_analisar_vendas_mensais_por_tipo_cultura_e_hub IS
        SELECT t.ano, t.mes_nome, SUM(pv.venda_milhares_euros)
        FROM producao_venda pv
            INNER JOIN tempo t ON pv.tempo_id = t.tempo_id
            INNER JOIN produto p ON pv.produto_id = p.produto_id
            INNER JOIN hub h ON pv.hub_id = h.hub_id
            WHERE pv.designacao_p_ou_v = 'venda'
                AND p.designacao_tc = v_designacao_tc
                AND h.designacao_th = v_designacao_th
            GROUP BY t.ano, t.mes, t.mes_nome
            ORDER BY t.ano, t.mes;
    
BEGIN

    SELECT p.designacao_tc INTO temp_v_designacao_tc
    FROM produto p
        WHERE p.designacao_tc = v_designacao_tc AND ROWNUM <=1;
        
    SELECT h.designacao_th INTO temp_v_designacao_th
    FROM hub h
        WHERE h.designacao_th = v_designacao_th AND ROWNUM <=1 ;
                
    OPEN c_analisar_vendas_mensais_por_tipo_cultura_e_hub;
        dbms_output.put_line('TIPO DE CULTURA= ' || v_designacao_tc);
        dbms_output.put_line('TIPO DE HUB= ' || v_designacao_th);
        LOOP
           FETCH c_analisar_vendas_mensais_por_tipo_cultura_e_hub INTO l_ano, l_mes_nome, l_sum_venda_milhares_euros; 
           EXIT WHEN c_analisar_vendas_mensais_por_tipo_cultura_e_hub%NOTFOUND;
           
                dbms_output.put_line('ano= '|| l_ano || ' mes_nome= '|| l_mes_nome 
                                    || '   sum_venda_milhares_euros= '|| l_sum_venda_milhares_euros);                   
       END LOOP;
    CLOSE c_analisar_vendas_mensais_por_tipo_cultura_e_hub;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_v_designacao_tc IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o tipo cultura especificado ');
            END IF;
            IF temp_v_designacao_th IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o tipo hub especificado ');
            END IF;           
        END;
    
END p_analisar_vendas_mensais_por_tipo_cultura_e_hub;
/


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
TIPO DE CULTURA= temporaria
TIPO DE HUB= P
ano= 2018 mes_nome= janeiro   sum_venda_milhares_euros= 20
ano= 2018 mes_nome= fevereiro   sum_venda_milhares_euros= 20
ano= 2018 mes_nome= marco   sum_venda_milhares_euros= 20
ano= 2018 mes_nome= abril   sum_venda_milhares_euros= 20
ano= 2018 mes_nome= maio   sum_venda_milhares_euros= 20
ano= 2019 mes_nome= janeiro   sum_venda_milhares_euros= 30
ano= 2019 mes_nome= fevereiro   sum_venda_milhares_euros= 40
ano= 2019 mes_nome= marco   sum_venda_milhares_euros= 60
ano= 2019 mes_nome= abril   sum_venda_milhares_euros= 40
ano= 2019 mes_nome= maio   sum_venda_milhares_euros= 60
ano= 2019 mes_nome= junho   sum_venda_milhares_euros= 50
ano= 2020 mes_nome= janeiro   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= fevereiro   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= marco   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= abril   sum_venda_milhares_euros= 50
ano= 2020 mes_nome= maio   sum_venda_milhares_euros= 80
ano= 2020 mes_nome= junho   sum_venda_milhares_euros= 75
ano= 2021 mes_nome= janeiro   sum_venda_milhares_euros= 130
ano= 2021 mes_nome= fevereiro   sum_venda_milhares_euros= 120
ano= 2021 mes_nome= marco   sum_venda_milhares_euros= 150
ano= 2021 mes_nome= abril   sum_venda_milhares_euros= 130
ano= 2021 mes_nome= maio   sum_venda_milhares_euros= 160
ano= 2021 mes_nome= junho   sum_venda_milhares_euros= 100
ano= 2022 mes_nome= janeiro   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= fevereiro   sum_venda_milhares_euros= 150
ano= 2022 mes_nome= marco   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= abril   sum_venda_milhares_euros= 150
ano= 2022 mes_nome= maio   sum_venda_milhares_euros= 140
ano= 2022 mes_nome= junho   sum_venda_milhares_euros= 170
*/
CALL  p_analisar_vendas_mensais_por_tipo_cultura_e_hub('temporaria','P');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o tipo cultura especificado
*/
CALL  p_analisar_vendas_mensais_por_tipo_cultura_e_hub('semestral','P');
 

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o tipo hub especificado
*/
CALL  p_analisar_vendas_mensais_por_tipo_cultura_e_hub('temporaria','D');