--liquibase formatted sql
--changeset amonopoli:202504021250_1 runAlways:true runOnChange:true stripComments:false
create or replace function f_get_descrizione_TSE
(a_cod_se		varchar2
)

return varchar2

IS

w_descrizione              varchar2(255);

begin
  if a_cod_se is not null then
     begin
       select descrizione
         into w_descrizione
         from anatse
        where cod_se = a_cod_se
       ;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;
  
  return w_descrizione;
  
end;
/
