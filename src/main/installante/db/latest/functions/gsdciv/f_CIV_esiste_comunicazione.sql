--liquibase formatted sql
--changeset amonopoli:202307031104 runOnChange:true stripComments:false
create or replace function f_CIV_esiste_comunicazione
(a_codice_co	IN	number
,a_tipo_atto	IN	number
,a_formula_dfa	IN 	varchar2
)

return varchar2

IS

w_errore	varchar2(4000);
w_esiste  	number := 0;

begin
  w_errore := '';

  if a_tipo_atto is not null and a_codice_co is not null then
     begin
       select 1
         into w_esiste
         from civcom_v com
        where com.tipo_atto_com = a_tipo_atto
          and com.codice_co     = a_codice_co
          and rownum = 1
       ;
       if w_esiste = 1 then
          w_errore := 'Cancellazione non consentita: esistono comunicazioni associate ad atti in archivio';
       end if;
     exception
       when no_data_found then
            w_errore := '';
     end;

  elsif a_codice_co is not null and a_formula_dfa is not null then
     begin
       select 1
         into w_esiste
         from civcom_v com
        where com.codice_co   = a_codice_co
          and com.formula_dfa = a_formula_dfa
          and rownum = 1
       ;
       if w_esiste = 1 then
          w_errore := 'Cancellazione non consentita: esistono comunicazioni associate a formule in archivio';
       end if;
     exception
       when no_data_found then
            w_errore := '';
     end;
  end if;

  return w_errore;

exception
  when others then
       w_errore := 'Errore generico nel controllo di esistenza della comunicazione';
       return w_errore;
end;
/
