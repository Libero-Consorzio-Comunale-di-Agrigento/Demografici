--liquibase formatted sql
--changeset amonopoli:202503211212_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDDU is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTEDDU;
/
