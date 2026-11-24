--liquibase formatted sql
--changeset amonopoli:202606111535_3 runOnChange:true stripComments:false
create or replace trigger ANADCO_ZK_TD
before DELETE
on ANADCO_ZK
for each row
declare
   w_errore		varchar2(255);
   errore		exception;

begin
  begin
    delete anadcp
     where codice_co = :old.codice_co
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione ANADCP ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete anadct
     where codice_co = :old.codice_Co
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione ANADCT_ZK ('||SQLERRM||')';
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
