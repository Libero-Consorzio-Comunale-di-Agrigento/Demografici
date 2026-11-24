--liquibase formatted sql
--changeset amonopoli:202305181240_3 runAlways:true runOnChange:true stripComments:false
create or replace view civmor_v_json as
select mor.id
     , mor.id_atto
     , mor.ufficio
     , mor.anno
     , mor.parte
     , mor.serie
     , mor.atto
-- evento
     , f_ANSC_valore_inp('ID_VERSION',1,10,'9','') idVersion
     , '2' idTipoEvento		-- (anst01) 1 - NASCITA / 2 - MORTE / 3 - MATRIMONIO / 4 - UNIONE CIVILE / 5 - CITTADINANZA
     , f_ANSC_id_tipo_contenuto(t03.tipo_atto_ansc,mor.natura,to_char(null)) idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , mor.id_usecase_ansc idUseCase		-- (anst03)
     , t03.descrizione  descrizioneCasoUso	-- (anst03)
     , decode(f_ANSC_flag_firmato('MOR', mor.id, 'USC'), 'S', 'FIRMATO DA USC', 'CONFERMATO') stato   -- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , 'FIRMATO DA USC' stato_firmatoUSC   -- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') dataFormazione
     , to_char(dpa.d_data_atto_utente,'yyyy') annoAtto
     , to_char(dpa.d_data_atto_utente,'mm') meseAtto
     , to_char(dpa.d_data_atto_utente,'dd') giornoAtto
     , lpad(dpa.ore_atto_utente, 2, '0') ora
     , lpad(dpa.minuti_atto_utente, 2, '0') minuto
     , to_char(f_ANSC_data_validita(5,cta.sigla,mor.natura,mor.d_data_mor,dpa.d_data_atto_utente),'yyyy-mm-dd') dataValidita
     , mor.numero_unico numeroatto
     , f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,'') idComuneRegistrazione
     , f_ANSC_comune_al(m.cod_provincia,m.cod_comune,'') nomeComuneRegistrazione
     , f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,'') idProvinciaRegistrazione
     , f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,'') siglaProvinciaRegistrazione
     , f_ANSC_id_operatore(mor.terminalista) operatore
     , f_ANSC_ruolo_operatore(dpa.qualifica_utente) ruoloOperatore
     , f_ANSC_nome_operatore(mor.terminalista) operatoreNome
     , f_ANSC_cognome_operatore(mor.terminalista) operatoreCognome
     , 'true' redattoNellaCasaComunale
     , f_ANSC_ausilio_interprete(dpa.tipo_comparente) ausilioInterprete
     , f_ANSC_motivo_recupero(mor.motivo_recupero_ansc) motivoRecupero            -- (anst96)
     , decode(mor.motivo_recupero_ansc,'','',to_char(dpa.d_data_atto_utente,'yyyy-mm-dd')) dataDecorrenza
     , decode(mor.natura, 'D', 'false', 'true') flagCertificatoSemplice
     , decode(mor.natura, 'D', 'false', 'true') flagEstrattoPerRiassunto
-- datiDichiarante
     , f_ANSC_comprensione(dpa.comprensione_dic) comprensione
     , dpa.motivo_impedimento_dic motivoImpedimentoScrittura
-- datiEventoMorte
     , f_ANSC_tipo_trasmissione(dpa.tipo_atto, dpa.id_atto, '') tipoTrasmissione
     , f_ANSC_des_trasmissione(dpa.tipo_atto, dpa.id_atto, '') descrizioneTrasmissione
     , to_char(dpa.d_data_documento_tes,'yyyy-mm-dd') dataTrasmissione
