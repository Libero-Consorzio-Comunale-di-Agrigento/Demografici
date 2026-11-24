--liquibase formatted sql
--changeset amonopoli:202512190840_4 runOnChange:true stripComments:false
create or replace function f_TPR_gg_monitoraggio
(a_anagrafe 		IN  	varchar2
,a_tipo_evento  	IN  	varchar2
,a_anno_pratica 	IN  	number
,a_pratica  		IN  	number
,a_data_pratica		IN  	number
,a_max_evento_sap	IN	number
)

return number

IS

w_anagrafe  		varchar2(255) := upper(a_anagrafe);
w_tipo_evento 		varchar2(255) := upper(a_tipo_evento);
w_anno_pratica  	number := a_anno_pratica;
w_pratica 		number := a_pratica;

w_data_evento_sap	number;

w_monitoraggio		number;

begin
  if a_max_evento_sap is not null then
     begin
       select max(nvl(sap.data_restituzione,sap.data_evento))
         into w_data_evento_sap
         from anadep dep
            , anasap sap
        where dep.flag_monitoraggio is not null
          and dep.cod_ep            = sap.evento_pratica
          and sap.anagrafe          = w_anagrafe
          and sap.tipo_evento       = w_tipo_evento
          and sap.anno_pratica      = w_anno_pratica
          and sap.pratica           = w_pratica
       ;
     exception
       when others then 
            w_data_evento_sap := '';
     end;
  end if;

  w_monitoraggio := nvl(w_data_evento_sap,to_char(sysdate,'j')) - a_data_pratica;

  return w_monitoraggio;

end;
/
