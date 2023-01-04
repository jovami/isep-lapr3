---------------------------
----------[US209]----------
---------------------------

-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 1 E 2--------------------------------
-----------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER t_registar_encomenda
AFTER INSERT ON encomenda
FOR EACH ROW

DECLARE
    
BEGIN

    INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(:NEW.cliente_id,:NEW.gestor_agricola_id,:NEW.data_estimada_entrega,1,CURRENT_TIMESTAMP); 
    
END t_registar_encomenda;
/


CREATE OR REPLACE TRIGGER t_verificar_plafond_cliente
BEFORE INSERT ON encomenda
FOR EACH ROW

DECLARE
    temp_utilizador             utilizador.utilizador_id%TYPE;
    temp_plafond_cliente        utilizador.plafond%TYPE;
    
    EX_ERRO_PLAFOND_INSUFICIENTE EXCEPTION;
    
BEGIN

    SELECT u.plafond INTO temp_plafond_cliente
        FROM utilizador u
        WHERE u.utilizador_id = :NEW.cliente_id;
        
    
    IF(temp_plafond_cliente < :NEW.valor_encomenda) THEN
       RAISE EX_ERRO_PLAFOND_INSUFICIENTE;
    END IF;

    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011,'Nao existe o cliente especificado');    
        WHEN EX_ERRO_PLAFOND_INSUFICIENTE THEN
            RAISE_APPLICATION_ERROR(-20006, 'O valor da encomenda e maior que o plafond do cliente, nao pode assim fazer a encomenda');
    
END t_verificar_plafond_cliente;
/

create or replace PROCEDURE p_registar_encomenda_cliente(v_codigo_interno_cliente utilizador.codigo_interno%TYPE, v_gestor_agricola_id utilizador.utilizador_id%TYPE,
                                                         v_data_estimada_entrega encomenda.data_estimada_entrega%TYPE, v_valor_encomenda encomenda.valor_encomenda%TYPE,
                                                         v_data_limite_pagamento encomenda.data_limite_pagamento%TYPE, v_endereco_entrega encomenda.endereco_entrega%TYPE) 
IS
    
    
    temp_utilizador_cliente_id                      utilizador.utilizador_id%TYPE;
    temp_utilizador_gestor_agricola_id              utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador_cliente                    tipo_utilizador.designacao%TYPE;
    temp_tipo_utilizador_gestor_agricola            tipo_utilizador.designacao%TYPE;   
    temp_morada_por_defeito                         utilizador.morada_correspondencia%TYPE;
    temp_hub_id                                     hub.hub_id%TYPE;
    temp_hub_morada                                 hub.morada%TYPE;    
 
    l_cliente_id                        utilizador.utilizador_id%TYPE;
    l_gestor_agricola_id                utilizador.utilizador_id%TYPE;
    l_data_estimada_entrega             encomenda.data_estimada_entrega%TYPE;
    l_valor_encomenda                   encomenda.valor_encomenda%TYPE;
    l_data_limite_pagamento             encomenda.data_limite_pagamento%TYPE;
    l_endereco_entrega                  encomenda.endereco_entrega%TYPE;
    l_hub_id                            hub.hub_id%TYPE;
    
    
    CURSOR c_encomendas   IS 
    SELECT cliente_id, gestor_agricola_id, data_estimada_entrega, valor_encomenda, data_limite_pagamento, endereco_entrega, hub_id FROM encomenda;
    
    EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA    EXCEPTION;
    EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE            EXCEPTION;
    EX_ERRO_INSERCAO_DATA_ENTREGA                   EXCEPTION;
    EX_ERRO_INSERCAO_DATA_LIMITE_PAGAMENTO          EXCEPTION;
    
