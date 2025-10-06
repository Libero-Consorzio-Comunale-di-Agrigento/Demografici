--liquibase formatted sql
--changeset amonopoli:202503260909_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE acacanas IS
   PROCEDURE Main ( prenotazione Number, passo Number );
END;
/
