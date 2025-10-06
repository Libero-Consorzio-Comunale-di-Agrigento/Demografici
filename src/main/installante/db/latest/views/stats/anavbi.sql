--liquibase formatted sql
--changeset amonopoli:202411191555_2 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW ANAVBI
(MATRICOLA,
 FLAG_RESIDENTE, FLAG_AIRE, FLAG_SENZA_FISSA_DIMORA, FLAG_ISCRITTO_PRELIMINARE, FLAG_ISCRITTO_DEFINITIVO,
 COGNOME_NOME, COGNOME, NOME, SESSO, DATA_NASCITA, DATA_NASCITA_EDIT, ANNO_NASCITA,
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
 INDIRIZZO, INDIRIZZO_INT, CAP_COMUNE_RESIDENZA, COMUNE_RESIDENZA,
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
 PENSIONATO, PENSIONATO_INPS, VAL_ESPATRIO,
 CODICE_FISCALE, FLAG_CF_CALCOLATO,
 ANNO_CENSIMENTO, SEZIONE_CENSIMENTO, FOGLIO_CENSIMENTO, COD_EDIFICIO_CENSIMENTO,
 DATA_ISCRIZIONE, DATA_IMMIGRAZIONE, COD_PROVINCIA_IMMI, COD_COMUNE_IMMI, COMUNE_IMMI,
 COD_REGIONE_IMMI, REGIONE_IMMI, NAZIONE_IMMI, GRUPPO_NAZIONE_IMMI,
 PRATICA_IMMI_EDIT,
 DATA_ULTIMA_VARIAZIONE,
 TIPO_DI, DES_TIPO_DI, NUMERO_DI, VAL_ESPATRIO_DI, DATA_EMISSIONE_DI, DATA_SCADENZA_DI, ENTE_EMISSIONE_DI,
 MOTIVO_DI, DES_MOTIVO_DI,
 TIPO_DS, DES_TIPO_DS,  NUMERO_DS, DATA_EMISSIONE_DS, DATA_SCADENZA_DS, ENTE_EMISSIONE_DS,
 MOTIVO_DS, DES_MOTIVO_DS,
 NUMERO_CI, VAL_ESPATRIO_CI, DATA_EMISSIONE_CI, DATA_SCADENZA_CI, ENTE_EMISSIONE_CI, MOTIVO_CI, DES_MOTIVO_CI,
 NUMERO_CIE, VAL_ESPATRIO_CIE, DATA_EMISSIONE_CIE, DATA_SCADENZA_CIE, ENTE_EMISSIONE_CIE, MOTIVO_CIE, DES_MOTIVO_CIE,
 NUMERO_PS, DATA_EMISSIONE_PS, DATA_SCADENZA_PS, ENTE_EMISSIONE_PS, MOTIVO_PS, DES_MOTIVO_PS,
 NUMERO_CS, DATA_EMISSIONE_CS, DATA_SCADENZA_CS, ENTE_EMISSIONE_CS, MOTIVO_CS, DES_MOTIVO_CS,
 NUMERO_U1, DATA_EMISSIONE_U1, DATA_SCADENZA_U1, ENTE_EMISSIONE_U1, MOTIVO_U1, DES_MOTIVO_U1,
 NUMERO_U2, DATA_EMISSIONE_U2, DATA_SCADENZA_U2, ENTE_EMISSIONE_U2, MOTIVO_U2, DES_MOTIVO_U2,
 NUMERO_RP, DATA_EMISSIONE_RP, DATA_SCADENZA_RP, ENTE_EMISSIONE_RP, MOTIVO_RP, DES_MOTIVO_RP,
 NUMERO_LL, DATA_EMISSIONE_LL, ENTE_EMISSIONE_LL,
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
-- flag_iscritto_preliminare
	decode(ana.fascia, 1, decode(ana.stato,17,'SI','NO'), 'NO') flag_iscritto_preliminare,
-- flag_iscritto_definitivo
	decode(ana.fascia, 1, decode(ana.stato,17,'NO','SI'), 'NO') flag_iscritto_definitivo,
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
       	a.descrizione||' ('||a.sigla_provincia||')' comune_nascita,
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
        h.descrizione||' ('||h.sigla_provincia||')' comune_atto_nascita,
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
	  'VE',translate(ana.cognome_nome_cn,'/',' '),'') cognome_nome_coniuge,
