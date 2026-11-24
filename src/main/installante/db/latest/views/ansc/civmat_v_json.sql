--liquibase formatted sql
--changeset amonopoli:202305181240_2 runAlways:true runOnChange:true stripComments:false
create or replace view civmat_v_json as
select mat.id
     , mat.id_atto
     , mat.ufficio
     , mat.anno
     , mat.parte
     , mat.serie
     , mat.atto
-- evento
     , f_ANSC_valore_inp('ID_VERSION',1,10,'9','') idVersion
     , '3' idTipoEvento				-- (anst01) 1 - NASCITA / 2 - MORTE / 3 - MATRIMONIO / 4 - UNIONE CIVILE / 5 - CITTADINANZA
     , f_ANSC_id_tipo_contenuto(t03.tipo_atto_ansc,mat.natura,to_char(null)) idTipoContenuto	 -- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , '1' datiProdotti
     , mat.id_usecase_ansc idUseCase		-- (anst03)
     , t03.descrizione  descrizioneCasoUso	-- (anst03)
     , decode(f_ANSC_flag_firmato('MAT', mat.id, 'USC'), 'S', 'FIRMATO DA USC', 'CONFERMATO') stato   			-- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , 'FIRMATO DA USC' stato_firmatoUSC   	-- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') dataFormazione
     , to_char(dpa.d_data_atto_utente,'yyyy') annoAtto
     , to_char(dpa.d_data_atto_utente,'mm') meseAtto
     , to_char(dpa.d_data_atto_utente,'dd') giornoAtto
     , lpad(dpa.ore_atto_utente, 2, '0') ora
     , lpad(dpa.minuti_atto_utente, 2, '0') minuto
     , to_char(f_ANSC_data_validita(4,cta.sigla,mat.natura,mat.d_data_mat,dpa.d_data_atto_utente),'yyyy-mm-dd') dataValidita
     , mat.numero_unico numeroatto
     , f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,'') idComuneRegistrazione
     , f_ANSC_comune_al(m.cod_provincia,m.cod_comune,'') nomeComuneRegistrazione
     , f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,'') idProvinciaRegistrazione
     , f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,'') siglaProvinciaRegistrazione
     , f_ANSC_id_operatore(mat.terminalista) operatore
     , f_ANSC_ruolo_operatore(dpa.qualifica_utente) ruoloOperatore
     , f_ANSC_nome_operatore(mat.terminalista) operatoreNome
     , f_ANSC_cognome_operatore(mat.terminalista) operatoreCognome
     , 'true' redattoNellaCasaComunale
     , to_char(null) tipoDichiarante
     , f_ANSC_ausilio_interprete(dpa.tipo_comparente) ausilioInterprete
     , f_ANSC_motivo_recupero(mat.motivo_recupero_ansc) motivoRecupero            -- (anst96)
     , decode(mat.motivo_recupero_ansc,'','',to_char(dpa.d_data_atto_utente,'yyyy-mm-dd')) dataDecorrenza
     , decode(mat.natura, 'D', 'false', 'true') flagCertificatoSemplice
     , decode(mat.natura, 'D', 'false', 'true') flagEstrattoPerRiassunto
-- sposo
     , nvl(occ.cognome,mat.cognome_m) cognome_m
     , nvl(occ.nome,mat.nome_m) nome_m
     , 'M' sesso_m
     , to_char(mat.d_data_nas_m,'yyyy-mm-dd') dataNascita_m
     , f_ANSC_id_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) idComuneNascita_m
     , f_ANSC_comune_italiano(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) nomeComuneNascita_m
     , f_ANSC_id_provincia_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) idProvinciaNascita_m
     , f_ANSC_provincia_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) siglaProvinciaNascita_m
     , f_ANSC_id_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) idStatoNascita_m
     , f_ANSC_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) nomeStatoNascita_m
     , f_ANSC_comune_estero(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) comuneEsteroNascita_m
     , f_ANSC_comprensione(mat.comprensione_m) comprensione_m
     , mat.motivo_impedimento_m motivoImpedimentoScrittura_m
     , decode( cta.sigla, 'PDV', f_ANSC_flag_pericolo_vita(dpa.impossibilitato_uci, 'SO')) sposoInPericoloVita
     , decode( cta.sigla, 'PDV', 'Accertamento') accertamentoVolontaSposo
-- attoNascitaSposo
     , spo.id_atto_ansc_nas_m NAS_idAttoAnsc_m
     , f_ANSC_id_provincia_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,'') NAS_idProvinciaReg_m
     , f_ANSC_provincia_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,'') NAS_siglaProvinciaReg_m
     , f_ANSC_id_comune_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,'') NAS_idComuneReg_m
     , f_ANSC_comune_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,'') NAS_nomeComuneReg_m
     , '1' NAS_idtipocontenuto_m              	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(spo.id_atto_ansc_nas_m, '', spo.atto_nas_m, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_nas_m,'NUMERO_COMUNALE'))  NAS_numeroatto_m
     , decode(spo.id_atto_ansc_nas_m, '', spo.anno_atto_nas_m, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_nas_m,'ANNO')) NAS_annoAtto_m
     , to_char(null) NAS_dataformazione_m
     , '1' NAS_tipologia_m
     , decode(spo.id_atto_ansc_nas_m, '', spo.parte_nas_m) NAS_parte_m
     , decode(spo.id_atto_ansc_nas_m, '', spo.serie_nas_m) NAS_serie_m
-- sposa
     , nvl(occ.cognome_cn,mat.cognome_f) cognome_f
     , nvl(occ.nome_cn,mat.nome_f) nome_f
     , 'F' sesso_f
     , to_char(mat.d_data_nas_f,'yyyy-mm-dd') dataNascita_f
     , f_ANSC_id_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) idComuneNascita_f
     , f_ANSC_comune_italiano(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) nomeComuneNascita_f
     , f_ANSC_id_provincia_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) idProvinciaNascita_f
     , f_ANSC_provincia_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) siglaProvinciaNascita_f
     , f_ANSC_id_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) idStatoNascita_f
     , f_ANSC_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) nomeStatoNascita_f
     , f_ANSC_comune_estero(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) comuneEsteroNascita_f
     , f_ANSC_comprensione(mat.comprensione_f) comprensione_f
     , mat.motivo_impedimento_f motivoImpedimentoScrittura_f
     , decode( cta.sigla, 'PDV', f_ANSC_flag_pericolo_vita(dpa.impossibilitato_uci, 'SA')) sposaInPericoloVita
     , decode( cta.sigla, 'PDV', 'Accertamento') accertamentoVolontaSposa
-- attoNascitaSposa
     , spo.id_atto_ansc_nas_f NAS_idAttoAnsc_f
     , f_ANSC_id_provincia_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,'') NAS_idProvinciaReg_f
     , f_ANSC_provincia_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,'') NAS_siglaProvinciaReg_f
     , f_ANSC_id_comune_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,'') NAS_idComuneReg_f
     , f_ANSC_comune_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,'') NAS_nomeComuneReg_f
     , '1' NAS_idtipocontenuto_f              	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(spo.id_atto_ansc_nas_f, '', spo.atto_nas_f, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_nas_f,'NUMERO_COMUNALE')) NAS_numeroatto_f
     , decode(spo.id_atto_ansc_nas_f, '', spo.anno_atto_nas_f, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_nas_f,'ANNO')) NAS_annoAtto_f
     , to_char(null) NAS_dataformazione_f
     , '1' NAS_tipologia_f
     , decode(spo.id_atto_ansc_nas_f, '', spo.parte_nas_f) NAS_parte_f
     , decode(spo.id_atto_ansc_nas_f, '', spo.serie_nas_f) NAS_serie_f
-- officiante
     , case when cta.sigla in ('TEP', 'TEA', 'UAC', 'UCO', 'UAL', 'AVV')  then '' else f_ANSC_officiante(dpa.tipo_atto, dpa.id_atto, '') end officiante
