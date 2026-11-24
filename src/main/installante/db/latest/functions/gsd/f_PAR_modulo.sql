--liquibase formatted sql
--changeset amonopoli:202410281245_2 runOnChange:true stripComments:false
create or replace function f_PAR_modulo
(a_fase		IN	varchar2)

return varchar2

IS

w_modulo	varchar2(255);

begin
  if a_fase is not null then
     begin
       select substr(voce_menu,1,3)
         into w_modulo
         from a_voci_menu
        where acronimo = a_fase
          and rownum   = 1
       ;
     exception
       when others then
            w_modulo := '';
     end;
  end if;
 
  return w_modulo;

end;
/
