--liquibase formatted sql
--changeset amonopoli:202411191555_4 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW ANAVBI_STORICO
(DATA_RIF, DATA_RIF_EDIT,
 MATRICOLA, FASCIA, STATO,
 FLAG_RESIDENTE, FLAG_AIRE, FLAG_SENZA_FISSA_DIMORA, FLAG_ISCRITTO_PRELIMINARE,
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
--
 INDIRIZZO, INDIRIZZO_INT, CAP_COMUNE_RESIDENZA, COMUNE_RESIDENZA,
 COD_PROVINCIA_RESIDENZA, COD_COMUNE_RESIDENZA, NAZIONE_RESIDENZA, GRUPPO_NAZIONE_RESIDENZA,
 CODICE_VIA, DENOMINAZIONE_VIA, DENOMINAZIONE_VIA_ORDINAMENTO,
 NUMERO_CIVICO, SUFFISSO, INTERNO, SUB_INTERNO, SCALA, PIANO,
 CODICE_ECOGRAFICO, CODICE_FAMIGLIA, CONVIVENZA,
 RAPPORTO_PAR, DES_RAPPORTO_PAR, SEQUENZA_PAR,
--
 NAZIONALITA, NAZIONALITA_ISTAT, NAZIONALITA_CEE, DES_NAZIONALITA, GRUPPO_NAZIONALITA, DATA_NAZIONALITA,
--
 CODICE_FISCALE, FLAG_CF_CALCOLATO,
--
 DATA_ISCRIZIONE,
--
 DATA_ULTIMA_VARIAZIONE,
--
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
--
 RECAPITO_CELLULARE, RECAPITO_TELEFONO_FISSO, RECAPITO_EMAIL, DOMICILIO_DIGITALE
)
AS
select to_date(ana_v.data,'j') d_data,
       to_char(to_date(ana_v.data,'j'),'dd/mm/yyyy') data_edit,
-- matricola
	ana_v.matricola,
        ana_v.fascia_al,
        ana_v.stato_al,
-- flag_residente
	decode(ana_v.fascia_al,1,'SI','NO') flag_residente,
-- flag_aire
	decode(ana_v.fascia_al,3,'SI','NO') flag_aire,
-- flag_senza_fissa_dimora
	decode(f_senza_fissa_dimora(rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                    rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                    rtrim(substr(ana_v.indirizzo_al,51,10)),
                                    rtrim(ltrim(substr(ana_v.indirizzo_al,61,2),'0'))),'S','SI','NO') senza_fissa_dimora,
-- flag_iscritto_preliminare
	decode(ana_v.stato_al,17,'SI','NO') flag_iscritto_preliminare,
-- cognome_nome
        ana_v.cognome_nome,
-- cognome
	f_cognome(ana_v.cognome_nome) cognome,
-- nome
	f_nome(ana_v.cognome_nome) nome,
-- sesso
       	ana_v.sesso,
-- data_nascita
	to_date(ana_v.data_nas,'j') DATA_NASCITA,
-- data_nascita_edit
       	decode(ana_v.anno_nas,'S',
	 '00/00/'||to_char(to_date(ana_v.data_nas,'j'),'yyyy'),
         to_char(to_date(ana_v.data_nas,'j'),'dd/mm/yyyy'))	DATA_NASCITA_EDIT,
-- anno_nascita
	to_char(to_date(ana_v.data_nas,'j'),'yyyy') ANNO_NASCITA,
-- cod_provincia_nascita
	lpad(ana_v.COD_PRO_NAS,3,'0') cod_provincia_nascita,
-- cod_comune_nascita
	lpad(ana_v.COD_COM_NAS,3,'0') cod_comune_nascita,
-- comune_nascita
       	a.descrizione||' ('||a.sigla_provincia||')' comune_nascita,
-- cod_regione_nascita
	substr(f_regione(ana_v.cod_pro_nas),1,2) COD_REGIONE_NASCITA,
-- regione_nascita
	substr(f_regione(ana_v.cod_pro_nas),3) REGIONE_NASCITA,
-- nazione_nascita
	f_nazione(ana_v.cod_pro_nas,ana_v.cod_com_nas) NAZIONE_NASCITA,
-- gruppo_nazione_nascita
	f_gruppo_nazioni(ana_v.cod_pro_nas) GRUPPO_NAZIONE_NASCITA,
