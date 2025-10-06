--liquibase formatted sql
--changeset amonopoli:202503261009_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE body CONTAPAG IS
function valore return number is
begin
  return numpag;
end;
procedure inizializza is
begin
  numpag := 1;
end;
procedure incrementa is
begin
  numpag := numpag+1;
end;
END CONTAPAG;
/

