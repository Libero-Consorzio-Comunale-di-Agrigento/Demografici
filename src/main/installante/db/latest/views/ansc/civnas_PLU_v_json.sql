--liquibase formatted sql
--changeset amonopoli:202311141630 runOnChange:true stripComments:false
create or replace view civnas_plu_v_json as
select nas.id
     , nas.id_atto
     , nas.ufficio
     , nas.anno
     , nas.parte
     , nas.serie
     , nas.atto
     , lower(nvl(nas.parto_plurimo,'NO')) partoGemellare
     , decode(nas.parto_plurimo, 'SI', nas.parto_plurimo_tot_gemelli) numeroGemelli
     , decode(nas.parto_plurimo, 'SI', nas.parto_plurimo_num_gemello) progressivoGemello
     , nas.numero_unico numeroUnicoComunale
     , (nas.numero_unico + nas_v.sequenza -1) numeroUnicoCalcolato
     , nas_v.sequenza sequenza
-- intestatari
     , nvl(occ.cognome,nas.cognome) INT_cognome
     , nvl(occ.nome,nas.nome) INT_nome
-- madre
     , nas.cognome_md MAT_cognome
     , nas.nome_md MAT_nome
-- padre
     , nas.cognome_pd PAT_cognome
     , nas.nome_pd PAT_nome
-- ANSC
     , nas.id_atto_ansc idAttoAnsc
     , nas.id_evento_ansc idEventoAnsc
     , to_number(null) INT_idSoggettoAnsc
     , to_number(null) PAT_idSoggettoAnsc
     , to_number(null) MAT_idSoggettoAnsc
--     , f_ANPR_id_scheda(nvl(ana.matricola_1,ana_r.matricola_1),'','','','','') PAT_idSoggettoAnpr
--     , f_ANPR_id_scheda(nvl(ana.matricola_2,ana_r.matricola_2),'','','','','') MAT_idSoggettoAnpr
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_1,ana_r.matricola_1),'') PAT_idSoggettoAnpr
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_2,ana_r.matricola_2),'') MAT_idSoggettoAnpr
  from (select rownum sequenza from civnas
        where rownum < 3) nas_v
     , civana ana
     , civana_recupero ana_r
     , civocc occ
     , civnas nas
 where ana.id_atto           (+) = nas.id_atto
   and ana_r.id_atto         (+) = nas.id_atto
   and occ.id_atto           (+) = nas.id_atto
   and nas.parto_plurimo     (+) = 'SI'
   and nas.cod_rec               in (0,3)
/
comment on table CIVNAS_PLU_V_JSON is 'ANSC - Atti di Nascita per request JSON - Prenotazione Atti (view)'
/
