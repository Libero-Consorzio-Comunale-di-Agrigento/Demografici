--liquibase formatted sql
--changeset amonopoli:202303271045 runOnChange:true stripComments:false
create or replace function f_CIV_comprensione
(a_comprensione		IN	varchar2
,a_sesso		IN	varchar2	default NULL
)

return varchar2

IS

w_sesso			varchar2(255) := upper(a_sesso);

w_testo_formula		varchar2(255);
w_descrizione		varchar2(255);


begin
  if a_comprensione is not null then
     begin
       select lower(descrizione), decode(w_sesso, 'M', testo_formula_m, 'F', testo_formula_f)
         into w_descrizione, w_testo_formula
         from civdcd
        where cod_cd = a_comprensione
       ;
     exception
       when others then
            w_descrizione := '';
     end;


  end if;

  return nvl(w_testo_formula,w_descrizione);

end;
/
