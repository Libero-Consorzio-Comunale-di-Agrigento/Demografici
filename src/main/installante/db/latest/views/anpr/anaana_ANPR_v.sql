--liquibase formatted sql
--changeset snocca:202211141525 runOnChange:true stripComments:false
create or replace view anaana_ANPR_v
     ( ID_OPERAZIONE
     , MATRICOLA, COGNOME_NOME, FASCIA, STATO, DATA_ULT_EVE, SOSPENSIONE
     , COD_FAM, RAPPORTO_PAR, SEQUENZA_PAR
     , DATA_INIZIO_FAM, D_DATA_INIZIO_FAM, DATA_INIZIO_RES, D_DATA_INIZIO_RES
     , STATO_CIVILE, SESSO, NAZIONALITA, DATA_INIZIO_NAZ, D_DATA_INIZIO_NAZ
     , PATERNITA, MATRICOLA_PD, MATERNITA, MATRICOLA_MD 
     , TITOLO_STUDIO, COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO
     , COD_PRO_NAS, COD_COM_NAS, DATA_NAS, ANNO_NAS
     , COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS
     , ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS
     , COD_PRO_ATTO_NAS_TR, COD_COM_ATTO_NAS_TR
     , ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR
     , COD_FISCALE, CF_CALCOLATO, DATA_REG
     , COGNOME_NOME_CN, MATRICOLA_CN
     , COD_PRO_MAT, COD_COM_MAT, DATA_MAT, ANNO_MAT
     , COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT
     , ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT
     , COD_PRO_ATTO_MAT_TR, COD_COM_ATTO_MAT_TR
     , ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR
     , COD_PRO_VED, COD_COM_VED, DATA_VED
     , COD_PRO_ATTO_VED, COD_COM_ATTO_VED
     , ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED
     , COD_PRO_DIV, COD_COM_DIV, DATA_DIV, DATA_DIV_GIU, DATA_DIV_ANN
     , COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV
     , ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV
     , COD_PRO_MOR, COD_COM_MOR, DATA_MOR               
     , COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR
     , ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR
     , COD_PRO_ATTO_MOR_TR, COD_COM_ATTO_MOR_TR
     , ANNO_ATTO_MOR_TR, ATTO_MOR_TR, PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR         
--
-- 23/06/2022 (AM): aggiunti per gestione su ZK
--
     , COGNOME, NOME
     , D_DATA_NAS, DES_COM_NAS, SIGLA_PRO_NAS, DES_COM_ATTO_NAS, SIGLA_PRO_ATTO_NAS     
     , DES_STATO_CIVILE, DES_NAZIONALITA, DES_COD_PROF, DES_RAPPORTO_PAR
     , COD_PRO_RES, COD_COM_RES, DES_COM_RES, SIGLA_PRO_RES, INDIRIZZO_RES, CAP_RES
     , PROVINCIA_CONTEA_AIR, PRESSO_AIR, COD_CONSOLATO_AIR, SEDE_CONSOLATO_AIR
     , FLAG_SENZA_FISSA_DIMORA
     , DES_STATO_ANA          
--
     , TIPO_DI, NUMERO_DI, DATA_EMISSIONE_DI, D_DATA_EMISSIONE_DI, DATA_SCADENZA_DI, D_DATA_SCADENZA_DI
     , COD_PRO_ENTE_DI, COD_COM_ENTE_DI, DES_COM_ENTE_DI, SIGLA_PRO_ENTE_DI, FLAG_VAL_ESPATRIO_DI
--
     , TIPO_DS, NUMERO_DS, DATA_EMISSIONE_DS, D_DATA_EMISSIONE_DS, DATA_SCADENZA_DS, D_DATA_SCADENZA_DS
     , COD_PRO_ENTE_DS, COD_COM_ENTE_DS, DES_COM_ENTE_DS, SIGLA_PRO_ENTE_DS, FLAG_SCADENZA_ILLIMITATA_DS
--
     , COGNOME_CN, NOME_CN, SESSO_CN
     , D_DATA_NAS_CN, COD_PRO_NAS_CN, COD_COM_NAS_CN, DES_COM_NAS_CN, SIGLA_PRO_NAS_CN       
     , DES_STATO_CIVILE_CN, NAZIONALITA_CN, DES_NAZIONALITA_CN     
     , COD_PRO_RES_CN, COD_COM_RES_CN, DES_COM_RES_CN, SIGLA_PRO_RES_CN
     , DES_STATO_ANA_CN
     , COGNOME_PD, NOME_PD
     , COGNOME_MD, NOME_MD                 
     , ID_SOGGETTO_ANPR, ID_FAMIGLIA_ANPR, TIPO_SCHEDA_ANPR
     , ID
--
-- 26/09/2023 (AM): aggiunti per gestione su ANSC
--
     , ATTO_NAS_DIGITALE, ATTO_NAS_TR_DIGITALE
     , ATTO_MAT_DIGITALE, ATTO_MAT_TR_DIGITALE
     , ATTO_DIV_DIGITALE, ATTO_VED_DIGITALE
     , ATTO_MOR_DIGITALE, ATTO_MOR_TR_DIGITALE
     , ID_UNICO_ANPR
--
-- 31/01/2025 (AM)
--
     , COGNOME_RIC, NOME_RIC, COGNOME_NOME_RIC
--
-- 21/02/2025 (AM): nuovi campi per visualizzazione individuo
--
     , D_DATA_MAT, DES_COM_MAT, SIGLA_PRO_MAT, DES_COM_ATTO_MAT, SIGLA_PRO_ATTO_MAT
     , D_DATA_VED, DES_COM_VED, SIGLA_PRO_VED, DES_COM_ATTO_VED, SIGLA_PRO_ATTO_VED
     , D_DATA_DIV, DES_COM_DIV, SIGLA_PRO_DIV, DES_COM_ATTO_DIV, SIGLA_PRO_ATTO_DIV
     , D_DATA_MOR, DES_COM_MOR, SIGLA_PRO_MOR, DES_COM_ATTO_MOR, SIGLA_PRO_ATTO_MOR
     , NOTE
     , MATRICOLA_AIRE
     , ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS, COD_EDIFICIO_CENS, QUESTIONARIO_CENS
     , VAL_ESPATRIO, DATA_VAL_ESPATRIO
     , ID_DOCUMENTO_GDM
     )
AS
select rec.ID_OPERAZIONE
-- MATRICOLA
     , rec.w_matricola
-- COGNOME_NOME
     , rec.COGNOME||'/'||rec.NOME
-- FASCIA
     , rec.w_fascia
-- STATO
     , rec.w_stato
-- DATA_ULT_EVE
     , f_ADS_data(nvl(rec.CAN_DATADECORRENZA,rec.ISC_DATAISCRIZIONE))
