--liquibase formatted sql
--changeset amonopoli:202503211222_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDAPX is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTEDAPX;
/
