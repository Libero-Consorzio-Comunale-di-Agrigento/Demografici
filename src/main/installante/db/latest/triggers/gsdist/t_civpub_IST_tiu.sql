--liquibase formatted sql
--changeset amonopoli:202401181010_2 runOnChange:true stripComments:false
create or replace trigger CIVPUB_IST_TIU
before INSERT
    or UPDATE
on CIVPUB
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

begin
--
-- 18/01/2024 (AM): gestito UPDATE di comune matrimonio (rif. CIVPUB_IST_FI)
--

 if nvl(w_integrazione_istat,'N') = 'S' then
   begin  -- Check DATA Integrity on INSERT or UPDATE
     if INSERTING then
        :new.id_atto      := nvl(:new.id_atto,f_CIV_get_id_atto(3,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto));
     end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         null;
      end if;
      if INSERTING then
         null;
      end if;
   end;

   begin  -- Set REFERENTIAL Integrity on UPDATE
      if UPDATING then
         IntegrityPackage.NextNestLevel;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
                ISTAT_PKG.ins_log('civpub_ist_tiu',:new.id_atto);
		CIVPUB_IST_FI(:new.cod_rec, :new.ufficio, :new.anno, :new.atto, :new.parte, :new.serie,
                              :new.cod_pro_mat, :new.cod_com_mat,
                              :new.cognome_nome_m, :new.data_nas_m, :new.cod_pro_res_m, :new.cod_com_res_m,
                              :new.cognome_nome_f, :new.data_nas_f, :new.cod_pro_res_f, :new.cod_com_res_f,
                              :old.atto, :old.cod_pro_mat, :old.cod_com_mat);
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
/

