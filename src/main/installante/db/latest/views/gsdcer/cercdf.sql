--liquibase formatted sql
--changeset amonopoli:202410091525_2 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW CERCDF
	(MATRICOLA, COD_CDF, SEQUENZA, STATO_CDF, 
         IL_LA_SIGNOR_A_1, COGNOME_NOME_1, COGNOME_1, NOME_1, SESSO_1, SESSO_1_MF, NAT_OA_1, 
	 DATA_NASCITA_1, COMUNE_NASCITA_1, ATTO_NASCITA_1, COMUNE_ATTO_NASCITA_1, 
	 CODICE_FISCALE_1, CITTADINANZA_1,
         IL_LA_SIGNOR_A_2, COGNOME_NOME_2, COGNOME_2, NOME_2, SESSO_2, SESSO_2_MF, NAT_OA_2, 
	 DATA_NASCITA_2, COMUNE_NASCITA_2, ATTO_NASCITA_2, COMUNE_ATTO_NASCITA_2,
	 CODICE_FISCALE_2, CITTADINANZA_2,
	 INDIRIZZO, INDIRIZZO_INT, RESIDENZA, 
	 DATA_INIZIO_CDF, COMUNE_INIZIO_CDF, PRATICA_INIZIO_CDF,
	 DATA_FINE_CDF, COMUNE_FINE_CDF, PRATICA_FINE_CDF, 
	 CONTRATTO_CONVIVENZA,
	 COMUNE_DATA, COMUNE, DATA, PROVINCIA, FASCIA, COD_FAM, COD_RP, SEQUENZA_PAR
)
AS
SELECT ana.matricola,
-- cod_cdf
       cdf.cod_cdf,
-- sequenza
       cdf.sequenza,
-- stato_cdf
       cdf.stato_cdf,
-- il_la_signor_a_1
       DECODE (ana.sesso, 'M', 'il Signor', 'la Signora'),
-- cognome_nome_1
       REPLACE (ana.cognome_nome, '/', '   '),
-- cognome_1
       SUBSTR (ana.cognome_nome, 1, INSTR (ana.cognome_nome, '/') - 1),
-- nome_1
       SUBSTR (ana.cognome_nome, INSTR (ana.cognome_nome, '/') + 1),
-- sesso_1
       DECODE (ana.sesso, 'M', 'maschile', 'femminile'),
-- sesso_1_MF
       ana.sesso,
-- nat_oa_1
       DECODE (ana.sesso, 'M', 'nato', 'nata'),
-- data_nascita_1
       DECODE (ana.anno_nas, 
         'S', '00/00/' || TO_CHAR (TO_DATE (ana.data_nas, 'j'), 'yyyy'),
              TO_CHAR (TO_DATE (ana.data_nas, 'j'), 'dd/mm/yyyy')),
-- comune_nascita_1
       RTRIM ( nvl(com_nas.descrizione_al1,com_nas.descrizione)||' '|| 
               f_provincia_stato_CER (com_nas.cod_provincia, com_nas.cod_comune, com_nas.sigla_provincia, 'S', 'S', ana.data_nas)),
-- atto_nascita_1
       'atto N. '||ana.atto_nas|| 
       DECODE (ana.parte_nas,1,' p. I',2,' p. II')|| 
       DECODE (ana.serie_nas, '', '', ' s. ' || ana.serie_nas)|| 
       DECODE (ana.ufficio_nas,0, '','', '',' uff. ' || ana.ufficio_nas)||
       DECODE (ana.anno_atto_nas, '', '', ' / ' || ana.anno_atto_nas),
-- comune_atto_nascita_1
       DECODE (nvl(com_atto_nas.descrizione_al1,com_atto_nas.descrizione), '', '',
               '- '||nvl(com_atto_nas.descrizione_al1,com_atto_nas.descrizione)||
               f_provincia_stato_CER (com_atto_nas.cod_provincia, com_atto_nas.cod_comune, com_atto_nas.sigla_provincia, 'S', 'S', ana.data_nas)),