-- cognome_coniuge
       decode(ana.stato_civile,
	   'CN',substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/') - 1),
	   'VE',substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/') - 1),'') cognome_coniuge,
-- nome_coniuge
       decode(ana.stato_civile,
         'CN',substr(ana.cognome_nome_cn,instr(ana.cognome_nome_cn,'/') + 1),
         'VE',substr(ana.cognome_nome_cn,instr(ana.cognome_nome_cn,'/') + 1),'') nome_coniuge,
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
       	b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')') comune_matrimonio,
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
       	c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') comune_vedovanza,
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
       	d.descrizione||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')') comune_divorzio,
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
-- indirizzo
       	decode(ana.fascia,1,
          vie.denom_uff||' '||fam.civico_esterno||
	    decode(nvl(upper(ainp.valore),'N'),'N','',' '||fam.civico_interno),
	  fam.via_aire)	INDIRIZZO,
-- indirizzo_int
       	decode(ana.fascia,1,
	  vie.denom_uff||' '||fam.num_civ||
       	    decode(fam.suffisso,'','','/'||fam.suffisso)||
            decode(fam.scala,'','',' S.'||fam.scala)||
            decode(fam.piano,'','',' P.'||fam.piano)||
            decode(fam.interno,'','',' int.'||fam.interno),
	  fam.via_aire) INDIRIZZO_INT,
-- cap_comune_residenza
       decode(ana.fascia,1,
         f_cap(fam.cod_via,fam.num_civ,fam.suffisso),
         nvl(fam.zipcode,decode(n.cap,99999,to_char(null),to_char(n.cap)))) cap_comune_residenza,
-- comune_residenza
       decode(ana.fascia,1,
         m.descrizione||' ('||m.sigla_provincia||')',
         n.descrizione||' ('||n.sigla_provincia||')') comune_residenza,
-- cod_provincia_residenza
       decode(ana.fascia,1,
         lpad(m.cod_provincia,3,'0'),
         lpad(n.cod_provincia,3,'0')) cod_provincia_residenza,
-- cod_comune_residenza
       decode(ana.fascia,1,
         lpad(m.cod_comune,3,'0'),
         lpad(n.cod_comune,3,'0')) cod_comune_residenza,
-- nazione_residenza
       decode(ana.fascia,1,
         f_nazione(m.cod_provincia,m.cod_comune),
         f_nazione(n.cod_provincia,n.cod_comune)) nazione_residenza,
-- gruppo_nazione_residenza
	f_gruppo_nazioni(
	  decode(ana.fascia,1,m.cod_provincia,n.cod_provincia)) GRUPPO_NAZIONE_residenza,
-- codice_via
	fam.cod_via codice_via,
-- denominazione_via
	vie.denom_uff denominazione_via,
-- denominazione_via_ordinamento
       	vie.denom_ord denominazione_via_ordinamento,
-- numero_civico
      	fam.num_civ NUMERO_CIVICO,
-- suffisso
	fam.suffisso,
-- interno
	fam.interno,
-- sub_interno
	fam.sub_interno,
-- scala
	fam.scala,
-- piano
	fam.piano,
-- codice ecografico
	to_char(null) codice_ecografico,
-- codice_famiglia
	ana.cod_fam CODICE_FAMIGLIA,
-- intestatario
	translate(fam.intestatario,'/',' ') intestatario,
-- convivenza
	fam.convivenza,
-- rapporto_par
       	ana.rapporto_par,
-- des_rapporto_par
	drp.descrizione des_rapporto_par,
-- sequenza_par
	ana.sequenza_par,
-- numero_familiari
       	to_number(nfa.numero_familiari) numero_familiari,
-- numero_familiari_stranieri
        to_number(nfa.numero_familiari_str) numero_familiari_stranieri,
-- numero_familiari_preliminari
        to_number(nfa.num_fam_preliminari) numero_familiari_preliminari,
-- numero_familiari_definitivi
        to_number(nfa.num_fam_definitivi) numero_familiari_definitivi,
-- numero_figli
	to_number(nfa.figli) numero_figli,
-- numero_figli_minori
	to_number(nfa.figli_minori) numero_figli_minori,
-- numero_ultra_64
	to_number(nfa.ultra_64) numero_ultra_64,
-- numero_ultra_65
	to_number(nfa.ultra_65) numero_ultra_65,
-- numero_ultra_75
	to_number(nfa.ultra_75) numero_ultra_75 ,
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
-- pensionato_inps
       	decode(doc_LP.ente_emissione,2,'SI','NO') pensionato_inps,
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
-- data_iscrizione
	to_date(ana.data_ult_eve,'j') data_iscrizione,
