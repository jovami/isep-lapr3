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


---------------------------
----------[US204]----------
---------------------------


--CODIGO POSTAL PARA A INSTALACAO AGRICOLA
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4490');
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4491');
--CODIGO POSTAL PARA O GESTOR AGRICOLA
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4480');
--CODIGO POSTAL PARA O CONDUTOR
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4470');
--CODIGO POSTAL PARA O GESTOR DE DISTRIBUICAO
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4460');
--CODIGO POSTAL PARA O CLIENTE
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4450');
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4440');
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4430');
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4420');
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4410');


--CODIGO POSTAL PARA OS HUBS
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4400');
INSERT INTO codigo_postal(codigo_postal_id) VALUES ('4390');


INSERT INTO instalacao_agricola(nome,morada,codigo_postal_id) VALUES ('INSTALACAO G31 LAPR3', 'ISEP', '4490');
INSERT INTO instalacao_agricola(nome,morada,codigo_postal_id) VALUES ('INSTALACAO G3X LAPR3', 'ISEPX', '4491');

INSERT INTO caderno_campo(ano,designacao) VALUES (2021,'CADERNO DE CAMPO G31 LAPR3');
INSERT INTO caderno_campo(ano,designacao) VALUES (2022,'CADERNO DE CAMPO G31 LAPR3');
INSERT INTO caderno_campo(ano,designacao) VALUES (2023,'CADERNO DE CAMPO G31 LAPR3');

-----------------------------------------------------------------------
------------------------------UTILIZADORES-----------------------------
---------------------E COISAS QUE ENVOLVAM ESTES-----------------------


INSERT INTO tipo_utilizador(designacao) VALUES ('cliente');
INSERT INTO tipo_utilizador(designacao) VALUES ('gestor agricola');
INSERT INTO tipo_utilizador(designacao) VALUES ('condutor');
INSERT INTO tipo_utilizador(designacao) VALUES ('gestor distribuicao');

INSERT INTO tipo_cliente(designacao) VALUES ('A');
INSERT INTO tipo_cliente(designacao) VALUES ('B');
INSERT INTO tipo_cliente(designacao) VALUES ('C');


--GESTOR AGRICOLA
INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (null,'Quim',231432462,'quimisep@isep.ipp.pt','rua quim ISEP',NULL,NULL,NULL,NULL,NULL,'4480',2,NULL);
            
--O UTILIZADOR QUIM TRABALHOU EM 2019 O ANO QUASE TODO NA instalacao_agricola_id=1,POSTERIORMENTE
--TRABALHOU NA instalacao_agricola_id=2 NO ANO 2020,VOLTANDO A instalacao_agricola_id=1 EM 2021
INSERT INTO gestor_agricola(instalacao_agricola_id,gestor_agricola_id,data_inicio_contrato,data_fim_contrato) VALUES (1,1,TO_DATE('01/01/2019 08:00','DD/MM/YYYY HH24:MI'),TO_DATE('12/12/2019 08:00','DD/MM/YYYY HH24:MI'));
INSERT INTO gestor_agricola(instalacao_agricola_id,gestor_agricola_id,data_inicio_contrato,data_fim_contrato) VALUES (2,1,TO_DATE('01/01/2020 08:00','DD/MM/YYYY HH24:MI'),TO_DATE('12/07/2020 08:00','DD/MM/YYYY HH24:MI'));
INSERT INTO gestor_agricola(instalacao_agricola_id,gestor_agricola_id,data_inicio_contrato,data_fim_contrato) VALUES (1,1,TO_DATE('01/01/2021 08:00','DD/MM/YYYY HH24:MI'),NULL);

--CONDUTOR
INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (null,'Antonio',231432461,'antonioisep@isep.ipp.pt','rua antonio ISEP',NULL,NULL,NULL,NULL,NULL,'4470',3,NULL);

--GESTOR DISTRIBUICAO
INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (null,'Manuel',231432460,'manuelisep@isep.ipp.pt','rua manuel ISEP',NULL,NULL,NULL,NULL,NULL,'4460',4,NULL);

--CLIENTES
--cliente joao plafond 100000,incidentes 1, numero encomendas do ultimo ano 1, valor total encomendas 60000, tipo cliente C
INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (1210957,'joao',231432459,'1210957@isep.ipp.pt','rua joao ISEP',100000,1,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),1,60000,'4450',1,3);

