--liquibase formatted sql
--changeset amonopoli:202504021250_2 runAlways:true runOnChange:true stripComments:false
create or replace function f_get_descrizione_DTP
(a_cod_tp		varchar2
)

return varchar2

IS

w_descrizione              varchar2(255);

begin
  if a_cod_tp is not null then
     begin
       select descrizione
         into w_descrizione
         from anadtp
        where cod_tp = a_cod_tp
       ;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;
  
  return w_descrizione;
  
end;
/
