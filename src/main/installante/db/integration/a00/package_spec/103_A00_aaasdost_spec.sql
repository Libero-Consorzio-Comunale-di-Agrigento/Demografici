--liquibase formatted sql
--changeset amonopoli:202503261003_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE aaasdost IS
  PROCEDURE Main ( prenotazione Number, passo Number );
END;
/
