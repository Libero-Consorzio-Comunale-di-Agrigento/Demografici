--liquibase formatted sql
--changeset amonopoli:202503211219_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDP4X is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTEDP4X;
/
