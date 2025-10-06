--liquibase formatted sql
--changeset amonopoli:202501041200 runOnChange:true stripComments:false
create or replace trigger CERDMS_TD
before DELETE
on CERDMS
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_esiste_ana	number;

begin
  w_esiste_ana := 0;

  begin
    select 1
      into w_esiste_ana
      from anaana
     where sospensione = :old.cod_ms
       and rownum = 1
    ;
  exception
    when others then
         w_esiste_ana := 0;
  end;

  if w_esiste_ana = 1 then
     raise_application_error(-20999, 'Eliminazione non consentita: esistono soggetti collegati');
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

