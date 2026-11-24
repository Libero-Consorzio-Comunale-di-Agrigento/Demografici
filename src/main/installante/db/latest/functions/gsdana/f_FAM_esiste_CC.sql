--liquibase formatted sql
--changeset amonopoli:202509300955 runOnChange:true stripComments:false
create or replace function f_FAM_esiste_CC
(a_fascia	IN	number
,a_cod_fam	IN 	number
)

return varchar2

IS

cursor sel_CC is
select matricola 
  from anaana
 where cod_fam      = a_cod_fam
   and fascia       = a_fascia
   and rapporto_par = 'CC'
 order by data_ult_eve desc
;

w_matricola_CC	number;
w_esiste_CC	varchar2(255);

begin
  if nvl(a_fascia,0) = 1 and a_cod_fam is not null then
     OPEN sel_CC;
     FETCH sel_CC INTO w_matricola_CC;
     CLOSE sel_CC;
  end if;

  if w_matricola_CC is not null then
     w_esiste_CC := 'S';
  end if;

  return w_esiste_CC;

end;
/
