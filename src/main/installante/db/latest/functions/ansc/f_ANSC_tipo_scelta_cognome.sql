--liquibase formatted sql
--changeset amonopoli:202504111230 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_scelta_cognome
(a_tipo_scelta_cognome     IN	varchar2
)

return number

IS

w_tipo_scelta_cognome		varchar2(2) := a_tipo_scelta_cognome;

w_return		number;

begin
  if w_tipo_scelta_cognome is not null then
     begin
       select id into w_return 
         from anst39
        where tipo_scelta_cognome_ads = w_tipo_scelta_cognome
       ;
     exception
       when others then
            w_return := 1;
     end;
  end if;
  
  return w_return;
end;
/
