--liquibase formatted sql
--changeset amonopoli:202305181240_1 runAlways:true runOnChange:true stripComments:false
create or replace view civnas_v_json as
select nas.id
     , nas.id_atto
     , nas.ufficio
     , nas.anno
     , nas.parte
     , nas.serie
     , nas.atto
-- evento
     , f_ANSC_flag_secretato(2,cta.sigla) flagSecretato
     , f_ANSC_valore_inp('ID_VERSION',1,10,'9','') idVersion
     , '1' idTipoEvento		-- (anst01) 1 - NASCITA / 2 - MORTE / 3 - MATRIMONIO / 4 - UNIONE CIVILE / 5 - CITTADINANZA 
     , f_ANSC_id_tipo_contenuto(t03.tipo_atto_ansc,nas.natura,to_char(null)) idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , '1' datiProdotti
     , nas.id_usecase_ansc idUseCase		-- (anst03) 
     , t03.descrizione  descrizioneCasoUso	-- (anst03) 
     , decode(f_ANSC_flag_firmato('NAS', nas.id, 'USC'), 'S', 'FIRMATO DA USC', 'CONFERMATO') stato   -- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , 'FIRMATO DA USC' stato_firmatoUSC   -- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') dataFormazione
     , to_char(dpa.d_data_atto_utente,'yyyy') annoAtto
     , to_char(dpa.d_data_atto_utente,'mm') meseAtto
     , to_char(dpa.d_data_atto_utente,'dd') giornoAtto
     , lpad(dpa.ore_atto_utente,2,'0') ora
     , lpad(dpa.minuti_atto_utente,2,'0') minuto
     , to_char(f_ANSC_data_validita(2,cta.sigla,nas.natura,nas.d_data_nas,dpa.d_data_atto_utente),'yyyy-mm-dd') dataValidita
     , nas.numero_unico numeroatto
     , decode(nas.parte||nas.serie,'1B',nas.motivo_ritardo) noteRitardo
     , f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,'') idComuneRegistrazione
     , f_ANSC_comune_al(m.cod_provincia,m.cod_comune,'') nomeComuneRegistrazione
     , f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,'') idProvinciaRegistrazione
     , f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,'') siglaProvinciaRegistrazione
     , f_ANSC_id_operatore(nas.terminalista) operatore
     , f_ANSC_ruolo_operatore(dpa.qualifica_utente) ruoloOperatore
     , f_ANSC_nome_operatore(nas.terminalista) operatoreNome
     , f_ANSC_cognome_operatore(nas.terminalista) operatoreCognome
     , 'true' redattoNellaCasaComunale
     , f_ANSC_tipo_dichiarante(dpa.tipo_dichiarante,dpa.tipo_comparente) tipoDichiarante
     , f_ANSC_ausilio_interprete(dpa.tipo_comparente) ausilioInterprete
     , 'false' sentenzaFiglioIncestuoso
     , f_ANSC_motivo_recupero(nas.motivo_recupero_ansc) motivoRecupero            -- (anst96)
     , decode(nas.motivo_recupero_ansc,'','',to_char(dpa.d_data_atto_utente,'yyyy-mm-dd')) dataDecorrenza
     , decode(nas.natura, 'D', 'false', 'true') flagCertificatoSemplice
     , decode(nas.natura, 'D', 'false', 'true') flagEstrattoPerRiassunto
-- intestatari
     , nas.cod_fiscale INT_codiceFiscale
     , f_ANSC_stringa_unicode('CIVNAS',nas.id,'COGNOME_1',nvl(occ.cognome,nas.cognome)) INT_cognome
     , f_ANSC_stringa_unicode('CIVNAS',nas.id,'NOME_1',nvl(occ.nome,nas.nome)) INT_nome
--     , lower(nas.sesso) INT_sesso
     , nas.sesso INT_sesso
     , decode(nas.sesso,'M','maschile','F','femminile','non conosciuto') INT_descrizioneSesso
     , to_char(nas.d_data_nas,'yyyy-mm-dd') INT_dataNascita
     , f_ANSC_id_comune_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas) INT_idComuneNascita
     , f_ANSC_comune_italiano(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas) INT_nomeComuneNascita
     , f_ANSC_id_provincia_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas) INT_idProvinciaNascita
     , f_ANSC_provincia_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas) INT_siglaProvinciaNascita
     , f_ANSC_id_stato_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas) INT_idStatoNascita
     , f_ANSC_stato_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas) INT_nomeStatoNascita
     , f_ANSC_comune_estero(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas) INT_comuneEsteroNascita
     , f_ANSC_id_comune_al(nas.cod_pro_res,nas.cod_com_res,dpa.d_data_atto_utente) INT_idComuneResidenza
     , f_ANSC_comune_italiano(nas.cod_pro_res,nas.cod_com_res,dpa.d_data_atto_utente) INT_nomeComuneResidenza
     , f_ANSC_id_provincia_al(nas.cod_pro_res,nas.cod_com_res,dpa.d_data_atto_utente) INT_idProvinciaResidenza
     , f_ANSC_provincia_al(nas.cod_pro_res,nas.cod_com_res,dpa.d_data_atto_utente) INT_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(nas.cod_pro_res,nas.cod_com_res,dpa.d_data_atto_utente) INT_idStatoResidenza
     , f_ANSC_stato_al(nas.cod_pro_res,nas.cod_com_res,dpa.d_data_atto_utente) INT_nomeStatoResidenza
     , f_ANSC_comune_estero(nas.cod_pro_res,nas.cod_com_res,dpa.d_data_atto_utente) INT_comuneEsteroResidenza
     , decode(f_flag_comune_estero(nas.cod_pro_res,nas.cod_com_res), 'S',
         CASE 
           when lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0') = lpad(nas.cod_pro_res_md,3,'0')||lpad(nas.cod_com_res_md,3,'0') and f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md) is not null THEN
                f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md)
           when lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0') = lpad(nas.cod_pro_res_pd,3,'0')||lpad(nas.cod_com_res_pd,3,'0') and f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd) is not null THEN
                f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd)
         END) INT_idComuneAIRE
     , decode(f_flag_comune_estero(nas.cod_pro_res,nas.cod_com_res), 'S',
         CASE 
           when lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0') = lpad(nas.cod_pro_res_md,3,'0')||lpad(nas.cod_com_res_md,3,'0') and f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md) is not null THEN
                f_ANSC_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md)
           when lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0') = lpad(nas.cod_pro_res_pd,3,'0')||lpad(nas.cod_com_res_pd,3,'0') and f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd) is not null THEN
                f_ANSC_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd)
         END) INT_nomeComuneAIRE
     , decode(f_flag_comune_estero(nas.cod_pro_res,nas.cod_com_res), 'S',
         CASE 
           when lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0') = lpad(nas.cod_pro_res_md,3,'0')||lpad(nas.cod_com_res_md,3,'0') and f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md) is not null THEN
                f_ANSC_id_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md)
           when lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0') = lpad(nas.cod_pro_res_pd,3,'0')||lpad(nas.cod_com_res_pd,3,'0') and f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd) is not null THEN
                f_ANSC_id_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd)
        END) INT_idProvinciaAIRE
     , decode(f_flag_comune_estero(nas.cod_pro_res,nas.cod_com_res), 'S',
         CASE 
           when lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0') = lpad(nas.cod_pro_res_md,3,'0')||lpad(nas.cod_com_res_md,3,'0') and f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md) is not null THEN
                f_ANSC_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md)
           when lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0') = lpad(nas.cod_pro_res_pd,3,'0')||lpad(nas.cod_com_res_pd,3,'0') and f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd) is not null THEN
                f_ANSC_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd)
         END) INT_siglaProvinciaAIRE
