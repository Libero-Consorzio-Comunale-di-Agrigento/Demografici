--liquibase formatted sql
--changeset amonopoli:202503211226_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDP2 is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTEDP2;
/
