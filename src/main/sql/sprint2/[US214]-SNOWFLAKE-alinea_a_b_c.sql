---------------------------
----------[US214]----------
---------------------------

-----------------------------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 6------------------------------------------------------
-----------------------------------------ALINEA a----------------------------------------------------------------
--Qual é a evolução da produção de uma determinada cultura num determinado setor ao longo dos últimos cinco anos?

SET SERVEROUTPUT ON;


create or replace PROCEDURE p_evolucao_producao(v_designacao_p produto.designacao_p%TYPE, v_parcela_agricola_id parcela_agricola.parcela_agricola_id%TYPE) 
IS
    
    l_designacao_p_ou_v                producao_venda.designacao_p_ou_v%TYPE;
    l_designacao_p                     produto.designacao_p%TYPE;
    l_valor_mercado_por_ha             produto.valor_mercado_por_ha%TYPE;
    l_parcela_agricola_id              parcela_agricola.parcela_agricola_id%TYPE;
    l_ano                              ano.ano%TYPE;
    l_producao_toneladas               producao_venda.producao_toneladas%TYPE;
    
    temp_designacao_p                  produto.designacao_p%TYPE;
    temp_parcela_agricola              parcela_agricola.parcela_agricola_id%TYPE;
   
    
    
   CURSOR c_evolucao_producao IS
        SELECT pv.designacao_p_ou_v , p.designacao_p, p.valor_mercado_por_ha, pa.parcela_agricola_id, a.ano , pv.producao_toneladas
        FROM producao_venda pv
            INNER JOIN tempo t ON pv.tempo_id = t.tempo_id
            INNER JOIN ano a ON t.ano = a.ano
            INNER JOIN produto p ON pv.produto_id = p.produto_id
            INNER JOIN parcela_agricola pa ON pv.parcela_agricola_id = pa.parcela_agricola_id
            WHERE pv.designacao_p_ou_v = 'producao' 
                AND p.designacao_p = v_designacao_p 
                AND pa.parcela_agricola_id = v_parcela_agricola_id 
                AND a.ano >= EXTRACT(YEAR FROM sysdate) - 5 ; 
    
BEGIN

    SELECT p.designacao_p INTO temp_designacao_p
    FROM produto p
        WHERE p.designacao_p = v_designacao_p AND ROWNUM <=1;
        
    SELECT pa.parcela_agricola_id INTO temp_parcela_agricola
    FROM parcela_agricola pa
        WHERE pa.parcela_agricola_id = v_parcela_agricola_id;        
    
               
        OPEN c_evolucao_producao;
                LOOP
                    FETCH c_evolucao_producao INTO l_designacao_p_ou_v, l_designacao_p, l_valor_mercado_por_ha, l_parcela_agricola_id, l_ano, l_producao_toneladas; 
                    EXIT WHEN c_evolucao_producao%NOTFOUND;
                    dbms_output.put_line('designacao_p_ou_v= '|| l_designacao_p_ou_v || ' designacao_p= '|| l_designacao_p || ' valor_mercado_por_ha= '|| l_valor_mercado_por_ha  
                                        || ' parcela_agricola_id= '|| l_parcela_agricola_id || ' ano= '|| l_ano
                                        || ' producao_toneladas= '|| l_producao_toneladas );

                END LOOP;
        CLOSE c_evolucao_producao;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_designacao_p IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o produto especificado');
            END IF;
            IF temp_parcela_agricola IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe a parcela agricola especificada');
            END IF;
        END;
    
END p_evolucao_producao;
/


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
designacao_p_ou_v= producao designacao_p= rosas valor_mercado_por_ha= 10 parcela_agricola_id= 1 ano= 2018 producao_toneladas= 10
designacao_p_ou_v= producao designacao_p= rosas valor_mercado_por_ha= 10 parcela_agricola_id= 1 ano= 2019 producao_toneladas= 40
designacao_p_ou_v= producao designacao_p= rosas valor_mercado_por_ha= 10 parcela_agricola_id= 1 ano= 2020 producao_toneladas= 90
designacao_p_ou_v= producao designacao_p= rosas valor_mercado_por_ha= 10 parcela_agricola_id= 1 ano= 2021 producao_toneladas= 160
designacao_p_ou_v= producao designacao_p= rosas valor_mercado_por_ha= 10 parcela_agricola_id= 1 ano= 2022 producao_toneladas= 250
*/
CALL  p_evolucao_producao('rosas',1);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o produto especificado*/
CALL  p_evolucao_producao('peras',1);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe a parcela agricola especificada*/
CALL  p_evolucao_producao('rosas',5);



