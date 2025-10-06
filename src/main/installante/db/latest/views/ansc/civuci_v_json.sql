--liquibase formatted sql
--changeset amonopoli:202305181240_4 runAlways:true runOnChange:true stripComments:false
create or replace view civuci_v_json as
select uci.id
     , uci.id_atto
     , uci.ufficio
     , uci.anno
     , uci.parte
     , uci.serie
     , uci.atto
-- evento
     , f_ANSC_valore_inp('ID_VERSION',1,10,'9','') idVersion
     , '4' idTipoEvento		-- (anst01) 1 - NASCITA / 2 - MORTE / 3 - MATRIMONIO / 4 - UNIONE CIVILE / 5 - CITTADINANZA 
     , f_ANSC_id_tipo_contenuto(t03.tipo_atto_ansc,uci.natura,to_char(null)) idTipoContenuto	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , f_ANSC_dati_prodotti(nvl(decode(pdo.flag_documenti_prodotti,'S','PR',
                                  decode(pdo.flag_documenti_acquisiti,'S','AC',
                                    decode(pdo.flag_documenti_presa_visione,'S','VI'))),'AC')) datiProdotti	-- (anst36)
     , uci.id_usecase_ansc idUseCase		-- (anst03) 
     , t03.descrizione  descrizioneCasoUso	-- (anst03) 
     , decode(f_ANSC_flag_firmato('UCI', uci.id, 'USC'), 'S', 'FIRMATO DA USC', 'CONFERMATO') stato   	-- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , 'FIRMATO DA USC' stato_firmatoUSC   	-- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') dataFormazione
     , to_char(dpa.d_data_atto_utente,'yyyy') annoAtto
     , to_char(dpa.d_data_atto_utente,'mm') meseAtto
     , to_char(dpa.d_data_atto_utente,'dd') giornoAtto
     , lpad(dpa.ore_atto_utente,2,'0') ora
     , lpad(dpa.minuti_atto_utente,2,'0') minuto
     , to_char(f_ANSC_data_validita(-4,cta.sigla,uci.natura,uci.d_data_mat,dpa.d_data_atto_utente),'yyyy-mm-dd') dataValidita
     , uci.numero_unico numeroatto
     , f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,'') idComuneRegistrazione
     , f_ANSC_comune_al(m.cod_provincia,m.cod_comune,'') nomeComuneRegistrazione
     , f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,'') idProvinciaRegistrazione
     , f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,'') siglaProvinciaRegistrazione
     , f_ANSC_id_operatore(uci.terminalista) operatore
     , f_ANSC_ruolo_operatore(dpa.qualifica_utente) ruoloOperatore
     , f_ANSC_nome_operatore(uci.terminalista) operatoreNome
     , f_ANSC_cognome_operatore(uci.terminalista) operatoreCognome
     , f_ANSC_tipo_dichiarante(dpa.tipo_dichiarante,dpa.tipo_comparente) tipoDichiarante
     , f_ANSC_ausilio_interprete(dpa.tipo_comparente) ausilioInterprete
     , f_ANSC_motivo_recupero(uci.motivo_recupero_ansc) motivoRecupero            -- (anst96)
     , decode(uci.motivo_recupero_ansc,'','',to_char(dpa.d_data_atto_utente,'yyyy-mm-dd')) dataDecorrenza
     , decode(uci.natura, 'D', 'false', 'true') flagCertificatoSemplice
     , decode(uci.natura, 'D', 'false', 'true') flagEstrattoPerRiassunto
-- coniuge1
     , nvl(occ.cognome,uci.cognome_m) cognome_1
     , nvl(occ.nome,uci.nome_m) nome_1
     , uci.sesso_m sesso_1
     , to_char(uci.d_data_nas_m,'yyyy-mm-dd') dataNascita_1
     , f_ANSC_id_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) idComuneNascita_1
     , f_ANSC_comune_italiano(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) nomeComuneNascita_1
     , f_ANSC_id_provincia_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) idProvinciaNascita_1
     , f_ANSC_provincia_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) siglaProvinciaNascita_1
     , f_ANSC_id_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) idStatoNascita_1
     , f_ANSC_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) nomeStatoNascita_1
     , f_ANSC_comune_estero(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) comuneEsteroNascita_1
     , f_ANSC_comprensione(uci.comprensione_m) comprensione_1
     , uci.motivo_impedimento_m motivoImpedimentoScrittura_1
     , decode( cta.sigla, 'PDV', f_ANSC_flag_pericolo_vita(dpa.impossibilitato_uci, 'C1')) coniuge1InPericoloVita
     , decode( cta.sigla, 'PDV', 'Accertamento') accertamentoVolontaConiuge1
-- attoNascitaConiuge1
     , spo.id_atto_ansc_nas_m NAS_idAttoAnsc_1
     , f_ANSC_id_provincia_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,'') NAS_idProvinciaReg_1
     , f_ANSC_provincia_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,'') NAS_siglaProvinciaReg_1
     , f_ANSC_id_comune_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,'') NAS_idComuneReg_1
     , f_ANSC_comune_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,'') NAS_nomeComuneReg_1
     , '1' NAS_idtipocontenuto_1              	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(spo.id_atto_ansc_nas_m, '', spo.atto_nas_m, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_nas_m,'NUMERO_COMUNALE'))  NAS_numeroatto_1
     , decode(spo.id_atto_ansc_nas_m, '', spo.anno_atto_nas_m, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_nas_m,'ANNO')) NAS_annoAtto_1
     , to_char(null) NAS_dataformazione_1
     , '1' NAS_tipologia_1
     , decode(spo.id_atto_ansc_nas_m, '', spo.parte_nas_m) NAS_parte_1
     , decode(spo.id_atto_ansc_nas_m, '', spo.serie_nas_m) NAS_serie_1
