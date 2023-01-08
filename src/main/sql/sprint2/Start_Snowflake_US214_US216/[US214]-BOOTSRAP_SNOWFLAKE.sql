DROP TABLE cliente CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_cultura CASCADE CONSTRAINTS PURGE ;
DROP TABLE produto CASCADE CONSTRAINTS PURGE ;
DROP TABLE cultura CASCADE CONSTRAINTS PURGE ;
DROP TABLE ano CASCADE CONSTRAINTS PURGE ;
DROP TABLE mes CASCADE CONSTRAINTS PURGE ;
DROP TABLE tempo CASCADE CONSTRAINTS PURGE ;
DROP TABLE parcela_agricola CASCADE CONSTRAINTS PURGE ;
DROP TABLE tipo_hub CASCADE CONSTRAINTS PURGE ;
DROP TABLE localizacao CASCADE CONSTRAINTS PURGE ;
DROP TABLE hub CASCADE CONSTRAINTS PURGE ;
DROP TABLE producao_venda CASCADE CONSTRAINTS PURGE ;

/*..........................................................*/
/*..........................................................*/
/*....................CREATE TABLE.........................*/


CREATE TABLE cliente (

     codigo_interno                     INTEGER CONSTRAINT pk_cliente_id    PRIMARY KEY,
     nome                               VARCHAR(40)     CONSTRAINT nn_utilizador_nome                NOT NULL,     
     email                              VARCHAR(40)     CONSTRAINT un_utilizador_email               UNIQUE,
     numero_fiscal                      INTEGER         CONSTRAINT un_utilizador_numero_fiscal       UNIQUE,
     plafond                            NUMBER(15,2)    CONSTRAINT ck_utilizador_plafond             CHECK(plafond >= 0 OR plafond = NULL), 
     numero_incidentes                  INTEGER         CONSTRAINT ck_utilizador_numero_incidentes   CHECK(numero_incidentes >= 0 OR numero_incidentes = NULL),
     data_ultimo_incidente              DATE,
     valor_total_encomendas_ultimo_ano  NUMBER(15,2)    CONSTRAINT ck_utilizador_valor_total_encomendas_ultimo_ano    CHECK(valor_total_encomendas_ultimo_ano >= 0 OR valor_total_encomendas_ultimo_ano = NULL),
     numero_encomendas_ultimo_ano       INTEGER         CONSTRAINT ck_utilizador_numero_encomendas_ultimo_ano  CHECK(numero_encomendas_ultimo_ano >= 0 OR numero_encomendas_ultimo_ano = NULL)
);


CREATE TABLE tipo_cultura (
    
    tipo_cultura_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_cultura_id  PRIMARY KEY,
    designacao                  VARCHAR(40) CONSTRAINT un_tipo_cultura_designacao            UNIQUE
);


CREATE TABLE cultura (
    
    
    cultura_id                      INTEGER GENERATED AS IDENTITY CONSTRAINT pk_cultura_id     PRIMARY KEY,
    quantidade_colhida_ton_por_ha   NUMBER(15,4) CONSTRAINT ck_registo_colheita_quantidade_colhida_ton_por_ha  CHECK(quantidade_colhida_ton_por_ha >= 0),
    area_plantada_ha                NUMBER(15,4) CONSTRAINT ck_registo_cultura_area_plantada_ha                CHECK(area_plantada_ha > 0)
);


CREATE TABLE produto (
    
    produto_id                      INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_produto_id     PRIMARY KEY,
    designacao_p                    VARCHAR(40) CONSTRAINT nn_produto_designacao_p                  NOT NULL, 
    valor_mercado_por_ha            NUMBER(15,4) CONSTRAINT ck_produto_valor_mercado_por_ha         CHECK(valor_mercado_por_ha >= 0),
    tipo_cultura_id                 INTEGER REFERENCES tipo_cultura(tipo_cultura_id) NOT NULL,
    cultura_id                      INTEGER REFERENCES cultura(cultura_id) NOT NULL
);


CREATE TABLE ano (
    
    ano             INTEGER CONSTRAINT pk_ano  PRIMARY KEY
);