--
     , nas.nuovo_cognome INT_nuovoCognome
     , nas.nuovo_nome INT_nuovoNome
-- datiEventoRiconoscimento
     , CASE when cta.sigla in ('RIC') THEN f_ANSC_tipo_assenso(nas.tipo_assenso) END assensoFiglio
     , CASE when cta.sigla in ('RIC') THEN 'false' END preMorto
     , CASE when cta.sigla in ('RIC') THEN f_ANSC_tipo_scelta_cognome(nas.tipo_scelta_cognome) END tipoSceltaCognome
-- datiEventoRiconoscimento.attoNascita
     , CASE when cta.sigla in ('RIC','ADO') THEN mar.id_atto_ansc_nas END INT_NAS_idAttoAnsc
     , CASE when cta.sigla in ('RIC','ADO') THEN '1' END INT_NAS_idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , CASE when cta.sigla in ('RIC','ADO') THEN '1' END INT_NAS_tipologia
     , CASE when cta.sigla in ('RIC','ADO') THEN decode(mar.id_atto_ansc_nas, '', mar.anno_nas, f_CIV_get_estremi_id_atto_ansc(mar.id_atto_ansc_nas,'ANNO')) END INT_NAS_annoAtto
     , CASE when cta.sigla in ('RIC','ADO') THEN decode(mar.id_atto_ansc_nas, '', mar.atto_nas, f_CIV_get_estremi_id_atto_ansc(mar.id_atto_ansc_nas,'NUMERO_COMUNALE')) END INT_NAS_numeroAtto
     , CASE when cta.sigla in ('RIC','ADO') THEN decode(mar.id_atto_ansc_nas, '', mar.parte_nas) END INT_NAS_parte
     , CASE when cta.sigla in ('RIC','ADO') THEN decode(mar.id_atto_ansc_nas, '', mar.serie_nas) END INT_NAS_serie
     , CASE when cta.sigla in ('RIC','ADO') THEN decode(mar.id_atto_ansc_nas, '', mar.ufficio_nas) END INT_NAS_ufficio
     , CASE when cta.sigla in ('RIC','ADO') THEN f_ANSC_id_comune_al(mar.cod_pro_atto_nas, mar.cod_com_atto_nas, nas.d_data_nas) END INT_NAS_idComuneReg
     , CASE when cta.sigla in ('RIC','ADO') THEN f_ANSC_id_provincia_al(mar.cod_pro_atto_nas, mar.cod_com_atto_nas, nas.d_data_nas) END INT_NAS_idProvinciaReg 
     , CASE when cta.sigla in ('RIC','ADO') THEN f_ANSC_comune_al(mar.cod_pro_atto_nas, mar.cod_com_atto_nas, nas.d_data_nas) END INT_NAS_nomeComuneReg 
     , CASE when cta.sigla in ('RIC','ADO') THEN f_ANSC_provincia_al(mar.cod_pro_atto_nas, mar.cod_com_atto_nas, nas.d_data_nas) END INT_NAS_siglaProvinciaReg
     , CASE when cta.sigla in ('RIC','ADO') THEN to_char(nvl(mar.d_data_atto_nas,nas.d_data_nas),'yyyy-mm-dd') END INT_NAS_dataFormazione
-- datiEventoRiconoscimento.attoAssenso
     , CASE when cta.sigla in ('RIC') THEN dpa.atto_assenso_id_atto_ansc END ATT_ASS_idAttoAnsc
--     , CASE when cta.sigla in ('RIC') THEN '1' END ATT_ASS_idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
--     , CASE when cta.sigla in ('RIC') THEN '1' END ATT_ASS_tipologia
     , CASE when cta.sigla in ('RIC') THEN decode(dpa.atto_assenso_id_atto_ansc, '', dpa.atto_assenso_anno, f_CIV_get_estremi_id_atto_ansc(dpa.atto_assenso_id_atto_ansc,'ANNO')) END ATT_ASS_annoAtto
     , CASE when cta.sigla in ('RIC') THEN decode(dpa.atto_assenso_id_atto_ansc, '', dpa.atto_assenso_atto, f_CIV_get_estremi_id_atto_ansc(dpa.atto_assenso_id_atto_ansc,'NUMERO_COMUNALE')) END ATT_ASS_numeroAtto
     , CASE when cta.sigla in ('RIC') THEN decode(dpa.atto_assenso_id_atto_ansc, '', dpa.atto_assenso_parte) END ATT_ASS_parte
     , CASE when cta.sigla in ('RIC') THEN decode(dpa.atto_assenso_id_atto_ansc, '', dpa.atto_assenso_serie) END ATT_ASS_serie
     , CASE when cta.sigla in ('RIC') THEN decode(dpa.atto_assenso_id_atto_ansc, '', dpa.atto_assenso_ufficio) END ATT_ASS_ufficio
     , CASE when cta.sigla in ('RIC') THEN f_ANSC_id_comune_al(dpa.atto_assenso_cod_pro, dpa.atto_assenso_cod_com, dpa.d_atto_assenso_data) END ATT_ASS_idComuneReg
     , CASE when cta.sigla in ('RIC') THEN f_ANSC_id_provincia_al(dpa.atto_assenso_cod_pro, dpa.atto_assenso_cod_com, dpa.d_atto_assenso_data) END ATT_ASS_idProvinciaReg 
     , CASE when cta.sigla in ('RIC') THEN f_ANSC_comune_al(dpa.atto_assenso_cod_pro, dpa.atto_assenso_cod_com, dpa.d_atto_assenso_data) END ATT_ASS_nomeComuneReg 
     , CASE when cta.sigla in ('RIC') THEN f_ANSC_provincia_al(dpa.atto_assenso_cod_pro, dpa.atto_assenso_cod_com, dpa.d_atto_assenso_data) END ATT_ASS_siglaProvinciaReg
     , CASE when cta.sigla in ('RIC') THEN to_char(dpa.d_atto_assenso_data,'yyyy-mm-dd') END ATT_ASS_dataFormazione
