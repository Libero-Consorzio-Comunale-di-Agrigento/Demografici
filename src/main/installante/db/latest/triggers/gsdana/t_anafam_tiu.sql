--liquibase formatted sql
--changeset amonopoli:202503071455_2 runOnChange:true stripComments:false
create or replace trigger ANAFAM_TIU
before INSERT
    or UPDATE
on ANAFAM
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.cod_fam_unique       := nvl(:new.cod_fam_unique,f_ANA_get_cod_fam_unique(:new.fascia,:new.cod_fam));
     :new.cognome_intestatario := nvl(:new.cognome_intestatario,f_cognome(:new.intestatario));
     :new.nome_intestatario    := nvl(:new.nome_intestatario,f_nome(:new.intestatario));


     :new.civico_esterno := f_civico_esterno(:new.cod_via
					     ,:new.num_civ
					     ,:new.suffisso
					     ,:new.scala
					     ,:new.piano
					     ,:new.interno
					     ,:new.sub_interno);
     :new.civico_interno := f_civico_interno(:new.cod_via
					     ,:new.num_civ
					     ,:new.suffisso
					     ,:new.scala
					     ,:new.piano
					     ,:new.interno
					     ,:new.sub_interno);

     if INSERTING then
        if :new.data_istituzione is null and :new.d_data_istituzione is not null then
	     :new.data_istituzione := to_number(to_char(:new.d_data_istituzione,'j'));
        end if;
        if :new.d_data_istituzione is null and :new.data_istituzione is not null then
	     :new.d_data_istituzione := to_date(:new.data_istituzione,'j');
        end if;
        if :new.data_intestatario is null and :new.d_data_intestatario is not null then
	     :new.data_intestatario := to_number(to_char(:new.d_data_intestatario,'j'));
        end if;
        if :new.d_data_intestatario is null and :new.data_intestatario is not null then
	     :new.d_data_intestatario	:= to_date(:new.data_intestatario,'j');
        end if;
     end if;

     if UPDATING then
	  if nvl(:new.data_istituzione, 0) != nvl(:old.data_istituzione, 0) then
	     :new.d_data_istituzione := to_date(:new.data_istituzione,'j');
	  end if;
	  if nvl(trunc(:new.d_data_istituzione), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_istituzione), to_date('01/01/1800','dd/mm/yyyy')) 
          then
	     :new.data_istituzione := to_char(:new.d_data_istituzione,'j');
	  end if;
	  if nvl(:new.data_intestatario, 0) != nvl(:old.data_intestatario, 0) then
	     :new.d_data_intestatario := to_date(:new.data_intestatario,'j');
	  end if;
	  if nvl(trunc(:new.d_data_intestatario), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_intestatario), to_date('01/01/1800','dd/mm/yyyy')) 
        then
	     :new.data_intestatario := to_char(:new.d_data_intestatario,'j');
	  end if;
     end if;

   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         ANAFAM_PU(:OLD.FASCIA,
                   :OLD.COD_FAM,
                         :NEW.FASCIA,
                         :NEW.COD_FAM);
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "ANAFAM"
            cursor cpk_anafam(var_FASCIA number,
                              var_COD_FAM number) is
               select 1
                 from   ANAFAM
                where  FASCIA = var_FASCIA and
                       COD_FAM = var_COD_FAM;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "ANAFAM"
               if :new.FASCIA is not null and
                  :new.COD_FAM is not null then
                  open  cpk_anafam(:new.FASCIA,
                                   :new.COD_FAM);
                  fetch cpk_anafam into dummy;
                  found := cpk_anafam%FOUND;
                  close cpk_anafam;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.FASCIA||' '||
                               :new.COD_FAM||
                               '" gia'' presente in ANAFAM. La registrazione  non puo'' essere inserita.';
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
            ANAFAM_FI(:old.fascia,:old.progr_eliminazione,:new.fascia,:new.Progr_eliminazione);
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
/