BEGIN 

    SELECT u.utilizador_id INTO temp_utilizador_cliente_id
    FROM utilizador u
        WHERE u.codigo_interno = v_codigo_interno_cliente;
    
    SELECT tu.designacao INTO temp_tipo_utilizador_cliente
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = temp_utilizador_cliente_id;
    
    SELECT u.utilizador_id INTO temp_utilizador_gestor_agricola_id
    FROM utilizador u
        WHERE u.utilizador_id = v_gestor_agricola_id;
            
    SELECT tu.designacao INTO temp_tipo_utilizador_gestor_agricola
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_gestor_agricola_id;
    
    IF v_data_estimada_entrega <  CURRENT_TIMESTAMP THEN
        RAISE EX_ERRO_INSERCAO_DATA_ENTREGA;
    END IF;
        
    IF v_data_limite_pagamento <  CURRENT_TIMESTAMP THEN
        RAISE EX_ERRO_INSERCAO_DATA_LIMITE_PAGAMENTO;
    END IF;
                       
    IF temp_tipo_utilizador_gestor_agricola LIKE 'gestor agricola'  THEN
        IF temp_tipo_utilizador_cliente LIKE 'cliente' THEN
            IF v_endereco_entrega IS NULL THEN
            
                SELECT  u.morada_correspondencia INTO temp_morada_por_defeito
                FROM utilizador u
                    WHERE u.codigo_interno = v_codigo_interno_cliente;
                    
                INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
                    VALUES(temp_utilizador_cliente_id,temp_utilizador_gestor_agricola_id,v_data_estimada_entrega,
                            v_valor_encomenda,v_data_limite_pagamento,temp_morada_por_defeito,NULL);
            ELSE
            
                SELECT  h.hub_id, h.morada INTO temp_hub_id, temp_hub_morada
                FROM hub h
                    WHERE h.morada = v_endereco_entrega;
                
                 INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
                            VALUES(temp_utilizador_cliente_id,temp_utilizador_gestor_agricola_id,v_data_estimada_entrega,
                                    v_valor_encomenda,v_data_limite_pagamento,temp_hub_morada,temp_hub_id);
            END IF;
        
         ELSE
            RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE;
        END IF;
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA;
    END IF;
 
 
    OPEN c_encomendas;
        LOOP
            FETCH c_encomendas INTO l_cliente_id , l_gestor_agricola_id, l_data_estimada_entrega, l_valor_encomenda, l_data_limite_pagamento, l_endereco_entrega, l_hub_id ;
            EXIT WHEN c_encomendas%NOTFOUND; 
            
            DBMS_OUTPUT.PUT_LINE('cliente_id= '|| l_cliente_id || ' gestor_agricola_id= '|| l_gestor_agricola_id || ' data_estimada_entrega= '|| l_data_estimada_entrega 
                                        ||' valor_encomenda= ' || l_valor_encomenda || ' data_limite_pagamento= ' || l_data_limite_pagamento || ' endereco_entrega= '
                                        || l_endereco_entrega || ' hub_id= ' ||l_hub_id);             
        END LOOP;
    CLOSE c_encomendas;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_utilizador_cliente_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o cliente com o codigo interno especificado');
            END IF;
            
            IF temp_tipo_utilizador_cliente IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O tipo de utilizador especificado nao existe');
            END IF;
            
            IF temp_utilizador_gestor_agricola_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o gestor agricola com o id especificado');
            END IF;   
            
            IF temp_tipo_utilizador_gestor_agricola IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O tipo de utilizador especificado nao existe');
            END IF;
            
            IF temp_hub_id IS NULL AND temp_hub_morada IS NULL AND temp_morada_por_defeito IS NULL THEN
                INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
                            VALUES(temp_utilizador_cliente_id,temp_utilizador_gestor_agricola_id,v_data_estimada_entrega,
                                    v_valor_encomenda,v_data_limite_pagamento,v_endereco_entrega,NULL);
                                    
                OPEN c_encomendas;
                    LOOP
                        FETCH c_encomendas INTO l_cliente_id , l_gestor_agricola_id, l_data_estimada_entrega, l_valor_encomenda, l_data_limite_pagamento, l_endereco_entrega, l_hub_id ;
                        EXIT WHEN c_encomendas%NOTFOUND; 
            
                        DBMS_OUTPUT.PUT_LINE('cliente_id= '|| l_cliente_id || ' gestor_agricola_id= '|| l_gestor_agricola_id || ' data_estimada_entrega= '|| l_data_estimada_entrega 
                                        ||' valor_encomenda= ' || l_valor_encomenda || ' data_limite_pagamento= ' || l_data_limite_pagamento || ' endereco_entrega= '
                                        || l_endereco_entrega || ' hub_id= ' ||l_hub_id);             
                    END LOOP;
                CLOSE c_encomendas;
            END IF;
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um cliente');
        WHEN EX_ERRO_INSERCAO_DATA_ENTREGA THEN
            RAISE_APPLICATION_ERROR(-20011,'A data de entrega nao pode ser inferior ao tempo em que e registada a encomenda');
        WHEN EX_ERRO_INSERCAO_DATA_LIMITE_PAGAMENTO THEN
            RAISE_APPLICATION_ERROR(-20011,'A data de pagamento nao pode ser inferior ao tempo em que e registada a encomenda');
            
            