CREATE TABLE mes (
    
    mes             INTEGER CONSTRAINT pk_mes                     PRIMARY KEY,
    nome            VARCHAR(40)  CONSTRAINT nn_mes_nome           NOT NULL
);

CREATE TABLE tempo (

    tempo_id         INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tempo_id  PRIMARY KEY, 
    ano              INTEGER REFERENCES ano(ano) NOT NULL,
    mes              INTEGER REFERENCES mes(mes) NOT NULL
);


CREATE TABLE parcela_agricola (

    parcela_agricola_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_parcela_agricola_id  PRIMARY KEY,
    designacao                      VARCHAR(40)  CONSTRAINT nn_parcela_agricola_designacao           NOT NULL,
    area_ha                         NUMBER(15,4) CONSTRAINT ck_parcela_agricola_area_ha              CHECK(area_ha > 0)
);


CREATE TABLE tipo_hub (
    
    tipo_hub_id             INTEGER GENERATED AS IDENTITY CONSTRAINT pk_tipo_hub_id  PRIMARY KEY,
    designacao              VARCHAR(40) CONSTRAINT un_tipo_hub_designacao            UNIQUE
);


CREATE TABLE localizacao (
    
    localizacao_id     INTEGER GENERATED AS IDENTITY CONSTRAINT pk_localizacao_id                 PRIMARY KEY,
    latitude           NUMBER(15,9) CONSTRAINT ck_localizacao_latitude  	CHECK( latitude >= -90 and latitude <= 90 ),
    longitude          NUMBER(15,9) CONSTRAINT ck_localizacao_longitude 	CHECK( longitude >= -180 and longitude <= 180 )
);
    

CREATE TABLE hub (

    hub_id              VARCHAR(40) CONSTRAINT pk_hub_id             PRIMARY KEY,
    
    tipo_hub_id         INTEGER REFERENCES tipo_hub(tipo_hub_id)     NOT NULL,
    localizacao_id      INTEGER REFERENCES localizacao(localizacao_id) NOT NULL
);  


CREATE TABLE producao_venda (

    producao_venda_id           INTEGER GENERATED AS IDENTITY CONSTRAINT pk_producao_venda_id   PRIMARY KEY,
    designacao_p_ou_v           VARCHAR(40) CONSTRAINT ck_designacao_p_ou_v                     CHECK(designacao_p_ou_v LIKE 'producao' OR designacao_p_ou_v LIKE 'venda'),
    cliente_codigo_interno      INTEGER REFERENCES cliente(codigo_interno),
    tempo_id                    INTEGER REFERENCES tempo(tempo_id)                              NOT NULL,
    produto_id                  INTEGER REFERENCES produto(produto_id)                          NOT NULL,
    parcela_agricola_id         INTEGER REFERENCES parcela_agricola(parcela_agricola_id),
    hub_id                      VARCHAR(40) REFERENCES hub(hub_id),
    producao_toneladas          NUMBER(15,4) CONSTRAINT ck_producao_toneladas CHECK(producao_toneladas >= 0),
    venda_milhares_euros        NUMBER(15,2) CONSTRAINT ck_venda_milhares_euros CHECK(venda_milhares_euros >= 0)
);  



---------------------------
----------INSERTS----------
---------------------------

INSERT INTO ano(ano) VALUES (2018);
INSERT INTO ano(ano) VALUES (2019);
INSERT INTO ano(ano) VALUES (2020);
INSERT INTO ano(ano) VALUES (2021);
INSERT INTO ano(ano) VALUES (2022);

INSERT INTO mes(mes,nome) VALUES (1,'janeiro');
INSERT INTO mes(mes,nome) VALUES (2,'fevereiro');
INSERT INTO mes(mes,nome) VALUES (3,'marco');
INSERT INTO mes(mes,nome) VALUES (4,'abril');
INSERT INTO mes(mes,nome) VALUES (5,'maio');
INSERT INTO mes(mes,nome) VALUES (6,'junho');
INSERT INTO mes(mes,nome) VALUES (7,'julho');
INSERT INTO mes(mes,nome) VALUES (8,'agosto');
INSERT INTO mes(mes,nome) VALUES (9,'setembro');
INSERT INTO mes(mes,nome) VALUES (10,'outubro');
INSERT INTO mes(mes,nome) VALUES (11,'novembro');
INSERT INTO mes(mes,nome) VALUES (12,'dezembro');

