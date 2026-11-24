--liquibase formatted sql
--changeset amonopoli:202606101210_2 runOnChange:true stripComments:false
create or replace trigger ANAC01_TIU
before INSERT
    or UPDATE
on ANAC01
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   if INSERTING then
      if :new.protocollo_aire is not null and :new.anno_protocollo_aire is null then
         :new.anno_protocollo_aire := :new.anno_pratica;
      end if;
   end if;

   :new.id                 := f_ANAC01_nr(:new.id);
   :new.id_pratica         := f_ANA_get_id_pratica('RES','C',:new.anno_pratica,:new.pratica);
   :new.id_protocollo_aire := f_ANA_get_id_pratica('AIR','I',:new.anno_protocollo_aire,:new.protocollo_aire);

   if :new.anno_pratica is not null and :new.pratica is not null then
      begin
        select tpr.id
          into :new.id_anatpr
          from anatpr tpr
         where anagrafe     = 'RES'
           and tipo_evento  = 'I'	
           and anno_pratica = :new.anno_pratica
           and pratica      = :new.pratica
           and rownum = 1
       ;
      exception
        when others then
--             raise_application_error(-20999, 'id_anatpr non trovato ('||sqlerrm||')');
             null;
      end;

   elsif :new.anno_pratica is null and :new.pratica is null and
         :new.anno_protocollo_aire is not null and :new.protocollo_aire is not null 
   then
      begin
        select tpr.id
          into :new.id_anatpr
          from anatpr tpr
         where anagrafe     = 'AIR'
           and tipo_evento  = 'C'
           and anno_pratica = :new.anno_protocollo_aire
           and pratica      = :new.protocollo_aire
           and rownum = 1
       ;
      exception
        when others then
--             raise_application_error(-20999, 'id_anatpr non trovato ('||sqlerrm||')');
             null;
      end;
   end if;

   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.DATA_PRATICA          := nvl(:new.data_pratica, to_char(:new.d_data_pratica,'j'));        
      :new.D_DATA_PRATICA        := nvl(:new.d_data_pratica, to_date(:new.data_pratica,'j'));
      :new.DATA_DECORRENZA       := nvl(:new.data_decorrenza, to_char(:new.d_data_decorrenza,'j'));
      :new.D_DATA_DECORRENZA     := nvl(:new.d_data_decorrenza, to_date(:new.data_decorrenza,'j'));
      :new.DATA_DEFINIZIONE      := nvl(:new.data_definizione, to_char(:new.d_data_definizione,'j'));
      :new.D_DATA_DEFINIZIONE    := nvl(:new.d_data_definizione, to_date(:new.data_definizione,'j'));
      :new.DATA_IRREPERIBILITA   := nvl(:new.data_irreperibilita, to_char(:new.d_data_irreperibilita,'j'));
      :new.D_DATA_IRREPERIBILITA := nvl(:new.d_data_irreperibilita, to_date(:new.data_irreperibilita,'j'));
      :new.DATA_REG              := nvl(:new.data_reg, to_char(:new.d_data_reg,'j'));
      :new.D_DATA_REG            := nvl(:new.d_data_reg, to_date(:new.data_reg,'j'));
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
	    null;
         end if;
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
/* End Trigger: ANAC01_TIU */
/