-- officianteEvento
     , case
          when cta.sigla in ('TEP', 'TEA', 'UAC', 'UCO', 'UAL', 'AVV')  then ''
          else decode(cta.sigla,
                 'CPD', f_ANSC_nome_officiante(dpa.ufficiale_utente, ''),
                 f_ANSC_nome_officiante(COALESCE(replace(replace(dpa.ministro_art,'suddetto parroco',''),'SUDDETTO PARROCO',''), dpa.ministro, dpa.ufficiale_prov, dpa.ufficiale_utente),''))
       end OFF_nome
     , case
          when cta.sigla in ('TEP', 'TEA', 'UAC', 'UCO', 'UAL', 'AVV')  then ''
          else decode(cta.sigla,
                 'CPD', f_ANSC_cognome_officiante(dpa.ufficiale_utente, ''),
                        f_ANSC_cognome_officiante(COALESCE(replace(replace(dpa.ministro_art,'suddetto parroco',''),'SUDDETTO PARROCO',''), dpa.ministro, dpa.ufficiale_prov, dpa.ufficiale_utente),''))
          end OFF_cognome
     , 'false' OFF_flagDichiarante
     , 'false' OFF_flagComparente
     , case when cta.sigla in ('O1', 'FCC', 'PDV', 'CPD') then 'true' else 'false' end OFF_flagFirmatario
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
     , f_ANSC_id_comune_al(tta.cod_pro_res_1,tta.cod_com_res_1,mat.d_data_mat) idComuneResidenza_t1
     , f_ANSC_comune_italiano(tta.cod_pro_res_1,tta.cod_com_res_1,mat.d_data_mat) nomeComuneResidenza_t1
     , f_ANSC_id_provincia_al(tta.cod_pro_res_1,tta.cod_com_res_1,mat.d_data_mat) idProvinciaResidenza_t1
     , f_ANSC_provincia_al(tta.cod_pro_res_1,tta.cod_com_res_1,mat.d_data_mat) siglaProvinciaResidenza_t1
     , f_ANSC_id_stato_al(tta.cod_pro_res_1,tta.cod_com_res_1,mat.d_data_mat) idStatoResidenza_t1
     , f_ANSC_stato_al(tta.cod_pro_res_1,tta.cod_com_res_1,mat.d_data_mat) nomeStatoResidenza_t1
     , f_ANSC_comune_estero(tta.cod_pro_res_1,tta.cod_com_res_1,mat.d_data_mat) comuneEsteroResidenza_t1
     , decode(tta.sesso_4,'M','o','F','a') genere_t1
     , f_ANSC_id_nazionalita(dci_t1.ist_ci) idNazionalita_t1
     , f_get_descrizione_dci(tta.nazionalita_1,'') nazionalita_t1
     , 'false' flagDichiarante_t1
     , decode(cta.flag_divorzio,'S', 'false', decode(tta.cognome_1||tta.nome_1, '', 'false', decode(mat.natura, 'T', 'false', 'true') ) ) flagFirmatario_t1
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
     , f_ANSC_id_comune_al(tta.cod_pro_res_2,tta.cod_com_res_2,mat.d_data_mat) idComuneResidenza_t2
     , f_ANSC_comune_italiano(tta.cod_pro_res_2,tta.cod_com_res_2,mat.d_data_mat) nomeComuneResidenza_t2
     , f_ANSC_id_provincia_al(tta.cod_pro_res_2,tta.cod_com_res_2,mat.d_data_mat) idProvinciaResidenza_t2
     , f_ANSC_provincia_al(tta.cod_pro_res_2,tta.cod_com_res_2,mat.d_data_mat) siglaProvinciaResidenza_t2
     , f_ANSC_id_stato_al(tta.cod_pro_res_2,tta.cod_com_res_2,mat.d_data_mat) idStatoResidenza_t2
     , f_ANSC_stato_al(tta.cod_pro_res_2,tta.cod_com_res_2,mat.d_data_mat) nomeStatoResidenza_t2
     , f_ANSC_comune_estero(tta.cod_pro_res_2,tta.cod_com_res_2,mat.d_data_mat) comuneEsteroResidenza_t2
     , decode(tta.sesso_4,'M','o','F','a') genere_t2
     , f_ANSC_id_nazionalita(dci_t2.ist_ci) idNazionalita_t2
     , f_get_descrizione_dci(tta.nazionalita_2,'') nazionalita_t2
     , 'false' flagDichiarante_t2
     , decode(cta.flag_divorzio,'S', 'false', decode(tta.cognome_2||tta.nome_2, '', 'false', decode(mat.natura, 'T', 'false', 'true') ) ) flagFirmatario_t2
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
     , f_ANSC_id_comune_al(tta.cod_pro_res_3,tta.cod_com_res_3,mat.d_data_mat) idComuneResidenza_t3
     , f_ANSC_comune_italiano(tta.cod_pro_res_3,tta.cod_com_res_3,mat.d_data_mat) nomeComuneResidenza_t3
     , f_ANSC_id_provincia_al(tta.cod_pro_res_3,tta.cod_com_res_3,mat.d_data_mat) idProvinciaResidenza_t3
     , f_ANSC_provincia_al(tta.cod_pro_res_3,tta.cod_com_res_3,mat.d_data_mat) siglaProvinciaResidenza_t3
     , f_ANSC_id_stato_al(tta.cod_pro_res_3,tta.cod_com_res_3,mat.d_data_mat) idStatoResidenza_t3
     , f_ANSC_stato_al(tta.cod_pro_res_3,tta.cod_com_res_3,mat.d_data_mat) nomeStatoResidenza_t3
     , f_ANSC_comune_estero(tta.cod_pro_res_3,tta.cod_com_res_3,mat.d_data_mat) comuneEsteroResidenza_t3
     , decode(tta.sesso_4,'M','o','F','a') genere_t3
     , f_ANSC_id_nazionalita(dci_t3.ist_ci) idNazionalita_t3
     , f_get_descrizione_dci(tta.nazionalita_3,'') nazionalita_t3
     , 'false' flagDichiarante_t3
     , decode(cta.flag_divorzio,'S', 'false', decode(tta.cognome_3||tta.nome_3, '', 'false', decode(mat.natura, 'T', 'false', 'true') ) ) flagFirmatario_t3
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
     , f_ANSC_id_comune_al(tta.cod_pro_res_4,tta.cod_com_res_4,mat.d_data_mat) idComuneResidenza_t4
     , f_ANSC_comune_italiano(tta.cod_pro_res_4,tta.cod_com_res_4,mat.d_data_mat) nomeComuneResidenza_t4
     , f_ANSC_id_provincia_al(tta.cod_pro_res_4,tta.cod_com_res_4,mat.d_data_mat) idProvinciaResidenza_t4
     , f_ANSC_provincia_al(tta.cod_pro_res_4,tta.cod_com_res_4,mat.d_data_mat) siglaProvinciaResidenza_t4
     , f_ANSC_id_stato_al(tta.cod_pro_res_4,tta.cod_com_res_4,mat.d_data_mat) idStatoResidenza_t4
     , f_ANSC_stato_al(tta.cod_pro_res_4,tta.cod_com_res_4,mat.d_data_mat) nomeStatoResidenza_t4
     , f_ANSC_comune_estero(tta.cod_pro_res_4,tta.cod_com_res_4,mat.d_data_mat) comuneEsteroResidenza_t4
     , decode(tta.sesso_4,'M','o','F','a') genere_t4
     , f_ANSC_id_nazionalita(dci_t4.ist_ci) idNazionalita_t4
     , f_get_descrizione_dci(tta.nazionalita_4,'') nazionalita_t4
     , 'false' flagDichiarante_t4
     , decode(cta.flag_divorzio,'S', 'false', decode(tta.cognome_4||tta.nome_4, '', 'false', decode(mat.natura, 'T', 'false', 'true') ) ) flagFirmatario_t4
     , 'false' flagComparente_t4
