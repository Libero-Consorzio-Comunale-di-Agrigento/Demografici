--liquibase formatted sql
--changeset amonopoli:202503071455_111 runOnChange:true stripComments:false
create or replace procedure ANAFAM_PU
(old_fascia IN number,
 old_cod_fam IN number,
 new_fascia IN number,
 new_cod_fam IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
begin
   begin  -- Check REFERENTIAL Integrity
      
      seq := IntegrityPackage.GetNestLevel;
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
