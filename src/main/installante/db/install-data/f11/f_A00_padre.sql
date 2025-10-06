--liquibase formatted sql
--changeset amonopoli:202503211020 runOnChange:true stripComments:false
create or replace function f_A00_padre
(a_voce_menu		IN	varchar2
,a_applicazione		IN	varchar2
,a_ruolo		IN 	varchar2
)

return number

IS

w_padre	number;

begin
  begin
    select figlio
      into w_padre
      from a_menu
     where applicazione	= a_applicazione
       and voce_menu	= a_voce_menu
       and ruolo	= a_ruolo
       and rownum 	= 1
    ;
  exception
    when others then 
         w_padre := 0;
  end;
  
  return w_padre;

end;
/
