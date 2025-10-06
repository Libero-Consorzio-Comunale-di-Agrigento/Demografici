--liquibase formatted sql
--changeset snocca:202212051038 runOnChange:true
create or replace trigger civcom_td
before DELETE
on CIVCOM
for each row
declare

   w_ctr_alle           number;
   w_ctr_prot           number;

   w_errore		varchar2(255);
   errore		exception;
  
   w_operazione_log     varchar2(255) := 'civcom_td'; 

begin
  begin
    select 1 into w_ctr_alle
      from civcom_alle
     where id_com = :old.id
       and rownum = 1
    ;
  exception
    when no_data_found then
         w_ctr_alle := 0;
    when others then
         w_errore := 'Errore in ricerca CIVCOM_ALLE ('||SQLERRM||')';
         raise errore;
  end;

  begin
    select 1 into w_ctr_prot
      from civcom_prot
     where id           = :old.id
       and flag_ws_prot is not null
       and rownum = 1
    ;
  exception
    when no_data_found then
         w_ctr_prot := 0;
    when others then
         w_errore := 'Errore in ricerca CIVCOM_PROT ('||SQLERRM||')';
         raise errore;
  end;

  if w_ctr_prot = 1 then
     w_errore := 'Eliminazione non consentita. Esiste comunicazione gi� protocollata (id '||:old.id||')';
     raise errore;
  else
     begin
       delete civcom_prot
        where id           = :old.id
          and flag_ws_prot is null
       ;
       if sql%notfound then
          begin
            delete civcom_alle
             where id_com = :old.id
            ;
          exception 
            when others then
                 w_errore := 'Errore in eliminazione CIVCOM_ALLE ('||SQLERRM||')';
                 raise errore;
          end;
       end if;
     exception 
       when others then
            w_errore := 'Errore in eliminazione CIVCOM_PROT ('||SQLERRM||')';
            raise errore;
     end;
  end if;

<< fine >>
null;

exception
  when errore then
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
       raise_application_error(-20999, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
       raise_application_error(-20999, w_errore);
end;
/