INSERT INTO tempo(ano,mes) VALUES (2018,1);
INSERT INTO tempo(ano,mes) VALUES (2018,2);
INSERT INTO tempo(ano,mes) VALUES (2018,3);
INSERT INTO tempo(ano,mes) VALUES (2018,4);
INSERT INTO tempo(ano,mes) VALUES (2018,5);
INSERT INTO tempo(ano,mes) VALUES (2018,6);
INSERT INTO tempo(ano,mes) VALUES (2018,7);
INSERT INTO tempo(ano,mes) VALUES (2018,8);
INSERT INTO tempo(ano,mes) VALUES (2018,9);
INSERT INTO tempo(ano,mes) VALUES (2018,10);
INSERT INTO tempo(ano,mes) VALUES (2018,11);
INSERT INTO tempo(ano,mes) VALUES (2018,12);
--ID DO SEGUINTE TEMPO ID=13
INSERT INTO tempo(ano,mes) VALUES (2019,1);
INSERT INTO tempo(ano,mes) VALUES (2019,2);
INSERT INTO tempo(ano,mes) VALUES (2019,3);
INSERT INTO tempo(ano,mes) VALUES (2019,4);
INSERT INTO tempo(ano,mes) VALUES (2019,5);
INSERT INTO tempo(ano,mes) VALUES (2019,6);
INSERT INTO tempo(ano,mes) VALUES (2019,7);
INSERT INTO tempo(ano,mes) VALUES (2019,8);
INSERT INTO tempo(ano,mes) VALUES (2019,9);
INSERT INTO tempo(ano,mes) VALUES (2019,10);
INSERT INTO tempo(ano,mes) VALUES (2019,11);
INSERT INTO tempo(ano,mes) VALUES (2019,12);
--ID DO SEGUINTE TEMPO ID=25
INSERT INTO tempo(ano,mes) VALUES (2020,1);
INSERT INTO tempo(ano,mes) VALUES (2020,2);
INSERT INTO tempo(ano,mes) VALUES (2020,3);
INSERT INTO tempo(ano,mes) VALUES (2020,4);
INSERT INTO tempo(ano,mes) VALUES (2020,5);
INSERT INTO tempo(ano,mes) VALUES (2020,6);
INSERT INTO tempo(ano,mes) VALUES (2020,7);
INSERT INTO tempo(ano,mes) VALUES (2020,8);
INSERT INTO tempo(ano,mes) VALUES (2020,9);
INSERT INTO tempo(ano,mes) VALUES (2020,10);
INSERT INTO tempo(ano,mes) VALUES (2020,11);
INSERT INTO tempo(ano,mes) VALUES (2020,12);
--ID DO SEGUINTE TEMPO ID=37
INSERT INTO tempo(ano,mes) VALUES (2021,1);
INSERT INTO tempo(ano,mes) VALUES (2021,2);
INSERT INTO tempo(ano,mes) VALUES (2021,3);
INSERT INTO tempo(ano,mes) VALUES (2021,4);
INSERT INTO tempo(ano,mes) VALUES (2021,5);
INSERT INTO tempo(ano,mes) VALUES (2021,6);
INSERT INTO tempo(ano,mes) VALUES (2021,7);
INSERT INTO tempo(ano,mes) VALUES (2021,8);
INSERT INTO tempo(ano,mes) VALUES (2021,9);
INSERT INTO tempo(ano,mes) VALUES (2021,10);
INSERT INTO tempo(ano,mes) VALUES (2021,11);
INSERT INTO tempo(ano,mes) VALUES (2021,12);
--ID DO SEGUINTE TEMPO ID=49
INSERT INTO tempo(ano,mes) VALUES (2022,1);
INSERT INTO tempo(ano,mes) VALUES (2022,2);
INSERT INTO tempo(ano,mes) VALUES (2022,3);
INSERT INTO tempo(ano,mes) VALUES (2022,4);
INSERT INTO tempo(ano,mes) VALUES (2022,5);
INSERT INTO tempo(ano,mes) VALUES (2022,6);
INSERT INTO tempo(ano,mes) VALUES (2022,7);
INSERT INTO tempo(ano,mes) VALUES (2022,8);
INSERT INTO tempo(ano,mes) VALUES (2022,9);
INSERT INTO tempo(ano,mes) VALUES (2022,10);
INSERT INTO tempo(ano,mes) VALUES (2022,11);
INSERT INTO tempo(ano,mes) VALUES (2022,12);
 
 
INSERT INTO cliente(codigo_interno,nome,email,numero_fiscal,plafond,numero_incidentes,data_ultimo_incidente,valor_total_encomendas_ultimo_ano,numero_encomendas_ultimo_ano) 
            VALUES(500,'joao','1210957@isep.ipp.pt',231432459,100000,1,TO_DATE('15/03/2022 16:01','DD/MM/YYYY HH24:MI'),60000,1);
            
