--liquibase formatted sql
--changeset amonopoli:202305231225_1 runOnChange:true stripComments:false
create or replace function f_ANSC_des_tipo_file
(a_id		IN	number
)

return varchar2

IS

w_descrizione		varchar2(255);

begin
  if a_id is not null then
     begin
       select t10.descrizione
         into w_descrizione
         from anst10 t10
        where id = a_id
          ;
      exception 
        when others then
             w_descrizione := '';
     end;
  end if; -- if a_id is not null then

  return w_descrizione;
end;
/
