---------------------------
----------[US205]----------
---------------------------

-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 1 e 2--------------------------------
-----------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;

create or replace PROCEDURE p_cria_cliente(v_codigo_interno utilizador.codigo_interno%TYPE, v_nome utilizador.nome%TYPE, v_numero_fiscal utilizador.numero_fiscal%TYPE,
                                            v_email utilizador.email%TYPE, v_morada_correspondencia utilizador.morada_correspondencia%TYPE,
                                            v_plafond utilizador.plafond%TYPE,v_numero_incidentes utilizador.numero_incidentes%TYPE,
                                            v_data_ultimo_incidente utilizador.data_ultimo_incidente%TYPE,v_numero_encomendas_ultimo_ano utilizador.numero_encomendas_ultimo_ano%TYPE,
                                            v_valor_total_encomendas_ultimo_ano  utilizador.numero_encomendas_ultimo_ano%TYPE,
                                            v_codigo_postal_id codigo_postal.codigo_postal_id%TYPE, v_tipo_utilizador_id tipo_utilizador.tipo_utilizador_id%TYPE,
                                            v_tipo_cliente_id utilizador.tipo_cliente%TYPE) 
IS

    temp_codigo_postal                       codigo_postal.codigo_postal_id%TYPE;
    temp_tipo_utilizador_cliente             tipo_utilizador.designacao%TYPE;
    temp_cliente_id                          utilizador.utilizador_id%TYPE;
    
    l_cliente_id                             utilizador.utilizador_id%TYPE;
    l_codigo_interno                         utilizador.codigo_interno%TYPE;
    l_nome                                   utilizador.nome%TYPE;
    l_numero_fiscal                          utilizador.numero_fiscal%TYPE;
    l_email                                  utilizador.email%TYPE;
    l_morada_correspondencia                 utilizador.morada_correspondencia%TYPE;
    l_plafond                                utilizador.plafond%TYPE;
    l_numero_incidentes                      utilizador.numero_incidentes%TYPE;
    l_data_ultimo_incidente                  utilizador.data_ultimo_incidente%TYPE;
    l_numero_encomendas_ultimo_ano           utilizador.numero_encomendas_ultimo_ano%TYPE;
    l_valor_total_encomendas_ultimo_ano      utilizador.valor_total_encomendas_ultimo_ano%TYPE;
    l_codigo_postal_id                       codigo_postal.codigo_postal_id%TYPE;
    l_tipo_utilizador_id                     tipo_utilizador.tipo_utilizador_id%TYPE;
    l_tipo_cliente                           tipo_cliente.tipo_cliente_id%TYPE;
    
    
    CURSOR c_utilizadores   IS 
    SELECT utilizador_id , codigo_interno, nome, numero_fiscal, email, plafond, numero_incidentes, data_ultimo_incidente,
           numero_encomendas_ultimo_ano, valor_total_encomendas_ultimo_ano, codigo_postal_id, tipo_utilizador_id, tipo_cliente
    FROM utilizador;
    
    EX_ERRO_FALHA_ATRIBUTOS_OBRIGATORIOS        EXCEPTION;
    EX_ERRO_CODIGO_INTERNO                      EXCEPTION;
    EX_ERRO_NUMERO_FISCAL                       EXCEPTION;
    EX_ERRO_EMAIL                               EXCEPTION;

