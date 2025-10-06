--liquibase formatted sql
--changeset amonopoli:202305181240_5 runAlways:true runOnChange:true stripComments:false
create or replace view civcit_v_json as
select cit.id
     , cit.id_atto
     , cit.ufficio
     , cit.anno
     , cit.atto
-- evento
     , f_ANSC_valore_inp('ID_VERSION',1,10,'9','') idVersion
     , '5' idTipoEvento		-- (anst01) 1 - NASCITA / 2 - MORTE / 3 - MATRIMONIO / 4 - UNIONE CIVILE / 5 - CITTADINANZA 
     , f_ANSC_id_tipo_contenuto(t03.tipo_atto_ansc,cit.natura,cit.tipo_richiesta) idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , f_ANSC_dati_prodotti(dpa.presentazione_documenti) datiProdotti
     , cit.id_usecase_ansc idUseCase		-- (anst03) 
     , t03.descrizione  descrizioneCasoUso	-- (anst03) 
     , decode(f_ANSC_flag_firmato('CIT', cit.id, 'USC'), 'S', 'FIRMATO DA USC', 'CONFERMATO') stato   -- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , 'FIRMATO DA USC' stato_firmatoUSC   -- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') dataFormazione
     , to_char(dpa.d_data_atto_utente,'yyyy') annoAtto
     , to_char(dpa.d_data_atto_utente,'mm') meseAtto
     , to_char(dpa.d_data_atto_utente,'dd') giornoAtto
     , lpad(dpa.ore_atto_utente, 2, '0') ora
     , lpad(dpa.minuti_atto_utente, 2, '0') minuto
     , to_char(f_ANSC_data_validita(1,cta.sigla,cit.natura,nvl(cit.d_data_decorrenza,cit.d_data_cit),dpa.d_data_atto_utente),'yyyy-mm-dd') dataValidita
     , cit.numero_unico numeroatto
     , f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,'') idComuneRegistrazione
     , f_ANSC_comune_al(m.cod_provincia,m.cod_comune,'') nomeComuneRegistrazione
     , f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,'') idProvinciaRegistrazione
     , f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,'') siglaProvinciaRegistrazione
     , f_ANSC_id_operatore(cit.terminalista) operatore
     , f_ANSC_ruolo_operatore(dpa.qualifica_utente) ruoloOperatore
     , f_ANSC_nome_operatore(cit.terminalista) operatoreNome
     , f_ANSC_cognome_operatore(cit.terminalista) operatoreCognome
     , 'true' redattoNellaCasaComunale
     , f_ANSC_ausilio_interprete(dpa.tipo_comparente) ausilioInterprete
     , f_ANSC_motivo_recupero(cit.motivo_recupero_ansc) motivoRecupero            -- (anst96)
     , decode(cit.motivo_recupero_ansc,'','',to_char(dpa.d_data_atto_utente,'yyyy-mm-dd')) dataDecorrenza
     , f_ANSC_tipo_riconoscimento(cit.tipo_riconoscimento) idRiconoscimentoSentenza  -- (anst98)
-- datiEventoCittadinanza
     , decode(cit.nazionalita,'APO','true','false') intestatarioApolide
     , dpa.autorita_prov_email indirizzoPostaAutorita
     , decode(cta.sigla, 
         'GIU', to_char(dpa.d_sentenza_data,'yyyy-mm-dd'), 
         'DAQ', to_char(dpa.d_sentenza_data,'yyyy-mm-dd')) dataDecretoConferimento
     , decode(cta.sigla,  
         'GIU', to_char(dpa.d_sentenza_data_notifica,'yyyy-mm-dd'),  
         'DAQ', to_char(dpa.d_sentenza_data_notifica,'yyyy-mm-dd')) dataNotificaDelDecreto 
     , decode(cta.sigla, 
         'GIU', dpa.sentenza_numero, 
         'DAQ', dpa.sentenza_numero) estremiDecretoConferimento 
     , decode(cta.sigla, 
         'DAQ', decode(dmc.flag_annotazione, 'S', dpa.testo_riassunto, 'dichiarazione riportata integralmente nel testo dell''atto') ) riassuntoDichiarazione
     , decode(dmc.flag_residenza, 'S', dpa.dati_residenza) infoResidenzaBiennale 
     , decode(dmc.flag_estremi_giuramento, 'S', to_char(cit.d_data_cit,'yyyy-mm-dd')) dataGiuramento
     , decode(dmc.flag_estremi_giuramento, 'S', decode(dpa.giuramento_atto||dpa.giuramento_anno,'',to_char(null),dpa.giuramento_atto||'/'||dpa.giuramento_anno)) estremiGiuramento
     , '1' tipoEventoCittadinanza
     , decode(cta.sigla, 'GIU', f_ANSC_officiante_CIT(dpa.qualifica_utente)) officiante
