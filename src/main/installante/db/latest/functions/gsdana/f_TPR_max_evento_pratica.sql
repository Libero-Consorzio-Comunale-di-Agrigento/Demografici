--liquibase formatted sql
--changeset amonopoli:202512190840_3 runOnChange:true stripComments:false
create or replace function f_TPR_max_evento_pratica
(a_anagrafe 		IN  	varchar2
,a_tipo_evento  	IN  	varchar2
,a_anno_pratica 	IN  	number
,a_pratica  		IN  	number
)

return varchar2

IS

w_anagrafe  	varchar2(255) := upper(a_anagrafe);
w_tipo_evento 	varchar2(255) := upper(a_tipo_evento);
w_anno_pratica	number := a_anno_pratica;
w_pratica 	number := a_pratica;

cursor sel_sap is
select sap.evento_pratica
  from anadep dep
     , anasap sap
 where dep.flag_monitoraggio is not null
   and dep.cod_ep            = sap.evento_pratica
   and sap.anagrafe          = w_anagrafe
   and sap.tipo_evento       = w_tipo_evento
   and sap.anno_pratica      = w_anno_pratica
   and sap.pratica           = w_pratica
   and sap.data_evento||sap.data_restituzione is not null
 order by data_evento desc, sequenza desc, nvl(data_restituzione,data_evento) desc
;

w_evento_pratica  number;

begin
  if a_anagrafe is not null and a_tipo_evento is not null and a_anno_pratica is not null and a_pratica is not null then
     OPEN sel_sap;
     FETCH sel_sap INTO w_evento_pratica;
     CLOSE sel_sap;
  end if;

  return w_evento_pratica;

end;
/
