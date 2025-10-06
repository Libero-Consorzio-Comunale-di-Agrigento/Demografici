--liquibase formatted sql
--changeset amonopoli:202503261004_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY acacanas IS
   PROCEDURE Main ( prenotazione Number, passo Number ) is
begin
DELETE FROM A_APPOGGIO_STAMPE
WHERE no_prenotazione = prenotazione
;
COMMIT;
end;
END;
/
