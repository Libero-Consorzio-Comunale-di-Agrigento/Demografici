--liquibase formatted sql
--changeset amonopoli:202506121250 runOnChange:true stripComments:false
create or replace function f_ANA_get_id_pratica
(a_anagrafe	IN	varchar2
,a_tipo_evento	IN	varchar2
,a_anno_pratica	IN	number
,a_pratica	IN	number
)

return varchar2

IS

w_anagrafe	varchar2(255) := upper(a_anagrafe);
w_tipo_evento	varchar2(255) := upper(a_tipo_evento);
w_anno_pratica	number := a_anno_pratica;
w_pratica	number := a_pratica;

w_id_pratica 	varchar2(255);

begin
  if a_anagrafe is not null and a_tipo_evento is not null and a_anno_pratica is not null and a_pratica is not null then
     w_id_pratica := w_anagrafe||w_tipo_evento||w_anno_pratica||lpad(w_pratica,6,'0');
  end if;

  return w_id_pratica;

end;
/