-- data_immigrazione
	decode(ana.fascia,1,
	  decode(ana.stato,1,to_date(null),to_date(ana.data_ult_eve,'j'))) data_immigrazione,
-- cod_provincia_immi
	decode(ana.fascia,1,
	  decode(ana.stato,1,to_char(null),lpad(eve.cod_pro_eve,3,'0'))) cod_provincia_immi,
-- cod_comune_immi
	decode(ana.fascia,1,
	  decode(ana.stato,1,to_char(null),lpad(eve.cod_pro_eve,3,'0'))) cod_comune_immi,
-- comune_immigrazione
       	decode(ana.fascia,1,
	  decode(ana.stato,1,to_char(null),e.descrizione||decode(e.sigla_provincia,'','',' ('||e.sigla_provincia||')'))) comune_immi,
-- cod_regione_immi
	decode(ana.fascia,1,
	  decode(ana.stato,1,to_char(null),f_regione(eve.cod_pro_eve))) COD_REGIONE_immi,
-- regione_immi
	decode(ana.fascia,1,
	  decode(ana.stato,1,to_char(null),f_regione(eve.cod_pro_eve))) REGIONE_immi,
-- nazione_immi
	decode(ana.fascia,1,
	  decode(ana.stato,1,to_char(null),s.descrizione)) nazione_immi,
-- gruppo_nazione_immi
	decode(ana.fascia,1,
	  decode(ana.stato,1,to_char(null),f_gruppo_nazioni(eve.cod_pro_eve))) GRUPPO_NAZIONE_immi,
-- pratica_immi_edit
       	decode(ana.fascia,1,
	  decode(ana.stato,1,to_char(null),eve.pratica||'/'||eve.anno_pratica)) pratica_immi_edit,
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
-- numero_CI
       	doc_CI.numero numero_CI,
-- val_espatrio_Ci
	decode(doc_CI.numero,'','',
	  decode(doc_CI.espatrio,'S','SI','NO')) val_espatrio_Ci,
-- data_emissione_ci
       	to_date(doc_CI.data_emissione,'j') data_emissione_Ci,
-- data_scadenza_ci
       	to_date(doc_CI.data_scadenza,'j') data_scadenza_ci,
-- ente_emissione_ci
       	decode(den_CI.descrizione,'','',den_CI.descrizione||' di ')||
	  com_CI.descrizione||' ('||com_CI.sigla_provincia||')' ente_emissione_ci,
-- motivo_ci
       	doc_CI.motivo_documento motivo_ci,
-- des_motivo_ci
       	dmd_CI.descrizione des_motivo_ci,
-- numero_cie
       	doc_CE.numero numero_cie,
-- validita_espatrio_cie
	decode(doc_CE.numero,'','',decode(doc_CE.espatrio,'S','SI','NO')) val_espatrio_cie,
-- data_emissione_cie
       	to_date(doc_CE.data_emissione,'j') data_emissione_cie,
-- data_scadenza_cie
       	to_date(doc_CE.data_scadenza,'j') data_scadenza_cie,
-- ente_emissione_cie
       	decode(den_CE.descrizione,'','',den_CE.descrizione||' di ')||
	  com_CE.descrizione||' ('||com_CE.sigla_provincia||')' ente_emissione_cie,
-- motivo_cie
       	doc_CE.motivo_documento motivo_cie,
-- des_motivo_cie
       	dmd_CE.descrizione des_motivo_cie,
-- numero_ps
       	doc_PS.numero numero_ps,
-- data_emissione_ps
       	to_date(doc_PS.data_emissione,'j') data_emissione_ps,
-- data_scadenza_ps
       	to_date(doc_PS.data_scadenza,'j') data_scadenza_ps,
-- ente_emissione_ps
        decode(den_PS.descrizione,'','',den_PS.descrizione||' di ')||
	  com_PS.descrizione||' ('||com_PS.sigla_provincia||')' ente_emissione_ps,
-- motivo_PS
       	doc_PS.motivo_documento motivo_PS,
-- des_motivo_PS
       	dmd_PS.descrizione des_motivo_PS,
-- numero_cs
       	doc_CS.numero NUMERO_CS,
-- data_emissione_cs
       	to_date(doc_CS.data_emissione,'j') data_emissione_cs,
-- data_scadenza_cs
       to_date(doc_CS.data_scadenza,'j') data_scadenza_cs,
