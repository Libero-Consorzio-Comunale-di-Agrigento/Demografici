--liquibase formatted sql
--changeset amonopoli:202312221025_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTED7A is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTED7A;
/
