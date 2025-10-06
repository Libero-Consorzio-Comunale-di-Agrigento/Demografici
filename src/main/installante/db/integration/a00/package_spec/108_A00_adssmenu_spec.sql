--liquibase formatted sql
--changeset amonopoli:202503261008_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE adssmenu IS
  PROCEDURE Main ( prenotazione Number, passo Number );
END;
/