INSERT INTO cliente(codigo_interno,nome,email,numero_fiscal,plafond,numero_incidentes,data_ultimo_incidente,valor_total_encomendas_ultimo_ano,numero_encomendas_ultimo_ano) 
            VALUES(600,'jose','1211155@isep.ipp.pt',231432457,10000,1,TO_DATE('20/03/2022 16:01','DD/MM/YYYY HH24:MI'),6000,1);

INSERT INTO parcela_agricola(designacao,area_ha) VALUES ('Balmada', 100);
INSERT INTO parcela_agricola(designacao,area_ha) VALUES ('Japa', 200);

INSERT INTO tipo_hub(designacao) VALUES ('P');
INSERT INTO tipo_hub(designacao) VALUES ('E');

INSERT INTO localizacao(latitude,longitude)  VALUES (38.5243,-8.8926);
INSERT INTO localizacao(latitude,longitude)  VALUES (39.3167,-7.4167);

INSERT INTO hub(hub_id,tipo_hub_id,localizacao_id) VALUES ('CT14',1,1);
INSERT INTO hub(hub_id,tipo_hub_id,localizacao_id) VALUES ('CT11',2,2);


INSERT INTO tipo_cultura(designacao) VALUES ('permanente');
INSERT INTO tipo_cultura(designacao) VALUES ('temporaria');


INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (10,1);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (20,2);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (30,3);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (40,4);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (50,5);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (5,1);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (10,2);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (15,3);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (20,4);
INSERT INTO cultura(quantidade_colhida_ton_por_ha,area_plantada_ha) VALUES (25,5);

--PRODUTO ROSAS
--PRODUTO_ID=1
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('rosas',10,1,1);
--PRODUTO_ID=2            
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('rosas',10,2,2);
--PRODUTO_ID=3            
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('rosas',10,1,3);
--PRODUTO_ID=4            
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('rosas',10,2,4);
--PRODUTO_ID=5            
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('rosas',10,1,5);

--PRODUTO MACAS
--PRODUTO_ID=6
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('macas',20,2,6);
--PRODUTO_ID=7
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('macas',20,2,7);
--PRODUTO_ID=8
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('macas',20,2,8);
--PRODUTO_ID=9
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('macas',20,1,9);
--PRODUTO_ID=10            
INSERT INTO produto(designacao_p,valor_mercado_por_ha,tipo_cultura_id,cultura_id) 
            VALUES('macas',20,2,10);
            
----------------------------------------------------------------------------------------            
--------------------------------PRODUCAO------------------------------------------------
----------------------------------------------------------------------------------------

--PRODUCAO NO ANO 2018 MES 12, NA PARCELA_AGRICOLA_ID=1  , PRODUTO_ID=1 ROSAS        
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 12, 1,1, NULL, 10, NULL);

--PRODUCAO NO ANO 2019 MES 12, NA PARCELA_AGRICOLA_ID=1  , PRODUTO_ID=2 ROSAS          
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 24, 2,1, NULL, 40, NULL);

--PRODUCAO NO ANO 2020 MES 12, NA PARCELA_AGRICOLA_ID=1  , PRODUTO_ID=3 ROSAS          
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 36, 3,1, NULL, 90, NULL);

