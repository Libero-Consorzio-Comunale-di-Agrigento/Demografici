--liquibase formatted sql
--changeset amonopoli:202312221150_1 runOnChange:true stripComments:false
create or replace trigger CIVUCI_IST_TIU
before INSERT
    or UPDATE
on CIVUCI
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

w_new_data_nas_m	number;
w_new_data_nas_f	number;
begin
--
-- 18/01/2024 (AM): gestito UPDATE di comune matrimonio (rif. CIVUCI_IST_FI)
--

 if nvl(w_integrazione_istat,'N') = 'S' then
   begin  -- Check DATA Integrity on INSERT or UPDATE
      if INSERTING then
         :new.id_atto      := nvl(:new.id_atto,f_CIV_get_id_atto(-4,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto));
         :new.natura_uci := nvl(:new.natura_uci,:new.natura); 
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
                w_new_data_nas_m := nvl(:new.data_nas_m,to_char(:new.d_data_nas_m,'j'));
                w_new_data_nas_f := nvl(:new.data_nas_f,to_char(:new.d_data_nas_f,'j'));
                ISTAT_PKG.ins_log('civuci_ist_tiu',:new.id_atto);
		CIVUCI_IST_FI(:new.cod_rec,:new.natura_uci,:new.ufficio,:new.anno,:new.atto,:new.parte,:new.serie,
 			      :new.cod_pro_mat,:new.cod_com_mat,
			      :new.cognome_nome_m,w_new_data_nas_m,:new.cod_pro_res_m,:new.cod_com_res_m,:new.nazionalita_m,:new.cod_fiscale_m,
			      :new.cognome_nome_f,w_new_data_nas_f,:new.cod_pro_res_f,:new.cod_com_res_f,:new.nazionalita_f,:new.cod_fiscale_f,
			      :old.atto,:new.id_civdta,:new.id_atto,
                              :old.cod_pro_mat,:old.cod_com_mat);
	    null;
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
/* End Trigger: CIVUCI_IST_TIU */
/
