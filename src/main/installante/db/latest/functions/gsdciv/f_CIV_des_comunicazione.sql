--liquibase formatted sql
--changeset amonopoli:202402221235 runOnChange:true stripComments:false
create or replace function f_CIV_des_comunicazione
(a_tipo_atto		IN	number
,a_codice_co		IN	number
,a_formula		IN	varchar2
,a_escape       IN	varchar2	default 'N'
)

return varchar2

IS

w_descrizione	varchar2(255);

begin
  if a_tipo_atto is not null and a_codice_co is not null then
     begin
       select descrizione
         into w_descrizione
         from civdco dco
        where codice_co = a_codice_co
       ;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;

  if w_descrizione is not null and a_escape = 'S' then
     w_descrizione := replace(w_descrizione,'/','_');
  elsif w_descrizione is not null and a_formula is not null then
     w_descrizione := w_descrizione||' (Formula '||f_CIV_formula_ann(a_tipo_atto,a_formula,'')||')';
  end if;

  return w_descrizione;

end;
/
