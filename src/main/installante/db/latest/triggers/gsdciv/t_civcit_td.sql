--liquibase formatted sql
--changeset amonopoli:202304111720_1 runOnChange:true
create or replace trigger CIVCIT_TD
before DELETE
on CIVCIT
for each row
declare
   w_errore		varchar2(255);
   errore		exception;

begin
  begin
    delete civana
     where id_atto = :old.id_atto
    ;
    delete civana_recupero
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVANA ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civcom
     where id_atto = :old.id_atto
    ;
    delete civcom
     where id_atto_rif = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVCOM ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtli
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTLI ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtli_formule
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTLI_FORMULE ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtli_annotazioni
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTLI_ANNOTAZIONI ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civann
     where id_atto = :old.id_atto
     ;
    delete civann
     where id_atto_rif = :old.id_atto
     ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVANN ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civdpa
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVDPA ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civocc
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVOCC ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civmar
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVMAR ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civsog
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVSOG ('||SQLERRM||')';
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