-- pubblicazioni
     , f_ANSC_id_provincia_al(mar.cod_pro_aff_1, mar.cod_com_aff_1, '') PU1_idProvincia
     , f_ANSC_provincia_al(mar.cod_pro_aff_1, mar.cod_com_aff_1, '') PU1_provincia
     , f_ANSC_id_comune_al(mar.cod_pro_aff_1, mar.cod_com_aff_1, '') PU1_idComune
     , f_ANSC_comune_italiano(mar.cod_pro_aff_1, mar.cod_com_aff_1, '') PU1_comune
     , f_ANSC_id_stato_al(mar.cod_pro_aff_1, mar.cod_com_aff_1, '') PU1_idNazione
     , f_ANSC_stato_al(mar.cod_pro_aff_1, mar.cod_com_aff_1, '') PU1_nomeNazione
     , mar.id_consolato_ansc_aff_1 PU1_idAnagraficaConsolato
     , t97_aff_1.descrizione PU1_nomeAnagraficaConsolato
     , to_char(mar.d_da_data_aff_1,'yyyy-mm-dd') PU1_dataInizio
     , to_char(mar.d_a_data_aff_1,'yyyy-mm-dd') PU1_dataFine
-- pubblicazioni altro comune
     , 'false' riduzioneTerminiPubblicazione
     , f_ANSC_id_provincia_al(mar.cod_pro_aff_2, mar.cod_com_aff_2, '') PU2_idProvincia
     , f_ANSC_provincia_al(mar.cod_pro_aff_2, mar.cod_com_aff_2, '') PU2_provincia
     , f_ANSC_id_comune_al(mar.cod_pro_aff_2, mar.cod_com_aff_2, '') PU2_idComune
     , f_ANSC_comune_italiano(mar.cod_pro_aff_2, mar.cod_com_aff_2, '') PU2_comune
     , f_ANSC_id_stato_al(mar.cod_pro_aff_2, mar.cod_com_aff_2, '') PU2_idNazione
     , f_ANSC_stato_al(mar.cod_pro_aff_2, mar.cod_com_aff_2, '') PU2_nomeNazione
     , mar.id_consolato_ansc_aff_2 PU2_idAnagraficaConsolato
     , t97_aff_2.descrizione PU2_nomeAnagraficaConsolato
     , to_char(mar.d_da_data_aff_2,'yyyy-mm-dd') PU2_dataInizio
     , to_char(mar.d_a_data_aff_2,'yyyy-mm-dd') PU2_dataFine
-- riconciliazione
     , decode(cta.sigla, 'RCN', spo.officiante_mat) RCN_officianteEventoMatrimonio
     , decode(cta.sigla, 'RCN', to_char(spo.d_data_mat, 'yyyy-mm-dd')) RCN_dataEventoMatrimonio
  -- attoMatrimonio
     , decode(cta.sigla, 'RCN', spo.id_atto_ansc_mat) RCN_idAttoAnsc_MAT
     , decode(cta.sigla, 'RCN', f_ANSC_id_provincia_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat,'')) RCN_idProvinciaReg_MAT
     , decode(cta.sigla, 'RCN', f_ANSC_provincia_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat,'')) RCN_siglaProvinciaReg_MAT
     , decode(cta.sigla, 'RCN', f_ANSC_id_comune_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat,'')) RCN_idComuneReg_MAT
     , decode(cta.sigla, 'RCN', f_ANSC_comune_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat,'')) RCN_nomeComuneReg_MAT
     , decode(cta.sigla, 'RCN', '1') RCN_idtipocontenuto_MAT  	-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , decode(cta.sigla, 'RCN', decode(spo.id_atto_ansc_mat, '', spo.atto_mat, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_mat,'NUMERO_COMUNALE') ) ) RCN_numeroatto_MAT
     , decode(cta.sigla, 'RCN', decode(spo.id_atto_ansc_mat, '', spo.anno_atto_mat, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_mat,'ANNO') ) ) RCN_annoAtto_MAT
     , decode(cta.sigla, 'RCN', to_char(spo.d_data_atto_mat,'yyyy-mm-dd')) RCN_dataformazione_MAT
     , decode(cta.sigla, 'RCN', '3') RCN_tipologia_MAT
     , decode(cta.sigla, 'RCN', decode(spo.id_atto_ansc_mat, '', spo.parte_mat) ) RCN_parte_MAT
     , decode(cta.sigla, 'RCN', decode(spo.id_atto_ansc_mat, '', spo.serie_mat) ) RCN_serie_MAT
  -- provvedimentoSeparazione
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-PR', to_char(dpa.d_separazione_data_doc,'yyyy-mm-dd')) RCN_dataTrascrizione_SEP
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-PR', dpa.separazione_estremi_doc) RCN_estremiDocumento_SEP
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-PR', dpa.separazione_ente) RCN_nomeEnte_SEP
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-PR', f_ANSC_id_provincia_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'')) RCN_idProvinciaEnte_SEP
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-PR', f_ANSC_provincia_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'')) RCN_siglaProvinciaEnte_SEP
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-PR', f_ANSC_id_comune_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'')) RCN_idComuneEnte_SEP
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-PR', f_ANSC_comune_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'')) RCN_nomeComuneEnte_SEP
  -- attoNegoziazioneAssistita
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', dpa.accordo_id_atto_ansc) RCN_idAttoAnsc_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', f_ANSC_id_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) RCN_idProvReg_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', f_ANSC_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) RCN_siglaProvReg_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', f_ANSC_id_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) RCN_idComuneReg_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', f_ANSC_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) RCN_nomeComuneReg_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_atto, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'NUMERO_COMUNALE'))) RCN_numeroAtto_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_anno, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'ANNO'))) RCN_annoAtto_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_parte)) RCN_parte_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_serie)) RCN_serie_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', to_char(dpa.d_accordo_data, 'yyyy-mm-dd')) RCN_dataFormazione_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', '3') RCN_tipologia_NEG
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-NA', '1') RCN_idtipocontenuto_NEG
  -- attoAccordoSeparazione
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', dpa.accordo_id_atto_ansc) RCN_idAttoAnsc_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', f_ANSC_id_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) RCN_idProvReg_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', f_ANSC_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) RCN_siglaProvReg_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', f_ANSC_id_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) RCN_idComuneReg_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', f_ANSC_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) RCN_nomeComuneReg_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_atto, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'NUMERO_COMUNALE'))) RCN_numeroAtto_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_anno, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'ANNO'))) RCN_annoAtto_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_parte)) RCN_parte_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_serie)) RCN_serie_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', to_char(dpa.d_accordo_data, 'yyyy-mm-dd')) RCN_dataFormazione_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', '3') RCN_tipologia_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', '1') RCN_idtipocontenuto_ACC
  -- attoConfermaAccordoSeparazione
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', dpa.separazione_conf_id_atto_ansc) RCN_idAttoAnsc_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', f_ANSC_id_provincia_al(dpa.separazione_conf_cod_pro, dpa.separazione_conf_cod_com, '')) RCN_idProvReg_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', f_ANSC_provincia_al(dpa.separazione_conf_cod_pro, dpa.separazione_conf_cod_com, '')) RCN_siglaProvReg_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', f_ANSC_id_comune_al(dpa.separazione_conf_cod_pro, dpa.separazione_conf_cod_com, '')) RCN_idComuneReg_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', f_ANSC_comune_al(dpa.separazione_conf_cod_pro, dpa.separazione_conf_cod_com, '')) RCN_nomeComuneReg_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', decode(dpa.separazione_conf_id_atto_ansc, '', dpa.separazione_conf_atto, f_CIV_get_estremi_id_atto_ansc(dpa.separazione_conf_id_atto_ansc,'NUMERO_COMUNALE'))) RCN_numeroAtto_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', decode(dpa.separazione_conf_id_atto_ansc, '', dpa.separazione_conf_anno, f_CIV_get_estremi_id_atto_ansc(dpa.separazione_conf_id_atto_ansc,'ANNO'))) RCN_annoAtto_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', decode(dpa.separazione_conf_id_atto_ansc, '', dpa.separazione_conf_parte)) RCN_parte_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', decode(dpa.separazione_conf_id_atto_ansc, '', dpa.separazione_conf_serie)) RCN_serie_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', to_char(dpa.d_separazione_conf_data, 'yyyy-mm-dd')) RCN_dataFormazione_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', '3') RCN_tipologia_CONF_ACC
     , decode(cta.sigla||'-'||dpa.separazione_tipo_provv, 'RCN-AC', '1') RCN_idtipocontenuto_CONF_ACC