-- ufficialeStatoCivile
     , decode(cta.sigla, 'GIU', decode(f_ANSC_officiante_CIT(dpa.qualifica_utente), '', '', f_ANSC_nome_officiante(dpa.ufficiale_utente, ''))) OFF_nome
     , decode(cta.sigla, 'GIU', decode(f_ANSC_officiante_CIT(dpa.qualifica_utente), '', '', f_ANSC_cognome_officiante(dpa.ufficiale_utente, ''))) OFF_cognome
     , 'false' OFF_flagDichiarante
     , 'false' OFF_flagComparente
     , decode(cta.sigla, 'GIU', decode(f_ANSC_officiante_CIT(dpa.qualifica_utente), '', 'false', 'true')) OFF_flagFirmatario
  -- parenteDiretto
     , sog_AS.cognome ASC_cognome
     , sog_AS.nome ASC_nome
     , sog_AS.sesso ASC_sesso
     , decode(sog_AS.sesso,'M','maschile','F','femminile') ASC_descrizioneSesso
     , to_char(sog_AS.d_data_nas,'yyyy-mm-dd') ASC_dataNascita
     , f_ANSC_id_comune_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_idComuneNascita
     , f_ANSC_comune_italiano(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_nomeComuneNascita
     , f_ANSC_id_provincia_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_idProvinciaNascita
     , f_ANSC_provincia_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_siglaProvinciaNascita
     , f_ANSC_id_stato_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_idStatoNascita
     , f_ANSC_stato_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_nomeStatoNascita
     , f_ANSC_comune_estero(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_comuneEsteroNascita
     , f_ANSC_id_comune_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_idComuneResidenza
     , f_ANSC_comune_italiano(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_nomeComuneResidenza
     , f_ANSC_id_provincia_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_idProvinciaResidenza
     , f_ANSC_provincia_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_idStatoResidenza
     , f_ANSC_stato_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_nomeStatoResidenza
     , f_ANSC_comune_estero(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,'') ASC_comuneEsteroResidenza
     , decode(sog_AS.sesso,'M','o','F','a') ASC_genere
     , f_ANSC_id_nazionalita(dci_AS.ist_ci) ASC_idNazionalita
     , f_get_descrizione_dci(sog_AS.nazionalita,'') ASC_nazionalita
     , decode(dpa.tipo_dichiarante,
         'AS', f_ANSC_comprensione(dpa.comprensione_dic)
       ) ASC_tipoImpedimento
     , 'false' ASC_flagDichiarante --f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'AS') ASC_flagDichiarante
     , 'false' ASC_flagComparente --f_ANSC_flag_comparente(dpa.tipo_comparente,'AS') ASC_flagComparente
     , 'false' ASC_flagFirmatario --f_ANSC_flag_firmatario(dpa.tipo_firmatario,'AS') ASC_flagFirmatario
     , f_ANSC_grado_parentela(sog_AS.grado_parentela) ASC_gradoDiParentela
-- trascrizioneCittadinanza
     , decode(cit.tipo_richiesta, 'TRA', to_char(cit.d_data_accertamento, 'yyyy-mm-dd') ) TRA_dataAccertamento  -- cit.d_data_accertamento ad oggi in uso solo per cdu 52111 (ius soli)
     , decode(cit.tipo_richiesta, 'TRA', to_char(cit.d_data_richiesta, 'yyyy-mm-dd') ) TRA_dataComunicazione
     , f_ANSC_tipo_dichiarazione(1, cta.sigla, cit.id_usecase_ansc, dpa.tipo_richiesta_trascrizione) TRA_tipoRichiestaTrascrizione	-- ANST38
     , decode(sog_CG.cambio_generalita, 'SI', 'true', 'false') TRA_flagCambioGeneralita
     , decode(cit.tipo_trasmissione_cittadinanza, 'MD', '1', 'PD', '2', 'EN', '3', '') TRA_genitoreConCittadinanza -- ANST88
     , case when dmc.flag_minore = 'S' and dmc.flag_riconoscimento = 'S'
            then 'Come da trascrizione contenuta nel corpo dell''atto' else '' end TRA_esitoAccertamento
     , case when dmc.flag_minore = 'S' and dmc.flag_riconoscimento = 'S'
            then to_char(cit.d_data_accertamento, 'yyyy-mm-dd') end TRA_dataProvvedimentoSindaco
     , 'Come da trascrizione contenuta nel corpo dell''atto' testoLibero
   -- atto/enteEstero (autorita mittente)
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN to_char(nvl(dpa.d_data_nota_rif,dpa.d_data_atto_utente),'yyyy-mm-dd')
            WHEN dmc.flag_accertamento = 'S' THEN to_char(dpa.d_accertamento_data_doc,'yyyy-mm-dd')
            ELSE decode(dmc.flag_pubblico_impiego, 'S', to_char(dpa.d_pubblico_impiego_data_doc,'yyyy-mm-dd')) END TRA_dataTrascrizione
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN dpa.nota_rif||decode(dpa.anno_nota_rif, '', '', '/')||dpa.anno_nota_rif
            WHEN dmc.flag_accertamento = 'S' THEN dpa.accertamento_estremi_doc
            ELSE decode(dmc.flag_pubblico_impiego, 'S', dpa.pubblico_impiego_estremi_doc) END TRA_estremiDocumento
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN dpa.autorita_prov
            WHEN dmc.flag_accertamento = 'S' THEN dpa.accertamento_ente
            ELSE decode(dmc.flag_pubblico_impiego, 'S', dpa.pubblico_impiego_ente) END TRA_nomeEnte
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            WHEN dmc.flag_accertamento = 'S' THEN f_ANSC_id_stato_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'')
            ELSE decode(dmc.flag_pubblico_impiego, 'S', f_ANSC_id_stato_al(dpa.pubblico_impiego_cod_pro,dpa.pubblico_impiego_cod_com,'')) END TRA_nazioneEnte
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            WHEN dmc.flag_accertamento = 'S' THEN f_ANSC_stato_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'')
            ELSE decode (dmc.flag_pubblico_impiego, 'S', f_ANSC_stato_al(dpa.pubblico_impiego_cod_pro,dpa.pubblico_impiego_cod_com,'')) END TRA_nomeNazioneEnte
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' AND dmc.flag_consolato = 'S' THEN f_ANSC_comune_estero(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            WHEN dmc.flag_accertamento = 'S' THEN f_ANSC_comune_estero(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'')
            ELSE decode (dmc.flag_pubblico_impiego, 'S', f_ANSC_comune_estero(dpa.pubblico_impiego_cod_pro,dpa.pubblico_impiego_cod_com,'')) END TRA_comuneEsteroEnte
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            WHEN dmc.flag_accertamento = 'S' THEN f_ANSC_id_comune_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') END TRA_idComuneEnte
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN f_ANSC_comune_italiano(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            WHEN dmc.flag_accertamento = 'S' THEN f_ANSC_comune_italiano(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') END TRA_nomeComuneEnte
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            WHEN dmc.flag_accertamento = 'S' THEN f_ANSC_id_provincia_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') END TRA_idProvinciaEnte
     , CASE WHEN dmc.flag_accertamento is null AND dmc.flag_autorita = 'S' THEN f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            WHEN dmc.flag_accertamento = 'S' THEN f_ANSC_provincia_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') END TRA_siglaProvinciaEnte
     , CASE WHEN dmc.flag_accertamento is null THEN dpa.id_consolato_ansc_prov END TRA_idAnagraficaConsolato
     , CASE WHEN dmc.flag_accertamento is null THEN t97.descrizione END TRA_nomeAnagraficaConsolato
  -- attoEstero/enteEstero (atto da trascrivere)
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN dpa.autorita_prov
            ELSE dpa.ente_straniero END EST_nomeEnte
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            ELSE f_ANSC_id_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') END EST_idComuneEnte
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN f_ANSC_comune_italiano(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            ELSE f_ANSC_comune_italiano(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') END EST_nomeComuneEnte
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            ELSE f_ANSC_id_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') END EST_idProvinciaEnte
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            ELSE f_ANSC_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') END EST_siglaProvinciaEnte
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            ELSE f_ANSC_id_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') END EST_nazioneEnte
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            ELSE f_ANSC_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') END EST_nomeNazioneEnte
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN f_ANSC_comune_estero(dpa.cod_pro_prov,dpa.cod_com_prov,'')
            ELSE f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') END EST_comuneEsteroEnte
     , to_char(null) EST_dataComunicazione
     , CASE WHEN dmc.FLAG_ENTE_ESTERO ='S' and dmc.flag_accertamento is null THEN to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd') 
            ELSE to_char(null) END EST_dataTrascrizione
     , CASE WHEN dmc.flag_autorita = 'S' AND dmc.flag_consolato IS NULL and dmc.flag_accertamento is null THEN dpa.nota_rif||decode(dpa.anno_nota_rif, '', '', '/')||dpa.anno_nota_rif
            ELSE dpa.ente_straniero_estremi_atto END EST_estremiDocumento
     , to_char(null) EST_idAnagraficaConsolato
     , to_char(null) EST_nomeAnagraficaConsolato
     , CASE WHEN dmc.flag_accertamento is null THEN f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') END EST_comuneEstero
  -- cambioGeneralita
     , sog_CG.cognome CG_cognome
     , sog_CG.nome CG_nome
     , sog_CG.sesso CG_sesso
     , to_char(sog_CG.d_data_nas,'yyyy-mm-dd') CG_dataNascita
     , f_ANSC_id_comune_al(sog_CG.cod_pro_nas,sog_CG.cod_com_nas,sog_CG.d_data_nas) CG_idComuneNascita
     , f_ANSC_comune_italiano(sog_CG.cod_pro_nas,sog_CG.cod_com_nas,sog_CG.d_data_nas) CG_nomeComuneNascita
     , f_ANSC_id_provincia_al(sog_CG.cod_pro_nas,sog_CG.cod_com_nas,sog_CG.d_data_nas) CG_idProvinciaNascita
     , f_ANSC_provincia_al(sog_CG.cod_pro_nas,sog_CG.cod_com_nas,sog_CG.d_data_nas) CG_siglaProvinciaNascita
     , f_ANSC_id_stato_al(sog_CG.cod_pro_nas,sog_CG.cod_com_nas,sog_CG.d_data_nas) CG_idStatoNascita
     , f_ANSC_stato_al(sog_CG.cod_pro_nas,sog_CG.cod_com_nas,sog_CG.d_data_nas) CG_nomeStatoNascita
     , f_ANSC_comune_estero(sog_CG.cod_pro_nas,sog_CG.cod_com_nas,sog_CG.d_data_nas) CG_comuneEsteroNascita
     , f_ANSC_id_comune_al(sog_CG.cod_pro_res,sog_CG.cod_com_res,cit.d_data_cit) CG_idComuneResidenza
     , f_ANSC_comune_italiano(sog_CG.cod_pro_res,sog_CG.cod_com_res,cit.d_data_cit) CG_nomeComuneResidenza
     , f_ANSC_id_provincia_al(sog_CG.cod_pro_res,sog_CG.cod_com_res,cit.d_data_cit) CG_idProvinciaResidenza
     , f_ANSC_provincia_al(sog_CG.cod_pro_res,sog_CG.cod_com_res,cit.d_data_cit) CG_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(sog_CG.cod_pro_res,sog_CG.cod_com_res,cit.d_data_cit) CG_idStatoResidenza
     , f_ANSC_stato_al(sog_CG.cod_pro_res,sog_CG.cod_com_res,cit.d_data_cit) CG_nomeStatoResidenza
     , f_ANSC_comune_estero(sog_CG.cod_pro_res,sog_CG.cod_com_res,cit.d_data_cit) CG_comuneEsteroResidenza
     , f_ANSC_id_nazionalita(dci_CG.ist_ci) CG_idNazionalita
     , f_get_descrizione_dci(sog_CG.nazionalita,'') CG_nazionalita
     , 'false' CG_flagDichiarante
     , 'false' CG_flagComparente
     , 'false' CG_flagFirmatario
  -- autoritaMittente
     , to_char(null) MIT_ruoloEnteDichiarante
     , dpa.autorita_prov MIT_nomeEnte
     , f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') MIT_idComuneEnte
     , f_ANSC_comune_italiano(dpa.cod_pro_prov,dpa.cod_com_prov,'') MIT_nomeComuneEnte
     , f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') MIT_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') MIT_siglaProvinciaEnte
     , to_char(dpa.d_data_nota_rif, 'yyyy-mm-dd') MIT_dataTrascrizione
     , dpa.nota_rif MIT_estremiDocumento
-- datiGenerali
     , to_char(null) dataRegistrazioneDecreto
     , to_char(null) tipoImpiego
     , to_char(null) nazioneImpiego
-- datiPubblicoImpiego
     , decode(dmc.flag_pubblico_impiego, 'S', f_ANSC_tempo_assunzione(dpa.pubblico_impiego_tempo)) PUB_tempoAssunzione
     , decode(dmc.flag_pubblico_impiego, 'S', to_char(dpa.d_pubblico_impiego_data_doc,'yyyy-mm-dd')) PUB_dataTrascrizione
     , decode(dmc.flag_pubblico_impiego, 'S', dpa.pubblico_impiego_estremi_doc) PUB_estremiDocumento
     , decode(dmc.flag_pubblico_impiego, 'S', dpa.pubblico_impiego_ente) PUB_nomeEnte
     , decode(dmc.flag_pubblico_impiego, 'S', f_ANSC_id_stato_al(dpa.pubblico_impiego_cod_pro,dpa.pubblico_impiego_cod_com,'')) PUB_nazioneEnte
     , decode(dmc.flag_pubblico_impiego, 'S', f_ANSC_stato_al(dpa.pubblico_impiego_cod_pro,dpa.pubblico_impiego_cod_com,'')) PUB_nomeNazioneEnte
     , to_char(null) datoreEstero
     , to_char(null) nomeDatoreLavoro
     , to_char(null) dataAssunzione
-- tipoRichiestaCittadinanza
     , to_char(null) tipoResidenza
     , to_char(null) idProvinciaResidenza
     , to_char(null) provinciaResidenza
     , to_char(null) idComuneResidenza
     , to_char(null) comuneResidenza
     , to_char(null) motivoPerditaCittadinanza
-- intestatari
     , cit.cod_fiscale INT_codiceFiscale
     , nvl(occ.cognome,cit.cognome) INT_cognome
     , nvl(occ.nome,cit.nome) INT_nome
     , cit.sesso INT_sesso
     , decode(cit.sesso,'M','maschile','F','femminile','non conosciuto') INT_descrizioneSesso
     , to_char(cit.d_data_nas,'yyyy-mm-dd') INT_dataNascita
     , f_ANSC_id_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas) INT_idComuneNascita
     , f_ANSC_comune_italiano(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas) INT_nomeComuneNascita
     , f_ANSC_id_provincia_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas) INT_idProvinciaNascita
     , f_ANSC_provincia_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas) INT_siglaProvinciaNascita
     , f_ANSC_id_stato_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas) INT_idStatoNascita
     , f_ANSC_stato_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas) INT_nomeStatoNascita
     , f_ANSC_comune_estero(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas) INT_comuneEsteroNascita
     , f_ANSC_id_comune_al(cit.cod_pro_res,cit.cod_com_res,'') INT_idComuneResidenza
     , f_ANSC_comune_italiano(cit.cod_pro_res,cit.cod_com_res,'') INT_nomeComuneResidenza
     , f_ANSC_id_provincia_al(cit.cod_pro_res,cit.cod_com_res,'') INT_idProvinciaResidenza
     , f_ANSC_provincia_al(cit.cod_pro_res,cit.cod_com_res,'') INT_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(cit.cod_pro_res,cit.cod_com_res,'') INT_idStatoResidenza
     , f_ANSC_stato_al(cit.cod_pro_res,cit.cod_com_res,'') INT_nomeStatoResidenza
     , f_ANSC_stato_al(cit.cod_pro_res,cit.cod_com_res,'') INT_comuneEsteroResidenza
     , to_char(null) INT_indirizzoResidenza
     , f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),cit.cod_pro_res,cit.cod_com_res) INT_idComuneAIRE
     , f_ANSC_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),cit.cod_pro_res,cit.cod_com_res) INT_nomeComuneAIRE
     , f_ANSC_id_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),cit.cod_pro_res,cit.cod_com_res) INT_idProvinciaAIRE
     , f_ANSC_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),cit.cod_pro_res,cit.cod_com_res) INT_siglaProvinciaAIRE