--cliente jonas plafond 10000,incidentes 0, numero encomendas do ultimo ano 1, valor total encomendas 6000, tipo cliente B
INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (1181478,'jonas',231432458,'1181478@isep.ipp.pt','rua jonas ISEP',10000,0,NULL,1,6000,'4440',1,2);

--cliente jose plafond 15000,incidentes 0, numero encomendas do ultimo ano 1, valor total encomendas 12000, tipo cliente A            
INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (1211155,'jose',231432457,'1211155@isep.ipp.pt','rua jose ISEP',15000,0,NULL,1,12000,'4430',1,1);

INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (1210951,'marco',231432456,'1210951@isep.ipp.pt','rua marco ISEP',13000,0,NULL,0,0,'4420',1,NULL);
            
INSERT INTO utilizador(codigo_interno,nome,numero_fiscal,email,morada_correspondencia,plafond,numero_incidentes,data_ultimo_incidente,
            numero_encomendas_ultimo_ano,valor_total_encomendas_ultimo_ano,codigo_postal_id,tipo_utilizador_id,tipo_cliente)
            VALUES
            (1210954,'ruben',231432455,'1210954@isep.ipp.pt','rua ruben ISEP',15000,0,NULL,0,0,'4410',1,NULL);
            
            
-----------------------------------------------------------------------
------------------------------EDIFICIOS--------------------------------
-----------------------------------------------------------------------
INSERT INTO tipo_edificio(designacao) VALUES ('armazem');
INSERT INTO tipo_edificio(designacao) VALUES ('garagem');
INSERT INTO tipo_edificio(designacao) VALUES ('estabulo');

INSERT INTO edificio(designacao,area_ha,tipo_edificio_id,instalacao_agricola_id) VALUES ('Almada', 1500.20, 1, 1);
INSERT INTO edificio(designacao,area_ha,tipo_edificio_id,instalacao_agricola_id) VALUES ('Lapa', 1300.10, 2, 1);
INSERT INTO edificio(designacao,area_ha,tipo_edificio_id,instalacao_agricola_id) VALUES ('Zapa', 1600.50, 3, 1);


-----------------------------------------------------------------------
------------------------------PLANTACOES-------------------------------
-----------------------------------------------------------------------
INSERT INTO tipo_cultura(designacao) VALUES ('temporaria');
INSERT INTO tipo_cultura(designacao) VALUES ('permanente');

INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (1000,'rosas');
INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (2000,'macas');
INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (3000,'trigo');
INSERT INTO produto(valor_mercado_por_ha,designacao) VALUES (0,'adubacao verde');

INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id) VALUES ('Balmada', 1100.20, 1);
INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id) VALUES ('Japa', 1000.10, 1);
INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id) VALUES ('Opat', 200.50, 1);
INSERT INTO parcela_agricola(designacao,area_ha,instalacao_agricola_id) VALUES ('Xat', 500, 1);

--Parcela agricola com 2 produtos la plantados
INSERT INTO registo_cultura(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)
            VALUES (1,1,1,1,TO_DATE('04/01/2021 10:00','DD/MM/YYYY HH24:MI'),50,TO_DATE('20/12/2021 12:00','DD/MM/YYYY HH24:MI'),100);
INSERT INTO registo_cultura(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)
            VALUES (1,1,2,1,TO_DATE('04/01/2021 10:30','DD/MM/YYYY HH24:MI'),40,TO_DATE('20/12/2021 12:00','DD/MM/YYYY HH24:MI'),90);

--Parcela agricola com 2 produtos la plantados                            
INSERT INTO registo_cultura(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)  
            VALUES (1,2,2,1,TO_DATE('04/01/2021 12:00','DD/MM/YYYY HH24:MI'),30,TO_DATE('21/12/2021 12:00','DD/MM/YYYY HH24:MI'),100);
INSERT INTO registo_cultura(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)  
            VALUES (1,2,3,2,TO_DATE('04/01/2021 12:30','DD/MM/YYYY HH24:MI'),20,TO_DATE('21/12/2021 12:00','DD/MM/YYYY HH24:MI'),90);

--Parcela agricola com 1 produto plantado            
INSERT INTO registo_cultura(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)  
            VALUES (1,3,3,2,TO_DATE('04/01/2021 16:00','DD/MM/YYYY HH24:MI'),20,TO_DATE('22/12/2021 12:00','DD/MM/YYYY HH24:MI'),150);