--
     , decode(cta.sigla, 'RCN', to_char(mat.d_data_mat,'yyyy-mm-dd')) dataRiconciliazione
--
     , decode(mar.documenti_presentati_mat, 'OME', 'true', 'false') omissionePubblicazione
     , to_char(null) dataTrascrizione
     , to_char(null) estremiDocumento
     , to_char(null) nomeEnte_pub
     , to_char(null) idProvinciaEnte
     , to_char(null) siglaProvinciaEnte
     , to_char(null) idComuneEnte
     , to_char(null) nomeComuneEnte
-- datiEventoMatrimonio
     , case when cta.sigla in ('RCN') then '' else to_char(mat.d_data_mat, 'yyyy-mm-dd') end dataEvento -- FIXME: bisognerebbe montare gestione per categoria
     , case when cta.sigla in ('RCN') then '' else lpad(mat.ore,2,'0') end oraEvento       -- FIXME: bisognerebbe montare gestione per categoria
     , case when cta.sigla in ('RCN') then '' else lpad(mat.minuti,2,'0') end minutoEvento -- FIXME: bisognerebbe montare gestione per categoria
     , decode(tta.numero_testimoni, '', '', tta.numero_testimoni) numeroTestimoni
     , decode(mar.documenti_presentati_mat, 'DUE', 'true', 'false') pubblicazioneInPiuComuni
     , decode(dpa.fine_opposizione_tipo_doc,'DE','true','false') rigettoOpposizione
     , decode(dpa.fine_opposizione_tipo_doc,'PR','true','false') estintaOpposizione
     , f_ANSC_difetto_eta(mat.difetto_eta) difettoEta
     , decode(mat.difetto_eta,
         'D2', f_ANSC_tipo_assistenza_minore(mat.TIPO_ASSISTENZA_DIFETTO_ETA_m),
         'D4', f_ANSC_tipo_assistenza_minore(mat.TIPO_ASSISTENZA_DIFETTO_ETA_m)) tipoAssistenteSposo
     , decode(mat.difetto_eta,
         'D3', f_ANSC_tipo_assistenza_minore(mat.TIPO_ASSISTENZA_DIFETTO_ETA_f),
         'D4', f_ANSC_tipo_assistenza_minore(mat.TIPO_ASSISTENZA_DIFETTO_ETA_f)) tipoAssistenteSposa
     , f_ANSC_impedimento_mat(mat.impedimento_mat) impedimentoParentela
     , decode(mat.flag_divieto_temporaneo, 'S', 'true','false') divietoTemporaneo
     , decode(nvl(dpa.flag_casa_comunale,'N'), 'N', f_ANSC_soggetto_impedimento(dpa.impossibilitato_uci)) soggettoImpedimento
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
  -- autorizzazioneDifettoEta
     , to_char(dpa.d_impedimento_eta_data_doc,'yyyy-mm-dd') ETA_dataTrascrizione
     , dpa.impedimento_eta_estremi_doc ETA_estremiDocumento
     , dpa.impedimento_eta_ente ETA_nomeEnte
     , f_ANSC_id_provincia_al(dpa.impedimento_eta_cod_pro,dpa.impedimento_eta_cod_com,'') ETA_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.impedimento_eta_cod_pro,dpa.impedimento_eta_cod_com,'') ETA_siglaProvinciaEnte
     , f_ANSC_id_comune_al(dpa.impedimento_eta_cod_pro,dpa.impedimento_eta_cod_com,'') ETA_idComuneEnte
     , f_ANSC_comune_al(dpa.impedimento_eta_cod_pro,dpa.impedimento_eta_cod_com,'') ETA_nomeComuneEnte
  -- autorizzazioneParentela
     , to_char(dpa.d_impedimento_par_data_doc,'yyyy-mm-dd') PAR_dataTrascrizione
     , dpa.impedimento_par_estremi_doc PAR_estremiDocumento
     , dpa.impedimento_par_ente PAR_nomeEnte
     , f_ANSC_id_provincia_al(dpa.impedimento_par_cod_pro,dpa.impedimento_par_cod_com,'') PAR_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.impedimento_par_cod_pro,dpa.impedimento_par_cod_com,'') PAR_siglaProvinciaEnte
     , f_ANSC_id_comune_al(dpa.impedimento_par_cod_pro,dpa.impedimento_par_cod_com,'') PAR_idComuneEnte
     , f_ANSC_comune_al(dpa.impedimento_par_cod_pro,dpa.impedimento_par_cod_com,'') PAR_nomeComuneEnte
  -- autorizzazioneDivietoTemporaneo
     , to_char(dpa.d_impedimento_tmp_data_doc,'yyyy-mm-dd') TMP_dataTrascrizione
     , dpa.impedimento_tmp_estremi_doc TMP_estremiDocumento
     , dpa.impedimento_tmp_ente TMP_nomeEnte
     , f_ANSC_id_provincia_al(dpa.impedimento_tmp_cod_pro,dpa.impedimento_tmp_cod_com,'') TMP_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.impedimento_tmp_cod_pro,dpa.impedimento_tmp_cod_com,'') TMP_siglaProvinciaEnte
     , f_ANSC_id_comune_al(dpa.impedimento_tmp_cod_pro,dpa.impedimento_tmp_cod_com,'') TMP_idComuneEnte
     , f_ANSC_comune_al(dpa.impedimento_tmp_cod_pro,dpa.impedimento_tmp_cod_com,'') TMP_nomeComuneEnte
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
-- regimePatrimoniale
     , f_ANSC_regime_patrimoniale(mat.convenzioni, mar.scelta_conv) tipo                     -- anst49
     , 'false' attoNotarile
     , decode(mar.scelta_conv, 2, mar.legge_conv) legge
     , to_char(null) nomeNotaio
     , to_char(null) cognomeNotaio
     , to_char(null) distrettoNotarile
     , to_char(null) dataAttoNotarile
     , '0' presenzaMinori
     , to_char(null) assistenzaMinori