--
     , decode(nas.sesso,'M','o','F','a') INT_genere
     , f_ANSC_id_nazionalita(dci.ist_ci) INT_idNazionalita
     , f_get_descrizione_DCI(nas.nazionalita,'') INT_nazionalita
     , decode(dpa.tipo_dichiarante,
         'IN', f_ANSC_comprensione(dpa.comprensione_dic)
       ) INT_tipoImpedimento
     , decode(cta.sigla, 
         'TEP', 'false',
         'RIC', f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'AL'),
                f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'IN')
       ) INT_flagDichiarante
     , decode(cta.sigla, 
         'TEP', 'false',
         'RIC', f_ANSC_flag_comparente(dpa.tipo_comparente,'AL'),
                f_ANSC_flag_comparente(dpa.tipo_comparente,'IN')
       ) INT_flagComparente
     , decode(cta.sigla, 
         'TEP', 'false',
         'RIC', f_ANSC_flag_firmatario(dpa.tipo_firmatario,'AL'),
                f_ANSC_flag_firmatario(dpa.tipo_firmatario,'IN')
       ) INT_flagFirmatario
     , nas.note note
-- datiDiNascita
     , to_char(nas.d_data_nas,'yyyy') annoNascita
     , to_char(nas.d_data_nas,'mm') meseNascita
     , to_char(nas.d_data_nas,'dd') giornoNascita
     , dpa.luogo_nas luogoFiliazione
     , lpad(nas.ore,2,'0') oraNascita
     , lpad(nas.minuti,2,'0') minutoNascita
     , lower(nvl(nas.nato_morto,'NO')) natoMorto
     , decode(nas.nato_morto,'NO','si','no') natoVivoMaDeceduto
     , lower(nvl(nas.parto_plurimo,'NO')) partoGemellare
     , decode(nas.parto_plurimo, 'SI', nas.parto_plurimo_tot_gemelli) numeroGemelli
     , decode(nas.parto_plurimo, 'SI', nas.parto_plurimo_num_gemello) progressivoGemello
     , f_ANSC_id_stato_al(m.cod_provincia,m.cod_comune,nas.d_data_nas) idStatoEvento
     , f_ANSC_stato_al(m.cod_provincia,m.cod_comune,nas.d_data_nas) nomeStatoEvento
     , f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,nas.d_data_nas) idProvinciaEvento
     , f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,nas.d_data_nas) siglaProvinciaEvento
     , f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,nas.d_data_nas) idComuneEvento
     , f_ANSC_comune_al(m.cod_provincia,m.cod_comune,nas.d_data_nas) nomeComuneEvento
--     , lower(nas.sesso) sesso
     , nas.sesso sesso
     , f_ANSC_tipo_accertamento(2,nas.id_atto,dpa.tipo_accertamento) tipoAccertamento
     , f_ANSC_tipo_nascita_soggetto(nas.nato_morto) tipoNascitaSoggetto
-- madre
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_stringa_unicode('CIVNAS',nas.id,'COGNOME_MD',nas.cognome_md) END MAT_cognome
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_stringa_unicode('CIVNAS',nas.id,'NOME_MD',nas.nome_md) END MAT_nome
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN decode(nas.cognome_md||nas.nome_md,'','','F') END MAT_sesso
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN decode(nas.cognome_md||nas.nome_md,'','','femminile') END MAT_descrizioneSesso
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN to_char(nas.d_data_nas_md,'yyyy-mm-dd') END MAT_dataNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_comune_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md) END MAT_idComuneNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_italiano(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md) END MAT_nomeComuneNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_provincia_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md) END MAT_idProvinciaNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_provincia_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md) END MAT_siglaProvinciaNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_stato_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md) END MAT_idStatoNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_stato_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md) END MAT_nomeStatoNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_estero(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md) END MAT_comuneEsteroNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_comune_al(nas.cod_pro_res_md,nas.cod_com_res_md,dpa.d_data_atto_utente) END MAT_idComuneResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_italiano(nas.cod_pro_res_md,nas.cod_com_res_md,dpa.d_data_atto_utente) END MAT_nomeComuneResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_provincia_al(nas.cod_pro_res_md,nas.cod_com_res_md,dpa.d_data_atto_utente) END MAT_idProvinciaResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_provincia_al(nas.cod_pro_res_md,nas.cod_com_res_md,dpa.d_data_atto_utente) END MAT_siglaProvinciaResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_stato_al(nas.cod_pro_res_md,nas.cod_com_res_md,dpa.d_data_atto_utente) END MAT_idStatoResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_stato_al(nas.cod_pro_res_md,nas.cod_com_res_md,dpa.d_data_atto_utente) END MAT_nomeStatoResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_estero(nas.cod_pro_res_md,nas.cod_com_res_md,dpa.d_data_atto_utente) END MAT_comuneEsteroResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md) END MAT_idComuneAIRE
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md) END MAT_nomeComuneAIRE
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md) END MAT_idProvinciaAIRE
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),nas.cod_pro_res_md,nas.cod_com_res_md) END MAT_siglaProvinciaAIRE
     , 'false' MAT_flagTrasmissioneResidenza
--
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN decode(nas.cognome_md||nas.nome_md,'','','a') END MAT_genere
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_nazionalita(dci_md.ist_ci) END MAT_idNazionalita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_get_descrizione_dci(nas.nazionalita_md,'') END MAT_nazionalita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN decode(dpa.tipo_dichiarante,'MD',f_ANSC_comprensione(dpa.comprensione_dic)) END MAT_tipoImpedimento
--
     , CASE when cta.sigla in ('TEP', 'CNA','T2A') THEN 'false' ELSE f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'MD') END MAT_flagDichiarante
     , CASE when cta.sigla in ('TEP', 'CNA','T2A') THEN 'false' ELSE f_ANSC_flag_comparente(dpa.tipo_comparente,'MD') END MAT_flagComparente
     -- per CNA non dobbiamo richiedere il servizio R006 - Firma Dichiarante
     , CASE when cta.sigla in ('TEP', 'CNA','T2A') THEN 'false' ELSE f_ANSC_flag_firmatario(dpa.tipo_firmatario,'MD') END MAT_flagFirmatario
-- padre
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_stringa_unicode('CIVNAS',nas.id,'COGNOME_PD',nas.cognome_pd) END PAT_cognome
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_stringa_unicode('CIVNAS',nas.id,'NOME_PD',nas.nome_pd) END PAT_nome
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN decode(nas.cognome_pd||nas.nome_pd,'','',decode(m.id||'-'||nas.id_atto,'039010-NAS_2025_2B_254_U1','F','M')) END PAT_sesso
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN decode(nas.cognome_pd||nas.nome_pd,'','',decode(m.id||'-'||nas.id_atto,'039010-NAS_2025_2B_254_U1','femminile','maschile')) END PAT_descrizioneSesso
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN to_char(nas.d_data_nas_pd,'yyyy-mm-dd') END PAT_dataNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_comune_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd) END PAT_idComuneNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_italiano(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd) END PAT_nomeComuneNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_provincia_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd) END PAT_idProvinciaNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_provincia_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd) END PAT_siglaProvinciaNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_stato_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd) END PAT_idStatoNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_stato_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd) END PAT_nomeStatoNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_estero(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd) END PAT_comuneEsteroNascita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_comune_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,dpa.d_data_atto_utente) END PAT_idComuneResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_italiano(nas.cod_pro_res_pd,nas.cod_com_res_pd,dpa.d_data_atto_utente) END PAT_nomeComuneResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_provincia_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,dpa.d_data_atto_utente) END PAT_idProvinciaResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_provincia_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,dpa.d_data_atto_utente) END PAT_siglaProvinciaResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_stato_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,dpa.d_data_atto_utente) END PAT_idStatoResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_stato_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,dpa.d_data_atto_utente) END PAT_nomeStatoResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_estero(nas.cod_pro_res_pd,nas.cod_com_res_pd,dpa.d_data_atto_utente) END PAT_comuneEsteroResidenza
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd) END PAT_idComuneAIRE
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd) END PAT_nomeComuneAIRE
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd) END PAT_idProvinciaAIRE
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),nas.cod_pro_res_pd,nas.cod_com_res_pd) END PAT_siglaProvinciaAIRE
     , 'false' PAT_flagTrasmissioneResidenza