--     , to_char(null) INT_idstatocivile
--     , f_get_descrizione_DSC(cit.stato_civile,cit.sesso,'','','') INT_descrizioneStatoCivile
     , decode(cit.sesso,'M','o','F','a') INT_genere
     , f_ANSC_id_nazionalita(dci.ist_ci) INT_idNazionalita
     , f_get_descrizione_DCI(cit.nazionalita,'') INT_nazionalita
     , decode(dpa.tipo_dichiarante,
         'IN', f_ANSC_comprensione(dpa.comprensione_dic)
       ) INT_tipoImpedimento
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'IN') INT_flagDichiarante
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'IN') INT_flagComparente
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'IN') INT_flagFirmatario
     , cit.note note
  -- documentoDiRiconoscimento
     , dpa.numero_documento_dic INT_numeroDocumento
     , f_ANSC_tipologia_documento(dpa.tipo_documento_dic) INT_tipologiaDocumento --f_get_descrizione_DDO(dpa.tipo_documento_dic) INT_tipologiaDocumento
     , to_char(dpa.d_data_scadenza_documento_dic,'yyyy-mm-dd') INT_dataScadenza
     , f_ANSC_rilasciato_da(dpa.ente_documento_dic,dpa.tipo_documento_dic) INT_rilasciatoDa --f_get_descrizione_DEN(dpa.ente_documento_dic) INT_rilasciatoDa
     , to_char(dpa.d_data_emissione_documento_dic,'yyyy-mm-dd') INT_dataRilascio
 -- riconoscimentoPadre
     , decode(cit.tipo_riconoscimento, 'PD', dpa.riconoscim_pre_id_atto_ansc_2) RIC_PAT_idAttoAnsc
     , decode(cit.tipo_riconoscimento, 'PD', f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2,'')) RIC_PAT_idProvinciaReg
     , decode(cit.tipo_riconoscimento, 'PD', f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2,'')) RIC_PAT_siglaProvinciaReg
     , decode(cit.tipo_riconoscimento, 'PD', f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2,'')) RIC_PAT_idComuneReg
     , decode(cit.tipo_riconoscimento, 'PD', f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2,'')) RIC_PAT_nomeComuneReg
     , decode(cit.tipo_riconoscimento, 'PD', '1') RIC_PAT_idtipocontenuto  -- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(cit.tipo_riconoscimento, 'PD', decode(dpa.riconoscim_pre_id_atto_ansc_2, '', dpa.riconoscimento_pre_atto_2, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_2,'NUMERO_COMUNALE'))) RIC_PAT_numeroatto
     , decode(cit.tipo_riconoscimento, 'PD', decode(dpa.riconoscim_pre_id_atto_ansc_2, '', dpa.riconoscimento_pre_anno_2, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_2,'ANNO'))) RIC_PAT_annoAtto
     , decode(cit.tipo_riconoscimento, 'PD', decode(dpa.riconoscim_pre_id_atto_ansc_2, '', dpa.riconoscimento_pre_parte_2)) RIC_PAT_parte
     , decode(cit.tipo_riconoscimento, 'PD', decode(dpa.riconoscim_pre_id_atto_ansc_2, '', dpa.riconoscimento_pre_serie_2)) RIC_PAT_serie
     , decode(cit.tipo_riconoscimento, 'PD', to_char(dpa.d_riconoscimento_pre_data_2, 'yyyy-mm-dd')) RIC_PAT_dataformazione
     , decode(cit.tipo_riconoscimento, 'PD', 'Nascita') RIC_PAT_tipologia
  -- riconoscimentoMadre
     , decode(cit.tipo_riconoscimento, 'MD', dpa.riconoscim_pre_id_atto_ansc_1) RIC_MAT_idAttoAnsc
     , decode(cit.tipo_riconoscimento, 'MD', f_ANSC_id_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1,'')) RIC_MAT_idProvinciaReg
     , decode(cit.tipo_riconoscimento, 'MD', f_ANSC_provincia_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1,'')) RIC_MAT_siglaProvinciaReg
     , decode(cit.tipo_riconoscimento, 'MD', f_ANSC_id_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1,'')) RIC_MAT_idComuneReg
     , decode(cit.tipo_riconoscimento, 'MD', f_ANSC_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1,'')) RIC_MAT_nomeComuneReg
     , decode(cit.tipo_riconoscimento, 'MD', '1') RIC_MAT_idtipocontenuto  -- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(cit.tipo_riconoscimento, 'MD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_atto_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'NUMERO_COMUNALE'))) RIC_MAT_numeroatto
     , decode(cit.tipo_riconoscimento, 'MD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_anno_1, f_CIV_get_estremi_id_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1,'ANNO'))) RIC_MAT_annoAtto
     , decode(cit.tipo_riconoscimento, 'MD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_parte_1)) RIC_MAT_parte
     , decode(cit.tipo_riconoscimento, 'MD', decode(dpa.riconoscim_pre_id_atto_ansc_1, '', dpa.riconoscimento_pre_serie_1)) RIC_MAT_serie
     , decode(cit.tipo_riconoscimento, 'MD', to_char(dpa.d_riconoscimento_pre_data_1, 'yyyy-mm-dd')) RIC_MAT_dataformazione
     , decode(cit.tipo_riconoscimento, 'MD', 'Nascita') RIC_MAT_tipologia
-- madre
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then sog_MD.cognome end MAT_cognome
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then sog_MD.nome end MAT_nome
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then sog_MD.sesso end MAT_sesso
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then 'femminile' end MAT_descrizioneSesso
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then to_char(sog_MD.d_data_nas,'yyyy-mm-dd') end MAT_dataNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_id_comune_al(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,sog_MD.d_data_nas) end MAT_idComuneNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_comune_italiano(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,sog_MD.d_data_nas) end MAT_nomeComuneNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_id_provincia_al(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,sog_MD.d_data_nas) end MAT_idProvinciaNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_provincia_al(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,sog_MD.d_data_nas) end MAT_siglaProvinciaNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_id_stato_al(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,sog_MD.d_data_nas) end MAT_idStatoNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_stato_al(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,sog_MD.d_data_nas) end MAT_nomeStatoNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_comune_estero(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,sog_MD.d_data_nas) end MAT_comuneEsteroNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_id_comune_al(sog_MD.cod_pro_res,sog_MD.cod_com_res,sog_MD.d_data_nas) end MAT_idComuneResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_comune_italiano(sog_MD.cod_pro_res,sog_MD.cod_com_res,sog_MD.d_data_nas) end MAT_nomeComuneResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_id_provincia_al(sog_MD.cod_pro_res,sog_MD.cod_com_res,sog_MD.d_data_nas) end MAT_idProvinciaResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_provincia_al(sog_MD.cod_pro_res,sog_MD.cod_com_res,sog_MD.d_data_nas) end MAT_siglaProvinciaResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_id_stato_al(sog_MD.cod_pro_res,sog_MD.cod_com_res,sog_MD.d_data_nas) end MAT_idStatoResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_stato_al(sog_MD.cod_pro_res,sog_MD.cod_com_res,sog_MD.d_data_nas) end MAT_nomeStatoResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_ANSC_comune_estero(sog_MD.cod_pro_res,sog_MD.cod_com_res,sog_MD.d_data_nas) end MAT_comuneEsteroResidenza
     , to_char(null) MAT_indirizzoResidenza
     , to_char(null) MAT_genere
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then dci_MD.ist_ci end MAT_idNazionalita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','MD','SM') then f_get_descrizione_dci(sog_MD.nazionalita,'') end MAT_nazionalita
     , decode(dpa.tipo_dichiarante,
         'MD', f_ANSC_comprensione(dpa.comprensione_dic)
       ) MAT_tipoImpedimento
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'MD') MAT_flagDichiarante
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'MD') MAT_flagComparente
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'MD') MAT_flagFirmatario
-- padre
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then sog_PD.cognome end PAT_cognome
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then sog_PD.nome end PAT_nome
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then sog_PD.sesso end PAT_sesso
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then 'maschile' end PAT_descrizioneSesso
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then to_char(sog_PD.d_data_nas,'yyyy-mm-dd') end PAT_dataNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_id_comune_al(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,sog_PD.d_data_nas) end PAT_idComuneNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_comune_italiano(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,sog_PD.d_data_nas) end PAT_nomeComuneNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_id_provincia_al(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,sog_PD.d_data_nas) end PAT_idProvinciaNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_provincia_al(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,sog_PD.d_data_nas) end PAT_siglaProvinciaNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_id_stato_al(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,sog_PD.d_data_nas) end PAT_idStatoNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_stato_al(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,sog_PD.d_data_nas) end PAT_nomeStatoNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_comune_estero(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,sog_PD.d_data_nas) end PAT_comuneEsteroNascita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_id_comune_al(sog_PD.cod_pro_res,sog_PD.cod_com_res,sog_PD.d_data_nas) end PAT_idComuneResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_comune_italiano(sog_PD.cod_pro_res,sog_PD.cod_com_res,sog_PD.d_data_nas) end PAT_nomeComuneResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_id_provincia_al(sog_PD.cod_pro_res,sog_PD.cod_com_res,sog_PD.d_data_nas) end PAT_idProvinciaResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_provincia_al(sog_PD.cod_pro_res,sog_PD.cod_com_res,sog_PD.d_data_nas) end PAT_siglaProvinciaResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_id_stato_al(sog_PD.cod_pro_res,sog_PD.cod_com_res,sog_PD.d_data_nas) end PAT_idStatoResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_stato_al(sog_PD.cod_pro_res,sog_PD.cod_com_res,sog_PD.d_data_nas) end PAT_nomeStatoResidenza
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_ANSC_comune_estero(sog_PD.cod_pro_res,sog_PD.cod_com_res,sog_PD.d_data_nas) end PAT_comuneEsteroResidenza
     , to_char(null) PAT_indirizzoResidenza
     , to_char(null) PAT_genere
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then dci_PD.ist_ci end PAT_idNazionalita
     , case when nvl(cit.tipo_riconoscimento,'XX') in ('XX','PD','SP') then f_get_descrizione_dci(sog_PD.nazionalita,'') end PAT_nazionalita
     , decode(dpa.tipo_dichiarante,
         'PD', f_ANSC_comprensione(dpa.comprensione_dic)
       ) PAT_tipoImpedimento
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'PD') PAT_flagDichiarante
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'PD') PAT_flagComparente
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'PD') PAT_flagFirmatario
-- datiProvvedimentoSindaco
     , to_char(null) SIN_dataTrascrizione
     , to_char(null) SIN_estremiDocumento
     , to_char(null) SIN_nomeEnte
     , to_char(null) SIN_nazioneEnte
     , to_char(null) SIN_nomeNazioneEnte
     , to_char(null) SIN_idProvinciaEnte
     , to_char(null) SIN_siglaProvinciaEnte
     , to_char(null) SIN_idComuneEnte
     , to_char(null) SIN_nomeComuneEnte