-- coniuge2
     , nvl(occ.cognome_cn,uci.cognome_f) cognome_2
     , nvl(occ.nome_cn,uci.nome_f) nome_2
     , uci.sesso_f sesso_2
     , to_char(uci.d_data_nas_f,'yyyy-mm-dd') dataNascita_2
     , f_ANSC_id_comune_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) idComuneNascita_2
     , f_ANSC_comune_italiano(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) nomeComuneNascita_2
     , f_ANSC_id_provincia_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) idProvinciaNascita_2
     , f_ANSC_provincia_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) siglaProvinciaNascita_2
     , f_ANSC_id_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) idStatoNascita_2
     , f_ANSC_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) nomeStatoNascita_2
     , f_ANSC_comune_estero(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) comuneEsteroNascita_2
     , f_ANSC_comprensione(uci.comprensione_f) comprensione_2
     , uci.motivo_impedimento_f motivoImpedimentoScrittura_2
     , decode( cta.sigla, 'PDV', f_ANSC_flag_pericolo_vita(dpa.impossibilitato_uci, 'C2')) coniuge2InPericoloVita
     , decode( cta.sigla, 'PDV', 'Accertamento') accertamentoVolontaConiuge2
-- attoNascitaConiuge2
     , spo.id_atto_ansc_nas_f NAS_idAttoAnsc_2
     , f_ANSC_id_provincia_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,'') NAS_idProvinciaReg_2
     , f_ANSC_provincia_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,'') NAS_siglaProvinciaReg_2
     , f_ANSC_id_comune_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,'') NAS_idComuneReg_2
     , f_ANSC_comune_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,'') NAS_nomeComuneReg_2
     , '1' NAS_idtipocontenuto_2              	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(spo.id_atto_ansc_nas_f, '', spo.atto_nas_f, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_nas_f,'NUMERO_COMUNALE')) NAS_numeroatto_2
     , decode(spo.id_atto_ansc_nas_f, '', spo.anno_atto_nas_f, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_nas_f,'ANNO')) NAS_annoAtto_2
     , to_char(null) NAS_dataformazione_2
     , '1' NAS_tipologia_2
     , decode(spo.id_atto_ansc_nas_f, '', spo.parte_nas_f) NAS_parte_2
     , decode(spo.id_atto_ansc_nas_f, '', spo.serie_nas_f) NAS_serie_2
-- datiEventoUnioneCivile
     , to_char(uci.d_data_mat, 'yyyy-mm-dd') dataEvento -- FIXME: bisognerebbe montare gestione per categoria
     , lpad(uci.ore,2,'0') oraEvento
     , lpad(uci.minuti,2,'0') minutoEvento
     , case when cta.sigla in ('TEP', 'TEA', 'UAC', 'UCO', 'UAL', 'AVV')  then '' else f_ANSC_officiante(dpa.tipo_atto, dpa.id_atto, '') end officiante
  -- officianteEvento
     , case when cta.sigla in ('TEP', 'TEA', 'UAC', 'UCO', 'UAL', 'AVV')  then '' else decode(cta.sigla, 'UPD', f_ANSC_nome_officiante(dpa.ufficiale_utente, ''), f_ANSC_nome_officiante(COALESCE(dpa.ministro_art, dpa.ministro, dpa.ufficiale_prov, dpa.ufficiale_utente),'')) end OFF_nome
     , case when cta.sigla in ('TEP', 'TEA', 'UAC', 'UCO', 'UAL', 'AVV')  then '' else decode(cta.sigla, 'UPD', f_ANSC_cognome_officiante(dpa.ufficiale_utente, ''), f_ANSC_cognome_officiante(COALESCE(dpa.ministro_art, dpa.ministro, dpa.ufficiale_prov, dpa.ufficiale_utente),'')) end OFF_cognome
     , 'false' OFF_flagDichiarante
     , case when cta.sigla in ('O1', 'FCC', 'PDV', 'UPD') then 'true' else 'false' end OFF_flagFirmatario
     , 'false' OFF_flagComparente
