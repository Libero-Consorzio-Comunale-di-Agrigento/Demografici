--liquibase formatted sql
--changeset amonopoli:202503261003_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY aaasdost IS
  PROCEDURE Main ( prenotazione Number, passo Number ) is
begin
insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
select prenotazione,passo,0,progressivo,null
  from  a_indici_aiuto
 where ambiente=(select valore
                   from a_parametri
                  where no_prenotazione=prenotazione and
                        parametro='AMBIENTE')
;
commit;
end;
END;
/