-- codice_fiscale_1
       ana.cod_fiscale,
-- nazionalita_1
       dci.descrizione,
-- il_la_signor_a_1
       DECODE (ana_cv.sesso, 'M', 'il Signor', 'la Signora'),
-- cognome_nome_2
       replace(nvl(ana_cv.cognome_nome,cdf.cognome_nome_cv), '/', '   '),
-- cognome_2
       SUBSTR(nvl(ana_cv.cognome_nome,cdf.cognome_nome_cv), 1, INSTR(nvl(ana_cv.cognome_nome,cdf.cognome_nome_cv),'/') - 1),
-- nome_2
       SUBSTR(nvl(ana_cv.cognome_nome,cdf.cognome_nome_cv), INSTR(nvl(ana_cv.cognome_nome,cdf.cognome_nome_cv),'/') + 1),
-- sesso_2
       DECODE (ana_cv.sesso, 'M', 'maschile', 'femminile'),
-- sesso_2_MF
       ana_cv.sesso,
-- nat_oa_2
       DECODE (ana_cv.sesso, 'M', 'nato', 'nata'),
-- data_nascita_2
       DECODE(ana_cv.anno_nas, 'S', 
         '00/00/'||TO_CHAR (TO_DATE (ana_cv.data_nas, 'j'), 'yyyy'),
         TO_CHAR (TO_DATE (ana_cv.data_nas, 'j'), 'dd/mm/yyyy')),
-- comune_nascita_2
       RTRIM (nvl(com_nas_cv.descrizione_al1,com_nas_cv.descrizione)||' '|| 
              f_provincia_stato_CER (com_nas_cv.cod_provincia,com_nas_cv.cod_comune,com_nas_cv.sigla_provincia,'S','S',ana_cv.data_nas)),
-- atto_nascita_2
       DECODE(ana_cv.matricola, '', '',
              DECODE(ana_cv.atto_nas, '', '','atto N. '||ana_cv.atto_nas)||
              DECODE(ana_cv.parte_nas, 1, ' p. I', 2, ' p. II')|| 
              DECODE(ana_cv.serie_nas, '', '',' s. '||ana_cv.serie_nas)|| 
              DECODE(ana_cv.ufficio_nas, 0, '', '', '', ' uff. '||ana_cv.ufficio_nas)||
              DECODE(ana_cv.anno_atto_nas, '', '', ' / '||ana_cv.anno_atto_nas)),
-- comune_atto_nascita_2
       DECODE (nvl(com_atto_nas_cv.descrizione_al1,com_atto_nas_cv.descrizione), '', '',
               '- '||nvl(com_atto_nas_cv.descrizione_al1,com_atto_nas_cv.descrizione)||
               f_provincia_stato_CER (com_atto_nas_cv.cod_provincia, com_atto_nas_cv.cod_comune, com_atto_nas_cv.sigla_provincia, 'S', 'S', ana_cv.data_nas)),
-- codice_fiscale_2
       ana_cv.cod_fiscale,
-- nazionalita_2
       dci_cv.descrizione,
-- indirizzo
       DECODE (nvl(cdf.stato_cdf,'D'), 
         'A', vie.denom_uff||fam.civico_esterno||DECODE (UPPER (inp.valore), 'N', '', fam.civico_interno),
         'D', nvl(f_CDF_indirizzo_pratica(ana.matricola,inp.valore),  vie.denom_uff||fam.civico_esterno||DECODE (UPPER (inp.valore), 'N', '', fam.civico_interno))),
-- indirizzo_int
       DECODE (nvl(cdf.stato_cdf,'D'),
         'A', vie.denom_uff||fam.civico_esterno||fam.civico_interno,
         'D', nvl(f_CDF_indirizzo_pratica(ana.matricola,inp.valore), vie.denom_uff||fam.civico_esterno||fam.civico_interno)),
-- residenza
       nvl(m.descrizione_al1,m.descrizione),
-- data_inizio_cdf
       TO_CHAR(TO_DATE(cdf.data_inizio, 'j'), 'dd/mm/yyyy'),
