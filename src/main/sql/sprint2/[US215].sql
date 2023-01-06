---------------------------
----------[US215]----------
---------------------------

-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 1------------------------------------
-----------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;


CREATE TABLE input_hub (
    
    input_string    VARCHAR(25)
);

CREATE OR REPLACE TRIGGER t_actualiza_hubs
AFTER INSERT OR UPDATE OR DELETE ON input_hub
FOR EACH ROW
DECLARE

    temp_hub_id                     hub.hub_id%TYPE;
    temp_localizacao_id             localizacao.localizacao_id%TYPE;
    
BEGIN

    IF deleting THEN
    
        DELETE FROM hub h WHERE h.hub_id = REGEXP_SUBSTR (:OLD.input_string,'[^;]+',1,1) ;
        
        DELETE FROM localizacao l WHERE l.latitude = REGEXP_SUBSTR (:OLD.input_string,'[^;]+',1,2)
                                    AND l.longitude = REGEXP_SUBSTR (:OLD.input_string,'[^;]+',1,3);
        
    ELSIF inserting THEN
    
        SELECT h.hub_id INTO temp_hub_id
        FROM hub h
        WHERE h.hub_id = REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,1);
        dbms_output.put_line('O hub com o seguinte id ja existe na base de dados ' || REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,1));
        
    ELSE 
        
        SELECT l.localizacao_id INTO temp_localizacao_id
        FROM localizacao l
        WHERE l.latitude = REGEXP_SUBSTR (:OLD.input_string,'[^;]+',1,2) AND l.longitude = REGEXP_SUBSTR (:OLD.input_string,'[^;]+',1,3);
        
        UPDATE localizacao
        SET latitude = REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,2), longitude = REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,3)
        WHERE localizacao_id = temp_localizacao_id;
        
        UPDATE hub
        SET hub_id = REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,1) , localizacao_id = temp_localizacao_id
        WHERE hub_id = REGEXP_SUBSTR (:OLD.input_string,'[^;]+',1,1);
     
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_insere_hub(REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,1),
                         REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,2),
                         REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,3),
                         REGEXP_SUBSTR (:NEW.input_string,'[^;]+',1,4));
            
END t_actualiza_hubs;
/
    
create or replace PROCEDURE p_insere_hub(v_hub_id hub.hub_id%TYPE, v_latitude localizacao.latitude%TYPE,
                                          v_longitude localizacao.longitude%TYPE, v_tipo_hub tipo_hub.designacao%TYPE)  
IS

    temp_localizacao_id             localizacao.localizacao_id%TYPE;
    temp                            localizacao.localizacao_id%TYPE;
    temp_tipo_hub_id                tipo_hub.tipo_hub_id%TYPE;

BEGIN 

    IF SUBSTR(v_tipo_hub,1,1) NOT LIKE 'C%' THEN
       
      SELECT l.localizacao_id INTO temp_localizacao_id
      FROM localizacao l
      WHERE l.latitude = v_latitude AND l.longitude = v_longitude;
                                    
      SELECT th.tipo_hub_id INTO temp_tipo_hub_id
      FROM tipo_hub th 
      WHERE th.designacao LIKE SUBSTR(v_tipo_hub,1,1);
                                                       
      INSERT INTO hub(hub_id,tipo_hub_id,localizacao_id) VALUES (v_hub_id,temp_tipo_hub_id,temp_localizacao_id);
                
      dbms_output.put_line('O HUB com os seguintes dados foi adicionado:');
      dbms_output.put_line('hub_id= '||v_hub_id || ' latitude= '|| v_latitude || ' longitude= '|| v_longitude || ' tipo_hub= '||SUBSTR(v_tipo_hub,1,1) );
       
   END IF;
   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_localizacao_id IS NULL THEN
            
                INSERT INTO localizacao(latitude,longitude) VALUES (v_latitude,v_longitude);
                
                SELECT l.localizacao_id INTO temp
                FROM localizacao l
                WHERE l.latitude = v_latitude AND l.longitude = v_longitude;
                
                SELECT th.tipo_hub_id INTO temp_tipo_hub_id
                FROM tipo_hub th 
                WHERE th.designacao LIKE SUBSTR(v_tipo_hub,1,1);
                                                       
                INSERT INTO hub(hub_id,tipo_hub_id,localizacao_id) VALUES (v_hub_id,temp_tipo_hub_id,temp);
                
                dbms_output.put_line('O HUB com os seguintes dados foi adicionado:');
                dbms_output.put_line('hub_id= '||v_hub_id || ' latitude= '|| v_latitude || ' longitude= '|| v_longitude || ' tipo_hub= '||SUBSTR(v_tipo_hub,1,1) );
                
            END IF;
        END;
                 