-- Dati accertamento
     , to_char(dpa.d_accertamento_data_doc,'yyyy-mm-dd') ACC_dataTrascrizione
     , dpa.accertamento_estremi_doc ACC_estremiDocumento
     , dpa.accertamento_ente ACC_nomeEnte
     , f_ANSC_id_stato_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') ACC_nazioneEnte
     , f_ANSC_stato_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') ACC_nomeNazioneEnte
     , f_ANSC_comune_estero(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') ACC_comuneEsteroEnte
     , f_ANSC_id_provincia_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') ACC_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') ACC_siglaProvinciaEnte
     , f_ANSC_id_comune_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') ACC_idComuneEnte
     , f_ANSC_comune_italiano(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') ACC_nomeComuneEnte
-- datiDichiarante
     , nvl(f_ANSC_comprensione(dpa.comprensione_dic),'00') comprensione
     , dpa.motivo_impedimento_dic motivoImpedimentoScrittura
-- Delegato
     , to_char(null) DEL_cognome
     , to_char(null) DEL_nome
     , to_char(null) DEL_sesso
     , to_char(null) DEL_dataNascita
     , to_char(null) DEL_idStatoNascita
     , to_char(null) DEL_nomeStatoNascita
     , to_char(null) DEL_idProvinciaNascita
     , to_char(null) DEL_siglaProvinciaNascita
     , to_char(null) DEL_idComuneNascita
     , to_char(null) DEL_nomeComuneNascita
     , to_char(null) DEL_idNazionalita
     , to_char(null) DEL_nazionalita
     , to_char(null) DEL_idStatoResidenza
     , to_char(null) DEL_nomeStatoResidenza
     , to_char(null) DEL_idProvinciaResidenza
     , to_char(null) DEL_siglaProvinciaResiden
     , to_char(null) DEL_idComuneResidenza
     , to_char(null) DEL_nomeComuneResidenza
     , to_char(null) DEL_indirizzoResidenza
     , to_char(null) DEL_flagDichiarante -- f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'DE') DEL_flagDichiarante
     , to_char(null) DEL_flagComparente -- f_ANSC_flag_comparente(dpa.tipo_comparente,'DE') DEL_flagComparente
     , to_char(null) DEL_flagFirmatario --f_ANSC_flag_firmatario(dpa.tipo_firmatario,'DE') DEL_flagFirmatario
