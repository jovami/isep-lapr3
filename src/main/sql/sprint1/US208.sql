---------------------------
----------[US208]----------
---------------------------

-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 1------------------------------------
-----------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;

create or replace PROCEDURE p_configurar_fatores_producao(v_utilizador_id utilizador.utilizador_id%TYPE, v_nome_comercial fator_producao.nome_comercial%TYPE,
                                                            v_fornecedor fator_producao.fornecedor%TYPE, v_preco_por_kg fator_producao.preco_por_kg%TYPE,
                                                            v_designacao_f formulacao.designacao%TYPE, v_designacao_tfp tipo_fator_producao.designacao%TYPE ) 
IS
    
    temp_utilizador                     utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador                tipo_utilizador.designacao%TYPE;
    temp_formulacao_id                  formulacao.formulacao_id%TYPE;
    temp_tipo_fator_producao_id         tipo_fator_producao.tipo_fator_producao_id%TYPE;

    
    l_fator_producao_id                 fator_producao.fator_producao_id%TYPE;
    l_nome_comercial                    fator_producao.nome_comercial%TYPE;
    l_fornecedor                        fator_producao.fornecedor%TYPE;
    l_preco_por_kg                      fator_producao.preco_por_kg%TYPE;
    l_formulacao_id                     fator_producao.formulacao_id%TYPE;
    l_tipo_fator_producao_id            fator_producao.tipo_fator_producao_id%TYPE;    
    
    
    CURSOR c_fatores_producao   IS 
    SELECT fator_producao_id, nome_comercial, fornecedor, preco_por_kg, formulacao_id, tipo_fator_producao_id FROM fator_producao;
    
    EX_ERRO_TEMP_TIPO_UTILIZADOR EXCEPTION;
    
BEGIN 

    SELECT u.utilizador_id INTO temp_utilizador
    FROM utilizador u
        WHERE u.utilizador_id = v_utilizador_id;
    
    SELECT tu.designacao INTO temp_tipo_utilizador
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_utilizador_id;

    SELECT f.formulacao_id INTO temp_formulacao_id
    FROM formulacao f
        WHERE f.designacao = v_designacao_f;
        
    SELECT tfp.tipo_fator_producao_id INTO temp_tipo_fator_producao_id
    FROM tipo_fator_producao tfp
        WHERE tfp.designacao = v_designacao_tfp;
            
            
    IF temp_tipo_utilizador LIKE 'gestor agricola' THEN
        INSERT INTO fator_producao(nome_comercial,fornecedor,preco_por_kg,formulacao_id,tipo_fator_producao_id)
            VALUES(v_nome_comercial,v_fornecedor,v_preco_por_kg,temp_formulacao_id,temp_tipo_fator_producao_id);         
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;
 
 
    OPEN c_fatores_producao;
        LOOP
            FETCH c_fatores_producao INTO l_fator_producao_id , l_nome_comercial, l_fornecedor, l_preco_por_kg, l_formulacao_id, l_tipo_fator_producao_id ;
            EXIT WHEN c_fatores_producao%NOTFOUND;
                
                DBMS_OUTPUT.PUT_LINE('fator_producao_id= '|| l_fator_producao_id || ' nome_comercial= '|| l_nome_comercial || ' fornecedor= '|| l_fornecedor 
                                        ||' preco_por_kg= ' || l_preco_por_kg || ' formulacao_id= ' || l_formulacao_id || ' tipo_fator_producao_id= '
                                        || l_tipo_fator_producao_id);
               
        END LOOP;
    CLOSE c_fatores_producao;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_utilizador IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
            END IF;
            
            IF temp_formulacao_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe a formulacao especificada');
            END IF;
            
            IF temp_tipo_fator_producao_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o tipo de fator de producao especificado');
            END IF;          
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
            
    END p_configurar_fatores_producao;
    /
    
create or replace PROCEDURE p_adicionar_fator_producao_instalacao_agricola(v_utilizador_id utilizador.utilizador_id%TYPE, v_nome_comercial fator_producao.nome_comercial%TYPE,
                                                            v_quantidade_kg instalacao_agricola_fator_producao.quantidade_kg%TYPE ) 
IS
    
    temp_utilizador                     utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador                tipo_utilizador.designacao%TYPE;
    temp_fator_producao_id              fator_producao.fator_producao_id%TYPE;  
    temp_instalacao_agricola_id         instalacao_agricola.instalacao_agricola_id%TYPE;
    temp_instalacao_agricola_idx        instalacao_agricola.instalacao_agricola_id%TYPE;
    
    l_instalacao_agricola_id            instalacao_agricola_fator_producao.instalacao_agricola_id%TYPE;
    l_fator_producao_id                 instalacao_agricola_fator_producao.fator_producao_id%TYPE;
    l_quantidade_kg                     instalacao_agricola_fator_producao.quantidade_kg%TYPE;    
    
    
    CURSOR c_instalacao_agricola_fator_producao   IS 
    SELECT instalacao_agricola_id, fator_producao_id, quantidade_kg FROM instalacao_agricola_fator_producao;
    
    EX_ERRO_TEMP_TIPO_UTILIZADOR EXCEPTION;
    