-- SOSPENSIONE
     , f_ADS_sospensione(rec.SOGGETTOCERTIFICABILE)
-- COD_FAM
     , rec.id_operazione
-- RAPPORTO_PAR
     , f_ADS_rapporto_par(rec.FAM_CODICELEGAME,rec.SESSO)
-- SEQUENZA_PAR
     , rec.FAM_CODICELEGAME
-- DATA_INIZIO_FAM
     , f_ADS_data(rec.FAM_DATADECORRENZA)
-- D_DATA_INIZIO_FAM
     , to_date(f_ADS_data(rec.FAM_DATADECORRENZA),'j')
-- DATA_INIZIO_RES
     , f_ADS_data(rec.RES_DATADECORRENZARESIDENZA)
-- D_DATA_INIZIO_RES
     , to_date(f_ADS_data(rec.RES_DATADECORRENZARESIDENZA),'j')
-- STATO_CIVILE
     , rec.w_stato_civile
-- SESSO
     , rec.SESSO
-- NAZIONALITA
     , f_ADS_nazionalita(rec.CIT_CODICESTATO)
-- DATA_INIZIO_NAZ
     , f_ADS_data(rec.CIT_DATAVALIDITA)
-- D_DATA_INIZIO_NAZ
     , to_date(f_ADS_data(rec.CIT_DATAVALIDITA),'j')
-- PATERNITA
     , decode(rec.COGNOME_PD,'','',rec.COGNOME_PD||'/')||rec.NOME_PD
-- MATRICOLA_PD
     , rec.w_matricola_PD
-- MATERNITA
     , decode(rec.COGNOME_MD,'','',rec.COGNOME_MD||'/')||rec.NOME_MD
-- MATRICOLA_MD
     , rec.w_matricola_MD
-- TITOLO_STUDIO
     , f_ADS_titolo_studio(rec.TITOLOSTUDIO)
-- COD_PROF
     , to_number(null)
-- ATTIVITA_PROF
     , to_number(null)
-- POSIZIONE_PROF
     , f_ADS_posizione_prof(rec.POSIZIONEPROFESSIONALE)
-- PENSIONATO
     , to_number(null)
-- COD_PRO_NAS
     , substr(lpad(rec.w_codice_comune_NAS,6,'0'),1,3)
-- COD_COM_NAS
     , substr(lpad(rec.w_codice_comune_NAS,6,'0'),4,3)
-- DATA_NAS
     , f_ADS_data(rec.DATANASCITA)
-- ANNO_NAS
     , decode(rec.SENZAGIORNOMESE,'','','S')
-- COD_PRO_ATTO_NAS
     , decode(rec.ATTNAS_TRASCRITTO,'S','',substr(lpad(rec.w_codice_comune_ATTNAS,6,'0'),1,3))
-- COD_COM_ATTO_NAS
     , decode(rec.ATTNAS_TRASCRITTO,'S','',substr(lpad(rec.w_codice_comune_ATTNAS,6,'0'),4,3))
-- ANNO_ATTO_NAS
     , decode(rec.ATTNAS_TRASCRITTO,'S','',decode(rec.ATTNAS_IDANSC,'',rec.ATTNAS_ANNO))
-- ATTO_NAS
     , decode(rec.ATTNAS_TRASCRITTO,'S','',decode(rec.ATTNAS_IDANSC,'',substr(ltrim(rec.ATTNAS_NUMEROATTO,'0'),1,4)))
-- PARTE_NAS
     , decode(rec.ATTNAS_TRASCRITTO,'S','',decode(rec.ATTNAS_IDANSC,'',rec.w_parte_nas))
-- SERIE_NAS
     , substr(decode(rec.ATTNAS_TRASCRITTO,'S','',decode(rec.ATTNAS_IDANSC,'',rec.ATTNAS_SERIE)),1,1)
-- UFFICIO_NAS
     , decode(rec.ATTNAS_TRASCRITTO,'S','',decode(rec.ATTNAS_IDANSC,'',rec.w_ufficio_nas))
-- COD_PRO_ATTO_NAS_TR
     , decode(rec.ATTNAS_TRASCRITTO,'S',substr(lpad(rec.w_codice_comune_ATTNAS,6,'0'),1,3))
-- COD_COM_ATTO_NAS_TR
     , decode(rec.ATTNAS_TRASCRITTO,'S',substr(lpad(rec.w_codice_comune_ATTNAS,6,'0'),4,3))
-- ANNO_ATTO_NAS_TR
     , decode(rec.ATTNAS_TRASCRITTO,'S',decode(rec.ATTNAS_IDANSC,'',rec.ATTNAS_ANNO))
-- ATTO_NAS_TR
     , decode(rec.ATTNAS_TRASCRITTO,'S',decode(rec.ATTNAS_IDANSC,'',substr(ltrim(rec.ATTNAS_NUMEROATTO,'0'),1,4)))
-- PARTE_NAS_TR
     , decode(rec.ATTNAS_TRASCRITTO,'S',decode(rec.ATTNAS_IDANSC,'',rec.w_parte_nas))
-- SERIE_NAS_TR
     , substr(decode(rec.ATTNAS_TRASCRITTO,'S',decode(rec.ATTNAS_IDANSC,'',rec.ATTNAS_SERIE)),1,1)
-- UFFICIO_NAS_TR
     , decode(rec.ATTNAS_TRASCRITTO,'S',decode(rec.ATTNAS_IDANSC,'',rec.w_ufficio_nas))
-- COD_FISCALE
     , rec.CODFISCALE
-- CF_CALCOLATO
     , decode(rec.CODFISCALE,'','',
                     decode(rec.VALIDITACF,'1',to_char(null),'S'))
-- DATA_REG
     , to_char(sysdate,'j')
-- COGNOME_NOME_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            decode(rec.COGNOME_CN,'','',rec.COGNOME_CN||'/')||rec.NOME_CN
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            decode(rec.COGNOME_UC,'','',rec.COGNOME_UC||'/')||rec.NOME_UC
       end
-- MATRICOLA_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            rec.w_matricola_CN
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            rec.w_matricola_UC
       end
-- COD_PRO_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then substr(lpad(rec.w_codice_comune_MAT,6,'0'),1,3)
                       when rec.w_stato_civile in ('UC','VU','GU')           then substr(lpad(rec.w_codice_comune_UCI,6,'0'),1,3)
       end
-- COD_COM_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then substr(lpad(rec.w_codice_comune_MAT,6,'0'),4,3)
                       when rec.w_stato_civile in ('UC','VU','GU')           then substr(lpad(rec.w_codice_comune_UCI,6,'0'),4,3)
       end
-- DATA_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then f_ADS_data(rec.MAT_DATAEVENTO)
                       when rec.w_stato_civile in ('UC','VU','GU')           then f_ADS_data(rec.UCI_DATAEVENTO)
       end
