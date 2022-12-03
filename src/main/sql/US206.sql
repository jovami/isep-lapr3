---------------------------
----------[US206]----------
---------------------------

-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 1------------------------------------
-----------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;

create or replace PROCEDURE p_cria_parcela_agricola(v_utilizador_id utilizador.utilizador_id%TYPE, v_designacao_pa  parcela_agricola.designacao%TYPE,
                                                    v_area_ha_pa  parcela_agricola.area_ha%TYPE) 
IS
    

    temp_instalacao_agricola_id         instalacao_agricola.instalacao_agricola_id%TYPE;
    temp_utilizador                     utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador                tipo_utilizador.designacao%TYPE;
    
    l_parcela_agricola_id               parcela_agricola.parcela_agricola_id%TYPE;
    l_designacao                        parcela_agricola.designacao%TYPE;
    l_area_ha                           parcela_agricola.area_ha%TYPE;
    l_instalacao_agricola_id            instalacao_agricola.instalacao_agricola_id%TYPE;
    
    
    
    CURSOR c_parcela_agricola   IS 
    SELECT parcela_agricola_id , designacao, area_ha, instalacao_agricola_id FROM parcela_agricola;
    
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
        SELECT ia.instalacao_agricola_id INTO  temp_instalacao_agricola_id
            FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
            INNER JOIN gestor_agricola ga
                ON u.utilizador_id = ga.gestor_agricola_id
                    AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
            INNER JOIN instalacao_agricola ia
                ON ga.instalacao_agricola_id = ia.instalacao_agricola_id;
     
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;
    
    
    INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id)  VALUES (v_designacao_pa,v_area_ha_pa,temp_instalacao_agricola_id);
    
    OPEN c_parcela_agricola;
        LOOP
            FETCH c_parcela_agricola INTO l_parcela_agricola_id , l_designacao, l_area_ha, l_instalacao_agricola_id;
            EXIT WHEN c_parcela_agricola%NOTFOUND;
                
                DBMS_OUTPUT.PUT_LINE('parcela_agricola_id= '|| l_parcela_agricola_id || ' designacao= '|| l_designacao || ' area_ha= '|| l_area_ha 
                                    || ' instalacao_agricola_id= ' || l_instalacao_agricola_id);
                
        END LOOP;
    CLOSE c_parcela_agricola;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_utilizador IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
            END IF;
        
            IF temp_instalacao_agricola_id IS NULL THEN 
                RAISE_APPLICATION_ERROR (-20006,'Este utilizador nao esta associado a nenhuma instalacao agricola');
            END IF;  
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
            
    END p_cria_parcela_agricola;
    /
    

    
SAVEPOINT us206_cria_parcela_agricola;


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
parcela_agricola_id= 1 designacao= Balmada area_ha= 1100.2 instalacao_agricola_id= 1
parcela_agricola_id= 2 designacao= Japa area_ha= 1000.1 instalacao_agricola_id= 1
parcela_agricola_id= 3 designacao= Opat area_ha= 200.5 instalacao_agricola_id= 1
parcela_agricola_id= 4 designacao= Xat area_ha= 500 instalacao_agricola_id= 1
parcela_agricola_id= 5 designacao= Patas area_ha= 500.12 instalacao_agricola_id= 1
*/
CALL p_cria_parcela_agricola(1,'Patas', 500.12);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o utilizador especificado
*/
CALL p_cria_parcela_agricola(NULL,'Patas', 500.12);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: O utilizador especificado nao e um gestor agricola
*/
CALL p_cria_parcela_agricola(2,'Patas', 500.12);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
CALL p_cria_parcela_agricola(12,'Patas', 500.12,'peras','temporaria')
Error report -
ORA-20011: Nao existe o utilizador especificado
*/
CALL p_cria_parcela_agricola(12,'Patas', 500.12);

ROLLBACK TO us206_cria_parcela_agricola;
    


-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 2.1----------------------------------
-----------------------------------------------------------------------------------------------

