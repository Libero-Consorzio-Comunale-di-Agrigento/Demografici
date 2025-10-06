--liquibase formatted sql
--changeset amonopoli:202503261005_2 runOnChange:false stripComments:false
CREATE OR REPLACE package body acacanrp is
PROCEDURE MAIN	(prenotazione  IN number,
		  		 PASSO 		   IN number) is
BEGIN
 DELETE FROM A_SEGNALAZIONI_ERRORE
  WHERE no_prenotazione = prenotazione
  ;
  commit;
END;
end;
/