-- intestatari
     , mor.cod_fiscale INT_codiceFiscale
     , f_ANSC_stringa_unicode('CIVMOR',mor.id,'COGNOME_1',nvl(occ.cognome,mor.cognome)) INT_cognome
     , f_ANSC_stringa_unicode('CIVMOR',mor.id,'NOME_1',nvl(occ.nome,mor.nome)) INT_nome
     , mor.sesso INT_sesso
     , decode(mor.sesso,'M','maschile','F','femminile','non conosciuto') INT_descrizioneSesso
     , to_char(mor.d_data_nas,'yyyy-mm-dd') INT_dataNascita
     , f_ANSC_id_comune_al(mor.cod_pro_nas,mor.cod_com_nas,mor.d_data_nas) INT_idComuneNascita
     , f_ANSC_comune_italiano(mor.cod_pro_nas,mor.cod_com_nas,mor.d_data_nas) INT_nomeComuneNascita
     , f_ANSC_id_provincia_al(mor.cod_pro_nas,mor.cod_com_nas,mor.d_data_nas) INT_idProvinciaNascita
     , f_ANSC_provincia_al(mor.cod_pro_nas,mor.cod_com_nas,mor.d_data_nas) INT_siglaProvinciaNascita
     , f_ANSC_id_stato_al(mor.cod_pro_nas,mor.cod_com_nas,mor.d_data_nas) INT_idStatoNascita
     , f_ANSC_stato_al(mor.cod_pro_nas,mor.cod_com_nas,mor.d_data_nas) INT_nomeStatoNascita
     , f_ANSC_comune_estero(mor.cod_pro_nas,mor.cod_com_nas,mor.d_data_nas) INT_comuneEsteroNascita
     , f_ANSC_id_comune_al(mor.cod_pro_res,mor.cod_com_res,mor.d_data_mor) INT_idComuneResidenza
     , f_ANSC_comune_italiano(mor.cod_pro_res,mor.cod_com_res,mor.d_data_mor) INT_nomeComuneResidenza
     , f_ANSC_id_provincia_al(mor.cod_pro_res,mor.cod_com_res,mor.d_data_mor) INT_idProvinciaResidenza
     , f_ANSC_provincia_al(mor.cod_pro_res,mor.cod_com_res,mor.d_data_mor) INT_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(mor.cod_pro_res,mor.cod_com_res,mor.d_data_mor) INT_idStatoResidenza
     , f_ANSC_stato_al(mor.cod_pro_res,mor.cod_com_res,mor.d_data_mor) INT_nomeStatoResidenza
     , f_ANSC_comune_estero(mor.cod_pro_res,mor.cod_com_res,mor.d_data_mor) INT_comuneEsteroResidenza
     , to_char(null) INT_indirizzoResidenza
     , f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),mor.cod_pro_res,mor.cod_com_res) INT_idComuneAIRE
     , f_ANSC_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),mor.cod_pro_res,mor.cod_com_res) INT_nomeComuneAIRE
     , f_ANSC_id_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),mor.cod_pro_res,mor.cod_com_res) INT_idProvinciaAIRE
     , f_ANSC_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),mor.cod_pro_res,mor.cod_com_res) INT_siglaProvinciaAIRE
--
     , dsc.codice_anpr INT_idstatocivile
     , f_ANSC_des_stato_civile(dsc.codice_anpr) INT_descrizioneStatoCivile
     , decode(mor.sesso,'M','o','F','a') INT_genere
     , f_ANSC_id_nazionalita(dci.ist_ci) INT_idNazionalita
     , f_get_descrizione_DCI(mor.nazionalita,'') INT_nazionalita
     , mor.note note
-- datiEventoMorte.attoNascitaDeceduto
     , mar.id_atto_ansc_nas INT_NAS_idAttoAnsc
     , decode(mar.id_atto_ansc_nas,'', decode(mar.atto_nas,'', to_char(null), '1')) INT_NAS_idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(mar.id_atto_ansc_nas,'', decode(mar.atto_nas,'', to_char(null), '1')) INT_NAS_tipologia
     , decode(mar.id_atto_ansc_nas, '', mar.anno_nas, f_CIV_get_estremi_id_atto_ansc(mar.id_atto_ansc_nas,'ANNO')) INT_NAS_annoAtto
     , decode(mar.id_atto_ansc_nas, '', mar.atto_nas, f_CIV_get_estremi_id_atto_ansc(mar.id_atto_ansc_nas,'NUMERO_COMUNALE')) INT_NAS_numeroAtto
     , decode(mar.id_atto_ansc_nas, '', mar.parte_nas) INT_NAS_parte
     , decode(mar.id_atto_ansc_nas, '', mar.serie_nas) INT_NAS_serie
     , decode(mar.id_atto_ansc_nas, '', mar.ufficio_nas) INT_NAS_ufficio
     , f_ANSC_id_comune_al(mar.cod_pro_atto_nas, mar.cod_com_atto_nas, mor.d_data_nas) INT_NAS_idComuneReg
     , f_ANSC_id_provincia_al(mar.cod_pro_atto_nas, mar.cod_com_atto_nas, mor.d_data_nas) INT_NAS_idProvinciaReg 
     , f_ANSC_comune_al(mar.cod_pro_atto_nas, mar.cod_com_atto_nas, mor.d_data_nas) INT_NAS_nomeComuneReg 
     , f_ANSC_provincia_al(mar.cod_pro_atto_nas, mar.cod_com_atto_nas, mor.d_data_nas) INT_NAS_siglaProvinciaReg
     , to_char(mar.d_data_atto_nas,'yyyy-mm-dd') INT_NAS_dataFormazione
