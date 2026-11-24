--liquibase formatted sql
--changeset amonopoli:202504021205 runAlways:true runOnChange:true stripComments:false
create or replace view anamov_VANA
AS
/*
20/07/2018 (AM): iscrizione preliminare (1-17) con accertamenti negativi (2-62) compare in Storico Ana?
(non ha mai funzionato la visualizzazione dei 2-51, ripristinati, perche'' cercava cod_eve = 52)
02/03/2026 (AM): gestito in maniera custom la valorizzazione degli estremi dell'indirizzo (attuale)
per fare in modo che NON vengano estratti in caso di rettifiche di dati anagrafici (cod_eve !" 98)
*/
select mov.matricola
     , mov.cod_mov
     , mov.cod_eve
     , mov.data_eve
     , mov.cod_pro_eve
     , mov.cod_com_eve
     , mov.anno_pratica
     , mov.pratica
     , mov.nucleo_partenza
     , mov.nucleo_arrivo
     , mov.cognome_nome_prec
     , mov.stato_civile_prec
     , mov.sesso_prec
     , mov.nazionalita_prec
     , mov.paternita_prec
     , mov.maternita_prec
     , mov.titolo_studio_prec
     , mov.cod_prof_prec
     , mov.attivita_prof_prec
     , mov.posizione_prof_prec
     , mov.pensionato_prec
     , mov.cod_fam_prec
     , mov.intestatario_prec
     , mov.rapporto_par_prec
     , mov.cod_via_prec
     , mov.num_civ_prec
     , mov.suffisso_prec
     , mov.interno_prec
     , mov.via_aire_prec
     , mov.cod_pro_aire_prec
     , mov.cod_com_aire_prec
     , mov.cognome_nome_cn_prec
     , mov.matricola_cn_prec
     , mov.anno_cens_prec
     , mov.sezione_cens_prec
     , mov.foglio_cens_prec
     , mov.cod_pro_nas_prec
     , mov.cod_com_nas_prec
     , mov.data_nas_prec
     , mov.cod_pro_atto_nas_prec
     , mov.cod_com_atto_nas_prec
     , mov.anno_atto_nas_prec
     , mov.atto_nas_prec
     , mov.parte_nas_prec
     , mov.serie_nas_prec
     , mov.ufficio_nas_prec
     , mov.anno_atto_nas_tr_prec
     , mov.atto_nas_tr_prec
     , mov.parte_nas_tr_prec
     , mov.serie_nas_tr_prec
     , mov.ufficio_nas_tr_prec
     , mov.cod_pro_mat_prec
     , mov.cod_com_mat_prec
     , mov.data_mat_prec
     , mov.anno_atto_mat_prec
     , mov.atto_mat_prec
     , mov.parte_mat_prec
     , mov.serie_mat_prec
     , mov.ufficio_mat_prec
     , mov.anno_atto_mat_tr_prec
     , mov.atto_mat_tr_prec
     , mov.parte_mat_tr_prec
     , mov.serie_mat_tr_prec
     , mov.ufficio_mat_tr_prec
     , mov.cod_pro_mor_prec
     , mov.cod_com_mor_prec
     , mov.data_mor_prec
     , mov.anno_atto_mor_prec
     , mov.atto_mor_prec
     , mov.parte_mor_prec
     , mov.serie_mor_prec
     , mov.ufficio_mor_prec
     , mov.anno_atto_mor_tr_prec
     , mov.atto_mor_tr_prec
     , mov.parte_mor_tr_prec
     , mov.serie_mor_tr_prec
     , mov.ufficio_mor_tr_prec
     , mov.cod_pro_ved_prec
     , mov.cod_com_ved_prec
     , mov.data_ved_prec
     , mov.anno_atto_ved_prec
     , mov.atto_ved_prec
     , mov.parte_ved_prec
     , mov.serie_ved_prec
     , mov.ufficio_ved_prec
     , mov.cod_fiscale_prec
     , mov.cognome_nome
     , mov.stato_civile
     , mov.sesso
     , mov.nazionalita
     , mov.paternita
     , mov.maternita
     , mov.titolo_studio
     , mov.cod_prof
     , mov.attivita_prof
     , mov.posizione_prof
     , mov.pensionato
     , mov.cod_fam
     , mov.intestatario
     , mov.rapporto_par
     , mov.data_inizio_fam
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.cod_via), mov.cod_via) cod_via
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.num_civ), mov.num_civ) num_civ
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.suffisso), mov.suffisso) suffisso
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.interno), mov.interno) interno
     , decode(mov.cod_mov, 98, decode(mov.cod_eve, 98, mov.via_aire), mov.via_aire) via_aire
     , decode(mov.cod_mov, 98, decode(mov.cod_eve, 98, mov.cod_pro_aire), mov.cod_pro_aire) cod_pro_aire
     , decode(mov.cod_mov, 98, decode(mov.cod_eve, 98, mov.cod_com_aire), mov.cod_com_aire) cod_com_aire
     , mov.data_inizio_res
     , mov.cognome_nome_cn
     , mov.matricola_cn
     , mov.anno_cens
     , mov.sezione_cens
     , mov.foglio_cens
     , mov.cod_pro_nas
     , mov.cod_com_nas
     , mov.data_nas
     , mov.cod_pro_atto_nas
     , mov.cod_com_atto_nas
     , mov.anno_atto_nas
     , mov.atto_nas
     , mov.parte_nas
     , mov.serie_nas
     , mov.ufficio_nas
     , mov.anno_atto_nas_tr
     , mov.atto_nas_tr
     , mov.parte_nas_tr
     , mov.serie_nas_tr
     , mov.ufficio_nas_tr
     , mov.cod_pro_mat
     , mov.cod_com_mat
     , mov.data_mat
     , mov.anno_atto_mat
     , mov.atto_mat
     , mov.parte_mat
     , mov.serie_mat
     , mov.ufficio_mat
     , mov.anno_atto_mat_tr
     , mov.atto_mat_tr
     , mov.parte_mat_tr
     , mov.serie_mat_tr
     , mov.ufficio_mat_tr
     , mov.cod_pro_mor
     , mov.cod_com_mor
     , mov.data_mor
     , mov.anno_atto_mor
     , mov.atto_mor
     , mov.parte_mor
     , mov.serie_mor
     , mov.ufficio_mor
     , mov.anno_atto_mor_tr
     , mov.atto_mor_tr
     , mov.parte_mor_tr
     , mov.serie_mor_tr
     , mov.ufficio_mor_tr
     , mov.cod_pro_ved
     , mov.cod_com_ved
     , mov.data_ved
     , mov.anno_atto_ved
     , mov.atto_ved
     , mov.parte_ved
     , mov.serie_ved
     , mov.ufficio_ved
     , mov.cod_fiscale
     , mov.data_reg
     , mov.terminalista
     , mov.elettorale
     , mov.annullamento
     , mov.anno_progr
     , mov.numero_progr
     , mov.cod_pro_div_prec
     , mov.cod_com_div_prec
     , mov.data_div_prec
     , mov.anno_atto_div_prec
     , mov.atto_div_prec
     , mov.parte_div_prec
     , mov.serie_div_prec
     , mov.ufficio_div_prec
     , mov.cod_pro_div
     , mov.cod_com_div
     , mov.data_div
     , mov.anno_atto_div
     , mov.atto_div
     , mov.parte_div
     , mov.serie_div
     , mov.ufficio_div
     , mov.matricola_aire_prec
     , mov.matricola_aire
     , mov.cod_pro_atto_mat_prec
     , mov.cod_com_atto_mat_prec
     , mov.cod_pro_atto_ved_prec
     , mov.cod_com_atto_ved_prec
     , mov.cod_pro_atto_mor_prec
     , mov.cod_com_atto_mor_prec
     , mov.cod_pro_atto_mat
     , mov.cod_com_atto_mat
     , mov.cod_pro_atto_ved
     , mov.cod_com_atto_ved
     , mov.cod_pro_atto_mor
     , mov.cod_com_atto_mor
     , mov.cf_calcolato_prec
     , mov.cf_calcolato
     , mov.cod_variazione
     , mov.scala_prec
     , mov.piano_prec
     , mov.zipcode_prec
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.scala), mov.scala) scala
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.piano), mov.piano) piano
     , decode(mov.cod_mov, 98, decode(mov.cod_eve, 98, mov.zipcode), mov.zipcode) zipcode
     , mov.cod_edificio_cens_prec
     , mov.cod_edificio_cens
     , mov.no_conteggio
     , mov.cod_pro_atto_div
     , mov.cod_com_atto_div
     , mov.data_div_giu
     , mov.data_div_ann
     , mov.cod_pro_atto_div_prec
     , mov.cod_com_atto_div_prec
     , mov.data_div_giu_prec
     , mov.data_div_ann_prec
     , mov.cod_pro_iscr_aire
     , mov.cod_com_iscr_aire
     , mov.provincia_contea_prec
     , mov.presso_prec
     , decode(mov.cod_mov, 98, decode(mov.cod_eve, 98, mov.provincia_contea), mov.provincia_contea) provincia_contea
     , decode(mov.cod_mov, 98, decode(mov.cod_eve, 98, mov.presso), mov.presso) presso
     , mov.anno_nas_prec
     , mov.anno_mat_prec
     , mov.anno_nas
     , mov.anno_mat
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.sub_interno), mov.sub_interno) sub_interno
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.civico_esterno), mov.civico_esterno) civico_esterno
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.civico_interno), mov.civico_interno) civico_interno
     , mov.sub_interno_prec
     , mov.civico_esterno_prec
     , mov.civico_interno_prec
     , mov.matricola_pd_prec
     , mov.matricola_md_prec
     , mov.matricola_pd
     , mov.matricola_md
     , mov.data_inizio_naz
     , mov.data_inizio_naz_prec
     , mov.no_vana
     , mov.atto_nas_digitale_prec
     , mov.atto_nas_tr_digitale_prec
     , mov.atto_mat_digitale_prec
     , mov.atto_mat_tr_digitale_prec
     , mov.atto_div_digitale_prec
     , mov.atto_ved_digitale_prec
     , mov.atto_mor_digitale_prec
     , mov.atto_mor_tr_digitale_prec
     , mov.atto_nas_digitale
     , mov.atto_nas_tr_digitale
     , mov.atto_mat_digitale
     , mov.atto_mat_tr_digitale
     , mov.atto_div_digitale
     , mov.atto_ved_digitale
     , mov.atto_mor_digitale
     , mov.atto_mor_tr_digitale
     , mov.des_evento
     , mov.id_anadrp_prec
     , mov.id_anadpr_prec
     , mov.id_anadrp
     , mov.id_anadpr
     , mov.des_stato_civile_prec
     , mov.des_stato_civile
     , mov.cognome_prec
     , mov.nome_prec
     , mov.cognome_pd_prec
     , mov.nome_pd_prec
     , mov.cognome_md_prec
     , mov.nome_md_prec
     , mov.cognome_cn_prec
     , mov.nome_cn_prec
     , mov.cognome_intestatario_prec
     , mov.nome_intestatario_prec
     , mov.cognome
     , mov.nome
     , mov.cognome_pd
     , mov.nome_pd
     , mov.cognome_md
     , mov.nome_md
     , mov.cognome_cn
     , mov.nome_cn
     , mov.cognome_intestatario
     , mov.nome_intestatario
     , mov.des_com_eve
     , mov.flag_solo_campi_variati
     , mov.sigla_pro_eve
     , mov.des_com_aire_prec
     , mov.sigla_pro_aire_prec
     , mov.des_com_nas_prec
     , mov.sigla_pro_nas_prec
     , mov.des_com_mat_prec
     , mov.sigla_pro_mat_prec
     , mov.des_com_ved_prec
     , mov.sigla_pro_ved_prec
     , mov.des_com_div_prec
     , mov.sigla_pro_div_prec
     , mov.des_com_mor_prec
     , mov.sigla_pro_mor_prec
     , mov.des_com_atto_nas_prec
     , mov.sigla_pro_atto_nas_prec
     , mov.des_com_atto_mat_prec
     , mov.sigla_pro_atto_mat_prec
     , mov.des_com_atto_ved_prec
     , mov.sigla_pro_atto_ved_prec
     , mov.des_com_atto_div_prec
     , mov.sigla_pro_atto_div_prec
     , mov.des_com_atto_mor_prec
     , mov.sigla_pro_atto_mor_prec
     , mov.des_com_aire
     , mov.sigla_pro_aire
     , mov.des_com_nas
     , mov.sigla_pro_nas
     , mov.des_com_mat
     , mov.sigla_pro_mat
     , mov.des_com_ved
     , mov.sigla_pro_ved
     , mov.des_com_div
     , mov.sigla_pro_div
     , mov.des_com_mor
     , mov.sigla_pro_mor
     , mov.des_com_atto_nas
     , mov.sigla_pro_atto_nas
     , mov.des_com_atto_mat
     , mov.sigla_pro_atto_mat
     , mov.des_com_atto_ved
     , mov.sigla_pro_atto_ved
     , mov.des_com_atto_div
     , mov.sigla_pro_atto_div
     , mov.des_com_atto_mor
     , mov.sigla_pro_atto_mor
     , mov.des_com_iscr_aire
     , mov.sigla_pro_iscr_aire
     , mov.d_data_eve
     , mov.d_data_inizio_fam
     , mov.d_data_inizio_res
     , mov.d_data_reg
     , mov.d_data_nas_prec
     , mov.d_data_mat_prec
     , mov.d_data_ved_prec
     , mov.d_data_div_prec
     , mov.d_data_div_giu_prec
     , mov.d_data_div_ann_prec
     , mov.d_data_mor_prec
     , mov.d_data_inizio_naz_prec
     , mov.d_data_nas
     , mov.d_data_mat
     , mov.d_data_ved
     , mov.d_data_div
     , mov.d_data_div_giu
     , mov.d_data_div_ann
     , mov.d_data_mor
     , mov.d_data_inizio_naz
     , mov.cod_consolato_aire_prec
     , mov.sede_consolato_aire_prec
     , mov.cod_consolato_aire
     , mov.sede_consolato_aire
     , mov.id
     , mov.FLAG_METRICO_PREC
     , mov.PROGR_SNC_PREC
     , mov.FLAG_LETTERA_PREC
     , mov.FLAG_ESPONENTE_PREC
     , mov.FLAG_NUI_PREC
     , mov.NUI_PREC
     , mov.COLORE_PREC
     , mov.CORTE_PREC
     , mov.INTERNO2_PREC
     , mov.SUB_INTERNO2_PREC
     , mov.SECONDARIO_PREC
     , mov.SCALA_ESTERNA_PREC
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.FLAG_METRICO), mov.FLAG_METRICO) flag_metrico
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.PROGR_SNC), mov.PROGR_SNC) progr_snc
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.FLAG_LETTERA), mov.FLAG_LETTERA) flag_lettera
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.FLAG_ESPONENTE), mov.FLAG_ESPONENTE) flag_esponente
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.FLAG_NUI), mov.FLAG_NUI) flag_nui
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.NUI), mov.NUI) nui
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.COLORE), mov.COLORE) colore
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.CORTE), mov.CORTE) corte
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.INTERNO2), mov.INTERNO2) interno2
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.SUB_INTERNO2), mov.SUB_INTERNO2) sub_interno2
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.SECONDARIO), mov.SECONDARIO) secondario
     , decode(mov.cod_mov, 97, decode(mov.cod_eve, 98, mov.SCALA_ESTERNA), mov.SCALA_ESTERNA) scala_esterna
     , f_SEN_privacy(mov.matricola,mov.anno_progr,mov.numero_progr) SEN_privacy
  from anamov_v mov
 where ((cod_mov not in (1,2,3,4,5,10,11,12,13) 
        or (cod_eve in (1,50))						-- nascita / morte
        )
       or ((cod_mov = 2 and cod_eve = 62)				-- accertamenti negativi
           or (cod_mov = 1 and cod_eve in (4,17)			-- iscrizione preliminare / reimmi aire con accertamenti negativi
              and exists (select 1
                            from anamov b
                           where b.cod_mov      = 2 
                             and b.cod_eve      = 62	
                             and b.matricola    = mov.matricola
                             and b.anno_pratica = mov.anno_pratica
                             and b.pratica      = mov.pratica)
              )
           or (cod_mov = 1 and cod_eve = 18)				-- ripristino posizione anagrafica
           or (cod_mov = 2 and cod_eve = 51				-- emigrazione c/ripristino
              and exists (select 1
                            from anamov b
                           where b.cod_mov      = 1 
                             and b.cod_eve      = 18
                             and b.matricola    = mov.matricola
                             and b.anno_pratica = mov.anno_pratica
                             and b.pratica      = mov.pratica)
              )
          )
       )
   and mov.no_vana is null
/
comment on table anamov_VANA is 'VANA - Elenco Variazioni - con filtro - per Visualizzazione (view)'
/