-- cod_provincia_atto_nascita
	lpad(ana_v.COD_PRO_ATTO_NAS,3,'0') COD_PROVINCIA_ATTO_NASCITA,
-- cod_comune_atto_nascita
	lpad(ana_v.COD_COM_ATTO_NAS,3,'0') COD_COMUNE_ATTO_NASCITA,
-- comune_atto_nascita
        h.descrizione||' ('||h.sigla_provincia||')' comune_atto_nascita,
-- cod_regione_atto_nascita
	substr(f_regione(ana_v.cod_pro_atto_nas),1,2) COD_REGIONE_ATTO_NASCITA,
-- regione_atto_nascita
	substr(f_regione(ana_v.cod_pro_atto_nas),3) REGIONE_ATTO_NASCITA,
-- atto_nascita_edit
	decode(ana_v.atto_nas_digitale,'',
          ana_v.atto_nas||
	    DECODE(ANA_v.PARTE_NAS,'','',' P.'||decode(ana_v.PARTE_NAS,1,'I',2,'II'))||
	    decode(ana_v.serie_nas,'','',' S.'||ana_v.serie_nas)||
	    decode(ana_v.ufficio_nas,'','',' U.'||ana_v.ufficio_nas)||
	    decode(ana_v.anno_atto_nas,'','','/'||ana_v.anno_atto_nas),
          ana_v.atto_nas_digitale) ATTO_NASCITA_EDIT,
-- paternita
       	ana_v.paternita,
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
       	ana_v.maternita,
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
-- des_stato_civile
-- indirizzo
       	decode(ana_v.fascia_al,
          1, rtrim(substr(ana_v.indirizzo_al,5,40))||
               ', '||rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0'))||
               decode(rtrim(substr(ana_v.indirizzo_al,51,10)),'','','/'||rtrim(substr(ana_v.indirizzo_al,51,10)))||
               decode(nvl(upper(ainp.valore),'N'),'N','',
                 decode(rtrim(substr(ana_v.indirizzo_al,63,3)),'','',' S.'||rtrim(substr(ana_v.indirizzo_al,63,3)))||
                 decode(rtrim(substr(ana_v.indirizzo_al,66,3)),'','',' P.'||rtrim(substr(ana_v.indirizzo_al,66,3)))||
                 decode(rtrim(ltrim(substr(ana_v.indirizzo_al,61,2),'0')),'','',' int.'||rtrim(ltrim(substr(ana_v.indirizzo_al,61,2),'0')))||
                 decode(rtrim(substr(ana_v.indirizzo_al,69,3)),'','','/'||rtrim(substr(ana_v.indirizzo_al,69,3)))
               ),
	  3, rtrim(substr(ana_v.indirizzo_aire_al,1,60))
        )	INDIRIZZO,
-- indirizzo_int
       	decode(ana_v.fascia_al,
          1,rtrim(substr(ana_v.indirizzo_al,5,40))||
               ', '||rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0'))||
               decode(rtrim(substr(ana_v.indirizzo_al,51,10)),'','','/'||rtrim(substr(ana_v.indirizzo_al,51,10)))||
               decode(rtrim(substr(ana_v.indirizzo_al,63,3)),'','',' S.'||rtrim(substr(ana_v.indirizzo_al,63,3)))||
               decode(rtrim(substr(ana_v.indirizzo_al,66,3)),'','',' P.'||rtrim(substr(ana_v.indirizzo_al,66,3)))||
               decode(rtrim(ltrim(substr(ana_v.indirizzo_al,61,2),'0')),'','',' int.'||rtrim(ltrim(substr(ana_v.indirizzo_al,61,2),'0')))||
               decode(rtrim(substr(ana_v.indirizzo_al,69,3)),'','','/'||rtrim(substr(ana_v.indirizzo_al,69,3))),
	  3, rtrim(substr(ana_v.indirizzo_aire_al,1,60))) INDIRIZZO_INT,
-- cap_comune_residenza
       decode(ana_v.fascia_al,
         1, f_cap(rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
               rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
               rtrim(substr(ana_v.indirizzo_al,51,10))
             ),
         3, nvl(rtrim(substr(ana_v.indirizzo_aire_al,187,10)),decode(n.cap,99999,to_char(null),to_char(n.cap)))) cap_comune_residenza,
