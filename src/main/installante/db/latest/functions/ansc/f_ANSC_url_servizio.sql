--liquibase formatted sql
--changeset amonopoli:202305181155 runOnChange:true stripComments:false
create or replace function f_ANSC_url_servizio
(a_servizio	IN	varchar2)

return varchar2

IS

w_url	varchar2(255);

begin
  begin
    select url
      into w_url
      from anstws
     where id = a_servizio
    ; 
  exception
    when others then
         w_url := '';
  end;

  return w_url;

end;
/