--
     , decode(tta.numero_testimoni, '', '', tta.numero_testimoni) numeroTestimoni
     , f_ANSC_impedimento_generico(dpa.impedimento_uci) impedimentoGenerico
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci)) soggettoImpedimentoCivile
     , decode(dpa.fine_opposizione_tipo_doc,'DE','true','false') rigettoOpposizione
     , decode(dpa.fine_opposizione_tipo_doc,'PR','true','false') estintaOpposizione
     , f_ANSC_difetto_eta(uci.difetto_eta) difettoEta
     , f_ANSC_impedimento_mat(uci.impedimento_mat) impedimentoParentela
  -- impedimentoSposo
    -- certificato
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (1,3) THEN dpa.certificato_uci END) CER_nomeEnte_1
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (1,3) THEN f_ANSC_id_comune_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') END) CER_idComuneEnte_1
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (1,3) THEN f_ANSC_comune_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') END) CER_nomeComuneEnte_1
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (1,3) THEN f_ANSC_id_provincia_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') END) CER_idProvinciaEnte_1
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (1,3) THEN f_ANSC_provincia_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') END) CER_siglaProvinciaEnte_1
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (1,3) THEN to_char(dpa.d_data_certificato_uci,'yyyy-mm-dd') END) CER_dataTrascrizione_1
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (1,3) THEN dpa.certificato_uci_estremi_doc END) CER_estremiDocumento_1
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (1,3) THEN 'come da dettagli contenuti nell''atto' END) CER_motivazione_1
  -- impedimentoSposa
    -- certificato
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (2,3) THEN dpa.certificato_uci END) CER_nomeEnte_2
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (2,3) THEN f_ANSC_id_comune_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') END) CER_idComuneEnte_2
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (2,3) THEN f_ANSC_comune_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') END) CER_nomeComuneEnte_2
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (2,3) THEN f_ANSC_id_provincia_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') END) CER_idProvinciaEnte_2
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (2,3) THEN f_ANSC_provincia_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') END) CER_siglaProvinciaEnte_2
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (2,3) THEN to_char(dpa.d_data_certificato_uci,'yyyy-mm-dd') END) CER_dataTrascrizione_2
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (2,3) THEN dpa.certificato_uci_estremi_doc END) CER_estremiDocumento_2
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', CASE when f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci) in (2,3) THEN 'come da dettagli contenuti nell''atto' END) CER_motivazione_2
  -- provvedimentoRigettoOpposizione
     , decode(dpa.fine_opposizione_tipo_doc,'DE', to_char(dpa.d_FINE_OPPOSIZIONE_data_doc,'yyyy-mm-dd')) RIGOPP_dataTrascrizione
     , decode(dpa.fine_opposizione_tipo_doc,'DE', dpa.FINE_OPPOSIZIONE_estremi_doc) RIGOPP_estremiDocumento
     , decode(dpa.fine_opposizione_tipo_doc,'DE', dpa.FINE_OPPOSIZIONE_ente) RIGOPP_nomeEnte
     , decode(dpa.fine_opposizione_tipo_doc,'DE', f_ANSC_id_provincia_al(dpa.FINE_OPPOSIZIONE_cod_pro,dpa.FINE_OPPOSIZIONE_cod_com,'')) RIGOPP_idProvinciaEnte
     , decode(dpa.fine_opposizione_tipo_doc,'DE', f_ANSC_provincia_al(dpa.FINE_OPPOSIZIONE_cod_pro,dpa.FINE_OPPOSIZIONE_cod_com,'')) RIGOPP_siglaProvinciaEnte
     , decode(dpa.fine_opposizione_tipo_doc,'DE', f_ANSC_id_comune_al(dpa.FINE_OPPOSIZIONE_cod_pro,dpa.FINE_OPPOSIZIONE_cod_com,'')) RIGOPP_idComuneEnte
     , decode(dpa.fine_opposizione_tipo_doc,'DE', f_ANSC_comune_al(dpa.FINE_OPPOSIZIONE_cod_pro,dpa.FINE_OPPOSIZIONE_cod_com,'')) RIGOPP_nomeComuneEnte
  -- provvedimentoEstinzioneOpposizione
     , decode(dpa.fine_opposizione_tipo_doc,'PR', to_char(dpa.d_FINE_OPPOSIZIONE_data_doc,'yyyy-mm-dd')) ESTOPP_dataTrascrizione
     , decode(dpa.fine_opposizione_tipo_doc,'PR', dpa.FINE_OPPOSIZIONE_estremi_doc) ESTOPP_estremiDocumento
     , decode(dpa.fine_opposizione_tipo_doc,'PR', dpa.FINE_OPPOSIZIONE_ente) ESTOPP_nomeEnte
     , decode(dpa.fine_opposizione_tipo_doc,'PR', f_ANSC_id_provincia_al(dpa.FINE_OPPOSIZIONE_cod_pro,dpa.FINE_OPPOSIZIONE_cod_com,'')) ESTOPP_idProvinciaEnte
     , decode(dpa.fine_opposizione_tipo_doc,'PR', f_ANSC_provincia_al(dpa.FINE_OPPOSIZIONE_cod_pro,dpa.FINE_OPPOSIZIONE_cod_com,'')) ESTOPP_siglaProvinciaEnte
     , decode(dpa.fine_opposizione_tipo_doc,'PR', f_ANSC_id_comune_al(dpa.FINE_OPPOSIZIONE_cod_pro,dpa.FINE_OPPOSIZIONE_cod_com,'')) ESTOPP_idComuneEnte
     , decode(dpa.fine_opposizione_tipo_doc,'PR', f_ANSC_comune_al(dpa.FINE_OPPOSIZIONE_cod_pro,dpa.FINE_OPPOSIZIONE_cod_com,'')) ESTOPP_nomeComuneEnte
  -- testimone_1
     , tta.cognome_1 cognome_t1
     , tta.nome_1 nome_t1
     , tta.sesso_1 sesso_t1
     , decode(tta.sesso_1,'M','maschile','F','femminile') descrizioneSesso_t1
     , to_char(tta.d_data_nas_1,'yyyy-mm-dd') dataNascita_t1
     , f_ANSC_id_comune_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,tta.d_data_nas_1) idComuneNascita_t1
     , f_ANSC_comune_italiano(tta.cod_pro_nas_1,tta.cod_com_nas_1,tta.d_data_nas_1) nomeComuneNascita_t1
     , f_ANSC_id_provincia_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,tta.d_data_nas_1) idProvinciaNascita_t1
     , f_ANSC_provincia_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,tta.d_data_nas_1) siglaProvinciaNascita_t1
     , f_ANSC_id_stato_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,tta.d_data_nas_1) idStatoNascita_t1
     , f_ANSC_stato_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,tta.d_data_nas_1) nomeStatoNascita_t1
     , f_ANSC_comune_estero(tta.cod_pro_nas_1,tta.cod_com_nas_1,tta.d_data_nas_1) comuneEsteroNascita_t1
     , f_ANSC_id_comune_al(tta.cod_pro_res_1,tta.cod_com_res_1,uci.d_data_mat) idComuneResidenza_t1
     , f_ANSC_comune_italiano(tta.cod_pro_res_1,tta.cod_com_res_1,uci.d_data_mat) nomeComuneResidenza_t1
     , f_ANSC_id_provincia_al(tta.cod_pro_res_1,tta.cod_com_res_1,uci.d_data_mat) idProvinciaResidenza_t1
     , f_ANSC_provincia_al(tta.cod_pro_res_1,tta.cod_com_res_1,uci.d_data_mat) siglaProvinciaResidenza_t1
     , f_ANSC_id_stato_al(tta.cod_pro_res_1,tta.cod_com_res_1,uci.d_data_mat) idStatoResidenza_t1
     , f_ANSC_stato_al(tta.cod_pro_res_1,tta.cod_com_res_1,uci.d_data_mat) nomeStatoResidenza_t1
     , f_ANSC_comune_estero(tta.cod_pro_res_1,tta.cod_com_res_1,uci.d_data_mat) comuneEsteroResidenza_t1
     , decode(tta.sesso_4,'M','o','F','a') genere_t1
     , f_ANSC_id_nazionalita(dci_t1.ist_ci) idNazionalita_t1
     , f_get_descrizione_dci(tta.nazionalita_1,'') nazionalita_t1
     , 'false' flagDichiarante_t1
     , decode(cta.flag_divorzio,'S', 'false', decode(tta.cognome_1||tta.nome_1, '', 'false', decode(uci.natura, 'T', 'false', 'true') ) ) flagFirmatario_t1
     , 'false' flagComparente_t1
  -- testimone_2
     , tta.cognome_2 cognome_t2
     , tta.nome_2 nome_t2
     , tta.sesso_2 sesso_t2
     , decode(tta.sesso_2,'M','maschile','F','femminile') descrizioneSesso_t2
     , to_char(tta.d_data_nas_2,'yyyy-mm-dd') dataNascita_t2
     , f_ANSC_id_comune_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,tta.d_data_nas_2) idComuneNascita_t2
     , f_ANSC_comune_italiano(tta.cod_pro_nas_2,tta.cod_com_nas_2,tta.d_data_nas_2) nomeComuneNascita_t2
     , f_ANSC_id_provincia_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,tta.d_data_nas_2) idProvinciaNascita_t2
     , f_ANSC_provincia_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,tta.d_data_nas_2) siglaProvinciaNascita_t2
     , f_ANSC_id_stato_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,tta.d_data_nas_2) idStatoNascita_t2
     , f_ANSC_stato_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,tta.d_data_nas_2) nomeStatoNascita_t2
     , f_ANSC_comune_estero(tta.cod_pro_nas_2,tta.cod_com_nas_2,tta.d_data_nas_2) comuneEsteroNascita_t2
     , f_ANSC_id_comune_al(tta.cod_pro_res_2,tta.cod_com_res_2,uci.d_data_mat) idComuneResidenza_t2
     , f_ANSC_comune_italiano(tta.cod_pro_res_2,tta.cod_com_res_2,uci.d_data_mat) nomeComuneResidenza_t2
     , f_ANSC_id_provincia_al(tta.cod_pro_res_2,tta.cod_com_res_2,uci.d_data_mat) idProvinciaResidenza_t2
     , f_ANSC_provincia_al(tta.cod_pro_res_2,tta.cod_com_res_2,uci.d_data_mat) siglaProvinciaResidenza_t2
     , f_ANSC_id_stato_al(tta.cod_pro_res_2,tta.cod_com_res_2,uci.d_data_mat) idStatoResidenza_t2
     , f_ANSC_stato_al(tta.cod_pro_res_2,tta.cod_com_res_2,uci.d_data_mat) nomeStatoResidenza_t2
     , f_ANSC_comune_estero(tta.cod_pro_res_2,tta.cod_com_res_2,uci.d_data_mat) comuneEsteroResidenza_t2
     , decode(tta.sesso_4,'M','o','F','a') genere_t2
     , f_ANSC_id_nazionalita(dci_t2.ist_ci) idNazionalita_t2
     , f_get_descrizione_dci(tta.nazionalita_2,'') nazionalita_t2
     , 'false' flagDichiarante_t2
     , decode(cta.flag_divorzio,'S', 'false', decode(tta.cognome_2||tta.nome_2, '', 'false', decode(uci.natura, 'T', 'false', 'true') ) ) flagFirmatario_t2
     , 'false' flagComparente_t2
  -- testimone_3
     , tta.cognome_3 cognome_t3
     , tta.nome_3 nome_t3
     , tta.sesso_3 sesso_t3
     , decode(tta.sesso_3,'M','maschile','F','femminile') descrizioneSesso_t3
     , to_char(tta.d_data_nas_3,'yyyy-mm-dd') dataNascita_t3
     , f_ANSC_id_comune_al(tta.cod_pro_nas_3,tta.cod_com_nas_3,tta.d_data_nas_3) idComuneNascita_t3
     , f_ANSC_comune_italiano(tta.cod_pro_nas_3,tta.cod_com_nas_3,tta.d_data_nas_3) nomeComuneNascita_t3
     , f_ANSC_id_provincia_al(tta.cod_pro_nas_3,tta.cod_com_nas_3,tta.d_data_nas_3) idProvinciaNascita_t3
     , f_ANSC_provincia_al(tta.cod_pro_nas_3,tta.cod_com_nas_3,tta.d_data_nas_3) siglaProvinciaNascita_t3
     , f_ANSC_id_stato_al(tta.cod_pro_nas_3,tta.cod_com_nas_3,tta.d_data_nas_3) idStatoNascita_t3
     , f_ANSC_stato_al(tta.cod_pro_nas_3,tta.cod_com_nas_3,tta.d_data_nas_3) nomeStatoNascita_t3
     , f_ANSC_comune_estero(tta.cod_pro_nas_3,tta.cod_com_nas_3,tta.d_data_nas_3) comuneEsteroNascita_t3
     , f_ANSC_id_comune_al(tta.cod_pro_res_3,tta.cod_com_res_3,uci.d_data_mat) idComuneResidenza_t3
     , f_ANSC_comune_italiano(tta.cod_pro_res_3,tta.cod_com_res_3,uci.d_data_mat) nomeComuneResidenza_t3
     , f_ANSC_id_provincia_al(tta.cod_pro_res_3,tta.cod_com_res_3,uci.d_data_mat) idProvinciaResidenza_t3
     , f_ANSC_provincia_al(tta.cod_pro_res_3,tta.cod_com_res_3,uci.d_data_mat) siglaProvinciaResidenza_t3
     , f_ANSC_id_stato_al(tta.cod_pro_res_3,tta.cod_com_res_3,uci.d_data_mat) idStatoResidenza_t3
     , f_ANSC_stato_al(tta.cod_pro_res_3,tta.cod_com_res_3,uci.d_data_mat) nomeStatoResidenza_t3
     , f_ANSC_comune_estero(tta.cod_pro_res_3,tta.cod_com_res_3,uci.d_data_mat) comuneEsteroResidenza_t3
     , decode(tta.sesso_4,'M','o','F','a') genere_t3
     , f_ANSC_id_nazionalita(dci_t3.ist_ci) idNazionalita_t3
     , f_get_descrizione_dci(tta.nazionalita_3,'') nazionalita_t3
     , 'false' flagDichiarante_t3
     , decode(cta.flag_divorzio,'S', 'false', decode(tta.cognome_3||tta.nome_3, '', 'false', decode(uci.natura, 'T', 'false', 'true') ) ) flagFirmatario_t3
     , 'false' flagComparente_t3
  -- testimone_4
     , tta.cognome_4 cognome_t4
     , tta.nome_4 nome_t4
     , tta.sesso_4 sesso_t4
     , decode(tta.sesso_4,'M','maschile','F','femminile') descrizioneSesso_t4
     , to_char(tta.d_data_nas_4,'yyyy-mm-dd') dataNascita_t4
     , f_ANSC_id_comune_al(tta.cod_pro_nas_4,tta.cod_com_nas_4,tta.d_data_nas_4) idComuneNascita_t4
     , f_ANSC_comune_italiano(tta.cod_pro_nas_4,tta.cod_com_nas_4,tta.d_data_nas_4) nomeComuneNascita_t4
     , f_ANSC_id_provincia_al(tta.cod_pro_nas_4,tta.cod_com_nas_4,tta.d_data_nas_4) idProvinciaNascita_t4
     , f_ANSC_provincia_al(tta.cod_pro_nas_4,tta.cod_com_nas_4,tta.d_data_nas_4) siglaProvinciaNascita_t4
     , f_ANSC_id_stato_al(tta.cod_pro_nas_4,tta.cod_com_nas_4,tta.d_data_nas_4) idStatoNascita_t4
     , f_ANSC_stato_al(tta.cod_pro_nas_4,tta.cod_com_nas_4,tta.d_data_nas_4) nomeStatoNascita_t4
     , f_ANSC_comune_estero(tta.cod_pro_nas_4,tta.cod_com_nas_4,tta.d_data_nas_4) comuneEsteroNascita_t4
     , f_ANSC_id_comune_al(tta.cod_pro_res_4,tta.cod_com_res_4,uci.d_data_mat) idComuneResidenza_t4
     , f_ANSC_comune_italiano(tta.cod_pro_res_4,tta.cod_com_res_4,uci.d_data_mat) nomeComuneResidenza_t4
     , f_ANSC_id_provincia_al(tta.cod_pro_res_4,tta.cod_com_res_4,uci.d_data_mat) idProvinciaResidenza_t4
     , f_ANSC_provincia_al(tta.cod_pro_res_4,tta.cod_com_res_4,uci.d_data_mat) siglaProvinciaResidenza_t4
     , f_ANSC_id_stato_al(tta.cod_pro_res_4,tta.cod_com_res_4,uci.d_data_mat) idStatoResidenza_t4
     , f_ANSC_stato_al(tta.cod_pro_res_4,tta.cod_com_res_4,uci.d_data_mat) nomeStatoResidenza_t4
     , f_ANSC_comune_estero(tta.cod_pro_res_4,tta.cod_com_res_4,uci.d_data_mat) comuneEsteroResidenza_t4
     , decode(tta.sesso_4,'M','o','F','a') genere_t4
     , f_ANSC_id_nazionalita(dci_t4.ist_ci) idNazionalita_t4
     , f_get_descrizione_dci(tta.nazionalita_4,'') nazionalita_t4
     , 'false' flagDichiarante_t4
     , decode(cta.flag_divorzio,'S', 'false', decode(tta.cognome_4||tta.nome_4, '', 'false', decode(uci.natura, 'T', 'false', 'true') ) ) flagFirmatario_t4
     , 'false' flagComparente_t4