-- ANNO_MAT
     , to_char(null)
-- COD_PRO_ATTO_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S','',substr(lpad(rec.w_codice_comune_ATTMAT,6,'0'),1,3))
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTMAT_TRASCRITTO,'S','',substr(lpad(rec.w_codice_comune_ATTUCI,6,'0'),1,3))
       end
-- COD_COM_ATTO_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S','',substr(lpad(rec.w_codice_comune_ATTMAT,6,'0'),4,3))
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTMAT_TRASCRITTO,'S','',substr(lpad(rec.w_codice_comune_ATTUCI,6,'0'),4,3))
       end
-- ANNO_ATTO_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S','',rec.ATTMAT_ANNO)
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTUCI_TRASCRITTO,'S','',rec.ATTUCI_ANNO)
       end
-- ATTO_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S','',substr(ltrim(rec.ATTMAT_NUMEROATTO,'0'),1,4))
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTUCI_TRASCRITTO,'S','',substr(ltrim(rec.ATTUCI_NUMEROATTO,'0'),1,4))
       end
-- PARTE_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S','',rec.w_parte_mat)
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTUCI_TRASCRITTO,'S','',rec.w_parte_uci)
       end
-- SERIE_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then substr(decode(rec.ATTMAT_TRASCRITTO,'S','',rec.ATTMAT_SERIE),1,1)
                       when rec.w_stato_civile in ('UC','VU','GU')           then substr(decode(rec.ATTUCI_TRASCRITTO,'S','',rec.ATTUCI_SERIE),1,1)
       end
-- UFFICIO_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S','',rec.w_ufficio_mat)
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTUCI_TRASCRITTO,'S','',rec.w_ufficio_uci)
       end
-- COD_PRO_ATTO_MAT_TR
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S',substr(lpad(rec.w_codice_comune_ATTMAT,6,'0'),1,3))
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTMAT_TRASCRITTO,'S',substr(lpad(rec.w_codice_comune_ATTUCI,6,'0'),1,3))
       end
-- COD_COM_ATTO_MAT_TR
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S',substr(lpad(rec.w_codice_comune_ATTMAT,6,'0'),4,3))
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTMAT_TRASCRITTO,'S',substr(lpad(rec.w_codice_comune_ATTUCI,6,'0'),4,3))
       end
-- ANNO_ATTO_MAT_TR
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S',rec.ATTMAT_ANNO)
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTUCI_TRASCRITTO,'S',rec.ATTUCI_ANNO)
       end
-- ATTO_MAT_TR
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S',substr(ltrim(rec.ATTMAT_NUMEROATTO,'0'),1,4))
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTUCI_TRASCRITTO,'S',substr(ltrim(rec.ATTUCI_NUMEROATTO,'0'),1,4))
       end
-- PARTE_MAT_TR
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S',rec.w_parte_mat)
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTUCI_TRASCRITTO,'S',rec.w_parte_uci)
       end
-- SERIE_MAT_TR
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then substr(decode(rec.ATTMAT_TRASCRITTO,'S',rec.ATTMAT_SERIE),1,1)
                       when rec.w_stato_civile in ('UC','VU','GU')           then substr(decode(rec.ATTUCI_TRASCRITTO,'S',rec.ATTUCI_SERIE),1,1)
       end
-- UFFICIO_MAT_TR
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then decode(rec.ATTMAT_TRASCRITTO,'S','',rec.w_ufficio_mat)
                       when rec.w_stato_civile in ('UC','VU','GU')           then decode(rec.ATTUCI_TRASCRITTO,'S','',rec.w_ufficio_uci)
       end
-- COD_PRO_VED
     , case
                       when w_stato_civile in ('VE','NC') then substr(lpad(rec.w_codice_comune_VED,6,'0'),1,3)
                       when w_stato_civile in ('VU')      then substr(lpad(rec.w_codice_comune_SCI,6,'0'),1,3)
       end
-- COD_COM_VED
     , case
                       when w_stato_civile in ('VE','NC') then substr(lpad(rec.w_codice_comune_VED,6,'0'),4,3)
                       when w_stato_civile in ('VU')      then substr(lpad(rec.w_codice_comune_SCI,6,'0'),4,3)
       end
-- DATA_VED
     , case
                       when w_stato_civile in ('VE','NC') then f_ADS_data(rec.VED_DATAEVENTO)
                       when w_stato_civile in ('VU')      then f_ADS_data(rec.SCI_DATAEVENTO)
       end
-- COD_PRO_ATTO_VED
     , case
                       when w_stato_civile in ('VE','NC') then substr(lpad(rec.w_codice_comune_ATTVED,6,'0'),1,3)
                       when w_stato_civile in ('VU')      then substr(lpad(rec.w_codice_comune_ATTSCI,6,'0'),1,3)
       end
-- COD_COM_ATTO_VED
     , case
                       when w_stato_civile in ('VE','NC') then substr(lpad(rec.w_codice_comune_ATTVED,6,'0'),4,3)
                       when w_stato_civile in ('VU')      then substr(lpad(rec.w_codice_comune_ATTSCI,6,'0'),4,3)
       end
-- ANNO_ATTO_VED
     , case
                       when w_stato_civile in ('VE','NC') then decode(rec.ATTVED_TRASCRITTO,'S','',rec.ATTVED_ANNO)
                       when w_stato_civile in ('VU')      then decode(rec.ATTSCI_TRASCRITTO,'S','',rec.ATTSCI_ANNO)
       end
-- ATTO_VED
     , case
                       when w_stato_civile in ('VE','NC') then decode(rec.ATTVED_TRASCRITTO,'S','',substr(ltrim(rec.ATTVED_NUMEROATTO,'0'),1,4))
                       when w_stato_civile in ('VU')      then decode(rec.ATTSCI_TRASCRITTO,'S','',substr(ltrim(rec.ATTSCI_NUMEROATTO,'0'),1,4))
       end
-- PARTE_VED
     , case
                       when w_stato_civile in ('VE','NC') then decode(rec.ATTVED_TRASCRITTO,'S','',rec.w_parte_ved)
                       when w_stato_civile in ('VU')      then decode(rec.ATTSCI_TRASCRITTO,'S','',rec.w_parte_sci)
       end
-- SERIE_VED
     , case
                       when w_stato_civile in ('VE','NC') then substr(decode(rec.ATTVED_TRASCRITTO,'S','',rec.ATTVED_SERIE),1,1)
                       when w_stato_civile in ('VU')      then substr(decode(rec.ATTSCI_TRASCRITTO,'S','',rec.ATTSCI_SERIE),1,1)
       end