create or replace PROCEDURE p_cria_tipo_cultura(v_designacao_tc tipo_cultura.designacao%TYPE) 
IS
    
    
    l_tipo_cultura_id                   tipo_cultura.tipo_cultura_id%TYPE;
    l_designacao                        tipo_cultura.designacao%TYPE;
    
    temp_designacao                     tipo_cultura.designacao%TYPE;
   
    CURSOR c_tipo_cultura   IS 
    SELECT tipo_cultura_id , designacao FROM tipo_cultura;
    
    EX_ERRO_DESIGNACAO_EXISTENTE EXCEPTION;
    EX_ERRO_DESIGNACAO_NULL EXCEPTION;
    
BEGIN 

    IF v_designacao_tc IS NOT NULL THEN   
       SELECT tc.designacao INTO temp_designacao
            FROM tipo_cultura tc 
            WHERE tc.designacao = v_designacao_tc;
        RAISE  EX_ERRO_DESIGNACAO_EXISTENTE;
    ELSE
        RAISE  EX_ERRO_DESIGNACAO_NULL; 
    END IF;
            
    EXCEPTION        
    WHEN NO_DATA_FOUND THEN
        INSERT INTO tipo_cultura(designacao)  VALUES (v_designacao_tc);
        
    OPEN c_tipo_cultura;
        LOOP
            FETCH c_tipo_cultura INTO l_tipo_cultura_id , l_designacao;
            EXIT WHEN c_tipo_cultura%NOTFOUND;
                
                DBMS_OUTPUT.PUT_LINE('tipo_cultura_id= '|| l_tipo_cultura_id || ' designacao= '|| l_designacao);
                
        END LOOP;
    CLOSE c_tipo_cultura;
    
    WHEN EX_ERRO_DESIGNACAO_NULL THEN 
        RAISE_APPLICATION_ERROR(-20011,'Esta a tentar criar um novo tipo_cultura com a designacao a NULL');
    WHEN EX_ERRO_DESIGNACAO_EXISTENTE THEN 
        RAISE_APPLICATION_ERROR(-20011,'Esta a tentar criar um novo tipo_cultura ja existente');
    
    END p_cria_tipo_cultura;
    /
    

    
SAVEPOINT us206_cria_tipo_cultura;


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
tipo_cultura_id= 1 designacao= temporaria
tipo_cultura_id= 2 designacao= permanente
tipo_cultura_id= 3 designacao= semestral
*/
CALL p_cria_tipo_cultura('semestral');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Esta a tentar criar um novo tipo_cultura ja existente
*/
CALL p_cria_tipo_cultura('temporaria');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Esta a tentar criar um novo tipo_cultura com a designacao a NULL
*/
CALL p_cria_tipo_cultura(NULL);
    
ROLLBACK TO us206_cria_tipo_cultura;


-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 2.2----------------------------------
-----------------------------------------------------------------------------------------------

create or replace PROCEDURE p_cria_produto(v_designacao_p produto.designacao%TYPE, v_valor_mercado_por_ha_p produto.valor_mercado_por_ha%TYPE) 
IS
    
    
    l_produto_id                        produto.produto_id%TYPE;
    l_designacao                        produto.designacao%TYPE;
    l_valor_mercado_por_ha              produto.valor_mercado_por_ha%TYPE;
    
    temp_designacao                     produto.designacao%TYPE;
   
    CURSOR c_produto   IS 
    SELECT produto_id , designacao, valor_mercado_por_ha FROM produto;
    
    EX_ERRO_DESIGNACAO_EXISTENTE EXCEPTION;
    EX_ERRO_DESIGNACAO_NULL EXCEPTION;
    
