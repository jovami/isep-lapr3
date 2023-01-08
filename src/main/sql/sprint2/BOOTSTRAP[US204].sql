DROP TABLE localizacao CASCADE CONSTRAINTS PURGE ;
DROP TABLE instalacao_agricola CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_edificio CASCADE CONSTRAINTS PURGE ;
DROP TABLE edificio CASCADE CONSTRAINTS PURGE ;
DROP TABLE parcela_agricola CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_cultura CASCADE CONSTRAINTS PURGE ;
DROP TABLE produto CASCADE CONSTRAINTS PURGE ;
DROP TABLE stock_produto CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_colheita CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_sensor CASCADE CONSTRAINTS PURGE ;
DROP TABLE sensor CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_dado_meteorologico CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_rega CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_sistema CASCADE CONSTRAINTS PURGE ;
DROP TABLE plano_rega CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_rega CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_fator_producao CASCADE CONSTRAINTS PURGE ;
DROP TABLE formulacao CASCADE CONSTRAINTS PURGE ;
DROP TABLE fator_producao CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_composto CASCADE CONSTRAINTS PURGE ;
DROP TABLE composto CASCADE CONSTRAINTS PURGE ;
DROP TABLE ficha_tecnica CASCADE CONSTRAINTS PURGE ;
DROP TABLE stock_fator_producao CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_fertilizacao CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_fertilizacao CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_restricao CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_hub CASCADE CONSTRAINTS PURGE ;
DROP TABLE hub CASCADE CONSTRAINTS PURGE ;
DROP TABLE gestor_agricola CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_contrato_gestor_agricola CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_cliente CASCADE CONSTRAINTS PURGE ;
DROP TABLE cliente CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_estado_encomenda CASCADE CONSTRAINTS PURGE ;
DROP TABLE encomenda CASCADE CONSTRAINTS PURGE ;
DROP TABLE incidente CASCADE CONSTRAINTS PURGE ;
DROP TABLE registo_encomenda_produto CASCADE CONSTRAINTS PURGE ;




/*..........................................................*/
/*..........................................................*/
/*....................CREATE TABLE.........................*/


CREATE TABLE localizacao (

    localizacao_id              INTEGER GENERATED AS IDENTITY CONSTRAINT pk_localizacao_id   PRIMARY KEY,
    latitude                    NUMBER(15,9) CONSTRAINT ck_localizacao_latitude  	CHECK( latitude >= -90 and latitude <= 90 ),
    longitude                   NUMBER(15,9) CONSTRAINT ck_localizacao_longitude 	CHECK( longitude >= -180 and longitude <= 180 )
); 


CREATE TABLE instalacao_agricola (
    instalacao_agricola_id      INTEGER GENERATED AS IDENTITY CONSTRAINT pk_instalacao_agricola_id  PRIMARY KEY,  
    nome                        VARCHAR(40)     CONSTRAINT nn_instalacao_agricola_nome              NOT NULL,
    localizacao_id              INTEGER REFERENCES localizacao(localizacao_id)                      NOT NULL
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


CREATE TABLE tipo_cultura (
    tipo_cultura_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_cultura_id  PRIMARY KEY,
    designacao                  VARCHAR(40) CONSTRAINT un_tipo_cultura_designacao            UNIQUE
);


CREATE TABLE produto (
    produto_id                    INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_produto_id  PRIMARY KEY,
    valor_mercado_por_ha          NUMBER(15,4) CONSTRAINT ck_produto_valor_mercado_por_ha      CHECK(valor_mercado_por_ha >= 0),
    designacao                    VARCHAR(40) CONSTRAINT un_produto_id_designacao              UNIQUE  
);


CREATE TABLE stock_produto (
        
    produto_id                    INTEGER REFERENCES produto(produto_id)                            NOT NULL,
    instalacao_agricola_id        INTEGER REFERENCES instalacao_agricola(instalacao_agricola_id)    NOT NULL,
    ano                           INTEGER,
    CONSTRAINT pk_stock_produto   PRIMARY KEY(produto_id,instalacao_agricola_id,ano),
    
    stock_ton                     NUMBER(15,4) CONSTRAINT ck_stock_ton                              CHECK(stock_ton >= 0)
);


CREATE TABLE registo_colheita (

     parcela_agricola_id                INTEGER REFERENCES parcela_agricola(parcela_agricola_id)        NOT NULL,
     produto_id                         INTEGER REFERENCES produto(produto_id)                          NOT NULL,
     tipo_cultura_id                    INTEGER REFERENCES tipo_cultura(tipo_cultura_id)                NOT NULL,
     data_plantacao                     DATE    CONSTRAINT nn_registo_colheita_data_plantacao            NOT NULL,
     CONSTRAINT pk_registo_cultura      PRIMARY KEY(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao),
     
     area_plantada_ha                   NUMBER(15,4) CONSTRAINT ck_registo_colheita_area_plantada_ha                CHECK(area_plantada_ha > 0),
     data_colheita                      DATE ,                                                                
     quantidade_colhida_ton_por_ha      NUMBER(15,4) CONSTRAINT ck_registo_colheita_quantidade_colhida_ton_por_ha  CHECK(quantidade_colhida_ton_por_ha >= 0)
);


CREATE TABLE tipo_sensor (
    
    tipo_sensor_id        INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_sensor_sensor_id  PRIMARY KEY,
    designacao            VARCHAR(70) CONSTRAINT ck_tipo_sensor_designacao CHECK(designacao ='HS' OR
                                                                            designacao = 'PI' OR
                                                                            designacao = 'TS' OR
                                                                            designacao = 'VV' OR
                                                                            designacao = 'TA' OR
                                                                            designacao = 'HA' OR
                                                                            designacao = 'PA') 
);
    

CREATE TABLE sensor(
    
    sensor_id               VARCHAR(5) CONSTRAINT pk_sensor_id  PRIMARY KEY,
    valor_referencia        INTEGER CONSTRAINT un_sensor_valor_referencia   UNIQUE,
    
    tipo_sensor_id          INTEGER REFERENCES tipo_sensor(tipo_sensor_id) NOT NULL
);


CREATE TABLE registo_dado_meteorologico(

    parcela_agricola_id                 INTEGER REFERENCES parcela_agricola(parcela_agricola_id)            NOT NULL,
    sensor_id                           VARCHAR(5) REFERENCES sensor(sensor_id)                                NOT NULL,
    data_instante_leitura               DATE CONSTRAINT nn_registo_dado_meteorologico_data_instante_leitura    NOT NULL,
    CONSTRAINT pk_dado_meteorologico    PRIMARY KEY(parcela_agricola_id,sensor_id,data_instante_leitura),
    
    valor_lido                          INTEGER CONSTRAINT ck_registo_dado_meteorologico_valor_lido CHECK(valor_lido >= 0 AND valor_lido <= 100)
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

    plano_rega_id                   INTEGER GENERATED AS IDENTITY CONSTRAINT pk_plano_rega_id  PRIMARY KEY,
    
    parcela_agricola_id             INTEGER CONSTRAINT nn_plano_rega_parcela_agricola_id            NOT NULL,
    produto_id                      INTEGER CONSTRAINT nn_plano_rega_produto_id                     NOT NULL,
    tipo_cultura_id                 INTEGER CONSTRAINT nn_plano_rega_tipo_cultura_id                NOT NULL,
    data_plantacao                  DATE    CONSTRAINT nn_plano_rega_data_plantacao                 NOT NULL,
    
    CONSTRAINT fk_plano_rega        FOREIGN KEY(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao) REFERENCES
                                                registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao),
    
    periodicidade_rega_hh          INTEGER CONSTRAINT ck_plano_rega_periodicidade_rega_hh           CHECK(periodicidade_rega_hh > 0), --de quantas em quantas horas
    tempo_rega_mm                  INTEGER CONSTRAINT ck_plano_rega_tempo_rega_mm                   CHECK(tempo_rega_mm > 0) --tempo rega em minutos
);