--
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN decode(nas.cognome_pd||nas.nome_pd,'','',decode(m.id||'-'||nas.id_atto,'039010-NAS_2025_2B_254_U1','a','o')) END PAT_genere
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_ANSC_id_nazionalita(dci_pd.ist_ci) END PAT_idNazionalita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN f_get_descrizione_dci(nas.nazionalita_pd,'') END PAT_nazionalita
     , CASE when nas.flag_figlio_di_ignoti is null or cta.sigla = 'RIC' THEN decode(dpa.tipo_dichiarante,'PD',f_ANSC_comprensione(dpa.comprensione_dic)) END PAT_tipoImpedimento
--
     , CASE when cta.sigla in ('TEP', 'CNA','T2A') THEN 'false' ELSE f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'PD') END PAT_flagDichiarante
     , CASE when cta.sigla in ('TEP', 'CNA','T2A') THEN 'false' ELSE f_ANSC_flag_comparente(dpa.tipo_comparente,'PD') END PAT_flagComparente
     -- per CNA non dobbiamo richiedere il servizio R006 - Firma Dichiarante
     , CASE when cta.sigla in ('TEP', 'CNA','T2A') THEN 'false' ELSE f_ANSC_flag_firmatario(dpa.tipo_firmatario,'PD') END PAT_flagFirmatario
-- datiDichiarante
  -- comprensione
     , f_ANSC_comprensione(dpa.comprensione_dic) comprensione
  -- motivoImpedimentoScrittura
     , dpa.motivo_impedimento_dic motivoImpedimentoScrittura
-- dichiarante
     , decode(dpa.tipo_dichiarante,
               'OS', sog_OS.cognome,
               'PP', sog_PP.cognome,
               'PM', sog_PM.cognome,
               dpa.cognome_dic) DIC_cognome
     , decode(dpa.tipo_dichiarante,
               'OS', sog_OS.nome,
               'PP', sog_PP.nome,
               'PM', sog_PM.nome,
               dpa.nome_dic) DIC_nome
     , decode(dpa.tipo_dichiarante,
               'OS', sog_OS.sesso,
               'PP', sog_PP.sesso,
               'PM', sog_PM.sesso,
               dpa.sesso_dic) DIC_sesso
     , decode(dpa.tipo_dichiarante,
               'OS', decode(sog_OS.sesso,'M','maschile','F','femminile'),
               'PP', decode(sog_PP.sesso,'M','maschile','F','femminile'),
               'PM', decode(sog_PM.sesso,'M','maschile','F','femminile'),
               decode(dpa.sesso_dic,'M','maschile','F','femminile')) DIC_descrizioneSesso
     , decode(dpa.tipo_dichiarante,
               'OS', to_char(sog_OS.d_data_nas,'yyyy-mm-dd'),
               'PP', to_char(sog_PP.d_data_nas,'yyyy-mm-dd'),
               'PM', to_char(sog_PM.d_data_nas,'yyyy-mm-dd'),
               to_char(dpa.d_data_nas_dic,'yyyy-mm-dd')) DIC_dataNascita
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_id_comune_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,sog_OS.d_data_nas),
               'PP', f_ANSC_id_comune_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,sog_PP.d_data_nas),
               'PM', f_ANSC_id_comune_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,sog_PM.d_data_nas),
               f_ANSC_id_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_idComuneNascita
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_comune_italiano(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,sog_OS.d_data_nas),
               'PP', f_ANSC_comune_italiano(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,sog_PP.d_data_nas),
               'PM', f_ANSC_comune_italiano(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,sog_PM.d_data_nas),
               f_ANSC_comune_italiano(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_nomeComuneNascita
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_id_provincia_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,sog_OS.d_data_nas),
               'PP', f_ANSC_id_provincia_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,sog_PP.d_data_nas),
               'PM', f_ANSC_id_provincia_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,sog_PM.d_data_nas),
               f_ANSC_id_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_idProvinciaNascita
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_provincia_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,sog_OS.d_data_nas),
               'PP', f_ANSC_provincia_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,sog_PP.d_data_nas),
               'PM', f_ANSC_provincia_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,sog_PM.d_data_nas),
               f_ANSC_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_siglaProvinciaNascita
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_id_stato_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,sog_OS.d_data_nas),
               'PP', f_ANSC_id_stato_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,sog_PP.d_data_nas),
               'PM', f_ANSC_id_stato_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,sog_PM.d_data_nas),
               f_ANSC_id_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_idStatoNascita
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_stato_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,sog_OS.d_data_nas),
               'PP', f_ANSC_stato_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,sog_PP.d_data_nas),
               'PM', f_ANSC_stato_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,sog_PM.d_data_nas),
               f_ANSC_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_nomeStatoNascita
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_comune_estero(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,sog_OS.d_data_nas),
               'PP', f_ANSC_comune_estero(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,sog_PP.d_data_nas),
               'PM', f_ANSC_comune_estero(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,sog_PM.d_data_nas),
               f_ANSC_comune_estero(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_comuneEsteroNascita
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_id_comune_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,dpa.d_data_atto_utente),
               'PP', f_ANSC_id_comune_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,dpa.d_data_atto_utente),
               'PM', f_ANSC_id_comune_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,dpa.d_data_atto_utente),
               f_ANSC_id_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,dpa.d_data_atto_utente)) DIC_idComuneResidenza
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_comune_italiano(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,dpa.d_data_atto_utente),
               'PP', f_ANSC_comune_italiano(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,dpa.d_data_atto_utente),
               'PM', f_ANSC_comune_italiano(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,dpa.d_data_atto_utente),
               f_ANSC_comune_italiano(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,dpa.d_data_atto_utente)) DIC_nomeComuneResidenza
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_id_provincia_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,dpa.d_data_atto_utente),
               'PP', f_ANSC_id_provincia_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,dpa.d_data_atto_utente),
               'PM', f_ANSC_id_provincia_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,dpa.d_data_atto_utente),
               f_ANSC_id_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,dpa.d_data_atto_utente)) DIC_idProvinciaResidenza
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_provincia_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,dpa.d_data_atto_utente),
               'PP', f_ANSC_provincia_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,dpa.d_data_atto_utente),
               'PM', f_ANSC_provincia_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,dpa.d_data_atto_utente),
               f_ANSC_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,dpa.d_data_atto_utente)) DIC_siglaProvinciaResidenza
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_id_stato_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,dpa.d_data_atto_utente),
               'PP', f_ANSC_id_stato_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,dpa.d_data_atto_utente),
               'PM', f_ANSC_id_stato_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,dpa.d_data_atto_utente),
               f_ANSC_id_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,dpa.d_data_atto_utente)) DIC_idStatoResidenza
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_stato_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,dpa.d_data_atto_utente),
               'PP', f_ANSC_stato_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,dpa.d_data_atto_utente),
               'PM', f_ANSC_stato_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,dpa.d_data_atto_utente),
               f_ANSC_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,dpa.d_data_atto_utente)) DIC_nomeStatoResidenza
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_comune_estero(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,dpa.d_data_atto_utente),
               'PP', f_ANSC_comune_estero(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,dpa.d_data_atto_utente),
               'PM', f_ANSC_comune_estero(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,dpa.d_data_atto_utente),
               f_ANSC_comune_estero(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,dpa.d_data_atto_utente)) DIC_comuneEsteroResidenza
     , decode(cta.sigla, 'TEP', 'N/D') DIC_indirizzoResidenza
     , decode(dpa.tipo_dichiarante,
               'OS', decode(sog_OS.sesso,'M','o','F','a'),
               'PP', decode(sog_PP.sesso,'M','o','F','a'),
               'PM', decode(sog_PM.sesso,'M','o','F','a'),
               decode(dpa.sesso_dic,'M','o','F','a')) DIC_genere
     , decode(dpa.tipo_dichiarante,
               'OS', f_ANSC_id_nazionalita(dci_os.ist_ci),
               'PP', f_ANSC_id_nazionalita(dci_pp.ist_ci),
               'PM', f_ANSC_id_nazionalita(dci_pm.ist_ci),
               f_ANSC_id_nazionalita(dci_dic.ist_ci)) DIC_idNazionalita
     , decode(dpa.tipo_dichiarante,
               'OS', f_get_descrizione_dci(sog_OS.nazionalita,''),
               'PP', f_get_descrizione_dci(sog_PP.nazionalita,''),
               'PM', f_get_descrizione_dci(sog_PM.nazionalita,''),
               f_get_descrizione_dci(dpa.nazionalita_dic,'')) DIC_nazionalita
     , decode(cta.sigla,
         'TEP', '0',
                decode(dpa.tipo_dichiarante,
                  'AL', f_ANSC_comprensione(dpa.comprensione_dic),
                  'PP', f_ANSC_comprensione(dpa.comprensione_dic),
                  'PM', f_ANSC_comprensione(dpa.comprensione_dic) 
                )
       ) DIC_tipoImpedimento
     , decode(cta.sigla,
         'TEP', decode (dpa.TIPO_RICHIESTA_TRASCRIZIONE, 'CV', 'true', 'false'),
         'RIC', 'false',
                decode(dpa.tipo_dichiarante,'PD','false','MD','false',f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,dpa.tipo_dichiarante))
       ) DIC_flagDichiarante
     , decode(cta.sigla,
         'TEP', decode (dpa.TIPO_RICHIESTA_TRASCRIZIONE, 'CV', 'true', 'false'),
         'RIC', 'false',
                decode(dpa.tipo_dichiarante,'PD','false','MD','false',f_ANSC_flag_comparente(dpa.tipo_comparente,dpa.tipo_dichiarante))
       ) DIC_flagComparente
     , decode(cta.sigla,
         'TEP', decode (dpa.tipo_firmatario, 'NE', 'false', 'true'), -- nelle TEP cdu 1312 la presenza di firmatari non dipende più dal tipo richiesta ma da campo in maschera
         'CNA', 'false', -- nelle CNA non ci sono firmatari
         'T2A', 'false', -- nelle T2A non ci sono firmatari
         'RIC', 'false',
                decode(dpa.tipo_dichiarante,'PD','false','MD','false',f_ANSC_flag_firmatario(dpa.tipo_firmatario,dpa.tipo_dichiarante))
       ) DIC_flagFirmatario
     , f_ANSC_titolo_dichiarante(dpa.tipo_dichiarante) titoloDichiarante
     , f_ANSC_tipo_procura(dpa.tipo_dichiarante) tipoProcura   
     , dpa.dati_procura datiEssenzialiProcura
