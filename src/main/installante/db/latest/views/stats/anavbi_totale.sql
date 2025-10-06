--liquibase formatted sql
--changeset amonopoli:202411191555_3 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW ANAVBI_TOTALE
(MATRICOLA,
 FLAG_RESIDENTE, FLAG_AIRE, FLAG_SENZA_FISSA_DIMORA, FLAG_ISCRITTO_PRELIMINARE, FLAG_DECEDUTO,
 COGNOME_NOME, COGNOME, NOME, SESSO,
 DATA_NASCITA, DATA_NASCITA_EDIT, ANNO_NASCITA,
 COD_PROVINCIA_NASCITA, COD_COMUNE_NASCITA, COMUNE_NASCITA,
 COD_REGIONE_NASCITA, REGIONE_NASCITA, NAZIONE_NASCITA, GRUPPO_NAZIONE_NASCITA,
 COD_PROVINCIA_ATTO_NASCITA, COD_COMUNE_ATTO_NASCITA, COMUNE_ATTO_NASCITA,
 COD_REGIONE_ATTO_NASCITA, REGIONE_ATTO_NASCITA,
 ATTO_NASCITA_EDIT,
 PATERNITA, MATRICOLA_PADRE, DATA_NASCITA_PADRE, DATA_NASCITA_PADRE_EDIT,
 CODICE_FISCALE_PADRE, FLAG_CF_CALCOLATO_PADRE,
 MATERNITA, MATRICOLA_MADRE, DATA_NASCITA_MADRE, DATA_NASCITA_MADRE_EDIT,
 CODICE_FISCALE_MADRE, FLAG_CF_CALCOLATO_MADRE,
 STATO_CIVILE, DES_STATO_CIVILE,
 COGNOME_NOME_CONIUGE, COGNOME_CONIUGE, NOME_CONIUGE,
 MATRICOLA_CONIUGE, DATA_NASCITA_CONIUGE, DATA_NASCITA_CONIUGE_EDIT,
 CODICE_FISCALE_CONIUGE, FLAG_CF_CALCOLATO_CONIUGE,
 DATA_MATRIMONIO, DATA_MATRIMONIO_EDIT,
 COD_PROVINCIA_MATRIMONIO, COD_COMUNE_MATRIMONIO, COMUNE_MATRIMONIO,
 COD_REGIONE_MATRIMONIO, REGIONE_MATRIMONIO, NAZIONE_MATRIMONIO, GRUPPO_NAZIONE_MATRIMONIO,
 ATTO_MATRIMONIO_EDIT,
 DATA_VEDOVANZA, COD_PROVINCIA_VEDOVANZA, COD_COMUNE_VEDOVANZA, COMUNE_VEDOVANZA,
 COD_REGIONE_VEDOVANZA, REGIONE_VEDOVANZA, NAZIONE_VEDOVANZA, GRUPPO_NAZIONE_VEDOVANZA,
 ATTO_VEDOVANZA_EDIT,
 DATA_DIVORZIO, DATA_DIVORZIO_ANNOTAZIONE, DATA_DIVORZIO_GIUDICATO,
 COD_PROVINCIA_DIVORZIO, COD_COMUNE_DIVORZIO, COMUNE_DIVORZIO,
 COD_REGIONE_DIVORZIO, REGIONE_DIVORZIO, NAZIONE_DIVORZIO, GRUPPO_NAZIONE_DIVORZIO,
 ATTO_DIVORZIO_EDIT,
 DATA_MORTE,
 COD_PROVINCIA_MORTE, COD_COMUNE_MORTE, COMUNE_MORTE,
 COD_REGIONE_MORTE, REGIONE_MORTE, NAZIONE_MORTE, GRUPPO_NAZIONE_MORTE,
 COD_PROVINCIA_ATTO_MORTE, COD_COMUNE_ATTO_MORTE, COMUNE_ATTO_MORTE,
 COD_REGIONE_ATTO_MORTE, REGIONE_ATTO_MORTE,
 ATTO_MORTE_EDIT,
 DATA_INDIRIZZO, INDIRIZZO, INDIRIZZO_INT, CAP_COMUNE_RESIDENZA, COMUNE_RESIDENZA,
 COD_PROVINCIA_RESIDENZA, COD_COMUNE_RESIDENZA, NAZIONE_RESIDENZA, GRUPPO_NAZIONE_RESIDENZA,
 CODICE_VIA, DENOMINAZIONE_VIA, DENOMINAZIONE_VIA_ORDINAMENTO,
 NUMERO_CIVICO, SUFFISSO, INTERNO, SUB_INTERNO, SCALA, PIANO,
 CODICE_ECOGRAFICO, CODICE_FAMIGLIA, INTESTATARIO, CONVIVENZA,
 RAPPORTO_PAR, DES_RAPPORTO_PAR, SEQUENZA_PAR,
 NUMERO_FAMILIARI, NUMERO_FAMILIARI_STRANIERI, NUMERO_FAMILIARI_PRELIMINARI, NUMERO_FAMILIARI_DEFINITIVI,
 NUMERO_FIGLI, NUMERO_FIGLI_MINORI, NUMERO_ULTRA_64, NUMERO_ULTRA_65, NUMERO_ULTRA_75,
 NAZIONALITA, NAZIONALITA_ISTAT, NAZIONALITA_CEE, DES_NAZIONALITA, GRUPPO_NAZIONALITA, DATA_NAZIONALITA,
 TITOLO_STUDIO, DES_TITOLO_STUDIO, GRUPPO_DI_STUDIO,
 COD_PROF, DES_PROFESSIONE, ATTIVITA_PROF, POSIZIONE_PROF,
 PENSIONATO, VAL_ESPATRIO,
 CODICE_FISCALE, FLAG_CF_CALCOLATO,
 ANNO_CENSIMENTO, SEZIONE_CENSIMENTO, FOGLIO_CENSIMENTO, COD_EDIFICIO_CENSIMENTO,
 COD_STATO_ANAGRAFICO, STATO_ANAGRAFICO,
 DATA_ISCRIZIONE, COD_PROVINCIA_ISCR, COD_COMUNE_ISCR, COMUNE_ISCR,
 COD_REGIONE_ISCR, REGIONE_ISCR, COD_NAZIONE_ISCR, NAZIONE_ISCR, GRUPPO_NAZIONE_ISCR,
 PRATICA_ISCR_EDIT,
 DATA_CANCELLAZIONE, COD_PROVINCIA_CANC, COD_COMUNE_CANC, COMUNE_CANC,
 COD_REGIONE_CANC, REGIONE_CANC, COD_NAZIONE_CANC, NAZIONE_CANC, GRUPPO_NAZIONE_CANC,
 PRATICA_CANC_EDIT,
 DATA_ULTIMA_VARIAZIONE,
 TIPO_DI, DES_TIPO_DI, NUMERO_DI, VAL_ESPATRIO_DI, DATA_EMISSIONE_DI, DATA_SCADENZA_DI, ENTE_EMISSIONE_DI,
 MOTIVO_DI, DES_MOTIVO_DI,
 TIPO_DS, DES_TIPO_DS,  NUMERO_DS, DATA_EMISSIONE_DS, DATA_SCADENZA_DS, ENTE_EMISSIONE_DS,
 MOTIVO_DS, DES_MOTIVO_DS,
 COGNOME_NOME_ELE, INDIRIZZO_ELE, COMUNE_AIRE_ELE, STATO_ELE,
 ANNO_ISCRIZIONE_ELE, FASCICOLO_ELE, PROGR_LISTA_GEN_ELE, SEZIONE_ELE, PROGR_LISTA_SEZ_ELE,
 TESSERA_ELE, DATA_TESSERA_ELE, VERBALE_ELE, DATA_VERBALE_ELE,
 STATO_SCRUTATORE_ALBO_S, ANNO_SCRUTATORE_ALBO_S, STATO_SCRUTATORE_ALBO_V, ANNO_SCRUTATORE_ALBO_V,
 STATO_SCRUTATORE_ALBO_R, ANNO_SCRUTATORE_ALBO_R, STATO_GIUDICE_ALBO_A, ANNO_GIUDICE_ALBO_A,
 STATO_GIUDICE_ALBO_P, ANNO_GIUDICE_ALBO_P, STATO_PRESIDENTE_SEGGIO, ANNO_PRESIDENTE_SEGGIO,
 MATRICOLA_MILITARE, CLASSE_LEVA, NUMERO_LISTA_LEVA, ESITO_LEVA, DES_ESITO_LEVA,
 COMUNE_LEVA, COMUNE_DISTRETTO, DATA_ARRUOLAMENTO, DATA_CHIAMATA, DATA_CONGEDO,
 ARMA, DES_ARMA, CORPO, DES_CORPO, GRADO, DES_GRADO,
 DES_UNITA_TERRITORIALE_1, CODICE_SUDDIVISIONE_1, DES_SUDDIVISIONE_1,
 DES_UNITA_TERRITORIALE_2, CODICE_SUDDIVISIONE_2, DES_SUDDIVISIONE_2,
 DES_UNITA_TERRITORIALE_3, CODICE_SUDDIVISIONE_3, DES_SUDDIVISIONE_3,
 DES_UNITA_TERRITORIALE_4, CODICE_SUDDIVISIONE_4, DES_SUDDIVISIONE_4,
 DES_UNITA_TERRITORIALE_5, CODICE_SUDDIVISIONE_5, DES_SUDDIVISIONE_5,
 DES_UNITA_TERRITORIALE_6, CODICE_SUDDIVISIONE_6, DES_SUDDIVISIONE_6,
 DES_UNITA_TERRITORIALE_7, CODICE_SUDDIVISIONE_7, DES_SUDDIVISIONE_7,
 DES_UNITA_TERRITORIALE_8, CODICE_SUDDIVISIONE_8, DES_SUDDIVISIONE_8,
 DES_UNITA_TERRITORIALE_9, CODICE_SUDDIVISIONE_9, DES_SUDDIVISIONE_9,
 DES_UNITA_TERRITORIALE_10, CODICE_SUDDIVISIONE_10, DES_SUDDIVISIONE_10,
 DES_UNITA_TERRITORIALE_CAP, CODICE_SUDDIVISIONE_CAP, DES_SUDDIVISIONE_CAP,
 RECAPITO_CELLULARE, RECAPITO_TELEFONO_FISSO, RECAPITO_EMAIL, DOMICILIO_DIGITALE
)
AS
select
-- matricola
	ana.matricola,
