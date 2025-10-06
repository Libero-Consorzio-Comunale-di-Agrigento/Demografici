--liquibase formatted sql
--changeset amonopoli:202501131620_2 runOnChange:true stripComments:false
create or replace trigger WS_PAGAMENTI_DOC_TIU
before INSERT or UPDATE
on WS_PAGAMENTI_DOC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
--dbms_output.put_line('dentro il trigger');
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id := F_WS_PAGAMENTI_DOC_NR(:new.id);
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      null;
   end;

   begin  -- Set REFERENTIAL Integrity on UPDATE
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
/