CREATE TABLE registo_rega (

    parcela_agricola_id             INTEGER CONSTRAINT nn_registo_rega_parcela_agricola_id            NOT NULL,
    produto_id                      INTEGER CONSTRAINT nn_registo_rega_produto_id                     NOT NULL,
    tipo_cultura_id                 INTEGER CONSTRAINT nn_registo_rega_tipo_cultura_id                NOT NULL,
    data_plantacao                  DATE    CONSTRAINT nn_registo_rega_data_plantacao                 NOT NULL,
    data_realizacao                 DATE    CONSTRAINT nn_registo_rega_data_realizacao                NOT NULL,
    
    CONSTRAINT pk_registo_rega        PRIMARY KEY(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,data_realizacao),
    
    CONSTRAINT fk_registo_rega        FOREIGN KEY(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao) REFERENCES
                                                registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao),
      
    quantidade_rega                     NUMBER(15,4) CONSTRAINT ck_rega_executada_quantidade_rega      CHECK(quantidade_rega > 0 ),
    tempo_rega_mm                       INTEGER CONSTRAINT ck_rega_executada_tempo_rega_mm             CHECK(tempo_rega_mm > 0),
    
    tipo_rega_id                        INTEGER REFERENCES tipo_rega(tipo_rega_id)                     NOT NULL, 
    tipo_sistema_id                     INTEGER REFERENCES tipo_sistema(tipo_sistema_id)               NOT NULL 
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


CREATE TABLE stock_fator_producao (
    instalacao_agricola_id            INTEGER REFERENCES instalacao_agricola(instalacao_agricola_id)                NOT NULL, 
    fator_producao_id                 INTEGER REFERENCES fator_producao(fator_producao_id)                          NOT NULL,
    ano                               INTEGER,
    CONSTRAINT pk_instalacao_agricola_fator_producao     PRIMARY KEY (instalacao_agricola_id,fator_producao_id,ano),
    
    quantidade_kg                     NUMBER(15,4) CONSTRAINT ck_stock_fator_producao_quantidade_kg    CHECK(quantidade_kg >= 0)
);


CREATE TABLE tipo_fertilizacao (

    tipo_fertilizacao_id   INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_fertilizacao_id  PRIMARY KEY,
    designacao             VARCHAR(40) CONSTRAINT ck_un_tipo_fertilizacao_designacao CHECK(designacao ='aplicacao direta solo' OR 
                                                                                           designacao ='fetirrega' OR 
                                                                                           designacao ='foliar') UNIQUE

);


CREATE TABLE registo_fertilizacao (

    parcela_agricola_id                    INTEGER REFERENCES parcela_agricola(parcela_agricola_id)         NOT NULL, 
    fator_producao_id                      INTEGER REFERENCES fator_producao(fator_producao_id)             NOT NULL, 
    data_fertilizacao                      DATE CONSTRAINT nn_registo_fertilizacao_data_fertilizacao        NOT NULL,
    CONSTRAINT pk_registo_fertilizacao     PRIMARY KEY(parcela_agricola_id,fator_producao_id,data_fertilizacao),
    
    quantidade_utilizada_kg                NUMBER(15,4) CONSTRAINT ck_registo_fertilizacao_quantidade_utilizada_kg  CHECK(quantidade_utilizada_kg > 0), 
    tipo_fertilizacao_id                   INTEGER REFERENCES tipo_fertilizacao(tipo_fertilizacao_id)       NOT NULL 
);


CREATE TABLE registo_restricao (

    parcela_agricola_id                    INTEGER REFERENCES parcela_agricola(parcela_agricola_id)         NOT NULL, 
    fator_producao_id                      INTEGER REFERENCES fator_producao(fator_producao_id)             NOT NULL, 
    data_inicio                            DATE CONSTRAINT nn_registo_restricao_data_inicio                 NOT NULL,
    CONSTRAINT pk_registo_restricao        PRIMARY KEY(parcela_agricola_id,fator_producao_id,data_inicio),
    
    data_fim                               DATE
);
    

CREATE TABLE tipo_hub (

    tipo_hub_id                  INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_hub_id       PRIMARY KEY,
    designacao                   VARCHAR(40)     CONSTRAINT un_tipo_hub_designacao             UNIQUE
);


CREATE TABLE hub (

    hub_id                  VARCHAR(10) CONSTRAINT pk_hub_id                        PRIMARY KEY,
    tipo_hub_id             INTEGER REFERENCES tipo_hub(tipo_hub_id)                NOT NULL,
    localizacao_id          INTEGER REFERENCES localizacao(localizacao_id)          NOT NULL
);


CREATE TABLE gestor_agricola (

    gestor_agricola_id                INTEGER GENERATED AS IDENTITY CONSTRAINT pk_gestor_agricola_id       PRIMARY KEY,
    nome                              VARCHAR(40)     CONSTRAINT nn_gestor_agricola_nome                        NOT NULL,
    email                             VARCHAR(40)     CONSTRAINT un_gestor_agricola_email                       UNIQUE,
    numero_fiscal                     INTEGER         CONSTRAINT un_gestor_agricola_numero_fiscal               UNIQUE
);


CREATE TABLE registo_contrato_gestor_agricola (

    gestor_agricola_id                INTEGER REFERENCES gestor_agricola(gestor_agricola_id)                    NOT NULL, 
    instalacao_agricola_id            INTEGER REFERENCES instalacao_agricola(instalacao_agricola_id)            NOT NULL,  
    data_inicio_contrato              DATE CONSTRAINT nn_registo_contrato_gestor_agricola_data_inicio_contrato  NOT NULL,
    CONSTRAINT pk_gestor_agricola     PRIMARY KEY (gestor_agricola_id,instalacao_agricola_id,data_inicio_contrato),
    
    data_fim_contrato          DATE 
);


CREATE TABLE tipo_cliente (

     tipo_cliente_id         INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_cliente_id    PRIMARY KEY,
     designacao              VARCHAR(40) CONSTRAINT ck_un_tipo_cliente_designacao CHECK(designacao ='A' OR 
                                                                                        designacao ='B'  OR 
                                                                                        designacao ='C') UNIQUE
);


