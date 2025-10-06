--liquibase formatted sql
--changeset amonopoli:202411191555_5 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW ANAVMO
(MATRICOLA,
 FLAG_RESIDENTE, FLAG_AIRE, FLAG_ISCRITTO_PRELIMINARE,
 CODICE_MOVIMENTO, DES_CODICE_MOVIMENTO,
 CODICE_EVENTO, DES_CODICE_EVENTO, DATA_EVENTO, DATA_EVENTO_EDIT, COD_PROVINCIA_EVENTO, COD_COMUNE_EVENTO,
 COMUNE_EVENTO, COD_REGIONE_EVENTO, REGIONE_EVENTO, GRUPPO_NAZIONE_EVENTO, COD_PROVINCIA_PREC_ISCR_AIRE,
 COD_COMUNE_PREC_ISCR_AIRE, COMUNE_PREC_ISCR_AIRE, COD_REGIONE_PREC_ISCR_AIRE, REGIONE_PREC_ISCR_AIRE, ANNO_PRATICA,
 PRATICA, NUCLEO_CHIUSO, NUCLEO_ISTITUITO, COGNOME_NOME, COGNOME_NOME_PREC,
 COD_PROVINCIA_NASCITA, COD_COMUNE_NASCITA, COMUNE_NASCITA, COD_REGIONE_NASCITA, REGIONE_NASCITA,
 GRUPPO_NAZIONE_NASCITA, DATA_NASCITA, DATA_NASCITA_EDIT, ANNO_NASCITA,
 COD_PROVINCIA_ATTO_NASCITA, COD_COMUNE_ATTO_NASCITA,
 COMUNE_ATTO_NASCITA, COD_REGIONE_ATTO_NASCITA, REGIONE_ATTO_NASCITA, ATTO_NASCITA_EDIT,
 STATO_CIVILE, DES_STATO_CIVILE, STATO_CIVILE_PREC, DES_STATO_CIVILE_PREC,
 SESSO, SESSO_PREC, NAZIONALITA, NAZIONALITA_ISTAT,
 NAZIONALITA_CEE, DES_NAZIONALITA, GRUPPO_NAZIONALITA, NAZIONALITA_PREC, NAZIONALITA_ISTAT_PREC,
 DES_NAZIONALITA_PREC, GRUPPO_NAZIONALITA_PREC, PATERNITA, MATERNITA, TITOLO_STUDIO,
 DES_TITOLO_STUDIO, COD_PROF, DES_PROFESSIONE, CODICE_FAMIGLIA, PROGR_ELIMINAZIONE_FOGLIO,
 INTESTATARIO, RAPPORTO_PAR, DES_RAPPORTO_PAR, CODICE_VIA, DENOMINAZIONE_VIA,
 NUMERO_CIVICO, SUFFISSO, INTERNO, SUB_INTERNO, SCALA, PIANO,
 INDIRIZZO, INDIRIZZO_INT, COD_PROVINCIA_RESIDENZA, COD_COMUNE_RESIDENZA, COMUNE_RESIDENZA,
 NAZIONE_RESIDENZA, COD_REGIONE_RESIDENZA, REGIONE_RESIDENZA, GRUPPO_NAZIONE_RESIDENZA, ZIPCODE_RESIDENZA,
 PROVINCIA_CONTEA_RESIDENZA, PRESSO_RESIDENZA, UFFICIO_CONSOLARE_RESIDENZA, CODICE_FAMIGLIA_PREC, INTESTATARIO_PREC,
 RAPPORTO_PAR_PREC, DES_RAPPORTO_PAR_PREC, CODICE_VIA_PREC, DENOMINAZIONE_VIA_PREC, NUMERO_CIVICO_PREC,
 SUFFISSO_PREC, INTERNO_PREC, SUB_INTERNO_PREC, SCALA_PREC, PIANO_PREC, INDIRIZZO_PREC,
 INDIRIZZO_INT_PREC, COD_PROVINCIA_RES_PREC, COD_COMUNE_RES_PREC, COMUNE_RES_PREC, NAZIONE_RES_PREC,
 GRUPPO_NAZIONE_RES_PREC, ZIPCODE_RES_PREC, PROVINCIA_CONTEA_RES_PREC, PRESSO_RES_PREC, UFFICIO_CONSOLARE_RES_PREC,
 INDIRIZZO_ATTUALE, INDIRIZZO_INT_ATTUALE, COD_PROVINCIA_RES_ATTUALE, COD_COMUNE_RES_ATTUALE, COMUNE_RES_ATTUALE,
 CAP_COMUNE_RES_ATTUALE, NAZIONE_RES_ATTUALE, GRUPPO_NAZIONE_RES_ATTUALE, ZIPCODE_RES_ATTUALE, PROVINCIA_CONTEA_RES_ATTUALE,
 PRESSO_RES_ATTUALE, UFFICIO_CONSOLARE_RES_ATTUALE, COGNOME_NOME_CONIUGE, MATRICOLA_CONIUGE, DATA_MATRIMONIO, DATA_MATRIMONIO_EDIT,
 DATA_VEDOVANZA, DATA_VEDOVANZA_EDIT, DATA_DIVORZIO, DATA_DIVORZIO_EDIT, ANNO_CENSIMENTO, SEZIONE_CENSIMENTO, FOGLIO_CENSIMENTO,
 COD_EDIFICIO_CENSIMENTO, CODICE_FISCALE, FLAG_CF_CALCOLATO,
 STATO_ELE,
 STATO_SCRUTATORE_ALBO_S, STATO_SCRUTATORE_ALBO_V, STATO_SCRUTATORE_ALBO_R,
 STATO_GIUDICE_ALBO_A, STATO_GIUDICE_ALBO_P,
 STATO_PRESIDENTE_SEGGIO,
 DATA_REGISTRAZIONE, DATA_REGISTRAZIONE_EDIT, TERMINALISTA,
 NOME_TERMINALISTA,
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
 ANNO_PROGR, NUMERO_PROGR, SEQUENZA,
 RECAPITO_CELLULARE, RECAPITO_TELEFONO_FISSO, RECAPITO_EMAIL, DOMICILIO_DIGITALE
)
AS
--
--	estrazione movimenti RESIDENTI
--	. ISCRIZIONI
-- 	. CANCELLAZIONI
--	. RETTIFICHE NAZIONALITA
--	. RETTIFICHE STATO CIVILE
--
select
	 mov.MATRICOLA,
	 decode(ana.fascia,1,'SI','NO') flag_residente,
	 decode(ana.fascia,3,'SI','NO') flag_aire,
	 decode(ana.stato,17,'SI','NO') flag_iscritto_preliminare,
 	 mov.COD_MOV CODICE_MOVIMENTO,
	 decode(mov.cod_mov,
	   1,'ISCRIZIONE IN APR',
	   2,'CANCELLAZIONE DA APR',
	   3,'CANCELLAZIONE DA APR',
	  10,'CAMBIO DI ABITAZIONE IN APR',
	  11,'CAMBIO DI ABITAZIONE IN APR',
	  97,'RETTIFICA APR') DES_CODICE_MOVIMENTO,
	 mov.COD_EVE CODICE_EVENTO,
	 decode(mov.cod_mov,
	   2,decode(mov.cod_variazione, 'C', dev.descrizione||' AL CENSIMENTO', dev.descrizione),
	     decode(mov.cod_mov,97,decode(mov.nazionalita_prec,mov.nazionalita,'STATO CIVILE','CITTADINANZA'),
	       dev.descrizione)) DES_CODICE_EVENTO,
 	 to_date(mov.DATA_EVE,'j') DATA_EVENTO,
 	 to_char(to_date(mov.DATA_EVE,'j'),'dd/mm/yyyy') DATA_EVENTO_EDIT,
 	 lpad(mov.COD_PRO_EVE,3,'0') COD_PROVINCIA_EVENTO,
	 lpad(mov.COD_COM_EVE,3,'0') COD_COMUNE_EVENTO,
	 a.descrizione||decode(a.sigla_provincia,'','',' ('||a.sigla_provincia||')') COMUNE_EVENTO,
	 substr(f_regione(mov.COD_PRO_EVE),1,2) COD_REGIONE_EVENTO,
	 substr(f_regione(mov.COD_PRO_EVE),3) REGIONE_EVENTO,
	 f_gruppo_nazioni(mov.cod_pro_eve) GRUPPO_NAZIONE_EVENTO,
 	 lpad(mov.COD_PRO_ISCR_AIRE,3,'0') COD_PROVINCIA_PREC_ISCR_AIRE,
	 lpad(mov.COD_COM_ISCR_AIRE,3,'0') COD_COMUNE_PREC_ISCR_AIRE,
	 d.descrizione||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')') COMUNE_PREC_ISCR_AIRE,
	 substr(f_regione(mov.COD_PRO_ISCR_AIRE),1,2) COD_REGIONE_PREC_ISCR_AIRE,
	 substr(f_regione(mov.COD_COM_ISCR_AIRE),3) REGIONE_PREC_ISCR_AIRE,
	 mov.ANNO_PRATICA, mov.PRATICA,
	 decode(mov.NUCLEO_PARTENZA,1,'SI','NO') NUCLEO_CHIUSO,
	 decode(mov.NUCLEO_ARRIVO,1,'SI','NO') NUCLEO_ISTITUITO,
	 mov.COGNOME_NOME,
	 decode(mov.cod_mov,97,mov.COGNOME_NOME_PREC) COGNOME_NOME_PREC,
	 lpad(ana.COD_PRO_NAS,3,'0') cod_provincia_nascita,
	 lpad(ana.COD_COM_NAS,3,'0') cod_comune_nascita,
	 b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')') comune_nascita,
	 substr(f_regione(ana.cod_pro_nas),1,2) COD_REGIONE_NASCITA,
	 substr(f_regione(ana.cod_pro_nas),3) REGIONE_NASCITA,
	 f_gruppo_nazioni(ana.cod_pro_nas) GRUPPO_NAZIONE_NASCITA,
	 TO_DATE(ana.DATA_NAS,'J') DATA_NASCITA,
	 DECODE(ana.anno_nas,'S','00/00/'||to_char(to_date(ana.DATA_NAS,'j'),'yyyy'),
		to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')) DATA_NASCITA_EDIT,
	 to_char(TO_DATE(ana.DATA_NAS,'J'),'yyyy') ANNO_NASCITA,
	 lpad(ana.COD_PRO_ATTO_NAS,3,'0') COD_PROVINCIA_ATTO_NASCITA,
	 lpad(ana.COD_COM_ATTO_NAS,3,'0') COD_COMUNE_ATTO_NASCITA,
	 c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') comune_atto_nascita,
	 substr(f_regione(ana.cod_pro_atto_nas),1,2) COD_REGIONE_ATTO_NASCITA,
	 substr(f_regione(ana.cod_pro_atto_nas),3) REGIONE_ATTO_NASCITA,
         ana.atto_nas||
	   DECODE(ANA.PARTE_NAS,'','',' P.'||decode(ana.PARTE_NAS,1,'I',2,'II'))||
	   decode(ana.serie_nas,'','',' S.'||ana.serie_nas)||
	   decode(ana.ufficio_nas,'','',' U.'||ana.ufficio_nas)||
	   decode(ana.anno_atto_nas,'','','/'||ana.anno_atto_nas) ATTO_NASCITA_EDIT,
	 mov.STATO_CIVILE,
	 dsc.descrizione des_stato_civile,
	 decode(mov.cod_mov,97,mov.STATO_CIVILE_PREC,'') STATO_CIVILE_PREC,
	 decode(mov.cod_mov,97,dsc_p.descrizione,'') DES_STATO_CIVILE_PREC,
	 mov.SESSO,
	 decode(mov.cod_mov,97,mov.SESSO_PREC) SESSO_prec,
	 mov.NAZIONALITA,
	 dci.ist_ci NAZIONALITA_ISTAT,
	 decode(dci.cee,'S','SI','NO') NAZIONALITA_CEE,
	 dci.descrizione DES_NAZIONALITA,
	 f_gruppo_nazionalita(mov.nazionalita) GRUPPO_NAZIONALITA,
	 decode(mov.cod_mov,97,mov.NAZIONALITA_PREC,'') NAZIONALITA_PREC,
	 decode(mov.cod_mov,97,dci_p.ist_ci,'') NAZIONALITA_ISTAT_PREC,
	 decode(mov.cod_mov,97,dci_p.descrizione,'') DES_NAZIONALITA_PREC,
	 decode(mov.cod_mov,97,f_gruppo_nazionalita(mov.nazionalita_prec),'') GRUPPO_NAZIONALITA_PREC,
	 ana.PATERNITA,
	 ana.MATERNITA,
	 mov.TITOLO_STUDIO,
	 dts.descrizione DES_TITOLO_STUDIO,
	 mov.COD_PROF,
	 dpr.descrizione DES_PROFESSIONE,
	 decode(mov.cod_mov,3,mov.COD_FAM_PREC,mov.COD_FAM) CODICE_FAMIGLIA,
	 decode(mov.cod_mov,1,to_number(null),fam_2.progr_eliminazione) PROGR_ELIMINAZIONE_FOGLIO,
	 decode(mov.cod_mov,3,mov.INTESTATARIO_PREC,mov.INTESTATARIO) INTESTATARIO,
	 decode(mov.cod_mov,3,mov.RAPPORTO_PAR_PREC,mov.RAPPORTO_PAR) RAPPORTO_PAR,
	 decode(mov.cod_mov,3,drp_p.descrizione,drp.descrizione) DES_RAPPORTO_PAR,
	 decode(mov.cod_mov,3,mov.COD_VIA_PREC,mov.COD_VIA) CODICE_VIA,
	 decode(mov.cod_mov,3,vie_p.denom_uff,vie.denom_uff) DENOMINAZIONE_VIA,
	 decode(mov.cod_mov,3,mov.NUM_CIV_PREC,mov.NUM_CIV) NUMERO_CIVICO,
	 decode(mov.cod_mov,3,mov.SUFFISSO_PREC,mov.SUFFISSO) SUFFISSO,
	 decode(mov.cod_mov,3,mov.INTERNO_PREC,mov.INTERNO) INTERNO,
         decode(mov.cod_mov,3,mov.SUB_INTERNO_PREC,mov.SUB_INTERNO) SUB_INTERNO,
	 decode(mov.cod_mov,3,mov.SCALA_PREC,mov.SCALA) SCALA,
 	 decode(mov.cod_mov,3,mov.PIANO_PREC,mov.PIANO) PIANO,
	 decode(mov.cod_mov,3,
           vie_p.denom_uff||', '||MOV.CIVICO_ESTERNO_PREC||
	    decode(upper(ainp.valore),'S',' '||MOV.CIVICO_INTERNO_PREC,''),
           vie.denom_uff||', '||MOV.CIVICO_ESTERNO||
	    decode(upper(ainp.valore),'S',' '||MOV.CIVICO_INTERNO,'')) INDIRIZZO,
	 decode(mov.cod_mov,3,
           vie_p.denom_uff||', '||nvl(mov.num_civ_prec,0)||
	    decode(mov.suffisso_prec,'','','/'||mov.suffisso_prec)||
	    decode(mov.interno_prec,'','',' int.'||mov.interno_prec)||
	    decode(mov.scala_prec,'','',' Sc.'||mov.scala_prec)||
	    decode(mov.piano_prec,'','',' P.'||mov.piano_prec),
           vie.denom_uff||', '||nvl(mov.num_civ,0)||
	    decode(mov.suffisso,'','','/'||mov.suffisso)||
	    decode(mov.interno,'','',' int.'||mov.interno)||
	    decode(mov.scala,'','',' Sc.'||mov.scala)||
	    decode(mov.piano,'','',' P.'||mov.piano)) INDIRIZZO_INT,
	 lpad(m.cod_provincia,3,'0') COD_PROVINCIA_RESIDENZA,
	 lpad(m.cod_comune,3,'0') COD_COMUNE_RESIDENZA,
	 m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')') COMUNE_RESIDENZA,
	 to_char(null) NAZIONE_RESIDENZA,
	 substr(f_regione(m.cod_provincia),1,2) COD_REGIONE_RESIDENZA,
	 substr(f_regione(m.cod_provincia),3) REGIONE_RESIDENZA,
	 f_gruppo_nazioni(m.cod_provincia) GRUPPO_NAZIONE_RESIDENZA,
	 to_char(null) ZIPCODE_RESIDENZA,
         to_char(null) PROVINCIA_CONTEA_RESIDENZA,
	 to_char(null) PRESSO_RESIDENZA,
	 to_char(null) UFFICIO_CONSOLARE_RESIDENZA,
	 decode(mov.cod_mov,10,mov.COD_FAM_PREC,11,mov.COD_FAM_PREC) CODICE_FAMIGLIA_PREC,
	 decode(mov.cod_mov,10,mov.INTESTATARIO_PREC,11,mov.INTESTATARIO_PREC) INTESTATARIO_PREC,
	 decode(mov.cod_mov,10,mov.RAPPORTO_PAR_PREC,11,mov.RAPPORTO_PAR_PREC) RAPPORTO_PAR_PREC,
	 decode(mov.cod_mov,10,drp_p.descrizione,11,drp_p.descrizione) DES_RAPPORTO_PAR_PREC,
	 decode(mov.cod_mov,10,mov.COD_VIA_PREC,11,mov.COD_VIA_PREC) CODICE_VIA_PREC,
	 decode(mov.cod_mov,10,vie_p.denom_uff,11,vie_p.denom_uff) DENOMINAZIONE_VIA_PREC,
	 decode(mov.cod_mov,10,mov.NUM_CIV_PREC,11,mov.NUM_CIV_PREC) NUMERO_CIVICO_PREC,
	 decode(mov.cod_mov,10,mov.SUFFISSO_PREC,11,mov.SUFFISSO_PREC) SUFFISSO_PREC,
	 decode(mov.cod_mov,10,mov.INTERNO_PREC,11,mov.INTERNO_PREC) INTERNO_PREC,
         decode(mov.cod_mov,10,mov.SUB_INTERNO_PREC,11,mov.SUB_INTERNO_PREC) SUB_INTERNO_PREC,
	 decode(mov.cod_mov,10,mov.SCALA_PREC,11,mov.SCALA_PREC) SCALA_PREC,
 	 decode(mov.cod_mov,10,mov.PIANO_PREC,11,mov.PIANO_PREC) PIANO_PREC,
	 decode(mov.cod_mov,
           10,vie_p.denom_uff||', '||MOV.CIVICO_ESTERNO_PREC||
	    decode(upper(ainp.valore),'S',' '||MOV.CIVICO_INTERNO_PREC,''),
           11,vie_p.denom_uff||', '||MOV.CIVICO_ESTERNO_PREC||
	    decode(upper(ainp.valore),'S',' '||MOV.CIVICO_INTERNO_PREC,'')) INDIRIZZO_PREC,
	 decode(mov.cod_mov,
           10,vie_p.denom_uff||', '||nvl(mov.num_civ_prec,0)||
	    decode(mov.suffisso_prec,'','','/'||mov.suffisso_prec)||
	    decode(mov.interno_prec,'','',' int.'||mov.interno_prec)||
	    decode(mov.scala_prec,'','',' Sc.'||mov.scala_prec)||
	    decode(mov.piano_prec,'','',' P.'||mov.piano_prec),
           11,vie_p.denom_uff||', '||nvl(mov.num_civ_prec,0)||
	    decode(mov.suffisso_prec,'','','/'||mov.suffisso_prec)||
	    decode(mov.interno_prec,'','',' int.'||mov.interno_prec)||
	    decode(mov.scala_prec,'','',' Sc.'||mov.scala_prec)||
	    decode(mov.piano_prec,'','',' P.'||mov.piano_prec)) INDIRIZZO_INT_PREC,
	 lpad(m.cod_provincia,3,'0') COD_PROVINCIA_RES_PREC,
	 lpad(m.cod_comune,3,'0') COD_COMUNE_RES_PREC,
	 m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')') COMUNE_RES_PREC,
	 to_char(null) NAZIONE_RES_PREC,
	 to_char(null) GRUPPO_NAZIONE_RES_PREC,
	 to_char(null) ZIPCODE_RES_PREC,
         to_char(null) PROVINCIA_CONTEA_RES_PREC,
	 to_char(null) PRESSO_RES_PREC,
	 to_char(null) UFFICIO_CONSOLARE_RES_PREC,
	 decode(ana.fascia,1,
           vie_f.denom_uff||', '||FAM.CIVICO_ESTERNO||
	    decode(upper(ainp.valore),'S',' '||FAM.CIVICO_INTERNO)) INDIRIZZO_ATTUALE,
	 decode(ana.fascia,1,
           vie_f.denom_uff||', '||nvl(fam.num_civ,0)||
	    decode(fam.suffisso,'','','/'||fam.suffisso)||
	    decode(fam.interno,'','',' int.'||fam.interno)||
	    decode(fam.scala,'','',' Sc.'||fam.scala)||
	    decode(fam.piano,'','',' P.'||fam.piano)) INDIRIZZO_INT_ATTUALE,
	 decode(ana.fascia,1,lpad(m.cod_provincia,3,'0')) COD_PROVINCIA_RES_ATTUALE,
	 decode(ana.fascia,1,lpad(m.cod_comune,3,'0')) COD_COMUNE_RES_ATTUALE,
	 decode(ana.fascia,1,m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')')) COMUNE_RES_ATTUALE,
	 decode(ana.fascia,1,f_cap(fam.cod_via, fam.num_civ, fam.suffisso)) CAP_COMUNE_RES_ATTUALE,
	 to_char(null) NAZIONE_RES_ATTUALE,
	 to_char(null) GRUPPO_NAZIONE_RES_ATTUALE,
	 to_char(null) ZIPCODE_RES_ATTUALE,
         to_char(null) PROVINCIA_CONTEA_RES_ATTUALE,
	 to_char(null) PRESSO_RES_ATTUALE,
	 to_char(null) UFFICIO_CONSOLARE_RES_ATTUALE,
 	 mov.COGNOME_NOME_CN cognome_nome_coniuge,
 	 mov.MATRICOLA_CN matricola_coniuge,
	 TO_DATE(mov.DATA_MAT,'J') DATA_MATRIMONIO,
	 TO_CHAR(TO_DATE(mov.DATA_MAT,'J'),'DD/MM/YYYY') DATA_MATRIMONIO_EDIT,
	 TO_DATE(mov.DATA_VED,'J') DATA_VEDOVANZA,
	 TO_CHAR(TO_DATE(mov.DATA_VED,'J'),'DD/MM/YYYY') DATA_VEDOVANZA_EDIT,
	 TO_DATE(mov.DATA_DIV,'J') DATA_DIVORZIO,
	 TO_CHAR(TO_DATE(mov.DATA_DIV,'J'),'DD/MM/YYYY') DATA_DIVORZIO_EDIT,
     mov.ANNO_CENS anno_censimento,
	 mov.SEZIONE_CENS sezione_censimento,
	 mov.FOGLIO_CENS foglio_censimento,
	 mov.COD_EDIFICIO_CENS cod_edificio_censimento,
 	 ana.COD_FISCALE CODICE_FISCALE,
	 ana.CF_CALCOLATO FLAG_CF_CALCOLATO,
