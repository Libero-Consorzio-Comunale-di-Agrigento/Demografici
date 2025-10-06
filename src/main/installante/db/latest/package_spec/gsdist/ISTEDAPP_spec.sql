--liquibase formatted sql
--changeset amonopoli:202503211223_1 runOnChange:true stripComments:false
CREATE OR REPLACE package ISTEDAPP is
PROCEDURE MAIN   (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
end ISTEDAPP;
/
