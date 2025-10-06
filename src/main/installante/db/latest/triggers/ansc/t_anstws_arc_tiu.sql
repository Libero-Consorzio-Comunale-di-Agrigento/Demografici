--liquibase formatted sql
--changeset amonopoli:202305050930_2 runOnChange:true stripComments:false
create or replace trigger ANSTWS_ARC_TIU
before INSERT
    or UPDATE
on ANSTWS_ARC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id      := F_ANSTWS_ARC_NR(:new.id);
     :new.version := nvl(:new.version,0);
   end;      

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
         null;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
         null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANSTWS_ARC_TIU */
/