-- comune_residenza
       decode(ana_v.fascia_al,
         1, m.descrizione||' ('||m.sigla_provincia||')',
         3, n.descrizione||' ('||n.sigla_provincia||')') comune_residenza,
-- cod_provincia_residenza
       decode(ana_v.fascia_al,
         1, lpad(m.cod_provincia,3,'0'),
         3, lpad(n.cod_provincia,3,'0')) cod_provincia_residenza,
-- cod_comune_residenza
       decode(ana_v.fascia_al,
         1, lpad(m.cod_comune,3,'0'),
         3, lpad(n.cod_comune,3,'0')) cod_comune_residenza,
-- nazione_residenza
       decode(ana_v.fascia_al,
         1, f_nazione(m.cod_provincia,m.cod_comune),
         3, f_nazione(n.cod_provincia,n.cod_comune)) nazione_residenza,
-- gruppo_nazione_residenza
	f_gruppo_nazioni(decode(ana_v.fascia_al, 1, m.cod_provincia, 3, n.cod_provincia)) GRUPPO_NAZIONE_residenza,
-- codice_via
	rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')) codice_via,
-- denominazione_via
	rtrim(substr(ana_v.indirizzo_al,5,40)) denominazione_via,
-- denominazione_via_ordinamento
       	vie.denom_ord denominazione_via_ordinamento,
-- numero_civico
      	rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')) NUMERO_CIVICO,
-- suffisso
	rtrim(substr(ana_v.indirizzo_al,51,10)),
-- interno
	rtrim(ltrim(substr(ana_v.indirizzo_al,61,2),'0')),
-- sub_interno
	rtrim(substr(ana_v.indirizzo_al,69,3)),
-- scala
	rtrim(substr(ana_v.indirizzo_al,63,3)),
-- piano
	rtrim(substr(ana_v.indirizzo_al,66,3)),
-- codice ecografico
	to_char(null) codice_ecografico,
-- codice_famiglia
	decode(ana_v.fascia_al,
          1, rtrim(ltrim(substr(ana_v.famiglia_al,1,7),'0')),
          3, rtrim(ltrim(substr(ana_v.famiglia_aire_al,1,7),'0'))) CODICE_FAMIGLIA,
-- intestatario
-- convivenza
	fam.convivenza,
-- rapporto_par
	decode(ana_v.fascia_al,
          1, rtrim(ltrim(substr(ana_v.famiglia_al,8,2),'0')),
          3, rtrim(ltrim(substr(ana_v.famiglia_aire_al,8,2),'0'))) rapporto_par,
-- des_rapporto_par
	drp.descrizione des_rapporto_par,
-- sequenza_par
	drp.sequenza sequenza_par,
-- nazionalita
	ana_v.nazionalita,
-- nazionalita_istat
	dci.ist_ci nazionalita_istat,
-- nazionalita_cee
	decode(dci.cee,'S','SI','NO') nazionalita_cee,
-- des_nazionalita
	dci.descrizione des_nazionalita,
-- gruppo_nazionalita
	f_gruppo_nazionalita(ana_v.nazionalita) GRUPPO_NAZIONALITA,
-- data_nazionalita
        to_date(ana_v.data_inizio_naz,'j') data_nazionalita,
-- codice_fiscale
       	ana_v.cod_fiscale codice_fiscale,
-- codice_fiscale_calcolato
       	ana_v.cf_calcolato flag_cf_calcolato,
-- data_iscrizione
	to_date(ana_v.data_eve_al,'j') data_iscrizione,
-- data_ultima_variazione
       	to_date(ana_v.data_reg,'j') data_ultima_variazione,
