--liquibase formatted sql
--changeset amonopoli:202606101435_2 runOnChange:true stripComments:false
create or replace trigger ANAMOV_TIU
before INSERT
    or UPDATE
on ANAMOV
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

   w_flag_istat_1_17  	varchar2(255);
   w_flag_istat_2_62	varchar2(255);
   w_flag_preliminare	varchar2(255);
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.civico_esterno := f_civico_esterno_ZK(:new.cod_via,
                                                :new.num_civ,:new.suffisso,:new.scala,:new.piano,:new.interno,:new.sub_interno,
                                                :new.progr_snc,:new.nui,:new.colore,:new.corte,:new.interno2,:new.sub_interno2,:new.secondario,:new.scala_esterna);
     :new.civico_interno := f_civico_interno_ZK(:new.cod_via,
                                                :new.num_civ,:new.suffisso,:new.scala,:new.piano,:new.interno,:new.sub_interno,
                                                :new.progr_snc,:new.nui,:new.colore,:new.corte,:new.interno2,:new.sub_interno2,:new.secondario,:new.scala_esterna);

     :new.civico_esterno_prec := f_civico_esterno_ZK(:new.cod_via_prec,
                                                    :new.num_civ_prec,:new.suffisso_prec,:new.scala_prec,:new.piano_prec,:new.interno_prec,:new.sub_interno_prec,
                                                    :new.progr_snc_prec,:new.nui_prec,:new.colore_prec,:new.corte_prec,:new.interno2_prec,:new.sub_interno2_prec,:new.secondario_prec,:new.scala_esterna_prec);
     :new.civico_interno_prec := f_civico_interno_ZK(:new.cod_via_prec,
                                                     :new.num_civ_prec,:new.suffisso_prec,:new.scala_prec,:new.piano_prec,:new.interno_prec,:new.sub_interno_prec,
                                                     :new.progr_snc_prec,:new.nui_prec,:new.colore_prec,:new.corte_prec,:new.interno2_prec,:new.sub_interno2_prec,:new.secondario_prec,:new.scala_esterna_prec);
   end;

   if INSERTING then
      begin 
        ANAMOV_NR(:new.anno_progr, :new.numero_progr);
      end;

      if :new.cod_mov = 1 and :new.cod_eve != 1 then
         w_flag_istat_1_17 := f_get_campo_DCE('RES','I',1,17,'','FLAG_ISTAT');
 
         if :new.cod_eve = 17 then
            if w_flag_istat_1_17 is null then
               :new.no_conteggio := 'S';
            end if;
         elsif :new.cod_eve != 17 then
            if w_flag_istat_1_17 is not null then
               w_flag_preliminare := f_flag_preliminare('RES','I',:new.anno_pratica,:new.pratica);
               if w_flag_preliminare is not null then
                  :new.no_conteggio := 'S';
               end if;
            end if;
         end if;
      elsif :new.cod_mov = 2 and :new.cod_eve = 62 then
         w_flag_istat_2_62 := f_get_campo_DCE('RES','C',2,62,'','FLAG_ISTAT');
 
         if w_flag_istat_2_62 is null then
            :new.no_conteggio := 'S';
         end if;
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
            ANAMOV_FI(:new.matricola, :new.cod_mov, :new.cod_eve, :new.cod_variazione, :new.data_eve, :new.data_reg,
                      :new.cod_pro_eve, :new.cod_com_eve, :new.cod_pro_iscr_aire, :new.cod_com_iscr_aire, 
                      :new.nazionalita_prec, :new.nazionalita, :new.cognome_nome_prec, :new.cognome_nome,
                      :new.sesso_prec, :new.sesso, :new.annullamento, :new.elettorale,
			    :new.cod_via, :new.num_civ, :new.suffisso, :new.interno, :new.sub_interno, :new.scala, :new.piano,
			    :new.via_aire, :new.cod_pro_aire, :new.cod_com_aire, :new.zipcode,
                      :new.anno_pratica, :new.pratica, :new.nucleo_arrivo, :new.cod_fam, :new.intestatario);
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
