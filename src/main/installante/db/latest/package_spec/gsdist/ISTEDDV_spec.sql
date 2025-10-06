--liquibase formatted sql
--changeset amonopoli:202312211135_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDDV is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTEDDV;
/