-- stato_ele
       	 ele.stato stato_ele,
-- stato_scrutatore_albo_S
         scr_s.stato stato_scrutatore_albo_s,
-- stato_scrutatore_albgo_V
	     scr_v.stato stato_scrutatore_albo_v,
-- stato_scrutatore_albo_r
         scr_r.stato stato_scrutatore_albo_r,
-- stato_giudice_albo_a
	     gpo_a.stato stato_giudice_albo_a,
-- stato_giudice_albo_p
     	 gpo_p.stato stato_giudice_albo_p,
-- stato_presidente_seggio
	     pse.stato stato_presidente_seggio,
	 TO_DATE(mov.DATA_REG,'J') DATA_REGISTRAZIONE,
	 TO_CHAR(TO_DATE(mov.DATA_REG,'J'),'DD/MM/YYYY') DATA_REGISTRAZIONE_EDIT,
	 mov.TERMINALISTA,
	 a_utenti.nominativo NOME_TERMINALISTA,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(1, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(1, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_1,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(1, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(1, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_1,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(1, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(1, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_1,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(2, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(2, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_2,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(2, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(2, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_2,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(2, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(2, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_2,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(3, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(3, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_3,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(3, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(3, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_3,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(3, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(3, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_3,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(4, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(4, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_4,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(4, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(4, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_4,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(4, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(4, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_4,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(5, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(5, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_5,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(5, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(5, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_5,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(5, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(5, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_5,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(6, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(6, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_6,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(6, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(6, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_6,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(6, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(6, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_6,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(7, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(7, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_7,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(7, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(7, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_7,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(7, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(7, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_7,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(8, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(8, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_8,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(8, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(8, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_8,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(8, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(8, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_8,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(9, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(9, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_9,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(9, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(9, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_9,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(9, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(9, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_9,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(10, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(10, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_10,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(10, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(10, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_10,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(10, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(10, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_10,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(99, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(99, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_CAP,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(99, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(99, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_CAP,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(99, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(99, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_CAP,
       mov.anno_progr, mov.numero_progr,
       decode(mov.cod_eve,4,2,1) sequenza,
-- RECAPITO_CELLULARE
         f_recapito_individuo(ana.matricola,'S') recapito_cellulare,
-- RECAPITO_TELEFONO_FISSO
         f_recapito_individuo(ana.matricola,'f') recapito_telefono_fisso,
-- RECAPITO_EMAIL
         f_recapito_individuo(ana.matricola,'E') recapito_email,
-- DOMICILIO_DIGITALE
         f_domicilio_digitale(ana.matricola) domicilio_digitale
  from a_utenti,
	arccom a, arccom b, arccom c, arccom d, arccom m,
	arcinp ainp, arcvie vie, arcvie vie_p, arcvie vie_f,
 	anadev dev, anadrp drp, anadrp drp_p,
	anadsc dsc, anadsc dsc_p, anadci dci, anadci dci_p, anadts dts, anadpr dpr,
	eleasc scr_v, eleasc scr_s, eleasc scr_r,
    eleagp gpo_a, eleagp gpo_p, eleaps pse,
    eleana ele,
	anafam fam_2, anafam fam, anaana ana, anamov mov
 where (m.cod_provincia, m.cod_Comune)	= (select pro_cliente, com_cliente
					     from menuditta)
   and a_utenti.utente		(+)	= mov.terminalista
   and ainp.parametro			= 'INTERNO_S'
   and a.cod_provincia		(+)	= mov.cod_pro_eve
   and a.cod_comune		(+)	= mov.cod_com_eve
   and b.cod_provincia		(+)	= ana.cod_pro_nas
   and b.cod_comune		(+)	= ana.cod_com_nas
   and c.cod_provincia		(+)	= ana.cod_pro_atto_nas
   and c.cod_comune		(+)	= ana.cod_com_atto_nas
   and d.cod_provincia		(+)	= mov.cod_pro_iscr_aire
   and d.cod_comune		(+)	= mov.cod_com_iscr_aire
   and vie.cod_via		(+)	= mov.cod_via
   and vie_p.cod_via		(+)	= mov.cod_via_prec
   and vie_f.cod_via		(+)	= fam.cod_via
   and drp.cod_rp		(+)	= mov.rapporto_par
   and drp.sesso		(+)	= mov.sesso
   and drp_p.cod_rp		(+)	= mov.rapporto_par_prec
   and drp_p.sesso		(+)	= mov.sesso_prec
   and dsc.cod_sc		(+)	= mov.stato_civile
   and dsc.sesso		(+)	= mov.sesso
   and dsc_p.cod_sc		(+)	= mov.stato_civile_prec
   and dsc_p.sesso		(+)	= mov.sesso_prec
   and dci.cod_ci		(+)	= mov.nazionalita
   and dci_p.cod_ci		(+)	= mov.nazionalita_prec
   and dpr.cod_pr		(+)	= mov.cod_prof
   and dpr.sesso		(+)	= mov.sesso
   and dts.cod_ts		(+)	= mov.titolo_studio
--
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
--
   and fam_2.fascia		(+)	= 2
   and fam_2.cod_fam		(+)	= decode(mov.cod_mov,3,mov.cod_fam_prec,mov.cod_fam)
   and fam.fascia		(+)	= 1
   and fam.cod_fam		(+)	= decode(mov.cod_mov,3,mov.cod_fam_prec,mov.cod_fam)
   and dev.cod_ev			= mov.cod_eve
   and ana.matricola			= mov.matricola
   and (mov.cod_mov in (1,2)
        or (mov.cod_mov = 3 and mov.cod_eve = 52)
        or (mov.cod_mov = 10 and mov.cod_eve = 92)
        or (mov.cod_mov = 11 and mov.cod_eve = 91)
        or (mov.cod_mov = 97 and mov.cod_eve = 99
            and (nvl(mov.nazionalita_prec,' ') != nvl(mov.nazionalita,' ')
                 or
                 nvl(mov.stato_civile_prec,' ') != nvl(mov.stato_civile,' ')
                )
           )
       )
UNION
--
--	estrazione movimenti RESIDENTI
-- 	. RETTIFICHE GENERALITA (COGNOME_NOME o SESSO)
--
select
	 mov.MATRICOLA,
	 decode(ana.fascia,1,'SI','NO') flag_residente,
	 decode(ana.fascia,3,'SI','NO') flag_aire,
	 decode(ana.stato,17,'SI','NO') flag_iscritto_preliminare,
 	 mov.COD_MOV CODICE_MOVIMENTO,
	 decode(mov.cod_mov,
	   1,'ISCRIZIONE IN APR',
	   2,'CANCELLAZIONE DA APR',
	   3,'CANCELLAZIONE DA APR',
	  10,'CAMBIO DI ABITAZIONE IN APR',
	  11,'CAMBIO DI ABITAZIONE IN APR',
	  97,'RETTIFICA APR') DES_CODICE_MOVIMENTO,
	 mov.COD_EVE CODICE_EVENTO,
	 'GENERALITA' DES_CODICE_EVENTO,
 	 to_date(mov.DATA_EVE,'j') DATA_EVENTO,
 	 to_char(to_date(mov.DATA_EVE,'j'),'dd/mm/yyyy') DATA_EVENTO_EDIT,
 	 lpad(mov.COD_PRO_EVE,3,'0') COD_PROVINCIA_EVENTO,
	 lpad(mov.COD_COM_EVE,3,'0') COD_COMUNE_EVENTO,
	 a.descrizione||decode(a.sigla_provincia,'','',' ('||a.sigla_provincia||')') COMUNE_EVENTO,
	 substr(f_regione(mov.COD_PRO_EVE),1,2) COD_REGIONE_EVENTO,
	 substr(f_regione(mov.COD_PRO_EVE),3) REGIONE_EVENTO,
	 f_gruppo_nazioni(mov.cod_pro_eve) GRUPPO_NAZIONE_EVENTO,
 	 lpad(mov.COD_PRO_ISCR_AIRE,3,'0') COD_PROVINCIA_PREC_ISCR_AIRE,
	 lpad(mov.COD_COM_ISCR_AIRE,3,'0') COD_COMUNE_PREC_ISCR_AIRE,
	 d.descrizione||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')') COMUNE_PREC_ISCR_AIRE,
	 substr(f_regione(mov.COD_PRO_ISCR_AIRE),1,2) COD_REGIONE_PREC_ISCR_AIRE,
	 substr(f_regione(mov.COD_COM_ISCR_AIRE),3) REGIONE_PREC_ISCR_AIRE,
	 mov.ANNO_PRATICA, mov.PRATICA,
	 decode(mov.NUCLEO_PARTENZA,1,'SI','NO') NUCLEO_CHIUSO,
	 decode(mov.NUCLEO_ARRIVO,1,'SI','NO') NUCLEO_ISTITUITO,
	 mov.COGNOME_NOME,
	 decode(mov.cod_mov,97,mov.COGNOME_NOME_PREC) COGNOME_NOME_PREC,
	 lpad(ana.COD_PRO_NAS,3,'0') cod_provincia_nascita,
	 lpad(ana.COD_COM_NAS,3,'0') cod_comune_nascita,
	 b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')') comune_nascita,
	 substr(f_regione(ana.cod_pro_nas),1,2) COD_REGIONE_NASCITA,
	 substr(f_regione(ana.cod_pro_nas),3) REGIONE_NASCITA,
	 f_gruppo_nazioni(ana.cod_pro_nas) GRUPPO_NAZIONE_NASCITA,
	 TO_DATE(ana.DATA_NAS,'J') DATA_NASCITA,
	 DECODE(ana.anno_nas,'S','00/00/'||to_char(to_date(ana.DATA_NAS,'j'),'yyyy'),
		to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')) DATA_NASCITA_EDIT,
	 to_char(TO_DATE(ana.DATA_NAS,'J'),'yyyy') ANNO_NASCITA,
	 lpad(ana.COD_PRO_ATTO_NAS,3,'0') COD_PROVINCIA_ATTO_NASCITA,
	 lpad(ana.COD_COM_ATTO_NAS,3,'0') COD_COMUNE_ATTO_NASCITA,
	 c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') comune_atto_nascita,
	 substr(f_regione(ana.cod_pro_atto_nas),1,2) COD_REGIONE_ATTO_NASCITA,
	 substr(f_regione(ana.cod_pro_atto_nas),3) REGIONE_ATTO_NASCITA,
         ana.atto_nas||
	   DECODE(ANA.PARTE_NAS,'','',' P.'||decode(ana.PARTE_NAS,1,'I',2,'II'))||
	   decode(ana.serie_nas,'','',' S.'||ana.serie_nas)||
	   decode(ana.ufficio_nas,'','',' U.'||ana.ufficio_nas)||
	   decode(ana.anno_atto_nas,'','','/'||ana.anno_atto_nas) ATTO_NASCITA_EDIT,
	 mov.STATO_CIVILE,
	 dsc.descrizione des_stato_civile,
	 mov.STATO_CIVILE_PREC,
	 dsc_p.descrizione des_stato_civile_prec,
	 mov.SESSO,
	 decode(mov.cod_mov,97,mov.SESSO_PREC) SESSO_prec,
	 mov.NAZIONALITA,
	 dci.ist_ci NAZIONALITA_ISTAT,
	 decode(dci.cee,'S','SI','NO') NAZIONALITA_CEE,
	 dci.descrizione DES_NAZIONALITA,
	 f_gruppo_nazionalita(mov.nazionalita) GRUPPO_NAZIONALITA,
	 decode(mov.cod_mov,97,mov.NAZIONALITA_PREC,'') NAZIONALITA_PREC,
	 decode(mov.cod_mov,97,dci_p.ist_ci,'') NAZIONALITA_ISTAT_PREC,
	 decode(mov.cod_mov,97,dci_p.descrizione,'') DES_NAZIONALITA_PREC,
	 decode(mov.cod_mov,97,f_gruppo_nazionalita(mov.nazionalita_prec),'') GRUPPO_NAZIONALITA_PREC,
	 ana.PATERNITA,
	 ana.MATERNITA,
	 mov.TITOLO_STUDIO,
	 dts.descrizione DES_TITOLO_STUDIO,
	 mov.COD_PROF,
	 dpr.descrizione DES_PROFESSIONE,
	 decode(mov.cod_mov,3,mov.COD_FAM_PREC,mov.COD_FAM) CODICE_FAMIGLIA,
	 decode(mov.cod_mov,1,to_number(null),fam_2.progr_eliminazione) PROGR_ELIMINAZIONE_FOGLIO,
	 decode(mov.cod_mov,3,mov.INTESTATARIO_PREC,mov.INTESTATARIO) INTESTATARIO,
	 decode(mov.cod_mov,3,mov.RAPPORTO_PAR_PREC,mov.RAPPORTO_PAR) RAPPORTO_PAR,
	 decode(mov.cod_mov,3,drp_p.descrizione,drp.descrizione) DES_RAPPORTO_PAR,
	 decode(mov.cod_mov,3,mov.COD_VIA_PREC,mov.COD_VIA) CODICE_VIA,
	 decode(mov.cod_mov,3,vie_p.denom_uff,vie.denom_uff) DENOMINAZIONE_VIA,
	 decode(mov.cod_mov,3,mov.NUM_CIV_PREC,mov.NUM_CIV) NUMERO_CIVICO,
	 decode(mov.cod_mov,3,mov.SUFFISSO_PREC,mov.SUFFISSO) SUFFISSO,
	 decode(mov.cod_mov,3,mov.INTERNO_PREC,mov.INTERNO) INTERNO,
	 decode(mov.cod_mov,3,mov.SUB_INTERNO_PREC,mov.SUB_INTERNO) SUB_INTERNO,
	 decode(mov.cod_mov,3,mov.SCALA_PREC,mov.SCALA) SCALA,
 	 decode(mov.cod_mov,3,mov.PIANO_PREC,mov.PIANO) PIANO,
	 decode(mov.cod_mov,3,
           vie_p.denom_uff||', '||mov.civico_esterno_prec||
	    decode(upper(ainp.valore),'S',' '||mov.civico_interno_prec,''),
           vie.denom_uff||', '||mov.civico_esterno||
	    decode(upper(ainp.valore),'S',' '||mov.civico_interno,'')) INDIRIZZO,
	 decode(mov.cod_mov,3,
           vie_p.denom_uff||', '||nvl(mov.num_civ_prec,0)||
	    decode(mov.suffisso_prec,'','','/'||mov.suffisso_prec)||
	    decode(mov.interno_prec,'','',' int.'||mov.interno_prec)||
	    decode(mov.scala_prec,'','',' Sc.'||mov.scala_prec)||
	    decode(mov.piano_prec,'','',' P.'||mov.piano_prec),
           vie.denom_uff||', '||nvl(mov.num_civ,0)||
	    decode(mov.suffisso,'','','/'||mov.suffisso)||
	    decode(mov.interno,'','',' int.'||mov.interno)||
	    decode(mov.scala,'','',' Sc.'||mov.scala)||
	    decode(mov.piano,'','',' P.'||mov.piano)) INDIRIZZO_INT,
	 lpad(m.cod_provincia,3,'0') COD_PROVINCIA_RESIDENZA,
	 lpad(m.cod_comune,3,'0') COD_COMUNE_RESIDENZA,
	 m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')') COMUNE_RESIDENZA,
	 to_char(null) NAZIONE_RESIDENZA,
	 substr(f_regione(m.cod_provincia),1,2) COD_REGIONE_RESIDENZA,
	 substr(f_regione(m.cod_provincia),3) REGIONE_RESIDENZA,
	 f_gruppo_nazioni(m.cod_provincia) GRUPPO_NAZIONE_RESIDENZA,
	 to_char(null) ZIPCODE_RESIDENZA,
         to_char(null) PROVINCIA_CONTEA_RESIDENZA,
	 to_char(null) PRESSO_RESIDENZA,
	 to_char(null) UFFICIO_CONSOLARE_RESIDENZA,
	 decode(mov.cod_mov,10,mov.COD_FAM_PREC,11,mov.COD_FAM_PREC) CODICE_FAMIGLIA_PREC,
	 decode(mov.cod_mov,10,mov.INTESTATARIO_PREC,11,mov.INTESTATARIO_PREC) INTESTATARIO_PREC,
	 decode(mov.cod_mov,10,mov.RAPPORTO_PAR_PREC,11,mov.RAPPORTO_PAR_PREC) RAPPORTO_PAR_PREC,
	 decode(mov.cod_mov,10,drp_p.descrizione,11,drp_p.descrizione) DES_RAPPORTO_PAR_PREC,
	 decode(mov.cod_mov,10,mov.COD_VIA_PREC,11,mov.COD_VIA_PREC) CODICE_VIA_PREC,
	 decode(mov.cod_mov,10,vie_p.denom_uff,11,vie_p.denom_uff) DENOMINAZIONE_VIA_PREC,
	 decode(mov.cod_mov,10,mov.NUM_CIV_PREC,11,mov.NUM_CIV_PREC) NUMERO_CIVICO_PREC,
	 decode(mov.cod_mov,10,mov.SUFFISSO_PREC,11,mov.SUFFISSO_PREC) SUFFISSO_PREC,
	 decode(mov.cod_mov,10,mov.INTERNO_PREC,11,mov.INTERNO_PREC) INTERNO_PREC,
	 decode(mov.cod_mov,10,mov.SUB_INTERNO_PREC,11,mov.SUB_INTERNO_PREC) SUB_INTERNO_PREC,
	 decode(mov.cod_mov,10,mov.SCALA_PREC,11,mov.SCALA_PREC) SCALA_PREC,
 	 decode(mov.cod_mov,10,mov.PIANO_PREC,11,mov.PIANO_PREC) PIANO_PREC,
	 decode(mov.cod_mov,
           10,vie_p.denom_uff||', '||MOV.CIVICO_ESTERNO_PREC||
	    decode(upper(ainp.valore),'S',' '||MOV.CIVICO_INTERNO_PREC,''),
           11,vie_p.denom_uff||', '||MOV.CIVICO_ESTERNO_PREC||
	    decode(upper(ainp.valore),'S',' '||MOV.CIVICO_INTERNO_PREC,'')) INDIRIZZO_PREC,
	 decode(mov.cod_mov,
           10,vie_p.denom_uff||', '||nvl(mov.num_civ_prec,0)||
	    decode(mov.suffisso_prec,'','','/'||mov.suffisso_prec)||
	    decode(mov.interno_prec,'','',' int.'||mov.interno_prec)||
	    decode(mov.scala_prec,'','',' Sc.'||mov.scala_prec)||
	    decode(mov.piano_prec,'','',' P.'||mov.piano_prec),
           11,vie_p.denom_uff||', '||nvl(mov.num_civ_prec,0)||
	    decode(mov.suffisso_prec,'','','/'||mov.suffisso_prec)||
	    decode(mov.interno_prec,'','',' int.'||mov.interno_prec)||
	    decode(mov.scala_prec,'','',' Sc.'||mov.scala_prec)||
	    decode(mov.piano_prec,'','',' P.'||mov.piano_prec)) INDIRIZZO_INT_PREC,
	 lpad(m.cod_provincia,3,'0') COD_PROVINCIA_RES_PREC,
	 lpad(m.cod_comune,3,'0') COD_COMUNE_RES_PREC,
	 m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')') COMUNE_RES_PREC,
	 to_char(null) NAZIONE_RES_PREC,
	 to_char(null) GRUPPO_NAZIONE_RES_PREC,
	 to_char(null) ZIPCODE_RES_PREC,
         to_char(null) PROVINCIA_CONTEA_RES_PREC,
	 to_char(null) PRESSO_RES_PREC,
	 to_char(null) UFFICIO_CONSOLARE_RES_PREC,
	 decode(ana.fascia,1,
           vie_f.denom_uff||', '||nvl(fam.num_civ,0)||
	    decode(fam.suffisso,'','','/'||fam.suffisso)||
	    decode(upper(ainp.valore),'S',
	     decode(fam.interno,'','',' int.'||fam.interno)||
	     decode(fam.scala,'','',' Sc.'||fam.scala)||
	     decode(fam.piano,'','',' P.'||fam.piano))) INDIRIZZO_ATTUALE,
	 decode(ana.fascia,1,
           vie_f.denom_uff||', '||nvl(fam.num_civ,0)||
	    decode(fam.suffisso,'','','/'||fam.suffisso)||
	    decode(fam.interno,'','',' int.'||fam.interno)||
	    decode(fam.scala,'','',' Sc.'||fam.scala)||
	    decode(fam.piano,'','',' P.'||fam.piano)) INDIRIZZO_INT_ATTUALE,
	 decode(ana.fascia,1,lpad(m.cod_provincia,3,'0')) COD_PROVINCIA_RES_ATTUALE,
	 decode(ana.fascia,1,lpad(m.cod_comune,3,'0')) COD_COMUNE_RES_ATTUALE,
	 decode(ana.fascia,1,m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')')) COMUNE_RES_ATTUALE,
	 decode(ana.fascia,1,f_cap(fam.cod_via, fam.num_civ, fam.suffisso)) CAP_COMUNE_RES_ATTUALE,
	 to_char(null) NAZIONE_RES_ATTUALE,
	 to_char(null) GRUPPO_NAZIONE_RES_ATTUALE,
	 to_char(null) ZIPCODE_RES_ATTUALE,
         to_char(null) PROVINCIA_CONTEA_RES_ATTUALE,
	 to_char(null) PRESSO_RES_ATTUALE,
	 to_char(null) UFFICIO_CONSOLARE_RES_ATTUALE,
 	 mov.COGNOME_NOME_CN cognome_nome_coniuge,
 	 mov.MATRICOLA_CN matricola_coniuge,
	 TO_DATE(mov.DATA_MAT,'J') DATA_MATRIMONIO,
	 TO_CHAR(TO_DATE(mov.DATA_MAT,'J'),'DD/MM/YYYY') DATA_MATRIMONIO_EDIT,
	 TO_DATE(mov.DATA_VED,'J') DATA_VEDOVANZA,
	 TO_CHAR(TO_DATE(mov.DATA_VED,'J'),'DD/MM/YYYY') DATA_VEDOVANZA_EDIT,
	 TO_DATE(mov.DATA_DIV,'J') DATA_DIVORZIO,
	 TO_CHAR(TO_DATE(mov.DATA_DIV,'J'),'DD/MM/YYYY') DATA_DIVORZIO_EDIT,
   	 mov.ANNO_CENS anno_censimento,
	 mov.SEZIONE_CENS sezione_censimento,
	 mov.FOGLIO_CENS foglio_censimento,
	 mov.COD_EDIFICIO_CENS cod_edificio_censimento,
 	 ana.COD_FISCALE CODICE_FISCALE,
	 ana.CF_CALCOLATO FLAG_CF_CALCOLATO,
-- stato_ele
       	 ele.stato stato_ele,
-- stato_scrutatore_albo_S
         scr_s.stato stato_scrutatore_albo_s,
-- stato_scrutatore_albgo_V
	     scr_v.stato stato_scrutatore_albo_v,
-- stato_scrutatore_albo_r
         scr_r.stato stato_scrutatore_albo_r,
-- stato_giudice_albo_a
	     gpo_a.stato stato_giudice_albo_a,
-- stato_giudice_albo_p
     	 gpo_p.stato stato_giudice_albo_p,
-- stato_presidente_seggio
	     pse.stato stato_presidente_seggio,
	 TO_DATE(mov.DATA_REG,'J') DATA_REGISTRAZIONE,
	 TO_CHAR(TO_DATE(mov.DATA_REG,'J'),'DD/MM/YYYY') DATA_REGISTRAZIONE_EDIT,
	 mov.TERMINALISTA,
	 a_utenti.nominativo NOME_TERMINALISTA,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(1, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(1, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_1,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(1, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(1, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_1,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(1, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(1, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_1,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(2, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(2, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_2,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(2, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(2, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_2,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(2, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(2, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_2,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(3, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(3, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_3,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(3, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(3, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_3,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(3, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(3, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_3,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(4, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(4, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_4,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(4, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(4, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_4,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(4, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(4, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_4,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(5, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(5, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_5,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(5, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(5, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_5,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(5, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(5, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_5,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(6, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(6, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_6,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(6, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(6, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_6,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(6, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(6, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_6,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(7, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(7, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_7,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(7, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(7, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_7,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(7, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(7, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_7,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(8, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(8, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_8,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(8, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(8, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_8,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(8, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(8, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_8,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(9, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(9, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_9,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(9, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(9, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_9,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(9, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(9, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_9,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(10, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(10, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_10,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(10, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(10, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_10,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(10, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(10, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_10,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(99, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),1,20)),
	   rtrim(substr(f_unita_territoriale(99, mov.cod_via, mov.num_civ, mov.suffisso),1,20))) des_unita_territoriale_CAP,
	 decode(mov.cod_mov,3,
	   substr(f_unita_territoriale(99, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),21,4),
	   substr(f_unita_territoriale(99, mov.cod_via, mov.num_civ, mov.suffisso),21,4)) codice_suddivisione_CAP,
	 decode(mov.cod_mov,3,
	   rtrim(substr(f_unita_territoriale(99, mov.cod_via_prec, mov.num_civ_prec, mov.suffisso_prec),25,30)),
	   rtrim(substr(f_unita_territoriale(99, mov.cod_via, mov.num_civ, mov.suffisso),25,30))) des_suddivisione_CAP,
       mov.anno_progr, mov.numero_progr, 1 sequenza,
-- RECAPITO_CELLULARE
         f_recapito_individuo(ana.matricola,'S') recapito_cellulare,
-- RECAPITO_TELEFONO_FISSO
         f_recapito_individuo(ana.matricola,'f') recapito_telefono_fisso,
-- RECAPITO_EMAIL
         f_recapito_individuo(ana.matricola,'E') recapito_email,
-- DOMICILIO_DIGITALE
         f_domicilio_digitale(ana.matricola) domicilio_digitale
  from a_utenti,
	arccom a, arccom b, arccom c, arccom d, arccom m,
	arcinp ainp, arcvie vie, arcvie vie_p, arcvie vie_f,
 	anadev dev, anadrp drp, anadrp drp_p,
	anadsc dsc, anadsc dsc_p, anadci dci, anadci dci_p, anadts dts, anadpr dpr,
	eleasc scr_v, eleasc scr_s, eleasc scr_r,
    eleagp gpo_a, eleagp gpo_p, eleaps pse,
    eleana ele,
	anafam fam_2, anafam fam, anaana ana, anamov mov
 where (m.cod_provincia, m.cod_Comune)	= (select pro_cliente, com_cliente
					     from menuditta)
   and a_utenti.utente		(+)	= mov.terminalista
   and ainp.parametro			= 'INTERNO_S'
   and a.cod_provincia		(+)	= mov.cod_pro_eve
   and a.cod_comune		(+)	= mov.cod_com_eve
   and b.cod_provincia		(+)	= ana.cod_pro_nas
   and b.cod_comune		(+)	= ana.cod_com_nas
   and c.cod_provincia		(+)	= ana.cod_pro_atto_nas
   and c.cod_comune		(+)	= ana.cod_com_atto_nas
   and d.cod_provincia		(+)	= mov.cod_pro_iscr_aire
   and d.cod_comune		(+)	= mov.cod_com_iscr_aire
   and vie.cod_via		(+)	= mov.cod_via
   and vie_p.cod_via		(+)	= mov.cod_via_prec
   and vie_f.cod_via		(+)	= fam.cod_via
   and drp.cod_rp		(+)	= mov.rapporto_par
   and drp.sesso		(+)	= mov.sesso
   and drp_p.cod_rp		(+)	= mov.rapporto_par_prec
   and drp_p.sesso		(+)	= mov.sesso_prec
   and dsc.cod_sc		(+)	= mov.stato_civile
   and dsc.sesso		(+)	= mov.sesso
   and dsc_p.cod_sc		(+)	= mov.stato_civile_prec
   and dsc_p.sesso		(+)	= mov.sesso_prec
   and dci.cod_ci		(+)	= mov.nazionalita
   and dci_p.cod_ci		(+)	= mov.nazionalita_prec
   and dpr.cod_pr		(+)	= mov.cod_prof
   and dpr.sesso		(+)	= mov.sesso
   and dts.cod_ts		(+)	= mov.titolo_studio
--
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
--
   and fam_2.fascia		(+)	= 2
   and fam_2.cod_fam		(+)	= decode(mov.cod_mov,3,mov.cod_fam_prec,mov.cod_fam)
   and fam.fascia		(+)	= 1
   and fam.cod_fam		(+)	= decode(mov.cod_mov,3,mov.cod_fam_prec,mov.cod_fam)
   and dev.cod_ev			= mov.cod_eve
   and ana.matricola			= mov.matricola
   and mov.cod_mov 			= 97
   and mov.cod_eve 			= 99
   and (nvl(mov.cognome_nome_prec,' ') 	!= nvl(mov.cognome_nome,' ')
        or nvl(mov.sesso_prec,' ') 	!= nvl(mov.sesso,' '))
UNION
--
--	estrazione movimenti A.I.R.E.
--	. ISCRIZIONI
-- 	. CANCELLAZIONI
--	. RETTIFICHE STATO CIVILE
--
select
	 mov.MATRICOLA,
	 decode(ana.fascia,1,'SI','NO') flag_residente,
	 decode(ana.fascia,3,'SI','NO') flag_aire,
	 decode(ana.stato,17,'SI','NO') flag_iscritto_preliminare,
 	 mov.COD_MOV CODICE_MOVIMENTO,
	 decode(mov.cod_mov,
	   3,'ISCRIZIONE IN AIRE',
	   1,'CANCELLAZIONE DA AIRE',
	   4,'CANCELLAZIONE DA AIRE',
	  12,'CAMBIO DI ABITAZIONE IN AIRE',
	  13,'CAMBIO DI ABITAZIONE IN AIRE',
	  98,'RETTIFICA AIRE') DES_CODICE_MOVIMENTO,
	 mov.COD_EVE CODICE_EVENTO,
	 decode(mov.cod_mov,98,'STATO CIVILE',dev.descrizione) DES_CODICE_EVENTO,
 	 to_date(mov.DATA_EVE,'j') DATA_EVENTO,
 	 to_char(to_date(mov.DATA_EVE,'j'),'dd/mm/yyyy') DATA_EVENTO_EDIT,
 	 lpad(mov.COD_PRO_EVE,3,'0') COD_PROVINCIA_EVENTO,
	 lpad(mov.COD_COM_EVE,3,'0') COD_COMUNE_EVENTO,
	 a.descrizione||decode(a.sigla_provincia,'','',' ('||a.sigla_provincia||')') COMUNE_EVENTO,
	 substr(f_regione(mov.COD_PRO_EVE),1,2) COD_REGIONE_EVENTO,
	 substr(f_regione(mov.COD_PRO_EVE),3) REGIONE_EVENTO,
	 f_gruppo_nazioni(mov.cod_pro_eve) GRUPPO_NAZIONE_EVENTO,
 	 lpad(mov.COD_PRO_ISCR_AIRE,3,'0') COD_PROVINCIA_PREC_ISCR_AIRE,
	 lpad(mov.COD_COM_ISCR_AIRE,3,'0') COD_COMUNE_PREC_ISCR_AIRE,
	 d.descrizione||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')') COMUNE_PREC_ISCR_AIRE,
	 substr(f_regione(mov.COD_PRO_ISCR_AIRE),1,2) COD_REGIONE_PREC_ISCR_AIRE,
	 substr(f_regione(mov.COD_COM_ISCR_AIRE),3) REGIONE_PREC_ISCR_AIRE,
	 mov.ANNO_PRATICA, mov.PRATICA,
	 decode(mov.NUCLEO_PARTENZA,1,'SI','NO') NUCLEO_CHIUSO,
	 decode(mov.NUCLEO_ARRIVO,1,'SI','NO') NUCLEO_ISTITUITO,
	 mov.COGNOME_NOME,
	 decode(mov.cod_mov,98,mov.COGNOME_NOME_PREC) COGNOME_NOME_PREC,
	 lpad(ana.COD_PRO_NAS,3,'0') cod_provincia_nascita,
	 lpad(ana.COD_COM_NAS,3,'0') cod_comune_nascita,
	 b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')') comune_nascita,
	 substr(f_regione(ana.cod_pro_nas),1,2) COD_REGIONE_NASCITA,
	 substr(f_regione(ana.cod_pro_nas),3) REGIONE_NASCITA,
	 f_gruppo_nazioni(ana.cod_pro_nas) GRUPPO_NAZIONE_NASCITA,
	 TO_DATE(ana.DATA_NAS,'J') DATA_NASCITA,
	 DECODE(ana.anno_nas,'S','00/00/'||to_char(to_date(ana.DATA_NAS,'j'),'yyyy'),
		to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')) DATA_NASCITA_EDIT,
	 to_char(TO_DATE(ana.DATA_NAS,'J'),'yyyy') ANNO_NASCITA,
	 lpad(ana.COD_PRO_ATTO_NAS,3,'0') COD_PROVINCIA_ATTO_NASCITA,
	 lpad(ana.COD_COM_ATTO_NAS,3,'0') COD_COMUNE_ATTO_NASCITA,
	 c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') comune_atto_nascita,
	 substr(f_regione(ana.cod_pro_atto_nas),1,2) COD_REGIONE_ATTO_NASCITA,
	 substr(f_regione(ana.cod_pro_atto_nas),3) REGIONE_ATTO_NASCITA,
         ana.atto_nas||
	   DECODE(ANA.PARTE_NAS,'','',' P.'||decode(ana.PARTE_NAS,1,'I',2,'II'))||
	   decode(ana.serie_nas,'','',' S.'||ana.serie_nas)||
	   decode(ana.ufficio_nas,'','',' U.'||ana.ufficio_nas)||
	   decode(ana.anno_atto_nas,'','','/'||ana.anno_atto_nas) ATTO_NASCITA_EDIT,
	 mov.STATO_CIVILE,
	 dsc.descrizione des_stato_civile,
	 mov.STATO_CIVILE_PREC,
	 dsc_p.descrizione des_stato_civile,
	 mov.SESSO,
	 decode(mov.cod_mov,98,mov.SESSO_PREC) SESSO_PREC,
	 mov.NAZIONALITA,
	 dci.ist_ci NAZIONALITA_ISTAT,
	 decode(dci.cee,'S','SI','NO') NAZIONALITA_CEE,
	 dci.descrizione DES_NAZIONALITA,
	 f_gruppo_nazionalita(mov.nazionalita) GRUPPO_NAZIONALITA,
	 to_char(null) NAZIONALITA_PREC,
	 to_number(null) NAZIONALITA_ISTAT_PREC,
	 to_char(null) DES_NAZIONALITA_PREC,
	 to_char(null) GRUPPO_NAZIONALITA_PREC,
	 ana.PATERNITA,
	 ana.MATERNITA,
	 mov.TITOLO_STUDIO,
	 dts.descrizione DES_TITOLO_STUDIO,
	 mov.COD_PROF,
	 dpr.descrizione DES_PROFESSIONE,
	 decode(mov.cod_mov,1,mov.COD_FAM_PREC,mov.COD_FAM) CODICE_FAMIGLIA,
	 decode(mov.cod_mov,3,to_number(null),fam_4.progr_eliminazione) PROGR_ELIMINAZIONE_FOGLIO,
	 decode(mov.cod_mov,1,mov.INTESTATARIO_PREC,mov.INTESTATARIO) INTESTATARIO,
	 decode(mov.cod_mov,1,mov.RAPPORTO_PAR_PREC,mov.RAPPORTO_PAR) RAPPORTO_PAR,
	 decode(mov.cod_mov,1,drp_p.descrizione,drp.descrizione) DES_RAPPORTO_PAR,
	 to_number(null) CODICE_VIA,
	 to_char(null) DENOMINAZIONE_VIA,
	 to_number(null) NUMERO_CIVICO,
	 to_char(null) SUFFISSO,
	 to_number(null) INTERNO,
         to_char(null) SUB_INTERNO,
	 to_char(null) SCALA,
 	 to_char(null) PIANO,
	 decode(mov.cod_mov,1,mov.VIA_AIRE_PREC,mov.VIA_AIRE) INDIRIZZO,
	 decode(mov.cod_mov,1,mov.VIA_AIRE_PREC,mov.VIA_AIRE) INDIRIZZO_INT,
	 lpad(decode(mov.cod_mov,1,mov.cod_pro_aire_prec,mov.cod_pro_aire),3,'0') COD_PROVINCIA_RESIDENZA,
	 lpad(decode(mov.cod_mov,1,mov.cod_com_aire_prec,mov.cod_com_aire),3,'0') COD_COMUNE_RESIDENZA,
	 decode(mov.cod_mov,1,
  	   m_p.descrizione||decode(m_p.sigla_provincia,'','',' ('||m_p.sigla_provincia||')'),
  	   m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')')) COMUNE_RESIDENZA,
	 decode(mov.cod_mov,1,n_p.descrizione,n.descrizione) NAZIONE_RESIDENZA,
	 to_char(null) COD_REGIONE_RESIDENZA,
	 to_char(null) REGIONE_RESIDENZA,
	 f_gruppo_nazioni(decode(mov.cod_mov,1,mov.cod_pro_aire_prec,mov.cod_pro_aire)) GRUPPO_NAZIONE_RESIDENZA,
	 decode(mov.cod_mov,1,mov.zipcode_prec,mov.zipcode) ZIPCODE_RESIDENZA,
         decode(mov.cod_mov,1,mov.provincia_contea_prec,mov.provincia_contea) PROVINCIA_CONTEA_RESIDENZA,
	 decode(mov.cod_mov,1,mov.presso_prec,mov.presso) PRESSO_RESIDENZA,
	 decode(mov.cod_mov,1,
	   lpad(m_p.cod_consolato,5,'0')||lpad(m_p.tipo_consolato,2,'0'),
	   lpad(m.cod_consolato,5,'0')||lpad(m.tipo_consolato,2,'0')) UFFICIO_CONSOLARE_RESIDENZA,
	 decode(mov.cod_mov,12,mov.COD_FAM_PREC,13,mov.COD_FAM_PREC) CODICE_FAMIGLIA_PREC,
	 decode(mov.cod_mov,12,mov.INTESTATARIO_PREC,13,mov.INTESTATARIO_PREC) INTESTATARIO_PREC,
	 decode(mov.cod_mov,12,mov.RAPPORTO_PAR_PREC,13,mov.RAPPORTO_PAR_PREC) RAPPORTO_PAR_PREC,
	 decode(mov.cod_mov,12,drp_p.descrizione,13,drp_p.descrizione) DES_RAPPORTO_PAR_PREC,
	 to_number(null) CODICE_VIA_PREC,
	 to_char(null) DENOMINAZIONE_VIA_PREC,
	 to_number(null) NUMERO_CIVICO_PREC,
	 to_char(null) SUFFISSO_PREC,
	 to_number(null) INTERNO_PREC,
	 to_char(null) SUB_INTERNO_PREC,
	 to_char(null) SCALA_PREC,
 	 to_char(null) PIANO_PREC,
	 decode(mov.cod_mov,12,mov.VIA_AIRE_PREC,13,mov.VIA_AIRE_PREC) INDIRIZZO_PREC,
	 decode(mov.cod_mov,12,mov.VIA_AIRE_PREC,13,mov.VIA_AIRE_PREC) INDIRIZZO_INT_PREC,
	 lpad(decode(mov.cod_mov,12,mov.cod_pro_aire_prec,13,mov.cod_pro_aire_prec),3,'0') COD_PROVINCIA_RES_PREC,
	 lpad(decode(mov.cod_mov,12,mov.cod_com_aire_prec,13,mov.cod_com_aire_prec),3,'0') COD_COMUNE_RES_PREC,
	 decode(mov.cod_mov,
	   12,m_p.descrizione||decode(m_p.sigla_provincia,'','',' ('||m_p.sigla_provincia||')'),
  	   13,m_p.descrizione||decode(m_p.sigla_provincia,'','',' ('||m_p.sigla_provincia||')')) COMUNE_RES_PREC,
	 decode(mov.cod_mov,12,n_p.descrizione,13,n_p.descrizione) NAZIONE_RESIDENZA_PREC,
	 f_gruppo_nazioni(decode(mov.cod_mov,12,mov.cod_pro_aire_prec,13,mov.cod_pro_aire_prec)) GRUPPO_NAZIONE_RES_PREC,
	 decode(mov.cod_mov,12,mov.zipcode_prec,13,mov.zipcode_prec) ZIPCODE_RESIDENZA_PREC,
         decode(mov.cod_mov,12,mov.provincia_contea_prec,13,mov.provincia_contea_prec) PROVINCIA_CONTEA_RES_PREC,
	 decode(mov.cod_mov,12,mov.presso_prec,13,mov.presso_prec) PRESSO_RESIDENZA_PREC,
	 decode(mov.cod_mov,
	   12,lpad(m_p.cod_consolato,5,'0')||lpad(m_p.tipo_consolato,2,'0'),
	   13,lpad(m_p.cod_consolato,5,'0')||lpad(m_p.tipo_consolato,2,'0')) UFFICIO_CONSOLARE_RES_PREC,
	 decode(ana.fascia,3,fam.VIA_AIRE) INDIRIZZO_ATTUALE,
	 decode(ana.fascia,3,fam.VIA_AIRE) INDIRIZZO_ATTUALE,
	 lpad(decode(ana.fascia,3,fam.cod_pro_aire),3,'0') COD_PROVINCIA_RES_ATTUALE,
	 lpad(decode(ana.fascia,3,fam.cod_com_aire),3,'0') COD_COMUNE_RES_ATTUALE,
	 decode(ana.fascia,3,
  	   e.descrizione||decode(e.sigla_provincia,'','',' ('||e.sigla_provincia||')')) COMUNE_RES_ATTUALE,
	 to_char(null) CAP_COMUNE_RES_ATTUALE,
	 decode(ana.fascia,3,f.descrizione) NAZIONE_RES_ATTUALE,
	 f_gruppo_nazioni(decode(ana.fascia,3,fam.cod_pro_aire)) GRUPPO_NAZIONE_RES_ATTUALE,
	 decode(ana.fascia,3,fam.ZIPCODE) ZIPCODE_RES_ATTUALE,
         decode(ana.fascia,3,fam.provincia_contea) PROVINCIA_CONTEA_RES_ATTUALE,
	 decode(ana.fascia,3,fam.presso) PRESSO_RES_ATTUALE,
	 decode(ana.fascia,3,lpad(e.cod_consolato,5,'0')||lpad(e.tipo_consolato,2,'0')) UFFICIO_CONSOLARE_RES_ATTUALE,
 	 mov.COGNOME_NOME_CN cognome_nome_coniuge,
 	 mov.MATRICOLA_CN matricola_coniuge,
	 TO_DATE(mov.DATA_MAT,'J') DATA_MATRIMONIO,
	 TO_CHAR(TO_DATE(mov.DATA_MAT,'J'),'DD/MM/YYYY') DATA_MATRIMONIO_EDIT,
	 TO_DATE(mov.DATA_VED,'J') DATA_VEDOVANZA,
	 TO_CHAR(TO_DATE(mov.DATA_VED,'J'),'DD/MM/YYYY') DATA_VEDOVANZA_EDIT,
	 TO_DATE(mov.DATA_DIV,'J') DATA_DIVORZIO,
	 TO_CHAR(TO_DATE(mov.DATA_DIV,'J'),'DD/MM/YYYY') DATA_DIVORZIO_EDIT,
   	 mov.ANNO_CENS anno_censimento,
	 mov.SEZIONE_CENS sezione_censimento,
	 mov.FOGLIO_CENS foglio_censimento,
	 mov.COD_EDIFICIO_CENS cod_edificio_censimento,
 	 ana.COD_FISCALE CODICE_FISCALE,
	 ana.CF_CALCOLATO FLAG_CF_CALCOLATO,
-- stato_ele
       	 ele.stato stato_ele,
-- stato_scrutatore_albo_S
         scr_s.stato stato_scrutatore_albo_s,
-- stato_scrutatore_albgo_V
	     scr_v.stato stato_scrutatore_albo_v,
-- stato_scrutatore_albo_r
         scr_r.stato stato_scrutatore_albo_r,
-- stato_giudice_albo_a
	     gpo_a.stato stato_giudice_albo_a,
-- stato_giudice_albo_p
     	 gpo_p.stato stato_giudice_albo_p,
-- stato_presidente_seggio
	     pse.stato stato_presidente_seggio,
	 TO_DATE(mov.DATA_REG,'J') DATA_REGISTRAZIONE,
	 TO_CHAR(TO_DATE(mov.DATA_REG,'J'),'DD/MM/YYYY') DATA_REGISTRAZIONE_EDIT,
	 mov.TERMINALISTA,
	 a_utenti.nominativo NOME_TERMINALISTA,
	 to_char(null) des_unita_territoriale_1,
	 to_char(null) codice_suddivisione_1,
	 to_char(null) des_suddivisione_1,
	 to_char(null) des_unita_territoriale_2,
	 to_char(null) codice_suddivisione_2,
	 to_char(null) des_suddivisione_2,
	 to_char(null) des_unita_territoriale_3,
	 to_char(null) codice_suddivisione_3,
	 to_char(null) des_suddivisione_3,
	 to_char(null) des_unita_territoriale_4,
	 to_char(null) codice_suddivisione_4,
	 to_char(null) des_suddivisione_4,
	 to_char(null) des_unita_territoriale_5,
	 to_char(null) codice_suddivisione_5,
	 to_char(null) des_suddivisione_5,
	 to_char(null) des_unita_territoriale_6,
	 to_char(null) codice_suddivisione_6,
	 to_char(null) des_suddivisione_6,
	 to_char(null) des_unita_territoriale_7,
	 to_char(null) codice_suddivisione_7,
	 to_char(null) des_suddivisione_7,
	 to_char(null) des_unita_territoriale_8,
	 to_char(null) codice_suddivisione_8,
	 to_char(null) des_suddivisione_8,
	 to_char(null) des_unita_territoriale_9,
	 to_char(null) codice_suddivisione_9,
	 to_char(null) des_suddivisione_9,
	 to_char(null) des_unita_territoriale_10,
	 to_char(null) codice_suddivisione_10,
	 to_char(null) des_suddivisione_10,
	 to_char(null) des_unita_territoriale_CAP,
	 to_char(null) codice_suddivisione_CAP,
	 to_char(null) des_suddivisione_CAP,
       mov.anno_progr, mov.numero_progr,
       decode(mov.cod_eve,52,2,1) sequenza,
-- RECAPITO_CELLULARE
         f_recapito_individuo(ana.matricola,'S') recapito_cellulare,
-- RECAPITO_TELEFONO_FISSO
         f_recapito_individuo(ana.matricola,'f') recapito_telefono_fisso,
-- RECAPITO_EMAIL
         f_recapito_individuo(ana.matricola,'E') recapito_email,
-- DOMICILIO_DIGITALE
         f_domicilio_digitale(ana.matricola) domicilio_digitale
  from a_utenti,
	arccom a, arccom b, arccom c, arccom d,
	arccom e, arccom f,
	arccom m, arccom m_p, arccom n, arccom n_p,
 	anadev dev, anadrp drp, anadrp drp_p,
	anadsc dsc, anadsc dsc_p, anadci dci, anadts dts, anadpr dpr,
	eleasc scr_v, eleasc scr_s, eleasc scr_r,
    eleagp gpo_a, eleagp gpo_p, eleaps pse,
    eleana ele,
	anafam fam_4, anafam fam, anaana ana, anamov mov
 where a_utenti.utente		(+)	= mov.terminalista
   and a.cod_provincia		(+)	= mov.cod_pro_eve
   and a.cod_comune		(+)	= mov.cod_com_eve
   and b.cod_provincia		(+)	= ana.cod_pro_nas
   and b.cod_comune		(+)	= ana.cod_com_nas
   and c.cod_provincia		(+)	= ana.cod_pro_atto_nas
   and c.cod_comune		(+)	= ana.cod_com_atto_nas
   and d.cod_provincia		(+)	= mov.cod_pro_iscr_aire
   and d.cod_comune		(+)	= mov.cod_com_iscr_aire
   and e.cod_provincia		(+)	= fam.cod_pro_aire
   and e.cod_comune		(+)	= fam.cod_com_aire
   and f.cod_provincia		(+)	= fam.cod_pro_aire
   and f.cod_comune		(+)	= 0
   and m.cod_provincia		(+) 	= mov.cod_pro_aire
   and m.cod_comune		(+)	= mov.cod_com_aire
   and m_p.cod_provincia	(+) 	= mov.cod_pro_aire_prec
   and m_p.cod_comune		(+)	= mov.cod_com_aire_prec
   and n.cod_provincia		(+) 	= mov.cod_pro_aire
   and n.cod_comune		(+)	= 0
   and n_p.cod_provincia	(+) 	= mov.cod_pro_aire_prec
   and n_p.cod_comune		(+)	= 0
   and drp.cod_rp		(+)	= mov.rapporto_par
   and drp.sesso		(+)	= mov.sesso
   and drp_p.cod_rp		(+)	= mov.rapporto_par_prec
   and drp_p.sesso		(+)	= mov.sesso_prec
   and dsc.cod_sc		(+)	= mov.stato_civile
   and dsc.sesso		(+)	= mov.sesso
   and dsc_p.cod_sc		(+)	= mov.stato_civile_prec
   and dsc_p.sesso		(+)	= mov.sesso_prec
   and dci.cod_ci		(+)	= mov.nazionalita
   and dpr.cod_pr		(+)	= mov.cod_prof
   and dpr.sesso		(+)	= mov.sesso
   and dts.cod_ts		(+)	= mov.titolo_studio
--
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
--
   and fam_4.fascia		(+)	= 4
   and fam_4.cod_fam		(+)	= decode(mov.cod_mov,1,mov.cod_fam_prec,mov.cod_fam)
   and fam.fascia		(+)	= 3
   and fam.cod_fam		(+)	= decode(mov.cod_mov,1,mov.cod_fam_prec,mov.cod_fam)
   and dev.cod_ev			= mov.cod_eve
   and ana.matricola			= mov.matricola
   and (mov.cod_mov in (3,4)
        or (mov.cod_mov = 1 and mov.cod_eve = 4)
        or (mov.cod_mov = 12 and mov.cod_eve = 92)
        or (mov.cod_mov = 13 and mov.cod_eve = 91)
        or (mov.cod_mov = 98 and mov.cod_eve = 99
            and nvl(mov.stato_civile_prec,' ') != nvl(mov.stato_civile,' ')
           )
       )
UNION
--
--	estrazione movimenti A.I.R.E.
--	. RETTIFICHE GENERALITA (COGNOME_NOME o SESSO)
--
select
	 mov.MATRICOLA,
	 decode(ana.fascia,1,'SI','NO') flag_residente,
	 decode(ana.fascia,3,'SI','NO') flag_aire,
	 decode(ana.stato,17,'SI','NO') flag_iscritto_preliminare,
 	 mov.COD_MOV CODICE_MOVIMENTO,
	 decode(mov.cod_mov,
	   3,'ISCRIZIONE IN AIRE',
	   1,'CANCELLAZIONE DA AIRE',
	   4,'CANCELLAZIONE DA AIRE',
	  12,'CAMBIO DI ABITAZIONE IN AIRE',
	  13,'CAMBIO DI ABITAZIONE IN AIRE',
	  98,'RETTIFICA AIRE') DES_CODICE_MOVIMENTO,
	 mov.COD_EVE CODICE_EVENTO,
	 decode(mov.cod_mov,98,'GENERALITA',dev.descrizione) DES_CODICE_EVENTO,
 	 to_date(mov.DATA_EVE,'j') DATA_EVENTO,
 	 to_char(to_date(mov.DATA_EVE,'j'),'dd/mm/yyyy') DATA_EVENTO_EDIT,
 	 lpad(mov.COD_PRO_EVE,3,'0') COD_PROVINCIA_EVENTO,
	 lpad(mov.COD_COM_EVE,3,'0') COD_COMUNE_EVENTO,
	 a.descrizione||decode(a.sigla_provincia,'','',' ('||a.sigla_provincia||')') COMUNE_EVENTO,
	 substr(f_regione(mov.COD_PRO_EVE),1,2) COD_REGIONE_EVENTO,
	 substr(f_regione(mov.COD_PRO_EVE),3) REGIONE_EVENTO,
	 f_gruppo_nazioni(mov.cod_pro_eve) GRUPPO_NAZIONE_EVENTO,
 	 lpad(mov.COD_PRO_ISCR_AIRE,3,'0') COD_PROVINCIA_PREC_ISCR_AIRE,
	 lpad(mov.COD_COM_ISCR_AIRE,3,'0') COD_COMUNE_PREC_ISCR_AIRE,
	 d.descrizione||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')') COMUNE_PREC_ISCR_AIRE,
	 substr(f_regione(mov.COD_PRO_ISCR_AIRE),1,2) COD_REGIONE_PREC_ISCR_AIRE,
	 substr(f_regione(mov.COD_COM_ISCR_AIRE),3) REGIONE_PREC_ISCR_AIRE,
	 mov.ANNO_PRATICA, mov.PRATICA,
	 decode(mov.NUCLEO_PARTENZA,1,'SI','NO') NUCLEO_CHIUSO,
	 decode(mov.NUCLEO_ARRIVO,1,'SI','NO') NUCLEO_ISTITUITO,
	 mov.COGNOME_NOME,
	 decode(mov.cod_mov,98,mov.COGNOME_NOME_PREC) COGNOME_NOME_PREC,
	 lpad(ana.COD_PRO_NAS,3,'0') cod_provincia_nascita,
	 lpad(ana.COD_COM_NAS,3,'0') cod_comune_nascita,
	 b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')') comune_nascita,
	 substr(f_regione(ana.cod_pro_nas),1,2) COD_REGIONE_NASCITA,
	 substr(f_regione(ana.cod_pro_nas),3) REGIONE_NASCITA,
	 f_gruppo_nazioni(ana.cod_pro_nas) GRUPPO_NAZIONE_NASCITA,
	 TO_DATE(ana.DATA_NAS,'J') DATA_NASCITA,
	 DECODE(ana.anno_nas,'S','00/00/'||to_char(to_date(ana.DATA_NAS,'j'),'yyyy'),
		to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')) DATA_NASCITA_EDIT,
	 to_char(TO_DATE(ana.DATA_NAS,'J'),'yyyy') ANNO_NASCITA,
	 lpad(ana.COD_PRO_ATTO_NAS,3,'0') COD_PROVINCIA_ATTO_NASCITA,
	 lpad(ana.COD_COM_ATTO_NAS,3,'0') COD_COMUNE_ATTO_NASCITA,
	 c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') comune_atto_nascita,
	 substr(f_regione(ana.cod_pro_atto_nas),1,2) COD_REGIONE_ATTO_NASCITA,
	 substr(f_regione(ana.cod_pro_atto_nas),3) REGIONE_ATTO_NASCITA,
         ana.atto_nas||
	   DECODE(ANA.PARTE_NAS,'','',' P.'||decode(ana.PARTE_NAS,1,'I',2,'II'))||
	   decode(ana.serie_nas,'','',' S.'||ana.serie_nas)||
	   decode(ana.ufficio_nas,'','',' U.'||ana.ufficio_nas)||
	   decode(ana.anno_atto_nas,'','','/'||ana.anno_atto_nas) ATTO_NASCITA_EDIT,
	 mov.STATO_CIVILE,
	 dsc.descrizione des_stato_civile,
	 mov.STATO_CIVILE_PREC,
	 dsc_p.descrizione des_stato_civile,
	 mov.SESSO,
	 decode(mov.cod_mov,98,mov.SESSO_PREC) SESSO_PREC,
	 mov.NAZIONALITA,
	 dci.ist_ci NAZIONALITA_ISTAT,
	 decode(dci.cee,'S','SI','NO') NAZIONALITA_CEE,
	 dci.descrizione DES_NAZIONALITA,
	 f_gruppo_nazionalita(mov.nazionalita) GRUPPO_NAZIONALITA,
	 to_char(null) NAZIONALITA_PREC,
	 to_number(null) NAZIONALITA_ISTAT_PREC,
	 to_char(null) DES_NAZIONALITA_PREC,
	 to_char(null) GRUPPO_NAZIONALITA_PREC,
	 ana.PATERNITA,
	 ana.MATERNITA,
	 mov.TITOLO_STUDIO,
	 dts.descrizione DES_TITOLO_STUDIO,
	 mov.COD_PROF,
	 dpr.descrizione DES_PROFESSIONE,
	 decode(mov.cod_mov,1,mov.COD_FAM_PREC,mov.COD_FAM) CODICE_FAMIGLIA,
	 decode(mov.cod_mov,3,to_number(null),fam_4.progr_eliminazione) PROGR_ELIMINAZIONE_FOGLIO,
	 decode(mov.cod_mov,1,mov.INTESTATARIO_PREC,mov.INTESTATARIO) INTESTATARIO,
	 decode(mov.cod_mov,1,mov.RAPPORTO_PAR_PREC,mov.RAPPORTO_PAR) RAPPORTO_PAR,
	 decode(mov.cod_mov,1,drp_p.descrizione,drp.descrizione) DES_RAPPORTO_PAR,
	 to_number(null) CODICE_VIA,
	 to_char(null) DENOMINAZIONE_VIA,
	 to_number(null) NUMERO_CIVICO,
	 to_char(null) SUFFISSO,
	 to_number(null) INTERNO,
         to_char(null) SUB_INTERNO,
	 to_char(null) SCALA,
 	 to_char(null) PIANO,
	 decode(mov.cod_mov,1,mov.VIA_AIRE_PREC,mov.VIA_AIRE) INDIRIZZO,
	 decode(mov.cod_mov,1,mov.VIA_AIRE_PREC,mov.VIA_AIRE) INDIRIZZO_INT,
	 lpad(decode(mov.cod_mov,1,mov.cod_pro_aire_prec,mov.cod_pro_aire),3,'0') COD_PROVINCIA_RESIDENZA,
	 lpad(decode(mov.cod_mov,1,mov.cod_com_aire_prec,mov.cod_com_aire),3,'0') COD_COMUNE_RESIDENZA,
	 decode(mov.cod_mov,1,
  	   m_p.descrizione||decode(m_p.sigla_provincia,'','',' ('||m_p.sigla_provincia||')'),
  	   m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')')) COMUNE_RESIDENZA,
	 decode(mov.cod_mov,1,n_p.descrizione,n.descrizione) NAZIONE_RESIDENZA,
	 to_char(null) COD_REGIONE_RESIDENZA,
	 to_char(null) REGIONE_RESIDENZA,
	 f_gruppo_nazioni(decode(mov.cod_mov,1,mov.cod_pro_aire_prec,mov.cod_pro_aire)) GRUPPO_NAZIONE_RESIDENZA,
	 decode(mov.cod_mov,1,mov.zipcode_prec,mov.zipcode) ZIPCODE_RESIDENZA,
         decode(mov.cod_mov,1,mov.provincia_contea_prec,mov.provincia_contea) PROVINCIA_CONTEA_RESIDENZA,
	 decode(mov.cod_mov,1,mov.presso_prec,mov.presso) PRESSO_RESIDENZA,
	 decode(mov.cod_mov,1,
	   lpad(m_p.cod_consolato,5,'0')||lpad(m_p.tipo_consolato,2,'0'),
	   lpad(m.cod_consolato,5,'0')||lpad(m.tipo_consolato,2,'0')) UFFICIO_CONSOLARE_RESIDENZA,
	 decode(mov.cod_mov,12,mov.COD_FAM_PREC,13,mov.COD_FAM_PREC) CODICE_FAMIGLIA_PREC,
	 decode(mov.cod_mov,12,mov.INTESTATARIO_PREC,13,mov.INTESTATARIO_PREC) INTESTATARIO_PREC,
	 decode(mov.cod_mov,12,mov.RAPPORTO_PAR_PREC,13,mov.RAPPORTO_PAR_PREC) RAPPORTO_PAR_PREC,
	 decode(mov.cod_mov,12,drp_p.descrizione,13,drp_p.descrizione) DES_RAPPORTO_PAR_PREC,
	 to_number(null) CODICE_VIA_PREC,
	 to_char(null) DENOMINAZIONE_VIA_PREC,
	 to_number(null) NUMERO_CIVICO_PREC,
	 to_char(null) SUFFISSO_PREC,
	 to_number(null) INTERNO_PREC,
	 to_char(null) SUB_INTERNO_PREC,
	 to_char(null) SCALA_PREC,
 	 to_char(null) PIANO_PREC,
	 decode(mov.cod_mov,12,mov.VIA_AIRE_PREC,13,mov.VIA_AIRE_PREC) INDIRIZZO_PREC,
	 decode(mov.cod_mov,12,mov.VIA_AIRE_PREC,13,mov.VIA_AIRE_PREC) INDIRIZZO_INT_PREC,
	 lpad(decode(mov.cod_mov,12,mov.cod_pro_aire_prec,13,mov.cod_pro_aire_prec),3,'0') COD_PROVINCIA_RES_PREC,
	 lpad(decode(mov.cod_mov,12,mov.cod_com_aire_prec,13,mov.cod_com_aire_prec),3,'0') COD_COMUNE_RES_PREC,
	 decode(mov.cod_mov,
	   12,m_p.descrizione||decode(m_p.sigla_provincia,'','',' ('||m_p.sigla_provincia||')'),
  	   13,m_p.descrizione||decode(m_p.sigla_provincia,'','',' ('||m_p.sigla_provincia||')')) COMUNE_RES_PREC,
	 decode(mov.cod_mov,12,n_p.descrizione,13,n_p.descrizione) NAZIONE_RESIDENZA_PREC,
	 f_gruppo_nazioni(decode(mov.cod_mov,12,mov.cod_pro_aire_prec,13,mov.cod_pro_aire_prec)) GRUPPO_NAZIONE_RES_PREC,
	 decode(mov.cod_mov,12,mov.zipcode_prec,13,mov.zipcode_prec) ZIPCODE_RESIDENZA_PREC,
         decode(mov.cod_mov,12,mov.provincia_contea_prec,13,mov.provincia_contea_prec) PROVINCIA_CONTEA_RES_PREC,
	 decode(mov.cod_mov,12,mov.presso_prec,13,mov.presso_prec) PRESSO_RESIDENZA_PREC,
	 decode(mov.cod_mov,
	   12,lpad(m_p.cod_consolato,5,'0')||lpad(m_p.tipo_consolato,2,'0'),
	   13,lpad(m_p.cod_consolato,5,'0')||lpad(m_p.tipo_consolato,2,'0')) UFFICIO_CONSOLARE_RES_PREC,
	 decode(ana.fascia,3,fam.VIA_AIRE) INDIRIZZO_ATTUALE,
	 decode(ana.fascia,3,fam.VIA_AIRE) INDIRIZZO_ATTUALE,
	 lpad(decode(ana.fascia,3,fam.cod_pro_aire),3,'0') COD_PROVINCIA_RES_ATTUALE,
	 lpad(decode(ana.fascia,3,fam.cod_com_aire),3,'0') COD_COMUNE_RES_ATTUALE,
	 decode(ana.fascia,3,
  	   e.descrizione||decode(e.sigla_provincia,'','',' ('||e.sigla_provincia||')')) COMUNE_RES_ATTUALE,
	 to_char(null) CAP_COMUNE_RES_ATTUALE,
	 decode(ana.fascia,3,f.descrizione) NAZIONE_RES_ATTUALE,
	 f_gruppo_nazioni(decode(ana.fascia,3,fam.cod_pro_aire)) GRUPPO_NAZIONE_RES_ATTUALE,
	 decode(ana.fascia,3,fam.ZIPCODE) ZIPCODE_RES_ATTUALE,
         decode(ana.fascia,3,fam.provincia_contea) PROVINCIA_CONTEA_RES_ATTUALE,
	 decode(ana.fascia,3,fam.presso) PRESSO_RES_ATTUALE,
	 decode(ana.fascia,3,lpad(e.cod_consolato,5,'0')||lpad(e.tipo_consolato,2,'0')) UFFICIO_CONSOLARE_RES_ATTUALE,
 	 mov.COGNOME_NOME_CN cognome_nome_coniuge,
 	 mov.MATRICOLA_CN matricola_coniuge,
	 TO_DATE(mov.DATA_MAT,'J') DATA_MATRIMONIO,
	 TO_CHAR(TO_DATE(mov.DATA_MAT,'J'),'DD/MM/YYYY') DATA_MATRIMONIO_EDIT,
	 TO_DATE(mov.DATA_VED,'J') DATA_VEDOVANZA,
	 TO_CHAR(TO_DATE(mov.DATA_VED,'J'),'DD/MM/YYYY') DATA_VEDOVANZA_EDIT,
	 TO_DATE(mov.DATA_DIV,'J') DATA_DIVORZIO,
	 TO_CHAR(TO_DATE(mov.DATA_DIV,'J'),'DD/MM/YYYY') DATA_DIVORZIO_EDIT,
   	 mov.ANNO_CENS anno_censimento,
	 mov.SEZIONE_CENS sezione_censimento,
	 mov.FOGLIO_CENS foglio_censimento,
	 mov.COD_EDIFICIO_CENS cod_edificio_censimento,
 	 ana.COD_FISCALE CODICE_FISCALE,
	 ana.CF_CALCOLATO FLAG_CF_CALCOLATO,
-- stato_ele
       	 ele.stato stato_ele,
-- stato_scrutatore_albo_S
         scr_s.stato stato_scrutatore_albo_s,
-- stato_scrutatore_albgo_V
	     scr_v.stato stato_scrutatore_albo_v,
-- stato_scrutatore_albo_r
         scr_r.stato stato_scrutatore_albo_r,
-- stato_giudice_albo_a
	     gpo_a.stato stato_giudice_albo_a,
-- stato_giudice_albo_p
     	 gpo_p.stato stato_giudice_albo_p,
-- stato_presidente_seggio
	     pse.stato stato_presidente_seggio,
	 TO_DATE(mov.DATA_REG,'J') DATA_REGISTRAZIONE,
	 TO_CHAR(TO_DATE(mov.DATA_REG,'J'),'DD/MM/YYYY') DATA_REGISTRAZIONE_EDIT,
	 mov.TERMINALISTA,
	 a_utenti.nominativo NOME_TERMINALISTA,
	 to_char(null) des_unita_territoriale_1,
	 to_char(null) codice_suddivisione_1,
	 to_char(null) des_suddivisione_1,
	 to_char(null) des_unita_territoriale_2,
	 to_char(null) codice_suddivisione_2,
	 to_char(null) des_suddivisione_2,
	 to_char(null) des_unita_territoriale_3,
	 to_char(null) codice_suddivisione_3,
	 to_char(null) des_suddivisione_3,
	 to_char(null) des_unita_territoriale_4,
	 to_char(null) codice_suddivisione_4,
	 to_char(null) des_suddivisione_4,
	 to_char(null) des_unita_territoriale_5,
	 to_char(null) codice_suddivisione_5,
	 to_char(null) des_suddivisione_5,
	 to_char(null) des_unita_territoriale_6,
	 to_char(null) codice_suddivisione_6,
	 to_char(null) des_suddivisione_6,
	 to_char(null) des_unita_territoriale_7,
	 to_char(null) codice_suddivisione_7,
	 to_char(null) des_suddivisione_7,
	 to_char(null) des_unita_territoriale_8,
	 to_char(null) codice_suddivisione_8,
	 to_char(null) des_suddivisione_8,
	 to_char(null) des_unita_territoriale_9,
	 to_char(null) codice_suddivisione_9,
	 to_char(null) des_suddivisione_9,
	 to_char(null) des_unita_territoriale_10,
	 to_char(null) codice_suddivisione_10,
	 to_char(null) des_suddivisione_10,
	 to_char(null) des_unita_territoriale_CAP,
	 to_char(null) codice_suddivisione_CAP,
	 to_char(null) des_suddivisione_CAP,
       mov.anno_progr, mov.numero_progr,
       decode(mov.cod_eve,52,2,1) sequenza,
-- RECAPITO_CELLULARE
         f_recapito_individuo(ana.matricola,'S') recapito_cellulare,
-- RECAPITO_TELEFONO_FISSO
         f_recapito_individuo(ana.matricola,'f') recapito_telefono_fisso,
-- RECAPITO_EMAIL
         f_recapito_individuo(ana.matricola,'E') recapito_email,
-- DOMICILIO_DIGITALE
         f_domicilio_digitale(ana.matricola) domicilio_digitale
  from a_utenti,
	arccom a, arccom b, arccom c, arccom d,
	arccom e, arccom f,
	arccom m, arccom m_p, arccom n, arccom n_p,
 	anadev dev, anadrp drp, anadrp drp_p,
	anadsc dsc, anadsc dsc_p, anadci dci, anadts dts, anadpr dpr,
	eleasc scr_v, eleasc scr_s, eleasc scr_r,
    eleagp gpo_a, eleagp gpo_p, eleaps pse,
    eleana ele,
	anafam fam_4, anafam fam, anaana ana, anamov mov
 where a_utenti.utente		(+)	= mov.terminalista
   and a.cod_provincia		(+)	= mov.cod_pro_eve
   and a.cod_comune		(+)	= mov.cod_com_eve
   and b.cod_provincia		(+)	= ana.cod_pro_nas
   and b.cod_comune		(+)	= ana.cod_com_nas
   and c.cod_provincia		(+)	= ana.cod_pro_atto_nas
   and c.cod_comune		(+)	= ana.cod_com_atto_nas
   and d.cod_provincia		(+)	= mov.cod_pro_iscr_aire
   and d.cod_comune		(+)	= mov.cod_com_iscr_aire
   and e.cod_provincia		(+)	= fam.cod_pro_aire
   and e.cod_comune		(+)	= fam.cod_com_aire
   and f.cod_provincia		(+)	= fam.cod_pro_aire
   and f.cod_comune		(+)	= 0
   and m.cod_provincia		(+) 	= mov.cod_pro_aire
   and m.cod_comune		(+)	= mov.cod_com_aire
   and m_p.cod_provincia	(+) 	= mov.cod_pro_aire_prec
   and m_p.cod_comune		(+)	= mov.cod_com_aire_prec
   and n.cod_provincia		(+) 	= mov.cod_pro_aire
   and n.cod_comune		(+)	= 0
   and n_p.cod_provincia	(+) 	= mov.cod_pro_aire_prec
   and n_p.cod_comune		(+)	= 0
   and drp.cod_rp		(+)	= mov.rapporto_par
   and drp.sesso		(+)	= mov.sesso
   and drp_p.cod_rp		(+)	= mov.rapporto_par_prec
   and drp_p.sesso		(+)	= mov.sesso_prec
   and dsc.cod_sc		(+)	= mov.stato_civile
   and dsc.sesso		(+)	= mov.sesso
   and dsc_p.cod_sc		(+)	= mov.stato_civile_prec
   and dsc_p.sesso		(+)	= mov.sesso_prec
   and dci.cod_ci		(+)	= mov.nazionalita
   and dpr.cod_pr		(+)	= mov.cod_prof
   and dpr.sesso		(+)	= mov.sesso
   and dts.cod_ts		(+)	= mov.titolo_studio
--
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
--
   and fam_4.fascia		(+)	= 4
   and fam_4.cod_fam		(+)	= decode(mov.cod_mov,1,mov.cod_fam_prec,mov.cod_fam)
   and fam.fascia		(+)	= 3
   and fam.cod_fam		(+)	= decode(mov.cod_mov,1,mov.cod_fam_prec,mov.cod_fam)
   and dev.cod_ev			= mov.cod_eve
   and ana.matricola			= mov.matricola
   and mov.cod_mov = 98 and mov.cod_eve = 99
   and (nvl(mov.cognome_nome_prec,' ') != nvl(mov.cognome_nome,' ')
        or nvl(mov.sesso_prec,' ') 	 != nvl(mov.sesso,' ')
       )
/
comment on table ANAVMO is 'Statistiche Anagrafe - Movimenti (view)'
/