-- ente_emissione_cs
	decode(den_CS.descrizione,'','',den_CS.descrizione||' di ')||
	  com_CS.descrizione||' ('||com_CS.sigla_provincia||')' ente_emissione_cs,
-- motivo_CS
       	doc_CS.motivo_documento motivo_CS,
-- des_motivo_CS
       	dmd_CS.descrizione des_motivo_CS,
-- numero_U1
       	doc_U1.numero NUMERO_U1,
-- data_emissione_U1
       	to_date(doc_U1.data_emissione,'j') data_emissione_U1,
-- data_scadenza_U1
       to_date(doc_U1.data_scadenza,'j') data_scadenza_U1,
-- ente_emissione_U1
	decode(den_U1.descrizione,'','',den_U1.descrizione||' di ')||
	  com_U1.descrizione||' ('||com_U1.sigla_provincia||')' ente_emissione_U1,
-- motivo_U1
       	doc_U1.motivo_documento motivo_U1,
-- des_motivo_U1
       	dmd_U1.descrizione des_motivo_U1,
-- numero_U2
       	doc_U2.numero NUMERO_U2,
-- data_emissione_U2
       	to_date(doc_U2.data_emissione,'j') data_emissione_U2,
-- data_scadenza_U2
       to_date(doc_U2.data_scadenza,'j') data_scadenza_U2,
-- ente_emissione_U2
	decode(den_U2.descrizione,'','',den_U2.descrizione||' di ')||
	  com_U2.descrizione||' ('||com_U2.sigla_provincia||')' ente_emissione_U2,
-- motivo_U2
       	doc_U2.motivo_documento motivo_U2,
-- des_motivo_U2
       	dmd_U2.descrizione des_motivo_U2,
-- numero_RP
       	doc_RP.numero NUMERO_RP,
-- data_emissione_RP
       	to_date(doc_RP.data_emissione,'j') data_emissione_RP,
-- data_scadenza_RP
       to_date(doc_RP.data_scadenza,'j') data_scadenza_RP,
-- ente_emissione_RP
	decode(den_RP.descrizione,'','',den_RP.descrizione||' di ')||
	  com_RP.descrizione||' ('||com_RP.sigla_provincia||')' ente_emissione_RP,
-- motivo_RP
       	doc_RP.motivo_documento motivo_RP,
-- des_motivo_RP
       	dmd_RP.descrizione des_motivo_RP,
-- numero_ll
       	doc_LL.numero  numero_ll,
-- data_emissione_ll
       	to_date(doc_LL.data_emissione,'j') data_emissione_ll,
-- ente_emissione_ll
	decode(den_LL.descrizione,'','',den_LL.descrizione||' di ')||
	  com_LL.descrizione||' ('||com_LL.sigla_provincia||')' ente_emissione_ll,
-- cognome_nome_ele
       	translate(ele.cognome_nome,'/',' ')||
          decode(ele.sesso,'F',
            decode(ana.stato_civile,
              'CN',' in '||substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/')-1),
              'VE',' Ved. '||substr(ana.cognome_nome_cn,1,instr(ana.cognome_nome_cn,'/')-1))) cognome_nome_ele,
-- indirizzo_ele
	decode(bvie.denom_uff,'',
	  ele.via_aire_ele,
          bvie.denom_uff||' '||ele.civico_esterno_ele||
            decode(nvl(upper(binp.valore),'N'),'N','',' '||ele.civico_interno_ele)) INDIRIZZO_ELE,
-- comune_aire_ele
	decode(p.descrizione,'','',
          p.descrizione||' ('||p.sigla_provincia||')') comune_aire_ele,
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
       	i.descrizione||' ('||i.sigla_provincia||')' comune_leva,