--
-- comparente1
     , '1' numeroComparenti
     , dpa.cognome_dic CO1_cognome
     , dpa.nome_dic CO1_nome
     , dpa.sesso_dic CO1_sesso
     , to_char(dpa.d_data_nas_dic,'yyyy-mm-dd') CO1_dataNascita
     , f_ANSC_id_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) CO1_idComuneNascita
     , f_ANSC_comune_italiano(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) CO1_nomeComuneNascita
     , f_ANSC_id_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) CO1_idProvinciaNascita
     , f_ANSC_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) CO1_siglaProvinciaNascita
     , f_ANSC_id_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) CO1_idStatoNascita
     , f_ANSC_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) CO1_nomeStatoNascita
     , f_ANSC_comune_estero(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) CO1_comuneEsteroNascita
     , f_ANSC_id_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor) CO1_idComuneResidenza
     , f_ANSC_comune_italiano(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor) CO1_nomeComuneResidenza
     , f_ANSC_id_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor) CO1_idProvinciaResidenza
     , f_ANSC_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor) CO1_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor) CO1_idStatoResidenza
     , f_ANSC_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor) CO1_nomeStatoResidenza
     , f_ANSC_comune_estero(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor) CO1_comuneEsteroResidenza
     , f_ANSC_id_nazionalita(dci_c1.ist_ci) CO1_idNazionalita
     , f_get_descrizione_DCI(dpa.nazionalita_dic,'') CO1_nazionalita
     , decode(instr(dpa.tipo_comparente,'C1'),1, f_ANSC_comprensione(dpa.comprensione_dic)) CO1_tipoImpedimento
     , decode(cta.sigla, 'TEP', '', f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'C1')) CO1_flagDichiarante
   --  , decode(cta.sigla, 'TEP', '', f_ANSC_flag_comparente(dpa.tipo_comparente,'C1')) CO1_flagComparente
     , decode(cta.sigla,
         'TEP', 'false',
         'T2A', 'false', -- nelle T2A non ci sono comparenti
               f_ANSC_flag_firmatario(dpa.tipo_comparente,'C1')
       ) CO1_flagComparente
   --  , decode(cta.sigla, 'TEP', '', f_ANSC_flag_firmatario(dpa.tipo_firmatario,'C1')) CO1_flagFirmatario
     , decode(cta.sigla,
         'TEP', 'false',
         'T2A', 'false', -- nelle T2A non ci sono firmatari
               f_ANSC_flag_firmatario(dpa.tipo_firmatario,'C1')
       ) CO1_flagFirmatario
