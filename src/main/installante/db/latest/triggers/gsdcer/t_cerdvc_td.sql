--liquibase formatted sql
--changeset amonopoli:2025020414204 runOnChange:true stripComments:false
create or replace trigger CERDVC_TD
before DELETE
on CERDVC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
w_esiste_dce	number;

begin
  w_esiste_dce := 0;

  begin
    select 1
      into w_esiste_dce
      from cerdce
     where validita = :old.cod_vc
       and rownum = 1
    ;
  exception
    when others then
         w_esiste_dce := 0;
  end;

  if w_esiste_dce = 1 then
     raise_application_error(-20999, 'Eliminazione non consentita: esistono tipi certificato collegati');
  end if;


exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/