-- UFFICIO_VED
     , case
                       when w_stato_civile in ('VE','NC') then decode(rec.ATTVED_TRASCRITTO,'S','',rec.w_ufficio_ved)
                       when w_stato_civile in ('VU')      then decode(rec.ATTSCI_TRASCRITTO,'S','',rec.w_ufficio_sci)
       end
-- COD_PRO_DIV
     , to_number(null)
-- COD_COM_DIV
     , to_number(null)
-- DATA_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then f_ADS_data(rec.DIV_DATAVALIDITASENTENZA)
                       when w_stato_civile in ('GU')           then f_ADS_data(rec.SCI_DATAEVENTO)
       end
-- DATA_DIV_GIU
     , to_number(null)
-- DATA_DIV_ANN
     , to_number(null)
-- COD_PRO_ATTO_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then substr(lpad(rec.w_codice_comune_ATTDIV,6,'0'),1,3)
                       when w_stato_civile in ('GU')           then substr(lpad(rec.w_codice_comune_ATTSCI,6,'0'),1,3)
       end
-- COD_COM_ATTO_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then substr(lpad(rec.w_codice_comune_ATTDIV,6,'0'),4,3)
                       when w_stato_civile in ('GU')           then substr(lpad(rec.w_codice_comune_ATTSCI,6,'0'),4,3)
       end
-- ANNO_ATTO_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then decode(rec.ATTDIV_TRASCRITTO,'S','',rec.ATTDIV_ANNO)
                       when w_stato_civile in ('GU')           then decode(rec.ATTSCI_TRASCRITTO,'S','',rec.ATTSCI_ANNO)
       end
-- ATTO_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then decode(rec.ATTDIV_TRASCRITTO,'S','',substr(ltrim(rec.ATTDIV_NUMEROATTO,'0'),1,4))
                       when w_stato_civile in ('GU')           then decode(rec.ATTSCI_TRASCRITTO,'S','',substr(ltrim(rec.ATTSCI_NUMEROATTO,'0'),1,4))
       end
-- PARTE_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then decode(rec.ATTDIV_TRASCRITTO,'S','',rec.w_parte_div)
                       when w_stato_civile in ('GU')           then decode(rec.ATTSCI_TRASCRITTO,'S','',rec.w_parte_sci)
       end
-- SERIE_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then substr(decode(rec.ATTDIV_TRASCRITTO,'S','',rec.ATTDIV_SERIE),1,1)
                       when w_stato_civile in ('GU')           then substr(decode(rec.ATTSCI_TRASCRITTO,'S','',rec.ATTSCI_SERIE),1,1)
       end
-- UFFICIO_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then decode(rec.ATTDIV_TRASCRITTO,'S','',rec.w_ufficio_div)
                       when w_stato_civile in ('GU')           then decode(rec.ATTSCI_TRASCRITTO,'S','',rec.w_ufficio_sci)
       end
-- COD_PRO_MOR
     , substr(lpad(rec.w_codice_comune_MOR,6,'0'),1,3)
-- COD_COM_MOR
     , substr(lpad(rec.w_codice_comune_MOR,6,'0'),4,3)
-- DATA_MOR
     , f_ADS_data(rec.MOR_DATAEVENTO)
-- COD_PRO_ATTO_MOR
     , decode(rec.ATTMOR_TRASCRITTO,'S','',substr(lpad(rec.w_codice_comune_ATTMOR,6,'0'),1,3))
-- COD_COM_ATTO_MOR
     , decode(rec.ATTMOR_TRASCRITTO,'S','',substr(lpad(rec.w_codice_comune_ATTMOR,6,'0'),4,3))
-- ANNO_ATTO_MOR
     , decode(rec.ATTMOR_TRASCRITTO,'S','',rec.ATTMOR_ANNO)
-- ATTO_MOR
     , decode(rec.ATTMOR_TRASCRITTO,'S','',substr(ltrim(rec.ATTMOR_NUMEROATTO,'0'),1,4))
-- PARTE_MOR
     , decode(rec.ATTMOR_TRASCRITTO,'S','',rec.w_parte_mor)
-- SERIE_MOR
     , substr(decode(rec.ATTMOR_TRASCRITTO,'S','',rec.ATTMOR_SERIE),1,1)
-- UFFICIO_MOR
     , decode(rec.ATTMOR_TRASCRITTO,'S','',rec.w_ufficio_mor)
-- COD_PRO_ATTO_MOR_TR
     , decode(rec.ATTMOR_TRASCRITTO,'S',substr(lpad(rec.w_codice_comune_ATTMOR,6,'0'),1,3))
-- COD_COM_ATTO_MOR_TR
     , decode(rec.ATTMOR_TRASCRITTO,'S',substr(lpad(rec.w_codice_comune_ATTMOR,6,'0'),4,3))
-- ANNO_ATTO_MOR_TR
     , decode(rec.ATTMOR_TRASCRITTO,'S',rec.ATTMOR_ANNO)
-- ATTO_MOR_TR
     , decode(rec.ATTMOR_TRASCRITTO,'S',substr(ltrim(rec.ATTMOR_NUMEROATTO,'0'),1,4))
-- PARTE_MOR_TR
     , decode(rec.ATTMOR_TRASCRITTO,'S',rec.w_parte_mor)
-- SERIE_MOR_TR
     , substr(decode(rec.ATTMOR_TRASCRITTO,'S',rec.ATTMOR_SERIE),1,1)
-- UFFICIO_MOR_TR
     , decode(rec.ATTMOR_TRASCRITTO,'S',rec.w_ufficio_mor)
--
-- 23/06/2022 (AM): aggiunti per gestione su ZK
--
-- COGNOME
     , rec.cognome
-- NOME
     , rec.nome
-- D_DATA_NAS
     , to_date(f_ADS_data(rec.DATANASCITA),'j')
-- DES_COM_NAS
     , nvl(rec.NAS_DESCRIZIONELOCALITA,rec.NAS_NOMECOMUNE)
-- SIGLA_PRO_NAS
     , nvl(rec.NAS_DESCRIZIONESTATO,rec.NAS_SIGLAPROVINCIAISTAT)
-- DES_COM_ATTO_NAS
     , rec.ATTNAS_NOMECOMUNE
-- SIGLA_PRO_ATTO_NAS
     , rec.ATTNAS_SIGLAPROVINCIAISTAT
-- DES_STATO_CIVILE
     , f_get_descrizione_DSC(rec.w_stato_civile,rec.sesso,'','','')
-- DES_NAZIONALITA
     , f_get_descrizione_DCI(f_ADS_nazionalita(rec.CIT_CODICESTATO),'')
-- DES_COD_PROF
     , to_char(null)
-- DES_RAPPORTO_PAR
     , f_get_descrizione_DRP(f_ADS_rapporto_par(rec.FAM_CODICELEGAME,rec.SESSO), rec.SESSO)
