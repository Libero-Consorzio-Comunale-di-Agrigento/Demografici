--liquibase formatted sql
--changeset amonopoli:202606091245_3 runOnChange:true stripComments:false
create or replace trigger ANAAPM_TD
before DELETE
on ANAAPM
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
-- Creata il 05/06/2006 (A.Monopoli) - Salvataggio Anagrafica

   begin -- Set FUNCTIONAL Integrity on DELETE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            ANAAPM_FI(:new.matricola,:new.anno_dic,:new.numero_dic,:new.annullamento,
		      :old.matricola,:old.anno_dic,:old.numero_dic,:old.annullamento);
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;

   begin  -- Check REFERENTIAL Integrity on DELETE
            /* NONE */ null;
   end;

   begin  -- Set REFERENTIAL Integrity on DELETE
      IntegrityPackage.NextNestLevel;
            /* NONE */ null;
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
/* End Trigger: ANAAPM_TD */
/