CREATE TABLE cliente (

     codigo_interno                     INTEGER         CONSTRAINT pk_cliente_codigo_interno      PRIMARY KEY,
     nome                               VARCHAR(40)     CONSTRAINT nn_cliente_nome                NOT NULL,
     email                              VARCHAR(40)     CONSTRAINT un_cliente_email               UNIQUE,
     numero_fiscal                      INTEGER         CONSTRAINT un_cliente_numero_fiscal       UNIQUE, 
     plafond                            NUMBER(15,2)    CONSTRAINT ck_cliente_plafond             CHECK(plafond >= 0 OR plafond = NULL), 
     numero_incidentes                  INTEGER         CONSTRAINT ck_cliente_numero_incidentes   CHECK(numero_incidentes >= 0 OR numero_incidentes = NULL),
     data_ultimo_incidente              DATE,
     numero_encomendas_ultimo_ano       INTEGER         CONSTRAINT ck_cliente_numero_encomendas_ultimo_ano  CHECK(numero_encomendas_ultimo_ano >= 0 OR numero_encomendas_ultimo_ano = NULL),
     valor_total_encomendas_ultimo_ano  NUMBER(15,2)    CONSTRAINT ck_cliente_valor_total_encomendas_ultimo_ano    CHECK(valor_total_encomendas_ultimo_ano >= 0 OR valor_total_encomendas_ultimo_ano = NULL),
     
     tipo_cliente                       INTEGER REFERENCES tipo_cliente(tipo_cliente_id)           NOT NULL,
     hub_por_defeito_id                 VARCHAR(10) REFERENCES hub(hub_id)                         NOT NULL,
     localizacao_morada_id              INTEGER REFERENCES localizacao(localizacao_id)             NOT NULL
);


CREATE TABLE tipo_estado_encomenda (

     tipo_estado_encomenda_id       INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_estado_encomenda_id    PRIMARY KEY,
     designacao                     VARCHAR(40) CONSTRAINT ck_un_estado_encomenda_designacao CHECK(designacao ='registado' OR 
                                                                                                    designacao ='entregue'  OR 
                                                                                                    designacao ='pago') UNIQUE
);


CREATE TABLE encomenda (

    encomenda_id                    INTEGER GENERATED AS IDENTITY CONSTRAINT pk_encomenda_id        PRIMARY KEY,
    
    cliente_codigo_interno          INTEGER REFERENCES cliente(codigo_interno)                      NOT NULL,
    gestor_agricola_id              INTEGER REFERENCES gestor_agricola(gestor_agricola_id)          NOT NULL,
    data_estimada_entrega           DATE CONSTRAINT nn_encomenda_data_estimada_entrega              NOT NULL,  
    CONSTRAINT un_combinacao        UNIQUE (cliente_codigo_interno,gestor_agricola_id,data_estimada_entrega),
    
    valor_encomenda                 NUMBER(10,2) CONSTRAINT ck_encomenda_valor_encomenda         CHECK(valor_encomenda > 0),
    data_limite_pagamento           DATE CONSTRAINT nn_encomenda_data_limite_pagamento           NOT NULL,
    endereco_entrega                VARCHAR(40) ,                               --pode ser null caso a morada seja um hub ou a do proprio cliente
    data_registo                    DATE CONSTRAINT nn_encomenda_data_registo                    NOT NULL,
    data_entrega                    DATE,                                       --pode ser null a quando da criacao da encomenda esta ainda nao foi entregue
    data_pagamento                  DATE,                                       --pode ser null a quando da criacao da encomenda esta pode nao ser logo paga
    
    hub_id                          VARCHAR(10) REFERENCES hub(hub_id),         --pode ser null caso a morada nao seja um hub
    tipo_estado_encomenda           INTEGER REFERENCES tipo_estado_encomenda(tipo_estado_encomenda_id) NOT NULL
);


CREATE TABLE incidente (

    incidente_id                  INTEGER GENERATED AS IDENTITY CONSTRAINT pk_incidente_id    PRIMARY KEY,
    valor_incidente               NUMBER(10,2) CONSTRAINT ck_incidente_valor_incidente        CHECK(valor_incidente > 0),  
    data_incidente                DATE CONSTRAINT nn_incidente_data_incidente                 NOT NULL,
    data_incidente_liquidado      DATE, 
    
    encomenda_id                  INTEGER REFERENCES encomenda(encomenda_id) NOT NULL
);



CREATE TABLE registo_encomenda_produto (

    encomenda_id                        INTEGER REFERENCES encomenda(encomenda_id)                  NOT NULL,
    produto_id                          INTEGER REFERENCES produto(produto_id)                      NOT NULL, 
    CONSTRAINT pk_encomenda_produto     PRIMARY KEY (encomenda_id,produto_id),
    
    quantidade_ton                      NUMBER(15,4) CONSTRAINT ck_encomenda_produto_quantidade_ton    CHECK(quantidade_ton > 0)
);


---------------------------
----------[US204]----------
---------------------------

--LOCALIZACAO INSTALACAO AGRICOLA
INSERT INTO localizacao(latitude,longitude)  VALUES (38.5241,-8.8921);
INSERT INTO localizacao(latitude,longitude)  VALUES (39.3161,-7.4161);

--LOCALIZACAO HUB
INSERT INTO localizacao(latitude,longitude)  VALUES (40.3161,-5.4165);
INSERT INTO localizacao(latitude,longitude)  VALUES (41.3161,-6.4165);
INSERT INTO localizacao(latitude,longitude)  VALUES (42.3161,-9.4165);

--LOCALIZACAO CLIENTE
INSERT INTO localizacao(latitude,longitude)  VALUES (51.3161,-17.4165);
INSERT INTO localizacao(latitude,longitude)  VALUES (52.3161,-27.4165);
INSERT INTO localizacao(latitude,longitude)  VALUES (53.3161,-37.4165);
INSERT INTO localizacao(latitude,longitude)  VALUES (54.3161,-47.4165);
INSERT INTO localizacao(latitude,longitude)  VALUES (55.3161,-57.4165);

-----------------------------------------------------------------------
------------------------------EDIFICIOS--------------------------------
-----------------------------------------------------------------------

INSERT INTO instalacao_agricola(nome,localizacao_id) VALUES ('INSTALACAO G31 LAPR3', 1);
INSERT INTO instalacao_agricola(nome,localizacao_id) VALUES ('INSTALACAO G3X LAPR3', 2);

INSERT INTO tipo_edificio(designacao) VALUES ('armazem');
INSERT INTO tipo_edificio(designacao) VALUES ('garagem');
INSERT INTO tipo_edificio(designacao) VALUES ('estabulo');

INSERT INTO edificio(designacao,area_ha,tipo_edificio_id,instalacao_agricola_id) VALUES ('Almada', 1500.20, 1, 1);
INSERT INTO edificio(designacao,area_ha,tipo_edificio_id,instalacao_agricola_id) VALUES ('Lapa', 1300.10, 2, 1);
INSERT INTO edificio(designacao,area_ha,tipo_edificio_id,instalacao_agricola_id) VALUES ('Zapa', 1600.50, 3, 1);

INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id) VALUES ('Balmada', 1100.20, 1);
INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id) VALUES ('Japa', 1000.10, 1);
INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id) VALUES ('Opat', 200.50, 1);
INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id) VALUES ('Xat', 500, 1);

-----------------------------------------------------------------------
------------------------------PLANTACOES-------------------------------
-----------------------------------------------------------------------

INSERT INTO tipo_cultura(designacao) VALUES ('temporaria');
INSERT INTO tipo_cultura(designacao) VALUES ('permanente');

INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (1000,'rosas');
INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (2000,'macas');
INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (3000,'trigo');
INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (0,'adubacao verde');

INSERT INTO stock_produto(produto_id, instalacao_agricola_id, ano, stock_ton) VALUES (1,1,2021,100);
INSERT INTO stock_produto(produto_id, instalacao_agricola_id, ano, stock_ton) VALUES (2,1,2021,190);
INSERT INTO stock_produto(produto_id, instalacao_agricola_id, ano, stock_ton) VALUES (3,1,2021,240);
INSERT INTO stock_produto(produto_id, instalacao_agricola_id, ano, stock_ton) VALUES (4,1,2021,200);

INSERT INTO stock_produto(produto_id, instalacao_agricola_id, ano, stock_ton) VALUES (1,1,2022,100);
INSERT INTO stock_produto(produto_id, instalacao_agricola_id, ano, stock_ton) VALUES (2,1,2022,190);
INSERT INTO stock_produto(produto_id, instalacao_agricola_id, ano, stock_ton) VALUES (3,1,2022,240);
INSERT INTO stock_produto(produto_id, instalacao_agricola_id, ano, stock_ton) VALUES (4,1,2022,200);


--Parcela agricola com 2 produtos la plantados
INSERT INTO registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)
            VALUES (1,1,1,TO_DATE('04/01/2021 10:00','DD/MM/YYYY HH24:MI'),50,TO_DATE('20/12/2021 12:00','DD/MM/YYYY HH24:MI'),100);
INSERT INTO registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)
            VALUES (1,2,1,TO_DATE('04/01/2021 10:30','DD/MM/YYYY HH24:MI'),40,TO_DATE('20/12/2021 12:00','DD/MM/YYYY HH24:MI'),90);

--Parcela agricola com 2 produtos la plantados                            
INSERT INTO registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)  
            VALUES (2,2,1,TO_DATE('04/01/2021 12:00','DD/MM/YYYY HH24:MI'),30,TO_DATE('21/12/2021 12:00','DD/MM/YYYY HH24:MI'),100);
INSERT INTO registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha) 
            VALUES (2,3,2,TO_DATE('04/01/2021 12:30','DD/MM/YYYY HH24:MI'),20,TO_DATE('21/12/2021 12:00','DD/MM/YYYY HH24:MI'),90);

--Parcela agricola com 1 produto plantado            
INSERT INTO registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)  
            VALUES (3,3,2,TO_DATE('04/01/2021 16:00','DD/MM/YYYY HH24:MI'),20,TO_DATE('22/12/2021 12:00','DD/MM/YYYY HH24:MI'),150);

--Parcela agricola com 1 produto plantado            
INSERT INTO registo_colheita(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)  
            VALUES (4,4,1,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);

-----------------------------------------------------------------------
---------------------------------SENSORES------------------------------
-----------------------------------------------------------------------

INSERT INTO tipo_sensor(designacao) VALUES ('HS'); 
INSERT INTO tipo_sensor(designacao) VALUES ('PI'); 
INSERT INTO tipo_sensor(designacao) VALUES ('TS'); 
INSERT INTO tipo_sensor(designacao) VALUES ('VV'); 
INSERT INTO tipo_sensor(designacao) VALUES ('TA'); 
INSERT INTO tipo_sensor(designacao) VALUES ('HA');
INSERT INTO tipo_sensor(designacao) VALUES ('PA'); 

INSERT INTO sensor(sensor_id,valor_referencia, tipo_sensor_id) VALUES ('SENS1',111,1);
INSERT INTO sensor(sensor_id,valor_referencia, tipo_sensor_id) VALUES ('SENS2',222,2); 
INSERT INTO sensor(sensor_id,valor_referencia, tipo_sensor_id) VALUES ('SENS3',333,3); 
INSERT INTO sensor(sensor_id,valor_referencia, tipo_sensor_id) VALUES ('SENS4',444,4); 
INSERT INTO sensor(sensor_id,valor_referencia, tipo_sensor_id) VALUES ('SENS5',555,5); 
INSERT INTO sensor(sensor_id,valor_referencia, tipo_sensor_id) VALUES ('SENS6',666,6); 
INSERT INTO sensor(sensor_id,valor_referencia, tipo_sensor_id) VALUES ('SENS7',777,7);

-----------------------------------------------------------------------
---------------------------------DADOS MEDIDOS-------------------------
-----------------------------------------------------------------------

--dados medidos na parcela agricola 1
INSERT INTO registo_dado_meteorologico(parcela_agricola_id,sensor_id,data_instante_leitura,valor_lido) VALUES (1,'SENS1',TO_DATE('05/01/2021 12:00','DD/MM/YYYY HH24:MI'),20);
INSERT INTO registo_dado_meteorologico(parcela_agricola_id,sensor_id,data_instante_leitura,valor_lido) VALUES (1,'SENS2',TO_DATE('05/01/2021 12:01','DD/MM/YYYY HH24:MI'),30);
INSERT INTO registo_dado_meteorologico(parcela_agricola_id,sensor_id,data_instante_leitura,valor_lido) VALUES (1,'SENS3',TO_DATE('05/01/2021 12:02','DD/MM/YYYY HH24:MI'),40);

--dados medidos na parcela agricola 2
INSERT INTO registo_dado_meteorologico(parcela_agricola_id,sensor_id,data_instante_leitura,valor_lido) VALUES (2,'SENS4',TO_DATE('05/01/2021 12:03','DD/MM/YYYY HH24:MI'),30);
INSERT INTO registo_dado_meteorologico(parcela_agricola_id,sensor_id,data_instante_leitura,valor_lido) VALUES (2,'SENS5',TO_DATE('05/01/2021 12:04','DD/MM/YYYY HH24:MI'),40);
INSERT INTO registo_dado_meteorologico(parcela_agricola_id,sensor_id,data_instante_leitura,valor_lido) VALUES (2,'SENS6',TO_DATE('05/01/2021 12:05','DD/MM/YYYY HH24:MI'),50);
INSERT INTO registo_dado_meteorologico(parcela_agricola_id,sensor_id,data_instante_leitura,valor_lido) VALUES (2,'SENS7',TO_DATE('05/01/2021 12:06','DD/MM/YYYY HH24:MI'),90);

-----------------------------------------------------------------------
---------------------------------REGAS---------------------------------
-----------------------------------------------------------------------

INSERT INTO tipo_rega(designacao) VALUES('pulverizacao');
INSERT INTO tipo_rega(designacao) VALUES('gotejamento');
INSERT INTO tipo_rega(designacao) VALUES('asprecao');