-- certificatoCostituzione1
     , f_ANSC_id_provincia_al(dpa.costituzione_uci_cod_pro_1, dpa.costituzione_uci_cod_com_1, '') CC1_idProvincia
     , f_ANSC_provincia_al(dpa.costituzione_uci_cod_pro_1, dpa.costituzione_uci_cod_com_1, '') CC1_siglaProvincia
     , f_ANSC_id_comune_al(dpa.costituzione_uci_cod_pro_1, dpa.costituzione_uci_cod_com_1, '') CC1_comune
     , f_ANSC_comune_al(dpa.costituzione_uci_cod_pro_1, dpa.costituzione_uci_cod_com_1, '') CC1_nomeComune
     , to_char(dpa.d_costituzione_uci_data_1,'yyyy-mm-dd') CC1_data
-- certificatoCostituzione2
     , f_ANSC_id_provincia_al(dpa.costituzione_uci_cod_pro_2, dpa.costituzione_uci_cod_com_2, '') CC2_idProvincia
     , f_ANSC_provincia_al(dpa.costituzione_uci_cod_pro_2, dpa.costituzione_uci_cod_com_2, '') CC2_siglaProvincia
     , f_ANSC_id_comune_al(dpa.costituzione_uci_cod_pro_2, dpa.costituzione_uci_cod_com_2, '') CC2_comune
     , f_ANSC_comune_al(dpa.costituzione_uci_cod_pro_2, dpa.costituzione_uci_cod_com_2, '') CC2_nomeComune
     , to_char(dpa.d_costituzione_uci_data_2,'yyyy-mm-dd') CC2_data
