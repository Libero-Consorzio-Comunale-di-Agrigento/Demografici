--liquibase formatted sql
--changeset amonopoli:202304111720_4 runOnChange:true
create or replace trigger CIVMOR_TD
before DELETE
on CIVMOR
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
    delete civcom
     where (anno,atto,parte,nvl(serie,' '),ufficio) =
           (select anno,atto,parte,nvl(serie,' '),ufficio
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas
               and cod_com_nas      = :old.cod_com_nas
               and nvl(data_nas,0)  = nvl(:old.data_nas,0)
               and cognome_nome     = :old.cognome_nome
               and cod_rec          = 0)
       and formula          = '164'
       and tipo_atto        = 2
       and :old.natura          = 'O'
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVCOM ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civttr
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTTR ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtes
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTES ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civdic
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVDIC ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtte
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTTE ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civdmo
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVDMO ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civgmo
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVGMO ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civchi
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVCHI ('||SQLERRM||')';
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
    delete civann
     where (anno,atto,parte,nvl(serie,' '),ufficio) =
           (select anno,atto,parte,nvl(serie,' '),ufficio
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas
               and cod_com_nas      = :old.cod_com_nas
               and nvl(data_nas,0)  = nvl(:old.data_nas,0)
               and cognome_nome     = :old.cognome_nome
               and cod_rec          = 0)
       and to_number(c6)    = :old.anno
       and c7               = decode(:old.parte,1,'I','II')
       and upper(nvl(c8,' '))       = decode(:old.serie,'',' ',
                                             upper('SERIE '||:old.serie))
       and to_number(c9)    = :old.atto
       and formula          = '164'
       and tipo_atto        = 2
       and :old.natura          = 'O'
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

  begin
    delete civdts
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVDTS ('||SQLERRM||')';
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
