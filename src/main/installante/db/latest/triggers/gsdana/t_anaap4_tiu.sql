--liquibase formatted sql
--changeset amonopoli:202606091150_2 runOnChange:true stripComments:false
create or replace trigger ANAAP4_TIU
before INSERT
    or UPDATE
on ANAAP4
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   :new.id               := f_anaap4_nr(:new.id);
   :new.id_pratica       := f_ANA_get_id_pratica('RES','I',:new.anno_pratica,:new.pratica);
   :new.id_dichiarazione := f_ANA_get_id_pratica('RES','I',:new.anno_dic,:new.numero_dic);

   :new.cognome_presso   := nvl(:new.cognome_presso, f_cognome(:new.presso));
   :new.nome_presso      := nvl(:new.nome_presso, f_nome(:new.presso));

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
--          raise_application_error(-20999, 'id_anatpr non trovato ('||sqlerrm||')');
          null;
   end;

   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.cod_fam_unique_dest := nvl(:new.cod_fam_unique_dest,f_ANA_get_cod_fam_unique(1,:new.cod_fam_dest));
      :new.cod_fam_unique_prov := nvl(:new.cod_fam_unique_prov,f_ANA_get_cod_fam_unique(3,:new.cod_fam_prov));

      :new.civico_esterno := f_civico_esterno_ZK(:new.cod_via,
                                                 :new.num_civ,:new.suffisso,:new.scala,:new.piano,:new.interno,:new.sub_interno,
                                                 :new.progr_snc,:new.nui,:new.colore,:new.corte,:new.interno2,:new.sub_interno2,:new.secondario,:new.scala_esterna);
      :new.civico_interno := f_civico_interno_ZK(:new.cod_via,
                                                 :new.num_civ,:new.suffisso,:new.scala,:new.piano,:new.interno,:new.sub_interno,
                                                 :new.progr_snc,:new.nui,:new.colore,:new.corte,:new.interno2,:new.sub_interno2,:new.secondario,:new.scala_esterna);

      ANAAP4_FI(:new.anno_dic, :new.numero_dic, :new.flag_aggregazione, :new.cod_fam_dest,
                :new.cod_via, :new.num_civ, :new.suffisso, :new.scala, :new.piano, :new.interno, :new.sub_interno,
                :old.cod_via, :old.num_civ, :old.suffisso, :old.scala, :old.piano, :old.interno, :old.sub_interno);


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
         if :new.data_irreperibilita is null and :new.d_data_irreperibilita is not null then
            :new.data_irreperibilita := to_char(:new.d_data_irreperibilita,'j');
         elsif :new.d_data_irreperibilita is null and :new.data_irreperibilita is not null then
            :new.d_data_irreperibilita := to_date(:new.data_irreperibilita,'j');
         end if;
         if :new.data_definizione is null and :new.d_data_definizione is not null then
            :new.data_definizione := to_char(:new.d_data_definizione,'j');
         elsif :new.d_data_definizione is null and :new.data_definizione is not null then
            :new.d_data_definizione := to_date(:new.data_definizione,'j');
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
         if nvl(:old.data_irreperibilita,0) != nvl(:new.data_irreperibilita,0) then
            :new.d_data_irreperibilita := to_date(:new.data_irreperibilita,'j');
         elsif nvl(:old.d_data_irreperibilita,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_irreperibilita,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_irreperibilita   := to_char(:new.d_data_irreperibilita,'j');
         end if;
         if nvl(:old.data_definizione,0) != nvl(:new.data_definizione,0) then
            :new.d_data_definizione := to_date(:new.data_definizione,'j');
         elsif nvl(:old.d_data_definizione,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_definizione,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_definizione   := to_char(:new.d_data_definizione,'j');
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
/
