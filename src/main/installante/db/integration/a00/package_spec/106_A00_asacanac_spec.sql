--liquibase formatted sql
--changeset amonopoli:202503261006_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE asacanac IS
  PROCEDURE Main ( prenotazione Number, passo Number );
END;
/