-- luogoCelebrazione
     , decode(cta.sigla, 'O2A', dpa.luogo_mat, 'T2B', dpa.luogo_mat, decode(dpa.flag_casa_comunale, '', dpa.luogo_uci, 'Casa Comunale')) luogo
     , f_ANSC_id_comune_al(mat.cod_pro_mat,mat.cod_com_mat,'') idComuneCelebrazione
     , f_ANSC_comune_italiano(mat.cod_pro_mat,mat.cod_com_mat,'') nomeComuneCelebrazione
     , f_ANSC_id_provincia_al(mat.cod_pro_mat,mat.cod_com_mat,'') idProvinciaCelebrazione
     , f_ANSC_provincia_al(mat.cod_pro_mat,mat.cod_com_mat,'') siglaProvinciaCelebrazione
     , f_ANSC_id_stato_al(mat.cod_pro_mat,mat.cod_com_mat,'') idStato
     , f_ANSC_stato_al(mat.cod_pro_mat,mat.cod_com_mat,'') nomeStato
     , f_ANSC_comune_estero(mat.cod_pro_mat,mat.cod_com_mat,'') comuneEsteroCelebrazione
     , dpa.indirizzo_uci indirizzo
     , dpa.civico_uci numeroCivico
     , decode(cta.sigla, 'O2A', f_ANSC_tipo_dichiarante(dpa.tipo_dichiarante,dpa.tipo_comparente,4), to_char(null)) dichiaranteMatrimonioReligioso
     , decode(cta.sigla, 'O2A', dpa.rito, to_char(null)) descrizioneRitoReligioso
     , decode(cta.sigla, 'O2A', 'true', to_char(null)) ritoRiconosciuto
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
     , f_ANSC_id_comune_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mat.d_data_mat) ITP_idComuneResidenza
     , f_ANSC_comune_italiano(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mat.d_data_mat) ITP_nomeComuneResidenza
     , f_ANSC_id_provincia_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mat.d_data_mat) ITP_idProvinciaResidenza
     , f_ANSC_provincia_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mat.d_data_mat) ITP_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mat.d_data_mat) ITP_idStatoResidenza
     , f_ANSC_stato_al(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mat.d_data_mat) ITP_nomeStatoResidenza
     , f_ANSC_comune_estero(sog_ITP.cod_pro_res,sog_ITP.cod_com_res,mat.d_data_mat) ITP_comuneEsteroResidenza
     , decode(sog_ITP.sesso,'M','o','F','a') ITP_genere
     , f_ANSC_id_nazionalita(dci_itp.ist_ci) ITP_idNazionalita
     , f_get_descrizione_dci(sog_ITP.nazionalita,'') ITP_nazionalita
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'IT') ITP_flagDichiarante
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'IT') ITP_flagComparente
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'IT') ITP_flagFirmatario
--
     , decode(dpa.segretario_utente, '', '', 1) ruoloSegretario
  -- segretarioComunale
     , decode(dpa.segretario_utente, '', '', f_ANSC_cognome_segretario(dpa.segretario_utente,'')) SEG_cognome
     , decode(dpa.segretario_utente, '', '', f_ANSC_nome_segretario(dpa.segretario_utente,'')) SEG_nome
     , 'false' SEG_flagDichiarante
     , 'false' SEG_flagComparente
     , decode(dpa.segretario_utente, '', 'false', 'true') SEG_flagFirmatario
-- delegante
     , decode(cta.sigla,
         'CPD', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd'),
         'TMD', to_char(dpa.d_data_nota_rif,'yyyy-mm-dd')) DEL_data
     , decode(cta.sigla,
         'CPD', 'Come da trascrizione contenuta nel corpo dell''atto',
         'TMD', 'Come da trascrizione contenuta nel corpo dell''atto') DEL_testo
     , decode(cta.sigla,
         'CPD', f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,''),
         'TMD', f_ANSC_id_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_comune
     , decode(cta.sigla,
         'CPD', f_ANSC_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,''),
         'TMD', f_ANSC_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_nomeComune
     , decode(cta.sigla,
         'CPD', f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,''),
         'TMD', f_ANSC_id_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_idProvinciaComune
     , decode(cta.sigla,
         'CPD', f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,''),
         'TMD', f_ANSC_provincia_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_siglaProvinciaComune
     , decode(cta.sigla,
         'CPD', f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,''),
         'TMD', f_ANSC_id_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_idNazione
     , decode(cta.sigla,
         'CPD', f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,''),
         'TMD', f_ANSC_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'')) DEL_nomeNazione
     , decode(cta.sigla,
         'CPD', dpa.id_consolato_ansc_prov,
         'TMD', dpa.id_consolato_ansc_prov) DEL_idAnagraficaConsolato
     , decode(cta.sigla,
         'CPD', t97_prov.descrizione,
         'TMD', t97_prov.descrizione) DEL_nomeAnagraficaConsolato
