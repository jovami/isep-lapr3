---------------------------
----------[US212]----------
---------------------------

SET SERVEROUTPUT ON;


CREATE TABLE input_sensor (

    input_string VARCHAR(25)
);

CREATE TABLE guarda_processo_leitura_dados(

    data_hora_execucao                  DATE CONSTRAINT nn_data_hora_execucao NOT NULL,
    numero_registos_lidos               INTEGER CONSTRAINT nn_numero_registos_lidos NOT NULL,
    numero_registos_inseridos           INTEGER CONSTRAINT nn_numero_registos_inseridos NOT NULL,
    numero_registos_nao_inseridos       INTEGER CONSTRAINT nn_numero_registos_nao_inseridos NOT NULL
);

CREATE OR REPLACE FUNCTION f_retorna_n_esimo_valor_por_tuplo(v_n_esimo_valor INTEGER, v_input_string input_sensor.input_string%TYPE) RETURN VARCHAR
IS

    temp_valor_retorno  VARCHAR(25);

BEGIN

    IF v_n_esimo_valor = 1 THEN

        SELECT SUBSTR(v_input_string,1,5) INTO temp_valor_retorno from dual;

    ELSIF v_n_esimo_valor = 2 THEN
    
        SELECT SUBSTR(v_input_string,6,2) INTO temp_valor_retorno  from dual;
    
    ELSIF v_n_esimo_valor = 3 THEN
    
        SELECT SUBSTR(v_input_string,8,3) INTO temp_valor_retorno  from dual;
    
    ELSIF v_n_esimo_valor = 4 THEN
    
        SELECT SUBSTR(v_input_string,11,3) INTO temp_valor_retorno  from dual;
    
    ELSIF v_n_esimo_valor = 5 THEN
    
        SELECT SUBSTR(v_input_string,14,12) INTO temp_valor_retorno  from dual;
    
    END IF;

    RETURN(temp_valor_retorno);

END f_retorna_n_esimo_valor_por_tuplo;
/

CREATE OR REPLACE PROCEDURE p_adiciona_valores(v_parcela_agricola parcela_agricola.parcela_agricola_id%TYPE)
IS

    temp_sensor_id                     sensor.sensor_id%TYPE;
    temp_tipo_sensor_designacao        tipo_sensor.designacao%TYPE;
    temp_tipo_sensor_id                tipo_sensor.tipo_sensor_id%TYPE;
    temp_valor_referencia              sensor.valor_referencia%TYPE;
    temp_valor_lido                    registo_dado_meteorologico.valor_lido%TYPE;
    temp_data_instante_leitura         registo_dado_meteorologico.data_instante_leitura%TYPE;

    temp_data              VARCHAR(10);
    temp_hora              VARCHAR(10);
    temp_data_completa     DATE;

    l_input_string                      input_sensor.input_string%TYPE;

    CONTADOR_ERROS                      INTEGER;
    CONTADOR_REGISTOS_LIDOS             INTEGER;
    CONTADOR_REGISTOS_INSERIDOS         INTEGER;
    CONTADOR_REGISTOS_NAO_INSERIDOS     INTEGER;

    TYPE tabela_erros IS TABLE OF NUMBER INDEX BY VARCHAR2(25);
    l_sensor_id               tabela_erros;
    i                         VARCHAR(25);

    CURSOR c_input_sensor IS
    SELECT * FROM input_sensor;



