--liquibase formatted sql
--changeset amonopoli:202304141055 runOnChange:true stripComments:false
create or replace trigger ANSTWS_TIU
before INSERT
    or UPDATE
on ANSTWS
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.version := nvl(:new.version,0);
   end;      

   if :new.url like '%anscserviceval.anpr.interno.it%' then
      :new.flag_attributo_jws := '';
   else
      :new.flag_attributo_jws := 'S';
   end if;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANSTWS_TIU */
/