-- comune_distretto
       	l.descrizione||' ('||l.sigla_provincia||')' comune_distretto,
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
  from arcinp ainp, arcinp binp,
       	arccom a,arccom b,arccom c,arccom d,arccom e,
	arccom h,arccom i,arccom l,arccom m,
	arccom n,arccom p,arccom s,
       	arccom com_DI, arccom com_DS,
        arccom com_CI, arccom com_CE, arccom com_LL,
       	arccom com_PS, arccom com_CS,
	arccom com_U1, arccom com_U2, arccom com_RP,
	arcvie vie, arcvie bvie,
       	levdgr dgr, levdar dar, levdco dco, levdes des, levruo lev,
	anadat dat, anadpp dpp, anadpr dpr,
	anadts dts, anadci dci, anadrp drp, anadsc dsc,
       	eleasc scr_v, eleasc scr_s, eleasc scr_r,
	eleagp gpo_a, eleagp gpo_p, eleaps pse,
	eledsr dsr, eleana ele,
	anaden den_DI, anaden den_DS,
        anaden den_CI, anaden den_CE, anaden den_LL,
	anaden den_PS, anaden den_CS,
	anaden den_U1, anaden den_U2, anaden den_RP,
	anadmd dmd_DI, anadmd dmd_DS,
	anadmd dmd_CI, anadmd dmd_CE,
	anadmd dmd_PS, anadmd dmd_CS,
	anadmd dmd_U1, anadmd dmd_U2, anadmd dmd_RP,
	anaddo ddo_DI, anaddo ddo_DS,
	anadoc doc_CI, anadoc doc_CE, anadoc doc_LL,
	anadoc doc_LP, anadoc doc_PS, anadoc doc_CS,
	anadoc doc_U1, anadoc doc_U2, anadoc doc_RP,
        anastr str, anawdi wdi,
        anaana ana_cn, anaana ana_pd, anaana ana_md,
	ananfa nfa, anaeve eve, anafam fam, anaana ana
 where ainp.parametro	     		= 'INTERNO_S'
   and binp.parametro	     		= 'INTERNO_E'
   and (m.cod_provincia,m.cod_comune) = (select pro_cliente,com_cliente
					   from menuditta)
   and n.cod_provincia 		(+)   	= fam.cod_pro_aire
   and n.cod_comune    		(+)   	= fam.cod_com_aire
   and p.cod_provincia 		(+)   	= ele.cod_pro_aire_ele
   and p.cod_comune    		(+)   	= ele.cod_com_aire_ele
   and bvie.cod_via 		(+)     = ele.cod_via_ele
   and des.cod_es		(+)	= lev.esito
   and dco.cod_co		(+)	= lev.corpo
   and dar.cod_ar		(+)	= lev.arma
   and dgr.cod_gr		(+)	= lev.grado
   and i.cod_provincia 		(+)   	= lev.cod_pro_lev
   and i.cod_comune    		(+)   	= lev.cod_com_lev
   and l.cod_provincia 		(+)   	= lev.cod_pro_dis
   and l.cod_comune    		(+)   	= lev.cod_com_dis
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
   and a.cod_comune          		= ana.cod_com_nas
   and a.cod_provincia       		= ana.cod_pro_nas
   and h.cod_comune		(+)     = ana.cod_com_atto_nas
   and h.cod_provincia		(+)    	= ana.cod_pro_atto_nas
   and b.cod_comune		(+)     = ana.cod_com_mat
   and b.cod_provincia		(+)    	= ana.cod_pro_mat
   and c.cod_comune		(+)     = ana.cod_com_ved
   and c.cod_provincia		(+)    	= ana.cod_pro_ved
   and d.cod_comune		(+)     = ana.cod_com_div
   and d.cod_provincia		(+)    	= ana.cod_pro_div
   and s.cod_comune		(+)     = 0
   and s.cod_provincia		(+)    	= eve.cod_pro_eve
   and e.cod_comune		(+)     = eve.cod_com_eve
   and e.cod_provincia		(+)    	= eve.cod_pro_eve
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
   and com_CI.cod_comune	(+)     = doc_CI.cod_com_ente
   and com_CI.cod_provincia	(+)    	= doc_CI.cod_pro_ente
   and dmd_CI.cod_md		(+)	= doc_CI.motivo_documento
   and den_CI.cod_en		(+)	= doc_CI.ente_emissione
   and doc_CI.natura_documento	(+) 	!= 'A'
   and doc_CI.progr_documento 	(+) 	= 1
   and doc_CI.tipo_documento  	(+) 	= 'CI'
   and doc_CI.matricola       	(+) 	= ana.matricola
   and com_CE.cod_comune	(+)     = doc_CE.cod_com_ente
   and com_CE.cod_provincia	(+)    	= doc_CE.cod_pro_ente
   and dmd_CE.cod_md		(+)	= doc_CE.motivo_documento
   and den_CE.cod_en		(+)	= doc_CE.ente_emissione
   and doc_CE.natura_documento	(+) 	!= 'A'
   and doc_CE.progr_documento 	(+) 	= 1
   and doc_CE.tipo_documento  	(+) 	= 'CE'
   and doc_CE.matricola       	(+) 	= ana.matricola
   and com_LL.cod_comune	(+)     = doc_LL.cod_com_ente
   and com_LL.cod_provincia	(+)    	= doc_LL.cod_pro_ente
   and den_LL.cod_en		(+)	= doc_LL.ente_emissione
   and doc_LL.natura_documento	(+) 	!= 'A'
   and doc_LL.progr_documento 	(+) 	= 1
   and doc_LL.tipo_documento  	(+) 	= 'LL'
   and doc_LL.matricola       	(+) 	= ana.matricola
   and nvl(doc_LP.progr_documento,0) = (select nvl(min(b.progr_documento),0)
					  from anadoc b
				         where b.natura_documento != 'A'
                                           and b.ente_emissione    = 2
					   and b.tipo_documento    = 'LP'
				 	   and b.matricola         = ana.matricola)
   and doc_LP.natura_documento	(+) 	!= 'A'
   and doc_LP.ente_emissione  	(+) 	= 2
   and doc_LP.tipo_documento  	(+) 	= 'LP'
   and doc_LP.matricola	    	(+) 	= ana.matricola
   and com_PS.cod_comune	(+)     = doc_PS.cod_com_ente
   and com_PS.cod_provincia	(+)    	= doc_PS.cod_pro_ente
   and dmd_PS.cod_md		(+)	= doc_PS.motivo_documento
   and den_PS.cod_en		(+)	= doc_PS.ente_emissione
   and doc_PS.natura_documento	(+) 	!= 'A'
   and doc_PS.progr_documento 	(+) 	= 1
   and doc_PS.tipo_documento  	(+) 	= 'PS'
   and doc_PS.matricola       	(+) 	= ana.matricola
   and com_CS.cod_comune	(+)     = doc_CS.cod_com_ente
   and com_CS.cod_provincia	(+)    	= doc_CS.cod_pro_ente
   and dmd_CS.cod_md		(+)	= doc_CS.motivo_documento
   and den_CS.cod_en		(+)	= doc_CS.ente_emissione
   and doc_CS.natura_documento	(+) 	!= 'A'
   and doc_CS.progr_documento 	(+) 	= 1
   and doc_CS.tipo_documento  	(+) 	= 'CS'
   and doc_CS.matricola       	(+) 	= ana.matricola
   and com_U1.cod_comune	(+)     = doc_U1.cod_com_ente
   and com_U1.cod_provincia	(+)    	= doc_U1.cod_pro_ente
   and dmd_U1.cod_md		(+)	= doc_U1.motivo_documento
   and den_U1.cod_en		(+)	= doc_U1.ente_emissione
   and doc_U1.natura_documento	(+) 	!= 'A'
   and doc_U1.progr_documento 	(+) 	= 1
   and doc_U1.tipo_documento  	(+) 	= 'U1'
   and doc_U1.matricola       	(+) 	= ana.matricola
   and com_U2.cod_comune	(+)     = doc_U2.cod_com_ente
   and com_U2.cod_provincia	(+)    	= doc_U2.cod_pro_ente
   and dmd_U2.cod_md		(+)	= doc_U2.motivo_documento
   and den_U2.cod_en		(+)	= doc_U2.ente_emissione
   and doc_U2.natura_documento	(+) 	!= 'A'
   and doc_U2.progr_documento 	(+) 	= 1
   and doc_U2.tipo_documento  	(+) 	= 'U2'
   and doc_U2.matricola       	(+) 	= ana.matricola
   and com_RP.cod_comune	(+)     = doc_RP.cod_com_ente
   and com_RP.cod_provincia	(+)    	= doc_RP.cod_pro_ente
   and dmd_RP.cod_md		(+)	= doc_RP.motivo_documento
   and den_RP.cod_en		(+)	= doc_RP.ente_emissione
   and doc_RP.natura_documento	(+) 	!= 'A'
   and doc_RP.progr_documento 	(+) 	= 1
   and doc_RP.tipo_documento  	(+) 	= 'RP'
   and doc_RP.matricola       	(+) 	= ana.matricola
   and ana_cn.matricola		(+)	= ana.matricola_cn
   and ana_pd.matricola		(+)	= ana.matricola_pd
   and ana_md.matricola		(+)	= ana.matricola_md
   and eve.data_eve 		(+)     = ana.data_ult_eve
   and eve.cod_eve		(+)	= ana.stato
   and eve.cod_mov		(+)	= ana.fascia
   and eve.matricola		(+)	= ana.matricola
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
   and ana.fascia + 0  	      		in (1,3)
/
comment on table ANAVBI is 'Statistiche Anagrafe - Individui Residenti e AIRE - Iscritti (view)'
/
