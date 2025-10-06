--liquibase formatted sql
--changeset snocca:202301301703_2 runOnChange:true
declare
   d_esiste number;
   d_esisteDM number;
begin
   begin
      SELECT INSTR(a.TESTO_4000, 'Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF> del Registro', 1),
             INSTR(a.TESTO_4000, 'Innanzi al sottoscritto Direttore Medico <UFFICIALE_PROV>')
        INTO d_esiste, d_esisteDM
        from civtfa a where a.formula = '2-TES-CNA2' and a.riga = 1
         and rownum = 1
      ;
   exception
      when no_data_found then
         d_esiste := 0;
         d_esisteDM := 0;
   end;
     if nvl(d_esiste, 0) > 0 or nvl(d_esisteDM, 0) > 0 then
     begin
        if nvl(d_esiste, 0) > 0 then
          update civtfa set TESTO_4000 = replace(TESTO_4000, 'Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF> del Registro', 'Atto Numero <NOTA_RIF>/<ANNO_NOTA_RIF> del Registro')
           where formula = '2-TES-CNA2' and riga = 1
          ;
        end if;
        if nvl(d_esisteDM, 0) > 0 then
          update civtfa set TESTO_4000 = replace(TESTO_4000, 'Innanzi al sottoscritto Direttore Medico <UFFICIALE_PROV>', 'Innanzi al sottoscritto Direttore Sanitario <UFFICIALE_PROV>')
           where formula = '2-TES-CNA2' and riga = 1
          ;
        end if;
     end;
   end if;
end;
/