BEGIN 

    SELECT cp.codigo_postal_id INTO temp_codigo_postal
    FROM codigo_postal cp
        WHERE cp.codigo_postal_id = v_codigo_postal_id;
        
    SELECT tu.designacao INTO temp_tipo_utilizador_cliente
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_tipo_utilizador_id;
 
    IF  v_codigo_interno IS NULL OR v_nome IS NULL OR v_numero_fiscal IS NULL OR v_email IS NULL OR v_morada_correspondencia IS NULL OR v_plafond IS NULL THEN 
        RAISE EX_ERRO_FALHA_ATRIBUTOS_OBRIGATORIOS;
    END IF;
    
    OPEN c_utilizadores;
        LOOP
            FETCH c_utilizadores INTO l_cliente_id , l_codigo_interno, l_nome, l_numero_fiscal, l_email, l_plafond, l_numero_incidentes, l_data_ultimo_incidente,
                                    l_numero_encomendas_ultimo_ano, l_valor_total_encomendas_ultimo_ano, l_codigo_postal_id, l_tipo_utilizador_id, l_tipo_cliente;
            EXIT WHEN c_utilizadores%NOTFOUND; 
            
            IF l_codigo_interno = v_codigo_interno THEN
                RAISE EX_ERRO_CODIGO_INTERNO;
            END IF;
            
            IF  l_numero_fiscal = v_numero_fiscal THEN
                RAISE EX_ERRO_NUMERO_FISCAL;
            END IF;
            
            IF  l_email = v_email THEN
                RAISE EX_ERRO_EMAIL;
            END IF;
 
        END LOOP;
    CLOSE c_utilizadores;
    
    INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
                numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
                (v_codigo_interno,v_nome,v_numero_fiscal,v_email,v_morada_correspondencia,v_plafond,v_numero_incidentes,v_data_ultimo_incidente,
                 v_numero_encomendas_ultimo_ano,v_valor_total_encomendas_ultimo_ano,v_codigo_postal_id,v_tipo_utilizador_id,v_tipo_cliente_id);
            
    SELECT MAX(utilizador_id) INTO temp_cliente_id
        FROM utilizador;
        
    DBMS_OUTPUT.PUT_LINE('cliente_id= '|| temp_cliente_id );   
            
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_codigo_postal IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe este codigo postal');
            END IF;
            
            IF temp_tipo_utilizador_cliente IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O tipo de utilizador especificado nao existe');
            END IF;
        END;
        WHEN EX_ERRO_FALHA_ATRIBUTOS_OBRIGATORIOS THEN
            RAISE_APPLICATION_ERROR(-20011,'Nenhum atributo dos seguintes pode ser NULL quando especificamos clientes, codigo_interno
                                            nome, numero_fiscal , email, morada_correspondencia, plafond');
        WHEN EX_ERRO_CODIGO_INTERNO THEN 
            RAISE_APPLICATION_ERROR(-20011,'Ja existe utilizador com este codigo interno');
        WHEN EX_ERRO_NUMERO_FISCAL THEN 
            RAISE_APPLICATION_ERROR(-20011,'Ja existe utilizador com este numero fiscal');
        WHEN EX_ERRO_EMAIL THEN 
            RAISE_APPLICATION_ERROR(-20011,'Ja existe utilizador com este email');
 
    END p_cria_cliente;
    /
    

    
SAVEPOINT us205_cria_cliente;


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
cliente_id= 9
*/
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('3000');
CALL p_cria_cliente(123450,'napoles',200,'napoelesisep@isep.ipp.pt','rua correspondencia ISEP',1000,0,NULL,0,0,'3000',1,NULL);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nao existe este codigo postal
*/
CALL p_cria_cliente(123450,'napoles',200,'napoelesisep@isep.ipp.pt','rua correspondencia ISEP',1000,0,NULL,0,0,NULL,1,NULL);


---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: O tipo de utilizador especificado nao existe
*/
CALL p_cria_cliente(123450,'napoles',200,'napoelesisep@isep.ipp.pt','rua correspondencia ISEP',1000,0,NULL,0,0,'3000',13,NULL);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Nenhum atributo dos seguintes pode ser NULL quando especificamos clientes, codigo_interno
                                            nome, numero_fiscal , email, morada_correspondencia, plafond
*/
CALL p_cria_cliente(123450,NULL,200,'napoelesisep@isep.ipp.pt','rua correspondencia ISEP',1000,0,NULL,0,0,'3000',1,NULL);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Ja existe utilizador com este codigo interno
*/
CALL p_cria_cliente(123450,'napoles',200,'napoelesisep@isep.ipp.pt','rua correspondencia ISEP',1000,0,NULL,0,0,'3000',1,NULL);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Ja existe utilizador com este numero fiscal
*/
CALL p_cria_cliente(123451,'napoles',200,'napoelesisep@isep.ipp.pt','rua correspondencia ISEP',1000,0,NULL,0,0,'3000',1,NULL);

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
Error report -
ORA-20011: Ja existe utilizador com este email
*/
CALL p_cria_cliente(123452,'napoles',201,'napoelesisep@isep.ipp.pt','rua correspondencia ISEP',1000,0,NULL,0,0,'3000',1,NULL);


ROLLBACK TO us205_cria_cliente;


-------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 3--------------------------------
-------------------------------------------------------------------------------------------

create or replace PROCEDURE actualiza_clientes_info
IS


    
    l_cliente_id                             utilizador.utilizador_id%TYPE;
    l_codigo_interno                         utilizador.codigo_interno%TYPE;
    l_nome                                   utilizador.nome%TYPE;
    l_numero_fiscal                          utilizador.numero_fiscal%TYPE;
    l_email                                  utilizador.email%TYPE;
    l_morada_correspondencia                 utilizador.morada_correspondencia%TYPE;
    l_plafond                                utilizador.plafond%TYPE;
    l_numero_incidentes                      utilizador.numero_incidentes%TYPE;
    l_data_ultimo_incidente                  utilizador.data_ultimo_incidente%TYPE;
    l_numero_encomendas_ultimo_ano           utilizador.numero_encomendas_ultimo_ano%TYPE;
    l_valor_total_encomendas_ultimo_ano      utilizador.valor_total_encomendas_ultimo_ano%TYPE;
    l_codigo_postal_id                       codigo_postal.codigo_postal_id%TYPE;
    l_tipo_utilizador_id                     tipo_utilizador.tipo_utilizador_id%TYPE;
    l_tipo_cliente                           tipo_cliente.tipo_cliente_id%TYPE;
    
    l_ce_cliente_id                        utilizador.utilizador_id%TYPE;
    l_ce_gestor_agricola_id                utilizador.utilizador_id%TYPE;
    l_ce_data_estimada_entrega             encomenda.data_estimada_entrega%TYPE;
    l_ce_valor_encomenda                   encomenda.valor_encomenda%TYPE;
    l_ce_data_limite_pagamento             encomenda.data_limite_pagamento%TYPE;
    l_ce_endereco_entrega                  encomenda.endereco_entrega%TYPE;
    l_ce_hub_id                            hub.hub_id%TYPE;
    
    CURSOR c_utilizadores   IS 
        SELECT utilizador_id , codigo_interno, nome, numero_fiscal, email, plafond, numero_incidentes, data_ultimo_incidente,
           numero_encomendas_ultimo_ano, valor_total_encomendas_ultimo_ano, codigo_postal_id, tipo_utilizador_id, tipo_cliente
        FROM utilizador;
    
   CURSOR ce_encomendas   IS 
        SELECT e.cliente_id, e.gestor_agricola_id, e.data_estimada_entrega, e.valor_encomenda, e.data_limite_pagamento, e.endereco_entrega, e.hub_id 
        FROM encomenda e
         INNER JOIN registo_encomenda re
            ON e.cliente_id = re.cliente_id AND e.gestor_agricola_id = re.gestor_agricola_id AND e.data_estimada_entrega = re.data_estimada_entrega
         WHERE re.estado_encomenda_id = 1 AND re.data_registo_entrega_pagamento >  TRUNC(ADD_MONTHS(SYSDATE,-12));    

BEGIN 
    

    DBMS_OUTPUT.PUT_LINE('---------INFORMACAO ANTES DE ATUALIZAR O UTILIZADOR---------');
    OPEN c_utilizadores;
    LOOP
    FETCH c_utilizadores INTO l_cliente_id , l_codigo_interno, l_nome, l_numero_fiscal, l_email, l_plafond, l_numero_incidentes, l_data_ultimo_incidente,
                              l_numero_encomendas_ultimo_ano, l_valor_total_encomendas_ultimo_ano, l_codigo_postal_id, l_tipo_utilizador_id, l_tipo_cliente;
    EXIT WHEN c_utilizadores%NOTFOUND;
    
        DBMS_OUTPUT.PUT_LINE('cliente_id= '|| l_cliente_id || ' nome= '|| l_nome || ' numero_encomendas_ultimo_ano= '|| l_numero_encomendas_ultimo_ano 
                                    || ' valor_total_encomendas_ultimo_ano= ' || l_valor_total_encomendas_ultimo_ano);
            
        OPEN ce_encomendas;
        LOOP
        FETCH ce_encomendas INTO l_ce_cliente_id , l_ce_gestor_agricola_id, l_ce_data_estimada_entrega, l_ce_valor_encomenda, l_ce_data_limite_pagamento,
                                 l_ce_endereco_entrega, l_ce_hub_id ;
        EXIT WHEN ce_encomendas%NOTFOUND; 
            
            IF(l_cliente_id = l_ce_cliente_id) THEN
                UPDATE utilizador SET valor_total_encomendas_ultimo_ano = valor_total_encomendas_ultimo_ano + l_ce_valor_encomenda,
                                      numero_encomendas_ultimo_ano = numero_encomendas_ultimo_ano + 1
                WHERE utilizador_id = l_cliente_id;
            END IF;    
                       
        END LOOP;
        CLOSE ce_encomendas;
 
    END LOOP;
    CLOSE c_utilizadores;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('---------INFORMACAO APOS ATUALIZAR O UTILIZADOR---------');
    
    OPEN c_utilizadores;
    LOOP
        FETCH c_utilizadores INTO l_cliente_id , l_codigo_interno, l_nome, l_numero_fiscal, l_email, l_plafond, l_numero_incidentes, l_data_ultimo_incidente,
                              l_numero_encomendas_ultimo_ano, l_valor_total_encomendas_ultimo_ano, l_codigo_postal_id, l_tipo_utilizador_id, l_tipo_cliente;
        EXIT WHEN c_utilizadores%NOTFOUND;
    
        DBMS_OUTPUT.PUT_LINE('cliente_id= '|| l_cliente_id || ' nome= '|| l_nome || ' numero_encomendas_ultimo_ano= '|| l_numero_encomendas_ultimo_ano 
                                    || ' valor_total_encomendas_ultimo_ano= ' || l_valor_total_encomendas_ultimo_ano);
    
    END LOOP;
    CLOSE c_utilizadores;
    
    END actualiza_clientes_info;
    /
    

    
SAVEPOINT us205_actualiza_clientes_info;

INSERT INTO codigo_postal(codigo_postal_id) VALUES ('3100');
INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (1234560,'ruben-US205-CA-3',1112,'rubenx@isep.ipp.pt','rua joao ISEP',100000,0,NULL,0,0,'3100',1,1);
            
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(10,1,TO_DATE('10/05/2022 10:00','DD/MM/YYYY HH24:MI'),10000,TO_DATE('15/05/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(10,1,TO_DATE('10/05/2022 10:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('8/05/2022 16:00','DD/MM/YYYY HH24:MI'));
            
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(10,1,TO_DATE('11/05/2022 10:00','DD/MM/YYYY HH24:MI'),9000,TO_DATE('15/05/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(10,1,TO_DATE('11/05/2022 10:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('8/05/2022 16:00','DD/MM/YYYY HH24:MI'));
            
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(10,1,TO_DATE('12/05/2022 10:00','DD/MM/YYYY HH24:MI'),11000,TO_DATE('15/05/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(10,1,TO_DATE('12/05/2022 10:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('8/05/2022 16:00','DD/MM/YYYY HH24:MI'));
 
           
CALL actualiza_clientes_info();

ROLLBACK TO us205_actualiza_clientes_info;



-------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 4--------------------------------
-------------------------------------------------------------------------------------------


CREATE VIEW clientes_informacao AS
    SELECT e.cliente_id AS cliente, re.data_estimada_entrega AS data_registo_entrega_pagamento , ee.designacao AS designacao, COALESCE(TO_CHAR(u.data_ultimo_incidente,'YYYY-MM-DD'),'Sem incidentes a data') AS data_ultimo_incidente
    FROM utilizador u
        INNER JOIN tipo_utilizador tp 
            ON u.tipo_utilizador_id = tp.tipo_utilizador_id AND tp.tipo_utilizador_id = 1
        INNER JOIN tipo_cliente tc
            ON u.tipo_cliente = tc.tipo_cliente_id
        INNER JOIN encomenda e
            ON u.utilizador_id = e.cliente_id 
        INNER JOIN registo_encomenda re
            ON e.cliente_id = re.cliente_id AND e.gestor_agricola_id = re.gestor_agricola_id AND e.data_estimada_entrega = re.data_estimada_entrega
        INNER JOIN estado_encomenda ee
            ON re.estado_encomenda_id = ee.estado_encomenda_id
        WHERE re.estado_encomenda_id = 3 
            AND re.data_registo_entrega_pagamento >  TRUNC(ADD_MONTHS(SYSDATE,-12))
        UNION
    SELECT e.cliente_id AS cliente, re.data_estimada_entrega AS drep , ee.designacao AS design, COALESCE(TO_CHAR(u.data_ultimo_incidente,'YYYY-MM-DD'),'Sem incidentes a data') AS incidentes
    FROM utilizador u
        INNER JOIN tipo_utilizador tp 
            ON u.tipo_utilizador_id = tp.tipo_utilizador_id AND tp.tipo_utilizador_id = 1
        INNER JOIN tipo_cliente tc
            ON u.tipo_cliente = tc.tipo_cliente_id
        INNER JOIN encomenda e
            ON u.utilizador_id = e.cliente_id 
        INNER JOIN registo_encomenda re
            ON e.cliente_id = re.cliente_id AND e.gestor_agricola_id = re.gestor_agricola_id AND e.data_estimada_entrega = re.data_estimada_entrega
        INNER JOIN estado_encomenda ee
            ON re.estado_encomenda_id = ee.estado_encomenda_id
        WHERE re.estado_encomenda_id =  2 
                    AND (re.cliente_id, re.gestor_agricola_id, re.data_estimada_entrega) NOT IN (SELECT re.cliente_id, re.gestor_agricola_id, re.data_estimada_entrega 
                                                                                            FROM registo_encomenda re
                                                                                            WHERE re.estado_encomenda_id = 3
                                                                                            AND re.data_registo_entrega_pagamento >  TRUNC(ADD_MONTHS(SYSDATE,-12)));


SAVEPOINT us205_view;

INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(4,1,TO_DATE('20/02/2022 16:00','DD/MM/YYYY HH24:MI'),60000,TO_DATE('16/03/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(4,1,TO_DATE('21/02/2022 16:00','DD/MM/YYYY HH24:MI'),30000,TO_DATE('17/03/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(4,1,TO_DATE('22/02/2022 16:00','DD/MM/YYYY HH24:MI'),20000,TO_DATE('18/03/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);

INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('20/02/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('13/02/2022 16:00','DD/MM/YYYY HH24:MI'));
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('20/02/2022 16:00','DD/MM/YYYY HH24:MI'),2,TO_DATE('16/02/2022 16:00','DD/MM/YYYY HH24:MI'));

INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('21/02/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('14/02/2022 16:00','DD/MM/YYYY HH24:MI'));            
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('21/02/2022 16:00','DD/MM/YYYY HH24:MI'),2,TO_DATE('16/02/2022 16:00','DD/MM/YYYY HH24:MI'));

INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('22/02/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'));            
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('22/02/2022 16:00','DD/MM/YYYY HH24:MI'),2,TO_DATE('16/02/2022 16:00','DD/MM/YYYY HH24:MI'));
 
                               
SELECT * FROM clientes_informacao;

ROLLBACK TO us205_view;
DROP VIEW clientes_informacao;


-------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 5--------------------------------
-------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION f_get_fator_risco_cliente(v_gestor_agricola_id utilizador.utilizador_id%TYPE,v_codigo_interno_cliente utilizador.codigo_interno%TYPE) RETURN VARCHAR
IS

    temp_utilizador_cliente_id                      utilizador.utilizador_id%TYPE;
    temp_utilizador_gestor_agricola_id              utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador_cliente                    tipo_utilizador.designacao%TYPE;
    temp_tipo_utilizador_gestor_agricola            tipo_utilizador.designacao%TYPE;
    temp_valor_incidentes_ultimos_12_meses          INTEGER;
    temp_data_ultimo_incidente                      DATE;
    
    temp_numero_encomendas_registas_nao_pagas_depois_ultimo_incidente   INTEGER;
    
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


    IF temp_tipo_utilizador_gestor_agricola LIKE 'gestor agricola'  THEN
        IF temp_tipo_utilizador_cliente LIKE 'cliente' THEN
        
            SELECT SUM(i.valor_incidente), MAX(i.data_incidente) INTO temp_valor_incidentes_ultimos_12_meses, temp_data_ultimo_incidente
            FROM incidente i
                WHERE i.cliente_id = temp_utilizador_cliente_id AND i.data_incidente > TRUNC(ADD_MONTHS(SYSDATE,-12));                
                
            SELECT COUNT(re.data_registo_entrega_pagamento) INTO temp_numero_encomendas_registas_nao_pagas_depois_ultimo_incidente
            FROM registo_encomenda re
                WHERE re.cliente_id = temp_utilizador_cliente_id 
                    AND re.data_registo_entrega_pagamento > temp_data_ultimo_incidente
                    AND re.estado_encomenda_id = 1
                    AND (re.cliente_id,re.gestor_agricola_id, re.data_estimada_entrega) NOT IN (SELECT ree.cliente_id,ree.gestor_agricola_id, ree.data_estimada_entrega 
                                                                                                FROM registo_encomenda ree
                                                                                                WHERE ree.estado_encomenda_id = 3
                                                                                                AND ree.data_registo_entrega_pagamento >  re.data_registo_entrega_pagamento);   
        ELSE
            RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_CLIENTE;
        END IF;
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR_GESTOR_AGRICOLA;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('temp_valor_incidentes_ultimos_12_meses= '|| temp_valor_incidentes_ultimos_12_meses );
    DBMS_OUTPUT.PUT_LINE('temp_data_ultimo_incidente= '|| temp_data_ultimo_incidente );    
    DBMS_OUTPUT.PUT_LINE('temp_numero_encomendas_registas_nao_pagas_depois_ultimo_incidente= '|| temp_numero_encomendas_registas_nao_pagas_depois_ultimo_incidente );
     
    RETURN (temp_valor_incidentes_ultimos_12_meses/temp_numero_encomendas_registas_nao_pagas_depois_ultimo_incidente);
    
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



END f_get_fator_risco_cliente;
/


SAVEPOINT us205_get_fator_risco_cliente;

--estado_encomenda_id=1 'registado'
--estado_encomenda_id=2 'entregue'
--estado_encomenda_id=3 'pago'

INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (12345670,'napoles-US205-CA-5',222333444,'12000@isep.ipp.pt','rua ruben ISEP',20000,0,NULL,0,0,'4410',1,NULL);

INSERT INTO incidente(valor_incidente,data_incidente,data_incidente_liquidado,cliente_id) 
            VALUES(6000,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),TO_DATE('16/03/2022 16:00','DD/MM/YYYY HH24:MI'),11);
INSERT INTO incidente(valor_incidente,data_incidente,data_incidente_liquidado,cliente_id) 
            VALUES(5000,TO_DATE('20/03/2022 16:01','DD/MM/YYYY HH24:MI'),TO_DATE('21/03/2022 16:00','DD/MM/YYYY HH24:MI'),11);
INSERT INTO incidente(valor_incidente,data_incidente,data_incidente_liquidado,cliente_id) 
            VALUES(1000,TO_DATE('25/03/2022 16:01','DD/MM/YYYY HH24:MI'),TO_DATE('26/03/2022 16:00','DD/MM/YYYY HH24:MI'),11);

INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(11,1,TO_DATE('01/06/2022 16:00','DD/MM/YYYY HH24:MI'),3000,TO_DATE('15/06/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('01/06/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('01/05/2022 16:00','DD/MM/YYYY HH24:MI'));
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('01/06/2022 16:00','DD/MM/YYYY HH24:MI'),2,TO_DATE('01/06/2022 16:00','DD/MM/YYYY HH24:MI'));
            
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(11,1,TO_DATE('02/06/2022 16:00','DD/MM/YYYY HH24:MI'),4000,TO_DATE('15/06/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('02/06/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('02/05/2022 16:00','DD/MM/YYYY HH24:MI'));
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('02/06/2022 16:00','DD/MM/YYYY HH24:MI'),2,TO_DATE('02/06/2022 16:00','DD/MM/YYYY HH24:MI'));
            
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(11,1,TO_DATE('03/06/2022 16:00','DD/MM/YYYY HH24:MI'),7000,TO_DATE('15/06/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('03/06/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('03/05/2022 16:00','DD/MM/YYYY HH24:MI'));

---ESTA ENCOMENDA TEM estado_encomenda_id=3 'pago'           
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(11,1,TO_DATE('04/06/2022 16:00','DD/MM/YYYY HH24:MI'),8000,TO_DATE('15/06/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('04/06/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('01/05/2022 16:00','DD/MM/YYYY HH24:MI'));
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('04/06/2022 16:00','DD/MM/YYYY HH24:MI'),3,TO_DATE('03/05/2022 16:00','DD/MM/YYYY HH24:MI'));
 
---SECCAO 1.1- ENCOMENDA REGISTADA ANTES DO ULTIMO INCIDENTE, MAS PAGA APOS ULTIMO INCIDENTE, NAO DEVE ENTRAR PARA O CALCULO            
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(11,1,TO_DATE('04/02/2022 16:00','DD/MM/YYYY HH24:MI'),8000,TO_DATE('15/06/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);            
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('04/02/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('01/02/2022 16:00','DD/MM/YYYY HH24:MI'));
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(11,1,TO_DATE('04/02/2022 16:00','DD/MM/YYYY HH24:MI'),3,TO_DATE('03/05/2022 16:00','DD/MM/YYYY HH24:MI'));
            
--3 incidentes no ultimo ano, 4 encomendas (4 registadas, 1 paga,
--2 entregues(so para testar que nao interfere)) feitas depois da data do ultimo incidente,(uma encomenda adicionada no fim so para teste mesmo seccao 1.1)
--valor total dos incidentes 6000+5000+1000 = 12000, racio 12000/3 = 4000
            
CALL DBMS_OUTPUT.PUT_LINE('Fator_de_risco= ' || f_get_fator_risco_cliente(1,12345670) ||'€');

ROLLBACK TO us205_get_fator_risco_cliente;