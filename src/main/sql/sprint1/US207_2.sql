SET serveroutput ON;

--- 2. Um utilizador pode listar os Setores de sua exploração agrícola
--- ordenados por ordem decrescente do lucro por hectare
--- em uma determinada safra, medido em K€ por hectare.

CREATE or replace PROCEDURE
hectares_lucro_desc(
    v_user_id utilizador.utilizador_id%type,
    v_ano caderno_campo.ano%TYPE
)
AS
    temp_user_id    utilizador.utilizador_id%TYPE;
    temp_ga_id      gestor_agricola.gestor_agricola_id%TYPE;
    
    ex_nosuch_user EXCEPTION;
    ex_bad_user EXCEPTION;
BEGIN

    SELECT
        u.utilizador_id
    into
        temp_user_id
    FROM
        utilizador u
    WHERE
        u.utilizador_id = v_user_id;
        
    SELECT UNIQUE
        ga.gestor_agricola_id
    INTO
        temp_ga_id
    FROM
        gestor_agricola ga
    WHERE
        ga.gestor_agricola_id = v_user_id;


    dbms_output.put_line('Parcela ID  ||  DESIGNACAO  ||  AREA  ||  LUCRO');
    FOR record IN (
        SELECT
            pa.parcela_agricola_id parcela_id,
            pa.area_ha area,
            pa.designacao designacao,
            sum(rc.quantidade_colhida_ton_por_ha) qtd,
            sum(
                p.valor_mercado_por_ha * rc.quantidade_colhida_ton_por_ha
                ) - custo_fator.custo as lucro
        FROM (
            SELECT
                ia.instalacao_agricola_id ia_id
            FROM
                instalacao_agricola ia
            INNER JOIN
                gestor_agricola ga
                ON ga.instalacao_agricola_id = ia.instalacao_agricola_id
            INNER JOIN
                utilizador usr
                ON usr.utilizador_id = ga.gestor_agricola_id
            WHERE
                usr.utilizador_id = v_user_id
                AND ga.data_inicio_contrato = (
                    SELECT
                        MAX(data_inicio_contrato)
                    FROM
                        gestor_agricola ga2
                    WHERE
                        usr.utilizador_id = ga2.gestor_agricola_id
                )
        ) instalacao_parcela
        INNER JOIN
            parcela_agricola pa
            ON pa.instalacao_agricola_id = instalacao_parcela.ia_id
        INNER JOIN
            registo_cultura rc -- stuff we actually want
            ON rc.parcela_agricola_id = pa.parcela_agricola_id
            AND rc.caderno_campo_id = (
                SELECT 
                    ca.caderno_campo_id
                FROM
                    caderno_campo ca
                WHERE
                    ca.ano = v_ano
            )
        INNER JOIN
            produto p
            ON p.produto_id = rc.produto_id
        INNER JOIN (
            SELECT
                f.parcela_agricola_id,
                sum(fp.preco_por_kg * f.quantidade_utilizada_kg) AS custo
            FROM
                fertilizacao f
            INNER JOIN
                fator_producao fp
                ON fp.fator_producao_id = f.fator_producao_id
                AND v_ano = extract(
                    YEAR FROM f.data_fertilizacao
                )
            GROUP BY
                f.parcela_agricola_id
        ) custo_fator
            ON custo_fator.parcela_agricola_id = pa.parcela_agricola_id
        GROUP BY
            pa.parcela_agricola_id,
            pa.designacao,
            pa.area_ha,
            custo_fator.custo
        ORDER BY
            lucro DESC
    ) LOOP
        dbms_output.put_line(
            record.parcela_id 
            || ',   '
            || record.designacao
            || ',   '
            || record.area
            || ',   '
            || record.qtd
            || ',   '
            || record.lucro
        );
    END LOOP;
    
-- Exceptions
EXCEPTION
    WHEN no_data_found THEN
        if temp_user_id is null THEN
            raise_application_error(
            -20010,
            'O utilizador especificado nao existe!'
            );
        elsif temp_ga_id is null THEN
            raise_application_error(
            -20010,
            'O utilizador especificado nao e um gestor agricola!'
            );
        end if;
END;
/

-- should result in:
-- 2, Japa,     1000.1,  190,  469500
-- 3, Opat,     200.5,  150,   449500
-- 1, Balmada,  1100.2, 190,   279500
-- 4, Xat,      500,    200,   -500
CALL hectares_lucro_desc(1, 2021);

-- expected to fail; user is not a 'gestor agricola
CALL hectares_lucro_desc(2, 2021);

-- expected to fail; user does not exist
CALL hectares_lucro_desc(-22, 2021);