-- inteprete
     , sog_IT.cognome ITP_cognome
     , sog_IT.nome ITP_nome
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
     , f_ANSC_id_comune_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,cit.d_data_cit) ITP_idComuneResidenza
     , f_ANSC_comune_italiano(sog_IT.cod_pro_res,sog_IT.cod_com_res,cit.d_data_cit) ITP_nomeComuneResidenza
     , f_ANSC_id_provincia_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,cit.d_data_cit) ITP_idProvinciaResidenza
     , f_ANSC_provincia_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,cit.d_data_cit) ITP_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,cit.d_data_cit) ITP_idStatoResidenza
     , f_ANSC_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,cit.d_data_cit) ITP_nomeStatoResidenza
     , f_ANSC_comune_estero(sog_IT.cod_pro_res,sog_IT.cod_com_res,cit.d_data_cit) ITP_comuneEsteroResidenza
     , decode(sog_IT.sesso,'M','o','F','a') ITP_genere
     , f_ANSC_id_nazionalita(dci_it.ist_ci) ITP_idNazionalita
     , f_get_descrizione_dci(sog_IT.nazionalita,'') ITP_nazionalita
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'IT') ITP_flagDichiarante
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'IT') ITP_flagComparente
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'IT') ITP_flagFirmatario
-- attoCollegato
-- recupero sempre l'atto di nascita
-- solo per cdu 51105 (non gestito al 22/04/2025) bisognera' recuperare atto di matrimonio
     , to_char(null) ATTCOL_dataTrascrizione
     , decode(cta.sigla, 'DAQ', mar.id_atto_ansc_nas) ATTCOL_idAttoAnsc
     , decode(cta.sigla, 'DAQ', f_ANSC_id_provincia_al(mar.cod_pro_atto_nas,mar.cod_com_atto_nas,'')) ATTCOL_idProvinciaReg
     , decode(cta.sigla, 'DAQ', f_ANSC_provincia_al(mar.cod_pro_atto_nas,mar.cod_com_atto_nas,'')) ATTCOL_siglaProvinciaReg
     , decode(cta.sigla, 'DAQ', f_ANSC_id_comune_al(mar.cod_pro_atto_nas,mar.cod_com_atto_nas,'')) ATTCOL_idComuneReg
     , decode(cta.sigla, 'DAQ', f_ANSC_comune_al(mar.cod_pro_atto_nas,mar.cod_com_atto_nas,'')) ATTCOL_nomeComuneReg
     , decode(cta.sigla, 'DAQ', decode(mar.id_atto_ansc_nas||mar.atto_nas, '', to_char(null), '1')) ATTCOL_idTipoContenuto
     , decode(cta.sigla, 'DAQ', decode(mar.id_atto_ansc_nas, '', mar.atto_nas, f_CIV_get_estremi_id_atto_ansc(mar.id_atto_ansc_nas,'NUMERO_COMUNALE'))) ATTCOL_numeroAtto
     , decode(cta.sigla, 'DAQ', decode(mar.id_atto_ansc_nas, '', mar.anno_nas, f_CIV_get_estremi_id_atto_ansc(mar.id_atto_ansc_nas,'ANNO'))) ATTCOL_annoAtto
     , decode(cta.sigla, 'DAQ', decode(mar.id_atto_ansc_nas||mar.atto_nas, '', to_char(null), to_char(mar.d_data_atto_nas,'yyyy-mm-dd'))) ATTCOL_dataFormazione
     , decode(cta.sigla, 'DAQ', decode(mar.id_atto_ansc_nas||mar.atto_nas, '', to_char(null), '1')) ATTCOL_tipologia