--Parcela agricola com 1 produto plantado            
INSERT INTO registo_cultura(caderno_campo_id,parcela_agricola_id,produto_id,tipo_cultura_id,data_plantacao,
            area_plantada_ha,data_colheita,quantidade_colhida_ton_por_ha)  
            VALUES (1,4,4,1,TO_DATE('04/01/2021 18:00','DD/MM/YYYY HH24:MI'),10,TO_DATE('23/12/2021 12:00','DD/MM/YYYY HH24:MI'),200);


INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (1,1,100);
INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (1,2,190);
INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (1,3,240);
INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (1,4,200);

INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (2,1,100);
INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (2,2,190);
INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (2,3,240);
INSERT INTO stock(caderno_campo_id, produto_id, stock_ton) VALUES (2,4,200);

-----------------------------------------------------------------------
---------------------------------DADOS MEDIDOS-------------------------
-----------------------------------------------------------------------
INSERT INTO sensor(designacao) VALUES ('sensor de pluviosidade');
INSERT INTO sensor(designacao) VALUES ('sensor de temperatura do solo');
INSERT INTO sensor(designacao) VALUES ('sensor de humidade do solo');
INSERT INTO sensor(designacao) VALUES ('sensor de velocidade do vento');
INSERT INTO sensor(designacao) VALUES ('sensor de temperatura, de humidade do ar e pressão atmosférica');

INSERT INTO dado_meteorologico(caderno_campo_id,sensor_id,data_registo_meteorologico,designacao) VALUES (1,1,TO_DATE('05/01/2021 12:00','DD/MM/YYYY HH24:MI'),'meteorologico');
INSERT INTO dado_meteorologico(caderno_campo_id,sensor_id,data_registo_meteorologico,designacao) VALUES (1,2,TO_DATE('05/01/2021 12:01','DD/MM/YYYY HH24:MI'),'solo');
INSERT INTO dado_meteorologico(caderno_campo_id,sensor_id,data_registo_meteorologico,designacao) VALUES (1,3,TO_DATE('05/01/2021 12:02','DD/MM/YYYY HH24:MI'),'solo');
INSERT INTO dado_meteorologico(caderno_campo_id,sensor_id,data_registo_meteorologico,designacao) VALUES (1,4,TO_DATE('05/01/2021 12:03','DD/MM/YYYY HH24:MI'),'meteorologico');
INSERT INTO dado_meteorologico(caderno_campo_id,sensor_id,data_registo_meteorologico,designacao) VALUES (1,5,TO_DATE('05/01/2021 12:04','DD/MM/YYYY HH24:MI'),'meteorologico');


-----------------------------------------------------------------------
---------------------------------REGAS---------------------------------
-----------------------------------------------------------------------
INSERT INTO tipo_rega(designacao) VALUES('pulverizacao');
INSERT INTO tipo_rega(designacao) VALUES('gotejamento');
INSERT INTO tipo_rega(designacao) VALUES('asprecao');

INSERT INTO tipo_sistema(designacao) VALUES('gravidade');
INSERT INTO tipo_sistema(designacao) VALUES('bombeada');

--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=1
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (1,TO_DATE('06/01/2021 12:00','DD/MM/YYYY HH24:MI'),TO_DATE('06/01/2021 12:30','DD/MM/YYYY HH24:MI'),24,30);
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (1,TO_DATE('07/01/2021 12:00','DD/MM/YYYY HH24:MI'),TO_DATE('07/01/2021 12:30','DD/MM/YYYY HH24:MI'),24,30);            
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (1,TO_DATE('08/01/2021 12:00','DD/MM/YYYY HH24:MI'),TO_DATE('08/01/2021 12:30','DD/MM/YYYY HH24:MI'),24,30);
--ESTA ULTIMA REGA FOI PLANEADA MAS NAO EXECUTADA , POIS NAO CONSTA DA TABELA REGA_EXECUTADA
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (1,TO_DATE('09/01/2021 12:00','DD/MM/YYYY HH24:MI'),TO_DATE('09/01/2021 12:30','DD/MM/YYYY HH24:MI'),24,30);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=1            
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,1,TO_DATE('06/01/2021 12:00','DD/MM/YYYY HH24:MI'),1000,30,1,1);
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,1,TO_DATE('07/01/2021 12:00','DD/MM/YYYY HH24:MI'),500,30,2,1);
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,1,TO_DATE('08/01/2021 12:00','DD/MM/YYYY HH24:MI'),100,30,3,2);
            
