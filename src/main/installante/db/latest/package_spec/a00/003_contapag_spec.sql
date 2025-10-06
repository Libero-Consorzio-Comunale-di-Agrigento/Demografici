--liquibase formatted sql
--changeset amonopoli:202503260903_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE CONTAPAG IS
numpag number(10);
function valore  return number;
procedure inizializza;
procedure incrementa;
end;
/
