--liquibase formatted sql
--changeset amonopoli:202503211214_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDD3 is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTEDD3;
/