-- composizioneCompleta
     , tli.riga_clob composizioneCompleta
-- ANSC
     , cit.id_atto_ansc idAttoAnsc
     , cit.id_evento_ansc idEventoAnsc
     , cit.id_soggetto_ansc INT_idSoggettoAnsc
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_1,ana_r.matricola_1),cit.cod_fiscale) INT_idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_1,ana_r.matricola_1),cit.cod_fiscale) INT_idUnicoAnpr
     , to_char(null) forcingCode
  from arccom m
     , anst03 t03
     , anst97 t97
     , civana ana
     , civana_recupero ana_r
     , anadci dci_it
     , anadci dci_PD
     , anadci dci_MD
     , anadci dci_AS
     , anadci dci_CG
     , anadci dci
     , civsog sog_PD
     , civsog sog_MD
     , civsog sog_IT
     , civsog sog_AS
     , civsog_v sog_CG
     , civtli_v tli
     , civmar mar
     , civdpa dpa
     , civocc occ
     , civdmc dmc
     , civcta cta
     , civdta dta
     , civcit cit
 where (m.cod_provincia,m.cod_comune)    = (select pro_cliente, com_cliente from menuditta)
   and ana.id_atto           (+) = cit.id_atto
   and ana_r.id_atto         (+) = cit.id_atto
   and t03.id                (+) = cit.id_usecase_ansc
   and t97.id                (+) = dpa.id_consolato_ansc_prov
   and dci_it.cod_ci         (+) = sog_IT.nazionalita
   and dci_PD.cod_ci         (+) = sog_PD.nazionalita
   and dci_MD.cod_ci         (+) = sog_MD.nazionalita
   and dci_AS.cod_ci         (+) = sog_AS.nazionalita
   and dci_CG.cod_ci         (+) = sog_CG.nazionalita
   and dci.cod_ci            (+) = cit.nazionalita
   and sog_PD.id_atto        (+) = cit.id_atto
   and sog_PD.tipo_soggetto  (+) = 'PD'
   and sog_MD.id_atto        (+) = cit.id_atto
   and sog_MD.tipo_soggetto  (+) = 'MD'
   and sog_IT.id_atto        (+) = cit.id_atto
   and sog_IT.tipo_soggetto  (+) = 'IT'
   and sog_AS.id_atto        (+) = cit.id_atto
   and sog_AS.tipo_soggetto  (+) = 'AS'
   and sog_CG.id_atto        (+) = cit.id_atto
   and sog_CG.tipo_soggetto  (+) = 'CG'
   and tli.id_atto           (+) = cit.id_atto
   and occ.id_atto           (+) = cit.id_atto
   and mar.id_atto           (+) = cit.id_atto
   and dpa.id_atto           (+) = cit.id_atto
   and dmc.id                (+) = cit.id_civdmc
   and cta.id                    = dta.id_civcta
   and dta.id                    = cit.id_civdta
   and cit.cod_rec     in (0,3)
/
comment on table CIVCIT_V_JSON is 'ANSC - Atti di Cittadinanza per request JSON (view)'
/