BEGIN 

    SELECT u.utilizador_id INTO temp_utilizador
    FROM utilizador u
        WHERE u.utilizador_id = v_utilizador_id;
    
    SELECT tu.designacao INTO temp_tipo_utilizador
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_utilizador_id;

    SELECT f.fator_producao_id INTO temp_fator_producao_id
    FROM fator_producao f
        WHERE f.nome_comercial = v_nome_comercial; 
    
              
    IF temp_tipo_utilizador LIKE 'gestor agricola' THEN
    
        SELECT ia.instalacao_agricola_id INTO temp_instalacao_agricola_id     
            FROM (SELECT ux.utilizador_id FROM utilizador ux WHERE ux.utilizador_id = v_utilizador_id) u
            INNER JOIN gestor_agricola ga
                ON u.utilizador_id = ga.gestor_agricola_id
                    AND ga.data_inicio_contrato =(SELECT MAX(data_inicio_contrato) FROM gestor_agricola gaa WHERE u.utilizador_id = gaa.gestor_agricola_id)
            INNER JOIN instalacao_agricola ia
                ON ga.instalacao_agricola_id = ia.instalacao_agricola_id;

         SELECT iafp.instalacao_agricola_id INTO temp_instalacao_agricola_idx    
            FROM instalacao_agricola_fator_producao iafp
                WHERE iafp.instalacao_agricola_id = temp_instalacao_agricola_id AND iafp.fator_producao_id = temp_fator_producao_id; 

        UPDATE instalacao_agricola_fator_producao 
            SET quantidade_kg = quantidade_kg + v_quantidade_kg 
                WHERE instalacao_agricola_id = temp_instalacao_agricola_idx AND fator_producao_id = temp_fator_producao_id;
        
        
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;
 
 
    OPEN c_instalacao_agricola_fator_producao;
        LOOP
            FETCH c_instalacao_agricola_fator_producao INTO l_instalacao_agricola_id , l_fator_producao_id, l_quantidade_kg ;
            EXIT WHEN c_instalacao_agricola_fator_producao%NOTFOUND;               
                DBMS_OUTPUT.PUT_LINE('instalacao_agricola_id= '|| l_instalacao_agricola_id || ' fator_producao_id= '|| l_fator_producao_id 
                                    || ' quantidade_kg= '|| l_quantidade_kg );               
        END LOOP;
    CLOSE c_instalacao_agricola_fator_producao;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_utilizador IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
            END IF;
            
            IF temp_fator_producao_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o fator producao com o nome comercial especificado');
            END IF;
              
            IF temp_instalacao_agricola_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'O gestor agricola nao esta associado a nenhuma instalacao agricola');
            END IF;    
            
            IF temp_instalacao_agricola_idx IS NULL THEN
            
                INSERT INTO instalacao_agricola_fator_producao(instalacao_agricola_id,fator_producao_id,quantidade_kg)
                            VALUES(temp_instalacao_agricola_id,temp_fator_producao_id,v_quantidade_kg);
                DBMS_OUTPUT.PUT_LINE('A linha seguinte foi adicionada a tabela instalacao_agricola_fator_producao:' );
                DBMS_OUTPUT.PUT_LINE(' temp_instalacao_agricola_id= '|| temp_instalacao_agricola_id 
                                    || ' temp_fator_producao_id= '|| temp_fator_producao_id || ' quantidade_kg= '|| v_quantidade_kg);
                            
            END IF;
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
            
    END p_adicionar_fator_producao_instalacao_agricola;
    /
    
SAVEPOINT us208_configurar_fatores_producao;

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
fator_producao_id= 1 nome_comercial= ENERGIZER fornecedor= AGRICHEM S.A preco_por_kg= 10 formulacao_id= 1 tipo_fator_producao_id= 1
fator_producao_id= 2 nome_comercial= LYSODIN DRY fornecedor= AGRICHEM S.A preco_por_kg= 12 formulacao_id= 1 tipo_fator_producao_id= 2
fator_producao_id= 3 nome_comercial= AUXIGRO PLUS fornecedor= AGRICHEM S.A preco_por_kg= 13 formulacao_id= 2 tipo_fator_producao_id= 3
fator_producao_id= 4 nome_comercial= AMINOLUM ALFAFA fornecedor= ALFREDO INESTA, SL preco_por_kg= 13 formulacao_id= 3 tipo_fator_producao_id= 4
fator_producao_id= 5 nome_comercial= fatorX fornecedor= ALFREDO INESTA, SL preco_por_kg= 12 formulacao_id= 1 tipo_fator_producao_id= 1
*/
CALL p_configurar_fatores_producao(1,'fatorX','ALFREDO INESTA, SL',12,'liquido','fertilizante');

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
A linha seguinte foi adicionada a tabela instalacao_agricola_fator_producao
temp_instalacao_agricola_id= 1 temp_fator_producao_id= 5 quantidade_kgx= 100
*/
CALL p_adicionar_fator_producao_instalacao_agricola(1,'fatorX',100);


