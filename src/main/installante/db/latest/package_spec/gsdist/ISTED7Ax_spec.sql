--liquibase formatted sql
--changeset amonopoli:202503211217_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTED7AX is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTED7AX;
/