END p_registar_encomenda_cliente;
/


CREATE OR REPLACE TRIGGER t_registar_encomenda_produto
AFTER INSERT ON encomenda_produto
FOR EACH ROW

DECLARE

    temp_data_registo_encomenda     registo_encomenda.data_registo_entrega_pagamento%TYPE; 
    
BEGIN

    SELECT re.data_registo_entrega_pagamento INTO temp_data_registo_encomenda
    FROM registo_encomenda re
        WHERE re.cliente_id = :NEW.cliente_id 
            AND re.gestor_agricola_id = :NEW.gestor_agricola_id
            AND re.data_estimada_entrega = :NEW.data_estimada_entrega
            AND re.estado_encomenda_id = 1;

    UPDATE stock 
    SET stock_ton = stock_ton - :NEW.quantidade_ton
    WHERE produto_id = :NEW.produto_id AND caderno_campo_id = (SELECT cc.caderno_campo_id
                                                               FROM caderno_campo cc
                                                               WHERE cc.ano = EXTRACT(YEAR FROM temp_data_registo_encomenda));
 
END t_registar_encomenda_produto;
/

create or replace PROCEDURE p_registar_encomenda_produto(v_codigo_interno_cliente utilizador.codigo_interno%TYPE, v_gestor_agricola_id utilizador.utilizador_id%TYPE,
                                                         v_data_estimada_entrega encomenda.data_estimada_entrega%TYPE, v_designacao_p produto.designacao%TYPE,
                                                         v_quantidade_ton encomenda_produto.quantidade_ton%TYPE) 
IS
    
    
    temp_utilizador_cliente_id                      utilizador.utilizador_id%TYPE;
    temp_utilizador_gestor_agricola_id              utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador_cliente                    tipo_utilizador.designacao%TYPE;
    temp_tipo_utilizador_gestor_agricola            tipo_utilizador.designacao%TYPE;
    temp_produto_id                                 produto.produto_id%TYPE;
   
 
    l_cliente_id                        utilizador.utilizador_id%TYPE;
    l_gestor_agricola_id                utilizador.utilizador_id%TYPE;
    l_data_estimada_entrega             encomenda.data_estimada_entrega%TYPE;
    l_produto_id                        produto.produto_id%TYPE;
    l_quantidade_ton                    encomenda_produto.quantidade_ton%TYPE;
    
    
    CURSOR c_encomendas_produtos   IS 
    SELECT cliente_id, gestor_agricola_id, data_estimada_entrega, produto_id, quantidade_ton FROM encomenda_produto;
    
    EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA    EXCEPTION;
    EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE            EXCEPTION;

    
