-- vim: ft=sqloracle

SET serveroutput on;



--- Acceptance criteria #1 ---
CREATE TABLE exploracao_agr_audit (
    audit_id                INTEGER GENERATED AS IDENTITY NOT NULL,
    login_name              VARCHAR(50) NOT NULL,
    operation_date          TIMESTAMP NOT NULL,
    operation_type          VARCHAR(6) NOT NULL,
    CONSTRAINT ck_op_type
            CHECK(operation_type IN ('INSERT', 'UPDATE', 'DELETE')),
    CONSTRAINT pk_audit_id PRIMARY KEY(audit_id)
);


--- Acceptance criteria #2 ---
-- Triggers {{{
CREATE OR REPLACE TRIGGER t_registo_colheita_audit
AFTER
    INSERT OR UPDATE OR DELETE ON registo_colheita
FOR EACH ROW
DECLARE
    v_op_type   exploracao_agr_audit.operation_type%TYPE;
BEGIN
    if deleting then
        v_op_type := 'DELETE';
    elsif inserting then
        v_op_type := 'INSERT';
    else
        v_op_type := 'UPDATE';
    end if;

    INSERT into exploracao_agr_audit (
        login_name, operation_date, operation_type
    ) values (USER, SYSTIMESTAMP, v_op_type);
END;
/

CREATE OR REPLACE TRIGGER t_registo_restricao_audit
AFTER
    INSERT OR UPDATE OR DELETE ON registo_restricao
FOR EACH ROW
DECLARE
    v_op_type   exploracao_agr_audit.operation_type%TYPE;
BEGIN
    if deleting then
        v_op_type := 'DELETE';
    elsif inserting then
        v_op_type := 'INSERT';
    else
        v_op_type := 'UPDATE';
    end if;

    INSERT into exploracao_agr_audit (
        login_name, operation_date, operation_type
    ) values (USER, SYSTIMESTAMP, v_op_type);
END;
/

CREATE OR REPLACE TRIGGER t_registo_dado_met_audit
AFTER
    INSERT OR UPDATE OR DELETE ON registo_dado_meteorologico
FOR EACH ROW
DECLARE
    v_op_type   exploracao_agr_audit.operation_type%TYPE;
BEGIN
    if deleting then
        v_op_type := 'DELETE';
    elsif inserting then
        v_op_type := 'INSERT';
    else
        v_op_type := 'UPDATE';
    end if;

    INSERT into exploracao_agr_audit (
        login_name, operation_date, operation_type
    ) values (USER, SYSTIMESTAMP, v_op_type);
END;
/

CREATE OR REPLACE TRIGGER t_registo_fertilizacao_audit
AFTER
    INSERT OR UPDATE OR DELETE ON registo_fertilizacao
FOR EACH ROW
DECLARE
    v_op_type   exploracao_agr_audit.operation_type%TYPE;
BEGIN
    if deleting then
        v_op_type := 'DELETE';
    elsif inserting then
        v_op_type := 'INSERT';
    else
        v_op_type := 'UPDATE';
    end if;

    INSERT into exploracao_agr_audit (
        login_name, operation_date, operation_type
    ) values (USER, SYSTIMESTAMP, v_op_type);
END;
/

CREATE OR REPLACE TRIGGER t_registo_rega_audit
AFTER
    INSERT OR UPDATE OR DELETE ON registo_rega
FOR EACH ROW
DECLARE
    v_op_type   exploracao_agr_audit.operation_type%TYPE;
BEGIN
    if deleting then
        v_op_type := 'DELETE';
    elsif inserting then
        v_op_type := 'INSERT';
    else
        v_op_type := 'UPDATE';
    end if;

    INSERT into exploracao_agr_audit (
        login_name, operation_date, operation_type
    ) values (USER, SYSTIMESTAMP, v_op_type);
END;
/

CREATE OR REPLACE TRIGGER t_plano_rega_audit
AFTER
    INSERT OR UPDATE OR DELETE ON plano_rega
FOR EACH ROW
DECLARE
    v_op_type   exploracao_agr_audit.operation_type%TYPE;
BEGIN
    if deleting then
        v_op_type := 'DELETE';
    elsif inserting then
        v_op_type := 'INSERT';
    else
        v_op_type := 'UPDATE';
    end if;

    INSERT into exploracao_agr_audit(
        login_name, operation_date, operation_type
    ) values (USER, SYSTIMESTAMP, v_op_type);
END;
/
-- }}}


