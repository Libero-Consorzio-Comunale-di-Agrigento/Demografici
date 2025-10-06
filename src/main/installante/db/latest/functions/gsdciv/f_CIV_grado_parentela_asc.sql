--liquibase formatted sql
--changeset ftravaglini:202309121500 runOnChange:true stripComments:false
create or replace function f_CIV_grado_parentela_asc
(a_grado_parentela		IN	varchar2
)

return number

IS

w_id_grado_parentela			number;

begin
  if a_grado_parentela is not null then
     begin
       select upper(t43.descrizione)
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