-- COD_PRO_RES
     , substr(lpad(rec.w_codice_comune_RES,6,'0'),1,3)
-- COD_COM_RES
     , substr(lpad(rec.w_codice_comune_RES,6,'0'),4,3)
-- DES_COM_RES
     , nvl(rec.RES_DESCRIZIONELOCALITA,rec.RES_NOMECOMUNE)
-- SIGLA_PRO_RES
     , nvl(rec.RES_DESCRIZIONESTATO,rec.RES_SIGLAPROVINCIAISTAT)
-- INDIRIZZO_RES
     , nvl(
         decode(rec.RES_TOPONIMOESTERO,'','',rec.RES_TOPONIMOESTERO||
           decode(rec.RES_NUMERO,'','',', '||rec.RES_NUMERO)||
           decode(rec.RES_LETTERA,'','','/'||rec.RES_LETTERA)
         ),
         rec.RES_SPECIE||' '||rec.RES_DENOMINAZIONETOPONIMO||
           decode(rec.RES_NUMERO,'','',', '||rec.RES_NUMERO)||
           decode(rec.RES_LETTERA,'','','/'||rec.RES_LETTERA)
       )
-- CAP_RES
     , nvl(rec.RES_CAPESTERO,rec.RES_CAP)
-- PROVINCIA_CONTEA_AIR
     , rec.RES_PROVINCIACONTEA
-- PRESSO_AIR
     , rec.RES_PRESSO
-- COD_CONSOLATO_AIR
     , rec.RES_CODICECONSOLATO
-- SEDE_CONSOLATO_AIR
     , rec.RES_DESCRIZIONECONSOLATO
-- FLAG_SENZA_FISSA_DIMORA
     , decode(rec.SENZAFISSADIMORA,'S','S')
-- DES_STATO_ANA
     , decode(rec.w_fascia,
         1, f_get_campo_DCE('RES','I',rec.w_fascia,rec.w_stato,'','DESCRIZIONE_'||rec.sesso),
         2, f_get_campo_DCE('RES','C',rec.w_fascia,rec.w_stato,'','DESCRIZIONE_'||rec.sesso),
         3, f_get_campo_DCE('AIR','I',rec.w_fascia,rec.w_stato,'','DESCRIZIONE_'||rec.sesso),
         4, f_get_campo_DCE('AIR','C',rec.w_fascia,rec.w_stato,'','DESCRIZIONE_'||rec.sesso),
         5, f_get_campo_DCE('RES','',rec.w_fascia,rec.w_stato,'','DESCRIZIONE_'||rec.sesso),
         6, f_get_campo_DCE('NRE','',rec.w_fascia,rec.w_stato,'','DESCRIZIONE_'||rec.sesso))
--
-- TIPO_DI
     , decode(rec.DI_CARTACEAELETTRONICA,'0','CI','1','CE')
-- NUMERO_DI
     , rec.DI_NUMERO
-- DATA_EMISSIONE_DI
     , f_ADS_data(rec.DI_DATARILASCIO)
-- D_DATA_EMISSIONE_DI
     , to_date(f_ADS_data(rec.DI_DATARILASCIO),'j')
-- DATA_SCADENZA_DI
     , f_ADS_data(rec.DI_DATASCADENZA)
-- D_DATA_SCADENZA_DI
     , to_date(f_ADS_data(rec.DI_DATASCADENZA),'j')
-- COD_PRO_ENTE_DI
     , substr(rec.DI_CODICEISTAT,1,3)
-- COD_COM_ENTE_DI
     , substr(rec.DI_CODICEISTAT,4,3)
-- DES_COM_ENTE_DI
     , rec.DI_NOMECOMUNE
-- SIGLA_PRO_ENTE_DI
     , rec.DI_SIGLAPROVINCIAISTAT
-- FLAG_VAL_ESPATRIO_DI
     , decode(rec.DI_INTERDIZIONEESPATRIO,'N','','S') flag_val_espatrio_DI
--
-- TIPO_DS
     , f_ADS_tipo_soggiorno(rec.DS_TIPOSOGGIORNO)
-- NUMERO_DS
     , rec.DS_NUMERO
-- DATA_EMISSIONE_DS
     , f_ADS_data(rec.DS_DATARILASCIO)
-- D_DATA_EMISSIONE_DS
     , to_date(f_ADS_data(rec.DS_DATARILASCIO),'j')
-- DATA_SCADENZA_DS
     , f_ADS_data(rec.DS_DATASCADENZA)
-- D_DATA_SCADENZA_DS
     , to_date(f_ADS_data(rec.DS_DATASCADENZA),'j')
-- COD_PRO_ENTE_DS
     , substr(rec.DS_CODICEISTAT,1,3)
-- COD_COM_ENTE_DS
     , substr(rec.DS_CODICEISTAT,4,3)
-- DES_COM_ENTE_DS
     , rec.DS_NOMECOMUNE
-- SIGLA_PRO_ENTE_DS
     , rec.DS_SIGLAPROVINCIAISTAT
-- FLAG_SCADENZA_ILLIMITATA_DS
     , to_char(null)
--
-- COGNOME_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            rec.COGNOME_CN
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            rec.COGNOME_UC
       end
-- NOME_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            rec.NOME_CN
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            rec.NOME_UC
       end
-- SESSO_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            rec.SESSO_CN
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            rec.SESSO_UC
       end
-- D_DATA_NAS_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            to_date(f_ADS_data(rec.DATANASCITA_CN),'j')
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            to_date(f_ADS_data(rec.DATANASCITA_UC),'j')
       end
-- COD_PRO_NAS_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            substr(lpad(rec.w_codice_comune_NAS_cn,6,'0'),1,3)
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            substr(lpad(rec.w_codice_comune_NAS_uc,6,'0'),1,3)
       end
-- COD_COM_NAS_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            substr(lpad(rec.w_codice_comune_NAS_cn,6,'0'),4,3)
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            substr(lpad(rec.w_codice_comune_NAS_uc,6,'0'),4,3)
       end
-- DES_COM_NAS_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            nvl(rec.NAS_DESCRIZIONELOCALITA_CN,rec.NAS_NOMECOMUNE_CN)
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            nvl(rec.NAS_DESCRIZIONELOCALITA_UC,rec.NAS_NOMECOMUNE_UC)
       end
-- SIGLA_PRO_NAS_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            nvl(rec.NAS_DESCRIZIONESTATO_CN,rec.NAS_SIGLAPROVINCIAISTAT_CN)
                       when rec.w_stato_civile in ('UC','VU','GU') then
                            nvl(rec.NAS_DESCRIZIONESTATO_UC,rec.NAS_SIGLAPROVINCIAISTAT_UC)
       end
-- DES_STATO_CIVILE_CN
     , to_char(null)
-- NAZIONALITA_CN
     , f_ADS_nazionalita(rec.CIT_CODICESTATO_CN_2)