BEGIN 

    IF v_designacao_p IS NOT NULL THEN   
       SELECT p.designacao INTO temp_designacao
            FROM produto p 
            WHERE p.designacao = v_designacao_p;
       RAISE  EX_ERRO_DESIGNACAO_EXISTENTE;
    ELSE
        RAISE  EX_ERRO_DESIGNACAO_NULL; 
    END IF;
            
    EXCEPTION        
    WHEN NO_DATA_FOUND THEN
        INSERT INTO produto(designacao,valor_mercado_por_ha) VALUES (v_designacao_p,v_valor_mercado_por_ha_p);
        
    OPEN c_produto;
        LOOP
            FETCH c_produto INTO l_produto_id , l_designacao, l_valor_mercado_por_ha ;
            EXIT WHEN c_produto%NOTFOUND;
                
                DBMS_OUTPUT.PUT_LINE('produto_id= '|| l_produto_id || ' designacao= '|| l_designacao || ' valor_mercado_por_ha= '|| l_valor_mercado_por_ha );
                
        END LOOP;
    CLOSE c_produto;
    
    WHEN EX_ERRO_DESIGNACAO_NULL THEN 
        RAISE_APPLICATION_ERROR(-20011,'Esta a tentar criar um novo produto com a designacao a NULL');
    WHEN EX_ERRO_DESIGNACAO_EXISTENTE THEN 
        RAISE_APPLICATION_ERROR(-20011,'Esta a tentar criar um novo produto ja existente');
    
    END p_cria_produto;
    /
    

    
SAVEPOINT us206_p_cria_produto;


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
produto_id= 1 designacao= rosas valor_mercado_por_ha= 1000
produto_id= 2 designacao= macas valor_mercado_por_ha= 2000
produto_id= 3 designacao= trigo valor_mercado_por_ha= 3000
produto_id= 4 designacao= adubacao verde valor_mercado_por_ha= 0
produto_id= 5 designacao= laranjas valor_mercado_por_ha= 4000
*/
CALL p_cria_produto('laranjas',4000);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Esta a tentar criar um novo produto com a designacao a NULL
*/
CALL p_cria_produto(NULL,4000);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Esta a tentar criar um novo produto ja existente
*/
CALL p_cria_produto('rosas',4000);


ROLLBACK TO us206_p_cria_produto;


-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 2.3----------------------------------
-----------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER t_registar_cultura
AFTER UPDATE ON registo_cultura
FOR EACH ROW

DECLARE
    
    temp_produto_id             produto.produto_id%TYPE;
    temp_caderno_campo_id       caderno_campo.caderno_campo_id%TYPE;
    
BEGIN

      SELECT s.produto_id, s.caderno_campo_id INTO temp_produto_id, temp_caderno_campo_id
      FROM stock s
      WHERE s.produto_id = :NEW.produto_id 
        AND s.caderno_campo_id = :NEW.caderno_campo_id;
      
      UPDATE stock 
      SET stock_ton = stock_ton + (:NEW.quantidade_colhida_ton_por_ha * :NEW.area_plantada_ha)
      WHERE produto_id = temp_produto_id AND caderno_campo_id = temp_caderno_campo_id;
      
     EXCEPTION 
     WHEN NO_DATA_FOUND THEN
        INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (:NEW.produto_id,:NEW.caderno_campo_id,
                            :NEW.quantidade_colhida_ton_por_ha * :NEW.area_plantada_ha );
    
END t_registar_cultura;
/


create or replace PROCEDURE p_registo_cultura(v_utilizador_id utilizador.utilizador_id%TYPE, v_parcela_agricola_id parcela_agricola.parcela_agricola_id%TYPE,
                                              v_caderno_campo_id caderno_campo.caderno_campo_id%TYPE, v_produto_id produto.produto_id%TYPE,
                                              v_tipo_cultura_id tipo_cultura.tipo_cultura_id%TYPE, v_data_plantacao registo_cultura.data_plantacao%TYPE,
                                              v_data_colheita registo_cultura.data_colheita%TYPE, v_quantidade_colhida_ton_por_ha registo_cultura.quantidade_colhida_ton_por_ha%TYPE,
                                              v_area_plantada_ha registo_cultura.area_plantada_ha%TYPE) 
