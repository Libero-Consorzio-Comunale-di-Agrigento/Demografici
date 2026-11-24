--liquibase formatted sql
--changeset amonopoli:202501311415_111 runOnChange:true stripComments:false
create or replace procedure ANAANA_PU
(old_matricola IN number,
 new_matricola IN number)
is
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
   seq              number;
   mutating         exception;
   PRAGMA exception_init(mutating, -4091);
   
   --  Declaration of UpdateParentRestrict constraint for "ANADOC"
   cursor cfk1_anaana(var_matricola number) is
      select 1
      from   ANADOC
      where  MATRICOLA = var_matricola
       and   var_matricola is not null;
begin
   begin  -- Check REFERENTIAL Integrity
      
      seq := IntegrityPackage.GetNestLevel;
      
      --  Chiave di "ANAANA" non modificabile se esistono referenze su "ANADOC"
      if (OLD_MATRICOLA != NEW_MATRICOLA) then
         open  cfk1_anaana(OLD_MATRICOLA);
         fetch cfk1_anaana into dummy;
         found := cfk1_anaana%FOUND;
         close cfk1_anaana;
         if found then
            errno  := -20005;
            errmsg := 'Esistono riferimenti su ANADOC. La registrazione di ANAANA non e'' modificabile.';
            raise integrity_error;
         end if;
      end if;
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