-- DES_NAZIONALITA_CN
     , f_get_descrizione_DCI(f_ADS_nazionalita(rec.CIT_CODICESTATO_CN_2),'')
-- COD_PRO_RES_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            substr(lpad(rec.w_codice_comune_RES_cn,6,'0'),1,3)
       end
-- COD_COM_RES_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            substr(lpad(rec.w_codice_comune_RES_cn,6,'0'),4,3)
       end
-- DES_COM_RES_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            nvl(rec.RES_DESCRIZIONELOCALITA_CN,rec.RES_NOMECOMUNE_CN)
       end
-- SIGLA_PRO_RES_CN
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then
                            nvl(rec.RES_DESCRIZIONESTATO_CN,rec.RES_SIGLAPROVINCIAISTAT_CN)
       end
-- DES_STATO_ANA_CN
     , to_char(null)
-- COGNOME_PD
     , rec.cognome_pd
-- NOME_PD
     , rec.nome_pd
-- COGNOME_MD
     , rec.cognome_md
-- NOME_MD
     , rec.nome_md
-- ID_SOGGETTO_ANPR
     , rec.idSoggettoANPR
-- ID_FAMIGLIA_ANPR
     , rec.FAM_idFamigliaANPR
-- TIPO_SCHEDA_ANPR
     , rec.FAM_tipoScheda
-- ID
     , rec.id_operazione||rec.idSoggettoANPR
-- ATTO_NAS_DIGITALE
     , decode(rec.ATTNAS_TRASCRITTO,'S','',rec.ATTNAS_IDANSC)
-- ATTO_NAS_TR_DIGITALE
     , decode(rec.ATTNAS_TRASCRITTO,'S',rec.ATTNAS_IDANSC)
-- ATTO_MAT_DIGITALE
     , decode(rec.ATTMAT_TRASCRITTO,'S','',rec.ATTMAT_IDANSC)
-- ATTO_MAT_TR_DIGITALE
     , decode(rec.ATTMAT_TRASCRITTO,'S',rec.ATTMAT_IDANSC)
-- ATTO_DIV_DIGITALE
     , decode(rec.ATTDIV_TRASCRITTO,'S','',rec.ATTDIV_IDANSC)
-- ATTO_VED_DIGITALE
     , decode(rec.ATTVED_TRASCRITTO,'S','',rec.ATTVED_IDANSC)
-- ATTO_MOR_DIGITALE
     , decode(rec.ATTMOR_TRASCRITTO,'S','',rec.ATTMOR_IDANSC)
-- ATTO_MOR_TR_DIGITALE
     , decode(rec.ATTMOR_TRASCRITTO,'S',rec.ATTMOR_IDANSC)
-- ID_UNICO_ANPR
     , f_ANPR_id_unico(rec.w_matricola,'') id_unico_anpr
-- COGNOME_RIC
     , upper(rec.cognome)
-- NOME_RIC
     , upper(rec.nome)
-- COGNOME_NOME_RIC
     , upper(rec.cognome)||'/'||upper(rec.nome)
-- D_DATA_MAT, DES_COM_MAT, SIGLA_PRO_MAT, DES_COM_ATTO_MAT, SIGLA_PRO_ATTO_MAT
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then to_date(f_ADS_data(rec.MAT_DATAEVENTO),'j')
                       when rec.w_stato_civile in ('UC','VU','GU')           then to_date(f_ADS_data(rec.UCI_DATAEVENTO),'j')
       end
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then nvl(rec.MAT_DESCRIZIONELOCALITA,rec.MAT_NOMECOMUNE)
                       when rec.w_stato_civile in ('UC','VU','GU')           then nvl(rec.UCI_DESCRIZIONELOCALITA,rec.UCI_NOMECOMUNE)
       end
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then nvl(rec.MAT_DESCRIZIONESTATO,rec.MAT_SIGLAPROVINCIAISTAT) 
                       when rec.w_stato_civile in ('UC','VU','GU')           then nvl(rec.UCI_DESCRIZIONESTATO,rec.UCI_SIGLAPROVINCIAISTAT) 
       end
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then rec.ATTMAT_NOMECOMUNE 
                       when rec.w_stato_civile in ('UC','VU','GU')           then rec.ATTUCI_NOMECOMUNE  
       end
     , case
                       when rec.w_stato_civile in ('CN','VE','DV','GC','NC') then rec.ATTMAT_SIGLAPROVINCIAISTAT 
                       when rec.w_stato_civile in ('UC','VU','GU')           then rec.ATTUCI_SIGLAPROVINCIAISTAT 
       end
-- D_DATA_VED, DES_COM_VED, SIGLA_PRO_VED, DES_COM_ATTO_VED, SIGLA_PRO_ATTO_VED
     , case
                       when w_stato_civile in ('VE','NC') then to_date(f_ADS_data(rec.VED_DATAEVENTO),'j')
                       when w_stato_civile in ('VU')      then to_date(f_ADS_data(rec.SCI_DATAEVENTO),'j')
       end
     , case
                       when w_stato_civile in ('VE','NC') then nvl(rec.VED_DESCRIZIONELOCALITA,rec.VED_NOMECOMUNE)
                       when w_stato_civile in ('VU')      then nvl(rec.SCI_DESCRIZIONELOCALITA,rec.SCI_NOMECOMUNE)
       end
     , case
                       when w_stato_civile in ('VE','NC') then nvl(rec.VED_DESCRIZIONESTATO,rec.VED_SIGLAPROVINCIAISTAT)
                       when w_stato_civile in ('VU')      then nvl(rec.SCI_DESCRIZIONESTATO,rec.SCI_SIGLAPROVINCIAISTAT)
       end
     , case
                       when w_stato_civile in ('VE','NC') then rec.ATTVED_NOMECOMUNE
                       when w_stato_civile in ('VU')      then rec.ATTSCI_NOMECOMUNE
       end
     , case
                       when w_stato_civile in ('VE','NC') then rec.ATTVED_SIGLAPROVINCIAISTAT
                       when w_stato_civile in ('VU')      then rec.ATTSCI_SIGLAPROVINCIAISTAT
       end