BEGIN 

    SELECT u.utilizador_id INTO temp_utilizador_cliente_id
    FROM utilizador u
        WHERE u.codigo_interno = v_codigo_interno_cliente;
    
    SELECT tu.designacao INTO temp_tipo_utilizador_cliente
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = temp_utilizador_cliente_id;
    
    SELECT u.utilizador_id INTO temp_utilizador_gestor_agricola_id
    FROM utilizador u
        WHERE u.utilizador_id = v_gestor_agricola_id;
            
    SELECT tu.designacao INTO temp_tipo_utilizador_gestor_agricola
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_gestor_agricola_id;
            
    SELECT p.produto_id INTO temp_produto_id
    FROM produto p
        WHERE p.designacao= v_designacao_p;
                       
    IF temp_tipo_utilizador_gestor_agricola LIKE 'gestor agricola'  THEN
        IF temp_tipo_utilizador_cliente LIKE 'cliente' THEN
        
            INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
                VALUES (temp_utilizador_cliente_id,temp_utilizador_gestor_agricola_id,v_data_estimada_entrega,temp_produto_id,v_quantidade_ton);
        
         ELSE
            RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE;
        END IF;
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA;
    END IF;
 
 
    OPEN c_encomendas_produtos;
        LOOP
            FETCH c_encomendas_produtos INTO l_cliente_id , l_gestor_agricola_id, l_data_estimada_entrega, l_produto_id, l_quantidade_ton ;
            EXIT WHEN c_encomendas_produtos%NOTFOUND; 
            
            DBMS_OUTPUT.PUT_LINE('cliente_id= '|| l_cliente_id || ' gestor_agricola_id= '|| l_gestor_agricola_id || ' data_estimada_entrega= '|| l_data_estimada_entrega 
                                        ||' produto_id= ' || l_produto_id || ' quantidade_ton= ' || l_quantidade_ton);  
        END LOOP;
    CLOSE c_encomendas_produtos;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_utilizador_cliente_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o cliente com o codigo interno especificado');
            END IF;
            
            IF temp_tipo_utilizador_cliente IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O tipo de utilizador especificado nao existe');
            END IF;
            
            IF temp_utilizador_gestor_agricola_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o gestor agricola com o id especificado');
            END IF;   
            
            IF temp_tipo_utilizador_gestor_agricola IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O tipo de utilizador especificado nao existe');
            END IF;
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um cliente');
            
END p_registar_encomenda_produto;
/


SAVEPOINT us209_registar_pedidos_cliente;


/*---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
...continua...
cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 01-MAR-23 valor_encomenda= 100 data_limite_pagamento= 01-APR-23 endereco_entrega= rua ruben ISEP hub_id=
*/
CALL p_registar_encomenda_cliente(1210954,1,TO_DATE('01/03/2023 16:00','DD/MM/YYYY HH24:MI'),100,TO_DATE('01/04/2023 16:00','DD/MM/YYYY HH24:MI'),NULL);

/*
...continua...
cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 01-MAR-23 valor_encomenda= 100 data_limite_pagamento= 01-APR-23 endereco_entrega= rua ruben ISEP hub_id= 
cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 02-MAR-23 valor_encomenda= 1000 data_limite_pagamento= 01-APR-23 endereco_entrega= Trindade hub_id= 1
*/
CALL p_registar_encomenda_cliente(1210954,1,TO_DATE('02/03/2023 16:00','DD/MM/YYYY HH24:MI'),1000,TO_DATE('01/04/2023 16:00','DD/MM/YYYY HH24:MI'),'Trindade');

/*
...continua...
cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 01-MAR-23 valor_encomenda= 100 data_limite_pagamento= 01-APR-23 endereco_entrega= rua ruben ISEP hub_id= 
cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 02-MAR-23 valor_encomenda= 1000 data_limite_pagamento= 01-APR-23 endereco_entrega= Trindade hub_id= 1
cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 03-MAR-23 valor_encomenda= 1000 data_limite_pagamento= 01-APR-23 endereco_entrega= morada aleatoria hub_id=
*/
CALL p_registar_encomenda_cliente(1210954,1,TO_DATE('03/03/2023 16:00','DD/MM/YYYY HH24:MI'),1000,TO_DATE('01/04/2023 16:00','DD/MM/YYYY HH24:MI'),'morada aleatoria');

/*
Error report -
ORA-20006: O valor da encomenda e maior que o plafond do cliente, nao pode assim fazer a encomenda
*/
CALL p_registar_encomenda_cliente(1210954,1,TO_DATE('03/03/2023 16:00','DD/MM/YYYY HH24:MI'),100000,TO_DATE('01/04/2023 16:00','DD/MM/YYYY HH24:MI'),'morada aleatoria');

/*
...continua...
cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 01-MAR-23 produto_id= 1 quantidade_ton= 20
*/
CALL p_registar_encomenda_produto(1210954,1,TO_DATE('01/03/2023 16:00','DD/MM/YYYY HH24:MI'),'rosas',20);


ROLLBACK TO us209_registar_pedidos_cliente;

DROP TRIGGER t_verificar_plafond_cliente;
DROP TRIGGER t_registar_encomenda;
DROP TRIGGER t_registar_encomenda_produto;