-- luogoCelebrazione
     , nvl(dpa.luogo_uci,'Casa Comunale') luogo
     , f_ANSC_id_comune_al(uci.cod_pro_mat,uci.cod_com_mat,'') idComuneCelebrazione
     , f_ANSC_comune_italiano(uci.cod_pro_mat,uci.cod_com_mat,'') nomeComuneCelebrazione
     , f_ANSC_id_provincia_al(uci.cod_pro_mat,uci.cod_com_mat,'') idProvinciaCelebrazione
     , f_ANSC_provincia_al(uci.cod_pro_mat,uci.cod_com_mat,'') siglaProvinciaCelebrazione
     , f_ANSC_id_stato_al(uci.cod_pro_mat,uci.cod_com_mat,'') idStato
     , f_ANSC_stato_al(uci.cod_pro_mat,uci.cod_com_mat,'') nomeStato
     , f_ANSC_comune_estero(uci.cod_pro_mat,uci.cod_com_mat,'') comuneEsteroCelebrazione
     , dpa.indirizzo_uci indirizzo
     , dpa.civico_uci numeroCivico
-- delegante
     , decode(cta.sigla, 
         'UPD', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd'), 
         'TPD', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd')) DEL_data
     , decode(cta.sigla, 
         'UPD', 'Come da trascrizione contenuta nel corpo dell''atto', 
         'TPD', 'Come da trascrizione contenuta nel corpo dell''atto') DEL_testo
     , decode(cta.sigla, 
         'UPD', f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,''), 
         'TPD', f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_comune
     , decode(cta.sigla, 
         'UPD', f_ANSC_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,''), 
         'TPD', f_ANSC_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_nomeComune
     , decode(cta.sigla, 
         'UPD', f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,''), 
         'TPD', f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_idProvinciaComune
     , decode(cta.sigla, 
         'UPD', f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,''), 
         'TPD', f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_siglaProvinciaComune  
     , decode(cta.sigla, 
         'UPD', f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,''), 
         'TPD', f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_idNazione
     , decode(cta.sigla, 
         'UPD', f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,''), 
         'TPD', f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_nomeNazione
     , decode(cta.sigla,
         'UPD', dpa.id_consolato_ansc_prov,
         'TMD', dpa.id_consolato_ansc_prov) DEL_idAnagraficaConsolato
     , decode(cta.sigla,
         'UPD', t97.descrizione,
         'TMD', t97.descrizione) DEL_nomeAnagraficaConsolato
  -- regimePatrimoniale
     , f_ANSC_regime_patrimoniale(uci.convenzioni, mar.scelta_conv) tipo                     -- anst49
     , 'false' attoNotarile
     , decode(mar.scelta_conv, 2, mar.legge_conv) legge
     , to_char(null) nomeNotaio
     , to_char(null) cognomeNotaio
     , to_char(null) distrettoNotarile
     , to_char(null) dataAttoNotarile
     , to_char(null) presenzaMinori
     , to_char(null) assistenzaMinori
-- 
     , decode(dpa.segretario_utente, '', '', 1) ruoloSegretario
  -- segretarioComunale
     , decode(dpa.segretario_utente, '', '', f_ANSC_cognome_segretario(dpa.segretario_utente,'')) SEG_cognome
     , decode(dpa.segretario_utente, '', '', f_ANSC_nome_segretario(dpa.segretario_utente,'')) SEG_nome
     , 'false' SEG_flagDichiarante
     , 'false' SEG_flagComparente
     , decode(dpa.segretario_utente, '', 'false', 'true') SEG_flagFirmatario
  -- interprete
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
     , f_ANSC_id_comune_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,uci.d_data_mat) ITP_idComuneResidenza
     , f_ANSC_comune_italiano(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,uci.d_data_mat) ITP_nomeComuneResidenza
     , f_ANSC_id_provincia_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,uci.d_data_mat) ITP_idProvinciaResidenza
     , f_ANSC_provincia_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,uci.d_data_mat) ITP_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,uci.d_data_mat) ITP_idStatoResidenza
     , f_ANSC_stato_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,uci.d_data_mat) ITP_nomeStatoResidenza
     , f_ANSC_comune_estero(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,uci.d_data_mat) ITP_comuneEsteroResidenza
     , decode(sog_ITP.sesso,'M','o','F','a') ITP_genere
     , f_ANSC_id_nazionalita(dci_itp.ist_ci) ITP_idNazionalita
     , f_get_descrizione_dci(sog_ITP.nazionalita,'') ITP_nazionalita
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'IT') ITP_flagDichiarante
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'IT') ITP_flagComparente
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'IT') ITP_flagFirmatario
-- Trascrizione unione civile
     , decode(dpa.tipo_atto, 4, '2', -4, '1') tipoTrascrizione -- anst55
     , f_ANSC_tipo_dichiarazione(-4, cta.sigla, uci.id_usecase_ansc, dpa.tipo_richiesta_trascrizione) TRA_tipoRichiestaTrascrizione	-- ANST38
  -- Autorità mittente
     , decode(dpa.nota_rif||dpa.anno_nota_rif,'',to_char(null),dpa.nota_rif||'/'||dpa.anno_nota_rif) TRA_estremiDocumento
     , dpa.autorita_prov TRA_nomeEnte
     , f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') TRA_idComuneEnte
     , f_ANSC_comune_italiano(dpa.cod_pro_prov,dpa.cod_com_prov,'') TRA_nomeComuneEnte
     , f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') TRA_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') TRA_siglaProvinciaEnte
     , f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') TRA_nazioneEnte
     , f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') TRA_nomeNazioneEnte
     , f_ANSC_comune_estero(dpa.cod_pro_prov,dpa.cod_com_prov,'') TRA_comuneEsteroEnte
     , decode(cta.sigla, 'TEP', to_char(dpa.d_data_richiesta_trascrizione,'yyyy-mm-dd')
                       , 'TEA', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd')
                              , to_char(nvl(dpa.d_data_nota_rif,dpa.d_ente_straniero_data_atto),'yyyy-mm-dd') ) TRA_dataComunicazione
     , 'Come da trascrizione contenuta nel corpo dell''atto' TRA_testoLibero
     , dpa.id_consolato_ansc_prov TRA_idAnagraficaConsolato
     , t97.descrizione TRA_nomeAnagraficaConsolato
  -- 
     , to_char(null) MIT_ruoloEnteDichiarante
     , to_char(null) MIT_nomeEnte
  -- Atto da trascrivere
     , case when cta.sigla in ('TEP', 'TEA') then to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd') else to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') end EST_dataTrascrizione
     , to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd') EST_dataComunicazione
     , dpa.ente_straniero_estremi_atto EST_estremiDocumento
     , dpa.ente_straniero EST_nomeEnte
     , f_ANSC_id_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idComuneEnte
     , f_ANSC_comune_italiano(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nomeComuneEnte
     , f_ANSC_id_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_siglaProvinciaEnte
     , f_ANSC_id_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nazioneEnte
     , f_ANSC_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nomeNazioneEnte
     , f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_comuneEsteroEnte
     , to_char(null) EST_idAnagraficaConsolato
     , to_char(null) EST_nomeAnagraficaConsolato
-- composizioneCompleta
     , tli.riga_clob composizioneCompleta
-- separazione
-- scioglimentoUnioneCivile
     , decode(cta.flag_divorzio,'S', f_ANSC_tipo_accordo(dpa.tipo_divorzio,dpa.tipo_divorzio_altro)) SCI_tipoAccordo 
     , decode(cta.flag_divorzio,'S', decode(dpa.flag_giudizio_pendente,'S', 'true', 'false')) parteInGiudizioPendente
     , decode(cta.flag_divorzio,'S', decode(dpa.flag_giudizio_pendente,'S', dpa.autorita_giud_ente))  autoritaGiudiziaria
     , decode(cta.flag_divorzio,'S', decode(dpa.dati_assegno_divorzio, '', 'false', 'true'))  assegnoMantenimento
     , decode(cta.flag_divorzio,'S', dpa.dati_assegno_divorzio) datiAssegnoMantenimento
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_conferma_data, 'yyyy-mm-dd')) SCI_dataConfermaAccordo
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_comparente(dpa.tipo_comparente,'A1')) presenzaAvvocatoConiuge1 
     , decode(cta.flag_divorzio,'S', dpa.foro_avvocato_sposo) foroAvvocatoConiuge1
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_comparente(dpa.tipo_comparente,'A2')) presenzaAvvocatoConiuge2 
     , decode(cta.flag_divorzio,'S', dpa.foro_avvocato_sposa) foroAvvocatoConiuge2