--PRODUCAO NO ANO 2021 MES 12 , NA PARCELA_AGRICOLA_ID=1  , PRODUTO_ID=4 ROSAS           
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 48, 4,1, NULL, 160, NULL);

--PRODUCAO NO ANO 2022 MES 12 , NA PARCELA_AGRICOLA_ID=1  , PRODUTO_ID=5 ROSAS           
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 60, 5,1, NULL, 250, NULL);



--PRODUCAO NO ANO 2018 MES 12, NA PARCELA_AGRICOLA_ID=2  , PRODUTO_ID=6 MACAS        
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 12, 6,2, NULL, 5, NULL);

--PRODUCAO NO ANO 2019 MES 12, NA PARCELA_AGRICOLA_ID=2  , PRODUTO_ID=7 MACAS          
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 24, 7,2, NULL, 20, NULL);

--PRODUCAO NO ANO 2020 MES 12, NA PARCELA_AGRICOLA_ID=2  , PRODUTO_ID=8 MACAS          
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 36, 8,2, NULL, 45, NULL);

--PRODUCAO NO ANO 2021 MES 12 , NA PARCELA_AGRICOLA_ID=2  , PRODUTO_ID=9 MACAS           
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 48, 9,2, NULL, 80, NULL);

--PRODUCAO NO ANO 2022 MES 12 , NA PARCELA_AGRICOLA_ID=2  , PRODUTO_ID=10 MACAS           
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('producao', NULL, 60, 10,2, NULL, 100, NULL);
            

----------------------------------------------------------------------------------------            
--------------------------------VENDAS--------------------------------------------------
----------------------------------------------------------------------------------------

----------------
---VENDAS 2018--
---VENDAS 2018--
---VENDAS 2018--
----------------

-------ROSAS------
-------ROSAS------

--VENDA NO ANO 2018 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=1          
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 1, 1,NULL, 'CT14', NULL, 10);
            
--VENDA NO ANO 2018 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=1                
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 2, 1,NULL, 'CT14', NULL, 10);
            
--VENDA NO ANO 2018 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 3, 1,NULL, 'CT14', NULL, 10);

--VENDA NO ANO 2018 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 4, 1,NULL, 'CT14', NULL, 10);

--VENDA NO ANO 2018 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 5, 1,NULL, 'CT14', NULL, 10);

--VENDA NO ANO 2018 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 6, 1,NULL, 'CT14', NULL, 10);

--VENDA NO ANO 2018 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 7, 1,NULL, 'CT11', NULL, 10);
            
--VENDA NO ANO 2018 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 8, 1,NULL, 'CT11', NULL, 10);            
                      
--VENDA NO ANO 2018 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 9, 1,NULL, 'CT11', NULL, 10);            
            
--VENDA NO ANO 2018 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=1 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 10, 1,NULL, 'CT11', NULL, 10);
            
-------MACAS------
-------MACAS------ 
            
--VENDA NO ANO 2018 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=6 MACAS , HUB_ID=1          
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 1, 6,NULL, 'CT14', NULL, 20);
            
--VENDA NO ANO 2018 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=6 MACAS , HUB_ID=1                
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 2, 6,NULL, 'CT14', NULL, 20);
            
--VENDA NO ANO 2018 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=6 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 3, 6,NULL, 'CT14', NULL, 20);

--VENDA NO ANO 2018 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=6 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 4, 6,NULL, 'CT14', NULL, 20);

--VENDA NO ANO 2018 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=6 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 5, 6,NULL, 'CT14', NULL, 20);

----------------
---VENDAS 2019--
---VENDAS 2019--
---VENDAS 2019--
----------------

-------ROSAS------
-------ROSAS------
                     
--VENDA NO ANO 2019 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 13, 2,NULL, 'CT14', NULL, 10);              
            
--VENDA NO ANO 2019 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 14, 2,NULL, 'CT14', NULL, 20);             
            
--VENDA NO ANO 2019 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 15, 2,NULL, 'CT14', NULL, 40);             
                       
--VENDA NO ANO 2019 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 16, 2,NULL, 'CT14', NULL, 20);             
            
--VENDA NO ANO 2019 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 17, 2,NULL, 'CT14', NULL, 40);             
            
--VENDA NO ANO 2019 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 18, 2,NULL, 'CT14', NULL, 10);             
            