-- dichiarante
     , decode(cta.sigla, 'TEP', dpa.cognome_dic) DIC_cognome
     , decode(cta.sigla, 'TEP', dpa.nome_dic) DIC_nome
     , decode(cta.sigla, 'TEP', dpa.sesso_dic) DIC_sesso
     , decode(cta.sigla, 'TEP', to_char(dpa.d_data_nas_dic,'yyyy-mm-dd')) DIC_dataNascita
     , decode(cta.sigla, 'TEP', f_ANSC_id_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_idComuneNascita
     , decode(cta.sigla, 'TEP', f_ANSC_comune_italiano(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_nomeComuneNascita
     , decode(cta.sigla, 'TEP', f_ANSC_id_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_idProvinciaNascita
     , decode(cta.sigla, 'TEP', f_ANSC_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_siglaProvinciaNascita
     , decode(cta.sigla, 'TEP', f_ANSC_id_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_idStatoNascita
     , decode(cta.sigla, 'TEP', f_ANSC_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_nomeStatoNascita
     , decode(cta.sigla, 'TEP', f_ANSC_comune_estero(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) DIC_comuneEsteroNascita
     , decode(cta.sigla, 'TEP', f_ANSC_id_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor)) DIC_idComuneResidenza
     , decode(cta.sigla, 'TEP', f_ANSC_comune_italiano(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor)) DIC_nomeComuneResidenza
     , decode(cta.sigla, 'TEP', f_ANSC_id_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor)) DIC_idProvinciaResidenza
     , decode(cta.sigla, 'TEP', f_ANSC_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor)) DIC_siglaProvinciaResidenza
     , decode(cta.sigla, 'TEP', f_ANSC_id_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor)) DIC_idStatoResidenza
     , decode(cta.sigla, 'TEP', f_ANSC_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor)) DIC_nomeStatoResidenza
     , decode(cta.sigla, 'TEP', f_ANSC_comune_estero(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.d_data_mor)) DIC_comuneEsteroResidenza
     , decode(cta.sigla, 'TEP', f_ANSC_id_nazionalita(dci_c1.ist_ci)) DIC_idNazionalita
     , decode(cta.sigla, 'TEP', f_get_descrizione_DCI(dpa.nazionalita_dic,'')) DIC_nazionalita
     , decode(cta.sigla, 'TEP', decode(instr(dpa.tipo_comparente,'C1'),1, f_ANSC_comprensione(dpa.comprensione_dic))) DIC_tipoImpedimento
     , decode(cta.sigla, 'TEP', 'false') DIC_flagDichiarante
     , decode(cta.sigla, 'TEP', 'false') DIC_flagComparente
     , decode(cta.sigla, 'TEP', 'false') DIC_flagFirmatario
-- datiDiMorte
     , to_char(mor.d_data_mor,'yyyy-mm-dd') dataMorte
     , decode(mor.des_evento_mor,'', decode(mor.parte,1,dpa.luogo_mor_1)) luogoMorte
     , f_ANSC_id_comune_al(mor.cod_pro_mor,mor.cod_com_mor,mor.d_data_mor) idComuneMorte
     , f_ANSC_comune_italiano(mor.cod_pro_mor,mor.cod_com_mor,mor.d_data_mor) nomeComuneMorte
     , f_ANSC_id_provincia_al(mor.cod_pro_mor,mor.cod_com_mor,mor.d_data_mor) idProvinciaMorte
     , f_ANSC_provincia_al(mor.cod_pro_mor,mor.cod_com_mor,mor.d_data_mor) siglaProvinciaMorte
     , f_ANSC_id_stato_al(mor.cod_pro_mor,mor.cod_com_mor,mor.d_data_mor) idStatoMorte
     , f_ANSC_stato_al(mor.cod_pro_mor,mor.cod_com_mor,mor.d_data_mor) nomeStatoMorte
     , f_ANSC_comune_estero(mor.cod_pro_mor,mor.cod_com_mor,mor.d_data_mor) comuneEsteroMorte
     , to_char(null) indirizzoMorte
     , to_char(mor.d_data_mor,'yyyy') annoMorte
     , to_char(mor.d_data_mor,'mm') meseMorte
     , to_char(mor.d_data_mor,'dd') giornoMorte
     , lpad(mor.ore,2,'0') oraMorte
     , lpad(mor.minuti,2,'0') minutoMorte
     , mor.des_evento_mor ritrovamento
     , rtrim(mor.des_data_mor||' '||mor.des_ore_minuti_mor) testoDataPresuntaMorte
     , to_char(null) dataPresuntaMorteDa
     , to_char(null) dataPresuntaMorteA
     , to_char(null) oraPresuntaMorteDa
     , to_char(null) oraPresuntaMorteA
-- coniuge
     , f_ANSC_stringa_unicode('CIVMOR',mor.id,'COGNOME_CN',mor.cognome_cn) CON_cognome
     , f_ANSC_stringa_unicode('CIVMOR',mor.id,'NOME_CN',mor.nome_cn) CON_nome
     , mor.sesso_cn CON_sesso
     , to_char(mor.d_data_nas_cn,'yyyy-mm-dd') CON_dataNascita
     , f_ANSC_id_comune_al(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,mor.d_data_nas_cn) CON_idComuneNascita
     , f_ANSC_comune_italiano(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,mor.d_data_nas_cn) CON_nomeComuneNascita
     , f_ANSC_id_provincia_al(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,mor.d_data_nas_cn) CON_idProvinciaNascita
     , f_ANSC_provincia_al(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,mor.d_data_nas_cn) CON_siglaProvinciaNascita
     , f_ANSC_id_stato_al(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,mor.d_data_nas_cn) CON_idStatoNascita
     , f_ANSC_stato_al(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,mor.d_data_nas_cn) CON_nomeStatoNascita
     , f_ANSC_comune_estero(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,mor.d_data_nas_cn) CON_comuneEsteroNascita
     , f_ANSC_id_comune_al(mor.cod_pro_res_cn,mor.cod_com_res_cn,mor.d_data_mor) CON_idComuneResidenza
     , f_ANSC_comune_italiano(mor.cod_pro_res_cn,mor.cod_com_res_cn,mor.d_data_mor) CON_nomeComuneResidenza
     , f_ANSC_id_provincia_al(mor.cod_pro_res_cn,mor.cod_com_res_cn,mor.d_data_mor) CON_idProvinciaResidenza
     , f_ANSC_provincia_al(mor.cod_pro_res_cn,mor.cod_com_res_cn,mor.d_data_mor) CON_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(mor.cod_pro_res_cn,mor.cod_com_res_cn,mor.d_data_mor) CON_idStatoResidenza
     , f_ANSC_stato_al(mor.cod_pro_res_cn,mor.cod_com_res_cn,mor.d_data_mor) CON_nomeStatoResidenza
     , f_ANSC_comune_estero(mor.cod_pro_res_cn,mor.cod_com_res_cn,mor.d_data_mor) CON_comuneEsteroResidenza
     , f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),mor.cod_pro_res_cn,mor.cod_com_res_cn) CON_idComuneAIRE
     , f_ANSC_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),mor.cod_pro_res_cn,mor.cod_com_res_cn) CON_nomeComuneAIRE
     , f_ANSC_id_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),mor.cod_pro_res_cn,mor.cod_com_res_cn) CON_idProvinciaAIRE
     , f_ANSC_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),mor.cod_pro_res_cn,mor.cod_com_res_cn) CON_siglaProvinciaAIRE
