--liquibase formatted sql
--changeset amonopoli:202503211216_1 runOnChange:true stripComments:false
create or replace package ISTED7B is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
FUNCTION  VERSIONE         RETURN varchar2;
end ISTED7B;
/