--- Acceptance criteria #3 ---
CREATE or replace PROCEDURE p_view_audits
AS
BEGIN
    dbms_output.put_line('USER            ||    DATE    ||   OPERATION TYPE');

    for record in (
        SELECT a.login_name     as name
            , a.operation_type  as type
            , to_char(a.operation_date, 'YYYY-MM-DD HH24:MI:SS') as dt
        FROM
            exploracao_agr_audit a
        ORDER BY
            a.operation_date ASC
    ) loop
        dbms_output.put_line(
            '' || record.name
            || ' || ' || record.dt
            || ' || ' || record.type
        );
    end loop;
END;
/


-- test setup:
SAVEPOINT us_213_audit;

-- TEST: registo_colheita {{{
INSERT into registo_colheita (
    parcela_agricola_id, produto_id, tipo_cultura_id, data_plantacao,
    area_plantada_ha, data_colheita, quantidade_colhida_ton_por_ha
) values (1, 1, 1, to_date('01/01/2022 20:00', 'DD/MM/YYYY HH24:MI'),
          50, to_date('01/08/2022 20:00', 'DD/MM/YYYY HH24:MI'), 100
);

UPDATE registo_colheita rc
    SET
        rc.quantidade_colhida_ton_por_ha = 200
WHERE
    rc.parcela_agricola_id = 1
    AND rc.produto_id = 1
    AND rc.tipo_cultura_id = 1
    AND rc.data_plantacao = to_date('01/01/2022 20:00', 'DD/MM/YYYY HH24:MI');

DELETE FROM registo_colheita rc
WHERE
    rc.parcela_agricola_id = 1
    AND rc.produto_id = 1
    AND rc.tipo_cultura_id = 1
    AND rc.data_plantacao = to_date('01/01/2022 20:00', 'DD/MM/YYYY HH24:MI');
-- }}}

-- TEST: registo_restricao {{{
INSERT into registo_restricao(
    parcela_agricola_id, fator_producao_id, data_inicio,data_fim
) values (1, 2,
          to_date('02/01/2021 00:00', 'DD/MM/YYYY HH24:MI'),
          to_date('30/12/2021 00:00', 'DD/MM/YYYY HH24:MI')
);

UPDATE registo_restricao rr
    SET rr.data_fim = TO_DATE('30/12/2021 23:00','DD/MM/YYYY HH24:MI')
WHERE
    rr.parcela_agricola_id = 1
    AND rr.fator_producao_id = 2
    AND rr.data_inicio = TO_DATE('02/01/2021 00:00','DD/MM/YYYY HH24:MI');

DELETE FROM registo_restricao rr
WHERE
    rr.parcela_agricola_id = 1
    AND rr.fator_producao_id = 2
    AND rr.data_inicio = TO_DATE('02/01/2021 00:00','DD/MM/YYYY HH24:MI');
-- }}}

-- TEST: registo_dado_meteorologico {{{
INSERT into registo_dado_meteorologico(
    parcela_agricola_id, sensor_id, data_instante_leitura, valor_lido
) values (1, 'SENS1', to_date('10/01/2021 12:00', 'DD/MM/YYYY HH24:MI'), 20
);

UPDATE registo_dado_meteorologico rdm
    SET
        rdm.valor_lido = 10
WHERE
    rdm.parcela_agricola_id = 1
    AND rdm.sensor_id = 'SENS1'
    AND rdm.data_instante_leitura = TO_DATE('10/01/2021 12:00','DD/MM/YYYY HH24:MI');

DELETE FROM registo_dado_meteorologico rdm
WHERE
    rdm.parcela_agricola_id = 1
    AND rdm.sensor_id = 'SENS1'
    AND rdm.data_instante_leitura = TO_DATE('10/01/2021 12:00','DD/MM/YYYY HH24:MI');
-- }}}