-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 3------------------------------------
-----------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER t_validar_pagamentos
BEFORE INSERT ON pagamento
FOR EACH ROW

DECLARE

    valor_encomenda      encomenda.valor_encomenda%TYPE;
    total_pagamentos     pagamento.valor_pagamento%TYPE;
    
    EX_ERRO_PAGAMENTO_SUPERIOR EXCEPTION;

BEGIN
    
    SELECT e.valor_encomenda INTO valor_encomenda
    FROM encomenda e 
    WHERE e.cliente_id = :NEW.cliente_id AND e.gestor_agricola_id = :NEW.gestor_agricola_id AND e.data_estimada_entrega = :NEW.data_estimada_entrega;
    
    SELECT SUM(p.valor_pagamento) INTO total_pagamentos
    FROM pagamento p 
    WHERE p.cliente_id = :NEW.cliente_id AND p.gestor_agricola_id = :NEW.gestor_agricola_id AND p.data_estimada_entrega = :NEW.data_estimada_entrega;


     IF (valor_encomenda = total_pagamentos + :NEW.valor_pagamento) THEN
        INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
                        VALUES(:NEW.cliente_id, :NEW.gestor_agricola_id, :NEW.data_estimada_entrega, 3, :NEW.data_pagamento);
     END IF;

     IF (valor_encomenda < total_pagamentos + :NEW.valor_pagamento) THEN
        RAISE EX_ERRO_PAGAMENTO_SUPERIOR;
     END IF;

    EXCEPTION
    WHEN EX_ERRO_PAGAMENTO_SUPERIOR THEN
            RAISE_APPLICATION_ERROR(-20006, 'O pagamento que quer efetuar supera o valor dos dividendos');

END t_validar_pagamentos;
/



create or replace PROCEDURE p_registar_pagamento_encomenda(v_valor_pagamento pagamento.valor_pagamento%TYPE, v_data_pagamento pagamento.data_pagamento%TYPE,
                                                           v_codigo_interno_cliente utilizador.codigo_interno%TYPE, v_gestor_agricola_id utilizador.utilizador_id%TYPE,
                                                           v_data_estimada_entrega encomenda.data_estimada_entrega%TYPE) 
IS
    
    
    temp_utilizador_cliente_id                      utilizador.utilizador_id%TYPE;
    temp_utilizador_gestor_agricola_id              utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador_cliente                    tipo_utilizador.designacao%TYPE;
    temp_tipo_utilizador_gestor_agricola            tipo_utilizador.designacao%TYPE; 
    
  
 
    l_pagamento_id                 pagamento.pagamento_id%TYPE;
    l_valor_pagamento              pagamento.valor_pagamento%TYPE;
    l_data_pagamento               pagamento.data_pagamento%TYPE;
    l_cliente_id                   utilizador.utilizador_id%TYPE;
    l_gestor_agricola_id           utilizador.utilizador_id%TYPE;
    l_data_estimada_entrega        encomenda.data_estimada_entrega%TYPE;
    
    valor_encomenda      encomenda.valor_encomenda%TYPE;
    total_pagamentos     pagamento.valor_pagamento%TYPE;
    
    CURSOR c_pagamentos   IS 
    SELECT pagamento_id, valor_pagamento, data_pagamento, cliente_id, gestor_agricola_id, data_estimada_entrega FROM pagamento;
    
    EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA    EXCEPTION;
    EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE            EXCEPTION;
    EX_ERRO_INSERCAO_DATA_PAGAMENTO                 EXCEPTION;
    
