--liquibase formatted sql
--changeset amonopoli:202305231300 runOnChange:true stripComments:false
create or replace function f_ANSC_id_nazionalita
(a_ist_ci		IN	varchar2
)

return varchar2

IS

w_id		varchar2(255);

begin
  if a_ist_ci is not null then
     begin
       select t02.id
         into w_id
         from anpt02 t02
        where codice = a_ist_ci
          ;
      exception 
        when others then
             w_id := '';
     end;
  end if; -- if a_ist_ci is not null then

  return w_id;
end;
/
