--liquibase formatted sql
--changeset amonopoli:202512231105 runOnChange:true stripComments:false
create or replace function f_TPR_des_variazione
(a_anagrafe  in  varchar2
,a_tipo_evento  in  varchar2
,a_cod_variazione in varchar2
)
 
return varchar2
 
IS
 
w_anagrafe   varchar2(255) := upper(a_anagrafe);
w_tipo_evento     varchar2(255) := upper(a_tipo_evento);
w_cod_variazione varchar2(255) := upper(a_cod_variazione);
 
w_des_variazione varchar2(255);
 
begin
  if a_anagrafe       is not null and
     a_tipo_evento    is not null
  then
     begin
       select des_evento_tpr
         into w_des_variazione
         from anadce
        where anagrafe       = w_anagrafe
          and tipo_evento    = w_tipo_evento
          and nvl(tipo_evento_tpr,' ') = nvl(w_cod_variazione, ' ')
          and flag_tpr = 'S'
          and rownum = 1
      ;
    exception
      when others then
           w_des_variazione := w_cod_variazione;
    end;
 
  end if;
 
  return w_des_variazione;
end;
/