BEGIN

    CONTADOR_REGISTOS_LIDOS := 0;
    CONTADOR_REGISTOS_INSERIDOS := 0;
    CONTADOR_REGISTOS_NAO_INSERIDOS := 0;

    OPEN c_input_sensor;
        LOOP
        FETCH c_input_sensor INTO l_input_string;
        EXIT WHEN c_input_sensor%NOTFOUND;

            CONTADOR_ERROS := 0;
            CONTADOR_REGISTOS_LIDOS := CONTADOR_REGISTOS_LIDOS + 1;

            temp_sensor_id := f_retorna_n_esimo_valor_por_tuplo(1,l_input_string);

            temp_tipo_sensor_designacao := f_retorna_n_esimo_valor_por_tuplo(2,l_input_string);

            temp_valor_lido := f_retorna_n_esimo_valor_por_tuplo(3,l_input_string);

            temp_data_instante_leitura := TO_DATE(f_retorna_n_esimo_valor_por_tuplo(5,l_input_string),'DD/MM/YYYY HH24:MI');

            IF LENGTH(temp_sensor_id) != 5 THEN

                CONTADOR_ERROS := CONTADOR_ERROS + 1;

            END IF;
            
            IF LENGTH(temp_tipo_sensor_designacao) != 2 THEN
            
                CONTADOR_ERROS := CONTADOR_ERROS + 1;
            
            ELSIF temp_tipo_sensor_designacao NOT LIKE 'HS'
                    AND temp_tipo_sensor_designacao NOT LIKE 'PI' AND temp_tipo_sensor_designacao NOT LIKE 'TS' 
                    AND temp_tipo_sensor_designacao NOT LIKE 'VV' AND temp_tipo_sensor_designacao NOT LIKE 'TA'
                    AND temp_tipo_sensor_designacao NOT LIKE 'HA' AND temp_tipo_sensor_designacao NOT LIKE 'PA' THEN

                CONTADOR_ERROS := CONTADOR_ERROS + 1;

            END IF;

            IF  temp_valor_lido < 0 OR temp_valor_lido > 100 THEN

                CONTADOR_ERROS := CONTADOR_ERROS + 1;

            END IF;

            IF REGEXP_LIKE(f_retorna_n_esimo_valor_por_tuplo(4,l_input_string), '^[[:digit:]]+$') THEN

                temp_valor_referencia := f_retorna_n_esimo_valor_por_tuplo(4,l_input_string);

            ELSE

                CONTADOR_ERROS := CONTADOR_ERROS + 1;

            END IF;

            
            temp_data_instante_leitura := TO_DATE(f_retorna_n_esimo_valor_por_tuplo(5,l_input_string),'DD/MM/YYYY HH24:MI');


            IF CONTADOR_ERROS = 0 THEN

                SELECT ts.tipo_sensor_id INTO temp_tipo_sensor_id
                FROM tipo_sensor ts
                WHERE ts.designacao = temp_tipo_sensor_designacao;
                
                
                INSERT INTO sensor(sensor_id,valor_referencia, tipo_sensor_id) VALUES (temp_sensor_id,temp_valor_referencia,temp_tipo_sensor_id);
                INSERT INTO registo_dado_meteorologico(parcela_agricola_id,sensor_id,data_instante_leitura,valor_lido)
                VALUES (v_parcela_agricola,temp_sensor_id,temp_data_instante_leitura,temp_valor_lido);
    
                CONTADOR_REGISTOS_INSERIDOS := CONTADOR_REGISTOS_INSERIDOS + 1;
                
                DELETE FROM input_sensor WHERE input_string = l_input_string;

            ELSE

                CONTADOR_REGISTOS_NAO_INSERIDOS := CONTADOR_REGISTOS_NAO_INSERIDOS + 1;
                l_sensor_id(temp_sensor_id) := CONTADOR_ERROS;

            END IF;

        END LOOP;
    CLOSE c_input_sensor;

    i := l_sensor_id.FIRST;

    DBMS_OUTPUT.PUT_LINE('---Registos nao inseridos devido a erros de formatacao---');

    WHILE i IS NOT NULL
        LOOP
            DBMS_OUTPUT.PUT_LINE('Sensor_id = ' || i || ' Numero de erros originados por este sensor = ' || l_sensor_id(i));
            i := l_sensor_id.NEXT(i);
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('');

    SELECT to_char(EXTRACT(HOUR FROM CURRENT_TIMESTAMP))  INTO temp_hora FROM DUAL;
    SELECT to_char(CAST(CURRENT_TIMESTAMP AS DATE),'DD/MM/YYYY') INTO temp_data FROM dual;
    SELECT TO_DATE (TO_CHAR ( TO_DATE (CONCAT(temp_data,temp_hora), 'DD/MM/YYYYHH24'), 'DD/MM/YYYY HH24'),'DD/MM/YYYY HH24') INTO temp_data_completa FROM DUAL;
    
    INSERT INTO guarda_processo_leitura_dados(data_hora_execucao,numero_registos_lidos,numero_registos_inseridos,numero_registos_nao_inseridos)
    VALUES
        (temp_data_completa,CONTADOR_REGISTOS_LIDOS,CONTADOR_REGISTOS_INSERIDOS,CONTADOR_REGISTOS_NAO_INSERIDOS);

    DBMS_OUTPUT.PUT_LINE('Data e hora de execucao do processo = ' || temp_data || ' ' || temp_hora);
    DBMS_OUTPUT.PUT_LINE('Numero total de registos lidos = ' || CONTADOR_REGISTOS_LIDOS);
    DBMS_OUTPUT.PUT_LINE('Numero total de registos transferidos = ' || CONTADOR_REGISTOS_INSERIDOS);
    DBMS_OUTPUT.PUT_LINE('Numero total de registos nao transferidos = ' || CONTADOR_REGISTOS_NAO_INSERIDOS);

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011,'Nao existe o tipo de sensor');


