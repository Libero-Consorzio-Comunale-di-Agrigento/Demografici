--liquibase formatted sql
--changeset amonopoli:202506111115_1 runOnChange:true stripComments:false
create or replace function f_GSD_operazione_log
(a_fase		IN	varchar)

return varchar2

IS 

w_fase		varchar2(255) := upper(a_fase);
w_operazione	varchar2(255);

begin
  if w_fase is not null then
     begin
       select titolo into w_operazione
         from a_voci_menu
        where acronimo = w_fase
          and rownum = 1
       ;
     exception
       when others then
            w_operazione := w_fase;
     end;
  end if;

  return w_operazione;
  
end;
/