--
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd')) SCI_dataComunicazione
     , decode(cta.flag_divorzio,'S', dpa.nota_rif) SCI_raccomandataAR
     , decode(cta.flag_divorzio,'S', 'indirizzo comunicazione') SCI_indirizzoComunicazione
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_data_protocollo,'yyyy-mm-dd')) SCI_dataRicezione
  -- accordoScioglimento
     , decode(cta.flag_divorzio,'S', dpa.accordo_id_atto_ansc) SCI_idAttoAnsc_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.ACCORDO_TIPO, 
                                                   'U', f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,''),
                                                   'A', f_ANSC_id_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, ''))) SCI_idProvReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.ACCORDO_TIPO, 
                                                   'U', f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,''),
                                                   'A', f_ANSC_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, ''))) SCI_siglaProvReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.ACCORDO_TIPO, 
                                                   'U', f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,''),
                                                   'A', f_ANSC_id_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, ''))) SCI_idComuneReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.ACCORDO_TIPO, 
                                                   'U', f_ANSC_comune_al(m.cod_provincia,m.cod_comune,''),
                                                   'A', f_ANSC_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, ''))) SCI_nomeComuneReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_atto, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'NUMERO_COMUNALE'))) SCI_numeroAtto_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_anno, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'ANNO'))) SCI_annoAtto_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_parte)) SCI_parte_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_serie)) SCI_serie_ACC
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_accordo_data, 'yyyy-mm-dd')) SCI_dataFormazione_ACC
     , decode(cta.flag_divorzio,'S', '4') SCI_tipologia_ACC
     , decode(cta.flag_divorzio,'S', '1') SCI_idtipocontenuto_ACC
  -- attoUnioneCivile
     , decode(cta.flag_divorzio,'S', spo.id_atto_ansc_mat) SCI_idAttoAnsc_UCI
     , decode(cta.flag_divorzio,'S', f_ANSC_id_provincia_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '')) SCI_idProvinciaReg_UCI
     , decode(cta.flag_divorzio,'S', f_ANSC_provincia_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '')) SCI_siglaProvinciaReg_UCI
     , decode(cta.flag_divorzio,'S', f_ANSC_id_comune_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '')) SCI_idComuneReg_UCI 
     , decode(cta.flag_divorzio,'S', f_ANSC_comune_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '')) SCI_nomeComuneReg_UCI 
     , decode(cta.flag_divorzio,'S', '1') SCI_idTipoContenuto_UCI 
     , decode(cta.flag_divorzio,'S', decode(spo.id_atto_ansc_mat, '', spo.atto_mat, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_mat,'NUMERO_COMUNALE') ) ) SCI_numeroAtto_UCI
     , decode(cta.flag_divorzio,'S', decode(spo.id_atto_ansc_mat, '', spo.anno_atto_mat, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_mat,'ANNO') ) ) SCI_annoAtto_UCI
     , decode(cta.flag_divorzio,'S', to_char(spo.d_data_atto_mat, 'yyyy-mm-dd')) SCI_dataformazione_UCI
     , decode(cta.flag_divorzio,'S', '4') SCI_tipologia_UCI
     , decode(cta.flag_divorzio,'S', decode(spo.id_atto_ansc_mat, '', spo.parte_mat) ) SCI_parte_UCI
     , decode(cta.flag_divorzio,'S', decode(spo.id_atto_ansc_mat, '', spo.serie_mat) ) SCI_serie_UCI
  --attoSeparazione
     , decode(cta.flag_divorzio,'S', f_ANSC_id_provincia_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '') ) SCI_idProvRegistrazione
     , decode(cta.flag_divorzio,'S', f_ANSC_provincia_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '') ) SCI_siglaProvRegistrazione 
     , decode(cta.flag_divorzio,'S', f_ANSC_id_comune_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '') ) SCI_idComuneRegistrazione  
     , decode(cta.flag_divorzio,'S', f_ANSC_comune_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '') ) SCI_nomeComuneRegistrazione 
     , decode(cta.flag_divorzio,'S', '1' ) SCI_idtipocontenuto 
     , decode(cta.flag_divorzio,'S', dpa.separazione_estremi_doc ) SCI_numeroatto 
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_separazione_data_doc, 'yyyy') ) SCI_annoAtto 
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_separazione_data_doc, 'yyyy-mm-dd')) SCI_dataformazione 
     , decode(cta.flag_divorzio,'S', '4') SCI_tipologia 
  -- provvedimentoSeparazione
     , to_char(null) SCI_dataTrascrizione  	
     , to_char(null) SCI_estremiDocumento	
     , to_char(null) SCI_nomeEnte  		
     , to_char(null) SCI_idProvinciaEnte	
     , to_char(null) SCI_siglaProvinciaEnte	
     , to_char(null) SCI_idComuneEnte 		
     , to_char(null) SCI_nomeComuneEnte 	
     , to_char(null) SCI_modificaAccordo	
  -- accordoSeparazione
     , decode(cta.flag_divorzio,'S', dpa.accordo_id_atto_ansc) SEP_idAttoAnsc_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.ACCORDO_TIPO, 
                                                   'U', f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,''),
                                                   'A', f_ANSC_id_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, ''))) SEP_idProvReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.ACCORDO_TIPO, 
                                                   'U', f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,''),
                                                   'A', f_ANSC_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, ''))) SEP_siglaProvReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.ACCORDO_TIPO, 
                                                   'U', f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,''),
                                                   'A', f_ANSC_id_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, ''))) SEP_idComuneReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.ACCORDO_TIPO, 
                                                   'U', f_ANSC_comune_al(m.cod_provincia,m.cod_comune,''),
                                                   'A', f_ANSC_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, ''))) SEP_nomeComuneReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_atto, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'NUMERO_COMUNALE'))) SEP_numeroAtto_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_anno, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'ANNO'))) SEP_annoAtto_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_parte)) SEP_parte_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_serie)) SEP_serie_ACC
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_accordo_data, 'yyyy-mm-dd')) SEP_dataFormazione_ACC
     , decode(cta.flag_divorzio,'S', '4') SEP_tipologia_ACC
     , decode(cta.flag_divorzio,'S', '1') SEP_idtipocontenuto_ACC