END p_insere_hub;
/

SAVEPOINT us215_inserir_hubs;


---------------INSERTING---------------'
INSERT INTO input_hub(input_string) VALUES('CT1;40.6389;-8.6553;C1');
INSERT INTO input_hub(input_string) VALUES('CT2;38.0333;-7.8833;C2');
INSERT INTO input_hub(input_string) VALUES('CT14;38.5243;-8.8926;E1');
INSERT INTO input_hub(input_string) VALUES('CT11;39.3167;-7.4167;E2');
INSERT INTO input_hub(input_string) VALUES('CT10;39.7444;-8.8072;P3');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*O HUB com os seguintes dados foi adicionado:
hub_id= CT14 latitude= 38.5243 longitude= -8.8926 tipo_hub= E
O HUB com os seguintes dados foi adicionado:
hub_id= CT11 latitude= 39.3167 longitude= -7.4167 tipo_hub= E
O HUB com os seguintes dados foi adicionado:
hub_id= CT10 latitude= 39.7444 longitude= -8.8072 tipo_hub= P*/

SELECT * FROM localizacao;
SELECT * FROM hub;
SELECT * FROM input_hub;

---------------UPDATING---------------
UPDATE input_hub SET input_string = 'CT9000;0;111;E1' WHERE input_string = 'CT14;38.5243;-8.8926;E1';
SELECT * FROM localizacao;
SELECT * FROM hub;
SELECT * FROM input_hub;
UPDATE input_hub SET input_string = 'CT14;38.5243;-8.8926;E1' WHERE input_string = 'CT9000;0;111;E1';


INSERT INTO input_hub(input_string) VALUES ('CT14;38.5243;-8.8926;E1');
----------------TENTAR INSERIR REPETIDOS--------------------
---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
O hub com o seguinte id ja existe na base de dados CT14
*/

---------------DELITING---------------

SELECT * FROM input_hub;

DELETE FROM input_hub ih WHERE ih.input_string = 'CT14;38.5243;-8.8926;E1';
DELETE FROM input_hub ih WHERE ih.input_string = 'CT11;39.3167;-7.4167;E2';
DELETE FROM input_hub ih WHERE ih.input_string = 'CT10;39.7444;-8.8072;P3';

SELECT * FROM localizacao;
SELECT * FROM hub;
SELECT * FROM input_hub;


ROLLBACK TO us215_inserir_hubs;


DROP TRIGGER t_actualiza_hubs;
DROP TABLE input_hub CASCADE CONSTRAINTS PURGE ;


-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 2------------------------------------
-----------------------------------------------------------------------------------------------


create or replace PROCEDURE p_atribui_ou_altera_hub_cliente(v_cliente_codigo_interno cliente.codigo_interno%TYPE, v_hub_id hub.hub_id%TYPE) 
IS
    
    
    temp_cliente_codigo_interno            cliente.codigo_interno%TYPE;
    temp_hub_id                            hub.hub_id%TYPE; 
    

