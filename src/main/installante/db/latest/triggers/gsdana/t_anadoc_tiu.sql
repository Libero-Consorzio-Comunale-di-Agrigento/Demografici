--liquibase formatted sql
--changeset amonopoli:202412060935_2 runOnChange:true stripComments:false
create or replace trigger ANADOC_TIU
before INSERT
    or UPDATE
on ANADOC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.data_reg := nvl(:new.data_reg,to_number(to_char(trunc(sysdate),'j')));
     :new.id       := F_ANADOC_NR(:new.id);

     if INSERTING then
        :new.d_data_reg := to_date(:new.data_reg,'j');
        if :new.data_emissione is null and :new.d_data_emissione is not null then
	     :new.data_emissione := to_number(to_char(:new.d_data_emissione,'j'));
        end if;
        if :new.d_data_emissione is null and :new.data_emissione is not null then
	     :new.d_data_emissione := to_date(:new.data_emissione,'j');
        end if;
        if :new.data_scadenza is null and :new.d_data_scadenza is not null then
	     :new.data_scadenza := to_number(to_char(:new.d_data_scadenza,'j'));
        end if;
        if :new.d_data_scadenza is null and :new.data_scadenza is not null then
	     :new.d_data_scadenza	:= to_date(:new.data_scadenza,'j');
        end if;
     end if;

     if UPDATING then
	  if nvl(:new.data_emissione, 0) != nvl(:old.data_emissione, 0) then
	     :new.d_data_emissione := to_date(:new.data_emissione,'j');
	  end if;
	  if nvl(trunc(:new.d_data_emissione), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_emissione), to_date('01/01/1800','dd/mm/yyyy')) 
        then
	     :new.data_emissione := to_char(:new.d_data_emissione,'j');
	  end if;
	  if nvl(:new.data_scadenza, 0) != nvl(:old.data_scadenza, 0) then
	     :new.d_data_scadenza := to_date(:new.data_scadenza,'j');
	  end if;
	  if nvl(trunc(:new.d_data_scadenza), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_scadenza), to_date('01/01/1800','dd/mm/yyyy')) 
        then
	     :new.data_scadenza := to_char(:new.d_data_scadenza,'j');
	  end if;
	  if nvl(:new.data_reg, 0) != nvl(:old.data_reg, 0) then
	     :new.d_data_reg := to_date(:new.data_reg,'j');
 	  end if;
	  if nvl(trunc(:new.d_data_reg), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_reg), to_date('01/01/1800','dd/mm/yyyy')) 
        then
	     :new.data_reg := to_char(:new.d_data_reg,'j');
	  end if;
     end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         ANADOC_PU(:OLD.MATRICOLA,
                   :OLD.TIPO_DOCUMENTO,
                   :OLD.PROGR_DOCUMENTO,
                         :NEW.MATRICOLA,
                         :NEW.TIPO_DOCUMENTO,
                         :NEW.PROGR_DOCUMENTO);
         null;
      end if;
      if INSERTING then
         ANADOC_PI(:NEW.MATRICOLA);
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "ANADOC"
            cursor cpk_anadoc(var_MATRICOLA number,
                              var_TIPO_DOCUMENTO varchar,
                              var_PROGR_DOCUMENTO number) is
               select 1
                 from   ANADOC
                where  MATRICOLA = var_MATRICOLA and
                       TIPO_DOCUMENTO = var_TIPO_DOCUMENTO and
                       PROGR_DOCUMENTO = var_PROGR_DOCUMENTO;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "ANADOC"
               if :new.MATRICOLA is not null and
                  :new.TIPO_DOCUMENTO is not null and
                  :new.PROGR_DOCUMENTO is not null then
                  open  cpk_anadoc(:new.MATRICOLA,
                                   :new.TIPO_DOCUMENTO,
                                   :new.PROGR_DOCUMENTO);
                  fetch cpk_anadoc into dummy;
                  found := cpk_anadoc%FOUND;
                  close cpk_anadoc;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.MATRICOLA||' '||
                               :new.TIPO_DOCUMENTO||' '||
                               :new.PROGR_DOCUMENTO||
                               '" gia'' presente in ANADOC. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
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
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANADOC_TIU */
/