--VENDA NO ANO 2019 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 19, 2,NULL, 'CT11', NULL, 50);             
            
--VENDA NO ANO 2019 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 20, 2,NULL, 'CT11', NULL, 70);             
            
--VENDA NO ANO 2019 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 21, 2,NULL, 'CT11', NULL, 50);             
            
--VENDA NO ANO 2019 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 22, 2,NULL, 'CT11', NULL, 60);             
                        
--VENDA NO ANO 2019 MES 11 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 23, 2,NULL, 'CT11', NULL, 10);                         
            
--VENDA NO ANO 2019 MES 12 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=2 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 24, 2,NULL, 'CT11', NULL, 20);

-------MACAS------
-------MACAS------  
            
--VENDA NO ANO 2019 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 13, 7,NULL, 'CT14', NULL, 20);              
            
--VENDA NO ANO 2019 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 14, 7,NULL, 'CT14', NULL, 20);             
            
--VENDA NO ANO 2019 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 15, 7,NULL, 'CT14', NULL, 20);             
                       
--VENDA NO ANO 2019 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 16, 7,NULL, 'CT14', NULL, 20);             
            
--VENDA NO ANO 2019 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 17, 7,NULL, 'CT14', NULL, 20);             
            
--VENDA NO ANO 2019 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 18, 7,NULL, 'CT14', NULL, 40);             
            
--VENDA NO ANO 2019 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 19, 7,NULL, 'CT11', NULL, 40);             
            
--VENDA NO ANO 2019 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 20, 7,NULL, 'CT11', NULL, 40);             
            
--VENDA NO ANO 2019 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 21, 7,NULL, 'CT11', NULL, 40);             
            
--VENDA NO ANO 2019 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 22, 7,NULL, 'CT11', NULL, 40);             
                        
--VENDA NO ANO 2019 MES 11 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 23, 7,NULL, 'CT11', NULL, 40);                         
            
--VENDA NO ANO 2019 MES 12 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=7 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 24, 7,NULL, 'CT11', NULL, 40);               

            
----------------
---VENDAS 2020--
---VENDAS 2020--
---VENDAS 2020--
----------------

-------ROSAS------
-------ROSAS------
            
--VENDA NO ANO 2020 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 25, 3,NULL, 'CT14', NULL, 20);              
            
--VENDA NO ANO 2020 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 26, 3,NULL, 'CT14', NULL, 70);             
            
--VENDA NO ANO 2020 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 27, 3,NULL, 'CT14', NULL, 80);             
                       
--VENDA NO ANO 2020 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 28, 3,NULL, 'CT14', NULL, 20);             
            
--VENDA NO ANO 2020 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 29, 3,NULL, 'CT14', NULL, 60);             
            
--VENDA NO ANO 2020 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 30, 3,NULL, 'CT14', NULL, 60);             
            
--VENDA NO ANO 2020 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 31, 3,NULL, 'CT11', NULL, 70);             
            
--VENDA NO ANO 2020 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 32, 3,NULL, 'CT11', NULL, 150);             
            
--VENDA NO ANO 2020 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 33, 3,NULL, 'CT11', NULL, 70);             
            
--VENDA NO ANO 2020 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 34, 3,NULL, 'CT11', NULL, 80);             
                        
--VENDA NO ANO 2020 MES 11 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 35, 3,NULL, 'CT11', NULL, 70);                         
            
--VENDA NO ANO 2020 MES 12 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=3 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 36, 3,NULL, 'CT11', NULL, 80); 
            
-------MACAS------
-------MACAS------  
            
--VENDA NO ANO 2020 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 25, 8,NULL, 'CT14', NULL, 75);              
            
--VENDA NO ANO 2020 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 26, 8,NULL, 'CT14', NULL, 75);             
            
--VENDA NO ANO 2020 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 27, 8,NULL, 'CT14', NULL, 75);             
                       
--VENDA NO ANO 2020 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 28, 8,NULL, 'CT14', NULL, 50);             
            
--VENDA NO ANO 2020 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 29, 8,NULL, 'CT14', NULL, 80);             
            
--VENDA NO ANO 2020 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 30, 8,NULL, 'CT14', NULL, 75);             
            