BEGIN 

    SELECT c.codigo_interno INTO temp_cliente_codigo_interno
    FROM cliente c
        WHERE c.codigo_interno = v_cliente_codigo_interno;  
         
    SELECT h.hub_id INTO temp_hub_id
    FROM hub h
        WHERE h.hub_id = v_hub_id;
        
    UPDATE cliente
    SET hub_por_defeito_id = temp_hub_id 
    WHERE codigo_interno = v_cliente_codigo_interno;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_cliente_codigo_interno IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o cliente com o codigo interno especificado');
            END IF;
            IF temp_hub_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o hub com o id especificado');
            END IF;
        END;
        
END p_atribui_ou_altera_hub_cliente;
/


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
CODIGO_INTERNO NOME                                     EMAIL                                    NUMERO_FISCAL    PLAFOND NUMERO_INCIDENTES DATA_ULTI NUMERO_ENCOMENDAS_ULTIMO_ANO VALOR_TOTAL_ENCOMENDAS_ULTIMO_ANO TIPO_CLIENTE HUB_POR_DE LOCALIZACAO_MORADA_ID
-------------- ---------------------------------------- ---------------------------------------- ------------- ---------- ----------------- --------- ---------------------------- --------------------------------- ------------ ---------- ---------------------
       1210957 joao                                     1210957@isep.ipp.pt                          231432459     100000                 1 15-MAR-22                            1                             60000            3 CT501                          6
*/
CALL  p_atribui_ou_altera_hub_cliente(1210957,'CT501');

SELECT * FROM cliente c WHERE c.codigo_interno = 1210957;


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o cliente com o codigo interno especificado
*/
CALL  p_atribui_ou_altera_hub_cliente(121097,'CT501');


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe o hub com o id especificado
*/
CALL  p_atribui_ou_altera_hub_cliente(1210957,'CT30000');


-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 3------------------------------------
-----------------------------------------------------------------------------------------------

create or replace PROCEDURE p_nota_encomenda(v_cliente_codigo_interno cliente.codigo_interno%TYPE,v_gestor_agricola_id gestor_agricola.gestor_agricola_id%TYPE,
                                            v_data_estimada_entrega encomenda.data_estimada_entrega%TYPE, v_valor_encomenda encomenda.valor_encomenda%TYPE,
                                            v_data_limite_pagamento encomenda.data_limite_pagamento%TYPE, v_endereco_entrega encomenda.endereco_entrega%TYPE,
                                            v_hub_id hub.hub_id%TYPE) 
IS
        
    temp_cliente_codigo_interno            cliente.codigo_interno%TYPE;
    temp_cliente_hub_por_defeito_id        cliente.hub_por_defeito_id%TYPE;
    temp_gestor_agricola                   gestor_agricola.gestor_agricola_id%TYPE;
    temp_hub_id                            hub.hub_id%TYPE; 
    
    
    
    EX_ERRO_INSERCAO_DATA_ENTREGA                   EXCEPTION;
    EX_ERRO_INSERCAO_DATA_LIMITE_PAGAMENTO          EXCEPTION;
    