IS
    
    
    l_parcela_agricola_id                        parcela_agricola.parcela_agricola_id%TYPE;
    l_caderno_campo_id                           caderno_campo.caderno_campo_id%TYPE;
    l_produto_id                                 produto.produto_id%TYPE;
    l_tipo_cultura_id                            tipo_cultura.tipo_cultura_id%TYPE;
    l_data_plantacao                             registo_cultura.data_plantacao%TYPE;
    l_data_colheita                              registo_cultura.data_colheita%TYPE;
    l_quantidade_colhida_ton_por_ha              registo_cultura.quantidade_colhida_ton_por_ha%TYPE;
    l_area_plantada_ha                           registo_cultura.area_plantada_ha%TYPE;
    
    temp_utilizador                              utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador                         tipo_utilizador.designacao%TYPE;
   
    CURSOR c_registo_cultura   IS 
    SELECT caderno_campo_id, parcela_agricola_id , produto_id, tipo_cultura_id, data_plantacao,
            area_plantada_ha, data_colheita, quantidade_colhida_ton_por_ha
    FROM registo_cultura;
    
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
        
        INSERT INTO registo_cultura(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
                    area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)  
                    VALUES 
                    (v_caderno_campo_id,v_parcela_agricola_id,v_produto_id,v_tipo_cultura_id,v_data_plantacao,v_area_plantada_ha,
                     v_data_colheita,v_quantidade_colhida_ton_por_ha);
        
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;

    OPEN c_registo_cultura;
        LOOP
            FETCH c_registo_cultura INTO l_caderno_campo_id, l_parcela_agricola_id , l_produto_id, l_tipo_cultura_id, l_data_plantacao, l_area_plantada_ha, l_data_colheita, l_quantidade_colhida_ton_por_ha ;
            EXIT WHEN c_registo_cultura%NOTFOUND;
                
                DBMS_OUTPUT.PUT_LINE('caderno_campo_id= '|| l_caderno_campo_id || ' parcela_agricola_id= '|| l_parcela_agricola_id 
                                    || ' produto_id= '|| l_produto_id ||' tipo_cultura_id='|| l_tipo_cultura_id ||' data_plantacao=' 
                                    ||l_data_plantacao ||' area_plantada_ha=' || l_area_plantada_ha ||' data_colheita=' || l_data_colheita
                                    ||' quantidade_colhida_ton_por_ha=' || l_quantidade_colhida_ton_por_ha);
                
        END LOOP;
    CLOSE c_registo_cultura;
  
            
    EXCEPTION        
    WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
    WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
    
    END p_registo_cultura;
    /
    

    