END p_adiciona_valores;
/

SAVEPOINT us_212_input_sensor;

-----62943/HS/078/783/010120211035
INSERT INTO input_sensor(input_string) VALUES ('62943HS078783010120211035');---0 erros
INSERT INTO input_sensor(input_string) VALUES ('62942HS178783010120211035');---1 erro 178 em vez de 078
INSERT INTO input_sensor(input_string) VALUES ('62941HS078A83010120211035');---1 erro A83 em vez de 783
INSERT INTO input_sensor(input_string) VALUES ('62940HS178A83010120211035');---2 erro 178 em vez de 078 e erro A83 em vez de 783
INSERT INTO input_sensor(input_string) VALUES ('62939HX178A83010120211035');---3 erro 178 em vez de 078 e erro A83 em vez de 783 erro HX em vez de HS

---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------

---Registos nao inseridos devido a erros de formatacao---
/*---Registos nao inseridos devido a erros de formatacao---
Sensor_id = 62939 Numero de erros originados por este sensor = 3
Sensor_id = 62940 Numero de erros originados por este sensor = 2
Sensor_id = 62941 Numero de erros originados por este sensor = 1
Sensor_id = 62942 Numero de erros originados por este sensor = 1

Data e hora de execucao do processo = 05/01/2023 22
Numero total de registos lidos = 5
Numero total de registos transferidos = 1
Numero total de registos nao transferidos = 4*/
CALL p_adiciona_valores(1);

SELECT * FROM sensor WHERE sensor_id = '62943';
SELECT * FROM registo_dado_meteorologico WHERE sensor_id = '62943';



---------OUTPUT OBTIDO E DE ACORDO AO ESPERADO--------------

/*---Registos nao inseridos devido a erros de formatacao---
Sensor_id = 62939 Numero de erros originados por este sensor = 3
Sensor_id = 62940 Numero de erros originados por este sensor = 2
Sensor_id = 62941 Numero de erros originados por este sensor = 1
Sensor_id = 62942 Numero de erros originados por este sensor = 1

Data e hora de execucao do processo = 05/01/2023 22
Numero total de registos lidos = 4
Numero total de registos transferidos = 0
Numero total de registos nao transferidos = 4*/
CALL p_adiciona_valores(1);

SELECT * FROM guarda_processo_leitura_dados;


ROLLBACK TO us_212_input_sensor;

DROP TABLE input_sensor CASCADE CONSTRAINTS PURGE ;
DROP TABLE guarda_processo_leitura_dados CASCADE CONSTRAINTS PURGE ;