BEGIN 

    SELECT c.codigo_interno INTO temp_cliente_codigo_interno
    FROM cliente c
        WHERE c.codigo_interno = v_cliente_codigo_interno;
        
   SELECT c.hub_por_defeito_id INTO temp_cliente_hub_por_defeito_id
    FROM cliente c
        WHERE c.codigo_interno = v_cliente_codigo_interno;     
    
    SELECT ga.gestor_agricola_id INTO temp_gestor_agricola
    FROM gestor_agricola ga
        WHERE ga.gestor_agricola_id = v_gestor_agricola_id;        
    
    IF v_data_estimada_entrega <  CURRENT_TIMESTAMP THEN
        RAISE EX_ERRO_INSERCAO_DATA_ENTREGA;
    END IF;
    
    IF v_data_limite_pagamento <  CURRENT_TIMESTAMP THEN
        RAISE EX_ERRO_INSERCAO_DATA_LIMITE_PAGAMENTO;
    END IF;
           
        
    IF v_endereco_entrega IS NULL THEN
        IF v_hub_id IS NULL THEN
            INSERT INTO encomenda(cliente_codigo_interno,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,
                                    data_registo,data_entrega,data_pagamento,hub_id,tipo_estado_encomenda)
            VALUES
            (v_cliente_codigo_interno,v_gestor_agricola_id,v_data_estimada_entrega,v_valor_encomenda,v_data_limite_pagamento,NULL,
            CURRENT_TIMESTAMP,NULL,NULL,temp_cliente_hub_por_defeito_id,1);          
        ELSE
        
            SELECT h.hub_id INTO temp_hub_id
            FROM hub h
                WHERE h.hub_id = v_hub_id;
        
            INSERT INTO encomenda(cliente_codigo_interno,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,
            data_registo,data_entrega,data_pagamento,hub_id,tipo_estado_encomenda)
            VALUES
            (v_cliente_codigo_interno,v_gestor_agricola_id,v_data_estimada_entrega,v_valor_encomenda,v_data_limite_pagamento,NULL,
            CURRENT_TIMESTAMP,NULL,NULL,v_hub_id,1);            
        END IF;
        
    ELSE        
        INSERT INTO encomenda(cliente_codigo_interno,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,
        data_registo,data_entrega,data_pagamento,hub_id,tipo_estado_encomenda)
        VALUES
        (v_cliente_codigo_interno,v_gestor_agricola_id,v_data_estimada_entrega,v_valor_encomenda,v_data_limite_pagamento,v_endereco_entrega,
        CURRENT_TIMESTAMP,NULL,NULL,NULL,1);          
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_cliente_codigo_interno IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o cliente com o codigo interno especificado');
            END IF;
            IF temp_cliente_hub_por_defeito_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O cliente nao possui um hub por defeito');
            END IF;
            IF temp_gestor_agricola IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o gestor agricola especificado');
            END IF;
            IF temp_hub_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o hub com o id especificado especificado');
            END IF;
        END;
        WHEN EX_ERRO_INSERCAO_DATA_ENTREGA THEN
            RAISE_APPLICATION_ERROR(-20011,'A data de entrega nao pode ser inferior ao tempo em que e registada a encomenda');
        WHEN EX_ERRO_INSERCAO_DATA_LIMITE_PAGAMENTO THEN
            RAISE_APPLICATION_ERROR(-20011,'A data de pagamento nao pode ser inferior ao tempo em que e registada a encomenda');
        
END p_nota_encomenda;
/


SAVEPOINT us215_p_nota_encomenda;

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
ENCOMENDA_ID CLIENTE_CODIGO_INTERNO GESTOR_AGRICOLA_ID DATA_ESTI VALOR_ENCOMENDA DATA_LIMI ENDERECO_ENTREGA                         DATA_REGI DATA_ENTR DATA_PAGA HUB_ID     TIPO_ESTADO_ENCOMENDA
------------ ---------------------- ------------------ --------- --------------- --------- ---------------------------------------- --------- --------- --------- ---------- ---------------------
           1                1210957                  1 15-FEB-22           60000 15-MAR-22                                          10-FEB-22 16-FEB-22 20-MAR-22 CT501                          3
           2                1181478                  1 15-FEB-22            6000 15-MAR-22                                          10-FEB-22 17-FEB-22 10-MAR-22 CT502                          3
           3                1211155                  1 15-FEB-22           12000 15-MAR-22                                          10-FEB-22 18-FEB-22 15-FEB-22 CT501                          3
           4                1211155                  1 15-FEB-23           11000 15-MAR-23                                          03-JAN-23                     CT501                          1
*/
CALL p_nota_encomenda(1211155,1,TO_DATE('15/02/2023 10:00','DD/MM/YYYY HH24:MI'),11000,
                        TO_DATE('15/03/2023 10:00','DD/MM/YYYY HH24:MI'),NULL,'CT501');
                        
SELECT * FROM encomenda;

ROLLBACK TO us215_p_nota_encomenda;
