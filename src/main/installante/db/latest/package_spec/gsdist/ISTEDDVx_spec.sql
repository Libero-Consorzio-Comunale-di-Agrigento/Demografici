--liquibase formatted sql
--changeset amonopoli:202312211140_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDDVX is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTEDDVX;
/