--VENDA NO ANO 2020 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 31, 8,NULL, 'CT11', NULL, 90);             
            
--VENDA NO ANO 2020 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 32, 8,NULL, 'CT11', NULL, 50);             
            
--VENDA NO ANO 2020 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 33, 8,NULL, 'CT11', NULL, 75);             
            
--VENDA NO ANO 2020 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 34, 8,NULL, 'CT11', NULL, 75);             
                        
--VENDA NO ANO 2020 MES 11 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 35, 8,NULL, 'CT11', NULL, 75);                         
            
--VENDA NO ANO 2020 MES 12 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=8 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 36, 8,NULL, 'CT11', NULL, 75);  
            
----------------
---VENDAS 2021--
---VENDAS 2021--
---VENDAS 2021--
----------------            
            
--VENDA NO ANO 2021 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 37, 4,NULL, 'CT14', NULL, 130);              
            
--VENDA NO ANO 2021 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 38, 4,NULL, 'CT14', NULL, 120);             
            
--VENDA NO ANO 2021 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 39, 4,NULL, 'CT14', NULL, 150);             
                       
--VENDA NO ANO 2021 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 40, 4,NULL, 'CT14', NULL, 130);             
            
--VENDA NO ANO 2021 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 41, 4,NULL, 'CT14', NULL, 160);             
            
--VENDA NO ANO 2021 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 42, 4,NULL, 'CT14', NULL, 100);             
            
--VENDA NO ANO 2021 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 43, 4,NULL, 'CT11', NULL, 170);             
            
--VENDA NO ANO 2021 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 44, 4,NULL, 'CT11', NULL, 80);             
            
--VENDA NO ANO 2021 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 45, 4,NULL, 'CT11', NULL, 190);             
            
--VENDA NO ANO 2021 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 46, 4,NULL, 'CT11', NULL, 140);             
                        
--VENDA NO ANO 2021 MES 11 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 47, 4,NULL, 'CT11', NULL, 150);                         
            
--VENDA NO ANO 2021 MES 12 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=4 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 48, 4,NULL, 'CT11', NULL, 20);
            
-------MACAS------
-------MACAS------            
            
--VENDA NO ANO 2021 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 37, 9,NULL, 'CT14', NULL, 130);              
            
--VENDA NO ANO 2021 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 38, 9,NULL, 'CT14', NULL, 130);             
            
--VENDA NO ANO 2021 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 39, 9,NULL, 'CT14', NULL, 130);             
                       
--VENDA NO ANO 2021 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 40, 9,NULL, 'CT14', NULL, 130);             
            
--VENDA NO ANO 2021 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 41, 9,NULL, 'CT14', NULL, 110);             
            
--VENDA NO ANO 2021 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 42, 9,NULL, 'CT14', NULL, 120);             
            
--VENDA NO ANO 2021 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 43, 9,NULL, 'CT11', NULL, 130);             
            
--VENDA NO ANO 2021 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 44, 9,NULL, 'CT11', NULL, 120);             
            
--VENDA NO ANO 2021 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 45, 9,NULL, 'CT11', NULL, 130);             
            
--VENDA NO ANO 2021 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 46, 9,NULL, 'CT11', NULL, 130);             
                        
--VENDA NO ANO 2021 MES 11 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 47, 9,NULL, 'CT11', NULL, 120);                         
            
--VENDA NO ANO 2021 MES 12 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=9 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 48, 9,NULL, 'CT11', NULL, 120);  
            
             
----------------
---VENDAS 2022--
---VENDAS 2022--
---VENDAS 2022--
----------------            
            
--VENDA NO ANO 2022 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 49, 5,NULL, 'CT14', NULL, 200);              
            
--VENDA NO ANO 2022 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 50, 5,NULL, 'CT14', NULL, 190);             
            
--VENDA NO ANO 2022 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 51, 5,NULL, 'CT14', NULL, 180);             
                       
--VENDA NO ANO 2022 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 52, 5,NULL, 'CT14', NULL, 170);             
            
--VENDA NO ANO 2022 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 53, 5,NULL, 'CT14', NULL, 190);             
            