INSERT INTO tipo_sistema(designacao) VALUES('gravidade');
INSERT INTO tipo_sistema(designacao) VALUES('bombeada');


--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=1 PARA o produto_id=1
INSERT INTO plano_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (1,1,1,TO_DATE('04/01/2021 10:00','DD/MM/YYYY HH24:MI'),24,30);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=1 PARA o produto_id=1           
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,1,1,TO_DATE('04/01/2021 10:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('06/01/2021 12:00','DD/MM/YYYY HH24:MI'),1000,30,1,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,1,1,TO_DATE('04/01/2021 10:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('07/01/2021 12:00','DD/MM/YYYY HH24:MI'),500,30,2,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,1,1,TO_DATE('04/01/2021 10:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('08/01/2021 12:00','DD/MM/YYYY HH24:MI'),100,30,3,2);


--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=1 PARA o produto_id=2
INSERT INTO plano_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (1,2,1,TO_DATE('04/01/2021 10:30','DD/MM/YYYY HH24:MI'),12,30);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=1 PARA o produto_id=2           
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,2,1,TO_DATE('04/01/2021 10:30','DD/MM/YYYY HH24:MI'),
            TO_DATE('06/01/2021 12:00','DD/MM/YYYY HH24:MI'),1001,30,1,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,2,1,TO_DATE('04/01/2021 10:30','DD/MM/YYYY HH24:MI'),
            TO_DATE('07/01/2021 12:00','DD/MM/YYYY HH24:MI'),501,30,2,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,2,1,TO_DATE('04/01/2021 10:30','DD/MM/YYYY HH24:MI'),
            TO_DATE('08/01/2021 12:00','DD/MM/YYYY HH24:MI'),101,30,3,2);


--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=2 PARA o produto_id=2
INSERT INTO plano_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (2,2,1,TO_DATE('04/01/2021 12:00','DD/MM/YYYY HH24:MI'),24,35);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=2 PARA o produto_id=2           
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(2,2,1,TO_DATE('04/01/2021 12:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('06/01/2021 12:00','DD/MM/YYYY HH24:MI'),1002,35,1,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(2,2,1,TO_DATE('04/01/2021 12:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('07/01/2021 12:00','DD/MM/YYYY HH24:MI'),502,35,2,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(2,2,1,TO_DATE('04/01/2021 12:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('08/01/2021 12:00','DD/MM/YYYY HH24:MI'),102,35,3,2);


--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=2 PARA o produto_id=3
INSERT INTO plano_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (2,3,2,TO_DATE('04/01/2021 12:30','DD/MM/YYYY HH24:MI'),12,35);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=2 PARA o produto_id=3           
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(2,3,2,TO_DATE('04/01/2021 12:30','DD/MM/YYYY HH24:MI'),
            TO_DATE('06/01/2021 12:00','DD/MM/YYYY HH24:MI'),1003,35,1,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(2,3,2,TO_DATE('04/01/2021 12:30','DD/MM/YYYY HH24:MI'),
            TO_DATE('07/01/2021 12:00','DD/MM/YYYY HH24:MI'),503,35,2,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(2,3,2,TO_DATE('04/01/2021 12:30','DD/MM/YYYY HH24:MI'),
            TO_DATE('08/01/2021 12:00','DD/MM/YYYY HH24:MI'),103,35,3,2);           


--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=3 PARA o produto_id=3
INSERT INTO plano_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (3,3,2,TO_DATE('04/01/2021 16:00','DD/MM/YYYY HH24:MI'),12,40);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=3 PARA o produto_id=3           
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(3,3,2,TO_DATE('04/01/2021 16:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('06/01/2021 12:00','DD/MM/YYYY HH24:MI'),1004,40,1,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(3,3,2,TO_DATE('04/01/2021 16:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('07/01/2021 12:00','DD/MM/YYYY HH24:MI'),504,40,2,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(3,3,2,TO_DATE('04/01/2021 16:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('08/01/2021 12:00','DD/MM/YYYY HH24:MI'),104,40,3,2);
            

--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=4 PARA o produto_id=4
INSERT INTO plano_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (4,4,1,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),24,45);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=4 PARA o produto_id=4           
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(4,4,1,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('06/01/2021 12:00','DD/MM/YYYY HH24:MI'),1005,45,1,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(4,4,1,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('07/01/2021 12:00','DD/MM/YYYY HH24:MI'),505,45,2,1);
INSERT INTO registo_rega(parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(4,4,1,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('08/01/2021 12:00','DD/MM/YYYY HH24:MI'),105,45,3,2);  

-----------------------------------------------------------------------
-------------------------FATORES DE PRODUCAO---------------------------
---------------------E COISAS QUE ENVOLVAM ESTES-----------------------

INSERT INTO tipo_fator_producao(designacao) VALUES ('fertilizante');
INSERT INTO tipo_fator_producao(designacao) VALUES ('adubo');
INSERT INTO tipo_fator_producao(designacao) VALUES ('correctivo mineral');
INSERT INTO tipo_fator_producao(designacao) VALUES ('produto fitofarmaco');

INSERT INTO formulacao(designacao) VALUES ('liquido');
INSERT INTO formulacao(designacao) VALUES ('granulado');
INSERT INTO formulacao(designacao) VALUES ('po');

INSERT INTO fator_producao(nome_comercial,fornecedor,preco_por_kg,formulacao_id,tipo_fator_producao_id)
            VALUES('ENERGIZER','AGRICHEM S.A',10,1,1);
INSERT INTO fator_producao(nome_comercial,fornecedor,preco_por_kg,formulacao_id,tipo_fator_producao_id)
            VALUES('LYSODIN DRY','AGRICHEM S.A',12,1,2);
INSERT INTO fator_producao(nome_comercial,fornecedor,preco_por_kg,formulacao_id,tipo_fator_producao_id)
            VALUES('AUXIGRO PLUS','AGRICHEM S.A',13,2,3);
INSERT INTO fator_producao(nome_comercial,fornecedor,preco_por_kg,formulacao_id,tipo_fator_producao_id)
            VALUES('AMINOLUM ALFAFA','ALFREDO INESTA, SL',13,3,4);

INSERT INTO tipo_composto(designacao) VALUES ('elemento');         
INSERT INTO tipo_composto(designacao) VALUES ('substancia');

INSERT INTO composto(designacao,tipo_composto_id) VALUES ('Azoto organico',1);
INSERT INTO composto(designacao,tipo_composto_id) VALUES ('Pentoxido de fosforo',1);
INSERT INTO composto(designacao,tipo_composto_id) VALUES ('Oxido de potassio',1);
INSERT INTO composto(designacao,tipo_composto_id) VALUES ('Carbono de origem biologica',2);
INSERT INTO composto(designacao,tipo_composto_id) VALUES ('Materia organica',2);
INSERT INTO composto(designacao,tipo_composto_id) VALUES ('Acidos fulvicos',2);

--FICHA TECNICA DO FATOR DE PRODUCAO COM fator_producao_id = 1
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (1,1,'kg',1);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (1,2,'l',2);            
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (1,3,'kg',1);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (1,4,'l',3);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (1,5,'kg',2);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (1,6,'kg',5);
            
--FICHA TECNICA DO FATOR DE PRODUCAO COM fator_producao_id = 2
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (2,1,'kg',10);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (2,2,'l',20);            
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (2,3,'kg',10);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (2,4,'l',30);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (2,5,'kg',20);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (2,6,'kg',50);
            
--FICHA TECNICA DO FATOR DE PRODUCAO COM fator_producao_id = 3
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (3,1,'kg',100);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (3,2,'l',200);            
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (3,3,'kg',100);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (3,4,'l',300);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (3,5,'kg',200);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (3,6,'kg',500);
            
--FICHA TECNICA DO FATOR DE PRODUCAO COM fator_producao_id = 4
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (4,1,'kg',1000);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (4,2,'l',2000);            
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (4,3,'kg',1000);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (4,4,'l',3000);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (4,5,'kg',2000);
INSERT INTO ficha_tecnica(fator_producao_id,composto_id,unidade_medida,quantidade_composto)
            VALUES (4,6,'kg',5000);
            
--NA instalacao_agricola_id = 1 o fator_producao_id=1 TEMOS 100 kg           
INSERT INTO stock_fator_producao(instalacao_agricola_id,fator_producao_id,ano,quantidade_kg)
            VALUES(1,1,2021,100);
            
--NA instalacao_agricola_id = 1 o fator_producao_id=2 TEMOS 1000 kg           
INSERT INTO stock_fator_producao(instalacao_agricola_id,fator_producao_id,ano,quantidade_kg)
            VALUES(1,2,2021,1000);
            
--NA instalacao_agricola_id = 1 o fator_producao_id=3 TEMOS 10000 kg           
INSERT INTO stock_fator_producao(instalacao_agricola_id,fator_producao_id,ano,quantidade_kg)
            VALUES(1,3,2021,10000);
            
--NA instalacao_agricola_id = 1 o fator_producao_id=4 TEMOS 100000 kg           
INSERT INTO stock_fator_producao(instalacao_agricola_id,fator_producao_id,ano,quantidade_kg)
            VALUES(1,4,2021,100000);

-----------------------------------------------------------------------
--------------FERTILIZACOES E RESTRICOES DE FERTILIZACAO---------------
---------------------E COISAS QUE ENVOLVAM ESTES-----------------------

INSERT INTO tipo_fertilizacao(designacao) VALUES ('aplicacao direta solo');
INSERT INTO tipo_fertilizacao(designacao) VALUES ('fetirrega');
INSERT INTO tipo_fertilizacao(designacao) VALUES ('foliar');

--NA parcela_agricola_id=1 E USANDO fator_producao_id=1 , FERTILIZAMOS COM 50kg
INSERT INTO registo_fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(1,1,TO_DATE('03/01/2021 12:00','DD/MM/YYYY HH24:MI'),50,1);
--NA parcela_agricola_id=2 E USANDO fator_producao_id=1 , FERTILIZAMOS COM 50kg
INSERT INTO registo_fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(2,1,TO_DATE('03/01/2021 14:00','DD/MM/YYYY HH24:MI'),50,2);
--NA parcela_agricola_id=3 E USANDO fator_producao_id=1 , FERTILIZAMOS COM 50kg
INSERT INTO registo_fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(3,1,TO_DATE('03/01/2021 16:00','DD/MM/YYYY HH24:MI'),50,3);
--NA parcela_agricola_id=4 E USANDO fator_producao_id=1 , FERTILIZAMOS COM 50kg
INSERT INTO registo_fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(4,1,TO_DATE('03/01/2021 18:00','DD/MM/YYYY HH24:MI'),50,1);


--NA parcela_agricola_id=1 NAO PODE USAR fator_producao_id=2 DENTRO DO TEMPO ESTIPULADO
INSERT INTO registo_restricao(parcela_agricola_id,fator_producao_id,data_inicio,data_fim)
            VALUES(1,2,TO_DATE('01/01/2021 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('31/12/2021 00:00','DD/MM/YYYY HH24:MI'));
--NA parcela_agricola_id=2 NAO PODE USAR fator_producao_id=2 DENTRO DO TEMPO ESTIPULADO            
INSERT INTO registo_restricao(parcela_agricola_id,fator_producao_id,data_inicio,data_fim)
            VALUES(2,2,TO_DATE('01/01/2021 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('31/12/2021 00:00','DD/MM/YYYY HH24:MI'));
--NA parcela_agricola_id=2 NAO PODE USAR fator_producao_id=2 DENTRO DO TEMPO ESTIPULADO            
INSERT INTO registo_restricao(parcela_agricola_id,fator_producao_id,data_inicio,data_fim)
            VALUES(3,2,TO_DATE('01/01/2021 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('31/12/2021 00:00','DD/MM/YYYY HH24:MI'));
--NA parcela_agricola_id=2 NAO PODE USAR fator_producao_id=2 DENTRO DO TEMPO ESTIPULADO            
INSERT INTO registo_restricao(parcela_agricola_id,fator_producao_id,data_inicio,data_fim)
            VALUES(4,2,TO_DATE('01/01/2021 00:00','DD/MM/YYYY HH24:MI'),TO_DATE('31/12/2021 00:00','DD/MM/YYYY HH24:MI'));
            
-----------------------------------------------------------------------
---------------------------------HUBS----------------------------------
-----------------------------------------------------------------------            

INSERT INTO tipo_hub(designacao) VALUES ('P');
INSERT INTO tipo_hub(designacao) VALUES ('E');
            
INSERT INTO hub(hub_id,tipo_hub_id,localizacao_id) VALUES ('CT500',1,3);
INSERT INTO hub(hub_id,tipo_hub_id,localizacao_id) VALUES ('CT501',2,4);
INSERT INTO hub(hub_id,tipo_hub_id,localizacao_id) VALUES ('CT502',2,5);

-----------------------------------------------------------------------
------------------------------GESTOR AGRICOLA--------------------------
-----------------------------------------------------------------------

INSERT INTO gestor_agricola(nome,email,numero_fiscal) VALUES ('Quim','quimisep@isep.ipp.pt',231432462);

--O UTILIZADOR QUIM TRABALHOU EM 2019 O ANO QUASE TODO NA instalacao_agricola_id=1,POSTERIORMENTE
--TRABALHOU NA instalacao_agricola_id=2 NO ANO 2020,VOLTANDO A instalacao_agricola_id=1 EM 2021
INSERT INTO registo_contrato_gestor_agricola(gestor_agricola_id,instalacao_agricola_id,data_inicio_contrato,data_fim_contrato) 
            VALUES (1,1,TO_DATE('01/01/2019 08:00','DD/MM/YYYY HH24:MI'),TO_DATE('12/12/2019 08:00','DD/MM/YYYY HH24:MI'));
INSERT INTO registo_contrato_gestor_agricola(gestor_agricola_id,instalacao_agricola_id,data_inicio_contrato,data_fim_contrato) 
            VALUES (1,2,TO_DATE('01/01/2020 08:00','DD/MM/YYYY HH24:MI'),TO_DATE('12/07/2020 08:00','DD/MM/YYYY HH24:MI'));
INSERT INTO registo_contrato_gestor_agricola(gestor_agricola_id,instalacao_agricola_id,data_inicio_contrato,data_fim_contrato) 
            VALUES (1,1,TO_DATE('01/01/2021 08:00','DD/MM/YYYY HH24:MI'),NULL);

-----------------------------------------------------------------------
------------------------------CLIENTES---------------------------------
-----------------------------------------------------------------------

INSERT INTO tipo_cliente(designacao) VALUES ('A');
INSERT INTO tipo_cliente(designacao) VALUES ('B');
INSERT INTO tipo_cliente(designacao) VALUES ('C');


--cliente joao plafond 100000,incidentes 1, numero encomendas do ultimo ano 1, valor total encomendas 60000, tipo cliente C
INSERT INTO cliente(codigo_interno,nome,email,numero_fiscal,plafond,numero_incidentes,data_ultimo_incidente,numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,
            tipo_cliente,hub_por_defeito_id,localizacao_morada_id) 
            VALUES(1210957,'joao','1210957@isep.ipp.pt',231432459,100000,1,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),1,60000,3,'CT500',6);
            
--cliente jonas plafond 10000,incidentes 0, numero encomendas do ultimo ano 1, valor total encomendas 6000, tipo cliente B
INSERT INTO cliente(codigo_interno,nome,email,numero_fiscal,plafond,numero_incidentes,data_ultimo_incidente,numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,
            tipo_cliente,hub_por_defeito_id,localizacao_morada_id) 
            VALUES(1181478,'jonas','1181478@isep.ipp.pt',231432458,10000,0,NULL,1,6000,2,'CT500',7);

--cliente jose plafond 15000,incidentes 0, numero encomendas do ultimo ano 1, valor total encomendas 12000, tipo cliente A
INSERT INTO cliente(codigo_interno,nome,email,numero_fiscal,plafond,numero_incidentes,data_ultimo_incidente,numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,
            tipo_cliente,hub_por_defeito_id,localizacao_morada_id) 
            VALUES(1211155,'jose','1211155@isep.ipp.pt',231432457,15000,0,NULL,1,12000,1,'CT500',8);
            
INSERT INTO cliente(codigo_interno,nome,email,numero_fiscal,plafond,numero_incidentes,data_ultimo_incidente,numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,
            tipo_cliente,hub_por_defeito_id,localizacao_morada_id) 
            VALUES(1210951,'marco','1210951@isep.ipp.pt',231432456,13000,0,NULL,0,0,1,'CT500',9);
            
INSERT INTO cliente(codigo_interno,nome,email,numero_fiscal,plafond,numero_incidentes,data_ultimo_incidente,numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,
            tipo_cliente,hub_por_defeito_id,localizacao_morada_id) 
            VALUES(1210954,'ruben','1210954@isep.ipp.pt',231432455,15000,0,NULL,0,0,1,'CT500',10);
            
-----------------------------------------------------------------------
----------------------------ENCOMENDAS---------------------------------
---------------------E COISAS QUE ENVOLVAM ESTES-----------------------     

INSERT INTO tipo_estado_encomenda(designacao) VALUES ('registado');
INSERT INTO tipo_estado_encomenda(designacao) VALUES ('entregue');
INSERT INTO tipo_estado_encomenda(designacao) VALUES ('pago');

--VALORES IMPORTANTES A TER EM CONTA:
--codigo_interno=1210957, nome = joao
--codigo_interno=1181478, nome = jonas
--codigo_interno=1211155, nome = jose
--codigo_interno=1210951, nome = marco
--codigo_interno=1210954, nome = ruben

--produto_id= 1 valor_mercado_por_ha = 1000 designacao= rosas;
--produto_id= 2 valor_mercado_por_ha = 2000 designacao= macas;
--produto_id= 3 valor_mercado_por_ha = 3000 designacao= trigo;


--CODIGO_INTERNO=1210957, NOME=JOAO
--produto_id= 1 valor_mercado_por_ha = 10 designacao= rosas;
--produto_id= 2 valor_mercado_por_ha = 20 designacao= macas;
--produto_id= 3 valor_mercado_por_ha = 30 designacao= trigo;
--valor_encomenda = 1000*10 + 2000*10 + 3000*10 = 60000
--codigo_interno=1210957, nome = joao
--teve a sua encomenda registada no dia 10 de fevereiro (tipo_estado_encomenda=1 'registada')
--sendo a sua encomenda entregue no dia 16 de fevereiro, um dia depois da data estimada (tipo_estado_encomenda=2 'entregue')
--efectuou o pagamento no dia 20 de marco
--apos o pagamento feito a encomenda passa a estar  tipo_estado_encomenda=3 'pago'
INSERT INTO encomenda(cliente_codigo_interno,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,
            data_registo,data_entrega,data_pagamento,hub_id,tipo_estado_encomenda)
            VALUES
            (1210957,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'),60000,TO_DATE('15/03/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,
            TO_DATE('10/02/2022 16:00','DD/MM/YYYY HH24:MI'),TO_DATE('16/02/2022 16:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'),'CT501',3);
            
--sendo que gerou um incidente pois a data limite a quando do registo da encomenda era dia 15 de março
INSERT INTO incidente(valor_incidente,data_incidente,data_incidente_liquidado,encomenda_id) 
            VALUES(60000,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'),1);  

--codigo_interno=1210957, nome = joao
--encomendou 10 toneladas de rosas, 10 toneladas de macas e 10 toneladas de trigo, daí o valor 60000 em cima mencionado
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton) 
            VALUES (1,1,10);
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton)  
            VALUES (1,2,10);
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton)  
            VALUES (1,3,10);
 
--Conclusao
--codigo_interno=1210957, nome = joao é um cliente do tipo C nos ultimos 12 meses pois tem um
--incidente apesar de ter 60000 euros em compras 

  
          
--CODIGO_INTERNO=1181478, NOME=JONAS
--produto_id= 1 valor_mercado_por_ha = 10 designacao= rosas;
--produto_id= 2 valor_mercado_por_ha = 20 designacao= macas;
--produto_id= 3 valor_mercado_por_ha = 30 designacao= trigo;
--valor_encomenda = 1000*1 + 2000*1 + 3000*1 = 6000
--teve a sua encomenda registada no dia 10 de fevereiro (tipo_estado_encomenda=1 'registada')
--sendo a sua encomenda entregue no dia 17 de fevereiro, dois dia depois da data estimada (tipo_estado_encomenda=2 'entregue')
--efectuou o pagamento no dia 10 de marco 
--apos o pagamento feito a encomenda passa a estar  tipo_estado_encomenda=3 'pago' 
INSERT INTO encomenda(cliente_codigo_interno,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,
            data_registo,data_entrega,data_pagamento,hub_id,tipo_estado_encomenda)
            VALUES
            (1181478,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'),6000,TO_DATE('15/03/2022 12:00','DD/MM/YYYY HH24:MI'),NULL,
            TO_DATE('10/02/2022 12:00','DD/MM/YYYY HH24:MI'),TO_DATE('17/02/2022 12:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('10/03/2022 12:00','DD/MM/YYYY HH24:MI'),'CT502',3);
 
        
--encomendou 1 toneladas de rosas, 1 toneladas de macas e 1 toneladas de trigo, daí o valor 6000 em cima mencionado
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton) 
            VALUES (2,1,1);
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton) 
            VALUES (2,2,1);
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton) 
            VALUES (2,3,1);            

--Conclusao
--codigo_interno=1181478, nome = jonas é um cliente do tipo B nos ultimos 12 meses pois nao tem
--incidentes mas só possui um valor de 6000 euros em compras


--CODIGO_INTERNO=1211155, NOME=JOSE
--produto_id= 1 valor_mercado_por_ha = 10 designacao= rosas;
--produto_id= 2 valor_mercado_por_ha = 20 designacao= macas;
--produto_id= 3 valor_mercado_por_ha = 30 designacao= trigo;
--valor_encomenda = 1000*2 + 2000*2 + 3000*2 = 12000
--teve a sua encomenda registada no dia 10 de fevereiro (estado_encomenda_id=1 'registada')
--sendo a sua encomenda entregue no dia 18 de fevereiro, TRES dia depois da data estimada (estado_encomenda_id=2 'entregue')
--efectuou o pagamento no dia 10 de marco
--apos o pagamento feito a encomenda passa a estar  estado_encomenda_id=3 'pago'
INSERT INTO encomenda(cliente_codigo_interno,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,
            data_registo,data_entrega,data_pagamento,hub_id,tipo_estado_encomenda)
            VALUES
            (1211155,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),12000,TO_DATE('15/03/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,
            TO_DATE('10/02/2022 10:00','DD/MM/YYYY HH24:MI'),TO_DATE('18/02/2022 12:00','DD/MM/YYYY HH24:MI'),
            TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),'CT501',3);

--encomendou 2 toneladas de rosas, 2 toneladas de macas e 2 toneladas de trigo, daí o valor 12000 em cima mencionado
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton)  
            VALUES (3,1,2);
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton)  
            VALUES (3,2,2);
INSERT INTO registo_encomenda_produto(encomenda_id,produto_id,quantidade_ton)  
            VALUES (3,3,2);      


--Conclusao
--codigo_interno=1211155, nome = jose é um cliente do tipo A nos ultimos 12 meses pois nao tem
--incidentes e possui um valor de 12000 euros em compras


SELECT * FROM localizacao ;
SELECT count(*) AS "linhas/tuplos na tabela localizacao" FROM localizacao;

SELECT * FROM instalacao_agricola ;
SELECT count(*) AS "linhas/tuplos na tabela instalacao_agricola" FROM instalacao_agricola;

SELECT * FROM tipo_edificio ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_edificio" FROM tipo_edificio;

SELECT * FROM edificio ;
SELECT count(*) AS "linhas/tuplos na tabela edificio" FROM edificio;

SELECT * FROM parcela_agricola ;
SELECT count(*) AS "linhas/tuplos na tabela parcela_agricola" FROM parcela_agricola;

SELECT * FROM tipo_cultura ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_cultura" FROM tipo_cultura;

SELECT * FROM produto ;
SELECT count(*) AS "linhas/tuplos na tabela produto" FROM produto;

SELECT * FROM stock_produto ;
SELECT count(*) AS "linhas/tuplos na tabela stock_produto" FROM stock_produto;

SELECT * FROM registo_colheita ;
SELECT count(*) AS "linhas/tuplos na tabela registo_colheita" FROM registo_colheita;

SELECT * FROM tipo_sensor ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_sensor" FROM tipo_sensor;

SELECT * FROM sensor ;
SELECT count(*) AS "linhas/tuplos na tabela sensor" FROM sensor;

SELECT * FROM registo_dado_meteorologico ;
SELECT count(*) AS "linhas/tuplos na tabela registo_dado_meteorologico" FROM registo_dado_meteorologico;

SELECT * FROM tipo_rega ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_rega" FROM tipo_rega;

SELECT * FROM tipo_sistema ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_sistema" FROM tipo_sistema;

SELECT * FROM plano_rega ;
SELECT count(*) AS "linhas/tuplos na tabela plano_rega" FROM plano_rega;

SELECT * FROM registo_rega ;
SELECT count(*) AS "linhas/tuplos na tabela registo_rega" FROM registo_rega;

SELECT * FROM tipo_fator_producao ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_fator_producao" FROM tipo_fator_producao;

SELECT * FROM formulacao ;
SELECT count(*) AS "linhas/tuplos na tabela formulacao" FROM formulacao;

SELECT * FROM fator_producao ;
SELECT count(*) AS "linhas/tuplos na tabela fator_producao" FROM fator_producao;

SELECT * FROM tipo_composto ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_composto" FROM tipo_composto;

SELECT * FROM composto ;
SELECT count(*) AS "linhas/tuplos na tabela composto" FROM composto;

SELECT * FROM ficha_tecnica ;
SELECT count(*) AS "linhas/tuplos na tabela ficha_tecnica" FROM ficha_tecnica;

SELECT * FROM stock_fator_producao ;
SELECT count(*) AS "linhas/tuplos na tabela stock_fator_producao" FROM stock_fator_producao;

SELECT * FROM tipo_fertilizacao ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_fertilizacao" FROM tipo_fertilizacao;

SELECT * FROM registo_fertilizacao ;
SELECT count(*) AS "linhas/tuplos na tabela registo_fertilizacao" FROM registo_fertilizacao;

SELECT * FROM registo_restricao ;
SELECT count(*) AS "linhas/tuplos na tabela registo_restricao" FROM registo_restricao;

SELECT * FROM tipo_hub ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_hub" FROM tipo_hub;

SELECT * FROM hub ;
SELECT count(*) AS "linhas/tuplos na tabela hub" FROM hub;

SELECT * FROM gestor_agricola ;
SELECT count(*) AS "linhas/tuplos na tabela gestor_agricola" FROM gestor_agricola;

SELECT * FROM registo_contrato_gestor_agricola ;
SELECT count(*) AS "linhas/tuplos na tabela registo_contrato_gestor_agricola" FROM registo_contrato_gestor_agricola;

SELECT * FROM tipo_cliente ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_cliente" FROM tipo_cliente;

SELECT * FROM cliente ;
SELECT count(*) AS "linhas/tuplos na tabela cliente" FROM cliente;

SELECT * FROM tipo_estado_encomenda ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_estado_encomenda" FROM tipo_estado_encomenda;

SELECT * FROM encomenda ;
SELECT count(*) AS "linhas/tuplos na tabela encomenda" FROM encomenda;

SELECT * FROM incidente ;
SELECT count(*) AS "linhas/tuplos na tabela incidente" FROM incidente;

SELECT * FROM registo_encomenda_produto ;
SELECT count(*) AS "linhas/tuplos na tabela registo_encomenda_produto" FROM registo_encomenda_produto;



