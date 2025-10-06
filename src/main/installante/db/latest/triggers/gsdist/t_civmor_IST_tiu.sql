--liquibase formatted sql
--changeset amonopoli:202302131300_3 runOnChange:true stripComments:false
create or replace trigger CIVMOR_IST_TIU
before INSERT
    or UPDATE
on CIVMOR
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_new_data_mor		number;
w_new_data_reg		number;
w_new_data_nas		number;
w_old_data_nas		number;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

begin
 if nvl(w_integrazione_istat,'N') = 'S' then
   begin  -- Check DATA Integrity on INSERT or UPDATE
     if INSERTING then
        :new.id_atto      := nvl(:new.id_atto,f_CIV_get_id_atto(5,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto));
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
                if :old.data_nas is not null and :new.data_nas is not null and :old.data_nas != :new.data_nas then
                   w_old_data_nas := :old.data_nas;
                elsif :old.d_data_nas is not null and :new.d_data_nas is not null and :old.d_data_nas != :new.d_data_nas then
                   w_old_data_nas := to_char(:old.d_data_nas,'j');
                end if;

                w_new_data_mor := nvl(:new.data_mor,to_char(:new.d_data_mor,'j'));
                w_new_data_reg := nvl(:new.data_reg,to_char(:new.d_data_reg,'j'));
                w_new_data_nas := nvl(:new.data_nas,to_char(:new.d_data_nas,'j'));
                ISTAT_PKG.ins_log('civmor_ist_tiu',:new.id_atto||' (data_nas: '||w_new_data_nas||' - w_data_mor: '||w_new_data_mor||' - w_data_reg: '||w_new_data_reg||')');
		CIVMOR_IST_FI(:new.cod_rec,:new.natura,
			      :new.ufficio,:new.anno,:new.atto,:new.parte,:new.serie,
			      :new.cod_pro_mor,:new.cod_com_mor,w_new_data_mor,:new.ore,:new.minuti,
			      :new.cognome_nome,:new.sesso,w_new_data_nas,
			      :new.cod_pro_nas,:new.cod_com_nas,
			      :new.stato_civile,w_old_data_nas,
			      :new.nazionalita,
			      :old.atto,
			      w_new_data_reg);
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
/* End Trigger: CIVMOR_IST_TIU */
/
