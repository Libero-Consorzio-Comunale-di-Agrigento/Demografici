--liquibase formatted sql
--changeset amonopoli:202511261130_1 runOnChange:true stripComments:false
create or replace function F_ANAMOD_NR
(a_tipo_modello		IN	varchar2
,a_cod_modello		IN	varchar2
)

return varchar2

IS

w_id		varchar2(255);

begin
   if a_tipo_modello is not null and a_cod_modello is not null then
      w_id := a_tipo_modello||a_cod_modello;
   end if;

   return w_id;

end;
/
