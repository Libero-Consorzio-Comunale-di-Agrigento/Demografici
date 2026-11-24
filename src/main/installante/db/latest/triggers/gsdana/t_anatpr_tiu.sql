--liquibase formatted sql
--changeset amonopoli:202606081630_2 runOnChange:true stripComments:false
create or replace trigger ANATPR_TIU
before INSERT
    or UPDATE
on ANATPR
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   :new.id         := f_anatpr_nr(:new.id);
   :new.id_pratica := f_ANA_get_id_pratica(:new.anagrafe,:new.tipo_evento,:new.anno_pratica,:new.pratica);
   :new.version  := nvl(:new.version,0);

   begin  -- Check DATA Integrity on INSERT or UPDATE
      if INSERTING then
         if :new.data_reg is null and :new.d_data_reg is null then
            :new.data_reg := to_char(sysdate,'j');
            :new.d_data_reg := sysdate;
         elsif :new.data_reg is not null and :new.d_data_reg is null then
            :new.d_data_reg := to_date(:new.data_reg,'j');
         elsif :new.d_data_reg is not null and :new.data_reg is null then
            :new.data_reg := to_char(:new.d_data_reg,'j');
         end if;
         if :new.data_pratica is not null and :new.d_data_pratica is null then
            :new.d_data_pratica := to_date(:new.data_pratica,'j');
         elsif :new.d_data_pratica is not null and :new.data_pratica is null then
            :new.data_pratica := to_char(:new.d_data_pratica,'j');
         end if;
      end if;

      if UPDATING then
         if nvl(:old.data_reg,0) != nvl(:new.data_reg,0) then
            :new.d_data_reg := to_date(:new.data_reg,'j');
         elsif nvl(:old.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_reg := to_char(:new.d_data_reg,'j');
         end if;
         if nvl(:old.data_pratica,0) != nvl(:new.data_pratica,0) then
            :new.d_data_pratica := to_date(:new.data_pratica,'j');
         elsif nvl(:old.d_data_pratica,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_pratica,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_pratica := to_char(:new.d_data_pratica,'j');
         end if;
      end if;
   end;

   if UPDATING then
--raise_application_error(-20999,:new.anagrafe||' '||:new.tipo_evento||' '||:new.anno_pratica||' '||:new.pratica||' '||
--                               :old.cod_variazione||' '||:new.cod_variazione||' '||
--                               :old.flag_perfezionamento||' '||:new.flag_perfezionamento||' '||
--                               :old.flag_annullamento||' '||:new.flag_annullamento);
      ANATPR_FI(:new.anagrafe, :new.tipo_evento, :new.anno_pratica, :new.pratica,
                :old.cod_variazione, :new.cod_variazione,
                :old.flag_perfezionamento, :new.flag_perfezionamento,
                :old.flag_annullamento, :new.flag_annullamento);

      if :new.anagrafe = 'RES' and :new.tipo_evento = 'I' and :new.cod_variazione in ('P','W','Y','a') and
         :old.flag_perfezionamento is null and :new.flag_perfezionamento = 'S'
      then
         :new.flag_perfezionamento := null;
         if :new.cod_variazione = 'a' then
            :new.cod_variazione := 'i';
         end if;

      elsif :new.anagrafe = 'RES' and :new.tipo_evento = 'I' and :new.cod_variazione = 'i' and
         :old.flag_perfezionamento is null and :new.flag_perfezionamento = 'S'
      then
         :new.cod_variazione := 'A';
      end if;
   end if;

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
/
