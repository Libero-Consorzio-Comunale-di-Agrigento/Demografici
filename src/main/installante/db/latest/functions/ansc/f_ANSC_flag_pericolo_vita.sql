--liquibase formatted sql
--changeset ftravaglini:202307251030 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_pericolo_vita
(a_tipo_impossibilitato	IN	varchar2,
a_codice                IN	varchar2
)

return varchar2

IS

w_tipo_impossibilitato	varchar2(255) := upper(a_tipo_impossibilitato);
w_codice		varchar2(255) := upper(a_codice);

w_flag			varchar2(10);

begin
  if w_tipo_impossibilitato is not null and w_codice is not null then
     if instr(w_tipo_impossibilitato,w_codice) > 0 then
        w_flag := 'true'; 
     elsif w_codice in ('SO', 'SA', 'C1', 'C2') and w_tipo_impossibilitato like '%EN%' then
        w_flag := 'true';
     else
        w_flag := 'false'; 
     end if;
  else
     w_flag := 'false';
  end if;

  return w_flag;
end;
/