--liquibase formatted sql
--changeset amonopoli:202503211215_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTED4B is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTED4B;
/
