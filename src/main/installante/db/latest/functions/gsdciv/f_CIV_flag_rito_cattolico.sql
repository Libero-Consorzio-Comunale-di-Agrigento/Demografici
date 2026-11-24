--liquibase formatted sql
--changeset amonopoli:202510201255 runOnChange:true stripComments:false
create or replace function f_CIV_flag_rito_cattolico
(a_rito		IN	varchar2
)

return varchar2

IS

w_rito		varchar2(255) := upper(a_rito);

w_flag		varchar2(255);

begin
  if w_rito is not null then
     if replace(w_rito,' ','') in ('CATTOLICO','CONCORDATARIO','CATTOLICOCONCORDATARIO') then
        w_flag := 'S';
     end if;
  end if;
 
  return w_flag;

end;
/