--
     , f_ANSC_id_nazionalita(dci_cn.ist_ci) CON_idNazionalita
     , f_get_descrizione_DCI(mor.nazionalita_cn,'') CON_nazionalita
-- madre
     , f_ANSC_stringa_unicode('CIVMOR',mor.id,'COGNOME_MD',mor.cognome_md) MAT_cognome
     , f_ANSC_stringa_unicode('CIVMOR',mor.id,'NOME_MD',mor.nome_md) MAT_nome
-- padre
     , f_ANSC_stringa_unicode('CIVMOR',mor.id,'COGNOME_PD',mor.cognome_pd) PAT_cognome
     , f_ANSC_stringa_unicode('CIVMOR',mor.id,'NOME_PD',mor.nome_pd) PAT_nome
-- inteprete
     , sog_ITP.cognome ITP_cognome
     , sog_ITP.nome ITP_nome
     , sog_ITP.sesso ITP_sesso
     , decode(sog_ITP.sesso,'M','maschile','F','femminile') ITP_descrizioneSesso
     , to_char(sog_ITP.d_data_nas,'yyyy-mm-dd') ITP_dataNascita
     , f_ANSC_id_comune_al(sog_ITP.cod_pro_nas,sog_ITP.cod_com_nas,sog_ITP.d_data_nas) ITP_idComuneNascita
     , f_ANSC_comune_italiano(sog_ITP.cod_pro_nas,sog_ITP.cod_com_nas,sog_ITP.d_data_nas) ITP_nomeComuneNascita
     , f_ANSC_id_provincia_al(sog_ITP.cod_pro_nas,sog_ITP.cod_com_nas,sog_ITP.d_data_nas) ITP_idProvinciaNascita
     , f_ANSC_provincia_al(sog_ITP.cod_pro_nas,sog_ITP.cod_com_nas,sog_ITP.d_data_nas) ITP_siglaProvinciaNascita
     , f_ANSC_id_stato_al(sog_ITP.cod_pro_nas,sog_ITP.cod_com_nas,sog_ITP.d_data_nas) ITP_idStatoNascita
     , f_ANSC_stato_al(sog_ITP.cod_pro_nas,sog_ITP.cod_com_nas,sog_ITP.d_data_nas) ITP_nomeStatoNascita
     , f_ANSC_comune_estero(sog_ITP.cod_pro_nas,sog_ITP.cod_com_nas,sog_ITP.d_data_nas) ITP_comuneEsteroNascita
     , f_ANSC_id_comune_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mor.d_data_mor) ITP_idComuneResidenza
     , f_ANSC_comune_italiano(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mor.d_data_mor) ITP_nomeComuneResidenza
     , f_ANSC_id_provincia_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mor.d_data_mor) ITP_idProvinciaResidenza
     , f_ANSC_provincia_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mor.d_data_mor) ITP_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mor.d_data_mor) ITP_idStatoResidenza
     , f_ANSC_stato_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mor.d_data_mor) ITP_nomeStatoResidenza
     , f_ANSC_comune_estero(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mor.d_data_mor) ITP_comuneEsteroResidenza
     , decode(sog_ITP.sesso,'M','o','F','a') ITP_genere
     , f_ANSC_id_nazionalita(dci_it.ist_ci) ITP_idNazionalita
     , f_get_descrizione_dci(sog_ITP.nazionalita,'') ITP_nazionalita
  -- flagDichiarante
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'IT') ITP_flagDichiarante
  -- flagComparente
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'IT') ITP_flagComparente
  -- flagFirmatario
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'IT') ITP_flagFirmatario
-- trascrizione morte
     , f_ANSC_tipo_dichiarazione(5, cta.sigla, mor.id_usecase_ansc, dpa.tipo_richiesta_trascrizione) TRA_tipoRichiestaTrascrizione	-- ANST38
     , decode(cta.sigla, 'TEA', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd'),
                                to_char(dpa.d_data_atto_utente,'yyyy-mm-dd')) TRA_dataTrascrizione
     , decode(dpa.nota_rif||dpa.anno_nota_rif,'',to_char(null),dpa.nota_rif||'/'||dpa.anno_nota_rif) TRA_estremiDocumento
     , to_char(dpa.autorita_prov) TRA_nomeEnte
     , f_ANSC_id_comune_al(mor.cod_pro_mor,mor.cod_com_mor,'') TRA_idComuneEnte
     , f_ANSC_comune_italiano(mor.cod_pro_mor,mor.cod_com_mor,'') TRA_nomeComuneEnte
     , f_ANSC_id_provincia_al(mor.cod_pro_mor,mor.cod_com_mor,'') TRA_idProvinciaEnte
     , f_ANSC_provincia_al(mor.cod_pro_mor,mor.cod_com_mor,'') TRA_siglaProvinciaEnte
     , f_ANSC_id_stato_al(mor.cod_pro_mor,mor.cod_com_mor,'') TRA_nazioneEnte
     , f_ANSC_stato_al(mor.cod_pro_mor,mor.cod_com_mor,'') TRA_nomeNazioneEnte
     , f_ANSC_comune_estero(mor.cod_pro_mor,mor.cod_com_mor,'') TRA_comuneEsteroEnte
     , decode(cta.sigla, 'TEP', to_char(dpa.d_data_richiesta_trascrizione,'yyyy-mm-dd')
                       , 'TEA', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd')
                              , to_char(nvl(dpa.d_data_nota_rif,dpa.d_ente_straniero_data_atto),'yyyy-mm-dd') ) TRA_dataComunicazione
     , 'Come da trascrizione contenuta nel corpo dell''atto' TRA_testoLibero
