--liquibase formatted sql
--changeset ftravaglini:202301201135_2_2 runOnChange:true stripComments:false
create or replace function f_CIV_documenti_presentati_mat
(a_tipo_atto		IN	number
,a_parte		IN	number
,a_serie		IN	varchar2
,a_richiamo		IN	number
,a_progr_dettaglio	IN	number
,a_formula		IN	varchar2
,a_tipo_annotazione	IN	varchar2
,a_categoria		IN	varchar2
)

return varchar2

IS

w_return		varchar2(255);

begin
  if a_tipo_atto = 3 then
     if a_formula like '%-OME%' then
        w_return := 'OME';
     elsif a_formula like '%-DUE%' then
        w_return := 'DUE';
     else
        w_return := 'UNODUEALT';
     end if;

  elsif a_tipo_atto = 4 then
     if a_richiamo = 6 and a_progr_dettaglio = 0 then
        w_return := 'UNODUEOMEALT';
     elsif a_richiamo = 6 and a_progr_dettaglio = 1 and a_formula = '54/A' then
        w_return := 'UNO';
     elsif a_richiamo = 6 and a_progr_dettaglio = 1 and a_formula = '54/B' then
        w_return := 'DUE';
     elsif a_richiamo = 6 and a_progr_dettaglio = 1 and a_formula = '55' then
        w_return := 'OME';
     elsif a_richiamo = 6 and a_progr_dettaglio = 1 and a_formula not in ('54/A','54/B','55') then
        w_return := 'OME';
     end if;

  end if;
 
  return w_return;

end;
/
