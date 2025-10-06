--liquibase formatted sql
--changeset ftravaglini:20230718940 runOnChange:true stripComments:false
create or replace function f_ANSC_grado_parentela
(a_grado_parentela		IN	varchar2
)

return number

IS

w_id_grado_parentela			number;

begin
  if a_grado_parentela is not null then
     begin
       select t43.id
         into w_id_grado_parentela
         from anst43 t43
        where grado_parentela_ads = a_grado_parentela
       ;
     exception
       when others then
            w_id_grado_parentela := '';
     end;
  else 
     w_id_grado_parentela := '';
  end if;

  return w_id_grado_parentela;
end;
/