--     , f_ANSC_id_consolato(dpa.cod_pro_prov,dpa.cod_com_prov,dpa.comune_prov) TRA_idAnagraficaConsolato
--     , f_ANSC_consolato(dpa.cod_pro_prov,dpa.cod_com_prov,dpa.comune_prov) TRA_nomeAnagraficaConsolato
     , dpa.id_consolato_ansc_prov TRA_idAnagraficaConsolato
     , t97.descrizione TRA_nomeAnagraficaConsolato
-- Ente Estero
     , dpa.ente_straniero EST_nomeEnte
     , f_ANSC_id_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idComuneEnte
     , f_ANSC_comune_italiano(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nomeComuneEnte
     , f_ANSC_id_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_siglaProvinciaEnte
     , f_ANSC_id_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nazioneEnte
     , f_ANSC_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nomeNazioneEnte
     , f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_comuneEsteroEnte
     , to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd') EST_dataComunicazione
     , case when cta.sigla in ('TEP', 'TEA') then to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd') else to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') end EST_dataTrascrizione
     , dpa.ente_straniero_tipo_atto EST_descrizione
     , dpa.ente_straniero_estremi_atto EST_estremiDocumento
--     , f_ANSC_id_consolato(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idAnagraficaConsolato
--     , f_ANSC_consolato(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nomeAnagraficaConsolato
     , to_char(null) EST_idAnagraficaConsolato
     , to_char(null) EST_nomeAnagraficaConsolato
-- Autorità mittente
     , to_char(null) MIT_ruoloEnteDichiarante
     , to_char(null) MIT_nomeEnte
-- dati della trascrizione
  , to_char(null) dataRichiestaTrascrizione
  , to_char(null) riassunto
-- composizioneCompleta
     , tli.riga_clob composizioneCompleta
-- ANSC
     , mor.id_atto_ansc idAttoAnsc
     , mor.id_evento_ansc idEventoAnsc
     , mor.id_soggetto_ansc INT_idSoggettoAnsc
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_1,ana_r.matricola_1),mor.cod_fiscale) INT_idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_1,ana_r.matricola_1),mor.cod_fiscale) INT_idUnicoAnpr
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_2,ana_r.matricola_2),'') CON_idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_2,ana_r.matricola_2),'') CON_idUnicoAnpr
     , to_char(null) forcingCode
  from arccom m
     , civana ana
     , civana_recupero ana_r
     , anadci dci
     , anadci dci_cn
     , anadci dci_c1
     , anadci dci_it
     , anadsc dsc
     , anst03 t03
     , anst97 t97
     , civtli_v tli
     , civsog sog_ITP
     , civmar mar
     , civdpa dpa
     , civocc occ
     , civcta cta
     , civdta dta
     , civmor mor
 where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and ana.id_atto           (+) = mor.id_atto
   and ana_r.id_atto         (+) = mor.id_atto
   and dci.cod_ci            (+) = mor.nazionalita
   and dci_cn.cod_ci         (+) = mor.nazionalita_cn
   and dci_c1.cod_ci         (+) = dpa.nazionalita_dic
   and dci_it.cod_ci         (+) = sog_ITP.nazionalita
   and dsc.sesso             (+) = mor.sesso
   and dsc.cod_sc            (+) = mor.stato_civile
   and t03.id                (+) = mor.id_usecase_ansc
   and t97.id                (+) = dpa.id_consolato_ansc_prov
   and tli.id_atto           (+) = mor.id_atto
   and sog_ITP.id_atto       (+) = mor.id_atto
   and sog_ITP.tipo_soggetto (+) = 'IT'
   and mar.id_atto           (+) = mor.id_atto
   and occ.id_atto           (+) = mor.id_atto
   and dpa.id_atto           (+) = mor.id_atto
   and cta.id                    = dta.id_civcta
   and dta.id                    = mor.id_civdta
   and mor.cod_rec     in (0,3)
/
comment on table CIVMOR_V_JSON is 'ANSC - Atti di Morte per request JSON (view)'
/