-- des_unita_territoriale...
	 rtrim(substr(f_unita_territoriale(1, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_1,
	 substr(f_unita_territoriale(1, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_1,
	 rtrim(substr(f_unita_territoriale(1, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_1,
	 rtrim(substr(f_unita_territoriale(2, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_2,
	 substr(f_unita_territoriale(2, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_2,
	 rtrim(substr(f_unita_territoriale(2, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_2,
	 rtrim(substr(f_unita_territoriale(3, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_3,
	 substr(f_unita_territoriale(3, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_3,
	 rtrim(substr(f_unita_territoriale(3, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_3,
	 rtrim(substr(f_unita_territoriale(4, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_4,
	 substr(f_unita_territoriale(4, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_4,
	 rtrim(substr(f_unita_territoriale(4, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_4,
	 rtrim(substr(f_unita_territoriale(5, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_5,
	 substr(f_unita_territoriale(5, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_5,
	 rtrim(substr(f_unita_territoriale(5, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_5,
	 rtrim(substr(f_unita_territoriale(6, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_6,
	 substr(f_unita_territoriale(6, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_6,
	 rtrim(substr(f_unita_territoriale(6, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_6,
	 rtrim(substr(f_unita_territoriale(7, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_7,
	 substr(f_unita_territoriale(7, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_7,
	 rtrim(substr(f_unita_territoriale(7, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_7,
	 rtrim(substr(f_unita_territoriale(8, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_8,
	 substr(f_unita_territoriale(8, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_8,
	 rtrim(substr(f_unita_territoriale(8, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_8,
	 rtrim(substr(f_unita_territoriale(9, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_9,
	 substr(f_unita_territoriale(9, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_9,
	 rtrim(substr(f_unita_territoriale(9, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_9,
	 rtrim(substr(f_unita_territoriale(10, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_10,
	 substr(f_unita_territoriale(10, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_10,
	 rtrim(substr(f_unita_territoriale(10, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_10,
	 rtrim(substr(f_unita_territoriale(99, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),1,20)) des_unita_territoriale_CAP,
	 substr(f_unita_territoriale(99, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),21,4) codice_suddivisione_CAP,
	 rtrim(substr(f_unita_territoriale(99, rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0')),
                                        rtrim(ltrim(substr(ana_v.indirizzo_al,45,6),'0')),
                                        rtrim(substr(ana_v.indirizzo_al,51,10))),25,30)) des_suddivisione_CAP,
-- RECAPITO_CELLULARE
         f_recapito_individuo(ana_v.matricola,'S') recapito_cellulare,
-- RECAPITO_TELEFONO_FISSO
         f_recapito_individuo(ana_v.matricola,'f') recapito_telefono_fisso,
-- RECAPITO_EMAIL
         f_recapito_individuo(ana_v.matricola,'E') recapito_email,
-- DOMICILIO_DIGITALE
         f_domicilio_digitale(ana_v.matricola) domicilio_digitale
  from (select sta.data
             , f_ult_eve_al(ana.matricola, sta.data, 'FASCIA') fascia_al
             , f_ult_eve_al(ana.matricola, sta.data, 'STATO') stato_al
             , f_ult_eve_al(ana.matricola, sta.data, 'DATA_EVE') data_eve_al
             , f_indirizzo_al_j(ana.matricola, sta.data) indirizzo_al
             , f_indirizzo_aire_al_j(ana.matricola, sta.data) indirizzo_aire_al
             , f_famiglia_al_j(ana.matricola, sta.data) famiglia_al
             , f_famiglia_aire_al_j(ana.matricola, sta.data) famiglia_aire_al
             , ana.*
          from (select distinct sta.data from anasta sta) sta
             , anaana ana
        ) ana_v,
        arcinp ainp, arcinp binp,
       	arccom a,arccom e,
	arccom h,arccom m,
	arccom n,arccom s,
	arcvie vie,
	anadci dci, anadrp drp, anadsc dsc,
        anaana ana_cn, anaana ana_pd, anaana ana_md,
	anaeve eve, anafam fam
 where ainp.parametro	     		= 'INTERNO_S'
   and binp.parametro	     		= 'INTERNO_E'
   and (m.cod_provincia,m.cod_comune) = (select pro_cliente,com_cliente
					   from menuditta)
   and n.cod_provincia 		(+)   	= rtrim(ltrim(substr(ana_v.indirizzo_aire_al,61,3),'0'))
   and n.cod_comune    		(+)   	= rtrim(ltrim(substr(ana_v.indirizzo_aire_al,64,3),'0'))
--
   and dsc.cod_sc            		= ana_v.stato_civile
   and dsc.sesso             		= ana_v.sesso
--
   and a.cod_comune          		= ana_v.cod_com_nas
   and a.cod_provincia       		= ana_v.cod_pro_nas
   and h.cod_comune		(+)     = ana_v.cod_com_atto_nas
   and h.cod_provincia		(+)    	= ana_v.cod_pro_atto_nas
   and s.cod_comune		(+)     = 0
   and s.cod_provincia		(+)    	= eve.cod_pro_eve
   and e.cod_comune		(+)     = eve.cod_com_eve
   and e.cod_provincia		(+)    	= eve.cod_pro_eve
--
   and ana_cn.matricola		(+)	= ana_v.matricola_cn
--
   and ana_pd.matricola		(+)	= ana_v.matricola_pd
   and ana_md.matricola		(+)	= ana_v.matricola_md
   and eve.data_eve 		(+)     = ana_v.data_eve_al
   and eve.cod_eve		(+)	= ana_v.stato_al
   and eve.cod_mov		(+)	= ana_v.fascia_al
   and eve.matricola		(+)	= ana_v.matricola
--
   and dci.cod_ci      		(+)   	= ana_v.nazionalita
--
   and drp.sesso       		(+)   	= ana_v.sesso
   and drp.cod_rp      		(+)   	= decode(ana_v.fascia_al,
                                            1, rtrim(substr(ana_v.famiglia_al,8,2)),
                                            3, rtrim(substr(ana_v.famiglia_aire_al,8,2)))
   and vie.cod_via     		(+)   	= rtrim(ltrim(substr(ana_v.indirizzo_al,1,4),'0'))
   and fam.cod_fam     		(+)   	= rtrim(ltrim(substr(ana_v.famiglia_al,1,7),'0'))
   and fam.fascia      		(+)   	= 1
   and ana_v.fascia_al 	      		in (1,3)
--
-- f_famiglia_al_j
--   nvl(lpad(w_cod_fam,7,'0'),'       ')||			-- substr(...,1,7)
--   nvl(rpad(w_rapporto_par,2,' '),'  ')||			-- substr(...,8,2)
--   nvl(lpad(w_ist_rp,2,' '),'  ')||				-- substr(...,10,2)
--   nvl(to_char(w_data_inizio_rp),'       ')||			-- substr(...,12,7)
--   nvl(to_char(w_data_inizio_fam),'       ')||		-- substr(...,19,7)
--   nvl(to_char(w_tipo_fam),' ');				-- substr(...,26,1)
--
-- f_famiglia_aire_al_j
--   nvl(lpad(w_cod_fam,7,'0'),'       ')||			-- substr(...,1,7)
--   nvl(rpad(w_rapporto_par,2,' '),'  ')||			-- substr(...,8,2)
--   nvl(lpad(w_ist_rp,2,' '),'  ')||				-- substr(...,10,2)
--   nvl(to_char(w_data_inizio),'       ');			-- substr(...,12,7)
--
-- f_indirizzo_al_j
--   nvl(lpad(w_cod_via,4,'0'),'    ')||			-- substr(...,1,4)
--   nvl(rpad(w_denom_uff,40,' '),rpad(' ',40,' '))||		-- substr(...,5,40)
--   nvl(lpad(w_num_civ,6,'0'),'      ')||			-- substr(...,45,6)
--   nvl(rpad(w_suffisso,10,' '),'          ')||		-- substr(...,51,10)
--   nvl(lpad(w_interno,2,'0'),'  ')||				-- substr(...,61,2)
--   nvl(rpad(w_scala,3,' '),'   ')||				-- substr(...,63,3)
--   nvl(rpad(w_piano,3,' '),'   ')||				-- substr(...,66,3)
--   nvl(rpad(w_sub_interno,3,' '),'   ')||			-- substr(...,69,3)
--   nvl(lpad(w_data_inizio,7,'0'),'       ');			-- substr(...,72,7)
--
-- f_indirizzo_aire_al_j
--   nvl(rpad(w_via_aire,60,' '),rpad(' ',60,' '))||		-- substr(...,1,60)
--   nvl(lpad(w_cod_pro_aire,3,'0'),'   ')||			-- substr(...,61,3)
--   nvl(lpad(w_cod_com_aire,3,'0'),'   ')||			-- substr(...,64,3)
--   nvl(rpad(w_provincia_contea,60,' '),rpad(' ',60,' '))||	-- substr(...,67,60)
--   nvl(rpad(w_presso,60,' '),rpad(' ',60,' '))||		-- substr(...,127,60)
--   nvl(rpad(w_zipcode,10,' '),rpad(' ',10,' '))||		-- substr(...,187,10)
--   nvl(lpad(w_data_inizio,7,'0'),'       ');			-- substr(...,197,7)
/
comment on table ANAVBI_STORICO is 'Statistiche Anagrafe - Individui Residenti e AIRE "alla data" (view)'
/