--presenzaConiugi
     , f_ANSC_flag_comparente(dpa.tipo_comparente, 'C1') presenzaConiuge1
     , f_ANSC_flag_comparente(dpa.tipo_comparente, 'C2') presenzaConiuge2
-- avvocatoConiuge1
     , decode(cta.flag_divorzio,'S', dpa.avvocato_sposo_cognome) AV1_cognome
     , decode(cta.flag_divorzio,'S', dpa.avvocato_sposo_nome) AV1_nome
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'A1')) AV1_flagDichiarante
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_comparente(dpa.tipo_comparente,'A1')) AV1_flagComparente
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_firmatario(dpa.tipo_firmatario,'A1')) AV1_flagFirmatario
-- avvocatoConiuge2
     , decode(cta.flag_divorzio,'S', dpa.avvocato_sposa_cognome) AV2_cognome
     , decode(cta.flag_divorzio,'S', dpa.avvocato_sposa_nome) AV2_nome
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'A2')) AV2_flagDichiarante
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_comparente(dpa.tipo_comparente,'A2')) AV2_flagComparente
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_firmatario(dpa.tipo_firmatario,'A2')) AV2_flagFirmatario
--dichiarante
     , dpa.nome_dic DIC_nome
     , dpa.cognome_dic DIC_cognome
     , dpa.sesso_dic DIC_sesso
     , to_char(dpa.d_data_nas_dic,'yyyy-mm-dd') DIC_dataNascita
     , f_ANSC_id_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) DIC_idComuneNascita
     , f_ANSC_comune_italiano(dpa.cod_pro_nas_dic,dpa.COD_COM_NAS_DIC,dpa.d_data_nas_dic) DIC_nomeComuneNascita
     , f_ANSC_id_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) DIC_idProvinciaNascita
     , f_ANSC_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) DIC_siglaProvinciaNascita
     , f_ANSC_id_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) DIC_idStatoNascita
     , f_ANSC_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) DIC_nomeStatoNascita
     , f_ANSC_comune_estero(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic) DIC_comuneEsteroNascita
     , f_ANSC_id_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat) DIC_idComuneResidenza
     , f_ANSC_comune_italiano(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat) DIC_nomeComuneResidenza
     , f_ANSC_id_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat) DIC_idProvinciaResidenza
     , f_ANSC_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat) DIC_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat) DIC_idStatoResidenza
     , f_ANSC_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat) DIC_nomeStatoResidenza
     , f_ANSC_comune_estero(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat) DIC_comuneEsteroResidenza
     , f_get_descrizione_DCI(dpa.nazionalita_dic, '') DIC_nazionalita
     , f_ANSC_id_nazionalita(dci_dic.ist_ci) DIC_idNazionalita
     , 'true' DIC_flagDichiarante
     , 'true' DIC_flagComparente
     -- nelle TEP cdu 431000 la presenza di firmatari non dipende più dal tipo richiesta ma da campo in maschera
     , decode( cta.sigla,
                   'TEP', decode (dpa.tipo_firmatario, 'NE', 'false', 'true'),
                   decode(dpa.cognome_dic||dpa.nome_dic, '', 'false', 'true') ) DIC_flagFirmatario
