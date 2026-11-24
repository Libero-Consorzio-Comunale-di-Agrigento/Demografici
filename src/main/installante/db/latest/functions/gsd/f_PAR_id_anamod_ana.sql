--liquibase formatted sql
--changeset amonopoli:202512021440 runOnChange:true stripComments:false
create or replace function f_PAR_id_anamod_ana
(a_fase		IN	varchar2
,a_funzione	IN	varchar2
)

return varchar2

IS

w_tipo_modello		varchar2(255);
w_cod_modello		varchar2(255);

w_id_anamod		varchar2(255);

begin
  if a_fase||a_funzione is not null then
     if a_fase = 'SCAW' then
        w_tipo_modello := 'C';
     else 
        w_tipo_modello := 'P';
     end if;
     w_cod_modello := substr(a_funzione,2);

     w_id_anamod := w_tipo_modello||w_cod_modello;
  end if;
 
  return w_id_anamod;

end;
/
