--liquibase formatted sql
--changeset amonopoli:202502191035_2 runOnChange:true stripComments:false
create or replace function f_ANSC_uso_matrimonio
(a_codice_anpr_dce	IN	varchar2
,a_codice_anpr		IN	varchar2
)

return varchar2

IS

w_codice_anpr_dce	varchar2(255) := upper(a_codice_anpr_dce);
w_codice_ansc_dce	varchar2(255) := f_ANSC_id_tipo_certificato(w_codice_anpr_dce);
w_codice_anpr		varchar2(255) := upper(a_codice_anpr);
w_codice_ansc		varchar2(255);

begin
-- ANST113
-- 1 - Art. 40 comma 2 DPR 445/2000
-- 2 - Certificati da produrre all'estero
-- 3 - Procedimenti giudiziari contenziosi
-- 4 - Norme sulla condizione dello straniero e immigrazione
-- 5 - Formalità ipotecarie e catastali
-- 6 - Servizio Elettorale

-- ANPT39
-- S1 - STATO CIVILE - Art. 40 comma 2 DPR 445/2000
-- S2 - STATO CIVILE - Certificati da produrre all'estero
-- S3 - STATO CIVILE - Procedimenti giudiziari contenziosi		
-- S4 - STATO CIVILE - Norme sulla condizione dello straniero e immigrazione		
-- S5 - STATO CIVILE - Formalità ipotecarie e catastali		
-- S6 - STATO CIVILE - Servizio Elettorale		
-- S8 - STATO CIVILE - NON VALIDO PER L'ESTERO (uso matrimonio)		
-- S9 - STATO CIVILE - VALIDO PER L'ESTERO (uso matrimonio)		

  w_codice_ansc := 'false';

  if w_codice_ansc_dce != 3 then
     if w_codice_anpr in ('S8','S9') then
        w_codice_ansc := 'true';
     end if;
  end if;

<< fine >>

  return w_codice_ansc;
end;
/