--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=2
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (2,TO_DATE('06/01/2021 14:00','DD/MM/YYYY HH24:MI'),TO_DATE('06/01/2021 14:30','DD/MM/YYYY HH24:MI'),24,30);
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (2,TO_DATE('07/01/2021 14:00','DD/MM/YYYY HH24:MI'),TO_DATE('07/01/2021 14:30','DD/MM/YYYY HH24:MI'),24,30);            
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (2,TO_DATE('08/01/2021 14:00','DD/MM/YYYY HH24:MI'),TO_DATE('08/01/2021 14:30','DD/MM/YYYY HH24:MI'),24,30);
--ESTA ULTIMA REGA FOI PLANEADA MAS NAO EXECUTADA , POIS NAO CONSTA DA TABELA REGA_EXECUTADA
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (2,TO_DATE('09/01/2021 14:00','DD/MM/YYYY HH24:MI'),TO_DATE('09/01/2021 14:30','DD/MM/YYYY HH24:MI'),24,30);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=2            
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,2,TO_DATE('06/01/2022 14:00','DD/MM/YYYY HH24:MI'),100,30,1,1);
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,2,TO_DATE('07/01/2022 14:00','DD/MM/YYYY HH24:MI'),50,30,2,1);
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,2,TO_DATE('08/01/2022 14:00','DD/MM/YYYY HH24:MI'),10,30,3,2);
            
--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=3
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (3,TO_DATE('06/01/2021 16:00','DD/MM/YYYY HH24:MI'),TO_DATE('06/01/2021 16:30','DD/MM/YYYY HH24:MI'),24,30);
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (3,TO_DATE('07/01/2021 16:00','DD/MM/YYYY HH24:MI'),TO_DATE('07/01/2021 16:30','DD/MM/YYYY HH24:MI'),24,30);            
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (3,TO_DATE('08/01/2021 16:00','DD/MM/YYYY HH24:MI'),TO_DATE('08/01/2021 16:30','DD/MM/YYYY HH24:MI'),24,30);
--ESTA ULTIMA REGA FOI PLANEADA MAS NAO EXECUTADA , POIS NAO CONSTA DA TABELA REGA_EXECUTADA
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (3,TO_DATE('09/01/2021 16:00','DD/MM/YYYY HH24:MI'),TO_DATE('09/01/2021 16:30','DD/MM/YYYY HH24:MI'),24,30);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=3            
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,3,TO_DATE('06/01/2021 16:00','DD/MM/YYYY HH24:MI'),10,30,1,1);
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,3,TO_DATE('07/01/2021 16:00','DD/MM/YYYY HH24:MI'),5,30,2,1);
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,3,TO_DATE('08/01/2021 16:00','DD/MM/YYYY HH24:MI'),1,30,3,2);
            
--PLANO DE REGA DA PARCELA AGRICOLA COM parcela_agricola_id=4
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (4,TO_DATE('06/01/2021 18:00','DD/MM/YYYY HH24:MI'),TO_DATE('06/01/2021 18:30','DD/MM/YYYY HH24:MI'),24,30);
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (4,TO_DATE('07/01/2021 18:00','DD/MM/YYYY HH24:MI'),TO_DATE('07/01/2021 18:30','DD/MM/YYYY HH24:MI'),24,30);            
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (4,TO_DATE('08/01/2021 18:00','DD/MM/YYYY HH24:MI'),TO_DATE('08/01/2021 18:30','DD/MM/YYYY HH24:MI'),24,30);
--ESTA ULTIMA REGA FOI PLANEADA MAS NAO EXECUTADA , POIS NAO CONSTA DA TABELA REGA_EXECUTADA
INSERT INTO plano_rega(parcela_agricola_id,data_inicio,data_fim,periodicidade_rega_hh,tempo_rega_mm) 
            VALUES (4,TO_DATE('09/01/2021 18:00','DD/MM/YYYY HH24:MI'),TO_DATE('09/01/2021 18:30','DD/MM/YYYY HH24:MI'),24,30);
            
