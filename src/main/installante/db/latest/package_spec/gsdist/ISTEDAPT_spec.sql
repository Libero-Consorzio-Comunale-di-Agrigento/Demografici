--liquibase formatted sql
--changeset amonopoli:202503211224_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDAPT is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
end ISTEDAPT;
/