-- ANSC
     , uci.id_atto_ansc idAttoAnsc
     , uci.id_evento_ansc idEventoAnsc
     , uci.id_soggetto_ansc_m idSoggettoAnsc_1
     , uci.id_soggetto_ansc_f idSoggettoAnsc_2
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_1,ana_r.matricola_1),uci.cod_fiscale_m) idSoggettoAnpr_1
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_1,ana_r.matricola_1),uci.cod_fiscale_m) idUnicoAnpr_1
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_2,ana_r.matricola_2),uci.cod_fiscale_f) idSoggettoAnpr_2
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_2,ana_r.matricola_2),uci.cod_fiscale_f) idUnicoAnpr_2
     , to_char(null) forcingCode
  from arccom m
     , anst03 t03
     , anst97 t97
     , civana ana
     , civana_recupero ana_r
     , civsog sog_ITP
     , anadci dci_itp
     , anadci dci_dic
     , anadci dci_t4
     , anadci dci_t3
     , anadci dci_t2
     , anadci dci_t1
     , anadci dci_m
     , anadci dci_f
     , civpdo pdo
     , civtta tta
     , civtli_v tli
     , civspo spo
     , civmar mar
     , civdpa dpa
     , civocc occ
     , civcta cta
     , civdta dta
     , civuci uci
 where (m.cod_provincia,m.cod_comune)    = (select pro_cliente, com_cliente from menuditta)
   and ana.id_atto                   (+) = uci.id_atto
   and ana_r.id_atto                 (+) = uci.id_atto
   and t03.id                        (+) = uci.id_usecase_ansc
   and t97.id                        (+) = dpa.id_consolato_ansc_prov
   and sog_ITP.id_atto               (+) = uci.id_atto
   and sog_ITP.tipo_soggetto         (+) = 'IT'	
   and dci_dic.cod_ci                (+) = dpa.nazionalita_dic
   and dci_itp.cod_ci                (+) = sog_ITP.nazionalita
   and dci_t4.cod_ci                 (+) = tta.nazionalita_4
   and dci_t3.cod_ci                 (+) = tta.nazionalita_3
   and dci_t2.cod_ci                 (+) = tta.nazionalita_2
   and dci_t1.cod_ci                 (+) = tta.nazionalita_1
   and dci_f.cod_ci                  (+) = uci.nazionalita_f
   and dci_m.cod_ci                  (+) = uci.nazionalita_m
   and pdo.id_atto                   (+) = uci.id_atto
   and tta.id_atto                   (+) = uci.id_atto
   and spo.id_atto                   (+) = uci.id_atto
   and mar.id_atto                   (+) = uci.id_atto
   and tli.id_atto                   (+) = uci.id_atto
   and occ.id_atto                   (+) = uci.id_atto
   and cta.id                            = dta.id_civcta
   and dta.id                            = uci.id_civdta
   and dpa.id_atto                   (+) = uci.id_atto
   and uci.cod_rec                 in (0,3)
/
comment on table CIVUCI_V_JSON is 'ANSC - Atti di Unione Civile per request JSON (view)'
/