-- Trascrizione matrimonio
     , decode(dpa.tipo_atto, 4, '2', -4, '1') tipoTrascrizione -- anst55
     , f_ANSC_tipo_dichiarazione(4, cta.sigla, mat.id_usecase_ansc, dpa.tipo_richiesta_trascrizione) TRA_tipoRichiestaTrascrizione	-- ANST38
     , decode(cta.sigla,'EST', f_ANSC_tipo_modifica_mat(dpa.tipo_divorzio)) TRA_tipoModificaMatrimonio	-- ANST54
     , decode(cta.sigla,'EST', decode(dpa.flag_privato_dic, 'S', 'true', 'false')) TRA_ricevutaDaPrivato
     , decode(cta.sigla,'EST', to_char(dpa.d_sentenza_data_decorrenza,'yyyy-mm-dd')) TRA_dataDecorrenzaSentenza
     , decode(cta.sigla,'EST', to_char(dpa.d_sentenza_data_pubblicazione,'yyyy-mm-dd')) TRA_dataPubblicazioneSentenza
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
     , t97_prov.descrizione TRA_nomeAnagraficaConsolato
  --
     , to_char(null) MIT_ruoloEnteDichiarante
     , to_char(null) MIT_nomeEnte
  -- Atto da Trascrivere
     , case when cta.sigla in ('TEP', 'TEA','EST') then to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd')
            else to_char(dpa.d_data_atto_utente,'yyyy-mm-dd') end EST_dataTrascrizione
     , to_char(dpa.d_ente_straniero_data_atto,'yyyy-mm-dd') EST_dataComunicazione
     , dpa.ente_straniero_tipo_atto EST_descrizione
     , dpa.ente_straniero_estremi_atto                                                EST_estremiDocumento
     , dpa.ente_straniero                                                             EST_nomeEnte
     , f_ANSC_id_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idComuneEnte
     , f_ANSC_comune_italiano(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_nomeComuneEnte
     , f_ANSC_id_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_idProvinciaEnte
     , f_ANSC_provincia_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_siglaProvinciaEnte
     , f_ANSC_id_stato_al(dpa.ente_straniero_cod_pro, dpa.ente_straniero_cod_com, '') EST_nazioneEnte
     , f_ANSC_stato_al(dpa.ente_straniero_cod_pro, dpa.ente_straniero_cod_com, '')    EST_nomeNazioneEnte
     , f_ANSC_comune_estero(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') EST_comuneEsteroEnte
     , to_char(null) EST_idAnagraficaConsolato
     , to_char(null) EST_nomeAnagraficaConsolato
-- composizioneCompleta
     , tli.riga_clob composizioneCompleta
-- separazione
     , decode(cta.sigla, 'UAC', case when dpa.tipo_divorzio in ('C', 'S') then f_ANSC_tipo_provvedimento_sep(dpa.separazione_tipo_provv) end
                       , 'UAL', case when dpa.tipo_divorzio_altro in ('C', 'D') then f_ANSC_tipo_provvedimento_sep(dpa.separazione_tipo_provv) end
                       , 'RCN', f_ANSC_tipo_provvedimento_sep(dpa.separazione_tipo_provv)
             ) tipoProvvedimentoSeparazione  -- ANSC_104
     , CASE WHEN cta.sigla IN ('UAC') THEN spo.officiante_mat
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then spo.officiante_mat else '' end
            ELSE '' END officianteEventoMatrimonio
     , CASE WHEN cta.sigla IN ('UAC') THEN to_char(spo.d_data_mat, 'yyyy-mm-dd')
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then to_char(spo.d_data_mat, 'yyyy-mm-dd') else '' end
            ELSE '' END dataEventoMatrimonio
  -- attoMatrimonio
     , decode(cta.flag_divorzio,'S', spo.id_atto_ansc_mat) SEP_idAttoAnsc_MAT
     , decode(cta.flag_divorzio,'S', f_ANSC_id_provincia_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '')) SEP_idProvReg_MAT
     , decode(cta.flag_divorzio,'S', f_ANSC_provincia_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '')) SEP_siglaProvReg_MAT
     , decode(cta.flag_divorzio,'S', f_ANSC_id_comune_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '')) SEP_idComuneReg_MAT
     , decode(cta.flag_divorzio,'S', f_ANSC_comune_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '')) SEP_nomeComuneReg_MAT
     , decode(cta.flag_divorzio,'S', '1') SEP_idtipocontenuto_MAT
     , decode(cta.flag_divorzio,'S', decode(spo.id_atto_ansc_mat, '', spo.atto_mat, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_mat,'NUMERO_COMUNALE') ) ) SEP_numeroatto_MAT
     , decode(cta.flag_divorzio,'S', decode(spo.id_atto_ansc_mat, '', spo.anno_atto_mat, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_mat,'ANNO') ) ) SEP_annoAtto_MAT
     , decode(cta.flag_divorzio,'S', to_char(spo.d_data_atto_mat, 'yyyy-mm-dd')) SEP_dataformazione_MAT
     , decode(cta.flag_divorzio,'S', '3') SEP_tipologia_MAT
     , decode(cta.flag_divorzio,'S', decode(spo.id_atto_ansc_mat, '', spo.parte_mat) ) SEP_parte_MAT
     , decode(cta.flag_divorzio,'S', decode(spo.id_atto_ansc_mat, '', spo.serie_mat) ) SEP_serie_MAT
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_conferma_data, 'yyyy-mm-dd')) SEP_dataConfermaAccordo
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_comparente(dpa.tipo_comparente,'AO')) presenzaAvvocatoConiuge1
     , decode(cta.flag_divorzio,'S', dpa.foro_avvocato_sposo) foroAvvocatoConiuge1
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_comparente(dpa.tipo_comparente,'AA', 'AVV2')) presenzaAvvocatoConiuge2
     , decode(cta.flag_divorzio,'S', dpa.foro_avvocato_sposa) foroAvvocatoConiuge2
     , decode(cta.flag_divorzio,'S', 'false') avvocatoUnico
     , decode(cta.flag_divorzio,'S', f_ANSC_tipo_accordo(dpa.tipo_divorzio,dpa.tipo_divorzio_altro,f_CIV_get_id_atto(4,dpa.accordo_ufficio,dpa.accordo_anno,dpa.accordo_parte,dpa.accordo_serie,dpa.accordo_atto))) SEP_tipoAccordo
  --
     , decode(cta.flag_divorzio,'S', decode(dpa.flag_giudizio_pendente,'S', 'true', 'false')) parteInGiudizioPendente
     , decode(cta.flag_divorzio,'S', decode(dpa.flag_giudizio_pendente,'S', dpa.autorita_giud_ente))  autoritaGiudiziaria
     , decode(cta.flag_divorzio,'S', decode(dpa.tipo_divorzio, 'A', decode(dpa.tipo_divorzio_altro,'C', 1, 'D', 2, ''), '') ) tipoSeparazioneDivorzio   -- ANSC_106
     , decode(cta.flag_divorzio,'S', decode(dpa.dati_assegno_divorzio, '', 'false', 'true'))  assegnoMantenimento
     , decode(cta.flag_divorzio,'S', dpa.dati_assegno_divorzio) datiAssegnoMantenimento
  --
  -- luogoEventoMatrimonio
     , CASE WHEN cta.sigla IN ('UAC', 'RCN') THEN f_ANSC_id_stato_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat)
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then f_ANSC_id_stato_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat) else '' end
            ELSE '' END SEP_idStatoCelebrazione_MAT
     , CASE WHEN cta.sigla IN ('UAC', 'RCN') THEN f_ANSC_stato_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat)
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then f_ANSC_stato_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat) else '' end
            ELSE '' END SEP_nomeStatoCelebrazione_MAT
     , CASE WHEN cta.sigla IN ('UAC', 'RCN') THEN f_ANSC_id_comune_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat)
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then f_ANSC_id_comune_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat) else '' end
            ELSE '' END SEP_idComuneCelebrazione_MAT
     , CASE WHEN cta.sigla IN ('UAC', 'RCN') THEN f_ANSC_comune_italiano(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat)
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then f_ANSC_comune_italiano(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat) else '' end
            ELSE '' END SEP_nomeComuneCelebrazione_MAT
     , CASE WHEN cta.sigla IN ('UAC', 'RCN') THEN f_ANSC_id_provincia_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat)
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then f_ANSC_id_provincia_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat) else '' end
            ELSE '' END SEP_idProvCelebrazione_MAT
     , CASE WHEN cta.sigla IN ('UAC', 'RCN') THEN f_ANSC_provincia_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat)
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then f_ANSC_provincia_al(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat) else '' end
            ELSE '' END SEP_siglaProvCelebrazione_MAT
     , CASE WHEN cta.sigla IN ('UAC', 'RCN') THEN f_ANSC_comune_estero(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat)
            WHEN cta.sigla IN ('UAL') THEN case when dpa.tipo_divorzio_altro in ('C', 'D') then f_ANSC_comune_estero(spo.cod_pro_mat,spo.cod_com_mat,spo.d_data_mat) else '' end
            ELSE '' END SEP_comEsteroCelebrazione_MAT
  --
  --attoSeparazione
     , decode(cta.flag_divorzio,'S', f_ANSC_id_provincia_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '') ) SEP_idProvRegistrazione
     , decode(cta.flag_divorzio,'S', f_ANSC_provincia_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '') ) SEP_siglaProvRegistrazione
     , decode(cta.flag_divorzio,'S', f_ANSC_id_comune_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '') ) SEP_idComuneRegistrazione
     , decode(cta.flag_divorzio,'S', f_ANSC_comune_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '') ) SEP_nomeComuneRegistrazione
     , decode(cta.flag_divorzio,'S', '1' ) SEP_idtipocontenuto
     , decode(cta.flag_divorzio,'S', dpa.separazione_estremi_doc ) SEP_numeroatto
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_separazione_data_doc, 'yyyy') ) SEP_annoAtto
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_separazione_data_doc, 'yyyy-mm-dd')) SEP_dataformazione
     , decode(cta.flag_divorzio,'S', '3' ) SEP_tipologia
  -- provvedimentoSeparazione
     , case when (cta.sigla = 'UAL' and dpa.tipo_divorzio_altro in ('C', 'D')) or (cta.sigla = 'UAC' and dpa.separazione_tipo_provv = 'PR') then to_char(dpa.d_separazione_data_doc,'yyyy-mm-dd') else '' end SEP_dataTrascrizione
     , case when (cta.sigla = 'UAL' and dpa.tipo_divorzio_altro in ('C', 'D')) or (cta.sigla = 'UAC' and dpa.separazione_tipo_provv = 'PR') then dpa.separazione_estremi_doc else '' end SEP_estremiDocumento
     , case when (cta.sigla = 'UAL' and dpa.tipo_divorzio_altro in ('C', 'D')) or (cta.sigla = 'UAC' and dpa.separazione_tipo_provv = 'PR') then dpa.separazione_ente else '' end SEP_nomeEnte
     , case when (cta.sigla = 'UAL' and dpa.tipo_divorzio_altro in ('C', 'D')) or (cta.sigla = 'UAC' and dpa.separazione_tipo_provv = 'PR') then f_ANSC_id_provincia_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'') else '' end SEP_idProvinciaEnte
     , case when (cta.sigla = 'UAL' and dpa.tipo_divorzio_altro in ('C', 'D')) or (cta.sigla = 'UAC' and dpa.separazione_tipo_provv = 'PR') then f_ANSC_provincia_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'') else '' end SEP_siglaProvinciaEnte
     , case when (cta.sigla = 'UAL' and dpa.tipo_divorzio_altro in ('C', 'D')) or (cta.sigla = 'UAC' and dpa.separazione_tipo_provv = 'PR') then f_ANSC_id_comune_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'') else '' end SEP_idComuneEnte
     , case when (cta.sigla = 'UAL' and dpa.tipo_divorzio_altro in ('C', 'D')) or (cta.sigla = 'UAC' and dpa.separazione_tipo_provv = 'PR') then f_ANSC_comune_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'') else '' end SEP_nomeComuneEnte
     , decode(cta.sigla||'-'||dpa.tipo_divorzio_altro, 'UAL-C', 'testo come da trascrizione in composizione') SEP_modificaAccordo
  -- accordoSeparazione
     , decode(cta.flag_divorzio,'S', dpa.accordo_id_atto_ansc) SEP_idAttoAnsc_ACC
     , decode(cta.flag_divorzio,'S', f_ANSC_id_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) SEP_idProvReg_ACC
     , decode(cta.flag_divorzio,'S', f_ANSC_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) SEP_siglaProvReg_ACC
     , decode(cta.flag_divorzio,'S', f_ANSC_id_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) SEP_idComuneReg_ACC
     , decode(cta.flag_divorzio,'S', f_ANSC_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '')) SEP_nomeComuneReg_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_atto, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'NUMERO_COMUNALE'))) SEP_numeroAtto_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_anno, f_CIV_get_estremi_id_atto_ansc(dpa.accordo_id_atto_ansc,'ANNO'))) SEP_annoAtto_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_parte)) SEP_parte_ACC
     , decode(cta.flag_divorzio,'S', decode(dpa.accordo_id_atto_ansc, '', dpa.accordo_serie)) SEP_serie_ACC
     , decode(cta.flag_divorzio,'S', to_char(dpa.d_accordo_data, 'yyyy-mm-dd')) SEP_dataFormazione_ACC
     , decode(cta.flag_divorzio,'S', '3') SEP_tipologia_ACC
     , decode(cta.flag_divorzio,'S', '1') SEP_idtipocontenuto_ACC
  -- confermaAccordoSeparazione
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN dpa.separazione_conf_id_atto_ansc ELSE '' END SEP_idAttoAnsc_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN f_ANSC_id_provincia_al(dpa.separazione_conf_cod_pro, dpa.separazione_conf_cod_com, '') ELSE '' END SEP_idProvReg_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN f_ANSC_provincia_al(dpa.separazione_conf_cod_pro, dpa.separazione_conf_cod_com, '') ELSE '' END SEP_siglaProvReg_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN f_ANSC_id_comune_al(dpa.separazione_conf_cod_pro, dpa.separazione_conf_cod_com, '') ELSE '' END SEP_idComuneReg_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN f_ANSC_comune_al(dpa.separazione_conf_cod_pro, dpa.separazione_conf_cod_com, '') ELSE '' END SEP_nomeComuneReg_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN decode(dpa.separazione_conf_id_atto_ansc, '', dpa.separazione_conf_atto, f_CIV_get_estremi_id_atto_ansc(dpa.separazione_conf_id_atto_ansc,'NUMERO_COMUNALE')) ELSE to_number(null) END SEP_numeroAtto_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN decode(dpa.separazione_conf_id_atto_ansc, '', dpa.separazione_conf_anno, f_CIV_get_estremi_id_atto_ansc(dpa.separazione_conf_id_atto_ansc,'ANNO')) ELSE to_number(null) END SEP_annoAtto_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN decode(dpa.separazione_conf_id_atto_ansc, '', dpa.separazione_conf_parte) ELSE to_number(null) END SEP_parte_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN decode(dpa.separazione_conf_id_atto_ansc, '', dpa.separazione_conf_serie) ELSE '' END SEP_serie_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN to_char(dpa.d_separazione_conf_data, 'yyyy-mm-dd') ELSE '' END SEP_dataFormazione_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN '3' ELSE '' END SEP_tipologia_CONF_ACC
     , CASE WHEN cta.sigla IN ('UAC','UAL','RCN') THEN '1' ELSE '' END SEP_idtipocontenuto_CONF_ACC