--VENDA NO ANO 2022 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 54, 5,NULL, 'CT14', NULL, 180);             
            
--VENDA NO ANO 2022 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 55, 5,NULL, 'CT11', NULL, 170);             
            
--VENDA NO ANO 2022 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 56, 5,NULL, 'CT11', NULL, 130);             
            
--VENDA NO ANO 2022 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 57, 5,NULL, 'CT11', NULL, 120);             
            
--VENDA NO ANO 2022 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 58, 5,NULL, 'CT11', NULL, 180);             
                        
--VENDA NO ANO 2022 MES 11 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 59, 5,NULL, 'CT11', NULL, 170);                         
            
--VENDA NO ANO 2022 MES 12 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=5 ROSAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 60, 5,NULL, 'CT11', NULL, 150);    
            
-------MACAS------
-------MACAS------ 
 
--VENDA NO ANO 2022 MES 1 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 49, 10,NULL, 'CT14', NULL, 160);              
            
--VENDA NO ANO 2022 MES 2 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 50, 10,NULL, 'CT14', NULL, 150);             
            
--VENDA NO ANO 2022 MES 3 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 51, 10,NULL, 'CT14', NULL, 160);             
                       
--VENDA NO ANO 2022 MES 4 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 52, 10,NULL, 'CT14', NULL, 150);             
            
--VENDA NO ANO 2022 MES 5 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 53, 10,NULL, 'CT14', NULL, 140);             
            
--VENDA NO ANO 2022 MES 6 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=1       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 54, 10,NULL, 'CT14', NULL, 170);             
            
--VENDA NO ANO 2022 MES 7 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 55, 10,NULL, 'CT11', NULL, 160);             
            
--VENDA NO ANO 2022 MES 8 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 56, 10,NULL, 'CT11', NULL, 160);             
            
--VENDA NO ANO 2022 MES 9 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 57, 10,NULL, 'CT11', NULL, 160);             
            
--VENDA NO ANO 2022 MES 10 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 58, 10,NULL, 'CT11', NULL, 160);             
                        
--VENDA NO ANO 2022 MES 11 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 59, 10,NULL, 'CT11', NULL, 160);                         
            
--VENDA NO ANO 2022 MES 12 ,CLIENTE_CODIGO_INTERNO=500, PRODUTO_ID=10 MACAS , HUB_ID=2       
INSERT INTO producao_venda(designacao_p_ou_v,cliente_codigo_interno,tempo_id,produto_id,parcela_agricola_id,hub_id,producao_toneladas,venda_milhares_euros)
            VALUES ('venda', 500, 60, 10,NULL, 'CT11', NULL, 150);               
            
            
----------------------------------
----------CARDINALIDADES----------
----------------------------------

SELECT * FROM cliente ;
SELECT count(*) AS "linhas/tuplos na tabela cliente" FROM cliente;

SELECT * FROM tipo_cultura ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_cultura" FROM tipo_cultura;

SELECT * FROM produto ;
SELECT count(*) AS "linhas/tuplos na tabela produto" FROM produto;

SELECT * FROM cultura ;
SELECT count(*) AS "linhas/tuplos na tabela cultura" FROM cultura;

SELECT * FROM ano ;
SELECT count(*) AS "linhas/tuplos na tabela ano" FROM ano;

SELECT * FROM mes ;
SELECT count(*) AS "linhas/tuplos na tabela mes" FROM mes;

SELECT * FROM tempo ;
SELECT count(*) AS "linhas/tuplos na tabela tempo" FROM tempo;

SELECT * FROM parcela_agricola ;
SELECT count(*) AS "linhas/tuplos na tabela parcela_agricola" FROM parcela_agricola;

SELECT * FROM localizacao ;
SELECT count(*) AS "linhas/tuplos na tabela localizacao" FROM localizacao;

SELECT * FROM tipo_hub ;
SELECT count(*) AS "linhas/tuplos na tabela tipo_hub" FROM tipo_hub;

SELECT * FROM hub ;
SELECT count(*) AS "linhas/tuplos na tabela hub" FROM hub;

SELECT * FROM producao_venda ;
SELECT count(*) AS "linhas/tuplos na tabela producao_venda" FROM producao_venda;


