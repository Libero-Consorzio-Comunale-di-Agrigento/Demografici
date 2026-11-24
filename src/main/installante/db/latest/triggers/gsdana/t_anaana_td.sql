--liquibase formatted sql
--changeset amonopoli:202501311415_3 runOnChange:true stripComments:false
CREATE OR REPLACE TRIGGER ANAANA_TD
before DELETE
on ANAANA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   w_abilito        number;
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
      -- Child Restrict Table: ELEANA
      w_abilito := f_se_elimina_anaana(:OLD.matricola,:OLD.fascia);
      if w_abilito = 1
         then delete from ANAAPM where matricola = :OLD.matricola;
         else errno  := -20006;
              errmsg := 'Esistono dei riferimenti. La registrazione di Individui non e'' eliminabile.';
              raise integrity_error;
      end if;
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
