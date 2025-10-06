--liquibase formatted sql
--changeset amonopoli:202502041155 runOnChange:true stripComments:false
create or replace trigger CERDTP_TD
before DELETE
on CERDTP
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_esiste_cem	number;

begin
  w_esiste_cem := 0;

  begin
    select 1
      into w_esiste_cem
      from cercem
     where tipo_pagamento = :old.cod_tp
       and rownum = 1
    ;
  exception
    when others then
         w_esiste_cem := 0;
  end;

  if w_esiste_cem = 1 then
     raise_application_error(-20999, 'Eliminazione non consentita: esistono certificati emessi');
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

