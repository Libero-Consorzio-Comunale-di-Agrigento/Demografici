--liquibase formatted sql
--changeset amonopoli:202503071455_3 runOnChange:true stripComments:false
create or replace trigger ANAFAM_TD
before DELETE
on ANAFAM
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
   begin  -- Check REFERENTIAL Integrity on DELETE
     update anaap4 
        set cod_fam_dest        = '',
            cod_fam_unique_dest = ''
      where cod_fam_unique_dest = :old.cod_fam_unique
     ;
     update anacre
        set cod_fam_dest        = '',
            cod_fam_unique_dest = ''
      where cod_fam_unique_dest = :old.cod_fam_unique
     ;
   end;
   begin  -- Set REFERENTIAL Integrity on DELETE
      IntegrityPackage.NextNestLevel;
      IntegrityPackage.PreviousNestLevel;
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