-- inteprete
     , sog_IT.cognome ITP_cognome
     , sog_IT.nome ITP_nome
--     , lower(sog_IT.sesso) ITP_sesso
     , sog_IT.sesso ITP_sesso
     , decode(sog_IT.sesso,'M','maschile','F','femminile') ITP_descrizioneSesso
     , to_char(sog_IT.d_data_nas,'yyyy-mm-dd') ITP_dataNascita
     , f_ANSC_id_comune_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,sog_IT.d_data_nas) ITP_idComuneNascita
     , f_ANSC_comune_italiano(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,sog_IT.d_data_nas) ITP_nomeComuneNascita
     , f_ANSC_id_provincia_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,sog_IT.d_data_nas) ITP_idProvinciaNascita
     , f_ANSC_provincia_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,sog_IT.d_data_nas) ITP_siglaProvinciaNascita
     , f_ANSC_id_stato_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,sog_IT.d_data_nas) ITP_idStatoNascita
     , f_ANSC_stato_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,sog_IT.d_data_nas) ITP_nomeStatoNascita
     , f_ANSC_comune_estero(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,sog_IT.d_data_nas) ITP_comuneEsteroNascita
     , f_ANSC_id_comune_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,nas.d_data_nas) ITP_idComuneResidenza
     , f_ANSC_comune_italiano(sog_IT.cod_pro_res,sog_IT.cod_com_res,nas.d_data_nas) ITP_nomeComuneResidenza
     , f_ANSC_id_provincia_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,nas.d_data_nas) ITP_idProvinciaResidenza
     , f_ANSC_provincia_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,nas.d_data_nas) ITP_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,nas.d_data_nas) ITP_idStatoResidenza
     , f_ANSC_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,nas.d_data_nas) ITP_nomeStatoResidenza
     , f_ANSC_comune_estero(sog_IT.cod_pro_res,sog_IT.cod_com_res,nas.d_data_nas) ITP_comuneEsteroResidenza
     , decode(sog_IT.sesso,'M','o','F','a') ITP_genere
     , f_ANSC_id_nazionalita(dci_it.ist_ci) ITP_idNazionalita
     , f_get_descrizione_dci(sog_IT.nazionalita,'') ITP_nazionalita
     , CASE when cta.sigla in ('CNA','T2A') THEN 'false' ELSE f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'IT') END ITP_flagDichiarante
     , CASE when cta.sigla in ('CNA','T2A') THEN 'false' ELSE f_ANSC_flag_comparente(dpa.tipo_comparente,'IT') END ITP_flagComparente
     , CASE when cta.sigla in ('CNA','T2A') THEN 'false' ELSE f_ANSC_flag_firmatario(dpa.tipo_firmatario,'IT') END ITP_flagFirmatario
