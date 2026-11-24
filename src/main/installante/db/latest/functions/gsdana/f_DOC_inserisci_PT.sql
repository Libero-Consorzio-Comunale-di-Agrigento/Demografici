--liquibase formatted sql
--changeset amonopoli:202509031340_1 runOnChange:true stripComments:false
create or replace function f_DOC_inserisci_PT
(a_matricola		IN	number
)

return number

IS

w_esiste_PT	number;

w_errore	varchar2(32000);
errore 		exception;

w_return	number;


begin

  begin
    select 1 into w_esiste_PT
      from anadoc
     where matricola        = a_matricola
       and tipo_documento   = 'PT'
       and natura_documento != 'A'
       and progr_documento  = 1
       and rownum = 1
   ;
  exception
    when no_data_found then
         w_esiste_PT := 0;
    when others then
         w_esiste_PT := -1;
  end;

  if nvl(w_esiste_PT,-1) = 1 then
     w_errore := 'Possesso Patente già presente';

  elsif nvl(w_esiste_PT,-1) = -1 then
     w_errore := 'Problema nel controllo di Possesso Patente';
     raise errore;

  elsif nvl(w_esiste_PT,-1) = 0 then
     begin
       update anadoc 
          set progr_documento = progr_documento + 1
        where tipo_documento = 'PT'
          and matricola      = a_matricola
       ;
     exception
       when others then
            w_errore := 'Errore in storicizzazione Patenti';
            raise errore;
     end;

     begin
       insert into anadoc (matricola, tipo_documento, progr_documento, natura_documento)
       values (a_matricola, 'PT', 1, 'O')
       ;
     exception
       when others then
            w_errore := 'Errore in inserimento Possesso Patente';
            raise errore;
     end;
  end if;

  return w_return;
    
exception 
  when errore then
       raise_application_error(-20999, w_errore);
  when others then
       w_errore := 'Errore in inserimento Possesso Patente (others)';
       raise_application_error(-20999, w_errore);
end;
/
