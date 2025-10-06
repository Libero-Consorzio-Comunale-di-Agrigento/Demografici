--liquibase formatted sql
--changeset amonopoli:202503211135_1 runOnChange:true stripComments:false
create or replace trigger ANAANA_IST_TIU
before INSERT
    or UPDATE
on ANAANA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

begin
 if nvl(w_integrazione_istat,'N') = 'S' then
   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
	    if INSERTING then
		ANAANA_IST_FI(:new.fascia,:new.stato,:new.matricola,:new.cod_fam,
 			      :new.ufficio_nas,:new.anno_atto_nas,:new.atto_nas,:new.parte_nas,:new.serie_nas,
 			      :new.ufficio_nas_tr,:new.anno_atto_nas_tr,
			      :new.atto_nas_tr,:new.parte_nas_tr,:new.serie_nas_tr);
	    end if;
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
 end if; --if nvl(w_integrazione_istat,'N') = 'S' then
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANAANA_IST_TIU */
/
