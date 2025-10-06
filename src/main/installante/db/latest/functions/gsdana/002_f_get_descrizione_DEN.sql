--liquibase formatted sql
--changeset amonopoli:202307071120_2 runAlways:true runOnChange:true stripComments:false
create or replace function f_get_descrizione_DEN
(a_cod_en		varchar2
)

return varchar2

IS

w_descrizione              varchar2(255);

begin
  if a_cod_en is not null then
     begin
       select descrizione
         into w_descrizione
         from anaden
        where cod_en = a_cod_en
       ;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;
  
  return w_descrizione;
  
end;
/
