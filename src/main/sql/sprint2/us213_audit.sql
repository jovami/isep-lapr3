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
