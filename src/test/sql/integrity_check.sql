--- Copyright (c) 2022 Jovami. All Rights Reserved. ---

-- Drops {{{
DROP TABLE instalacao_agricola CASCADE CONSTRAINTS PURGE ;
DROP TABLE caderno_campo CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_cultura CASCADE CONSTRAINTS PURGE ;
DROP TABLE produto CASCADE CONSTRAINTS PURGE ;
DROP TABLE stock CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_edificio CASCADE CONSTRAINTS PURGE ;
DROP TABLE edificio CASCADE CONSTRAINTS PURGE ;
DROP TABLE parcela_agricola CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_cultura CASCADE CONSTRAINTS PURGE ;
DROP TABLE sensor CASCADE CONSTRAINTS PURGE ;
DROP TABLE dado_meteorologico CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_rega CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_sistema CASCADE CONSTRAINTS PURGE ;
DROP TABLE plano_rega CASCADE CONSTRAINTS PURGE ;
DROP TABLE rega_executada CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_fator_producao CASCADE CONSTRAINTS PURGE ;
DROP TABLE formulacao CASCADE CONSTRAINTS PURGE ;
DROP TABLE fator_producao CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_fertilizacao CASCADE CONSTRAINTS PURGE ;
DROP TABLE fertilizacao CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_composto CASCADE CONSTRAINTS PURGE ;
DROP TABLE composto CASCADE CONSTRAINTS PURGE ;
DROP TABLE ficha_tecnica CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_utilizador CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_cliente CASCADE CONSTRAINTS PURGE ;
DROP TABLE codigo_postal CASCADE CONSTRAINTS PURGE ;
DROP TABLE utilizador CASCADE CONSTRAINTS PURGE ;
DROP TABLE gestor_agricola CASCADE CONSTRAINTS PURGE ;
DROP TABLE hub CASCADE CONSTRAINTS PURGE ;
DROP TABLE incidente CASCADE CONSTRAINTS PURGE ;
DROP TABLE estado_encomenda CASCADE CONSTRAINTS PURGE ;
DROP TABLE encomenda CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_encomenda CASCADE CONSTRAINTS PURGE ;
DROP TABLE pagamento CASCADE CONSTRAINTS PURGE ;
DROP TABLE instalacao_agricola_fator_producao CASCADE CONSTRAINTS PURGE ;
DROP TABLE encomenda_produto CASCADE CONSTRAINTS PURGE ;

-- }}}

