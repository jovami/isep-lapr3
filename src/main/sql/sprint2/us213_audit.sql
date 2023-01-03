-- vim: ft=sqloracle

SET serveroutput on;



--- Acceptance criteria #1 ---
CREATE TABLE exploracao_agr_audit (
    -- TODO: usar algo diff de gen as identity?
    audit_id                INTEGER GENERATED AS IDENTITY,
    login_name              VARCHAR(50),
    operation_date          TIMESTAMP,
    operation_type          VARCHAR(6),
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
SAVEPOINT us_213;

INSERT INTO localizacao (latitude, longitude) values (23.3161,-48.4165);
INSERT INTO instalacao_agricola (
    nome,localizacao_id
) values ('INSTALACAO G31 LAPR3 nova', 1);
INSERT INTO produto (valor_mercado_por_ha,designacao) VALUES (2000,'uva da boa');
INSERT INTO parcela_agricola (
    designacao,area_ha,instalacao_agricola_id
) values ('Parcela teste', 1100.20, 1);
INSERT INTO tipo_cultura(designacao) VALUES ('temporaria');

INSERT INTO registo_colheita (
    parcela_agricola_id, produto_id, tipo_cultura_id, data_plantacao,
    area_plantada_ha, data_colheita, quantidade_colhida_ton_por_ha
) values (
    1, 1, 1, TO_DATE('01/01/2022 11:00', 'DD/MM/YYYY HH24:MI'),
    50, TO_DATE('20/01/2022 12:00', 'DD/MM/YYYY HH24:MI'), 100
);


-- run:
BEGIN
    p_view_audits();
END;
/

ROLLBACK to us_213;

--- Cleanup
DROP TABLE exploracao_agr_audit CASCADE CONSTRAINTS PURGE;
DROP PROCEDURE p_view_audits;

DROP TRIGGER t_registo_colheita_audit;
DROP TRIGGER t_registo_restricao_audit;
DROP TRIGGER t_registo_dado_met_audit;
DROP TRIGGER t_registo_fertilizacao_audit;
DROP TRIGGER t_registo_rega_audit;
DROP TRIGGER t_plano_rega_audit;
