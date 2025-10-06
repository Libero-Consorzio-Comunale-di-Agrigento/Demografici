--liquibase formatted sql
--changeset amonopoli:202503260909_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY acacanas IS
   PROCEDURE Main ( prenotazione Number, passo Number ) is
    wambiente	  varchar2(8);
begin

	 SELECT max(VALORE)
	   INTO wambiente
	   from a_parametri
	  where parametro = 'P_AMBIENTE'
	    and no_prenotazione = prenotazione
		;
	if wambiente is null then	 
	   DELETE FROM A_APPOGGIO_STAMPE
	    WHERE no_prenotazione = prenotazione
		;
	else
		delete 	FROM A_APPOGGIO_STAMPE aas1
		where aas1.no_prenotazione in (select distinct aas.no_prenotazione
			  					   	     from a_appoggio_stampe aas, a_prenotazioni ap
										where ap.no_prenotazione = aas.no_prenotazione
										  and ap.ambiente like wambiente
									  );
	end if;								   
COMMIT;
end;
END;
/