-- Creates {{{
/*..........................................................*/
/*..........................................................*/
/*....................CREATE TABLE.........................*/

CREATE TABLE codigo_postal (

    codigo_postal_id        VARCHAR(40)     CONSTRAINT pk_codigo_postal_id PRIMARY KEY
);

CREATE TABLE instalacao_agricola (
    instalacao_agricola_id      INTEGER GENERATED AS IDENTITY CONSTRAINT pk_instalacao_agricola_id  PRIMARY KEY,
    nome                        VARCHAR(40)     CONSTRAINT nn_instalacao_agricola_nome              NOT NULL,
    morada                      VARCHAR(40)     CONSTRAINT nn_instalacao_agricola_morada            NOT NULL,

    codigo_postal_id            VARCHAR(40) REFERENCES codigo_postal(codigo_postal_id)              NOT NULL
);

CREATE TABLE caderno_campo (
    caderno_campo_id            INTEGER GENERATED AS IDENTITY CONSTRAINT pk_caderno_campo_id  PRIMARY KEY,
    ano                         INTEGER CONSTRAINT nn_caderno_campo_ano                       NOT NULL,
    designacao                  VARCHAR(40)     CONSTRAINT nn_caderno_campo_designacao        NOT NULL

);


CREATE TABLE tipo_cultura (
    tipo_cultura_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_cultura_id  PRIMARY KEY,
    designacao                  VARCHAR(40) CONSTRAINT un_tipo_cultura_designacao            UNIQUE
);


CREATE TABLE produto (
    produto_id                    INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_produto_id  PRIMARY KEY,
    valor_mercado_por_ha          NUMBER(15,4) CONSTRAINT ck_produto_valor_mercado_por_ha      CHECK(valor_mercado_por_ha >= 0),
    designacao                    VARCHAR(40) CONSTRAINT un_produto_id_designacao              UNIQUE
);


CREATE TABLE stock (

    caderno_campo_id              INTEGER REFERENCES caderno_campo(caderno_campo_id)                NOT NULL,
    produto_id                    INTEGER REFERENCES produto(produto_id)                            NOT NULL,
    CONSTRAINT pk_stock           PRIMARY KEY(caderno_campo_id,produto_id),
    stock_ton                     NUMBER(15,4) CONSTRAINT ck_stock_ton                              CHECK(stock_ton >= 0)
);


CREATE TABLE tipo_edificio (
    tipo_edificio_id            INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_edificio_id  PRIMARY KEY,
    designacao                  VARCHAR(40) CONSTRAINT ck_un_tipo_edificio_designacao CHECK(designacao = 'armazem' OR designacao = 'garagem' OR designacao = 'estabulo') UNIQUE   ---VERIFICAR
);


CREATE TABLE edificio (

    edificio_id                      INTEGER GENERATED AS IDENTITY CONSTRAINT pk_edificio_id        PRIMARY KEY,
    designacao                       VARCHAR(40)     CONSTRAINT nn_edificio_designacao              NOT NULL,
    area_ha                          NUMBER(15,4)    CONSTRAINT ck_edificio_area_ha                 CHECK(area_ha > 0),
    tipo_edificio_id                 INTEGER REFERENCES tipo_edificio(tipo_edificio_id)             NOT NULL,
    instalacao_agricola_id           INTEGER REFERENCES instalacao_agricola(instalacao_agricola_id) NOT NULL
);


CREATE TABLE parcela_agricola (

    parcela_agricola_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_parcela_agricola_id  PRIMARY KEY,
    designacao                      VARCHAR(40)  CONSTRAINT nn_parcela_agricola_designacao           NOT NULL,
    area_ha                         NUMBER(15,4) CONSTRAINT ck_parcela_agricola_area_ha              CHECK(area_ha > 0),
    instalacao_agricola_id          INTEGER REFERENCES instalacao_agricola(instalacao_agricola_id)   NOT NULL
);


CREATE TABLE registo_cultura (

     caderno_campo_id                   INTEGER REFERENCES caderno_campo(caderno_campo_id)              NOT NULL,
     parcela_agricola_id                INTEGER REFERENCES parcela_agricola(parcela_agricola_id)        NOT NULL,
     produto_id                         INTEGER REFERENCES produto(produto_id)                          NOT NULL,
     tipo_cultura_id                    INTEGER REFERENCES tipo_cultura(tipo_cultura_id)                NOT NULL,
     data_plantacao                     DATE    CONSTRAINT nn_registo_cultura_data_plantacao            NOT NULL,
     CONSTRAINT pk_registo_cultura      PRIMARY KEY(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao),

     area_plantada_ha                   NUMBER(15,4) CONSTRAINT ck_registo_cultura_area_plantada_ha                CHECK(area_plantada_ha > 0),
     data_colheita                      DATE ,
     quantidade_colhida_ton_por_ha      NUMBER(15,4) CONSTRAINT ck_registo_colheita_quantidade_colhida_ton_por_ha  CHECK(quantidade_colhida_ton_por_ha >= 0)
);


CREATE TABLE sensor(

    sensor_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_sensor_id  PRIMARY KEY,
    designacao            VARCHAR(70) CONSTRAINT ck_sensor_designacao CHECK(designacao ='sensor de pluviosidade' OR
                                                                            designacao = 'sensor de temperatura do solo' OR
                                                                            designacao = 'sensor de humidade do solo' OR
                                                                            designacao = 'sensor de velocidade do vento' OR
                                                                            designacao = 'sensor de temperatura, de humidade do ar e pressão atmosférica')
);


CREATE TABLE dado_meteorologico(

    caderno_campo_id                    INTEGER REFERENCES caderno_campo(caderno_campo_id)                  NOT NULL,
    sensor_id                           INTEGER REFERENCES sensor(sensor_id)                                NOT NULL,
    data_registo_meteorologico          DATE CONSTRAINT nn_dado_meteorologico_data_registo_meteorologico    NOT NULL,
    CONSTRAINT pk_dado_meteorologico    PRIMARY KEY(caderno_campo_id,sensor_id,data_registo_meteorologico),
    designacao                          VARCHAR(40) CONSTRAINT ck_dado_meteorologico_designacao CHECK(designacao ='solo' OR designacao ='meteorologico')

);


CREATE TABLE tipo_rega (

    tipo_rega_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_rega  PRIMARY KEY,
    designacao               VARCHAR(40) CONSTRAINT ck_un_tipo_rega_designacao CHECK(designacao ='pulverizacao' OR
                                                                                     designacao ='gotejamento' OR
                                                                                     designacao ='asprecao') UNIQUE
);


CREATE TABLE tipo_sistema (

    tipo_sistema_id          INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_sistema_id  PRIMARY KEY,
    designacao               VARCHAR(40) CONSTRAINT ck_un_tipo_sistema_designacao CHECK(designacao ='gravidade' OR
                                                                                        designacao ='bombeada') UNIQUE

);


CREATE TABLE plano_rega (

    parcela_agricola_id                 INTEGER REFERENCES parcela_agricola(parcela_agricola_id)    NOT NULL,
    data_inicio                         DATE CONSTRAINT nn_plano_rega_data_inicio                   NOT NULL,
    data_fim                            DATE CONSTRAINT nn_plano_rega_data_fim                      NOT NULL,

    CONSTRAINT pk_plano_rega    PRIMARY KEY(parcela_agricola_id,data_inicio,data_fim),

    periodicidade_rega_hh          INTEGER CONSTRAINT ck_plano_rega_periodicidade_rega_hh           CHECK(periodicidade_rega_hh > 0), --de quantas em quantas horas
    tempo_rega_mm                  INTEGER CONSTRAINT ck_plano_rega_tempo_rega_mm                   CHECK(tempo_rega_mm > 0) --tempo rega em minutos
);


CREATE TABLE rega_executada (

    caderno_campo_id                   INTEGER REFERENCES caderno_campo(caderno_campo_id)              NOT NULL,
    parcela_agricola_id                INTEGER REFERENCES parcela_agricola(parcela_agricola_id)        NOT NULL,
    data_realizacao                    DATE  CONSTRAINT nn_rega_executada_data_realizacao              NOT NULL,
    CONSTRAINT pk_rega_executada       PRIMARY KEY(caderno_campo_id,parcela_agricola_id,data_realizacao),

    quantidade_rega                    NUMBER(15,4) CONSTRAINT ck_rega_executada_quantidade_rega      CHECK(quantidade_rega > 0 ),
    tempo_rega_mm                      INTEGER CONSTRAINT ck_rega_executada_tempo_rega_mm             CHECK(tempo_rega_mm > 0),
    tipo_rega_id                       INTEGER REFERENCES tipo_rega(tipo_rega_id)                     NOT NULL,
    tipo_sistema_id                    INTEGER REFERENCES tipo_sistema(tipo_sistema_id)               NOT NULL
);


CREATE TABLE tipo_fator_producao (

    tipo_fator_producao_id   INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_fator_producao_id  PRIMARY KEY,
    designacao               VARCHAR(40) CONSTRAINT ck_un_tipo_fator_producao_designacao CHECK(designacao ='fertilizante' OR
                                                                                                designacao ='adubo' OR
                                                                                                designacao ='correctivo mineral' OR
                                                                                                designacao ='produto fitofarmaco') UNIQUE
);


CREATE TABLE formulacao (

    formulacao_id   INTEGER GENERATED AS IDENTITY CONSTRAINT pk_formulacao_id  PRIMARY KEY,
    designacao      VARCHAR(40) CONSTRAINT ck_un_formulacao_designacao CHECK(designacao ='liquido' OR
                                                                             designacao ='granulado' OR
                                                                             designacao ='po') UNIQUE
);


CREATE TABLE fator_producao (

    fator_producao_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_fator_producao_id    PRIMARY KEY,
    nome_comercial                VARCHAR(40)     CONSTRAINT nn_fator_producao_nome_comercial      NOT NULL,
    fornecedor                    VARCHAR(40)     CONSTRAINT nn_fator_producao_fornecedor          NOT NULL,
    preco_por_kg                  NUMBER(15,2) CONSTRAINT ck_fator_producao_preco_por_kg           CHECK(preco_por_kg > 0 ),
    formulacao_id                 INTEGER REFERENCES formulacao(formulacao_id)                     NOT NULL,
    tipo_fator_producao_id        INTEGER REFERENCES tipo_fator_producao(tipo_fator_producao_id)   NOT NULL

);

CREATE TABLE tipo_fertilizacao (

    tipo_fertilizacao_id   INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_fertilizacao_id  PRIMARY KEY,
    designacao             VARCHAR(40) CONSTRAINT ck_un_tipo_fertilizacao_designacao CHECK(designacao ='aplicacao direta solo' OR
                                                                                           designacao ='fetirrega' OR
                                                                                           designacao ='foliar') UNIQUE

);

CREATE TABLE fertilizacao (

    parcela_agricola_id            INTEGER REFERENCES parcela_agricola(parcela_agricola_id)         NOT NULL,
    fator_producao_id              INTEGER REFERENCES fator_producao(fator_producao_id)             NOT NULL,
    data_fertilizacao              DATE CONSTRAINT nn_fertilizacao_data_fertilizacao                NOT NULL,
    CONSTRAINT pk_fertilizacao     PRIMARY KEY(parcela_agricola_id,fator_producao_id,data_fertilizacao),

    quantidade_utilizada_kg        NUMBER(15,4) CONSTRAINT ck_fertilizacao_quantidade_utilizada_kg  CHECK(quantidade_utilizada_kg > 0),
    tipo_fertilizacao_id           INTEGER REFERENCES tipo_fertilizacao(tipo_fertilizacao_id)       NOT NULL
);


CREATE TABLE tipo_composto (

    tipo_composto_id    INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_composto_id    PRIMARY KEY,
    designacao          VARCHAR(40) CONSTRAINT ck_un_tipo_composto_designacao CHECK(designacao ='substancia' OR
                                                                                    designacao ='elemento') UNIQUE

);


CREATE TABLE composto (

    composto_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_composto_id    PRIMARY KEY,
    designacao              VARCHAR(40)     CONSTRAINT un_composto_designacao          UNIQUE,

    tipo_composto_id        INTEGER REFERENCES tipo_composto(tipo_composto_id)         NOT NULL
);


CREATE TABLE ficha_tecnica (

    fator_producao_id                 INTEGER REFERENCES fator_producao(fator_producao_id)        NOT NULL,
    composto_id                       INTEGER REFERENCES composto(composto_id)                    NOT NULL,
    CONSTRAINT pk_ficha_tecnica       PRIMARY KEY(composto_id,fator_producao_id),

    unidade_medida                    VARCHAR(40)  CONSTRAINT nn_ficha_tecnica_unidade_medida    NOT NULL,
    quantidade_composto               NUMBER(15,4) CONSTRAINT ck_composto_quantidade_composto    CHECK(quantidade_composto > 0)

);


CREATE TABLE instalacao_agricola_fator_producao (
    instalacao_agricola_id            INTEGER REFERENCES instalacao_agricola(instalacao_agricola_id)                NOT NULL,
    fator_producao_id                 INTEGER REFERENCES fator_producao(fator_producao_id)  NOT NULL,
    CONSTRAINT pk_instalacao_agricola_fator_producao     PRIMARY KEY (instalacao_agricola_id,fator_producao_id),

    quantidade_kg                     NUMBER(15,4) CONSTRAINT ck_instalacao_agricola_fator_producao_quantidade_kg    CHECK(quantidade_kg >= 0)
);


CREATE TABLE tipo_utilizador (

     tipo_utilizador_id         INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_utilizador_id    PRIMARY KEY,
     designacao                 VARCHAR(40) CONSTRAINT ck_un_tipo_utilizador_designacao CHECK(designacao ='cliente' OR
                                                                                              designacao ='gestor agricola'  OR
                                                                                              designacao ='condutor' OR
                                                                                              designacao ='gestor distribuicao') UNIQUE
);


CREATE TABLE tipo_cliente (

     tipo_cliente_id         INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_cliente_id    PRIMARY KEY,
     designacao              VARCHAR(40) CONSTRAINT ck_un_tipo_cliente_designacao CHECK(designacao ='A' OR
                                                                                        designacao ='B'  OR
                                                                                        designacao ='C') UNIQUE
);


CREATE TABLE utilizador (

     utilizador_id                      INTEGER GENERATED AS IDENTITY CONSTRAINT pk_utilizador_id    PRIMARY KEY,
     codigo_interno                     INTEGER         CONSTRAINT un_utilizador_codigo_interno      UNIQUE,
     nome                               VARCHAR(40)     CONSTRAINT nn_utilizador_nome                NOT NULL,
     numero_fiscal                      INTEGER         CONSTRAINT un_utilizador_numero_fiscal       UNIQUE,
     email                              VARCHAR(40)     CONSTRAINT un_utilizador_email               UNIQUE,
     morada_correspondencia             VARCHAR(40)     CONSTRAINT nn_utilizador_morada              NOT NULL,
     plafond                            NUMBER(15,2)    CONSTRAINT ck_utilizador_plafond             CHECK(plafond >= 0 OR plafond = NULL),
     numero_incidentes                  INTEGER         CONSTRAINT ck_utilizador_numero_incidentes   CHECK(numero_incidentes >= 0 OR numero_incidentes = NULL),
     data_ultimo_incidente              DATE,
     numero_encomendas_ultimo_ano       INTEGER         CONSTRAINT ck_utilizador_numero_encomendas_ultimo_ano  CHECK(numero_encomendas_ultimo_ano >= 0 OR numero_encomendas_ultimo_ano = NULL),
     valor_total_encomendas_ultimo_ano  NUMBER(15,2)    CONSTRAINT ck_utilizador_valor_total_encomendas_ultimo_ano    CHECK(valor_total_encomendas_ultimo_ano >= 0 OR valor_total_encomendas_ultimo_ano = NULL),

     codigo_postal_id          VARCHAR(40) REFERENCES codigo_postal(codigo_postal_id)       NOT NULL,
     tipo_utilizador_id        INTEGER REFERENCES tipo_utilizador(tipo_utilizador_id)       NOT NULL,
     tipo_cliente              INTEGER REFERENCES tipo_cliente(tipo_cliente_id)  --pode ser null, temos utilizadores que podem nao ser clientes
);


CREATE TABLE gestor_agricola (

    instalacao_agricola_id            INTEGER REFERENCES instalacao_agricola(instalacao_agricola_id)       NOT NULL,
    gestor_agricola_id                INTEGER REFERENCES utilizador(utilizador_id)                         NOT NULL,
    data_inicio_contrato              DATE CONSTRAINT nn_gestor_agricola_data_inicio_contrato              NOT NULL,
    CONSTRAINT pk_gestor_agricola     PRIMARY KEY (instalacao_agricola_id,gestor_agricola_id,data_inicio_contrato),

    data_fim_contrato          DATE
);


CREATE TABLE hub (

    hub_id                  INTEGER GENERATED AS IDENTITY CONSTRAINT pk_hub_id      PRIMARY KEY,
    morada                  VARCHAR(40)     CONSTRAINT nn_hub_morada                NOT NULL,
    codigo_postal_id        VARCHAR(40) REFERENCES codigo_postal(codigo_postal_id)  NOT NULL
);


CREATE TABLE incidente (

    incidente_id                  INTEGER GENERATED AS IDENTITY CONSTRAINT pk_incidente_id    PRIMARY KEY,
    valor_incidente               NUMBER(10,2) CONSTRAINT ck_incidente_valor_incidente        CHECK(valor_incidente > 0),
    data_incidente                DATE CONSTRAINT nn_incidente_data_incidente                 NOT NULL,
    data_incidente_liquidado      DATE ,
    cliente_id                    INTEGER REFERENCES utilizador(utilizador_id)                NOT NULL
);


CREATE TABLE estado_encomenda (

     estado_encomenda_id       INTEGER GENERATED AS IDENTITY CONSTRAINT pk_estado_encomenda_id    PRIMARY KEY,
     designacao                VARCHAR(40) CONSTRAINT ck_un_estado_encomenda_designacao CHECK(designacao ='registado' OR
                                                                                              designacao ='entregue'  OR
                                                                                              designacao ='pago') UNIQUE
);


CREATE TABLE encomenda (

    cliente_id                  INTEGER REFERENCES utilizador(utilizador_id)                  NOT NULL,
    gestor_agricola_id          INTEGER REFERENCES utilizador(utilizador_id)                  NOT NULL,
    data_estimada_entrega       DATE CONSTRAINT nn_encomenda_data_estimada_entrega            NOT NULL,
    CONSTRAINT pk_encomenda     PRIMARY KEY (cliente_id,gestor_agricola_id,data_estimada_entrega),

    valor_encomenda             NUMBER(10,2) CONSTRAINT ck_encomenda_valor_encomenda         CHECK(valor_encomenda > 0),
    data_limite_pagamento       DATE CONSTRAINT nn_encomenda_data_limite_pagamento           NOT NULL,
    endereco_entrega            VARCHAR(40) , --pode ser null caso a morada seja um hub ou a do proprio cliente

    hub_id                      INTEGER REFERENCES hub(hub_id)    --pode ser null caso a morada nao seja um hub
);


CREATE TABLE registo_encomenda (

    cliente_id                          INTEGER CONSTRAINT nn_registo_encomenda_cliente_id                         NOT NULL,
    gestor_agricola_id                  INTEGER CONSTRAINT nn_registo_encomenda_gestor_agricola_id                 NOT NULL,
    data_estimada_entrega               DATE    CONSTRAINT nn_registo_encomenda_data_estimada_entrega              NOT NULL,
    estado_encomenda_id                 INTEGER REFERENCES estado_encomenda(estado_encomenda_id)                   NOT NULL,
    CONSTRAINT pk_registo_encomenda     PRIMARY KEY (cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id),

    CONSTRAINT fk_registo_encomenda     FOREIGN KEY (cliente_id,gestor_agricola_id,data_estimada_entrega) REFERENCES encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega),

    data_registo_entrega_pagamento      DATE CONSTRAINT nn_registo_encomenda_data_entrega_registo_pagamento  NOT NULL
);


CREATE TABLE pagamento (

    pagamento_id                INTEGER GENERATED AS IDENTITY CONSTRAINT pk_pagamento_id            PRIMARY KEY,

    valor_pagamento             NUMBER(10,2) CONSTRAINT ck_pagamento_valor_pagamento                CHECK(valor_pagamento > 0),
    data_pagamento              DATE CONSTRAINT nn_encomenda_data_pagamento                         NOT NULL,

    cliente_id                  INTEGER CONSTRAINT nn_pagamento_cliente_id                         NOT NULL,
    gestor_agricola_id          INTEGER CONSTRAINT nn_pagamento_gestor_agricola_id                 NOT NULL,
    data_estimada_entrega       DATE    CONSTRAINT nn_pagamento_data_estimada_entrega              NOT NULL,
    CONSTRAINT fk_pagamento     FOREIGN KEY (cliente_id,gestor_agricola_id,data_estimada_entrega) REFERENCES encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega)
);


CREATE TABLE encomenda_produto (

    cliente_id                          INTEGER CONSTRAINT nn_encomenda_produto_cliente_id                         NOT NULL,
    gestor_agricola_id                  INTEGER CONSTRAINT nn_encomenda_produto_gestor_agricola_id                 NOT NULL,
    data_estimada_entrega               DATE    CONSTRAINT nn_encomenda_produto_data_estimada_entrega              NOT NULL,
    produto_id                          INTEGER REFERENCES produto(produto_id)                                     NOT NULL,
    CONSTRAINT pk_encomenda_produto     PRIMARY KEY (cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id),

    CONSTRAINT fk_encomenda_produto     FOREIGN KEY (cliente_id,gestor_agricola_id,data_estimada_entrega) REFERENCES encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega),

    quantidade_ton                      NUMBER(15,4) CONSTRAINT ck_encomenda_produto_quantidade_ton    CHECK(quantidade_ton > 0)
);

