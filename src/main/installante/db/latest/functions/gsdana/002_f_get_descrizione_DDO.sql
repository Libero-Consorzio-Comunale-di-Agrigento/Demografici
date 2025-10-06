--liquibase formatted sql
--changeset amonopoli:202307071120_1 runAlways:true runOnChange:true stripComments:false
create or replace function f_get_descrizione_DDO
(a_cod_do		varchar2
)

return varchar2

IS

w_descrizione              varchar2(255);

begin
  if a_cod_do is not null then
     begin
       select descrizione
         into w_descrizione
         from anaddo
        where cod_do = a_cod_do
       ;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;
  
  return w_descrizione;
  
end;
/
