--liquibase formatted sql
--changeset amonopoli:202304111720_5 runOnChange:true
create or replace trigger CIVUCI_TD
before DELETE
on CIVUCI
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
    delete civann
     where id_atto = :old.id_atto
    ;
    delete civann
     where id_atto_rif = :old.id_atto
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) =
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_m
               and cod_com_nas      = :old.cod_com_nas_m
               and nvl(data_nas,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome     = :old.cognome_nome_m
               and cod_rec          = 0)
       and tipo_atto        = 2
       and data_reg         = :old.data_reg
       and formula          in (select nat.formula
                                  from civuci_natura nat
                                 where tipo_atto = 2
                                   and natura    = :old.natura_uci)
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) =
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_f
               and cod_com_nas      = :old.cod_com_nas_f
               and nvl(data_nas,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome     = :old.cognome_nome_f
               and cod_rec          = 0)
       and tipo_atto        = 2
       and data_reg         = :old.data_reg
       and formula          in (select nat.formula
                                  from civuci_natura nat
                                 where tipo_atto = 2
                                   and natura    = :old.natura_uci)
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) =
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civmat mat
             where cod_pro_nas_m      = :old.cod_pro_nas_m
               and cod_com_nas_m      = :old.cod_com_nas_m
               and nvl(data_nas_m,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome_m     = :old.cognome_nome_m
               and cod_pro_nas_f      = :old.cod_pro_nas_f
               and cod_com_nas_f      = :old.cod_com_nas_f
               and nvl(data_nas_f,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome_f     = :old.cognome_nome_f
               and cod_rec          = 0)
       and tipo_atto        = 4
       and data_reg         = :old.data_reg
       and formula          in (select nat.formula
                                  from civuci_natura nat
                                 where tipo_atto = 4
                                   and natura    = :old.natura_uci)
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVANN ('||SQLERRM||')';
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
     where (ufficio,anno,atto,parte,nvl(serie,' ')) =
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_m
               and cod_com_nas      = :old.cod_com_nas_m
               and nvl(data_nas,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome     = :old.cognome_nome_m
               and cod_rec          = 0)
       and tipo_atto        = 2
       and formula          in (select nat.formula
                                  from civuci_natura nat
                                 where tipo_atto = 2
                                   and natura    = :old.natura_uci)
    ;
    delete civcom
     where (ufficio,anno,atto,parte,nvl(serie,' ')) =
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_f
               and cod_com_nas      = :old.cod_com_nas_f
               and nvl(data_nas,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome     = :old.cognome_nome_f
               and cod_rec          = 0)
       and tipo_atto        = 2
       and formula          in (select nat.formula
                                  from civuci_natura nat
                                 where tipo_atto = 2
                                   and natura    = :old.natura_uci)
    ;
    delete civcom com
     where (ufficio,anno,atto,parte,nvl(serie,' ')) =
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civmat mat
             where cod_pro_nas_m      = :old.cod_pro_nas_m
               and cod_com_nas_m      = :old.cod_com_nas_m
               and nvl(data_nas_m,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome_m     = :old.cognome_nome_m
               and cod_pro_nas_f      = :old.cod_pro_nas_f
               and cod_com_nas_f      = :old.cod_com_nas_f
               and nvl(data_nas_f,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome_f     = :old.cognome_nome_f
               and cod_rec          = 0)
       and tipo_atto        = 4
       and formula          in (select nat.formula
                                  from civuci_natura nat
                                 where tipo_atto = 4
                                   and natura    = :old.natura_uci)
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVCOM ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civspo
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVSPO ('||SQLERRM||')';
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
    delete civtta
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTTA ('||SQLERRM||')';
         raise errore;
  end;
  
  begin
    delete civpdo
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVPDO ('||SQLERRM||')';
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