-- }}}

-- Print stuff
SET serveroutput on;

--- Don't actually alter the DB ---
SET autocommit off;


CREATE or replace PROCEDURE test_codigo_postal(
    test_code codigo_postal.codigo_postal_id%type
) AS
BEGIN
    BEGIN
        INSERT INTO codigo_postal(codigo_postal_id) VALUES(test_code);
        ROLLBACK;

        dbms_output.put_line('SUCCESS: Valid codigo_postal_id: '
            || test_code);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('FAILED: Value codigo_postal_id '
            || test_code
            || ' already exists');
        WHEN OTHERS THEN
            dbms_output.put_line('FAILED: Bad codigo_postal_id: '
                || nvl(test_code, q'['null']'));
    END;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing codigo_postal -----------');

    test_codigo_postal('8000');
    test_codigo_postal('4560');
    test_codigo_postal(null);

    dbms_output.new_line();
END;
/


CREATE or replace PROCEDURE test_instalacao_agricola(
    nome instalacao_agricola.nome%TYPE,
    morada instalacao_agricola.morada%TYPE,
    codigo_postal_id instalacao_agricola.codigo_postal_id%TYPE)
AS
BEGIN
    INSERT INTO
        instalacao_agricola(nome,morada,codigo_postal_id)
    VALUES (nome,morada,codigo_postal_id);
    ROLLBACK;

    dbms_output.put_line(
        'SUCCESS: '
        || nome
        || ' '
        || morada
        || ' '
        || codigo_postal_id
    );