-- TEST: registo_fertilizacao {{{
INSERT into registo_fertilizacao (
    parcela_agricola_id, fator_producao_id, data_fertilizacao,
    quantidade_utilizada_kg,tipo_fertilizacao_id
) values (1, 1, to_date('13/01/2021 12:00','DD/MM/YYYY HH24:MI'),
          50, 1
);

UPDATE registo_fertilizacao rf
    SET
        rf.quantidade_utilizada_kg = 100
WHERE
    rf.parcela_agricola_id = 1
    AND rf.fator_producao_id = 1
    AND rf.data_fertilizacao = TO_DATE('13/01/2021 12:00','DD/MM/YYYY HH24:MI');

DELETE FROM registo_fertilizacao rf
WHERE
    rf.parcela_agricola_id = 1
    AND rf.fator_producao_id = 1
    AND rf.data_fertilizacao = TO_DATE('13/01/2021 12:00','DD/MM/YYYY HH24:MI');
-- }}}

-- TEST: registo_rega {{{
INSERT into registo_rega (
    parcela_agricola_id, produto_id, tipo_cultura_id, data_plantacao,
    data_realizacao, quantidade_rega, tempo_rega_mm, tipo_rega_id, tipo_sistema_id
) values (1, 2, 1, to_date('04/01/2021 10:30','DD/MM/YYYY HH24:MI'),
          to_date('16/01/2021 12:00', 'DD/MM/YYYY HH24:MI'), 1001, 30, 1, 1
);

UPDATE registo_rega rr
    SET
        rr.quantidade_rega = 100
WHERE
    rr.parcela_agricola_id = 1
    AND rr.produto_id = 2
    AND rr.tipo_cultura_id = 1
    AND rr.data_plantacao = to_date('04/01/2021 10:30','DD/MM/YYYY HH24:MI')
    AND rr.data_realizacao = to_date('16/01/2021 12:00','DD/MM/YYYY HH24:MI');

DELETE FROM registo_rega rr
WHERE rr.parcela_agricola_id = 1
    AND rr.produto_id = 2
    AND rr.tipo_cultura_id = 1
    AND rr.data_plantacao = to_date('04/01/2021 10:30','DD/MM/YYYY HH24:MI')
    AND rr.data_realizacao = to_date('16/01/2021 12:00','DD/MM/YYYY HH24:MI');
-- }}}

-- TEST: plano_rega {{{
INSERT into plano_rega (
    parcela_agricola_id, produto_id, tipo_cultura_id,
    data_plantacao, periodicidade_rega_hh, tempo_rega_mm
) values (2, 2, 1,
          to_date('04/01/2021 12:00', 'DD/MM/YYYY HH24:MI'), 12, 35
);

UPDATE plano_rega pr
    SET
        pr.periodicidade_rega_hh = 1
WHERE
    pr.plano_rega_id = 7;

DELETE FROM plano_rega pr
WHERE
    pr.plano_rega_id = 7;
-- }}}

-- run:
BEGIN
    p_view_audits();
END;
/

ROLLBACK to us_213_audit;

--- Cleanup
DROP TABLE exploracao_agr_audit CASCADE CONSTRAINTS PURGE;
DROP PROCEDURE p_view_audits;

DROP TRIGGER t_registo_colheita_audit;
DROP TRIGGER t_registo_restricao_audit;
DROP TRIGGER t_registo_dado_met_audit;
DROP TRIGGER t_registo_fertilizacao_audit;
DROP TRIGGER t_registo_rega_audit;
DROP TRIGGER t_plano_rega_audit;