SAVEPOINT us206_p_registo_cultura;


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
caderno_campo_id= 1 parcela_agricola_id= 1 produto_id= 1 tipo_cultura_id=1 data_plantacao=04-JAN-21 area_plantada_ha=50 data_colheita=20-DEC-21 quantidade_colhida_ton_por_ha=100
caderno_campo_id= 1 parcela_agricola_id= 1 produto_id= 2 tipo_cultura_id=1 data_plantacao=04-JAN-21 area_plantada_ha=40 data_colheita=20-DEC-21 quantidade_colhida_ton_por_ha=90
caderno_campo_id= 1 parcela_agricola_id= 2 produto_id= 2 tipo_cultura_id=1 data_plantacao=04-JAN-21 area_plantada_ha=30 data_colheita=21-DEC-21 quantidade_colhida_ton_por_ha=100
caderno_campo_id= 1 parcela_agricola_id= 2 produto_id= 3 tipo_cultura_id=2 data_plantacao=04-JAN-21 area_plantada_ha=20 data_colheita=21-DEC-21 quantidade_colhida_ton_por_ha=90
caderno_campo_id= 1 parcela_agricola_id= 3 produto_id= 3 tipo_cultura_id=2 data_plantacao=04-JAN-21 area_plantada_ha=20 data_colheita=22-DEC-21 quantidade_colhida_ton_por_ha=150
caderno_campo_id= 1 parcela_agricola_id= 4 produto_id= 4 tipo_cultura_id=1 data_plantacao=04-JAN-21 area_plantada_ha=10 data_colheita=23-DEC-21 quantidade_colhida_ton_por_ha=200
caderno_campo_id= 1 parcela_agricola_id= 1 produto_id= 2 tipo_cultura_id=1 data_plantacao=01-MAR-23 area_plantada_ha=30 data_colheita= quantidade_colhida_ton_por_ha=
*/
CALL p_registo_cultura(1,1,1,2,1,TO_DATE('01/03/2023 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL,30);


---------INFORMACAO ANTES DE ATUALIZAR O STOCK---------
---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
CADERNO_CAMPO_ID PRODUTO_ID  STOCK_TON
---------------- ---------- ----------
               1          1        100
               1          2        190(este e o dado que vai ser atualizado)
               1          3        240
               1          4        200
               2          1        100
               2          2        190
               2          3        240
               2          4        200
*/
SELECT * FROM stock;

 UPDATE registo_cultura 
 SET data_colheita = TO_DATE('12/12/2023 16:00','DD/MM/YYYY HH24:MI'), quantidade_colhida_ton_por_ha = 5 
    WHERE parcela_agricola_id = 1 
        AND caderno_campo_id = 1
        AND produto_id = 2
        AND tipo_cultura_id = 1
        AND data_plantacao = TO_DATE('01/03/2023 16:00','DD/MM/YYYY HH24:MI');


---------INFORMACAO APOS DE ATUALIZAR O STOCK---------
---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
CADERNO_CAMPO_ID PRODUTO_ID  STOCK_TON
---------------- ---------- ----------
               1          1        100
               1          2        340(este foi o dado atualizado, quantidade_colhida_ton_por_ha * area_plantada_ha = 5 * 30, 190 + 150 = 340)
               1          3        240
               1          4        200
               2          1        100
               2          2        190
               2          3        240
               2          4        200
*/
SELECT * FROM stock;
    
ROLLBACK TO us206_p_registo_cultura;




-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 3------------------------------------
-----------------------------------------------------------------------------------------------


create or replace PROCEDURE p_ordena_alfabeticamente_parcela_agricola(v_utilizador_id utilizador.utilizador_id%TYPE, v_ordem VARCHAR) 
IS
    
    
    l_parcela_agricola_id       parcela_agricola.parcela_agricola_id%TYPE; 
    l_designacao                parcela_agricola.designacao%TYPE;
    l_area_ha                   parcela_agricola.area_ha%TYPE;
    l_instalacao_agricola_id    parcela_agricola.instalacao_agricola_id%TYPE;
    
    temp_utilizador             utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador        tipo_utilizador.designacao%TYPE;
    
    
    CURSOR c_ordena_crescente IS
        SELECT pa.parcela_agricola_id, pa.designacao, pa.area_ha, pa.instalacao_agricola_id 
        FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
        INNER JOIN gestor_agricola ga
            ON u.utilizador_id = ga.gestor_agricola_id
                AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
        INNER JOIN instalacao_agricola ia
            ON ga.instalacao_agricola_id = ia.instalacao_agricola_id
        INNER JOIN parcela_agricola pa
            ON ia.instalacao_agricola_id = pa.instalacao_agricola_id
        ORDER BY pa.designacao;
            
            
    
        
    CURSOR c_ordena_decrescente IS
        SELECT pa.parcela_agricola_id, pa.designacao, pa.area_ha, pa.instalacao_agricola_id 
        FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
        INNER JOIN gestor_agricola ga
            ON u.utilizador_id = ga.gestor_agricola_id
                AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
        INNER JOIN instalacao_agricola ia
            ON ga.instalacao_agricola_id = ia.instalacao_agricola_id
        INNER JOIN parcela_agricola pa
            ON ia.instalacao_agricola_id = pa.instalacao_agricola_id
        ORDER BY pa.designacao DESC; 
        
        
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
        IF v_ordem LIKE 'crescente' THEN
            OPEN c_ordena_crescente;
                LOOP
                    FETCH c_ordena_crescente  into  l_parcela_agricola_id, l_designacao, l_area_ha , l_instalacao_agricola_id;
                    EXIT WHEN c_ordena_crescente%NOTFOUND;
                    dbms_output.put_line('parcela_agricola_id= '|| l_parcela_agricola_id || ' designacao= '|| l_designacao || ' area_ha= '|| l_area_ha  || ' instalacao_agricola_id= '||l_instalacao_agricola_id);       
                END LOOP;
            CLOSE c_ordena_crescente;
        END IF;
    
        IF v_ordem LIKE 'decrescente' THEN
            OPEN c_ordena_decrescente;
                LOOP
                    FETCH c_ordena_decrescente  into  l_parcela_agricola_id, l_designacao, l_area_ha , l_instalacao_agricola_id;
                    EXIT WHEN c_ordena_decrescente%NOTFOUND;
                    dbms_output.put_line('parcela_agricola_id= '|| l_parcela_agricola_id || ' designacao= '|| l_designacao || ' area_ha= '|| l_area_ha  ||' instalacao_agricola_id= '||l_instalacao_agricola_id);
                END LOOP;
            CLOSE c_ordena_decrescente;
        END IF;
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
        
END p_ordena_alfabeticamente_parcela_agricola;
/


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
parcela_agricola_id= 1 designacao= Balmada area_ha= 1100.2 instalacao_agricola_id= 1
parcela_agricola_id= 2 designacao= Japa area_ha= 1000.1 instalacao_agricola_id= 1
parcela_agricola_id= 3 designacao= Opat area_ha= 200.5 instalacao_agricola_id= 1
parcela_agricola_id= 4 designacao= Xat area_ha= 500 instalacao_agricola_id= 1
*/
CALL  p_ordena_alfabeticamente_parcela_agricola(1,'crescente');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
parcela_agricola_id= 4 designacao= Xat area_ha= 500 instalacao_agricola_id= 1
parcela_agricola_id= 3 designacao= Opat area_ha= 200.5 instalacao_agricola_id= 1
parcela_agricola_id= 2 designacao= Japa area_ha= 1000.1 instalacao_agricola_id= 1
parcela_agricola_id= 1 designacao= Balmada area_ha= 1100.2 instalacao_agricola_id= 1
*/
CALL  p_ordena_alfabeticamente_parcela_agricola(1,'decrescente');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: O utilizador especificado nao e um gestor agricola
*/
CALL  p_ordena_alfabeticamente_parcela_agricola(2,'decrescente');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o utilizador especificado
*/
CALL  p_ordena_alfabeticamente_parcela_agricola(12,'decrescente');




-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 4------------------------------------
-----------------------------------------------------------------------------------------------
create or replace PROCEDURE p_ordena_por_tamanho_parcela_agricola(v_utilizador_id utilizador.utilizador_id%TYPE, v_ordem VARCHAR) 
IS
    
    l_parcela_agricola_id       parcela_agricola.parcela_agricola_id%TYPE; 
    l_designacao                parcela_agricola.designacao%TYPE;
    l_area_ha                   parcela_agricola.area_ha%TYPE;
    l_instalacao_agricola_id    parcela_agricola.instalacao_agricola_id%TYPE;
    
    temp_utilizador             utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador        tipo_utilizador.designacao%TYPE;
    
    CURSOR c_ordena_crescente IS
        SELECT pa.parcela_agricola_id, pa.designacao, pa.area_ha, pa.instalacao_agricola_id 
        FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
        INNER JOIN gestor_agricola ga
            ON u.utilizador_id = ga.gestor_agricola_id
                AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
        INNER JOIN instalacao_agricola ia
            ON ga.instalacao_agricola_id = ia.instalacao_agricola_id
        INNER JOIN parcela_agricola pa
            ON ia.instalacao_agricola_id = pa.instalacao_agricola_id
        ORDER BY pa.area_ha;
            
        
    CURSOR c_ordena_decrescente IS
        SELECT pa.parcela_agricola_id, pa.designacao, pa.area_ha, pa.instalacao_agricola_id 
        FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
        INNER JOIN gestor_agricola ga
            ON u.utilizador_id = ga.gestor_agricola_id
                AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
        INNER JOIN instalacao_agricola ia
            ON ga.instalacao_agricola_id = ia.instalacao_agricola_id
        INNER JOIN parcela_agricola pa
            ON ia.instalacao_agricola_id = pa.instalacao_agricola_id
        ORDER BY pa.area_ha DESC;
        
        
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
        IF v_ordem LIKE 'crescente' THEN
            OPEN c_ordena_crescente;
                LOOP
                    FETCH c_ordena_crescente  into  l_parcela_agricola_id, l_designacao, l_area_ha, l_instalacao_agricola_id;
                    EXIT WHEN c_ordena_crescente%NOTFOUND;
                    dbms_output.put_line('parcela_agricola_id= '|| l_parcela_agricola_id || ' designacao= '|| l_designacao || ' area_ha= '|| l_area_ha  || ' instalacao_agricola_id= '||l_instalacao_agricola_id);       
                END LOOP;
            CLOSE c_ordena_crescente;
        END IF;
    
        IF v_ordem LIKE 'decrescente' THEN
            OPEN c_ordena_decrescente;
                LOOP
                    FETCH c_ordena_decrescente  into  l_parcela_agricola_id, l_designacao, l_area_ha, l_instalacao_agricola_id;
                    EXIT WHEN c_ordena_decrescente%NOTFOUND;
                    dbms_output.put_line('parcela_agricola_id= '|| l_parcela_agricola_id || ' designacao= '|| l_designacao || ' area_ha= '|| l_area_ha  || ' instalacao_agricola_id= '||l_instalacao_agricola_id);
                END LOOP;
            CLOSE c_ordena_decrescente;
        END IF;
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');   
        
END p_ordena_por_tamanho_parcela_agricola;
/

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
parcela_agricola_id= 3 designacao= Opat area_ha= 200.5 instalacao_agricola_id= 1
parcela_agricola_id= 4 designacao= Xat area_ha= 500 instalacao_agricola_id= 1
parcela_agricola_id= 2 designacao= Japa area_ha= 1000.1 instalacao_agricola_id= 1
parcela_agricola_id= 1 designacao= Balmada area_ha= 1100.2 instalacao_agricola_id= 1
`*/
CALL p_ordena_por_tamanho_parcela_agricola(1,'crescente');

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
parcela_agricola_id= 1 designacao= Balmada area_ha= 1100.2 instalacao_agricola_id= 1
parcela_agricola_id= 2 designacao= Japa area_ha= 1000.1 instalacao_agricola_id= 1
parcela_agricola_id= 4 designacao= Xat area_ha= 500 instalacao_agricola_id= 1
parcela_agricola_id= 3 designacao= Opat area_ha= 200.5 instalacao_agricola_id= 1
`*/
CALL p_ordena_por_tamanho_parcela_agricola(1,'decrescente');

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: O utilizador especificado nao e um gestor agricola
`*/
CALL p_ordena_por_tamanho_parcela_agricola(2,'crescente');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o utilizador especificado
`*/
CALL p_ordena_por_tamanho_parcela_agricola(12,'crescente');



-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 5------------------------------------
-----------------------------------------------------------------------------------------------


create or replace PROCEDURE p_ordena_por_cultura_e_tipocultura_parcela_agricola(v_utilizador_id utilizador.utilizador_id%TYPE) 
IS
    
    l_parcela_agricola_id       parcela_agricola.parcela_agricola_id%TYPE; 
    l_designacao                parcela_agricola.designacao%TYPE;
    l_area_ha                   parcela_agricola.area_ha%TYPE;
    l_tc_designacao             tipo_cultura.designacao%TYPE;
    l_p_designacao              produto.designacao%TYPE;
    l_instalacao_agricola_id    parcela_agricola.instalacao_agricola_id%TYPE;
    
    temp_utilizador             utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador        tipo_utilizador.designacao%TYPE;
    
    CURSOR c_ordena_por_cultura_e_tipocultura IS       
        SELECT pa.parcela_agricola_id, pa.designacao, pa.area_ha, tc.designacao AS "tipo cultura designacao",  p.designacao, pa.instalacao_agricola_id 
        FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
        INNER JOIN gestor_agricola ga
            ON u.utilizador_id = ga.gestor_agricola_id
                AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
        INNER JOIN instalacao_agricola ia
            ON ga.instalacao_agricola_id = ia.instalacao_agricola_id
        INNER JOIN parcela_agricola pa
            ON ia.instalacao_agricola_id = pa.instalacao_agricola_id
        INNER JOIN registo_cultura rc
            ON pa.parcela_agricola_id = rc.parcela_agricola_id
        INNER JOIN produto p
            ON rc.produto_id = p.produto_id
        INNER JOIN tipo_cultura tc
            ON rc.tipo_cultura_id = tc.tipo_cultura_id
        ORDER BY tc.designacao, p.designacao;
     
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
        OPEN c_ordena_por_cultura_e_tipocultura;
                LOOP
                    FETCH c_ordena_por_cultura_e_tipocultura  into  l_parcela_agricola_id, l_designacao, l_area_ha , l_tc_designacao, l_p_designacao,  l_instalacao_agricola_id;
                    EXIT WHEN c_ordena_por_cultura_e_tipocultura%NOTFOUND;
                    dbms_output.put_line('parcela_agricola_id= '|| l_parcela_agricola_id || ' designacao= '|| l_designacao || ' area_ha= '|| l_area_ha  
                                        || ' tipo_cultura_designacao= ' || l_tc_designacao || ' produto_designacao= ' ||
                                        l_p_designacao ||' instalacao_agricola_id= '||l_instalacao_agricola_id);
                END LOOP;
        CLOSE c_ordena_por_cultura_e_tipocultura;
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;
    
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
       
              
END p_ordena_por_cultura_e_tipocultura_parcela_agricola;
/

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
parcela_agricola_id= 2 designacao= Japa area_ha= 1000.1     tipo_cultura_designacao= permanente  produto_designacao= trigo           instalacao_agricola_id= 1
parcela_agricola_id= 3 designacao= Opat area_ha= 200.5      tipo_cultura_designacao= permanente  produto_designacao= trigo           instalacao_agricola_id= 1
parcela_agricola_id= 4 designacao= Xat area_ha= 500         tipo_cultura_designacao= temporaria  produto_designacao= adubacao verde  instalacao_agricola_id= 1
parcela_agricola_id= 1 designacao= Balmada area_ha= 1100.2  tipo_cultura_designacao= temporaria  produto_designacao= macas           instalacao_agricola_id= 1
parcela_agricola_id= 2 designacao= Japa area_ha= 1000.1     tipo_cultura_designacao= temporaria  produto_designacao= macas           instalacao_agricola_id= 1
parcela_agricola_id= 1 designacao= Balmada area_ha= 1100.2  tipo_cultura_designacao= temporaria  produto_designacao= rosas           instalacao_agricola_id= 1
`*/
CALL p_ordena_por_cultura_e_tipocultura_parcela_agricola(1);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: O utilizador especificado nao e um gestor agricola
`*/
CALL p_ordena_por_cultura_e_tipocultura_parcela_agricola(2);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o utilizador especificado
`*/
CALL p_ordena_por_cultura_e_tipocultura_parcela_agricola(12);