-- negoziazioneAssistita
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_tipo_accordo(dpa.tipo_divorzio,dpa.tipo_divorzio_altro) else '' end NEG_tipoAccordo
     , case when cta.sigla in ('AVV', 'AAL') then to_char(dpa.D_ACCORDO_DATA_COM_AVV_1, 'yyyy-mm-dd') else '' end NEG_dataRicezioneAtto_m
     , case when cta.sigla in ('AVV', 'AAL') then dpa.ACCORDO_PROT_AVV_1 else '' end NEG_protocolloAtto_m
     , case when cta.sigla in ('AVV', 'AAL') then to_char(dpa.D_ACCORDO_DATA_COM_AVV_2, 'yyyy-mm-dd') else '' end NEG_dataRicezioneAtto_f
     , case when cta.sigla in ('AVV', 'AAL') then dpa.ACCORDO_PROT_AVV_2 else '' end NEG_protocolloAtto_f
     , case when cta.sigla in ('AVV', 'AAL') then to_char(dpa.ricezione_atto_avvocati) else '' end NEG_ricezioneAtto  -- ANSC_103
     , case when cta.sigla in ('AVV', 'AAL') then 'come da trascrizione contenuta nel corpo dell''atto'  else '' end NEG_testoTrascrizione
  -- accordo
     , case when cta.sigla in ('AVV', 'AAL') then to_char(dpa.d_accordo_data, 'yyyy-mm-dd') else '' end NEG_dataTrascrizione_ACC
     , case when cta.sigla in ('AVV', 'AAL') then to_char(nvl(dpa.D_ACCORDO_DATA_STIPULA,dpa.d_accordo_data), 'yyyy-mm-dd') else '' end NEG_dataStipula_ACC
     , case when cta.sigla in ('AVV', 'AAL') then dpa.accordo_numero end NEG_estremiDocumento_ACC
     --, decode(cta.sigla, 'AVV', dpa.accordo_ente) NEG_nomeEnte_ACC -- campo dismesso per https://github.com/italia/ansc/issues/377
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_id_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '') else '' end NEG_idProvinciaEnte_ACC
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_provincia_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '') else '' end NEG_siglaProvinciaEnte_ACC
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_id_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '') else '' end NEG_idComuneEnte_ACC
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_comune_al(dpa.accordo_cod_pro, dpa.accordo_cod_com, '') else '' end NEG_nomeComuneEnte_ACC
  -- attoMatrimonio
     , case when cta.sigla in ('AVV', 'AAL') then spo.id_atto_ansc_mat else '' end NEG_idAttoAnsc_MAT
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_id_provincia_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '') else '' end NEG_idProvinciaReg_MAT
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_provincia_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '') else '' end NEG_siglaProvinciaReg_MAT
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_id_comune_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '') else '' end NEG_idComuneReg_MAT
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_comune_al(spo.cod_pro_atto_mat, spo.cod_com_atto_mat, '') else '' end NEG_nomeComuneReg_MAT
     , case when cta.sigla in ('AVV', 'AAL') then '1' else '' end NEG_idTipoContenuto_MAT
     , case when cta.sigla in ('AVV', 'AAL') then decode(spo.id_atto_ansc_mat, '', spo.atto_mat, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_mat,'NUMERO_COMUNALE') ) end NEG_numeroAtto_MAT
     , case when cta.sigla in ('AVV', 'AAL') then decode(spo.id_atto_ansc_mat, '', spo.anno_atto_mat, f_CIV_get_estremi_id_atto_ansc(spo.id_atto_ansc_mat,'ANNO') ) end NEG_annoAtto_MAT
     , case when cta.sigla in ('AVV', 'AAL') then to_char(spo.d_data_atto_mat, 'yyyy-mm-dd') else '' end NEG_dataFormazione_MAT
     , case when cta.sigla in ('AVV', 'AAL') then '3' else '' end NEG_tipologia_MAT
     , case when cta.sigla in ('AVV', 'AAL') then decode(spo.id_atto_ansc_mat, '', spo.parte_mat) else '' end NEG_parte_MAT
     , case when cta.sigla in ('AVV', 'AAL') then decode(spo.id_atto_ansc_mat, '', spo.serie_mat) else '' end NEG_serie_MAT
  -- provvedimentoAutoritaGiudiziaria
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_tipo_provvedimento(dpa.autorita_giud_tipo_provv) else '' end AUTGIU_tipoProvvedimento
     , case when cta.sigla in ('AVV', 'AAL') then to_char(dpa.d_autorita_giud_data_doc,'yyyy-mm-dd') else '' end AUTGIU_dataTrascrizione
     , case when cta.sigla in ('AVV', 'AAL') then dpa.autorita_giud_estremi_doc else '' end AUTGIU_estremiDocumento
     , case when cta.sigla in ('AVV', 'AAL') then dpa.autorita_giud_ente else '' end AUTGIU_nomeEnte
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_id_provincia_al(dpa.autorita_giud_cod_pro, dpa.autorita_giud_cod_com, '') else '' end AUTGIU_idProvinciaEnte
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_provincia_al(dpa.autorita_giud_cod_pro, dpa.autorita_giud_cod_com, '') else '' end AUTGIU_siglaProvinciaEnte
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_id_comune_al(dpa.autorita_giud_cod_pro, dpa.autorita_giud_cod_com, '') else '' end AUTGIU_idComuneEnte
     , case when cta.sigla in ('AVV', 'AAL') then f_ANSC_comune_al(dpa.autorita_giud_cod_pro, dpa.autorita_giud_cod_com, '') else '' end AUTGIU_nomeComuneEnte
     , case when cta.sigla in ('AVV', 'AAL') then to_char(dpa.D_AUTORITA_GIUD_DATA_DEPOSITO, 'yyyy-mm-dd') else '' end AUTGIU_dataDepProvvedimento
     , case when cta.sigla in ('AVV', 'AAL') then to_char(dpa.D_AUTORITA_GIUD_DATA_COM_AVV, 'yyyy-mm-dd') else '' end AUTGIU_dataComProvvedimento
