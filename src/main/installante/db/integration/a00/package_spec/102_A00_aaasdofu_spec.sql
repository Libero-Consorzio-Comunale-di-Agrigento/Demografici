--liquibase formatted sql
--changeset amonopoli:202503261002_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE AAASDOFU IS
    PROCEDURE Main ( prenotazione Number, passo Number );
END AAASDOFU;
/
