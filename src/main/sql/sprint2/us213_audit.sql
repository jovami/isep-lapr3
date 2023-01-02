-- vim: ft=sqloracle

SET serveroutput on;

DROP TABLE exploracao_agr_audit CASCADE CONSTRAINTS PURGE;


--- Acceptance criteria #1 ---
CREATE TABLE exploracao_agr_audit (
    -- TODO: usar algo diff de gen as identity?
    audit_id                INTEGER GENERATED AS IDENTITY,
    login_name              VARCHAR(50),
    operation_date          DATE,
    operation_type          VARCHAR(6),
    CONSTRAINT ck_op_type
            CHECK(operation_type IN ('INSERT', 'UPDATE', 'DELETE')),
    CONSTRAINT pk_audit_id PRIMARY KEY(audit_id)
);


--- Acceptance criteria #2 ---
CREATE OR REPLACE TRIGGER t_exploracao_agr_operations
AFTER
    INSERT OR UPDATE OR DELETE ON parcela_agricola
FOR EACH ROW
DECLARE
    v_op_type   exploracao_agr_audit.operation_type%TYPE;
BEGIN
    if deleting then
        v_op_type := 'DELETE';
    elsif inserting then
        v_op_type := 'INSERT';
    else
        v_op_type := 'DELETE';
    end if;

    INSERT into exploracao_agr_audit
        (login_name, operation_date, operation_type)
        values (USER, SYSDATE, v_op_type);
END;
/


--- Acceptance criteria #3 ---
CREATE or replace PROCEDURE p_view_audits
AS
BEGIN
    dbms_output.put_line('   USER   ||   DATE   ||   OPERATION TYPE');

    for record in (
        SELECT a.login_name     as name
            , a.operation_date  as dt
            , a.operation_type  as type
        FROM
            exploracao_agr_audit a
        ORDER BY
            a.operation_date ASC
    ) loop
        dbms_output.put_line(
            '' || record.name
            || '||' || record.dt
            || '||' || record.type
        );
    end loop;
END;
/

-- run:
BEGIN
    p_view_audits();
END;