-- comune_inizio_cdf
       DECODE(com_ini_cdf.descrizione, '', '',
         nvl(com_ini_cdf.descrizione_al1,com_ini_cdf.descrizione)||' ('||com_ini_cdf.sigla_provincia||')'),
-- pratica_inizio_cdf
       cdf.pratica_inizio||decode(cdf.anno_pratica_inizio,'','','/'||cdf.anno_pratica_inizio),
-- data_fine_Cdf
       TO_CHAR(TO_DATE(cdf.data_fine, 'j'), 'dd/mm/yyyy'),
-- comune_fine_cdf
       DECODE(com_fin_cdf.descrizione, '', '',
         nvl(com_fin_cdf.descrizione_al1,com_fin_cdf.descrizione)||' ('||com_fin_cdf.sigla_provincia||')'),
-- pratica_fine_cdf
       cdf.pratica_fine||decode(cdf.anno_pratica_fine,'','','/'||cdf.anno_pratica_fine),
-- contratto_convivenza
       decode(f_flag_CDF(ana.matricola), '', '', f_CDF_contratto_convivenza(ana.matricola)),
-- comune_data
       nvl(m.descrizione_al1,m.descrizione) || ' ' || TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- comune
       nvl(m.descrizione_al1,m.descrizione),
-- data
       TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- provincia
       pro.descrizione,
-- fascia
       ana.fascia,
-- cod_fam
       ana.cod_fam,
-- cod_rp
       ana.rapporto_par,
-- sequenza_par
       ana.sequenza_par
  FROM arcinp inp,
       arcpro pro,
       arccom m,
       arccom com_nas,
       arccom com_atto_nas,
       arccom com_ini_cdf,
       arccom com_fin_cdf,
       arccom com_nas_cv,
       arccom com_atto_nas_cv,
       arcvie vie,
       anadci dci_cv,
       anadci dci,
       anafam fam,
       anaana ana_cv,
       anaana ana,
       anacdf cdf
 WHERE inp.parametro                  (+) = 'INTERNO'
   AND pro.cod_provincia                  = m.cod_provincia
   AND (m.cod_provincia, m.cod_comune)    = (SELECT pro_cliente, com_cliente FROM menuditta)
--
   AND com_ini_cdf.cod_comune         (+) = cdf.cod_com_inizio
   AND com_ini_cdf.cod_provincia      (+) = cdf.cod_pro_inizio
   AND com_fin_cdf.cod_comune         (+) = cdf.cod_com_fine
   AND com_fin_cdf.cod_provincia      (+) = cdf.cod_pro_fine
   AND com_atto_nas_cv.cod_comune     (+) = ana_cv.cod_com_atto_nas
   AND com_atto_nas_cv.cod_provincia  (+) = ana_cv.cod_pro_atto_nas
   AND com_nas_cv.cod_comune          (+) = ana_cv.cod_com_nas
   AND com_nas_cv.cod_provincia       (+) = ana_cv.cod_pro_nas
   AND dci_cv.cod_ci                  (+) = ana_cv.nazionalita
   AND ana_cv.matricola               (+) = cdf.matricola_cv
--           
   AND vie.cod_via                    (+) = fam.cod_via
   AND fam.cod_fam                    (+) = ana.cod_fam
   AND fam.fascia                     (+) = ana.fascia
   AND com_nas.cod_comune                 = ana.cod_com_nas
   AND com_nas.cod_provincia              = ana.cod_pro_nas
   AND com_atto_nas.cod_comune        (+) = ana.cod_com_atto_nas
   AND com_atto_nas.cod_provincia     (+) = ana.cod_pro_atto_nas
   AND dci.cod_ci                     (+) = ana.nazionalita
   AND ana.matricola                      = cdf.matricola
   AND cdf.sequenza                       = 1
   AND nvl(cdf.stato_cdf,'D')             in ('D','I','F')
/
comment on table cercdf is 'Certifcazione - Dati Convivenza di Fatto (view)'
/