-- Atto notarile
     , to_char(dpa.d_atto_notarile_data_doc,'yyyy-mm-dd') NOT_dataTrascrizione
     , dpa.atto_notarile_estremi_doc NOT_estremiDocumento
     , dpa.atto_notarile_ente NOT_nomeEnte
     , f_ANSC_id_provincia_al(dpa.atto_notarile_cod_pro,dpa.atto_notarile_cod_com,'') NOT_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.atto_notarile_cod_pro,dpa.atto_notarile_cod_com,'') NOT_siglaProvinciaEnte
     , f_ANSC_id_comune_al(dpa.atto_notarile_cod_pro,dpa.atto_notarile_cod_com,'') NOT_idComuneEnte
     , f_ANSC_comune_al(dpa.atto_notarile_cod_pro,dpa.atto_notarile_cod_com,'') NOT_nomeComuneEnte
-- Trascrizione Nascita
     , f_ANSC_tipo_dichiarazione(2, cta.sigla, nas.id_usecase_ansc, dpa.tipo_richiesta_trascrizione) TRA_tipoRichiestaTrascrizione -- ANSC_38
     , decode(cta.sigla, 'TEP', decode(dpa.tipo_dichiarante, 'PD', 1, 'MD', 2, 'IN', 3, 'AL', 4)) TRA_tipoRichiedente -- ANSC_64
     , decode(cta.sigla, 'TEP', to_char(dpa.d_data_richiesta_trascrizione,'yyyy-mm-dd')
                       , 'TEA', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd')
                       , 'ADO', to_char(dpa.d_data_richiesta_trascrizione,'yyyy-mm-dd')
                              , to_char(nvl(dpa.d_data_nota_rif,dpa.d_ente_straniero_data_atto),'yyyy-mm-dd') ) TRA_dataComunicazione
     , decode(cta.sigla, 'O1A', to_char(null), 'Come da trascrizione contenuta nel corpo dell''atto') TRA_testoLibero
     , decode(cta.sigla, 'ODN', decode(nas.flag_figlio_di_ignoti,'S','true','false')) TRA_figlioDiIgnoti
     , decode(cta.sigla, 'TEA', f_ANSC_tipo_luogo_nascita(dpa.tipo_luogo_in_viaggio)) TRA_tipoLuogoNascita
     , decode(cta.sigla, 'TEA', decode(dpa.flag_in_viaggio,'S',dpa.luogo_nas)) TRA_specificaLuogoNascita
  -- atto - ente estero
     , decode(cta.sigla,
         'ADO', dpa.ente_straniero,
         'ODN', dpa.ente_straniero,
                dpa.autorita_prov) TRA_nomeEnte
     , decode(cta.sigla,
         'CNA', f_ANSC_id_comune_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas),
         'ADO', f_ANSC_id_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
         'ODN', f_ANSC_id_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
                f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) TRA_idComuneEnte
     , decode(cta.sigla,
         'CNA', f_ANSC_comune_italiano(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas),
         'ADO', f_ANSC_comune_italiano(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
         'ODN', f_ANSC_comune_italiano(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
                f_ANSC_comune_italiano(dpa.cod_pro_prov,dpa.cod_com_prov,'')) TRA_nomeComuneEnte
     , decode(cta.sigla,
         'CNA', f_ANSC_id_provincia_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas),
         'ADO', f_ANSC_id_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
         'ODN', f_ANSC_id_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
                f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) TRA_idProvinciaEnte
     , decode(cta.sigla,
         'CNA', f_ANSC_provincia_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas),
         'ADO', f_ANSC_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
         'ODN', f_ANSC_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
                f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) TRA_siglaProvinciaEnte
     , decode(cta.sigla,
         'CNA', f_ANSC_id_stato_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas),
         'ADO', f_ANSC_id_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
         'ODN', f_ANSC_id_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
                f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) TRA_nazioneEnte
     , decode(cta.sigla,
         'CNA', f_ANSC_stato_al(nas.cod_pro_nas,nas.cod_com_nas,nas.d_data_nas),
         'ADO', f_ANSC_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
         'ODN', f_ANSC_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
                f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) TRA_nomeNazioneEnte
     , decode(cta.sigla,
         'CNA', to_char(null),
         'ADO', f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
         'ODN', f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,''),
                f_ANSC_comune_estero(dpa.cod_pro_prov,dpa.cod_com_prov,'')) TRA_comuneEsteroEnte
     , decode(cta.sigla,
         'CNA', to_char(nvl(dpa.d_data_atto_orig,dpa.d_data_atto_utente),'yyyy-mm-dd'),
         'ADO', to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd'),
         'ODN', to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd'),
         'O1A', to_char(null),
                to_char(dpa.d_data_atto_utente,'yyyy-mm-dd')) TRA_dataTrascrizione
     , decode(cta.sigla,
         'ADO', dpa.ente_straniero_tipo_atto,
         'ODN', dpa.ente_straniero_tipo_atto,
                to_char(null)) TRA_descrizione
     , decode(cta.sigla,
         'ADO', dpa.ente_straniero_estremi_atto,
         'ODN', dpa.ente_straniero_estremi_atto,
                decode(dpa.nota_rif||dpa.anno_nota_rif,'',to_char(null),dpa.nota_rif||'/'||dpa.anno_nota_rif)) TRA_estremiDocumento
     , decode(cta.sigla,
         'ADO', to_char(null),
                dpa.id_consolato_ansc_prov) TRA_idAnagraficaConsolato
     , decode(cta.sigla,
         'ADO', to_char(null),
                t97.descrizione) TRA_nomeAnagraficaConsolato
  -- atto estero - ente estero
     , dpa.ente_straniero EST_nomeEnte
     , f_ANSC_id_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idComuneEnte
     , f_ANSC_comune_italiano(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nomeComuneEnte
     , f_ANSC_id_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_siglaProvinciaEnte
     , f_ANSC_id_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nazioneEnte
     , f_ANSC_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nomeNazioneEnte
     , f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_comuneEsteroEnte
     , to_char(null) EST_dataComunicazione
     , case 
         when cta.sigla in ('TEP', 'TEA') then to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd') 
         when cta.sigla in ('O1A') then to_char(null) 
         else to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') 
       end EST_dataTrascrizione
     , dpa.ente_straniero_tipo_atto EST_descrizione
     , dpa.ente_straniero_estremi_atto EST_estremiDocumento
     , to_char(null) EST_idAnagraficaConsolato
     , to_char(null) EST_nomeAnagraficaConsolato
  -- enteDichiarante
     , dpa.ente_straniero ENT_nomeEnte
     , f_ANSC_id_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') ENT_idComuneEnte
     , f_ANSC_comune_italiano(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') ENT_nomeComuneEnte
     , f_ANSC_id_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') ENT_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') ENT_siglaProvinciaEnte
     , f_ANSC_id_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') ENT_nazioneEnte
     , f_ANSC_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') ENT_nomeNazioneEnte
     , f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') ENT_comuneEsteroEnte
     , to_char(null) ENT_dataComunicazione
     , to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd') ENT_dataTrascrizione
     , dpa.ente_straniero_tipo_atto ENT_descrizione
     , dpa.ente_straniero_estremi_atto ENT_estremiDocumento
     , to_char(null) ENT_idAnagraficaConsolato
     , to_char(null) ENT_nomeAnagraficaConsolato
  -- autorità mittente
     , decode(cta.sigla,
         'ADO', to_char(null)) MIT_ruoloEnteDichiarante
     , decode(cta.sigla,
         'ADO', dpa.autorita_prov) MIT_nomeEnte
     , decode(cta.sigla,
         'ADO', f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) MIT_idComuneEnte
     , decode(cta.sigla,
         'ADO', f_ANSC_comune_italiano(dpa.cod_pro_prov,dpa.cod_com_prov,'')) MIT_nomeComuneEnte
     , decode(cta.sigla,
         'ADO', f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) MIT_idProvinciaEnte
     , decode(cta.sigla,
         'ADO', f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) MIT_siglaProvinciaEnte
     , decode(cta.sigla,
         'ADO', f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) MIT_nazioneEnte
     , decode(cta.sigla,
         'ADO', f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) MIT_nomeNazioneEnte
     , decode(cta.sigla,
         'ADO', dpa.id_consolato_ansc_prov) MIT_idAnagraficaConsolato
     , decode(cta.sigla,
         'ADO', t97.descrizione) MIT_nomeAnagraficaConsolato
     , decode(cta.sigla,
         'ADO', to_char(dpa.d_data_nota_rif, 'yyyy-mm-dd')) MIT_dataTrascrizione
     , decode(cta.sigla,
         'ADO', to_char(null)) MIT_descrizione
     , decode(cta.sigla,
         'ADO', dpa.nota_rif||decode(dpa.anno_nota_rif,'','','/'||dpa.anno_nota_rif)) MIT_estremiDocumento
-- composizioneCompleta
     , tli.riga_clob composizioneCompleta
-- datiAssenso.tipoAssenso
     , decode(cta.sigla,'RIC', decode(nas.tipo_riconoscimento,'MD','1','PD','2','PDMD','3')) PRE_tipoAssenso
-- riconoscimento
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', 'true', 'false'),
         decode(nas.tipo_riconoscimento, '', 'false', 'true')) PRE_avvenuto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', dpa.riconoscim_pre_id_atto_ansc_1),
         decode(nas.tipo_riconoscimento, '', to_char(null), dpa.riconoscim_pre_id_atto_ansc_1)) PRE_idAttoAnsc
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', '1'),
         decode(nas.tipo_riconoscimento, '', to_char(null), '1')) PRE_idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', '1'),
         decode(nas.tipo_riconoscimento, '', to_char(null), '1')) PRE_tipologia
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_anno_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'ANNO') )),
         decode(nas.tipo_riconoscimento, '', to_number(null), decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_anno_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'ANNO') ))) PRE_annoAtto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_atto_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'NUMERO_COMUNALE') )),
         decode(nas.tipo_riconoscimento, '', to_number(null), decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_atto_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'NUMERO_COMUNALE') ))) PRE_numeroAtto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_parte_1)),
         decode(nas.tipo_riconoscimento, '', to_number(null), decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_parte_1))) PRE_parte
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_serie_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_serie_1))) PRE_serie
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', dpa.riconoscimento_pre_ufficio_1),
         decode(nas.tipo_riconoscimento, '', to_number(null), dpa.riconoscimento_pre_ufficio_1)) PRE_ufficio
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_idComuneReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_idProvinciaReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_nomeComuneReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_siglaProvinciaReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PDMD', to_char(dpa.d_riconoscimento_pre_data_1,'yyyy-mm-dd')),
         decode(nas.tipo_riconoscimento, '', to_char(null), to_char(dpa.d_riconoscimento_pre_data_1,'yyyy-mm-dd'))) PRE_dataFormazione
  -- certificato
     , decode(cta.sigla, 'RPN', dpa.autorita_atto_orig) PRE_autorita
     , decode(cta.sigla, 'RPN', to_char(dpa.d_data_atto_orig,'yyyy-mm-dd')) PRE_data