BEGIN 

    SELECT u.utilizador_id INTO temp_utilizador_cliente_id
    FROM utilizador u
        WHERE u.codigo_interno = v_codigo_interno_cliente;
    
    SELECT tu.designacao INTO temp_tipo_utilizador_cliente
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = temp_utilizador_cliente_id;
    
    SELECT u.utilizador_id INTO temp_utilizador_gestor_agricola_id
    FROM utilizador u
        WHERE u.utilizador_id = v_gestor_agricola_id;
            
    SELECT tu.designacao INTO temp_tipo_utilizador_gestor_agricola
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_gestor_agricola_id;
            
    IF v_data_pagamento <  CURRENT_TIMESTAMP THEN
        RAISE EX_ERRO_INSERCAO_DATA_PAGAMENTO;
    END IF;
                       
    IF temp_tipo_utilizador_gestor_agricola LIKE 'gestor agricola'  THEN
        IF temp_tipo_utilizador_cliente LIKE 'cliente' THEN
            
            INSERT INTO pagamento(valor_pagamento,data_pagamento,cliente_id,gestor_agricola_id,data_estimada_entrega) 
                VALUES(v_valor_pagamento,v_data_pagamento,temp_utilizador_cliente_id,temp_utilizador_gestor_agricola_id,v_data_estimada_entrega);
        ELSE
            RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE;
        END IF;
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA;
    END IF;
 
 
    OPEN c_pagamentos;
        LOOP
            FETCH c_pagamentos INTO l_pagamento_id , l_valor_pagamento, l_data_pagamento, l_cliente_id, l_gestor_agricola_id, l_data_estimada_entrega;
            EXIT WHEN c_pagamentos%NOTFOUND; 
            
            DBMS_OUTPUT.PUT_LINE('pagamento_id= '|| l_pagamento_id || ' valor_pagamento= '|| l_valor_pagamento || ' data_pagamento= '|| l_data_pagamento 
                                        ||' cliente_id= ' || l_cliente_id || ' gestor_agricola_id= ' || l_gestor_agricola_id || ' data_estimada_entrega= '
                                        || l_data_estimada_entrega );                                         
                                        
        END LOOP;
    CLOSE c_pagamentos;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_utilizador_cliente_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o cliente com o codigo interno especificado');
            END IF;
            
            IF temp_tipo_utilizador_cliente IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O tipo de utilizador especificado nao existe');
            END IF;
            
            IF temp_utilizador_gestor_agricola_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o gestor agricola com o id especificado');
            END IF;   
            
            IF temp_tipo_utilizador_gestor_agricola IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O tipo de utilizador especificado nao existe');
            END IF;
            
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um cliente');
        WHEN EX_ERRO_INSERCAO_DATA_PAGAMENTO THEN
            RAISE_APPLICATION_ERROR(-20011,'A data de pagamento nao pode ser inferior ao tempo atual');
      
    END p_registar_pagamento_encomenda;
    /



SAVEPOINT us209_registar_pagamento_encomenda;


INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(8,1,TO_DATE('01/03/2023 10:00','DD/MM/YYYY HH24:MI'),12000,TO_DATE('01/04/2023 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO pagamento(valor_pagamento,data_pagamento,cliente_id,gestor_agricola_id,data_estimada_entrega) 
                VALUES(1000,TO_DATE('1/03/2023 10:00','DD/MM/YYYY HH24:MI'),8,1,TO_DATE('01/03/2023 10:00','DD/MM/YYYY HH24:MI')); 

/*---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
pagamento_id= 1 valor_pagamento= 60000 data_pagamento= 20-MAR-22 cliente_id= 4 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22
pagamento_id= 2 valor_pagamento= 6000 data_pagamento= 10-MAR-22 cliente_id= 5 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22
pagamento_id= 3 valor_pagamento= 12000 data_pagamento= 10-MAR-22 cliente_id= 6 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22
pagamento_id= 4 valor_pagamento= 1000 data_pagamento= 01-MAR-23 cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 01-MAR-23
pagamento_id= 5 valor_pagamento= 11000 data_pagamento= 01-MAR-23 cliente_id= 8 gestor_agricola_id= 1 data_estimada_entrega= 01-MAR-23
*/
CALL p_registar_pagamento_encomenda(11000,TO_DATE('1/03/2023 10:05','DD/MM/YYYY HH24:MI'),1210954,1,TO_DATE('01/03/2023 10:00','DD/MM/YYYY HH24:MI'));


ROLLBACK TO us209_registar_pagamento_encomenda;

DROP TRIGGER t_validar_pagamentos;



-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 4------------------------------------
-----------------------------------------------------------------------------------------------
    
create or replace PROCEDURE p_listar_encomendas_por_estado(v_gestor_agricola_id utilizador.utilizador_id%TYPE,v_designacao_ee estado_encomenda.designacao%TYPE) 
IS
    
    
    temp_utilizador_gestor_agricola_id              utilizador.utilizador_id%TYPE;   
    temp_tipo_utilizador_gestor_agricola            tipo_utilizador.designacao%TYPE; 
    temp_estado_encomenda_id                        estado_encomenda.estado_encomenda_id%TYPE; 
    
    l_cliente_id                            utilizador.utilizador_id%TYPE;
    l_gestor_agricola_id                    utilizador.utilizador_id%TYPE;
    l_data_estimada_entrega                 encomenda.data_estimada_entrega%TYPE;
    l_estado_encomenda_id                   estado_encomenda.estado_encomenda_id%TYPE;
    l_data_registo_entrega_pagamento        registo_encomenda.data_registo_entrega_pagamento%TYPE;


    
    CURSOR c_registos_encomendas   IS 
    SELECT cliente_id, gestor_agricola_id, data_estimada_entrega, estado_encomenda_id, data_registo_entrega_pagamento FROM registo_encomenda;
    
    EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA    EXCEPTION;

    
BEGIN 
    
    SELECT u.utilizador_id INTO temp_utilizador_gestor_agricola_id
    FROM utilizador u
        WHERE u.utilizador_id = v_gestor_agricola_id;
            
    SELECT tu.designacao INTO temp_tipo_utilizador_gestor_agricola
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_gestor_agricola_id;
    
    SELECT ee.estado_encomenda_id INTO temp_estado_encomenda_id
    FROM estado_encomenda ee
        WHERE ee.designacao = v_designacao_ee;
            
                                  
    IF temp_tipo_utilizador_gestor_agricola LIKE 'gestor agricola'  THEN
        
        OPEN c_registos_encomendas;
            LOOP
            FETCH c_registos_encomendas INTO l_cliente_id , l_gestor_agricola_id, l_data_estimada_entrega, l_estado_encomenda_id, l_data_registo_entrega_pagamento;
            EXIT WHEN c_registos_encomendas%NOTFOUND;
            
            IF(l_estado_encomenda_id = temp_estado_encomenda_id) THEN
                
                DBMS_OUTPUT.PUT_LINE('cliente_id= '|| l_cliente_id || ' gestor_agricola_id= '|| l_gestor_agricola_id || ' data_estimada_entrega= '
                                || l_data_estimada_entrega ||' estado_encomenda_id= ' || l_estado_encomenda_id 
                                || ' data_registo_entrega_pagamento= ' || l_data_registo_entrega_pagamento);
            END IF;
                                        
            END LOOP;
        CLOSE c_registos_encomendas;    
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA;
    END IF;
 

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN            
            IF temp_utilizador_gestor_agricola_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o gestor agricola com o id especificado');
            END IF;   
            
            IF temp_tipo_utilizador_gestor_agricola IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O tipo de utilizador especificado nao existe');
            END IF;  
            
             IF temp_estado_encomenda_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe estados de encomenda com o tipo de estado especificado');
            END IF;            
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
      
    END p_listar_encomendas_por_estado;
    /
    
/*---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
cliente_id= 4 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 1 data_registo_entrega_pagamento= 10-FEB-22
cliente_id= 5 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 1 data_registo_entrega_pagamento= 10-FEB-22
cliente_id= 6 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 1 data_registo_entrega_pagamento= 10-FEB-22
*/
CALL p_listar_encomendas_por_estado(1,'registado');


/*
cliente_id= 4 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 2 data_registo_entrega_pagamento= 16-FEB-22
cliente_id= 5 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 2 data_registo_entrega_pagamento= 17-FEB-22
cliente_id= 6 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 2 data_registo_entrega_pagamento= 18-FEB-22
*/
CALL p_listar_encomendas_por_estado(1,'entregue');

/*
cliente_id= 4 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 3 data_registo_entrega_pagamento= 20-MAR-22
cliente_id= 5 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 3 data_registo_entrega_pagamento= 10-MAR-22
cliente_id= 6 gestor_agricola_id= 1 data_estimada_entrega= 15-FEB-22 estado_encomenda_id= 3 data_registo_entrega_pagamento= 10-MAR-22
*/
CALL p_listar_encomendas_por_estado(1,'pago');


/*
ORA-20011: Nao existe estados de encomenda com o tipo de estado especificado
*/
CALL p_listar_encomendas_por_estado(1,'lll');