--liquibase formatted sql
--changeset amonopoli:202509031405_2 runOnChange:true stripComments:false
create or replace function f_DOC_annulla_CC
(a_matricola		IN	number
,a_terminalista		IN	varchar2
)

return number

IS

w_esiste_CC	number;

w_errore	varchar2(32000);
errore 		exception;

w_return	number;


begin

  begin
    select 1 into w_esiste_CC
      from anadoc
     where matricola        = a_matricola
       and tipo_documento   = 'CC'
       and natura_documento != 'A'
       and progr_documento  = 1
       and rownum = 1
   ;
  exception
    when no_data_found then
         w_esiste_CC := 0;
    when others then
         w_esiste_CC := -1;
  end;

  if nvl(w_esiste_CC,-1) = 0 then
     w_errore := 'Possesso Autoveicoli non presente';

  elsif nvl(w_esiste_CC,-1) = -1 then
     w_errore := 'Problema nel controllo di Possesso Autoveicoli';
     raise errore;

  elsif nvl(w_esiste_CC,-1) = 1 then
     begin
       update anadoc 
          set natura_documento = 'A',
              note             = to_char(sysdate,'dd/mm/yyyy hh24:mi')||' ('||a_terminalista||'): annullato possesso autoveicoli'
        where tipo_documento = 'CC'
          and matricola      = a_matricola
          and progr_documento = 1
       ;
     exception
       when others then
            w_errore := 'Errore in annullamento Possesso Autoveicoli';
            raise errore;
     end;
  end if;

  return w_return;
    
exception 
  when errore then
       raise_application_error(-20999, w_errore);
  when others then
       w_errore := 'Errore in annullamento Possesso Autoveicoli (others)';
       raise_application_error(-20999, w_errore);
end;
/
