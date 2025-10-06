--liquibase formatted sql
--changeset amonopoli:202503261004_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE acacanas IS
   PROCEDURE Main ( prenotazione Number, passo Number );
END;
/
