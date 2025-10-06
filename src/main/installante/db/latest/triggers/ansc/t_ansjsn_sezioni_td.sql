--liquibase formatted sql
--changeset amonopoli:202304281530_3 runOnChange:true stripComments:false
create or replace trigger ANSJSN_SEZIONI_TD
before DELETE
on ANSJSN_SEZIONI
for each row
declare
   w_errore		varchar2(255);
   errore		exception;

begin
  begin
    delete ansjsn_campi
     where id_sezione = :old.id
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione ANSJSN_CAMPI ('||SQLERRM||')';
         raise errore;
  end;

exception
  when errore then
       raise_application_error(-20999, w_errore);
	 ROLLBACK;
  when others then
       raise_application_error(-20999, 'Errore ('||SQLERRM||')');
	 ROLLBACK;
end;
/
