--liquibase formatted sql
--changeset amonopoli:202504231455 runOnChange:true stripComments:false
create or replace function f_FAM_matricola_CF
(a_fascia	IN	number
,a_cod_fam	IN 	number
)

return varchar2

IS

cursor sel_CF is
select matricola
  from anaana
 where cod_fam      = a_cod_fam
   and fascia       = a_fascia
   and rapporto_par = 'CF'
 order by data_ult_eve desc
;

w_matricola_CF	number;

begin
  if a_fascia is not null and a_cod_fam is not null then
     OPEN sel_CF;
     FETCH sel_CF INTO w_matricola_CF;
     CLOSE sel_CF;
  end if;

  return w_matricola_CF;

end;
/