--presenzaConiugi
     , f_ANSC_flag_comparente(dpa.tipo_comparente, 'SO') presenzaConiuge1
     , f_ANSC_flag_comparente(dpa.tipo_comparente, 'SA') presenzaConiuge2
-- avvocatoConiuge1
     , decode(cta.flag_divorzio,'S', dpa.avvocato_sposo_cognome) AV1_cognome
     , decode(cta.flag_divorzio,'S', dpa.avvocato_sposo_nome)  AV1_nome
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'AO')) AV1_flagDichiarante
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_comparente(dpa.tipo_comparente,'AO')) AV1_flagComparente
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_firmatario(dpa.tipo_firmatario,'AO')) AV1_flagFirmatario
-- avvocatoConiuge2
     , decode(cta.flag_divorzio,'S', dpa.avvocato_sposa_cognome) AV2_cognome
     , decode(cta.flag_divorzio,'S', dpa.avvocato_sposa_nome) AV2_nome
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'AA','AVV2')) AV2_flagDichiarante
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_comparente(dpa.tipo_comparente,'AA','AVV2')) AV2_flagComparente
     , decode(cta.flag_divorzio,'S', f_ANSC_flag_firmatario(dpa.tipo_firmatario,'AA','AVV2')) AV2_flagFirmatario
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
     , f_ANSC_id_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat) DIC_idComuneResidenza
     , f_ANSC_comune_italiano(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat) DIC_nomeComuneResidenza
     , f_ANSC_id_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat) DIC_idProvinciaResidenza
     , f_ANSC_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat) DIC_siglaProvinciaResidenza
     , f_ANSC_id_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat) DIC_idStatoResidenza
     , f_ANSC_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat) DIC_nomeStatoResidenza
     , f_ANSC_comune_estero(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat) DIC_comuneEsteroResidenza
     , f_get_descrizione_DCI(dpa.nazionalita_dic, '') DIC_nazionalita
     , f_ANSC_id_nazionalita(dci_dic.ist_ci) DIC_idNazionalita
     , decode(cta.sigla, 'EST', 'false', 'TEP', 'true') DIC_flagDichiarante
     , decode(cta.sigla, 'EST', 'false', 'TEP', 'false') DIC_flagComparente
     -- nelle TEP cdu 331000 la presenza di firmatari non dipende più dal tipo richiesta ma da campo in maschera
     , decode(cta.sigla,
         'EST', decode (nvl(dpa.tipo_firmatario,'NE'), 'NE', 'false', 'true'),
         'TEP', decode (nvl(dpa.tipo_firmatario,'NE'), 'NE', 'false', 'true'),
                decode(dpa.cognome_dic||dpa.nome_dic, '', 'false', 'true') ) DIC_flagFirmatario
-- ANSC
     , mat.id_atto_ansc idAttoAnsc
     , mat.id_evento_ansc idEventoAnsc
     , mat.id_soggetto_ansc_m idSoggettoAnsc_m
     , mat.id_soggetto_ansc_f idSoggettoAnsc_f
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_1,ana_r.matricola_1),mat.cod_fiscale_m) idSoggettoAnpr_m
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_1,ana_r.matricola_1),mat.cod_fiscale_m) idUnicoAnpr_m
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_2,ana_r.matricola_2),mat.cod_fiscale_f) idSoggettoAnpr_f
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_2,ana_r.matricola_2),mat.cod_fiscale_f) idUnicoAnpr_f
     , to_char(null) forcingCode
  from arccom m
     , anst03 t03
     , anst97 t97_aff_1
     , anst97 t97_aff_2
     , anst97 t97_prov
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
     , civtta tta
     , civtli_v tli
     , civspo spo
     , civmar mar
     , civdpa dpa
     , civocc occ
     , civcta cta
     , civdta dta
     , civmat mat
 where (m.cod_provincia,m.cod_comune)    = (select pro_cliente, com_cliente from menuditta)
   and ana.id_atto                   (+) = mat.id_atto
   and ana_r.id_atto                 (+) = mat.id_atto
   and t03.id                        (+) = mat.id_usecase_ansc
   and t97_aff_1.id                  (+) = mar.id_consolato_ansc_aff_1
   and t97_aff_2.id                  (+) = mar.id_consolato_ansc_aff_2
   and t97_prov.id                   (+) = dpa.id_consolato_ansc_prov
   and sog_ITP.id_atto               (+) = mat.id_atto
   and sog_ITP.tipo_soggetto         (+) = 'IT'
   and dci_dic.cod_ci                (+) = dpa.nazionalita_dic
   and dci_itp.cod_ci                (+) = sog_ITP.nazionalita
   and dci_t4.cod_ci                 (+) = tta.nazionalita_4
   and dci_t3.cod_ci                 (+) = tta.nazionalita_3
   and dci_t2.cod_ci                 (+) = tta.nazionalita_2
   and dci_t1.cod_ci                 (+) = tta.nazionalita_1
   and dci_f.cod_ci                  (+) = mat.nazionalita_f
   and dci_m.cod_ci                  (+) = mat.nazionalita_m
   and tta.id_atto                   (+) = mat.id_atto
   and tli.id_atto                   (+) = mat.id_atto
   and spo.id_atto                   (+) = mat.id_atto
   and mar.id_atto                   (+) = mat.id_atto
   and occ.id_atto                   (+) = mat.id_atto
   and cta.id                            = dta.id_civcta
   and dta.id                            = mat.id_civdta
   and dpa.id_atto                   (+) = mat.id_atto
   and mat.cod_rec                 in (0,3)
/
comment on table CIVMAT_V_JSON is 'ANSC - Atti di Matrimonio per request JSON (view)'
/