-- riconoscimento madre
     , decode(cta.sigla, 'RIC', 'true',
         decode(nas.tipo_riconoscimento, '', 'false', 'true')) PRE_MAT_avvenuto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', dpa.riconoscim_pre_id_atto_ansc_1),
         decode(nas.tipo_riconoscimento, '', to_char(null), dpa.riconoscim_pre_id_atto_ansc_1)) PRE_MAT_idAttoAnsc
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', '1'),
         decode(nas.tipo_riconoscimento, '', to_char(null), '1')) PRE_MAT_idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', '1'),
         decode(nas.tipo_riconoscimento, '', to_char(null), '1')) PRE_MAT_tipologia
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_anno_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'ANNO') )),
         decode(nas.tipo_riconoscimento, '', to_number(null), decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_anno_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'ANNO') ))) PRE_MAT_annoAtto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_atto_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'NUMERO_COMUNALE') )),
         decode(nas.tipo_riconoscimento, '', to_number(null), decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_atto_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'NUMERO_COMUNALE') ))) PRE_MAT_numeroAtto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_parte_1)),
         decode(nas.tipo_riconoscimento, '', to_number(null), decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_parte_1))) PRE_MAT_parte
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_serie_1, '') ),
         decode(nas.tipo_riconoscimento, '', to_char(null), decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_serie_1))) PRE_MAT_serie
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', dpa.riconoscimento_pre_ufficio_1),
         decode(nas.tipo_riconoscimento, '', to_number(null), dpa.riconoscimento_pre_ufficio_1)) PRE_MAT_ufficio
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_MAT_idComuneReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_MAT_idProvinciaReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_MAT_nomeComuneReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, '', to_char(null), f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_MAT_siglaProvinciaReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'MD', to_char(dpa.d_riconoscimento_pre_data_1,'yyyy-mm-dd')),
         decode(nas.tipo_riconoscimento, '', to_char(null), to_char(dpa.d_riconoscimento_pre_data_1,'yyyy-mm-dd'))) PRE_MAT_dataFormazione
