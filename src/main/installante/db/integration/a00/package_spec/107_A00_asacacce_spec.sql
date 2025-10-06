--liquibase formatted sql
--changeset amonopoli:202503261007_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE asacacce IS
  PROCEDURE Main ( prenotazione Number, passo Number );
END;
/
