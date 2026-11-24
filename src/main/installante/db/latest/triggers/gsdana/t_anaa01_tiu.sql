--liquibase formatted sql
--changeset amonopoli:202606101110_2 runOnChange:true stripComments:false
create or replace trigger ANAA01_TIU
before INSERT
    or UPDATE
on ANAA01
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

   :new.id                 := f_ANAA01_nr(:new.id);
   :new.id_pratica         := f_ANA_get_id_pratica('RES','C',:new.anno_pratica,:new.pratica);
   :new.id_protocollo_aire := f_ANA_get_id_pratica('AIR','I',:new.anno_protocollo_aire,:new.protocollo_aire);

   :new.cognome_presso     := nvl(:new.cognome_presso, f_cognome(:new.presso));
   :new.nome_presso        := nvl(:new.nome_presso, f_nome(:new.presso));

   if :new.cod_consolato is not null and :new.tipo_consolato is not null and :new.cod_territorio is not null then
      begin
        select con.id
          into :new.id_arccon
          from arccon con
         where cod_consolato  = :new.cod_consolato
           and tipo_consolato = :new.tipo_consolato
           and stato          = :new.cod_territorio
           and rownum = 1
       ;
      exception
        when others then
   --          raise_application_error(-20999, 'id_anatpr non trovato ('||sqlerrm||')');
             :new.id_arccon := '';
             null;
      end;
   end if;

   if :new.anno_pratica is not null and :new.pratica is not null then
      begin
        select tpr.id
          into :new.id_anatpr
          from anatpr tpr
         where anagrafe     = 'RES'
           and tipo_evento  = 'C'
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
           and tipo_evento  = 'I'
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
      if INSERTING then
         if :new.data_reg is null and :new.d_data_reg is null then
            :new.data_reg   := to_char(sysdate,'j');
            :new.d_data_reg := sysdate;
         elsif :new.data_reg is null and :new.d_data_reg is not null then
            :new.data_reg := to_char(:new.d_data_reg,'j');
         elsif :new.d_data_reg is null and :new.data_reg is not null then
            :new.d_data_reg := to_date(:new.data_reg,'j');
         end if;
         if :new.data_pratica is null and :new.d_data_pratica is not null then
            :new.data_pratica := to_char(:new.d_data_pratica,'j');
         elsif :new.d_data_pratica is null and :new.data_pratica is not null then
            :new.d_data_pratica := to_date(:new.data_pratica,'j');
         end if;
         if :new.data_decorrenza is null and :new.d_data_decorrenza is not null then
            :new.data_decorrenza := to_char(:new.d_data_decorrenza,'j');
         elsif :new.d_data_decorrenza is null and :new.data_decorrenza is not null then
            :new.d_data_decorrenza := to_date(:new.data_decorrenza,'j');
         end if;
         if :new.data_definizione is null and :new.d_data_definizione is not null then
            :new.data_definizione := to_char(:new.d_data_definizione,'j');
         elsif :new.d_data_definizione is null and :new.data_definizione is not null then
            :new.d_data_definizione := to_date(:new.data_definizione,'j');
         end if;
         if :new.data_arrivo is null and :new.d_data_arrivo is not null then
            :new.data_arrivo := to_char(:new.d_data_arrivo,'j');
         elsif :new.d_data_arrivo is null and :new.data_arrivo is not null then
            :new.d_data_arrivo := to_date(:new.data_arrivo,'j');
         end if;
      end if;
 
      if UPDATING then
         if nvl(:old.data_reg,0) != nvl(:new.data_reg,0) then
            :new.d_data_reg := to_date(:new.data_reg,'j');
         elsif nvl(:old.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_reg,sysdate) then
            :new.data_reg   := to_char(:new.d_data_reg,'j');
         end if;
         if nvl(:old.data_pratica,0) != nvl(:new.data_pratica,0) then
            :new.d_data_pratica := to_date(:new.data_pratica,'j');
         elsif nvl(:old.d_data_pratica,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_pratica,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_pratica   := to_char(:new.d_data_pratica,'j');
         end if;
         if nvl(:old.data_decorrenza,0) != nvl(:new.data_decorrenza,0) then
            :new.d_data_decorrenza := to_date(:new.data_decorrenza,'j');
         elsif nvl(:old.d_data_decorrenza,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_decorrenza,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_decorrenza   := to_char(:new.d_data_decorrenza,'j');
         end if;
         if nvl(:old.data_definizione,0) != nvl(:new.data_definizione,0) then
            :new.d_data_definizione := to_date(:new.data_definizione,'j');
         elsif nvl(:old.d_data_definizione,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_definizione,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_definizione   := to_char(:new.d_data_definizione,'j');
         end if;
         if nvl(:old.data_arrivo,0) != nvl(:new.data_arrivo,0) then
            :new.d_data_arrivo := to_date(:new.data_arrivo,'j');
         elsif nvl(:old.d_data_arrivo,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_arrivo,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_arrivo   := to_char(:new.d_data_arrivo,'j');
         end if;
      end if;
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
/* End Trigger: ANAA01_TIU */
/