-- D_DATA_DIV, DES_COM_DIV, SIGLA_PRO_DIV, DES_COM_ATTO_DIV, SIGLA_PRO_ATTO_DIV
     , case
                       when w_stato_civile in ('DV','GC','NC') then to_date(f_ADS_data(rec.DIV_DATAVALIDITASENTENZA),'j')
                       when w_stato_civile in ('GU')           then to_date(f_ADS_data(rec.SCI_DATAEVENTO),'j')
       end
     , case
                       when w_stato_civile in ('DV','GC','NC') then rec.DIV_AUTORITASENTENZA
                       when w_stato_civile in ('GU')           then nvl(rec.SCI_DESCRIZIONELOCALITA,rec.SCI_NOMECOMUNE)
       end
     , case
                       when w_stato_civile in ('DV','GC','NC') then to_char(null)
                       when w_stato_civile in ('GU')           then nvl(rec.SCI_DESCRIZIONESTATO,rec.SCI_SIGLAPROVINCIAISTAT)
       end
     , case
                       when w_stato_civile in ('DV','GC','NC') then rec.ATTDIV_NOMECOMUNE
                       when w_stato_civile in ('GU')           then rec.ATTSCI_NOMECOMUNE
       end
     , case
                       when w_stato_civile in ('DV','GC','NC') then rec.ATTDIV_SIGLAPROVINCIAISTAT
                       when w_stato_civile in ('GU')           then rec.ATTSCI_SIGLAPROVINCIAISTAT
       end
-- D_DATA_MOR, DES_COM_MOR, SIGLA_PRO_MOR, DES_COM_ATTO_MOR, SIGLA_PRO_ATTO_MOR
     , to_date(f_ADS_data(rec.MOR_DATAEVENTO),'j')
     , nvl(rec.MOR_DESCRIZIONELOCALITA,rec.MOR_NOMECOMUNE)
     , nvl(rec.MOR_DESCRIZIONESTATO,rec.MOR_SIGLAPROVINCIAISTAT) 
     , rec.ATTMOR_NOMECOMUNE 
     , rec.ATTMOR_SIGLAPROVINCIAISTAT 
-- NOTE
     , to_char(null)
-- MATRICOLA_AIRE
     , to_char(null)
-- ANNO_CENS
     , rec.annoCensimento
-- SEZIONE_CENS
     , rec.sezioneCensimento
-- FOGLIO_CENS
     , rec.foglioCensimento
-- COD_EDIFICIO_CENS
     , to_char(null)
-- QUESTIONARIO_CENS
     , to_char(null)
-- VAL_ESPATRIO
     , to_char(null)
-- DATA_VAL_ESPATRIO
     , to_number(null)
