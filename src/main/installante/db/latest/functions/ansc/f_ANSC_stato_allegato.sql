--liquibase formatted sql
--changeset amonopoli:202305111455_2 runOnChange:true stripComments:false
create or replace function f_ANSC_stato_allegato
(a_stato_allegato	number
)

return varchar2

IS

w_descrizione			varchar2(255);

begin
  if a_stato_allegato is not null then
     begin
       select descrizione
         into w_descrizione
         from anst08
        where id = a_stato_allegato
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



 