-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 6------------------------------------
-----------------------------------------ALINEA b----------------------------------------------
-------------------------Comparar as vendas de um ano com outro?-------------------------------


create or replace PROCEDURE p_comparar_vendas(v_ano_x ano.ano%TYPE, v_ano_y ano.ano%TYPE) 
IS
    
    l_designacao_p_ou_v                producao_venda.designacao_p_ou_v%TYPE;
    l_ano                              ano.ano%TYPE;
    l_sum_venda_milhares_euros         producao_venda.venda_milhares_euros%TYPE;
    
    temp_ano_x                        ano.ano%TYPE;
    temp_ano_y                        ano.ano%TYPE;
    
    
   CURSOR c_comparar_vendas IS
        SELECT pv.designacao_p_ou_v , a.ano, SUM(pv.venda_milhares_euros)
        FROM producao_venda pv
            INNER JOIN tempo t ON pv.tempo_id = t.tempo_id
            INNER JOIN ano a   ON t.ano = a.ano
            INNER JOIN produto p ON pv.produto_id = p.produto_id
            WHERE pv.designacao_p_ou_v = 'venda'
            GROUP BY pv.designacao_p_ou_v , a.ano
            ORDER BY a.ano;
    
BEGIN

    SELECT a.ano INTO temp_ano_x
    FROM ano a
        WHERE a.ano = v_ano_x;
        
    SELECT a.ano INTO temp_ano_y
    FROM ano a
        WHERE a.ano = v_ano_y;
       
                   
    OPEN c_comparar_vendas;
        LOOP
           FETCH c_comparar_vendas INTO l_designacao_p_ou_v, l_ano, l_sum_venda_milhares_euros; 
           EXIT WHEN c_comparar_vendas%NOTFOUND;
           
           IF l_ano = temp_ano_x OR l_ano = temp_ano_y THEN
                dbms_output.put_line('designacao_p_ou_v= '|| l_designacao_p_ou_v || ' ano= '|| l_ano 
                                    || ' sum_venda_milhares_euros= '|| l_sum_venda_milhares_euros);
            END IF;
                   
       END LOOP;
    CLOSE c_comparar_vendas;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_ano_x IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe registo de vendas neste ano ' ||v_ano_x);
            END IF;
            IF temp_ano_y IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe registo de vendas neste ano ' ||v_ano_y);
            END IF;
        END;
    
END p_comparar_vendas;
/


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
designacao_p_ou_v= venda ano= 2018 sum_venda_milhares_euros= 200
designacao_p_ou_v= venda ano= 2022 sum_venda_milhares_euros= 3910

*/
CALL  p_comparar_vendas(2018,2022);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe registo de vendas neste ano 2017
*/
CALL  p_comparar_vendas(2017,2022);



-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 6------------------------------------
-----------------------------------------ALINEA c----------------------------------------------
-------------------Analisar a evolução das vendas mensais por tipo de cultura?-----------------

create or replace PROCEDURE p_analisar_vendas_mensais_por_tipo_cultura(v_designacao_tc  tipo_cultura.designacao%TYPE) 
IS
    
    l_ano                              ano.ano%TYPE;
    l_mes_nome                         mes.nome%TYPE; 
    l_sum_venda_milhares_euros         producao_venda.venda_milhares_euros%TYPE;
    
    temp_v_designacao_tc               tipo_cultura.designacao%TYPE;
    
    
   CURSOR c_analisar_vendas_mensais_por_tipo_cultura IS
        SELECT  a.ano, m.nome, SUM(pv.venda_milhares_euros)
        FROM producao_venda pv
            INNER JOIN tempo t ON pv.tempo_id = t.tempo_id
            INNER JOIN ano a ON t.ano = a.ano
            INNER JOIN mes m ON t.mes = m.mes
            INNER JOIN produto p ON pv.produto_id = p.produto_id
            INNER JOIN tipo_cultura tc ON p.tipo_cultura_id = tc.tipo_cultura_id
            WHERE pv.designacao_p_ou_v = 'venda'
                AND tc.designacao = v_designacao_tc
            GROUP BY a.ano, m.mes, m.nome
            ORDER BY a.ano, m.mes;
    