-- riconoscimento padre
     , decode(cta.sigla, 'RIC', 'true',
         decode(nas.tipo_riconoscimento, 'PDMD', 'true', 'PD', 'true', 'false')) PRE_PAT_avvenuto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   dpa.riconoscim_pre_id_atto_ansc_1),
         decode(nas.tipo_riconoscimento, 'PDMD', dpa.riconoscim_pre_id_atto_ansc_2,
                                         'PD',   dpa.riconoscim_pre_id_atto_ansc_1)) PRE_PAT_idAttoAnsc
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD', '1'),
         decode(nas.tipo_riconoscimento, 'PDMD', '1', 'PD', '1')) PRE_PAT_idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD', '1'),
         decode(nas.tipo_riconoscimento, 'PDMD', '1', 'PD', '1')) PRE_PAT_tipologia
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_anno_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'ANNO'))),
         decode(nas.tipo_riconoscimento, 'PDMD', decode(dpa.riconoscim_pre_id_atto_ansc_2, '', dpa.riconoscimento_pre_anno_2, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_2,'ANNO')),
                                         'PD',   decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_anno_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'ANNO')))) PRE_PAT_annoAtto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_atto_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'NUMERO_COMUNALE'))),
         decode(nas.tipo_riconoscimento, 'PDMD', decode(dpa.riconoscim_pre_id_atto_ansc_2, '', dpa.riconoscimento_pre_atto_2, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_2,'NUMERO_COMUNALE')),
                                         'PD',   decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_atto_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'NUMERO_COMUNALE')))) PRE_PAT_numeroAtto
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_parte_1)),
         decode(nas.tipo_riconoscimento, 'PDMD', decode(dpa.riconoscim_pre_id_atto_ansc_2, '', dpa.riconoscimento_pre_parte_2),
                                         'PD',   decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_parte_1))) PRE_PAT_parte
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_serie_1)),
         decode(nas.tipo_riconoscimento, 'PDMD', decode(dpa.riconoscim_pre_id_atto_ansc_2, '', dpa.riconoscimento_pre_serie_2),
                                         'PD',   decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_serie_1))) PRE_PAT_serie
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   dpa.riconoscimento_pre_ufficio_1),
         decode(nas.tipo_riconoscimento, 'PDMD', dpa.riconoscimento_pre_ufficio_2,
                                         'PD',   dpa.riconoscimento_pre_ufficio_1)) PRE_PAT_ufficio
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, 'PDMD', f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2, dpa.d_riconoscimento_pre_data_2),
                                         'PD',   f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_PAT_idComuneReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, 'PDMD', f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2, dpa.d_riconoscimento_pre_data_2),
                                         'PD',   f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_PAT_idProvinciaReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, 'PDMD', f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2, dpa.d_riconoscimento_pre_data_2),
                                         'PD',   f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_PAT_nomeComuneReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1)),
         decode(nas.tipo_riconoscimento, 'PDMD', f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2, dpa.d_riconoscimento_pre_data_2),
                                         'PD',   f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, dpa.d_riconoscimento_pre_data_1))) PRE_PAT_siglaProvinciaReg
     , decode(cta.sigla,'RIC',
         decode(nas.tipo_riconoscimento, 'PD',   to_char(dpa.d_riconoscimento_pre_data_1,'yyyy-mm-dd')),
         decode(nas.tipo_riconoscimento, 'PDMD', to_char(dpa.d_riconoscimento_pre_data_2,'yyyy-mm-dd'),
                                         'PD',   to_char(dpa.d_riconoscimento_pre_data_1,'yyyy-mm-dd'))) PRE_PAT_dataFormazione
-- consensoMadre.tipoConsenso
     , f_ANSC_tipo_consenso(nvl(nas.tipo_consenso_riconoscimento,'EV')) tipoConsenso
     , decode(nas.parte||nas.serie,'1B',f_ANSC_tipo_mancato_consenso(nas.tipo_mancato_consenso)) tipoMancatoConsenso
     , nas.concepito_da_mesi mesiDalConcepimento
-- consensoMadre.atto
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_idAttoAnsc
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_tipologia
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_annoAtto
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_numeroAtto
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_parte
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_serie
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_ufficio
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_idComuneReg
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_idProvinciaReg
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_nomeComuneReg
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_siglaProvinciaReg
     , decode(cta.sigla, 'RIC', to_char(null)) CON_MAT_dataFormazione
-- consensoPadre.tipoConsenso
     , f_ANSC_tipo_consenso(nvl(nas.tipo_consenso_riconoscimento,'EV')) PAT_tipoConsenso
-- consensoPadre.atto
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_idAttoAnsc
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_tipologia
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_annoAtto
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_numeroAtto
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_parte
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_serie
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_ufficio
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_idComuneReg
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_idProvinciaReg
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_nomeComuneReg
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_siglaProvinciaReg
     , decode(cta.sigla, 'RIC', to_char(null)) CON_PAT_dataFormazione
-- ANSC
     , nas.id_atto_ansc idAttoAnsc
     , nas.id_evento_ansc idEventoAnsc
     , nas.id_soggetto_ansc INT_idSoggettoAnsc
     , to_number(null) PAT_idSoggettoAnsc
     , to_number(null) MAT_idSoggettoAnsc
     , f_ANSC_id_soggetto_anpr('',nas.cod_fiscale) INT_idSoggettoAnpr
     , f_ANSC_id_unico_anpr('',nas.cod_fiscale) INT_idUnicoAnpr
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_1,ana_r.matricola_1),'') PAT_idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_1,ana_r.matricola_1),'') PAT_idUnicoAnpr
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_2,ana_r.matricola_2),'') MAT_idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_2,ana_r.matricola_2),'') MAT_idUnicoAnpr
     , to_char(null) forcingCode
  from arccom_v m
     , civana ana
     , civana_recupero ana_r
     , civsog sog_IT
     , civsog sog_OS
     , civsog sog_PP
     , civsog sog_PM
     , anst03 t03
     , anst97 t97
     , anadci dci_it
     , anadci dci_os
     , anadci dci_pp
     , anadci dci_pm
     , anadci dci_dic
     , anadci dci_pd
     , anadci dci_md
     , anadci dci
     , civtli_v tli
     , civmar mar
     , civdpa dpa
     , civocc occ
     , civcta cta
     , civdta dta
     , civnas nas
 where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and ana.id_atto           (+) = nas.id_atto
   and ana_r.id_atto         (+) = nas.id_atto
   and t03.id                (+) = nas.id_usecase_ansc
   and t97.id                (+) = dpa.id_consolato_ansc_prov
   and sog_IT.id_atto        (+) = nas.id_atto
   and sog_IT.tipo_soggetto  (+) = 'IT'
   and sog_OS.id_atto        (+) = nas.id_atto
   and sog_OS.tipo_soggetto  (+) = 'OS'
   and sog_PP.id_atto        (+) = nas.id_atto
   and sog_PP.tipo_soggetto  (+) = 'PP'
   and sog_PM.id_atto        (+) = nas.id_atto
   and sog_PM.tipo_soggetto  (+) = 'PM'
   and dci_it.cod_ci         (+) = sog_IT.nazionalita
   and dci_os.cod_ci         (+) = sog_OS.nazionalita
   and dci_pp.cod_ci         (+) = sog_PP.nazionalita
   and dci_pm.cod_ci         (+) = sog_PM.nazionalita
   and dci_dic.cod_ci        (+) = dpa.nazionalita_dic
   and dci_pd.cod_ci         (+) = nas.nazionalita_pd
   and dci_md.cod_ci         (+) = nas.nazionalita_md
   and dci.cod_ci            (+) = nas.nazionalita
   and tli.id_atto           (+) = nas.id_atto
   and mar.id_atto           (+) = nas.id_atto
   and occ.id_atto           (+) = nas.id_atto
   and dpa.id_atto           (+) = nas.id_atto
   and cta.id                    = dta.id_civcta
   and dta.id                    = nas.id_civdta
   and nas.cod_rec               in (0,3)
/
comment on table CIVNAS_V_JSON is 'ANSC - Atti di Nascita per request JSON (view)'
/