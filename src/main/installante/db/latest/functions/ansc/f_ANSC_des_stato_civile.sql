--liquibase formatted sql
--changeset amonopoli:202305191705_3 runOnChange:true stripComments:false
create or replace function f_ANSC_des_stato_civile
(a_id_ansc		IN	varchar2)

return varchar2

IS

w_descrizione		varchar2(255);

begin
  if a_id_ansc is not null then
     begin
       select descrizione
         into w_descrizione
         from anst61
        where id = a_id_ansc
          and rownum = 1 
       ;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;

  return w_descrizione;
end;
/