BEGIN

    SELECT tc.designacao INTO temp_v_designacao_tc
    FROM tipo_cultura tc
        WHERE tc.designacao = v_designacao_tc;
                
    OPEN c_analisar_vendas_mensais_por_tipo_cultura;
        dbms_output.put_line('TIPO DE CULTURA= ' || v_designacao_tc);
        LOOP
           FETCH c_analisar_vendas_mensais_por_tipo_cultura INTO l_ano, l_mes_nome, l_sum_venda_milhares_euros; 
           EXIT WHEN c_analisar_vendas_mensais_por_tipo_cultura%NOTFOUND;
           
                dbms_output.put_line('ano= '|| l_ano || ' mes_nome= '|| l_mes_nome 
                                    || '   sum_venda_milhares_euros= '|| l_sum_venda_milhares_euros);                   
       END LOOP;
    CLOSE c_analisar_vendas_mensais_por_tipo_cultura;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011,'Nao existe o tipo cultura especificado ');
    
END p_analisar_vendas_mensais_por_tipo_cultura;
/


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
TIPO DE CULTURA= temporaria
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
ano= 2019 mes_nome= julho   sum_venda_milhares_euros= 90
ano= 2019 mes_nome= agosto   sum_venda_milhares_euros= 110
ano= 2019 mes_nome= setembro   sum_venda_milhares_euros= 90
ano= 2019 mes_nome= outubro   sum_venda_milhares_euros= 100
ano= 2019 mes_nome= novembro   sum_venda_milhares_euros= 50
ano= 2019 mes_nome= dezembro   sum_venda_milhares_euros= 60
ano= 2020 mes_nome= janeiro   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= fevereiro   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= marco   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= abril   sum_venda_milhares_euros= 50
ano= 2020 mes_nome= maio   sum_venda_milhares_euros= 80
ano= 2020 mes_nome= junho   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= julho   sum_venda_milhares_euros= 90
ano= 2020 mes_nome= agosto   sum_venda_milhares_euros= 50
ano= 2020 mes_nome= setembro   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= outubro   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= novembro   sum_venda_milhares_euros= 75
ano= 2020 mes_nome= dezembro   sum_venda_milhares_euros= 75
ano= 2021 mes_nome= janeiro   sum_venda_milhares_euros= 130
ano= 2021 mes_nome= fevereiro   sum_venda_milhares_euros= 120
ano= 2021 mes_nome= marco   sum_venda_milhares_euros= 150
ano= 2021 mes_nome= abril   sum_venda_milhares_euros= 130
ano= 2021 mes_nome= maio   sum_venda_milhares_euros= 160
ano= 2021 mes_nome= junho   sum_venda_milhares_euros= 100
ano= 2021 mes_nome= julho   sum_venda_milhares_euros= 170
ano= 2021 mes_nome= agosto   sum_venda_milhares_euros= 80
ano= 2021 mes_nome= setembro   sum_venda_milhares_euros= 190
ano= 2021 mes_nome= outubro   sum_venda_milhares_euros= 140
ano= 2021 mes_nome= novembro   sum_venda_milhares_euros= 150
ano= 2021 mes_nome= dezembro   sum_venda_milhares_euros= 20
ano= 2022 mes_nome= janeiro   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= fevereiro   sum_venda_milhares_euros= 150
ano= 2022 mes_nome= marco   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= abril   sum_venda_milhares_euros= 150
ano= 2022 mes_nome= maio   sum_venda_milhares_euros= 140
ano= 2022 mes_nome= junho   sum_venda_milhares_euros= 170
ano= 2022 mes_nome= julho   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= agosto   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= setembro   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= outubro   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= novembro   sum_venda_milhares_euros= 160
ano= 2022 mes_nome= dezembro   sum_venda_milhares_euros= 150
*/
CALL  p_analisar_vendas_mensais_por_tipo_cultura('temporaria');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o tipo cultura especificado
*/
CALL  p_analisar_vendas_mensais_por_tipo_cultura('semestral');