ROLLBACK TO us208_configurar_fatores_producao;





-----------------------------------------------------------------------------------------------
------------------------------------CRITERIO DE ACEITACAO 2------------------------------------
-----------------------------------------------------------------------------------------------


create or replace PROCEDURE p_configurar_ficha_tecnica(v_utilizador_id utilizador.utilizador_id%TYPE, v_nome_comercial fator_producao.nome_comercial%TYPE,
                                                       v_designacao_c composto.designacao%TYPE, v_quantidade_composto ficha_tecnica.quantidade_composto%TYPE,
                                                       v_unidade_medida ficha_tecnica.unidade_medida%TYPE) 
IS

    
    
    temp_utilizador                     utilizador.utilizador_id%TYPE;
    temp_tipo_utilizador                tipo_utilizador.designacao%TYPE;
    temp_fator_producao_id              fator_producao.fator_producao_id%TYPE; 
    temp_composto_id                    composto.composto_id%TYPE;
    
    l_fator_producao_id                 ficha_tecnica.fator_producao_id%TYPE;
    l_composto_id                       ficha_tecnica.composto_id%TYPE;
    l_unidade_medida                    ficha_tecnica.unidade_medida%TYPE;    
    l_quantidade_composto               ficha_tecnica.quantidade_composto%TYPE; 
    
    CURSOR c_ficha_tecnica   IS 
    SELECT fator_producao_id, composto_id, unidade_medida, quantidade_composto FROM ficha_tecnica;
    
    EX_ERRO_TEMP_TIPO_UTILIZADOR EXCEPTION;
    
BEGIN 

    SELECT u.utilizador_id INTO temp_utilizador
    FROM utilizador u
        WHERE u.utilizador_id = v_utilizador_id;
    
    SELECT tu.designacao INTO temp_tipo_utilizador
    FROM tipo_utilizador tu
        INNER JOIN utilizador u
            ON tu.tipo_utilizador_id = u.tipo_utilizador_id AND u.utilizador_id = v_utilizador_id;

    SELECT f.fator_producao_id INTO temp_fator_producao_id
    FROM fator_producao f
        WHERE f.nome_comercial = v_nome_comercial; 

    SELECT c.composto_id INTO temp_composto_id
    FROM composto c
        WHERE c.designacao = v_designacao_c;
              
    IF temp_tipo_utilizador LIKE 'gestor agricola' THEN
    
        INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (temp_fator_producao_id,temp_composto_id,v_unidade_medida,v_quantidade_composto);
  
    ELSE
        RAISE EX_ERRO_TEMP_TIPO_UTILIZADOR;
    END IF;
 
 
    OPEN c_ficha_tecnica;
        LOOP
            FETCH c_ficha_tecnica INTO l_fator_producao_id , l_composto_id, l_unidade_medida, l_quantidade_composto ;
            EXIT WHEN c_ficha_tecnica%NOTFOUND;               
                DBMS_OUTPUT.PUT_LINE('fator_producao_id= '|| l_fator_producao_id || ' composto_id= '|| l_composto_id 
                                    || ' unidade_medida= '|| l_unidade_medida || ' quantidade_composto= '|| l_quantidade_composto );               
        END LOOP;
    CLOSE c_ficha_tecnica;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            IF temp_utilizador IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o utilizador especificado');
            END IF;
            
            IF temp_fator_producao_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o fator producao com o nome comercial especificado');
            END IF;
            
             IF temp_composto_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20011,'Nao existe o composto com a designacao especificada');
            END IF;
        END;
        WHEN EX_ERRO_TEMP_TIPO_UTILIZADOR THEN
            RAISE_APPLICATION_ERROR(-20011,'O utilizador especificado nao e um gestor agricola');
            
    END p_configurar_ficha_tecnica;
    /
    
SAVEPOINT us208_configurar_ficha_tecnica;


INSERT INTO fator_producao(nome_comercial,fornecedor,preco_por_kg,formulacao_id,tipo_fator_producao_id)
            VALUES('fatorX','ALFREDO INESTA, SL',12,1,1);  
---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
...continua....
fator_producao_id= 6 composto_id= 1 unidade_medida= kg quantidade_composto= 1
*/
CALL p_configurar_ficha_tecnica(1,'fatorX','Azoto organico',1,'kg');

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
...continua....
fator_producao_id= 6 composto_id= 1 unidade_medida= kg quantidade_composto= 1
fator_producao_id= 6 composto_id= 2 unidade_medida= kg quantidade_composto= 2
*/
CALL p_configurar_ficha_tecnica(1,'fatorX','Pentoxido de fosforo',2,'kg');

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------
/*
...continua....
fator_producao_id= 6 composto_id= 1 unidade_medida= kg quantidade_composto= 1
fator_producao_id= 6 composto_id= 2 unidade_medida= kg quantidade_composto= 2
fator_producao_id= 6 composto_id= 3 unidade_medida= l quantidade_composto= 5
*/
CALL p_configurar_ficha_tecnica(1,'fatorX','Oxido de potassio',5,'l');


ROLLBACK TO us208_configurar_ficha_tecnica;