-- flag_residente
	decode(ana.fascia,1,'SI','NO') flag_residente,
-- flag_aire
	decode(ana.fascia,3,'SI','NO') flag_aire,
-- flag_senza_fissa_dimora
	decode(f_senza_fissa_dimora(fam.cod_via, fam.num_civ, fam.suffisso, fam.interno),'S','SI','NO') senza_fissa_dimora,
-- flag_residente
	decode(ana.stato,17,'SI','NO') flag_residente,
-- flag_deceduto
	decode(ana.stato,50,'SI','NO') flag_deceduto,
-- cognome_nome
        ana.cognome_nome,
-- cognome
	substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/') - 1) cognome,
-- nome
	substr(ana.cognome_nome,instr(ana.cognome_nome,'/') + 1) nome,
-- sesso
       	ana.sesso,
-- data_nascita
	to_date(ana.data_nas,'j') DATA_NASCITA,
-- data_nascita_edit
       	decode(ana.anno_nas,'S',
	 '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
         to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy'))	DATA_NASCITA_EDIT,
-- anno_nascita
	to_char(to_date(ana.data_nas,'j'),'yyyy') ANNO_NASCITA,
-- cod_provincia_nascita
	lpad(ana.COD_PRO_NAS,3,'0') cod_provincia_nascita,
-- cod_comune_nascita
	lpad(ana.COD_COM_NAS,3,'0') cod_comune_nascita,
-- comune_nascita
       	com_nas.descrizione||' ('||com_nas.sigla_provincia||')' comune_nascita,
-- cod_regione_nascita
	substr(f_regione(ana.cod_pro_nas),1,2) COD_REGIONE_NASCITA,
-- regione_nascita
	substr(f_regione(ana.cod_pro_nas),3) REGIONE_NASCITA,
-- nazione_nascita
	f_nazione(ana.cod_pro_nas,ana.cod_com_nas) NAZIONE_NASCITA,
-- gruppo_nazione_nascita
	f_gruppo_nazioni(ana.cod_pro_nas) GRUPPO_NAZIONE_NASCITA,
-- cod_provincia_atto_nascita
	lpad(ana.COD_PRO_ATTO_NAS,3,'0') COD_PROVINCIA_ATTO_NASCITA,
-- cod_comune_atto_nascita
	lpad(ana.COD_COM_ATTO_NAS,3,'0') COD_COMUNE_ATTO_NASCITA,
-- comune_atto_nascita
        com_atto_nas.descrizione||' ('||com_atto_nas.sigla_provincia||')' comune_atto_nascita,
-- cod_regione_atto_nascita
	substr(f_regione(ana.cod_pro_atto_nas),1,2) COD_REGIONE_ATTO_NASCITA,
-- regione_atto_nascita
	substr(f_regione(ana.cod_pro_atto_nas),3) REGIONE_ATTO_NASCITA,
-- atto_nascita_edit
	decode(ana.atto_nas_digitale,'',
          ana.atto_nas||
	    DECODE(ANA.PARTE_NAS,'','',' P.'||decode(ana.PARTE_NAS,1,'I',2,'II'))||
	    decode(ana.serie_nas,'','',' S.'||ana.serie_nas)||
	    decode(ana.ufficio_nas,'','',' U.'||ana.ufficio_nas)||
	    decode(ana.anno_atto_nas,'','','/'||ana.anno_atto_nas),
          ana.atto_nas_digitale) ATTO_NASCITA_EDIT,
-- paternita
       	ana.paternita,
-- matricola_padre
	ana_pd.matricola matricola_padre,
-- data_nascita_padre
       to_date(ana_pd.data_nas,'j') data_nascita_padre,
-- data_nascita_padre_edit
       decode(ana_pd.anno_nas,
	 'S','00/00/'||to_char(to_date(ana_pd.data_nas,'j'),'yyyy'),
	 to_char(to_date(ana_pd.data_nas,'j'),'dd/mm/yyyy')),
-- codice_fiscale_padre
	ana_pd.cod_fiscale,
-- cf_calcolato_padre
	ana_pd.cf_calcolato,
-- maternita
       	ana.maternita,
-- matricola_madre
	ana_md.matricola matricola_madre,
-- data_nascita_madre
        to_date(ana_md.data_nas,'j'),
-- data_nascita_madre_edit
       decode(ana_md.anno_nas,
	 'S','00/00/'||to_char(to_date(ana_md.data_nas,'j'),'yyyy'),
	 to_char(to_date(ana_md.data_nas,'j'),'dd/mm/yyyy')),
-- codice_fiscale_madre
	ana_md.cod_fiscale,
-- cf_calcolato_madre
	ana_md.cf_calcolato,
-- stato_civile
	ana.stato_civile,
-- des_stato_civile
       	dsc.descrizione des_stato_civile,
-- cognome_nome_coniuge
	decode(ana.stato_civile,
	  'CN',translate(ana.cognome_nome_cn,'/',' '),
	  'VE',translate(ana.cognome_nome_cn,'/',' '),
	  'UC',translate(ana.cognome_nome_cn,'/',' '),
	  'VU',translate(ana.cognome_nome_cn,'/',' '),'') cognome_nome_coniuge,
-- cognome_coniuge
       decode(ana.stato_civile,
	   'CN',substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/') - 1),
	   'VE',substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/') - 1),
	   'UC',substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/') - 1),
	   'VU',substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/') - 1),'') cognome_coniuge,
-- nome_coniuge
       decode(ana.stato_civile,
         'CN',substr(ana.cognome_nome_cn,instr(ana.cognome_nome_cn,'/') + 1),
         'VE',substr(ana.cognome_nome_cn,instr(ana.cognome_nome_cn,'/') + 1),
         'UC',substr(ana.cognome_nome_cn,instr(ana.cognome_nome_cn,'/') + 1),
         'VU',substr(ana.cognome_nome_cn,instr(ana.cognome_nome_cn,'/') + 1),'') nome_coniuge,
-- matricola_coniuge
	ana_cn.matricola matricola_coniuge,
-- data_nascita_coniuge
        to_date(ana_cn.data_nas,'j') data_nascita_coniuge,
-- data_nascita_coniuge_edit
        decode(ana_cn.anno_nas,
	  'S','00/00/'||to_char(to_date(ana_cn.data_nas,'j'),'yyyy'),
	  to_char(to_date(ana_cn.data_nas,'j'),'dd/mm/yyyy')),
-- codice_fiscale_coniuge
	ana_cn.cod_fiscale,
-- cf_calcolato_coniuge
	ana_cn.cf_calcolato,
-- data_matrimonio
	to_date(ana.data_mat,'j') data_matrimonio,
-- data_matrimonio_edit
	decode(ana.data_mat,'','',
	  decode(ana.anno_mat,'S',
 	    '00/00/'||to_char(to_date(ana.data_mat,'j'),'yyyy'),
	    to_char(to_date(ana.data_mat,'j'),'dd/mm/yyyy'))) data_matrimonio_edit,
-- cod_provincia_matrimonio
	lpad(ana.COD_PRO_MAT,3,'0') cod_provincia_matrimonio,
-- cod_comune_matrimonio
	lpad(ana.COD_COM_MAT,3,'0') cod_comune_matrimonio,
-- comune_matrimonio
       	com_mat.descrizione||decode(com_mat.sigla_provincia,'','',' ('||com_mat.sigla_provincia||')') comune_matrimonio,
-- cod_regione_matrimonio
	substr(f_regione(ana.cod_pro_MAT),1,2) COD_REGIONE_MATRIMONIO,
-- regione_matrimonio
	substr(f_regione(ana.cod_pro_mat),3) REGIONE_MATRIMONIO,
-- nazione_matrimonio
	f_nazione(ana.cod_pro_mat,ana.cod_com_mat) NAZIONE_MATRIMONIO,
-- gruppo_nazione_matrimonio
	f_gruppo_nazioni(ana.cod_pro_mat) GRUPPO_NAZIONE_matrimonio,
-- atto_matrimonio_edit
	decode(ana.atto_mat_digitale,'',
          ana.atto_mat||
	    DECODE(ANA.PARTE_mat,'','',' P.'||decode(ana.PARTE_mat,1,'I',2,'II'))||
	    decode(ana.serie_mat,'','',' S.'||ana.serie_mat)||
	    decode(ana.ufficio_mat,'','',' U.'||ana.ufficio_mat)||
	    decode(ana.anno_atto_mat,'','','/'||ana.anno_atto_mat),
          ana.atto_mat_digitale) ATTO_MATRIMONIO_EDIT,
-- data_vedovanza
	to_date(ana.data_ved,'j') data_vedovanza,
-- cod_provincia_vedovanza
	lpad(ana.COD_PRO_ved,3,'0') cod_provincia_vedovanza,
-- cod_comune_vedovanza
	lpad(ana.COD_COM_ved,3,'0') cod_comune_vedovanza,
-- comune_vedovanza
       	com_ved.descrizione||decode(com_ved.sigla_provincia,'','',' ('||com_ved.sigla_provincia||')') comune_vedovanza,
-- cod_regione_vedovanza
	substr(f_regione(ana.cod_pro_ved),1,2) COD_REGIONE_vedovanza,
-- regione_vedovanza
	substr(f_regione(ana.cod_pro_ved),3) REGIONE_vedovanza,
-- nazione_vedovanza
	f_nazione(ana.cod_pro_ved,ana.cod_com_ved) NAZIONE_vedovanza,
-- gruppo_nazione_vedovanza
	f_gruppo_nazioni(ana.cod_pro_ved) GRUPPO_NAZIONE_vedovanza,
-- atto_vedovanza_edit
	decode(ana.atto_ved_digitale,'',
          ana.atto_ved||
	    DECODE(ANA.PARTE_ved,'','',' P.'||decode(ana.PARTE_ved,1,'I',2,'II'))||
	    decode(ana.serie_ved,'','',' S.'||ana.serie_ved)||
	    decode(ana.ufficio_ved,'','',' U.'||ana.ufficio_ved)||
	    decode(ana.anno_atto_ved,'','','/'||ana.anno_atto_ved),
          ana.atto_ved_digitale) ATTO_VEDOVANZA_EDIT,
-- data_divorzio
	to_date(ana.data_div,'j') data_divorzio,
-- data_divorzio_annotazione
	to_date(ana.data_div_ann,'j') data_divorzio_annotazione,
-- data_divorzio_giudicato
	to_date(ana.data_div_giu,'j') data_divorzio_giudicato,
-- cod_provincia_divorzio
	lpad(ana.COD_PRO_div,3,'0') cod_provincia_divorzio,
-- cod_comune_divorzio
	lpad(ana.COD_COM_div,3,'0') cod_comune_divorzio,
-- comune_divorzio
       	com_div.descrizione||decode(com_div.sigla_provincia,'','',' ('||com_div.sigla_provincia||')') comune_divorzio,
-- cod_regione_divorzio
	substr(f_regione(ana.cod_pro_div),1,2) COD_REGIONE_divorzio,
-- regione_divorzio
	substr(f_regione(ana.cod_pro_div),3) REGIONE_divorzio,
-- nazione_divorzio
	f_nazione(ana.cod_pro_div,ana.cod_com_div) NAZIONE_divorzio,
-- gruppo_nazione_divorzio
	f_gruppo_nazioni(ana.cod_pro_div) GRUPPO_NAZIONE_divorzio,
-- atto_divorzio_edit
	decode(ana.atto_div_digitale,'',
          ana.atto_div||
	    DECODE(ANA.PARTE_div,'','',' P.'||decode(ana.PARTE_div,1,'I',2,'II'))||
	    decode(ana.serie_div,'','',' S.'||ana.serie_div)||
	    decode(ana.ufficio_div,'','',' U.'||ana.ufficio_div)||
	    decode(ana.anno_atto_div,'','','/'||ana.anno_atto_ved),
          ana.atto_div_digitale) ATTO_DIVORZIO_EDIT,
-- data_morte
	to_date(ana.data_mor,'j') data_morte,
-- cod_provincia_morte
	lpad(ana.COD_PRO_mor,3,'0') cod_provincia_morte,
-- cod_comune_morte
	lpad(ana.COD_COM_mor,3,'0') cod_comune_morte,
-- comune_morte
       	com_mor.descrizione||decode(com_mor.sigla_provincia,'','',' ('||com_mor.sigla_provincia||')') comune_morte,
-- cod_regione_morte
	substr(f_regione(ana.cod_pro_mor),1,2) COD_REGIONE_morte,
-- regione_morte
	substr(f_regione(ana.cod_pro_mor),3) REGIONE_morte,
-- nazione_morte
	f_nazione(ana.cod_pro_mor,ana.cod_com_mor) NAZIONE_morte,
-- gruppo_nazione_morte
	f_gruppo_nazioni(ana.cod_pro_mor) GRUPPO_NAZIONE_morte,
-- cod_provincia_atto_morte
	lpad(ana.COD_PRO_ATTO_mor,3,'0') COD_PROVINCIA_ATTO_morte,
-- cod_comune_atto_morte
	lpad(ana.COD_COM_ATTO_mor,3,'0') COD_COMUNE_ATTO_morte,
-- comune_atto_mor
        com_atto_mor.descrizione||decode(com_atto_mor.sigla_provincia,'','',' ('||com_atto_mor.sigla_provincia||')') comune_atto_morte,
-- cod_regione_atto_morte
	substr(f_regione(ana.cod_pro_atto_mor),1,2) COD_REGIONE_ATTO_morte,
-- regione_atto_morte
	substr(f_regione(ana.cod_pro_atto_mor),3) REGIONE_ATTO_morte,
-- atto_morte_edit
	decode(ana.atto_mor_digitale,'',
          ana.atto_mor||
	    DECODE(ANA.PARTE_mor,'','',' P.'||decode(ana.PARTE_mor,1,'I',2,'II'))||
	    decode(ana.serie_mor,'','',' S.'||ana.serie_mor)||
	    decode(ana.ufficio_mor,'','',' U.'||ana.ufficio_mor)||
	    decode(ana.anno_atto_mor,'','','/'||ana.anno_atto_mor),
          ana.atto_mor_digitale) ATTO_MORTE_EDIT,
-- DATA_indirizzo
	decode(ana.fascia,
          1, to_date(ana.data_inizio_res,'j'),
          2, to_date(eve_11.data_inizio,'j'),
	  3, to_date(ana.data_inizio_res,'j'),
          4, to_date(eve_13.data_inizio,'j')) DATA_INDIRIZZO,
-- indirizzo
	decode(ana.fascia,
          1, vie.denom_uff||fam.civico_esterno|| decode(nvl(upper(ainp.valore),'N'),'N','',' '||fam.civico_interno),
          2, vie_11.denom_uff||eve_11.civico_esterno|| decode(nvl(upper(ainp.valore),'N'),'N','',' '||eve_11.civico_interno),
	  3, fam.via_aire,
	  4, eve_13.via_aire,
          6, fam.via_res) INDIRIZZO,
-- indirizzo_int
       	decode(ana.fascia,
          1, vie.denom_uff||fam.civico_esterno||fam.civico_interno,
          2, vie_11.denom_uff||eve_11.civico_esterno||eve_11.civico_interno,
          3, fam.via_aire,
          4, eve_13.via_aire,
          6, fam.via_res) INDIRIZZO_INT,
-- cap_comune_residenza
	decode(ana.fascia,
          1, f_cap(fam.cod_via,fam.num_civ,fam.suffisso),
          2, f_cap(eve_11.cod_via,eve_11.num_civ,eve_11.suffisso),
          3, nvl(fam.zipcode,decode(com_air.cap,99999,to_char(null),to_char(com_air.cap))),
          4, nvl(eve_13.zipcode,decode(com_air_13.cap,99999,to_char(null),to_char(com_air_13.cap))),
          6, fam.via_res) cap_comune_residenza,
-- comune_residenza
	decode(ana.fascia,
          1, m.descrizione||' ('||m.sigla_provincia||')',
          2, m.descrizione||' ('||m.sigla_provincia||')',
          3, com_air.descrizione||' ('||com_air.sigla_provincia||')',
          4, com_air_13.descrizione||' ('||com_air_13.sigla_provincia||')',
          6, com_res.descrizione||' ('||com_res.sigla_provincia||')') comune_residenza,
-- cod_provincia_residenza
	decode(ana.fascia,
          1, lpad(m.cod_provincia,3,'0'),
          2, lpad(m.cod_provincia,3,'0'),
          3, lpad(com_air.cod_provincia,3,'0'),
          4, lpad(com_air_13.cod_provincia,3,'0'),
          6, lpad(com_res.cod_provincia,3,'0')) cod_provincia_residenza,
-- cod_comune_residenza
	decode(ana.fascia,
          1, lpad(m.cod_comune,3,'0'),
          2, lpad(m.cod_comune,3,'0'),
          3, lpad(com_air.cod_comune,3,'0'),
          4, lpad(com_air_13.cod_comune,3,'0'),
          6, lpad(com_res.cod_comune,3,'0')) cod_comune_residenza,
-- nazione_residenza
	decode(ana.fascia,
          1, f_nazione(m.cod_provincia,m.cod_comune),
          2, f_nazione(m.cod_provincia,m.cod_comune),
          3, f_nazione(com_air.cod_provincia,com_air.cod_comune),
          4, f_nazione(com_air_13.cod_provincia,com_air_13.cod_comune),
          6, f_nazione(com_res.cod_provincia,com_res.cod_comune)) nazione_residenza,
-- gruppo_nazione_residenza
	decode(ana.fascia,
          1, f_gruppo_nazioni(m.cod_provincia),
          2, f_gruppo_nazioni(m.cod_provincia),
          3, f_gruppo_nazioni(com_air.cod_provincia),
          4, f_gruppo_nazioni(com_air_13.cod_provincia),
          6, f_gruppo_nazioni(com_res.cod_provincia)) GRUPPO_NAZIONE_residenza,
-- codice_via
	decode(ana.fascia,
          1, fam.cod_via,
          2, eve_11.cod_via) codice_via,
-- denominazione_via
	decode(ana.fascia,
          1, vie.denom_uff,
          2, vie_11.denom_uff) denominazione_via,
-- denominazione_via_ordinamento
	decode(ana.fascia,
          1, vie.denom_ord,
          2, vie_11.denom_ord) denominazione_via_ordinamento,
-- numero_civico
	decode(ana.fascia,
          1, fam.num_civ,
          2, eve_11.num_civ) NUMERO_CIVICO,
-- suffisso
	decode(ana.fascia,
          1, fam.suffisso,
          2, eve_11.suffisso) suffisso,
-- interno
	decode(ana.fascia,
          1, fam.interno,
          2, eve_11.interno) interno,
-- sub_interno
	decode(ana.fascia,
          1, fam.sub_interno,
          2, eve_11.sub_interno) sub_interno,
-- scala
	decode(ana.fascia,
          1, fam.scala,
          2, eve_11.scala) scala,
-- piano
	decode(ana.fascia,
          1, fam.piano,
          2, eve_11.piano) piano,
-- codice ecografico
	to_char(null) codice_ecografico,
-- codice_famiglia
	ana.cod_fam CODICE_FAMIGLIA,
-- intestatario
	decode(ana.fascia,
          1, translate(fam.intestatario,'/',' '),
          3, translate(fam.intestatario,'/',' ')) intestatario,
-- convivenza
	decode(ana.fascia,
          1, fam.convivenza),
-- rapporto_par
	decode(ana.fascia,
          1, ana.rapporto_par,
          2, ana.rapporto_par,
          3, ana.rapporto_par,
          4, ana.rapporto_par) rapporto_par,
-- des_rapporto_par
	decode(ana.fascia,
          1, drp.descrizione,
          2, drp.descrizione,
          3, drp.descrizione,
          4, drp.descrizione) des_rapporto_par,
-- sequenza_par
	decode(ana.fascia,
          1, ana.sequenza_par,
          2, ana.sequenza_par,
          3, ana.sequenza_par,
          4, ana.sequenza_par) sequenza_par,
-- numero_familiari
	decode(ana.fascia,
          1, to_number(nfa.numero_familiari),
          3, to_number(nfa.numero_familiari)) numero_familiari,
-- numero_familiari_stranieri
	decode(ana.fascia,
          1, to_number(nfa.numero_familiari_str),
          3, to_number(nfa.numero_familiari_str)) numero_familiari_stranieri,
-- numero_familiari_preliminari
	decode(ana.fascia,
          1, to_number(nfa.num_fam_preliminari),
          3, to_number(nfa.num_fam_preliminari)) numero_familiari_preliminari,
-- numero_familiari_definitivi
	decode(ana.fascia,
          1, to_number(nfa.num_fam_definitivi),
          3, to_number(nfa.num_fam_definitivi)) numero_familiari_definitivi,
-- numero_figli
	decode(ana.fascia,
          1, to_number(nfa.figli),
          3, to_number(nfa.figli)) numero_figli,
-- numero_figli_minori
	decode(ana.fascia,
          1, to_number(nfa.figli_minori),
          3, to_number(nfa.figli_minori)) numero_figli_minori,
-- numero_ultra_64
	decode(ana.fascia,
          1, to_number(nfa.ultra_64),
          3, to_number(nfa.ultra_64)) numero_ultra_64,
-- numero_ultra_65
	decode(ana.fascia,
          1, to_number(nfa.ultra_65),
          3, to_number(nfa.ultra_65)) numero_ultra_65,
-- numero_ultra_75
	decode(ana.fascia,
          1, to_number(nfa.ultra_75),
          3, to_number(nfa.ultra_75)) numero_ultra_75 ,
-- nazionalita
	ana.nazionalita,
-- nazionalita_istat
	dci.ist_ci nazionalita_istat,
-- nazionalita_cee
	decode(dci.cee,'S','SI','NO') nazionalita_cee,
-- des_nazionalita
	dci.descrizione des_nazionalita,
-- gruppo_nazionalita
	f_gruppo_nazionalita(ana.nazionalita) GRUPPO_NAZIONALITA,
-- data_nazionalita
        to_date(ana.data_inizio_naz,'j') data_nazionalita,
-- titolo_studio
	ana.titolo_studio,
-- des_titolo_studio
	dts.descrizione des_titolo_studio,
-- gruppo_di_studio
	dts.gruppo gruppo_di_studio,
-- cod_prof
	ana.cod_prof,
-- des_professione
	dpr.descrizione des_professione,
-- attivita_prof
       dat.descrizione attivita_prof,
-- posizione_pro
	dpp.descrizione posizione_prof,
-- pensionato
       decode(ana.pensionato,1,'SI','NO') pensionato,
-- val_espatrio
	decode(ana.val_espatrio,'N','NO','SI') val_espatrio,
-- codice_fiscale
       	ana.cod_fiscale codice_fiscale,
-- codice_fiscale_calcolato
       	ana.cf_calcolato flag_cf_calcolato,
-- anno_censimento
       	ana.anno_cens anno_censimento,
-- sezione_censimento
	ana.sezione_cens sezione_censimento,
-- foglio_censimento
       	ana.foglio_cens foglio_censimento,
-- cod_edificio_censimento
	ana.cod_edificio_cens cod_edificio_censimento,
-- cod_stato_anagrafico
	ana.fascia cod_stato_anagrafico,
-- stato_anagrafico
	decode(ana.fascia,
          1, 'Iscritto in APR per ',
          2, 'Cancellato da APR per ',
          3, 'Iscritto in AIRE per ',
          4, 'Cancellato da AIRE per ')||
        dev.descrizione stato_anagrafico,
-- data_iscrizione
	decode(ana.fascia,
          1, to_date(ana.data_ult_eve,'j'),
          3, to_date(ana.data_ult_eve,'j')) data_iscrizione,
-- cod_provincia_iscr
	decode(ana.fascia,
          1, lpad(eve.cod_pro_eve,3,'0'),
          3, lpad(eve.cod_pro_eve,3,'0')) cod_provincia_iscr,
-- cod_comune_iscr
	decode(ana.fascia,
          1, lpad(eve.cod_com_eve,3,'0'),
          3, lpad(eve.cod_com_eve,3,'0')) cod_comune_iscr,
-- comune_iscrizione
       	decode(ana.fascia,
          1, com_eve.descrizione||decode(com_eve.sigla_provincia,'','',' ('||com_eve.sigla_provincia||')'),
          3, com_eve.descrizione||decode(com_eve.sigla_provincia,'','',' ('||com_eve.sigla_provincia||')')) comune_iscr,
-- cod_regione_iscr
	decode(ana.fascia,
          1, substr(f_regione(eve.cod_pro_eve),1,2),
          3, substr(f_regione(eve.cod_pro_eve),1,2)) COD_REGIONE_iscr,
-- regione_iscr
	decode(ana.fascia,
          1, substr(f_regione(eve.cod_pro_eve),3),
          3, substr(f_regione(eve.cod_pro_eve),3)) REGIONE_iscr,
-- cod_nazione_iscr
	decode(ana.fascia,
          1, com_eve0.cod_provincia,
          3, com_eve0.cod_provincia) cod_nazione_iscr,
-- nazione_iscr
	decode(ana.fascia,
          1, com_eve0.descrizione,
          3, com_eve0.descrizione) nazione_iscr,
-- gruppo_nazione_iscr
	decode(ana.fascia,
          1, f_gruppo_nazioni(eve.cod_pro_eve),
          3, f_gruppo_nazioni(eve.cod_pro_eve)) GRUPPO_NAZIONE_iscr,
-- pratica_iscr_edit
       	decode(ana.fascia,
          1, eve.pratica||'/'||eve.anno_pratica,
          3, eve.pratica||'/'||eve.anno_pratica) pratica_iscr_edit,
-- data_cancellazione
	decode(ana.fascia,
          2, to_date(ana.data_ult_eve,'j'),
          4, to_date(ana.data_ult_eve,'j')) data_cancellazione,
-- cod_provincia_canc
	decode(ana.fascia,
          2, lpad(eve.cod_pro_eve,3,'0'),
          4, lpad(eve.cod_pro_eve,3,'0')) cod_provincia_canc,
-- cod_comune_canc
	decode(ana.fascia,
          2, lpad(eve.cod_com_eve,3,'0'),
          4, lpad(eve.cod_com_eve,3,'0')) cod_comune_canc,
-- comune_cancellazione
       	decode(ana.fascia,
          2, com_eve.descrizione||decode(com_eve.sigla_provincia,'','',' ('||com_eve.sigla_provincia||')'),
          4, com_eve.descrizione||decode(com_eve.sigla_provincia,'','',' ('||com_eve.sigla_provincia||')')) comune_canc,
-- cod_regione_canc
	decode(ana.fascia,
          2, substr(f_regione(eve.cod_pro_eve),1,2),
          4, substr(f_regione(eve.cod_pro_eve),1,2)) COD_REGIONE_canc,
-- regione_canc
	decode(ana.fascia,
          2, substr(f_regione(eve.cod_pro_eve),3),
          4, substr(f_regione(eve.cod_pro_eve),3)) REGIONE_canc,
-- cod_nazione_canc
	decode(ana.fascia,
          2, com_eve0.cod_provincia,
          4, com_eve0.cod_provincia) cod_nazione_canc,
-- nazione_canc
	decode(ana.fascia,
          2, com_eve0.descrizione,
          4, com_eve0.descrizione) nazione_canc,
-- gruppo_nazione_canc
	decode(ana.fascia,
          2, f_gruppo_nazioni(eve.cod_pro_eve),
          4, f_gruppo_nazioni(eve.cod_pro_eve)) GRUPPO_NAZIONE_canc,
-- pratica_canc_edit
       	decode(ana.fascia,
          2, eve.pratica||'/'||eve.anno_pratica,
          4, eve.pratica||'/'||eve.anno_pratica) pratica_canc_edit,
-- data_ultima_variazione
       	to_date(ana.data_reg,'j') data_ultima_variazione,
-- tipo_DI
	wdi.tipo_DI,
-- des_tipo_DI
	ddo_DI.descrizione des_tipo_di,
-- numero_DI
       	wdi.numero_DI,
-- val_espatrio_di
	decode(wdi.numero_di,'','',decode(wdi.val_espatrio_di,'S','SI','NO')) val_espatrio_di,
-- data_emissione_DI
       	to_date(wdi.data_emissione_DI,'j') data_emissione_di,
-- data_scadenza_DI
       	to_date(wdi.data_scadenza_DI,'j') data_scadenza_di,
-- ente_emissione_DI
       	den_DI.descrizione||
	  decode(com_DI.descrizione,'','',' di '||com_DI.descrizione||' ('||com_DI.sigla_provincia||')') ente_emissione_di,
-- motivo_DI
	wdi.motivo_di,
-- des_motivo_DI
	dmd_DI.descrizione des_motivo_di,
-- tipo_DS
	str.tipo_DS,
-- des_tipo_DS
	ddo_DS.descrizione des_tipo_ds,
-- numero_DS
       	str.numero_DS,
-- data_emissione_DS
       	to_date(str.data_emissione_DS,'j') data_emissione_ds,
-- data_scadenza_DS
       	to_date(str.data_scadenza_DS,'j') data_emissione_ds,
-- ente_emissione_DS
       	den_DS.descrizione||
	  decode(com_DS.descrizione,'','',' di '||com_DS.descrizione||' ('||com_DS.sigla_provincia||')') ente_emissione_ds,
-- motivo_DS
	str.motivo_ds,
-- des_motivo_DS
	dmd_DS.descrizione des_motivo_ds,
-- cognome_nome_ele
       	translate(ele.cognome_nome,'/',' ')||
          decode(ele.sesso,'F',
            decode(ana.stato_civile,
              'CN',' in '||substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/')-1),
              'VE',' Ved. '||substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/')-1))) cognome_nome_ele,
-- indirizzo_ele
	decode(vie_ele.denom_uff,'',
	  ele.via_aire_ele,
          vie_ele.denom_uff||' '||ele.civico_esterno_ele||
            decode(nvl(upper(binp.valore),'N'),'N','',' '||ele.civico_interno_ele)) INDIRIZZO_ELE,
-- comune_aire_ele
	decode(com_air_ele.descrizione,'','',
          com_air_ele.descrizione||' ('||com_air_ele.sigla_provincia||')') comune_aire_ele,
-- stato_ele
       	ele.stato stato_ele,
-- anno_iscrizione_ele
	ele.anno anno_iscrizione_ele,
-- fascicolo_ele
	ele.fascicolo fascicolo_ele,
-- progr_lista_gen_ele
       	ele.progr_lista_gen progr_lista_gen_ele,
-- sezione_ele
	ele.sezione sezione_ele,
-- progr_lista_sez_ele
	ele.progr_lista_sez progr_lista_sez_ele,
-- tessera_ele
       	ele.tessera_ele,
-- data_tessera_ele
       	to_date(ele.data_tessera_ele,'j') data_tessera_ele,
-- verbale_ele
       	dsr.verbale verbale_ele,
-- data_verbale_ele
       	to_date(dsr.data_verbale,'j') data_verbale_ele,
-- stato_scrutatore_albo_S
        scr_s.stato stato_scrutatore_albo_s,
-- anno_scrutatore_albo_S
        scr_s.anno anno_scrutatore_albo_s,
-- stato_scrutatore_albgo_V
	scr_v.stato stato_scrutatore_albo_v,
-- anno_scrutatore_albgo_V
	scr_v.anno anno_scrutatore_albo_v,
-- stato_scrutatore_albo_r
        scr_r.stato stato_scrutatore_albo_r,
-- anno_scrutatore_albo_r
        scr_r.anno anno_scrutatore_albo_r,
-- stato_giudice_albo_a
	gpo_a.stato stato_giudice_albo_a,
-- anno_giudice_albo_a
	gpo_a.anno anno_giudice_albo_a,
-- stato_giudice_albo_p
	gpo_p.stato stato_giudice_albo_p,
-- anno_giudice_albo_p
	gpo_p.anno anno_giudice_albo_p,
-- stato_presidente_seggio
	pse.stato stato_presidente_seggio,
-- anno_presidente_seggio
	pse.anno anno_presidente_seggio,
-- matricola_militare
       	lev.matricola_mil matricola_militare,
-- classe_leva
       	lev.classe classe_leva,
-- numero_lista_leva
	lev.numero_lista numero_lista_leva,
-- esito_leva
       	lev.esito esito_leva,
-- des_esito_leva
	des.descrizione des_esito_leva,
-- comune_leva
       	com_lev.descrizione||' ('||com_lev.sigla_provincia||')' comune_leva,
-- comune_distretto
       	com_dis.descrizione||' ('||com_dis.sigla_provincia||')' comune_distretto,
-- data_arruolamento
       	to_date(lev.data_arr,'j') data_arruolamento,
-- data_chiamata
       	to_date(lev.data_chi,'j') data_chiamata,
-- data_congedo
       	to_date(lev.data_con,'j') data_congedo,
-- arma
       	lev.arma,
-- des_arma
	dar.descrizione des_arma,
-- corpo
 	lev.corpo,
-- des_corpo
	dco.descrizione des_corpo,
-- grado
	lev.grado,
-- des_grado
	dgr.descrizione des_grado,
-- des_unita_territoriale...
	 rtrim(substr(f_unita_territoriale(1, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_1,
	 substr(f_unita_territoriale(1, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_1,
	 rtrim(substr(f_unita_territoriale(1, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_1,
	 rtrim(substr(f_unita_territoriale(2, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_2,
	 substr(f_unita_territoriale(2, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_2,
	 rtrim(substr(f_unita_territoriale(2, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_2,
	 rtrim(substr(f_unita_territoriale(3, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_3,
	 substr(f_unita_territoriale(3, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_3,
	 rtrim(substr(f_unita_territoriale(3, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_3,
	 rtrim(substr(f_unita_territoriale(4, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_4,
	 substr(f_unita_territoriale(4, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_4,
	 rtrim(substr(f_unita_territoriale(4, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_4,
	 rtrim(substr(f_unita_territoriale(5, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_5,
	 substr(f_unita_territoriale(5, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_5,
	 rtrim(substr(f_unita_territoriale(5, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_5,
	 rtrim(substr(f_unita_territoriale(6, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_6,
	 substr(f_unita_territoriale(6, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_6,
	 rtrim(substr(f_unita_territoriale(6, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_6,
	 rtrim(substr(f_unita_territoriale(7, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_7,
	 substr(f_unita_territoriale(7, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_7,
	 rtrim(substr(f_unita_territoriale(7, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_7,
	 rtrim(substr(f_unita_territoriale(8, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_8,
	 substr(f_unita_territoriale(8, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_8,
	 rtrim(substr(f_unita_territoriale(8, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_8,
	 rtrim(substr(f_unita_territoriale(9, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_9,
	 substr(f_unita_territoriale(9, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_9,
	 rtrim(substr(f_unita_territoriale(9, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_9,
	 rtrim(substr(f_unita_territoriale(10, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_10,
	 substr(f_unita_territoriale(10, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_10,
	 rtrim(substr(f_unita_territoriale(10, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_10,
	 rtrim(substr(f_unita_territoriale(99, fam.cod_via, fam.num_civ, fam.suffisso),1,20)) des_unita_territoriale_CAP,
	 substr(f_unita_territoriale(99, fam.cod_via, fam.num_civ, fam.suffisso),21,4) codice_suddivisione_CAP,
	 rtrim(substr(f_unita_territoriale(99, fam.cod_via, fam.num_civ, fam.suffisso),25,30)) des_suddivisione_CAP,
-- RECAPITO_CELLULARE
         f_recapito_individuo(ana.matricola,'S') recapito_cellulare,
-- RECAPITO_TELEFONO_FISSO
         f_recapito_individuo(ana.matricola,'f') recapito_telefono_fisso,
-- RECAPITO_EMAIL
         f_recapito_individuo(ana.matricola,'E') recapito_email,
-- DOMICILIO_DIGITALE
         f_domicilio_digitale(ana.matricola) domicilio_digitale
  from arcinp ainp, arcinp binp, anadev dev,
       	arccom m,
        arccom com_nas, arccom com_atto_nas,
        arccom com_mat, arccom com_ved, arccom com_div,
        arccom com_eve, arccom com_eve0,
	arccom com_lev, arccom com_dis,
	arccom com_air, arccom com_air_ele, arccom com_air_13,
        arccom com_mor, arccom com_atto_mor,
       	arccom com_DI, arccom com_DS,
        arccom com_res,
	arcvie vie, arcvie vie_ele, arcvie vie_11,
       	levdgr dgr, levdar dar, levdco dco, levdes des, levruo lev,
	anadat dat, anadpp dpp, anadpr dpr,
	anadts dts, anadci dci, anadsc dsc,
        anadrp drp,
       	eleasc scr_v, eleasc scr_s, eleasc scr_r,
	eleagp gpo_a, eleagp gpo_p, eleaps pse,
	eledsr dsr, eleana ele,
	anaden den_DI, anaden den_DS,
	anadmd dmd_DI, anadmd dmd_DS,
	anaddo ddo_DI, anaddo ddo_DS,
        anastr str, anawdi wdi,
        anaana ana_cn, anaana ana_pd, anaana ana_md,
        anaeve eve, anaeve eve_11, anaeve eve_13,
	ananfa nfa, anafam fam, anaana ana
 where ainp.parametro	     		= 'INTERNO_S'
   and binp.parametro	     		= 'INTERNO_E'
   and (m.cod_provincia,m.cod_comune) = (select pro_cliente,com_cliente
					   from menuditta)
   and dev.cod_ev               (+)     = ana.stato
   and com_res.cod_provincia 		(+) = fam.cod_pro_res
   and com_res.cod_comune    		(+) = fam.cod_com_res
   and com_air.cod_provincia 		(+) = fam.cod_pro_aire
   and com_air.cod_comune    		(+) = fam.cod_com_aire
   and com_air_ele.cod_provincia 	(+) = ele.cod_pro_aire_ele
   and com_air_ele.cod_comune    	(+) = ele.cod_com_aire_ele
   and com_air_13.cod_provincia 	(+) = eve_13.cod_pro_aire
   and com_air_13.cod_comune    	(+) = eve_13.cod_com_aire
   and vie_ele.cod_via 		(+)     = ele.cod_via_ele
   and des.cod_es		(+)	= lev.esito
   and dco.cod_co		(+)	= lev.corpo
   and dar.cod_ar		(+)	= lev.arma
   and dgr.cod_gr		(+)	= lev.grado
   and com_lev.cod_provincia 		(+) = lev.cod_pro_lev
   and com_lev.cod_comune    		(+) = lev.cod_com_lev
   and com_dis.cod_provincia 		(+) = lev.cod_pro_dis
   and com_dis.cod_comune    		(+) = lev.cod_com_dis
   and lev.matricola   		(+)   	= ana.matricola
   and dsr.anno			(+)	= ele.anno
   and dsr.revisione		(+)	= ele.revisione
   and dsr.progr_revisione	(+)	= ele.progr_revisione
   and ele.matricola 		(+)    	= ana.matricola
   and pse.matricola 		(+)    	= ana.matricola
   and gpo_a.albo      		(+)   	= 'S'
   and gpo_a.matricola 		(+)   	= ana.matricola
   and gpo_p.albo      		(+)   	= 'P'
   and gpo_p.matricola 		(+)   	= ana.matricola
   and scr_s.albo      		(+)   	= 'S'
   and scr_s.matricola 		(+)   	= ana.matricola
   and scr_v.albo      		(+)   	= 'V'
   and scr_v.matricola 		(+)   	= ana.matricola
   and scr_r.albo      		(+)   	= 'R'
   and scr_r.matricola 		(+)   	= ana.matricola
   and dsc.cod_sc            		= ana.stato_civile
   and dsc.sesso             		= ana.sesso
   and com_nas.cod_comune          	    = ana.cod_com_nas
   and com_nas.cod_provincia       	    = ana.cod_pro_nas
   and com_atto_nas.cod_comune		(+) = ana.cod_com_atto_nas
   and com_atto_nas.cod_provincia	(+) = ana.cod_pro_atto_nas
   and com_mat.cod_comune		(+) = ana.cod_com_mat
   and com_mat.cod_provincia		(+) = ana.cod_pro_mat
   and com_ved.cod_comune		(+) = ana.cod_com_ved
   and com_ved.cod_provincia		(+) = ana.cod_pro_ved
   and com_div.cod_comune		(+) = ana.cod_com_div
   and com_div.cod_provincia		(+) = ana.cod_pro_div
   and com_mor.cod_comune          	(+) = ana.cod_com_mor
   and com_mor.cod_provincia       	(+) = ana.cod_pro_mor
   and com_atto_mor.cod_comune		(+) = ana.cod_com_atto_mor
   and com_atto_mor.cod_provincia	(+) = ana.cod_pro_atto_mor
   and com_eve0.cod_comune		(+) = 0
   and com_eve0.cod_provincia		(+) = eve.cod_pro_eve
   and com_eve.cod_comune		(+) = eve.cod_com_eve
   and com_eve.cod_provincia		(+) = eve.cod_pro_eve
   and com_DI.cod_comune	(+)     = wdi.cod_com_ente_di
   and com_DI.cod_provincia	(+)    	= wdi.cod_pro_ente_di
   and dmd_DI.cod_md		(+)	= wdi.motivo_di
   and den_DI.cod_en		(+)	= wdi.ente_emissione_di
   and ddo_DI.cod_do		(+)	= wdi.tipo_di
   and wdi.matricola       	(+) 	= ana.matricola
   and com_DS.cod_comune	(+)     = str.cod_com_ente_ds
   and com_DS.cod_provincia	(+)    	= str.cod_pro_ente_ds
   and dmd_DS.cod_md		(+)	= str.motivo_ds
   and den_DS.cod_en		(+)	= str.ente_emissione_ds
   and ddo_DS.cod_do		(+)	= str.tipo_ds
   and str.matricola       	(+) 	= ana.matricola
   and ana_cn.matricola		(+)	= ana.matricola_cn
   and ana_pd.matricola		(+)	= ana.matricola_pd
   and ana_md.matricola		(+)	= ana.matricola_md
--
   and eve_13.data_eve 		(+)     = ana.data_ult_eve - 1
   and eve_13.cod_eve		(+)	= ana.stato
   and eve_13.cod_mov		(+)	= 13
   and eve_13.matricola		(+)	= ana.matricola
   and vie_11.cod_via     	(+)  	= eve_11.cod_via
   and eve_11.data_eve 		(+)     = ana.data_ult_eve - 1
   and eve_11.cod_eve		(+)	= ana.stato
   and eve_11.cod_mov		(+)	= 11
   and eve_11.matricola		(+)	= ana.matricola
   and eve.data_eve 		(+)     = ana.data_ult_eve
   and eve.cod_eve		(+)	= ana.stato
   and eve.cod_mov		(+)	= ana.fascia
   and eve.matricola		(+)	= ana.matricola
--
   and dci.cod_ci      		(+)   	= ana.nazionalita
   and dpp.cod_pp      		(+)   	= ana.posizione_prof
   and dat.cod_at      		(+)   	= ana.attivita_prof
   and dts.cod_ts      		(+)   	= ana.titolo_studio
   and dpr.sesso       		(+)   	= ana.sesso
   and dpr.cod_pr      		(+)  	= ana.cod_prof
   and drp.sesso       		(+)   	= ana.sesso
   and drp.cod_rp      		(+)   	= ana.rapporto_par
   and vie.cod_via     		(+)   	= fam.cod_via
   and nfa.cod_fam     		(+)   	= fam.cod_fam
   and nfa.fascia      		(+)   	= fam.fascia
   and fam.cod_fam     		(+)   	= ana.cod_fam
   and fam.fascia      		(+)   	= ana.fascia
--   and ana.fascia + 0  	      		in (1,3)
/
comment on table ANAVBI_TOTALE is 'Statistiche Anagrafe - Individui Residenti e AIRE - Iscritti e Cancellati (view)'
/
