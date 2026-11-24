--liquibase formatted sql
--changeset amonopoli:202606091245_2 runOnChange:true stripComments:false
create or replace trigger ANAAPM_TIU
before INSERT or UPDATE
on ANAAPM
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.id               := f_anaapm_nr(:new.id);
      :new.id_dichiarazione := f_ANA_get_id_pratica('RES','I',:new.anno_dic,:new.numero_dic);
  
      begin
        select ap4.id, ap4.id_anatpr
          into :new.id_anaap4, :new.id_anatpr
          from anaap4 ap4
         where id_dichiarazione = :new.id_dichiarazione
           and rownum = 1
        ;
      exception
        when others then
   --          raise_application_error(-20999, 'id_anaap4 / id_anatpr non trovato ('||sqlerrm||')');
             null;
      end;

      if :new.fascia_ripristino            is null and
         :new.stato_ripristino             is null and
         :new.cod_fam_ripristino           is null and
         :new.rapporto_par_ripristino      is null and 
         :new.sequenza_par_ripristino      is null and 
         :new.d_data_inizio_fam_ripristino is null and
         :new.d_data_inizio_res_ripristino is null
      then
         begin
           select ana.fascia,
                  ana.stato,
                  decode(ana.fascia, 5, to_number(null), 6, to_number(null), ana.cod_fam),
                  decode(ana.fascia, 5, to_char(null), 6, to_char(null), ana.rapporto_par),
                  decode(ana.fascia, 5, to_number(null), 6, to_number(null), ana.sequenza_par),
                  decode(ana.fascia, 5, to_date(null), 6, to_date(null), to_date(ana.data_inizio_fam,'j')),
                  decode(ana.fascia, 5, to_date(null), 6, to_date(null), to_date(ana.data_inizio_res,'j')),
                  decode(ana.fascia, 5, to_char(null), 6, to_char(null), ana.cod_fam_unique)
             into :new.fascia_ripristino,
                  :new.stato_ripristino,
                  :new.cod_fam_ripristino,
                  :new.rapporto_par_ripristino,
                  :new.sequenza_par_ripristino,
                  :new.d_data_inizio_fam_ripristino,
                  :new.d_data_inizio_res_ripristino,
                  :new.cod_fam_unique_ripristino
             from anaana ana
            where matricola = :new.matricola
              and fascia    != 1
           ;
         exception
           when others then
                null;
         end;
      end if;
      :new.cod_fam_unique_ripristino := nvl(:new.cod_fam_unique_ripristino,f_ANA_get_cod_fam_unique(3,:new.cod_fam_ripristino));

   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      null;
   end;

   begin  -- Set REFERENTIAL Integrity on UPDATE
      null;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
           ANAAPM_FI(:new.matricola,:new.anno_dic,:new.numero_dic,:new.annullamento,
		      :old.matricola,:old.anno_dic,:old.numero_dic,:old.annullamento);
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
/* End Trigger: ANAAPM_TIU */
/