-- ID_DOCUMENTO_GDM
     , to_number(null)
  from (select f_ADS_matricola(rec.idsoggettoanpr,rec.codfiscale,rec.cognome,rec.nome,rec.sesso,rec.datanascita) w_matricola
             , f_ADS_fascia(rec.SOGGETTOAIRE,rec.ISC_DATAISCRIZIONE,rec.CAN_DATADECORRENZA) w_fascia
             , decode(rec.MOR_DATAEVENTO,'','',50) w_stato
             , f_ADS_stato_civile(rec.STATOCIVILE,rec.SESSO,rec.SCI_MOTIVOSCIOGLIMENTO) w_stato_civile
             , f_ADS_codice_comune(rec.NAS_CODICEISTAT,rec.NAS_NOMECOMUNE,rec.NAS_SIGLAPROVINCIAISTAT,rec.NAS_CODICESTATO,rec.NAS_DESCRIZIONELOCALITA,rec.DATANASCITA) w_codice_comune_NAS
             , f_ADS_codice_comune(rec.ATTNAS_CODICEISTAT,rec.ATTNAS_NOMECOMUNE,rec.ATTNAS_SIGLAPROVINCIAISTAT,'','',nvl(rec.ATTNAS_DATAFORMAZIONEATTO,rec.DATANASCITA)) w_codice_comune_ATTNAS
             , f_ADS_codice_comune(rec.MAT_CODICEISTAT,rec.MAT_NOMECOMUNE,rec.MAT_SIGLAPROVINCIAISTAT,rec.MAT_CODICESTATO,rec.MAT_DESCRIZIONELOCALITA,rec.MAT_DATAEVENTO) w_codice_comune_MAT
             , f_ADS_codice_comune(rec.ATTMAT_CODICEISTAT,rec.ATTMAT_NOMECOMUNE,rec.ATTMAT_SIGLAPROVINCIAISTAT,'','',nvl(rec.ATTMAT_DATAFORMAZIONEATTO,rec.MAT_DATAEVENTO)) w_codice_comune_ATTMAT
             , f_ADS_codice_comune(rec.VED_CODICEISTAT,rec.VED_NOMECOMUNE,rec.VED_SIGLAPROVINCIAISTAT,rec.VED_CODICESTATO,rec.VED_DESCRIZIONELOCALITA,rec.VED_DATAEVENTO) w_codice_comune_VED
             , f_ADS_codice_comune(rec.ATTVED_CODICEISTAT,rec.ATTVED_NOMECOMUNE,rec.ATTVED_SIGLAPROVINCIAISTAT,'','',nvl(rec.ATTVED_DATAFORMAZIONEATTO,rec.VED_DATAEVENTO)) w_codice_comune_ATTVED
             , f_ADS_codice_comune(rec.ATTDIV_CODICEISTAT,rec.ATTDIV_NOMECOMUNE,rec.ATTDIV_SIGLAPROVINCIAISTAT,'','',rec.ATTDIV_DATAFORMAZIONEATTO) w_codice_comune_ATTDIV
             , f_ADS_codice_comune(rec.UCI_CODICEISTAT,rec.UCI_NOMECOMUNE,rec.UCI_SIGLAPROVINCIAISTAT,rec.UCI_CODICESTATO,rec.UCI_DESCRIZIONELOCALITA,rec.UCI_DATAEVENTO) w_codice_comune_UCI
             , f_ADS_codice_comune(rec.ATTUCI_CODICEISTAT,rec.ATTUCI_NOMECOMUNE,rec.ATTUCI_SIGLAPROVINCIAISTAT,'','',nvl(rec.ATTUCI_DATAFORMAZIONEATTO,rec.UCI_DATAEVENTO)) w_codice_comune_ATTUCI
             , f_ADS_codice_comune(rec.SCI_CODICEISTAT,rec.SCI_NOMECOMUNE,rec.SCI_SIGLAPROVINCIAISTAT,rec.SCI_CODICESTATO,rec.SCI_DESCRIZIONELOCALITA,rec.SCI_DATAEVENTO) w_codice_comune_SCI
             , f_ADS_codice_comune(rec.ATTSCI_CODICEISTAT,rec.ATTSCI_NOMECOMUNE,rec.ATTSCI_SIGLAPROVINCIAISTAT,'','',nvl(rec.ATTSCI_DATAFORMAZIONEATTO,rec.SCI_DATAEVENTO)) w_codice_comune_ATTSCI
             , f_ADS_codice_comune(rec.MOR_CODICEISTAT,rec.MOR_NOMECOMUNE,rec.MOR_SIGLAPROVINCIAISTAT,rec.MOR_CODICESTATO,rec.MOR_DESCRIZIONELOCALITA,rec.MOR_DATAEVENTO) w_codice_comune_MOR
             , f_ADS_codice_comune(rec.ATTMOR_CODICEISTAT,rec.ATTMOR_NOMECOMUNE,rec.ATTMOR_SIGLAPROVINCIAISTAT,'','',nvl(rec.ATTMOR_DATAFORMAZIONEATTO,rec.MOR_DATAEVENTO)) w_codice_comune_ATTMOR
             , f_ADS_codice_comune(rec.RES_CODICEISTAT,rec.RES_NOMECOMUNE,rec.RES_SIGLAPROVINCIAISTAT,rec.RES_CODICESTATO,rec.RES_DESCRIZIONELOCALITA,'') w_codice_comune_RES
--
             , f_ADS_matricola(rec.idsoggettoanpr_CN,rec.codfiscale_CN,rec.cognome_CN,rec.nome_CN,rec.sesso_CN,rec.datanascita_CN) w_matricola_CN
             , f_ADS_codice_comune(rec.NAS_CODICEISTAT_CN,rec.NAS_NOMECOMUNE_CN,rec.NAS_SIGLAPROVINCIAISTAT_CN,rec.NAS_CODICESTATO_CN,rec.NAS_DESCRIZIONELOCALITA_CN,rec.DATANASCITA_CN) w_codice_comune_NAS_cn
             , f_ADS_codice_comune(rec_cn.RES_CODICEISTAT,rec_cn.RES_NOMECOMUNE,rec_cn.RES_SIGLAPROVINCIAISTAT,rec_cn.RES_CODICESTATO,rec_cn.RES_DESCRIZIONELOCALITA,rec_cn.DATANASCITA) w_codice_comune_RES_cn
             , rec_cn.RES_DESCRIZIONELOCALITA RES_DESCRIZIONELOCALITA_CN
             , rec_cn.RES_NOMECOMUNE RES_NOMECOMUNE_CN
             , rec_cn.RES_DESCRIZIONESTATO RES_DESCRIZIONESTATO_CN
             , rec_cn.RES_SIGLAPROVINCIAISTAT RES_SIGLAPROVINCIAISTAT_CN
             , rec_cn.CIT_CODICESTATO CIT_CODICESTATO_CN_2
--
             , f_ADS_matricola(rec.idsoggettoanpr_UC,rec.codfiscale_UC,rec.cognome_UC,rec.nome_UC,rec.sesso_UC,rec.datanascita_UC) w_matricola_UC
             , f_ADS_codice_comune(rec.NAS_CODICEISTAT_UC,rec.NAS_NOMECOMUNE_UC,rec.NAS_SIGLAPROVINCIAISTAT_UC,rec.NAS_CODICESTATO_UC,rec.NAS_DESCRIZIONELOCALITA_UC,rec.DATANASCITA_UC) w_codice_comune_NAS_uc
--
             , f_ADS_matricola(rec.idsoggettoanpr_PD,rec.codfiscale_PD,rec.cognome_PD,rec.nome_PD,rec.sesso_PD,rec.datanascita_PD) w_matricola_PD
             , f_ADS_matricola(rec.idsoggettoanpr_MD,rec.codfiscale_MD,rec.cognome_MD,rec.nome_MD,rec.sesso_MD,rec.datanascita_MD) w_matricola_MD
--
             , decode(rec.ATTNAS_PARTE, '', '', 'I', 1, 'II', 2, 
                    decode(translate(substr(rec.ATTNAS_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTNAS_PARTE,1,1))) w_parte_nas
             , decode(rec.ATTMAT_PARTE, '', '', 'I', 1, 'II', 2, 
                    decode(translate(substr(rec.ATTMAT_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTMAT_PARTE,1,1))) w_parte_mat
             , decode(rec.ATTUCI_PARTE, '', '', 'I', 1, 'II', 2, 
                    decode(translate(substr(rec.ATTUCI_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTUCI_PARTE,1,1))) w_parte_uci
             , decode(rec.ATTVED_PARTE, '', '', 'I', 1, 'II', 2, 
                    decode(translate(substr(rec.ATTVED_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTVED_PARTE,1,1))) w_parte_ved
             , decode(rec.ATTSCI_PARTE, '', '', 'I', 1, 'II', 2, 
                    decode(translate(substr(rec.ATTSCI_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTSCI_PARTE,1,1))) w_parte_sci
             , decode(rec.ATTDIV_PARTE, '', '', 'I', 1, 'II', 2, 
                    decode(translate(substr(rec.ATTDIV_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTDIV_PARTE,1,1))) w_parte_div
             , decode(rec.ATTMOR_PARTE, '', '', 'I', 1, 'II', 2, 
                    decode(translate(substr(rec.ATTMOR_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTMOR_PARTE,1,1))) w_parte_mor
             , decode(translate(substr(rec.ATTNAS_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'), 
                    '9', substr(rec.ATTNAS_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTNAS_UFFICIOMUNICIPIO,1,2)) w_ufficio_nas
             , decode(translate(substr(rec.ATTMAT_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'),
                    '9', substr(rec.ATTMAT_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTMAT_UFFICIOMUNICIPIO,1,2)) w_ufficio_mat
             , decode(translate(substr(rec.ATTUCI_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'), 
                    '9', substr(rec.ATTUCI_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTUCI_UFFICIOMUNICIPIO,1,2)) w_ufficio_uci
             , decode(translate(substr(rec.ATTVED_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'), 
                    '9', substr(rec.ATTVED_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTVED_UFFICIOMUNICIPIO,1,2)) w_ufficio_ved
             , decode(translate(substr(rec.ATTNAS_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'), 
                    '9', substr(rec.ATTSCI_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTSCI_UFFICIOMUNICIPIO,1,2)) w_ufficio_sci
             , decode(translate(substr(rec.ATTDIV_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'), 
                    '9', substr(rec.ATTDIV_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTDIV_UFFICIOMUNICIPIO,1,2)) w_ufficio_div
             , decode(translate(substr(rec.ATTMOR_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'), 
                    '9', substr(rec.ATTMOR_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTMOR_UFFICIOMUNICIPIO,1,2)) w_ufficio_mor
             , rec.*
          from anpana rec_cn
             , anpana_id ai_cn
             , anpana_id ai
             , anpana rec
         where rec_cn.id_operazione  (+) = ai_cn.id_operazione
           and rec_cn.idSoggettoANPR (+) = ai_cn.idSoggettoANPR
           and ai_cn.idSoggettoANPR  (+) = ai.idSoggettoANPR_CN
           and ai.id_operazione      (+) = rec.id_operazione) rec
     , anpana anp
 where rec.id_operazione  = anp.id_operazione
   and rec.idSoggettoANPR = anp.idSoggettoANPR
/
comment on table anaana_ANPR_v is 'ANPR - Dati Angrafe nel formato ADS (view)'
/