--REGA EXECUTADA DA PARCELA AGRICOLA COM parcela_agricola_id=4            
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,4,TO_DATE('06/01/2021 18:00','DD/MM/YYYY HH24:MI'),10000,30,1,1);
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,4,TO_DATE('07/01/2021 18:00','DD/MM/YYYY HH24:MI'),5000,30,2,1);
INSERT INTO rega_executada(caderno_campo_id,parcela_agricola_id,data_realizacao,quantidade_rega,tempo_rega_mm,tipo_rega_id,tipo_sistema_id)
            VALUES(1,4,TO_DATE('08/01/2021 18:00','DD/MM/YYYY HH24:MI'),1000,30,3,2);
            

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
INSERT INTO instalacao_agricola_fator_producao(instalacao_agricola_id,fator_producao_id,quantidade_kg)
            VALUES(1,1,100);
            
--NA instalacao_agricola_id = 1 o fator_producao_id=2 TEMOS 1000 kg           
INSERT INTO instalacao_agricola_fator_producao(instalacao_agricola_id,fator_producao_id,quantidade_kg)
            VALUES(1,2,1000);
            
--NA instalacao_agricola_id = 1 o fator_producao_id=2 TEMOS 10000 kg           
INSERT INTO instalacao_agricola_fator_producao(instalacao_agricola_id,fator_producao_id,quantidade_kg)
            VALUES(1,3,10000);
            
--NA instalacao_agricola_id = 1 o fator_producao_id=2 TEMOS 100000 kg           
INSERT INTO instalacao_agricola_fator_producao(instalacao_agricola_id,fator_producao_id,quantidade_kg)
            VALUES(1,4,100000);

-----------------------------------------------------------------------
----------------------------FERTILIZACOES------------------------------
---------------------E COISAS QUE ENVOLVAM ESTES-----------------------

INSERT INTO tipo_fertilizacao(designacao) VALUES ('aplicacao direta solo');
INSERT INTO tipo_fertilizacao(designacao) VALUES ('fetirrega');
INSERT INTO tipo_fertilizacao(designacao) VALUES ('foliar');

--NA parcela_agricola_id=1 E USANDO fator_producao_id=1 , FERTILIZAMOS COM 50kg
INSERT INTO fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(1,1,TO_DATE('03/01/2021 12:00','DD/MM/YYYY HH24:MI'),50,1);
--NA parcela_agricola_id=2 E USANDO fator_producao_id=1 , FERTILIZAMOS COM 50kg
INSERT INTO fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(2,1,TO_DATE('03/01/2021 14:00','DD/MM/YYYY HH24:MI'),50,2);
--NA parcela_agricola_id=3 E USANDO fator_producao_id=1 , FERTILIZAMOS COM 50kg
INSERT INTO fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(3,1,TO_DATE('03/01/2021 16:00','DD/MM/YYYY HH24:MI'),50,3);
--NA parcela_agricola_id=4 E USANDO fator_producao_id=1 , FERTILIZAMOS COM 50kg
INSERT INTO fertilizacao(parcela_agricola_id,fator_producao_id,data_fertilizacao,quantidade_utilizada_kg,tipo_fertilizacao_id)
            VALUES(4,1,TO_DATE('03/01/2021 18:00','DD/MM/YYYY HH24:MI'),50,1);

            
-----------------------------------------------------------------------
---------------------------------HUBS----------------------------------
-----------------------------------------------------------------------            
            
INSERT INTO hub(morada,codigo_postal_id) VALUES ('Trindade','4400');
INSERT INTO hub(morada,codigo_postal_id) VALUES ('Foz','4390');            
            
-----------------------------------------------------------------------
----------------------------ENCOMENDAS---------------------------------
---------------------E COISAS QUE ENVOLVAM ESTES-----------------------     

--VALORES IMPORTANTES A TER EM CONTA:
--cliente_id/utilizador_id=4 , codigo_interno=1210957, nome = joao
--cliente_id/utilizador_id=5 , codigo_interno=1181478, nome = jonas
--cliente_id/utilizador_id=6 , codigo_interno=1211155, nome = jose
--cliente_id/utilizador_id=7 , codigo_interno=1210951, nome = marco
--cliente_id/utilizador_id=8 , codigo_interno=1210954, nome = ruben

