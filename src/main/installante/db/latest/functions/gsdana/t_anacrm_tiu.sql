--liquibase formatted sql
--changeset amonopoli:202606091645_2 runOnChange:true stripComments:false
create or replace trigger ANACRM_TIU
before INSERT or UPDATE
on ANACRM
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   :new.id               := f_ANACRM_nr(:new.id);
   :new.id_pratica       := f_ANA_get_id_pratica('RES','I',:new.anno_pratica,:new.pratica);

   begin
     select cre.id, cre.id_anatpr
       into :new.id_anacre, :new.id_anatpr
       from anacre cre
      where id_pratica = :new.id_pratica
        and rownum = 1
     ;
   exception
     when others then
--          raise_application_error(-20999, 'id_anacre / id_anatpr non trovato ('||sqlerrm||')');
          null;
   end;

   begin  -- Check DATA Integrity on INSERT or UPDATE
      null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      null;
   end;

   begin  -- Set REFERENTIAL Integrity on UPDATE
      null;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
               /* NONE */ null;
         end;
         if IntegrityPackage.Functional then
            begin  -- Switched FUNCTIONAL Integrity at Level 0
               /* NONE */ null;
            end;
         end if;
         IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
      end;
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
/* End Trigger: ANACRM_TIU */
/
