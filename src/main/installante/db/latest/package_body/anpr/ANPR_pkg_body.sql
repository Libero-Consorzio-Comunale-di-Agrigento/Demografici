--liquibase formatted sql
--changeset amonopoli:202412041230_2 runOnChange:true stripComments:false
create or replace package body ANPR_PKG
is

function versione

return varchar2

IS

w_versione 		varchar2(255);

begin
--
-- Versione   Data         Autore   Note
-- V1.0                    AM       .prima emissione
-- V1.1   del 12/11/2015   AM       .adeguamento specifiche del 21/10/2015
-- V1.2                    AM       .adeguamento specifiche del 13/11/2015
-- V1.3   del 24/12/2015   AM       .adeguamento specifiche del 07/12/2015
-- V1.4   del 12/01/2016   AM       .adeguamento specifiche del 08/01/2016
-- V1.5   del 13/05/2016   AM       .adeguamento specifiche del 01/02/2016
-- V2.0   del 23/09/2016   AM       .adeguamento sepcifiche del 29/07/2016
-- V2.1   del 24/11/2016   AM       .consultazione / acquisizione notifiche
-- V2.2   del 13/12/2016   AM       .S001: interventi post-Poggibonsi
-- V2.3   del 27/12/2016   AM       .S001: interventi post-Rivoli
-- V2.4   del 30/12/2016   AM       .servizio 1010 - iscrizione convivenza
-- V3.0   del 30/03/2017   AM       .adeguamento specifiche del 26/01/2017 - 01/03/2017 - 17/03/2017
-- V3.1   del 07/04/2017   AM       .(bug) upd_anpads: aggiornamento idANPR x Aire
-- V3.2   del 23/06/2017   AM       .5000: indicazione del sesso del coniuge in assenza di matricola_cn
-- V3.3   del 28/06/2017   AM       .5000: indicazione dei dati di vedovanza solo se matricola_cn is null
-- V3.4   del 25/08/2017   AM       .S001: aggiunto tag unioneCivile e convivenzaDiFatto
-- V3.5   del 07/09/2017   AM       .5005: listaControlli per forzatura scissione senza cambio indirizzo
--                                  .S001: inclusione codici fiscali provvisori di 11 caratteri
--                                  .6001: forzaCertificazione + gestione bolloVirtuale in base al valore del bollo
--                                  .f_xml_atto - attoNascita: gestione della data_rif per comuneRegistrazione
--                                  .5008: mutazione listaElettorale / listaLeva
-- V3.6   del 16/10/2017   AM       .3002: consultazione "alla data..."
-- V3.7   del 20/10/2017   AM       .via_aire passata senza barre (fino a modifiche di SOGEI)
-- V3.8   del 23/10/2017   AM       .S001: dataUltimoAggiornamento = ana.data_ult_eve per soggetti AIS
-- V3.9   del 30/10/2017   AM       .2011: modificato tag da "tiposcheda" a "tipoScheda" 
-- V4.0   del 03/11/2017   AM       .5008: gestione delle mutazioni multiple nel caso di perfezionamento IAPR (rif. anptmu_20)
--                                  .modificato selezione w_versione_applicativo, recuperando il dato dal progetto DE4GSD
-- V4.0.a del 07/11/2017   AM       .gestioneCF: evitato impostazione '1' in caso di iscrizione diversa da nascita
-- V4.0.b del 07/11/2017   AM       .gestioneCF: impostazione '1' x richiesta attribuzione CF (rif. Medicina)
-- V4.0.c del 09/11/2017   AM       .1002: indicazione del codiceFiscale anche se calcolato (rif. San Lazzaro)
-- V4.1   del 15/11/2017   AM       .N014 / N015: gestito acquisizione risposte
--                                  .gestioneCF: nuova function f_ANPR_gestioneCF x gestire il dato da maschera
-- V4.2   del 21/11/2017   AM       .6001: applicato f_ANPR_stringa alla descrizioneEsenzioneBollo per caratteri diacritici
--                                  .5008: unitoCivilmente, valorizzato campo sesso
-- V4.2.a del 22/11/2017   AM       .2003: uso della data_subentro al posto della dataDecorrenza 
-- V4.2.b del 22/11/2017   AM       .5000: dataDecorrenza = data_reg solo se servizio '5008' e cod_mov = 1
-- V4.2.c del 30/11/2017   AM       .A006: sistemato xml nel caso di scissione (12-92)
-- V4.2.d del 06/12/2017   AM       .A006: sistemato xml iscrizioneAIRE nel caso di emigrazione AIRE (3-52)
--                                  .5008: evitato dati coniuge nel caso di VE / DV / GC (AIRE)
-- V4.2.e del 11/12/2017   AM       .5001: data_decorrenza = data_inizio_res per rettifica indirizzo
-- V4.3   del 05/12/2017   AM       .3003: elenco operazioni
--                                  .4003/3005: richiesta prospetti statistici
-- V4.3.a del 13/12/2017   AM       .5008: evitato dati coniuge nel caso di VE / DV / GC (APR)
-- V4.4   del 21/12/2017   AM       .ws_5000_mutazione_SFD (senzaFissaDimora)
-- V4.4.a del 22/12/2017   AM       .5008: dataDecorrenza = dataReg in assenza di n.ro di pratica (rif. Faenza)
--                                  .f_xml_divorzio: indicazione della sentenza anche se uguale a zero (rif. Faenza)
-- V4.4.b del 29/12/2017   AM       .5001: recupero idFamigliaANPR dalla posizione ANPR o dalla famiglia aire
-- V4.4.c del 09/01/2018   AM       .2000: evitato di indicare il luogo di nascita nel tag generalitaPerRicerca
-- V4.5   del 10/01/2018   AM       .3002: recupero anomalie da subentro in ANPERR
-- V4.5.a del 12/01/2018   AM       .sostituito '/' con '-' nell'indicazione del numero di pratica
-- V4.5.b del 16/01/2018   AM       .5005: evitato passaggio del CF nelle generalit  del soggetto (rif. Faenza)
-- V4.5.c del 17/01/2018   AM       .5008: comunicazioni non presenti in anpciu_v - tipo_evento = 'R' (rif. San Lazzaro)
-- V4.5.d del 18/01/2018   AM       .1013: annullamentoAttribuzione valorizzato a 'N' (rif. Faenza)
-- V4.6   del 19/01/2018   AM       .5001_mutazione_FAM: mutazione intestatario convivenza
-- V4.6.a del 22/01/2018   AM       .5008: caso di decorrenza da retro-datare x soggetto morto il giorno prima del perfezionamento (rif. Faenza)
-- V4.7   del 25/01/2018   AM       .nuova tabella ANPCIU_AGG x gestire la forzatura di gestioneCF (ex ANPGCF) e dataDecorrenza
-- V4.8   del 30/01/2018   AM       .gestione della denominazioneConvivenza (anche nel servizio ws_5001_mutazione_FAM)
-- V4.8.a del 30/01/2018   AM       .5008: datiMatrimonio nel caso di VE-GC-DV, se perfezionamento IAPR
-- V4.8.b del 02/02/2018   AM       .A006: dati del nuovo consolato nel caso di pratica CABA (rif. San Lazzaro)
-- V4.9   del 09/02/2018   AM       .ws_5000_mutazione_SUB (rettifica dati subentro)
-- V4.9.a del 12/02/2018   AM       .3005 (download prospetti statistici) evitato doppia decodifica base64
--                                  .5014: nuovo servizio per rettifica dataDecorrenzaResidenza e Dati Iscrizione
-- V4.9.b del 14/02/2018   AM       .1014: gestione annullamento di iscrizione AIRE (A001 / A002)
-- V4.9.c del 16/02/2018   AM       .f_xml_convivenzaDiFatto: aggiunto dati di stipula nel caso di Contratto di Convivenza registrato
-- V4.9.d del 23/02/2018   AM       .f_xml_datiCancellazione: corretto tag "note" in "notecancellazione"
-- V4.9.e del 27/02/2018   AM       .5008: datiVedovanza nel caso di completamento dati
-- V4.9.f del 09/03/2018   AM       .via_aire: ripristinata indicazione di '/' e '-' (modifiche di SOGEI eseguite)
-- V4.9.g del 16/03/2018   AM       .1002: ripristino anagrafico, recupero data_ult_eve / data_inizio_res / data_inizio_fam da anaana
-- V4.9.f del 26/03/2018   AM       .5008: annullamento paternita / maternita, indicazione di senzaCognome e senzaNome
-- V5.0   del 26/03/2018   AM       .5013: nuovo servizio per revoca dato
-- V5.0.a del 28/03/2018   AM       .testataRichiesta: campo codDestinatario parametrico (rif. parametro COD_DEST)
-- V5.1   del 30/03/2018   AM       .6001: dataDecorrenza valorizzata con cem.data_storico
-- V5.1.a del 03/04/2018   AM       .6001: emissione valorizzato a '2' per richiesta da portale (ON_LINE)
-- V5.2   del 13/04/2018   AM       .3003: insert into anpope, not exists su idOperazioneANPR invece che idOperazioneComune (rif. San Lazzaro)
-- V5.3   del 16/04/2018   AM       .5008: caso di annullamento di matrimonio (rif. Faenza)
-- V5.3.a del 16/04/2018   AM       .6001: emissione ON_LINE, annotazioni in caso di carta legale
-- V5.3.b del 23/04/2018   AM       .6001: importo diritti rpad-adato a zero per valori senza centesimi (rif. Guastalla)
-- V5.3.c del 27/04/2018   AM       .f_ANPR_stringa con passaggio caratteri non ammessi (rif. numeroSoggiorno:'.,-')
-- V5.3.d del 02/05/2018   AM       .f_ANPR_stringa con passaggio caratteri non ammessi (rif. numeroSentenza: '.,-')
-- V5.4   del 04/05/2018   AM       .4001/4003: estratti in ANPR_PKG_4000
--                                  .ws_7001_scarico_tabelle
-- V5.4.a del 14/05/2018   AM       .3002: getClobVal x ramo cittadinanza (anche _pd, _md, _cn, _uc, _cv)
-- V5.4.b del 15/05/2018   AM       .A000: gestione della data_decorrenza_ws
-- V5.4.c del 16/05/2018   AM       .2011/5012: gestione della listaControlli per comunicare il ripristino anagrafico (RA-1)
-- V5.4.d del 18/05/2018   AM       .6001: PAestera per gestione Destinazione d'uso specifica
--                                  .f_xml_convivenzaDiFatto: eliminato dataDocumento in assenza di contratto di convivenza
--                                  .via_aire: gestito caratteri non ammesso '#()' 
-- V5.5   del 24/05/2018   AM       .4001/4003: spostato su ANPR_pkg_4000 anche la function ws_4000_estrazione
-- V5.6   del 28/05/2018   AM       .3002: acquisizione dati consolatoRilascio per documento di identita'
-- V5.7   del 29/05/2018   AM       .idFamConvComune: trattamento specifico del tipoScheda nel caso di Rimpatrio
-- V5.7.a del 30/05/2018   AM       .5014: aggiunto richiestaRettifica103 x dataIngressoFamiglia
-- V5.7.b del 08/06/2018   AM       .5008: datiMatrimonio anche per statoCivile in ('VE','DV','GC') (rif. Faenza)   (*)
-- V5.8   del 21/06/2018   AM       .5014: aggiunto richiestaRettifica103 x dataUltimoAggiornamentoAPR
-- V5.8.a del 27/06/2018   AM       .2000: diviso gestione della dataDecorrenza di Richiesta e Cancellazione
--                                  .2011: controllo cod_mov '1' per ripristino cancellazione 1-18
-- V5.8.b del 23/07/2018   AM       .f_xml_cartaIdentita: data_emissione come riferimento per f_ANPR_luogo
-- V5.9   del 24/07/2018   AM       .f_xml_convivenzaDiFatto: corretto gestione data / dataDocumento
-- V5.9.a del 24/07/2018   AM       .ws_5000_mutazione_DOC x archivio_ric DOC_CDF
-- V5.9.b del 25/07/2018   AM       .5008: datiMatrimonio solo per statoCivile 'VE' (rif. V5.7.a)                   (*)
--                                  .solo per cod_mov '1' controllo su statoCivile in ('VE','DV','GC')
--                                  .motivoScioglimento/motivoRisoluzione: adeguamento codici ANPT43
-- V6.0   del 28/08/2018   AM       .5008: gestione del tipoMutazione '21' per Integrazione Dati AIRE	
-- V6.1   del 31/08/2018   AM       .ins_anpads: gestione del campo num_componenti_anpr x 'Famiglia ANPR'
-- V6.1.a del 03/09/2018   AM       .5008: datiMatrimonio per tipoMutazione '21'
-- V6.2   del 05/09/2018   AM       .5001/5005: controllo "Famiglia ANPR" in caso di iscrizione da comune subentrato
-- V6.2.a del 14/09/2018   AM       .5012: listaControlli per ripristino anagrafico (RA-1) nel caso di immi da comune subentrato
-- V6.2.b del 19/09/2018   AM       .5008: cartaIdentita per tipoMutazione '21'
-- V6.2.c del 20/09/2018   AM       .f_xml_codiceFiscale: x servizio '1001', indicazione del CF anche in caso di cf_calcolato attivo
-- V6.2.d del 24/09/2018   AM       .f_xml_indirizzo: f_ANPR_stringa applicata al campo SUFFISSO
-- V6.2.e del 26/09/2018   AM       .5001: listaControlli per sblocco certificazione (FC-S) nel caso di 10-90 con RP_prec = RP
-- V6.3   del 27/09/2018   AM       .5001: gestione della conferma rapporto_par, modificato tra iscr. preliminare e iscr. definitiva (archivio_rif = 'MOV_RP')
-- V6.3.a del 28/09/2018   AM       .f_xml_altriDati: x compilazione xml anche in assenza di prosizioneProfessionale e titoloStudio (rif. Bovezzo)
-- V6.3.b del 01/10/2018   AM       .f_xml_indirizzo: f_ANPR_stringa applicata ai campi SCALA e PIANO (rif. Trapani)
-- V6.3.c del 05/10/2018   AM       .5001: conferma rapporto parentela (archivio_rif 'MOV_RP') e sblocco certificabilita SFA (archivio_rif 'FAM' e tipo_operazione 'R')
-- V6.3.d del 08/10/2018   AM       .gestione parametro atab.ORA-31167 x errore omonimo (rif. Porto Azzurro) 
-- V6.4   del 08/10/2018   AM       .ins_anpads: gestione del campo rapporto_par_anpr x 'Famiglia ANPR'
-- V6.4.a del 10/10/2018   AM       .5014: aggiunto richiestaRettifica103 x dataPrimaIscrizioneComune (rif. Belluno)
--                                  .5008: apertura / chiusura CDF con data_inizio / data_fine in dataDecorrenza 
-- V6.4.b del 12/10/2018   AM       .f_ANPR_stringa con passaggio caratteri non ammessi (rif. numeroSoggiorno:'.,' - tolto '-') 
-- V6.4.c del 15/10/2018   AM       .f_ANPR_indirizzo: gestione del campo frazione (rif. Medicina)
-- V6.4.d del 16/10/2018   AM       .f_ANPR_stringa con passaggio caratteri non ammessi (rif. numeroSoggiorno:'.,*@' - aggiunto '*@')
-- V6.4.e del 23/10/2018   AM       .f_ANPR_data_atto_rif applicata anche all'atto di matrimonio (rif. Belluno)
-- V6.4.f del 31/10/2018   AM       .5008: conferma dati aire, solo per matrimonio (a_archivio_rif = 'AIR_M')
-- V6.5   del 06/11/2018   AM       .5001: gestione a_archivio_rif = 'VIE' per revisione dell'onomastica (rif. Bagno di Romagna)
-- V6.5.a del 07/11/2018   AM       .5012: f_5012_ann_mutazione_MOV / f_5012_ann_mutazione_FAM
-- V6.5.b del 08/11/2018   AM       .5008: x completamento dati aire, generalitaPerRicerca troncati a 36 caratteri (rif. Belluno)
-- V6.5.c del 13/11/2018   AM       .servizio 2009 - cancellazione convivenza
-- V6.5.d del 14/11/2018   AM       .1010: gestione della data_decorrenza_ws
-- V6.5.e del 16/11/2018   AM       .5008: gestione del tag "separazioneAnnullamentoCessazioneMatrimoni" in caso di stato civile in CE / NU
--                                  .3002: acquisizione dataAnnullamento x documento di identita'
-- V6.5.f del 23/11/2018   AM       .f_xml_permessoSoggiorno: f_ANPR_stringa applicata al campo numeroPassaporto ('.,*@-/+')
-- V6.5.g del 27/11/2018   AM       .ws_5001_mutazione_FAM: evitato ins_anpads nel caso di tipo_fam 'Famiglia'
--                                  .1002: w_tipoMutazione '01' per stato_civile 'GU'
-- V6.5.h del 07/12/2018   AM       .gestione archivio_rif like 'MOV%'
-- V6.5.i del 14/12/2018   AM       .nuove restrizioni applicate al campo indirizziAIRE ('\#() ^"')
-- V6.6   del 11/01/2019   AM       .N031/N010/N014/N015: acquisizione notifiche con gestione <data_fine> da GINP
--                                  .3002: gestione del tag ricercaNazionale (modalit  ANPR02)
-- V6.6.a del 23/01/2019   AM       .ws_5001_mutazione_FAM: gestito caso di variazione famiglia con nvl(data_istituzione,dataOrigineFam)
-- V6.6.b del 28/01/2019   AM       .ws_1013_ann_iscrizione: non era gestito il caso di annullamento di iscrizione AIRE (da anamov_elev)
-- V6.7   del 04/02/2019   AM       .ws_5013_revoca_DOC: estensione del servizio di revoca (5013) all'annullamento delle carte di identit 
-- V6.7.a del 04/02/2019   AM       .f_xml_cartaIdentit : aggiunto indicazione di dataAnnullamento
-- V6.7.b del 12/02/2019   AM       .UCI: modificato w_motivoScioglimento da '01' a '1'
-- V6.7.c del 19/02/2019   AM       .f_xml_cartaIdentita: gestione del consolatoRilascio in caso di cod_pro_ente > 199
-- V6.7.d del 11/03/2019   AM       .5001: in caso di rimpatrio AIRE (anche di altro comune), gestione del tipoScheda '5' con w_servizio_log = 'IMAI'
-- V6.8   del 18/03/2019   AM       .1014: gestione del procedimento amministrativo
--                                  .gestione dell'xml fisso, registrato in ANPCIU_T
-- V6.8.a del 25/03/2019   AM       .3002: gestione campi aggiuntivi RES_ (es. interno2 / NUI)
--                                  .f_xml_indirizzo: gestione del parametro atab.INTERNONUI x switch-are da "interno1" a "nui" (rif. Rivoli)
-- V6.8.b del 29/03/2019   AM       .ws_5000_mutazione_ELE: applicato outer join nella ricerca della revisione
-- V6.8.c del 01/04/2019   AM       .ws_5000_mutazione_MOV: ripristino di CABI pre-subentro. Gestione del tipoMutazione '6'
-- V7.0   del 30/04/2019   AM       .4005: nuova modalit  di acquisizione notifiche
--                                  .3003: nuovo parametro idSchedaSoggettoANPR per consultazione Elenco Operazioni
--                                  .5005: iscrizione da altro comune, famiglie diverse: tipoScheda = '2' (costituzione) solo per Intestatario Scheda
-- V7.0.a del 03/05/2019   AM       .f_xml_cartaIdentita: consolatoRilascio in caso di cod_pro_ente > 199 + nazionalita italiana
-- V7.0.b del 03/05/2019   AM       .ctr_risposta_ok: lettura delle anomolia dal tag listaAnomalie/errore
-- V7.0.c del 05/07/2019   AM       .per archivio_rif 'MOV_RP': gestito caso di famiglia AIRE (rif. Occhiobello)
-- V7.0.d del 19/07/2019   AM       .f_xml_cartaIdentita: eliminazione del testo tra parentesi per la ricerca della sede consolare (rif. Trapani)
-- V7.0.e del 08/08/2019   AM       .5001: modifca rapporto parentela - corretto bug su sel_CF (join su anaana)
-- V7.0.f del 26/08/2019   AM       .f_ANPR_data_atto_rif applicata anche all'atto di vedovanza (rif. San Benedetto Po)
-- V7.0.g del 26/08/2019   AM       .f_ANPR_data_atto_rif: gestione dell'anno_atto diverso dalla data_evento
-- V7.1   del 26/08/2019   AM       .ws_5000_mutazione_ARI: bozza di invio comunizione x mutazione domicilio digitale
-- V7.2   del 28/08/2019   AM       .ins_anpads: aggiornamento idFamigliaANPR x record gi  presenti
-- V7.2.a del 29/08/2019   AM       .5008: generalitaDaModificare.codiceFiscale nullo nel caso di rettifica con valorizzazione del CF
-- V7.3   del 30/08/2019   AM       .gestione del senzaGiorno in tutte le date dove gi  era gestito il senzaGiornoMese
--                                   + aggiunto gestione dei due flag nelle date MAT / VED / UCI / MOR
-- V7.3.a del 13/09/2019   AM       .f_xml_localitaEstera: evitato l'indicazione del tag <Toponimo> nel caso di via_aire nulla (rif. Poggibonsi)
-- V7.3.b del 17/09/2019   AM       .f_xml_indirizzo: tag <Specie> non obbligatorio (rif. Reggello)
-- V7.3.c del 20/09/2019   AM       .ctr_risposta_comune: evitato errore "ORA-06502: PL/SQL: numeric or value error" nel caso w_idFamiglia non numerico
-- V7.4   del 01/10/2019   AM       .ctr_risposta_comune: evitato errore "ORA-06502: PL/SQL: numeric or value error" nel caso w_idFamiglia non numerico
-- V7.5   del 04/11/2019   AM       .3002: acquisizione campo luogoEccezionale
-- V7.5.a del 15/11/2019   AM       .5001_mutazione_FAM: a_archivio_rif 'VIE_x', con indicazione esplicita del tipoMutazione
-- V7.5.b del 14/02/2020   AM       .3002: acquisizione tag "Comune" collegato alla listaElettorale
-- V7.6   del 06/05/2020   AM       .f_xml_cittadinanza: flag "altra cittadinanza" da gestire nei servizi A001 / A002
-- V7.6.a del 18/05/2020   AM       .f_xml_permessoSoggiorno: gestito la variazione di Passaporto
-- V7.7   del 26/05/2020   AM       .3003: nuovo parametro dettaglioElenco
-- V7.7.a del 10/06/2020   AM       .3002: getClobVal x ramo residenza (rif. Sabbioneta)
-- V7.7.b del 22/06/2020   AM       .6001: evitato di inviare il luogoNascita nei datiIntestaraio, in presenza di idANPR (rif. Rubiera)
-- V7.7.c del 27/11/2020   AM       .6001: controllo cognome_nome richiedente. se corrisponde al codice fiscale valorizzo a 3 + 3 caratteri del CF
-- V7.7.d del 15/02/2021   AM       .5008 - divorzio: dataValidita = data_div, in assenza di altre info
-- V7.7.g del 19/02/2021   AM       .5008 - cdf: inserito tag comuneRegistrazione
-- V7.7.h del 20/07/2021   AM       .6001: cognome_nome / codice fiscale richiedente: controllo su CF not null
-- V7.7.h del 20/07/2021   AM       .6001: cognome_nome / codice fiscale richiedente: controllo su CF not null
-- V7.8   del 17/11/2021   AM       .f_xml_listaElettorale: inserito tag <comune>
-- V8.0   del 18/11/2021   AM       .P001/P002/P003: nuovi servizi cittadino (P000) - solo gestione request
-- V8.0.a del 30/11/2021   AM       .f_xml_luogoEvento: gestione CODICE_MIN per territori (es. BERMUDA / REGNO UNITO)
-- V8.1   del 24/01/2022   AM       .P001/P002/P003: gestione response OK
-- V8.1.a del 27/01/2022   AM       .3002: anpciu_par con id_scheda_anpr valorizzato e tipo_scheda_anpr null, esegue ricerca individuo
-- V8.2   del 04/02/2022   AM       .richiesta_notifiche: aggiunta richieste per servizio P001
-- V8.3   del 10/03/2022   AM       .5001_mutazione_FAM: a_archivio_rif 'VIE_9', esteso gestione alle famiglie AIRE
-- V8.4   del 11/10/2022   AM       .gestione dell'xml fisso, registrato in ANPXML
-- V8.4.a del 24/01/2023   AM       .P000: gestione del parametro ORA-31167 (rif. Valeggio)
-- V8.4.b del 23/03/2023   AM       .1000: gestione dataDefinizione in base al parametro 1014_RES_I
-- V8.4.c del 07/07/2023   AM       .5000: gestione soggettoAIRE nel caso di cod_mov '98'
-- V8.4.d del 19/07/2023   AM       .5008: eliminato tag tipoCessazione del gruppo scioglimentoUnione
-- V8.4.e del 20/07/2023   AM       .f_xml_divorzio: popolamento dati "sentenza" anche in assenza di provvedimento in anasen
-- V9.0   del 19/06/2023   AM       .f_xml_listaElettorale: nuova integrazione con servizi 5010 e 5011 (17/06/2022)
--                                  .3002: nuovi dati elettorali - codDestinatario ANPR03 (17/06/2022)
--                                  .E001: subentro liste elettorali (12/12/2022)
--                                  .3002: nuovi campi ANSC (13/12/2022)
--                                  .f_xml_atto_anpr: nuovi tag ANSC (22/12/2022)
--                                  .5010: gestione tipoConsultazione/dataCancellazioneLista (13/01/2023)
--                                  .N017: nuovo servizio notifica x liste elettorali (01/02/2023)
--                                  .5010/5011: uso formalismi per collegi / circoscrizioni (03/02/2023)
--                                  .5010: archivio_rif 'PSE' per gestione certificabilita (09/02/2023)
--                                  .3002: nuovo campo idANPR (13/06/2023)
--                                  .NA00/NA01/NA02/NA03/NA04/NA05: nuovi servizi di notifica eventi ANSC (16/06/2023)
--                                  .upd_anpads_id_unico: x salvataggio id_unico_anpr (19/06/2023)
-- V9.0.a del 08/08/2023   AM     .E001: subentro elettori sospesi
-- V9.0.b del 09/08/2023   AM     .E001: subentro elettori sospesi - correzione flag / certificabilit 
-- V9.0.c del 08/09/2023   AM     .f_xml_listaElettorale: gestito solo in assenza di ANEL
-- V9.0.d del 02/11/2023   AM     .f_xml_listaElettorale: gestito solo in assenza di ANEL
-- V9.0.e del 11/12/2023   AM     .NA00: idNotifica + dati SEP_ x separazione
-- V9.1   del 28/12/2023   AM     .6001: tipoFirmaElettorale
-- V9.1.a del 26/03/2024   AM     .NA00: typo numeroComunale
-- V9.2   del 28/03/2024   AM     .NA00: nuovi campi in ANPNA0
-- V9.2.a del 03/04/2024   AM     .5008: tag "unioneCivile" nel caso di stato civile in ('VU','GU')
--                                .5008. tag "matrimonio" nal caso di stato civile 'VU' + tag "vedovanza"
--                                .f_UTIL_leggi_campo_xml
-- V9.3   del 02/05/2024   AM     .NA00: nuovi campi in ANPNA0 (residenza / nazionalita)
-- V9.3.1 del 29/05/2024   AM     .5001: tipoMutazione '5' per aggiornamento PT e CC
-- V9.3.2 del 04/12/2024   AM     .6001: docRiconoscimento (nuovi campi da cercem)
-- V9.3.4 del 22/10/2025   AM     .3002: idUnicoAnpr recuperato da ANPCIU_PAR
-- V9.3.5 del 01/12/2025   AM     .NA00: nuovi campi in ANPNA0 (evento/trascrizione)
-- V9.3.6 del 11/12/2025   AM     .NA00: nuovi campi in ANPNA0 (evento/separazione/accordoSeparazione)
-- V9.3.7 del 21/01/2026   AM     .5010: tipoMutazione '4' solo per archivio_rif 'PSE'
-- V9.4.0 del 29/05/2026   AM     .f_xml_indirizzo_esteso: gestione nuovi campi per civico esterno / civico interno
-- V9.4.1 del 06/07/2026   AM     .5010: elettorale - fix fine tag "datiControllo"
--

  w_versione := 'V9.4.1 del 06/07/2026';

  return w_versione;
end;

procedure dati_cliente
is

w_count_dco		number;

w_servizio_log		varchar2(255);
w_operazione_log	varchar2(255) := 'dati_cliente';

w_errore		varchar2(4000);
errore			exception;

begin
  w_codDestinatario := nvl(f_ANPR_valore_inp('COD_DEST',1,10,'X','S'),'ANPR00');

  begin
    select m.cod_provincia
         , m.cod_Comune
         , lpad(m.cod_provincia,3,'0')||lpad(m.cod_Comune,3,'0')
         , m.descrizione
         , m.sigla_provincia
         , lpad(m.cap,5,'0')
      into w_cod_pro_cliente
         , w_cod_com_cliente
         , w_codice_cliente
         , w_des_com_cliente
         , w_sigla_pro_cliente
         , w_cap_cliente
      from arccom m, anpinp inp
     where (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
       and inp.parametro = 'TIPO_INVIO'
       and inp.valore    != 'TEST'
    UNION
    select m.cod_provincia
         , m.cod_Comune
         , lpad(m.cod_provincia,3,'0')||lpad(m.cod_Comune,3,'0')
         , 'FAENZA'
         , m.sigla_provincia
         , lpad(m.cap,5,'0')
      from arccom m, anpinp inp
     where (m.cod_provincia, m.cod_comune) = (select 39, 10 from menuditta
                                                where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') in ('039010','025006'))
       and inp.parametro = 'TIPO_INVIO'
       and inp.valore    = 'TEST'
    UNION
    select m.cod_provincia
         , m.cod_Comune
         , lpad(m.cod_provincia,3,'0')||lpad(m.cod_Comune,3,'0')
         , m.descrizione
         , m.sigla_provincia
         , lpad(m.cap,5,'0')
      from arccom m, anpinp inp
     where (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta
                                                where lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0') not in ('039010','025006'))
       and inp.parametro = 'TIPO_INVIO'
       and inp.valore    = 'TEST'
    ;
  exception
    when others then
         w_errore := 'errore in dati_cliente ('||SQLERRM||')';
         raise errore;
  end;

  begin
    select MAX(versione)
      into w_versione_applicativo
      from ad4_istanze
     where progetto = 'DE4GSD'
       AND USER_ORACLE = USER
       and rownum  = 1
    ;
    w_versione_applicativo := f_ANPR_stringa(w_versione_applicativo||' - '||ANPR_pkg.versione,'/@');
  exception
    when others then
         w_errore := 'errore in ad4_istanze ('||SQLERRM||')';
         raise errore;
  end;

  begin
    select to_char(to_date(substr(dataoperativitaanpr,1,10),'yyyy-mm-dd'),'j')
      into w_data_subentro
      from anpn31
     where ric_codiceistat = w_codice_cliente
       and rownum  = 1
    ;
  exception
    when others then
         w_data_subentro := '';
  end;

  begin
    select count(distinct dco.collegio)
      into w_count_dco
      from eledco dco, eledte dte
     where dco.tipo_elezione   = dte.cod_te
       and dte.rif_tessera_ele = 6
    ;
  exception
    when others then
         w_count_dco := 0;
  end;

  if w_count_dco > 0 then
     w_flag_circoscrizionali := 'S';
  else
     w_flag_circoscrizionali := 'N';
  end if;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end dati_cliente;

procedure ins_anpads
(a_servizio		varchar2
,a_matricola		number
,a_matricola_aire       varchar2
,a_fascia 		number
,a_tipo_fam	 	number
,a_cod_fam 		number
,a_tipo_scheda_anpr 	varchar2
,a_flag_subentro 	varchar2	default null
,a_allegato_clob 	clob		default null
,a_num_componenti_anpr  number          default null
,a_rapporto_par_anpr    varchar2        default null
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ins_anpads';

w_errore		varchar2(4000);
errore			exception;

begin
  if a_tipo_scheda_anpr in ('Individuale','Aire') then
     begin
       insert into anpads (matricola_ads, id_scheda_aire, tipo_scheda_anpr, flag_subentro, allegato_clob)
       select a_matricola, a_matricola_aire, a_tipo_scheda_anpr, a_flag_subentro, a_allegato_clob
         from dual
        where not exists (select 'x' from anpads b
                           where b.matricola_ads    = a_matricola
                             and b.tipo_scheda_anpr in ('Individuale','Aire'))
       ;
     exception
       when others then
            w_errore := 'Errore in ins ANPADS - '||a_tipo_scheda_anpr||' '||a_matricola||' ('||sqlerrm||')';
            raise errore;
     end;

  elsif a_tipo_scheda_anpr in ('Famiglia','Convivenza','Famiglia AIRE') then
     begin
       delete anpads
        where fascia_ads          = a_fascia
          and nvl(tipo_fam_ads,0) = nvl(a_tipo_fam,0)
          and cod_fam_ads         = a_cod_fam
          and tipo_scheda_anpr    = a_tipo_scheda_anpr
       ;
       insert into anpads (matricola_ads, fascia_ads, tipo_fam_ads, cod_fam_ads, tipo_scheda_anpr, flag_subentro, allegato_clob)
       values (a_matricola, a_fascia, a_tipo_fam, a_cod_fam, a_tipo_scheda_anpr, a_flag_subentro, a_allegato_clob)
       ;
     exception
       when others then
            w_errore := 'Errore in ins ANPADS - '||a_tipo_scheda_anpr||' '||a_cod_fam||' ('||sqlerrm||')';
            raise errore;
     end;

  elsif a_tipo_scheda_anpr in ('Famiglia ANPR') then
     begin
       delete anpads
        where matricola_ads    = a_matricola
          and tipo_scheda_anpr = a_tipo_scheda_anpr
       ;
       insert into anpads (matricola_ads, tipo_scheda_anpr, id_scheda_anpr, num_componenti_anpr, rapporto_par_anpr)
       values (a_matricola, a_tipo_scheda_anpr, a_cod_fam, a_num_componenti_anpr, a_rapporto_par_anpr)
       ;
     exception
       when others then
            w_errore := 'Errore in ins ANPADS - '||a_tipo_scheda_anpr||' '||a_cod_fam||' ('||sqlerrm||')';
            raise errore;
     end;

  end if;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end ins_anpads;

procedure upd_anpads
(a_servizio		varchar2
,a_matricola		varchar2
,a_id_soggetto_anpr	number
,a_id_famiglia_anpr	number
,a_famiglia_aire 	varchar2
,a_cod_fiscale_AE 	varchar2
,a_validita_cf_AE 	number
,a_data_validita_cf_AE 	varchar2
)

is

w_matricola             number;
w_matricola_aire        varchar2(255);

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'upd_anpads';

w_errore		varchar2(4000);
errore			exception;

begin
  if a_servizio != '1010' then
     if translate(a_matricola,'0123456789','9999999999') in ('9','99','999','9999','99999','999999','9999999') then
        w_matricola      := a_matricola;
        w_matricola_aire := '';
     else
        w_matricola      := '';
        w_matricola_aire := a_matricola;
     end if;

     begin
       update anpads
          set cod_fiscale_ae      = a_cod_fiscale_ae
            , validita_cf_ae      = a_validita_cf_ae
            , data_validita_cf_ae = substr(a_data_validita_cf_ae,1,10)
        where tipo_scheda_anpr in ('Individuale','Aire')
          and id_scheda_anpr   = a_id_soggetto_anpr
       ;
       if sql%notfound then
          w_errore := 'Errore in upd ANPADS - soggetto non trovato x id__ANPR (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
--          ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);

          if w_matricola is not null then
             begin
               update anpads
                  set id_scheda_anpr      = a_id_soggetto_anpr
                    , cod_fiscale_ae      = a_cod_fiscale_ae
                    , validita_cf_ae      = a_validita_cf_ae
                    , data_validita_cf_ae = substr(a_data_validita_cf_ae,1,10)
                where tipo_scheda_anpr        in ('Individuale','Aire')
                  and matricola_ads           = w_matricola
               ;
               if sql%notfound then
                  raise no_data_found;
               end if;
             exception
               when others then
                    w_errore := 'Errore in upd ANPADS - soggetto non trovato x matricola (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
                    raise no_data_found;
             end;
          elsif w_matricola_aire is not null then
             begin
               update anpads
                  set id_scheda_anpr      = a_id_soggetto_anpr
                    , cod_fiscale_ae      = a_cod_fiscale_ae
                    , validita_cf_ae      = a_validita_cf_ae
                    , data_validita_cf_ae = substr(a_data_validita_cf_ae,1,10)
                where tipo_scheda_anpr    in ('Individuale','Aire')
                  and id_scheda_aire      = w_matricola_aire
               ;
               if sql%notfound then
                  raise no_data_found;
               end if;
             exception
               when others then
                    w_errore := 'Errore in upd ANPADS - soggetto non trovato x matricola_aire (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
                    raise no_data_found;
             end;
          else
             w_errore := 'Errore in upd ANPADS - soggetto non trovato (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
             raise no_data_found;
          end if;
       end if;
     exception
       when no_data_found then
            raise errore;
       when others then
            w_errore := 'Errore in upd ANPADS - Individuale (matricola: '||a_matricola||' - id_soggetto_ANPR: '||a_id_soggetto_ANPR||')';
            raise no_data_found;
     end;

     if w_matricola is null then
        begin
          select matricola_ads
            into w_matricola
            from anpads
           where tipo_scheda_anpr in ('Individuale','Aire')
             and id_scheda_anpr   = a_id_soggetto_anpr
             and rownum = 1
          ;
        exception
          when others then
               w_matricola := '';
        end;
     end if;

     if w_matricola is not null then
        begin
          update anpads
             set id_scheda_anpr = a_id_famiglia_anpr
           where tipo_scheda_anpr         = 'Famiglia'
             and nvl(a_famiglia_aire,'N') = 'N'
             and matricola_ads            = w_matricola
             and cod_fam_ads              is not null
          ;
        exception
          when others then
               w_errore := 'Errore in upd ANPADS - Famiglia x matricola (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
               raise no_data_found;
        end;
        begin
          update anpads
             set id_scheda_anpr = a_id_famiglia_anpr
           where tipo_scheda_anpr         = 'Famiglia AIRE'
             and nvl(a_famiglia_aire,'N') = 'S'
             and matricola_ads            = w_matricola
             and cod_fam_ads              is not null
          ;
        exception
          when others then
               w_errore := 'Errore in upd ANPADS - Famiglia AIRE x matricola (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
               raise no_data_found;
        end;

     elsif w_matricola_aire is not null then
        begin
          update anpads
             set id_scheda_anpr = a_id_famiglia_anpr
           where tipo_scheda_anpr         = 'Famiglia'
             and nvl(a_famiglia_aire,'N') = 'N'
             and id_scheda_aire           = w_matricola_aire
             and cod_fam_ads              is not null
          ;
        exception
          when others then
               w_errore := 'Errore in upd ANPADS - Famiglia x matricola_aire (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
               raise no_data_found;
        end;
        begin
          update anpads
             set id_scheda_anpr = a_id_famiglia_anpr
           where tipo_scheda_anpr         = 'Famiglia AIRE'
             and nvl(a_famiglia_aire,'N') = 'S'
             and id_scheda_aire            = w_matricola_aire
             and cod_fam_ads              is not null
          ;
        exception
          when others then
               w_errore := 'Errore in upd ANPADS - Famiglia AIRE x matricola_aire (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
               raise no_data_found;
        end;
     end if;

  elsif a_servizio = '1010' then
     begin
       update anpads
          set id_scheda_anpr = a_id_famiglia_anpr
        where tipo_scheda_anpr         = 'Convivenza'
          and cod_fam_ads              = a_matricola
          and fascia_ads               = 1
          and tipo_fam_ads             = 1
   --       and id_scheda_anpr           is null
       ;
     exception
       when others then
            w_errore := 'Errore in upd ANPADS - Famiglia (cod_fam: '||a_matricola||' - id_famiglia_ANPR: '||a_id_famiglia_ANPR||')';
            raise no_data_found;
     end;

  end if;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end upd_anpads;

procedure upd_anpads_5001
(a_servizio     varchar2
,a_cod_mov      number
,a_cod_eve      number
,a_matricola    number
,a_cod_fam      number
,a_cod_fam_aire number)

is

w_idFam_ANPR            number;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'upd_anpads_5001';

w_errore		varchar2(4000);
errore			exception;

begin
  if a_servizio = '5001' and a_cod_mov = 1 then
     if a_cod_eve = 4 then
        begin
          select id_scheda_anpr
            into w_idFam_ANPR
            from anpads
           where fascia_ads       = 3
             and cod_fam_ads      = a_cod_fam_aire
             and tipo_scheda_anpr = 'Famiglia AIRE'
          ;
        exception
          when others then
               w_idFam_ANPR := '';
        end;
     elsif a_cod_eve != 4 then
        begin
          select id_scheda_anpr
            into w_idFam_ANPR
            from anpads
           where matricola_ads    = a_matricola
             and tipo_scheda_anpr = 'Famiglia ANPR'
          ;
        exception
          when others then
               w_idFam_ANPR := '';
        end;
     end if;

     if w_idFam_ANPR is not null then
        begin
          delete anpads
           where matricola_ads    = a_matricola
             and tipo_scheda_anpr = 'Famiglia'
          ;
          insert into anpads
                 ( MATRICOLA_ADS, FASCIA_ADS, TIPO_FAM_ADS, COD_FAM_ADS, TIPO_SCHEDA_ANPR, ID_SCHEDA_ANPR )
          values ( a_matricola, 1, '', a_cod_fam, 'Famiglia', w_idFam_ANPR )
          ;
        exception
          when others then
               w_errore := 'Errore in inserimento ANPADS - Famiglia ('||SQLERRM||')';
               raise errore;
        end;
     end if;
  end if;
exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end upd_anpads_5001;

procedure upd_anpads_id_unico
(a_servizio		varchar2
,a_matricola		varchar2
,a_id_soggetto_anpr	number
,a_id_unico_anpr	varchar2
)

is

w_matricola             number;
w_matricola_aire        varchar2(255);

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'upd_anpads_id_unico';

w_errore		varchar2(4000);
errore			exception;

begin
  if a_servizio != '1010' then
     if translate(a_matricola,'0123456789','9999999999') in ('9','99','999','9999','99999','999999','9999999') then
        w_matricola      := a_matricola;
        w_matricola_aire := '';
     else
        w_matricola      := '';
        w_matricola_aire := a_matricola;
     end if;

     begin
       update anpads
          set id_unico_anpr = a_id_unico_anpr
        where tipo_scheda_anpr in ('Individuale','Aire')
          and id_scheda_anpr   = a_id_soggetto_anpr
       ;
       if sql%notfound then
          w_errore := 'Errore in upd ANPADS (id_unico) - soggetto non trovato x id__ANPR (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
--          ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);

          if w_matricola is not null then
             begin
               update anpads
                  set id_unico_anpr = a_id_unico_anpr
                where tipo_scheda_anpr        in ('Individuale','Aire')
                  and matricola_ads           = w_matricola
               ;
               if sql%notfound then
                  raise no_data_found;
               end if;
             exception
               when others then
                    w_errore := 'Errore in upd ANPADS (id_unico) - soggetto non trovato x matricola (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
                    raise no_data_found;
             end;
          elsif w_matricola_aire is not null then
             begin
               update anpads
                  set id_unico_anpr = a_id_unico_anpr
                where tipo_scheda_anpr    in ('Individuale','Aire')
                  and id_scheda_aire      = w_matricola_aire
               ;
               if sql%notfound then
                  raise no_data_found;
               end if;
             exception
               when others then
                    w_errore := 'Errore in upd ANPADS - soggetto non trovato x matricola_aire (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
                    raise no_data_found;
             end;
          else
             w_errore := 'Errore in upd ANPADS (id_unico) - soggetto non trovato (matricola: '||w_matricola||' - matricola_aire: '||w_matricola_aire||' - id_ANPR: '||a_id_soggetto_ANPR||')';
             raise no_data_found;
          end if;
       end if;
     exception
       when no_data_found then
            raise errore;
       when others then
            w_errore := 'Errore in upd ANPADS (id_unico) - Individuale (matricola: '||a_matricola||' - id_soggetto_ANPR: '||a_id_soggetto_ANPR||')';
            raise no_data_found;
     end;

  end if;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end upd_anpads_id_unico;

procedure ins_log
(a_servizio 	varchar2
,a_operazione   varchar2
,a_note 	varchar2
,a_campo_clob 	clob	default null
)

is

w_id			number;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ins_log';

w_errore		varchar2(4000);
errore			exception;

begin
  if w_servizio_log in ('S001','E001') then
     goto fine;
  end if;

  begin
    select ANPR_LOG_SQ.nextval
      into w_id
      from dual
    ;
  end;

  begin
    insert into anpr_log (id, data_ora, servizio, operazione, note, campo_clob)
    values (w_id, sysdate, w_servizio_log, a_operazione, a_note, a_campo_clob)
    ;
--COMMIT;
  exception
    when others then
         raise errore;
  end;
<< fine >>
null;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       begin
         insert into anpr_log (id, data_ora, servizio, operazione, note, campo_clob)
         values (w_id, sysdate, w_servizio_log, w_operazione_log, a_note, a_campo_clob)
         ;
       end;
end ins_log;

procedure del_allegati
(a_servizio 		varchar2
,a_chiave		number 	default NULL
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'del_allegati';

w_errore		varchar2(4000);
errore			exception;

begin
  if a_chiave is not null then
     begin
       delete anpr_allegati
        where servizio   = a_servizio
          and chiave     = a_chiave
       ;
     exception
       when others then
            w_errore := 'errore in del anpr_allegati - x chiave ('||SQLERRM||')';
            raise errore;
     end;
  else
     begin
       delete anpr_allegati
        where servizio   = a_servizio
          and session_id = userenv('sessionID')
       ;
     exception
       when others then
            w_errore := 'errore in del anpr_allegati - x sessionID ('||SQLERRM||')';
            raise errore;
     end;
  end if;

--COMMIT;
exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end del_allegati;

procedure ins_allegati
(a_servizio 		varchar2
,a_chiave		number
,a_nome_allegato	varchar2
,a_allegato_clob 	clob
,a_flag_base64		varchar2	default NULL
)

is

w_id			number;

w_allegato_blob		blob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ins_allegati';

w_errore		varchar2(4000);
errore			exception;

begin
  if nvl(a_flag_base64,'N') = 'S' then
--     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'bas64 - prima');
     w_allegato_blob := ANPR_pkg.DECODE_BASE64(a_allegato_clob);
--     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'bas64 - dopo');
  end if;

  begin
    insert into anpr_allegati (session_id, servizio, chiave, nome_allegato, allegato_clob, allegato_blob)
    values (userenv('sessionID'), a_servizio, a_chiave, a_nome_allegato, a_allegato_clob, w_allegato_blob)
    ;
  exception
    when others then
         w_errore := 'errore in ins anpr_allegati ('||SQLERRM||')';
         raise errore;
  end;

--COMMIT;
exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end ins_allegati;

procedure upd_allegati
(a_servizio 		varchar2
,a_chiave		number
,a_tag_substr	varchar2
,a_flag_base64		varchar2	default NULL
)

is

w_id			number;

w_tag_substr_in		varchar2(255) := '<'||a_tag_substr||'>';
w_tag_substr_fi		varchar2(255) := '</'||a_tag_substr||'>';

w_allegato_clob		clob;
w_allegato_blob		blob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'upd_allegati';

w_errore		varchar2(4000);
errore			exception;

begin

  begin
    select substr(substr(allegato_clob,instr(allegato_clob,w_tag_substr_in)+9), 1, instr(allegato_clob,w_tag_substr_fi)-1)
      into w_allegato_clob
      from anpr_allegati
     where chiave = a_chiave
       and session_id = userenv('sessionID')
    ;
  exception
    when others then
         w_errore := 'errore upd_allegati - 1 ('||sqlerrm||')';
         raise errore;
  end;

  begin
    select substr(w_allegato_clob, 1, instr(w_allegato_clob,w_tag_substr_fi)-1)
      into w_allegato_clob
      from anpr_allegati
     where chiave = a_chiave
       and session_id = userenv('sessionID')
    ;
  exception
    when others then
         w_errore := 'errore upd_allegati - 2 ('||sqlerrm||')';
         raise errore;
  end;

  if nvl(a_flag_base64,'N') = 'S' then
--     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'bas64 - prima');
     w_allegato_blob := ANPR_pkg.DECODE_BASE64(w_allegato_clob);
--     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'bas64 - dopo');
  end if;

  begin
    delete anpr_allegati
     where chiave = a_chiave
    ;
    insert into anpr_allegati (session_id, servizio, chiave, nome_allegato, allegato_clob, allegato_blob)
    values (userenv('sessionID'), a_servizio, a_chiave, '', w_allegato_clob, w_allegato_blob)
    ;
  exception
    when others then
         w_errore := 'errore in ins anpr_allegati ('||SQLERRM||')';
         raise errore;
  end;

--COMMIT;
exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end upd_allegati;

procedure valida_xml
(a_servizio 		varchar2
,a_allegato_clob 	clob
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'valida_xml';

w_xml			xmltype;

w_errore		varchar2(4000);
errore			exception;

begin
  begin
    w_xml := xmltype(a_allegato_clob);
  exception
    when others then
         w_errore := 'errore in validazione xml ('||SQLERRM||')';
         raise errore;
  end;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end valida_xml;

procedure attivazione_ws
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
,a_matricola 		number
,a_fascia_fam 		number
,a_cod_fam 		number
,a_id_anadoc 		number
,a_id_anamsi 		number
,a_archivio_rif 	varchar2
,a_terminalista 	varchar2
,w_id_ANPR 		OUT 	number
,w_esito_ANPR 		OUT 	varchar2
,w_flag_errore		OUT	varchar2
,w_flag_anomalia	OUT	varchar2
,w_xml_richiesta	OUT 	clob
,w_xml_risposta		OUT 	clob
,a_note		 	varchar2 	default NULL
)

--return varchar2

is

w_servizio		varchar2(255) := a_servizio;
w_archivio_rif		varchar2(255);

w_testata_richiesta	clob;

w_id_operatore		varchar2(255);
w_url_servizio		varchar2(255);

w_service_url		varchar2(255);
w_service_name		varchar2(255);
w_service_ns		varchar2(255);

w_chiave		varchar2(255);

w_request_clob		clob;
w_response_clob		clob;

w_xml_richiesta_t       clob;
w_xml_import		number;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'attivazione_ws';

w_errore		varchar2(4000);
errore			exception;

begin
  ANPR_pkg.dati_cliente;

  begin
    w_xml_richiesta_t := f_ANPR_esporta_xml(a_id_operazione);
    if instr(w_xml_richiesta_t,'<') = 0 then
       w_xml_richiesta_t := null;
    end if;
  exception
    when others then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore esporta_xml');
         w_xml_richiesta_t := null;
  end;

  if w_xml_richiesta_t is not null then
     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'xml_richiesta_t not null');
     w_request_clob := w_xml_richiesta_t;
     goto esegui_request;
  end if;

  if w_servizio in ('1001','1002') then
     w_request_clob := ANPR_pkg.ws_1000_iscrizione_apr(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif);

  elsif w_servizio in ('1010') then
     w_request_clob := ANPR_pkg.ws_1010_iscrizione_FAM(w_servizio,a_id_operazione,a_tipo_operazione,a_fascia_fam,a_cod_fam);

  elsif w_servizio in ('1013') then
     w_request_clob := ANPR_pkg.ws_1013_ann_iscrizione(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif);

  elsif w_servizio in ('1014') then
     w_request_clob := ANPR_pkg.ws_1014_procedimento(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif,a_matricola);

  elsif w_servizio in ('A001','A002','A006') then
     w_request_clob := ANPR_pkg.ws_A000_iscrizione_aire(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif);

  elsif w_servizio in ('2001','2003') then
     w_request_clob := ANPR_pkg.ws_2000_cancellazione_apr(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif);

  elsif w_servizio in ('2009') then
     w_request_clob := ANPR_pkg.ws_2009_cancellazione_FAM(w_servizio,a_id_operazione,a_tipo_operazione,a_fascia_fam,a_cod_fam);

  elsif w_servizio in ('2011') then
     w_request_clob := ANPR_pkg.ws_2011_ann_cancellazione(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif);

  elsif w_servizio in ('3002','3003') then
     w_chiave := a_matricola;
     w_request_clob := ANPR_pkg.ws_3000_consultazione(w_servizio,a_id_operazione,a_tipo_operazione,w_chiave,a_archivio_rif);

  elsif w_servizio in ('4001','4002','4003') then
     w_request_clob := ANPR_pkg_4000.ws_4000_estrazione(w_servizio,a_id_operazione,a_tipo_operazione,a_numero_rif,a_archivio_rif);

  elsif w_servizio in ('5001','5005','5008','5010','5011','5014') then
     w_request_clob := ANPR_pkg.ws_5000_mutazione(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif,a_id_anadoc,a_id_anamsi,a_matricola,a_fascia_fam,a_cod_fam,a_archivio_rif);

  elsif w_servizio in ('5013') then
     w_request_clob := ANPR_pkg.ws_5013_revoca(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif,a_id_anadoc,a_id_anamsi,a_matricola,a_cod_fam,a_archivio_rif);

  elsif w_servizio in ('5012') then
     w_archivio_rif := a_archivio_rif;
     if w_codDestinatario >= 'ANPR03' and (a_archivio_rif like 'ELE%' or a_archivio_rif like 'ELA%') then	-- annullamento mutazione 5010 (liste elettorali)
        w_servizio     := '5010';
        w_servizio_log := '5010';
        w_archivio_rif := w_archivio_rif||'_ANN';
     end if;
     w_request_clob := ANPR_pkg.ws_5012_ann_mutazione(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif,a_id_anadoc,a_id_anamsi,a_matricola,a_fascia_fam,a_cod_fam,w_archivio_rif);

  elsif w_servizio in ('6001') then
     w_request_clob := ANPR_pkg.ws_6001_certificazione(w_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif);

  elsif w_servizio in ('7001') then
     w_request_clob := ANPR_pkg.ws_7001_scarico_tabelle(w_servizio,a_id_operazione,a_tipo_operazione,a_numero_rif,a_archivio_rif);

  elsif w_codDestinatario = 'ANPR01' and w_servizio in ('3005','3007','N010','N014','N015','N017','N030','N031','NRIS') then
     if w_servizio = '3005' then
        w_chiave := a_numero_rif;
     else
        w_chiave := a_matricola;
     end if;
     w_request_clob := ANPR_pkg.ws_3000_consultazione(w_servizio,a_id_operazione,a_tipo_operazione,w_chiave,a_archivio_rif);
     if w_servizio in ('3007','N010','N014','N015','N017','N030','N031','NRIS') then
        w_servizio := '3003';
     end if;

  elsif w_codDestinatario != 'ANPR01' and w_servizio in ('3005','3007','N010','N014','N015','N017','N030','N031','NRIS','NA00','NA01','NA02','NA03','NA04','NA05') then
     w_chiave := a_numero_rif;
     if w_servizio = '3005' then
        w_servizio := '7002';
        w_request_clob := ANPR_pkg.ws_7002_download_file(w_servizio,a_id_operazione,a_tipo_operazione,w_chiave,a_archivio_rif);
     else
        w_request_clob := ANPR_pkg_4000.ws_4005_consultazione(w_servizio,a_id_operazione,a_tipo_operazione,w_chiave,a_archivio_rif);
        w_servizio := '4005';
     end if;

  elsif w_servizio in ('P001','P002','P003') then
     w_chiave := a_numero_rif;
     w_request_clob := ANPR_pkg_P000.ws_P000_servizi_cittadino(w_servizio,a_id_operazione,a_tipo_operazione,w_chiave,a_archivio_rif,a_terminalista,a_note);

  end if;

<< esegui_request >>

  begin
    w_xml_import := f_anpr_importa_xml(a_id_operazione,w_request_clob);
    ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'importa_xml: '||w_xml_import);
  exception
    when others then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore importa_xml');
  end;

  w_ws_client    := f_ANPR_valore_inp('WS_CLIENT',1,255,'X','');
  w_id_operatore := f_ANPR_id_operatore(a_terminalista);
  w_url_servizio := f_ANPR_url_servizio(w_servizio);

  w_service_url := w_ws_client||'/service?'||
                   'richiesta='||w_servizio||
                   '&operatore='||w_id_operatore||
                   '&wsdl='||w_url_servizio;

  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'request '||w_servizio_log, w_request_clob);
  w_response_clob := ANPR_pkg.WS_REQUEST(w_service_url, w_service_name, w_service_ns, w_request_clob, '');
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'response '||w_servizio_log, w_response_clob);

<< risposta_ko>>
  ANPR_pkg.ctr_risposta_ko(w_servizio,a_id_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_errore);
  if w_esito_ANPR is not null then
     goto fine;
  end if;

<< risposta_ok >>
  if w_servizio in ('1001','1002','1010','1013','1014','A001','A002','A006','2001','2003','2009','2011','5001','5005','5008','5010','5011','5012','5013','5014') then
     ANPR_pkg.ctr_risposta_comune(w_servizio_log,a_id_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia);

  elsif w_servizio in ('3002','3003') then
     ANPR_pkg.ctr_risposta_ok(w_servizio_log,a_id_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia,w_chiave);

  elsif w_servizio in ('6001') then
     w_chiave := a_anno_rif||lpad(a_numero_rif,6,'0');
     ANPR_pkg.ctr_risposta_ok(w_servizio_log,a_id_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia,w_chiave);

  elsif w_servizio in ('4001','4003','4005') then
     ANPR_pkg_4000.ctr_risposta_multipla(w_servizio,a_id_operazione,a_tipo_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia,a_numero_rif,a_archivio_rif);
     w_flag_errore := '';
     if w_esito_ANPR = 'XXXX' then
        w_flag_errore := 'S';
     end if;

  elsif w_servizio in ('7001','7002') then
--     ANPR_pkg.ctr_risposta_ok(w_servizio,a_id_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia,w_chiave);
     ANPR_pkg_4000.ctr_risposta_multipla(w_servizio,a_id_operazione,a_tipo_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia,a_numero_rif,a_archivio_rif);

  elsif w_codDestinatario = 'ANPR01' and w_servizio in ('3005','3007','N010','N014','N015','N017','N030','N031','NRIS') then
     if w_servizio = '3005' then
        w_chiave := a_numero_rif;
     else
        w_chiave := a_matricola;
     end if;
     ANPR_pkg.ctr_risposta_ok(w_servizio,a_id_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia,w_chiave);

  elsif w_codDestinatario != 'ANPR01' and w_servizio in ('3005','3007','N010','N014','N015','N017','N030','N031','NRIS','NA00','NA01','NA02','NA03','NA04','NA05') then
     if w_servizio = '3005' then
        w_chiave := a_numero_rif;
     else
        w_chiave := a_matricola;
     end if;
     ANPR_pkg_4000.ctr_risposta_multipla(w_servizio,a_id_operazione,a_tipo_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia,w_chiave,a_archivio_rif);
     w_flag_errore := '';
     if w_esito_ANPR = 'XXXX' then
        w_flag_errore := 'S';
     end if;

  elsif w_servizio in ('P001','P002','P003') then
     ANPR_pkg_P000.ctr_risposta_ok(w_servizio,a_id_operazione,w_response_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia,w_chiave);

  end if;

<< fine >>
  w_xml_richiesta := w_request_clob;
  w_xml_risposta  := w_response_clob;

--  return w_response_clob;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end attivazione_ws;

procedure ctr_risposta_ko
(a_servizio 		varchar2
,a_id_operazione	number
,a_campo_clob 		clob
,w_id_ANPR 	OUT 	number
,w_esito_ANPR 	OUT 	varchar2
,w_flag_errore	OUT	varchar2)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ctr_risposta_ko';

w_xml			xmltype;
w_xml_clob		clob;

w_extract_str 		varchar2(255);
w_extract_str_1		varchar2(255);
w_extract_str_2  	varchar2(255);
w_extract_str_3		varchar2(255);
w_extract_str_4		varchar2(255);
w_extract_str_5  	varchar2(255);
w_extract_str_6  	varchar2(255);
w_estract_str_7		varchar2(255);
w_estract_str_8		varchar2(255);
w_estract_str_9		varchar2(255);
w_estract_str_10	varchar2(255);

w_id_soggetto		number;
w_id_soggetto_ANPR	number;
w_id_famiglia		number;
w_id_famiglia_ANPR	number;

w_codice_errore		varchar2(255);
w_tipo_errore		varchar2(255);
w_testo_errore		varchar2(255);

cursor sel_testata (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/idOperazioneANPR') idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/esitoOperazione') esitoOperazioneANPR
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_errori (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/codiceErroreAnomalia') codiceErrore
     , extractValue(value(rowdata),w_root||'/tipoErroreAnomalia') tipoErrore
     , extractValue(value(rowdata),w_root||'/testoErroreAnomalia') testoErrore
  from table(XMLSequence(w_xml)) rowdata
;

w_errore		varchar2(4000);
errore			exception;

begin
  if a_servizio = '6001' and nvl(w_ora_31167,'N') = 'S' then	-- Porto Azzurro
     if a_campo_clob like '%Risposta6001OK%certificatoPdf%' then
        goto fine;
     end if;
  elsif a_servizio = 'P002' and nvl(w_ora_31167,'N') = 'S' then	-- Valeggio
     goto fine;
  end if;

  begin
    select tws.risposta_ko_str,
           tws.risposta_ko_str_1, tws.risposta_ko_str_2, tws.risposta_ko_str_3, tws.risposta_ko_str_4, tws.risposta_ko_str_5
      into w_extract_str, w_extract_str_1, w_extract_str_2, w_extract_str_3, w_extract_str_4, w_extract_str_5
      from anptws tws
     where codice = a_servizio
    ;
  exception
    when others then
         w_extract_str   := '';
         w_extract_str_1 := '';
         w_extract_str_2 := '';
         w_extract_str_3 := '';
         w_extract_str_4 := '';
         w_extract_str_5 := '';
  end;

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio (servizio: '||a_servizio||')', a_campo_clob);

  begin
    w_xml 	:= xmltype(a_campo_clob);
--    ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'xmltype - ok');
  exception
    when others then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'xmltype - errore', sqlerrm);
  end;

<< testataRisposta >>
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta - 1', a_campo_clob);
  w_xml 	:= xmltype(a_campo_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta - 2', a_campo_clob);
  w_xml 	:= w_xml.extract(w_extract_str||'/testataRisposta'
                                ,w_extract_str_1||' '||w_extract_str_2);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta - 3', w_extract_str||'/testataRisposta'||' '||w_extract_str_1||' '||w_extract_str_2);
  w_xml_clob	:= xmltype.getclobval(w_xml);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta - extract', w_xml_clob);

  for rec in sel_testata ('testataRisposta') loop
      w_id_ANPR    := rec.idOperazioneANPR;
      w_esito_ANPR := rec.esitoOperazioneANPR;
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta', 'idOperazioneANPR: '||w_id_ANPR||' - esito: '||w_esito_ANPR);
  end loop;

<< listaErrori >>
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori - 1', a_campo_clob);
  w_xml 	:= xmltype(a_campo_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori - 2', a_campo_clob);
  w_xml 	:= w_xml.extract(w_extract_str||'/listaErrori/errore'
                                ,w_extract_str_1||' '||w_extract_str_2);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori - 3', a_campo_clob);
  w_xml_clob	:= xmltype.getclobval(w_xml);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori - extract', w_xml_clob);

  for rec in sel_errori ('errore') loop
      w_codice_errore := rec.codiceErrore;
      w_tipo_errore   := rec.tipoErrore;
      w_testo_errore  := rec.testoErrore;
      begin
        insert into anperr (id_operazione, data_ora, codice_errore, tipo_errore, testo_errore)
        values (a_id_operazione, sysdate, w_codice_errore, w_tipo_errore, w_testo_errore)
        ;
      exception
        when others then
             ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANPERR', SQLERRM);
      end;
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori', w_codice_errore||' - '||w_tipo_errore||' - '||w_testo_errore);

      w_flag_errore := 'S';
  end loop;

<< fine >>
null;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end ctr_risposta_ko;

procedure ctr_risposta_ok
(a_servizio 			varchar2
,a_id_operazione		number
,a_campo_clob 			clob
,w_id_ANPR 		OUT 	number
,w_esito_ANPR 		OUT 	varchar2
,w_flag_anomalia	OUT	varchar2
,a_chiave 			varchar2 default NULL
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ctr_risposta_ok';

w_xml			xmltype;
w_xml_clob		clob;

w_extract_str 		varchar2(255);
w_extract_str_1		varchar2(255);
w_extract_str_2  	varchar2(255);
w_extract_str_3		varchar2(255);
w_extract_str_4		varchar2(255);
w_extract_str_5  	varchar2(255);
w_extract_str_6  	varchar2(255);
w_estract_str_7		varchar2(255);
w_estract_str_8		varchar2(255);
w_estract_str_9		varchar2(255);
w_estract_str_10	varchar2(255);

w_certificato_pdf	clob;

w_errori_anomalie       clob;

w_codice_errore		varchar2(255);
w_tipo_errore		varchar2(255);
w_testo_errore		varchar2(255);

w_risposta_xml		xmltype;
w_risposta_b64		clob;
w_risposta_blob		blob;
w_risposta_clob		clob;

w_statoLavorazione      varchar2(255);
w_tipoOperazione        varchar2(255);

w_id_richiesta_ANPR	varchar2(255);
w_operazione_richiesta	varchar2(255);
w_archivio_rif		varchar2(255);

w_step                  number;

cursor sel_testata (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/idOperazioneANPR') idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/esitoOperazione') esitoOperazioneANPR
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_soggetti (w_root varchar2) is
select
-- generalita
       extractValue(value(rowdata),w_root||'/identificativi/idANPR') idANPR
     , extractValue(value(rowdata),w_root||'/generalita/codiceFiscale/codFiscale') codFiscale
     , extractValue(value(rowdata),w_root||'/generalita/codiceFiscale/validitaCF') validitaCF
     , extractValue(value(rowdata),w_root||'/generalita/codiceFiscale/dataAttribuzioneValidita') dataAttribuzioneValidita
     , extractValue(value(rowdata),w_root||'/generalita/cognome') cognome
     , extractValue(value(rowdata),w_root||'/generalita/senzaCognome') senzaCognome
     , extractValue(value(rowdata),w_root||'/generalita/nome') nome
     , extractValue(value(rowdata),w_root||'/generalita/senzaNome') senzaNome
     , extractValue(value(rowdata),w_root||'/generalita/sesso') sesso
     , extractValue(value(rowdata),w_root||'/generalita/dataNascita') dataNascita
     , extractValue(value(rowdata),w_root||'/generalita/senzaGiorno') senzaGiorno
     , extractValue(value(rowdata),w_root||'/generalita/senzaGiornoMese') senzaGiornoMese
     , extractValue(value(rowdata),w_root||'/generalita/luogoNascita/comune/nomeComune') NAS_nomecomune
     , extractValue(value(rowdata),w_root||'/generalita/luogoNascita/comune/codiceIstat') NAS_codiceIstat
     , extractValue(value(rowdata),w_root||'/generalita/luogoNascita/comune/siglaProvinciaIstat') NAS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/generalita/luogoNascita/localita/descrizioneLocalita') NAS_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/generalita/luogoNascita/localita/descrizioneStato') NAS_descrizioneStato
     , extractValue(value(rowdata),w_root||'/generalita/luogoNascita/localita/codiceStato') NAS_codiceStato
     , extractValue(value(rowdata),w_root||'/generalita/luogoNascita/luogoEccezionale') NAS_luogoEccezionale
     , extractValue(value(rowdata),w_root||'/generalita/idSchedaSoggettoComune/idSchedaSoggettoComuneIstat') idSoggettoComuneIstat
     , extractValue(value(rowdata),w_root||'/generalita/idSchedaSoggettoComune/idSchedaSoggetto') idSoggettoComune
     , extractValue(value(rowdata),w_root||'/generalita/idSchedaSoggettoANPR') idSoggettoANPR
     , extractValue(value(rowdata),w_root||'/generalita/soggettoAIRE') soggettoAIRE
-- statoCivile
     , extractValue(value(rowdata),w_root||'/statoCivile/statoCivile') statoCivile
     , extractValue(value(rowdata),w_root||'/statoCivile/noteStatoCivile') noteStatoCivile
-- attributiSoggetto
     , extractValue(value(rowdata),w_root||'/attributiSoggetto/senzaFissaDimora') senzaFissaDimora
     , extractValue(value(rowdata),w_root||'/attributiSoggetto/soggettoCertificabile') soggettoCertificabile
-- attoNascita
     , extractValue(value(rowdata),w_root||'/attoNascita/comuneRegistrazione/nomeComune') ATTNAS_nomeComune
     , extractValue(value(rowdata),w_root||'/attoNascita/comuneRegistrazione/codiceIstat') ATTNAS_codiceIstat
     , extractValue(value(rowdata),w_root||'/attoNascita/comuneRegistrazione/siglaProvinciaIstat') ATTNAS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/attoNascita/ufficioMunicipio') ATTNAS_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/attoNascita/anno') ATTNAS_anno
     , extractValue(value(rowdata),w_root||'/attoNascita/parte') ATTNAS_parte
     , extractValue(value(rowdata),w_root||'/attoNascita/serie') ATTNAS_serie
     , extractValue(value(rowdata),w_root||'/attoNascita/numeroAtto') ATTNAS_numeroAtto
     , extractValue(value(rowdata),w_root||'/attoNascita/dataFormazioneAtto') ATTNAS_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/attoNascita/trascritto') ATTNAS_trascritto
-- attoNascitaANPR
  -- atto
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/comuneRegistrazione/nomeComune') ANPNAS_nomeComune
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/comuneRegistrazione/codiceIstat') ANPNAS_codiceIstat
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/comuneRegistrazione/siglaProvinciaIstat') ANPNAS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/ufficioMunicipio') ANPNAS_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/anno') ANPNAS_anno
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/parte') ANPNAS_parte
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/serie') ANPNAS_serie
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/numeroAtto') ANPNAS_numeroAtto
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/dataFormazioneAtto') ANPNAS_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/atto/trascritto') ANPNAS_trascritto
  -- attoANSC
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/idANSC') ANSNAS_idANSC
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/comuneRegistrazione/nomeComune') ANSNAS_nomeComune
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/comuneRegistrazione/codiceIstat') ANSNAS_codiceIstat
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/comuneRegistrazione/siglaProvinciaIstat') ANSNAS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/anno') ANSNAS_anno
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/ufficioMunicipio') ANSNAS_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/numeroComunale') ANSNAS_numeroComunale
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/dataFormazioneAtto') ANSNAS_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/attoNascitaANPR/attoANSC/trascritto') ANSNAS_trascritto
-- paternita
     , extractValue(value(rowdata),w_root||'/paternita/generalita/codiceFiscale/codFiscale') codFiscale_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/codiceFiscale/validitaCF') validitaCF_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/codiceFiscale/dataAttribuzioneValidita') dataAttribuzioneValidita_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/cognome') cognome_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/senzaCognome') senzaCognome_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/nome') nome_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/senzaNome') senzaNome_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/sesso') sesso_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/dataNascita') dataNascita_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/senzaGiorno') senzaGiorno_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/senzaGiornoMese') senzaGiornoMese_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/luogoNascita/comune/nomeComune') NAS_nomecomune_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/luogoNascita/comune/codiceIstat') NAS_codiceIstat_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/luogoNascita/comune/siglaProvinciaIstat') NAS_siglaProvinciaIstat_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/luogoNascita/localita/descrizioneLocalita') NAS_descrizioneLocalita_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/luogoNascita/localita/descrizioneStato') NAS_descrizioneStato_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/luogoNascita/localita/codiceStato') NAS_codiceStato_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/luogoNascita/luogoEccezionale') NAS_luogoEccezionale_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/idSchedaSoggettoComune/idSchedaSoggettoComuneIstat') idSoggettoComuneIstat_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/idSchedaSoggettoComune/idSchedaSoggetto') idSoggettoComune_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/idSchedaSoggettoANPR') idSoggettoANPR_pd
     , extractValue(value(rowdata),w_root||'/paternita/generalita/soggettoAIRE') soggettoAIRE_pd
     , extractValue(value(rowdata),w_root||'/paternita/statoCivile/statoCivile') statoCivile_pd
     , extractValue(value(rowdata),w_root||'/paternita/statoCivile/noteStatoCivile') noteStatoCivile_pd
-- maternita
     , extractValue(value(rowdata),w_root||'/maternita/generalita/codiceFiscale/codFiscale') codFiscale_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/codiceFiscale/validitaCF') validitaCF_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/codiceFiscale/dataAttribuzioneValidita') dataAttribuzioneValidita_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/cognome') cognome_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/senzaCognome') senzaCognome_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/nome') nome_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/senzaNome') senzaNome_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/sesso') sesso_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/dataNascita') dataNascita_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/senzaGiorno') senzaGiorno_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/senzaGiornoMese') senzaGiornoMese_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/luogoNascita/comune/nomeComune') NAS_nomecomune_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/luogoNascita/comune/codiceIstat') NAS_codiceIstat_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/luogoNascita/comune/siglaProvinciaIstat') NAS_siglaProvinciaIstat_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/luogoNascita/localita/descrizioneLocalita') NAS_descrizioneLocalita_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/luogoNascita/localita/descrizioneStato') NAS_descrizioneStato_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/luogoNascita/localita/codiceStato') NAS_codiceStato_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/luogoNascita/luogoEccezionale') NAS_luogoEccezionale_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/idSchedaSoggettoComune/idSchedaSoggettoComuneIstat') idSoggettoComuneIstat_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/idSchedaSoggettoComune/idSchedaSoggetto') idSoggettoComune_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/idSchedaSoggettoANPR') idSoggettoANPR_md
     , extractValue(value(rowdata),w_root||'/maternita/generalita/soggettoAIRE') soggettoAIRE_md
     , extractValue(value(rowdata),w_root||'/maternita/statoCivile/statoCivile') statoCivile_md
     , extractValue(value(rowdata),w_root||'/maternita/statoCivile/noteStatoCivile') noteStatoCivile_md
-- datiTraslitterati
     , extractValue(value(rowdata),w_root||'/datiTraslitterati/cognomeTranslitterato') TRA_cognome
     , extractValue(value(rowdata),w_root||'/datiTraslitterati/nomeTranslitterato') TRA_nome
     , extractValue(value(rowdata),w_root||'/datiTraslitterati/denominazioneToponimoTranslitterato') TRA_denominazioneToponimo
     , extractValue(value(rowdata),w_root||'/datiTraslitterati/denominazioneComuneTranslitterato') TRA_denominazioneComune
-- liste
     , extractValue(value(rowdata),w_root||'/listaElettorale/elettore') ELE_elettore
     , extractValue(value(rowdata),w_root||'/listaElettorale/comune/nomeComune') ELE_nomeComune
     , extractValue(value(rowdata),w_root||'/listaElettorale/comune/codiceIstat') ELE_codiceIstat
     , extractValue(value(rowdata),w_root||'/listaElettorale/comune/siglaProvinciaIstat') ELE_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/listaLeva/iscritto') LEV_iscritto
-- listaElettoraleCompleta
     , extractValue(value(rowdata),w_root||'/listaElettoraleCompleta/certificabilita') ELE_certificabilita
     , extractValue(value(rowdata),w_root||'/listaElettoraleCompleta/cancellazione/motivoCancellazione') ELE_motivoCancellazione
     , extractValue(value(rowdata),w_root||'/listaElettoraleCompleta/cancellazione/noteCancellazione') ELE_noteCancellazione
     , extractValue(value(rowdata),w_root||'/listaElettoraleCompleta/cancellazione/tipoConsultazione') ELE_tipoConsultazione
     , extractValue(value(rowdata),w_root||'/listaElettoraleCompleta/cancellazione/dataCancellazione') ELE_dataCancellazione
-- cartaIdentita
     , extractValue(value(rowdata),w_root||'/cartaIdentita/numero') DI_numero
     , extractValue(value(rowdata),w_root||'/cartaIdentita/dataRilascio') DI_dataRilascio
     , extractValue(value(rowdata),w_root||'/cartaIdentita/cartaceaElettronica') DI_cartaceaElettronica
     , extractValue(value(rowdata),w_root||'/cartaIdentita/interdizioneEspatrio') DI_interdizioneEspatrio
     , extractValue(value(rowdata),w_root||'/cartaIdentita/comuneRilascio/nomeComune') DI_nomeComune
     , extractValue(value(rowdata),w_root||'/cartaIdentita/comuneRilascio/codiceIstat') DI_codiceIstat
     , extractValue(value(rowdata),w_root||'/cartaIdentita/comuneRilascio/siglaProvinciaIstat') DI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/cartaIdentita/dataScadenza') DI_dataScadenza
     , extractValue(value(rowdata),w_root||'/cartaIdentita/dataAnnullamento') DI_dataAnnullamento
     , extractValue(value(rowdata),w_root||'/cartaIdentita/consolatoRilascio/codiceConsolato') DI_codiceConsolato
     , extractValue(value(rowdata),w_root||'/cartaIdentita/consolatoRilascio/descrizioneConsolato') DI_descrizioneConsolato
-- permessoSoggiorno
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/numeroSoggiorno') DS_numero
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/tipoSoggiorno') DS_tipoSoggiorno
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/dataRilascio') DS_dataRilascio
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/dataScadenza') DS_dataScadenza
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/questuraRilascioSoggiorno') DS_questuraRilascioSoggiorno
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/comune/nomeComune') DS_nomeComune
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/comune/codiceIstat') DS_codiceIstat
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/comune/siglaProvinciaIstat') DS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/permessoSoggiorno/numeroPassaporto') DS_numeroPassaporto
-- matrimonio
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/codiceFiscale/codFiscale') codFiscale_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/codiceFiscale/validitaCF') validitaCF_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/codiceFiscale/dataAttribuzioneValidita') dataAttribuzioneValidita_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/cognome') cognome_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/senzaCognome') senzaCognome_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/nome') nome_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/senzaNome') senzaNome_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/sesso') sesso_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/dataNascita') dataNascita_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/senzaGiorno') senzaGiorno_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/senzaGiornoMese') senzaGiornoMese_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/luogoNascita/comune/nomeComune') NAS_nomecomune_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/luogoNascita/comune/codiceIstat') NAS_codiceIstat_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/luogoNascita/comune/siglaProvinciaIstat') NAS_siglaProvinciaIstat_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/luogoNascita/localita/descrizioneLocalita') NAS_descrizioneLocalita_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/luogoNascita/localita/descrizioneStato') NAS_descrizioneStato_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/luogoNascita/localita/codiceStato') NAS_codiceStato_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/luogoNascita/luogoEccezionale') NAS_luogoEccezionale_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/idSchedaSoggettoComune/idSchedaSoggettoComuneIstat') idSoggettoComuneIstat_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/idSchedaSoggettoComune/idSchedaSoggetto') idSoggettoComune_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/coniuge/idSchedaSoggettoANPR') idSoggettoANPR_cn
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/dataEvento') MAT_dataEvento
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/senzaGiorno') MAT_senzaGiorno
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/senzaGiornoMese') MAT_senzaGiornoMese
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/luogoEvento/comune/nomeComune') MAT_nomecomune
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/luogoEvento/comune/codiceIstat') MAT_codiceIstat
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/luogoEvento/comune/siglaProvinciaIstat') MAT_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/luogoEvento/localita/descrizioneLocalita') MAT_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/luogoEvento/localita/descrizioneStato') MAT_descrizioneStato
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/luogoEvento/localita/codiceStato') MAT_codiceStato
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/luogoEvento/luogoEccezionale') MAT_luogoEccezionale
-- attoEvento
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/comuneRegistrazione/nomeComune') ATTMAT_nomeComune
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/comuneRegistrazione/codiceIstat') ATTMAT_codiceIstat
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/comuneRegistrazione/siglaProvinciaIstat') ATTMAT_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/ufficioMunicipio') ATTMAT_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/anno') ATTMAT_anno
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/parte') ATTMAT_parte
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/serie') ATTMAT_serie
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/numeroAtto') ATTMAT_numeroAtto
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/dataFormazioneAtto') ATTMAT_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEvento/trascritto') ATTMAT_trascritto
-- attoEventoANPR
  -- atto
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/comuneRegistrazione/nomeComune') ANPMAT_nomeComune
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/comuneRegistrazione/codiceIstat') ANPMAT_codiceIstat
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/comuneRegistrazione/siglaProvinciaIstat') ANPMAT_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/ufficioMunicipio') ANPMAT_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/anno') ANPMAT_anno
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/parte') ANPMAT_parte
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/serie') ANPMAT_serie
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/numeroAtto') ANPMAT_numeroAtto
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/dataFormazioneAtto') ANPMAT_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/atto/trascritto') ANPMAT_trascritto
  -- attoANSC
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/idANSC') ANSMAT_idANSC
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/comuneRegistrazione/nomeComune') ANSMAT_nomeComune
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/comuneRegistrazione/codiceIstat') ANSMAT_codiceIstat
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/comuneRegistrazione/siglaProvinciaIstat') ANSMAT_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/anno') ANSMAT_anno
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/ufficioMunicipio') ANSMAT_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/numeroComunale') ANSMAT_numeroComunale
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/dataFormazioneAtto') ANSMAT_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/matrimonio/datiMatrimonio/attoEventoANPR/attoANSC/trascritto') ANSMAT_trascritto
--
     , extractValue(value(rowdata),w_root||'/matrimonio/ordineMatrimonio') MAT_ordineMatrimonio
-- vedovanza
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/dataEvento') VED_dataEvento
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/senzaGiorno') VED_senzaGiorno
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/senzaGiornoMese') VED_senzaGiornoMese
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/luogoEvento/comune/nomeComune') VED_nomecomune
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/luogoEvento/comune/codiceIstat') VED_codiceIstat
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/luogoEvento/comune/siglaProvinciaIstat') VED_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/luogoEvento/localita/descrizioneLocalita') VED_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/luogoEvento/localita/descrizioneStato') VED_descrizioneStato
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/luogoEvento/localita/codiceStato') VED_codiceStato
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/luogoEvento/luogoEccezionale') VED_luogoEccezionale
-- attoEvento
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/comuneRegistrazione/nomeComune') ATTVED_nomeComune
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/comuneRegistrazione/codiceIstat') ATTVED_codiceIstat
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/comuneRegistrazione/siglaProvinciaIstat') ATTVED_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/ufficioMunicipio') ATTVED_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/anno') ATTVED_anno
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/parte') ATTVED_parte
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/serie') ATTVED_serie
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/numeroAtto') ATTVED_numeroAtto
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/dataFormazioneAtto') ATTVED_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEvento/trascritto') ATTVED_trascritto
-- attoEventoANPR
  -- atto
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/comuneRegistrazione/nomeComune') ANPVED_nomeComune
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/comuneRegistrazione/codiceIstat') ANPVED_codiceIstat
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/comuneRegistrazione/siglaProvinciaIstat') ANPVED_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/ufficioMunicipio') ANPVED_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/anno') ANPVED_anno
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/parte') ANPVED_parte
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/serie') ANPVED_serie
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/numeroAtto') ANPVED_numeroAtto
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/dataFormazioneAtto') ANPVED_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/atto/trascritto') ANPVED_trascritto
  -- attoANSC
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/idANSC') ANSVED_idANSC
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/comuneRegistrazione/nomeComune') ANSVED_nomeComune
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/comuneRegistrazione/codiceIstat') ANSVED_codiceIstat
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/comuneRegistrazione/siglaProvinciaIstat') ANSVED_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/anno') ANSVED_anno
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/ufficioMunicipio') ANSVED_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/numeroComunale') ANSVED_numeroComunale
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/dataFormazioneAtto') ANSVED_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/vedovanza/datiMorteconiuge/attoEventoANPR/attoANSC/trascritto') ANSVED_trascritto
-- annullamentoMatrimonio
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/tipoCessazione') DIV_tipoCessazione
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/sentenza/data') DIV_dataSentenza
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/sentenza/numero') DIV_numeroSentenza
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/sentenza/tipoTribunale') DIV_tipoTribunaleSentenza
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/sentenza/autorita') DIV_autoritaSentenza
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/sentenza/dataValidita') DIV_dataValiditaSentenza
-- attoAnnullamentoMatrimonio
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/comuneRegistrazione/nomeComune') ATTDIV_nomeComune
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/comuneRegistrazione/codiceIstat') ATTDIV_codiceIstat
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/comuneRegistrazione/siglaProvinciaIstat') ATTDIV_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/ufficioMunicipio') ATTDIV_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/anno') ATTDIV_anno
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/parte') ATTDIV_parte
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/serie') ATTDIV_serie
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/numeroAtto') ATTDIV_numeroAtto
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/dataFormazioneAtto') ATTDIV_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonio/trascritto') ATTDIV_trascritto
-- attoAnnullamentoMatrimonioANPR
  -- atto
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/comuneRegistrazione/nomeComune') ANPDIV_nomeComune
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/comuneRegistrazione/codiceIstat') ANPDIV_codiceIstat
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/comuneRegistrazione/siglaProvinciaIstat') ANPDIV_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/ufficioMunicipio') ANPDIV_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/anno') ANPDIV_anno
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/parte') ANPDIV_parte
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/serie') ANPDIV_serie
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/numeroAtto') ANPDIV_numeroAtto
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/dataFormazioneAtto') ANPDIV_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/atto/trascritto') ANPDIV_trascritto
  -- attoANSC
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/idANSC') ANSDIV_idANSC
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/comuneRegistrazione/nomeComune') ANSDIV_nomeComune
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/comuneRegistrazione/codiceIstat') ANSDIV_codiceIstat
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/comuneRegistrazione/siglaProvinciaIstat') ANSDIV_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/anno') ANSDIV_anno
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/ufficioMunicipio') ANSDIV_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/numeroComunale') ANSDIV_numeroComunale
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/dataFormazioneAtto') ANSDIV_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/annullamentoMatrimonio/attoAnnullamentoMatrimonioANPR/attoANSC/trascritto') ANSDIV_trascritto
-- unioneCivile
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/codiceFiscale/codFiscale') codFiscale_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/codiceFiscale/validitaCF') validitaCF_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/codiceFiscale/dataAttribuzioneValidita') dataAttribuzioneValidita_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/cognome') cognome_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/senzaCognome') senzaCognome_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/nome') nome_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/senzaNome') senzaNome_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/sesso') sesso_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/dataNascita') dataNascita_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/senzaGiorno') senzaGiorno_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/senzaGiornoMese') senzaGiornoMese_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/luogoNascita/comune/nomeComune') NAS_nomecomune_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/luogoNascita/comune/codiceIstat') NAS_codiceIstat_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/luogoNascita/comune/siglaProvinciaIstat') NAS_siglaProvinciaIstat_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/luogoNascita/localita/descrizioneLocalita') NAS_descrizioneLocalita_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/luogoNascita/localita/descrizioneStato') NAS_descrizioneStato_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/luogoNascita/localita/codiceStato') NAS_codiceStato_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/luogoNascita/luogoEccezionale') NAS_luogoEccezionale_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/idSchedaSoggettoComune/idSchedaSoggettoComuneIstat') idSoggettoComuneIstat_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/idSchedaSoggettoComune/idSchedaSoggetto') idSoggettoComune_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/unitoCivilmente/idSchedaSoggettoANPR') idSoggettoANPR_uc
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/dataEvento') UCI_dataEvento
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/senzaGiorno') UCI_senzaGiorno
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/senzaGiornoMese') UCI_senzaGiornoMese
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/luogoEvento/comune/nomeComune') UCI_nomecomune
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/luogoEvento/comune/codiceIstat') UCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/luogoEvento/comune/siglaProvinciaIstat') UCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/luogoEvento/localita/descrizioneLocalita') UCI_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/luogoEvento/localita/descrizioneStato') UCI_descrizioneStato
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/luogoEvento/localita/codiceStato') UCI_codiceStato
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/luogoEvento/luogoEccezionale') UCI_luogoEccezionale
-- attoEvento
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/comuneRegistrazione/nomeComune') ATTUCI_nomeComune
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/comuneRegistrazione/codiceIstat') ATTUCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/comuneRegistrazione/siglaProvinciaIstat') ATTUCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/ufficioMunicipio') ATTUCI_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/anno') ATTUCI_anno
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/parte') ATTUCI_parte
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/serie') ATTUCI_serie
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/numeroAtto') ATTUCI_numeroAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/dataFormazioneAtto') ATTUCI_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEvento/trascritto') ATTUCI_trascritto
-- attoEventoANPR
  -- atto
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/comuneRegistrazione/nomeComune') ANPUCI_nomeComune
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/comuneRegistrazione/codiceIstat') ANPUCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/comuneRegistrazione/siglaProvinciaIstat') ANPUCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/ufficioMunicipio') ANPUCI_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/anno') ANPUCI_anno
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/parte') ANPUCI_parte
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/serie') ANPUCI_serie
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/numeroAtto') ANPUCI_numeroAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/dataFormazioneAtto') ANPUCI_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/atto/trascritto') ANPUCI_trascritto
  -- attoANSC
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/idANSC') ANSUCI_idANSC
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/comuneRegistrazione/nomeComune') ANSUCI_nomeComune
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/comuneRegistrazione/codiceIstat') ANSUCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/comuneRegistrazione/siglaProvinciaIstat') ANSUCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/anno') ANSUCI_anno
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/ufficioMunicipio') ANSUCI_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/numeroComunale') ANSUCI_numeroComunale
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/dataFormazioneAtto') ANSUCI_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/attoUnione/attoEventoANPR/attoANSC/trascritto') ANSUCI_trascritto
-- scioglimentoUnione
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/motivoScioglimento') SCI_motivoScioglimento
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/sentenza/data') SCI_dataSentenza
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/sentenza/numero') SCI_numeroSentenza
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/sentenza/tipoTribunale') SCI_tipoTribunaleSentenza
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/sentenza/autorita') SCI_autoritaSentenza
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/sentenza/dataValidita') SCI_dataValiditaSentenza
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/dataEvento') SCI_dataEvento
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/luogoEvento/comune/nomeComune') SCI_nomecomune
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/luogoEvento/comune/codiceIstat') SCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/luogoEvento/comune/siglaProvinciaIstat') SCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/luogoEvento/localita/descrizioneLocalita') SCI_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/luogoEvento/localita/descrizioneStato') SCI_descrizioneStato
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/luogoEvento/localita/codiceStato') SCI_codiceStato
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/luogoEvento/luogoEccezionale') SCI_luogoEccezionale
-- attoEvento
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/comuneRegistrazione/nomeComune') ATTSCI_nomeComune
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/comuneRegistrazione/codiceIstat') ATTSCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/comuneRegistrazione/siglaProvinciaIstat') ATTSCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/ufficioMunicipio') ATTSCI_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/anno') ATTSCI_anno
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/parte') ATTSCI_parte
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/serie') ATTSCI_serie
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/numeroAtto') ATTSCI_numeroAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/dataFormazioneAtto') ATTSCI_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEvento/trascritto') ATTSCI_trascritto
-- attoEventoANPR
  -- atto
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/comuneRegistrazione/nomeComune') ANPSCI_nomeComune
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/comuneRegistrazione/codiceIstat') ANPSCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/comuneRegistrazione/siglaProvinciaIstat') ANPSCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/ufficioMunicipio') ANPSCI_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/anno') ANPSCI_anno
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/parte') ANPSCI_parte
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/serie') ANPSCI_serie
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/numeroAtto') ANPSCI_numeroAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/dataFormazioneAtto') ANPSCI_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/atto/trascritto') ANPSCI_trascritto
  -- attoANSC
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/idANSC') ANSSCI_idANSC
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/comuneRegistrazione/nomeComune') ANSSCI_nomeComune
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/comuneRegistrazione/codiceIstat') ANSSCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/comuneRegistrazione/siglaProvinciaIstat') ANSSCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/anno') ANSSCI_anno
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/ufficioMunicipio') ANSSCI_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/numeroComunale') ANSSCI_numeroComunale
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/dataFormazioneAtto') ANSSCI_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/unioneCivile/scioglimentoUnione/datiEvento/attoEventoANPR/attoANSC/trascritto') ANSSCI_trascritto
--
     , extractValue(value(rowdata),w_root||'/unioneCivile/ordineUnione') UCI_ordineUnione
-- convivenzaDiFatto
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/codiceFiscale/codFiscale') codFiscale_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/codiceFiscale/validitaCF') validitaCF_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/codiceFiscale/dataAttribuzioneValidita') dataAttribuzioneValidita_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/cognome') cognome_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/senzaCognome') senzaCognome_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/nome') nome_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/senzaNome') senzaNome_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/sesso') sesso_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/dataNascita') dataNascita_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/senzaGiorno') senzaGiorno_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/senzaGiornoMese') senzaGiornoMese_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/luogoNascita/comune/nomeComune') NAS_nomecomune_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/luogoNascita/comune/codiceIstat') NAS_codiceIstat_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/luogoNascita/comune/siglaProvinciaIstat') NAS_siglaProvinciaIstat_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/luogoNascita/localita/descrizioneLocalita') NAS_descrizioneLocalita_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/luogoNascita/localita/descrizioneStato') NAS_descrizioneStato_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/luogoNascita/localita/codiceStato') NAS_codiceStato_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/luogoNascita/luogoEccezionale') NAS_luogoEccezionale_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/idSchedaSoggettoComune/idSchedaSoggettoComuneIstat') idSoggettoComuneIstat_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/idSchedaSoggettoComune/idSchedaSoggetto') idSoggettoComune_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/convivente/idSchedaSoggettoANPR') idSoggettoANPR_cv
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/data') CDFSTI_data
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/dataNotifica') CDFSTI_dataNotifica
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/dataDocumento') CDFSTI_dataDocumento
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/protocollo') CDFSTI_protocollo
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/luogoEvento/comune/nomeComune') CDFSTI_nomeComune
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/luogoEvento/comune/codiceIstat') CDFSTI_codiceIstat
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/luogoEvento/comune/siglaProvinciaIstat') CDFSTI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/professionista') CDFSTI_professionista
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/comuneRegistrazione/nomeComune') CDFSTI_nomeComuneReg
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/comuneRegistrazione/codiceIstat') CDFSTI_codiceIstatReg
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/comuneRegistrazione/siglaProvinciaIstat') CDFSTI_siglaProvinciaIstatReg
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoStipula/stato') CDFSTI_stato
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/motivoRisoluzione') CDFRIS_motivoRisoluzione
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/data') CDFRIS_data
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/dataNotifica') CDFRIS_dataNotifica
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/dataDocumento') CDFRIS_dataDocumento
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/protocollo') CDFRIS_protocollo
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/luogoEvento/comune/nomeComune') CDFRIS_nomeComune
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/luogoEvento/comune/codiceIstat') CDFRIS_codiceIstat
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/luogoEvento/comune/siglaProvinciaIstat') CDFRIS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/professionista') CDFRIS_professionista
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/comuneRegistrazione/nomeComune') CDFRIS_nomeComuneReg
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/comuneRegistrazione/codiceIstat') CDFRIS_codiceIstatReg
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/comuneRegistrazione/siglaProvinciaIstat') CDFRIS_siglaProvinciaIstatReg
     , extractValue(value(rowdata),w_root||'/convivenzaDiFatto/contrattoRisoluzione/contratto/stato') CDFRIS_stato
-- legameSoggetto
     , extractValue(value(rowdata),w_root||'/legameSoggetto/tipoLegame') FAM_tipoLegame
     , extractValue(value(rowdata),w_root||'/legameSoggetto/dataDecorrenza') FAM_dataDecorrenza
     , extractValue(value(rowdata),w_root||'/legameSoggetto/codiceLegame') FAM_codiceLegame
     , extractValue(value(rowdata),w_root||'/legameSoggetto/dataDecorrenzaLegame') FAM_dataDecorrenzaLegame
-- famigliaConvivenza
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/idFamigliaConvivenzaComune/idFamigliaConvivenzaComuneIstat') FAM_idFamigliaComuneIstat
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/idFamigliaConvivenzaComune/idFamigliaConvivenza') FAM_idFamigliaComune
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/idFamigliaConvivenzaANPR') FAM_idFamigliaANPR
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/famigliaAire') FAM_famigliaAire
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/dataOrigineFamigliaConvivenza') FAM_dataOrigineFamiglia
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/denominazioneConvivenza') FAM_denominazioneConvivenza
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/specieConvivenza') FAM_specieConvivenza
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/presenzaFamigliaCoabitante') FAM_presenzaFamigliaCoabitante
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/tipoScheda') FAM_tipoScheda
-- censimento
     , extractValue(value(rowdata),w_root||'/censimento/annoCensimento') annoCensimento
     , extractValue(value(rowdata),w_root||'/censimento/sezioneCensimento') sezioneCensimento
     , extractValue(value(rowdata),w_root||'/censimento/foglioCensimento') foglioCensimento
-- altriDati
     , extractValue(value(rowdata),w_root||'/altriDati/posizioneProfessionale') posizioneProfessionale
     , extractValue(value(rowdata),w_root||'/altriDati/condizioneNonProfessionale') condizioneNonProfessionale
     , extractValue(value(rowdata),w_root||'/altriDati/titoloStudio') titoloStudio
-- autoveicoli
     , extractValue(value(rowdata),w_root||'/autoveicoli/possessoAutoveicoli') possessoAutoveicoli
     , extractValue(value(rowdata),w_root||'/autoveicoli/possessoPatente') possessoPatente
-- datiIscrizione
     , extractValue(value(rowdata),w_root||'/datiIscrizione/datiIscrizioneComune/dataIscrizione') ISC_dataIscrizione
     , extractValue(value(rowdata),w_root||'/datiIscrizione/datiIscrizioneComune/protocolloComune') ISC_protocolloComune
     , extractValue(value(rowdata),w_root||'/datiIscrizione/datiIscrizioneComune/comune/nomeComune') ISC_nomeComune
     , extractValue(value(rowdata),w_root||'/datiIscrizione/datiIscrizioneComune/comune/codiceIstat') ISC_codiceIstat
     , extractValue(value(rowdata),w_root||'/datiIscrizione/datiIscrizioneComune/comune/siglaProvinciaIstat') ISC_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/datiIscrizione/datiIscrizioneComune/idOperazioneComune') ISC_idOperazioneComune
     , extractValue(value(rowdata),w_root||'/datiIscrizione/datiIscrizioneComune/idOperazioneANPR') ISC_idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/datiIscrizione/datiIscrizioneComune/dataDefinizionePratica') ISC_dataDefinizionePratica
     , extractValue(value(rowdata),w_root||'/datiIscrizione/iscrizioneResidente/motivoIscrizione') ISC_motivoIscrizione
     , extractValue(value(rowdata),w_root||'/datiIscrizione/iscrizioneResidente/descrizioneMotivoIscrizione') ISC_desMotivoIscrizione
     , extractValue(value(rowdata),w_root||'/datiIscrizione/tipoIscrizioneAIRE/motivoIscrizione') ISC_motivoIscrizioneAire
     , extractValue(value(rowdata),w_root||'/datiIscrizione/tipoIscrizioneAIRE/iniziativaIscrizione') ISC_iniziativaAire
     , extractValue(value(rowdata),w_root||'/datiIscrizione/tipoIscrizioneAIRE/individuazioneComuneIscrizione') ISC_individuazioneAire
     , extractValue(value(rowdata),w_root||'/datiIscrizione/tipoIscrizioneAIRE/dataArrivoConsolato') ISC_dataArrivoConsolato
-- provenienza
     , extractValue(value(rowdata),w_root||'/provenienza/comune/nomeComune') PRO_nomeComune
     , extractValue(value(rowdata),w_root||'/provenienza/comune/codiceIstat') PRO_codiceIstat
     , extractValue(value(rowdata),w_root||'/provenienza/comune/siglaProvinciaIstat') PRO_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/provenienza/localita/descrizioneLocalita') PRO_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/provenienza/localita/descrizioneStato') PRO_descrizioneStato
     , extractValue(value(rowdata),w_root||'/provenienza/localita/codiceStato') PRO_codiceStato
-- datiCancellazione
     , extractValue(value(rowdata),w_root||'/datiCancellazione/motivoCancellazione') CAN_motivoCancellazione
     , extractValue(value(rowdata),w_root||'/datiCancellazione/notecancellazione') CAN_noteCancellazione
     , extractValue(value(rowdata),w_root||'/datiCancellazione/dataDecorrenzaCancellazione') CAN_dataDecorrenza
-- destinazione
     , extractValue(value(rowdata),w_root||'/destinazione/comune/nomeComune') DES_nomeComune
     , extractValue(value(rowdata),w_root||'/destinazione/comune/codiceIstat') DES_codiceIstat
     , extractValue(value(rowdata),w_root||'/destinazione/comune/siglaProvinciaIstat') DES_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/destinazione/localita/descrizioneLocalita') DES_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/destinazione/localita/descrizioneStato') DES_descrizioneStato
     , extractValue(value(rowdata),w_root||'/destinazione/localita/codiceStato') DES_codiceStato
-- datiDecesso
     , extractValue(value(rowdata),w_root||'/datiDecesso/dataEvento') MOR_dataEvento
     , extractValue(value(rowdata),w_root||'/datiDecesso/senzaGiorno') MOR_senzaGiorno
     , extractValue(value(rowdata),w_root||'/datiDecesso/senzaGiornoMese') MOR_senzaGiornoMese
     , extractValue(value(rowdata),w_root||'/datiDecesso/luogoEvento/comune/nomeComune') MOR_nomeComune
     , extractValue(value(rowdata),w_root||'/datiDecesso/luogoEvento/comune/codiceIstat') MOR_codiceIstat
     , extractValue(value(rowdata),w_root||'/datiDecesso/luogoEvento/comune/siglaProvinciaIstat') MOR_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/datiDecesso/luogoEvento/localita/descrizioneLocalita') MOR_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/datiDecesso/luogoEvento/localita/descrizioneStato') MOR_descrizioneStato
     , extractValue(value(rowdata),w_root||'/datiDecesso/luogoEvento/localita/codiceStato') MOR_codiceStato
     , extractValue(value(rowdata),w_root||'/datiDecesso/luogoEvento/luogoEccezionale') MOR_luogoEccezionale
-- attoEvento
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/comuneRegistrazione/nomeComune') ATTMOR_nomeComune
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/comuneRegistrazione/codiceIstat') ATTMOR_codiceIstat
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/comuneRegistrazione/siglaProvinciaIstat') ATTMOR_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/ufficioMunicipio') ATTMOR_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/anno') ATTMOR_anno
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/parte') ATTMOR_parte
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/serie') ATTMOR_serie
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/numeroAtto') ATTMOR_numeroAtto
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/dataFormazioneAtto') ATTMOR_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEvento/trascritto') ATTMOR_trascritto
-- attoEventoANPR
  -- atto
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/comuneRegistrazione/nomeComune') ANPMOR_nomeComune
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/comuneRegistrazione/codiceIstat') ANPMOR_codiceIstat
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/comuneRegistrazione/siglaProvinciaIstat') ANPMOR_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/ufficioMunicipio') ANPMOR_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/anno') ANPMOR_anno
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/parte') ANPMOR_parte
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/serie') ANPMOR_serie
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/numeroAtto') ANPMOR_numeroAtto
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/dataFormazioneAtto') ANPMOR_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/atto/trascritto') ANPMOR_trascritto
  -- attoANSC
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/idANSC') ANSMOR_idANSC
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/comuneRegistrazione/nomeComune') ANSMOR_nomeComune
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/comuneRegistrazione/codiceIstat') ANSMOR_codiceIstat
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/comuneRegistrazione/siglaProvinciaIstat') ANSMOR_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/anno') ANSMOR_anno
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/ufficioMunicipio') ANSMOR_ufficioMunicipio
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/numeroComunale') ANSMOR_numeroComunale
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/dataFormazioneAtto') ANSMOR_dataFormazioneAtto
     , extractValue(value(rowdata),w_root||'/datiDecesso/attoEventoANPR/attoANSC/trascritto') ANSMOR_trascritto
-- erroriAnomalie
     , extract(value(rowdata),w_root||'/erroriAnomalie').getClobVal() erroriAnomalie
-- cittadinanza
     , extract(value(rowdata),w_root||'/cittadinanza').getClobVal() cittadinanza
-- cittadinanza_pd
     , extract(value(rowdata),w_root||'/paternita/cittadinanza').getClobVal() cittadinanza_pd
-- cittadinanza_md
     , extract(value(rowdata),w_root||'/maternita/cittadinanza').getClobVal() cittadinanza_md
-- cittadinanza_cn
     , extract(value(rowdata),w_root||'/matrimonio/cittadinanza').getClobVal() cittadinanza_cn
-- cittadinanza_uc
     , extract(value(rowdata),w_root||'/unioneCivile/cittadinanza').getClobVal() cittadinanza_uc
-- cittadinanza_cv
     , extract(value(rowdata),w_root||'/convivenzaDiFatto/cittadinanza').getClobVal() cittadinanza_cv
-- residenza
     , extract(value(rowdata),w_root||'/residenza').getClobVal() residenza
-- listaElettoraleCompleta
     , extract(value(rowdata),w_root||'/listaElettoraleCompleta/liste').getClobVal() liste
  from table(XMLSequence(w_xml)) rowdata
;

w_CIT_descrizioneStato      varchar2(255);
w_CIT_codiceStato           varchar2(255);
w_CIT_dataValidita          varchar2(255);
w_CIT_descrizioneStato_pd   varchar2(255);
w_CIT_codiceStato_pd        varchar2(255);
w_CIT_dataValidita_pd       varchar2(255);
w_CIT_descrizioneStato_md   varchar2(255);
w_CIT_codiceStato_md        varchar2(255);
w_CIT_dataValidita_md       varchar2(255);
w_CIT_descrizioneStato_cn   varchar2(255);
w_CIT_codiceStato_cn        varchar2(255);
w_CIT_dataValidita_cn       varchar2(255);
w_CIT_descrizioneStato_uc   varchar2(255);
w_CIT_codiceStato_uc        varchar2(255);
w_CIT_dataValidita_uc       varchar2(255);
w_CIT_descrizioneStato_cv   varchar2(255);
w_CIT_codiceStato_cv        varchar2(255);
w_CIT_dataValidita_cv       varchar2(255);

cursor sel_cittadinanza (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/descrizioneStato') CIT_descrizioneStato
     , extractValue(value(rowdata),w_root||'/codiceStato') CIT_codiceStato
     , extractValue(value(rowdata),w_root||'/dataValidita') CIT_dataValidita
  from table(XMLSequence(w_xml)) rowdata
;

w_RES_tipoIndirizzo		varchar2(255);
w_RES_noteIndirizzo		varchar2(255);
w_RES_cap			varchar2(255);
w_RES_nomeComune		varchar2(255);
w_RES_codiceIstat		varchar2(255);
w_RES_siglaProvinciaIstat	varchar2(255);
w_RES_frazione			varchar2(255);
w_RES_codSpecie			varchar2(255);
w_RES_specie			varchar2(255);
w_RES_specieFonte		varchar2(255);
w_RES_codToponimo		varchar2(255);
w_RES_denominazioneToponimo	varchar2(255);
w_RES_toponimoFonte		varchar2(255);
w_RES_codiceCivico		varchar2(255);
w_RES_civicoFonte		varchar2(255);
w_RES_numero			varchar2(255);
w_RES_metrico			varchar2(255);
w_RES_progSNC			varchar2(255);
w_RES_lettera			varchar2(255);
w_RES_esponente1		varchar2(255);
w_RES_colore			varchar2(255);
w_RES_corte			varchar2(255);
w_RES_scala			varchar2(255);
w_RES_interno1			varchar2(255);
w_RES_espInterno1		varchar2(255);
w_RES_interno2			varchar2(255);
w_RES_espInterno2		varchar2(255);
w_RES_scalaEsterna		varchar2(255);
w_RES_secondario		varchar2(255);
w_RES_piano			varchar2(255);
w_RES_nui			varchar2(255);
w_RES_isolato			varchar2(255);
w_RES_capEstero			varchar2(255);
w_RES_descrizioneLocalita	varchar2(255);
w_RES_descrizioneStato		varchar2(255);
w_RES_codiceStato		varchar2(255);
w_RES_provinciaContea		varchar2(255);
w_RES_toponimoEstero		varchar2(255);
w_RES_codiceConsolato		varchar2(255);
w_RES_descrizioneConsolato	varchar2(255);
w_RES_presso			varchar2(255);
w_RES_dataDecorrenzaResidenza	varchar2(255);

cursor sel_residenza (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/tipoIndirizzo') RES_tipoIndirizzo
     , extractValue(value(rowdata),w_root||'/noteIndirizzo') RES_noteIndirizzo
     , extractValue(value(rowdata),w_root||'/indirizzo/cap') RES_cap
     , extractValue(value(rowdata),w_root||'/indirizzo/comune/nomeComune') RES_nomeComune
     , extractValue(value(rowdata),w_root||'/indirizzo/comune/codiceIstat') RES_codiceIstat
     , extractValue(value(rowdata),w_root||'/indirizzo/comune/siglaProvinciaIstat') RES_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/indirizzo/frazione') RES_frazione
     , extractValue(value(rowdata),w_root||'/indirizzo/toponimo/codSpecie') RES_codSpecie
     , extractValue(value(rowdata),w_root||'/indirizzo/toponimo/specie') RES_specie
     , extractValue(value(rowdata),w_root||'/indirizzo/toponimo/specieFonte') RES_specieFonte
     , extractValue(value(rowdata),w_root||'/indirizzo/toponimo/codToponimo') RES_codToponimo
     , extractValue(value(rowdata),w_root||'/indirizzo/toponimo/denominazioneToponimo') RES_denominazioneToponimo
     , extractValue(value(rowdata),w_root||'/indirizzo/toponimo/toponimoFonte') RES_toponimoFonte
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/codiceCivico') RES_codiceCivico
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoFonte') RES_civicoFonte
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/numero') RES_numero
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/metrico') RES_metrico
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/progSNC') RES_progSNC
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/lettera') RES_lettera
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/esponente1') RES_esponente1
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/colore') RES_colore
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/corte') RES_corte
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/scala') RES_scala
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/interno1') RES_interno1
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/espInterno1') RES_espInterno1
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/interno2') RES_interno2
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/espInterno2') RES_espInterno2
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/scalaEsterna') RES_scalaEsterna
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/secondario') RES_secondario
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/piano') RES_piano
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/nui') RES_nui
     , extractValue(value(rowdata),w_root||'/indirizzo/numeroCivico/civicoInterno/isolato') RES_isolato
     , extractValue(value(rowdata),w_root||'/localitaEstera/indirizzoEstero/cap') RES_capEstero
     , extractValue(value(rowdata),w_root||'/localitaEstera/indirizzoEstero/localita/descrizioneLocalita') RES_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/localitaEstera/indirizzoEstero/localita/descrizioneStato') RES_descrizioneStato
     , extractValue(value(rowdata),w_root||'/localitaEstera/indirizzoEstero/localita/codiceStato') RES_codiceStato
     , extractValue(value(rowdata),w_root||'/localitaEstera/indirizzoEstero/localita/provinciaContea') RES_provinciaContea
     , extractValue(value(rowdata),w_root||'/localitaEstera/indirizzoEstero/toponimo/denominazione') RES_toponimoEstero
     , extractValue(value(rowdata),w_root||'/localitaEstera/consolato/codiceConsolato') RES_codiceConsolato
     , extractValue(value(rowdata),w_root||'/localitaEstera/consolato/descrizioneConsolato') RES_descrizioneConsolato
     , extractValue(value(rowdata),w_root||'/presso') RES_presso
     , extractValue(value(rowdata),w_root||'/dataDecorrenzaResidenza') RES_dataDecorrenzaResidenza
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_liste (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/elettore') ELE_elettore
-- listaGenerale
  -- comune
      , extractValue(value(rowdata),w_root||'/listaGenerale/comune/nomeComune') ELE_nomeComune
      , extractValue(value(rowdata),w_root||'/listaGenerale/comune/codiceIstat') ELE_codiceIstat
      , extractValue(value(rowdata),w_root||'/listaGenerale/comune/siglaProvinciaIstat') ELE_siglaProvinciaIstat
      , extractValue(value(rowdata),w_root||'/listaGenerale/comune/descrizioneLocalita') ELE_descrizioneLocalita
      , extractValue(value(rowdata),w_root||'/listaGenerale/sezioneelettoralenum') ELE_sezioneelettoralenum
-- listaAggiuntaUE
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/ueelettorecomunali') ELAC_ueelettorecomunali
  -- listaAggiuntaUEComunali
    -- comune
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEComunali/comune/nomeComune') ELAC_nomeComune
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEComunali/comune/codiceIstat') ELAC_codiceIstat
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEComunali/comune/siglaProvinciaIstat') ELAC_siglaProvinciaIstat
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEComunali/comune/descrizioneLocalita') ELAC_descrizioneLocalita
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEComunali/sezioneelettoralenum') ELAC_sezioneelettoralenum
--
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/ueelettoreparlamento') ELAE_ueelettoreparlamento
  -- listaAggiuntaUEParlamento
    -- comune
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEParlamento/comune/nomeComune') ELAE_nomeComune
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEParlamento/comune/codiceIstat') ELAE_codiceIstat
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEParlamento/comune/siglaProvinciaIstat') ELAE_siglaProvinciaIstat
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEParlamento/comune/descrizioneLocalita') ELAE_descrizioneLocalita
      , extractValue(value(rowdata),w_root||'/listaAggiuntaUE/listaAggiuntaUEParlamento/sezioneelettoralenum') ELAE_sezioneelettoralenum
  -- listaAggiuntaComReg
      , extractValue(value(rowdata),w_root||'/listaAggiuntaComReg/comregelettorebolzano') ELAB_comregelettorebolzano
      , extractValue(value(rowdata),w_root||'/listaAggiuntaComReg/comregelettoretrento') ELAT_comregelettoretrento
      , extractValue(value(rowdata),w_root||'/listaAggiuntaComReg/comregelettorevalledaosta') ELAV_comregelettorevalledaosta
  -- listaBolTreVal
    -- comune
      , extractValue(value(rowdata),w_root||'/listaAggiuntaComReg/listaBolTreVal/comune/nomeComune') ELABTV_nomeComune
      , extractValue(value(rowdata),w_root||'/listaAggiuntaComReg/listaBolTreVal/comune/codiceIstat') ELABTV_codiceIstat
      , extractValue(value(rowdata),w_root||'/listaAggiuntaComReg/listaBolTreVal/comune/siglaProvinciaIstat') ELABTV_siglaProvinciaIstat
      , extractValue(value(rowdata),w_root||'/listaAggiuntaComReg/listaBolTreVal/comune/descrizioneLocalita') ELABTV_descrizioneLocalita
      , extractValue(value(rowdata),w_root||'/listaAggiuntaComReg/listaBolTreVal/sezioneelettoralenum') ELABTV_sezioneelettoralenum
--
      , extractValue(value(rowdata),w_root||'/referendumnazionali') ELE_referendumnazionali
      , extractValue(value(rowdata),w_root||'/elezionimembriue') ELE_elezionimembriue
      , extractValue(value(rowdata),w_root||'/senatorepubblica') ELE_senatorepubblica
      , extractValue(value(rowdata),w_root||'/circoscrsenatorepubblica') ELE_circoscrsenatorepubblica
      , extractValue(value(rowdata),w_root||'/cameradeputati') ELE_cameradeputati
      , extractValue(value(rowdata),w_root||'/circoscrcameradeputati') ELE_circoscrcameradeputati
      , extractValue(value(rowdata),w_root||'/regionali') ELE_regionali
      , extractValue(value(rowdata),w_root||'/comunali') ELE_comunali
      , extractValue(value(rowdata),w_root||'/circoscrizionali') ELE_circoscrizionali
-- sezione
  -- comune
      , extractValue(value(rowdata),w_root||'/sezione/comune/nomeComune') SEZ_nomeComune
      , extractValue(value(rowdata),w_root||'/sezione/comune/codiceIstat') SEZ_codiceIstat
      , extractValue(value(rowdata),w_root||'/sezione/comune/siglaProvinciaIstat') SEZ_siglaProvinciaIstat
      , extractValue(value(rowdata),w_root||'/sezione/comune/descrizioneLocalita') SEZ_descrizioneLocalita
--
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoralenum') SEZ_sezioneelettoralenum
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraledenom') SEZ_sezioneelettoraledenom
  -- sezioneelettoraleind
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/cap') SEZIND_cap
     -- comune
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/comune/nomeComune') SEZIND_nomeComune
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/comune/codiceIstat') SEZIND_codiceIstat
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/comune/siglaProvinciaIstat') SEZIND_siglaProvinciaIstat
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/comune/descrizioneLocalita') SEZIND_descrizioneLocalita
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/frazione') SEZIND_frazione
      -- toponimo
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/toponimo/codSpecie') SEZIND_codSpecie
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/toponimo/specie') SEZIND_specie
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/toponimo/specieFonte') SEZIND_specieFonte
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/toponimo/codToponimo') SEZIND_codToponimo
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/toponimo/denominazioneToponimo') SEZIND_denominazioneToponimo
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/toponimo/toponimoFonte') SEZIND_toponimoFonte
      -- numeroCivico
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/codiceCivico') SEZIND_codiceCivico
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoFonte') SEZIND_civicoFonte
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/numero') SEZIND_numero
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/metrico') SEZIND_metrico
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/progSNC') SEZIND_progSNC
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/lettera') SEZIND_lettera
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/esponente1') SEZIND_esponente1
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/colore') SEZIND_colore
        -- civicoInterno
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/corte') SEZIND_corte
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/scala') SEZIND_scala
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/interno1') SEZIND_interno1
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/espInterno1') SEZIND_espInterno1
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/interno2') SEZIND_interno2
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/espInterno2') SEZIND_espInterno2
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/scalaEsterna') SEZIND_scalaEsterna
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/secondario') SEZIND_secondario
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/piano') SEZIND_piano
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/nui') SEZIND_nui
      , extractValue(value(rowdata),w_root||'/sezione/sezioneelettoraleind/numeroCivico/civicoInterno/isolato') SEZIND_isolato
--
      , extractValue(value(rowdata),w_root||'/sezione/circoscrelezionimembriue') ELE_circoscrelezionimembriue
      , extractValue(value(rowdata),w_root||'/sezione/collegiocameradeputati') ELE_collegiocameradeputati
      , extractValue(value(rowdata),w_root||'/sezione/circoscrregionali') ELE_circoscrregionali
      , extractValue(value(rowdata),w_root||'/sezione/circosrizioneelezcircosc') ELE_circosrizioneelezcircosc
      , extractValue(value(rowdata),w_root||'/sezione/collegiosenatorepubblica') ELE_collegiosenatorepubblica
--
      , extractValue(value(rowdata),w_root||'/tipoConsultazione') ELE_tipoConsultazione
      , extractValue(value(rowdata),w_root||'/dataCancellazioneLista') ELE_dataCancellazioneLista
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_errori (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/codiceErroreAnomalia') ERR_codiceErrore
     , extractValue(value(rowdata),w_root||'/tipoErroreAnomalia') ERR_tipoErrore
     , extractValue(value(rowdata),w_root||'/testoErroreAnomalia') ERR_testoErrore
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_risposte (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/statoLavorazione') statoLavorazione
     , extractValue(value(rowdata),w_root||'/tipoOperazione') tipoOperazione
     , extract(value(rowdata),w_root||'/xmlRisposta').getClobVal() xmlRisposta
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_risposte_N (w_root varchar2) is
select extractValue(value(rowdata),w_root) xmlRisposta
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_risposta (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/operazioneRichiesta',w_extract_str_1||' '||w_extract_str_2) operazioneRichiesta
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_richiesta (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/idOperazioneANPR',w_extract_str_1||' '||w_extract_str_2) idOperazioneANPR
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_anomalie (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/codiceErroreAnomalia') codiceErrore
     , extractValue(value(rowdata),w_root||'/tipoErroreAnomalia') tipoErrore
     , extractValue(value(rowdata),w_root||'/testoErroreAnomalia') testoErrore
  from table(XMLSequence(w_xml)) rowdata
;

w_errore		varchar2(4000);
errore			exception;

w_stringa               varchar2(32000);

begin
w_step := 1;
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio', a_campo_clob);

  if a_servizio = '6001' and nvl(w_ora_31167,'N') = 'S' then   -- Porto Azzurro
w_step := 1.1;
     w_stringa         := substr(a_campo_clob,1,instr(a_campo_clob,'</idOperazioneANPR>')-1);
     w_stringa         := substr(w_stringa,instr(a_campo_clob,'<idOperazioneANPR>')+18);
     w_id_ANPR         := to_number(w_stringa);
ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'ora_31167', 'w_id_ANPR: '||w_id_anpr);

w_step := 1.2;
     w_stringa         := substr(a_campo_clob,1,instr(a_campo_clob,'</esitoOperazione>')-1);
     w_stringa         := substr(w_stringa,instr(a_campo_clob,'<esitoOperazione>')+17);
     w_esito_ANPR      := w_stringa;
ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'ora_31167', 'w_esito_ANPR: '||w_esito_ANPR);

w_step := 1.3;
     w_certificato_pdf := substr(a_campo_clob,instr(a_campo_clob,'<certificatoPdf>')+16);
     w_certificato_pdf := substr(w_certificato_pdf,1,instr(w_certificato_pdf,'</certificatoPdf>')-1);

     ANPR_pkg.ins_allegati(w_servizio_log,a_chiave,'',w_certificato_pdf,'S');
     goto salta_listaAnomalie;
  end if;

  begin
    select tws.risposta_ok_str,
           tws.risposta_ok_str_1, tws.risposta_ok_str_2, tws.risposta_ok_str_3, tws.risposta_ok_str_4, tws.risposta_ok_str_5
      into w_extract_str, w_extract_str_1, w_extract_str_2, w_extract_str_3, w_extract_str_4, w_extract_str_5
      from anptws tws
     where codice = a_servizio
    ;
  exception
    when others then
         w_extract_str   := '';
         w_extract_str_1 := '';
         w_extract_str_2 := '';
         w_extract_str_3 := '';
         w_extract_str_4 := '';
         w_extract_str_5 := '';
  end;

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio', a_campo_clob);

  begin
    w_xml 	:= xmltype(a_campo_clob);
--    ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'xmltype - ok');
  exception
    when others then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'xmltype - errore', sqlerrm);
  end;

<< testataRisposta >>
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta - inizio', a_campo_clob);
  w_xml 	:= xmltype(a_campo_clob);
  w_xml 	:= w_xml.extract(w_extract_str||'/testataRisposta'
                                ,w_extract_str_1||' '||w_extract_str_2);
  w_xml_clob	:= xmltype.getclobval(w_xml);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta - extract', w_xml_clob);

  for rec in sel_testata ('testataRisposta') loop
      w_id_ANPR    := rec.idOperazioneANPR;
      w_esito_ANPR := rec.esitoOperazioneANPR;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta', 'idOperazioneANPR: '||w_id_ANPR||' - esito: '||w_esito_ANPR);
  end loop;

  if a_servizio = '6001' then
-- <ns2:Risposta6001 xmlns:ns2="http://sogei.it/ANPR/6001certificazione">
-- 	<ns2:Risposta6001OK>
-- 		<file>
-- 			<certificatoPdf></certificatoPdf>
-- 		</file>
-- 	</ns2:Risposta6001OK>
-- </ns2:Risposta6001>
     goto file_pdf;

  elsif a_servizio in ('3005','7002') then
-- <ns2:Risposta3005 xmlns:ns2="http://sogei.it/ANPR/3000consultazione">
-- 	<ns2:Risposta3005_OK>
-- 		<datiRichiesta>
-- 			<idOperazioneANPR>646349</idOperazioneANPR>
-- 		</datiRichiesta>
-- 		<file>
-- 			<xmlFile></xmlFile>
-- 		</file>
-- 	</ns2:Risposta3005_OK>
-- </ns2:Risposta3005>
     goto file_xml;

  elsif a_servizio = '3002' then
     goto listaSoggetti;

  elsif a_servizio in ('3003','3007','N010','N014','N015','N017','N020','N030','N031','NRIS','NA00','NA01','NA02','NA03','NA04','NA05') then
--
-- <ns2:Risposta3003 xmlns:ns2="http://sogei.it/ANPR/3000consultazione">
-- 	<ns2:Risposta3003_OK>
-- 		<elencoRisposte>
-- 			<statoLavorazione>2</statoLavorazione>
-- 			<tipoOperazione>5008</tipoOperazione>
-- 			<xmlRisposta></xmlRisposta>
-- 		</elencoRisposte>
-- 	</ns2:Risposta3003_OK>
-- </ns2:Risposta3003>
--
     goto elencoRisposte;
  else
     goto fine;
  end if;

<< elencoRisposte >>
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'elencoRisposte - inizio', a_campo_clob);
  w_xml 	:= xmltype(a_campo_clob);
--  w_xml 	:= w_xml.extract(w_extract_str||'/elencoRisposte/xmlRisposta'
--                                ,w_extract_str_1||' '||w_extract_str_2);
  w_xml 	:= w_xml.extract(w_extract_str||'/elencoRisposte'
                                ,w_extract_str_1||' '||w_extract_str_2);
  w_xml_clob    := xmltype.getclobval(w_xml);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'elencoRisposte - extract', w_xml_clob);

--  for rec in sel_risposte_N ('xmlRisposta') loop
  for rec in sel_risposte ('elencoRisposte') loop
      w_risposta_xml  := xmltype(rec.xmlRisposta);
      w_risposta_xml  := w_risposta_xml.extract('/xmlRisposta/child::node()');
--      w_risposta_b64  := rec.xmlRisposta;
      w_risposta_b64  := xmltype.getclobval(w_risposta_xml);
      w_risposta_blob := anpr_pkg.decode_base64(w_risposta_b64);
      w_risposta_clob := anpr_pkg.blob_to_clob(w_risposta_blob);

--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'elencoRisposte', w_risposta_b64);
      if a_servizio = '3003' then
         w_statoLavorazione := rec.statoLavorazione;
         w_tipoOperazione   := rec.tipoOperazione;
         ANPR_pkg.acquisisci_operazioni(a_servizio,a_id_operazione,w_statoLavorazione,w_tipoOperazione,w_risposta_clob);
      else
         ANPR_pkg.acquisisci_notifiche(a_servizio,w_risposta_clob);
      end if;
  end loop;

  goto fine;

<< listaSoggetti >>
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'Soggetti - inizio', a_campo_clob);
  w_xml 	:= xmltype(a_campo_clob);
  w_xml 	:= w_xml.extract(w_extract_str||'/listaSoggetti/datiSoggetto'
                                ,w_extract_str_1||' '||w_extract_str_2);
  w_xml_clob    := xmltype.getclobval(w_xml);
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti - extract', w_xml_clob);

  begin
    delete anpana
     where id_operazione = a_id_operazione
    ;
  end;
  for rec in sel_soggetti ('datiSoggetto') loop
      if rec.cittadinanza is not null then
         w_xml      := xmltype('<ROOT>'||rec.cittadinanza||'</ROOT>');
         w_xml      := w_xml.extract('/ROOT/cittadinanza'
                                     ,w_extract_str_1||' '||w_extract_str_2);
         w_xml_clob := xmltype.getclobval(w_xml);

         for rec_cit in sel_cittadinanza ('cittadinanza') loop
             w_CIT_descrizioneStato := rec_cit.CIT_descrizioneStato;
             w_CIT_codiceStato      := rec_cit.CIT_codiceStato;
             w_CIT_dataValidita     := rec_cit.CIT_dataValidita;
             exit;
         end loop;
      end if;

      if rec.cittadinanza_pd is not null then
         w_xml      := xmltype('<ROOT>'||rec.cittadinanza_pd||'</ROOT>');
         w_xml      := w_xml.extract('/ROOT/cittadinanza'
                                     ,w_extract_str_1||' '||w_extract_str_2);
         w_xml_clob := xmltype.getclobval(w_xml);

         for rec_cit in sel_cittadinanza ('cittadinanza') loop
             w_CIT_descrizioneStato_pd := rec_cit.CIT_descrizioneStato;
             w_CIT_codiceStato_pd      := rec_cit.CIT_codiceStato;
             w_CIT_dataValidita_pd     := rec_cit.CIT_dataValidita;
             exit;
         end loop;
      end if;

      if rec.cittadinanza_md is not null then
         w_xml      := xmltype('<ROOT>'||rec.cittadinanza_md||'</ROOT>');
         w_xml      := w_xml.extract('/ROOT/cittadinanza'
                                     ,w_extract_str_1||' '||w_extract_str_2);
         w_xml_clob := xmltype.getclobval(w_xml);

         for rec_cit in sel_cittadinanza ('cittadinanza') loop
             w_CIT_descrizioneStato_md := rec_cit.CIT_descrizioneStato;
             w_CIT_codiceStato_md      := rec_cit.CIT_codiceStato;
             w_CIT_dataValidita_md     := rec_cit.CIT_dataValidita;
             exit;
         end loop;
      end if;

      if rec.cittadinanza_cn is not null then
         w_xml      := xmltype('<ROOT>'||rec.cittadinanza_cn||'</ROOT>');
         w_xml      := w_xml.extract('/ROOT/cittadinanza'
                                     ,w_extract_str_1||' '||w_extract_str_2);
         w_xml_clob := xmltype.getclobval(w_xml);

         for rec_cit in sel_cittadinanza ('cittadinanza') loop
             w_CIT_descrizioneStato_cn := rec_cit.CIT_descrizioneStato;
             w_CIT_codiceStato_cn      := rec_cit.CIT_codiceStato;
             w_CIT_dataValidita_cn     := rec_cit.CIT_dataValidita;
             exit;
         end loop;
      end if;

      if rec.cittadinanza_uc is not null then
         w_xml      := xmltype('<ROOT>'||rec.cittadinanza_uc||'</ROOT>');
         w_xml      := w_xml.extract('/ROOT/cittadinanza'
                                     ,w_extract_str_1||' '||w_extract_str_2);
         w_xml_clob := xmltype.getclobval(w_xml);

         for rec_cit in sel_cittadinanza ('cittadinanza') loop
             w_CIT_descrizioneStato_uc := rec_cit.CIT_descrizioneStato;
             w_CIT_codiceStato_uc      := rec_cit.CIT_codiceStato;
             w_CIT_dataValidita_uc     := rec_cit.CIT_dataValidita;
             exit;
         end loop;
      end if;

      if rec.cittadinanza_cv is not null then
         w_xml      := xmltype('<ROOT>'||rec.cittadinanza_cv||'</ROOT>');
         w_xml      := w_xml.extract('/ROOT/cittadinanza'
                                     ,w_extract_str_1||' '||w_extract_str_2);
         w_xml_clob := xmltype.getclobval(w_xml);

         for rec_cit in sel_cittadinanza ('cittadinanza') loop
             w_CIT_descrizioneStato_cv := rec_cit.CIT_descrizioneStato;
             w_CIT_codiceStato_cv      := rec_cit.CIT_codiceStato;
             w_CIT_dataValidita_cv     := rec_cit.CIT_dataValidita;
             exit;
         end loop;
      end if;

      if rec.residenza is not null then
         w_xml      := xmltype('<ROOT>'||rec.residenza||'</ROOT>');
         w_xml      := w_xml.extract('/ROOT/residenza'
                                     ,w_extract_str_1||' '||w_extract_str_2);
         w_xml_clob := xmltype.getclobval(w_xml);

         for rec_res in sel_residenza ('residenza') loop
             w_RES_tipoIndirizzo         := rec_res.RES_tipoIndirizzo;
             w_RES_noteIndirizzo         := rec_res.RES_noteIndirizzo;
             w_RES_cap			 := rec_res.RES_cap;
             w_RES_nomeComune	  	 := rec_res.RES_nomeComune;
             w_RES_codiceIstat		 := rec_res.RES_codiceIstat;
             w_RES_siglaProvinciaIstat	 := rec_res.RES_siglaProvinciaIstat;
             w_RES_frazione		 := rec_res.RES_frazione;
             w_RES_codSpecie	         := rec_res.RES_codSpecie;
             w_RES_specie		 := rec_res.RES_specie;
             w_RES_specieFonte		 := rec_res.RES_specieFonte;
             w_RES_codToponimo		 := rec_res.RES_codToponimo;
             w_RES_denominazioneToponimo := rec_res.RES_denominazioneToponimo;
             w_RES_toponimoFonte	 := rec_res.RES_toponimoFonte;
             w_RES_codiceCivico		 := rec_res.RES_codiceCivico;
             w_RES_civicoFonte		 := rec_res.RES_civicoFonte;
             w_RES_numero		 := rec_res.RES_numero;
             w_RES_metrico		 := rec_res.RES_metrico;
             w_RES_progSNC		 := rec_res.RES_progSNC;
             w_RES_lettera		 := rec_res.RES_lettera;
             w_RES_esponente1		 := rec_res.RES_esponente1;
             w_RES_colore		 := rec_res.RES_colore;
             w_RES_corte		 := rec_res.RES_corte;
             w_RES_scala		 := rec_res.RES_scala;
             w_RES_interno1		 := rec_res.RES_interno1;
             w_RES_espInterno1		 := rec_res.RES_espInterno1;
             w_RES_interno2		 := rec_res.RES_interno2;
             w_RES_espInterno2		 := rec_res.RES_espInterno2;
             w_RES_scalaEsterna		 := rec_res.RES_scalaEsterna;
             w_RES_secondario		 := rec_res.RES_secondario;
             w_RES_piano		 := rec_res.RES_piano;
             w_RES_nui		 	 := rec_res.RES_nui;
             w_RES_isolato		 := rec_res.RES_isolato;
             w_RES_capEstero		 := rec_res.RES_capEstero;
             w_RES_descrizioneLocalita	 := rec_res.RES_descrizioneLocalita;
             w_RES_descrizioneStato	 := rec_res.RES_descrizioneStato;
             w_RES_codiceStato	 	 := rec_res.RES_codiceStato;
             w_RES_provinciaContea	 := rec_res.RES_provinciaContea;
             w_RES_toponimoEstero	 := rec_res.RES_toponimoEstero;
             w_RES_codiceConsolato	 := rec_res.RES_codiceConsolato;
             w_RES_descrizioneConsolato	 := rec_res.RES_descrizioneConsolato;
             w_RES_presso		 := rec_res.RES_presso;
             w_RES_dataDecorrenzaResidenza := rec_res.RES_dataDecorrenzaResidenza;
             exit;
         end loop;
      end if;

      begin
        insert into anpana
               (id_operazione, matricola_ads
               ,codFiscale,validitaCF,dataAttribuzioneValidita
               ,cognome,senzaCognome,nome,senzaNome,sesso
               ,dataNascita,senzaGiorno,senzaGiornoMese
-- nascita
               ,NAS_nomecomune,NAS_codiceIstat,NAS_siglaProvinciaIstat
               ,NAS_descrizioneLocalita,NAS_descrizioneStato,NAS_codiceStato
               ,NAS_luogoEccezionale
               ,idSoggettoComuneIstat,idSoggettoComune,idSoggettoANPR
               ,soggettoAIRE
               ,statoCivile,noteStatoCivile
               ,senzaFissaDimora,soggettoCertificabile
               ,ATTNAS_nomeComune,ATTNAS_codiceIstat,ATTNAS_siglaProvinciaIstat
               ,ATTNAS_ufficioMunicipio,ATTNAS_anno,ATTNAS_parte,ATTNAS_serie,ATTNAS_numeroAtto
               ,ATTNAS_dataFormazioneAtto,ATTNAS_trascritto
               ,ATTNAS_numeroComunale,ATTNAS_idANSC
               ,CIT_descrizioneStato,CIT_codiceStato,CIT_dataValidita
-- paternita
               ,codFiscale_pd,validitaCF_pd,dataAttribuzioneValidita_pd
               ,cognome_pd,senzaCognome_pd,nome_pd,senzaNome_pd,sesso_pd
               ,dataNascita_pd,senzaGiorno_pd,senzaGiornoMese_pd
               ,NAS_nomecomune_pd,NAS_codiceIstat_pd,NAS_siglaProvinciaIstat_pd
               ,NAS_descrizioneLocalita_pd,NAS_descrizioneStato_pd,NAS_codiceStato_pd
               ,NAS_luogoEccezionale_pd
               ,idSoggettoComuneIstat_pd,idSoggettoComune_pd,idSoggettoANPR_pd
               ,soggettoAIRE_pd
               ,statoCivile_pd,noteStatoCivile_pd
               ,CIT_descrizioneStato_pd,CIT_codiceStato_pd,CIT_dataValidita_pd
-- maternita
               ,codFiscale_md,validitaCF_md,dataAttribuzioneValidita_md
               ,cognome_md,senzaCognome_md,nome_md,senzaNome_md,sesso_md
               ,dataNascita_md,senzaGiorno_md,senzaGiornoMese_md
               ,NAS_nomecomune_md,NAS_codiceIstat_md,NAS_siglaProvinciaIstat_md
               ,NAS_descrizioneLocalita_md,NAS_descrizioneStato_md,NAS_codiceStato_md
               ,NAS_luogoEccezionale_md
               ,idSoggettoComuneIstat_md,idSoggettoComune_md,idSoggettoANPR_md
               ,soggettoAIRE_md
               ,statoCivile_md,noteStatoCivile_md
               ,CIT_descrizioneStato_md,CIT_codiceStato_md,CIT_dataValidita_md
-- residenza
               ,RES_tipoIndirizzo,RES_noteIndirizzo
               ,RES_cap,RES_nomeComune,RES_codiceIstat,RES_siglaProvinciaIstat
               ,RES_frazione
               ,RES_codspecie,RES_specie,RES_specieFonte
               ,RES_codToponimo,RES_denominazioneToponimo,RES_toponimoFonte
               ,RES_codiceCivico,RES_civicoFonte,RES_numero
               ,RES_metrico,RES_progSNC,RES_lettera,RES_esponente1,RES_colore
               ,RES_corte,RES_scala,RES_interno1,RES_espInterno1,RES_interno2,RES_espInterno2
               ,RES_scalaEsterna,RES_secondario,RES_piano,RES_nui,RES_isolato
               ,RES_dataDecorrenzaResidenza
               ,RES_capEstero,RES_descrizioneLocalita,RES_descrizioneStato,RES_codiceStato,RES_provinciaContea
               ,RES_toponimoEstero,RES_codiceConsolato,RES_descrizioneConsolato
               ,RES_presso
               ,TRA_cognome,TRA_nome,TRA_denominazioneToponimo,TRA_denominazioneComune
               ,ELE_elettore,ELE_nomeComune,ELE_codiceIstat,ELE_siglaProvinciaIstat
               ,LEV_iscritto
-- documentoIdentita
               ,DI_numero,DI_dataRilascio,DI_cartaceaElettronica,DI_interdizioneEspatrio
               ,DI_nomeComune,DI_codiceIstat,DI_siglaProvinciaIstat
               ,DI_dataScadenza,DI_dataAnnullamento
               ,DI_codiceConsolato,DI_descrizioneConsolato
-- documentoSoggiorno
               ,DS_numero,DS_tipoSoggiorno,DS_dataRilascio,DS_dataScadenza
               ,DS_questuraRilascioSoggiorno
               ,DS_nomeComune,DS_codiceIstat,DS_siglaProvinciaIstat
               ,DS_numeroPassaporto
-- matrimonio
               ,codFiscale_cn,validitaCF_cn,dataAttribuzioneValidita_cn
               ,cognome_cn,senzaCognome_cn,nome_cn,senzaNome_cn,sesso_cn
               ,dataNascita_cn,senzaGiorno_cn,senzaGiornoMese_cn
               ,NAS_nomecomune_cn,NAS_codiceIstat_cn,NAS_siglaProvinciaIstat_cn
               ,NAS_descrizioneLocalita_cn,NAS_descrizioneStato_cn,NAS_codiceStato_cn
               ,NAS_luogoEccezionale_cn
               ,idSoggettoComuneIstat_cn,idSoggettoComune_cn,idSoggettoANPR_cn
               ,CIT_descrizioneStato_cn,CIT_codiceStato_cn,CIT_dataValidita_cn
               ,MAT_dataEvento,MAT_senzaGiorno,MAT_senzaGiornoMese
               ,MAT_nomecomune,MAT_codiceIstat,MAT_siglaProvinciaIstat
               ,MAT_descrizioneLocalita,MAT_descrizioneStato,MAT_codiceStato
               ,MAT_luogoEccezionale
               ,ATTMAT_nomeComune,ATTMAT_codiceIstat,ATTMAT_siglaProvinciaIstat
               ,ATTMAT_ufficioMunicipio,ATTMAT_anno,ATTMAT_parte,ATTMAT_serie,ATTMAT_numeroAtto
               ,ATTMAT_dataFormazioneAtto,ATTMAT_trascritto
               ,ATTMAT_numeroComunale,ATTMAT_idANSC
               ,MAT_ordineMatrimonio
-- vedovanza
               ,VED_dataEvento,VED_senzaGiorno,VED_senzaGiornoMese
               ,VED_nomecomune,VED_codiceIstat,VED_siglaProvinciaIstat
               ,VED_descrizioneLocalita,VED_descrizioneStato,VED_codiceStato
               ,VED_luogoEccezionale
               ,ATTVED_nomeComune,ATTVED_codiceIstat,ATTVED_siglaProvinciaIstat
               ,ATTVED_ufficioMunicipio,ATTVED_anno,ATTVED_parte,ATTVED_serie,ATTVED_numeroAtto
               ,ATTVED_dataFormazioneAtto,ATTVED_trascritto
               ,ATTVED_numeroComunale,ATTVED_idANSC
-- divorzio
               ,DIV_tipoCessazione
               ,DIV_dataSentenza,DIV_numeroSentenza
               ,DIV_tipoTribunaleSentenza,DIV_autoritaSentenza,DIV_dataValiditaSentenza
               ,ATTDIV_nomeComune,ATTDIV_codiceIstat,ATTDIV_siglaProvinciaIstat
               ,ATTDIV_ufficioMunicipio,ATTDIV_anno,ATTDIV_parte,ATTDIV_serie,ATTDIV_numeroAtto
               ,ATTDIV_dataFormazioneAtto,ATTDIV_trascritto
               ,ATTDIV_numeroComunale,ATTDIV_idANSC
-- unioneCivile
               ,codFiscale_uc,validitaCF_uc,dataAttribuzioneValidita_uc
               ,cognome_uc,senzaCognome_uc,nome_uc,senzaNome_uc,sesso_uc
               ,dataNascita_uc,senzaGiorno_uc,senzaGiornoMese_uc
               ,NAS_nomecomune_uc,NAS_codiceIstat_uc,NAS_siglaProvinciaIstat_uc
               ,NAS_descrizioneLocalita_uc,NAS_descrizioneStato_uc,NAS_codiceStato_uc
               ,NAS_luogoEccezionale_uc
               ,idSoggettoComuneIstat_uc,idSoggettoComune_uc,idSoggettoANPR_uc
               ,UCI_dataEvento,UCI_senzaGiorno,UCI_senzaGiornoMese
               ,UCI_nomecomune,UCI_codiceIstat,UCI_siglaProvinciaIstat
               ,UCI_descrizioneLocalita,UCI_descrizioneStato,UCI_codiceStato
               ,UCI_luogoEccezionale
               ,ATTUCI_nomeComune,ATTUCI_codiceIstat,ATTUCI_siglaProvinciaIstat
               ,ATTUCI_ufficioMunicipio,ATTUCI_anno,ATTUCI_parte,ATTUCI_serie,ATTUCI_numeroAtto
               ,ATTUCI_dataFormazioneAtto,ATTUCI_trascritto
               ,ATTUCI_numeroComunale,ATTUCI_idANSC
-- scioglimentoUnione
               ,SCI_motivoScioglimento,SCI_dataSentenza,SCI_numeroSentenza
               ,SCI_tipoTribunaleSentenza,SCI_autoritaSentenza,SCI_dataValiditaSentenza,SCI_dataEvento
               ,SCI_nomecomune,SCI_codiceIstat,SCI_siglaProvinciaIstat
               ,SCI_descrizioneLocalita,SCI_descrizioneStato,SCI_codiceStato
               ,SCI_luogoEccezionale
               ,ATTSCI_nomeComune,ATTSCI_codiceIstat,ATTSCI_siglaProvinciaIstat
               ,ATTSCI_ufficioMunicipio,ATTSCI_anno,ATTSCI_parte,ATTSCI_serie,ATTSCI_numeroAtto
               ,ATTSCI_dataFormazioneAtto,ATTSCI_trascritto
               ,ATTSCI_numeroComunale,ATTSCI_idANSC
               ,CIT_descrizioneStato_uc,CIT_codiceStato_uc,CIT_dataValidita_uc
               ,UCI_ordineUnione
-- convivenzaDiFatto
               ,codFiscale_cv,validitaCF_cv,dataAttribuzioneValidita_cv
               ,cognome_cv,senzaCognome_cv,nome_cv,senzaNome_cv,sesso_cv
               ,dataNascita_cv,senzaGiorno_cv,senzaGiornoMese_cv
               ,NAS_nomecomune_cv,NAS_codiceIstat_cv,NAS_siglaProvinciaIstat_cv
               ,NAS_descrizioneLocalita_cv,NAS_descrizioneStato_cv,NAS_codiceStato_cv
               ,NAS_luogoEccezionale_cv
               ,idSoggettoComuneIstat_cv,idSoggettoComune_cv,idSoggettoANPR_cv
               ,CIT_descrizioneStato_cv,CIT_codiceStato_cv,CIT_dataValidita_cv
               ,CDFSTI_data
               ,CDFSTI_dataNotifica,CDFSTI_dataDocumento,CDFSTI_protocollo
               ,CDFSTI_nomeComune,CDFSTI_codiceIstat,CDFSTI_siglaProvinciaIstat
               ,CDFSTI_professionista
               ,CDFSTI_nomeComuneReg,CDFSTI_codiceIstatReg,CDFSTI_siglaProvinciaIstatReg
               ,CDFSTI_stato
               ,CDFRIS_motivoRisoluzione,CDFRIS_data
               ,CDFRIS_dataNotifica,CDFRIS_dataDocumento,CDFRIS_protocollo
               ,CDFRIS_nomeComune,CDFRIS_codiceIstat,CDFRIS_siglaProvinciaIstat
               ,CDFRIS_professionista
               ,CDFRIS_nomeComuneReg,CDFRIS_codiceIstatReg,CDFRIS_siglaProvinciaIstatReg
               ,CDFRIS_stato
-- famiglia
               ,FAM_tipoLegame,FAM_dataDecorrenza,FAM_codiceLegame,FAM_dataDecorrenzaLegame
               ,FAM_idFamigliaComuneIstat,FAM_idFamigliaComune,FAM_idFamigliaANPR,FAM_famigliaAire
               ,FAM_dataOrigineFamiglia,FAM_denominazioneConvivenza,FAM_specieConvivenza
               ,FAM_presenzaFamigliaCoabitante,FAM_tipoScheda
               ,annoCensimento,sezioneCensimento,foglioCensimento
               ,posizioneProfessionale,condizioneNonProfessionale,titoloStudio
               ,possessoAutoveicoli,possessoPatente
-- iscrizione
               ,ISC_dataIscrizione,ISC_protocolloComune,ISC_nomeComune,ISC_codiceIstat,ISC_siglaProvinciaIstat
               ,ISC_idOperazioneComune,ISC_idOperazioneANPR,ISC_dataDefinizionePratica
               ,ISC_motivoIscrizione,ISC_desMotivoIscrizione
               ,ISC_motivoIscrizioneAire,ISC_iniziativaAire,ISC_individuazioneAire
               ,ISC_dataArrivoConsolato
               ,PRO_nomeComune,PRO_codiceIstat,PRO_siglaProvinciaIstat
               ,PRO_descrizioneLocalita,PRO_descrizioneStato,PRO_codiceStato
-- cancellazione
               ,CAN_MOTIVOCANCELLAZIONE,CAN_NOTECANCELLAZIONE,CAN_DATADECORRENZA
               ,DES_NOMECOMUNE,DES_CODICEISTAT,DES_SIGLAPROVINCIAISTAT
               ,DES_DESCRIZIONELOCALITA,DES_DESCRIZIONESTATO,DES_CODICESTATO
-- morte
               ,MOR_DATAEVENTO,MOR_senzaGiorno,MOR_senzaGiornoMese
               ,MOR_NOMECOMUNE,MOR_CODICEISTAT,MOR_SIGLAPROVINCIAISTAT
               ,MOR_DESCRIZIONELOCALITA,MOR_DESCRIZIONESTATO,MOR_CODICESTATO
               ,MOR_luogoEccezionale
               ,ATTMOR_NOMECOMUNE,ATTMOR_CODICEISTAT,ATTMOR_SIGLAPROVINCIAISTAT
               ,ATTMOR_UFFICIOMUNICIPIO,ATTMOR_ANNO,ATTMOR_PARTE,ATTMOR_SERIE,ATTMOR_NUMEROATTO
               ,ATTMOR_DATAFORMAZIONEATTO,ATTMOR_TRASCRITTO
               ,ATTMOR_numeroComunale,ATTMOR_idANSC
               ,ELE_CERTIFICABILITA,ELE_MOTIVOCANCELLAZIONE,ELE_NOTECANCELLAZIONE,ELE_TIPOCONSULTAZIONE,ELE_DATACANCELLAZIONE
-- idANPR
               ,idANPR
               )
        values (a_id_operazione, to_number(a_chiave)
               ,rec.codFiscale,rec.validitaCF,rec.dataAttribuzioneValidita
               ,rec.cognome,rec.senzaCognome,rec.nome,rec.senzaNome,rec.sesso
-- nascita
               ,rec.dataNascita,rec.senzaGiorno,rec.senzaGiornoMese
               ,rec.NAS_nomecomune,rec.NAS_codiceIstat,rec.NAS_siglaProvinciaIstat
               ,rec.NAS_descrizioneLocalita,rec.NAS_descrizioneStato,rec.NAS_codiceStato
               ,rec.NAS_luogoEccezionale
               ,rec.idSoggettoComuneIstat,rec.idSoggettoComune,rec.idSoggettoANPR
               ,rec.soggettoAIRE
               ,rec.statoCivile,rec.noteStatoCivile
               ,rec.senzaFissaDimora,rec.soggettoCertificabile
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'',rec.ANSNAS_nomeComune,rec.ANPNAS_nomeComune),
                  rec.ATTNAS_nomeComune)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'',rec.ANSNAS_codiceIstat,rec.ANPNAS_codiceIstat),
                  rec.ATTNAS_codiceIstat)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'',rec.ANSNAS_siglaProvinciaIstat,rec.ANPNAS_siglaProvinciaIstat),
                  rec.ATTNAS_siglaProvinciaIstat)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'',rec.ANsNAS_ufficioMunicipio,rec.ANPNAS_ufficioMunicipio),
                  rec.ATTNAS_ufficioMunicipio)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'',rec.ANSNAS_anno,rec.ANPNAS_anno),
                  rec.ATTNAS_anno)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'','',rec.ANPNAS_parte),
                  rec.ATTNAS_parte)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'','',rec.ANPNAS_serie),
                  rec.ATTNAS_serie)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'','',rec.ANPNAS_numeroAtto),
                  rec.ATTNAS_numeroAtto)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'',rec.ANSNAS_dataFormazioneAtto,rec.ANPNAS_dataFormazioneAtto),
                  rec.ATTNAS_dataFormazioneAtto)
               ,decode(rec.ATTNAS_numeroAtto,'',
                  decode(rec.ANPNAS_numeroAtto,'',rec.ANSNAS_trascritto,rec.ANPNAS_trascritto),
                  rec.ATTNAS_trascritto)
               ,decode(rec.ATTNAS_numeroAtto,'',decode(rec.ANPNAS_numeroAtto,'',rec.ANSNAS_numeroComunale))
               ,decode(rec.ATTNAS_numeroAtto,'',decode(rec.ANPNAS_numeroAtto,'',rec.ANSNAS_idANSC))
               ,w_CIT_descrizioneStato,w_CIT_codiceStato,w_CIT_dataValidita
-- paternita
               ,rec.codFiscale_pd,rec.validitaCF_pd,rec.dataAttribuzioneValidita_pd
               ,rec.cognome_pd,rec.senzaCognome_pd,rec.nome_pd,rec.senzaNome_pd,rec.sesso_pd
               ,rec.dataNascita_pd,rec.senzaGiorno_pd,rec.senzaGiornoMese_pd
               ,rec.NAS_nomecomune_pd,rec.NAS_codiceIstat_pd,rec.NAS_siglaProvinciaIstat_pd
               ,rec.NAS_descrizioneLocalita_pd,rec.NAS_descrizioneStato_pd,rec.NAS_codiceStato_pd
               ,rec.NAS_luogoEccezionale_pd
               ,rec.idSoggettoComuneIstat_pd,rec.idSoggettoComune_pd,rec.idSoggettoANPR_pd
               ,rec.soggettoAIRE_pd
               ,rec.statoCivile_pd,rec.noteStatoCivile_pd
               ,w_CIT_descrizioneStato_pd,w_CIT_codiceStato_pd,w_CIT_dataValidita_pd
-- maternita
               ,rec.codFiscale_md,rec.validitaCF_md,rec.dataAttribuzioneValidita_md
               ,rec.cognome_md,rec.senzaCognome_md,rec.nome_md,rec.senzaNome_md,rec.sesso_md
               ,rec.dataNascita_md,rec.senzaGiorno_md,rec.senzaGiornoMese_md
               ,rec.NAS_nomecomune_md,rec.NAS_codiceIstat_md,rec.NAS_siglaProvinciaIstat_md
               ,rec.NAS_descrizioneLocalita_md,rec.NAS_descrizioneStato_md,rec.NAS_codiceStato_md
               ,rec.NAS_luogoEccezionale_md
               ,rec.idSoggettoComuneIstat_md,rec.idSoggettoComune_md,rec.idSoggettoANPR_md
               ,rec.soggettoAIRE_md
               ,rec.statoCivile_md,rec.noteStatoCivile_md
               ,w_CIT_descrizioneStato_md,w_CIT_codiceStato_md,w_CIT_dataValidita_md
-- residenza
               ,w_RES_tipoIndirizzo,w_RES_noteIndirizzo
               ,w_RES_cap,w_RES_nomeComune,w_RES_codiceIstat,w_RES_siglaProvinciaIstat
               ,w_RES_frazione
               ,w_RES_codspecie,w_RES_specie,w_RES_specieFonte
               ,w_RES_codToponimo,w_RES_denominazioneToponimo,w_RES_toponimoFonte
               ,w_RES_codiceCivico,w_RES_civicoFonte,w_RES_numero
               ,w_RES_metrico,w_RES_progSNC,w_RES_lettera,w_RES_esponente1,w_RES_colore
               ,w_RES_corte,w_RES_scala,w_RES_interno1,w_RES_espInterno1,w_RES_interno2,w_RES_espInterno2
               ,w_RES_scalaEsterna,w_RES_secondario,w_RES_piano,w_RES_nui,w_RES_isolato
               ,w_RES_dataDecorrenzaResidenza
               ,w_RES_capEstero,w_RES_descrizioneLocalita,w_RES_descrizioneStato,w_RES_codiceStato,w_RES_provinciaContea
               ,w_RES_toponimoEstero,w_RES_codiceConsolato,w_RES_descrizioneConsolato
               ,w_RES_presso
               ,rec.TRA_cognome,rec.TRA_nome,rec.TRA_denominazioneToponimo,rec.TRA_denominazioneComune
               ,rec.ELE_elettore,rec.ELE_nomeComune,rec.ELE_codiceIstat,rec.ELE_siglaProvinciaIstat
               ,rec.LEV_iscritto
-- documentoIdentita
               ,rec.DI_numero,rec.DI_dataRilascio,rec.DI_cartaceaElettronica,rec.DI_interdizioneEspatrio
               ,rec.DI_nomeComune,rec.DI_codiceIstat,rec.DI_siglaProvinciaIstat
               ,rec.DI_dataScadenza,rec.DI_dataAnnullamento
               ,rec.DI_codiceConsolato,rec.DI_descrizioneConsolato
-- documentoSoggiorno
               ,rec.DS_numero,rec.DS_tipoSoggiorno,rec.DS_dataRilascio,rec.DS_dataScadenza
               ,rec.DS_questuraRilascioSoggiorno
               ,rec.DS_nomeComune,rec.DS_codiceIstat,rec.DS_siglaProvinciaIstat
               ,rec.DS_numeroPassaporto
-- matrimonio
               ,rec.codFiscale_cn,rec.validitaCF_cn,rec.dataAttribuzioneValidita_cn
               ,rec.cognome_cn,rec.senzaCognome_cn,rec.nome_cn,rec.senzaNome_cn,rec.sesso_cn
               ,rec.dataNascita_cn,rec.senzaGiorno_cn,rec.senzaGiornoMese_cn
               ,rec.NAS_nomecomune_cn,rec.NAS_codiceIstat_cn,rec.NAS_siglaProvinciaIstat_cn
               ,rec.NAS_descrizioneLocalita_cn,rec.NAS_descrizioneStato_cn,rec.NAS_codiceStato_cn
               ,rec.NAS_luogoEccezionale_cn
               ,rec.idSoggettoComuneIstat_cn,rec.idSoggettoComune_cn,rec.idSoggettoANPR_cn
               ,w_CIT_descrizioneStato_cn,w_CIT_codiceStato_cn,w_CIT_dataValidita_cn
               ,rec.MAT_dataEvento,rec.MAT_senzaGiorno,rec.MAT_senzaGiornoMese
               ,rec.MAT_nomecomune,rec.MAT_codiceIstat,rec.MAT_siglaProvinciaIstat
               ,rec.MAT_descrizioneLocalita,rec.MAT_descrizioneStato,rec.MAT_codiceStato
               ,rec.MAT_luogoEccezionale
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_nomeComune,rec.ANPMAT_nomeComune),
                  rec.ATTMAT_nomeComune)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_codiceIstat,rec.ANPMAT_codiceIstat),
                  rec.ATTMAT_codiceIstat)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_siglaProvinciaIstat,rec.ANPMAT_siglaProvinciaIstat),
                  rec.ATTMAT_siglaProvinciaIstat)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_ufficioMunicipio,rec.ANPMAT_ufficioMunicipio),
                  rec.ATTMAT_ufficioMunicipio)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_anno,rec.ANPMAT_anno),
                  rec.ATTMAT_anno)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'','',rec.ANPMAT_parte),
                  rec.ATTMAT_parte)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'','',rec.ANPMAT_serie),
                  rec.ATTMAT_serie)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'','',rec.ANPMAT_numeroAtto),
                  rec.ATTMAT_numeroAtto)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_dataFormazioneAtto,rec.ANPMAT_dataFormazioneAtto),
                  rec.ATTMAT_dataFormazioneAtto)
               ,decode(rec.ATTMAT_numeroAtto,'',
                  decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_trascritto,rec.ANPMAT_trascritto),
                  rec.ATTMAT_trascritto)
               ,decode(rec.ATTMAT_numeroAtto,'',decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_numeroComunale))
               ,decode(rec.ATTMAT_numeroAtto,'',decode(rec.ANPMAT_numeroAtto,'',rec.ANSMAT_idANSC))
               ,rec.MAT_ordineMatrimonio
-- vedovanza
               ,rec.VED_dataEvento,rec.VED_senzaGiorno,rec.VED_senzaGiornoMese
               ,rec.VED_nomecomune,rec.VED_codiceIstat,rec.VED_siglaProvinciaIstat
               ,rec.VED_descrizioneLocalita,rec.VED_descrizioneStato,rec.VED_codiceStato
               ,rec.VED_luogoEccezionale
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_nomeComune,rec.ANPVED_nomeComune),
                  rec.ATTVED_nomeComune)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_codiceIstat,rec.ANPVED_codiceIstat),
                  rec.ATTVED_codiceIstat)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_siglaProvinciaIstat,rec.ANPVED_siglaProvinciaIstat),
                  rec.ATTVED_siglaProvinciaIstat)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_ufficioMunicipio,rec.ANPVED_ufficioMunicipio),
                  rec.ATTVED_ufficioMunicipio)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_anno,rec.ANPVED_anno),
                  rec.ATTVED_anno)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'','',rec.ANPVED_parte),
                  rec.ATTVED_parte)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'','',rec.ANPVED_serie),
                  rec.ATTVED_serie)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'','',rec.ANPVED_numeroAtto),
                  rec.ATTVED_numeroAtto)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_dataFormazioneAtto,rec.ANPVED_dataFormazioneAtto),
                  rec.ATTVED_dataFormazioneAtto)
               ,decode(rec.ATTVED_numeroAtto,'',
                  decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_trascritto,rec.ANPVED_trascritto),
                  rec.ATTVED_trascritto)
               ,decode(rec.ATTVED_numeroAtto,'',decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_numeroComunale))
               ,decode(rec.ATTVED_numeroAtto,'',decode(rec.ANPVED_numeroAtto,'',rec.ANSVED_idANSC))
-- divorzio
               ,rec.DIV_tipoCessazione
               ,rec.DIV_dataSentenza,rec.DIV_numeroSentenza
               ,rec.DIV_tipoTribunaleSentenza,rec.DIV_autoritaSentenza,rec.DIV_dataValiditaSentenza
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_nomeComune,rec.ANPDIV_nomeComune),
                  rec.ATTDIV_nomeComune)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_codiceIstat,rec.ANPDIV_codiceIstat),
                  rec.ATTDIV_codiceIstat)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_siglaProvinciaIstat,rec.ANPDIV_siglaProvinciaIstat),
                  rec.ATTDIV_siglaProvinciaIstat)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_ufficioMunicipio,rec.ANPDIV_ufficioMunicipio),
                  rec.ATTDIV_ufficioMunicipio)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_anno,rec.ANPDIV_anno),
                  rec.ATTDIV_anno)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'','',rec.ANPDIV_parte),
                  rec.ATTDIV_parte)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'','',rec.ANPDIV_serie),
                  rec.ATTDIV_serie)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'','',rec.ANPDIV_numeroAtto),
                  rec.ATTDIV_numeroAtto)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_dataFormazioneAtto,rec.ANPDIV_dataFormazioneAtto),
                  rec.ATTDIV_dataFormazioneAtto)
               ,decode(rec.ATTDIV_numeroAtto,'',
                  decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_trascritto,rec.ANPDIV_trascritto),
                  rec.ATTDIV_trascritto)
               ,decode(rec.ATTDIV_numeroAtto,'',decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_numeroComunale))
               ,decode(rec.ATTDIV_numeroAtto,'',decode(rec.ANPDIV_numeroAtto,'',rec.ANSDIV_idANSC))
-- unioneCivile
               ,rec.codFiscale_uc,rec.validitaCF_uc,rec.dataAttribuzioneValidita_uc
               ,rec.cognome_uc,rec.senzaCognome_uc,rec.nome_uc,rec.senzaNome_uc
               ,rec.sesso_uc,rec.dataNascita_uc,rec.senzaGiorno_uc,rec.senzaGiornoMese_uc
               ,rec.NAS_nomecomune_uc,rec.NAS_codiceIstat_uc,rec.NAS_siglaProvinciaIstat_uc
               ,rec.NAS_descrizioneLocalita_uc,rec.NAS_descrizioneStato_uc,rec.NAS_codiceStato_uc
               ,rec.NAS_luogoEccezionale_uc
               ,rec.idSoggettoComuneIstat_uc,rec.idSoggettoComune_uc,rec.idSoggettoANPR_uc
               ,rec.UCI_dataEvento,rec.UCI_senzaGiorno,rec.UCI_senzaGiornoMese
               ,rec.UCI_nomecomune,rec.UCI_codiceIstat,rec.UCI_siglaProvinciaIstat
               ,rec.UCI_descrizioneLocalita,rec.UCI_descrizioneStato,rec.UCI_codiceStato
               ,rec.UCI_luogoEccezionale
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_nomeComune,rec.ANPUCI_nomeComune),
                  rec.ATTUCI_nomeComune)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_codiceIstat,rec.ANPUCI_codiceIstat),
                  rec.ATTUCI_codiceIstat)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_siglaProvinciaIstat,rec.ANPUCI_siglaProvinciaIstat),
                  rec.ATTUCI_siglaProvinciaIstat)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_ufficioMunicipio,rec.ANPUCI_ufficioMunicipio),
                  rec.ATTUCI_ufficioMunicipio)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_anno,rec.ANPUCI_anno),
                  rec.ATTUCI_anno)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'','',rec.ANPUCI_parte),
                  rec.ATTUCI_parte)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'','',rec.ANPUCI_serie),
                  rec.ATTUCI_serie)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'','',rec.ANPUCI_numeroAtto),
                  rec.ATTUCI_numeroAtto)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_dataFormazioneAtto,rec.ANPUCI_dataFormazioneAtto),
                  rec.ATTUCI_dataFormazioneAtto)
               ,decode(rec.ATTUCI_numeroAtto,'',
                  decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_trascritto,rec.ANPUCI_trascritto),
                  rec.ATTUCI_trascritto)
               ,decode(rec.ATTUCI_numeroAtto,'',decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_numeroComunale))
               ,decode(rec.ATTUCI_numeroAtto,'',decode(rec.ANPUCI_numeroAtto,'',rec.ANSUCI_idANSC))
-- scioglimentoUnione
               ,rec.SCI_motivoScioglimento,rec.SCI_dataSentenza,rec.SCI_numeroSentenza
               ,rec.SCI_tipoTribunaleSentenza,rec.SCI_autoritaSentenza,rec.SCI_dataValiditaSentenza,rec.SCI_dataEvento
               ,rec.SCI_nomecomune,rec.SCI_codiceIstat,rec.SCI_siglaProvinciaIstat
               ,rec.SCI_descrizioneLocalita,rec.SCI_descrizioneStato,rec.SCI_codiceStato
               ,rec.SCI_luogoEccezionale
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_nomeComune,rec.ANPSCI_nomeComune),
                  rec.ATTSCI_nomeComune)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_codiceIstat,rec.ANPSCI_codiceIstat),
                  rec.ATTSCI_codiceIstat)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_siglaProvinciaIstat,rec.ANPSCI_siglaProvinciaIstat),
                  rec.ATTSCI_siglaProvinciaIstat)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_ufficioMunicipio,rec.ANPSCI_ufficioMunicipio),
                  rec.ATTSCI_ufficioMunicipio)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_anno,rec.ANPSCI_anno),
                  rec.ATTSCI_anno)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'','',rec.ANPSCI_parte),
                  rec.ATTSCI_parte)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'','',rec.ANPSCI_serie),
                  rec.ATTSCI_serie)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'','',rec.ANPSCI_numeroAtto),
                  rec.ATTSCI_numeroAtto)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_dataFormazioneAtto,rec.ANPSCI_dataFormazioneAtto),
                  rec.ATTSCI_dataFormazioneAtto)
               ,decode(rec.ATTSCI_numeroAtto,'',
                  decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_trascritto,rec.ANPSCI_trascritto),
                  rec.ATTSCI_trascritto)
               ,decode(rec.ATTSCI_numeroAtto,'',decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_numeroComunale))
               ,decode(rec.ATTSCI_numeroAtto,'',decode(rec.ANPSCI_numeroAtto,'',rec.ANSSCI_idANSC))
               ,w_CIT_descrizioneStato_uc,w_CIT_codiceStato_uc,w_CIT_dataValidita_uc
               ,rec.UCI_ordineUnione
-- convivenzaDiFatto
               ,rec.codFiscale_cv,rec.validitaCF_cv,rec.dataAttribuzioneValidita_cv
               ,rec.cognome_cv,rec.senzaCognome_cv,rec.nome_cv,rec.senzaNome_cv,rec.sesso_cv
               ,rec.dataNascita_cv,rec.senzaGiorno_cv,rec.senzaGiornoMese_cv
               ,rec.NAS_nomecomune_cv,rec.NAS_codiceIstat_cv,rec.NAS_siglaProvinciaIstat_cv
               ,rec.NAS_descrizioneLocalita_cv,rec.NAS_descrizioneStato_cv,rec.NAS_codiceStato_cv
               ,rec.NAS_luogoEccezionale_cv
               ,rec.idSoggettoComuneIstat_cv,rec.idSoggettoComune_cv,rec.idSoggettoANPR_cv
               ,w_CIT_descrizioneStato_cv,w_CIT_codiceStato_cv,w_CIT_dataValidita_cv
-- convivenzaDiFatto
               ,rec.CDFSTI_data
               ,rec.CDFSTI_dataNotifica,rec.CDFSTI_dataDocumento,rec.CDFSTI_protocollo
               ,rec.CDFSTI_nomeComune,rec.CDFSTI_codiceIstat,rec.CDFSTI_siglaProvinciaIstat
               ,rec.CDFSTI_professionista
               ,rec.CDFSTI_nomeComuneReg,rec.CDFSTI_codiceIstatReg,rec.CDFSTI_siglaProvinciaIstatReg
               ,rec.CDFSTI_stato
               ,rec.CDFRIS_motivoRisoluzione,rec.CDFRIS_data
               ,rec.CDFRIS_dataNotifica,rec.CDFRIS_dataDocumento,rec.CDFRIS_protocollo
               ,rec.CDFRIS_nomeComune,rec.CDFRIS_codiceIstat,rec.CDFRIS_siglaProvinciaIstat
               ,rec.CDFRIS_professionista
               ,rec.CDFRIS_nomeComuneReg,rec.CDFRIS_codiceIstatReg,rec.CDFRIS_siglaProvinciaIstatReg
               ,rec.CDFRIS_stato
-- famiglia
               ,rec.FAM_tipoLegame,rec.FAM_dataDecorrenza,rec.FAM_codiceLegame,rec.FAM_dataDecorrenzaLegame
               ,rec.FAM_idFamigliaComuneIstat,rec.FAM_idFamigliaComune,rec.FAM_idFamigliaANPR,rec.FAM_famigliaAire
               ,rec.FAM_dataOrigineFamiglia,rec.FAM_denominazioneConvivenza,rec.FAM_specieConvivenza
               ,rec.FAM_presenzaFamigliaCoabitante,rec.FAM_tipoScheda
               ,rec.annoCensimento,rec.sezioneCensimento,rec.foglioCensimento
               ,rec.posizioneProfessionale,rec.condizioneNonProfessionale,rec.titoloStudio
               ,rec.possessoAutoveicoli,rec.possessoPatente
-- iscrizione
               ,rec.ISC_dataIscrizione,rec.ISC_protocolloComune,rec.ISC_nomeComune,rec.ISC_codiceIstat,rec.ISC_siglaProvinciaIstat
               ,rec.ISC_idOperazioneComune,rec.ISC_idOperazioneANPR,rec.ISC_dataDefinizionePratica
               ,rec.ISC_motivoIscrizione,rec.ISC_desMotivoIscrizione
               ,rec.ISC_motivoIscrizioneAire,rec.ISC_iniziativaAire,rec.ISC_individuazioneAire
               ,rec.ISC_dataArrivoConsolato
               ,rec.PRO_nomeComune,rec.PRO_codiceIstat,rec.PRO_siglaProvinciaIstat
               ,rec.PRO_descrizioneLocalita,rec.PRO_descrizioneStato,rec.PRO_codiceStato
-- cancellazione
               ,rec.CAN_MOTIVOCANCELLAZIONE,rec.CAN_NOTECANCELLAZIONE,rec.CAN_DATADECORRENZA
               ,rec.DES_NOMECOMUNE,rec.DES_CODICEISTAT,rec.DES_SIGLAPROVINCIAISTAT
               ,rec.DES_DESCRIZIONELOCALITA,rec.DES_DESCRIZIONESTATO,rec.DES_CODICESTATO
-- morte
               ,rec.MOR_dataEvento,rec.MOR_senzaGiorno,rec.MOR_senzaGiornoMese
               ,rec.MOR_nomecomune,rec.MOR_codiceIstat,rec.MOR_siglaProvinciaIstat
               ,rec.MOR_descrizioneLocalita,rec.MOR_descrizioneStato,rec.MOR_codiceStato
               ,rec.MOR_luogoEccezionale
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_nomeComune,rec.ANPMOR_nomeComune),
                  rec.ATTMOR_nomeComune)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_codiceIstat,rec.ANPMOR_codiceIstat),
                  rec.ATTMOR_codiceIstat)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_siglaProvinciaIstat,rec.ANPMOR_siglaProvinciaIstat),
                  rec.ATTMOR_siglaProvinciaIstat)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_ufficioMunicipio,rec.ANPMOR_ufficioMunicipio),
                  rec.ATTMOR_ufficioMunicipio)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_anno,rec.ANPMOR_anno),
                  rec.ATTMOR_anno)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'','',rec.ANPMOR_parte),
                  rec.ATTMOR_parte)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'','',rec.ANPMOR_serie),
                  rec.ATTMOR_serie)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'','',rec.ANPMOR_numeroAtto),
                  rec.ATTMOR_numeroAtto)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_dataFormazioneAtto,rec.ANPMOR_dataFormazioneAtto),
                  rec.ATTMOR_dataFormazioneAtto)
               ,decode(rec.ATTMOR_numeroAtto,'',
                  decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_trascritto,rec.ANPMOR_trascritto),
                  rec.ATTMOR_trascritto)
               ,decode(rec.ATTMOR_numeroAtto,'',decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_numeroComunale))
               ,decode(rec.ATTMOR_numeroAtto,'',decode(rec.ANPMOR_numeroAtto,'',rec.ANSMOR_idANSC))
               ,rec.ELE_CERTIFICABILITA,rec.ELE_MOTIVOCANCELLAZIONE,rec.ELE_NOTECANCELLAZIONE,rec.ELE_TIPOCONSULTAZIONE,rec.ELE_DATACANCELLAZIONE
               ,rec.idANPR
               )
        ;
      end;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti', rec.codFiscale||' - '||rec.cognome||' - '||rec.nome||' - '||rec.sesso);
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti', 'pd '||rec.codFiscale_pd||' - '||rec.cognome_pd||' - '||rec.nome_pd||' - '||rec.sesso_pd);
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti', 'md '||rec.codFiscale_md||' - '||rec.cognome_md||' - '||rec.nome_md||' - '||rec.sesso_md);
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti', 'cn '||rec.codFiscale_cn||' - '||rec.cognome_cn||' - '||rec.nome_cn||' - '||rec.sesso_cn);
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti', 'di '||rec.di_dataRilascio||' - '||rec.di_dataScadenza||' - '||rec.di_dataAnnullamento);
      if rec.idANPR is not null then
            ANPR_pkg.upd_anpads_id_unico(w_servizio_log,to_number(a_chiave),rec.idSoggettoAnpr,rec.idANPR);
      end if;

      if rec.liste is not null then
--         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'liste', rec.liste);
w_step := 2;
         w_xml      := xmltype('<ROOT>'||rec.liste||'</ROOT>');
w_step := 3;
         w_xml      := w_xml.extract('/ROOT/liste'
                                     ,w_extract_str_1||' '||w_extract_str_2);
w_step := 4;
         w_xml_clob := xmltype.getclobval(w_xml);
--         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'liste - extract', w_xml_clob);

         begin
           delete anpele
            where id_operazione = a_id_operazione
          ;
        end;
w_step := 5;
        for rec_ele in sel_liste ('liste') loop
--            ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'liste - btvSez', 'SEZIONEELETTORALENUM '||rec_ele.ELEBTV_SEZIONEELETTORALENUM);
            begin
              insert into anpele
                     (ID_OPERAZIONE, ELE_ELETTORE, ELE_NOMECOMUNE, ELE_CODICEISTAT, ELE_SIGLAPROVINCIAISTAT, ELE_DESCRIZIONELOCALITA, ELE_SEZIONEELETTORALENUM,
                      ELAC_UEELETTORECOMUNALI, ELAC_NOMECOMUNE, ELAC_CODICEISTAT, ELAC_SIGLAPROVINCIAISTAT, ELAC_DESCRIZIONELOCALITA, ELAC_SEZIONEELETTORALENUM,
                      ELAE_UEELETTOREPARLAMENTO, ELAE_NOMECOMUNE, ELAE_CODICEISTAT, ELAE_SIGLAPROVINCIAISTAT, ELAE_DESCRIZIONELOCALITA, ELAE_SEZIONEELETTORALENUM,
                      ELAB_COMREGELETTOREBOLZANO, ELAT_COMREGELETTORETRENTO, ELAV_COMREGELETTOREVALLEDAOSTA,
                      ELABTV_NOMECOMUNE, ELABTV_CODICEISTAT, ELABTV_SIGLAPROVINCIAISTAT, ELABTV_DESCRIZIONELOCALITA,
                      ELABTV_SEZIONEELETTORALENUM,
                      ELE_REFERENDUMNAZIONALI, ELE_ELEZIONIMEMBRIUE, ELE_SENATOREPUBBLICA, ELE_CIRCOSCRSENATOREPUBBLICA, ELE_CAMERADEPUTATI,
                      ELE_CIRCOSCRCAMERADEPUTATI, ELE_REGIONALI, ELE_COMUNALI, ELE_CIRCOSCRIZIONALI,
                      SEZ_NOMECOMUNE, SEZ_CODICEISTAT, SEZ_SIGLAPROVINCIAISTAT, SEZ_DESCRIZIONELOCALITA, SEZ_SEZIONEELETTORALENUM, SEZ_SEZIONEELETTORALEDENOM,
                      SEZIND_CAP, SEZIND_NOMECOMUNE, SEZIND_CODICEISTAT, SEZIND_SIGLAPROVINCIAISTAT, SEZIND_DESCRIZIONELOCALITA, SEZIND_FRAZIONE,
                      SEZIND_CODSPECIE, SEZIND_SPECIE, SEZIND_SPECIEFONTE, SEZIND_CODTOPONIMO, SEZIND_DENOMINAZIONETOPONIMO, SEZIND_TOPONIMOFONTE,
                      SEZIND_CODICECIVICO, SEZIND_CIVICOFONTE, SEZIND_NUMERO, SEZIND_METRICO, SEZIND_PROGSNC, SEZIND_LETTERA, SEZIND_ESPONENTE1, SEZIND_COLORE,
                      SEZIND_CORTE, SEZIND_SCALA, SEZIND_INTERNO1, SEZIND_ESPINTERNO1, SEZIND_INTERNO2, SEZIND_ESPINTERNO2,
                      SEZIND_SCALAESTERNA, SEZIND_SECONDARIO, SEZIND_PIANO, SEZIND_NUI, SEZIND_ISOLATO,
                      ELE_CIRCOSCRELEZIONIMEMBRIUE, ELE_COLLEGIOCAMERADEPUTATI, ELE_CIRCOSCRREGIONALI, ELE_CIRCOSRIZIONEELEZCIRCOSC,
                      ELE_COLLEGIOSENATOREPUBBLICA, ELE_TIPOCONSULTAZIONE, ELE_DATACANCELLAZIONELISTA)
              values (a_id_operazione,
                      rec_ele.ELE_ELETTORE, rec_ele.ELE_NOMECOMUNE, rec_ele.ELE_CODICEISTAT, rec_ele.ELE_SIGLAPROVINCIAISTAT, rec_ele.ELE_DESCRIZIONELOCALITA, rec_ele.ELE_SEZIONEELETTORALENUM,
                      rec_ele.ELAC_UEELETTORECOMUNALI, rec_ele.ELAC_NOMECOMUNE, rec_ele.ELAC_CODICEISTAT, rec_ele.ELAC_SIGLAPROVINCIAISTAT, rec_ele.ELAC_DESCRIZIONELOCALITA, rec_ele.ELAC_SEZIONEELETTORALENUM,
                      rec_ele.ELAE_UEELETTOREPARLAMENTO, rec_ele.ELAE_NOMECOMUNE, rec_ele.ELAE_CODICEISTAT, rec_ele.ELAE_SIGLAPROVINCIAISTAT, rec_ele.ELAE_DESCRIZIONELOCALITA, rec_ele.ELAE_SEZIONEELETTORALENUM,
                      rec_ele.ELAB_COMREGELETTOREBOLZANO, rec_ele.ELAT_COMREGELETTORETRENTO, rec_ele.ELAV_COMREGELETTOREVALLEDAOSTA,
                      rec_ele.ELABTV_NOMECOMUNE, rec_ele.ELABTV_CODICEISTAT, rec_ele.ELABTV_SIGLAPROVINCIAISTAT, rec_ele.ELABTV_DESCRIZIONELOCALITA,
                      rec_ele.ELABTV_SEZIONEELETTORALENUM,
                      rec_ele.ELE_REFERENDUMNAZIONALI, rec_ele.ELE_ELEZIONIMEMBRIUE, rec_ele.ELE_SENATOREPUBBLICA, rec_ele.ELE_CIRCOSCRSENATOREPUBBLICA,
                      rec_ele.ELE_CAMERADEPUTATI, rec_ele.ELE_CIRCOSCRCAMERADEPUTATI, rec_ele.ELE_REGIONALI, rec_ele.ELE_COMUNALI, rec_ele.ELE_CIRCOSCRIZIONALI,
                      rec_ele.SEZ_NOMECOMUNE, rec_ele.SEZ_CODICEISTAT, rec_ele.SEZ_SIGLAPROVINCIAISTAT, rec_ele.SEZ_DESCRIZIONELOCALITA,
                      rec_ele.SEZ_SEZIONEELETTORALENUM, rec_ele.SEZ_SEZIONEELETTORALEDENOM,
                      rec_ele.SEZIND_CAP, rec_ele.SEZIND_NOMECOMUNE, rec_ele.SEZIND_CODICEISTAT, rec_ele.SEZIND_SIGLAPROVINCIAISTAT, rec_ele.SEZIND_DESCRIZIONELOCALITA, rec_ele.SEZIND_FRAZIONE,
                      rec_ele.SEZIND_CODSPECIE, rec_ele.SEZIND_SPECIE, rec_ele.SEZIND_SPECIEFONTE,
                      rec_ele.SEZIND_CODTOPONIMO, rec_ele.SEZIND_DENOMINAZIONETOPONIMO, rec_ele.SEZIND_TOPONIMOFONTE,
                      rec_ele.SEZIND_CODICECIVICO, rec_ele.SEZIND_CIVICOFONTE, rec_ele.SEZIND_NUMERO,
                      rec_ele.SEZIND_METRICO, rec_ele.SEZIND_PROGSNC, rec_ele.SEZIND_LETTERA, rec_ele.SEZIND_ESPONENTE1, rec_ele.SEZIND_COLORE,
                      rec_ele.SEZIND_CORTE, rec_ele.SEZIND_SCALA, rec_ele.SEZIND_INTERNO1, rec_ele.SEZIND_ESPINTERNO1, rec_ele.SEZIND_INTERNO2, rec_ele.SEZIND_ESPINTERNO2,
                      rec_ele.SEZIND_SCALAESTERNA, rec_ele.SEZIND_SECONDARIO, rec_ele.SEZIND_PIANO, rec_ele.SEZIND_NUI, rec_ele.SEZIND_ISOLATO,
                      rec_ele.ELE_CIRCOSCRELEZIONIMEMBRIUE, rec_ele.ELE_COLLEGIOCAMERADEPUTATI, rec_ele.ELE_CIRCOSCRREGIONALI, rec_ele.ELE_CIRCOSRIZIONEELEZCIRCOSC,
                      rec_ele.ELE_COLLEGIOSENATOREPUBBLICA, rec_ele.ELE_TIPOCONSULTAZIONE, rec_ele.ELE_DATACANCELLAZIONELISTA)
              ;
            exception
              when others then
                   ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANPERR', SQLERRM);
            end;
--            ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaElettorale', rec_ele.ELE_elettore||' - '||
--                                                                                  rec_ele.ELAC_UEELETTORECOMUNALI||' - '||
--                                                                                  rec_ele.ELAE_UEELETTOREPARLAMENTO||' - '||
--                                                                                  rec_ele.ELAB_COMREGELETTOREBOLZANO||' - '||
--                                                                                  rec_ele.ELAT_COMREGELETTORETRENTO||' - '||
--                                                                                  rec_ele.ELAV_COMREGELETTOREVALLEDAOSTA);
        end loop;
      end if;

      if rec.erroriAnomalie is not null then
         w_errori_anomalie := rec.erroriAnomalie;
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'erroriAnomalie', rec.erroriAnomalie);
w_step := 2;
         w_xml      := xmltype('<ROOT>'||rec.erroriAnomalie||'</ROOT>');
w_step := 3;
         w_xml      := w_xml.extract('/ROOT/erroriAnomalie'
                                     ,w_extract_str_1||' '||w_extract_str_2);
w_step := 4;
         w_xml_clob := xmltype.getclobval(w_xml);
--         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'erroriAnomalie - extract', w_xml_clob);

         begin
           delete anperr
            where id_operazione = a_id_operazione
              and sequenza      = rec.idSoggettoANPR
          ;
        end;
w_step := 5;
        for rec_err in sel_errori ('erroriAnomalie') loop
            if rec_err.ERR_codiceErrore is not null then
               begin
                 insert into anperr (id_operazione, data_ora, sequenza, codice_errore, tipo_errore, testo_errore)
                 values (a_id_operazione, sysdate, rec.idSoggettoANPR, rec_err.ERR_codiceErrore, rec_err.ERR_tipoErrore, rec_err.ERR_testoErrore)
                 ;
               exception
                 when others then
                      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANPERR', SQLERRM);
               end;
               ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori', rec_err.ERR_codiceErrore||' - '||rec_err.ERR_tipoErrore||' - '||rec_err.ERR_testoErrore);
            end if;
        end loop;
      end if;

--      if a_chiave is not null then
--         ANPR_pkg.ins_anpads(w_servizio_log,to_char(a_chiave),'','','','','Individuale');
--      end if;
  end loop;

  goto fine;

<< file_pdf >>

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'file - inizio', a_campo_clob);
  w_xml 	:= xmltype(a_campo_clob);
  w_xml 	:= w_xml.extract(w_extract_str||'/file/certificatoPdf/child::node()'
                                ,w_extract_str_1||' '||w_extract_str_2);
  w_xml_clob    := xmltype.getclobval(w_xml);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'file - extract', w_xml_clob);

  w_certificato_pdf := xmltype.getclobval(w_xml);
  ANPR_pkg.ins_allegati(w_servizio_log,a_chiave,'',w_certificato_pdf,'S');

  goto fine;

<< file_xml >>
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'prima di extract', a_campo_clob);
  w_xml 	:= xmltype(a_campo_clob);
  w_xml 	:= w_xml.extract(w_extract_str||'/datiRichiesta'
                                ,w_extract_str_1||' '||w_extract_str_2);
  w_xml_clob	:= xmltype.getclobval(w_xml);
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'datiRichiesta - extract', w_xml_clob);

  for rec in sel_richiesta('datiRichiesta') loop
      w_id_richiesta_ANPR := rec.idOperazioneANPR;
      begin
        select archivio_rif
          into w_archivio_rif
          from anpeps
         where id_richiesta_anpr = w_id_richiesta_anpr
           and rownum = 1
        ;
      exception
        when others then
             w_archivio_rif := 'XXX';
      end;

      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'datiRichiesta', 'a_chiave: '||a_chiave||' - idOperazioneANPR: '||w_id_richiesta_ANPR||' - w_archivio_rif: '||w_archivio_rif);

      ANPR_pkg.ins_allegati(w_servizio_log,a_chiave,'',a_campo_clob,'');
      ANPR_pkg.upd_allegati(w_servizio_log,a_chiave,'xmlFile','S');

/*
      w_xml 	:= xmltype(a_campo_clob);
      w_xml 	:= w_xml.extract(w_extract_str||'/file/xmlFile/child::node()'
                                ,w_extract_str_1||' '||w_extract_str_2);
      w_xml_clob    := xmltype.getclobval(w_xml);

      w_xml_clob := substr(a_campo_clob,instr(a_campo_clob,'<xmlFile>')+9);
      w_xml_clob := substr(w_xml_clob,1,instr(w_xml_clob,'</xmlFile>')-1);
      w_risposta_b64  := w_xml_clob;
*/
      begin
        select allegato_clob
          into w_risposta_b64
          from anpr_allegati
         where chiave = a_chiave
           and session_id = userenv('sessionID')
        ;
      exception
        when others then
              w_risposta_b64 := a_campo_clob;
      end;

      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_risposta_b64', w_risposta_b64);
      w_risposta_blob := anpr_pkg.decode_base64(w_risposta_b64);
      w_risposta_clob := anpr_pkg.blob_to_clob(w_risposta_blob);

      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'file - extract', w_risposta_clob);

      ANPR_pkg.ctr_risposta_ko(w_servizio_log,a_id_operazione,w_risposta_clob,w_id_ANPR,w_esito_ANPR,w_flag_anomalia);
      if w_esito_ANPR is not null then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_esito_ANPR: '||w_esito_anpr);
         goto fine;
      end if;

      if w_archivio_rif in ('EAR','EAA') then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'prima di acquisisci_elenco',w_risposta_clob);
         ANPR_pkg_4000.acquisisci_elenco(a_servizio,a_id_operazione,a_chiave,w_risposta_clob);
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'dopo acquisisci_elenco',w_risposta_clob);

      elsif w_archivio_rif = 'EPS' then
         ANPR_pkg_4000.acquisisci_prospetto(a_servizio,a_chiave,w_risposta_clob);
      end if;
  end loop;

  goto fine;

<< fine >>
  null;

<< listaAnomalie >>
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie - inizio', a_campo_clob);
  begin
     w_xml 	:= xmltype(a_campo_clob);
     w_xml 	:= w_xml.extract(w_extract_str||'/listaAnomalie/anomalie'
                                ,w_extract_str_1||' '||w_extract_str_2);
     w_xml_clob	:= xmltype.getclobval(w_xml);
  exception
    when others then
         w_xml_clob := '';
  end;

  if w_xml_clob is null then
     goto listaAnomalie_err;
  end if;

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie - extract', w_xml_clob);

  for rec in sel_anomalie ('anomalie') loop
      w_codice_errore := rec.codiceErrore;
      w_tipo_errore   := rec.tipoErrore;
      w_testo_errore  := rec.testoErrore;
      begin
        insert into anperr (id_operazione, data_ora, codice_errore, tipo_errore, testo_errore, flag_anomalia)
        values (a_id_operazione, sysdate, w_codice_errore, w_tipo_errore, w_testo_errore, 'S')
        ;
      exception
        when others then
             ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANPERR - anomalia', SQLERRM);
      end;
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie', w_codice_errore||' - '||w_tipo_errore||' - '||w_testo_errore);

      w_flag_anomalia := 'S';
  end loop;

<< listaAnomalie_err >>
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie_err - inizio', a_campo_clob);
  w_xml 	:= xmltype(a_campo_clob);
  w_xml 	:= w_xml.extract(w_extract_str||'/listaAnomalie/errore'
                                ,w_extract_str_1||' '||w_extract_str_2);
  w_xml_clob	:= xmltype.getclobval(w_xml);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie_err - extract', w_xml_clob);

  for rec in sel_anomalie ('errore') loop
      w_codice_errore := rec.codiceErrore;
      w_tipo_errore   := rec.tipoErrore;
      w_testo_errore  := rec.testoErrore;
      begin
        insert into anperr (id_operazione, data_ora, codice_errore, tipo_errore, testo_errore, flag_anomalia)
        values (a_id_operazione, sysdate, w_codice_errore, w_tipo_errore, w_testo_errore, 'S')
        ;
      exception
        when others then
             ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANPERR - anomalia_err', SQLERRM);
      end;
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie_err', w_codice_errore||' - '||w_tipo_errore||' - '||w_testo_errore);

      w_flag_anomalia := 'S';
  end loop;

<< salta_listaAnomalie >>
null;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore - '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end ctr_risposta_ok;

procedure ctr_risposta_comune
(a_servizio 			varchar2
,a_id_operazione		number
,a_campo_clob 			clob
,w_id_ANPR 		OUT 	number
,w_esito_ANPR 		OUT 	varchar2
,w_flag_anomalia	OUT	varchar2
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ctr_risposta_comune';

w_xml			xmltype;
w_xml_clob		clob;

w_extract_str 		varchar2(255);
w_extract_str_1		varchar2(255);
w_extract_str_2  	varchar2(255);
w_extract_str_3		varchar2(255);
w_extract_str_4		varchar2(255);
w_extract_str_5  	varchar2(255);
w_extract_str_6  	varchar2(255);
w_estract_str_7		varchar2(255);
w_estract_str_8		varchar2(255);
w_estract_str_9		varchar2(255);
w_estract_str_10	varchar2(255);

w_id_soggetto		varchar2(255);
w_id_soggetto_ANPR	number;
w_id_famiglia		number;
w_id_famiglia_ANPR	number;
w_famiglia_AIRE         varchar2(255);

w_id_unico_anpr		varchar2(255);

w_cod_fiscale_AE	varchar2(255);
w_validita_CF_AE	number;
w_data_validita_CF_AE	varchar2(255);

w_codice_errore		varchar2(255);
w_tipo_errore		varchar2(255);
w_testo_errore		varchar2(255);

cursor sel_testata (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/idOperazioneANPR') idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/esitoOperazione') esitoOperazioneANPR
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_soggetti (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/identificativi/idANPR') idANPR
     , extractValue(value(rowdata),w_root||'/generalitaAttuali/idSchedaSoggettoComune/idSchedaSoggetto') idSchedaSoggetto
     , extractValue(value(rowdata),w_root||'/generalitaAttuali/idSchedaSoggettoANPR') idSchedaSoggettoANPR
     , extractValue(value(rowdata),w_root||'/generalitaAttuali/codiceFiscale/codFiscale') codFiscale_AE
     , extractValue(value(rowdata),w_root||'/generalitaAttuali/codiceFiscale/validitaCF') validitaCF_AE
     , extractValue(value(rowdata),w_root||'/generalitaAttuali/codiceFiscale/dataAttribuzioneValidita') dataValiditaCF_AE
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/idFamigliaConvivenzaComune/idFamigliaConvivenza') idFamigliaConvivenza
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/idFamigliaConvivenzaANPR') idFamigliaConvivenzaANPR
     , extractValue(value(rowdata),w_root||'/famigliaConvivenza/famigliaAIRE') famigliaAIRE
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_anomalie (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/codiceErroreAnomalia') codiceErrore
     , extractValue(value(rowdata),w_root||'/tipoErroreAnomalia') tipoErrore
     , extractValue(value(rowdata),w_root||'/testoErroreAnomalia') testoErrore
  from table(XMLSequence(w_xml)) rowdata
;

w_errore		varchar2(4000);
errore			exception;

w_step                  number;

begin

  begin
    select tws.risposta_ok_str,
           tws.risposta_ok_str_1, tws.risposta_ok_str_2, tws.risposta_ok_str_3, tws.risposta_ok_str_4, tws.risposta_ok_str_5
      into w_extract_str, w_extract_str_1, w_extract_str_2, w_extract_str_3, w_extract_str_4, w_extract_str_5
      from anptws tws
     where codice = a_servizio
    ;
  exception
    when others then
         w_extract_str   := '';
         w_extract_str_1 := '';
         w_extract_str_2 := '';
         w_extract_str_3 := '';
         w_extract_str_4 := '';
         w_extract_str_5 := '';
  end;

w_step := 1;
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio', a_campo_clob);

  begin
w_step := 2;
    w_xml 	:= xmltype(a_campo_clob);
w_step := 3;
--    ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'xmltype - ok');
  exception
    when others then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'xmltype - errore', sqlerrm);
  end;

<< testataRisposta >>
w_step := 4;
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta - inizio', a_campo_clob);
w_step := 5;
  w_xml 	:= xmltype(a_campo_clob);
w_step := 6;
  w_xml 	:= w_xml.extract(w_extract_str||'/testataRisposta'
                                ,w_extract_str_1||' '||w_extract_str_2);
w_step := 7;
  w_xml_clob	:= xmltype.getclobval(w_xml);
w_step := 8;
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta - extract', w_xml_clob);

w_step := 9;
  for rec in sel_testata ('testataRisposta') loop
      w_id_ANPR    := rec.idOperazioneANPR;
      w_esito_ANPR := rec.esitoOperazioneANPR;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'testataRisposta', 'idOperazioneANPR: '||w_id_ANPR||' - esito: '||w_esito_ANPR);
  end loop;

<< listaSoggettiVariati >>
w_step := 10;
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti - inizio', a_campo_clob);
w_step := 11.1;
  w_xml 	:= xmltype(a_campo_clob);
w_step := 12;
  w_xml 	:= w_xml.extract(w_extract_str||'/listaSoggettiVariati/datiSoggetto'
                                ,w_extract_str_1||' '||w_extract_str_2);
w_step := 13;
  w_xml_clob	:= xmltype.getclobval(w_xml);
w_step := 14;
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti - extract', w_xml_clob);

w_step := 15;
  for rec in sel_soggetti ('datiSoggetto') loop
      w_id_soggetto         := rec.idSchedaSoggetto;
      w_id_soggetto_ANPR    := rec.idSchedaSoggettoANPR;
      w_id_unico_ANPR       := rec.idANPR;
      if translate(rec.idFamigliaConvivenza,'0123456789','9999999999')
           in ('9','99','999','9999','99999','999999','9999999','99999999','999999999','9999999999')
      then
         w_id_famiglia         := rec.idFamigliaConvivenza;
      else
         w_id_famiglia         := '';
      end if;
      w_id_famiglia_ANPR    := rec.idFamigliaConvivenzaANPR;
      w_famiglia_AIRE       := rec.famigliaAIRE;
      w_cod_fiscale_AE      := rec.codFiscale_AE;
      w_validita_CF_AE      := rec.validitaCF_AE;
      w_data_validita_CF_AE := rec.dataValiditaCF_AE;
      if a_servizio = '1010' and w_id_famiglia is not null then
         ANPR_pkg.upd_anpads(w_servizio_log,w_id_famiglia,'',w_id_famiglia_anpr,w_famiglia_AIRE,w_cod_fiscale_AE,w_validita_CF_AE,w_data_validita_CF_AE);
      elsif w_id_soggetto is not null then
         ANPR_pkg.upd_anpads(w_servizio_log,w_id_soggetto,w_id_soggetto_anpr,w_id_famiglia_anpr,w_famiglia_AIRE,w_cod_fiscale_AE,w_validita_CF_AE,w_data_validita_CF_AE);
         if w_id_unico_anpr is not null then
            ANPR_pkg.upd_anpads_id_unico(w_servizio_log,w_id_soggetto,w_id_soggetto_anpr,w_id_unico_anpr);
         end if;
      end if;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaSoggetti', 'idSchedaSoggetto: '||w_id_soggetto||' - idFamigliaConvivenza: '||w_id_famiglia||' - ANPR: '||w_id_soggetto_ANPR||' - famiglia: '||w_id_famiglia_ANPR);
  end loop;

<< listaAnomalie >>
w_step := 16;
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie - inizio', a_campo_clob);
w_step := 17;
  w_xml 	:= xmltype(a_campo_clob);
w_step := 18;
  w_xml 	:= w_xml.extract(w_extract_str||'/listaAnomalie/anomalie'
                                ,w_extract_str_1||' '||w_extract_str_2);
w_step := 19;
  w_xml_clob	:= xmltype.getclobval(w_xml);
w_step := 20;
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie - extract', w_xml_clob);

w_step := 21;
  for rec in sel_anomalie ('anomalie') loop
      w_codice_errore := rec.codiceErrore;
      w_tipo_errore   := rec.tipoErrore;
      w_testo_errore  := rec.testoErrore;
      begin
        insert into anperr (id_operazione, data_ora, codice_errore, tipo_errore, testo_errore, flag_anomalia)
        values (a_id_operazione, sysdate, w_codice_errore, w_tipo_errore, w_testo_errore, 'S')
        ;
      exception
        when others then
             ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANPERR - anomalia', SQLERRM);
      end;
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaAnomalie', w_codice_errore||' - '||w_tipo_errore||' - '||w_testo_errore);

      w_flag_anomalia := 'S';
  end loop;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := w_step||' errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end ctr_risposta_comune;

function ws_1000_iscrizione_apr
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
)

return clob

is

cursor sel_mov is
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.*
-- dati soggetto
     , mov.cod_mov fascia
     , mov.cod_eve stato
     , decode(mov.cod_mov,3,'S') soggettoAIRE
     , ana.sospensione
     , ana.questionario_cens
     , decode(mov.cod_eve,18,ana.data_ult_eve) data_ult_eve_ana
     , decode(mov.cod_eve,18,ana.data_inizio_res) data_inizio_res_ana
     , decode(mov.cod_eve,18,ana.data_inizio_fam) data_inizio_fam_ana
-- dati famiglia
     , mov.cod_mov fascia_fam
     , decode(mov.rapporto_par,'IC',1,'CC',1) tipo_fam
     , fam.tipo_convivenza tipo_convivenza
     , fam.matricola_intestatario matricola_intestatario
     , fam.data_intestatario data_intestatario
-- dati coniuge
     , decode(ana_cn.fascia,3,'S') soggettoAIRE_cn
     , ana_cn.fascia fascia_cn
     , decode(ana_cn.sesso, '',
         decode(mov.stato_civile,'UC',mov.sesso,'VU',mov.sesso,'GU',mov.sesso,
           decode(mov.sesso,'M','F','M')),
         ana_cn.sesso) sesso_cn
     , ana_cn.data_nas data_nas_cn
     , ana_cn.anno_nas anno_nas_cn
     , ana_cn.cod_pro_nas cod_pro_nas_cn
     , ana_cn.cod_com_nas cod_com_nas_cn
     , ana_cn.stato_civile stato_civile_cn
     , ana_cn.nazionalita nazionalita_cn
     , ana_cn.data_inizio_naz data_inizio_naz_cn
     , ana_cn.cod_prof cod_prof_cn
     , ana_cn.posizione_prof posizione_prof_cn
     , ana_cn.titolo_studio titolo_studio_cn
     , ana_cn.cod_fiscale cod_fiscale_cn
-- dati paternita
     , decode(ana_pd.fascia,3,'S') soggettoAIRE_pd
     , ana_pd.fascia fascia_pd
     , ana_pd.cognome_nome cognome_nome_pd
     , ana_pd.sesso sesso_pd
     , ana_pd.data_nas data_nas_pd
     , ana_pd.anno_nas anno_nas_pd
     , ana_pd.cod_pro_nas cod_pro_nas_pd
     , ana_pd.cod_com_nas cod_com_nas_pd
     , ana_pd.stato_civile stato_civile_pd
     , ana_pd.nazionalita nazionalita_pd
     , ana_pd.data_inizio_naz data_inizio_naz_pd
     , ana_pd.cod_prof cod_prof_pd
     , ana_pd.posizione_prof posizione_prof_pd
     , ana_pd.titolo_studio titolo_studio_pd
     , ana_pd.cod_fiscale cod_fiscale_pd
     , ana_pd.cod_fam cod_fam_pd
     , ana_pd.rapporto_par rapporto_par_pd
-- dati maternita
     , decode(ana_md.fascia,3,'S') soggettoAIRE_md
     , ana_md.fascia fascia_md
     , ana_md.cognome_nome cognome_nome_md
     , ana_md.sesso sesso_md
     , ana_md.data_nas data_nas_md
     , ana_md.anno_nas anno_nas_md
     , ana_md.cod_pro_nas cod_pro_nas_md
     , ana_md.cod_com_nas cod_com_nas_md
     , ana_md.stato_civile stato_civile_md
     , ana_md.nazionalita nazionalita_md
     , ana_md.data_inizio_naz data_inizio_naz_md
     , ana_md.cod_prof cod_prof_md
     , ana_md.posizione_prof posizione_prof_md
     , ana_md.titolo_studio titolo_studio_md
     , ana_md.cod_fiscale cod_fiscale_md
     , ana_md.cod_fam cod_fam_md
     , ana_md.rapporto_par rapporto_par_md
  from anadce dce
     , anaana ana_cn
     , anaana ana_md
     , anaana ana_pd
     , anafam fam
     , anaana ana
     , anamov mov
 where dce.anagrafe                = 'RES'
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and ana_cn.matricola (+)        = mov.matricola_cn
   and ana_md.matricola (+)        = mov.matricola_md
   and ana_pd.matricola (+)        = mov.matricola_pd
   and fam.cod_fam      (+)        = mov.cod_fam
   and fam.fascia       (+)        = mov.cod_mov
   and ana.matricola               = mov.matricola
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;
w_data_decorrenza_ws		number;

w_progr_componente		number;

w_cognome 			varchar2(255);
w_cognome_cn                   	varchar2(255);
w_cognome_pd			varchar2(255);
w_cognome_md			varchar2(255);

w_nome 				varchar2(255);
w_nome_cn			varchar2(255);
w_nome_pd			varchar2(255);
w_nome_md			varchar2(255);

w_idSchedaSoggettoANPR		varchar2(255);
w_idSchedaSoggettoANPR_cn	varchar2(255);
w_idSchedaSoggettoANPR_pd	varchar2(255);
w_idSchedaSoggettoANPR_md	varchar2(255);

w_soggettoAIRE			varchar2(255);
w_soggettoAIRE_cn		varchar2(255);
w_soggettoAIRE_pd		varchar2(255);
w_soggettoAIRE_md		varchar2(255);

w_data_atto_rif                 number;

w_ordineUnione                  varchar2(255);
w_motivoScioglimento		varchar2(255);

w_tipoIndirizzo			varchar2(255);
w_data_decorrenza_res		number;
w_dataDecorrenzaResidenza	varchar2(255);

w_data_decorrenza_fam		number;
w_origineCognome		varchar2(255);
w_filiazione     		varchar2(255);
w_attribuzioneFamiglia 		varchar2(255);

w_gestioneCF			varchar2(255);

w_tipo_evento_proc              varchar2(255);

w_cod_fiscale_ws		varchar2(255);

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '1000_iscrizione_apr';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno_progr '||a_anno_rif||' - numero_progr '||a_numero_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario1000iscrizione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/1000iscrizione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_mov loop
      w_note_log := 'cod_mov '||rec.cod_mov||' - cod_eve '||rec.cod_eve||' - matricola '||rec.matricola||' - pratica '||rec.pratica||' - anno_pratica '||rec.anno_pratica;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log);

w_step := 0.1;
      w_cognome                 := f_cognome(rec.cognome_nome);
      w_nome                    := f_nome(rec.cognome_nome);

w_step := 0.2;
      if rec.cognome_nome_cn is not null then
         w_cognome_cn		:= f_cognome(rec.cognome_nome_cn);
         w_nome_cn		:= f_nome(rec.cognome_nome_cn);
      end if;

w_step := 0.3;
      if rec.cognome_nome_pd is not null then
         w_cognome_pd		:= f_cognome(rec.cognome_nome_pd);
         w_nome_pd		:= f_nome(rec.cognome_nome_pd);
      elsif rec.paternita is not null then
         w_cognome_pd 		:= f_cognome_pd('',rec.paternita,rec.cognome_nome);
         w_nome_pd 		:= f_nome_pd('',rec.paternita,rec.cognome_nome);
      end if;

w_step := 0.4;
      if nvl(rec.cognome_nome_md,rec.maternita) is not null then
         w_cognome_md		:= f_cognome(nvl(rec.cognome_nome_md,rec.maternita));
         w_nome_md		:= f_nome(nvl(rec.cognome_nome_md,rec.maternita));
      end if;

      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR    := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'CN') is null then
         w_idSchedaSoggettoANPR_cn := f_ANPR_id_scheda(rec.matricola_cn,'','','','');
      end if;
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'PD') is null then
         w_idSchedaSoggettoANPR_pd := f_ANPR_id_scheda(rec.matricola_pd,'','','','');
      end if;
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'MD') is null then
         w_idSchedaSoggettoANPR_md := f_ANPR_id_scheda(rec.matricola_md,'','','','');
      end if;

      w_soggettoAIRE            := rec.soggettoAIRE;
      w_soggettoAIRE_cn         := rec.soggettoAIRE_cn;
      w_soggettoAIRE_pd         := rec.soggettoAIRE_pd;
      w_soggettoAIRE_md         := rec.soggettoAIRE_md;

w_step := 0.5;
      w_data_decorrenza_ws      := f_ANPR_data_decorrenza_ws(a_id_operazione);

      w_tipoIndirizzo           := f_ANPR_tipo_indirizzo(w_soggettoAIRE,rec.presso);
      w_data_decorrenza_res     := nvl(w_data_decorrenza_ws,nvl(rec.data_inizio_res_ana,rec.data_inizio_res));
      w_dataDecorrenzaResidenza := f_ANPR_data(w_data_decorrenza_res);

w_step := 0.6;
      w_data_decorrenza  := nvl(w_data_decorrenza_ws,nvl(rec.data_ult_eve_ana,rec.data_eve));
      w_data_definizione := rec.data_reg;
      if a_servizio in ('1001') then
         w_protocollo       := '';
         w_data_protocollo  := '';
      elsif a_servizio in ('1002') then
         w_protocollo       := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,rec.anagrafe,rec.tipo_evento);
         w_data_protocollo  := f_ANPR_data_pratica(rec.anagrafe,rec.tipo_evento,rec.anno_pratica,rec.pratica);
      end if;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione,rec.cod_mov,rec.cod_eve);

      w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,rec.cod_fiscale,rec.cf_calcolato);
      if a_servizio in ('1001') then
         goto generalita;
      end if;

<< motivoIscrizione >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_motivoIscrizione(w_servizio_log,rec.cod_mov,rec.cod_eve,rec.cod_variazione,rec.cod_pro_eve);

<< generalita >>
w_step := 1;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita'||a_servizio,'I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
        if w_gestioneCF = 1 then
           goto salta_cf;
        end if;
        w_cod_fiscale_ws := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
<< salta_cf >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_step := 2;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_step := 3;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');

        if a_servizio in ('1001') then
           goto attributiSoggetto;
        end if;

<< statoCivile >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile,rec.sesso);

<< attributiSoggetto >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_attributiSoggetto(w_servizio_log,rec.matricola,rec.sospensione,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita'||a_servizio,'F');

        if a_servizio in ('1001') then
           goto attoNascita;
        end if;

<< altriDati >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof,rec.sesso,rec.posizione_prof,rec.titolo_studio);

<< attoNascita>>
        w_data_atto_rif := f_ANPR_data_atto_rif(2,rec.cod_pro_atto_nas,rec.cod_com_atto_nas,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,rec.anno_atto_nas);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_nas,rec.cod_com_atto_nas,w_data_atto_rif,rec.anno_atto_nas,rec.ufficio_nas,rec.parte_nas,rec.serie_nas,rec.atto_nas,'attoNascita',rec.atto_nas_digitale);

<< cittadinanza >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita,rec.data_inizio_naz);

<< paternita >>
        if rec.paternita is null and rec.matricola_pd is null then
           goto maternita;
        end if;

w_step := 11.2;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'paternita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_pd,rec.matricola_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_pd,w_nome_pd,nvl(rec.sesso_pd,'M'),rec.data_nas_pd,rec.anno_nas_pd);
w_step := 12;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_pd,rec.cod_com_nas_pd,rec.data_nas_pd,'luogoNascita','N');
w_step := 13;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_pd,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR_pd is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_pd);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_pd,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile_pd,rec.sesso_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_pd,rec.data_inizio_naz_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof_pd,rec.sesso_pd,rec.posizione_prof_pd,rec.titolo_studio_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'paternita','F');

<< maternita >>
        if rec.maternita is null and rec.matricola_md is null then
           goto provenienza;
        end if;

w_step := 21;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'maternita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_md,rec.matricola_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_md,w_nome_md,nvl(rec.sesso_md,'F'),rec.data_nas_md,rec.anno_nas_md);
w_step := 22;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_md,rec.cod_com_nas_md,rec.data_nas_md,'luogoNascita','N');
w_step := 23;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_md,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR_md is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_md);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_md,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile_md,rec.sesso_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_md,rec.data_inizio_naz_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof_md,rec.sesso_md,rec.posizione_prof_md,rec.titolo_studio_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'maternita','F');

<< provenienza >>
        if a_servizio in ('1001') then
           goto famiglia_convivenza;
        end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_eve,rec.cod_com_eve,'','provenienza','N');

<< residenza >>
w_step := 31;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'residenza','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoIndirizzo,'tipoIndirizzo');

      if w_tipoIndirizzo not in ('5','6') then
--w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_indirizzo(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_indirizzo_esteso(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano
                                                                                ,rec.flag_metrico,rec.progr_snc,rec.flag_lettera,rec.flag_esponente,rec.flag_nui,rec.nui,rec.colore
                                                                                ,rec.corte,rec.interno2,rec.sub_interno2,rec.secondario,rec.scala_esterna);

      elsif w_tipoIndirizzo in ('5','6') then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_localitaEstera(w_servizio_log,rec.via_aire,rec.zipcode,rec.cod_pro_aire,rec.cod_com_aire,rec.provincia_contea,'','','');
      end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.presso,'presso','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenzaResidenza,'dataDecorrenzaResidenza','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'residenza','F');

<< famiglia_convivenza >>
      if a_servizio in ('1001') then
         goto famConv;
      end if;
      if rec.tipo_fam is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'famiglia','I');
      elsif rec.tipo_fam = 1 then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'convivenza','I');
      end if;

<< famConv >>
      w_data_decorrenza_fam := nvl(w_data_decorrenza_ws,nvl(rec.data_inizio_fam_ana,rec.data_inizio_fam));
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,rec.tipo_convivenza,rec.matricola_intestatario,rec.data_intestatario,a_id_operazione);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_legame(w_servizio_log,rec.tipo_fam,rec.fascia,rec.cod_fam,rec.rapporto_par,rec.sesso,w_data_decorrenza_fam,w_progr_componente,'');

      if a_servizio in ('1001') then
         goto datiControllo;
      end if;

      if rec.tipo_fam is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'famiglia','F');
      elsif rec.tipo_fam = 1 then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'convivenza','F');
      end if;


<< matrimonio >>
      if rec.stato_civile in ('CN','VE','DV','GC') then
         if rec.cognome_nome_cn is null and rec.matricola_cn is null and rec.data_mat is null then
            goto vedovanza;
         end if;
w_step := 41;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'matrimonio','I');

        if rec.cognome_nome_cn is null and rec.matricola_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaCognome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaNome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','F');
           goto datiMatrimonio;
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_cn,rec.matricola_cn);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_cn,w_nome_cn,rec.sesso_cn,rec.data_nas_cn,rec.anno_nas_cn);
w_step := 42;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_cn,rec.cod_com_nas_cn,rec.data_nas_cn,'luogoNascita','N');
w_step := 43;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_cn,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_cn);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_cn,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_cn,rec.data_inizio_naz_cn);

<< datiMatrimonio >>
        if rec.data_mat is null then
           goto ordineMatrimonio;
        end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMatrimonio','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_mat,rec.anno_mat),'dataEvento','S');
           if nvl(rec.anno_mat,'N') = 'S' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','senzaGiornoMese');
           end if;
w_step := 44;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,'luogoEvento','N');
w_step := 45;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
        if ltrim(rec.cod_pro_atto_mat||rec.cod_com_atto_mat,'0') is not null then
           w_data_atto_rif := f_ANPR_data_atto_rif(4,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,w_data_atto_rif,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoMatrimonio',rec.atto_mat_digitale);
        else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoMatrimonio',rec.atto_mat_digitale);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMatrimonio','F');

<< ordineMatrimonio >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'','ordineMatrimonio','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'matrimonio','F');
      end if;

<< vedovanza >>
      if rec.stato_civile in ('VE') then
         if rec.data_ved is null then
            goto divorzio;
         end if;
w_step := 51;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'vedovanza','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMorteconiuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_ved),'dataEvento');
w_step := 52;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,'luogoEvento','N');
w_step := 53;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
         if ltrim(rec.cod_pro_atto_ved||rec.cod_com_atto_ved,'0') is not null then
           w_data_atto_rif := f_ANPR_data_atto_rif(5,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,w_data_atto_rif,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoMorteConiuge',rec.atto_ved_digitale);
         else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoMorteConiuge',rec.atto_ved_digitale);
         end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMorteconiuge','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'','ordineMatrimonioPrecedente','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'vedovanza','F');
      end if;

<< divorzio >>
      if rec.stato_civile in ('DV','GC') and nvl(rec.data_div,rec.data_div_ann) is not null then
         if rec.data_div is null and rec.data_div_ann is null then
            goto unioneCivile;
         end if;
w_step := 61;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'separazioneAnnullamentoCessazioneMatrimonio','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_divorzio(w_servizio_log,rec.matricola,rec.data_div,rec.data_div_ann);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_div,rec.cod_com_atto_div,nvl(rec.data_div_ann,rec.data_div),rec.anno_atto_div,rec.ufficio_div,rec.parte_div,rec.serie_div,rec.atto_div,'attoAnnullamentoMatrimonio',rec.atto_div_digitale);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'separazioneAnnullamentoCessazioneMatrimonio','F');
      end if;

w_step := 71;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);

<< unioneCivile >>
        if rec.stato_civile in ('UC','VU','GU') then
           if rec.cognome_nome_cn is null and rec.matricola_cn is null and rec.data_mat is null then
              goto convivenzaDiFatto;
           end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unioneCivile','I');

           if rec.cognome_nome_cn is null and rec.matricola_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaCognome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaNome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','F');
              goto attoUnione;
           end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_cn,rec.matricola_cn);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_cn,w_nome_cn,rec.sesso_cn,rec.data_nas_cn,rec.anno_nas_cn);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_cn,rec.cod_com_nas_cn,rec.data_nas_cn,'luogoNascita','N');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_cn,'soggettoAIRE','S');
           if w_idSchedaSoggettoANPR_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_cn);
           end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_cn,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','F');

<< attoUnione >>
          if rec.data_mat is null then
             goto scioglimentoUnione;
          end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'attoUnione','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_mat,rec.anno_mat),'dataEvento','S');
          if nvl(rec.anno_mat,'N') = 'S' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','senzaGiornoMese');
          end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,'luogoEvento','N');
          if ltrim(rec.cod_pro_atto_mat||rec.cod_com_atto_mat,'0') is not null then
             w_data_atto_rif := f_ANPR_data_atto_rif(4,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,w_data_atto_rif,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoUnione',rec.atto_mat_digitale);
          else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoUnione',rec.atto_mat_digitale);
          end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'attoUnione','F');

<< scioglimentoUnione >>
          if rec.stato_civile in ('VU','GU') then
             if rec.stato_civile = 'VU' and rec.data_ved is not null then
                w_motivoScioglimento := '98';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoScioglimento,'motivoScioglimento','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_ved),'dataEvento');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,'luogoEvento','N');
                if ltrim(rec.cod_pro_atto_ved||rec.cod_com_atto_ved,'0') is not null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,'',rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoScioglimentoUnione',rec.atto_ved_digitale);
                else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoScioglimentoUnione',rec.atto_ved_digitale);
                end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','F');

             elsif rec.stato_civile = 'GU' and nvl(rec.data_div,rec.data_div_ann) is not null then
                w_motivoScioglimento := '1';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoScioglimento,'motivoScioglimento','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_divorzio(w_servizio_log,rec.matricola,rec.data_div,rec.data_div_ann,rec.stato_civile);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(nvl(rec.data_div,rec.data_div_ann)),'dataEvento');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_div,rec.cod_com_div,rec.data_div,'luogoEvento','N');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_div,rec.cod_com_atto_div,rec.data_div,rec.anno_atto_div,rec.ufficio_div,rec.parte_div,rec.serie_div,rec.atto_div,'attoScioglimentoUnione',rec.atto_div_digitale);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','F');

             end if;
          end if;

<< cittadinanzaUnione >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_cn,rec.data_inizio_naz_cn);

<< ordineUnione >>
          w_ordineUnione := '1';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_ordineUnione,'ordineUnione','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unioneCivile','F');
      end if;

<< convivenzaDiFatto >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_convivenzaDiFatto(w_servizio_log,rec.matricola,'',rec.data_eve,'MOV');

<< cartaIdentita >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cartaIdentita(w_servizio_log,rec.matricola);

<< permessoSoggiorno >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_permessoSoggiorno(w_servizio_log,rec.matricola);

<< listaLeva >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_listaLeva(w_servizio_log,rec.matricola);

<< listaElettorale >>
/* ANEL */
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_listaElettorale(w_servizio_log,rec.matricola);

<< censimento >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_censimento(w_servizio_log,rec.anno_cens,rec.sezione_cens,rec.foglio_cens,rec.questionario_cens,w_data_decorrenza);

<< autoveicoli >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_autoveicoli(w_servizio_log,rec.matricola);

<< datiDelProcedimento >>
      w_tipo_evento_proc := f_ANPR_tipo_evento_ciu(rec.cod_mov,rec.cod_eve,'S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_datiDelProcedimento(w_servizio_log,rec.pratica,rec.anno_pratica,rec.data_reg,rec.anagrafe,w_tipo_evento_proc);

<< datiSentenza >>
-- obbligatorio se motivoIscrizione = 2 (esistenza giudizialmente riconosciuta)
null;

<< datiControllo >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');

      if a_servizio in ('1001') then
         w_origineCognome       := f_ANPR_origine_cognome(w_cognome,w_cognome_pd,w_cognome_md);
         w_filiazione           := f_ANPR_filiazione(rec.paternita,rec.maternita);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_origineCognome,'origineCognome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_filiazione,'filiazione','S');
         w_attribuzioneFamiglia := f_ANPR_attribuzione_fam(rec.fascia,rec.cod_fam,rec.fascia_pd,rec.cod_fam_pd,rec.fascia_md,rec.cod_fam_md,rec.tipo_fam);
      elsif a_servizio in ('1002') then
         if rec.nucleo_arrivo = 1 and rec.rapporto_par = 'CF' then
            ANPR_pkg.ins_anpads(w_servizio_log,rec.matricola, '', rec.fascia, rec.tipo_fam, rec.cod_fam, 'Famiglia');
            w_attribuzioneFamiglia := 2;
         else
            w_attribuzioneFamiglia := 1;
         end if;
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_attribuzioneFamiglia,'attribuzioneFamiglia','S');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob_sog);
w_xml_clob := w_xml_clob||w_xml_clob_sog;

      ANPR_pkg.ins_anpads(w_servizio_log,rec.matricola, '', '', '', '', 'Individuale');
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_1000_iscrizione_apr;

function ws_1010_iscrizione_FAM
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_fascia_fam		number
,a_cod_fam		number
)

return clob

is

cursor sel_fam is
select * from anafam
 where fascia  = a_fascia_fam
   and cod_fam = a_cod_fam
;

w_data_decorrenza_ws		number;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;

w_tipoIndirizzo			varchar2(255);
w_dataDecorrenzaResidenza	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '1010_iscrizione_fam';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fascia_fam '||a_fascia_fam||' - cod_fam '||a_cod_fam);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario1000iscrizione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/1000iscrizione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_fam loop
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_istituzione);
      w_data_definizione   := nvl(w_data_decorrenza_ws,rec.data_istituzione);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,rec.tipo_convivenza,rec.matricola_intestatario,rec.data_intestatario,a_id_operazione);

      w_tipoIndirizzo           := '1';
      w_dataDecorrenzaResidenza := f_ANPR_data(rec.data_istituzione);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaConvivneza','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoIndirizzo,'tipoIndirizzo');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_indirizzo(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_indirizzo_esteso(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano
                                                                        ,rec.flag_metrico,rec.progr_snc,rec.flag_lettera,rec.flag_esponente,rec.flag_nui,rec.nui,rec.colore
                                                                        ,rec.corte,rec.interno2,rec.sub_interno2,rec.secondario,rec.scala_esterna);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.presso,'presso','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenzaResidenza,'dataDecorrenzaResidenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaConvivneza','F');

<< datiDelProcedimento >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiDelProcedimento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiDelProcedimento','F');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);
      ANPR_pkg.ins_anpads(w_servizio_log, '', '', rec.fascia, rec.tipo_fam, rec.cod_fam, 'Convivenza');
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_1010_iscrizione_FAM;

function ws_1014_procedimento
(a_servizio 		IN	varchar2
,a_id_operazione  	IN	number
,a_tipo_operazione  	IN	varchar2
,a_anno_rif 		IN	number
,a_numero_rif 		IN	number
,a_matricola 		IN	number
)

return clob

is

cursor sel_mov is
select *
  from anamov
 where anno_progr   = a_anno_rif
   and numero_progr = a_numero_rif
;

w_data_decorrenza_ws		number;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;

w_anagrafe			varchar2(255);
w_tipo_evento			varchar2(255);
w_tipo_evento_proc		varchar2(255);

w_numeroPraticaComune		varchar2(255);
w_tipoOperazione                varchar2(255);
w_motivoAvvio 			varchar2(255);
w_dataStato			varchar2(255);
w_statoProcedimento		varchar2(255);
w_dataChiusura 			varchar2(255);
w_esitoChiusura 		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '1014_procedimento';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario1000iscrizione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/1000iscrizione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_mov loop
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_eve);
      w_data_definizione   := rec.data_reg;

      w_anagrafe           := f_ANPR_anagrafe_ciu(rec.cod_mov,rec.cod_eve);
      w_tipo_evento        := f_ANPR_tipo_evento_ciu(rec.cod_mov,rec.cod_eve);
      w_protocollo         := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,w_anagrafe,w_tipo_evento);
      w_data_protocollo    := f_ANPR_data_pratica(w_anagrafe,w_tipo_evento,rec.anno_pratica,rec.pratica);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,'C',w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

      w_tipo_evento_proc    := f_ANPR_tipo_evento_ciu(rec.cod_mov,rec.cod_eve,'S');
      w_numeroPraticaComune := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,w_anagrafe,w_tipo_evento_proc,'S');
      w_dataStato           := f_ANPR_data(w_data_definizione);
      if a_tipo_operazione = 'I' then
         w_tipoOperazione      := 'I';
         w_statoProcedimento   := '1';
         w_esitoChiusura       := '';
         w_dataChiusura        := '';
      elsif a_tipo_operazione = 'C' then
         w_tipoOperazione      := 'C';
         w_statoProcedimento   := '2';
         w_esitoChiusura       := 'C';
         w_dataChiusura        := f_ANPR_data(w_data_definizione);
      elsif a_tipo_operazione = 'R' then
         w_tipoOperazione      := 'C';
         w_statoProcedimento   := '2';
         w_esitoChiusura       := 'R';
         w_dataChiusura        := f_ANPR_data(w_data_definizione);
      end if;

      begin
        select t29.codice
          into w_motivoAvvio
          from anpt29 t29
             , anpciu_rif rif
         where t29.servizio_rif = rif.servizio_rif
           and rif.id_operazione = a_id_operazione
        ;
      exception
        when others then
             w_errore := 'errore in ricerca motivoAvvio ('||sqlerrm||')';
             ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
             w_motivoAvvio := '12';
      end;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'procedimentoIstruttoria','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numeroPraticaComune,'numeroPraticaComune');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoOperazione,'tipoOperazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataChiusura,'dataChiusura','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoAvvio,'motivoAvvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataStato,'dataStato','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_statoProcedimento,'statoProcedimento','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_esitoChiusura,'esitoChiusura','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'procedimentoIstruttoria','F');
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_1014_procedimento;

function ws_2009_cancellazione_FAM
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_fascia_fam		number
,a_cod_fam		number
)

return clob

is

cursor sel_fam is
select * from anafam
 where fascia  in (1,2)
   and cod_fam = a_cod_fam
;

w_data_decorrenza_ws            number;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;

w_tipoIndirizzo			varchar2(255);
w_dataDecorrenzaResidenza	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '2009_cancellazione_fam';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fascia_fam '||a_fascia_fam||' - cod_fam '||a_cod_fam);

w_step := 0;
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario2000cancellazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/2000cancellazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_fam loop
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,to_char(sysdate,'j'));
      w_data_definizione   := to_char(sysdate,'j');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,rec.tipo_convivenza,rec.matricola_intestatario,rec.data_intestatario,a_id_operazione);

<< datiArchiviazione >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiArchiviazione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(w_data_decorrenza),'dataDecorrenzaArchiviazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiArchiviazione','F');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_2009_cancellazione_FAM;

function ws_5001_mutazione_FAM
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_fascia_fam		number
,a_cod_fam		number
,a_archivio_rif 	varchar2
)

return clob

is

cursor sel_fam is
select fam.fascia
     , fam.cod_fam
     , min(fam.tipo_fam) tipo_fam
     , min(fam.tipo_convivenza) tipo_convivenza
     , min(fam.data_istituzione) data_istituzione
     , min(fam.matricola_intestatario) matricola_intestatario
     , min(fam.data_intestatario) data_intestatario
--
     , min(fam.cod_via) cod_via
     , min(fam.num_civ) num_civ
     , min(fam.suffisso) suffisso
     , min(fam.interno) interno
     , min(fam.sub_interno) sub_interno
     , min(fam.scala) scala
     , min(fam.piano) piano
     , min(fam.flag_metrico) flag_metrico
     , min(fam.progr_snc) progr_snc
     , min(fam.flag_lettera) flag_lettera
     , min(fam.flag_esponente) flag_esponente
     , min(fam.flag_nui) flag_nui
     , min(fam.nui) nui
     , min(fam.colore) colore
     , min(fam.corte) corte
     , min(fam.interno2) interno2
     , min(fam.sub_interno2) sub_interno2
     , min(fam.secondario) secondario
     , min(fam.scala_esterna) scala_esterna
--
     , min(fam.presso) presso
     , min(fam.via_aire) via_aire
     , min(fam.zipcode) zipcode
     , min(fam.cod_pro_aire) cod_pro_aire
     , min(fam.cod_com_aire) cod_com_aire
     , min(fam.provincia_contea) provincia_contea
     , min(com.cod_consolato) cod_consolato
     , min(com.tipo_consolato) tipo_consolato
     , min(nvl(com.cod_territorio,com.cod_provincia)) cod_stato
     , min(ana.data_inizio_res) min_data_inizio_res
     , max(ana.data_inizio_res) max_data_inizio_res
  from arccom com
     , anaana ana
     , anafam fam
 where com.cod_provincia (+) = fam.cod_pro_aire
   and com.cod_comune    (+) = fam.cod_com_aire
   and ana.fascia        (+) = fam.fascia
   and ana.cod_fam       (+) = fam.cod_fam
   and fam.fascia            = a_fascia_fam
   and fam.cod_fam           = a_cod_fam
 group by fam.fascia, fam.cod_fam
;

w_tipo_operazione               varchar2(255) := 'V';

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;

w_data_decorrenza_ws		number;

w_tipoIndirizzo			varchar2(255);
w_dataDecorrenzaResidenza	varchar2(255);

w_matricola_CC                  number;
w_cognome_nome_CC               varchar2(255);
w_cognome_CC                    varchar2(255);
w_nome_CC                       varchar2(255);
w_sesso_CC                      varchar2(255);
w_data_nas_CC                   number;
w_anno_nas_CC                   varchar2(255);
w_cod_fiscale_CC                varchar2(255);

w_tipoMutazione			varchar2(255);
w_tipoScheda 			varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5001_mutazione_fam';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fascia_fam '||a_fascia_fam||' - cod_fam '||a_cod_fam);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_fam loop
      if a_archivio_rif like 'VIE%' then
         goto archivio_VIE;
      end if;

<< archivio_FAM >>
--
-- a_tipo_operazione = 'C': aggiornamento specie / denominazione convivenza
-- a_tipo_operazione = 'V': aggiornamento intestatario convivenza
-- a_tipo_operazione = 'R': sblocco certificabilit  famiglia (attributo FC)
--
      if a_archivio_rif = 'FAM' and a_tipo_operazione = 'C' then
         w_data_decorrenza  := nvl(rec.data_istituzione,f_ANPR_data_origine_fam(rec.fascia,rec.cod_fam));
         w_data_definizione := nvl(rec.data_istituzione,f_ANPR_data_origine_fam(rec.fascia,rec.cod_fam));
      elsif a_archivio_rif = 'FAM' and a_tipo_operazione = 'V' then
         w_data_decorrenza  := rec.data_intestatario;
         w_data_definizione := rec.data_intestatario;
      else
         w_data_decorrenza  := to_char(sysdate,'j');
         w_data_definizione := to_char(sysdate,'j');
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,w_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,rec.tipo_convivenza,rec.matricola_intestatario,rec.data_intestatario,a_id_operazione);

     if a_archivio_rif = 'FAM' and a_tipo_operazione in ('C','R') then
        goto datiDelProcedimento;
     end if;

     begin
       select ana.matricola, ana.cognome_nome, ana.sesso, ana.data_nas, ana.anno_nas, ana.cod_fiscale
         into w_matricola_CC, w_cognome_nome_CC, w_sesso_CC, w_data_nas_CC, w_anno_nas_CC, w_cod_fiscale_CC
         from anaana ana
        where ana.matricola = rec.matricola_intestatario
--          and (ana.fascia != 1 or ana.cod_fam != rec.cod_fam)
       ;
       w_cognome_CC               := f_cognome(w_cognome_nome_CC);
       w_nome_CC                  := f_nome(w_cognome_nome_CC);
--       w_dataIntestarioConvivenza := f_ANPR_data(a_data_CC);
     exception
       when others then
            w_cognome_nome_CC := '';
            w_sesso_CC        := '';
            w_data_nas_CC     := '';
            w_anno_nas_CC     := '';
     end;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggettiFamiglia','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_CC,w_matricola_CC);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_CC,w_nome_CC,w_sesso_CC,w_data_nas_CC,w_anno_nas_CC);
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_legame(w_servizio_log,rec.tipo_fam,rec.fascia,rec.cod_fam,'CC',w_sesso_CC,rec.data_intestatario,'','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_autoveicoli(w_servizio_log,w_matricola_CC);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggettiFamiglia','F');

      goto datiDelProcedimento;

<< archivio_VIE >>
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      if a_archivio_rif = 'VIE_9' then
         w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.min_data_inizio_res);
      else
         w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.max_data_inizio_res);
      end if;
      w_data_definizione   := to_char(sysdate,'j');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,w_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,rec.tipo_convivenza,rec.matricola_intestatario,rec.data_intestatario,a_id_operazione);

      if rec.fascia = 1 then
         w_tipoIndirizzo           := '1';
      elsif rec.fascia = 3 then
         w_tipoIndirizzo           := '4';
      end if;

      w_dataDecorrenzaResidenza := f_ANPR_data(w_data_decorrenza);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaFamigliaConvivenza','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoIndirizzo,'tipoIndirizzo');

      if rec.fascia = 1 then
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_indirizzo(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_indirizzo_esteso(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano
                                                                        ,rec.flag_metrico,rec.progr_snc,rec.flag_lettera,rec.flag_esponente,rec.flag_nui,rec.nui,rec.colore
                                                                        ,rec.corte,rec.interno2,rec.sub_interno2,rec.secondario,rec.scala_esterna);
      elsif rec.fascia = 3 then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_localitaEstera(w_servizio_log,rec.via_aire,rec.zipcode,rec.cod_pro_aire,rec.cod_com_aire,rec.provincia_contea,rec.cod_consolato,rec.tipo_consolato,rec.cod_stato);
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.presso,'presso','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenzaResidenza,'dataDecorrenzaResidenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaFamigliaConvivenza','F');

<< datiDelProcedimento >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiDelProcedimento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiDelProcedimento','F');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      if a_archivio_rif = 'FAM' and a_tipo_operazione in ('C','R') then
-- w_tipoMutazione = '3': dati generali famiglia / convivenza
         w_tipoMutazione := '3';

      elsif a_archivio_rif = 'FAM' and a_tipo_operazione in ('V')  then
-- w_tipoMutazione = '1': intestatario tutore responsabile
         w_tipoMutazione := '1';

      elsif a_archivio_rif like 'VIE%' then
-- w_tipoMutazione = '4': Residenza scheda
-- w_tipoMutazione = '7': Revisione onomastica stradale e dei numeri civici
-- w_tipoMutazione = '9': Rettifica/Integrazione indirizzo
         if length(a_archivio_rif) = 5 then
            w_tipoMutazione := substr(a_archivio_rif,5,1);
         else
            w_tipoMutazione := '4';
         end if;
      end if;

      if rec.tipo_fam is null then
-- w_tipoSchecda = 1: famiglia
         w_tipoScheda    := 1;
      elsif rec.tipo_fam is not null then
-- w_tipoScheda = 2: convivenza
         w_tipoScheda    := 2;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda','S');

      if a_archivio_rif = 'FAM' and a_tipo_operazione = 'R' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'FC','codice');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'S','valore');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','F');
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);
      if rec.tipo_fam is not null then
         ANPR_pkg.ins_anpads(w_servizio_log, '', '', rec.fascia, rec.tipo_fam, rec.cod_fam, 'Convivenza');
      end if;
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5001_mutazione_FAM;

function ws_A000_iscrizione_aire
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
)

return clob

is

cursor sel_mov is
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.*
-- dati soggetto
     , decode(mov.cod_mov,12,3,13,3,mov.cod_mov) fascia
     , mov.cod_eve stato
     , decode(mov.cod_mov,3,'S',12,'S',13,'S') soggettoAIRE
     , ana.sospensione
     , ana.questionario_cens
     , ana.matricola_aire matricola_aire_ana
     , ana.data_inizio_naz data_inizio_naz_ana
-- dati famiglia
     , mov.cod_mov fascia_fam
     , decode(mov.rapporto_par,'IC',1,'CC',1) tipo_fam
     , to_number(null) tipo_convivenza
     , to_number(null) matricola_intestatario
     , to_number(null) data_intestatario
-- dati coniuge
     , decode(ana_cn.fascia,3,'S') soggettoAIRE_cn
     , ana_cn.fascia fascia_cn
     , decode(ana_cn.sesso, '',
         decode(mov.stato_civile,'UC',mov.sesso,'VU',mov.sesso,'GU',mov.sesso,
           decode(mov.sesso,'M','F','M')),
         ana_cn.sesso) sesso_cn
     , ana_cn.data_nas data_nas_cn
     , ana_cn.anno_nas anno_nas_cn
     , ana_cn.cod_pro_nas cod_pro_nas_cn
     , ana_cn.cod_com_nas cod_com_nas_cn
     , ana_cn.stato_civile stato_civile_cn
     , ana_cn.nazionalita nazionalita_cn
     , ana_cn.data_inizio_naz data_inizio_naz_cn
     , ana_cn.cod_prof cod_prof_cn
     , ana_cn.posizione_prof posizione_prof_cn
     , ana_cn.titolo_studio titolo_studio_cn
     , ana_cn.cod_fiscale cod_fiscale_cn
-- dati paternita
     , decode(ana_pd.fascia,3,'S') soggettoAIRE_pd
     , ana_pd.fascia fascia_pd
     , ana_pd.cognome_nome cognome_nome_pd
     , ana_pd.sesso sesso_pd
     , ana_pd.data_nas data_nas_pd
     , ana_pd.anno_nas anno_nas_pd
     , ana_pd.cod_pro_nas cod_pro_nas_pd
     , ana_pd.cod_com_nas cod_com_nas_pd
     , ana_pd.stato_civile stato_civile_pd
     , ana_pd.nazionalita nazionalita_pd
     , ana_pd.data_inizio_naz data_inizio_naz_pd
     , ana_pd.cod_prof cod_prof_pd
     , ana_pd.posizione_prof posizione_prof_pd
     , ana_pd.titolo_studio titolo_studio_pd
     , ana_pd.cod_fiscale cod_fiscale_pd
     , ana_pd.cod_fam cod_fam_pd
     , ana_pd.rapporto_par rapporto_par_pd
-- dati maternita
     , decode(ana_md.fascia,3,'S') soggettoAIRE_md
     , ana_md.fascia fascia_md
     , ana_md.cognome_nome cognome_nome_md
     , ana_md.sesso sesso_md
     , ana_md.data_nas data_nas_md
     , ana_md.anno_nas anno_nas_md
     , ana_md.cod_pro_nas cod_pro_nas_md
     , ana_md.cod_com_nas cod_com_nas_md
     , ana_md.stato_civile stato_civile_md
     , ana_md.nazionalita nazionalita_md
     , ana_md.data_inizio_naz data_inizio_naz_md
     , ana_md.cod_prof cod_prof_md
     , ana_md.posizione_prof posizione_prof_md
     , ana_md.titolo_studio titolo_studio_md
     , ana_md.cod_fiscale cod_fiscale_md
     , ana_md.cod_fam cod_fam_md
     , ana_md.rapporto_par rapporto_par_md
  from anadce dce
     , anaana ana_cn
     , anaana ana_md
     , anaana ana_pd
     , anaana ana
     , anamov mov
 where dce.anagrafe                = 'AIR'
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and ana_cn.matricola (+)        = mov.matricola_cn
   and ana_md.matricola (+)        = mov.matricola_md
   and ana_pd.matricola (+)        = mov.matricola_pd
   and ana.matricola               = mov.matricola
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
;

w_protocollo_aire		number;
w_anno_protocollo_aire		number;
w_iniziativa			number;
w_individuazione		number;
w_data_arrivo 			number;
w_anno_espatrio			number;
w_cod_consolato			number;
w_tipo_consolato		number;
w_stato				number;
w_matricola_aire		varchar2(255);

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;

w_progr_componente		number;

w_cod_fiscale			varchar2(255);
w_cognome 			varchar2(255);
w_cognome_cn                   	varchar2(255);
w_cognome_pd			varchar2(255);
w_cognome_md			varchar2(255);

w_nome 				varchar2(255);
w_nome_cn			varchar2(255);
w_nome_pd			varchar2(255);
w_nome_md			varchar2(255);

w_idSchedaSoggettoANPR		varchar2(255);
w_idSchedaSoggettoANPR_cn	varchar2(255);
w_idSchedaSoggettoANPR_pd	varchar2(255);
w_idSchedaSoggettoANPR_md	varchar2(255);

w_soggettoAIRE			varchar2(255);
w_soggettoAIRE_cn		varchar2(255);
w_soggettoAIRE_pd		varchar2(255);
w_soggettoAIRE_md		varchar2(255);

w_data_decorrenza_ws		number;
w_data_decorrenza_fam		number;

w_data_atto_rif        		number;

w_tipoIndirizzo			varchar2(255);
w_dataDecorrenzaResidenza	varchar2(255);

w_origineCognome		varchar2(255);
w_filiazione     		varchar2(255);
w_attribuzioneFamiglia 		varchar2(255);
w_gestioneCF			varchar2(255);

w_tipo_evento_proc              varchar2(255);

w_tipoMutazione			varchar2(255);

w_cod_fiscale_ws		varchar2(255);

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'A000_iscrizione_aire';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno_progr '||a_anno_rif||' - numero_progr '||a_numero_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolarioA000aire" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/A000aire" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_mov loop
      w_note_log := 'cod_mov '||rec.cod_mov||' - cod_eve '||rec.cod_eve||' - matricola '||rec.matricola||' - pratica '||rec.pratica||' - anno_pratica '||rec.anno_pratica;

      begin
        select a01.protocollo_aire
             , a01.anno_protocollo_aire
             , a01.iniziativa
             , a01.individuazione
             , a01.data_arrivo
             , a01.anno_espatrio
             , a01.cod_consolato
             , a01.tipo_consolato
             , a01.cod_territorio
             , a0m.matricola_aire
          into w_protocollo_aire
             , w_anno_protocollo_aire
             , w_iniziativa
             , w_individuazione
             , w_data_arrivo
             , w_anno_espatrio
             , w_cod_consolato
             , w_tipo_consolato
             , w_stato
             , w_matricola_aire
          from anaa01 a01, anaa0m a0m
         where a01.anno_protocollo_aire = a0m.anno_protocollo_aire
           and a01.protocollo_aire      = a0m.protocollo_aire
           and a01.data_decorrenza      = rec.data_eve
           and a0m.matricola_aire       = nvl(rec.matricola_aire,rec.matricola_aire_ana)
           and a0m.matricola            = rec.matricola
           and rownum                   = 1
        ;
--        ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'parametri', ' w_iniz '||w_iniziativa||' w_indi '||w_individuazione||' w_data '||w_data_arrivo||' w_anno '||w_anno_espatrio);
      exception
        when others then
             ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore a01/a0m', 'matricola '||rec.matricola||' matricola_aire '||rec.matricola_aire||' ('||SQLERRM||')');
             w_protocollo_aire      := '';
             w_anno_protocollo_aire := '';
             w_iniziativa           := '';
             w_individuazione       := '';
             w_data_arrivo          := '';
             w_anno_espatrio        := '';
             w_cod_consolato        := '';
             w_tipo_consolato       := '';
             w_stato                := '';
      end;

      if rec.cf_calcolato = 'S' then
         w_cod_fiscale := '';
      else
         w_cod_fiscale := rec.cod_fiscale;
      end if;

      w_cognome                 := f_cognome(rec.cognome_nome);
      w_nome                    := f_nome(rec.cognome_nome);

      if rec.cognome_nome_cn is not null then
         w_cognome_cn		:= f_cognome(rec.cognome_nome_cn);
         w_nome_cn		:= f_nome(rec.cognome_nome_cn);
      end if;

      if rec.cognome_nome_pd is not null then
         w_cognome_pd		:= f_cognome(rec.cognome_nome_pd);
         w_nome_pd		:= f_nome(rec.cognome_nome_pd);
      elsif rec.paternita is not null then
         w_cognome_pd 		:= f_cognome_pd('',rec.paternita,rec.cognome_nome);
         w_nome_pd 		:= f_nome_pd('',rec.paternita,rec.cognome_nome);
      end if;

      if nvl(rec.cognome_nome_md,rec.maternita) is not null then
         w_cognome_md		:= f_cognome(nvl(rec.cognome_nome_md,rec.maternita));
         w_nome_md		:= f_nome(nvl(rec.cognome_nome_md,rec.maternita));
      end if;

      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR    := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'CN') is null then
         w_idSchedaSoggettoANPR_cn := f_ANPR_id_scheda(rec.matricola_cn,'','','','');
      end if;
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'PD') is null then
         w_idSchedaSoggettoANPR_pd := f_ANPR_id_scheda(rec.matricola_pd,'','','','');
      end if;
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'MD') is null then
         w_idSchedaSoggettoANPR_md := f_ANPR_id_scheda(rec.matricola_md,'','','','');
      end if;

      w_soggettoAIRE            := rec.soggettoAIRE;
      w_soggettoAIRE_cn         := rec.soggettoAIRE_cn;
      w_soggettoAIRE_pd         := rec.soggettoAIRE_pd;
      w_soggettoAIRE_md         := rec.soggettoAIRE_md;

      w_data_decorrenza_ws      := f_ANPR_data_decorrenza_ws(a_id_operazione);

      w_tipoIndirizzo           := f_ANPR_tipo_indirizzo(w_soggettoAIRE,rec.presso);
      w_dataDecorrenzaResidenza := f_ANPR_data(nvl(w_data_decorrenza_ws,rec.data_inizio_res));

      if rec.cod_mov = 98 and rec.cod_eve = 98 then
         w_data_decorrenza  := nvl(w_data_decorrenza_ws,rec.data_inizio_res);
      else
         w_data_decorrenza  := nvl(w_data_decorrenza_ws,rec.data_eve);
      end if;

      w_data_definizione := rec.data_reg;

      if w_protocollo_aire is not null and w_anno_protocollo_aire is not null then
         w_protocollo       := f_ANPR_protocollo(w_protocollo_aire,w_anno_protocollo_aire,rec.anagrafe,rec.tipo_evento);
         w_data_protocollo  := f_ANPR_data_pratica(rec.anagrafe,rec.tipo_evento,w_anno_protocollo_aire,w_protocollo_aire);
      elsif rec.pratica is not null and rec.anno_pratica is not null then
         w_protocollo       := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,rec.anagrafe,rec.tipo_evento);
         w_data_protocollo  := f_ANPR_data_pratica(rec.anagrafe,rec.tipo_evento,rec.anno_pratica,rec.pratica);
      else
         w_protocollo       := '';
         w_data_protocollo  := '';
      end if;

      w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,rec.cod_fiscale,rec.cf_calcolato);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalita >>
w_step := 1;
        if a_servizio in ('A001','A002') then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita'||a_servizio,'I');
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
        if w_gestioneCF = 1 and a_servizio != 'A006' then
           goto salta_cf;
        end if;
        w_cod_fiscale_ws := f_ANPR_cod_fiscale_ws(a_id_operazione,'',w_cod_fiscale,rec.cf_calcolato);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
<< salta_cf >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_step := 2;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_step := 3;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_anno_espatrio,'annoEspatrio','S');
        if w_idSchedaSoggettoANPR is null then
--w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,w_matricola_aire);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');

        if a_servizio in ('A001') then
           goto attributiSoggetto;
        elsif a_servizio in ('A006') then
           goto famiglia;
        end if;

<< statoCivile >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile,rec.sesso);

<< attributiSoggetto >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_attributiSoggetto(w_servizio_log,rec.matricola,rec.sospensione,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita'||a_servizio,'F');

<< attoNascita >>
        w_data_atto_rif := f_ANPR_data_atto_rif(2,rec.cod_pro_atto_nas,rec.cod_com_atto_nas,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,rec.anno_atto_nas);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_nas,rec.cod_com_atto_nas,w_data_atto_rif,rec.anno_atto_nas,rec.ufficio_nas,rec.parte_nas,rec.serie_nas,rec.atto_nas,'attoNascita',rec.atto_nas_digitale);

<< altraCittadinanza >>
        if nvl(rec.data_inizio_naz,rec.data_inizio_naz_ana) is not null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita,nvl(rec.data_inizio_naz,rec.data_inizio_naz_ana),'S');
        end if;

<< paternita >>
        if rec.paternita is null and rec.matricola_pd is null then
           goto maternita;
        end if;

w_step := 11.3;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'paternita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_pd,rec.matricola_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_pd,w_nome_pd,nvl(rec.sesso_pd,'M'),rec.data_nas_pd,rec.anno_nas_pd);
w_step := 12;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_pd,rec.cod_com_nas_pd,rec.data_nas_pd,'luogoNascita','N');
w_step := 13;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_pd,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR_pd is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_pd);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_pd,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile_pd,rec.sesso_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_pd,rec.data_inizio_naz_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof_pd,rec.sesso_pd,rec.posizione_prof_pd,rec.titolo_studio_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'paternita','F');

<< maternita >>
        if rec.maternita is null and rec.matricola_md is null then
           goto ultimaResidenzaIt;
        end if;

w_step := 21;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'maternita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_md,rec.matricola_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_md,w_nome_md,nvl(rec.sesso_md,'F'),rec.data_nas_md,rec.anno_nas_md);
w_step := 22;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_md,rec.cod_com_nas_md,rec.data_nas_md,'luogoNascita','N');
w_step := 23;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_md,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR_md is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_md);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_md,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile_md,rec.sesso_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_md,rec.data_inizio_naz_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof_md,rec.sesso_md,rec.posizione_prof_md,rec.titolo_studio_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'maternita','F');

<< ultimaResidenzaIt >>
      if a_servizio = 'A001' then
         goto famiglia;
      end if;

      if rec.cod_via_prec is not null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'ultimaResidenzaIt','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','tipoIndirizzo');
--w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_indirizzo(w_servizio_log,rec.cod_via_prec,rec.num_civ_prec,rec.suffisso_prec,rec.interno_prec,rec.sub_interno_prec,rec.scala_prec,rec.piano_prec);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_indirizzo_esteso(w_servizio_log,rec.cod_via_prec,rec.num_civ_prec,rec.suffisso_prec,rec.interno_prec,rec.sub_interno_prec,rec.scala_prec,rec.piano_prec
                                                                                ,rec.flag_metrico_prec,rec.progr_snc_prec,rec.flag_lettera_prec,rec.flag_esponente_prec,rec.flag_nui_prec,rec.nui_prec,rec.colore_prec
                                                                                ,rec.corte_prec,rec.interno2_prec,rec.sub_interno2_prec,rec.secondario_prec,rec.scala_esterna_prec);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'ultimaResidenzaIt','F');
      end if;

<< famiglia >>
      if a_servizio = 'A002' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'famiglia','I');
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,rec.tipo_convivenza,rec.matricola_intestatario,rec.data_intestatario,a_id_operazione);
      if a_servizio = 'A006' and rec.cod_mov = 98 then
         goto salta_legame;
      end if;
      w_data_decorrenza_fam := nvl(w_data_decorrenza_ws,rec.data_inizio_fam);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_legame(w_servizio_log,rec.tipo_fam,rec.fascia,rec.cod_fam,rec.rapporto_par,rec.sesso,w_data_decorrenza_fam,w_progr_componente,'');
<< salta_legame>>

      if a_servizio = 'A002' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'famiglia','F');
      end if;

      if a_servizio in ('A001','A006') then
         goto iscrizioneAire;
      end if;

<< matrimonio >>
      if rec.stato_civile in ('CN','VE','DV','GC') then
         if rec.cognome_nome_cn is null and rec.matricola_cn is null and rec.data_mat is null then
            goto vedovanza;
         end if;

w_step := 41;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'matrimonio','I');

        if rec.cognome_nome_cn is null and rec.matricola_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaCognome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaNome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','F');
           goto datiMatrimonio;
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_cn,rec.matricola_cn);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_cn,w_nome_cn,rec.sesso_cn,rec.data_nas_cn,rec.anno_nas_cn);
w_step := 42;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_cn,rec.cod_com_nas_cn,rec.data_nas_cn,'luogoNascita','N');
w_step := 43;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_cn,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_cn);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_cn,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_cn,rec.data_inizio_naz_cn);

<< datiMatrimonio >>
        if rec.data_mat is null then
           goto ordineMatrimonio;
        end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMatrimonio','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_mat,rec.anno_mat),'dataEvento','S');
           if nvl(rec.anno_mat,'N') = 'S' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','senzaGiornoMese');
           end if;
w_step := 44;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,'luogoEvento','N');
w_step := 45;
           if ltrim(rec.cod_pro_atto_mat||rec.cod_com_atto_mat,'0') is not null then
              w_data_atto_rif := f_ANPR_data_atto_rif(4,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,w_data_atto_rif,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoMatrimonio',rec.atto_mat_digitale);
           else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoMatrimonio',rec.atto_mat_digitale);
           end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMatrimonio','F');

<< ordineMatrimonio >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'','ordineMatrimonio','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'matrimonio','F');
      end if;

<< vedovanza >>
      if rec.stato_civile in ('VE') then
         if rec.data_ved is null then
            goto divorzio;
         end if;
w_step := 51;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'vedovanza','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMorteconiuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_ved),'dataEvento');
w_step := 52;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,'luogoEvento','N');
w_step := 53;
         if ltrim(rec.cod_pro_atto_ved||rec.cod_com_atto_ved,'0') is not null then
           w_data_atto_rif := f_ANPR_data_atto_rif(5,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,w_data_atto_rif,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoMorteConiuge',rec.atto_ved_digitale);
         else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoMorteConiuge',rec.atto_ved_digitale);
         end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMorteconiuge','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'','ordineMatrimonioPrecedente','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'vedovanza','F');
      end if;

<< divorzio >>
      if rec.stato_civile in ('DV','GC') and nvl(rec.data_div,rec.data_div_ann) is not null then
         if rec.data_div is null and rec.data_div_ann is null then
            goto cartaIdentita;
         end if;
w_step := 61;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'annullamentoMatrimonio','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_divorzio(w_servizio_log,rec.matricola,rec.data_div,rec.data_div_ann);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_div,rec.cod_com_atto_div,nvl(rec.data_div_ann,rec.data_div),rec.anno_atto_div,rec.ufficio_div,rec.parte_div,rec.serie_div,rec.atto_div,'attoAnnullamentoMatrimonio',rec.atto_div_digitale);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'annullamentoMatrimonio','F');
      end if;

w_step := 71;
<< cartaIdentita >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cartaIdentita(w_servizio_log,rec.matricola);

<< permessoSoggiorno >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_permessoSoggiorno(w_servizio_log,rec.matricola);

<< listaElettorale >>
/* ANEL */
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_listaElettorale(w_servizio_log,rec.matricola);

<< listaLeva >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_listaLeva(w_servizio_log,rec.matricola);

<< altriDati >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof,rec.sesso,rec.posizione_prof,rec.titolo_studio);

<< iscrizioneAire >>
      if (a_servizio = 'A006' and rec.cod_mov != 3) or w_cod_consolato is null then
         begin
           select c.cod_consolato
                , c.tipo_consolato
                , nvl(c.cod_territorio,c.cod_provincia)
             into w_cod_consolato
                , w_tipo_consolato
                , w_stato
             from arccom c
            where c.cod_provincia = rec.cod_pro_aire
              and c.cod_comune    = rec.cod_com_aire
           ;
         exception
           when others then
                nuLL;
         end;
         if a_servizio = 'A006' and rec.cod_mov != 3 then
            goto residenzaEstera;
         end if;
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_iscrizioneAire(w_servizio_log,rec.cod_mov,rec.cod_eve,rec.cod_variazione,w_iniziativa,w_individuazione,w_data_arrivo);

<< residenzaEstera >>
w_step := 31;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaEstera','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoIndirizzo,'tipoIndirizzo');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_localitaEstera(w_servizio_log,rec.via_aire,rec.zipcode,rec.cod_pro_aire,rec.cod_com_aire,rec.provincia_contea,w_cod_consolato,w_tipo_consolato,w_stato);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.presso,'presso','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenzaResidenza,'dataDecorrenzaResidenza','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaEstera','F');

<< datiDelProcedimento >>
      w_tipo_evento_proc := f_ANPR_tipo_evento_ciu(rec.cod_mov,rec.cod_eve,'S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_datiDelProcedimento(w_servizio_log,rec.pratica,rec.anno_pratica,rec.data_reg,rec.anagrafe,w_tipo_evento_proc);

<< datiControllo >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
--
-- tipoMutazione
-- Valori ammessi:
-- 1=Modifica della residenza dall'Italia all estero
-- 2=Modifica residenza, abitazione o indirizzo all estero
-- 3=Modifica del comune AIRE di riferimento
-- 4=Dati generali iscrizione
--
      if a_servizio = 'A006' then
         if rec.cod_mov = 3 then
            w_tipoMutazione := '1';
         elsif rec.cod_mov in (12,13) then
            w_tipoMutazione := '2';
         elsif rec.cod_mov = 98 and rec.cod_eve = 98 then
            w_tipoMutazione := '2';
         end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end if;

      if rec.cod_mov = 98 and rec.cod_eve = 98 then
         w_attribuzioneFamiglia := 1;
      elsif rec.cod_eve != 91 and rec.nucleo_arrivo = 1 and rec.rapporto_par = 'CF' then
         ANPR_pkg.ins_anpads(w_servizio_log, rec.matricola, '', rec.fascia, rec.tipo_fam, rec.cod_fam, 'Famiglia AIRE');
         w_attribuzioneFamiglia := 2;
      else
         w_attribuzioneFamiglia := 1;
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_attribuzioneFamiglia,'attribuzioneFamigliaAIRE','S');

      if a_servizio != 'A006' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob_sog);
w_xml_clob := w_xml_clob||w_xml_clob_sog;

      ANPR_pkg.ins_anpads(w_servizio_log, rec.matricola, rec.matricola_aire, '', '', '', 'Aire');
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_A000_iscrizione_aire;

function ws_2000_cancellazione_apr
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
)

return clob

is

cursor sel_mov is
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.*
-- dati soggetto
     , decode(mov.cod_mov,2,1,3,1,3) fascia
     , decode(mov.cod_mov,4,'S') soggettoAIRE
  from anadce dce
     , anaana ana
     , anamov mov
 where ((dce.anagrafe = 'RES' and dce.cod_mov in (2,3))
        or
        (dce.anagrafe = 'AIR' and mov.cod_mov = 4))
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and ana.matricola               = mov.matricola
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
;

cursor sel_mov_comp (p_cod_mov number, p_cod_fam number, p_data_eve number, p_data_reg number, p_pratica number, p_anno_pratica number) is
select
-- dati movimento
       mov.*
-- dati soggetto
     , decode(mov.cod_mov,10,1,12,3) fascia
     , decode(mov.cod_mov,12,'S') soggettoAIRE
-- dati famiglia
     , decode(mov.rapporto_par,'CC',1,'IC',1) tipo_fam
  from anaana ana
     , anamov mov
 where ana.matricola           = mov.matricola
   and mov.rapporto_par_prec   != mov.rapporto_par
   and nvl(mov.pratica,0)      = nvl(p_pratica,0)
   and nvl(mov.anno_pratica,0) = nvl(p_anno_pratica,0)
   and mov.cod_fam             = p_cod_fam
   and mov.data_eve            = p_data_eve
   and mov.data_reg            = p_data_reg
   and mov.cod_mov             = decode(p_cod_mov,2,10,3,10,4,12)
;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;
w_data_decorrenza_ws		number;

w_progr_componente		number;

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);
w_ruoloSoggetto			varchar2(255);

w_cognome_comp 			varchar2(255);
w_nome_comp 			varchar2(255);
w_idSchedaSoggettoANPR_comp	varchar2(255);
w_soggettoAIRE_comp		varchar2(255);

w_data_atto_rif			number;

w_tipo_evento_proc              varchar2(255);

w_cod_fiscale_ws		varchar2(255);

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '2000_cancellazione_apr';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno_progr '||a_anno_rif||' - numero_progr '||a_numero_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario2000cancellazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/2000cancellazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_mov loop
      w_note_log := 'cod_mov '||rec.cod_mov||' - cod_eve '||rec.cod_eve||' - matricola '||rec.matricola||' - pratica '||rec.pratica||' - anno_pratica '||rec.anno_pratica;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log);

w_step := 0.1;
      w_cognome                 := f_cognome(rec.cognome_nome);
      w_nome                    := f_nome(rec.cognome_nome);
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR    := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_soggettoAIRE            := rec.soggettoAIRE;

w_step := 0.6;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
--      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_eve);
      w_data_decorrenza    := rec.data_eve;

      w_data_definizione   := rec.data_reg;
      if a_servizio in ('2001') then
         w_protocollo       := '';
         w_data_protocollo  := '';
      elsif a_servizio in ('2003') then
         w_protocollo       := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,rec.anagrafe,rec.tipo_evento);
         w_data_protocollo  := f_ANPR_data_pratica(rec.anagrafe,rec.tipo_evento,rec.anno_pratica,rec.pratica);
      end if;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,nvl(w_data_decorrenza_ws,w_data_decorrenza),w_data_definizione);

<< datiCancellazione >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_datiCancellazione(w_servizio_log,rec.cod_mov,rec.cod_eve,rec.cod_variazione,rec.cod_pro_eve,w_data_decorrenza);

<< generalita >>
w_step := 1;
      w_cod_fiscale_ws := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
--w_step := 2;
--w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_step := 3;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
      if w_idSchedaSoggettoANPR is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< datiDecesso >>
      if a_servizio not in ('2001') then
         goto destinazione;
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiDecesso','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(nvl(rec.data_mor,rec.data_eve)),'dataEvento','S');

      if w_tipo_invio = 'TEST' and w_codice_cliente = '039010' and rec.matricola = 115830 then		-- Faenza_TEST
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaGiorno','S');
      elsif w_tipo_invio = 'PROD' and w_codice_cliente = '039010' and rec.matricola = 50970 then	-- Faenza_PROD
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaGiorno','S');
      elsif w_tipo_invio = 'PROD' and w_codice_cliente = '040020' and rec.matricola = 2672421 then	-- Mercato Saraceno - 09/05/2022
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaGiorno','S');
      elsif w_tipo_invio = 'PROD' and w_codice_cliente = '081021' and rec.matricola = 160562 then       -- Trapani_PROD
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'2022-04-22','dataEvento','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaGiornoMese','S');
      elsif w_tipo_invio = 'PROD' and w_codice_cliente = '048035' and rec.matricola = 15952 then       	-- Reggello_PROD
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaGiornoMese','S');
      elsif w_tipo_invio = 'PROD' and w_codice_cliente = '048035' and rec.matricola = 7734 then       	-- Reggello_PROD
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaGiorno','S');
      end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_mor,rec.cod_com_mor,rec.data_mor,'luogoEvento','N');
      if ltrim(rec.cod_pro_atto_mor||rec.cod_com_atto_mor,'0') is not null then
         w_data_atto_rif := f_ANPR_data_atto_rif(5,rec.cod_pro_atto_mor,rec.cod_com_atto_mor,rec.cod_pro_mor,rec.cod_com_mor,rec.data_mor,rec.anno_atto_mor);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_mor,rec.cod_com_atto_mor,w_data_atto_rif,rec.anno_atto_mor,rec.ufficio_mor,rec.parte_mor,rec.serie_mor,rec.atto_mor,'attoEvento',rec.atto_mor_digitale);
      else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_mor,rec.cod_com_mor,rec.data_mor,rec.anno_atto_mor,rec.ufficio_mor,rec.parte_mor,rec.serie_mor,rec.atto_mor,'attoEvento',rec.atto_mor_digitale);
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiDecesso','F');

<< datiSentenza >>
-- obbligatorio se motivoCancellazione = 2 (morte presunta dichiarata giudizialmente)
null;
      goto elencoSoggetti;

<< destinazione >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_eve,rec.cod_com_eve,'','destinazione','N');

<< elencoSoggetti >>
      for rec_comp in sel_mov_comp (rec.cod_mov,rec.cod_fam,rec.data_eve,rec.data_reg,rec.pratica,rec.anno_pratica) loop
          w_cognome_comp              := f_cognome(rec_comp.cognome_nome);
          w_nome_comp                 := f_nome(rec_comp.cognome_nome);
          w_idSchedaSoggettoANPR_comp := f_ANPR_id_scheda(rec_comp.matricola,'','','','');
          w_soggettoAIRE_comp         := rec_comp.soggettoAIRE;
          if a_servizio in ('2001') then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggettiFamiglia','I');
          else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggetti','I');
          end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec_comp.cod_fiscale,rec_comp.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_comp,w_nome_comp,rec_comp.sesso,rec_comp.data_nas,rec_comp.anno_nas);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec_comp.cod_pro_nas,rec_comp.cod_com_nas,rec_comp.data_nas,'luogoNascita','N');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_comp,'soggettoAIRE','S');
          if w_idSchedaSoggettoANPR_comp is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec_comp.matricola);
          end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_comp,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_legame(w_servizio_log,rec_comp.tipo_fam,rec_comp.fascia,rec_comp.cod_fam,rec_comp.rapporto_par,rec_comp.sesso,rec_comp.data_eve,'','');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_autoveicoli(w_servizio_log,rec_comp.matricola);
          if a_servizio in ('2001') then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggettiFamiglia','F');
          else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggetti','F');
          end if;
      end loop;

<< altriDati >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof,rec.sesso,rec.posizione_prof,rec.titolo_studio);

<< datiDelProcedimento >>
      w_tipo_evento_proc := f_ANPR_tipo_evento_ciu(rec.cod_mov,rec.cod_eve,'S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_datiDelProcedimento(w_servizio_log,rec.pratica,rec.anno_pratica,rec.data_reg,rec.anagrafe,w_tipo_evento_proc);

<< datiControllo >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      if nvl(rec.rapporto_par_prec,rec.rapporto_par) = 'CF' then
         w_ruoloSoggetto := '1';
      else
         w_ruoloSoggetto := '2';
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_ruoloSoggetto,'ruoloSoggetto','S');

<< listaControlli >>
      if a_servizio = '2003' and rec.cod_mov = 2 and rec.cod_eve = 62 then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'RA','codice');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','valore');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','F');
      end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob_sog);
w_xml_clob := w_xml_clob||w_xml_clob_sog;

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_2000_cancellazione_apr;

function ws_5000_mutazione
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
,a_id_anadoc		number
,a_id_anamsi		number
,a_matricola		number
,a_fascia_fam		number
,a_cod_fam		number
,a_archivio_rif		varchar2
)

return clob

is

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  if a_archivio_rif like 'MOV%' or a_archivio_rif in ('APR','AIR','AIR_M') then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_MOV(a_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif,a_archivio_rif);
  elsif a_archivio_rif like 'DOC%' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_DOC(a_servizio,a_id_operazione,a_tipo_operazione,a_id_anadoc,a_archivio_rif,a_cod_fam);
  elsif a_archivio_rif = 'MSI' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_MSI(a_servizio,a_id_operazione,a_tipo_operazione,a_id_anamsi);
  elsif a_archivio_rif = 'SFD' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_SFD(a_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif);
  elsif a_archivio_rif like 'CDF%' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_CDF(a_servizio,a_id_operazione,a_tipo_operazione,a_matricola,a_cod_fam,a_archivio_rif);
  elsif a_archivio_rif like 'ELE%' or a_archivio_rif like 'ELA%' or a_archivio_rif = 'DSE' or a_archivio_rif = 'PSE' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_ELE(a_servizio,a_id_operazione,a_tipo_operazione,a_matricola,a_archivio_rif,a_anno_rif,a_numero_rif);
  elsif a_archivio_rif = 'LEV' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_LEV(a_servizio,a_id_operazione,a_tipo_operazione,a_matricola,a_archivio_rif);
  elsif a_archivio_rif like 'SUB%' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_SUB(a_servizio,a_id_operazione,a_tipo_operazione,a_matricola,a_archivio_rif,a_anno_rif,a_numero_rif);
  elsif a_archivio_rif = 'FAM' or a_archivio_rif like 'VIE%' then
     w_xml_clob := ANPR_pkg.ws_5001_mutazione_FAM(a_servizio,a_id_operazione,a_tipo_operazione,a_fascia_fam,a_cod_fam,a_archivio_rif);
  elsif a_archivio_rif = 'ARI' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_ARI(a_servizio,a_id_operazione,a_tipo_operazione,a_matricola,a_archivio_rif);
  end if;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione;

function ws_5000_mutazione_MOV
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
,a_archivio_rif 	varchar2
)

return clob

is

cursor sel_mov is
select distinct dce.anagrafe
     , decode(a_archivio_rif,'MOV_RP','E',dce.tipo_evento) tipo_evento
-- dati movimento
     , mov.MATRICOLA
     , decode(a_archivio_rif,'MOV_RP',decode(dce.anagrafe,'AIR',12,10),mov.COD_MOV) cod_mov
     , decode(a_archivio_rif,'MOV_RP',90,mov.COD_EVE) cod_eve
     , mov.COD_VARIAZIONE
     , mov.DATA_EVE, mov.COD_PRO_EVE, mov.COD_COM_EVE, mov.ANNO_PRATICA, mov.PRATICA, mov.NUCLEO_PARTENZA, mov.NUCLEO_ARRIVO
     , mov.COGNOME_NOME_PREC, mov.STATO_CIVILE_PREC, mov.SESSO_PREC
     , mov.COD_FAM_PREC, mov.RAPPORTO_PAR_PREC
     , mov.COD_VIA_PREC, mov.NUM_CIV_PREC, mov.SUFFISSO_PREC, mov.INTERNO_PREC
     , mov.DATA_NAS_PREC, mov.COD_FISCALE_PREC
     , mov.COGNOME_NOME, mov.STATO_CIVILE, mov.SESSO, mov.NAZIONALITA, mov.PATERNITA, mov.MATERNITA
     , mov.TITOLO_STUDIO, mov.COD_PROF, mov.ATTIVITA_PROF, mov.POSIZIONE_PROF
     , mov.COD_FAM, mov.INTESTATARIO, mov.RAPPORTO_PAR
     , mov.DATA_INIZIO_FAM
     , mov.COD_VIA, mov.NUM_CIV, mov.SUFFISSO, mov.INTERNO
     , mov.VIA_AIRE, mov.COD_PRO_AIRE, mov.COD_COM_AIRE
     , mov.DATA_INIZIO_RES
     , mov.COGNOME_NOME_CN, mov.MATRICOLA_CN
     , mov.ANNO_CENS, mov.SEZIONE_CENS, mov.FOGLIO_CENS
     , mov.COD_PRO_NAS, mov.COD_COM_NAS, mov.DATA_NAS, mov.COD_PRO_ATTO_NAS, mov.COD_COM_ATTO_NAS
     , mov.ANNO_ATTO_NAS, mov.ATTO_NAS, mov.PARTE_NAS, mov.SERIE_NAS, mov.UFFICIO_NAS
     , mov.ANNO_ATTO_NAS_TR, mov.ATTO_NAS_TR, mov.PARTE_NAS_TR, mov.SERIE_NAS_TR, mov.UFFICIO_NAS_TR
     , mov.COD_PRO_MAT, mov.COD_COM_MAT, mov.DATA_MAT
     , mov.ANNO_ATTO_MAT, mov.ATTO_MAT, mov.PARTE_MAT, mov.SERIE_MAT, mov.UFFICIO_MAT
     , mov.ANNO_ATTO_MAT_TR, mov.ATTO_MAT_TR, mov.PARTE_MAT_TR, mov.SERIE_MAT_TR, mov.UFFICIO_MAT_TR
     , mov.COD_PRO_VED, mov.COD_COM_VED, mov.DATA_VED
     , mov.ANNO_ATTO_VED, mov.ATTO_VED, mov.PARTE_VED, mov.SERIE_VED, mov.UFFICIO_VED
     , mov.COD_FISCALE, mov.DATA_REG
     , mov.ANNO_PROGR, mov.NUMERO_PROGR
     , mov.COD_PRO_DIV, mov.COD_COM_DIV, mov.DATA_DIV
     , mov.ANNO_ATTO_DIV, mov.ATTO_DIV, mov.PARTE_DIV, mov.SERIE_DIV, mov.UFFICIO_DIV
     , mov.MATRICOLA_AIRE
     , mov.COD_PRO_ATTO_MAT, mov.COD_COM_ATTO_MAT, mov.COD_PRO_ATTO_VED, mov.COD_COM_ATTO_VED, mov.COD_PRO_ATTO_MOR, mov.COD_COM_ATTO_MOR
     , mov.CF_CALCOLATO
     , mov.SCALA_PREC, mov.PIANO_PREC, mov.ZIPCODE_PREC
     , mov.SCALA, mov.PIANO, mov.ZIPCODE
     , mov.COD_EDIFICIO_CENS
     , mov.COD_PRO_ATTO_DIV, mov.COD_COM_ATTO_DIV, mov.DATA_DIV_GIU, mov.DATA_DIV_ANN
     , mov.PROVINCIA_CONTEA, mov.PRESSO
     , mov.ANNO_NAS_PREC
     , mov.ANNO_NAS, mov.ANNO_MAT, mov.SUB_INTERNO
     , mov.SUB_INTERNO_PREC
     , mov.MATRICOLA_PD, mov.MATRICOLA_MD
     , mov.DATA_INIZIO_NAZ
     , mov.ATTO_NAS_DIGITALE, mov.ATTO_NAS_TR_DIGITALE, mov.ATTO_MAT_DIGITALE, mov.ATTO_MAT_TR_DIGITALE
     , mov.ATTO_DIV_DIGITALE, mov.ATTO_VED_DIGITALE, mov.ATTO_MOR_DIGITALE, mov.ATTO_MOR_TR_DIGITALE
--
     , mov.FLAG_METRICO_PREC, mov.PROGR_SNC_PREC, mov.FLAG_LETTERA_PREC, mov.FLAG_ESPONENTE_PREC, mov.FLAG_NUI_PREC, mov.NUI_PREC, mov.COLORE_PREC
     , mov.CORTE_PREC, mov.INTERNO2_PREC, mov.SUB_INTERNO2_PREC, mov.SECONDARIO_PREC, mov.SCALA_ESTERNA_PREC
     , mov.FLAG_METRICO, mov.PROGR_SNC, mov.FLAG_LETTERA, mov.FLAG_ESPONENTE, mov.FLAG_NUI, mov.NUI, mov.COLORE
     , mov.CORTE, mov.INTERNO2, mov.SUB_INTERNO2, mov.SECONDARIO, mov.SCALA_ESTERNA
-- dati soggetto
     , decode(mov.cod_mov,1,1,10,1,11,1,97,1,3) fascia
     , decode(mov.cod_mov,12,'S',13,'S',98,'S') soggettoAIRE
-- dati anagrafe
     , ana.questionario_cens
     , ana.sospensione
-- dati famiglia
     , decode(mov.cod_mov,1,1,10,1,11,1,97,1,3) fascia_fam
     , decode(mov.rapporto_par,'CC',1,'IC',1) tipo_fam
-- dati coniuge
     , decode(ana_cn.fascia,3,'S') soggettoAIRE_cn
     , decode(ana_cn.sesso, '',
         decode(mov.stato_civile,'UC',mov.sesso,'VU',mov.sesso,'GU',mov.sesso,
           decode(mov.sesso,'M','F','M')),
         ana_cn.sesso) sesso_cn
     , ana_cn.nazionalita nazionalita_cn
     , ana_cn.data_inizio_naz data_inizio_naz_cn
-- dati paternita
     , decode(ana_pd.fascia,3,'S') soggettoAIRE_pd
     , ana_pd.cognome_nome cognome_nome_pd
-- dati maternita
     , decode(ana_md.fascia,3,'S') soggettoAIRE_md
     , ana_md.cognome_nome cognome_nome_md
  from anadce dce
     , anaana ana_cn
     , anaana ana_md
     , anaana ana_pd
     , anaana ana
     , anamov mov
 where ana_cn.matricola (+)        = mov.matricola_cn
   and ana_md.matricola (+)        = mov.matricola_md
   and ana_pd.matricola (+)        = mov.matricola_pd
   and ((dce.tipo_evento != 'R' and dce.cod_mov in (10,12))
        or (dce.cod_mov not in (10,12)))
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and dce.anagrafe                = decode(mov.cod_eve,4,'RES',dce.anagrafe)
   and ana.matricola               = mov.matricola
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
   and a_archivio_rif              like 'MOV%'
UNION
select distinct to_char(null) anagrafe
     , to_char(null) tipo_evento
-- dati movimento
     , ana.MATRICOLA
     , ana.fascia COD_MOV, to_number(null) COD_EVE, to_char(null) COD_VARIAZIONE
     , ana.data_ult_eve DATA_EVE, to_number(null) COD_PRO_EVE, to_number(null) COD_COM_EVE
     , to_number(null) ANNO_PRATICA, to_number(null) PRATICA, to_number(null) NUCLEO_PARTENZA, to_number(null) NUCLEO_ARRIVO
     , to_char(null) COGNOME_NOME_PREC, to_char(null) STATO_CIVILE_PREC, to_char(null) SESSO_PREC
     , to_number(null) COD_FAM_PREC, to_char(null) RAPPORTO_PAR_PREC
     , to_number(null) COD_VIA_PREC, to_number(null) NUM_CIV_PREC, to_char(null) SUFFISSO_PREC, to_number(null) INTERNO_PREC
     , to_number(null) DATA_NAS_PREC, to_char(null) COD_FISCALE_PREC
     , ana.COGNOME_NOME, ana.STATO_CIVILE, ana.SESSO, ana.NAZIONALITA, ana.PATERNITA, ana.MATERNITA
     , ana.TITOLO_STUDIO, ana.COD_PROF, ana.ATTIVITA_PROF, ana.POSIZIONE_PROF
     , ana.COD_FAM, to_char(Null) INTESTATARIO, ana.RAPPORTO_PAR
     , ana.DATA_INIZIO_FAM
     , to_number(null) COD_VIA, to_number(null) NUM_CIV, to_char(null) SUFFISSO, to_number(null) INTERNO
     , to_char(null) VIA_AIRE, to_number(null) COD_PRO_AIRE, to_number(null) COD_COM_AIRE
     , ana.DATA_INIZIO_RES
     , ana.COGNOME_NOME_CN, ana.MATRICOLA_CN
     , ana.ANNO_CENS, ana.SEZIONE_CENS, ana.FOGLIO_CENS
     , ana.COD_PRO_NAS, ana.COD_COM_NAS, ana.DATA_NAS, ana.COD_PRO_ATTO_NAS, ana.COD_COM_ATTO_NAS
     , ana.ANNO_ATTO_NAS, ana.ATTO_NAS, ana.PARTE_NAS, ana.SERIE_NAS, ana.UFFICIO_NAS
     , ana.ANNO_ATTO_NAS_TR, ana.ATTO_NAS_TR, ana.PARTE_NAS_TR, ana.SERIE_NAS_TR, ana.UFFICIO_NAS_TR
     , ana.COD_PRO_MAT, ana.COD_COM_MAT, ana.DATA_MAT
     , ana.ANNO_ATTO_MAT, ana.ATTO_MAT, ana.PARTE_MAT, ana.SERIE_MAT, ana.UFFICIO_MAT
     , ana.ANNO_ATTO_MAT_TR, ana.ATTO_MAT_TR, ana.PARTE_MAT_TR, ana.SERIE_MAT_TR, ana.UFFICIO_MAT_TR
     , ana.COD_PRO_VED, ana.COD_COM_VED, ana.DATA_VED
     , ana.ANNO_ATTO_VED, ana.ATTO_VED, ana.PARTE_VED, ana.SERIE_VED, ana.UFFICIO_VED
     , ana.COD_FISCALE, ana.DATA_REG
--     , mov.ANNO_PROGR, mov.NUMERO_PROGR
     , to_number(null) ANNO_PROGR, to_number(null) NUMERO_PROGR
     , ana.COD_PRO_DIV, ana.COD_COM_DIV, ana.DATA_DIV
     , ana.ANNO_ATTO_DIV, ana.ATTO_DIV, ana.PARTE_DIV, ana.SERIE_DIV, ana.UFFICIO_DIV
     , ana.MATRICOLA_AIRE
     , ana.COD_PRO_ATTO_MAT, ana.COD_COM_ATTO_MAT, ana.COD_PRO_ATTO_VED, ana.COD_COM_ATTO_VED, ana.COD_PRO_ATTO_MOR, ana.COD_COM_ATTO_MOR
     , ana.CF_CALCOLATO
     , to_char(null) SCALA_PREC, to_char(null) PIANO_PREC, to_char(null) ZIPCODE_PREC
     , to_char(null) SCALA, to_char(null) PIANO, to_char(null) ZIPCODE
     , ana.COD_EDIFICIO_CENS
     , ana.COD_PRO_ATTO_DIV, ana.COD_COM_ATTO_DIV, ana.DATA_DIV_GIU, ana.DATA_DIV_ANN
     , to_char(null) PROVINCIA_CONTEA, to_char(null) PRESSO
     , to_char(null) ANNO_NAS_PREC
     , ana.ANNO_NAS, ana.ANNO_MAT, to_char(null) SUB_INTERNO
     , to_char(null) SUB_INTERNO_PREC
     , ana.MATRICOLA_PD, ana.MATRICOLA_MD
     , ana.DATA_INIZIO_NAZ
     , ana.ATTO_NAS_DIGITALE, ana.ATTO_NAS_TR_DIGITALE, ana.ATTO_MAT_DIGITALE, ana.ATTO_MAT_TR_DIGITALE
     , ana.ATTO_DIV_DIGITALE, ana.ATTO_VED_DIGITALE, ana.ATTO_MOR_DIGITALE, ana.ATTO_MOR_TR_DIGITALE
--
     , to_char(null) FLAG_METRICO_PREC, to_char(null) PROGR_SNC_PREC, to_char(null) FLAG_LETTERA_PREC, to_char(null) FLAG_ESPONENTE_PREC, to_char(null) FLAG_NUI_PREC, to_char(null) NUI_PREC, to_char(null) COLORE_PREC
     , to_char(null) CORTE_PREC, to_number(null) INTERNO2_PREC, to_char(null) SUB_INTERNO2_PREC, to_char(null) SECONDARIO_PREC, to_char(null) SCALA_ESTERNA_PREC
     , to_char(null) FLAG_METRICO, to_char(null) PROGR_SNC, to_char(null) FLAG_LETTERA, to_char(null) FLAG_ESPONENTE, to_char(null) FLAG_NUI, to_char(null) NUI, to_char(null) COLORE
     , to_char(null) CORTE, to_number(null) INTERNO2, to_char(null) SUB_INTERNO2, to_char(null) SECONDARIO, to_char(null) SCALA_ESTERNA
-- dati soggetto
     , ana.fascia
     , decode(ana.fascia,3,'S') soggettoAIRE
-- dati anagrafe
     , ana.questionario_cens
     , ana.sospensione
-- dati famiglia
     , ana.fascia fascia_fam
     , decode(ana.rapporto_par,'CC',1,'IC',1) tipo_fam
-- dati coniuge
     , decode(ana_cn.fascia,3,'S') soggettoAIRE_cn
     , decode(ana_cn.sesso, '',
         decode(ana.stato_civile,'UC',ana.sesso,'VU',ana.sesso,'GU',ana.sesso,
           decode(ana.sesso,'M','F','M')),
         ana_cn.sesso) sesso_cn
     , ana_cn.nazionalita nazionalita_cn
     , ana_cn.data_inizio_naz data_inizio_naz_cn
-- dati paternita
     , decode(ana_pd.fascia,3,'S') soggettoAIRE_pd
     , ana_pd.cognome_nome cognome_nome_pd
-- dati maternita
     , decode(ana_md.fascia,3,'S') soggettoAIRE_md
     , ana_md.cognome_nome cognome_nome_md
  from anaana ana_cn
     , anaana ana_md
     , anaana ana_pd
     , anaana ana
--     , anamov mov
 where ana_cn.matricola (+)        = ana.matricola_cn
   and ana_md.matricola (+)        = ana.matricola_md
   and ana_pd.matricola (+)        = ana.matricola_pd
   and ana.matricola               = a_numero_rif
   and a_archivio_rif              in ('AIR','AIR_M')
--   and ana.matricola               = mov.matricola
--   and mov.anno_progr              = a_anno_rif
--   and mov.numero_progr            = a_numero_rif
--   and a_archivio_rif              in ('APR','AIR')
;

cursor sel_mov_comp (p_cod_mov number,p_cod_eve number,p_cod_fam number,p_data_eve number,p_data_reg number,p_pratica number,p_anno_pratica number,p_matricola number) is
select
-- dati movimento
       mov.*
-- dati soggetto
     , decode(mov.cod_mov,1,1,10,1,12,3) fascia
     , decode(mov.cod_mov,12,'S',98,'S') soggettoAIRE
-- dati famiglia
     , decode(mov.cod_mov,1,1,10,1,12,3) fascia_fam
     , decode(mov.rapporto_par,'CC',1,'IC',1) tipo_fam
  from anaana ana
     , anamov mov
 where ana.matricola           = mov.matricola
   and nvl(mov.pratica,0)      = nvl(p_pratica,0)
   and nvl(mov.anno_pratica,0) = nvl(p_anno_pratica,0)
   and mov.cod_fam             = p_cod_fam
   and mov.data_eve            = p_data_eve
   and mov.data_reg            = p_data_reg
   and mov.cod_mov             = p_cod_mov
   and ((mov.cod_eve = p_cod_eve and a_servizio = '5001')
        or (mov.cod_eve = 92 and a_servizio = '5005'))
   and p_cod_mov               != 1
UNION
select
-- dati movimento
       mov.*
-- dati soggetto
     , decode(mov.cod_mov,10,1,12,3) fascia
     , decode(mov.cod_mov,12,'S',98,'S') soggettoAIRE
-- dati famiglia
     , decode(mov.cod_mov,10,1,12,3) fascia_fam
     , decode(mov.rapporto_par,'CC',1,'IC',1) tipo_fam
  from anaana ana
     , anamov mov
 where ana.matricola         = mov.matricola
   and nvl(f_ANPR_id_scheda(mov.matricola,'','','','','Famiglia ANPR'),0) =
         nvl(f_ANPR_id_scheda(p_matricola,'','','','','Famiglia ANPR'),0)
   and nvl(mov.pratica,0)      = nvl(p_pratica,0)
   and nvl(mov.anno_pratica,0) = nvl(p_anno_pratica,0)
   and mov.cod_fam           = p_cod_fam
   and mov.data_eve          = p_data_eve
   and mov.data_reg          = p_data_reg
   and mov.cod_mov           = p_cod_mov
   and p_cod_mov             = 1
   and a_servizio            in ('5001','5005')
UNION
select
-- dati movimento
       mov.*
-- dati soggetto
     , decode(mov.cod_mov,1,1,10,1,12,3) fascia
     , decode(mov.cod_mov,12,'S',98,'S') soggettoAIRE
-- dati famiglia
     , decode(mov.cod_mov,1,1,10,1,12,3) fascia_fam
     , decode(mov.rapporto_par,'CC',1,'IC',1) tipo_fam
  from anaana ana
     , anamov mov
 where ana.matricola           = mov.matricola
   and mov.anno_progr          = a_anno_rif
   and mov.numero_progr        = a_numero_rif
   and a_archivio_rif          = 'MOV_RP'
   and a_servizio              = '5001'
;

cursor sel_CF (p_cod_mov number,p_cod_fam number,p_data_eve number) is
select
-- dati evento
       ana.matricola
     , ana.cod_fam
     , ana.rapporto_par
     , ana.data_inizio_fam data_eve
-- dati soggetto
     , ana.cognome_nome
     , ana.cod_fiscale
     , ana.sesso
     , ana.data_nas
     , ana.anno_nas
     , ana.cod_pro_nas
     , ana.cod_com_nas
     , ana.fascia
     , decode(ana.fascia,3,'S') soggettoAIRE
-- dati famiglia
     , ana.fascia fascia_fam
     , to_number(null) tipo_fam
  from anaana ana
 where ana.data_inizio_fam <= p_data_eve
   and ana.rapporto_par    = 'CF'
   and ana.fascia          = decode(p_cod_mov,10,1,12,3)
   and ana.cod_fam         = p_cod_fam
UNION
select
-- dati evento
       eve.matricola
     , eve.cod_fam
     , eve.rapporto_par
     , eve.data_inizio data_eve
-- dati soggetto
     , ana.cognome_nome
     , ana.cod_fiscale
     , ana.sesso
     , ana.data_nas
     , ana.anno_nas
     , ana.cod_pro_nas
     , ana.cod_com_nas
     , decode(eve.cod_mov,10,1,12,3) fascia
     , decode(eve.cod_mov,12,'S') soggettoAIRE
-- dati famiglia
     , decode(eve.cod_mov,10,1,12,3) fascia_fam
     , to_number(null) tipo_fam
  from anaana ana
     , anaeve eve
 where ana.matricola     = eve.matricola
   and eve.rapporto_par    = 'CF'
   and eve.cod_mov       = p_cod_mov
   and eve.cod_fam       = p_cod_fam
   and p_data_eve          between eve.data_inizio and eve.data_eve
;

cursor sel_tmu is
select tipo_mutazione
  from anptmu
 where anno_rif              = a_anno_rif
   and numero_rif            = a_numero_rif
   and archivio_rif          = 'MOV'
   and a_archivio_rif        like 'MOV%'
UNION
select tipo_mutazione
  from anptmu_20
 where anno_rif              = a_anno_rif
   and numero_rif            = a_numero_rif
   and archivio_rif          = 'MOV'
   and a_archivio_rif        like 'MOV%'
UNION
select tipo_mutazione
  from anptmu_21
 where anno_rif              = a_anno_rif
   and numero_rif            = a_numero_rif
   and archivio_rif          = decode(a_archivio_rif,'AIR_M','AIR',a_archivio_rif)
   and a_archivio_rif        in ('APR','AIR','AIR_M')
 order by 1 desc
;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;
w_data_decorrenza_ws		number;

w_tipoIndirizzo			varchar2(255);
w_dataDecorrenzaResidenza	varchar2(255);

w_progr_componente		number;

w_cognome_prec 			varchar2(255);
w_nome_prec			varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_idSchedaSoggettoANPR_pd	varchar2(255);
w_idSchedaSoggettoANPR_md	varchar2(255);
w_idSchedaSoggettoANPR_cn	varchar2(255);

w_cognome_comp 			varchar2(255);
w_nome_comp 			varchar2(255);
w_idSchedaSoggettoANPR_comp	varchar2(255);
w_soggettoAIRE_comp		varchar2(255);

w_CF_trattato			number;

w_cognome_cn			varchar2(255);
w_nome_cn			varchar2(255);
w_soggettoAIRE_cn		varchar2(255);

w_cognome_nome_pd		varchar2(255);
w_cognome_pd			varchar2(255);
w_nome_pd			varchar2(255);
w_soggettoAIRE_pd		varchar2(255);

w_cognome_nome_md		varchar2(255);
w_cognome_md			varchar2(255);
w_nome_md			varchar2(255);
w_soggettoAIRE_md		varchar2(255);

w_data_atto_rif			number;

w_ordineUnione                  varchar2(255);
w_motivoScioglimento            varchar2(255);

w_data_div                      number;
w_data_atto_div                 number;
w_cod_pro_atto_div              number;
w_cod_com_atto_div              number;
w_anno_atto_div                 number;
w_ufficio_div                   number;
w_parte_div                     number;
w_serie_div                     varchar2(255);
w_atto_div                      number;

w_check_tmu		number;

w_senzaFissaDimora	varchar2(255);
w_tipoMutazione		varchar2(255);
w_tipoScheda		number;
w_gestioneCF		varchar2(255);

w_tipo_evento_proc              varchar2(255);

w_fam_coabitante	varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_mov';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno_progr '||a_anno_rif||' - numero_progr '||a_numero_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_mov loop
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'PD') is null then
         w_idSchedaSoggettoANPR_pd := f_ANPR_id_scheda(rec.matricola_pd,'','','','');
      end if;
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'MD') is null then
         w_idSchedaSoggettoANPR_md := f_ANPR_id_scheda(rec.matricola_md,'','','','');
      end if;
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'CN') is null then
         w_idSchedaSoggettoANPR_cn := f_ANPR_id_scheda(rec.matricola_cn,'','','','');
      end if;

      w_note_log := 'cod_mov '||rec.cod_mov||' - cod_eve '||rec.cod_eve||' - pratica '||rec.pratica||' - anno_pratica '||rec.anno_pratica;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log);

w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      if a_servizio = '5008' and rec.cod_mov = 1 then
         w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_reg);

      elsif a_servizio = '5001' and rec.cod_mov in (97,98) and rec.cod_eve = 98 then
         w_data_decorrenza  := nvl(rec.data_inizio_res,rec.data_inizio_fam);

      else
         if rec.pratica is not null then
            w_data_decorrenza  := nvl(w_data_decorrenza_ws,rec.data_eve);
         else
            w_data_decorrenza  := nvl(w_data_decorrenza_ws,rec.data_reg);
         end if;
      end if;

      w_data_definizione := rec.data_reg;

      if rec.pratica is not null then
         w_protocollo       := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,rec.anagrafe,rec.tipo_evento);
         w_data_protocollo  := f_ANPR_data_pratica(rec.anagrafe,rec.tipo_evento,rec.anno_pratica,rec.pratica);
      else
         w_protocollo       := '';
         w_data_protocollo  := rec.data_eve;
      end if;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione,rec.cod_mov,rec.cod_eve);

      if a_servizio = '5008' then
         begin
           select gestione_cf_anpr
             into w_gestioneCF
             from anpciu_agg
            where id_operazione = a_id_operazione
           ;
         exception
           when others then
                w_gestioneCF := '';
         end;
         goto datiGenerali;
      end if;

<< famigliaConvivenza >>
      if a_servizio = '5001' and rec.cod_mov = 1 then
         ANPR_pkg.upd_anpads_5001(w_servizio_log,rec.cod_mov,rec.cod_eve,rec.matricola,rec.cod_fam,rec.cod_fam_prec);
      end if;

-- 11/03/2019 - A.Monopoli
-- in presenza di rimpatrio da AIRE, forzo w_servizio_log con il valore 'IMAI' x pilotare il tipoScheda della famiglia,
-- che deve essere '5' - AIRE
      if a_servizio = '5001' and rec.cod_mov = 1 then
         if rec.cod_eve = 4 then
            w_servizio_log := 'IMAI';
         elsif rec.cod_eve != 1 and nvl(rec.cod_pro_eve,0) > 199 and rec.nazionalita = 'I' then
            w_servizio_log := 'IMAI';
         end if;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,'','','',a_id_operazione);
      if w_servizio_log = 'IMAI' then
         w_servizio_log := '5001';
      end if;

      if a_servizio = '5005' then
         if rec.cod_eve != 91 and rec.nucleo_arrivo = 1 and rec.rapporto_par = 'CF' then
            if rec.fascia = 1 then
               ANPR_pkg.ins_anpads(w_servizio_log,rec.matricola, '', rec.fascia, rec.tipo_fam, rec.cod_fam, 'Famiglia');
            elsif rec.fascia = 3 then
               ANPR_pkg.ins_anpads(w_servizio_log,rec.matricola, '', rec.fascia, rec.tipo_fam, rec.cod_fam, 'Famiglia AIRE');
            end if;
         end if;
      end if;

<< elencoSoggetti >>
      if rec.cod_mov != 1 then
         if rec.cod_eve not in (90,92) then
            goto residenzaFamConv;
         end if;
      end if;

      w_CF_trattato := 0;
      for rec_comp in sel_mov_comp (rec.cod_mov,rec.cod_eve,rec.cod_fam,rec.data_eve,rec.data_reg,rec.pratica,rec.anno_pratica,rec.matricola) loop
          if rec_comp.rapporto_par = 'CF' then
             w_CF_trattato := 1;
          end if;
          w_cognome_comp              := f_cognome(rec_comp.cognome_nome);
          w_nome_comp                 := f_nome(rec_comp.cognome_nome);
          w_idSchedaSoggettoANPR_comp := f_ANPR_id_scheda(rec_comp.matricola,'','','','');
          w_soggettoAIRE_comp         := rec_comp.soggettoAIRE;
w_xml_clob_sog := ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggettiFamiglia','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
--w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec_comp.cod_fiscale,rec_comp.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_comp,w_nome_comp,rec_comp.sesso,rec_comp.data_nas,rec_comp.anno_nas);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec_comp.cod_pro_nas,rec_comp.cod_com_nas,rec_comp.data_nas,'luogoNascita','N');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_comp,'soggettoAIRE','S');
          if w_idSchedaSoggettoANPR_comp is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec_comp.matricola);
          end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_comp,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_legame(w_servizio_log,rec_comp.tipo_fam,rec_comp.fascia,rec_comp.cod_fam,rec_comp.rapporto_par,rec_comp.sesso,rec_comp.data_eve,'','');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_autoveicoli(w_servizio_log,rec_comp.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggettiFamiglia','F');

w_xml_clob := w_xml_clob||w_xml_clob_sog;
      end loop;

      if a_servizio = '5001' and w_CF_trattato = 0 then
         for rec_CF in sel_CF (rec.cod_mov,rec.cod_fam,rec.data_eve) loop
--             ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'dentro rec_CF');
             w_cognome_comp              := f_cognome(rec_CF.cognome_nome);
             w_nome_comp                 := f_nome(rec_CF.cognome_nome);
             w_idSchedaSoggettoANPR_comp := f_ANPR_id_scheda(rec_CF.matricola,'','','','');
             w_soggettoAIRE_comp         := rec_CF.soggettoAIRE;
w_xml_clob_sog := ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggettiFamiglia','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec_CF.cod_fiscale,rec_CF.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_comp,w_nome_comp,rec_CF.sesso,rec_CF.data_nas,rec_CF.anno_nas);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec_CF.cod_pro_nas,rec_CF.cod_com_nas,rec_CF.data_nas,'luogoNascita','N');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_comp,'soggettoAIRE','S');
             if w_idSchedaSoggettoANPR_comp is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec_CF.matricola);
             end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_comp,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_legame(w_servizio_log,rec_CF.tipo_fam,rec_CF.fascia,rec_CF.cod_fam,rec_CF.rapporto_par,rec_CF.sesso,rec_CF.data_eve,'','');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_autoveicoli(w_servizio_log,rec_CF.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'elencoSoggettiFamiglia','F');

w_xml_clob := w_xml_clob||w_xml_clob_sog;
         end loop;
      end if;

<< residenzaFamConv >>
      if rec.nucleo_arrivo is null then
         goto datiDelProcedimento;
      end if;

      w_tipoIndirizzo           := f_ANPR_tipo_indirizzo(rec.soggettoAIRE,rec.presso);
      w_dataDecorrenzaResidenza := f_ANPR_data(nvl(rec.data_inizio_res,rec.data_inizio_fam));
--      if a_servizio = '5005' and rec.cod_mov = 10 and rec.cod_eve = 92 then
--         if rec.cod_via_prec||rec.num_civ_prec||rec.suffisso_prec||rec.interno_prec||rec.scala_prec||rec.piano_prec||rec.sub_interno_prec =
--              rec.cod_via||rec.num_civ||rec.suffisso||rec.interno||rec.scala||rec.piano||rec.sub_interno
--         then
--            w_dataDecorrenzaResidenza := '';
--         else
--            w_dataDecorrenzaResidenza := f_ANPR_data(nvl(rec.data_inizio_res,rec.data_inizio_fam));
--         end if;
--      end if;

      if a_servizio = '5001' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaFamigliaConvivenza','I');
      elsif a_servizio = '5005' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaFamiglia','I');
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoIndirizzo,'tipoIndirizzo');

      if w_tipoIndirizzo not in ('4','6') then
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_indirizzo(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_indirizzo_esteso(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano
                                                                        ,rec.flag_metrico,rec.progr_snc,rec.flag_lettera,rec.flag_esponente,rec.flag_nui,rec.nui,rec.colore
                                                                        ,rec.corte,rec.interno2,rec.sub_interno2,rec.secondario,rec.scala_esterna);
      elsif w_tipoIndirizzo in ('4','6') then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_localitaEstera(w_servizio_log,rec.via_aire,rec.zipcode,rec.cod_pro_aire,rec.cod_com_aire,rec.provincia_contea,'','','');
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.presso,'presso','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenzaResidenza,'dataDecorrenzaResidenza','S');
      if a_servizio = '5001' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaFamigliaConvivenza','F');
      elsif a_servizio = '5005' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'residenzaFamiglia','F');
      end if;

<< datiGenerali >>
      if a_servizio != '5008' then
         goto datiDelProcedimento;
      end if;

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      if rec.cod_mov = 1 then
         w_cognome_prec         := f_cognome(rec.cognome_nome);
         w_nome_prec            := f_nome(rec.cognome_nome);
      else
         if a_archivio_rif like 'AIR%' then
            w_cognome_prec         := substr(f_cognome(nvl(rec.cognome_nome_prec,rec.cognome_nome)),1,36);
            w_nome_prec            := substr(f_nome(nvl(rec.cognome_nome_prec,rec.cognome_nome)),1,36);
         else
            w_cognome_prec         := f_cognome(nvl(rec.cognome_nome_prec,rec.cognome_nome));
            w_nome_prec            := f_nome(nvl(rec.cognome_nome_prec,rec.cognome_nome));
         end if;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
-- 29/08/2019 (AM): evitato la stampa del codiceFiscale "per ricerca" nel caso di rettifica da nulla cf valorizzato
      if rec.cod_mov in (97,98) and rec.cod_eve = 99 and rec.cod_fiscale_prec is null and rec.cod_fiscale is not null then
         w_cod_fiscale_ws := f_ANPR_cod_fiscale_ws(a_id_operazione,'S','');
-- 03/11/2017 (AM): riattivato controllo sulla presenza del codice fiscale
      elsif rec.cod_fiscale is not null and nvl(w_gestioneCF,'0') != '1' then
         w_cod_fiscale_ws := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',nvl(rec.cod_fiscale_prec,rec.cod_fiscale));
      else
         w_cod_fiscale_ws := f_ANPR_cod_fiscale_ws(a_id_operazione,'S','');
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,nvl(rec.sesso_prec,rec.sesso),nvl(rec.data_nas_prec,rec.data_nas),nvl(rec.anno_nas_prec,rec.anno_nas));
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< generalitaDaModificare >>
      w_cognome              := f_cognome(rec.cognome_nome);
      w_nome                 := f_nome(rec.cognome_nome);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaDaModificare','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
      if nvl(w_gestioneCF,'0') != '1' then
         w_cod_fiscale_ws := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
      if w_idSchedaSoggettoANPR is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_attributiSoggetto(w_servizio_log,rec.matricola,rec.sospensione,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaDaModificare','F');

      if a_servizio = '5008' and a_archivio_rif = 'AIR_M' then
         goto matrimonio;
      end if;

<< statoCivile >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile,rec.sesso);

<< attoNascita>>
      w_data_atto_rif := f_ANPR_data_atto_rif(2,rec.cod_pro_atto_nas,rec.cod_com_atto_nas,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,rec.anno_atto_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_nas,rec.cod_com_atto_nas,w_data_atto_rif,rec.anno_atto_nas,rec.ufficio_nas,rec.parte_nas,rec.serie_nas,rec.atto_nas,'attoNascita',rec.atto_nas_digitale);

<< paternita >>
      if rec.paternita is null and rec.matricola_pd is null then
         goto maternita;
      elsif rec.cognome_nome_pd is not null then
         w_cognome_pd		:= f_cognome(rec.cognome_nome_pd);
         w_nome_pd		:= f_nome(rec.cognome_nome_pd);
      elsif rec.paternita is not null then
         w_cognome_pd 		:= f_cognome_pd('',rec.paternita,rec.cognome_nome);
         w_nome_pd 		:= f_nome_pd('',rec.paternita,rec.cognome_nome);
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'paternita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_pd,w_nome_pd,'','','');
        if w_idSchedaSoggettoANPR_pd is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_pd);
        end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_pd,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'paternita','F');

<< maternita >>
      if rec.maternita is null and rec.matricola_md is null then
         goto cittadinanza;
      else
         w_cognome_md		:= f_cognome(nvl(rec.cognome_nome_md,rec.maternita));
         w_nome_md		:= f_nome(nvl(rec.cognome_nome_md,rec.maternita));
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'maternita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_md,w_nome_md,'','','');
        if w_idSchedaSoggettoANPR_md is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_md);
        end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_md,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'maternita','F');

<< cittadinanza >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita,rec.data_inizio_naz);

<< matrimonio >>
      if (rec.cod_mov in (1,3) and rec.stato_civile in ('CN','VE','DV','GC'))
         or (rec.cod_mov in (97,98) and rec.stato_civile in ('CN'))
      then
         if rec.cognome_nome_cn is null and rec.matricola_cn is null and rec.data_mat is null then
            goto vedovanza;
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'matrimonio','I');
         if rec.cognome_nome_cn is null and rec.matricola_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaCognome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaNome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','F');
            goto datiMatrimonio;
         end if;
         w_cognome_cn		:= f_cognome(rec.cognome_nome_cn);
         w_nome_cn		:= f_nome(rec.cognome_nome_cn);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_cn,w_nome_cn,rec.sesso_cn,'','');
        if w_idSchedaSoggettoANPR_cn is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_cn);
        end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_cn,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','F');

<< datiMatrimonio >>
         if rec.cod_mov in (97,98) and rec.stato_civile not in ('CN','VE') then
            goto salta_ordineMatrimonio;
         elsif rec.data_mat is null then
            goto ordineMatrimonio;
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMatrimonio','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_mat,rec.anno_mat),'dataEvento','S');
         if nvl(rec.anno_mat,'N') = 'S' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','senzaGiornoMese');
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,'luogoEvento','N');
         if ltrim(rec.cod_pro_atto_mat||rec.cod_com_atto_mat,'0') is not null then
            w_data_atto_rif := f_ANPR_data_atto_rif(4,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,w_data_atto_rif,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoMatrimonio',rec.atto_mat_digitale);
         else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoMatrimonio',rec.atto_mat_digitale);
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMatrimonio','F');

<< ordineMatrimonio >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'','ordineMatrimonio','S');
<< salta_ordineMatrimonio >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'matrimonio','F');
      end if;

      if a_servizio = '5008' and a_archivio_rif = 'AIR_M' then
         goto datiDelProcedimento;
      end if;

<< vedovanza >>
--      if rec.stato_civile in ('VE') and
--         ((rec.cod_mov in (97,98) and rec.matricola_cn is null)
--          or rec.cod_mov not in (97,98))
--      then
      if rec.stato_civile in ('VE') then
         if rec.data_ved is null then
            goto divorzio;
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'vedovanza','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMorteconiuge','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_ved),'dataEvento');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,'luogoEvento','N');
         if ltrim(rec.cod_pro_atto_ved||rec.cod_com_atto_ved,'0') is not null then
           w_data_atto_rif := f_ANPR_data_atto_rif(5,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,w_data_atto_rif,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoMorteConiuge',rec.atto_ved_digitale);
         else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoMorteConiuge',rec.atto_ved_digitale);
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMorteconiuge','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'','ordineMatrimonioPrecedente','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'vedovanza','F');
      end if;

<< divorzio >>
      if rec.stato_civile in ('DV','GC','CE','NU') and nvl(rec.data_div,rec.data_div_ann) is not null then
         if rec.data_div is null and rec.data_div_ann is null then
            goto cartaIdentita;
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'separazioneAnnullamentoCessazioneMatrimonio','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_divorzio(w_servizio_log,rec.matricola,rec.data_div,rec.data_div_ann);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_div,rec.cod_com_atto_div,nvl(rec.data_div_ann,rec.data_div),rec.anno_atto_div,rec.ufficio_div,rec.parte_div,rec.serie_div,rec.atto_div,'attoAnnullamentoMatrimonio',rec.atto_div_digitale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'separazioneAnnullamentoCessazioneMatrimonio','F');

      elsif rec.stato_civile_prec in ('CN') and rec.stato_civile in ('CE','NU') then
         begin
           select sen.data_decreto
                , sen.data_atto_tr
                , sen.cod_pro_atto_tr
                , sen.cod_com_atto_tr
                , sen.anno_atto_tr
                , sen.ufficio_atto_tr
                , sen.parte_atto_tr
                , sen.serie_atto_tr
                , sen.atto_tr
             into w_data_div
                , w_data_atto_div
                , w_cod_pro_atto_div
                , w_cod_com_atto_div
                , w_anno_atto_div
                , w_ufficio_div
                , w_parte_div
                , w_serie_div
                , w_atto_div
             from anasen sen
            where anno_progr_mov   = rec.anno_progr
              and numero_progr_mov = rec.numero_progr
              and data_decreto     is not null
              and rownum           = 1
           ;
         exception
           when others then
                w_data_div         := '';
                w_data_atto_div    := '';
                w_cod_pro_atto_div := '';
                w_cod_com_atto_div := '';
                w_anno_atto_div    := '';
                w_ufficio_div      := '';
                w_parte_div        := '';
                w_serie_div        := '';
                w_atto_div         := '';
         end;

         if w_data_div is null then
            goto cartaIdentita;
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'separazioneAnnullamentoCessazioneMatrimonio','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_divorzio(w_servizio_log,rec.matricola,w_data_div,'');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,w_cod_pro_atto_div,w_cod_com_atto_div,w_data_atto_div,w_anno_atto_div,w_ufficio_div,w_parte_div,w_serie_div,w_atto_div,'attoAnnullamentoMatrimonio',rec.atto_div_digitale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'separazioneAnnullamentoCessazioneMatrimonio','F');
      end if;

<< unioneCivile >>
      if rec.stato_civile in ('UC','VU','GU') then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'unioneCivile','I');
         if rec.cod_mov in (97,98) and rec.stato_civile in ('VU','GU') then
            goto scioglimentoUnione;
         end if;
         if rec.cognome_nome_cn is null and rec.matricola_cn is null and rec.data_mat is null then
            goto scioglimentoUnione;
         end if;
         if rec.cognome_nome_cn is null and rec.matricola_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaCognome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaNome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','F');
            goto attoUnione;
         end if;
         w_cognome_cn		:= f_cognome(rec.cognome_nome_cn);
         w_nome_cn		:= f_nome(rec.cognome_nome_cn);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_cn,w_nome_cn,rec.sesso_cn,'','');
        if w_idSchedaSoggettoANPR_cn is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_cn);
        end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_cn,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','F');

<< attoUnione >>
         if rec.data_mat is null then
            goto scioglimentoUnione;
         end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'attoUnione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_mat,rec.anno_mat),'dataEvento','S');
         if nvl(rec.anno_mat,'N') = 'S' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','senzaGiornoMese');
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,'luogoEvento','N');
         if ltrim(rec.cod_pro_atto_mat||rec.cod_com_atto_mat,'0') is not null then
            w_data_atto_rif := f_ANPR_data_atto_rif(4,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,w_data_atto_rif,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoUnione',rec.atto_mat_digitale);
         else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoUnione',rec.atto_mat_digitale);
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'attoUnione','F');

<< scioglimentoUnione >>
         if rec.stato_civile in ('VU','GU') then
            if rec.stato_civile = 'VU' and rec.data_ved is not null then
               w_motivoScioglimento := '98';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoScioglimento,'motivoScioglimento');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_ved),'dataEvento');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,'luogoEvento','N');
               if ltrim(rec.cod_pro_atto_ved||rec.cod_com_atto_ved,'0') is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,'',rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoScioglimentoUnione',rec.atto_ved_digitale);
               else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoScioglimentoUnione',rec.atto_ved_digitale);
               end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','F');

            elsif rec.stato_civile = 'GU' and nvl(rec.data_div,rec.data_div_ann) is not null then
               w_motivoScioglimento := '1';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoScioglimento,'motivoScioglimento');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_divorzio(w_servizio_log,rec.matricola,rec.data_div,rec.data_div_ann,rec.stato_civile);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(nvl(rec.data_div,rec.data_div_ann)),'dataEvento');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_div,rec.cod_com_div,rec.data_div,'luogoEvento','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_div,rec.cod_com_atto_div,rec.data_div,rec.anno_atto_div,rec.ufficio_div,rec.parte_div,rec.serie_div,rec.atto_div,'attoScioglimentoUnione',rec.atto_div_digitale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','F');

            end if;
         end if;

<< cittadinanzaUnione >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_cn,rec.data_inizio_naz_cn);

<< ordineUnione >>
         w_ordineUnione := '';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_ordineUnione,'ordineUnione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'unioneCivile','F');
      end if;

<< cartaIdentita >>
null;
      if rec.cod_mov in (1,3) then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_cartaIdentita(w_servizio_log,rec.matricola);
      end if;

<< permessoSoggiorno >>
null;
      if rec.cod_mov = 1 then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_permessoSoggiorno(w_servizio_log,rec.matricola);
      end if;

<< liste >>
null;
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'liste','I');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_listaLeva(w_servizio_log,rec.matricola);
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_listaElettorale(w_servizio_log,rec.matricola);
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'liste','F');

<< censimento >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_censimento(w_servizio_log,rec.anno_cens,rec.sezione_cens,rec.foglio_cens,rec.questionario_cens,w_data_decorrenza);

<< altriDati >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof,rec.sesso,rec.posizione_prof,rec.titolo_studio);

<< autoveicoli >>
null;
      if rec.cod_mov in (1,3) then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_autoveicoli(w_servizio_log,rec.matricola);
      end if;

<< datiDelProcedimento >>
      w_tipo_evento_proc := f_ANPR_tipo_evento_ciu(rec.cod_mov,rec.cod_eve,'S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_datiDelProcedimento(w_servizio_log,rec.pratica,rec.anno_pratica,rec.data_reg,rec.anagrafe,w_tipo_evento_proc);

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      if a_servizio = '5001' then
-- tipoMutazione
-- Valori ammessi:
-- 1=Tutore/Responsabile Convivenza
-- 2=composizione scheda
-- 3=motivo famiglia/specie convivenza
-- 4=residenza scheda
-- 5=Residenza scheda con patente e autoveicoli - 29/05/2024 (AM)
-- 6=Ripristino residenza ante subentro - 29/05/2024 (AM)
-- 7=Revisione onomastica stradale e dei numeri civici - 29/05/2024 (AM)
-- 8=Rettifica indirizzo post accertamento - 29/05/2024 (AM)
-- 9=Rettifica/Integrazione indirizzo - 29/05/2024 (AM)

         if rec.cod_mov in (10,11) and nvl(rec.cod_variazione,' ') = 'X' then
            w_tipoMutazione := '6';
         elsif rec.cod_mov in (10,12) then
            w_tipoMutazione := '2';
         elsif rec.cod_mov in (1,11,13) then
--            w_tipoMutazione := '4';
            w_tipoMutazione := '5';
         elsif rec.cod_mov in (97,98) then
            w_tipoMutazione := '9';
         end if;
-- tipoScheda
-- Valori ammessi:
-- 1= scheda famiglia
-- 2= scheda convivenza
         if rec.tipo_fam is null then
            w_tipoScheda := 1;
         elsif rec.tipo_fam = 1 then
            w_tipoScheda := 2;
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda','S');

      elsif a_servizio = '5005' then
         w_senzaFissaDimora := f_senza_fissa_dimora(rec.cod_via,rec.num_civ,rec.suffisso,rec.interno);
-- tipoMutazione
-- Valori ammessi:
-- 1=Senza fissa dimora
-- 2=residenza
-- 3=dimora abituale
-- 4=domicilio eletto
         if rec.cod_mov in (10,11) and nvl(rec.cod_variazione,' ') = 'X' then
            w_tipoMutazione := '06';
         elsif nvl(w_senzaFissaDimora,'N') = 'S' then
            w_tipoMutazione := '01';
         else
            w_tipoMutazione := '02';
         end if;
-- tipoScheda
-- Valori ammessi:
-- 1=famiglia/convivenza esistente
-- 2=nuova famiglia
         if rec.cod_eve = 91 or rec.nucleo_arrivo is null then
            w_tipoScheda := 1;
         elsif rec.nucleo_arrivo = 1 then
            if rec.rapporto_par = 'CF' then
               w_tipoScheda := 2;
            else
               w_tipoScheda := 1;
            end if;
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda','S');

      elsif a_servizio = '5008' then
         w_check_tmu := 0;

         for rec_tmu in sel_tmu loop
             w_check_tmu := 1;
             w_tipoMutazione := lpad(rec_tmu.tipo_mutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
         end loop;

         if w_check_tmu = 0 then
--            if rec.cod_mov = 1 then
--               w_tipoMutazione := '20';
--            else
--               w_tipoMutazione := '01';
--            end if;
               w_tipoMutazione := '01';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
         end if;

         if w_tipoMutazione = '01' and (rec.cod_fiscale is null or rec.cf_calcolato ='S') then
            w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,rec.cod_fiscale,rec.cf_calcolato);
         elsif rec.cod_mov = 1 then
            w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'','');
         else
            w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'XXXXXX99X99X999X','');
         end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
      end if;

<< listaControlli >>
      if a_servizio = '5005' and rec.cod_mov = 10 and rec.cod_eve = 92 then
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaControlli',
--                        'old: '||rec.cod_via_prec||rec.num_civ_prec||rec.suffisso_prec||rec.interno_prec||rec.scala_prec||rec.piano_prec||rec.sub_interno_prec||
--                        ' - new: '||rec.cod_via||rec.num_civ||rec.suffisso||rec.interno||rec.scala||rec.piano||rec.sub_interno);
         if rec.cod_via_prec||rec.num_civ_prec||rec.suffisso_prec||rec.interno_prec||rec.scala_prec||rec.piano_prec||rec.sub_interno_prec =
              rec.cod_via||rec.num_civ||rec.suffisso||rec.interno||rec.scala||rec.piano||rec.sub_interno
         then
            w_fam_coabitante := '';
            w_fam_coabitante := f_ANPR_fam_coabitante(rec.fascia,rec.cod_fam);
            if nvl(w_fam_coabitante,'N') = 'N' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'FO','codice');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'S','valore');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','F');
            end if;
         end if;

      elsif a_servizio = '5001' then
         if (rec.cod_mov in (10,12) and rec.cod_eve = 90) or a_archivio_rif = 'MOV_RP' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'FC','codice');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'S','valore');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','F');
         end if;

      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_MOV;

function ws_5000_mutazione_DOC
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_id_anadoc		number
,a_archivio_rif		varchar2
,a_cod_cdf		number
)

return clob

is

cursor sel_doc is
select
-- dati anagrafe
       ana.*
-- dati soggetto
     , decode(ana.fascia,3,'S',4,'S') soggettoAIRE
-- dati documento
     , doc.data_reg data_reg_doc
  from anaana ana
     , anadoc doc
 where ana.matricola               = doc.matricola
   and doc.id                      = a_id_anadoc
;

cursor sel_tmu is
select tipo_mutazione
  from anptmu
 where archivio_rif          = a_archivio_rif
 order by 1
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);
w_idSchedaSoggettoANPR  varchar2(255);

w_tipoMutazione		varchar2(255);
w_gestioneCF		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_doc';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'id_anadoc '||a_id_anadoc||' a_archivio_rif '||a_archivio_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_doc loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_reg_doc);
      w_data_definizione   := rec.data_reg_doc;
      w_protocollo         := '';
      w_data_protocollo    := rec.data_reg_doc;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< cartaIdentita >>
      if a_archivio_rif != 'DOC_DI' then
         goto permessoSoggiorno;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_cartaIdentita(w_servizio_log,rec.matricola,a_id_anadoc);

<< permessoSoggiorno >>
      if a_archivio_rif != 'DOC_DS' then
         goto autoveicoli;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_permessoSoggiorno(w_servizio_log,rec.matricola,a_id_anadoc);

<< autoveicoli >>
      if a_archivio_rif != 'DOC_PT_CC' then
         goto convivenzaDiFatto;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_autoveicoli(w_servizio_log,rec.matricola);

<< convivenzaDiFatto >>
      if a_archivio_rif != 'DOC_CDF' then
         goto datiControllo;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_convivenzaDiFatto(w_servizio_log,rec.matricola,a_cod_cdf,'','CDF_I');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      for rec_tmu in sel_tmu loop
          w_tipoMutazione := lpad(rec_tmu.tipo_mutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end loop;

      if a_archivio_rif != 'DOC_CDF' then
         w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'XXXXXX99X99X999X','');
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_DOC;

function ws_5000_mutazione_MSI
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_id_anamsi		number
)

return clob

is

cursor sel_msi is
select
-- dati anagrafe
       ana.*
-- dati soggetto
     , decode(ana.fascia,3,'S',4,'S') soggettoAIRE
-- dati movimento
     , msi.sospensione sospensione_msi
     , msi.data_reg data_reg_msi
  from anaana ana
     , anamsi msi
 where ana.matricola = msi.matricola
   and msi.id        = a_id_anamsi
   and rownum = 1
;

cursor sel_tmu is
select tipo_mutazione
  from anptmu
 where archivio_rif          = 'MSI'
 order by 1
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoMutazione		varchar2(255);
w_gestioneCF		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_msi';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'id_anadoc '||a_id_anamsi);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_msi loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_reg_msi);
      w_data_definizione   := rec.data_reg_msi;
      w_protocollo         := '';
      w_data_protocollo    := rec.data_reg_msi;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< generalitaDaModificare >>
      w_cognome              := f_cognome(rec.cognome_nome);
      w_nome                 := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaDaModificare','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
      if w_idSchedaSoggettoANPR is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_attributiSoggetto(w_servizio_log,rec.matricola,rec.sospensione_msi,'','','','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaDaModificare','F');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      for rec_tmu in sel_tmu loop
          w_tipoMutazione := lpad(rec_tmu.tipo_mutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end loop;

      w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'XXXXXX99X99X999X','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_MSI;

function ws_5000_mutazione_SFD
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
)

return clob

is

cursor sel_sfd is
select
-- dati anagrafe
       ana.*
-- dati soggetto
     , decode(ana.fascia,3,'S',4,'S') soggettoAIRE
-- dati movimento
     , mov.cod_via
     , mov.num_civ
     , mov.suffisso
     , mov.interno
     , mov.data_reg data_reg_mov
  from anaana ana
     , anamov mov
 where ana.matricola    = mov.matricola
   and mov.anno_progr   = a_anno_rif
   and mov.numero_progr = a_numero_rif
   and rownum = 1
;

cursor sel_tmu is
select tipo_mutazione
  from anptmu
 where archivio_rif = 'SFD'
   and anno_rif     = a_anno_rif
   and numero_rif   = a_numero_rif
 order by 1
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoMutazione		varchar2(255);
w_gestioneCF		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_sfd';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno_progr '||a_anno_rif||' - numero_progr '||a_numero_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_sfd loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_reg_mov);
      w_data_definizione   := rec.data_reg_mov;
      w_protocollo         := '';
      w_data_protocollo    := rec.data_reg_mov;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< generalitaDaModificare >>
      w_cognome              := f_cognome(rec.cognome_nome);
      w_nome                 := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaDaModificare','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
      if w_idSchedaSoggettoANPR is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_attributiSoggetto(w_servizio_log,rec.matricola,'-1',rec.cod_via,rec.num_civ,rec.suffisso,rec.interno);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaDaModificare','F');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      for rec_tmu in sel_tmu loop
          w_tipoMutazione := lpad(rec_tmu.tipo_mutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end loop;

      w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'XXXXXX99X99X999X','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_SFD;

function ws_5000_mutazione_CDF
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_matricola		number
,a_cod_fam		number
,a_archivio_rif         varchar2
)

return clob

is

cursor sel_cdf is
select
-- dati anagrafe
       ana.*
-- dati soggetto
     , to_char(null) soggettoAIRE
-- dati cdf
     , cdf.cod_cdf  cod_cdf
     , cdf.data_reg data_reg_cdf
     , cdf.data_inizio data_inizio_cdf
     , cdf.data_fine data_fine_cdf
  from anacdf cdf
     , anaana ana
 where cdf.cod_cdf   = a_cod_fam
   and cdf.matricola = ana.matricola
   and ana.matricola = a_matricola
;

cursor sel_tmu is
select tipo_mutazione
  from anptmu
 where archivio_rif          = a_archivio_rif
 order by 1
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoMutazione		varchar2(255);
w_gestioneCF		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_cdf';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'matricola '||a_matricola||' - cod_cdf '||a_cod_fam);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_cdf loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      if a_archivio_rif = 'CDF_I' then
         w_data_decorrenza    := nvl(w_data_decorrenza_ws,nvl(rec.data_inizio_cdf,rec.data_reg_cdf));
      elsif a_archivio_rif = 'CDF_F' then
         w_data_decorrenza    := nvl(w_data_decorrenza_ws,nvl(rec.data_fine_cdf,rec.data_reg_cdf));
      else
         w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_reg_cdf);
      end if;
      w_data_definizione   := rec.data_reg_cdf;
      w_protocollo         := '';
      w_data_protocollo    := rec.data_reg_cdf;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< convivenzaDiFatto >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_convivenzaDiFatto(w_servizio_log,rec.matricola,rec.cod_cdf,'',a_archivio_rif);

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      for rec_tmu in sel_tmu loop
          w_tipoMutazione := lpad(rec_tmu.tipo_mutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end loop;

      w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'XXXXXX99X99X999X','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_CDF;

function ws_5000_mutazione_ELE
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_matricola		number
,a_archivio_rif         varchar2
,a_anno_rif		number
,a_numero_rif		number
)

return clob

is

cursor sel_ele is
select
-- dati anagrafe
       ana.*
-- dati elettorale
     , decode(ele.sezione,'',
         decode(ele.stato,'S',f_sezione_ele(ele.cod_via_ele,ele.num_civ_ele,ele.suffisso_ele)),
         ele.sezione) sezione_ele
     , ele.stato stato_ele
     , ele.motivo motivo_ele
-- dati dsr
     , dsr.revisione
     , dsr.straordinaria
     , dsr.data_verbale
     , dsr.data_revisione
-- dati e32/e33
     , e32.des_ripartizione circ_estero_senato
     , e33.des_ripartizione circ_estero_camera
  from anpe32 e32
     , anpe33 e33
     , eledsr dsr
     , eleana ele
     , anaana ana
 where e32.codice          (+) = ele.cod_pro_aire_ele
   and e33.codice          (+) = ele.cod_pro_aire_ele
   and dsr.anno            (+) = ele.anno
   and dsr.revisione       (+) = ele.revisione
   and dsr.progr_revisione (+) = ele.progr_revisione
   and ele.matricola       = ana.matricola
   and ana.matricola       = a_matricola
   and (a_archivio_rif like 'ELE%' or a_archivio_rif = 'PSE')
UNION
select
-- dati anagrafe
       ana.*
-- dati elettorale
     , to_char(ela.sezione) sezione_ele
     , ela.stato stato_ele
     , ela.motivo motivo_ele
-- dati dsr
     , dsr.revisione
     , dsr.straordinaria
     , dsr.data_verbale
     , dsr.data_revisione
-- dati e32/e33
     , to_char(null)
     , to_char(null)
  from eledsr dsr
     , eleela ela
     , anaana ana
 where dsr.anno            (+) = ela.anno
   and dsr.revisione       (+) = ela.revisione
   and dsr.progr_revisione (+) = ela.progr_revisione
   and ela.matricola       = ana.matricola
   and ana.matricola       = a_matricola
   and ((a_archivio_rif like 'ELA%' and ela.tipo_lista = substr(a_archivio_rif,5,1))
        or a_archivio_rif = 'PSE')
;

cursor sel_tmu is
select tipo_mutazione
  from anptmu
 where archivio_rif          = a_archivio_rif
 order by 1
;

cursor sel_sez (w_sezione_par number) is
select dse.sezione,
       dlr.descrizione luogo_riunione, dlr.indirizzo,
-- 1 - parlamento europeo
       dco_1.collegio collegio_1, dco_1.descrizione des_collegio_1,
       f_ANPR_circoscrizione_ele(1) circoscrizione_anpr_1,
-- 2 - senato della repubblica
       dco_2.collegio collegio_2, dco_2.descrizione des_collegio_2,
       f_ANPR_circoscrizione_ele(2) circoscrizione_anpr_2,
       f_ANPR_collegio_ele(2) collegio_anpr_2,
-- 3 - camera dei deputati
       dco_3.collegio collegio_3, dco_3.descrizione des_collegio_3,
       f_ANPR_circoscrizione_ele(3) circoscrizione_anpr_3,
       f_ANPR_collegio_ele(3) collegio_anpr_3,
-- 4 - regionali
       dco_4.collegio collegio_4, dco_4.descrizione des_collegio_4,
       f_ANPR_circoscrizione_ele(4) circoscrizione_anpr_4,
-- 5 - provinciali
       dco_5.collegio collegio_5, dco_5.descrizione des_collegio_5,
-- 6 - circoscrizionali
       dco_6.collegio collegio_6, dco_6.descrizione des_collegio_6,
       nvl(dse.data_ult_agg,to_char(sysdate,'j')) data_ult_agg,
       2100+dse.luogo_riunione /*to_number(null)*/ cod_via,
       dse.luogo_riunione      /*to_number(null)*/ num_civ,
       to_char(null) suffisso,
       to_number(null) interno,
       to_char(null) sub_interno,
       to_char(null) scala,
       to_char(null) piano
  from eledte dte_6, eledco dco_6, eledsc dsc_6,
       eledte dte_5, eledco dco_5, eledsc dsc_5,
       eledte dte_4, eledco dco_4, eledsc dsc_4,
       eledte dte_3, eledco dco_3, eledsc dsc_3,
       eledte dte_2, eledco dco_2, eledsc dsc_2,
       eledte dte_1, eledco dco_1, eledsc dsc_1,
       eledlr dlr, eledse dse
 where dco_6.tipo_elezione   = dsc_6.tipo_elezione
   and dco_6.collegio= dsc_6.collegio
   and dsc_6.tipo_elezione   = dte_6.cod_te
   and dsc_6.sezione = dse.sezione
   and dte_6.rif_tessera_ele = 6
   and dco_5.tipo_elezione   = dsc_5.tipo_elezione
   and dco_5.collegio= dsc_5.collegio
   and dsc_5.tipo_elezione   = dte_5.cod_te
   and dsc_5.sezione = dse.sezione
   and dte_5.rif_tessera_ele = 5
   and dco_4.tipo_elezione   = dsc_4.tipo_elezione
   and dco_4.collegio= dsc_4.collegio
   and dsc_4.tipo_elezione   = dte_4.cod_te
   and dsc_4.sezione = dse.sezione
   and dte_4.rif_tessera_ele = 4
   and dco_3.tipo_elezione   = dsc_3.tipo_elezione
   and dco_3.collegio= dsc_3.collegio
   and dsc_3.tipo_elezione   = dte_3.cod_te
   and dsc_3.sezione = dse.sezione
   and dte_3.rif_tessera_ele = 3
   and dco_2.tipo_elezione   = dsc_2.tipo_elezione
   and dco_2.collegio= dsc_2.collegio
   and dsc_2.tipo_elezione   = dte_2.cod_te
   and dsc_2.sezione = dse.sezione
   and dte_2.rif_tessera_ele = 2
   and dco_1.tipo_elezione   = dsc_1.tipo_elezione
   and dco_1.collegio= dsc_1.collegio
   and dsc_1.tipo_elezione   = dte_1.cod_te
   and dsc_1.sezione = dse.sezione
   and dte_1.rif_tessera_ele = 1
   and dlr.cod_lr    = dse.luogo_riunione
   and dse.sezione   = w_sezione_par
   and rownum = 1
;

w_archivio_rif		varchar2(255) := substr(a_archivio_rif,1,5);

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_matricola_prec	number;
w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 		varchar2(255);
w_nome 			varchar2(255);
w_idSchedaSoggettoANPR	varchar2(255);
w_soggettoAIRE		varchar2(255);

w_elettore			varchar2(255);
w_elettore_O			varchar2(255);
w_elettore_C			varchar2(255);
w_elettore_E			varchar2(255);
w_elettore_B			varchar2(255);
w_elettore_T			varchar2(255);
w_elettore_V			varchar2(255);

w_soggettoCertificabile		varchar2(255);
w_motivoCancellazione		varchar2(255);
w_noteCancellazione		varchar2(255);
w_tipoConsultazione 		varchar2(255);
w_dataCancellazioneLista 	varchar2(255);
w_tipoRevisione			varchar2(255);

w_tipoMutazione		varchar2(255);

w_gestioneCF		varchar2(255);
w_cod_fiscale_ws 	varchar2(255);

w_sezione		number;
w_luogo_riunione	varchar2(255);
w_indirizzo		varchar2(255);
w_des_luogo_riunione	varchar2(255);
w_des_collegio_1	varchar2(255);
w_des_collegio_2	varchar2(255);
w_des_collegio_3	varchar2(255);
w_des_collegio_4	varchar2(255);
w_des_collegio_5	varchar2(255);
w_des_collegio_6	varchar2(255);

w_referendumNazionali		varchar2(255) := 'N';
w_elezioniMembriUe		varchar2(255) := 'N';
w_senatoRepubblica		varchar2(255) := 'N';
w_circoscrSenatoRepubblica	varchar2(255);
w_cameraDeputati		varchar2(255) := 'N';
w_circoscrCameraDeputati	varchar2(255);
w_regionali			varchar2(255) := 'N';
w_comunali			varchar2(255) := 'N';
w_circoscrizionali		varchar2(255) := 'N';

w_ctr_elezioni			number;
w_data_elezioni_j		number;
w_data_elezioni			varchar2(255);
w_codice_anpr_dce		number;
cursor sel_dce (w_matricola number) is
select dce.data_elezioni, dce.codice_anpr
  from eledce dce, eleana_save1 s1
 where dce.anno_elezioni  = s1.anno_elezioni
   and dce.progr_elezioni = s1.progr_elezioni
   and s1.stato           = 'E'
   and s1.matricola       = w_matricola
UNION
select dce.data_elezioni, dce.codice_anpr
  from eledce dce, eleana_save2 s2
 where dce.anno_elezioni  = s2.anno_elezioni
   and dce.progr_elezioni = s2.progr_elezioni
   and s2.stato           = 'E'
   and s2.matricola       = w_matricola
order by 1 desc
;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_ele';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'matricola '||a_matricola||' - archivio_rif '||a_archivio_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  if a_servizio = '5008' then
     goto mutazioneElettore;
  elsif a_servizio = '5010' then
     goto mutazioneLista;
  elsif a_servizio = '5011' then
     goto mutazioneSezione;
  end if;

  goto fine;

<< mutazioneLista >>
  w_matricola_prec := 0;
  for rec in sel_ele loop
--ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'matricola: '||rec.matricola||' - motivo: '||rec.motivo_ele);
      if rec.matricola = w_matricola_prec then
         goto fine_loop;
      end if;

w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,nvl(rec.data_verbale,rec.data_revisione));
      w_data_definizione   := nvl(rec.data_verbale,rec.data_revisione);
      w_protocollo         := '';
      w_data_protocollo    := nvl(rec.data_verbale,rec.data_revisione);

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

w_step := 0.10;
      w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSoggetto');

w_step := 0.11;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'liste','I');
--      w_elettore                := f_ANPR_elettorale(a_matricola,'ELETTORE','ELE');
      if a_archivio_rif like '%_ANN'then
w_step := 0.12;
         w_elettore := 'N';
      elsif a_archivio_rif = 'PSE' then
w_step := 0.13;
         w_elettore   := f_ANPR_elettorale(a_matricola,'ELETTORE','');
         w_elettore_O := f_ANPR_elettorale(a_matricola,'ELETTORE','ELE');
         w_elettore_C := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_C');
         w_elettore_E := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_E');
         w_elettore_B := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_B');
         w_elettore_T := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_T');
         w_elettore_V := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_V');
      else
w_step := 0.14;
         w_elettore := f_ANPR_elettorale(a_matricola,'ELETTORE','');--w_archivio_rif);
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore,'elettore');

      w_referendumNazionali		:= 'N';
      w_elezioniMembriUe		:= 'N';
      w_senatoRepubblica		:= 'N';
      w_cameraDeputati			:= 'N';
      w_regionali			:= 'N';
      w_comunali			:= 'N';
      w_circoscrizionali		:= 'N';
      w_circoscrSenatoRepubblica        := '';
      w_circoscrCameraDeputati          := '';

w_step := 0.15;
      if (w_archivio_rif like 'ELE%') or (a_archivio_rif = 'PSE' and w_elettore_O = 'S') then
         if rec.sezione_ele is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaGenerale','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.sezione_ele,'sezioneelettoralenum','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaGenerale','F');
         end if;
         if w_elettore = 'S' then
            w_referendumNazionali		:= 'S';
            w_elezioniMembriUe		:= 'S';
            w_senatoRepubblica		:= 'S';
            w_cameraDeputati		:= 'S';
            w_regionali			:= 'S';
            w_comunali			:= 'S';
            w_circoscrizionali		:= w_flag_circoscrizionali;
         end if;
      end if;

w_step := 0.16;
      if w_archivio_rif in ('ELA_C','ELA_E')  or (a_archivio_rif = 'PSE' and w_elettore_C||w_elettore_E like '%S%') then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUE','I');

            w_elettore_C                   := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_C');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_C,'ueelettorecomunali');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUEComunali','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.sezione_ele,'sezioneelettoralenum');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUEComunali','F');

            w_elettore_E                   := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_E');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_E,'ueelettoreparlamento');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUEParlamento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.sezione_ele,'sezioneelettoralenum');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUEParlamento','F');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUE','F');

         if w_elettore_E = 'S' then
            w_elezioniMembriUe		:= 'S';
         end if;

         if w_elettore_C = 'S' then
            w_comunali			:= 'S';
            w_circoscrizionali		:= w_flag_circoscrizionali;
         end if;

      end if;

w_step := 0.17;
      if w_archivio_rif in ('ELA_B','ELA_T','ELA_V') or (a_archivio_rif = 'PSE' and w_elettore_B||w_elettore_T||w_elettore_V like '%S%') then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaComReg','I');
         if w_archivio_rif = 'ELA_B' or (a_archivio_rif = 'PSE' and w_elettore_B = 'S') then
            w_elettore_B                := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_B');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_B,'comregelettorebolzano');
            w_regionali			:= 'S';
            w_comunali			:= 'S';
            w_circoscrizionali		:= w_flag_circoscrizionali;
         end if;

w_step := 0.18;
         if w_archivio_rif = 'ELA_T' or (a_archivio_rif = 'PSE' and w_elettore_T = 'S') then
            w_elettore_T                := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_T');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_T,'comregelettoretrento');
            w_regionali			:= 'S';
         end if;

w_step := 0.19;
         if w_archivio_rif = 'ELA_V' or (a_archivio_rif = 'PSE' and w_elettore_V = 'S') then
            w_elettore_V                := f_ANPR_elettorale(a_matricola,'ELETTORE','ELA_V');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_V,'comregelettorevalledaosta');
            w_regionali			:= 'S';
         end if;

w_step := 0.20;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaBolTreVal','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.sezione_ele,'sezioneelettoralenum');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaBolTreVal','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaComReg','F');
      end if;

w_step := 0.21;
      if w_senatoRepubblica||w_cameraDeputati != 'NN' then
         if rec.circ_estero_senato||rec.circ_estero_camera is not null then
            w_circoscrSenatoRepubblica := nvl(rec.circ_estero_senato,'-');
            w_circoscrCameraDeputati   := nvl(rec.circ_estero_camera,'-');
         else
            for rec_sez in sel_sez (rec.sezione_ele) loop
                w_circoscrSenatoRepubblica	:= nvl(rec_sez.circoscrizione_anpr_2,rec_sez.des_collegio_2);
                w_circoscrCameraDeputati	:= nvl(rec_sez.circoscrizione_anpr_3,rec_sez.des_collegio_3);
            end loop;
            w_circoscrSenatoRepubblica := nvl(w_circoscrSenatoRepubblica,'-');
            w_circoscrCameraDeputati   := nvl(w_circoscrCameraDeputati,'-');
         end if;
      end if;

w_step := 0.22;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_referendumNazionali,'referendumnazionali');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elezioniMembriUe,'elezionimembriue');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_senatoRepubblica,'senatorepubblica');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_circoscrSenatoRepubblica,'circoscrsenatorepubblica','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cameraDeputati,'cameradeputati');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_circoscrCameraDeputati,'circoscrcameradeputati','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_regionali,'regionali');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_comunali,'comunali');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_circoscrizionali,'circoscrizionali');


w_step := 0.23;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'liste','F');

--
-- soggettoCertificabile
-- 0=non certificabile
-- 1=certificabilita parziale
-- 2=certificabilita completa
--
-- tipoMutazione
-- 01=lista generale
-- 02=lista aggiunta ue
-- 03=lista aggiunta comunale regionale
-- 04=certificabilita
-- 05=cancellazione
      if a_archivio_rif like '%_ANN' then
w_step := 0.24;
         w_soggettoCertificabile := 0;
         w_tipoMutazione         := '05';
      elsif w_archivio_rif like 'PSE%' then
w_step := 0.25;
         w_soggettoCertificabile := a_numero_rif;
         w_tipoMutazione         := '01';
      elsif w_archivio_rif like 'ELE%' then
w_step := 0.26;
         if w_elettore = 'S' then
            w_soggettoCertificabile := 2;
         else
            w_soggettoCertificabile := 0;
         end if;
         if rec.stato_ele = 'E' then
            w_tipoMutazione         := '01';
         else
            if a_archivio_rif like '%_CAR' then
               w_tipoMutazione         := '01';
            else
               w_tipoMutazione         := '05';
            end if;
         end if;

      elsif w_archivio_rif in ('ELA_C','ELA_E') then
w_step := 0.27;
         w_soggettoCertificabile := 2;
         if rec.stato_ele = 'E' then
            w_tipoMutazione         := '02';
         else
            w_tipoMutazione         := '05';
         end if;
      elsif w_archivio_rif in ('ELA_B','ELA_T','ELA_V') then
         w_soggettoCertificabile := 2;
         if rec.stato_ele = 'E' then
            w_tipoMutazione         := '03';
         else
            w_tipoMutazione         := '05';
         end if;
      end if;

ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'a_matricola: '||a_matricola||' - stato_ele: '||rec.stato_ele||' - a_archivio_rif: '||a_archivio_rif);
      if rec.stato_ele in ('C','S') or a_archivio_rif like '%_ANN' then
w_step := 0.28;
         w_motivoCancellazione    := f_ANPR_elettorale(a_matricola,'MOTIVO',a_archivio_rif);
         w_noteCancellazione      := f_ANPR_elettorale(a_matricola,'NOTE',a_archivio_rif);
         if a_archivio_rif like '%_ANN' then
            w_tipoConsultazione      := '';
            w_dataCancellazioneLista := '';
         else
            begin
              select 1 into w_ctr_elezioni
                from eledce
               where data_elezioni > nvl(rec.data_verbale,rec.data_revisione)
                 and rownum = 1
              ;
            exception
              when others then
                   w_ctr_elezioni := 0;
            end;
--ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'data_verbale: '||rec.data_verbale||' - w_ctr_elezioni: '||w_ctr_elezioni);
w_step := 0.29;
            if w_ctr_elezioni = 1 then
               w_data_elezioni_j := '';
               open sel_dce (rec.matricola);
               fetch sel_dce into w_data_elezioni_j,w_codice_anpr_dce;
               close sel_dce;
               if w_data_elezioni_j is not null then
                  w_tipoConsultazione      := w_codice_anpr_dce;
                  w_dataCancellazioneLista := f_ANPR_data(w_data_elezioni_j);
               else
                  w_tipoConsultazione      := '';
                  w_dataCancellazioneLista := '';
               end if;
            end if;
          end if;
w_step := 0.30;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'certificabilita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoCertificabile,'soggettoCertificabile');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'certificabilita','F');

w_step := 0.31;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'cancellazione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoCancellazione,'motivoCancellazione');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_noteCancellazione,'noteCancellazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoConsultazione,'tipoConsultazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataCancellazioneLista,'dataCancellazioneLista','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'cancellazione','F');

      else
w_step := 0.32;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'certificabilita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoCertificabile,'soggettoCertificabile');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'certificabilita','F');
      end if;

-- PRIMOCARICAMENTO|SEMESTRALE|DINAMICA|STRAORDINARIA
w_step := 0.33;
      if a_archivio_rif like '%_CAR' then
         w_tipoRevisione := 'PRIMOCARICAMENTO';
      elsif a_archivio_rif = 'PSE' then
         w_tipoRevisione := 'ALTRA';
      elsif rec.revisione is not null and rec.revisione = 'SE' then
         w_tipoRevisione := 'SEMESTRALE';
      elsif rec.revisione is not null and rec.straordinaria is null then
         w_tipoRevisione := 'DINAMICA';
      elsif rec.revisione is not null and rec.straordinaria is not null then
         w_tipoRevisione := 'STRAORDINARIA';
      else
         w_tipoRevisione := 'ALTRA';
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoRevisione,'tipoRevisione');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');

w_step := 0.34;
      if a_archivio_rif != 'PSE' then
         w_tipoMutazione := lpad(w_tipoMutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end if;

      if w_tipoMutazione = '05' and w_elettore = 'N' and w_archivio_rif not like 'ELA%' then
         w_tipoMutazione := '01';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end if;

      if w_tipoMutazione = '05' and w_archivio_rif in ('ELA_C','ELA_E') and w_elettore_C||w_elettore_E like '%S%' then
         w_tipoMutazione := '02';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end if;

w_step := 0.35;
      if w_archivio_rif = 'PSE' then
         w_tipoMutazione := '04';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

<< fine_loop >>
      w_matricola_prec := rec.matricola;
  end loop;

  goto fine;

<< mutazioneSezione >>
  for rec in sel_sez (a_numero_rif) loop
      w_sezione        := rec.sezione;
      w_luogo_riunione := f_ANPR_stringa(rec.luogo_riunione);
      w_indirizzo      := f_ANPR_stringa(rec.indirizzo);
      w_des_collegio_1 := nvl(rec.circoscrizione_anpr_1,rec.des_collegio_1);
      w_des_collegio_2 := nvl(rec.collegio_anpr_2,rec.des_collegio_2);
      w_des_collegio_3 := nvl(rec.collegio_anpr_3,rec.des_collegio_3);
      w_des_collegio_4 := nvl(rec.circoscrizione_anpr_4,rec.des_collegio_4);
      w_des_collegio_5 := f_ANPR_stringa(rec.des_collegio_5);
      w_des_collegio_6 := f_ANPR_stringa(rec.des_collegio_6);

      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_ult_agg); --to_char(sysdate,'j');
      w_data_definizione   := rec.data_ult_agg; --to_char(sysdate,'j');
      w_protocollo         := '';
      w_data_protocollo    := rec.data_ult_agg; --to_char(sysdate,'j');

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comune','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_com_cliente,'nomeComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'codiceIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_sigla_pro_cliente,'siglaProvinciaIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comune','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_sezione,'sezioneelettoralenum','S');
       goto indirizzo_stringa;
--       goto indirizzo_strutturato;

<< indirizzo_stringa >>
--       w_des_luogo_riunione := w_luogo_riunione||' - '||w_indirizzo;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_luogo_riunione,'sezioneelettoraledenom','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezioneelettoraleind','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cap_cliente,'cap','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comune','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_com_cliente,'nomeComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'codiceIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_sigla_pro_cliente,'siglaProvinciaIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comune','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_specie_area(w_indirizzo),'specie');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'2','specieFonte');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_toponimo(w_indirizzo),'denominazioneToponimo');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'2','toponimoFonte');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'','numeroCivico','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezioneelettoraleind','F');
       goto collegi;

<< indirizzo_strutturato >>
       w_des_luogo_riunione := w_luogo_riunione; 
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_luogo_riunione,'sezioneelettoraledenom','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_indirizzo(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano,'sezioneelettoraleind');

<< collegi >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_1,'circoscrelezionimembriue','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_3,'collegiocameradeputati','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_4,'circoscrregionali','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_6,'circosrizioneelezcircosc','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_2,'collegiosenatorepubblica','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezione','F');
  end loop;

  goto fine;

<< mutazioneElettore >>
  for rec in sel_ele loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,nvl(rec.data_verbale,rec.data_revisione));
      w_data_definizione   := nvl(rec.data_verbale,rec.data_revisione);
      w_protocollo         := '';
      w_data_protocollo    := nvl(rec.data_verbale,rec.data_revisione);

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< liste >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'liste','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_listaElettorale(w_servizio_log,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'liste','F');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      for rec_tmu in sel_tmu loop
-- tipo_mutazione 5 - liste elettorali 
          w_tipoMutazione := lpad(rec_tmu.tipo_mutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end loop;

      w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'XXXXXX99X99X999X','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);
  end loop;

<< fine >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_ELE;

function ws_5000_mutazione_LEV
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_matricola		number
,a_archivio_rif         varchar2
)

return clob

is

cursor sel_lev is
select
-- dati anagrafe
       ana.*
  from levruo ruo
     , anaana ana
 where ruo.matricola       = ana.matricola
   and ana.matricola       = a_matricola
;

cursor sel_tmu is
select tipo_mutazione
  from anptmu
 where archivio_rif          = a_archivio_rif
 order by 1
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoMutazione		varchar2(255);
w_gestioneCF		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_lev';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'matricola '||a_matricola);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_lev loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,to_char(sysdate,'j'));
      w_data_definizione   := to_char(sysdate,'j');
      w_protocollo         := '';
      w_data_protocollo    := to_char(sysdate,'j');

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< liste >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'liste','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_listaLeva(w_servizio_log,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'liste','F');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      for rec_tmu in sel_tmu loop
          w_tipoMutazione := lpad(rec_tmu.tipo_mutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end loop;

      w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'XXXXXX99X99X999X','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_LEV;

function ws_5000_mutazione_SUB
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_matricola		number
,a_archivio_rif         varchar2
,a_anno_rif             number
,a_numero_rif           number
)

return clob

is

cursor sel_lev is
select
-- dati anagrafe
       ana.*
-- dati evento
     , eve.cod_mov
     , eve.cod_eve
     , eve.cod_variazione
     , eve.cod_pro_eve
     , eve.cod_com_eve
     , eve.data_eve
  from anaeve eve
     , anaana ana
 where eve.matricola (+)   = ana.matricola
   and eve.cod_mov   (+)   = ana.fascia
   and eve.cod_eve   (+)   = ana.stato
   and eve.data_eve  (+)   = ana.data_ult_eve
   and ana.matricola       = a_matricola
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_cod_mov               number;
w_cod_eve               number;
w_cod_variazione        varchar2(255);
w_cod_pro_eve           number;
w_cod_com_eve           number;
w_data_eve              number;

w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoMutazione		varchar2(255);
w_gestioneCF		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_SUB';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'matricola '||a_matricola);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_lev loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_inizio_res);
      w_data_definizione   := to_char(sysdate,'j');
      w_protocollo         := '';
      w_data_protocollo    := to_char(sysdate,'j');

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< tipoRettifica >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tipoRettifica','I');

      if a_archivio_rif = 'SUB_R' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica101','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(w_data_decorrenza),'dataDecorrenzaResidenza');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica101','F');

      elsif a_archivio_rif = 'SUB_F' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica103','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(w_data_decorrenza),'dataIngressoFamiglia');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica103','F');

      elsif a_archivio_rif = 'SUB_U' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica103','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(w_data_decorrenza),'dataUltimoAggiornamentoAPR');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica103','F');

      elsif a_archivio_rif in ('SUB_I','SUB_P') then
         if a_anno_rif is not null and a_numero_rif is not null then
            begin
              select mov.cod_mov
                   , mov.cod_eve
                   , mov.cod_variazione
                   , mov.cod_pro_eve
                   , mov.cod_com_eve
                   , mov.data_eve
                into w_cod_mov
                   , w_cod_eve
                   , w_cod_variazione
                   , w_cod_pro_eve
                   , w_cod_com_eve
                   , w_data_eve
                from anamov mov
               where mov.anno_progr = a_anno_rif
                 and mov.numero_progr = a_numero_rif
              ;
            exception
              when others then
                   w_cod_mov        := rec.cod_mov;
                   w_cod_eve        := rec.cod_eve;
                   w_cod_variazione := rec.cod_variazione;
                   w_cod_pro_eve    := rec.cod_pro_eve;
                   w_cod_com_eve    := rec.cod_com_eve;
                   w_data_eve       := rec.data_eve;
            end;
         end if;
         if a_archivio_rif = 'SUB_I' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica102','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_motivoIscrizione(w_servizio_log,w_cod_mov,w_cod_eve,w_cod_variazione,w_cod_pro_eve);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_eve,w_cod_com_eve,'','provenienza','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica102','F');
         elsif a_archivio_rif = 'SUB_P' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica103','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(w_data_eve),'dataPrimaIscrizioneComune');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'richiestaRettifica103','F');
         end if;
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tipoRettifica','F');

<< datiControllo >>
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_SUB;

function ws_5000_mutazione_ARI
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_matricola		number
,a_archivio_rif         varchar2
)

return clob

is

cursor sel_ari is
select
-- dati anagrafe
       ana.*
-- recapito individuo
     , ari.indirizzo_rec
     , ari.data_reg data_reg_ARI
  from anadtr dtr
     , anaari ari
     , anaana ana
 where dtr.tipo_comunicazione   = 'E'
   and dtr.cod_tr               = ari.tipo_recapito
   and upper(ari.indirizzo_rec) like '%@%PEC%'
   and ari.matricola            = ana.matricola
   and ana.matricola            = a_matricola
   and rownum = 1
;

cursor sel_tmu is
select tipo_mutazione
  from anptmu
 where archivio_rif          = a_archivio_rif
 order by 1
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_indirizzoDigitale		varchar2(255);
w_dataInizioValidita		varchar2(255);
w_enteErogatore			varchar2(255);

w_tipoMutazione		varchar2(255);
w_gestioneCF		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5000_mutazione_ari';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'matricola '||a_matricola);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_ari loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,nvl(rec.data_reg_ARI,to_char(sysdate,'j')));
      w_data_definizione   := nvl(rec.data_reg_ARI,to_char(sysdate,'j'));
      w_protocollo         := '';
      w_data_protocollo    := nvl(rec.data_reg_ARI,to_char(sysdate,'j'));

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');

<< domicilioDigitale>>
      w_indirizzoDigitale  := rec.indirizzo_rec;
      w_dataInizioValidita := f_ANPR_data(w_data_decorrenza);
      w_enteErogatore      := '';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'domicilioDigitale','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_indirizzoDigitale,'indirizzoDigitale','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataInizioValidita,'dataInizioValidita','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_enteErogatore,'enteErogatore','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'domicilioDigitale','F');

<< datiControllo >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
      for rec_tmu in sel_tmu loop
          w_tipoMutazione := lpad(rec_tmu.tipo_mutazione,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMutazione,'tipoMutazione','S');
      end loop;

      w_gestioneCF := f_ANPR_gestioneCF(a_id_operazione,w_servizio_log,'XXXXXX99X99X999X','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_gestioneCF,'gestioneCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5000_mutazione_ARI;

function ws_5013_revoca
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
,a_id_anadoc		number
,a_id_anamsi		number
,a_matricola		number
,a_cod_fam		number
,a_archivio_rif		varchar2
)

return clob

is

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5013_revoca';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  if a_archivio_rif like ('MOV%') then
     w_xml_clob := ANPR_pkg.ws_5013_revoca_MOV(a_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif);
  elsif a_archivio_rif like ('DOC%') then
     w_xml_clob := ANPR_pkg.ws_5013_revoca_DOC(a_servizio,a_id_operazione,a_tipo_operazione,a_archivio_rif,a_id_anadoc);
  end if;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5013_revoca;

function ws_5013_revoca_MOV
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif             number
,a_numero_rif           number
)

return clob

is

cursor sel_mov is
select
-- dati movimento
       mov.*
  from anaana ana
     , anamov mov
 where ana.matricola               = mov.matricola
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
;

cursor sel_tre is
select tipo_revoca, motivo_revoca, note_revoca
  from anptre
 where archivio_rif = 'MOV'
   and anno_rif     = a_anno_rif
   and numero_rif   = a_numero_rif
 order by 1
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;


w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoRevoca		varchar2(255);
w_motivoRevoca		varchar2(255);
w_noteRevoca		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5013_revoca_MOV';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'matricola '||a_matricola);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_mov loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,nvl(rec.data_eve,rec.data_reg));
      w_data_definizione   := rec.data_reg;
      w_protocollo         := '';
      w_data_protocollo    := rec.data_reg;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'schedaSoggetto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'schedaSoggetto','F');

      for rec_tre in sel_tre loop
<< motivoAnnullamento >>
          w_motivoRevoca := rec_tre.motivo_revoca;
          w_noteRevoca   := rec_tre.note_revoca;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'motivoAnnullamento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoRevoca,'motivoRevoca','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_noteRevoca,'noteRevoca','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'motivoAnnullamento','F');

<< datiControllo >>
          w_tipoRevoca := lpad(rec_tre.tipo_revoca,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoRevoca,'tipoRevoca','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');
        end loop;

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5013_revoca_MOV;

function ws_5013_revoca_DOC
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_archivio_rif 	varchar2
,a_id_anadoc            number
)

return clob

is

cursor sel_doc is
select ana.cognome_nome
     , ana.cod_fiscale
     , ana.sesso
     , ana.data_nas
     , ana.anno_nas
-- dati documento
     , doc.*
  from anaana ana
     , anadoc doc
 where ana.matricola = doc.matricola
   and doc.id        = a_id_anadoc
;

cursor sel_tre is
select tipo_revoca, motivo_revoca, note_revoca
  from anptre
 where archivio_rif = a_archivio_rif
 order by 1
;

w_protocollo		varchar2(255);
w_data_protocollo	number;
w_data_decorrenza	number;
w_data_definizione	number;
w_data_decorrenza_ws	number;

w_cognome_prec 		varchar2(255);
w_nome_prec		varchar2(255);

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoRevoca		varchar2(255);
w_motivoRevoca		varchar2(255);
w_noteRevoca		varchar2(255);

w_cod_fiscale_ws	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5013_revoca_DOC';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'matricola '||a_matricola);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_doc loop
w_step := 0.1;
      w_data_decorrenza_ws := f_ANPR_data_decorrenza_ws(a_id_operazione);
      w_data_decorrenza    := nvl(w_data_decorrenza_ws,rec.data_reg);
      w_data_definizione   := rec.data_reg;
      w_protocollo         := '';
      w_data_protocollo    := rec.data_reg;

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio_log,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

<< generalitaPerRicerca >>
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_cognome_prec         := f_cognome(rec.cognome_nome);
      w_nome_prec            := f_nome(rec.cognome_nome);
      w_cod_fiscale_ws       := f_ANPR_cod_fiscale_ws(a_id_operazione,'S',rec.cod_fiscale);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'schedaSoggetto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_prec,w_nome_prec,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaPerRicerca','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'schedaSoggetto','F');

      for rec_tre in sel_tre loop
<< motivoAnnullamento >>
          w_motivoRevoca := rec_tre.motivo_revoca;
          w_noteRevoca   := rec_tre.note_revoca;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'motivoAnnullamento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoRevoca,'motivoRevoca','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_noteRevoca,'noteRevoca','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'motivoAnnullamento','F');

<< datiControllo >>
          w_tipoRevoca := lpad(rec_tre.tipo_revoca,2,'0');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoRevoca,'tipoRevoca','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');
        end loop;

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob);

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5013_revoca_DOC;

function ws_1013_ann_iscrizione
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
)

return clob

is

cursor sel_mov is
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.cod_mov
     , mov.cod_eve
     , mov.cod_variazione
     , mov.pratica
     , mov.anno_pratica
     , mov.matricola
     , mov.cognome_nome
     , mov.sesso
     , mov.data_nas
     , mov.anno_nas
     , mov.cod_pro_nas
     , mov.cod_com_nas
     , mov.cod_fiscale
     , mov.cf_calcolato
     , mov.data_reg
-- dati soggetto
     , mov.cod_mov fascia
     , mov.cod_eve stato
     , decode(mov.cod_mov,3,'S') soggettoAIRE
-- dati comunicazione
     , rif.servizio_rif servizio_rif
     , rif.id_operazione_rif id_operazione_rif
     , rif.id_operazione_anpr_rif id_operazione_anpr_rif
  from anpciu_rif rif
     , anadce dce
     , anamov mov
 where rif.id_operazione           = a_id_operazione
   and dce.anagrafe                in ('RES','AIR')
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
UNION
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.cod_mov
     , mov.cod_eve
     , mov.cod_variazione
     , mov.pratica
     , mov.anno_pratica
     , mov.matricola
     , mov.cognome_nome
     , mov.sesso
     , mov.data_nas
     , mov.anno_nas
     , mov.cod_pro_nas
     , mov.cod_com_nas
     , mov.cod_fiscale
     , mov.cf_calcolato
     , mov.data_reg
-- dati soggetto
     , mov.cod_mov fascia
     , mov.cod_eve stato
     , decode(mov.cod_mov,3,'S') soggettoAIRE
-- dati comunicazione
     , rif.servizio_rif servizio_rif
     , rif.id_operazione_rif id_operazione_rif
     , rif.id_operazione_anpr_rif id_operazione_anpr_rif
  from anpciu_rif rif
     , anadce dce
     , anamov_elev mov
 where rif.id_operazione           = a_id_operazione
   and dce.anagrafe                in ('AIR','RES')
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;

w_operazione             	varchar2(255);
w_id_operazione_comune		varchar2(255);
w_id_operazione_anpr		varchar2(255);

w_progr_componente		number;

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoScheda			varchar2(255);
w_annullamentoAttribuzioneCF	varchar2(255);

w_cod_fiscale_ws		varchar2(255);

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '1013_ann_iscrizione';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno_progr '||a_anno_rif||' - numero_progr '||a_numero_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario1000iscrizione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/1000iscrizione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_mov loop
      w_note_log := 'cod_mov '||rec.cod_mov||' - cod_eve '||rec.cod_eve||' - matricola '||rec.matricola||' - pratica '||rec.pratica||' - anno_pratica '||rec.anno_pratica;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log);

w_step := 1;
      w_protocollo       := '';
      w_data_protocollo  := '';
      w_data_decorrenza  := to_char(sysdate,'j');
      w_data_definizione := to_char(sysdate,'j');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

w_step := 2;
      w_operazione           := rec.servizio_rif;
      w_id_operazione_comune := rec.id_operazione_rif;
      w_protocollo           := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,rec.anagrafe,rec.tipo_evento); 
      w_data_protocollo      := f_ANPR_data_pratica(rec.anagrafe,rec.tipo_evento,rec.anno_pratica,rec.pratica);
      w_id_operazione_anpr   := rec.id_operazione_anpr_rif;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_datiOperazione(w_operazione,w_id_operazione_comune,w_protocollo,w_data_protocollo,w_id_operazione_anpr);

w_step := 3;
      w_cognome                 := f_cognome(rec.cognome_nome);
      w_nome                    := f_nome(rec.cognome_nome);
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR    := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_soggettoAIRE            := rec.soggettoAIRE;

w_step := 4;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
      w_cod_fiscale_ws          := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSchedaSoggettoFamigliaConvivenza','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_step := 5;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_step := 6;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSchedaSoggettoFamigliaConvivenza','F');

<< datiDelProcedimento >>
null;

<< datiControllo >>
      w_tipoScheda                 := '1';
      w_annullamentoAttribuzioneCF := 'N';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tiposcheda','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_annullamentoAttribuzioneCF,'annullamentoAttribuzione','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob_sog);
w_xml_clob := w_xml_clob||w_xml_clob_sog;

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_1013_ann_iscrizione;

function ws_2011_ann_cancellazione
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
)

return clob

is

cursor sel_mov is
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.cod_mov
     , mov.cod_eve
     , mov.cod_variazione
     , mov.pratica
     , mov.anno_pratica
     , mov.matricola
     , mov.cognome_nome
     , mov.sesso
     , mov.data_nas
     , mov.anno_nas
     , mov.cod_pro_nas
     , mov.cod_com_nas
     , mov.cod_fiscale
     , mov.cf_calcolato
     , mov.data_reg
-- dati soggetto
     , mov.cod_mov fascia
     , mov.cod_eve stato
     , decode(mov.cod_mov,3,'S',4,'S') soggettoAIRE
-- dati comunicazione
     , rif.servizio_rif servizio_rif
     , rif.id_operazione_rif id_operazione_rif
     , rif.id_operazione_anpr_rif id_operazione_anpr_rif
  from anpciu_rif rif
     , anadce dce
     , anamov mov
 where rif.id_operazione           = a_id_operazione
   and dce.anagrafe                = decode(mov.cod_mov,1,'RES',2,'RES',4,'AIR')
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
UNION
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.cod_mov
     , mov.cod_eve
     , mov.cod_variazione
     , mov.pratica
     , mov.anno_pratica
     , mov.matricola
     , mov.cognome_nome
     , mov.sesso
     , mov.data_nas
     , mov.anno_nas
     , mov.cod_pro_nas
     , mov.cod_com_nas
     , mov.cod_fiscale
     , mov.cf_calcolato
     , mov.data_reg
-- dati soggetto
     , mov.cod_mov fascia
     , mov.cod_eve stato
     , decode(mov.cod_mov,3,'S',4,'S') soggettoAIRE
-- dati comunicazione
     , rif.servizio_rif servizio_rif
     , rif.id_operazione_rif id_operazione_rif
     , rif.id_operazione_anpr_rif id_operazione_anpr_rif
  from anpciu_rif rif
     , anadce dce
     , anamov_elev mov
 where rif.id_operazione           = a_id_operazione
   and dce.anagrafe                = decode(mov.cod_mov,2,'RES',4,'AIR')
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;

w_operazione             	varchar2(255);
w_id_operazione_comune		varchar2(255);
w_id_operazione_anpr		varchar2(255);

w_progr_componente		number;

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoScheda			varchar2(255);

w_cod_fiscale_ws		varchar2(255);

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '2011_ann_cancellazione';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno_progr '||a_anno_rif||' - numero_progr '||a_numero_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario2000cancellazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/2000cancellazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel_mov loop
      w_note_log := 'cod_mov '||rec.cod_mov||' - cod_eve '||rec.cod_eve||' - matricola '||rec.matricola||' - pratica '||rec.pratica||' - anno_pratica '||rec.anno_pratica;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log);

w_step := 1;
      w_protocollo       := '';
      w_data_protocollo  := '';
      w_data_decorrenza  := to_char(sysdate,'j');
      w_data_definizione := to_char(sysdate,'j');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

w_step := 2;
      w_operazione           := rec.servizio_rif;
      w_id_operazione_comune := rec.id_operazione_rif;
      w_protocollo           := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,rec.anagrafe,rec.tipo_evento);
      w_data_protocollo      := f_ANPR_data_pratica(rec.anagrafe,rec.tipo_evento,rec.anno_pratica,rec.pratica);
      w_id_operazione_anpr   := rec.id_operazione_anpr_rif;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_datiOperazione(w_operazione,w_id_operazione_comune,w_protocollo,w_data_protocollo,w_id_operazione_anpr);

w_step := 3;
      w_cognome                 := f_cognome(rec.cognome_nome);
      w_nome                    := f_nome(rec.cognome_nome);
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR    := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_soggettoAIRE            := rec.soggettoAIRE;

w_step := 4;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
      w_cod_fiscale_ws          := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSchedaSoggettoFamigliaConvivenza','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_step := 5;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_step := 6;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSchedaSoggettoFamigliaConvivenza','F');

<< datiDelProcedimento >>
--w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_datiDelProcedimento(w_servizio_log,rec.pratica,rec.anno_pratica,rec.data_reg);
null;

<< datiControllo >>
      w_tipoScheda               := '1';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda','S');

      if a_servizio = '2011' and rec.cod_mov = 1 and rec.cod_eve = 18 then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'RA','codice');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','valore');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','F');
      end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob_sog);
w_xml_clob := w_xml_clob||w_xml_clob_sog;

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_2011_ann_cancellazione;

function ws_5012_ann_mutazione
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
,a_id_anadoc		number
,a_id_anamsi		number
,a_matricola		number
,a_fascia_fam           number
,a_cod_fam		number
,a_archivio_rif		varchar2
)

return clob

is

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5012_ann_mutazione';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  if a_archivio_rif like 'VIE%' then
     w_xml_clob := ANPR_pkg.ws_5012_ann_mutazione_FAM(a_servizio,a_id_operazione,a_tipo_operazione,a_fascia_fam,a_cod_fam,a_archivio_rif);
  elsif a_archivio_rif = 'FAM' and a_matricola is null then
     w_xml_clob := ANPR_pkg.ws_5012_ann_mutazione_FAM(a_servizio,a_id_operazione,a_tipo_operazione,a_fascia_fam,a_cod_fam,a_archivio_rif);
  elsif a_archivio_rif like 'E%_ANN' then
     w_xml_clob := ANPR_pkg.ws_5000_mutazione_ELE(a_servizio,a_id_operazione,a_tipo_operazione,a_matricola,a_archivio_rif,a_anno_rif,a_numero_rif);
  else
     w_xml_clob := ANPR_pkg.ws_5012_ann_mutazione_MOV(a_servizio,a_id_operazione,a_tipo_operazione,a_anno_rif,a_numero_rif,a_id_anadoc,a_id_anamsi,a_matricola,a_archivio_rif);
  end if;

  return w_xml_clob;

end ws_5012_ann_mutazione;

function ws_5012_ann_mutazione_MOV
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
,a_id_anadoc		number
,a_id_anamsi		number
,a_matricola		number
,a_archivio_rif		varchar2
)

return clob

is

cursor sel is
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.cod_mov
     , mov.cod_eve
     , mov.cod_variazione
     , mov.pratica
     , mov.anno_pratica
     , mov.matricola
     , mov.cognome_nome
     , mov.sesso
     , mov.data_nas
     , mov.anno_nas
     , mov.cod_pro_nas
     , mov.cod_com_nas
     , mov.cod_fiscale
     , mov.cf_calcolato
     , mov.data_reg
-- dati soggetto
     , mov.cod_mov fascia
     , mov.cod_eve stato
     , decode(mov.cod_mov,3,'S') soggettoAIRE
  from anadce dce
     , anamov mov
 where ((dce.tipo_evento != 'R' and dce.cod_mov in (10,12))
        or (dce.cod_mov not in (10,12)))
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
   and a_archivio_rif              like 'MOV%'
UNION
select dce.anagrafe
     , dce.tipo_evento
-- dati movimento
     , mov.cod_mov
     , mov.cod_eve
     , to_char(null)
     , mov.pratica
     , mov.anno_pratica
     , mov.matricola
     , mov.cognome_nome
     , mov.sesso
     , mov.data_nas
     , mov.anno_nas
     , mov.cod_pro_nas
     , mov.cod_com_nas
     , mov.cod_fiscale
     , mov.cf_calcolato
     , mov.data_reg
-- dati soggetto
     , mov.cod_mov fascia
     , mov.cod_eve stato
     , decode(mov.cod_mov,3,'S') soggettoAIRE
  from anadce dce
     , anamov_elev mov
 where ((dce.tipo_evento != 'R' and dce.cod_mov in (10,12))
        or (dce.cod_mov not in (10,12)))
   and dce.cod_mov                 = mov.cod_mov
   and dce.cod_eve                 = mov.cod_eve
   and nvl(dce.cod_variazione,' ') = nvl(mov.cod_variazione,' ')
   and mov.anno_progr              = a_anno_rif
   and mov.numero_progr            = a_numero_rif
   and a_archivio_rif              like 'MOV%'
UNION
select to_char(null)
     , to_char(null)
-- dati movimento
     , to_number(null)
     , to_number(null)
     , to_char(null)
     , to_number(null)
     , to_number(null)
     , ana.matricola
     , ana.cognome_nome
     , ana.sesso
     , ana.data_nas
     , ana.anno_nas
     , ana.cod_pro_nas
     , ana.cod_com_nas
     , ana.cod_fiscale
     , ana.cf_calcolato
     , ana.data_reg
-- dati soggetto
     , ana.fascia fascia
     , ana.stato stato
     , decode(ana.fascia,3,'S') soggettoAIRE
  from anaana ana
 where ana.matricola               = a_matricola
   and a_archivio_rif              not like 'MOV%'
   and a_archivio_rif              not like 'FAM%'
   and a_archivio_rif              not like 'VIE%'
;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;
w_servizio_rif             	varchar2(255);
w_id_operazione_rif		number;
w_id_operazione_anpr_rif	number;

w_data_decorrenza_ws		number;

w_progr_componente		number;

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoScheda			varchar2(255);
w_annullamentoAttribuzioneCF	varchar2(255);

w_cod_fiscale_ws		varchar2(255);

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5012_ann_mutazione_MOV';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno_progr '||a_anno_rif||' - numero_progr '||a_numero_rif);

w_step := 0;
--w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

  for rec in sel loop
--      w_note_log := 'cod_mov '||rec.cod_mov||' - cod_eve '||rec.cod_eve||' - matricola '||rec.matricola||' - pratica '||rec.pratica||' - anno_pratica '||rec.anno_pratica;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log);

w_step := 1;
      w_data_decorrenza_ws      := f_ANPR_data_decorrenza_ws(a_id_operazione);

      w_protocollo       := '';
      w_data_protocollo  := '';
      w_data_decorrenza  := nvl(w_data_decorrenza_ws,to_char(sysdate,'j'));
      w_data_definizione := to_char(sysdate,'j');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

w_step := 2;
      begin
        select rif.servizio_rif, rif.id_operazione_rif, rif.id_operazione_anpr_rif
          into w_servizio_rif, w_id_operazione_rif, w_id_operazione_anpr_rif
          from anpciu_rif rif
         where rif.id_operazione = a_id_operazione
        ;
      exception
        when others then
             w_servizio_rif           := '';
             w_id_operazione_rif      := '';
             w_id_operazione_anpr_rif := '';
      end;

      if rec.pratica is not null then
         w_protocollo           := f_ANPR_protocollo(rec.pratica,rec.anno_pratica,rec.anagrafe,rec.tipo_evento);
         w_data_protocollo      := f_ANPR_data_pratica(rec.anagrafe,rec.tipo_evento,rec.anno_pratica,rec.pratica);
      else
         w_protocollo           := null;
         w_data_protocollo      := null;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_datiOperazione(w_servizio_rif,w_id_operazione_rif,w_protocollo,w_data_protocollo,w_id_operazione_anpr_rif);

w_step := 3;
      w_cognome                 := f_cognome(rec.cognome_nome);
      w_nome                    := f_nome(rec.cognome_nome);
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR    := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_soggettoAIRE            := rec.soggettoAIRE;

w_step := 4;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
      w_cod_fiscale_ws          := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSchedaSoggettoFamigliaConvivenza','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_step := 5;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_step := 6;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSchedaSoggettoFamigliaConvivenza','F');

<< datiDelProcedimento >>
--w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_datiDelProcedimento(w_servizio_log,rec.pratica,rec.anno_pratica,rec.data_reg);
null;

<< datiControllo >>
      w_tipoScheda                 := '1';
      w_annullamentoAttribuzioneCF := 'S';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_annullamentoAttribuzioneCF,'annullamentoAttribuzioneCF','S');

      if a_servizio = '5012' then
         if (rec.cod_mov in (10,11) and rec.cod_variazione = 'X') or
            (rec.cod_mov = 2 and rec.cod_eve = 62)
         then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'RA','codice');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','valore');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'controllo','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaControlli','F');
         end if;
      end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');

<< fine >>
null;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_note_log, w_xml_clob_sog);
w_xml_clob := w_xml_clob||w_xml_clob_sog;

  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5012_ann_mutazione_MOV;

function ws_5012_ann_mutazione_FAM
(a_servizio		varchar2
,a_id_operazione	number
,a_tipo_operazione 	varchar2
,a_fascia_fam		number
,a_cod_fam		number
,a_archivio_rif		varchar2
)

return clob

is

cursor sel is
select 
-- dati soggetto
       ana.matricola
     , ana.cognome_nome
     , ana.sesso
     , ana.data_nas
     , ana.anno_nas
     , ana.cod_pro_nas
     , ana.cod_com_nas
     , ana.cod_fiscale
     , ana.cf_calcolato
     , ana.data_reg
     , ana.fascia fascia
     , ana.stato stato
     , decode(ana.fascia,3,'S') soggettoAIRE
-- dati famiglia
     , fam.tipo_fam
  from anaana ana
     , anafam fam
 where ana.rapporto_par           in ('CF','CC','IC')
   and ana.cod_fam                = fam.cod_fam
   and ana.fascia                 = fam.fascia
   and fam.cod_fam                = a_cod_fam
   and fam.fascia                 = a_fascia_fam
   and (a_archivio_rif = 'FAM' or a_archivio_rif like 'VIE%')
   and rownum = 1
;

w_protocollo			varchar2(255);
w_data_protocollo		number;
w_data_decorrenza		number;
w_data_definizione		number;
w_servizio_rif             	varchar2(255);
w_id_operazione_rif		number;
w_id_operazione_anpr_rif	number;

w_data_decorrenza_ws		number;

w_cognome 			varchar2(255);
w_nome 				varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);
w_soggettoAIRE			varchar2(255);

w_tipoScheda			varchar2(255);
w_annullamentoAttribuzioneCF	varchar2(255);
w_cod_fiscale_ws		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '5012_ann_mutazione_FAM';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.del_allegati(w_servizio_log);

w_step := 0;
w_xml_clob := w_xml_clob||'<tnsd:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario5000mutazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/vocabolarioRispostaComune" '||
                          'xmlns:tnsc="http://sogei.it/ANPR/rispostaComune" '||
                          'xmlns:tnsd="http://sogei.it/ANPR/5000mutazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

w_step := 1;
  w_data_decorrenza_ws      := f_ANPR_data_decorrenza_ws(a_id_operazione);
  w_protocollo       := '';
  w_data_protocollo  := '';
  w_data_decorrenza  := nvl(w_data_decorrenza_ws,to_char(sysdate,'j'));
  w_data_definizione := to_char(sysdate,'j');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,w_protocollo,w_data_protocollo,w_data_decorrenza,w_data_definizione);

w_step := 2;
  begin
    select rif.servizio_rif, rif.id_operazione_rif, rif.id_operazione_anpr_rif
      into w_servizio_rif, w_id_operazione_rif, w_id_operazione_anpr_rif
      from anpciu_rif rif
     where rif.id_operazione = a_id_operazione
    ;
  exception
    when others then
         w_servizio_rif           := '';
         w_id_operazione_rif      := '';
         w_id_operazione_anpr_rif := '';
  end;

  w_protocollo           := null;
  w_data_protocollo      := null;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_datiOperazione(w_servizio_rif,w_id_operazione_rif,w_protocollo,w_data_protocollo,w_id_operazione_anpr_rif);

w_step := 3;
  for rec in sel loop
      w_cognome                 := f_cognome(rec.cognome_nome);
      w_nome                    := f_nome(rec.cognome_nome);
      if f_ANPR_no_id_anpr_ws(a_id_operazione,'') is null then
         w_idSchedaSoggettoANPR    := f_ANPR_id_scheda(rec.matricola,'','','','');
      end if;
      w_soggettoAIRE            := rec.soggettoAIRE;
      w_cod_fiscale_ws          := f_ANPR_cod_fiscale_ws(a_id_operazione,'',rec.cod_fiscale,rec.cf_calcolato);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSchedaSoggettoFamigliaConvivenza','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_ws,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
        end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSchedaSoggettoFamigliaConvivenza','F');

<< datiControllo >>
      if rec.tipo_fam is null then
         w_tipoScheda                 := '2';
      else
         w_tipoScheda                 := '3';
      end if;
      w_annullamentoAttribuzioneCF := 'N';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_annullamentoAttribuzioneCF,'annullamentoAttribuzioneCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');
  end loop;

<< fine >>
null;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsd:Richiesta'||a_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_5012_ann_mutazione_FAM;

function ws_6001_certificazione
(a_servizio		varchar2
,a_id_operazione 	number
,a_tipo_operazione 	varchar2
,a_anno_rif		number
,a_numero_rif		number
)

return clob

is

w_cognome			varchar2(255);
w_nome                  	varchar2(255);
w_soggettoAIRE			varchar2(255);
w_idSchedaSoggettoANPR		varchar2(255);

w_cod_fiscale_r			varchar2(255);
w_cognome_r			varchar2(255);
w_nome_r                	varchar2(255);
w_sesso_r			varchar2(255);
w_data_nas_r			number;
w_cod_pro_nas_r			number;
w_cod_com_nas_r			number;
w_idSchedaSoggettoANPR_r	varchar2(255);
w_note_r			varchar2(4000);
w_data_doc_r			varchar2(255);

w_listaTipiCertificati	varchar2(255);
w_tipoCertificato	varchar2(255);

w_cognomeUffAnagrafe	varchar2(255);
w_nomeUffAnagrafe	varchar2(255);
w_tipoRichiedente	number;
w_tipoRichiesta		number := 1;	
w_paEstera		number := 0;
w_emissione		number := 1;
w_bollo			number(10,2);
w_bollo_char		varchar2(255);
w_bolloVirtuale		number := f_ANPR_valore_inp('6001_VIRTU',1,1,'9','');
w_esenzioneDiritti	varchar2(255);
w_diritti		number(10,2);
w_diritti_char		varchar2(255);
w_esenzioneBollo	varchar2(255);
w_desEsenzioneBollo	varchar2(4000);

w_rigaAnnotazione_1	varchar2(255);
w_rigaAnnotazione_2	varchar2(255);
w_rigaAnnotazione_3	varchar2(255);

w_data_decorrenza       number;

w_step			number;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '6001_certificazione';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

cursor sel_certificato is
select inc.terminale
-- dati richiedente
     , cem.flag_richiedente
     , cem.cod_fiscale_richiedente cod_fiscale_r
     , cem.richiedente cognome_nome_r
     , cem.sesso_richiedente sesso_r
     , cem.data_nas_richiedente data_nas_r
     , cem.note_richiedente note_r
-- dati beneficiario
     , ana.matricola
     , ana.cod_fiscale
     , ana.cognome_nome
     , ana.sesso
     , ana.data_nas
     , ana.anno_nas
     , ana.cod_pro_nas
     , ana.cod_com_nas
     , decode(ana.fascia,3,'S') soggettoAIRE
     , anp.id_scheda_anpr idSchedaANPR
-- dati certificato
     , nvl(t13.lista_tipi_certificato,t13.codice) cod_certificato_anpr
     , dri.codice_anpr cod_rilascio_anpr
     , decode(dri.fascia_tariffaria,'','','S') flag_bollo
     , decode(nvl(dri.codice_anpr,99),99,dri.descr_stampa_1||' '||dri.descr_stampa_2) des_rilascio_ads
     , cem.bollo
     , cem.segreteria
     , cem.rimborso_st
     , cem.terminalista
     , decode(cem.terminalista,
         'ON_LINE', decode(instr(dns.nome_sindaco,'/'),0,substr(dns.nome_sindaco,1,instr(nome_sindaco,' ')-1),substr(dns.nome_sindaco,1,instr(nome_sindaco,'/')-1)),
                    ute.cognome) cognome_terminalista
     , decode(cem.terminalista,
         'ON_LINE', decode(instr(dns.nome_sindaco,'/'),0,substr(dns.nome_sindaco,instr(nome_sindaco,' ')+1),substr(dns.nome_sindaco,instr(nome_sindaco,'/')+1)),
                    ute.nome) nome_terminalista
     , cem.data_storico
     , decode(t13.flag_ele,'S', 
         decode(cem.terminalista, 'ON_LINE', '3',
            decode(dce.tipo_firma,3,'3','1'))) tipo_firma_ele
     , cem.tipo_doc_richiedente tipo_doc_r
     , cem.numero_doc_richiedente numero_doc_r
     , to_char(cem.d_data_ril_doc_richiedente,'j') data_ril_doc_r_j
  from anpute ute, anpads anp,
       cerdfi dfi, cerdns dns, anpt13 t13, cerdri dri, cerdce dce,
       anaana ana, cercem cem, cerinc inc
 where ute.cod_utente (+)	= cem.terminalista
   and anp.tipo_scheda_anpr	in ('Individuale','Aire')
   and anp.matricola_ads	= ana.matricola
   and dri.cod_ri		= cem.modalita_rilascio
   and t13.codice               = dce.codice_anpr
   and dfi.cod_fi               = dce.tipo_firma
   and dce.cod_certificato      = cem.cod_certificato
   and ana.matricola		= inc.matricola
   and cem.anno_emissione	= inc.anno_emissione
   and cem.progr_emissione	= inc.progr_emissione
   and inc.anno_emissione       = a_anno_rif
   and inc.progr_emissione      = a_numero_rif
;

begin

  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'anno '||a_anno_rif||' - progr '||a_numero_rif);

  for rec in sel_certificato loop
w_xml_clob := w_xml_clob||'<tnsb:Richiesta'||a_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario6001certificazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/6001certificazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);
<< testataRichiesta>>
      w_data_decorrenza := rec.data_storico;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,'','',w_data_decorrenza,'');

<< listaTipiCertificati >>
      w_listaTipiCertificati := rec.cod_certificato_anpr;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaTipiCertificati','I');
      if instr(w_listaTipiCertificati,'#') = 0 then
         w_tipoCertificato := w_listaTipiCertificati;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoCertificato,'tipoCertificato','S');
      else
         while instr(w_listaTipiCertificati,'#') > 0 loop
               w_tipoCertificato      := substr(w_listaTipiCertificati,1,instr(w_listaTipiCertificati,'#')-1);
               w_listaTipiCertificati := substr(w_listaTipiCertificati,instr(w_listaTipiCertificati,'#')+1);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoCertificato,'tipoCertificato','S');
         end loop;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaTipiCertificati','F');

<< generalitaRichiedente >>
      if rec.flag_richiedente is null then
         goto generalitaIntestatario;
      end if;
      w_cod_fiscale_r          := rec.cod_fiscale_r;
      if rec.cod_fiscale_r is not null and rec.cognome_nome_r like rec.cod_fiscale_r||'%' then
         w_cognome_r := substr(rec.cod_fiscale_r,1,3);
         w_nome_r    := substr(rec.cod_fiscale_r,4,3);
      else
         w_cognome_r := f_cognome(rec.cognome_nome_r);
         w_nome_r    := f_nome(rec.cognome_nome_r);
      end if;
      w_sesso_r                := rec.sesso_r;
      w_data_nas_r             := rec.data_nas_r;
      w_cod_pro_nas_r          := null;
      w_cod_com_nas_r          := null;
      w_idSchedaSoggettoANPR_r := f_ANPR_id_scheda('',rec.cod_fiscale_r,'','','');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaRichiedente','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_r,'');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_r,w_nome_r,w_sesso_r,w_data_nas_r,'');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_nas_r,w_cod_com_nas_r,w_data_nas_r,'luogoNascita','N');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_r,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');

      if rec.numero_doc_r is not null then
         w_note_r     := rec.tipo_doc_r||'.'||rec.numero_doc_r;
         w_note_r     := substr(w_note_r,1,40);
         w_data_doc_r := f_ANPR_data(rec.data_ril_doc_r_j);
      elsif rec.note_r is not null then
--         w_note_r     := rec.note_r;
         w_note_r     := translate(rec.note_r,'-/','..');
         w_note_r     := substr(w_note_r,1,40);
         w_data_doc_r := f_ANPR_data(to_char(sysdate,'j'));
      else
         if rec.terminalista = 'ON_LINE' then
            w_note_r     := 'autenticazione.portale.comunale';
            w_data_doc_r := f_ANPR_data(to_char(sysdate,'j'));
         else
--            w_note_r     := 'riconosciuto.personalmente';
--            w_data_doc_r := f_ANPR_data(to_char(sysdate,'j'));
            w_note_r     := '';
            w_data_doc_r := '';
         end if;
      end if;

      if w_note_r is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'docRiconoscimento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_note_r,'estDocRiconoscimento','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data_doc_r,'dataRilascio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'docRiconoscimento','F');
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaRichiedente','F');

<< generalitaIntestatario >>
      w_cognome              := f_cognome(rec.cognome_nome);
      w_nome	             := f_nome(rec.cognome_nome);
      w_soggettoAIRE         := rec.soggettoAIRE;
      w_idSchedaSoggettoANPR := rec.idSchedaANPR;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'soggettoIntestatario','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale,rec.matricola);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);

      if w_idSchedaSoggettoANPR is not null then
         goto salta_luogoNascita;
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');

<< salta_luogoNascita >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'soggettoIntestatario','F');

<< datiControllo >>
      w_cognomeUffAnagrafe := rec.cognome_terminalista;
      w_nomeUffAnagrafe    := rec.nome_terminalista;
-- tipoRichiedente = 1: richiedente diverso da intestatario
-- tipoRichiedente = 2: richiedente corrisponde a intestatario
-- tipoRichiedente = 3: richiedente Ente
      if rec.flag_richiedente is null then
         w_tipoRichiedente	:= 2;
      else
         w_tipoRichiedente	:= 1;
--         w_tipoRichiedente	:= 3;
      end if;
      w_bollo		  := nvl(rec.bollo,0);
      if w_bollo like '%.%' then
         w_bollo_char := replace(w_bollo,'.','');
      elsif w_bollo like '%,%' then
         w_bollo_char := replace(w_bollo,',','');
      else
         w_bollo_char := w_bollo||'00';
      end if;

      w_diritti		  := nvl(rec.segreteria,0) + nvl(rec.rimborso_st,0);
      if w_diritti like '%.%' then
         w_diritti_char := substr(w_diritti,1,instr(w_diritti,'.'))||
                            rpad(substr(w_diritti,instr(w_diritti,'.')+1),2,'0');
         w_diritti_char := replace(w_diritti_char,'.','');
      elsif w_diritti like '%,%' then
         w_diritti_char := substr(w_diritti,1,instr(w_diritti,','))||
                            rpad(substr(w_diritti,instr(w_diritti,',')+1),2,'0');
         w_diritti_char := replace(w_diritti_char,',','');
      else
         w_diritti_char := w_diritti||'00';
      end if;

--      w_desEsenzioneBollo := f_ANPR_stringa(rec.des_rilascio_ads);
--      w_desEsenzioneBollo := rec.des_rilascio_ads;
      if rec.cod_rilascio_anpr < 0 then
         w_paEstera          := abs(rec.cod_rilascio_anpr);
         w_esenzioneBollo    := '';
         w_esenzioneDiritti  := '';
         w_desEsenzioneBollo := '';
      else
         w_paEstera          := '0';
         w_esenzioneBollo    := ltrim(rec.cod_rilascio_anpr,'0');
         w_esenzioneDiritti  := ltrim(rec.cod_rilascio_anpr,'0');
         w_desEsenzioneBollo := substr(f_ANPR_stringa(rec.des_rilascio_ads),1,255);
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cognomeUffAnagrafe,'cognomeUffAnagrafe');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_nomeUffAnagrafe,'nomeUffAnagrafe');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoRichiedente,'tipoRichiedente','S');

--      w_tipoRichiesta := 1;	-- emissione certificato
--      w_tipoRichiesta := 2;	-- richiesta dati
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoRichiesta,'tipoRichiesta','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_paEstera,'paEstera','S');

-- w_emissione (1 = sportello / 2 = internet)
--
      if rec.terminalista = 'ON_LINE' then
         w_emissione := '2';
      else
         w_emissione := '1';
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_emissione,'emissione','S');

--
-- w_bolloVirtuale (0 = esente / 1 = Bollo assolto in modo virtuale / 2 = Bollo "ordinario"
--
      if nvl(w_bollo,0) = 0 then
         if rec.flag_bollo = 'S' then
            w_bollo_char := f_ANPR_valore_inp('6001_BOLLO',1,10,'X','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_bollo_char,'bollo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'2','bolloVirtuale','S');
         else
            w_bollo_char := '0';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_bollo_char,'bollo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_bolloVirtuale,'bolloVirtuale','S');
         end if;
      else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_bollo_char,'bollo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_bolloVirtuale,'bolloVirtuale','S');
      end if;

      if nvl(w_diritti,0) = 0 then
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_esenzioneDiritti,'esenzioneDiritti','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'0','diritti','S');
      else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_diritti_char,'diritti','S');
      end if;

      if nvl(w_bollo,0) = 0 then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_esenzioneBollo,'esenzioneBollo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_desEsenzioneBollo,'descrizioneEsenzioneBollo','S');
      end if;

      if rec.terminalista != 'ON_LINE' then
         begin
           select riga1, riga2, riga3
             into w_rigaAnnotazione_1, w_rigaAnnotazione_2, w_rigaAnnotazione_3
             from cerdrl
            where terminale = rec.terminale
              and rec.terminalista != 'ON_LINE'
           ;
         exception
           when others then
                w_rigaAnnotazione_1 := '';
                w_rigaAnnotazione_2 := '';
                w_rigaAnnotazione_3 := '';
         end;
      
      elsif rec.terminalista = 'ON_LINE' and rec.flag_bollo = 'S' then
         w_rigaAnnotazione_1 := f_ANPR_stringa('IL CERTIFICATO HA VALORE LEGALE SE MUNITO DI MARCA DA BOLLO');
         w_rigaAnnotazione_2 := f_ANPR_stringa('L''imposta di bollo   a carico del richiedente (o del destinatario) del certificato,');
         w_rigaAnnotazione_3 := f_ANPR_stringa('che devono procedere all''annullamento ai sensi dell''art. 12 del D.P.R. 26 ottobre 1972, n. 642');
      end if;

      if w_rigaAnnotazione_1||w_rigaAnnotazione_2||w_rigaAnnotazione_3 is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAnnotazioni','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_rigaAnnotazione_1,'rigaAnnotazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_rigaAnnotazione_2,'rigaAnnotazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_rigaAnnotazione_3,'rigaAnnotazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAnnotazioni','F');
      end if;

      if a_tipo_operazione = 'V' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','forzaCertificazione','S');
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.tipo_firma_ele,'tipoFirmaElettorale','S');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiControllo','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsb:Richiesta'||a_servizio,'F');
  end loop;

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_6001_certificazione;

function ws_3000_consultazione
(a_servizio		varchar2
,a_id_operazione 	number
,a_tipo_operazione 	varchar2
,a_matricola            number
,a_archivio_rif		varchar2
)

return clob

is

w_servizio			varchar2(255);

w_statoLavorazione 		varchar2(255);
w_operazioneRichiesta		varchar2(255);
w_dataOraIniziale		varchar2(255);
w_dataOraFinale			varchar2(255);

w_idSchedaSoggettoANPR		varchar2(255);
w_idUnicoANPR			varchar2(255);

w_cognome			varchar2(255);
w_nome				varchar2(255);
w_data_nas			varchar2(255);
w_cod_fiscale			varchar2(255);
w_id_soggetto_ANPR              varchar2(255);

w_schedaAnagraficaRichiesta	varchar2(255);
w_dataRiferimentoRichiesta	varchar2(255);
w_datiAnagraficiRichiesti	varchar2(255);
w_data_rif			varchar2(255);

w_ricercaNazionale              varchar2(255);

w_fascia			number;
w_cod_fam                       number;
w_tipo_fam                      number;
w_tipo_scheda_anpr		varchar2(255);
w_id_scheda_anpr		varchar2(255);
w_tipoScheda                    varchar2(255);
w_idFamigliaConvivenzaANPR	varchar2(255);

w_data_inp_rif                  varchar2(255);
w_data_inp                      varchar2(255);
w_data_inp_fine                 varchar2(255);
w_data_iniziale                 varchar2(255);
w_data_finale                   varchar2(255);

w_idOperazioneANPR		varchar2(255);

w_step			number;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '3000_consultazione';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

begin

  ANPR_pkg.del_allegati(w_servizio_log);

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio');

  if a_servizio in ('3007','N010','N014','N015','N017','N030','N031','NRIS','NA00','NA01','NA02','NA03','NA04','NA05') then
     w_servizio := '3003';
  else
     w_servizio := a_servizio;
  end if;

w_xml_clob := w_xml_clob||'<tnsb:Richiesta'||w_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario3000consultazione" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/3000consultazione" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);
<< testataRichiesta>>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio,a_id_operazione,a_tipo_operazione,'','','','');

  if a_servizio in ('3007','N010','N014','N015','N017','N030','N031','NRIS','NA00','NA01','NA02','NA03','NA04','NA05') then
-- 3002 - Consultazione schede individuali e di famiglia
-- 3003 - Consultazione richieste e notifiche
-- 3005 - Visualizzazione Elaborati.
-- 3007 - Consultazione identificativi Operazioni
-- N010 - Notifica mutazione di residenza
-- N014 - Notifica di ripristino da eseguire
-- N015 - Notifica di avvenuto ripristino
-- N020 - Notifica attribuzione codice fiscale
-- N030 - Notifica disponibilit  risposte
-- N031 - Notifica avvenuto subentro
-- NRIS - Notifica Risposta ANPR
-- 01/02/2023 (AM)
-- N017 - Notifica di elettore gi  iscritto in altro comune
-- 13/06/2023 (AM)
-- NA00 - Tutti i registri
-- NA01 - NASCITA
-- NA02 - MORTE
-- NA03 - MATRIMONIO
-- NA04 - UNIONE CIVILE
-- NA05 - CITTADINANZA
     w_operazioneRichiesta := a_servizio;

-- statoLavorazione - valori ammessi:
-- 1 = richieste complete
-- 2 = richieste complete con esito positivo
-- 3 = richieste complete con esito negativo
-- 4 = richieste di estrazione annullate
-- 5 = richieste di estrazione da elaborare
-- 6=  richieste complete con esito positivo ma segnalazione di errori non bloccanti
-- 7 = notifiche  da prendere in carico
-- 8 = notifiche  fruite
-- 9 = tutte le notifiche
     w_statoLavorazione          := '9';

     if w_data_subentro is not null then
        w_data_inp_rif := to_char(to_date(w_data_subentro,'j'),'dd/mm/yyyy');
     else
        w_data_inp_rif := '01/01/2016';
     end if;

     begin
       insert into anpinp (parametro, valore, descrizione)
       select a_servizio||'_DATA', w_data_inp_rif, a_servizio||': DATA RIF.'
         from dual
        where not exists (select 'x' from anpinp b
                           where b.parametro = a_servizio||'_DATA')
       ;
     exception
       when others then
            null;
     end;

     begin
       select substr(a.valore,1,10)
            , rtrim(substr(a.valore,11,10))
         into w_data_inp
            , w_data_inp_fine
         from anpinp a
        where a.parametro = a_servizio||'_DATA'
       ;
     exception
       when others then
            w_data_inp := w_data_inp_rif;
     end;

     w_data_iniziale := w_data_inp;
     if w_data_inp_fine is not null then
        w_data_finale := w_data_inp_fine;
     else
        if a_servizio in ('N010','N014','N015','N017','NA00','NA01','NA02','NA03','NA04','NA05') then
           if add_months(to_date(w_data_iniziale,'dd/mm/yyyy'),12) > trunc(sysdate) then
              w_data_finale := to_char(sysdate,'dd/mm/yyyy');
           else
              w_data_finale := to_char(add_months(to_date(w_data_iniziale,'dd/mm/yyyy'),12),'dd/mm/yyyy');
           end if;
        else
           if add_months(to_date(w_data_iniziale,'dd/mm/yyyy'),1) > trunc(sysdate) then
              w_data_finale := to_char(sysdate,'dd/mm/yyyy');
           else
              w_data_finale := to_char(add_months(to_date(w_data_iniziale,'dd/mm/yyyy'),1),'dd/mm/yyyy');
           end if;
        end if;
     end if;
     w_dataOraIniziale           := f_ANPR_data(to_char(to_date(w_data_iniziale,'dd/mm/yyyy'),'j'))||'T00:00:00';
     w_dataOraFinale             := f_ANPR_data(to_char(to_date(w_data_finale,'dd/mm/yyyy'),'j'))||'T23:59:59';

     begin
       update anpinp a
          set valore = w_data_finale
        where a.parametro = a_servizio||'_DATA'
       ;
     exception
       when others then
            null;
     end;

     if a_servizio = '3007' then
        goto ricercaElenchiRichieste;
     end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comuneRichiesta','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_com_cliente,'nomeComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'codiceIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_sigla_pro_cliente,'siglaProvinciaIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comuneRichiesta','F');

<< ricercaElenchiRichieste >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'ricercaElenchiRichieste','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_statoLavorazione,'statoLavorazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_operazioneRichiesta,'operazioneRichiesta','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'periodoRiferimentoRichieste','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataOraIniziale,'dataOraIniziale','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataOraFinale,'dataOraFinale','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'periodoRiferimentoRichieste','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'ricercaElenchiRichieste','F');

  elsif a_servizio = '3002' then
     if a_archivio_rif = 'ADS' then
        begin
          select decode(ana.cod_fiscale,'',f_cognome(ana.cognome_nome)) cognome,
                 decode(ana.cod_fiscale,'',f_nome(ana.cognome_nome)) nome,
                 ana.cod_fiscale,
                 ana.fascia, ana.cod_fam, fam.tipo_fam
            into w_cognome, w_nome, w_cod_fiscale, w_fascia, w_cod_fam, w_tipo_fam
            from anafam fam, anaana ana
           where fam.fascia  (+) = ana.fascia
             and fam.cod_fam (+) = ana.cod_fam
             and ana.matricola   = a_matricola
          ;
          w_idSchedaSoggettoANPR      := f_ANPR_id_scheda(a_matricola,'','','','');
          w_idUnicoANPR               := f_ANPR_id_unico(a_matricola,'');
        exception
          when others then
               w_idSchedaSoggettoANPR      := '';
               w_idUnicoANPR               := '';
               w_cognome                   := '';
               w_nome                      := '';
               w_cod_fiscale               := '';
               w_tipo_scheda_anpr          := '';
               w_id_scheda_anpr            := '';
        end;
        begin
          select rtrim(ltrim(par.data_rif,'0'))
            into w_data_rif
            from anpciu_par par
           where par.id_operazione = a_id_operazione
          ;
          w_dataRiferimentoRichiesta  := f_ANPR_data(w_data_rif);
        exception
          when others then
               w_dataRiferimentoRichiesta  := '';
        end;
     elsif a_archivio_rif = 'ANPR' then
        begin
          select rtrim(decode(par.cod_fiscale,'',par.cognome)) cognome,
                 rtrim(decode(par.cod_fiscale,'',par.nome)) nome,
                 rtrim(par.cod_fiscale),
                 f_ANPR_data(rtrim(par.data_nas)),
                 rtrim(par.tipo_scheda_anpr),
                 rtrim(par.id_scheda_anpr),
                 rtrim(ltrim(par.data_rif,'0'))
            into w_cognome, w_nome, w_cod_fiscale, w_data_nas,
                 w_tipo_scheda_anpr, w_id_scheda_anpr,
                 w_data_rif
            from anpciu_par par
           where par.id_operazione = a_id_operazione
          ;
          w_idSchedaSoggettoANPR      := '';
          w_dataRiferimentoRichiesta  := f_ANPR_data(w_data_rif);
        exception
          when others then
               w_idSchedaSoggettoANPR      := '';
               w_idUnicoANPR               := '';
               w_cognome                   := '';
               w_nome                      := '';
               w_cod_fiscale               := '';
               w_tipo_scheda_anpr          := '';
               w_id_scheda_anpr            := '';
               w_dataRiferimentoRichiesta  := '';
        end;
     end if;

     if w_dataRiferimentoRichiesta is null then
        w_dataRiferimentoRichiesta  := f_ANPR_data(to_char(sysdate,'j'));
     end if;

     if w_tipo_scheda_anpr is not null and w_id_scheda_anpr is not null then
        goto schedaFamiglia;
     else
        if w_id_scheda_anpr is not null then
           if translate(w_id_scheda_anpr,'0123456789','9999999999') in ('99999','999999','9999999','99999999','999999999','9999999999') then
              w_idSchedaSoggettoANPR := w_id_scheda_anpr;
              w_idUnicoANPR          := '';
           else
              w_idSchedaSoggettoANPR := '';
              w_idUnicoANPR          := w_id_scheda_anpr;
           end if;
        end if;
        goto schedaIndividuale;
     end if;

<< schedaFamiglia >>
-- tipoScheda - valori ammessi:
-- 1 = famiglia
-- 2 = convivenza
--
-- schedaAnagraficaRichiesta - valori ammessi:
-- 1 - scheda individuale
-- 2 - famiglia/convivenza
-- 3 - scheda famiglia
-- 4 - scheda convivenza
     if w_tipo_scheda_anpr = '4' then
        w_tipoScheda                := '2';
        w_schedaAnagraficaRichiesta := '4';
     elsif w_tipo_scheda_anpr in ('3','5') then
        w_tipoScheda                := '1';
        w_schedaAnagraficaRichiesta := '3';
     end if;
     w_datiAnagraficiRichiesti   := '';
     w_idFamigliaConvivenzaANPR  := w_id_scheda_anpr;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'criteriRicerca','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idFamigliaConvivenzaANPR,'identificativoANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'criteriRicerca','F');
     goto datiRichiesta;

<< schedaIndividuale >>
     w_cognome                   := f_ANPR_stringa(w_cognome);
     w_nome                      := f_ANPR_stringa(w_nome);

-- schedaAnagraficaRichiesta - valori ammessi:
-- 1 - scheda individuale
-- 2 - famiglia/convivenza
-- 3 - scheda famiglia
-- 4 - scheda convivenza
     w_schedaAnagraficaRichiesta := '1';
     w_datiAnagraficiRichiesti   := '1';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'criteriRicerca','I');
     if w_idSchedaSoggettoANPR is null and w_idUnicoANPR is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cod_fiscale,'codiceFiscale','S');
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cognome,'cognome','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_nome,'nome','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idUnicoANPR,'idANPR','S');
     if w_idUnicoANPR is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'criteriRicerca','F');

     if w_data_nas is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiNascita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data_nas,'dataEvento','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiNascita','F');
     end if;

<< datiRichiesta >>
-- ricercaNazionale = '0': indica ricerca sul comune mittente
-- ricercaNazionale = '1': indica ricerca su tutta ANPR
     w_ricercaNazionale := '1';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiRichiesta','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_schedaAnagraficaRichiesta,'schedaAnagraficaRichiesta','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataRiferimentoRichiesta,'dataRiferimentoRichiesta','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_datiAnagraficiRichiesti,'datiAnagraficiRichiesti','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_ricercaNazionale,'ricercaNazionale','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiRichiesta','F');

  elsif a_servizio = '3003' then
     begin
       select rtrim(par.cod_fiscale),
              rtrim(decode(par.cod_fiscale,'',par.cognome)) cognome,
              rtrim(decode(par.cod_fiscale,'',par.nome)) nome,
              rtrim(decode(par.cod_fiscale,'',f_ANPR_data(rtrim(par.data_nas)))) data_nas
         into w_cod_fiscale, w_cognome, w_nome, w_data_nas
         from anpciu_par par
        where par.id_operazione = a_id_operazione
       ;
       w_id_scheda_anpr := '';
     exception
       when others then
            w_cod_fiscale    := '';
            w_cognome        := '';
            w_nome           := '';
            w_data_nas       := '';
            w_id_scheda_anpr := '';
     end;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'parametriRicercaSoggetto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSoggetto','I');

--            <idSchedaSoggettoANPR>0</idSchedaSoggettoANPR>

     if w_cod_fiscale is not null then
--        ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_cod_fiscale '||w_cod_fiscale);
        if length(w_cod_fiscale) < 11 and translate(w_cod_fiscale,'0123456789','9999999999') in ('9','99','999','9999','99999','999999','9999999','99999999','999999999','9999999999') then
--           ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_id_scheda_anpr');
           w_id_soggetto_anpr := w_cod_fiscale;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_id_soggetto_anpr,'idSchedaSoggettoANPR','S');
        else
--           ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_cod_fiscale');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cod_fiscale,'codiceFiscale','S');
        end if;
     elsif w_cod_fiscale is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cognome,'cognome','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_nome,'nome','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiNascitaSoggetto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data_nas,'dataEvento','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiNascitaSoggetto','F');
     end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiSoggetto','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','dettaglioElenco','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'parametriRicercaSoggetto','F');

  elsif a_servizio = '3005' then
     w_idOperazioneANPR := a_matricola;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiRichiesta','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idOperazioneANPR,'idOperazioneANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiRichiesta','F');

  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsb:Richiesta'||w_servizio,'F');

  ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');

  return w_xml_clob;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_3000_consultazione;

function ws_7001_scarico_tabelle
(a_servizio		varchar2
,a_id_operazione 	number
,a_tipo_operazione 	varchar2
,a_numero_rif	 	number
,a_archivio_rif 	varchar2
)

return clob

is

w_servizio              varchar2(255);
w_data_decorrenza	number;
w_idTabella             varchar2(255);

w_step                  number;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '7001_scarico_tabelle';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

begin
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio');

  ANPR_pkg.del_allegati(w_servizio_log);

  if a_numero_rif is not null then
     w_servizio        := a_servizio;
     w_data_decorrenza := to_char(sysdate,'j');
     w_idTabella       := lpad(a_numero_rif,3,'0');

w_xml_clob := w_xml_clob||'<tnsb:Richiesta'||w_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario7001scaricoTabelle" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/7001scaricoTabelle" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

<< testataRichiesta>>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio,a_id_operazione,a_tipo_operazione,'','',w_data_decorrenza,'');

<< datiRichiesta >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiRichiesta','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idTabella,'idTabella','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiRichiesta','F');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsb:Richiesta'||w_servizio,'F');

     ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');
  end if;

  return w_xml_clob;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_7001_scarico_tabelle;

function ws_7002_download_file
(a_servizio		varchar2
,a_id_operazione 	number
,a_tipo_operazione 	varchar2
,a_numero_rif	 	number
,a_archivio_rif 	varchar2
)

return clob

is

w_servizio              varchar2(255);
w_data_decorrenza	number;
w_idOperazioneANPR      number;

w_step                  number;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := '7002_download_file';
w_note_log		varchar2(4000);
w_errore		varchar2(255);
errore			exception;

begin
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio');

  ANPR_pkg.del_allegati(w_servizio_log);

  if a_numero_rif is not null then
     w_servizio        := a_servizio;
     w_data_decorrenza := to_char(sysdate,'j');

w_xml_clob := w_xml_clob||'<tnsb:Richiesta'||w_servizio||' '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolario7001scaricoTabelle" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/7001scaricoTabelle" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10);

<< testataRichiesta>>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_testataRichiesta(w_servizio,a_id_operazione,a_tipo_operazione,'','',w_data_decorrenza,'');

<< datiRichiesta >>
     w_idOperazioneANPR := a_numero_rif;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiRichiesta','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idOperazioneANPR,'idOperazioneANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiRichiesta','F');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsb:Richiesta'||w_servizio,'F');

     ANPR_pkg.ins_allegati(w_servizio_log,'','',w_xml_clob);
     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'fine');
  end if;

  return w_xml_clob;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_7002_download_file;

procedure ws_e001_subentro
is

w_xml_clob		clob;

w_servizio_log		varchar2(255) := 'E001';
w_operazione_log	varchar2(255) := 'subentro';

w_errore		varchar2(255);
errore			exception;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
  ANPR_pkg.ws_e001_parametri;
  ANPR_pkg.ws_e001_subentro_controlli;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end ws_e001_subentro;

procedure ws_e001_parametri
is

w_progr_fornitura	number;
w_tot_ana		number;
w_conta_ana		number;
w_cod_fam_dep		number;
w_cod_fam_ini		number;
w_conta_inv		number;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := 'E001';
w_operazione_log	varchar2(255) := 'parametri';

w_errore		varchar2(255);
errore			exception;

begin
<< datiFornitura >>
  begin
    select valore into w_progr_fornitura
      from anpinp
     where parametro = 'E001_FOR'
    ;
    w_progr_fornitura := w_progr_fornitura + 1;
    ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_progr_fornitura '||w_progr_Fornitura);
    update anpinp
       set valore = w_progr_fornitura
     where parametro = 'E001_FOR'
    ;
  exception
    when no_data_found then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins anpinp - no data found');
         w_progr_fornitura := 1;
         begin
           insert into anpinp (parametro, valore, descrizione)
           values ('E001_FOR',w_progr_fornitura,'S001: PROGR. FORNITURA')
           ;
         end;
    when others then
         w_errore := 'Errore in sel_par ('||SQLERRM||')';
         raise errore;
  end;

--COMMIT;
exception
  when errore then
       ROLLBACK;
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       ROLLBACK;
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end ws_e001_parametri;

procedure ws_e001_subentro_controlli

is

cursor sel_con is
select *
  from anpr_e001_controlli
;

w_fornitura		number;
w_invio			number;
w_tot_invii		number;
w_nome_allegato		varchar2(255);

w_count_sez		number;

w_xml_clob		clob;
w_xml			xmltype;

w_servizio_log		varchar2(255) := 'E001';
w_operazione_log	varchar2(255) := 'controlli';
w_errore		varchar2(255);
errore			exception;

begin
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio');

<< subele >>
  for rec in sel_con loop
<< datiFornitura >>
w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsb:subentroListe '||
                          'xmlns:tnsb="http://sogei.it/ANPR/subentroListe" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '||
                          'xsi:schemaLocation="http://sogei.it/ANPR/subentroListe">'||chr(10);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiFornitura','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_versioneFornitura,'versioneFornitura','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_ntotListe,'numeroTotaleListe','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiFornitura','F');

w_xml_clob := w_xml_clob||ws_e001_subentro_liste_ele;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsb:subentroListe','F');

  w_fornitura     := rec.c_for_versionefornitura;
  w_nome_allegato := w_codice_cliente||'_SUBELE_'||w_fornitura;
  ANPR_pkg.ins_allegati(w_servizio_log,'1',w_nome_allegato,w_xml_clob);

  end loop;

  ANPR_pkg.valida_xml(w_servizio_log,w_xml_clob);

<< subsez >>
  begin
    select count(dse.sezione)
      into w_count_sez
      from eledlr dlr, eledse dse
     where dlr.cod_lr    = dse.luogo_riunione
    ;
  exception
    when others then 
         w_count_sez := 0;
  end;

w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsb:subentroSezioni '||
                          'xmlns:tnsb="http://sogei.it/ANPR/subentroSezioni" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '||
                          'xsi:schemaLocation="http://sogei.it/ANPR/subentroSezioni">'||chr(10);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_count_sez,'numeroTotaleSezioni','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezioni','I');

w_xml_clob := w_xml_clob||ws_e001_subentro_sezioni_ele;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezioni','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsb:subentroSezioni','F');

  w_nome_allegato := w_codice_cliente||'_SUBSEZ_'||w_fornitura;
  ANPR_pkg.ins_allegati(w_servizio_log,'0',w_nome_allegato,w_xml_clob);

  ANPR_pkg.valida_xml(w_servizio_log,w_xml_clob);

--  return w_xml_clob;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
--       return w_xml_clob;
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
--       return w_xml_clob;
end ws_e001_subentro_controlli;

function ws_e001_subentro_liste_ele

return clob

is

cursor sel_ele is
select 'ELE' archivio_rif
     , ana.matricola
     , decode(ele.sezione,'',
         decode(ele.stato,'S',f_sezione_ele(ele.cod_via_ele,ele.num_civ_ele,ele.suffisso_ele)),
         ele.sezione) sezione_ele
     , ele.stato stato_ele
     , ele.motivo motivo_ele
     , e32.des_ripartizione circ_estero_senato
     , e33.des_ripartizione circ_estero_camera
  from anpe32 e32
     , anpe33 e33
     , anaana ana
     , eleana ele
 where e32.codice (+) = ele.cod_pro_aire_ele
   and e33.codice (+) = ele.cod_pro_aire_ele
   and ana.matricola  = ele.matricola
   and (ele.stato = 'E'
        or (ele.stato = 'S' and ana.fascia in (1,3)))
   and f_ANPR_id_scheda(ele.matricola,'','','','') is not null
UNION
select 'ELA_'||tipo_lista archivio_rif
     , ana.matricola
     , to_char(ela.sezione) sezione_ele
     , ela.stato stato_ele
     , ela.motivo motivo_ele
     , to_char(null)
     , to_char(null)
  from anaana ana
     , eleela ela
 where ana.matricola  = ela.matricola
   and ela.tipo_lista in ('B','T','V')
   and ela.stato      = 'E'
   and f_ANPR_id_scheda(ela.matricola,'','','','') is not null
UNION
select 'ELA_'||tipo_lista archivio_rif
     , ana.matricola
     , to_char(ela.sezione) sezione_ele
     , ela.stato stato_ele
     , ela.motivo motivo_ele
     , to_char(null)
     , to_char(null)
  from anaana ana
     , eleela ela
 where ana.matricola  = ela.matricola
   and ela.tipo_lista in ('C','E')
   and ela.stato      = 'E'
   and f_ANPR_id_scheda(ela.matricola,'','','','') is not null
 order by 2
;

cursor sel_sez (w_sezione_par number) is
select dse.sezione, 
       dlr.descrizione luogo_riunione, dlr.indirizzo,
-- 1 - parlamento europeo
       dco_1.collegio collegio_1, dco_1.descrizione des_collegio_1,
       f_ANPR_circoscrizione_ele(1) circoscrizione_anpr_1,
-- 2 - senato della repubblica
       dco_2.collegio collegio_2, dco_2.descrizione des_collegio_2,
       f_ANPR_circoscrizione_ele(2) circoscrizione_anpr_2,
-- 3 - camera dei deputati
       dco_3.collegio collegio_3, dco_3.descrizione des_collegio_3,
       f_ANPR_circoscrizione_ele(3) circoscrizione_anpr_3,
-- 4 - regionali
       dco_4.collegio collegio_4, dco_4.descrizione des_collegio_4,
       f_ANPR_circoscrizione_ele(4) circoscrizione_anpr_4,
-- 5 - provinciali
       dco_5.collegio collegio_5, dco_5.descrizione des_collegio_5,
-- 6 - circoscrizionali
       dco_6.collegio collegio_6, dco_6.descrizione des_collegio_6,
       nvl(dse.data_ult_agg,to_char(sysdate,'j')) data_ult_agg,
       2100+dse.luogo_riunione /*to_number(null)*/ cod_via,
       dse.luogo_riunione      /*to_number(null)*/ num_civ,
       to_char(null) suffisso,
       to_number(null) interno,
       to_char(null) sub_interno,
       to_char(null) scala,
       to_char(null) piano
  from eledte dte_6, eledco dco_6, eledsc dsc_6,
       eledte dte_5, eledco dco_5, eledsc dsc_5,
       eledte dte_4, eledco dco_4, eledsc dsc_4,
       eledte dte_3, eledco dco_3, eledsc dsc_3,
       eledte dte_2, eledco dco_2, eledsc dsc_2,
       eledte dte_1, eledco dco_1, eledsc dsc_1,
       eledlr dlr, eledse dse
 where dco_6.tipo_elezione   = dsc_6.tipo_elezione
   and dco_6.collegio= dsc_6.collegio
   and dsc_6.tipo_elezione   = dte_6.cod_te
   and dsc_6.sezione = dse.sezione
   and dte_6.rif_tessera_ele = 6
   and dco_5.tipo_elezione   = dsc_5.tipo_elezione
   and dco_5.collegio= dsc_5.collegio
   and dsc_5.tipo_elezione   = dte_5.cod_te
   and dsc_5.sezione = dse.sezione
   and dte_5.rif_tessera_ele = 5
   and dco_4.tipo_elezione   = dsc_4.tipo_elezione
   and dco_4.collegio= dsc_4.collegio
   and dsc_4.tipo_elezione   = dte_4.cod_te
   and dsc_4.sezione = dse.sezione
   and dte_4.rif_tessera_ele = 4
   and dco_3.tipo_elezione   = dsc_3.tipo_elezione
   and dco_3.collegio= dsc_3.collegio
   and dsc_3.tipo_elezione   = dte_3.cod_te
   and dsc_3.sezione = dse.sezione
   and dte_3.rif_tessera_ele = 3
   and dco_2.tipo_elezione   = dsc_2.tipo_elezione
   and dco_2.collegio= dsc_2.collegio
   and dsc_2.tipo_elezione   = dte_2.cod_te
   and dsc_2.sezione = dse.sezione
   and dte_2.rif_tessera_ele = 2
   and dco_1.tipo_elezione   = dsc_1.tipo_elezione
   and dco_1.collegio= dsc_1.collegio
   and dsc_1.tipo_elezione   = dte_1.cod_te
   and dsc_1.sezione = dse.sezione
   and dte_1.rif_tessera_ele = 1
   and dlr.cod_lr    = dse.luogo_riunione
   and dse.sezione   = w_sezione_par
   and rownum = 1
;

w_matricola_prec		number;

w_idSchedaSoggettoANPR		varchar2(255);

w_archivio_rif			varchar2(255);

w_elettore			varchar2(255);
w_elettore_C			varchar2(255);
w_elettore_E			varchar2(255);
w_elettore_B			varchar2(255);
w_elettore_T			varchar2(255);
w_elettore_V			varchar2(255);

w_soggettoCertificabile		varchar2(255);

w_referendumNazionali		varchar2(255) := 'N';
w_elezioniMembriUe		varchar2(255) := 'N';
w_senatoRepubblica		varchar2(255) := 'N';
w_circoscrSenatoRepubblica	varchar2(255);
w_cameraDeputati		varchar2(255) := 'N';
w_circoscrCameraDeputati	varchar2(255);
w_regionali			varchar2(255) := 'N';
w_comunali			varchar2(255) := 'N';
w_circoscrizionali		varchar2(255) := 'N';

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := 'E001';
w_operazione_log	varchar2(255) := 'liste_ele';
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.DATI_CLIENTE;

  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio');

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'listeElettorali','I');
  for rec in sel_ele loop
      if rec.matricola = nvl(w_matricola_prec,0) then 
         goto fine_loop;
      end if;

w_xml_clob_sog := ANPR_pkg.f_xml_tag(w_servizio_log,'listaSoggetto','I');
      w_idSchedaSoggettoANPR := f_ANPR_id_scheda(rec.matricola,'','','','');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'lista','I');
      w_elettore := f_ANPR_elettorale(rec.matricola,'ELETTORE',rec.archivio_rif);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore,'elettore');

      w_referendumNazionali		:= 'N';
      w_elezioniMembriUe		:= 'N';
      w_senatoRepubblica		:= 'N';
      w_cameraDeputati			:= 'N';
      w_regionali			:= 'N';
      w_comunali			:= 'N';
      w_circoscrizionali		:= 'N';
      w_circoscrSenatoRepubblica        := '';
      w_circoscrCameraDeputati          := '';

      if rec.archivio_rif = 'ELE' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaGenerale','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.sezione_ele,'sezioneelettoralenum');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaGenerale','F');
         if rec.stato_ele = 'E' then
            w_referendumNazionali	:= 'S';
            w_elezioniMembriUe		:= 'S';
            w_senatoRepubblica		:= 'S';
            w_cameraDeputati		:= 'S';
            w_regionali			:= 'S';
            w_comunali			:= 'S';
            w_circoscrizionali		:= w_flag_circoscrizionali;
         end if;
      end if;

      if rec.archivio_rif in ('ELA_C','ELA_E') then
         w_elettore_C                   := f_ANPR_elettorale(rec.matricola,'ELETTORE','ELA_C');
         w_elettore_E                   := f_ANPR_elettorale(rec.matricola,'ELETTORE','ELA_E');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUE','I');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_C,'ueelettorecomunali');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUEComunali','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.sezione_ele,'sezioneelettoralenum');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUEComunali','F');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_E,'ueelettoreparlamento');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUEParlamento','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.sezione_ele,'sezioneelettoralenum');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUEParlamento','F');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaUE','F');

         if w_elettore_E = 'S' then
            w_elezioniMembriUe		:= 'S';
         end if;
         
         if w_elettore_C = 'S' then
            w_comunali			:= 'S';
            w_circoscrizionali		:= w_flag_circoscrizionali;
         end if;

      end if;

      if rec.archivio_rif in ('ELA_B','ELA_T','ELA_V') then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaComReg','I');
         if rec.archivio_rif = 'ELA_B' then
            w_elettore_B                := f_ANPR_elettorale(rec.matricola,'ELETTORE','ELA_B');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_B,'comregelettorebolzano');
            w_regionali			:= 'S';
            w_comunali			:= 'S';
            w_circoscrizionali		:= w_flag_circoscrizionali;
         end if;

         if rec.archivio_rif = 'ELA_T' then
            w_elettore_T                := f_ANPR_elettorale(rec.matricola,'ELETTORE','ELA_T');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_T,'comregelettoretrento');
            w_regionali			:= 'S';
         end if;

         if rec.archivio_rif = 'ELA_V' then
            w_elettore_V                := f_ANPR_elettorale(rec.matricola,'ELETTORE','ELA_V');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore_V,'comregelettorevalledaosta');
            w_regionali			:= 'S';
         end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaBolTreVal','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.sezione_ele,'sezioneelettoralenum');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaBolTreVal','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaAggiuntaComReg','F');
      end if;

      if w_senatoRepubblica||w_cameraDeputati != 'NN' then
         if rec.circ_estero_senato||rec.circ_estero_camera is not null then
            w_circoscrSenatoRepubblica := nvl(rec.circ_estero_senato,'-');
            w_circoscrCameraDeputati   := nvl(rec.circ_estero_camera,'-');
         else
            for rec_sez in sel_sez (rec.sezione_ele) loop
                w_circoscrSenatoRepubblica	:= nvl(rec_sez.circoscrizione_anpr_2,rec_sez.des_collegio_2);
                w_circoscrCameraDeputati	:= nvl(rec_sez.circoscrizione_anpr_3,rec_sez.des_collegio_3);   
            end loop;
            w_circoscrSenatoRepubblica := nvl(w_circoscrSenatoRepubblica,'-');
            w_circoscrCameraDeputati   := nvl(w_circoscrCameraDeputati,'-');
         end if;
      end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_referendumNazionali,'referendumnazionali');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elezioniMembriUe,'elezionimembriue');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_senatoRepubblica,'senatorepubblica');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_circoscrSenatoRepubblica,'circoscrsenatorepubblica','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cameraDeputati,'cameradeputati');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_circoscrCameraDeputati,'circoscrcameradeputati','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_regionali,'regionali');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_comunali,'comunali');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_circoscrizionali,'circoscrizionali');


w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'lista','F');

      if rec.stato_ele = 'E' then
         w_soggettoCertificabile := 2;
      else
         w_soggettoCertificabile := 0;
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'certificabilita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoCertificabile,'soggettoCertificabile');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'certificabilita','F');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'listaSoggetto','F');

w_xml_clob := w_xml_clob||w_xml_clob_sog;

<< fine_loop >>
      w_matricola_prec := rec.matricola;
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listeElettorali','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_e001_subentro_liste_ele;

function ws_e001_subentro_sezioni_ele

return clob

is

cursor sel_sez_tot is
select dse.sezione
  from eledlr dlr, eledse dse
 where dlr.cod_lr = dse.luogo_riunione
 order by 1
;

cursor sel_sez (w_sezione_par number) is
select dse.sezione, 
       dlr.descrizione luogo_riunione, dlr.indirizzo,
-- 1 - parlamento europeo
       dco_1.collegio collegio_1, dco_1.descrizione des_collegio_1,
       f_ANPR_circoscrizione_ele(1) circoscrizione_anpr_1,
-- 2 - senato della repubblica
       dco_2.collegio collegio_2, dco_2.descrizione des_collegio_2,
       f_ANPR_circoscrizione_ele(2) circoscrizione_anpr_2,
       f_ANPR_collegio_ele(2) collegio_anpr_2,
-- 3 - camera dei deputati
       dco_3.collegio collegio_3, dco_3.descrizione des_collegio_3,
       f_ANPR_circoscrizione_ele(3) circoscrizione_anpr_3,
       f_ANPR_collegio_ele(3) collegio_anpr_3,
-- 4 - regionali
       dco_4.collegio collegio_4, dco_4.descrizione des_collegio_4,
       f_ANPR_circoscrizione_ele(4) circoscrizione_anpr_4,
-- 5 - provinciali
       dco_5.collegio collegio_5, dco_5.descrizione des_collegio_5,
-- 6 - circoscrizionali
       dco_6.collegio collegio_6, dco_6.descrizione des_collegio_6,
       nvl(dse.data_ult_agg,to_char(sysdate,'j')) data_ult_agg,
       2100+dse.luogo_riunione /*to_number(null)*/ cod_via,
       dse.luogo_riunione      /*to_number(null)*/ num_civ,
       to_char(null) suffisso,
       to_number(null) interno,
       to_char(null) sub_interno,
       to_char(null) scala,
       to_char(null) piano
  from eledte dte_6, eledco dco_6, eledsc dsc_6,
       eledte dte_5, eledco dco_5, eledsc dsc_5,
       eledte dte_4, eledco dco_4, eledsc dsc_4,
       eledte dte_3, eledco dco_3, eledsc dsc_3,
       eledte dte_2, eledco dco_2, eledsc dsc_2,
       eledte dte_1, eledco dco_1, eledsc dsc_1,
       eledlr dlr, eledse dse
 where dco_6.tipo_elezione   = dsc_6.tipo_elezione
   and dco_6.collegio= dsc_6.collegio
   and dsc_6.tipo_elezione   = dte_6.cod_te
   and dsc_6.sezione = dse.sezione
   and dte_6.rif_tessera_ele = 6
   and dco_5.tipo_elezione   = dsc_5.tipo_elezione
   and dco_5.collegio= dsc_5.collegio
   and dsc_5.tipo_elezione   = dte_5.cod_te
   and dsc_5.sezione = dse.sezione
   and dte_5.rif_tessera_ele = 5
   and dco_4.tipo_elezione   = dsc_4.tipo_elezione
   and dco_4.collegio= dsc_4.collegio
   and dsc_4.tipo_elezione   = dte_4.cod_te
   and dsc_4.sezione = dse.sezione
   and dte_4.rif_tessera_ele = 4
   and dco_3.tipo_elezione   = dsc_3.tipo_elezione
   and dco_3.collegio= dsc_3.collegio
   and dsc_3.tipo_elezione   = dte_3.cod_te
   and dsc_3.sezione = dse.sezione
   and dte_3.rif_tessera_ele = 3
   and dco_2.tipo_elezione   = dsc_2.tipo_elezione
   and dco_2.collegio= dsc_2.collegio
   and dsc_2.tipo_elezione   = dte_2.cod_te
   and dsc_2.sezione = dse.sezione
   and dte_2.rif_tessera_ele = 2
   and dco_1.tipo_elezione   = dsc_1.tipo_elezione
   and dco_1.collegio= dsc_1.collegio
   and dsc_1.tipo_elezione   = dte_1.cod_te
   and dsc_1.sezione = dse.sezione
   and dte_1.rif_tessera_ele = 1
   and dlr.cod_lr    = dse.luogo_riunione
   and dse.sezione   = w_sezione_par
   and rownum = 1
;

w_sezione		number;
w_luogo_riunione	varchar2(255);
w_indirizzo		varchar2(255);
w_des_luogo_riunione	varchar2(255);
w_des_collegio_1	varchar2(255);
w_des_collegio_2	varchar2(255);
w_des_collegio_3	varchar2(255);
w_des_collegio_4	varchar2(255);
w_des_collegio_5	varchar2(255);
w_des_collegio_6	varchar2(255);

w_xml_clob_sog		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := 'E001';
w_operazione_log	varchar2(255) := 'liste_ele';
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.DATI_CLIENTE;

  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio');

  for rec_tot in sel_sez_tot loop
   for rec in sel_sez (rec_tot.sezione) loop
      w_sezione        := rec.sezione;
      w_luogo_riunione := f_ANPR_stringa(rec.luogo_riunione);
      w_indirizzo      := f_ANPR_stringa(rec.indirizzo);
      w_des_collegio_1 := nvl(rec.circoscrizione_anpr_1,rec.des_collegio_1);
      w_des_collegio_2 := nvl(rec.collegio_anpr_2,rec.des_collegio_2);
      w_des_collegio_3 := nvl(rec.collegio_anpr_3,rec.des_collegio_3);
      w_des_collegio_4 := nvl(rec.circoscrizione_anpr_4,rec.des_collegio_4);
      w_des_collegio_5 := f_ANPR_stringa(rec.des_collegio_5);
      w_des_collegio_6 := f_ANPR_stringa(rec.des_collegio_6);

w_step := 0.9;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comune','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_com_cliente,'nomeComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'codiceIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_sigla_pro_cliente,'siglaProvinciaIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comune','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_sezione,'sezioneelettoralenum','S');
       goto indirizzo_stringa;
--       goto indirizzo_strutturato;

<< indirizzo_stringa >>
--       w_des_luogo_riunione := w_luogo_riunione||' - '||w_indirizzo;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_luogo_riunione,'sezioneelettoraledenom','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezioneelettoraleind','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cap_cliente,'cap','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comune','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_com_cliente,'nomeComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'codiceIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_sigla_pro_cliente,'siglaProvinciaIstat','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'comune','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_specie_area(w_indirizzo),'specie');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'2','specieFonte');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,f_toponimo(w_indirizzo),'denominazioneToponimo');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'2','toponimoFonte');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,'','numeroCivico','');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezioneelettoraleind','F');
       goto collegi;

<< indirizzo_strutturato >>
       w_des_luogo_riunione := w_luogo_riunione; 
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_luogo_riunione,'sezioneelettoraledenom','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_indirizzo(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano,'sezioneelettoraleind');

<< collegi >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_1,'circoscrelezionimembriue','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_3,'collegiocameradeputati','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_4,'circoscrregionali','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_6,'circosrizioneelezcircosc','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_des_collegio_2,'collegiosenatorepubblica','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sezione','F');

   end loop;
  end loop;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_e001_subentro_sezioni_ele;

--function ws_s001_subentro return clob
procedure ws_s001_subentro
is

w_xml_clob		clob;

w_servizio_log		varchar2(255) := 'S001';
w_operazione_log	varchar2(255) := 'subentro';

w_errore		varchar2(255);
errore			exception;

begin
  ANPR_pkg.del_allegati(w_servizio_log);
  ANPR_pkg.ws_s001_parametri;
  ANPR_pkg.ws_s001_subentro_controlli;

--  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
--       return w_xml_clob;
end ws_s001_subentro;

procedure ws_s001_parametri
is

cursor sel_ana is
select ana.cod_fam
     , ana.matricola
  from anpr_s001_soggetti ana
 where fascia + 0 = 1
 order by 1, 2
;

w_limite		number := f_ANPR_valore_inp('S001_RANGE',1,10,'9','');

w_progr_fornitura	number;
w_tot_ana		number;
w_conta_ana		number;
w_cod_fam_dep		number;
w_cod_fam_ini		number;
w_conta_inv		number;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := 'S001';
w_operazione_log	varchar2(255) := 'parametri';

w_errore		varchar2(255);
errore			exception;

begin
<< datiFornitura >>
  begin
    select valore into w_progr_fornitura
      from anpinp
     where parametro = 'S001_FOR'
    ;
    w_progr_fornitura := w_progr_fornitura + 1;
    ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_progr_fornitura '||w_progr_Fornitura);
    update anpinp
       set valore = w_progr_fornitura
     where parametro = 'S001_FOR'
    ;
  exception
    when no_data_found then
         ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins anpinp - no data found');
         w_progr_fornitura := 1;
         begin
           insert into anpinp (parametro, valore, descrizione)
           values ('S001_FOR',w_progr_fornitura,'S001: PROGR. FORNITURA')
           ;
         end;
    when others then
         w_errore := 'Errore in sel_par ('||SQLERRM||')';
         raise errore;
  end;

<< datiInvio >>
  begin
    delete anpinp
     where parametro = 'S001_TOT'
    ;
    delete anpinp
     where parametro like 'S001_INV%'
    ;
  exception
    when others then
         w_errore := 'errore in del anpinp s001_tot / s001_inv ('||SQLERRM||')';
         raise errore;
  end;

  begin
    select count(*)
      into w_tot_ana
      from anpr_s001_soggetti
     where fascia + 0 = 1
    ;
  end;

  if w_tot_ana <= w_limite then
     begin
       insert into anpinp (parametro, valore, descrizione)
       values ('S001_TOT','1','S001: TOTALE INVII')
       ;
       insert into anpinp (parametro, valore, descrizione)
       values ('S001_INV01','00000000009999999999','S001: RANGE COD_FAM')
       ;
     exception
       when others then
            w_errore := 'errore ins anpinp < '||w_limite||' ('||SQLERRM||')';
            raise errore;
     end;

  elsif w_tot_ana > w_limite then
     w_conta_ana := 0;
     w_conta_inv := 0;
     for rec in sel_ana loop
         w_conta_ana := w_conta_ana + 1;
         if w_conta_ana > w_limite then
            if rec.cod_fam != w_cod_fam_dep then
               w_conta_inv := w_conta_inv + 1;
               begin
                 insert into anpinp (parametro, valore, descrizione)
                 values ('S001_INV'||lpad(w_conta_inv,2,'0'),lpad(w_cod_fam_ini,10,'0')||lpad(w_cod_fam_dep,10,'0'),'S001: RANGE COD_FAM')
                 ;
               exception
                 when others then
                      w_errore := 'errore ins anpinp > '||w_limite||' - '||w_conta_inv||' ('||SQLERRM||')';
                      raise errore;
               end;
               w_conta_ana := 1;
            end if;
         end if;
         if w_conta_ana = 1 then
            w_cod_fam_ini := rec.cod_fam;
         end if;
         w_cod_fam_dep := rec.cod_fam;
     end loop;

--     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_cod_fam_ini '||w_cod_fam_ini||' - w_cod_fam_dep '||w_cod_fam_dep);
     w_conta_inv := w_conta_inv + 1;
     begin
       insert into anpinp (parametro, valore, descrizione)
       values ('S001_INV'||lpad(w_conta_inv,2,'0'),lpad(w_cod_fam_ini,10,'0')||lpad('9',10,'9'),'S001: RANGE COD_FAM')
       ;
     exception
       when others then
            w_errore := 'errore ins anpinp > '||w_limite||' - '||w_conta_inv||' ('||SQLERRM||')';
            raise errore;
     end;

     begin
       insert into anpinp (parametro, valore, descrizione)
       values ('S001_TOT',w_conta_inv,'S001: TOTALE INVII')
       ;
     exception
       when others then
            w_errore := 'errore ins anpinp > '||w_limite||' - s001_tot ('||SQLERRM||')';
            raise errore;
     end;
  end if;
--COMMIT;
exception
  when errore then
       ROLLBACK;
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       ROLLBACK;
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end ws_s001_parametri;

--function ws_s001_subentro_controlli return clob
procedure ws_s001_subentro_controlli

is

cursor sel_con is
select *
  from anpr_s001_controlli
 order by ads_progr_invio
;


w_fornitura		number;
w_invio			number;
w_tot_invii		number;
w_nome_allegato		varchar2(255);

w_xml_clob		clob;
w_xml			xmltype;

w_servizio_log		varchar2(255) := 'S001';
w_operazione_log	varchar2(255) := 'controlli';
w_errore		varchar2(255);
errore			exception;

begin
  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio');

  for rec in sel_con loop
<< datiFornitura >>
w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<tnsb:subentro '||
                          'xmlns:tns="http://sogei.it/ANPR/tipoDato" '||
                          'xmlns:tnsa="http://sogei.it/ANPR/vocabolarioSubentro" '||
                          'xmlns:tnsb="http://sogei.it/ANPR/subentro" '||
                          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '||
                          'xsi:schemaLocation="http://sogei.it/ANPR/subentro">'||chr(10);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiFornitura','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_versionefornitura,'versioneFornitura','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_totaleinvii,'totaleInvii','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_ntotschedesoggetto,'numeroTotaleSchedeSoggetto','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_ntotcittadiniitaliani,'numeroTotaleCittadiniItaliani','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_ntotiscrittinonitaliani,'numeroTotaleIscrittiNonItaliani','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_ntotpersonesessof,'numeroTotalePersoneSessoFemminile','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_ntotpersonesessom,'numeroTotalePersoneSessoMaschile','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_ntotschedefamiglia,'numeroTotaleSchedeFamiglia','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_for_ntotschedeconvivenza,'numeroTotaleSchedeConvivenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiFornitura','F');

<< datiInvio >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiInvio','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_progressivoinvio,'progressivoInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_dataestrazione,'dataEstrazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_nschedesoggetto,'numeroSchedeSoggettoInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_ncittadiniitaliani,'numeroCittadiniItalianiInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_niscrittinonitaliani,'numeroIscrittiNonItalianiInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_npersonesessof,'numeroPersoneSessoFemminileInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_npersonesessom,'numeroPersoneSessoMaschileInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_ntotschedefamiglia,'numeroTotaleSchedeFamigliaInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.c_inv_ntotschedeconvivenza,'numeroTotaleSchedeConvivenzaInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiInvio','F');

w_xml_clob := w_xml_clob||ws_s001_subentro_soggetti(rec.ads_cod_fam_inizio,rec.ads_cod_fam_fine);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tnsb:subentro','F');

  w_fornitura     := rec.c_for_versionefornitura;
  w_invio         := rec.c_inv_progressivoinvio;
  w_tot_invii     := rec.c_for_totaleinvii;
  w_nome_allegato := w_codice_cliente||'_SUBAPR_'||w_fornitura||'_'||w_invio||'_'||w_tot_invii;
  ANPR_pkg.ins_allegati(w_servizio_log,rec.ads_progr_invio,w_nome_allegato,w_xml_clob);

  end loop;

  ANPR_pkg.valida_xml(w_servizio_log,w_xml_clob);

--  return w_xml_clob;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
--       return w_xml_clob;
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
--       return w_xml_clob;
end ws_s001_subentro_controlli;

function ws_s001_subentro_soggetti
(a_cod_fam_inizio	in	number
,a_cod_fam_fine		in	number
)

return clob

is

cursor sel_ana is
select
-- dati soggetto
       ana.*
     , decode(ana.fascia,3,'S') soggettoAIRE
-- dati famiglia
     , fam.fascia fascia_fam
     , fam.tipo_fam
     , fam.cod_via
     , fam.num_civ
     , fam.suffisso
     , fam.interno
     , fam.sub_interno
     , fam.scala
     , fam.piano
     , fam.flag_metrico
     , fam.progr_snc
     , fam.flag_lettera
     , fam.flag_esponente
     , fam.flag_nui
     , fam.nui
     , fam.colore
     , fam.corte
     , fam.interno2
     , fam.sub_interno2
     , fam.secondario
     , fam.scala_esterna
     , fam.via_aire
     , fam.cod_pro_aire
     , fam.cod_com_aire
     , fam.zipcode
     , fam.presso
     , fam.provincia_contea
     , fam.tipo_convivenza
-- dati evento
     , eve.cod_variazione
     , eve.cod_pro_eve
-- dati coniuge
     , decode(ana_cn.fascia,3,'S') soggettoAIRE_cn
     , ana_cn.fascia fascia_cn
--     , ana_cn.cognome_nome cognome_nome_cn
     , decode(ana_cn.sesso, '',
         decode(ana.stato_civile,'UC',ana.sesso,'VU',ana.sesso,'GU',ana.sesso,
           decode(ana.sesso,'M','F','M')),
         ana_cn.sesso) sesso_cn
     , ana_cn.data_nas data_nas_cn
     , ana_cn.anno_nas anno_nas_cn
     , ana_cn.cod_pro_nas cod_pro_nas_cn
     , ana_cn.cod_com_nas cod_com_nas_cn
     , ana_cn.stato_civile stato_civile_cn
     , ana_cn.nazionalita nazionalita_cn
     , ana_cn.data_inizio_naz data_inizio_naz_cn
     , ana_cn.cod_prof cod_prof_cn
     , ana_cn.posizione_prof posizione_prof_cn
     , ana_cn.titolo_studio titolo_studio_cn
     , ana_cn.cod_fiscale cod_fiscale_cn
-- dati paternita
     , decode(ana_pd.fascia,3,'S') soggettoAIRE_pd
     , ana_pd.fascia fascia_pd
     , ana_pd.cognome_nome cognome_nome_pd
     , ana_pd.sesso sesso_pd
     , ana_pd.data_nas data_nas_pd
     , ana_pd.anno_nas anno_nas_pd
     , ana_pd.cod_pro_nas cod_pro_nas_pd
     , ana_pd.cod_com_nas cod_com_nas_pd
     , ana_pd.stato_civile stato_civile_pd
     , ana_pd.nazionalita nazionalita_pd
     , ana_pd.data_inizio_naz data_inizio_naz_pd
     , ana_pd.cod_prof cod_prof_pd
     , ana_pd.posizione_prof posizione_prof_pd
     , ana_pd.titolo_studio titolo_studio_pd
     , ana_pd.cod_fiscale cod_fiscale_pd
-- dati maternita
     , decode(ana_md.fascia,3,'S') soggettoAIRE_md
     , ana_md.fascia fascia_md
     , ana_md.cognome_nome cognome_nome_md
     , ana_md.sesso sesso_md
     , ana_md.data_nas data_nas_md
     , ana_md.anno_nas anno_nas_md
     , ana_md.cod_pro_nas cod_pro_nas_md
     , ana_md.cod_com_nas cod_com_nas_md
     , ana_md.stato_civile stato_civile_md
     , ana_md.nazionalita nazionalita_md
     , ana_md.data_inizio_naz data_inizio_naz_md
     , ana_md.cod_prof cod_prof_md
     , ana_md.posizione_prof posizione_prof_md
     , ana_md.titolo_studio titolo_studio_md
     , ana_md.cod_fiscale cod_fiscale_md
  from anadrp drp
     , anaana ana_cn
     , anaana ana_md
     , anaana ana_pd
     , anaeve eve
     , anafam fam
     , anpr_s001_soggetti ana
 where drp.cod_rp       (+) = ana.rapporto_par
   and drp.sesso        (+) = ana.sesso
   and ana_cn.matricola (+) = ana.matricola_cn
   and ana_md.matricola (+) = ana.matricola_md
   and ana_pd.matricola (+) = ana.matricola_pd
   and eve.matricola    (+) = ana.matricola
   and eve.cod_mov      (+) = ana.fascia
   and eve.cod_eve      (+) = ana.stato
   and eve.data_eve     (+) = ana.data_ult_eve
   and fam.cod_fam          = ana.cod_fam
   and fam.fascia           = ana.fascia
   and ana.fascia + 0       = 1
   and ana.cod_fam	    between a_cod_fam_inizio and a_cod_fam_fine
--   and ana.matricola        between 1 and 1000
--   and ana.matricola        between 1000 and 1099
 order by ana.cod_fam, nvl(drp.sequenza,99), ana.data_nas, ana.cognome_nome
;

cursor sel_fam is
select fam.*
  from anpr_s001_famiglie fam
 where fam.tipo_fam         is null
   and fam.fascia + 0       = 1
   and fam.cod_fam	    between a_cod_fam_inizio and a_cod_fam_fine
 order by fam.cod_fam
;

cursor sel_conv is
select fam.*
  from anpr_s001_famiglie fam
 where fam.tipo_fam         = 1
   and fam.fascia + 0       = 1
   and fam.cod_fam	    between a_cod_fam_inizio and a_cod_fam_fine
 order by fam.cod_fam
;

w_cod_fam_prec			number := -1;
w_progr_componente		number;

w_cognome 			varchar2(255);
w_cognome_pd			varchar2(255);
w_cognome_md			varchar2(255);
w_cognome_cn                   	varchar2(255);

w_nome 				varchar2(255);
w_nome_pd			varchar2(255);
w_nome_md			varchar2(255);
w_nome_cn			varchar2(255);

w_idSchedaSoggettoANPR		varchar2(255);
w_idSchedaSoggettoANPR_cn	varchar2(255);
w_idSchedaSoggettoANPR_pd	varchar2(255);
w_idSchedaSoggettoANPR_md	varchar2(255);

w_soggettoAIRE			varchar2(255);
w_soggettoAIRE_cn		varchar2(255);
w_soggettoAIRE_pd		varchar2(255);
w_soggettoAIRE_md		varchar2(255);

w_data_atto_rif			number;

w_ordineUnione                  varchar2(255);
w_motivoScioglimento		varchar2(255);

w_data_decorrenza_res           number;
w_data_ultimo_agg               number;

w_tipoIndirizzo			varchar2(255);
w_dataDecorrenzaResidenza	varchar2(255);
w_motivoIscrizioneAPR		varchar2(255);

w_dataPrimaIscrizione           varchar2(255);


w_xml_clob_sog		clob;
w_xml_clob_fam		clob;
w_xml_clob_conv		clob;
w_xml_clob		clob;

w_servizio_log		varchar2(255) := 'S001';
w_operazione_log	varchar2(255) := 'soggetti';
w_errore		varchar2(255);
errore			exception;

w_step			number;

begin
  ANPR_pkg.DATI_CLIENTE;

  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'da cod_fam '||a_cod_fam_inizio||' a cod_fam '||a_cod_fam_fine||' - inizio');

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaSoggetti','I');
  for rec in sel_ana loop
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'cod_fam '||rec.cod_fam||' - matricola '||rec.matricola);

      w_cognome                 := f_cognome(rec.cognome_nome);
      w_nome                    := f_nome(rec.cognome_nome);

      if rec.cognome_nome_pd is not null then
         w_cognome_pd		:= f_cognome(rec.cognome_nome_pd);
         w_nome_pd		:= f_nome(rec.cognome_nome_pd);
      elsif rec.paternita is not null then
         w_cognome_pd 		:= f_cognome_pd('',rec.paternita,rec.cognome_nome);
         w_nome_pd 		:= f_nome_pd('',rec.paternita,rec.cognome_nome);
      end if;

      if nvl(rec.cognome_nome_md,rec.maternita) is not null then
         w_cognome_md		:= f_cognome(nvl(rec.cognome_nome_md,rec.maternita));
         w_nome_md		:= f_nome(nvl(rec.cognome_nome_md,rec.maternita));
      end if;

      if rec.cognome_nome_cn is not null then
         w_cognome_cn		:= f_cognome(rec.cognome_nome_cn);
         w_nome_cn		:= f_nome(rec.cognome_nome_cn);
      end if;

      w_idSchedaSoggettoANPR    := '';
      w_idSchedaSoggettoANPR_cn := '';
      w_idSchedaSoggettoANPR_pd := '';
      w_idSchedaSoggettoANPR_md := '';

      w_soggettoAIRE            := rec.soggettoAIRE;
      w_soggettoAIRE_cn         := rec.soggettoAIRE_cn;
      w_soggettoAIRE_pd         := rec.soggettoAIRE_pd;
      w_soggettoAIRE_md         := rec.soggettoAIRE_md;

      w_tipoIndirizzo           := f_ANPR_tipo_indirizzo(w_soggettoAIRE,rec.presso);
      w_data_decorrenza_res     := f_ANPR_data_decorrenza_res(rec.matricola,rec.data_inizio_res);
      w_dataDecorrenzaResidenza := f_ANPR_data(w_data_decorrenza_res);

      w_motivoIscrizioneAPR     := f_ANPR_motivo_iscr_APR(rec.fascia,rec.stato,rec.cod_variazione,rec.cod_pro_eve,'CODICE');
      w_dataPrimaIscrizione     := f_ANPR_data(rec.data_ult_eve);

w_step := 1;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','I');

<< generalitaSubIscr >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaSubIscr','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale,rec.matricola);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome,w_nome,rec.sesso,rec.data_nas,rec.anno_nas);
w_step := 2;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,'luogoNascita','N');
w_step := 3;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE,'soggettoAIRE','S');
      if w_idSchedaSoggettoANPR is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola);
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataPrimaIscrizione,'dataPrimaIscrizioneComune','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaSubIscr','F');

<< statoCivile >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile,rec.sesso);

<< attributiSoggetto >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_attributiSoggetto(w_servizio_log,rec.matricola,rec.sospensione,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno);

<< dataUltimoAggiornamento >>
        if rec.data_reg is not null then
           if rec.stato = 17 then
              w_data_ultimo_agg := rec.data_ult_eve;
           else
              w_data_ultimo_agg := rec.data_reg;
           end if;
        else
           if rtrim(w_data_ads) is not null then
              begin
                w_data_ultimo_agg := to_char(to_date(w_data_ads,'dd/mm/yyyy'),'j');
              exception
                when others then
                     w_data_ultimo_agg := '';
              end;
           else
              w_data_ultimo_agg := '';
           end if;
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(w_data_ultimo_agg),'dataUltimoAggiornamento','S');

<< motivoIscrizioneAPR >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoIscrizioneAPR,'motivoIscrizioneAPR');

<< attoNascita>>
        w_data_atto_rif := f_ANPR_data_atto_rif(2,rec.cod_pro_atto_nas,rec.cod_com_atto_nas,rec.cod_pro_nas,rec.cod_com_nas,rec.data_nas,rec.anno_atto_nas);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_nas,rec.cod_com_atto_nas,w_data_atto_rif,rec.anno_atto_nas,rec.ufficio_nas,rec.parte_nas,rec.serie_nas,rec.atto_nas,'attoNascita',rec.atto_nas_digitale);

<< cittadinanza >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita,rec.data_inizio_naz);

<< paternita >>
        if rec.paternita is null and rec.matricola_pd is null then
           goto maternita;
        end if;

w_step := 11.4;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'paternita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_pd,rec.matricola_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_pd,w_nome_pd,nvl(rec.sesso_pd,'M'),rec.data_nas_pd,rec.anno_nas_pd);
w_step := 12;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_pd,rec.cod_com_nas_pd,rec.data_nas_pd,'luogoNascita','N');
w_step := 13;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_pd,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR_pd is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_pd);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_pd,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile_pd,rec.sesso_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_pd,rec.data_inizio_naz_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof_pd,rec.sesso_pd,rec.posizione_prof_pd,rec.titolo_studio_pd);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'paternita','F');

<< maternita >>
        if rec.maternita is null and rec.matricola_md is null then
           goto residenza;
        end if;

w_step := 21;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'maternita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_md,rec.matricola_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_md,w_nome_md,nvl(rec.sesso_md,'F'),rec.data_nas_md,rec.anno_nas_md);
w_step := 22;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_md,rec.cod_com_nas_md,rec.data_nas_md,'luogoNascita','N');
w_step := 23;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_md,'soggettoAIRE','S');
        if w_idSchedaSoggettoANPR_md is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_md);
        end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_md,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_statoCivile(w_servizio_log,rec.stato_civile_md,rec.sesso_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_md,rec.data_inizio_naz_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof_md,rec.sesso_md,rec.posizione_prof_md,rec.titolo_studio_md);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'maternita','F');

<< residenza >>
w_step := 31;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'residenza','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoIndirizzo,'tipoIndirizzo');

      if w_tipoIndirizzo not in ('5','6') then
--w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_indirizzo(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_indirizzo_esteso(w_servizio_log,rec.cod_via,rec.num_civ,rec.suffisso,rec.interno,rec.sub_interno,rec.scala,rec.piano
                                                                                ,rec.flag_metrico,rec.progr_snc,rec.flag_lettera,rec.flag_esponente,rec.flag_nui,rec.nui,rec.colore
                                                                                ,rec.corte,rec.interno2,rec.sub_interno2,rec.secondario,rec.scala_esterna);


      elsif w_tipoIndirizzo in ('5','6') then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_localitaEstera(w_servizio_log,rec.via_aire,rec.zipcode,rec.cod_pro_aire,rec.cod_com_aire,rec.provincia_contea,'','','');
      end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.presso,'presso','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenzaResidenza,'dataDecorrenzaResidenza','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'residenza','F');

<< famiglia_convivenza >>
      if rec.tipo_fam = 1 then
         w_progr_componente := '';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'convivenza','I');
      else
         if rec.cod_fam != w_cod_fam_prec then
            w_progr_componente := 0;
         end if;
         w_progr_componente := w_progr_componente + 1;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'famiglia','I');
      end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,rec.cod_fam,'idFamConvComune','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_legame(w_servizio_log,rec.tipo_fam,rec.fascia,rec.cod_fam,rec.rapporto_par,rec.sesso,rec.data_inizio_fam,w_progr_componente,rec.matricola);
      if rec.tipo_fam = 1 then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'convivenza','F');
      else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'famiglia','F');
      end if;

<< matrimonio >>
      if rec.stato_civile in ('CN','VE','DV','GC') then
         if rec.cognome_nome_cn is null and rec.matricola_cn is null and rec.data_mat is null then
            goto vedovanza;
         end if;
w_step := 41;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'matrimonio','I');

         if rec.cognome_nome_cn is null and rec.matricola_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaCognome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaNome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','F');
            goto datiMatrimonio;
         end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_cn,rec.matricola_cn);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_cn,w_nome_cn,rec.sesso_cn,rec.data_nas_cn,rec.anno_nas_cn);
w_step := 42;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_cn,rec.cod_com_nas_cn,rec.data_nas_cn,'luogoNascita','N');
w_step := 43;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_cn,'soggettoAIRE','S');
         if w_idSchedaSoggettoANPR_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_cn);
         end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_cn,'idSchedaSoggettoANPR','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'coniuge','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_cn,rec.data_inizio_naz_cn);

<< datiMatrimonio >>
         if rec.data_mat is null then
            goto ordineMatrimonio;
         end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMatrimonio','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_mat,rec.anno_mat),'dataEvento','S');
         if nvl(rec.anno_mat,'N') = 'S' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','senzaGiornoMese');
         end if;
w_step := 44;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,'luogoEvento','N');
w_step := 45;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
         if ltrim(rec.cod_pro_atto_mat||rec.cod_com_atto_mat,'0') is not null then
            w_data_atto_rif := f_ANPR_data_atto_rif(4,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,w_data_atto_rif,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoMatrimonio',rec.atto_mat_digitale);
         else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoMatrimonio',rec.atto_mat_digitale);
         end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMatrimonio','F');

<< ordineMatrimonio >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'','ordineMatrimonio','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'matrimonio','F');
      end if;

<< vedovanza >>
      if rec.stato_civile in ('VE') then
         if rec.data_ved is null then
            goto divorzio;
         end if;
w_step := 51;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'vedovanza','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMorteconiuge','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_ved),'dataEvento');
w_step := 52;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,'luogoEvento','N');
w_step := 53;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
         if ltrim(rec.cod_pro_atto_ved||rec.cod_com_atto_ved,'0') is not null then
           w_data_atto_rif := f_ANPR_data_atto_rif(5,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,w_data_atto_rif,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoMorteConiuge',rec.atto_ved_digitale);
         else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoMorteConiuge',rec.atto_ved_digitale);
         end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiMorteconiuge','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'','ordineMatrimonioPrecedente','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'vedovanza','F');
      end if;

<< divorzio >>
      if rec.stato_civile in ('DV','GC') and nvl(rec.data_div,rec.data_div_ann) is not null then
         if rec.data_div is null and rec.data_div_ann is null then
            goto cartaIdentita;
         end if;
w_step := 61;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'separazioneAnnullamentoCessazioneMatrimonio','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_divorzio(w_servizio_log,rec.matricola,rec.data_div,rec.data_div_ann);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_div,rec.cod_com_atto_div,nvl(rec.data_div_ann,rec.data_div),rec.anno_atto_div,rec.ufficio_div,rec.parte_div,rec.serie_div,rec.atto_div,'attoAnnullamentoMatrimonio',rec.atto_div_digitale);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'separazioneAnnullamentoCessazioneMatrimonio','F');
      end if;

w_step := 71;
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step);
<< cartaIdentita >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cartaIdentita(w_servizio_log,rec.matricola);

<< permessoSoggiorno >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_permessoSoggiorno(w_servizio_log,rec.matricola);

<< listaElettorale >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_listaElettorale(w_servizio_log,rec.matricola);

<< listaLeva >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_listaLeva(w_servizio_log,rec.matricola);

<< censimento >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_censimento(w_servizio_log,rec.anno_cens,rec.sezione_cens,rec.foglio_cens,rec.questionario_cens,'');

<< autoveicoli >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_autoveicoli(w_servizio_log,rec.matricola);

<< altriDati >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_altriDati(w_servizio_log,rec.cod_prof,rec.sesso,rec.posizione_prof,rec.titolo_studio);

<< unioneCivile >>
        if rec.stato_civile in ('UC','VU','GU') then
           if rec.cognome_nome_cn is null and rec.matricola_cn is null and rec.data_mat is null then
              goto convivenzaDiFatto;
           end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unioneCivile','I');

           if rec.cognome_nome_cn is null and rec.matricola_cn is null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaCognome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,1,'senzaNome','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','F');
              goto attoUnione;
           end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_cn,rec.matricola_cn);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_cn,w_nome_cn,rec.sesso_cn,rec.data_nas_cn,rec.anno_nas_cn);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_cn,rec.cod_com_nas_cn,rec.data_nas_cn,'luogoNascita','N');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_cn,'soggettoAIRE','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_cn);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unitoCivilmente','F');

<< attoUnione >>
          if rec.data_mat is null then
             goto scioglimentoUnione;
          end if;

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'attoUnione','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_mat,rec.anno_mat),'dataEvento','S');
          if nvl(rec.anno_mat,'N') = 'S' then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,'1','senzaGiornoMese');
          end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,'luogoEvento','N');
          if ltrim(rec.cod_pro_atto_mat||rec.cod_com_atto_mat,'0') is not null then
             w_data_atto_rif := f_ANPR_data_atto_rif(4,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_mat,rec.cod_com_atto_mat,w_data_atto_rif,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoUnione',rec.atto_mat_digitale);
          else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_mat,rec.cod_com_mat,rec.data_mat,rec.anno_atto_mat,rec.ufficio_mat,rec.parte_mat,rec.serie_mat,rec.atto_mat,'attoUnione',rec.atto_mat_digitale);
          end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'attoUnione','F');

<< scioglimentoUnione >>
          if rec.stato_civile in ('VU','GU') then
             if rec.stato_civile = 'VU' and rec.data_ved is not null then
                w_motivoScioglimento := '98';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoScioglimento,'motivoScioglimento','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(rec.data_ved),'dataEvento');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,'luogoEvento','N');
                if ltrim(rec.cod_pro_atto_ved||rec.cod_com_atto_ved,'0') is not null then
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_ved,rec.cod_com_atto_ved,'',rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoScioglimentoUnione',rec.atto_ved_digitale);
                else
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_ved,rec.cod_com_ved,rec.data_ved,rec.anno_atto_ved,rec.ufficio_ved,rec.parte_ved,rec.serie_ved,rec.atto_ved,'attoScioglimentoUnione',rec.atto_ved_digitale);
                end if;
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','F');

             elsif rec.stato_civile = 'GU' and nvl(rec.data_div,rec.data_div_ann) is not null then
                w_motivoScioglimento := '1';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoScioglimento,'motivoScioglimento','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_divorzio(w_servizio_log,rec.matricola,rec.data_div,rec.data_div_ann,rec.stato_civile);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','I');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,f_ANPR_data(nvl(rec.data_div,rec.data_div_ann)),'dataEvento');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_div,rec.cod_com_div,rec.data_div,'luogoEvento','N');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_atto_anpr(w_servizio_log,rec.cod_pro_atto_div,rec.cod_com_atto_div,rec.data_div,rec.anno_atto_div,rec.ufficio_div,rec.parte_div,rec.serie_div,rec.atto_div,'attoScioglimentoUnione',rec.atto_div_digitale);
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'datiEvento','F');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'scioglimentoUnione','F');

             end if;
          end if;

<< cittadinanzaUnione >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_cn,rec.data_inizio_naz_cn);

<< ordineUnione >>
          w_ordineUnione := '1';
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_elemento(w_servizio_log,w_ordineUnione,'ordineUnione','S');
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'unioneCivile','F');
      end if;

<< convivenzaDiFatto >>
w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_convivenzaDiFatto(w_servizio_log,rec.matricola,'','','CDF_I');

w_xml_clob_sog := w_xml_clob_sog||ANPR_pkg.f_xml_tag(w_servizio_log,'soggetto','F');

      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'cod_fam '||rec.cod_fam||' - matricola '||rec.matricola,w_xml_clob_sog);
w_xml_clob := w_xml_clob||w_xml_clob_sog;

      ANPR_pkg.ins_anpads(w_servizio_log, rec.matricola, '', '', '', '', 'Individuale', 'S', w_xml_clob_sog);
      w_cod_fam_prec := rec.cod_fam;
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalitaSoggetti','F');

<< famiglie >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'famiglie','I');
  for rec in sel_fam loop
w_xml_clob_fam := ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,rec.tipo_convivenza,'','');
w_xml_clob := w_xml_clob||w_xml_clob_fam;

      ANPR_pkg.ins_anpads(w_servizio_log, '', '', rec.fascia, rec.tipo_fam, rec.cod_fam, 'Famiglia', 'S', w_xml_clob_fam);
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'famiglie','F');

<< convivenze >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'convivenze','I');
  for rec in sel_conv loop
w_xml_clob_conv := ANPR_pkg.f_xml_idFamConvComune(w_servizio_log,rec.fascia,rec.cod_fam,rec.tipo_fam,rec.tipo_convivenza,rec.matricola_intestatario,rec.data_intestatario);
w_xml_clob := w_xml_clob||w_xml_clob_conv;

      ANPR_pkg.ins_anpads(w_servizio_log, '', '', rec.fascia, rec.tipo_fam, rec.cod_fam, 'Convivenza', 'S', w_xml_clob_fam);
  end loop;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'convivenze','F');

  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'da cod_fam '||a_cod_fam_inizio||' a cod_fam '||a_cod_fam_fine||' - fine');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end ws_s001_subentro_soggetti;

function f_xml_testataRichiesta
(a_servizio 		varchar2
,a_id_operazione	varchar2
,a_tipo_operazione	varchar2
,a_protocollo		varchar2
,a_data_protocollo	number
,a_data_decorrenza	number
,a_data_definizione	number
,a_cod_mov 		number default null
,a_cod_eve 		number default null
)

return CLOB

is

w_idOperazione			varchar2(255) := a_id_operazione;
--w_codDestinatario		varchar2(255) := nvl(f_ANPR_valore_inp('COD_DEST',1,10,'X','S'),'ANPR00');
w_operazioneRichiesta		varchar2(255) := a_servizio;
w_dataOraRichiesta		varchar2(255) := to_char(sysdate,'yyyy-mm-dd"T"hh24:mi:ss');
w_tipoOperazione		varchar2(255) := nvl(a_tipo_operazione,'C');	-- C = richiesta del cittadino
                                                                                -- V = variazione per correzioni di errori o anomalie dei dati
                                                                                -- R = rettifica di una precedente operazione
w_protocolloComune		varchar2(255) := a_protocollo;
w_dataProtocolloComune		varchar2(255) := f_ANPR_data(a_data_protocollo);
w_dataDecorrenza		varchar2(255) := f_ANPR_data(a_data_decorrenza);
w_dataDefinizionePratica	varchar2(255) := f_ANPR_data(a_data_definizione);

w_parametro_1014		varchar2(255);
w_valore_1014		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_testataRichiesta';
w_errore		varchar2(255);
errore			exception;

begin
  ANPR_pkg.DATI_CLIENTE;

  w_parametro_1014 := '';
  w_valore_1014    := '';
  if a_cod_mov||a_cod_eve is not null and a_cod_eve not in (1,50) then
     if a_cod_mov = 1 then
         w_parametro_1014 := '1014_RES_I';
     elsif a_cod_mov = 2 then
         w_parametro_1014 := '1014_RES_C';
     elsif a_cod_mov = 3 then
         w_parametro_1014 := '1014_AIR_I';
     elsif a_cod_mov = 4 then
         w_parametro_1014 := '1014_AIR_C';
     end if;
     w_valore_1014 := f_ANPR_valore_inp(w_parametro_1014,1,1,'X','S');
  end if;

  if nvl(w_valore_1014,'N') = 'S' then
     w_dataDefinizionePratica := '';
  elsif a_data_decorrenza is not null and a_data_definizione is not null then
     if a_data_definizione < a_data_decorrenza then
        w_dataDefinizionePratica := f_ANPR_data(a_data_decorrenza);
     end if;
  end if;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'testataRichiesta','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idOperazione,'idOperazioneComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'codMittente','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codDestinatario,'codDestinatario','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_operazioneRichiesta,'operazioneRichiesta','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataOraRichiesta,'dataOraRichiesta','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoOperazione,'tipoOperazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_protocolloComune,'protocolloComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataProtocolloComune,'dataProtocolloComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipo_invio,'tipoInvio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenza,'dataDecorrenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDefinizionePratica,'dataDefinizionePratica','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_nome_applicativo,'nomeApplicativo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_versione_applicativo,'versioneApplicativo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_fornitore_applicativo,'fornitoreApplicativo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'testataRichiesta','F');

  return w_xml_clob;

end f_xml_testataRichiesta;

function f_xml_datiOperazione
(a_servizio 		varchar2
,a_id_operazione	varchar2
,a_protocollo		varchar2
,a_data_protocollo	number
,a_id_operazione_anpr	varchar2
)

return CLOB

is

w_operazioneRichiesta		varchar2(255) := a_servizio;
w_idOperazioneComune		varchar2(255) := a_id_operazione;
w_protocolloComune		varchar2(255) := a_protocollo;
w_dataProtocolloComune		varchar2(255) := f_ANPR_data(a_data_protocollo);
w_idOperazioneANPR		varchar2(255) := a_id_operazione_anpr;
w_dataOperazione		varchar2(255);
w_motivoRichiesta		varchar2(255);
w_noteOperazione                varchar2(255);
w_dataDecorrenza		varchar2(255) := to_char(sysdate,'yyyy-mm-dd');

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_datiOperazione';
w_errore		varchar2(255);
errore			exception;

begin
  ANPR_pkg.DATI_CLIENTE;

  if substr(a_servizio,1,1) = '1' then
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'datiOperazione','I');
  elsif a_servizio in ('A001','A002') then
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'datiOperazione','I');
  else
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'datiOperazioneDaAnnullare','I');
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_operazioneRichiesta,'operazioneRichiesta','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idOperazioneComune,'idOperazioneComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_protocolloComune,'protocolloComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataProtocolloComune,'dataProtocolloComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idOperazioneANPR,'idOperazioneANPR','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataOperazione,'dataOperazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoRichiesta,'motivoRichiesta','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_noteOperazione,'noteOperazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenza,'dataDecorrenza','S');
  if substr(a_servizio,1,1) = '1' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiOperazione','F');
  elsif a_servizio in ('A001','A002') then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiOperazione','F');
  else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiOperazioneDaAnnullare','F');
  end if;


  return w_xml_clob;

end f_xml_datiOperazione;

function f_xml_tag
(a_servizio 	varchar2
,a_tag 		varchar2
,a_tipo_tag	varchar2)

return clob

is

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_tag';
w_errore		varchar2(255);
errore			exception;


begin
  if upper(nvl(a_tipo_tag,'I')) = 'I' then
w_xml_clob := '<'||a_tag||'>'||chr(10);
  elsif upper(nvl(a_tipo_tag,'I')) = 'F' then
w_xml_clob := '</'||a_tag||'>'||chr(10);
  end if;

  return w_xml_clob;
end f_xml_tag;

function f_xml_elemento
(a_servizio 	varchar2
,a_valore 	varchar2
,a_tag 		varchar2
,a_check_null	varchar2 default NULL)

return clob

is

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_elemento';
w_errore		varchar2(255);
errore			exception;

begin
  if upper(nvl(a_check_null,'N')) = 'S' and a_valore is null then
     goto fine;
  end if;

w_xml_clob := '<'||a_tag||'>'||a_valore||'</'||a_tag||'>'||chr(10);

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_elemento;

function f_xml_codiceFiscale
(a_servizio		varchar2
,a_codice_fiscale	varchar2
,a_matricola		number
,a_cf_calcolato         varchar2 default null
)

return clob

is

w_codFiscale			varchar2(255) := a_codice_fiscale;
w_validitaCF			varchar2(255) := '';
w_dataAttribuzioneValidita	varchar2(255) := '';

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_codiceFiscale';
w_errore		varchar2(255);
errore			exception;

begin
  if a_codice_fiscale is null then
     goto fine;
  end if;

  if a_cf_calcolato is not null and a_servizio not in ('1001','1002') then
     goto fine;
  end if;

  if a_servizio = 'S001' and length(a_codice_fiscale) not in (11,16) then
     goto fine;
  end if;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'codiceFiscale','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codFiscale,'codFiscale','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_validitaCF,'validitaCF','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataAttribuzioneValidita,'dataAttribuzioneValidita','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'codiceFiscale','F');

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_codiceFiscale;

function f_xml_generalita
(a_servizio		varchar2
,a_cognome		varchar2
,a_nome			varchar2
,a_sesso		varchar2
,a_data_nas		number
,a_anno_nas		varchar2
)

return clob

is

w_cognome		varchar2(255) := a_cognome;
w_senzaCognome		varchar2(255) := '';
w_nome			varchar2(255) := a_nome;
w_senzaNome		varchar2(255) := '';
w_dataNascita		varchar2(255) := '';
w_senzaGiorno		varchar2(255) := '';
w_senzaGiornoMese	varchar2(255) := '';

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_generalita';
w_errore		varchar2(255);
errore			exception;

begin
  w_cognome     := rtrim(f_ANPR_stringa(w_cognome));
  if w_cognome is null then
     w_senzaCognome := 1;
  end if;
  w_nome        := rtrim(f_ANPR_stringa(w_nome));
  if w_nome is null then
     w_senzaNome := 1;
  end if;
  w_dataNascita := f_ANPR_data(a_data_nas, a_anno_nas);
  if nvl(a_anno_nas,'N') = 'S' then
     w_senzaGiornoMese := 1;
  end if;

w_xml_clob := ANPR_pkg.f_xml_elemento(w_servizio_log,w_cognome,'cognome','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_senzaCognome,'senzaCognome','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_nome,'nome','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_senzaNome,'senzaNome','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_sesso,'sesso','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataNascita,'dataNascita','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_senzaGiorno,'senzaGiorno','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_senzaGiornoMese,'senzaGiornoMese','S');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_generalita;

function f_xml_luogoEvento
(a_servizio		varchar2
,a_cod_provincia	number
,a_cod_comune		number
,a_data_rif		number
,a_tag			varchar2
,a_flag_comune		varchar2
,a_provincia_contea	varchar2 	default NULL
)

return clob

is

w_cod_provincia         number;
w_cod_comune            number;

w_luogoEccezionale	varchar2(255);
w_nomeComune		varchar2(255);
w_codiceIstat		varchar2(255);
w_siglaProIstat		varchar2(255);
w_desLocalita		varchar2(255);
w_descrizioneStato	varchar2(255);
w_codiceStato		varchar2(255);
w_provinciaContea	varchar2(255) := a_provincia_contea;

w_tag_comune		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_luogoEvento';
w_errore		varchar2(255);
errore			exception;

begin
  w_luogoEccezionale := f_ANPR_luogo(a_cod_provincia,a_cod_comune,a_data_rif,1,1);
  w_nomeComune       := f_ANPR_luogo(a_cod_provincia,a_cod_comune,a_data_rif,2,1);
  w_desLocalita      := f_ANPR_luogo(a_cod_provincia,a_cod_comune,a_data_rif,3,1);
  w_luogoEccezionale := rtrim(f_ANPR_stringa(w_luogoEccezionale));
  w_nomeComune       := rtrim(f_ANPR_stringa(w_nomeComune));
  w_desLocalita      := rtrim(f_ANPR_stringa(w_desLocalita));


  if w_luogoEccezionale is null and w_nomeComune is null and w_desLocalita is null then
     goto fine;
  end if;

  if nvl(a_flag_comune,'N') = 'S' then
     w_tag_comune := a_tag;
     goto comune;
  else
     w_tag_comune := 'comune';
  end if;

<< tag_I >>
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,a_tag,'I');

  if w_luogoEccezionale is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_luogoEccezionale,'luogoEccezionale');
     goto tag_F;
  end if;

<< comune >>
  if w_nomeComune is not null then
     w_codiceIstat   := f_ANPR_luogo(a_cod_provincia,a_cod_comune,a_data_rif,2,2);
     w_siglaProIstat := f_ANPR_luogo(a_cod_provincia,a_cod_comune,a_data_rif,2,3);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag_comune,'I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_nomeComune,'nomeComune');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceIstat,'codiceIstat');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_siglaProIstat,'siglaProvinciaIstat');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag_comune,'F');
     goto tag_F;
  end if;

  if w_desLocalita is not null then
     if upper(a_tag) like '%NASCITA%' then
        begin
          select nvl(codice_min,codice), 0
            into w_cod_provincia, w_cod_comune
            from anpt02
           where codice = a_cod_provincia
          ;
        exception
          when others then
               w_cod_provincia := a_cod_provincia;
               w_cod_comune    := a_cod_Comune;
        end;
     else
        w_cod_provincia := a_cod_provincia;
        w_cod_comune    := a_cod_Comune;
     end if;
     w_descrizioneStato := f_ANPR_luogo(w_cod_provincia,w_cod_comune,a_data_rif,3,2);
     w_descrizioneStato := f_ANPR_stringa(w_descrizioneStato);
     w_codiceStato      := f_ANPR_luogo(w_cod_provincia,w_cod_comune,a_data_rif,3,3);
     w_provinciaContea	:= f_ANPR_stringa(a_provincia_contea);
     if a_tag != 'localita' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'localita','I');
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_desLocalita,'descrizioneLocalita');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_descrizioneStato,'descrizioneStato');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceStato,'codiceStato');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_provinciaContea,'provinciaContea','S');
     if a_tag != 'localita' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'localita','F');
     end if;
     goto tag_F;
  end if;

<< tag_F >>
  if nvl(a_flag_comune,'N') = 'S' then
     goto fine;
  end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,a_tag,'F');

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_luogoEvento;

function f_xml_idSchedaSoggettoComune
(a_servizio		varchar2
,a_matricola		varchar2
)

return clob

is

w_idSchedaSoggetto	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_idSchedaSoggetto';
w_errore		varchar2(255);
errore			exception;

begin
  if a_matricola is null then
     goto fine;
  end if;

  w_idSchedaSoggetto := a_matricola;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'idSchedaSoggettoComune','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'idSchedaSoggettoComuneIstat');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggetto,'idSchedaSoggetto');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'idSchedaSoggettoComune','F');

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_idSchedaSoggettoComune;

function f_xml_statoCivile
(a_servizio		varchar2
,a_stato_civile		varchar2
,a_sesso		varchar2
)

return clob

is

w_statoCivile		varchar2(255);
w_noteStatoCivile	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_statoCivile';
w_errore		varchar2(255);
errore			exception;

begin
  if a_stato_civile is null then
     goto fine;
  end if;

  w_statoCivile := f_ANPR_stato_civile(a_stato_civile,a_sesso);
  if w_statoCivile = 9 then
     begin
       select descrizione
         into w_noteStatoCivile
         from anadsc
        where cod_sc = a_stato_civile
          and sesso  = a_sesso
          and rownum = 1
       ;
     exception
       when others then
            w_noteStatoCivile := 'Non Codificato';
     end;
  end if;
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'statoCivile','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_statoCivile,'statoCivile');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_noteStatoCivile,'noteStatoCivile','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'statoCivile','F');

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_statoCivile;

function f_xml_attributiSoggetto
(a_servizio		varchar2
,a_matricola		number
,a_sospensione		number
,a_cod_via		number
,a_num_civ		number
,a_suffisso		varchar2
,a_interno		number
)

return clob

is

w_senzaFissaDimora		varchar2(255);
w_soggettoCertificabile		varchar2(255);
w_soggettoNonIscrivibile	varchar2(255);
w_interdizioneTutela		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_attributiSoggetto';
w_errore		varchar2(255);
errore			exception;

begin
  if a_matricola is null then
     goto fine;
  end if;

  w_senzaFissaDimora       := f_senza_fissa_dimora(a_cod_via,a_num_civ,a_suffisso,a_interno);
  w_soggettoCertificabile  := f_ANPR_sogg_certificabile(a_sospensione);
--  w_soggettoNonIscrivibile := f_ANPR_sogg_iscrivibile(a_matricola);
--  w_interdizioneTutela     := f_ANPR_interdizione_tutela(a_sospensione);

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'attributiSoggetto','I');
  if a_cod_via||a_num_civ||a_suffisso||a_interno is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_senzaFissaDimora,'senzaFissaDimora','S');
  end if;
  if nvl(a_sospensione,0) >= 0 then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoCertificabile,'soggettoCertificabile','S');
  end if;
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoNonIscrivibile,'soggettoNonIscrivibile','S');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_interdizioneTutela,'interdizioneTutela','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'attributiSoggetto','F');

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_attributiSoggetto;

function f_xml_atto
(a_servizio		varchar2
,a_cod_pro_atto		number
,a_cod_com_atto		number
,a_data_rif		number
,a_anno			number
,a_ufficio		number
,a_parte		number
,a_serie		varchar2
,a_atto			number
,a_tag			varchar2
)

return clob

is

w_tipo_atto		number;
w_tag			varchar2(255);

w_volume		varchar2(255);
w_dataFormazioneAtto	varchar2(255);
w_trascritto		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_atto';
w_errore		varchar2(255);
errore			exception;

begin
  if a_atto is not null and a_parte is not null and nvl(a_anno,0) > 0 and ltrim(a_cod_pro_atto,'0') is not null then
     if a_cod_pro_atto >= 198 then
        if a_cod_pro_atto in (701,702,703) and a_cod_com_atto < 500 then
           goto fine;
        elsif a_cod_pro_atto not in (701,702,703) then
           goto fine;
        end if;
     end if;

     if a_tag = 'attoNascita' then
        w_tipo_atto := 2;
        w_tag       := a_tag;
     elsif a_tag = 'attoMatrimonio' then
        w_tipo_atto := 4;
        w_tag       := 'attoEvento';
     elsif a_tag = 'attoMorteConiuge' then
        w_tipo_atto := 5;
        w_tag       := 'attoEvento';
     elsif a_tag = 'attoAnnullamentoMatrimonio' then
        w_tipo_atto := 4;
        w_tag       := a_tag;
     elsif a_tag = 'attoEvento' and a_servizio in ('2001') then
        w_tipo_atto := 5;
        w_tag       := 'attoEvento';
     elsif a_tag in ('attoUnione','attoScioglimentoUnione') then
        w_tipo_atto := -4;
        w_tag       := 'attoEvento';
     end if;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,a_cod_pro_atto,a_cod_com_atto,a_data_rif,'comuneRegistrazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_ufficio,'ufficioMunicipio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_anno,'anno','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_parte,'parte','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_serie,'serie','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_atto,'numeroAtto','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_volume,'volume','S');

     if a_tag = 'attoAnnullamentoMatrimonio' then
        w_dataFormazioneAtto := f_ANPR_data_formazione_atto(a_cod_pro_atto,a_cod_com_atto,w_tipo_atto,a_ufficio,a_anno,a_parte,a_serie,a_atto);
        if w_dataFormazioneAtto is null then
           w_dataFormazioneAtto := f_ANPR_data(a_data_rif);
        end if;
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataFormazioneAtto,'dataFormazioneAtto','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_trascritto,'trascritto','S');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'F');
  end if;

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_atto;

function f_xml_atto_anpr
(a_servizio		varchar2
,a_cod_pro_atto		number
,a_cod_com_atto		number
,a_data_rif		number
,a_anno			number
,a_ufficio		number
,a_parte		number
,a_serie		varchar2
,a_atto			number
,a_tag			varchar2
,a_id_atto_ansc		varchar2	default null
)

return clob

is

w_tipo_atto		number;
w_tag			varchar2(255);

w_anno             	varchar2(255);
w_ufficioMunicipio	varchar2(255);
w_numeroComunale   	varchar2(255);

w_volume		varchar2(255);
w_dataFormazioneAtto	varchar2(255);
w_trascritto		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_atto_anpr';
w_errore		varchar2(255);
errore			exception;

begin
  if w_codDestinatario < 'ANPR04' then
     w_xml_clob := f_xml_atto(a_servizio,a_cod_pro_atto,a_cod_com_atto,a_data_rif,a_anno,a_ufficio,a_parte,a_serie,a_atto,a_tag);
     goto fine;
  end if;

  if ltrim(a_cod_pro_atto,'0') is not null and 
     ((a_atto is not null and a_parte is not null and nvl(a_anno,0) > 0) 
      or a_id_atto_ansc is not null)
  then
     if a_cod_pro_atto >= 198 then
        if a_cod_pro_atto in (701,702,703) and a_cod_com_atto < 500 then
           goto fine;
        elsif a_cod_pro_atto not in (701,702,703) then
           goto fine;
        end if;
     end if;

     if a_tag = 'attoNascita' then
        w_tipo_atto := 2;
        w_tag       := a_tag;
     elsif a_tag = 'attoMatrimonio' then
        w_tipo_atto := 4;
        w_tag       := 'attoEvento';
     elsif a_tag = 'attoMorteConiuge' then
        w_tipo_atto := 5;
        w_tag       := 'attoEvento';
     elsif a_tag = 'attoAnnullamentoMatrimonio' then
        w_tipo_atto := 4;
        w_tag       := a_tag;
     elsif a_tag = 'attoEvento' and a_servizio in ('2001') then
        w_tipo_atto := 5;
        w_tag       := 'attoEvento';
     elsif a_tag in ('attoUnione','attoScioglimentoUnione') then
        w_tipo_atto := -4;
        w_tag       := 'attoEvento';
     end if;

--w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'I');
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,w_tag||'ANPR','I');

     if a_id_atto_ansc is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'atto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,a_cod_pro_atto,a_cod_com_atto,a_data_rif,'comuneRegistrazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_ufficio,'ufficioMunicipio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_anno,'anno','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_parte,'parte','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_serie,'serie','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_atto,'numeroAtto','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_volume,'volume','S');
     elsif a_id_atto_ansc is not null then
         w_anno             := substr(a_id_atto_ansc,1,4);
         w_ufficioMunicipio := '';
         w_numeroComunale   := substr(a_id_atto_ansc,1,instr(a_id_atto_ansc,'-',-1)-1);
         w_numeroComunale   := substr(w_numeroComunale,instr(w_numeroComunale,'-',-1)+1);
 
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'attoANSC','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,a_id_atto_ansc,'idANSC','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,a_cod_pro_atto,a_cod_com_atto,a_data_rif,'comuneRegistrazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_anno,'anno','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_ufficioMunicipio,'ufficioMunicipio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numeroComunale,'numeroComunale','S');
end if;

     if a_tag = 'attoAnnullamentoMatrimonio' then
        w_dataFormazioneAtto := f_ANPR_data_formazione_atto(a_cod_pro_atto,a_cod_com_atto,w_tipo_atto,a_ufficio,a_anno,a_parte,a_serie,a_atto);
        if w_dataFormazioneAtto is null then
           w_dataFormazioneAtto := f_ANPR_data(a_data_rif);
        end if;
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataFormazioneAtto,'dataFormazioneAtto','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_trascritto,'trascritto','S');

     if a_id_atto_ansc is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'atto','F');
     elsif a_id_atto_ansc is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'attoANSC','F');
     end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag||'ANPR','F');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'F');
  end if;

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_atto_anpr;

function f_xml_cittadinanza
(a_servizio		varchar2
,a_nazionalita		varchar2
,a_data_inizio_naz	number
,a_flag_altra_cit	varchar2	default NULL
)

return clob

is

w_descrizioneStato	varchar2(255);
w_codiceStato		varchar2(255);
w_noteStato		varchar2(255);
w_dataValidita		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_cittadinanza';
w_errore		varchar2(255);
errore			exception;

begin
  if a_nazionalita is null then
     goto fine;
  end if;

  begin
    select 'ITALIA', '100', to_char(null), f_ANPR_data(a_data_inizio_naz)
      into w_descrizioneStato, w_codiceStato, w_noteStato, w_dataValidita
      from dual
     where a_nazionalita = 'I'
    UNION
    select nvl(t02.descrizione,com.descrizione), to_char(dci.ist_ci), decode(dci.ist_ci,'998','Non Attribuibile'), to_char(null)
      from anpt02 t02, arccom com, anadci dci
     where t02.codice        (+) = dci.ist_ci
       and com.cod_provincia (+) = dci.ist_ci
       and com.cod_comune    (+) = 0
       and dci.cod_ci            = a_nazionalita
       and a_nazionalita        != 'I'
       and rownum                = 1
    ;
    w_descrizioneStato := f_ANPR_stringa(w_descrizioneStato);
  exception
    when others then
         w_descrizioneStato := a_nazionalita;
         w_codiceStato      := '';
         w_noteStato        := '';
         w_dataValidita     := f_ANPR_data(a_data_inizio_naz);
  end;

  if w_descrizioneStato is not null and w_codiceStato is not null then
     if a_flag_altra_cit is null then
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'cittadinanza','I');
     else
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'altraCittadinanza','I');
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_descrizioneStato,'descrizioneStato');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceStato,'codiceStato');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_noteStato,'noteStato','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataValidita,'dataValidita','S');
     if a_flag_altra_cit is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'cittadinanza','F');
     else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'altraCittadinanza','F');
     end if;
  end if;

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_cittadinanza;

function f_xml_altriDati
(a_servizio		varchar2
,a_cod_prof		number
,a_sesso		varchar2
,a_posizione_prof	number
,a_titolo_studio	varchar2
)

return clob

is

w_posizioneProfessionale	varchar2(255);
w_condizioneNonProfessionale	varchar2(255);
w_titoloStudio			varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_altriDati';
w_errore		varchar2(255);
errore			exception;

begin
  if a_cod_prof is not null then
     w_condizioneNonProfessionale := f_ANPR_condizione_non_prof(a_cod_prof,a_sesso);
     if w_posizioneProfessionale is not null then
        w_posizioneProfessionale := 0;
     else
        w_posizioneProfessionale := f_ANPR_posizione_prof(a_posizione_prof);
        if w_posizioneProfessionale is null then
           w_posizioneProfessionale := 9;
        end if;
     end if;
  else
     w_posizioneProfessionale := 9;
  end if;

  if a_titolo_studio is not null then
     w_titoloStudio := f_ANPR_titolo_studio(a_titolo_studio);
  else
     w_titoloStudio := 'Z';
  end if;

  if w_posizioneProfessionale||w_condizioneNonProfessionale||w_titoloStudio is null then
     goto fine;
  end if;
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'altriDati','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_posizioneProfessionale,'posizioneProfessionale','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_condizioneNonProfessionale,'condizioneNonProfessionale','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_titoloStudio,'titoloStudio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'altriDati','F');

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_altriDati;

function f_xml_indirizzo
(a_servizio		varchar2
,a_cod_via		number
,a_num_civ		number
,a_suffisso		varchar2
,a_interno		number
,a_sub_interno		varchar2
,a_scala		varchar2
,a_piano		varchar2
,a_tag 			varchar2 	default null
)

return clob

is

w_tag_indirizzo		varchar2(255);

w_des_cod_via		varchar2(255);

w_cap			varchar2(255);
w_nomeComune		varchar2(255);
w_codiceIstat		varchar2(255);
w_siglaProIstat		varchar2(255);
w_frazione		varchar2(255);
w_codSpecie		varchar2(255); -- alternativo a w_specie
w_specie		varchar2(255);
w_specieFonte		varchar2(255);
w_codToponimo           varchar2(255); -- alternativo a w_toponimo
w_toponimo              varchar2(255);
w_toponimoFonte         varchar2(255);
w_codiceCivico		varchar2(255);
w_civicoFonte		varchar2(255);
w_numero		number;
w_lettera		varchar2(255);
w_interno1		number;
w_espInterno1		varchar2(255);
w_scala			varchar2(255);
w_scalaEsterna		varchar2(255);
w_piano			varchar2(255);

w_nui			varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_indirizzo';
w_errore		varchar2(255);
errore			exception;

begin

  begin
    select denom_uff, specie_area, toponimo
      into w_des_cod_via, w_specie, w_toponimo
      from arcvie
     where cod_via = a_cod_via
    ;
  exception
    when others then
         null;
  end;

  w_cap           := f_cap(a_cod_via,a_num_civ,a_suffisso);
  w_nomeComune    := f_ANPR_luogo(w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),2,1);
  w_codiceIstat   := f_ANPR_luogo(w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),2,2);
  w_siglaProIstat := f_ANPR_luogo(w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),2,3);
  if w_specie is null then
     w_specie        := f_specie_area(w_des_cod_via);
  end if;
  if w_toponimo is null then
     w_toponimo      := f_toponimo(w_des_cod_via);
  end if;
  w_toponimo      := rtrim(f_ANPR_stringa(w_toponimo));
  w_numero        := a_num_civ;
  w_lettera       := f_ANPR_stringa(a_suffisso,'/.');
  if nvl(f_ANPR_valore_inp('INTERNONUI',1,1,'X','S'),'N') = 'S' then
     w_interno1	   := '';
     w_espInterno1 := '';
     w_nui	   := a_interno||a_sub_interno;
  else
     w_interno1	   := a_interno;
     w_espInterno1 := a_sub_interno;
     w_nui	   := '';
  end if;
  if nvl(f_valore_inp('GSTR_SCALA',1,1,'X','S'),'N') = 'S' then
     w_scala        := '';
     w_scalaEsterna := f_ANPR_stringa(a_scala,'/.');
  else
     w_scala        := f_ANPR_stringa(a_scala,'/.');
     w_scalaEsterna := '';
  end if;
  w_piano          := f_ANPR_stringa(a_piano,'/.');

  w_frazione       := f_ANPR_frazione(a_cod_via,a_num_civ,a_suffisso);

  w_tag_indirizzo  := nvl(a_tag,'indirizzo');
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,w_tag_indirizzo,'I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cap,'cap');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_frazione,'frazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','I');

  if w_codSpecie is not null then
     w_specieFonte := 1;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codSpecie,'codSpecie');
  else
     w_specieFonte := 2;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_specie,'specie','S');
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_specieFonte,'specieFonte');

  if w_codToponimo is not null then
     w_toponimoFonte := 1;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codToponimo,'codToponimo');
  else
     w_toponimoFonte := 2;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_toponimo,'denominazioneToponimo');
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_toponimoFonte,'toponimoFonte');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'numeroCivico','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceCivico,'codiceCivico','S');

  if w_codiceCivico is not null then
     w_civicoFonte := 1;
  else
     w_civicoFonte := 2;
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_civicoFonte,'civicoFonte');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numero,'numero');
--w_xml_clob := w_xml_clob||<metrico></metrico>||chr(10); -- alternativo a "numero"
--w_xml_clob := w_xml_clob||<progSNC></progSNC>||chr(10);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_lettera,'lettera','S');
--w_xml_clob := w_xml_clob||<esponente1></esponente1>||chr(10);
--w_xml_clob := w_xml_clob||<colore></colore>||chr(10);

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'civicoInterno','I');
--w_xml_clob := w_xml_clob||<corte></corte>||chr(10);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_scala,'scala','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_interno1,'interno1','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_espInterno1,'espInterno1','S');
--w_xml_clob := w_xml_clob||<interno2></interno2>||chr(10);
--w_xml_clob := w_xml_clob||<espInterno2></espInterno2>||chr(10);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_scalaEsterna,'scalaEsterna','S');
--w_xml_clob := w_xml_clob||<secondario></secondario>||chr(10);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_piano,'piano','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_nui,'nui','S');
--w_xml_clob := w_xml_clob||<isolato></isolato>||chr(10);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'civicoInterno','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'numeroCivico','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag_indirizzo,'F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_indirizzo;

function f_xml_indirizzo_esteso
(a_servizio		varchar2
,a_cod_via		number
,a_num_civ		number
,a_suffisso		varchar2
,a_interno		number
,a_sub_interno		varchar2
,a_scala		varchar2
,a_piano		varchar2
,a_flag_metrico 	varchar2
,a_progr_snc 		varchar2
,a_flag_lettera 	varchar2
,a_flag_esponente 	varchar2
,a_flag_nui 		varchar2
,a_nui 			varchar2
,a_colore 		varchar2
,a_corte 		varchar2
,a_interno2 		number
,a_sub_interno2 	varchar2
,a_secondario 		varchar2
,a_scala_esterna 	varchar2 
,a_tag 			varchar2 	default null
)

return clob

is

w_tag_indirizzo		varchar2(255);

w_des_cod_via		varchar2(255);

w_cap			varchar2(255);
w_nomeComune		varchar2(255);
w_codiceIstat		varchar2(255);
w_siglaProIstat		varchar2(255);
w_frazione		varchar2(255);
w_codSpecie		varchar2(255); -- alternativo a w_specie
w_specie		varchar2(255);
w_specieFonte		varchar2(255);
w_codToponimo           varchar2(255); -- alternativo a w_toponimo
w_toponimo              varchar2(255);
w_toponimoFonte         varchar2(255);
w_codiceCivico		varchar2(255);
w_civicoFonte		varchar2(255);
w_numero		number;
w_lettera		varchar2(255);
w_interno1		number;
w_espInterno1		varchar2(255);
w_scala			varchar2(255);
w_scalaEsterna		varchar2(255);
w_piano			varchar2(255);

w_nui			varchar2(255);

w_flag_metrico 		varchar2(255) := upper(a_flag_metrico);
w_flag_lettera 		varchar2(255) := upper(a_flag_lettera);
w_flag_esponente 	varchar2(255) := upper(a_flag_esponente);
w_flag_nui 		varchar2(255) := upper(a_flag_nui);

w_metrico		varchar2(255);
w_progSNC		varchar2(255);
w_esponente1		varchar2(255);
w_colore		varchar2(255);
w_corte			varchar2(255);
w_interno2		varchar2(255);
w_espInterno2		varchar2(255);
w_secondario		varchar2(255);
w_isolato		varchar2(255);


w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_indirizzo';
w_errore		varchar2(255);
errore			exception;

begin

  begin
    select denom_uff, specie_area, toponimo
      into w_des_cod_via, w_specie, w_toponimo
      from arcvie
     where cod_via = a_cod_via
    ;
  exception
    when others then
         null;
  end;

  w_cap           := f_cap(a_cod_via,a_num_civ,a_suffisso);
  w_nomeComune    := f_ANPR_luogo(w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),2,1);
  w_codiceIstat   := f_ANPR_luogo(w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),2,2);
  w_siglaProIstat := f_ANPR_luogo(w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),2,3);

  if w_specie is null then
     w_specie        := f_specie_area(w_des_cod_via);
  end if;

  if w_toponimo is null then
     w_toponimo      := f_toponimo(w_des_cod_via);
  end if;

  w_toponimo      := rtrim(f_ANPR_stringa(w_toponimo));

  if nvl(w_flag_metrico,'N') = 'S' then
     w_numero        := '';
     w_metrico       := a_num_civ;
  else
     w_numero        := a_num_civ;
     w_metrico       := '';
  end if;

  if nvl(w_flag_lettera,'N')||nvl(w_flag_esponente,'N') in ('NN','SN') then
     w_lettera       := f_ANPR_stringa(a_suffisso,'/.');
     w_esponente1    := '';
  elsif nvl(w_flag_lettera,'N')||nvl(w_flag_esponente,'N') = 'NS' then
     w_lettera       := '';
     w_esponente1    := f_ANPR_stringa(a_suffisso,'/.');
  end if;

  if a_interno is not null and a_nui is null then
     if nvl(w_flag_nui,'N') = 'S' or nvl(f_ANPR_valore_inp('INTERNONUI',1,1,'X','S'),'N') = 'S' then
        w_interno1    := '';
        w_espInterno1 := '';
        w_nui         := a_interno||f_ANPR_stringa(a_sub_interno);
     else
        w_interno1    := a_interno;
        w_espInterno1 := f_ANPR_stringa(a_sub_interno);
        w_nui         := '';
     end if;

  else
        w_interno1    := a_interno;
        w_espInterno1 := f_ANPR_stringa(a_sub_interno);
        w_nui         := f_ANPR_stringa(a_nui);
  end if;

  if a_scala is not null and a_scala_esterna is null then
     if nvl(f_valore_inp('GSTR_SCALA',1,1,'X','S'),'N') = 'S' then
        w_scala        := '';
        w_scalaEsterna := f_ANPR_stringa(a_scala,'/.');
     else
        w_scala        := f_ANPR_stringa(a_scala,'/.');
        w_scalaEsterna := '';
     end if;
  else
     w_scala        := f_ANPR_stringa(a_scala,'/.');
     w_scalaEsterna := f_ANPR_stringa(a_scala_esterna,'/.');
  end if;

  w_piano          := f_ANPR_stringa(a_piano,'/.');

  w_frazione       := f_ANPR_frazione(a_cod_via,a_num_civ,a_suffisso);

  w_progSNC        := f_ANPR_stringa(a_progr_snc,'/.');
  w_colore         := f_ANPR_stringa(a_colore,'/.');
  w_corte          := f_ANPR_stringa(a_corte,'/.');
  w_interno2       := f_ANPR_stringa(a_interno2,'/.');
  w_espInterno2    := f_ANPR_stringa(a_sub_interno2,'/.');
  w_secondario     := f_ANPR_stringa(a_secondario,'/.');
  w_isolato        := '';

  w_tag_indirizzo  := nvl(a_tag,'indirizzo');
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,w_tag_indirizzo,'I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cap,'cap');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_frazione,'frazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','I');

  if w_codSpecie is not null then
     w_specieFonte := 1;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codSpecie,'codSpecie');
  else
     w_specieFonte := 2;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_specie,'specie','S');
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_specieFonte,'specieFonte');

  if w_codToponimo is not null then
     w_toponimoFonte := 1;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codToponimo,'codToponimo');
  else
     w_toponimoFonte := 2;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_toponimo,'denominazioneToponimo');
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_toponimoFonte,'toponimoFonte');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'numeroCivico','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceCivico,'codiceCivico','S');

  if w_codiceCivico is not null then
     w_civicoFonte := 1;
  else
     w_civicoFonte := 2;
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_civicoFonte,'civicoFonte');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numero,'numero');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_metrico,'metrico','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_progSNC,'progSNC','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_lettera,'lettera','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_esponente1,'esponente1','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_colore,'colore','S');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'civicoInterno','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_corte,'corte','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_scala,'scala','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_interno1,'interno1','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_espInterno1,'espInterno1','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_interno2,'interno2','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_espInterno2,'espInterno2','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_scalaEsterna,'scalaEsterna','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_secondario,'secondario','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_piano,'piano','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_nui,'nui','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_isolato,'isolato','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'civicoInterno','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'numeroCivico','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag_indirizzo,'F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_indirizzo_esteso;

function f_xml_localitaEstera
(a_servizio		varchar2
,a_via_aire		varchar2
,a_zipcode		varchar2
,a_cod_pro_aire		number
,a_cod_com_aire		number
,a_provincia_contea	varchar2
,a_cod_consolato	number
,a_tipo_consolato	number
,a_stato		number
)

return clob

is

w_cap			varchar2(255);
w_denominazione		varchar2(255);
w_numeroCivico		varchar2(255);
w_codiceConsolato	varchar2(255);
w_descrizioneConsolato	varchar2(255);
w_dataArrivoConsolato	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_localitaEstera';
w_errore		varchar2(255);
errore			exception;

begin
--ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'cod_consolato '||a_cod_consolato||' - tipo '||a_tipo_consolato||' - stato '||a_stato);
  if a_cod_consolato is not null then
     begin
       select lpad(con.cod_consolato,5,'0')||lpad(con.tipo_consolato,2,'0')
            , nvl(t24.sede,con.sede)
         into w_codiceConsolato
            , w_descrizioneConsolato
         from anpt24 t24, arccon con
        where t24.codice (+)     = con.cod_consolato||lpad(con.tipo_consolato,2,'0')
          and con.cod_consolato  = a_cod_consolato
          and con.tipo_consolato = a_tipo_consolato
          and con.stato          = a_stato
          and rownum             = 1
       ;
     exception
       when others then
            w_codiceConsolato      := '';
            w_descrizioneConsolato := '';
     end;
  else
     begin
       select lpad(com.cod_consolato,5,'0')||lpad(com.tipo_consolato,2,'0')
            , nvl(t24.sede,con.sede)
         into w_codiceConsolato
            , w_descrizioneConsolato
         from anpt24 t24, arccon con, arccom com
        where t24.codice (+)     = con.cod_consolato||lpad(con.tipo_consolato,2,'0')
          and con.cod_consolato  = com.cod_consolato
          and con.tipo_consolato = com.tipo_consolato
          and con.stato          = nvl(com.cod_territorio,com.cod_provincia)
          and com.cod_provincia  = a_cod_pro_aire
          and com.cod_comune     = a_cod_com_aire
          and rownum             = 1
       ;
     exception
       when others then
            w_codiceConsolato      := '';
            w_descrizioneConsolato := '';
     end;
  end if;
--ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_cod_consolato '||w_codiceConsolato||' - w_des_consolato '||w_descrizioneConsolato);

  w_cap           := a_zipcode;
-- 14/12/2018: restrizioni secondo la regex ([0-9Ii??????-? -  a-zA-Z\- '/.,()#:])*. ) 
  w_denominazione := f_ANPR_stringa(a_via_aire,'\#() ^"');
  w_numeroCivico  := '';

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'localitaEstera','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'indirizzoEstero','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cap,'cap','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,a_cod_pro_aire,a_cod_com_aire,to_char(sysdate,'j'),'localita','N',a_provincia_contea);

  if w_denominazione||w_numeroCivico is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_denominazione,'denominazione');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numeroCivico,'numeroCivico','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'toponimo','F');
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'indirizzoEstero','F');

  if w_codiceConsolato is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'consolato','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceConsolato,'codiceConsolato','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_descrizioneConsolato,'descrizioneConsolato','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'consolato','F');
  end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'localitaEstera','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_localitaEstera;

function f_xml_idFamConvComune
(a_servizio		varchar2
,a_fascia 		number
,a_cod_fam 		number
,a_tipo_fam		number
,a_tipo_conv		number
,a_matricola_CC		number
,a_data_CC		number
,a_id_operazione	number	default NULL
)

return clob

is

w_tag				varchar2(255);

w_idFamigliaConvivenza          varchar2(255);
w_idFamigliaConvivenzaANPR	varchar2(255);
w_famigliaAire			varchar2(255);
w_dataOrigineFamiglia		varchar2(255);
w_tipoMovimentazione		varchar2(255);
w_motivoCostituzioneFam		varchar2(255);
w_tipoScheda			varchar2(255);
w_presenzaFamCoabitante    	varchar2(255);
w_specieConvivenza		varchar2(255);

w_denominazioneConvivenza	varchar2(255);

w_matricola_CC                  number;
w_cognome_nome_CC               varchar2(255);
w_cognome_CC               	varchar2(255);
w_nome_CC               	varchar2(255);
w_sesso_CC                      varchar2(255);
w_data_nas_CC                   number;
w_anno_nas_CC                   varchar2(255);
w_cod_fiscale_CC                varchar2(255);
w_dataIntestarioConvivenza      varchar2(255);

w_flag_IMAI                     number := 0;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_idFamConvComune';
w_errore		varchar2(255);
errore			exception;

begin
  if a_servizio = 'IMAI' then
     w_flag_IMAI    := 1;
     w_servizio_log := '5001';
  else
     w_flag_IMAI    := 0;
     w_servizio_log := a_servizio;
  end if;

  if w_servizio_log in ('S001','1002') then
     if a_tipo_fam is null then
        w_tag := 'famiglia';
     elsif a_tipo_fam = 1 then
        w_tag := 'convivenza';
     end if;

  elsif w_servizio_log in ('1010') then
     w_tag := 'generalitaSchedaConvivenza';

  elsif w_servizio_log in ('2009') then
     w_tag := 'estremiSchedaConvivenza';

  elsif w_servizio_log in ('5001') then
     w_tag := 'famigliaConvivenza';

  elsif w_servizio_log in ('5005') then
     w_tag := 'generalitaSchedaFamiglia';

  elsif w_servizio_log in ('A001','A002','A006') then
     w_tag := 'famiglia';

  else
     w_tag := 'famConv';
  end if;

  if f_ANPR_no_id_anpr_ws(a_id_operazione,'FAM') is null then
     w_idFamigliaConvivenzaANPR := f_ANPR_id_scheda('','',a_fascia,a_cod_fam,a_tipo_fam);
  end if;
  if a_fascia = 3 then
     w_famigliaAire         := 'S';
     w_idFamigliaConvivenza := 'FE'||lpad(a_cod_fam,7,'0');
  else
     w_famigliaAire         := '';
     w_idFamigliaConvivenza := a_cod_fam;
  end if;
  w_dataOrigineFamiglia   := f_ANPR_data(f_ANPR_data_origine_fam(a_fascia,a_cod_fam));
  w_presenzaFamCoabitante := f_ANPR_fam_coabitante(a_fascia,a_cod_fam);

  if a_tipo_fam is null then
     if a_fascia = 3 then
        w_tipoScheda           := '5';
     else
        w_tipoScheda           := '3';
     end if;
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'I');
     if w_idFamigliaConvivenzaANPR is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'idFamigliaConvivenzaComune','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'idFamigliaConvivenzaComuneIstat');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idFamigliaConvivenza,'idFamigliaConvivenza');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'idFamigliaConvivenzaComune','F');
     else
        if w_codice_cliente = '039010' and w_idFamigliaConvivenzaANPR = 9180948 then	-- Faenza 08/05/2018
           w_tipoScheda           := '5';
        elsif w_codice_cliente = '037054' and w_idFamigliaConvivenzaANPR = 9125641 then	-- SanLazzaro 23/05/2018
           w_tipoScheda           := '5';
        elsif w_codice_cliente = '015192' and w_idFamigliaConvivenzaANPR = 12258863 then	-- SanDonato 24/05/2018
           w_tipoScheda           := '5';
        elsif w_codice_cliente = '012096' and w_idFamigliaConvivenzaANPR = 16296572 then	-- Malnate 10/08/2018
           w_tipoScheda           := '5';
        elsif nvl(w_flag_IMAI,0) = 1 then
           w_tipoScheda           := '5';
        end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idFamigliaConvivenzaANPR,'idFamigliaConvivenzaANPR','S');
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_famigliaAire,'famigliaAire','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataOrigineFamiglia,'dataOrigineFamigliaConvivenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoCostituzioneFam,'motivoCostituzioneFamiglia','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoMovimentazione,'tipoMovimentazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_presenzaFamCoabitante,'presenzaFamigliaCoabitante');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'F');

  elsif a_tipo_fam = 1 then
     begin
       select convivenza
         into w_denominazioneConvivenza
         from anafam
        where cod_fam = a_cod_fam
          and fascia  in (1,2)
          and rownum  = 1
       ;
       w_denominazioneConvivenza := f_ANPR_stringa(w_denominazioneConvivenza);
     exception
       when others then 
            w_denominazioneConvivenza := '';
     end;
     w_tipoScheda           := '4';
     w_specieConvivenza     := a_tipo_conv;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'I');
     if w_idFamigliaConvivenzaANPR is null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'idFamigliaConvivenzaComune','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codice_cliente,'idFamigliaConvivenzaComuneIstat');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idFamigliaConvivenza,'idFamigliaConvivenza');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'idFamigliaConvivenzaComune','F');
     else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idFamigliaConvivenzaANPR,'idFamigliaConvivenzaANPR','S');
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataOrigineFamiglia,'dataOrigineFamigliaConvivenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_denominazioneConvivenza,'denominazioneConvivenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_specieConvivenza,'specieConvivenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoScheda,'tipoScheda');

     if w_servizio_log in ('1001','1002','2009','5001') then
        goto tag_F;
     elsif w_servizio_log in ('1010') then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'F');
     end if;

     begin
       select ana.matricola, ana.cognome_nome, ana.sesso, ana.data_nas, ana.anno_nas, ana.cod_fiscale
         into w_matricola_CC, w_cognome_nome_CC, w_sesso_CC, w_data_nas_CC, w_anno_nas_CC, w_cod_fiscale_CC
         from anaana ana
        where ana.matricola = a_matricola_cc
--          and (ana.fascia != 1 or ana.cod_fam != a_cod_fam)
       ;
       w_cognome_CC               := f_cognome(w_cognome_nome_CC);
       w_nome_CC                  := f_nome(w_cognome_nome_CC);
       w_dataIntestarioConvivenza := f_ANPR_data(a_data_CC);
     exception
       when others then
            w_cognome_nome_CC := '';
            w_sesso_CC        := '';
            w_data_nas_CC     := '';
            w_anno_nas_CC     := '';
--            w_errore := 'errore ('||SQLERRM||')';
--            ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
     end;

     if w_cognome_nome_CC is not null then
        if w_servizio_log = '1010' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tutoreIntestatario','I');
        else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tipoTutoreIntestatario','I');
        end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,w_cod_fiscale_CC,w_matricola_CC);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_CC,w_nome_CC,w_sesso_CC,w_data_nas_CC,w_anno_nas_CC);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'generalita','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataIntestarioConvivenza,'dataIntestarioConvivenza','S');
        if w_servizio_log = '1010' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tutoreIntestatario','F');
        else
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'tipoTutoreIntestatario','F');
        end if;
     end if;

<< tag_F >>
     if w_servizio_log != '1010' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'F');
     end if;
  end if;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_idFamConvComune;

function f_xml_divorzio
(a_servizio		varchar2
,a_matricola		number
,a_data_div		number
,a_data_div_ann		number
,a_stato_civile 	varchar2 	default NULL
)

return clob

is

cursor sel_sen is
select sen.ente_provvedimento
     , sen.tipo_sentenza
     , sen.data_decreto
     , sen.numero_decreto
     , sen.data_atto_tr
     , nvl(den.codice_anpr,4) den_codice_anpr
     , com_trib.descrizione des_com_trib
  from arccom com_trib, anaden den, anatse tse, anasen sen
 where com_trib.cod_provincia (+) = sen.cod_pro_trib
   and com_trib.cod_comune    (+) = sen.cod_Com_trib
   and den.cod_en             (+) = sen.ente_provvedimento
   and tse.flag_divorzio          is not null
   and tse.cod_se 	          = sen.tipo_sentenza
   and sen.data_decreto	          in (a_data_div,a_data_div_ann)
   and sen.matricola 	          = a_matricola
   and rownum 		          = 1
UNION
select to_number(null)
     , to_number(null)
     , nvl(a_data_div,a_data_div_ann) --to_number(null)
     , 'N/D' --to_char(null)
     , a_data_div_ann --to_number(null)
     , 9 --to_number(null)
     , 'N/D' --to_char(null)
  from dual
 where not exists (select 'x'
                     from anatse tse, anasen sen
                    where tse.flag_divorzio       is not null
                      and tse.cod_se 	          = sen.tipo_sentenza
                      and sen.data_decreto	  in (a_data_div,a_data_div_ann)
                      and sen.matricola 	  = a_matricola)
;

w_tipoCessazione	varchar2(255) := '';
w_data			varchar2(255) := '';
w_numero		varchar2(255) := '';
w_tipoTribunale		varchar2(255) := '';
w_tribunale		varchar2(255) := '';
w_dataValidita		varchar2(255) := '';

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_divorzio';
w_errore		varchar2(255);
errore			exception;

begin
  for rec in sel_sen loop
      w_tipoCessazione := f_ANPR_tipo_cessazione(rec.ente_provvedimento,rec.tipo_sentenza);

      w_data           := f_ANPR_data(rec.data_decreto);
      w_numero         := f_ANPR_stringa(rec.numero_decreto,'.,-');
      w_tipoTribunale  := rec.den_codice_anpr;
      if w_tipoTribunale is not null then
         w_tribunale   := rec.des_com_trib;
      end if;
      w_dataValidita   := f_ANPR_data(nvl(nvl(nvl(a_data_div_ann,rec.data_atto_tr),rec.data_decreto),a_data_div));

      if nvl(a_stato_civile,'XX') != 'GU' then
w_xml_clob := f_xml_elemento(w_servizio_log,w_tipoCessazione,'tipoCessazione','S');
      end if;

--      if rec.numero_decreto is null or rec.des_com_trib is null then
--         goto salta;
--      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sentenza','I');
w_xml_clob := w_xml_clob||f_xml_elemento(w_servizio_log,w_data,'data','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_servizio_log,w_numero,'numero','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_servizio_log,w_tipoTribunale,'tipoTribunale','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_servizio_log,w_tribunale,'autorita','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_servizio_log,w_dataValidita,'dataValidita','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'sentenza','F');

<< salta >>
null;
  end loop;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_divorzio;

function f_xml_cartaIdentita
(a_servizio		varchar2
,a_matricola		number
,a_id_anadoc 		number default NULL
)

return clob

is

cursor sel_wdi is
select wdi.TIPO_DI
     , wdi.NUMERO_DI
     , wdi.DATA_EMISSIONE_DI
     , wdi.DATA_SCADENZA_DI
     , wdi.FLAG_SCADENZA_ILLIMITATA_DI
     , wdi.ENTE_EMISSIONE_DI
     , wdi.COD_PRO_ENTE_DI
     , wdi.COD_COM_ENTE_DI
     , wdi.NATURA_DI
     , wdi.MOTIVO_DI
     , wdi.VAL_ESPATRIO_DI
     , to_number(null) data_reg_DI
     , wdi.nazionalita
  from anawdi wdi
 where wdi.matricola = a_matricola
   and wdi.numero_di is not null
   and wdi.tipo_di   in ('CI','CE')
   and a_id_anadoc   is null
UNION
select doc.tipo_documento           TIPO_DI
     , doc.numero                   NUMERO_DI
     , doc.data_emissione           DATA_EMISSIONE_DI
     , doc.data_scadenza            DATA_SCADENZA_DI
     , doc.flag_scadenza_illimitata FLAG_SCADENZA_ILLIMITATA_DI
     , doc.ente_emissione           ENTE_EMISSIONE_DI
     , doc.cod_pro_ente             COD_PRO_ENTE_DI
     , doc.cod_com_ente             COD_COM_ENTE_DI
     , doc.natura_documento         NATURA_DI
     , doc.motivo_documento         MOTIVO_DI
     , doc.espatrio                 VAL_ESPATRIO_DI
     , doc.data_reg                 DATA_REG_DI
     , ana.nazionalita              NAZIONALITA
  from anaana ana
     , anadoc doc
 where ana.matricola = doc.matricola
   and doc.numero    is not null
   and doc.id        = a_id_anadoc
;

w_numero		varchar2(255);
w_dataRilascio		varchar2(255);
w_cartaceaElettronica	varchar2(255);
w_interdizioneEspatrio	varchar2(255);

w_sede_consolato_COM    varchar2(255);
w_codiceConsolato	varchar2(255) := '';
w_descrizioneConsolato	varchar2(255) := '';

w_dataScadenza		varchar2(255);

w_dataAnnullamento	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_cartaIdentita';
w_errore		varchar2(255);
errore			exception;

begin
  for rec in sel_wdi loop
      w_numero                := rec.numero_di;
      w_dataRilascio          := f_ANPR_data(rec.data_emissione_di);
      w_dataScadenza          := f_ANPR_data(rec.data_scadenza_di);
      if rec.tipo_di = 'CE' then
         w_cartaceaElettronica   := '1';
      else
         w_cartaceaElettronica   := '0';
      end if;
      if nvl(rec.val_espatrio_di,'N') = 'N' then
         w_interdizioneEspatrio := 'S';
      else
         w_interdizioneEspatrio := 'N';
      end if;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'cartaIdentita','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numero,'numero');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataRilascio,'dataRilascio');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_cartaceaElettronica,'cartaceaElettronica');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_interdizioneEspatrio,'interdizioneEspatrio');

      if rec.cod_pro_ente_di <= 199 then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ente_di,rec.cod_com_ente_di,rec.data_emissione_di,'comuneRilascio','S');
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataScadenza,'dataScadenza','S');

      if rec.natura_DI = 'A' then
         w_dataAnnullamento := f_ANPR_data(rec.data_reg_di);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataAnnullamento,'dataAnnullamento','S');
      end if;

      if rec.cod_pro_ente_di > 199 and rec.nazionalita = 'I' then
         begin
           select nvl(t24.codice,lpad(con.cod_consolato,5,'0')||lpad(con.tipo_consolato,2,'0'))
                , nvl(t24.sede,con.sede)
             into w_codiceConsolato
                , w_descrizioneConsolato
             from anpt24 t24, arccon con, arccom com
            where t24.codice (+)     = con.cod_consolato||lpad(con.tipo_consolato,2,'0')
              and con.sede           like '%'||
                                          decode(instr(com.descrizione,'('),0,
                                            com.descrizione,
                                            rtrim(substr(com.descrizione,1,instr(com.descrizione,'(')-1)))||
                                          '%'
              and con.stato          = nvl(com.cod_territorio,com.cod_provincia)
              and com.cod_provincia  = rec.cod_pro_ente_di
              and com.cod_comune     = rec.cod_com_ente_di
              and rownum             = 1
           ;
         exception
           when others then
                w_codiceConsolato      := '';
                w_descrizioneConsolato := '';
         end;
        
         if w_codiceConsolato is not null and w_descrizioneConsolato is not null then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'consolatoRilascio','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceConsolato,'codiceConsolato');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_descrizioneConsolato,'descrizioneConsolato');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'consolatoRilascio','F');
         end if;
      end if;

<< fine >>
null;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'cartaIdentita','F');
  end loop;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_cartaIdentita;

function f_xml_permessoSoggiorno
(a_servizio		varchar2
,a_matricola		number
,a_id_anadoc 		number default NULL
)

return clob

is

w_tipo_documento		varchar2(255);

cursor sel_str is
select str.TIPO_DS
     , str.NUMERO_DS
     , str.DATA_EMISSIONE_DS
     , str.DATA_SCADENZA_DS
     , str.FLAG_SCADENZA_ILLIMITATA_DS
     , str.ENTE_EMISSIONE_DS
     , str.COD_PRO_ENTE_DS
     , str.COD_COM_ENTE_DS
     , str.NATURA_DS
     , str.MOTIVO_DS
     , pro.descrizione des_pro_ente
  from arcpro pro
     , anastr str
 where pro.cod_provincia (+) = str.cod_pro_ente_ds
   and str.matricola         = a_matricola
   and str.numero_ds         is not null
   and (a_id_anadoc is null or nvl(w_tipo_documento,' ') = 'PP')
UNION
select doc.tipo_documento           TIPO_DS
     , doc.numero                   NUMERO_DS
     , doc.data_emissione           DATA_EMISSIONE_DS
     , doc.data_scadenza            DATA_SCADENZA_DS
     , doc.flag_scadenza_illimitata FLAG_SCADENZA_ILLIMITATA_DS
     , doc.ente_emissione           ENTE_EMISSIONE_DS
     , doc.cod_pro_ente             COD_PRO_ENTE_DS
     , doc.cod_com_ente             COD_COM_ENTE_DS
     , doc.natura_documento         NATURA_DS
     , doc.motivo_documento         MOTIVO_DS
     , pro.descrizione              des_pro_ente
  from arcpro pro
     , anadoc doc
 where pro.cod_provincia (+) = doc.cod_pro_ente
   and doc.numero            is not null
   and doc.id                = a_id_anadoc
   and doc.tipo_documento    not in ('PP')
;

w_numeroSoggiorno		varchar2(255);
w_tipoSoggiorno			varchar2(255);
w_noteSoggiorno			varchar2(255) := '';
w_dataRilascio			varchar2(255);
w_dataScadenza			varchar2(255);
w_questuraRilascioSoggiorno	varchar2(255);
w_numeroPassaporto		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_permessoSoggiorno';
w_errore		varchar2(255);
errore			exception;

begin
  begin
    select tipo_documento 
      into w_tipo_documento
      from anadoc
     where id = a_id_anadoc
    ;
  exception
    when others then
         w_tipo_documento := '';
  end;

  for rec in sel_str loop
      w_numeroSoggiorno       := f_ANPR_stringa(rec.numero_ds,'.,*@');
      w_tipoSoggiorno         := f_ANPR_tipo_soggiorno(rec.tipo_ds);
      w_dataRilascio          := f_ANPR_data(rec.data_emissione_ds);
      w_dataScadenza          := f_ANPR_data(rec.data_scadenza_ds);
      if rec.ente_emissione_ds = 1 then
         w_questuraRilascioSoggiorno := '';
      else
         w_questuraRilascioSoggiorno := rec.des_pro_ente;
      end if;
      w_numeroPassaporto      := f_ANPR_numero_passaporto(a_matricola);
      if w_numeroPassaporto is not null then
         w_numeroPassaporto      := f_ANPR_stringa(w_numeroPassaporto,'.,*@-/+');
      end if;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'permessoSoggiorno','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numeroSoggiorno,'numeroSoggiorno');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoSoggiorno,'tipoSoggiorno');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_noteSoggiorno,'noteSoggiorno','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataRilascio,'dataRilascio','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataScadenza,'dataScadenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_questuraRilascioSoggiorno,'questuraRilascioSoggiorno','S');

      if rec.ente_emissione_ds = 1 then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_ente_ds,rec.cod_com_ente_ds,to_char(sysdate,'j'),'comune','S');
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numeroPassaporto,'numeroPassaporto','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'permessoSoggiorno','F');
  end loop;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_permessoSoggiorno;

function f_xml_listaElettorale
(a_servizio		varchar2
,a_matricola		number
)

return clob

is

w_elettore			varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_listaElettorale';
w_errore		varchar2(255);
errore			exception;

w_cod_dest		varchar2(255) := f_ANPR_valore_inp('COD_DEST',1,10,'X','S');
w_anel_inp		varchar2(255) := nvl(rtrim(f_ANPR_valore_inp('ANEL',1,1,'X','S')),'N');

BEGIN
  if w_cod_dest >= 'ANPR03' and w_anel_inp = 'S' then
     goto fine;
  end if;

  w_elettore                := f_ANPR_elettorale(a_matricola,'ELETTORE');

  if w_elettore is null then
     goto fine;
  end if;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'listaElettorale','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_elettore,'elettore');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,to_char(sysdate,'j'),'comune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaElettorale','F');

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_listaElettorale;

function f_xml_listaLeva
(a_servizio		varchar2
,a_matricola		number
)

return clob

is

cursor sel_ruo is
select ruo.*
     , ana.fascia
  from levruo ruo
     , anaana ana
 where ruo.matricola (+) = ana.matricola
   and ana.sesso         = 'M'
   and ana.matricola	 = a_matricola
;

w_iscritto		varchar2(255);
w_dataiscrizione	varchar2(255);
w_listadiLeva		varchar2(255);
w_annolistadiLeva	varchar2(255);
w_datacancellazione	varchar2(255) := '';
w_tipocancellazione	varchar2(255) := '';
w_notecancellazione	varchar2(255) := '';
w_codiceLista		varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_listaLeva';
w_errore		varchar2(255);
errore			exception;

begin
  for rec in sel_ruo loop
      if rec.numero_lista is not null then
         w_iscritto        := 'S';
         w_listadiLeva     := rec.numero_lista;
         w_annolistadileva := rec.classe;
      else
         w_iscritto        := 'N';
         w_listadiLeva     := '';
         w_annolistadileva := '';
      end if;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'listaLeva','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_iscritto,'iscritto');
     goto tag_F;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataiscrizione,'dataiscrizione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_listadiLeva,'listadiLeva','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_annolistadiLeva,'annolistadiLeva','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_datacancellazione,'datacancellazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipocancellazione,'tipocancellazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_notecancellazione,'notecancellazione','S');
--w_xml_clob := w_xml_clob||<tipoLista>||chr(10);
--w_xml_clob := w_xml_clob||<codiceLista></codiceLista>||chr(10);
--w_xml_clob := w_xml_clob||</tipoLista>||chr(10);

<< tag_F >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'listaLeva','F');
  end loop;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_listaLeva;

function f_xml_censimento
(a_servizio		varchar2
,a_anno_cens		number
,a_sezione_cens		number
,a_foglio_cens		number
,a_questionario_cens	number
,a_data_decorrenza	number
)

return clob

is

w_annoCensimento	varchar2(255) := a_anno_cens;
w_sezioneCensimento 	varchar2(255) := a_sezione_cens;
w_foglioCensimento	varchar2(255) := nvl(a_foglio_cens,a_questionario_cens);

w_dataRegolazioneCens	varchar2(255);
w_motivoRegolazioneCens	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_censimento';
w_errore		varchar2(255);
errore			exception;

begin
  if w_annoCensimento is not null and w_sezioneCensimento is not null then
     w_foglioCensimento := nvl(w_foglioCensimento,0);
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'censimento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_annoCensimento,'annoCensimento');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_sezioneCensimento,'sezioneCensimento');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_foglioCensimento,'foglioCensimento');

     if a_servizio in ('1002','5008') and a_sezione_cens = 0 and a_foglio_cens = 0 then
        w_dataRegolazioneCens   := f_ANPR_data(a_data_decorrenza);
        w_motivoRegolazioneCens := '1';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataRegolazioneCens,'dataRegolazioneCensimento');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoRegolazioneCens,'motivoRegolazioneCensimento');
     end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'censimento','F');
  end if;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_censimento;

function f_xml_autoveicoli
(a_servizio		varchar2
,a_matricola		number
)

return clob

is

w_tag			varchar2(255);

w_possessoAutoveicoli	varchar2(255);
w_possessoPatente	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_autoveicoli';
w_errore		varchar2(255);
errore			exception;

begin
  if a_servizio in ('5008') then
     w_tag := 'autoVeicoli';
  else
     w_tag := 'autoveicoli';
  end if;
  w_possessoAutoveicoli := f_ANPR_possesso_autoveicoli(a_matricola);
  w_possessoPatente     := f_ANPR_possesso_patente(a_matricola);

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_possessoAutoveicoli,'possessoAutoveicoli');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_possessoPatente,'possessoPatente');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,w_tag,'F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_autoveicoli;

function f_xml_legame
(a_servizio		varchar2
,a_tipo_fam		number
,a_fascia		number
,a_cod_fam		number
,a_rapporto_par		varchar2
,a_sesso		varchar2
,a_data_inizio_fam	number
,a_progr_componente	number
,a_matricola		number
)

return clob

is

w_data_decorrenza_fam	number;

w_tipoLegame		varchar2(255);
w_dataDecorrenza	varchar2(255);
w_codiceLegame		varchar2(255);
w_progressivoComponente	varchar2(255) := a_progr_componente;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_legame';
w_errore		varchar2(255);
errore			exception;

begin
  if a_servizio = 'S001' and a_matricola is not null then
     w_data_decorrenza_fam := f_ANPR_data_decorrenza_fam(a_matricola,a_cod_fam,a_data_inizio_fam);
  else
     w_data_decorrenza_fam := a_data_inizio_fam;
  end if;

  w_dataDecorrenza := f_ANPR_data(w_data_decorrenza_fam);

  if a_tipo_fam is null then
     if a_fascia = 3 then
        w_tipoLegame   := 5;
     else
        w_tipoLegame   := 3;
     end if;
     w_codiceLegame := f_ANPR_relazione_parentela(a_rapporto_par,a_sesso);

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'legameSoggetto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoLegame,'tipoLegame');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenza,'dataDecorrenza','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceLegame,'codiceLegame');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_progressivoComponente,'progressivoComponente','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'legameSoggetto','F');

  elsif a_tipo_fam = 1 then
     w_tipoLegame := 4;
     w_codiceLegame := f_ANPR_legame_convivenza(a_rapporto_par,a_sesso);
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'legameSoggetto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_tipoLegame,'tipoLegame');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenza,'dataDecorrenza');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_codiceLegame,'codiceLegame');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'legameSoggetto','F');
  end if;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_legame;

function f_xml_datiDelProcedimento
(a_servizio		varchar2
,a_pratica		number
,a_anno_pratica		number
,a_data_reg		number
,a_anagrafe 		varchar2 	default NULL
,a_tipo_evento 		varchar2 	default NULL
)

return clob

is

w_numeroPraticaComune		varchar2(255);
w_dataDefinizionePratica	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_datiDelProcedimento';
w_errore		varchar2(255);
errore			exception;

begin
  if a_pratica is null then
     goto fine;
  end if;

  w_numeroPraticaComune    := f_ANPR_protocollo(a_pratica,a_anno_pratica,a_anagrafe,a_tipo_evento,'S');
  w_dataDefinizionePratica := f_ANPR_data(a_data_reg);

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'datiDelProcedimento','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_numeroPraticaComune,'numeroPraticaComune','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDefinizionePratica,'dataDefinizionePratica','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiDelProcedimento','F');

<< fine>>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_datiDelProcedimento;

function f_xml_motivoIscrizione
(a_servizio		varchar2
,a_cod_mov 		number
,a_cod_eve 		number
,a_cod_variazione 	varchar2
,a_cod_pro_eve		number
)

return clob

is

w_idMotivo		varchar2(255);
w_note			varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_motivoIscrizione';
w_errore		varchar2(255);
errore			exception;

begin

     w_idMotivo := f_ANPR_motivo_iscr_APR(a_cod_mov,a_cod_eve,a_cod_variazione,a_cod_pro_eve,'CODICE');
     w_note     := f_ANPR_motivo_iscr_APR(a_cod_mov,a_cod_eve,a_cod_variazione,a_cod_pro_eve,'NOTE');

     if a_servizio != '5014' then
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'motivoIscrizione','I');
     end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idMotivo,'idMotivoIscrizione');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_note,'note','S');

     if a_servizio != '5014' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'motivoIscrizione','F');
     end if;

<< fine>>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_motivoIscrizione;

function f_xml_iscrizioneAire
(a_servizio		varchar2
,a_cod_mov 		number
,a_cod_eve 		number
,a_cod_variazione 	varchar2
,a_iniziativa		number
,a_individuazione	number
,a_data_arrivo		number
)

return clob

is

w_motivo		varchar2(255);
w_note			varchar2(255);

w_iniziativaIscrizione			varchar2(255) := a_iniziativa;
w_individuazioneIscrizione		varchar2(255) := a_individuazione;
w_dataArrivoConsolato			varchar2(255) := f_ANPR_data(a_data_arrivo);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_iscrizioneAire';
w_errore		varchar2(255);
errore			exception;

begin
--     ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'parametri', 'a_cod_mov '||a_cod_mov||' a_cod_eve '||a_cod_eve||' a_cod_var '||a_cod_variazione||' a_iniz '||a_iniziativa||' a_indi '||a_individuazione);

     w_motivo   := f_ANPR_motivo_iscr_AIRE(a_cod_mov,a_cod_eve,a_cod_variazione,'CODICE');
     w_note     := f_ANPR_motivo_iscr_AIRE(a_cod_mov,a_cod_eve,a_cod_variazione,'NOTE');
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'iscrizioneAire','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivo,'motivoIscrizione');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_note,'noteMotivoIscrizione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_iniziativaIscrizione,'iniziativaIscrizione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_individuazioneIscrizione,'individuazioneComuneIscrizione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataArrivoConsolato,'dataArrivoConsolato','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'iscrizioneAire','F');

<< fine>>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_iscrizioneAire;

function f_xml_datiCancellazione
(a_servizio		varchar2
,a_cod_mov 		number
,a_cod_eve 		number
,a_cod_variazione 	varchar2
,a_cod_pro_eve		number
,a_data_eve		number
)

return clob

is

w_idMotivo		varchar2(255);
w_note			varchar2(255);
w_dataDecorrenza	varchar2(255);

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_datiCancellazione';
w_errore		varchar2(255);
errore			exception;

begin

  if a_cod_mov in (2,3) then
     w_idMotivo := f_ANPR_motivo_canc_APR(a_cod_mov,a_cod_eve,a_cod_variazione,a_cod_pro_eve,'CODICE');
     w_note     := f_ANPR_motivo_canc_APR(a_cod_mov,a_cod_eve,a_cod_variazione,a_cod_pro_eve,'NOTE');

  elsif a_cod_mov = 4 then
-- caso di cancellazione da AIRE
     w_idMotivo := f_ANPR_motivo_canc_AIRE(a_cod_mov,a_cod_eve,a_cod_variazione,a_cod_pro_eve,'CODICE');
     w_note     := f_ANPR_motivo_canc_AIRE(a_cod_mov,a_cod_eve,a_cod_variazione,a_cod_pro_eve,'NOTE');
  end if;

  if a_servizio = '2001' then
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'motivoCancellazione','I');
     if a_cod_mov = 2 then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idMotivo,'tipoMotivoCancellazione');
     elsif a_cod_mov = 4 then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idMotivo,'tipoMotivoCancellazioneAIRE');
     end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'motivoCancellazione','F');

  elsif a_servizio != '2001' then
     w_dataDecorrenza := f_ANPR_data(a_data_eve);
w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'datiCancellazione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idMotivo,'motivoCancellazione');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_note,'notecancellazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_dataDecorrenza,'dataDecorrenzaCancellazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'datiCancellazione','F');

  end if;

<< fine>>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_datiCancellazione;

function f_xml_convivenzaDiFatto
(a_servizio		varchar2
,a_matricola            number
,a_cod_cdf              number
,a_data_rif             number
,a_archivio_rif         varchar2
)

return clob

is

w_matricola			number;
w_cod_cdf			number;
w_data_rif              	number;
w_archivio_rif			varchar2(255);

w_cognome_cv                   	varchar2(255);
w_nome_cv			varchar2(255);
w_idSchedaSoggettoANPR_cv	varchar2(255);
w_soggettoAIRE_cv		varchar2(255);

w_data_inizio_cdf		number;
w_data_fine_cdf			number;

w_motivoRisoluzione		varchar2(255);

w_data				varchar2(255);
w_data_documento		varchar2(255);
w_data_notifica			varchar2(255);
w_protocollo			varchar2(255);
w_documento			varchar2(255);
w_professionista		varchar2(255);
w_stato				varchar2(255);

cursor sel_cdf is
select cdf.*
     , ana.stato
     , ana.stato_civile
     , decode(ana_cv.fascia,3,'S') soggettoAIRE_cv
     , ana_cv.fascia fascia_cv
     , ana_cv.stato stato_cv
     , ana_cv.sesso sesso_cv
     , ana_cv.data_nas data_nas_cv
     , ana_cv.anno_nas anno_nas_cv
     , ana_cv.cod_pro_nas cod_pro_nas_cv
     , ana_cv.cod_com_nas cod_com_nas_cv
     , ana_cv.stato_civile stato_civile_cv
     , ana_cv.nazionalita nazionalita_cv
     , ana_cv.data_inizio_naz data_inizio_naz_cv
     , ana_cv.cod_prof cod_prof_cv
     , ana_cv.posizione_prof posizione_prof_cv
     , ana_cv.titolo_studio titolo_studio_cv
     , ana_cv.cod_fiscale cod_fiscale_cv
     , f_CDF_contratto_convivenza(cdf.matricola,w_data_rif) contratto_cv
  from anaana ana_cv
     , anaana ana
     , anacdf cdf
 where ana_cv.matricola       = cdf.matricola_cv
   and ana.matricola          = cdf.matricola
   and w_data_rif 	      between cdf.data_inizio and nvl(cdf.data_fine,9999999)
   and nvl(cdf.stato_cdf,'D') in ('I','F')
   and cdf.matricola          = w_matricola
   and w_archivio_rif         like 'MOV%'
   and rownum                 = 1
UNION
select cdf.*
     , ana.stato
     , ana.stato_civile
     , decode(ana_cv.fascia,3,'S') soggettoAIRE_cv
     , ana_cv.fascia fascia_cv
     , ana_cv.stato stato_cv
     , ana_cv.sesso sesso_cv
     , ana_cv.data_nas data_nas_cv
     , ana_cv.anno_nas anno_nas_cv
     , ana_cv.cod_pro_nas cod_pro_nas_cv
     , ana_cv.cod_com_nas cod_com_nas_cv
     , ana_cv.stato_civile stato_civile_cv
     , ana_cv.nazionalita nazionalita_cv
     , ana_cv.data_inizio_naz data_inizio_naz_cv
     , ana_cv.cod_prof cod_prof_cv
     , ana_cv.posizione_prof posizione_prof_cv
     , ana_cv.titolo_studio titolo_studio_cv
     , ana_cv.cod_fiscale cod_fiscale_cv
     , f_CDF_contratto_convivenza(cdf.matricola,w_data_rif) contratto_cv
  from anaana ana_cv
     , anaana ana
     , anacdf cdf
 where ana_cv.matricola       = cdf.matricola_cv
   and ana.matricola          = cdf.matricola
   and cdf.matricola          = w_matricola
   and w_archivio_rif         like 'CDF%'
   and rownum                 = 1
   and ((a_servizio != 'S001' and cdf.cod_cdf = w_cod_cdf)
        or
        (a_servizio = 'S001' and nvl(cdf.stato_cdf,'D') = 'I'))
;

cursor sel_doc_S is
select doc.*
  from anaddo ddo
     , anadoc doc
 where nvl(ddo.flag_cdf,' ')	= 'S'
   and ddo.cod_do	 	= doc.tipo_documento
   and doc.progr_documento	= 1
   and w_data_rif 		between doc.data_emissione and nvl(doc.data_scadenza,9999999)
   and doc.matricola            = w_matricola
   and w_archivio_rif           like 'MOV%'
   and rownum = 1
UNION
select doc.*
  from anaddo ddo
     , anadoc doc
 where nvl(ddo.flag_cdf,' ')	= 'S'
   and ddo.cod_do	 	= doc.tipo_documento
   and doc.progr_documento	= 1
   and doc.data_emissione       between w_data_inizio_cdf and nvl(w_data_fine_cdf,9999999)
   and doc.matricola            = w_matricola
   and w_archivio_rif           = 'CDF_I'
   and rownum = 1
;

cursor sel_doc_R is
select doc.*
  from anaddo ddo
     , anadoc doc
 where nvl(ddo.flag_cdf,' ')	= 'R'
   and ddo.cod_do	 	= doc.tipo_documento
   and doc.progr_documento	= 1
   and doc.natura_documento	= 'O'
   and w_data_rif 		between doc.data_emissione and nvl(doc.data_scadenza,9999999)
   and doc.matricola            = w_matricola
   and w_archivio_rif           like 'MOV%'
   and rownum = 1
UNION
select doc.*
  from anaddo ddo
     , anadoc doc
 where nvl(ddo.flag_cdf,' ')	= 'R'
   and ddo.cod_do	 	= doc.tipo_documento
   and doc.progr_documento	= 1
   and doc.natura_documento	= 'O'
   and doc.data_emissione       between w_data_inizio_cdf and nvl(w_data_fine_cdf,9999999)
   and doc.matricola            = w_matricola
   and w_archivio_rif           = 'CDF_I'
   and rownum = 1
;

w_xml_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'xml_convivenzaDiFatto';
w_errore		varchar2(255);
errore			exception;

begin
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'archivio_rif '||a_archivio_rif||' - matricola '||a_matricola||' - cod_cdf '||a_cod_cdf);
  if a_matricola is null then
     goto fine;
  end if;

  w_matricola    := a_matricola;
  w_data_rif     := nvl(a_data_rif, to_char(sysdate,'j'));
  w_archivio_rif := a_archivio_rif;
  w_cod_cdf      := a_cod_cdf;

  for rec in sel_cdf loop
      w_idSchedaSoggettoANPR_cv := f_ANPR_id_scheda(rec.matricola_cv,'','','','');
      if w_idSchedaSoggettoANPR_cv is null and a_servizio != 'S001' then
         goto fine;
      end if;

      if rec.cognome_nome_cv is not null then
         w_cognome_cv		:= f_cognome(rec.cognome_nome_cv);
         w_nome_cv		:= f_nome(rec.cognome_nome_cv);
      end if;
      w_soggettoAIRE_cv         := rec.soggettoAIRE_cv;

w_xml_clob := ANPR_pkg.f_xml_tag(w_servizio_log,'convivenzaDiFatto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'convivente','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_codiceFiscale(w_servizio_log,rec.cod_fiscale_cv,rec.matricola_cv);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_generalita(w_servizio_log,w_cognome_cv,w_nome_cv,rec.sesso_cv,rec.data_nas_cv,rec.anno_nas_cv);
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_nas_cv,rec.cod_com_nas_cv,rec.data_nas_cv,'luogoNascita','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_soggettoAIRE_cv,'soggettoAIRE','S');

      if w_idSchedaSoggettoANPR_cv is null or a_servizio = 'S001' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_idSchedaSoggettoComune(w_servizio_log,rec.matricola_cv);
      end if;

      if a_servizio != 'S001' then
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_idSchedaSoggettoANPR_cv,'idSchedaSoggettoANPR','S');
      end if;
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'convivente','F');

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_cittadinanza(w_servizio_log,rec.nazionalita_cv,rec.data_inizio_naz_cv);

<< contrattoStipula >>
      if rec.data_inizio is null then
         goto contrattoRisoluzione;
      end if;

      if rec.contratto_cv is not null then
         goto doc_stipula;
      end if;

      if w_archivio_rif = 'CDF_F' then
         goto contrattoRisoluzione;
      end if;

      w_data          := f_ANPR_data(rec.data_inizio);
      w_data_notifica := f_ANPR_data(rec.data_reg);
      w_protocollo    := rec.pratica_inizio;
      if rec.anno_pratica_inizio is not null then
         w_protocollo  := w_protocollo||'-'||rec.anno_pratica_inizio;
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contrattoStipula','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data,'data','S');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data,'dataDocumento','S');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_protocollo,'protocollo','S');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_inizio,rec.cod_com_inizio,rec.data_inizio,'luogoEvento','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_inizio,rec.cod_com_inizio,rec.data_inizio,'comuneRegistrazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contrattoStipula','F');
      goto contrattoRisoluzione;

<< doc_stipula >>

      w_data_inizio_cdf := rec.data_inizio;
      w_data_fine_cdf   := rec.data_fine;
      for rec_S in sel_doc_S loop
          w_data           := f_ANPR_data(w_data_inizio_cdf);
          w_data_documento := f_ANPR_data(rec_S.data_emissione);
          w_data_notifica  := f_ANPR_data(rec_S.data_prov);
          w_protocollo     := rec_S.numero_prov;
          if rec_S.anno_prov is not null then
             w_protocollo  := w_protocollo||'-'||rec_S.anno_prov;
          end if;
          w_professionista := rec_S.autore_emissione;
          w_documento      := '';
          w_stato          := '';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contrattoStipula','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data,'data','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data_notifica,'dataNotifica','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data_documento,'dataDocumento','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_protocollo,'protocollo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_documento,'documento','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec_S.cod_pro_ente,rec_S.cod_com_ente,rec_S.data_emissione,'luogoEvento','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_professionista,'professionista','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,w_data_rif,'comuneRegistrazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_stato,'stato','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contrattoStipula','F');
      end loop;

      goto contrattoRisoluzione;

<< contrattoRisoluzione >>
      if rec.data_fine is null then
         goto salta_sel_doc;
      end if;

      if rec.stato = 50 or rec.stato_cv = 50 then
--         w_motivoRisoluzione := '33';
         w_motivoRisoluzione := '98';
      elsif rec.stato_civile in ('CN','UC') or rec.stato_civile_cv in ('CN','UC') then
         w_motivoRisoluzione := '34';
      else
         w_motivoRisoluzione := '31';
      end if;

      w_data := f_ANPR_data(rec.data_fine);
      w_protocollo     := rec.pratica_fine;
      if rec.anno_pratica_fine is not null then
         w_protocollo  := w_protocollo||'-'||rec.anno_pratica_fine;
      end if;

w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contrattoRisoluzione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_motivoRisoluzione,'motivoRisoluzione');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contratto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data,'data','S');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data,'dataNotifica','S');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_protocollo,'protocollo','S');
--w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec.cod_pro_fine,rec.cod_com_fine,rec.data_fine,'luogoEvento','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contratto','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contrattoRisoluzione','F');

      goto salta_sel_doc;

<< doc_risoluzione >>

      w_data_inizio_cdf := rec.data_inizio;
      w_data_fine_cdf   := rec.data_fine;
      for rec_R in sel_doc_R loop
          w_data           := f_ANPR_data(w_data_fine_cdf);
          w_data_documento := f_ANPR_data(rec_R.data_emissione);
          w_data_notifica  := f_ANPR_data(rec_R.data_prov);
          w_protocollo     := rec_R.numero_prov;
          if rec_R.anno_prov is not null then
             w_protocollo  := w_protocollo||'-'||rec_R.anno_prov;
          end if;
          w_professionista := rec_R.autore_emissione;
          w_documento      := '';
          w_stato          := '';
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contrattoRisoluzione','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contratto','I');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data,'data','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data_notifica,'dataNotifica','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_data_documento,'dataDocumento','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_protocollo,'protocollo','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_documento,'documento','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,rec_R.cod_pro_ente,rec_R.cod_com_ente,rec_R.data_emissione,'luogoEvento','N');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_professionista,'professionista','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_luogoEvento(w_servizio_log,w_cod_pro_cliente,w_cod_com_cliente,w_data_rif,'comuneRegistrazione','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_elemento(w_servizio_log,w_stato,'stato','S');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contratto','F');
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'contrattoRisoluzione','F');
      end loop;

<< salta_sel_doc >>
w_xml_clob := w_xml_clob||ANPR_pkg.f_xml_tag(w_servizio_log,'convivenzaDiFatto','F');

  end loop;

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_convivenzaDiFatto;

function WS_REQUEST
(a_service_url 		varchar2
,a_service_name 	varchar2
,a_service_ns       	varchar2
,a_soap_request		clob
,a_service_timeout  	number default 600
)

return CLOB

IS

w_soap_request		clob	:= a_soap_request;
w_service_timeout  	number	:= a_service_timeout;

rest_request		varchar2(30000);
rest_respond		clob;
http_request		utl_http.req;
http_response		utl_http.resp;

soap_response_30000	varchar2(30000);
soap_response		clob;
soap_response_5000	clob;
soap_response_line	varchar2(32000);

i                	number := 0;

out_xml               	xmltype;
out_xml_clob		clob;

w_step          	number;
w_errore		varchar2(4000);
errore			exception;

begin

w_step := 1;
  utl_http.set_transfer_timeout(w_service_timeout);

w_step := 2;
  http_request:= utl_http.begin_request
                 ( a_service_url
                 , 'POST'
                 , 'HTTP/1.1'
                 );

w_step := 3;
  utl_http.set_persistent_conn_support(http_request, true);

w_step := 4;
  utl_http.set_header(http_request, 'Content-Type', 'text/xml');
w_step := 5;
  utl_http.set_header(http_request, 'Content-Length', length(w_soap_request));
--  utl_http.set_header(http_request, 'SOAPAction', a_service_ns||'/'||a_service_name);

w_step := 6;
  utl_http.write_text(http_request,w_soap_request);

w_step := 7;
  http_response := utl_http.get_response(http_request);

Dbms_Output.Put_Line ( 'Status code: ' || http_response.status_code );
Dbms_Output.Put_Line ( 'Reason phrase: ' || http_response.reason_phrase );

  begin
w_step := 8;
    LOOP
      UTL_HTTP.read_text(http_response, soap_response_30000, 30000);
      soap_response := soap_response||soap_response_30000;
    END LOOP;
w_step := 9;
    UTL_HTTP.end_response(http_response);
  exception
    when UTL_HTTP.end_of_body THEN
         UTL_HTTP.end_response(http_response);
    when others then
         dbms_output.put_line('errore: '||sqlerrm);
  end;

  w_step := 10;
--  soap_response	:= decode_utf8_clob(soap_response);

--ANPR_pkg.ins_log('WS Request', 'response', a_service_url, soap_response);
w_step := 11.5;
  if soap_response like '%Risposta6001OK%certificatoPdf%' and nvl(w_ora_31167,'N') = 'S'then	-- Porto Azzurro
     out_xml_clob       := soap_response;
  elsif soap_response like '%RispostaOKP002%riepilogoRichiesta%' and nvl(w_ora_31167,'N') = 'S'then	-- Valeggio
     out_xml_clob       := soap_response;
  else
     out_xml:= xmltype(soap_response);
w_step := 12;
     out_xml_clob	:= xmltype.getclobval(out_xml);
  end if;

  return out_xml_clob;
exception
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       ANPR_pkg.ins_log('WS Request', a_service_url, w_step||'. '||w_errore);
--       raise_application_error(-20999, 'Request 0 ('||SQLERRM||')');
end WS_REQUEST;

function DECODE_BASE64
(a_clob_in          IN    clob)

return BLOB

IS
v_blob          blob;
v_result          blob;
v_offset          integer;
v_buffer_size       binary_integer := 48;
v_buffer_varchar       varchar2(48);
v_buffer_raw       raw(48);
w_errore         varchar2(4000);
errore         exception;
w_nome_log         varchar2(255) := 'decode B64';
w_step         number;
begin
w_step := 1;
  if a_clob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_blob, true);
w_step := 2;
  v_offset := 1;
--dbms_output.put_line('ceil... '||ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size));
  for i in 1 .. ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size) loop
w_step := 1000000.1 + i;
--dbms_output.put_line(i||') v_buf_size '||v_buffer_size||' - v_off '||v_offset||' - v_buf_chr '||v_buffer_varchar);
      dbms_lob.read(a_clob_in, v_buffer_size, v_offset, v_buffer_varchar);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_raw.cast_to_raw(v_buffer_varchar);
w_step := 1000000.3 + i;
      v_buffer_raw := utl_encode.base64_decode(v_buffer_raw);
w_step := 1000000.4 + i;
--dbms_output.put_line(i||') len '||utl_raw.length(v_buffer_raw)||' - v_buf '||v_buffer_raw);
      dbms_lob.writeappend(v_blob, utl_raw.length(v_buffer_raw), v_buffer_raw);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_buffer_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_blob;
w_step := 4;
  dbms_lob.freetemporary(v_blob);
w_step := 5;
  return v_result;
exception
  when others then
    w_errore := '('||w_step||') exception '||SQLERRM||')';
       anpr_pkg.INS_LOG('',w_nome_log, w_errore);
end decode_base64;

function ENCODE_BASE64
(a_blob_in          IN    blob)

return CLOB

IS
v_clob          clob;
v_result          clob;
v_offset          integer;
v_chunk_size       binary_integer := (48 / 4) * 3;
v_buffer_varchar       varchar2(48);
v_buffer_raw       raw(48);
w_errore         varchar2(4000);
errore         exception;
w_nome_log         varchar2(255) := 'encode B64';
w_step         number;
begin
w_step := 1;
  if a_blob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_clob, true);
w_step := 2;
  v_offset := 1;
  for i in 1 .. ceil(dbms_lob.getlength(a_blob_in) / v_chunk_size) loop
w_step := 1000000.1 + i;
      dbms_lob.read(a_blob_in, v_chunk_size, v_offset, v_buffer_raw);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_encode.base64_encode(v_buffer_raw);
w_step := 1000000.3 + i;
      v_buffer_varchar := utl_raw.cast_to_varchar2(v_buffer_raw);
w_step := 1000000.4 + i;
      dbms_lob.writeappend(v_clob, length(v_buffer_varchar), v_buffer_varchar);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_chunk_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_clob;
w_step := 4;
  dbms_lob.freetemporary(v_clob);
w_step := 5;
  return v_result;
exception
  when others then
    w_errore := '('||w_step||') exception '||SQLERRM||')';
       anpr_pkg.INS_LOG('',w_nome_log, w_errore);
end encode_base64;

function CLOB_TO_BLOB
(a_clob_in          IN    clob)

return BLOB

IS
v_blob            blob;
v_result          blob;
v_offset          integer;
v_buffer_size     binary_integer := 48;
v_buffer_varchar  varchar2(48);
v_buffer_raw      raw(48);

w_errore          varchar2(4000);
errore            exception;

w_nome_log        varchar2(255) := 'clob_to_blob';
w_step            number;

begin
w_step := 1;
  if a_clob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_blob, true);
w_step := 2;
  v_offset := 1;

  for i in 1 .. ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size) loop
w_step := 1000000.1 + i;
      dbms_lob.read(a_clob_in, v_buffer_size, v_offset, v_buffer_varchar);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_raw.cast_to_raw(v_buffer_varchar);
w_step := 1000000.3 + i;
      dbms_lob.writeappend(v_blob, utl_raw.length(v_buffer_raw), v_buffer_raw);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_buffer_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_blob;
w_step := 4;
  dbms_lob.freetemporary(v_blob);
w_step := 5;
  return v_result;
exception
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       anpr_pkg.INS_LOG('',w_nome_log, w_errore);
end clob_to_blob;

function BLOB_TO_CLOB
(a_blob_in          IN    blob)

return CLOB

IS

w_documento_blob           blob := a_blob_in;
w_documento_clob           clob;

w_number_temp              number;
dest_offset                number := 1;
src_offset                 number := 1;
amount                     integer := DBMS_LOB.lobmaxsize;
blob_csid                  number := DBMS_LOB.default_csid;
lang_ctx                   integer := DBMS_LOB.default_lang_ctx;
warning                    integer;

w_errore          varchar2(4000);
errore            exception;

w_nome_log        varchar2(255) := 'blob_to_clob';
w_step            number;

begin
-- Verifica dimensione file caricato
w_step := 1;
  w_number_temp        := DBMS_LOB.getlength (w_documento_blob);
  if nvl (w_number_temp, 0) = 0 then
     w_errore := 'Attenzione File caricato Vuoto - Verificare Client Oracle';
     raise errore;
  end if;

w_step := 2;
-- Trasformazione in CLOB
  begin
    DBMS_LOB.createtemporary (lob_loc =>   w_documento_clob
                             ,cache =>     true
                             ,dur =>       DBMS_LOB.session
                             );
w_step := 3;
    DBMS_LOB.converttoclob (w_documento_clob
                           ,w_documento_blob
                           ,amount
                           ,dest_offset
                           ,src_offset
                           ,blob_csid
                           ,lang_ctx
                           ,warning
                           );
  exception
    when others then
         w_errore := 'Errore in trasformazione Blob in Clob  (' || sqlerrm || ')';
         raise errore;
  end;

  return w_documento_clob;
exception
  when errore then
       anpr_pkg.INS_LOG('',w_nome_log, w_errore);
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       anpr_pkg.INS_LOG('',w_nome_log, w_errore);
end blob_to_clob;

procedure richiesta_notifiche
(a_servizio 		varchar2
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'richiesta_notifiche';

w_id_operazione         number;
w_servizio              varchar2(255);
w_archivio_rif          varchar2(255);

w_conta_richieste	number;

w_errore		varchar2(4000);
errore			exception;

begin
  w_conta_richieste := 1;

<< loop_richieste >>
  w_id_operazione := '';
  if nvl(a_servizio,'N000') = 'N000' then
     if w_conta_richieste = 1 then
        w_servizio     := 'N010';
        w_servizio_log := 'N010';
        w_archivio_rif := 'N10';
     elsif w_conta_richieste = 2 then
        w_servizio     := 'N014';
        w_servizio_log := 'N014';
        w_archivio_rif := 'N14';
     elsif w_conta_richieste = 3 then
        w_servizio     := 'N015';
        w_servizio_log := 'N015';
        w_archivio_rif := 'N15';
     elsif w_conta_richieste = 4 then
        w_servizio     := 'N031';
        w_servizio_log := 'N031';
        w_archivio_rif := 'N31';
--     elsif w_conta_richieste = 4 then
--        w_servizio     := 'N017';
--        w_servizio_log := 'N017';
--        w_archivio_rif := 'N17';
     elsif w_conta_richieste = 5 and a_servizio is null then
        w_servizio     := 'P001';
        w_servizio_log := 'P001';
        w_archivio_rif := 'P01_1-2';
     elsif w_conta_richieste = 6 and a_servizio is null then
        w_servizio     := 'P001';
        w_servizio_log := 'P001';
        w_archivio_rif := 'P01_1-7';
     elsif w_conta_richieste = 7 and a_servizio is null  then
        w_servizio     := 'P001';
        w_servizio_log := 'P001';
        w_archivio_rif := 'P01_2-2';
     elsif w_conta_richieste = 8 and a_servizio is null  then
        w_servizio     := 'P001';
        w_servizio_log := 'P001';
        w_archivio_rif := 'P01_2-7';
     elsif w_conta_richieste = 9 and a_servizio is null  then
        w_servizio     := 'NA00';
        w_servizio_log := 'NA00';
        w_archivio_rif := 'NA0';
     else
        goto fine;
     end if;
  else
     w_servizio := a_servizio;
  end if;

  if w_servizio = 'N010' then
     w_archivio_rif := 'N10';
  elsif w_servizio = 'N014' then
     w_archivio_rif := 'N14';
  elsif w_servizio = 'N015' then
     w_archivio_rif := 'N15';
  elsif w_servizio = 'N031' then
     w_archivio_rif := 'N31';
--  elsif w_servizio = 'N017' then
--     w_archivio_rif := 'N17';
  elsif w_servizio = 'NA00' then
     w_archivio_rif := 'NA0';
  elsif w_servizio = 'NA01' then
     w_archivio_rif := 'NA1';
  elsif w_servizio = 'NA02' then
     w_archivio_rif := 'NA2';
  elsif w_servizio = 'NA03' then
     w_archivio_rif := 'NA3';
  elsif w_servizio = 'NA04' then
     w_archivio_rif := 'NA4';
  elsif w_servizio = 'NA05' then
     w_archivio_rif := 'NA5';
  end if;

  ANPCIU_NR(w_id_operazione,w_servizio);

  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_conta_richieste '||w_conta_richieste||' - w_id_operazione '||w_id_operazione);
  begin
    insert into anpciu (id_operazione, servizio, tipo_operazione, archivio_rif)
    values (w_id_operazione, w_servizio, 'C', w_archivio_rif)
    ;
  end;

<< fine_loop >>
  if nvl(a_servizio,'N000') = 'N000' then
     w_conta_richieste := w_conta_richieste + 1;
     goto loop_richieste;
  end if;

<< fine >>
null;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end richiesta_notifiche;

procedure verifica_stato_notifiche
(a_servizio 		varchar2
,a_id_operazione        number
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'verifica_stato_notifiche';

w_id_operazione         number;

w_terminalista          varchar2(255);
w_id_ANPR               number;
w_esito_ANPR            varchar2(255);
w_flag_errore           varchar2(255);
w_flag_anomalia         varchar2(255);
w_xml_richiesta         clob;
w_xml_risposta          clob;

w_flag_invio_ws         varchar2(255);
w_data_invio_ws         number;
w_note_ws               varchar2(4000);

w_errore		varchar2(4000);
errore			exception;

/*
cursor sel_ciu is
select ciu.servizio
     , ciu.id_operazione
     , ciu.tipo_operazione
     , nvl(rif.id_operazione_anpr_rif,ciu.id_operazione_anpr) id_operazione_anpr
     , ciu.archivio_rif
  from anpciu_rif rif
     , anpciu ciu
 where rif.servizio_rif              = '4005'
   and rif.id_operazione             = ciu.id_operazione
   and ciu.flag_invio_ws             is not null
   and ciu.tipo_operazione           = 'C'
   and ciu.servizio                  in ('N010','N014','N015','N031')
   and ciu.id_operazione             = nvl(a_id_operazione,ciu.id_operazione)
   and nvl(ciu.id_operazione_anpr,0) > 0
   and not exists (select 'x' from anpciu_rif r, anpciu c
                    where (c.note_ws like 'KO%' or c.note_ws = 'OK')
                      and c.tipo_operazione    = 'V' 
                      and c.servizio           = ciu.servizio
                      and c.id_operazione      = r.id_operazione
                      and r.id_operazione_rif  = ciu.id_operazione)
;
*/

cursor sel_ciu is
select ciu.servizio
     , ciu.id_operazione
     , ciu.tipo_operazione
     , ciu.id_operazione_anpr
     , ciu.archivio_rif
  from anpciu ciu
 where ciu.flag_invio_ws             is not null
   and ciu.tipo_operazione           = 'C'
   and substr(ciu.servizio,1,1)      = 'N'
   and substr(ciu.archivio_rif,1,1)  = 'N'
   and ciu.id_operazione             = nvl(a_id_operazione,ciu.id_operazione)
   and nvl(ciu.id_operazione_anpr,0) > 0
   and not exists (select 'x' from anpciu_rif r, anpciu c
                    where (c.note_ws like 'KO%' or c.note_ws = 'OK')
                      and c.tipo_operazione    = 'V' 
                      and c.servizio           = ciu.servizio
                      and c.id_operazione      = r.id_operazione
                      and r.id_operazione_rif  = ciu.id_operazione)
;

begin
  ANPR_pkg.dati_cliente;

  if w_codDestinatario = 'ANPR01' then
     goto fine;
  end if;

  for rec in sel_ciu loop
      w_id_operazione := '';
      ANPCIU_NR(w_id_operazione,rec.servizio);
      w_terminalista := si4.utente;

      begin
        insert into anpciu_rif (id_operazione, id_operazione_rif, servizio_rif)
        select w_id_operazione, rec.id_operazione, rec.servizio
          from dual
         where not exists (select 'x' from anpciu_rif b
                            where b.id_operazione = w_id_operazione)
        ;
      exception
        when others then
             w_errore := 'errore in inserimento anpciu_rif ('||sqlerrm||')';
             ANPR_PKG.ins_log(w_servizio_log,w_operazione_log,w_errore);
      end;

      begin
        insert into anpciu (id_operazione, servizio, tipo_operazione, archivio_rif, numero_rif)
        values (w_id_operazione, rec.servizio, 'V', rec.archivio_rif, rec.id_operazione_anpr)
        ;
      end;
  end loop;

<< fine >>
null;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end verifica_stato_notifiche;

procedure acquisisci_notifiche
(a_servizio 		varchar2
,a_campo_clob 		clob
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'acquisisci_notifiche';

w_xml			xmltype;
w_xml_clob		clob;

w_extract_str 		varchar2(255);
w_extract_str_1		varchar2(255) := 'xmlns:p="http://sogei.it/ANPR/N000notificheComuni"';
w_extract_str_2  	varchar2(255);
w_extract_str_3		varchar2(255);
w_extract_str_4		varchar2(255);
w_extract_str_5  	varchar2(255);
w_extract_str_6  	varchar2(255);
w_extract_str_7		varchar2(255);
w_extract_str_8		varchar2(255);
w_extract_str_9		varchar2(255);
w_extract_str_10	varchar2(255) := 'xmlns:ns2="http://sogei.it/ansc/predisposizioneAnagrafica"';

cursor sel_n010 (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/generalitaSoggetto/codiceFiscale/codFiscale',w_extract_str_1) codFiscale
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/cognome',w_extract_str_1) cognome
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/nome',w_extract_str_1) nome
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/sesso',w_extract_str_1) sesso
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/dataNascita',w_extract_str_1) dataNascita
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/nomeComune',w_extract_str_1) NAS_nomecomune
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/codiceIstat',w_extract_str_1) NAS_codiceIstat
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/siglaProvinciaIstat',w_extract_str_1) NAS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/descrizioneLocalita',w_extract_str_1) NAS_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/descrizioneStato',w_extract_str_1) NAS_descrizioneStato
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/codiceStato',w_extract_str_1) NAS_codiceStato
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/soggettoAIRE',w_extract_str_1) soggettoAIRE
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/idSchedaSoggettoANPR',w_extract_str_1) idSchedaSoggettoANPR
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/nomeComune',w_extract_str_1) RIC_nomecomune
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/codiceIstat',w_extract_str_1) RIC_codiceIstat
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/siglaProvinciaIstat',w_extract_str_1) RIC_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/idOperazioneANPR',w_extract_str_1) idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/dataDecorrenza',w_extract_str_1) dataDecorrenza
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_n014 (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/generalitaSoggetto/codiceFiscale/codFiscale',w_extract_str_1) codFiscale
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/cognome',w_extract_str_1) cognome
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/nome',w_extract_str_1) nome
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/sesso',w_extract_str_1) sesso
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/dataNascita',w_extract_str_1) dataNascita
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/nomeComune',w_extract_str_1) NAS_nomecomune
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/codiceIstat',w_extract_str_1) NAS_codiceIstat
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/siglaProvinciaIstat',w_extract_str_1) NAS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/descrizioneLocalita',w_extract_str_1) NAS_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/descrizioneStato',w_extract_str_1) NAS_descrizioneStato
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/codiceStato',w_extract_str_1) NAS_codiceStato
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/soggettoAIRE',w_extract_str_1) soggettoAIRE
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/idSchedaSoggettoANPR',w_extract_str_1) idSchedaSoggettoANPR
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/nomeComune',w_extract_str_1) RIC_nomecomune
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/codiceIstat',w_extract_str_1) RIC_codiceIstat
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/siglaProvinciaIstat',w_extract_str_1) RIC_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/idOperazioneANPR',w_extract_str_1) idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/dataDecorrenza',w_extract_str_1) dataDecorrenza
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_n015 (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/generalitaSoggetto/codiceFiscale/codFiscale',w_extract_str_1) codFiscale
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/cognome',w_extract_str_1) cognome
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/nome',w_extract_str_1) nome
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/sesso',w_extract_str_1) sesso
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/dataNascita',w_extract_str_1) dataNascita
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/nomeComune',w_extract_str_1) NAS_nomecomune
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/codiceIstat',w_extract_str_1) NAS_codiceIstat
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/comune/siglaProvinciaIstat',w_extract_str_1) NAS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/descrizioneLocalita',w_extract_str_1) NAS_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/descrizioneStato',w_extract_str_1) NAS_descrizioneStato
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/luogoNascita/localita/codiceStato',w_extract_str_1) NAS_codiceStato
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/soggettoAIRE',w_extract_str_1) soggettoAIRE
     , extractValue(value(rowdata),w_root||'/generalitaSoggetto/idSchedaSoggettoANPR',w_extract_str_1) idSchedaSoggettoANPR
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/nomeComune',w_extract_str_1) RIC_nomecomune
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/codiceIstat',w_extract_str_1) RIC_codiceIstat
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/siglaProvinciaIstat',w_extract_str_1) RIC_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/idOperazioneANPR',w_extract_str_1) idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/dataDecorrenza',w_extract_str_1) dataDecorrenza
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_n031 (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/comuneRichiesta/nomeComune',w_extract_str_1) RIC_nomecomune
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/codiceIstat',w_extract_str_1) RIC_codiceIstat
     , extractValue(value(rowdata),w_root||'/comuneRichiesta/siglaProvinciaIstat',w_extract_str_1) RIC_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/dataOperativitaAnpr',w_extract_str_1) dataOperativitaAnpr
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_n017 (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/idSoggetto',w_extract_str_1) idSoggetto
     , extractValue(value(rowdata),w_root||'/idOperazioneANPR',w_extract_str_1) idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/codiceErroreAnomalia',w_extract_str_1) codiceErroreAnomalia
     , extractValue(value(rowdata),w_root||'/testoErroreAnomalia',w_extract_str_1) testoErroreAnomalia
  from table(XMLSequence(w_xml)) rowdata
;

cursor sel_na00 (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/testata/idNotifica',w_extract_str_10) idNotifica
     , extractValue(value(rowdata),w_root||'/testata/idTipoContenuto',w_extract_str_10) idTipoContenuto
     , extractValue(value(rowdata),w_root||'/testata/idTipoEvento',w_extract_str_10) idTipoEvento
     , extractValue(value(rowdata),w_root||'/testata/codMittente',w_extract_str_10) codMittente
     , extractValue(value(rowdata),w_root||'/testata/idTipoNotifica',w_extract_str_10) idTipoNotifica
     , extractValue(value(rowdata),w_root||'/testata/dataValidita',w_extract_str_10) dataValidita
     , extractValue(value(rowdata),w_root||'/testata/idUsecase',w_extract_str_10) idUsecase
     , extractValue(value(rowdata),w_root||'/testata/descrizioneUsecase',w_extract_str_10) descrizioneUsecase
--
     , extract(value(rowdata),w_root||'/evento/intestatario',w_extract_str_10).getClobVal() intestatario
--
     , extractValue(value(rowdata),w_root||'/evento/atto/idAnsc',w_extract_str_10) idAnsc
     , extractValue(value(rowdata),w_root||'/evento/atto/comuneRegistrazione/nomeComune',w_extract_str_10) REG_nomecomune
     , extractValue(value(rowdata),w_root||'/evento/atto/comuneRegistrazione/codiceIstat',w_extract_str_10) REG_codiceIstat
     , extractValue(value(rowdata),w_root||'/evento/atto/comuneRegistrazione/siglaProvinciaIstat',w_extract_str_10) REG_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/evento/atto/anno',w_extract_str_10) anno
     , extractValue(value(rowdata),w_root||'/evento/atto/numeroComunale',w_extract_str_10) numeroComunale
     , extractValue(value(rowdata),w_root||'/evento/atto/dataFormazioneAtto',w_extract_str_10) dataFormazioneAtto
--     , extractValue(value(rowdata),w_root||'/evento/atto/composizioneCompleta',w_extract_str_10) composizioneCompleta
--
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/codiceFiscale/codFiscale',w_extract_str_10) codFiscale_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/cognome',w_extract_str_10) cognome_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/nome',w_extract_str_10) nome_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/sesso',w_extract_str_10) sesso_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/dataNascita',w_extract_str_10) dataNascita_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoNascita/luogoEccezionale',w_extract_str_10) NAS_luogoEccezionale_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoNascita/comune/nomeComune',w_extract_str_10) NAS_nomeComune_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoNascita/comune/codiceIstat',w_extract_str_10) NAS_codiceIstat_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoNascita/comune/siglaProvinciaIstat',w_extract_str_10) NAS_siglaProvinciaIstat_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoNascita/localita/descrizioneLocalita',w_extract_str_10) NAS_descrizioneLocalita_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoNascita/localita/descrizioneStato',w_extract_str_10) NAS_descrizioneStato_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoNascita/localita/codiceStato',w_extract_str_10) NAS_codiceStato_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoResidenza/luogoEccezionale',w_extract_str_10) RES_luogoEccezionale_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoResidenza/comune/nomeComune',w_extract_str_10) RES_nomeComune_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoResidenza/comune/codiceIstat',w_extract_str_10) RES_codiceIstat_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoResidenza/comune/siglaProvinciaIstat',w_extract_str_10) RES_siglaProvinciaIstat_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoResidenza/localita/descrizioneLocalita',w_extract_str_10) RES_descrizioneLocalita_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoResidenza/localita/descrizioneStato',w_extract_str_10) RES_descrizioneStato_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/luogoResidenza/localita/codiceStato',w_extract_str_10) RES_codiceStato_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/nazionalita/descrizioneStato',w_extract_str_10) NAZ_descrizioneStato_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/nazionalita/codiceStato',w_extract_str_10) NAZ_codiceStato_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/idSchedaSoggettoANPR',w_extract_str_10) idSchedaSoggettoANPR_PD
     , extractValue(value(rowdata),w_root||'/evento/paternita/generalita/idSoggettoANSC',w_extract_str_10) idSoggettoANSC_PD
     , extractValue(value(rowdata),w_root||'/evento/atto/paternita/generalita/senzaCognome',w_extract_str_10) senzaCognome_PD
     , extractValue(value(rowdata),w_root||'/evento/atto/paternita/generalita/senzaNome',w_extract_str_10) senzaNome_PD
     , extractValue(value(rowdata),w_root||'/evento/atto/paternita/generalita/soggettoAIRE',w_extract_str_10) soggettoAire_PD
     , extractValue(value(rowdata),w_root||'/evento/atto/paternita/generalita/idANPR',w_extract_str_10) idAnpr_PD
--
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/codiceFiscale/codFiscale',w_extract_str_10) codFiscale_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/cognome',w_extract_str_10) cognome_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/nome',w_extract_str_10) nome_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/sesso',w_extract_str_10) sesso_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/dataNascita',w_extract_str_10) dataNascita_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoNascita/luogoEccezionale',w_extract_str_10) NAS_luogoEccezionale_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoNascita/comune/nomeComune',w_extract_str_10) NAS_nomeComune_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoNascita/comune/codiceIstat',w_extract_str_10) NAS_codiceIstat_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoNascita/comune/siglaProvinciaIstat',w_extract_str_10) NAS_siglaProvinciaIstat_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoNascita/localita/descrizioneLocalita',w_extract_str_10) NAS_descrizioneLocalita_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoNascita/localita/descrizioneStato',w_extract_str_10) NAS_descrizioneStato_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoNascita/localita/codiceStato',w_extract_str_10) NAS_codiceStato_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoResidenza/luogoEccezionale',w_extract_str_10) RES_luogoEccezionale_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoResidenza/comune/nomeComune',w_extract_str_10) RES_nomeComune_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoResidenza/comune/codiceIstat',w_extract_str_10) RES_codiceIstat_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoResidenza/comune/siglaProvinciaIstat',w_extract_str_10) RES_siglaProvinciaIstat_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoResidenza/localita/descrizioneLocalita',w_extract_str_10) RES_descrizioneLocalita_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoResidenza/localita/descrizioneStato',w_extract_str_10) RES_descrizioneStato_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/luogoResidenza/localita/codiceStato',w_extract_str_10) RES_codiceStato_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/nazionalita/descrizioneStato',w_extract_str_10) NAZ_descrizioneStato_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/nazionalita/codiceStato',w_extract_str_10) NAZ_codiceStato_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/idSchedaSoggettoANPR',w_extract_str_10) idSchedaSoggettoANPR_MD
     , extractValue(value(rowdata),w_root||'/evento/maternita/generalita/idSoggettoANSC',w_extract_str_10) idSoggettoANSC_MD
     , extractValue(value(rowdata),w_root||'/evento/atto/maternita/generalita/senzaCognome',w_extract_str_10) senzaCognome_MD
     , extractValue(value(rowdata),w_root||'/evento/atto/maternita/generalita/senzaNome',w_extract_str_10) senzaNome_MD
     , extractValue(value(rowdata),w_root||'/evento/atto/maternita/generalita/soggettoAIRE',w_extract_str_10) soggettoAire_MD
     , extractValue(value(rowdata),w_root||'/evento/atto/maternita/generalita/idANPR',w_extract_str_10) idAnpr_MD
--
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/codiceFiscale/codFiscale',w_extract_str_10) codFiscale_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/cognome',w_extract_str_10) cognome_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/nome',w_extract_str_10) nome_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/sesso',w_extract_str_10) sesso_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/dataNascita',w_extract_str_10) dataNascita_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoNascita/luogoEccezioanle',w_extract_str_10) NAS_luogoEccezionale_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoNascita/comune/nomeComune',w_extract_str_10) NAS_nomeComune_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoNascita/comune/codiceIstat',w_extract_str_10) NAS_codiceIstat_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoNascita/comune/siglaProvinciaIstat',w_extract_str_10) NAS_siglaProvinciaIstat_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoNascita/localita/descrizioneLocalita',w_extract_str_10) NAS_descrizioneLocalita_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoNascita/localita/descrizioneStato',w_extract_str_10) NAS_descrizioneStato_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoNascita/localita/descrizioneStato',w_extract_str_10) NAS_codiceStato_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoResidenza/luogoEccezioanle',w_extract_str_10) RES_luogoEccezionale_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoResidenza/comune/nomeComune',w_extract_str_10) RES_nomeComune_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoResidenza/comune/codiceIstat',w_extract_str_10) RES_codiceIstat_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoResidenza/comune/siglaProvinciaIstat',w_extract_str_10) RES_siglaProvinciaIstat_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoResidenza/localita/descrizioneLocalita',w_extract_str_10) RES_descrizioneLocalita_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoResidenza/localita/descrizioneStato',w_extract_str_10) RES_descrizioneStato_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/luogoResidenza/localita/descrizioneStato',w_extract_str_10) RES_codiceStato_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/nazionalita/descrizioneStato',w_extract_str_10) NAZ_descrizioneStato_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/nazionalita/descrizioneStato',w_extract_str_10) NAZ_codiceStato_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/idSchedaSoggettoANPR',w_extract_str_10) idSchedaSoggettoANPR_CN
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/coniuge/idSoggettoANSC',w_extract_str_10) idSoggettoANSC_CN
     , extractValue(value(rowdata),w_root||'/evento/atto/matrimonio/coniuge/senzaCognome',w_extract_str_10) senzaCognome_CN
     , extractValue(value(rowdata),w_root||'/evento/atto/matrimonio/coniuge/senzaNome',w_extract_str_10) senzaNome_CN
     , extractValue(value(rowdata),w_root||'/evento/atto/matrimonio/coniuge/soggettoAIRE',w_extract_str_10) soggettoAire_CN
     , extractValue(value(rowdata),w_root||'/evento/atto/matrimonio/coniuge/idANPR',w_extract_str_10) idAnpr_CN
--
     , extractValue(value(rowdata),w_root||'/evento/datiDecesso/dataEvento',w_extract_str_10) MOR_dataEvento
     , extractValue(value(rowdata),w_root||'/evento/datiDecesso/luogoEvento/luogoEccezionale',w_extract_str_10) MOR_luogoEccezionale
     , extractValue(value(rowdata),w_root||'/evento/datiDecesso/luogoEvento/comune/nomeComune',w_extract_str_10) MOR_nomeComune
     , extractValue(value(rowdata),w_root||'/evento/datiDecesso/luogoEvento/comune/codiceIstat',w_extract_str_10) MOR_codiceIstat
     , extractValue(value(rowdata),w_root||'/evento/datiDecesso/luogoEvento/comune/siglaProvinciaIstat',w_extract_str_10) MOR_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/evento/datiDecesso/luogoEvento/localita/descrizioneLocalita',w_extract_str_10) MOR_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/evento/datiDecesso/luogoEvento/localita/descrizioneStato',w_extract_str_10) MOR_descrizioneStato
     , extractValue(value(rowdata),w_root||'/evento/datiDecesso/luogoEvento/localita/codiceStato',w_extract_str_10) MOR_codiceStato
--
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/datiMatrimonio/dataEvento',w_extract_str_10) MAT_dataEvento
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/datiMatrimonio/luogoEvento/luogoEccezionale',w_extract_str_10) MAT_luogoEccezionale
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/datiMatrimonio/luogoEvento/comune/nomeComune',w_extract_str_10) MAT_nomeComune
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/datiMatrimonio/luogoEvento/comune/codiceIstat',w_extract_str_10) MAT_codiceIstat
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/datiMatrimonio/luogoEvento/comune/siglaProvinciaIstat',w_extract_str_10) MAT_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/datiMatrimonio/luogoEvento/localita/descrizioneLocalita',w_extract_str_10) MAT_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/datiMatrimonio/luogoEvento/localita/descrizioneStato',w_extract_str_10) MAT_descrizioneStato
     , extractValue(value(rowdata),w_root||'/evento/matrimonio/datiMatrimonio/luogoEvento/localita/codiceStato',w_extract_str_10) MAT_codiceStato
--
     , extractValue(value(rowdata),w_root||'/evento/unioneCivile/attoUnione/dataEvento',w_extract_str_10) UCI_dataEvento
     , extractValue(value(rowdata),w_root||'/evento/unioneCivile/attoUnione/luogoEvento/luogoEccezionale',w_extract_str_10) UCI_luogoEccezionale
     , extractValue(value(rowdata),w_root||'/evento/unioneCivile/attoUnione/luogoEvento/comune/nomeComune',w_extract_str_10) UCI_nomeComune
     , extractValue(value(rowdata),w_root||'/evento/unioneCivile/attoUnione/luogoEvento/comune/codiceIstat',w_extract_str_10) UCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/evento/unioneCivile/attoUnione/luogoEvento/comune/siglaProvinciaIstat',w_extract_str_10) UCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/evento/unioneCivile/attoUnione/luogoEvento/localita/descrizioneLocalita',w_extract_str_10) UCI_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/evento/unioneCivile/attoUnione/luogoEvento/localita/descrizioneStato',w_extract_str_10) UCI_descrizioneStato
     , extractValue(value(rowdata),w_root||'/evento/unioneCivile/attoUnione/luogoEvento/localita/codiceStato',w_extract_str_10) UCI_codiceStato
--
     , extractValue(value(rowdata),w_root||'/evento/separazione/tipoAccordo',w_extract_str_10) SEP_tipoAccordo
     , extractValue(value(rowdata),w_root||'/evento/separazione/attoMatrimonio/idAnsc',w_extract_str_10) SEP_idAnsc_MAT
     , extractValue(value(rowdata),w_root||'/evento/separazione/attoMatrimonio/comuneRegistrazione/nomeComune',w_extract_str_10) SEP_nomeComune_MAT
     , extractValue(value(rowdata),w_root||'/evento/separazione/attoMatrimonio/comuneRegistrazione/codiceIstat',w_extract_str_10) SEP_codiceIstat_MAT
     , extractValue(value(rowdata),w_root||'/evento/separazione/attoMatrimonio/comuneRegistrazione/siglaProvinciaIstat',w_extract_str_10) SEP_siglaProvinciaIstat_MAT
     , extractValue(value(rowdata),w_root||'/evento/separazione/attoMatrimonio/anno',w_extract_str_10)  SEP_anno_MAT
     , extractValue(value(rowdata),w_root||'/evento/separazione/attoMatrimonio/numeroComunale',w_extract_str_10) SEP_numeroComunale_MAT
     , extractValue(value(rowdata),w_root||'/evento/separazione/attoMatrimonio/dataFormazioneAtto',w_extract_str_10) SEP_dataFormazioneAtto_MAT
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordo/comuneEnte/nomeComune',w_extract_str_10) SEP_nomeComune_ACC
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordo/comuneEnte/codiceIstat',w_extract_str_10) SEP_codiceIstat_ACC
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordo/comuneEnte/siglaProvinciaIstat',w_extract_str_10) SEP_siglaProvinciaIstat_ACC
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordo/dataTrascrizione',w_extract_str_10) SEP_dataTrascrizione_ACC
     , extractValue(value(rowdata),w_root||'/evento/separazione/provvedimento/nomeEnte',w_extract_str_10) SEP_nomeEnte_PRO
     , extractValue(value(rowdata),w_root||'/evento/separazione/provvedimento/comuneEnte/nomeComune',w_extract_str_10) SEP_nomeComune_PRO
     , extractValue(value(rowdata),w_root||'/evento/separazione/provvedimento/comuneEnte/codiceIstat',w_extract_str_10) SEP_codiceIstat_PRO
     , extractValue(value(rowdata),w_root||'/evento/separazione/provvedimento/comuneEnte/siglaProvinciaIstat',w_extract_str_10) SEP_siglaProvinciaIstat_PRO
     , extractValue(value(rowdata),w_root||'/evento/separazione/provvedimento/dataTrascrizione',w_extract_str_10) SEP_dataTrascrizione_PRO
     , extractValue(value(rowdata),w_root||'/evento/separazione/provvedimento/estremiDocumento',w_extract_str_10) SEP_estremiDocumento_PRO
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/idAnsc',w_extract_str_10) SEP_idAnsc_ACCSEP
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/comuneRegistrazione/nomeComune',w_extract_str_10) SEP_nomeComune_ACCSEP
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/comuneRegistrazione/codiceIstat',w_extract_str_10) SEP_codiceIstat_ACCSEP
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/comuneRegistrazione/siglaProvinciaIstat',w_extract_str_10) SEP_siglaProvinciaIstat_ACCSEP
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/anno',w_extract_str_10) SEP_anno_ACCSEP
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/numeroComunale',w_extract_str_10) SEP_numeroComunale_ACCSEP
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/idTipoContenuto',w_extract_str_10) SEP_idTipoContenuto_ACCSEP
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/numeroAtto',w_extract_str_10) SEP_numeroAtto_ACCSEP
     , extractValue(value(rowdata),w_root||'/evento/separazione/accordoSeparazione/tipologia',w_extract_str_10) SEP_tipologia_ACCSEP
--
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/motivoScioglimento',w_extract_str_10) SCI_motivoScioglimento
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/datiEvento/dataEvento',w_extract_str_10) SCI_dataEvento
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/datiEvento/luogoEvento/luogoEccezionale',w_extract_str_10) SCI_luogoEccezionale
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/datiEvento/luogoEvento/comune/nomeComune',w_extract_str_10) SCI_nomeComune
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/datiEvento/luogoEvento/comune/codiceIstat',w_extract_str_10) SCI_codiceIstat
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/datiEvento/luogoEvento/comune/siglaProvinciaIstat',w_extract_str_10) SCI_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/datiEvento/luogoEvento/localita/descrizioneLocalita',w_extract_str_10) SCI_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/datiEvento/luogoEvento/localita/descrizioneStato',w_extract_str_10) SCI_descrizioneStato
     , extractValue(value(rowdata),w_root||'/evento/atto/scioglimentoUnione/datiEvento/luogoEvento/localita/codiceStato',w_extract_str_10) SCI_codiceStato
--
     , extractValue(value(rowdata),w_root||'/evento/atto/cittadinanza/intestatarioApolide',w_extract_str_10) CIT_intestatarioApolide
     , extractValue(value(rowdata),w_root||'/evento/atto/cittadinanza/dataAcquisizioneCittadinanza',w_extract_str_10) CIT_dataAcquisizione
     , extractValue(value(rowdata),w_root||'/evento/atto/cittadinanza/dataRegistrazioneDecreto',w_extract_str_10) CIT_dataRegistrazioneDecreto
--
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/tipoModifica',w_extract_str_10) TRA_tipoModifica
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/dataComunicazione',w_extract_str_10) TRA_dataComunicazione
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/nomeEnte',w_extract_str_10) TRA_nomeEnte
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/dataTrascrizione',w_extract_str_10) TRA_dataTrascrizione
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/estremiDocumento',w_extract_str_10) TRA_estremiDocumento
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/localitaEnte/comune/nomeComune',w_extract_str_10) TRA_nomeComune
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/localitaEnte/comune/codiceIstat',w_extract_str_10) TRA_codiceIstat
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/localitaEnte/comune/siglaProvinciaIstat',w_extract_str_10) TRA_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/localitaEnte/descrizioneLocalita',w_extract_str_10) TRA_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/localitaEnte/descrizioneStato',w_extract_str_10) TRA_descrizioneStato
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/ente/localitaEnte/codiceStato',w_extract_str_10) TRA_codiceStato
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/dataPubblicazioneSentenza',w_extract_str_10) TRA_dataPubblicazioneSentenza
     , extractValue(value(rowdata),w_root||'/evento/trascrizione/dataDecorrenzaSentenza',w_extract_str_10) TRA_dataDecorrenzaSentenza
  from table(XMLSequence(w_xml)) rowdata
;

w_composizioneCompleta			clob;

w_sequenza_int				number;
w_CODFISCALE_1				varchar2(255) := '';
w_COGNOME_1				varchar2(255) := '';
w_SENZACOGNOME_1			varchar2(255) := '';
w_NOME_1				varchar2(255) := '';
w_SENZANOME_1			        varchar2(255) := '';
w_SESSO_1				varchar2(255) := '';
w_DATANASCITA_1				varchar2(255) := '';
w_NAS_LUOGOECCEZIONALE_1		varchar2(255) := '';
w_NAS_NOMECOMUNE_1			varchar2(255) := '';
w_NAS_CODICEISTAT_1			varchar2(255) := '';
w_NAS_SIGLAPROVINCIAISTAT_1		varchar2(255) := '';
w_NAS_DESCRIZIONELOCALITA_1		varchar2(255) := '';
w_NAS_DESCRIZIONESTATO_1		varchar2(255) := '';
w_NAS_CODICESTATO_1			varchar2(255) := '';
w_RES_LUOGOECCEZIONALE_1		varchar2(255) := '';
w_RES_NOMECOMUNE_1			varchar2(255) := '';
w_RES_CODICEISTAT_1			varchar2(255) := '';
w_RES_SIGLAPROVINCIAISTAT_1		varchar2(255) := '';
w_RES_DESCRIZIONELOCALITA_1		varchar2(255) := '';
w_RES_DESCRIZIONESTATO_1		varchar2(255) := '';
w_RES_CODICESTATO_1			varchar2(255) := '';
w_NAZ_DESCRIZIONESTATO_1		varchar2(255) := '';
w_NAZ_CODICESTATO_1			varchar2(255) := '';
w_SOGGETTOAIRE_1			varchar2(255) := '';
w_IDSCHEDASOGGETTOANPR_1		number := '';
w_IDSOGGETTOANSC_1			number := '';
w_IDANPR_1			        varchar2(255) := '';
w_CODFISCALE_2				varchar2(255) := '';
w_COGNOME_2				varchar2(255) := '';
w_SENZACOGNOME_2			varchar2(255) := '';
w_NOME_2				varchar2(255) := '';
w_SENZANOME_2			        varchar2(255) := '';
w_SESSO_2				varchar2(255) := '';
w_DATANASCITA_2				varchar2(255) := '';
w_NAS_LUOGOECCEZIONALE_2		varchar2(255) := '';
w_NAS_NOMECOMUNE_2			varchar2(255) := '';
w_NAS_CODICEISTAT_2			varchar2(255) := '';
w_NAS_SIGLAPROVINCIAISTAT_2		varchar2(255) := '';
w_NAS_DESCRIZIONELOCALITA_2		varchar2(255) := '';
w_NAS_DESCRIZIONESTATO_2		varchar2(255) := '';
w_NAS_CODICESTATO_2			varchar2(255) := '';
w_RES_LUOGOECCEZIONALE_2		varchar2(255) := '';
w_RES_NOMECOMUNE_2			varchar2(255) := '';
w_RES_CODICEISTAT_2			varchar2(255) := '';
w_RES_SIGLAPROVINCIAISTAT_2		varchar2(255) := '';
w_RES_DESCRIZIONELOCALITA_2		varchar2(255) := '';
w_RES_DESCRIZIONESTATO_2		varchar2(255) := '';
w_RES_CODICESTATO_2			varchar2(255) := '';
w_NAZ_DESCRIZIONESTATO_2		varchar2(255) := '';
w_NAZ_CODICESTATO_2			varchar2(255) := '';
w_SOGGETTOAIRE_2			varchar2(255) := '';
w_IDSCHEDASOGGETTOANPR_2		number := '';
w_IDSOGGETTOANSC_2			number := '';
w_IDANPR_2			        varchar2(255) := '';

cursor sel_na00_int (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/codiceFiscale/codFiscale',w_extract_str_10) codFiscale
     , extractValue(value(rowdata),w_root||'/cognome',w_extract_str_10) cognome
     , extractValue(value(rowdata),w_root||'/senzaCognome',w_extract_str_10) senzaCognome
     , extractValue(value(rowdata),w_root||'/nome',w_extract_str_10) nome
     , extractValue(value(rowdata),w_root||'/senzaNome',w_extract_str_10) senzaNome
     , extractValue(value(rowdata),w_root||'/sesso',w_extract_str_10) sesso
     , extractValue(value(rowdata),w_root||'/dataNascita',w_extract_str_10) dataNascita
     , extractValue(value(rowdata),w_root||'/luogoNascita/luogoEccezionale',w_extract_str_10) NAS_luogoEccezionale
     , extractValue(value(rowdata),w_root||'/luogoNascita/comune/nomeComune',w_extract_str_10) NAS_nomeComune
     , extractValue(value(rowdata),w_root||'/luogoNascita/comune/codiceIstat',w_extract_str_10) NAS_codiceIstat
     , extractValue(value(rowdata),w_root||'/luogoNascita/comune/siglaProvinciaIstat',w_extract_str_10) NAS_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/luogoNascita/localita/descrizioneLocalita',w_extract_str_10) NAS_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/luogoNascita/localita/descrizioneStato',w_extract_str_10) NAS_descrizioneStato
     , extractValue(value(rowdata),w_root||'/luogoNascita/localita/codiceStato',w_extract_str_10) NAS_codiceStato
     , extractValue(value(rowdata),w_root||'/luogoResidenza/luogoEccezionale',w_extract_str_10) RES_luogoEccezionale
     , extractValue(value(rowdata),w_root||'/luogoResidenza/comune/nomeComune',w_extract_str_10) RES_nomeComune
     , extractValue(value(rowdata),w_root||'/luogoResidenza/comune/codiceIstat',w_extract_str_10) RES_codiceIstat
     , extractValue(value(rowdata),w_root||'/luogoResidenza/comune/siglaProvinciaIstat',w_extract_str_10) RES_siglaProvinciaIstat
     , extractValue(value(rowdata),w_root||'/luogoResidenza/localita/descrizioneLocalita',w_extract_str_10) RES_descrizioneLocalita
     , extractValue(value(rowdata),w_root||'/luogoResidenza/localita/descrizioneStato',w_extract_str_10) RES_descrizioneStato
     , extractValue(value(rowdata),w_root||'/luogoResidenza/localita/codiceStato',w_extract_str_10) RES_codiceStato
     , extractValue(value(rowdata),w_root||'/nazionalita/descrizioneStato',w_extract_str_10) NAZ_descrizioneStato
     , extractValue(value(rowdata),w_root||'/nazionalita/codiceStato',w_extract_str_10) NAZ_codiceStato
     , extractValue(value(rowdata),w_root||'/soggettoAIRE',w_extract_str_10) soggettoAIRE
     , extractValue(value(rowdata),w_root||'/idSchedaSoggettoANPR',w_extract_str_10) idSchedaSoggettoANPR
     , extractValue(value(rowdata),w_root||'/idSoggettoANSC',w_extract_str_10) idSoggettoANSC
     , extractValue(value(rowdata),w_root||'/idANPR',w_extract_str_10) idANPR
  from table(XMLSequence(w_xml)) rowdata
;

w_errore		varchar2(4000);
errore			exception;

begin
  w_xml := xmltype(a_campo_clob);

  if a_servizio = 'N010' then
     w_extract_str := '/p:Notifica'||a_servizio;
     goto notificaN010;
  elsif a_servizio = 'N014' then
     w_extract_str := '/p:Notifica'||a_servizio;
     goto notificaN014;
  elsif a_servizio = 'N015' then
     w_extract_str := '/p:Notifica'||a_servizio;
     goto notificaN015;
  elsif a_servizio = 'N031' then
     w_extract_str := '/p:Notifica'||a_servizio;
     goto notificaN031;
  elsif a_servizio = 'N017' then
     w_extract_str := '/p:Notifica'||a_servizio;
     goto notificaN017;
  elsif a_servizio in ('NA00','NA01','NA02','NA03','NA04','NA05') then
     w_extract_str := '/ns2:predisposizioneAnagrafica';
     goto notificaNA00;
  else
     goto fine;
  end if;

<< notificaN010 >>
  for rec in sel_n010 (w_extract_str) loop
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'notifica', 'idOperazioneANPR '||rec.idOperazioneANPR||' - RIC_nomeComune '||rec.RIC_nomeComune||' - codFiscale '||rec.codFiscale);
      if rec.idOperazioneANPR is not null then
         begin
           insert into anpn10
                ( RIC_nomecomune, RIC_codiceIstat, RIC_siglaProvinciaIstat
                , idOperazioneANPR, dataDecorrenza
                , codFiscale, cognome, nome, sesso, dataNascita
                , NAS_nomecomune, NAS_codiceIstat, NAS_siglaProvinciaIstat
                , NAS_descrizioneStato, NAS_codiceStato
                , soggettoAIRE, idSchedaSoggettoANPR
                )
           select rec.RIC_nomecomune, rec.RIC_codiceIstat, rec.RIC_siglaProvinciaIstat
                , rec.idOperazioneANPR, rec.dataDecorrenza
                , rec.codFiscale, rec.cognome, rec.nome, rec.sesso, rec.dataNascita
                , rec.NAS_nomecomune, rec.NAS_codiceIstat, rec.NAS_siglaProvinciaIstat
                , rec.NAS_descrizioneStato, rec.NAS_codiceStato
                , rec.soggettoAIRE, rec.idSchedaSoggettoANPR
             from dual
            where not exists (select 'x' from anpn10 b
                               where b.idOperazioneANPR     = rec.idOperazioneANPR
                                 and b.idSchedaSoggettoANPR = rec.idSchedaSoggettoANPR )
           ;
         end;
      end if;
  end loop;

  goto fine;

<< notificaN014 >>
  for rec in sel_n014 (w_extract_str) loop
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'notifica', 'idOperazioneANPR '||rec.idOperazioneANPR||' - RIC_nomeComune '||rec.RIC_nomeComune||' - codFiscale '||rec.codFiscale);
      if rec.idOperazioneANPR is not null then
         begin
           insert into anpn14
                ( RIC_nomecomune, RIC_codiceIstat, RIC_siglaProvinciaIstat
                , idOperazioneANPR, dataDecorrenza
                , codFiscale, cognome, nome, sesso, dataNascita
                , NAS_nomecomune, NAS_codiceIstat, NAS_siglaProvinciaIstat
                , NAS_descrizioneStato, NAS_codiceStato
                , soggettoAIRE, idSchedaSoggettoANPR
                )
           select rtrim(rec.RIC_nomecomune), rec.RIC_codiceIstat, rtrim(rec.RIC_siglaProvinciaIstat)
                , rec.idOperazioneANPR, rec.dataDecorrenza
                , rec.codFiscale, rec.cognome, rec.nome, rec.sesso, rec.dataNascita
                , rec.NAS_nomecomune, rec.NAS_codiceIstat, rec.NAS_siglaProvinciaIstat
                , rec.NAS_descrizioneStato, rec.NAS_codiceStato
                , rec.soggettoAIRE, rec.idSchedaSoggettoANPR
             from dual
            where not exists (select 'x' from anpn14 b
                               where b.idOperazioneANPR     = rec.idOperazioneANPR
                                 and b.idSchedaSoggettoANPR = rec.idSchedaSoggettoANPR )
           ;
         end;
      end if;
  end loop;

  goto fine;

<< notificaN015 >>
  for rec in sel_n015 (w_extract_str) loop
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'notifica', 'idOperazioneANPR '||rec.idOperazioneANPR||' - RIC_nomeComune '||rec.RIC_nomeComune||' - codFiscale '||rec.codFiscale);
      if rec.idOperazioneANPR is not null then
         begin
           insert into anpn15
                ( RIC_nomecomune, RIC_codiceIstat, RIC_siglaProvinciaIstat
                , idOperazioneANPR, dataDecorrenza
                , codFiscale, cognome, nome, sesso, dataNascita
                , NAS_nomecomune, NAS_codiceIstat, NAS_siglaProvinciaIstat
                , NAS_descrizioneStato, NAS_codiceStato
                , soggettoAIRE, idSchedaSoggettoANPR
                )
           select rec.RIC_nomecomune, rec.RIC_codiceIstat, rec.RIC_siglaProvinciaIstat
                , rec.idOperazioneANPR, rec.dataDecorrenza
                , rec.codFiscale, rec.cognome, rec.nome, rec.sesso, rec.dataNascita
                , rec.NAS_nomecomune, rec.NAS_codiceIstat, rec.NAS_siglaProvinciaIstat
                , rec.NAS_descrizioneStato, rec.NAS_codiceStato
                , rec.soggettoAIRE, rec.idSchedaSoggettoANPR
             from dual
            where not exists (select 'x' from anpn15 b
                               where b.idOperazioneANPR     = rec.idOperazioneANPR
                                 and b.idSchedaSoggettoANPR = rec.idSchedaSoggettoANPR )
           ;
         end;
      end if;
  end loop;

  goto fine;

<< notificaN031 >>
  for rec in sel_n031 (w_extract_str) loop
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'notifica', 'RIC_nomeComune '||rec.RIC_nomeComune||' - dataOperativitaAnpr '||rec.dataOperativitaAnpr);
      if rec.RIC_codiceIstat is not null then
         begin
           insert into anpn31
                ( RIC_nomecomune, RIC_codiceIstat, RIC_siglaProvinciaIstat
                , dataOperativitaAnpr
                )
           select rec.RIC_nomecomune, rec.RIC_codiceIstat, rec.RIC_siglaProvinciaIstat
                , rec.dataOperativitaAnpr
             from dual
            where not exists (select 'x' from anpn31 b
                               where b.RIC_codiceIstat  = rec.RIC_codiceIstat)
           ;
         end;
      end if;
  end loop;

  goto fine;

<< notificaN017 >>
  for rec in sel_n017 (w_extract_str) loop
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'notifica', 'idOperazioneANPR '||rec.idOperazioneANPR||' - idSoggetto '||rec.idSoggetto);
      if rec.idOperazioneANPR is not null then
         begin
           insert into anpn17
                ( idOperazioneANPR, idSoggetto, codiceErroreAnomalia, testoErroreAnomalia
                )
           select rec.idOperazioneANPR, rec.idSoggetto, rec.codiceErroreAnomalia, rec.testoErroreAnomalia
             from dual
            where not exists (select 'x' from anpn17 b
                               where b.idOperazioneANPR = rec.idOperazioneANPR
                                 and b.idSoggetto       = rec.idSoggetto)
           ;
         end;
      end if;
  end loop;

  goto fine;

<< notificaNA00 >>
  for rec in sel_na00 (w_extract_str) loop
      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'notifica', 'idAnsc '||rec.idAnsc);
      if rec.idAnsc is not null then
         if rec.intestatario is not null then
            w_xml      := xmltype('<ROOT>'||rec.intestatario||'</ROOT>');
            w_xml      := w_xml.extract('/ROOT/intestatario',w_extract_str_10);
            w_xml_clob := xmltype.getclobval(w_xml);

            w_sequenza_int := 0;
            for rec_int in sel_na00_int ('intestatario') loop
                w_sequenza_int := w_sequenza_int + 1;
                if w_sequenza_int = 1 then
                   w_CODFISCALE_1              := rec_int.codFiscale;
                   w_COGNOME_1                 := rec_int.cognome;
                   w_SENZACOGNOME_1            := rec_int.senzaCognome;
                   w_NOME_1                    := rec_int.nome;
                   w_SENZANOME_1               := rec_int.senzaNome;
                   w_SESSO_1                   := rec_int.sesso;
                   w_DATANASCITA_1             := rec_int.dataNascita;
                   w_NAS_LUOGOECCEZIONALE_1    := rec_int.NAS_luogoEccezionale;
                   w_NAS_NOMECOMUNE_1          := rec_int.NAS_nomeComune;
                   w_NAS_CODICEISTAT_1         := rec_int.NAS_codiceIstat;
                   w_NAS_SIGLAPROVINCIAISTAT_1 := rec_int.NAS_siglaProvinciaIstat;
                   w_NAS_DESCRIZIONELOCALITA_1 := rec_int.NAS_descrizioneLocalita;
                   w_NAS_DESCRIZIONESTATO_1    := rec_int.NAS_descrizioneStato;
                   w_NAS_CODICESTATO_1         := rec_int.NAS_codiceStato;
                   w_RES_LUOGOECCEZIONALE_1    := rec_int.RES_luogoEccezionale;
                   w_RES_NOMECOMUNE_1          := rec_int.RES_nomeComune;
                   w_RES_CODICEISTAT_1         := rec_int.RES_codiceIstat;
                   w_RES_SIGLAPROVINCIAISTAT_1 := rec_int.RES_siglaProvinciaIstat;
                   w_RES_DESCRIZIONELOCALITA_1 := rec_int.RES_descrizioneLocalita;
                   w_RES_DESCRIZIONESTATO_1    := rec_int.RES_descrizioneStato;
                   w_RES_CODICESTATO_1         := rec_int.RES_codiceStato;
                   w_NAZ_DESCRIZIONESTATO_1    := rec_int.NAZ_descrizioneStato;
                   w_NAZ_CODICESTATO_1         := rec_int.NAZ_codiceStato;
                   w_SOGGETTOAIRE_1            := rec_int.soggettoAire;
                   w_IDSCHEDASOGGETTOANPR_1    := rec_int.idSchedaSoggettoANPR;
                   w_IDSOGGETTOANSC_1          := rec_int.idSoggettoANSC;
                   w_IDANPR_1                  := rec_int.idANPR;
                elsif w_sequenza_int = 2 then
                   w_CODFISCALE_2              := rec_int.codFiscale;
                   w_COGNOME_2                 := rec_int.cognome;
                   w_SENZACOGNOME_2            := rec_int.senzaCognome;
                   w_NOME_2                    := rec_int.nome;
                   w_SENZANOME_2               := rec_int.senzaNome;
                   w_SESSO_2                   := rec_int.sesso;
                   w_DATANASCITA_2             := rec_int.dataNascita;
                   w_NAS_LUOGOECCEZIONALE_2    := rec_int.NAS_luogoEccezionale;
                   w_NAS_NOMECOMUNE_2          := rec_int.NAS_nomeComune;
                   w_NAS_CODICEISTAT_2         := rec_int.NAS_codiceIstat;
                   w_NAS_SIGLAPROVINCIAISTAT_2 := rec_int.NAS_siglaProvinciaIstat;
                   w_NAS_DESCRIZIONELOCALITA_2 := rec_int.NAS_descrizioneLocalita;
                   w_NAS_DESCRIZIONESTATO_2    := rec_int.NAS_descrizioneStato;
                   w_NAS_CODICESTATO_2         := rec_int.NAS_codiceStato;
                   w_RES_LUOGOECCEZIONALE_2    := rec_int.RES_luogoEccezionale;
                   w_RES_NOMECOMUNE_2          := rec_int.RES_nomeComune;
                   w_RES_CODICEISTAT_2         := rec_int.RES_codiceIstat;
                   w_RES_SIGLAPROVINCIAISTAT_2 := rec_int.RES_siglaProvinciaIstat;
                   w_RES_DESCRIZIONELOCALITA_2 := rec_int.RES_descrizioneLocalita;
                   w_RES_DESCRIZIONESTATO_2    := rec_int.RES_descrizioneStato;
                   w_RES_CODICESTATO_2         := rec_int.RES_codiceStato;
                   w_NAZ_DESCRIZIONESTATO_2    := rec_int.NAZ_descrizioneStato;
                   w_NAZ_CODICESTATO_2         := rec_int.NAZ_codiceStato;
                   w_SOGGETTOAIRE_2            := rec_int.soggettoAire;
                   w_IDSCHEDASOGGETTOANPR_2    := rec_int.idSchedaSoggettoANPR;
                   w_IDSOGGETTOANSC_2          := rec_int.idSoggettoANSC;
                   w_IDANPR_2                  := rec_int.idANPR;
                else
                   exit;
                end if;
            end loop;
         end if;

         w_composizioneCompleta := f_UTIL_leggi_campo_xml(a_servizio,a_campo_clob,'composizioneCompleta');
         w_composizioneCompleta := ltrim(rtrim(w_composizioneCompleta,']]>'),'<![CDATA[');

         begin
           insert into anpna0
                ( IDNOTIFICA, 
                  IDTIPOCONTENUTO, IDTIPOEVENTO, CODMITTENTE, IDTIPONOTIFICA, DATAVALIDITA, IDUSECASE, DESCRIZIONEUSECASE,
                  CODFISCALE_1, COGNOME_1, NOME_1, SESSO_1, DATANASCITA_1,
                  NAS_LUOGOECCEZIONALE_1, 
                  NAS_NOMECOMUNE_1, NAS_CODICEISTAT_1, NAS_SIGLAPROVINCIAISTAT_1, 
                  NAS_DESCRIZIONELOCALITA_1, NAS_DESCRIZIONESTATO_1, NAS_CODICESTATO_1,
                  SOGGETTOAIRE_1, IDSCHEDASOGGETTOANPR_1, IDSOGGETTOANSC_1,
                  CODFISCALE_2, COGNOME_2, NOME_2, SESSO_2, DATANASCITA_2,
                  NAS_LUOGOECCEZIONALE_2,
                  NAS_NOMECOMUNE_2, NAS_CODICEISTAT_2, NAS_SIGLAPROVINCIAISTAT_2,
                  NAS_DESCRIZIONELOCALITA_2, NAS_DESCRIZIONESTATO_2, NAS_CODICESTATO_2,
                  SOGGETTOAIRE_2, IDSCHEDASOGGETTOANPR_2, IDSOGGETTOANSC_2,
                  IDANSC, REG_NOMECOMUNE, REG_CODICEISTAT, REG_SIGLAPROVINCIAISTAT,
                  ANNO, NUMEROCOMUNALE, DATAFORMAZIONEATTO,
                  CODFISCALE_PD, COGNOME_PD, NOME_PD, SESSO_PD, DATANASCITA_PD,
                  NAS_LUOGOECCEZIONALE_PD,
                  NAS_NOMECOMUNE_PD, NAS_CODICEISTAT_PD, NAS_SIGLAPROVINCIAISTAT_PD,
                  NAS_DESCRIZIONELOCALITA_PD, NAS_DESCRIZIONESTATO_PD, NAS_CODICESTATO_PD,
                  IDSCHEDASOGGETTOANPR_PD, IDSOGGETTOANSC_PD,
                  CODFISCALE_MD, COGNOME_MD, NOME_MD, SESSO_MD, DATANASCITA_MD,
                  NAS_LUOGOECCEZIONALE_MD,
                  NAS_NOMECOMUNE_MD, NAS_CODICEISTAT_MD, NAS_SIGLAPROVINCIAISTAT_MD,
                  NAS_DESCRIZIONELOCALITA_MD, NAS_DESCRIZIONESTATO_MD, NAS_CODICESTATO_MD,
                  IDSCHEDASOGGETTOANPR_MD, IDSOGGETTOANSC_MD,
                  CODFISCALE_CN, COGNOME_CN, NOME_CN, SESSO_CN, DATANASCITA_CN,
                  NAS_LUOGOECCEZIONALE_CN,
                  NAS_NOMECOMUNE_CN, NAS_CODICEISTAT_CN, NAS_SIGLAPROVINCIAISTAT_CN,
                  NAS_DESCRIZIONELOCALITA_CN, NAS_DESCRIZIONESTATO_CN, NAS_CODICESTATO_CN,
                  IDSCHEDASOGGETTOANPR_CN, IDSOGGETTOANSC_CN,
                  MOR_DATAEVENTO, MOR_LUOGOECCEZIONALE,
                  MOR_NOMECOMUNE, MOR_CODICEISTAT, MOR_SIGLAPROVINCIAISTAT,
                  MOR_DESCRIZIONELOCALITA, MOR_DESCRIZIONESTATO, MOR_CODICESTATO,
                  MAT_DATAEVENTO, MAT_LUOGOECCEZIONALE,
                  MAT_NOMECOMUNE, MAT_CODICEISTAT, MAT_SIGLAPROVINCIAISTAT,
                  MAT_DESCRIZIONELOCALITA, MAT_DESCRIZIONESTATO, MAT_CODICESTATO,
                  UCI_DATAEVENTO, UCI_LUOGOECCEZIONALE,
                  UCI_NOMECOMUNE, UCI_CODICEISTAT, UCI_SIGLAPROVINCIAISTAT,
                  UCI_DESCRIZIONELOCALITA, UCI_DESCRIZIONESTATO, UCI_CODICESTATO,
                  SEP_TIPOACCORDO,  
                  SEP_NOMECOMUNE_MAT, SEP_CODICEISTAT_MAT, SEP_SIGLAPROVINCIAISTAT_MAT, 
                  SEP_ANNO_MAT, SEP_NUMEROCOMUNALE_MAT, SEP_DATAFORMAZIONEATTO_MAT,
                  SEP_NOMECOMUNE_ACC, SEP_CODICEISTAT_ACC, SEP_SIGLAPROVINCIAISTAT_ACC, SEP_DATATRASCRIZIONE_ACC,
                  SEP_IDANSC_MAT, 
                  SEP_NOMEENTE_PRO,               
                  SEP_NOMECOMUNE_PRO, SEP_CODICEISTAT_PRO, SEP_SIGLAPROVINCIAISTAT_PRO, 
                  SEP_DATATRASCRIZIONE_PRO, SEP_ESTREMIDOCUMENTO_PRO,       
                  SENZACOGNOME_1, SENZANOME_1, IDANPR_1, 
                  SENZACOGNOME_2, SENZANOME_2, IDANPR_2,
                  SENZACOGNOME_PD, SENZANOME_PD, SOGGETTOAIRE_PD, IDANPR_PD,
                  SENZACOGNOME_MD, SENZANOME_MD, SOGGETTOAIRE_MD, IDANPR_MD, 
                  SENZACOGNOME_CN, SENZANOME_CN, SOGGETTOAIRE_CN, IDANPR_CN,
                  SCI_MOTIVOSCIOGLIMENTO, SCI_DATAEVENTO, SCI_LUOGOECCEZIONALE, 
                  SCI_NOMECOMUNE, SCI_CODICEISTAT, SCI_SIGLAPROVINCIAISTAT,
                  SCI_DESCRIZIONELOCALITA, SCI_DESCRIZIONESTATO, SCI_CODICESTATO,
                  CIT_INTESTATARIOAPOLIDE, CIT_DATAACQUISIZIONE, CIT_DATAREGISTRAZIONEDECRETO,
                  COMPOSIZIONECOMPLETA,
                  RES_LUOGOECCEZIONALE_1, 
                  RES_NOMECOMUNE_1, RES_CODICEISTAT_1, RES_SIGLAPROVINCIAISTAT_1,
                  RES_DESCRIZIONELOCALITA_1, RES_DESCRIZIONESTATO_1, RES_CODICESTATO_1,
                  RES_LUOGOECCEZIONALE_2, 
                  RES_NOMECOMUNE_2, RES_CODICEISTAT_2, RES_SIGLAPROVINCIAISTAT_2,
                  RES_DESCRIZIONELOCALITA_2, RES_DESCRIZIONESTATO_2, RES_CODICESTATO_2,
                  RES_LUOGOECCEZIONALE_PD, 
                  RES_NOMECOMUNE_PD, RES_CODICEISTAT_PD, RES_SIGLAPROVINCIAISTAT_PD,
                  RES_DESCRIZIONELOCALITA_PD, RES_DESCRIZIONESTATO_PD, RES_CODICESTATO_PD, 
                  RES_LUOGOECCEZIONALE_MD, 
                  RES_NOMECOMUNE_MD, RES_CODICEISTAT_MD, RES_SIGLAPROVINCIAISTAT_MD,
                  RES_DESCRIZIONELOCALITA_MD, RES_DESCRIZIONESTATO_MD, RES_CODICESTATO_MD, 
                  RES_LUOGOECCEZIONALE_CN, 
                  RES_NOMECOMUNE_CN, RES_CODICEISTAT_CN, RES_SIGLAPROVINCIAISTAT_CN,
                  RES_DESCRIZIONELOCALITA_CN, RES_DESCRIZIONESTATO_CN, RES_CODICESTATO_CN, 
                  NAZ_DESCRIZIONESTATO_1, NAZ_CODICESTATO_1,
                  NAZ_DESCRIZIONESTATO_2, NAZ_CODICESTATO_2, 
                  NAZ_DESCRIZIONESTATO_PD, NAZ_CODICESTATO_PD, 
                  NAZ_DESCRIZIONESTATO_MD, NAZ_CODICESTATO_MD,
                  NAZ_DESCRIZIONESTATO_CN, NAZ_CODICESTATO_CN,
                  TRA_TIPOMODIFICA, 
                  TRA_DATACOMUNICAZIONE, TRA_NOMEENTE, TRA_DATATRASCRIZIONE, TRA_ESTREMIDOCUMENTO,
                  TRA_NOMECOMUNE, TRA_CODICEISTAT, TRA_SIGLAPROVINCIAISTAT,
                  TRA_DESCRIZIONELOCALITA, TRA_DESCRIZIONESTATO, TRA_CODICESTATO,
                  TRA_DATAPUBBLICAZIONESENTENZA, TRA_DATADECORRENZASENTENZA,
                  SEP_IDANSC_ACCSEP, 
                  SEP_NOMECOMUNE_ACCSEP, SEP_CODICEISTAT_ACCSEP, SEP_SIGLAPROVINCIAISTAT_ACCSEP,
                  SEP_ANNO_ACCSEP, SEP_NUMEROCOMUNALE_ACCSEP, 
                  SEP_IDTIPOCONTENUTO_ACCSEP, SEP_NUMEROATTO_ACCSEP, SEP_TIPOLOGIA_ACCSEP
                )
           select rec.IDNOTIFICA, 
                  rec.IDTIPOCONTENUTO, rec.IDTIPOEVENTO, rec.CODMITTENTE, rec.IDTIPONOTIFICA, rec.DATAVALIDITA, rec.IDUSECASE, rec.DESCRIZIONEUSECASE,
                  w_CODFISCALE_1, w_COGNOME_1, w_NOME_1, w_SESSO_1, w_DATANASCITA_1,
                  w_NAS_LUOGOECCEZIONALE_1, 
                  w_NAS_NOMECOMUNE_1, w_NAS_CODICEISTAT_1, w_NAS_SIGLAPROVINCIAISTAT_1, 
                  w_NAS_DESCRIZIONELOCALITA_1, w_NAS_DESCRIZIONESTATO_1, w_NAS_CODICESTATO_1,
                  w_SOGGETTOAIRE_1, w_IDSCHEDASOGGETTOANPR_1, w_IDSOGGETTOANSC_1,
                  w_CODFISCALE_2, w_COGNOME_2, w_NOME_2, w_SESSO_2, w_DATANASCITA_2,
                  w_NAS_LUOGOECCEZIONALE_2,
                  w_NAS_NOMECOMUNE_2, w_NAS_CODICEISTAT_2, w_NAS_SIGLAPROVINCIAISTAT_2,
                  w_NAS_DESCRIZIONELOCALITA_2, w_NAS_DESCRIZIONESTATO_2, w_NAS_CODICESTATO_2,
                  w_SOGGETTOAIRE_2, w_IDSCHEDASOGGETTOANPR_2, w_IDSOGGETTOANSC_2,
                  rec.IDANSC, rec.REG_NOMECOMUNE, rec.REG_CODICEISTAT, rec.REG_SIGLAPROVINCIAISTAT,
                  rec.ANNO, rec.NUMEROCOMUNALE, rec.DATAFORMAZIONEATTO,
                  rec.CODFISCALE_PD, rec.COGNOME_PD, rec.NOME_PD, rec.SESSO_PD, rec.DATANASCITA_PD,
                  rec.NAS_LUOGOECCEZIONALE_PD,
                  rec.NAS_NOMECOMUNE_PD, rec.NAS_CODICEISTAT_PD, rec.NAS_SIGLAPROVINCIAISTAT_PD,
                  rec.NAS_DESCRIZIONELOCALITA_PD, rec.NAS_DESCRIZIONESTATO_PD, rec.NAS_CODICESTATO_PD,
                  rec.IDSCHEDASOGGETTOANPR_PD, rec.IDSOGGETTOANSC_PD,
                  rec.CODFISCALE_MD, rec.COGNOME_MD, rec.NOME_MD, rec.SESSO_MD, rec.DATANASCITA_MD,
                  rec.NAS_LUOGOECCEZIONALE_MD,
                  rec.NAS_NOMECOMUNE_MD, rec.NAS_CODICEISTAT_MD, rec.NAS_SIGLAPROVINCIAISTAT_MD,
                  rec.NAS_DESCRIZIONELOCALITA_MD, rec.NAS_DESCRIZIONESTATO_MD, rec.NAS_CODICESTATO_MD,
                  rec.IDSCHEDASOGGETTOANPR_MD, rec.IDSOGGETTOANSC_MD,
                  rec.CODFISCALE_CN, rec.COGNOME_CN, rec.NOME_CN, rec.SESSO_CN, rec.DATANASCITA_CN,
                  rec.NAS_LUOGOECCEZIONALE_CN,
                  rec.NAS_NOMECOMUNE_CN, rec.NAS_CODICEISTAT_CN, rec.NAS_SIGLAPROVINCIAISTAT_CN,
                  rec.NAS_DESCRIZIONELOCALITA_CN, rec.NAS_DESCRIZIONESTATO_CN, rec.NAS_CODICESTATO_CN,
                  rec.IDSCHEDASOGGETTOANPR_CN, rec.IDSOGGETTOANSC_CN,
                  rec.MOR_DATAEVENTO, rec.MOR_LUOGOECCEZIONALE,
                  rec.MOR_NOMECOMUNE, rec.MOR_CODICEISTAT, rec.MOR_SIGLAPROVINCIAISTAT,
                  rec.MOR_DESCRIZIONELOCALITA, rec.MOR_DESCRIZIONESTATO, rec.MOR_CODICESTATO,
                  rec.MAT_DATAEVENTO, rec.MAT_LUOGOECCEZIONALE,
                  rec.MAT_NOMECOMUNE, rec.MAT_CODICEISTAT, rec.MAT_SIGLAPROVINCIAISTAT,
                  rec.MAT_DESCRIZIONELOCALITA, rec.MAT_DESCRIZIONESTATO, rec.MAT_CODICESTATO,
                  rec.UCI_DATAEVENTO, rec.UCI_LUOGOECCEZIONALE,
                  rec.UCI_NOMECOMUNE, rec.UCI_CODICEISTAT, rec.UCI_SIGLAPROVINCIAISTAT,
                  rec.UCI_DESCRIZIONELOCALITA, rec.UCI_DESCRIZIONESTATO, rec.UCI_CODICESTATO,
                  rec.SEP_TIPOACCORDO,  
                  rec.SEP_NOMECOMUNE_MAT, rec.SEP_CODICEISTAT_MAT, rec.SEP_SIGLAPROVINCIAISTAT_MAT, 
                  rec.SEP_ANNO_MAT, rec.SEP_NUMEROCOMUNALE_MAT, rec.SEP_DATAFORMAZIONEATTO_MAT,
                  rec.SEP_NOMECOMUNE_ACC, rec.SEP_CODICEISTAT_ACC, rec.SEP_SIGLAPROVINCIAISTAT_ACC, rec.SEP_DATATRASCRIZIONE_ACC,
                  rec.SEP_IDANSC_MAT, 
                  rec.SEP_NOMEENTE_PRO,               
                  rec.SEP_NOMECOMUNE_PRO, rec.SEP_CODICEISTAT_PRO, rec.SEP_SIGLAPROVINCIAISTAT_PRO, 
                  rec.SEP_DATATRASCRIZIONE_PRO, rec.SEP_ESTREMIDOCUMENTO_PRO,       
                  w_SENZACOGNOME_1, w_SENZANOME_1, w_IDANPR_1, 
                  w_SENZACOGNOME_2, w_SENZANOME_2, w_IDANPR_2,
                  rec.SENZACOGNOME_PD, rec.SENZANOME_PD, rec.SOGGETTOAIRE_PD, rec.IDANPR_PD,
                  rec.SENZACOGNOME_MD, rec.SENZANOME_MD, rec.SOGGETTOAIRE_MD, rec.IDANPR_MD, 
                  rec.SENZACOGNOME_CN, rec.SENZANOME_CN, rec.SOGGETTOAIRE_CN, rec.IDANPR_CN,
                  rec.SCI_MOTIVOSCIOGLIMENTO, rec.SCI_DATAEVENTO, rec.SCI_LUOGOECCEZIONALE, 
                  rec.SCI_NOMECOMUNE, rec.SCI_CODICEISTAT, rec.SCI_SIGLAPROVINCIAISTAT,
                  rec.SCI_DESCRIZIONELOCALITA, rec.SCI_DESCRIZIONESTATO, rec.SCI_CODICESTATO,
                  rec.CIT_INTESTATARIOAPOLIDE, rec.CIT_DATAACQUISIZIONE, rec.CIT_DATAREGISTRAZIONEDECRETO,
                  w_composizioneCompleta,
                  w_RES_LUOGOECCEZIONALE_1, 
                  w_RES_NOMECOMUNE_1, w_RES_CODICEISTAT_1, w_RES_SIGLAPROVINCIAISTAT_1,
                  w_RES_DESCRIZIONELOCALITA_1, w_RES_DESCRIZIONESTATO_1, w_RES_CODICESTATO_1,
                  w_RES_LUOGOECCEZIONALE_2, 
                  w_RES_NOMECOMUNE_2, w_RES_CODICEISTAT_2, w_RES_SIGLAPROVINCIAISTAT_2,
                  w_RES_DESCRIZIONELOCALITA_2, w_RES_DESCRIZIONESTATO_2, w_RES_CODICESTATO_2,
                  rec.RES_LUOGOECCEZIONALE_PD, 
                  rec.RES_NOMECOMUNE_PD, rec.RES_CODICEISTAT_PD, rec.RES_SIGLAPROVINCIAISTAT_PD,
                  rec.RES_DESCRIZIONELOCALITA_PD, rec.RES_DESCRIZIONESTATO_PD, rec.RES_CODICESTATO_PD, 
                  rec.RES_LUOGOECCEZIONALE_MD, 
                  rec.RES_NOMECOMUNE_MD, rec.RES_CODICEISTAT_MD, rec.RES_SIGLAPROVINCIAISTAT_MD,
                  rec.RES_DESCRIZIONELOCALITA_MD, rec.RES_DESCRIZIONESTATO_MD, rec.RES_CODICESTATO_MD, 
                  rec.RES_LUOGOECCEZIONALE_CN, 
                  rec.RES_NOMECOMUNE_CN, rec.RES_CODICEISTAT_CN, rec.RES_SIGLAPROVINCIAISTAT_CN,
                  rec.RES_DESCRIZIONELOCALITA_CN, rec.RES_DESCRIZIONESTATO_CN, rec.RES_CODICESTATO_CN, 
                  w_NAZ_DESCRIZIONESTATO_1, w_NAZ_CODICESTATO_1,
                  w_NAZ_DESCRIZIONESTATO_2, w_NAZ_CODICESTATO_2, 
                  rec.NAZ_DESCRIZIONESTATO_PD, rec.NAZ_CODICESTATO_PD, 
                  rec.NAZ_DESCRIZIONESTATO_MD, rec.NAZ_CODICESTATO_MD,
                  rec.NAZ_DESCRIZIONESTATO_CN, rec.NAZ_CODICESTATO_CN,
                  rec.TRA_TIPOMODIFICA, 
                  rec.TRA_DATACOMUNICAZIONE, rec.TRA_NOMEENTE, rec.TRA_DATATRASCRIZIONE, rec.TRA_ESTREMIDOCUMENTO,
                  rec.TRA_NOMECOMUNE, rec.TRA_CODICEISTAT, rec.TRA_SIGLAPROVINCIAISTAT,
                  rec.TRA_DESCRIZIONELOCALITA, rec.TRA_DESCRIZIONESTATO, rec.TRA_CODICESTATO,
                  rec.TRA_DATAPUBBLICAZIONESENTENZA, rec.TRA_DATADECORRENZASENTENZA,
                  rec.SEP_IDANSC_ACCSEP, 
                  rec.SEP_NOMECOMUNE_ACCSEP, rec.SEP_CODICEISTAT_ACCSEP, rec.SEP_SIGLAPROVINCIAISTAT_ACCSEP,
                  rec.SEP_ANNO_ACCSEP, rec.SEP_NUMEROCOMUNALE_ACCSEP, 
                  rec.SEP_IDTIPOCONTENUTO_ACCSEP, rec.SEP_NUMEROATTO_ACCSEP, rec.SEP_TIPOLOGIA_ACCSEP
             from dual
            where not exists (select 'x' from anpna0 b
                               where b.idAnsc = rec.idAnsc )
           ;
         end;
      end if;
  end loop;

  goto fine;

<< fine >>
  null;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end acquisisci_notifiche;

procedure acquisisci_operazioni
(a_servizio 		varchar2
,a_id_operazione	varchar2
,a_stato_lavorazione	varchar2
,a_tipo_operazione	varchar2
,a_campo_clob 		clob
)

is

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'acquisisci_operazioni';

w_xml			xmltype;
w_xml_clob		clob;

w_extract_str 		varchar2(255);
w_extract_str_1		varchar2(255);
w_extract_str_2  	varchar2(255);
w_extract_str_3		varchar2(255);
w_extract_str_4		varchar2(255);
w_extract_str_5  	varchar2(255);
w_extract_str_6  	varchar2(255) := 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"';
w_extract_str_7		varchar2(255) := 'xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"';
w_extract_str_8		varchar2(255) := 'xmlns:xsd="http://www.w3.org/2001/XMLSchema"';
w_extract_str_9		varchar2(255) := 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"';
w_extract_str_10	varchar2(255);

cursor sel_ope (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/idOperazioneComune') idOperazioneComune
     , extractValue(value(rowdata),w_root||'/operazioneRichiesta') operazioneRichiesta
     , extractValue(value(rowdata),w_root||'/dataOraRichiesta') dataOraRichiesta
     , extractValue(value(rowdata),w_root||'/dataProtocolloComune') dataProtocolloComune
     , extractValue(value(rowdata),w_root||'/dataDecorrenza') dataDecorrenza
     , extractValue(value(rowdata),w_root||'/dataDefinizionePratica') dataDefinizionePratica
     , extractValue(value(rowdata),w_root||'/idOperazioneANPR') idOperazioneANPR
     , extractValue(value(rowdata),w_root||'/esitoOperazione') esitoOperazioneANPR
  from table(XMLSequence(w_xml)) rowdata
;


w_errore		varchar2(4000);
errore			exception;

w_step                  number;

begin
w_step := 0;
  w_xml := xmltype(a_campo_clob);

w_step := 1;
  begin
    select tws.risposta_ok_str,
           tws.risposta_ok_str_1, tws.risposta_ok_str_2, tws.risposta_ok_str_3, tws.risposta_ok_str_4, tws.risposta_ok_str_5
      into w_extract_str, w_extract_str_1, w_extract_str_2, w_extract_str_3, w_extract_str_4, w_extract_str_5
      from anptws tws
     where codice = a_tipo_operazione
    ;
  exception
    when others then
         w_extract_str   := '';
         w_extract_str_1 := '';
         w_extract_str_2 := '';
         w_extract_str_3 := '';
         w_extract_str_4 := '';
         w_extract_str_5 := '';
  end;

--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'servizio '||a_servizio||' - id_operazione '||a_id_operazione||' - stato_lavorazione '||a_stato_lavorazione||' - tipo_operazione '||a_tipo_operazione, a_campo_clob);
--  ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'servizio '||a_servizio||' - id_operazione '||a_id_operazione||' - w_extract_str '||w_extract_str||' '||w_extract_str_1||' '||w_extract_str_2, a_campo_clob);

w_step := 2;
  w_xml 	:= w_xml.extract('/soapenv:Envelope/soapenv:Body'||w_extract_str||'/testataRisposta'
                                ,w_extract_str_6||' '||w_extract_str_7||' '||w_extract_str_8||' '||w_extract_str_9||' '||w_extract_str_1||' '||w_extract_str_2);
w_step := 3;
  w_xml_clob	:= xmltype.getclobval(w_xml);

w_step := 4;
  for rec in sel_ope('testataRisposta') loop
--      ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, 'operazione', 'idOperazioneComune '||rec.idOperazioneComune||' - operazioneRichiesta '||rec.operazioneRichiesta||' - idOperazioneANPR '||rec.idOperazioneANPR);
      if rec.idOperazioneANPR is not null then
w_step := 5;
         begin
           insert into anpope
                ( id_operazione, 
                  idOperazioneComune, operazioneRichiesta, dataOraRichiesta, 
                  dataProtocolloComune, dataDecorrenza, dataDefinizionePratica,
                  idOperazioneANPR, esitoOperazione, 
                  statoLavorazione, tipoOperazione,
                  xml_richiesta, xml_risposta)
           select a_id_operazione,
                  rec.idOperazioneComune, rec.operazioneRichiesta, rec.dataOraRichiesta, 
                  rec.dataProtocolloComune, rec.dataDecorrenza, rec.dataDefinizionePratica,
                  rec.idOperazioneANPR, rec.esitoOperazioneANPR, 
                  a_stato_lavorazione, a_tipo_operazione,
                  '', a_campo_clob
             from dual
            where not exists (select 'x' from anpope b
                               where b.id_operazione    = a_id_operazione
                                 and b.idOperazioneANPR = rec.idOperazioneANPR)
           ;
         end;
w_step := 6;
      end if;
  end loop;

  goto fine;

<< fine >>
w_step := 7;
  null;

exception
  when errore then
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_step||' - '||w_errore);
  when others then
       w_errore := 'errore - '||w_step||' ('||SQLERRM||')';
       ANPR_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore);
end acquisisci_operazioni;

function f_UTIL_leggi_campo_xml
(a_servizio   	IN      varchar2
,a_campo_clob	IN	clob
,a_tag_ricerca	IN	varchar2
)

return clob

IS

w_tag_in		varchar2(255);
w_tag_fi		varchar2(255);
w_len_tag_in		number;
w_pos_tag		number;
w_campo_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'leggi_campo_xml';

w_errore		varchar2(4000);
errore			exception;

begin
  if a_campo_clob is not null and a_tag_ricerca is not null then
     w_campo_clob := a_campo_clob;
     w_tag_in     := '<'||a_tag_ricerca||'>';
     w_tag_fi     := '</'||a_tag_ricerca||'>';
     w_len_tag_in := length(w_tag_in);
     w_campo_clob := substr(w_campo_clob,instr(w_campo_clob,w_tag_in)+w_len_tag_in);
     w_campo_clob := substr(w_campo_clob,1,instr(w_campo_clob,w_tag_fi)-1);
     w_campo_clob := replace(w_campo_clob,chr(10),'');
  end if;

  return w_campo_clob;

end f_UTIL_leggi_campo_xml;

function ws_test
(a_servizio 		varchar2
,a_id_operazione	varchar2
,a_tipo_operazione	varchar2
)

return clob

IS

w_servizio		varchar2(255) := a_servizio;
w_idOperazione		varchar2(255) := a_id_operazione;
w_dataOraRichiesta	varchar2(255) := to_char(sysdate,'yyyy-mm-dd')||'T'||to_char(sysdate,'hh24:mi:ss');

w_data_inp		varchar2(255);
w_data_inp_fine		varchar2(255);
w_data_iniziale         varchar2(255);
w_data_finale           varchar2(255);
w_dataIniziale		varchar2(255);
w_dataFinale		varchar2(255);

w_testataRichiesta	clob;
w_campo_clob 		clob;

begin
  w_testataRichiesta := ANPR_PKG.f_xml_testataRichiesta(a_servizio,a_id_operazione,a_tipo_operazione,'','','','');

  if w_servizio = 'P001' then
     begin
       select substr(a.valore,1,10)
            , rtrim(substr(a.valore,11,10))
         into w_data_inp
            , w_data_inp_fine
         from anpinp a
        where a.parametro = a_servizio||'_DATA'
       ;
     exception
       when others then
            w_data_inp := to_char(sysdate-7,'dd/mm/yyyy');
     end;

     w_data_iniziale := w_data_inp;
     if w_data_inp_fine is not null then
        w_data_finale := w_data_inp_fine;
     else
        w_data_finale := to_char(to_date(w_data_iniziale,'dd/mm/yyyy')+7,'dd/mm/yyyy');
     end if;
     w_dataIniziale           := f_ANPR_data(to_char(to_date(w_data_iniziale,'dd/mm/yyyy'),'j'));
     w_dataFinale             := f_ANPR_data(to_char(to_date(w_data_finale,'dd/mm/yyyy'),'j'));

w_campo_clob := '<tnsb:RichiestaP001'||
--                  ' xmlns:tns="http://sogei.it/ANPR/tipoDato"'||
--                  ' xmlns:tnsa="http://sogei.it/ANPR/vocabolarioP000sc"'||
                  ' xmlns:tnsb="http://sogei.it/ANPR/P000sc"'||
                  ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'||chr(10)||
w_testataRichiesta||
'<criteriRicerca>
<dataIniziale>'||w_dataIniziale||'</dataIniziale>
<dataFinale>'||w_dataFinale||'</dataFinale>
<idTipologia>1</idTipologia>
<idStatoRichiesta>2</idStatoRichiesta>
</criteriRicerca>
</tnsb:RichiestaP001>';
end if;

return w_campo_clob;

end ws_test;

end;
/
