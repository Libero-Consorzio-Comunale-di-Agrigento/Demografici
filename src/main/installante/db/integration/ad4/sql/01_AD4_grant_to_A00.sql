--liquibase formatted sql
--changeset amonopoli:202503261100 runOnChange:true
declare
   d_errore varchar2(32000);
begin
   d_errore := admin_ad4.grant_to('${global.db.a00.username}','DB');
   if d_errore is not null then
      raise_application_error(-20999,'Errori in assegnazione grant:'||d_errore);
   end if;
end;
/
grant execute on ACCESSO to ${global.db.a00.username}
/
