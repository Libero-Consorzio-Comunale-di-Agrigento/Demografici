--liquibase formatted sql
--changeset amonopoli:202305291155_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANPANA';
w_nome_col      varchar2(255) := '';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'create table anpana
(ID_OPERAZIONE                          NUMBER(10)
,matricola_ads				number
-- generalita
,codFiscale				varchar2(255)
,validitaCF				varchar2(255)
,dataAttribuzioneValidita		varchar2(255)
,cognome				varchar2(255)
,senzaCognome				varchar2(255)
,nome					varchar2(255)
,senzaNome				varchar2(255)
,sesso					varchar2(255)
,dataNascita				varchar2(255)
,senzaGiorno    			varchar2(255)
,senzaGiornoMese			varchar2(255)
,NAS_nomeComune				varchar2(255)
,NAS_codiceIstat			varchar2(255)
,NAS_siglaProvinciaIstat		varchar2(255)
,NAS_descrizioneLocalita		varchar2(255)
,NAS_descrizioneStato			varchar2(255)
,NAS_codiceStato			varchar2(255)
,NAS_luogoEccezionale			varchar2(255)
,idSoggettoComuneIstat			varchar2(255)
,idSoggettoComune			varchar2(255)
,idSoggettoANPR				varchar2(255)
,soggettoAIRE				varchar2(255)
-- statoCivile
,statoCivile				varchar2(255)
,noteStatoCivile			varchar2(255)
-- attributiSoggetto
,senzaFissaDimora			varchar2(255)
,soggettoCertificabile			varchar2(255)
-- attoNascita
,ATTNAS_nomeComune			varchar2(255)
,ATTNAS_codiceIstat			varchar2(255)
,ATTNAS_siglaProvinciaIstat		varchar2(255)
,ATTNAS_ufficioMunicipio		varchar2(255)
,ATTNAS_anno				varchar2(255)
,ATTNAS_parte				varchar2(255)
,ATTNAS_serie				varchar2(255)
,ATTNAS_numeroAtto			varchar2(255)
,ATTNAS_dataFormazioneAtto		varchar2(255)
,ATTNAS_trascritto 			varchar2(255)
-- cittadinanza
,CIT_descrizioneStato			varchar2(255)
,CIT_codiceStato			varchar2(255)
,CIT_dataValidita			varchar2(255)
-- paternita
,codFiscale_pd				varchar2(255)
,validitaCF_pd				varchar2(255)
,dataAttribuzioneValidita_pd		varchar2(255)
,cognome_pd				varchar2(255)
,senzaCognome_pd			varchar2(255)
,nome_pd				varchar2(255)
,senzaNome_pd				varchar2(255)
,sesso_pd				varchar2(255)
,dataNascita_pd				varchar2(255)
,senzaGiorno_pd				varchar2(255)
,senzaGiornoMese_pd			varchar2(255)
,NAS_nomeComune_pd			varchar2(255)
,NAS_codiceIstat_pd			varchar2(255)
,NAS_siglaProvinciaIstat_pd		varchar2(255)
,NAS_descrizioneLocalita_pd		varchar2(255)
,NAS_descrizioneStato_pd		varchar2(255)
,NAS_codiceStato_pd			varchar2(255)
,NAS_luogoEccezionale_pd		varchar2(255)
,idSoggettoComuneIstat_pd		varchar2(255)
,idSoggettoComune_pd			varchar2(255)
,idSoggettoANPR_pd			varchar2(255)
,soggettoAIRE_pd			varchar2(255)
,statoCivile_pd				varchar2(255)
,noteStatoCivile_pd			varchar2(255)
,CIT_descrizioneStato_pd		varchar2(255)
,CIT_codiceStato_pd			varchar2(255)
,CIT_dataValidita_pd			varchar2(255)
-- maternita
,codFiscale_md				varchar2(255)
,validitaCF_md				varchar2(255)
,dataAttribuzioneValidita_md		varchar2(255)
,senzaCognome_md			varchar2(255)
,cognome_md				varchar2(255)
,senzaNome_md				varchar2(255)
,nome_md				varchar2(255)
,sesso_md				varchar2(255)
,dataNascita_md				varchar2(255)
,senzaGiorno_md				varchar2(255)
,senzaGiornoMese_md			varchar2(255)
,NAS_nomeComune_md			varchar2(255)
,NAS_codiceIstat_md			varchar2(255)
,NAS_siglaProvinciaIstat_md		varchar2(255)
,NAS_descrizioneLocalita_md		varchar2(255)
,NAS_descrizioneStato_md		varchar2(255)
,NAS_codiceStato_md			varchar2(255)
,NAS_luogoEccezionale_md		varchar2(255)
,idSoggettoComuneIstat_md		varchar2(255)
,idSoggettoComune_md			varchar2(255)
,idSoggettoANPR_md			varchar2(255)
,soggettoAIRE_md			varchar2(255)
,statoCivile_md				varchar2(255)
,noteStatoCivile_md			varchar2(255)
,CIT_descrizioneStato_md		varchar2(255)
,CIT_codiceStato_md			varchar2(255)
,CIT_dataValidita_md			varchar2(255)
-- residenza
,RES_tipoIndirizzo			varchar2(255)
,RES_noteIndirizzo			varchar2(255)
,RES_cap				varchar2(255)
,RES_nomeComune				varchar2(255)
,RES_codiceIstat			varchar2(255)
,RES_siglaProvinciaIstat		varchar2(255)
,RES_frazione    			varchar2(255)
,RES_codSpecie				varchar2(255)
,RES_specie				varchar2(255)
,RES_specieFonte			varchar2(255)
,RES_codToponimo			varchar2(255)
,RES_denominazioneToponimo		varchar2(255)
,RES_toponimoFonte			varchar2(255)
,RES_codiceCivico			varchar2(255)
,RES_civicoFonte			varchar2(255)
,RES_numero				varchar2(255)
,RES_metrico				varchar2(255)
,RES_progSNC				varchar2(255)
,RES_lettera				varchar2(255)
,RES_esponente1				varchar2(255)
,RES_colore				varchar2(255)
,RES_corte				varchar2(255)
,RES_scala				varchar2(255)
,RES_interno1				varchar2(255)
,RES_espInterno1			varchar2(255)
,RES_interno2				varchar2(255)
,RES_espInterno2			varchar2(255)
,RES_scalaEsterna			varchar2(255)
,RES_secondario				varchar2(255)
,RES_piano				varchar2(255)
,RES_nui				varchar2(255)
,RES_isolato				varchar2(255)
,RES_dataDecorrenzaResidenza		varchar2(255)
,RES_capEstero				varchar2(255)
,RES_descrizioneLocalita		varchar2(255)
,RES_descrizioneStato			varchar2(255)
,RES_codiceStato			varchar2(255)
,RES_provinciaContea			varchar2(255)
,RES_toponimoEstero			varchar2(255)
,RES_codiceConsolato			varchar2(255)
,RES_descrizioneConsolato		varchar2(255)
,RES_presso				varchar2(255)
-- datiTraslitterati
,TRA_cognome		   		varchar2(255)
,TRA_nome				varchar2(255)
,TRA_denominazioneToponimo		varchar2(255)
,TRA_denominazioneComune 		varchar2(255)
--
,ELE_elettore                           varchar2(255)
,ELE_nomeComune                         varchar2(255)
,ELE_codiceIstat                        varchar2(255)
,ELE_siglaProvinciaIstat                varchar2(255)
,LEV_iscritto                           varchar2(255)
-- cartaIdentita
,DI_numero				varchar2(255)
,DI_dataRilascio			varchar2(255)
,DI_cartaceaElettronica			varchar2(255)
,DI_interdizioneEspatrio		varchar2(255)
,DI_nomeComune				varchar2(255)
,DI_codiceIstat				varchar2(255)
,DI_siglaProvinciaIstat  		varchar2(255)
,DI_dataScadenza			varchar2(255)
,DI_codiceConsolato                     varchar2(255)
,DI_descrizioneConsolato                varchar2(255)
,DI_dataAnnullamento                    varchar2(255)
-- permessoSoggiorno
,DS_numero				varchar2(255)
,DS_tipoSoggiorno			varchar2(255)
,DS_dataRilascio			varchar2(255)
,DS_dataScadenza			varchar2(255)
,DS_questuraRilascioSoggiorno		varchar2(255)
,DS_nomeComune				varchar2(255)
,DS_codiceIstat				varchar2(255)
,DS_siglaProvinciaIstat  		varchar2(255)
,DS_numeroPassaporto	  		varchar2(255)
-- matrimonio
,codFiscale_cn				varchar2(255)
,validitaCF_cn				varchar2(255)
,dataAttribuzioneValidita_cn		varchar2(255)
,cognome_cn				varchar2(255)
,senzaCognome_cn			varchar2(255)
,nome_cn				varchar2(255)
,senzaNome_cn				varchar2(255)
,sesso_cn				varchar2(255)
,dataNascita_cn				varchar2(255)
,senzaGiorno_cn				varchar2(255)
,senzaGiornoMese_cn			varchar2(255)
,NAS_nomeComune_cn			varchar2(255)
,NAS_codiceIstat_cn			varchar2(255)
,NAS_siglaProvinciaIstat_cn		varchar2(255)
,NAS_descrizioneLocalita_cn		varchar2(255)
,NAS_descrizioneStato_cn		varchar2(255)
,NAS_codiceStato_cn			varchar2(255)
,NAS_luogoEccezionale_cn		varchar2(255)
,idSoggettoComuneIstat_cn		varchar2(255)
,idSoggettoComune_cn			varchar2(255)
,idSoggettoANPR_cn			varchar2(255)
,CIT_descrizioneStato_cn		varchar2(255)
,CIT_codiceStato_cn			varchar2(255)
,CIT_dataValidita_cn			varchar2(255)
,MAT_dataEvento				varchar2(255)
,MAT_senzaGiorno			varchar2(255)
,MAT_senzaGiornoMese			varchar2(255)
,MAT_nomeComune				varchar2(255)
,MAT_codiceIstat			varchar2(255)
,MAT_siglaProvinciaIstat		varchar2(255)
,MAT_descrizioneLocalita		varchar2(255)
,MAT_descrizioneStato			varchar2(255)
,MAT_codiceStato			varchar2(255)
,MAT_luogoEccezionale			varchar2(255)
,ATTMAT_nomeComune			varchar2(255)
,ATTMAT_codiceIstat			varchar2(255)
,ATTMAT_siglaProvinciaIstat		varchar2(255)
,ATTMAT_ufficioMunicipio		varchar2(255)
,ATTMAT_anno				varchar2(255)
,ATTMAT_parte				varchar2(255)
,ATTMAT_serie				varchar2(255)
,ATTMAT_numeroAtto			varchar2(255)
,ATTMAT_dataFormazioneAtto		varchar2(255)
,ATTMAT_trascritto 			varchar2(255)
,MAT_ordineMatrimonio 			varchar2(255)
-- vedovanza
,VED_dataEvento				varchar2(255)
,VED_senzaGiorno			varchar2(255)
,VED_senzaGiornoMese			varchar2(255)
,VED_nomeComune				varchar2(255)
,VED_codiceIstat			varchar2(255)
,VED_siglaProvinciaIstat		varchar2(255)
,VED_descrizioneLocalita		varchar2(255)
,VED_descrizioneStato			varchar2(255)
,VED_codiceStato			varchar2(255)
,VED_luogoEccezionale			varchar2(255)
,ATTVED_nomeComune			varchar2(255)
,ATTVED_codiceIstat			varchar2(255)
,ATTVED_siglaProvinciaIstat		varchar2(255)
,ATTVED_ufficioMunicipio		varchar2(255)
,ATTVED_anno				varchar2(255)
,ATTVED_parte				varchar2(255)
,ATTVED_serie				varchar2(255)
,ATTVED_numeroAtto			varchar2(255)
,ATTVED_dataFormazioneAtto		varchar2(255)
,ATTVED_trascritto 			varchar2(255)
-- annullamentoMatrimonio
,DIV_tipoCessazione			varchar2(255)
,DIV_dataSentenza			varchar2(255)
,DIV_senzaGiorno			varchar2(255)
,DIV_senzaGiornoMese			varchar2(255)
,DIV_numeroSentenza			varchar2(255)
,DIV_tipoTribunaleSentenza		varchar2(255)
,DIV_autoritaSentenza		 	varchar2(255)
,DIV_dataValiditaSentenza		varchar2(255)
,ATTDIV_nomeComune			varchar2(255)
,ATTDIV_codiceIstat			varchar2(255)
,ATTDIV_siglaProvinciaIstat		varchar2(255)
,ATTDIV_ufficioMunicipio		varchar2(255)
,ATTDIV_anno				varchar2(255)
,ATTDIV_parte				varchar2(255)
,ATTDIV_serie				varchar2(255)
,ATTDIV_numeroAtto			varchar2(255)
,ATTDIV_dataFormazioneAtto		varchar2(255)
,ATTDIV_trascritto			varchar2(255)
-- unioneCivile
,codFiscale_uc				varchar2(255)
,validitaCF_uc				varchar2(255)
,dataAttribuzioneValidita_uc		varchar2(255)
,cognome_uc				varchar2(255)
,senzaCognome_uc			varchar2(255)
,nome_uc				varchar2(255)
,senzaNome_uc				varchar2(255)
,sesso_uc				varchar2(255)
,dataNascita_uc				varchar2(255)
,senzaGiorno_uc				varchar2(255)
,senzaGiornoMese_uc			varchar2(255)
,NAS_nomecomune_uc			varchar2(255)
,NAS_codiceIstat_uc			varchar2(255)
,NAS_siglaProvinciaIstat_uc		varchar2(255)
,NAS_descrizioneLocalita_uc		varchar2(255)
,NAS_descrizioneStato_uc		varchar2(255)
,NAS_codiceStato_uc			varchar2(255)
,NAS_luogoEccezionale_uc		varchar2(255)
,idSoggettoComuneIstat_uc		varchar2(255)
,idSoggettoComune_uc			varchar2(255)
,idSoggettoANPR_uc			varchar2(255)
,UCI_dataEvento				varchar2(255)
,UCI_senzaGiorno			varchar2(255)
,UCI_senzaGiornoMese			varchar2(255)
,UCI_nomecomune				varchar2(255)
,UCI_codiceIstat			varchar2(255)
,UCI_siglaProvinciaIstat		varchar2(255)
,UCI_descrizioneLocalita		varchar2(255)
,UCI_descrizioneStato			varchar2(255)
,UCI_codiceStato			varchar2(255)
,UCI_luogoEccezionale			varchar2(255)
,ATTUCI_nomeComune			varchar2(255)
,ATTUCI_codiceIstat			varchar2(255)
,ATTUCI_siglaProvinciaIstat		varchar2(255)
,ATTUCI_ufficioMunicipio		varchar2(255)
,ATTUCI_anno				varchar2(255)
,ATTUCI_parte				varchar2(255)
,ATTUCI_serie				varchar2(255)
,ATTUCI_numeroAtto			varchar2(255)
,ATTUCI_dataFormazioneAtto		varchar2(255)
,ATTUCI_trascritto			varchar2(255)
,SCI_motivoScioglimento			varchar2(255)
,SCI_dataSentenza			varchar2(255)
,SCI_numeroSentenza			varchar2(255)
,SCI_tipoTribunaleSentenza		varchar2(255)
,SCI_autoritaSentenza			varchar2(255)
,SCI_dataValiditaSentenza		varchar2(255)
,SCI_dataEvento				varchar2(255)
,SCI_nomecomune				varchar2(255)
,SCI_codiceIstat			varchar2(255)
,SCI_siglaProvinciaIstat		varchar2(255)
,SCI_descrizioneLocalita		varchar2(255)
,SCI_descrizioneStato			varchar2(255)
,SCI_codiceStato			varchar2(255)
,SCI_luogoEccezionale			varchar2(255)
,ATTSCI_nomeComune			varchar2(255)
,ATTSCI_codiceIstat			varchar2(255)
,ATTSCI_siglaProvinciaIstat		varchar2(255)
,ATTSCI_ufficioMunicipio		varchar2(255)
,ATTSCI_anno				varchar2(255)
,ATTSCI_parte				varchar2(255)
,ATTSCI_serie				varchar2(255)
,ATTSCI_numeroAtto			varchar2(255)
,ATTSCI_dataFormazioneAtto		varchar2(255)
,ATTSCI_trascritto			varchar2(255)
,CIT_descrizioneStato_uc		varchar2(255)
,CIT_codiceStato_uc			varchar2(255)
,CIT_dataValidita_uc			varchar2(255)
,UCI_ordineUnione			varchar2(255)
-- convivenzaDiFatto
,codFiscale_cv				varchar2(255)
,validitaCF_cv				varchar2(255)
,dataAttribuzioneValidita_cv		varchar2(255)
,cognome_cv				varchar2(255)
,senzaCognome_cv			varchar2(255)
,nome_cv				varchar2(255)
,senzaNome_cv				varchar2(255)
,sesso_cv				varchar2(255)
,dataNascita_cv				varchar2(255)
,senzaGiorno_cv				varchar2(255)
,senzaGiornoMese_cv			varchar2(255)
,NAS_nomecomune_cv			varchar2(255)
,NAS_codiceIstat_cv			varchar2(255)
,NAS_siglaProvinciaIstat_cv		varchar2(255)
,NAS_descrizioneLocalita_cv		varchar2(255)
,NAS_descrizioneStato_cv		varchar2(255)
,NAS_codiceStato_cv    			varchar2(255)
,NAS_luogoEccezionale_cv   		varchar2(255)
,idSoggettoComuneIstat_cv		varchar2(255)
,idSoggettoComune_cv			varchar2(255)
,idSoggettoANPR_cv			varchar2(255)
,CIT_descrizioneStato_cv		varchar2(255)
,CIT_codiceStato_cv			varchar2(255)
,CIT_dataValidita_cv			varchar2(255)
,CDFSTI_data				varchar2(255)
,CDFSTI_dataNotifica			varchar2(255)
,CDFSTI_dataDocumento			varchar2(255)
,CDFSTI_protocollo			varchar2(255)
,CDFSTI_nomeComune			varchar2(255)
,CDFSTI_codiceIstat			varchar2(255)
,CDFSTI_siglaProvinciaIstat		varchar2(255)
,CDFSTI_professionista			varchar2(255)
,CDFSTI_nomeComuneReg			varchar2(255)
,CDFSTI_codiceIstatReg			varchar2(255)
,CDFSTI_siglaProvinciaIstatReg		varchar2(255)
,CDFSTI_stato				varchar2(255)
,CDFRIS_motivoRisoluzione		varchar2(255)
,CDFRIS_data				varchar2(255)
,CDFRIS_dataNotifica			varchar2(255)
,CDFRIS_dataDocumento			varchar2(255)
,CDFRIS_protocollo			varchar2(255)
,CDFRIS_nomeComune			varchar2(255)
,CDFRIS_codiceIstat			varchar2(255)
,CDFRIS_siglaProvinciaIstat		varchar2(255)
,CDFRIS_professionista			varchar2(255)
,CDFRIS_nomeComuneReg			varchar2(255)
,CDFRIS_codiceIstatReg			varchar2(255)
,CDFRIS_siglaProvinciaIstatReg		varchar2(255)
,CDFRIS_stato				varchar2(255)
-- legameSoggetto
,FAM_tipoLegame				varchar2(255)
,FAM_dataDecorrenza			varchar2(255)
,FAM_codiceLegame			varchar2(255)
,FAM_dataDecorrenzaLegame		varchar2(255)
-- famigliaConvivenza
,FAM_idFamigliaComuneIstat		varchar2(255)
,FAM_idFamigliaComune			varchar2(255)
,FAM_idFamigliaANPR			varchar2(255)
,FAM_FamigliaAire			varchar2(255)
,FAM_dataOrigineFamiglia		varchar2(255)
,FAM_denominazioneConvivenza		varchar2(255)
,FAM_specieConvivenza			varchar2(255)
,FAM_presenzaFamigliaCoabitante		varchar2(255)
,FAM_tipoScheda				varchar2(255)
-- censimento
,annoCensimento				varchar2(255)
,sezioneCensimento			varchar2(255)
,foglioCensimento			varchar2(255)
-- altriDati
,posizioneProfessionale			varchar2(255)
,condizioneNonProfessionale		varchar2(255)
,titoloStudio				varchar2(255)
-- autoveicoli
,possessoAutoveicoli			varchar2(255)
,possessoPatente			varchar2(255)
-- datiIscrizione
,ISC_dataIscrizione			varchar2(255)
,ISC_protocolloComune			varchar2(255)
,ISC_nomeComune				varchar2(255)
,ISC_codiceIstat			varchar2(255)
,ISC_siglaProvinciaIstat		varchar2(255)
,ISC_idOperazioneComune			varchar2(255)
,ISC_idOperazioneANPR			varchar2(255)
,ISC_dataDefinizionePratica		varchar2(255)
,ISC_motivoIscrizione			varchar2(255)
,ISC_desMotivoIscrizione		varchar2(255)
,ISC_motivoIscrizioneAire		varchar2(255)
,ISC_iniziativaAire			varchar2(255)
,ISC_individuazioneAire			varchar2(255)
,ISC_dataArrivoConsolato		varchar2(255)
-- provenienza
,PRO_nomeComune				varchar2(255)
,PRO_codiceIstat			varchar2(255)
,PRO_siglaProvinciaIstat		varchar2(255)
,PRO_descrizioneLocalita		varchar2(255)
,PRO_descrizioneStato			varchar2(255)
,PRO_codiceStato			varchar2(255)
-- cancellazione
,CAN_MOTIVOCANCELLAZIONE		varchar2(255)
,CAN_NOTECANCELLAZIONE			varchar2(255)
,CAN_DATADECORRENZA			varchar2(255)
-- destinazione
,DES_nomeComune				varchar2(255)
,DES_CODICEISTAT			varchar2(255)
,DES_SIGLAPROVINCIAISTAT		varchar2(255)
,DES_DESCRIZIONELOCALITA		varchar2(255)
,DES_DESCRIZIONESTATO			varchar2(255)
,DES_CODICESTATO			varchar2(255)
-- decesso
,MOR_DATAEVENTO				varchar2(255)
,MOR_senzaGiorno			varchar2(255)
,MOR_senzaGiornoMese			varchar2(255)
,MOR_nomeComune				varchar2(255)
,MOR_CODICEISTAT			varchar2(255)
,MOR_SIGLAPROVINCIAISTAT		varchar2(255)
,MOR_DESCRIZIONELOCALITA		varchar2(255)
,MOR_DESCRIZIONESTATO			varchar2(255)
,MOR_CODICESTATO			varchar2(255)
,MOR_luogoEccezionale			varchar2(255)
,ATTMOR_nomeComune			varchar2(255)
,ATTMOR_CODICEISTAT			varchar2(255)
,ATTMOR_SIGLAPROVINCIAISTAT		varchar2(255)
,ATTMOR_UFFICIOMUNICIPIO		varchar2(255)
,ATTMOR_ANNO				varchar2(255)
,ATTMOR_PARTE				varchar2(255)
,ATTMOR_SERIE				varchar2(255)
,ATTMOR_NUMEROATTO			varchar2(255)
,ATTMOR_DATAFORMAZIONEATTO		varchar2(255)
,ATTMOR_TRASCRITTO			varchar2(255)
-- nuovi campi ANSC
,ATTNAS_idANSC				varchar2(255)
,ATTNAS_numeroComunale			varchar2(255)
,ATTMAT_idANSC				varchar2(255)
,ATTMAT_numeroComunale			varchar2(255)
,ATTDIV_idANSC				varchar2(255)
,ATTDIV_numeroComunale			varchar2(255)
,ATTUCI_idANSC				varchar2(255)
,ATTUCI_numeroComunale			varchar2(255)
,ATTSCI_idANSC				varchar2(255)
,ATTSCI_numeroComunale			varchar2(255)
,ATTVED_idANSC				varchar2(255)
,ATTVED_numeroComunale			varchar2(255)
,ATTMOR_idANSC				varchar2(255)
,ATTMOR_numeroComunale			varchar2(255)
)';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'idx1anpana';
w_nome_col      varchar2(255) := '';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'create index idx1anpana on anpana (id_OPERAZIONE)';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'idx2anpana';
w_nome_col      varchar2(255) := '';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'create index idx2anpana on anpana (matricola_ads)';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'idx3anpana';
w_nome_col      varchar2(255) := '';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'create index idx3anpana on anpana (idSoggettoANPR)';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
comment on table anpana is 'ANPR - Soggetti'
/
