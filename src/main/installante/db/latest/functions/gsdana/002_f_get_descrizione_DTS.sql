--liquibase formatted sql
--changeset amonopoli:202505271025 runOnChange:true stripComments:false
create or replace function f_get_descrizione_DTS
(a_titolo_studio                   varchar2
)

return varchar2

IS

w_descrizione              varchar2(255);

begin
  if a_titolo_studio is not null then
     begin
       select descrizione
         into w_descrizione
         from anadts
        where cod_ts = a_titolo_studio
       ;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;

  return w_descrizione;

end;
/