--produto_id= 1 valor_mercado_por_ha = 1000 designacao= rosas;
--produto_id= 2 valor_mercado_por_ha = 2000 designacao= macas;
--produto_id= 3 valor_mercado_por_ha = 3000 designacao= trigo;


INSERT INTO estado_encomenda(designacao) VALUES ('registado');
INSERT INTO estado_encomenda(designacao) VALUES ('entregue');
INSERT INTO estado_encomenda(designacao) VALUES ('pago');


--CLIENTE_ID/UTILIZADOR_ID=4 , CODIGO_INTERNO=1210957, NOME=JOAO
--produto_id= 1 valor_mercado_por_ha = 10 designacao= rosas;
--produto_id= 2 valor_mercado_por_ha = 20 designacao= macas;
--produto_id= 3 valor_mercado_por_ha = 30 designacao= trigo;
--valor_encomenda = 1000*10 + 2000*10 + 3000*10 = 60000
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(4,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'),60000,TO_DATE('15/03/2022 16:00','DD/MM/YYYY HH24:MI'),NULL,NULL);

--cliente_id/utilizador_id=4 , codigo_interno=1210957, nome = joao
--encomendou 10 toneladas de rosas, 10 toneladas de macas e 10 toneladas de trigo, daí o valor 60000 em cima mencionado
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (4,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'),1,10);
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (4,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'),2,10);
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (4,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'),3,10);
 
 --cliente_id/utilizador_id=4 , codigo_interno=1210957, nome = joao
 --teve a sua encomenda registada no dia 10 de fevereiro (estado_encomenda_id=1 'registada')
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('10/02/2022 16:00','DD/MM/YYYY HH24:MI'));

--sendo a sua encomenda entregue no dia 16 de fevereiro, um dia depois da data estimada (estado_encomenda_id=2 'entregue')
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'),2,TO_DATE('16/02/2022 16:00','DD/MM/YYYY HH24:MI'));
            
--efectuou o pagamento no dia 20 de marco            
INSERT INTO pagamento(valor_pagamento,data_pagamento,cliente_id,gestor_agricola_id,data_estimada_entrega) 
            VALUES(60000,TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'),4,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'));

--sendo que gerou um incidente pois a data limite a quando do registo da encomenda era dia 15 de março
--EM TEORIA OS INCIDENTES DEVEM SER GERIDOS POR UM TRIGGER QUE TODOS OS DIAS VÊ TODOS OS CLIENTES QUE GERARM INCIDENTES NESSE DIA
--COMEÇANDO COM O ATRIBUTO "data_incidente_liquidado" a NULL , APOS CADA PAGAMENTO ESTES DEVEM SER EFETUADOS COM UM TRIGGER TAMBEM
--QUE APOS INSERIR UM PAGAMENTO ACUTALIZA OS VALORES NA TABELA INCIDENTE E LEMBRAR QUE OS ATRIBUTOS EM CLIENTE DEVEM TAMBEM SER ATUALIZADOS COM TRIGGERS
INSERT INTO incidente(valor_incidente,data_incidente,data_incidente_liquidado,cliente_id) 
            VALUES(60000,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'),4);  

--apos o pagamento feito a encomenda passa a estar  estado_encomenda_id=3 'pago'           
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(4,1,TO_DATE('15/02/2022 16:00','DD/MM/YYYY HH24:MI'),3,TO_DATE('20/03/2022 16:00','DD/MM/YYYY HH24:MI'));

--Conclusao
--cliente_id/utilizador_id=4 , codigo_interno=1210957, nome = joao é um cliente do tipo C nos ultimos 12 meses pois tem um
--incidente apesar de ter 60000 euros em compras 

  
          
--CLIENTE_ID/UTILIZADOR_ID=5 , CODIGO_INTERNO=1181478, NOME=JONAS
--produto_id= 1 valor_mercado_por_ha = 10 designacao= rosas;
--produto_id= 2 valor_mercado_por_ha = 20 designacao= macas;
--produto_id= 3 valor_mercado_por_ha = 30 designacao= trigo;
--valor_encomenda = 1000*1 + 2000*1 + 3000*1 = 6000
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(5,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'),6000,TO_DATE('15/03/2022 12:00','DD/MM/YYYY HH24:MI'),NULL,NULL);            

--encomendou 1 toneladas de rosas, 1 toneladas de macas e 1 toneladas de trigo, daí o valor 6000 em cima mencionado
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (5,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'),1,1);
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (5,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'),2,1);
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (5,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'),3,1);            
            
--teve a sua encomenda registada no dia 10 de fevereiro (estado_encomenda_id=1 'registada')
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(5,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('10/02/2022 12:00','DD/MM/YYYY HH24:MI'));

--sendo a sua encomenda entregue no dia 17 de fevereiro, dois dia depois da data estimada (estado_encomenda_id=2 'entregue')
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(5,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'),2,TO_DATE('17/02/2022 12:00','DD/MM/YYYY HH24:MI'));
            
--efectuou o pagamento no dia 10 de marco            
INSERT INTO pagamento(valor_pagamento,data_pagamento,cliente_id,gestor_agricola_id,data_estimada_entrega) 
            VALUES(6000,TO_DATE('10/03/2022 12:00','DD/MM/YYYY HH24:MI'),5,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'));            

--apos o pagamento feito a encomenda passa a estar  estado_encomenda_id=3 'pago'           
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(5,1,TO_DATE('15/02/2022 12:00','DD/MM/YYYY HH24:MI'),3,TO_DATE('10/03/2022 12:00','DD/MM/YYYY HH24:MI'));

--Conclusao
--cliente_id/utilizador_id=5 , codigo_interno=1181478, nome = jonas é um cliente do tipo B nos ultimos 12 meses pois nao tem
--incidentes mas só possui um valor de 6000 euros em compras


--CLIENTE_ID/UTILIZADOR_ID=6 , CODIGO_INTERNO=1211155, NOME=JOSE
--produto_id= 1 valor_mercado_por_ha = 10 designacao= rosas;
--produto_id= 2 valor_mercado_por_ha = 20 designacao= macas;
--produto_id= 3 valor_mercado_por_ha = 30 designacao= trigo;
--valor_encomenda = 1000*2 + 2000*2 + 3000*2 = 12000
INSERT INTO encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,valor_encomenda,data_limite_pagamento,endereco_entrega,hub_id)
            VALUES(6,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),12000,TO_DATE('15/03/2022 10:00','DD/MM/YYYY HH24:MI'),NULL,NULL);

--encomendou 2 toneladas de rosas, 2 toneladas de macas e 2 toneladas de trigo, daí o valor 12000 em cima mencionado
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (6,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),1,2);
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (6,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),2,2);
INSERT INTO encomenda_produto(cliente_id,gestor_agricola_id,data_estimada_entrega,produto_id,quantidade_ton) 
            VALUES (6,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),3,2);      

--teve a sua encomenda registada no dia 10 de fevereiro (estado_encomenda_id=1 'registada')
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(6,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),1,TO_DATE('10/02/2022 10:00','DD/MM/YYYY HH24:MI'));

--sendo a sua encomenda entregue no dia 18 de fevereiro, TRES dia depois da data estimada (estado_encomenda_id=2 'entregue')
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(6,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),2,TO_DATE('18/02/2022 12:00','DD/MM/YYYY HH24:MI'));
            
--efectuou o pagamento no dia 10 de marco            
INSERT INTO pagamento(valor_pagamento,data_pagamento,cliente_id,gestor_agricola_id,data_estimada_entrega) 
            VALUES(12000,TO_DATE('10/03/2022 10:00','DD/MM/YYYY HH24:MI'),6,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'));            

--apos o pagamento feito a encomenda passa a estar  estado_encomenda_id=3 'pago'           
INSERT INTO registo_encomenda(cliente_id,gestor_agricola_id,data_estimada_entrega,estado_encomenda_id,data_registo_entrega_pagamento)
            VALUES(6,1,TO_DATE('15/02/2022 10:00','DD/MM/YYYY HH24:MI'),3,TO_DATE('10/03/2022 10:00','DD/MM/YYYY HH24:MI'));

--Conclusao
--cliente_id/utilizador_id=6 , codigo_interno=1211155, nome = jose é um cliente do tipo A nos ultimos 12 meses pois nao tem
--incidentes e possui um valor de 12000 euros em compras




SELECT * FROM caderno_campo ;
SELECT count(*) AS "linhas/tuplos na tabela caderno_campo" FROM caderno_campo;

SELECT * FROM instalacao_agricola ;
SELECT count(*) AS "linhas/tuplos na tabela instalacao_agricola" FROM instalacao_agricola;

SELECT * FROM tipo_cultura ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_cultura" FROM tipo_cultura;

SELECT * FROM produto ;
SELECT count(*) AS "linhas/tuplos na tabela produto" FROM produto;

SELECT * FROM stock ;
SELECT count(*) AS "linhas/tuplos na tabela stock" FROM stock;

SELECT * FROM tipo_edificio ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_edificio" FROM tipo_edificio;

SELECT * FROM edificio ;
SELECT count(*) AS "linhas/tuplos na tabela edificio" FROM edificio;

SELECT * FROM parcela_agricola ;
SELECT count(*) AS "linhas/tuplos na tabela parcela_agricola" FROM parcela_agricola;

SELECT * FROM registo_cultura ;
SELECT count(*) AS "linhas/tuplos na tabela registo_cultura" FROM registo_cultura;

SELECT * FROM sensor ;
SELECT count(*) AS "linhas/tuplos na tabela sensor" FROM sensor;

SELECT * FROM dado_meteorologico ;
SELECT count(*) AS "linhas/tuplos na tabela dado_meteorologico" FROM dado_meteorologico;

SELECT * FROM tipo_rega ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_rega" FROM tipo_rega;

SELECT * FROM tipo_sistema ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_sistema" FROM tipo_sistema;

SELECT * FROM plano_rega ;
SELECT count(*) AS "linhas/tuplos na tabela plano_rega" FROM plano_rega;

SELECT * FROM rega_executada ;
SELECT count(*) AS "linhas/tuplos na tabela rega_executada" FROM rega_executada;

SELECT * FROM tipo_fator_producao ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_fator_producao" FROM tipo_fator_producao;

SELECT * FROM formulacao ;
SELECT count(*) AS "linhas/tuplos na tabela formulacao" FROM formulacao;

SELECT * FROM fator_producao ;
SELECT count(*) AS "linhas/tuplos na tabela fator_producao" FROM fator_producao;

SELECT * FROM tipo_fertilizacao ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_fertilizacao" FROM tipo_fertilizacao;

SELECT * FROM fertilizacao ;
SELECT count(*) AS "linhas/tuplos na tabela fertilizacao" FROM fertilizacao;

SELECT * FROM tipo_composto ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_composto" FROM tipo_composto;

SELECT * FROM composto ;
SELECT count(*) AS "linhas/tuplos na tabela composto" FROM composto;

SELECT * FROM ficha_tecnica ;
SELECT count(*) AS "linhas/tuplos na tabela ficha_tecnica" FROM ficha_tecnica;

SELECT * FROM instalacao_agricola_fator_producao ;
SELECT count(*) AS "linhas/tuplos na tabela instalacao_agricola_fator_producao" FROM instalacao_agricola_fator_producao;

SELECT * FROM tipo_utilizador ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_utilizador" FROM tipo_utilizador;

SELECT * FROM tipo_cliente ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_cliente" FROM tipo_cliente;

SELECT * FROM codigo_postal ;
SELECT count(*) AS "linhas/tuplos na tabela codigo_postal" FROM codigo_postal;

SELECT * FROM utilizador ;
SELECT count(*) AS "linhas/tuplos na tabela utilizador" FROM utilizador;

SELECT * FROM gestor_agricola ;
SELECT count(*) AS "linhas/tuplos na tabela gestor_agricola" FROM gestor_agricola;

SELECT * FROM hub ;
SELECT count(*) AS "linhas/tuplos na tabela hub" FROM hub;

SELECT * FROM incidente ;
SELECT count(*) AS "linhas/tuplos na tabela incidente" FROM incidente;

SELECT * FROM estado_encomenda ;
SELECT count(*) AS "linhas/tuplos na tabela estado_encomenda" FROM estado_encomenda;

SELECT * FROM encomenda ;
SELECT count(*) AS "linhas/tuplos na tabela encomenda" FROM encomenda;

SELECT * FROM registo_encomenda ;
SELECT count(*) AS "linhas/tuplos na tabela registo_encomenda" FROM registo_encomenda;

SELECT * FROM pagamento ;
SELECT count(*) AS "linhas/tuplos na tabela pagamento" FROM pagamento;

SELECT * FROM encomenda_produto ;
SELECT count(*) AS "linhas/tuplos na tabela encomenda_produto" FROM encomenda_produto;