EXCEPTION
    WHEN OTHERS THEN
        IF nome IS NULL then
            dbms_output.put_line('FAILED: nome nao pode ser null');
        elsif morada IS NULL then
            dbms_output.put_line('FAILED: morada nao pode ser null');
        elsif codigo_postal_id IS NULL then
            dbms_output.put_line('FAILED: codigo postal nao pode ser null');
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing instalacao_agricola -----------');

    test_instalacao_agricola('INSTALACAO G31 LAPR3', 'ISEP', '4490');
    test_instalacao_agricola(NULL, NULL, NULL);

    dbms_output.new_line();
END;
/

CREATE or replace PROCEDURE test_caderno_campo(
    ano caderno_campo.ano%type,
    designacao caderno_campo.designacao%type
) AS
BEGIN
    INSERT INTO caderno_campo(ano, designacao)
    VALUES(ano, designacao);
    ROLLBACK;

    dbms_output.put_line('SUCCESS: ' || ano || ' ' || designacao);
EXCEPTION
    WHEN others then
        IF ano IS NULL THEN
            dbms_output.put_line('FAILED: ano cannot be null');
        ELSIF designacao IS NULL THEN
            dbms_output.put_line('FAILED: designacao cannot be null');
        ELSIF length(designacao) > 40 THEN
            dbms_output.put_line('FAILED: designacao too big (>40 chars)');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing caderno_campo -----------');

    -- should work
    test_caderno_campo(2000, 'Caderno grupo 31');
    test_caderno_campo(2002, 'Caderno grupo 031');

    -- should fail
    test_caderno_campo(null, null);
    test_caderno_campo(null, 'hello');
    test_caderno_campo(2002, null);
    test_caderno_campo(2002, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

    dbms_output.new_line();
END;
/

CREATE or replace PROCEDURE test_tipo_cultura(
    designacao tipo_cultura.designacao%TYPE
)
AS
BEGIN
    INSERT into tipo_cultura(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);
EXCEPTION
    when dup_val_on_index then
        dbms_output.put_line('FAILED: designacao not unique');
END;
/

BEGIN
    dbms_output.put_line('----------- Testing tipo_cultura -----------');

    -- should work
    test_tipo_cultura('imaginaria');

    -- dupe entry => fail
    test_tipo_cultura('imaginaria');

    DELETE
    FROM
        tipo_cultura tc
    WHERE
        tc.designacao = 'imaginaria';

    dbms_output.new_line();
END;
/

create or replace PROCEDURE test_produto(
    valor produto.valor_mercado_por_ha%TYPE,
    designacao produto.designacao%TYPE
)
AS
BEGIN
    INSERT into produto(valor_mercado_por_ha, designacao)
    VALUES(valor, designacao);

    dbms_output.put_line('SUCCESS: ' || valor || ' ' || designacao);
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('FAILED: duplicate designacao');
    WHEN OTHERS THEN
        if valor < 0 then
            dbms_output.put_line('FAILED: price cannot be negative');
        end if;

END;
/

BEGIN
    dbms_output.put_line('----------- Testing produto -----------');

    -- should work
    test_produto(1000, 'abacate');

    -- dupe entry => fail
    test_produto(2000, 'abacate');

    -- free stuff!! i wish...
    test_produto(-100, 'xxxx');

    DELETE
    FROM
        produto p
    WHERE
        p.designacao = 'abacate';

    dbms_output.new_line();
END;
/

create or replace procedure test_stock(
    caderno_campo_id stock.caderno_campo_id%TYPE,
    produto_id       stock.produto_id%TYPE,
    stock_ton        stock.stock_ton%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (caderno_campo_id,produto_id,stock_ton);

    dbms_output.put_line('SUCCESS: ' || caderno_campo_id ||' ' || produto_id || ' ' || stock_ton);

EXCEPTION
    WHEN OTHERS THEN
        IF caderno_campo_id IS NULL THEN
            dbms_output.put_line('FAILED: caderno_campo_id cannot be null');
        ELSIF produto_id IS NULL THEN
            dbms_output.put_line('FAILED: produto_id cannot be null');
        ELSIF stock_ton < 0 THEN
            dbms_output.put_line('FAILED: stock_ton cannot be < 0');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing stock -----------');

    -- pass
    INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (1000,'rosas');
    INSERT INTO caderno_campo(ano,designacao) VALUES (2021,'CADERNO DE CAMPO G31 LAPR3');
    test_stock(7,4,100);

    -- dont pass
    test_stock(NULL, 4 , 100);

    -- dont pass
    test_stock(7, 4 , -1);

    -- dont pass
    test_stock(7, NULL , 100);

    dbms_output.new_line();
END;
/


create or replace procedure test_tipo_edificio(
    designacao tipo_edificio.designacao%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO tipo_edificio(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);

EXCEPTION
    WHEN OTHERS THEN
        if designacao is null then
            dbms_output.put_line('FAILED: designacao cannot be null');
        else
            dbms_output.put_line(
                'FAILED: designacao not equal to armazem/garagem/estabulo'
            );
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing tipo_edificio -----------');
    -- pass
    test_tipo_edificio('garagem');

    -- fails regex
    test_tipo_edificio('sei la');

    dbms_output.new_line();
END;
/

create or replace procedure test_edificio(
    designacao edificio.designacao%TYPE,
    area_ha edificio.area_ha%TYPE,
    tipo_edificio_id edificio.tipo_edificio_id%TYPE,
    instalacao_agricola_id edificio.instalacao_agricola_id%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO edificio(designacao, area_ha, tipo_edificio_id, instalacao_agricola_id)
    VALUES(designacao,area_ha,tipo_edificio_id,instalacao_agricola_id);

    dbms_output.put_line('SUCCESS: ' || designacao ||' ' || area_ha || ' ' || tipo_edificio_id || ' ' || instalacao_agricola_id);

EXCEPTION
    WHEN OTHERS THEN
        IF designacao IS NULL THEN
            dbms_output.put_line('FAILED: designacao cannot be null');
        ELSIF length(designacao) > 40 THEN
            dbms_output.put_line('FAILED: designacao too big (>40 chars)');
        ELSIF area_ha < 0 THEN
            dbms_output.put_line('FAILED: area cannot be < 0');
        ELSIF tipo_edificio_id IS NULL THEN
            dbms_output.put_line('FAILED: tipo_edificio_id cannot be null');
        ELSIF instalacao_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: instalacao_agricola_id cannot be null');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing edificio -----------');

    -- pass
    INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4490');
    INSERT INTO instalacao_agricola(nome,morada,codigo_postal_id) VALUES ('INSTALACAO G31 LAPR3', 'ISEP', '4490');
    INSERT INTO tipo_edificio(designacao) VALUES ('armazem');

    test_edificio('instalacao agricola', 1000, 1 , 3);

    -- dont pass
    test_edificio(null, 1000, 1 , 1);

    -- dont pass
    test_edificio('instalacao agricola', -1, 1 , 3);

    -- dont pass
    test_edificio('instalacao agricola', 1000, null , 3);

    -- dont pass
    test_edificio('instalacao agricola', 1000, 1 , null);

    dbms_output.new_line();
END;
/

create or replace procedure test_parcela_agricola(
    designacao parcela_agricola.designacao%TYPE,
    area_ha parcela_agricola.area_ha%TYPE,
    instalacao_agricola_id parcela_agricola.instalacao_agricola_id%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO parcela_agricola(designacao, area_ha, instalacao_agricola_id)
    VALUES(designacao, area_ha, instalacao_agricola_id);

    dbms_output.put_line('SUCCESS: ' || designacao ||' ' || area_ha || ' ' || instalacao_agricola_id);

EXCEPTION
    WHEN OTHERS THEN
        IF designacao IS NULL THEN
            dbms_output.put_line('FAILED: designacao cannot be null');
        ELSIF length(designacao) > 40 THEN
            dbms_output.put_line('FAILED: designacao too big (>40 chars)');
        ELSIF area_ha < 0 THEN
            dbms_output.put_line('FAILED: area cannot be < 0');
        ELSIF instalacao_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: instalacao_agricola_id cannot be null');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing parcela_agricola -----------');

    -- pass
    test_parcela_agricola('parcela', 1000, 3);

    -- dont pass
     test_parcela_agricola(NULL, 1000, 3);

    -- dont pass
     test_parcela_agricola('parcela', -1, 3);

    -- dont pass
     test_parcela_agricola('parcela', 1000, NULL);

    dbms_output.new_line();
END;
/

create or replace procedure test_registo_cultura(
    caderno_campo_id                registo_cultura.caderno_campo_id%TYPE,
    parcela_agricola_id             registo_cultura.parcela_agricola_id%TYPE,
    produto_id                      registo_cultura.produto_id%TYPE,
    tipo_cultura_id                 registo_cultura.tipo_cultura_id%TYPE,
    data_plantacao                  registo_cultura.data_plantacao%TYPE,
    area_plantada_ha                registo_cultura.area_plantada_ha%TYPE,
    data_colheita                   registo_cultura.data_colheita%TYPE,
    quantidade_colhida_ton_por_ha   registo_cultura.quantidade_colhida_ton_por_ha%TYPE

)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO registo_cultura(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)
    VALUES(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha);

    dbms_output.put_line('SUCCESS: ' || caderno_campo_id ||' ' || parcela_agricola_id || ' ' || produto_id
                            || ' ' || tipo_cultura_id || ' ' || data_plantacao || ' ' || area_plantada_ha || ' ' || data_colheita
                            || ' ' || quantidade_colhida_ton_por_ha);

EXCEPTION
    WHEN OTHERS THEN
        IF caderno_campo_id IS NULL THEN
            dbms_output.put_line('FAILED: caderno_campo_id cannot be null');
        ELSIF parcela_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: parcela_agricola_id cannot be null');
        ELSIF produto_id IS NULL THEN
            dbms_output.put_line('FAILED: produto_id cannot be null');
        ELSIF tipo_cultura_id IS NULL THEN
            dbms_output.put_line('FAILED: tipo_cultura_id cannot be null');
        ELSIF data_plantacao IS NULL THEN
            dbms_output.put_line('FAILED: data_plantacao cannot be null');
        ELSIF area_plantada_ha <= 0 THEN
            dbms_output.put_line('FAILED: area_plantada_ha cannot be <= 0');
        ELSIF quantidade_colhida_ton_por_ha <0 THEN
            dbms_output.put_line('FAILED: quantidade_colhida_ton_por_ha cannot be < 0');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing registo_cultura -----------');

    INSERT INTO tipo_cultura(designacao) VALUES ('permanente');

    -- pass
    test_registo_cultura(7,1,4,3,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);

    -- dont pass
     test_registo_cultura(null,1,4,3,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);

    -- dont pass
     test_registo_cultura(7,null,4,3,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);

    -- dont pass
     test_registo_cultura(7,1,null,3,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);

    -- dont pass
     test_registo_cultura(7,1,4,null,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);

    -- dont pass
     test_registo_cultura(7,1,4,3,null,10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);

    -- dont pass
     test_registo_cultura(7,1,4,3,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),0,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);

    -- dont pass
    test_registo_cultura(7,1,4,3,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),-1);

    dbms_output.new_line();
END;
/

create or replace procedure test_tipo_fator_producao(
    designacao tipo_fator_producao.designacao%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO tipo_fator_producao(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);

EXCEPTION
    WHEN OTHERS THEN
        if designacao is null then
            dbms_output.put_line('FAILED: designacao cannot be null');
        else
            dbms_output.put_line(
                'FAILED: designacao not equal to fertilizante/adubo/correctivo mineral/produto fitofarmaco'
            );
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing tipo_fator_producao -----------');

    -- pass
    test_tipo_fator_producao('fertilizante');

    -- fails regex
    test_tipo_fator_producao('sei la');

    dbms_output.new_line();
END;
/

create or replace procedure test_formulacao(
    designacao formulacao.designacao%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO formulacao(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);

EXCEPTION
    WHEN OTHERS THEN
        if designacao is null then
            dbms_output.put_line('FAILED: designacao cannot be null');
        else
            dbms_output.put_line(
                'FAILED: designacao not equal to liquido/granulado/po'
            );
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing formulacao -----------');

    -- pass
    test_formulacao('liquido');

    -- fails regex
    test_formulacao('sei la');

    dbms_output.new_line();
END;
/

create or replace procedure test_fator_producao(
    nome_comercial                  fator_producao.nome_comercial%TYPE,
    fornecedor                      fator_producao.fornecedor%TYPE,
    preco_por_kg                    fator_producao.preco_por_kg%TYPE,
    formulacao_id                   fator_producao.formulacao_id%TYPE,
    tipo_fator_producao_id          fator_producao.tipo_fator_producao_id%TYPE

)
AS
BEGIN
    -- Insert rows in a Table

   INSERT INTO fator_producao(nome_comercial,fornecedor,preco_por_kg,formulacao_id,tipo_fator_producao_id)
            VALUES(nome_comercial,fornecedor,preco_por_kg,formulacao_id,tipo_fator_producao_id);

    dbms_output.put_line('SUCCESS: ' || nome_comercial ||' ' || fornecedor || ' ' || preco_por_kg
                            || ' ' || formulacao_id || ' ' || tipo_fator_producao_id );

EXCEPTION
    WHEN OTHERS THEN
        IF nome_comercial IS NULL THEN
            dbms_output.put_line('FAILED: nome_comercial cannot be null');
        ELSIF fornecedor IS NULL THEN
            dbms_output.put_line('FAILED: fornecedor cannot be null');
        ELSIF preco_por_kg <= 0 THEN
            dbms_output.put_line('FAILED: preco_por_kg cannot be <= 0');
        ELSIF formulacao_id IS NULL THEN
            dbms_output.put_line('FAILED: formulacao_id cannot be null');
        ELSIF tipo_fator_producao_id IS NULL THEN
            dbms_output.put_line('FAILED: tipo_fator_producao_id cannot be null');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing fator_producao -----------');

    -- pass
    test_fator_producao('ENERGIZER','AGRICHEM S.A',10,1,1);

    -- dont pass
     test_fator_producao(null,'AGRICHEM S.A',10,1,1);

     -- dont pass
     test_fator_producao('ENERGIZER',null,10,1,1);

     -- dont pass
     test_fator_producao('ENERGIZER','AGRICHEM S.A',0,1,1);

     -- dont pass
     test_fator_producao('ENERGIZER','AGRICHEM S.A',10,null,1);

     -- dont pass
     test_fator_producao('ENERGIZER','AGRICHEM S.A',10,1,null);

    dbms_output.new_line();
END;
/

create or replace procedure test_tipo_fertilizacao(
    designacao tipo_fertilizacao.designacao%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO tipo_fertilizacao(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);

EXCEPTION
    WHEN OTHERS THEN
        if designacao is null then
            dbms_output.put_line('FAILED: designacao cannot be null');
        else
            dbms_output.put_line(
                'FAILED: designacao not equal to aplicacao direta solo/fetirrega/foliar'
            );
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing tipo_fertilizacao -----------');

    -- pass
    test_tipo_fertilizacao('fetirrega');

    -- fails regex
    test_tipo_fertilizacao('sei la');

    dbms_output.new_line();
END;
/

create or replace procedure test_fertilizacao(
    parcela_agricola_id                  fertilizacao.parcela_agricola_id%TYPE,
    fator_producao_id                    fertilizacao.fator_producao_id%TYPE,
    data_fertilizacao                    fertilizacao.data_fertilizacao%TYPE,
    quantidade_utilizada_kg              fertilizacao.quantidade_utilizada_kg%TYPE,
    tipo_fertilizacao_id                 fertilizacao.tipo_fertilizacao_id%TYPE

)
AS
BEGIN
    -- Insert rows in a Table

   INSERT INTO fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id);

    dbms_output.put_line('SUCCESS: ' || parcela_agricola_id ||' ' || fator_producao_id || ' ' || data_fertilizacao
                            || ' ' || quantidade_utilizada_kg || ' ' || tipo_fertilizacao_id );

EXCEPTION
    WHEN OTHERS THEN
        IF parcela_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: parcela_agricola_id cannot be null');
        ELSIF fator_producao_id IS NULL THEN
            dbms_output.put_line('FAILED: fator_producao_id cannot be null');
        ELSIF data_fertilizacao IS NULL THEN
            dbms_output.put_line('FAILED: data_fertilizacao cannot be null');
        ELSIF quantidade_utilizada_kg <=0 THEN
            dbms_output.put_line('FAILED: quantidade_utilizada_kg cannot be <=0');
        ELSIF tipo_fertilizacao_id IS NULL THEN
            dbms_output.put_line('FAILED: tipo_fertilizacao_id cannot be null');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing fertilizacao -----------');

    -- pass
    test_fertilizacao(1,1,TO_DATE('03/01/2021 12:00','DD/MM/YYYY HH24:MI'),50,1);

    -- dont pass
    test_fertilizacao(null,1,TO_DATE('03/01/2021 12:00','DD/MM/YYYY HH24:MI'),50,1);

     -- dont pass
    test_fertilizacao(1,null,TO_DATE('03/01/2021 12:00','DD/MM/YYYY HH24:MI'),50,1);

     -- dont pass
    test_fertilizacao(1,1,null,50,1);

     -- dont pass
    test_fertilizacao(1,1,TO_DATE('03/01/2021 12:00','DD/MM/YYYY HH24:MI'),0,1);

     -- dont pass
    test_fertilizacao(1,1,TO_DATE('03/01/2021 12:00','DD/MM/YYYY HH24:MI'),50,null);

    dbms_output.new_line();
END;
/

create or replace procedure test_tipo_composto(
    designacao tipo_composto.designacao%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO tipo_composto(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);

EXCEPTION
    WHEN OTHERS THEN
        if designacao is null then
            dbms_output.put_line('FAILED: designacao cannot be null');
        else
            dbms_output.put_line(
                'FAILED: designacao not equal to substancia/elemento'
            );
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing tipo_composto -----------');

    -- pass
    test_tipo_composto('substancia');

    -- fails regex
    test_tipo_composto('sei la');

    dbms_output.new_line();
END;
/

create or replace procedure test_composto(
    designacao composto.designacao%TYPE,
    tipo_composto_id composto.tipo_composto_id%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO composto(designacao,tipo_composto_id)
    VALUES(designacao,tipo_composto_id);

    dbms_output.put_line('SUCCESS: ' || designacao || ' ' || tipo_composto_id);

EXCEPTION
    WHEN OTHERS THEN
        if tipo_composto_id is null then
            dbms_output.put_line('FAILED: tipo_composto_id cannot be null');
        else
            dbms_output.put_line('FAILED: duplicate values for composto designacao');
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing composto -----------');

    -- pass
    test_composto('azoto',1);

    -- dont pass
    test_composto('azoto',1);

    -- dont pass
    test_composto('azoto',null);

    dbms_output.new_line();
END;
/

create or replace procedure test_ficha_tecnica(
    fator_producao_id                   ficha_tecnica.fator_producao_id%TYPE,
    composto_id                         ficha_tecnica.composto_id%TYPE,
    unidade_medida                      ficha_tecnica.unidade_medida%TYPE,
    quantidade_composto                 ficha_tecnica.quantidade_composto%TYPE

)
AS
BEGIN
    -- Insert rows in a Table

   INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES(fator_producao_id,composto_id,unidade_medida,quantidade_composto);

    dbms_output.put_line('SUCCESS: ' || fator_producao_id ||' ' || composto_id || ' ' || unidade_medida || ' ' || quantidade_composto );

EXCEPTION
    WHEN OTHERS THEN
        IF fator_producao_id IS NULL THEN
            dbms_output.put_line('FAILED: fator_producao_id cannot be null');
        ELSIF composto_id IS NULL THEN
            dbms_output.put_line('FAILED: composto_id cannot be null');
        ELSIF unidade_medida IS NULL THEN
            dbms_output.put_line('FAILED: unidade_medida cannot be null');
        ELSIF quantidade_composto <=0 THEN
            dbms_output.put_line('FAILED: quantidade_composto cannot be <=0');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing ficha_tecnica -----------');

    -- pass
    test_ficha_tecnica(1,1,'kg',1);

    -- dont pass
    test_ficha_tecnica(null,1,'kg',1);

    -- dont pass
    test_ficha_tecnica(1,null,'kg',1);

    -- dont pass
    test_ficha_tecnica(1,1,null,1);

    -- dont pass
    test_ficha_tecnica(1,1,'kg',0);

    dbms_output.new_line();
END;
/

create or replace procedure test_instalacao_agricola_fator_producao(
    instalacao_agricola_id              instalacao_agricola_fator_producao.instalacao_agricola_id%TYPE,
    fator_producao_id                   instalacao_agricola_fator_producao.fator_producao_id%TYPE,
    quantidade_kg                       instalacao_agricola_fator_producao.quantidade_kg%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

   INSERT INTO instalacao_agricola_fator_producao(instalacao_agricola_id,fator_producao_id,quantidade_kg)
            VALUES(instalacao_agricola_id,fator_producao_id,quantidade_kg);

    dbms_output.put_line('SUCCESS: ' || instalacao_agricola_id ||' ' || fator_producao_id || ' ' || quantidade_kg);

EXCEPTION
    WHEN OTHERS THEN
        IF instalacao_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: instalacao_agricola_id cannot be null');
        ELSIF fator_producao_id IS NULL THEN
            dbms_output.put_line('FAILED: fator_producao_id cannot be null');
        ELSIF quantidade_kg < 0 THEN
            dbms_output.put_line('FAILED: quantidade_kg cannot be < 0');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing instalacao_agricola_fator_producao -----------');

    -- pass
    test_instalacao_agricola_fator_producao(3,1,100000);

    -- dont pass
    test_instalacao_agricola_fator_producao(null,1,100000);

    -- dont pass
    test_instalacao_agricola_fator_producao(3,null,100000);

    -- dont pass
    test_instalacao_agricola_fator_producao(3,1,-100000);


    dbms_output.new_line();
END;
/

create or replace procedure test_tipo_utilizador(
    designacao tipo_utilizador.designacao%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO tipo_utilizador(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);

EXCEPTION
    WHEN OTHERS THEN
        if designacao is null then
            dbms_output.put_line('FAILED: designacao cannot be null');
        else
            dbms_output.put_line(
                'FAILED: designacao not equal to cliente/gestor agricola/condutor/gestor distribuicao'
            );
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing tipo_utilizador -----------');

    -- pass
    test_tipo_utilizador('cliente');

    -- fails regex
    test_tipo_utilizador('sei la');

    dbms_output.new_line();
END;
/

create or replace procedure test_tipo_cliente(
    designacao tipo_cliente.designacao%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO tipo_cliente(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);

EXCEPTION
    WHEN OTHERS THEN
        if designacao is null then
            dbms_output.put_line('FAILED: designacao cannot be null');
        else
            dbms_output.put_line(
                'FAILED: designacao not equal to A/B/C'
            );
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing tipo_cliente -----------');

    -- pass
    test_tipo_cliente('A');

    -- fails regex
    test_tipo_cliente('sei la');

    dbms_output.new_line();
END;
/

create or replace procedure test_utilizador(
    codigo_interno utilizador.codigo_interno%TYPE,nome utilizador.nome%TYPE,numero_fiscal utilizador.numero_fiscal%TYPE,
    email utilizador.email%TYPE, morada_correspondencia utilizador.morada_correspondencia%TYPE,
    plafond utilizador.plafond%TYPE,numero_incidentes utilizador.numero_incidentes%TYPE,
    data_ultimo_incidente utilizador.data_ultimo_incidente%TYPE,numero_encomendas_ultimo_ano utilizador.numero_encomendas_ultimo_ano%TYPE,
    valor_total_encomendas_ultimo_ano  utilizador.numero_encomendas_ultimo_ano%TYPE,
    codigo_postal_id utilizador.codigo_postal_id%TYPE, tipo_utilizador_id utilizador.tipo_utilizador_id%TYPE,
    tipo_cliente_id utilizador.tipo_cliente%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES (codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente_id);

    dbms_output.put_line('SUCCESS: utilizador inserido');

EXCEPTION
    WHEN OTHERS THEN
        IF nome IS NULL THEN
            dbms_output.put_line('FAILED: nome cannot be null');
        ELSIF morada_correspondencia IS NULL THEN
            dbms_output.put_line('FAILED: morada_correspondencia cannot be null');
        ELSIF plafond < 0 THEN
            dbms_output.put_line('FAILED: plafond cannot be < 0');
        ELSIF numero_incidentes < 0 THEN
            dbms_output.put_line('FAILED: numero_incidentes cannot be < 0');
        ELSIF numero_encomendas_ultimo_ano < 0 THEN
            dbms_output.put_line('FAILED: numero_encomendas_ultimo_ano cannot be < 0');
        ELSIF valor_total_encomendas_ultimo_ano < 0 THEN
            dbms_output.put_line('FAILED: valor_total_encomendas_ultimo_ano cannot be < 0');
        ELSIF codigo_postal_id IS NULL THEN
            dbms_output.put_line('FAILED: codigo_postal_id cannot be null');
        ELSIF tipo_utilizador_id IS NULL THEN
            dbms_output.put_line('FAILED: tipo_utilizador_id cannot be null');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing utilizador -----------');

    -- pass
    INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4450');
    INSERT INTO tipo_cliente(designacao) VALUES ('B');
    INSERT INTO tipo_cliente(designacao) VALUES ('C');
    test_utilizador(1210957,'joao',231432459,'1210957@isep.ipp.pt','rua joao ISEP',100000,1,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),1,60000,'4450',1,3);

    -- dont pass


    dbms_output.new_line();
END;
/

create or replace procedure test_gestor_agricola(
    instalacao_agricola_id      gestor_agricola.instalacao_agricola_id%TYPE,
    gestor_agricola_id          gestor_agricola.gestor_agricola_id%TYPE,
    data_inicio_contrato        gestor_agricola.data_inicio_contrato%TYPE,
    data_fim_contrato           gestor_agricola.data_fim_contrato%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO gestor_agricola(instalacao_agricola_id,gestor_agricola_id,data_inicio_contrato,data_fim_contrato)
    VALUES(instalacao_agricola_id,gestor_agricola_id,data_inicio_contrato,data_fim_contrato);

    dbms_output.put_line('SUCCESS: ' || instalacao_agricola_id || ' ' || gestor_agricola_id || ' ' || data_inicio_contrato || ' ' ||data_fim_contrato);

EXCEPTION
    WHEN OTHERS THEN
        IF instalacao_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: instalacao_agricola_id cannot be null');
        ELSIF gestor_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: gestor_agricola_id cannot be null');
        ELSIF data_inicio_contrato IS NULL THEN
            dbms_output.put_line('FAILED: data_inicio_contrato cannot be null');
        END IF;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing gestor_agricola -----------');
    INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4480');
    INSERT INTO tipo_utilizador(designacao) VALUES ('gestor agricola');
    INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (null,'Quim',231432462,'quimisep@isep.ipp.pt','rua quim ISEP',NULL,NULL,NULL,NULL,NULL,'4480',3,NULL);

    -- pass
    test_gestor_agricola(3,2,TO_DATE('01/01/2021 08:00','DD/MM/YYYY HH24:MI'),NULL);

    -- dont pass
    test_gestor_agricola(null,2,TO_DATE('01/01/2021 08:00','DD/MM/YYYY HH24:MI'),NULL);

    -- dont pass
    test_gestor_agricola(3,null,TO_DATE('01/01/2021 08:00','DD/MM/YYYY HH24:MI'),NULL);

    -- dont pass
    test_gestor_agricola(3,2,null,NULL);

    dbms_output.new_line();
END;
/

create or replace procedure test_hub(
    morada              hub.morada%TYPE,
    codigo_postal_id    hub.codigo_postal_id%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO hub(morada,codigo_postal_id)
    VALUES(morada,codigo_postal_id);

    dbms_output.put_line('SUCCESS: hub inserted' );

EXCEPTION
    WHEN OTHERS THEN
        if morada is null then
            dbms_output.put_line('FAILED: morada cannot be null');
        ELSIF codigo_postal_id IS NULL THEN
            dbms_output.put_line('FAILED: codigo_postal_id cannot be null');
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing hub -----------');

    INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4400');

    -- pass
    test_hub('Trindade','4400');

    -- dont pass
    test_hub(null,'4400');

     -- dont pass
    test_hub('Trindade',null);

    dbms_output.new_line();
END;
/


create or replace procedure test_incidente(
    valor_incidente             incidente.valor_incidente%TYPE,
    data_incidente              incidente.data_incidente%TYPE,
    data_incidente_liquidado    incidente.data_incidente_liquidado%TYPE,
    cliente_id                  incidente.cliente_id%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO incidente(valor_incidente,data_incidente,data_incidente_liquidado,cliente_id)
    VALUES(valor_incidente,data_incidente,data_incidente_liquidado,cliente_id);

    dbms_output.put_line('SUCCESS: incidente inserted' );

EXCEPTION
    WHEN OTHERS THEN
        if valor_incidente <= 0 then
            dbms_output.put_line('FAILED: valor_incidente cannot be <= 0');
        ELSIF data_incidente IS NULL THEN
            dbms_output.put_line('FAILED: data_incidente cannot be null');
        ELSIF cliente_id IS NULL THEN
            dbms_output.put_line('FAILED: cliente_id cannot be null');
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing incidente -----------');



    -- pass
    test_incidente(60000,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'),1);

    -- dont pass
    test_incidente(0,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'),1);

     -- dont pass
    test_incidente(60000,null,TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'),1);

    -- dont pass
    test_incidente(60000,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'),null);


    dbms_output.new_line();
END;
/

create or replace procedure test_estado_encomenda(
    designacao estado_encomenda.designacao%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO estado_encomenda(designacao)
    VALUES(designacao);

    dbms_output.put_line('SUCCESS: ' || designacao);

EXCEPTION
    WHEN OTHERS THEN
        if designacao is null then
            dbms_output.put_line('FAILED: designacao cannot be null');
        else
            dbms_output.put_line(
                'FAILED: designacao not equal to registado/entregue/pago'
            );
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing estado_encomenda -----------');

    -- pass
    test_estado_encomenda('registado');

    -- dont pass
    test_estado_encomenda('sei la');

    dbms_output.new_line();
END;
/

create or replace procedure test_encomenda(
    cliente_id              encomenda.cliente_id%TYPE,
    gestor_agricola_id      encomenda.gestor_agricola_id%TYPE,
    data_estimada_entrega   encomenda.data_estimada_entrega%TYPE,
    valor_encomenda         encomenda.valor_encomenda%TYPE,
    data_limite_pagamento   encomenda.data_limite_pagamento%TYPE,
    endereco_entrega        encomenda.endereco_entrega%TYPE,
    hub_id                  encomenda.hub_id%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
    VALUES(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id);

    dbms_output.put_line('SUCCESS: encomenda inserted' );

EXCEPTION
    WHEN OTHERS THEN
        if valor_encomenda <= 0 then
            dbms_output.put_line('FAILED: valor_encomenda cannot be <= 0');
        ELSIF cliente_id IS NULL THEN
            dbms_output.put_line('FAILED: cliente_id cannot be null');
        ELSIF data_estimada_entrega IS NULL THEN
            dbms_output.put_line('FAILED: data_estimada_entrega cannot be null');
        ELSIF gestor_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: gestor_agricola_id cannot be null');
        ELSIF data_limite_pagamento IS NULL THEN
            dbms_output.put_line('FAILED: data_limite_pagamento cannot be null');
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing encomenda -----------');


    -- pass
    test_encomenda(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),12000,TO_DATE('15/03/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);

    -- dont pass
    test_encomenda(null,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),12000,TO_DATE('15/03/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);

    -- dont pass
    test_encomenda(1,null,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),12000,TO_DATE('15/03/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);

    -- dont pass
    test_encomenda(1,9,null,12000,TO_DATE('15/03/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);

    -- dont pass
    test_encomenda(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),0,TO_DATE('15/03/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);

    -- dont pass
    test_encomenda(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),12000,null,NULL,NULL);


    dbms_output.new_line();
END;
/

create or replace procedure test_registo_encomenda(
    cliente_id                       registo_encomenda.cliente_id%TYPE,
    gestor_agricola_id               registo_encomenda.gestor_agricola_id%TYPE,
    data_estimada_entrega            registo_encomenda.data_estimada_entrega%TYPE,
    estado_encomenda_id              registo_encomenda.estado_encomenda_id%TYPE,
    data_registo_entrega_pagamento   registo_encomenda.data_registo_entrega_pagamento%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
    VALUES(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento);

    dbms_output.put_line('SUCCESS: registo_encomenda inserted' );

EXCEPTION
    WHEN OTHERS THEN
        if data_registo_entrega_pagamento  IS NULL then
            dbms_output.put_line('FAILED: data_registo_entrega_pagamento cannot be null');
        ELSIF cliente_id IS NULL THEN
            dbms_output.put_line('FAILED: cliente_id cannot be null');
        ELSIF data_estimada_entrega IS NULL THEN
            dbms_output.put_line('FAILED: data_estimada_entrega cannot be null');
        ELSIF gestor_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: gestor_agricola_id cannot be null');
        ELSIF estado_encomenda_id IS NULL THEN
            dbms_output.put_line('FAILED: estado_encomenda_id cannot be null');
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing registo_encomenda -----------');


    -- pass
    test_registo_encomenda(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('10/02/2022 12:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_registo_encomenda(NULL,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('10/02/2022 12:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_registo_encomenda(1,NULL,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('10/02/2022 12:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_registo_encomenda(1,9,NULL,1,TO_DATE('10/02/2022 12:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_registo_encomenda(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,TO_DATE('10/02/2022 12:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_registo_encomenda(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),1,NULL);


    dbms_output.new_line();
END;
/

create or replace procedure test_pagamento(
    valor_pagamento                  pagamento.valor_pagamento%TYPE,
    data_pagamento                   pagamento.data_pagamento%TYPE,
    cliente_id                       pagamento.cliente_id%TYPE,
    gestor_agricola_id               pagamento.gestor_agricola_id%TYPE,
    data_estimada_entrega            pagamento.data_estimada_entrega%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO pagamento(valor_pagamento,data_pagamento,cliente_id,gestor_agricola_id,data_estimada_entrega)
    VALUES(valor_pagamento,data_pagamento,cliente_id,gestor_agricola_id,data_estimada_entrega);

    dbms_output.put_line('SUCCESS: pagamento inserted' );

EXCEPTION
    WHEN OTHERS THEN
        if data_pagamento  IS NULL then
            dbms_output.put_line('FAILED: data_pagamento cannot be null');
        ELSIF cliente_id IS NULL THEN
            dbms_output.put_line('FAILED: cliente_id cannot be null');
        ELSIF data_estimada_entrega IS NULL THEN
            dbms_output.put_line('FAILED: data_estimada_entrega cannot be null');
        ELSIF gestor_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: gestor_agricola_id cannot be null');
        ELSIF valor_pagamento <= 0 THEN
            dbms_output.put_line('FAILED: valor_pagamento cannot be <= 0');
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing registo_encomenda -----------');


    -- pass
    test_pagamento(6000,TO_DATE('10/03/2022 12:00','DD/MM/YYYY HH24:MI'),1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_pagamento(0,TO_DATE('10/03/2022 12:00','DD/MM/YYYY HH24:MI'),1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_pagamento(6000,null,1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_pagamento(6000,TO_DATE('10/03/2022 12:00','DD/MM/YYYY HH24:MI'),null,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_pagamento(6000,TO_DATE('10/03/2022 12:00','DD/MM/YYYY HH24:MI'),1,null,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'));

    -- dont pass
    test_pagamento(6000,TO_DATE('10/03/2022 12:00','DD/MM/YYYY HH24:MI'),1,9,null);

    dbms_output.new_line();
END;
/

create or replace procedure test_encomenda_produto(
    cliente_id                       encomenda_produto.cliente_id%TYPE,
    gestor_agricola_id               encomenda_produto.gestor_agricola_id%TYPE,
    data_estimada_entrega            encomenda_produto.data_estimada_entrega%TYPE,
    produto_id                       encomenda_produto.produto_id%TYPE,
    quantidade_ton                   encomenda_produto.quantidade_ton%TYPE
)
AS
BEGIN
    -- Insert rows in a Table

    INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton)
    VALUES(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton);

    dbms_output.put_line('SUCCESS: encomenda produto inserted' );

EXCEPTION
    WHEN OTHERS THEN
        if produto_id  IS NULL then
            dbms_output.put_line('FAILED: produto_id cannot be null');
        ELSIF cliente_id IS NULL THEN
            dbms_output.put_line('FAILED: cliente_id cannot be null');
        ELSIF data_estimada_entrega IS NULL THEN
            dbms_output.put_line('FAILED: data_estimada_entrega cannot be null');
        ELSIF gestor_agricola_id IS NULL THEN
            dbms_output.put_line('FAILED: gestor_agricola_id cannot be null');
        ELSIF quantidade_ton <= 0 THEN
            dbms_output.put_line('FAILED: quantidade_ton cannot be <= 0');
        end if;
END;
/

BEGIN
    dbms_output.put_line('----------- Testing encomenda_produto -----------');


    -- pass
    test_encomenda_produto(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),4,2);

    -- dont pass
    test_encomenda_produto(null,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),4,2);

    -- dont pass
    test_encomenda_produto(1,null,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),4,2);

    -- dont pass
    test_encomenda_produto(1,9,null,4,2);

    -- dont pass
    test_encomenda_produto(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),null,2);

    -- dont pass
     test_encomenda_produto(1,9,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),4,null);

    dbms_output.new_line();
END;
/


--- Cleanup
DROP PROCEDURE test_codigo_postal;
DROP PROCEDURE test_instalacao_agricola;
DROP PROCEDURE test_caderno_campo;
DROP PROCEDURE test_tipo_cultura;
DROP PROCEDURE test_produto;
DROP PROCEDURE test_stock;
DROP PROCEDURE test_tipo_edificio;
DROP PROCEDURE test_edificio;
DROP PROCEDURE test_parcela_agricola;
DROP PROCEDURE test_tipo_fator_producao;
DROP PROCEDURE test_registo_cultura;
DROP PROCEDURE test_formulacao;
DROP PROCEDURE test_fator_producao;
DROP PROCEDURE test_tipo_fertilizacao;
DROP PROCEDURE test_fertilizacao;
DROP PROCEDURE test_tipo_composto;
DROP PROCEDURE test_composto;
DROP PROCEDURE test_ficha_tecnica;
DROP PROCEDURE test_instalacao_agricola_fator_producao;
DROP PROCEDURE test_tipo_utilizador;
DROP PROCEDURE test_tipo_cliente;
DROP PROCEDURE test_utilizador;
DROP PROCEDURE test_gestor_agricola;
DROP PROCEDURE test_hub;
DROP PROCEDURE test_incidente;
DROP PROCEDURE test_estado_encomenda;
DROP PROCEDURE test_encomenda;
DROP PROCEDURE test_registo_encomenda;
DROP PROCEDURE test_pagamento;
DROP PROCEDURE test_encomenda_produto;
