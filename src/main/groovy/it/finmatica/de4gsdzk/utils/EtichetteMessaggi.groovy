package it.finmatica.de4gsdzk.utils

class EtichetteMessaggi {

    ////////////////////////////////////////* SEGNALAZIONI CAMPI OBBLIGATORI *////////////////////////////////////////

    public static final Map<String, String> Compilare_campi_obbligatori = [codice: "Compilare_campi_obbligatori", defaultValue: "Compilare i campi obbligatori"]

    public static final Map<String, String> Compilare_campi_obbligatori_sezione = [codice: "Compilare_campi_obbligatori_sezione", defaultValue: "Compilare i campi obbligatori della sezione"]

    public static final Map<String, String> Compilare_cdu = [codice: "Compilare_cdu", defaultValue: "Selezionare il caso d'uso"]

    public static final Map<String, String> Compilare_servizio_ANSC = [codice: "Compilare_servizio_ANSC", defaultValue: "Selezionare il servizio da eseguire"]

    public static final Map<String, String> Compilare_Codice_OTP = [codice: "Compilare_Codice_OTP", defaultValue: "Inserire codice OTP"]

    public static final Map<String, String> Compilare_tipo_archivio = [codice: "Compilare_tipo_archivio", defaultValue: "Selezionare il tipo di archivio di riferimento"]

    public static final Map<String, String> Compilare_campi_obbligatori_allegato_fascicolo = [codice: "Compilare_campi_obbligatori_allegato_fascicolo", defaultValue: "Indicare il fascicolo di riferimento"]

    public static final Map<String, String> Compilare_tipo_documento_fascicolo = [codice: "Compilare_tipo_documento_fascicolo", defaultValue: "Compilare il tipo documento ai fini dell'inserimento nel fascicolo dell'atto"]

    public static final Map<String, String> Compilare_campi_prospetto = [codice: "Compilare_campi_prospetto", defaultValue: "Compilare almeno uno tra i parametri:\n anno - data registrazione "]

    public static final Map<String, String> Compilare_campi_estrazione = [codice: "Compilare_campi_estrazione", defaultValue: "Compilare almeno uno tra i parametri:\n anno - data evento - data registrazione "]

    public static final Map<String, String> Compilare_campi_estrazione_certificati = [codice: "Compilare_campi_estrazione_certificati", defaultValue: "Compilare data emissione"]

    public static final Map<String, String> Compilare_estremi_atto = [codice: "Compilare_estremi_atto", defaultValue: "Estremi atto mancanti!"]

    public static final Map<String, String> Compilare_estremi_data_registrazione = [codice: "Compilare_estremi_data_registrazione", defaultValue: "Estremi data registrazione mancanti!"]

    public static final Map<String, String> Compilare_tipo_comune = [codice: "Compilare_tipo_comune", defaultValue: "Selezionare il comune di riferimento"]

    public static final Map<String, String> Compilare_tipo_comunicazione = [codice: "Compilare_tipo_comunicazione", defaultValue: "Selezionare il tipo di comunicazione"]

    public static final Map<String, String> Compilare_firmatario = [codice: "Compilare_firmatario", defaultValue: "Compilare il firmatario"]

    public static final Map<String, String> Compilare_margine = [codice: "Compilare_margine", defaultValue: "Selezionare il margine"]

    public static final Map<String, String> Compilare_funzione = [codice: "Compilare_funzione", defaultValue: "Selezionare la funzione"]

    public static final Map<String, String> Compilare_campi_obbligatori_protocollazione = [codice: "Compilare_campi_obbligatori_protocollazione", defaultValue: "Compilare anno e registro di riferimento per la protocollazione"]

    public static final Map<String, String> Compilare_campi_parto_plurimo = [codice: "Compilare_campi_parto_plurimo", defaultValue: "Compilare i dati relativi al parto gemellare"]

    public static final Map<String, String> Compilare_campi_cf = [codice: "Compilare_campi_cf", defaultValue: "Compilare cognome, nome, sesso, data, comune e provincia di nascita"]

    public static final Map<String, String> Compilare_tipo_registro = [codice: "Compilare_tipo_registro", defaultValue: "Selezionare il tipo registro di riferimento"]

    public static final Map<String, String> Compilare_note = [codice: "Compilare_note", defaultValue: "Compilare il campo note"]

    public static final Map<String, String> Compilare_formula = [codice: "Compilare_formula", defaultValue: "Selezionare la formula"]

    public static final Map<String, String> Compilare_campi_obbligatori_occhiello = [codice: "Compilare_campi_obbligatori_occhiello", defaultValue: "Compilare gli estremi dell'atto nell'occhiello"]

    public static final Map<String, String> Compilare_campi_obbligatori_comunicazione = [codice: "Compilare_campi_obbligatori_comunicazione", defaultValue: "Dati comunicazione incompleti"]

    public static final Map<String, String> Compilare_campi_obbligatori_anagrafe = [codice: "Compilare_campi_obbligatori_anagrafe", defaultValue: "Compilare campi obbligatori (anagrafe) "]

    public static final Map<String, String> Compilare_campi_obbligatori_atto = [codice: "Compilare_campi_obbligatori_atto", defaultValue: "Compilare ufficio, anno e tipo di atto (parte/serie)"]

    public static final Map<String, String> Compilare_campi_obbligatori_modello_istat = [codice: "Compilare_campi_obbligatori_modello_istat", defaultValue: "Compilare i campi obbligatori del modello"]

    public static final Map<String, String> Compilare_campi_obbligatori_nato = [codice: "Compilare_campi_obbligatori_nato", defaultValue: "Generalità del nato incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_padre = [codice: "Compilare_campi_obbligatori_padre", defaultValue: "Generalità del padre incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_madre = [codice: "Compilare_campi_obbligatori_madre", defaultValue: "Generalità della madre incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_sposo = [codice: "Compilare_campi_obbligatori_sposo", defaultValue: "Generalità dello sposo incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_sposa = [codice: "Compilare_campi_obbligatori_sposa", defaultValue: "Generalità della sposa incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_sposi = [codice: "Compilare_campi_obbligatori_sposi", defaultValue: "Generalità degli sposi incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_contraente_1 = [codice: "Compilare_campi_obbligatori_contraente_1", defaultValue: "Generalità del primo contraente incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_contraente_2 = [codice: "Compilare_campi_obbligatori_contraente_2", defaultValue: "Generalità del secondo contraente incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_contraenti = [codice: "Compilare_campi_obbligatori_contraenti", defaultValue: "Generalità dei contraenti incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_deceduto_a = [codice: "Compilare_campi_obbligatori_deceduto_a", defaultValue: "Compilare campi obbligatori deceduto/deceduta"]

    public static final Map<String, String> Compilare_campi_obbligatori_coniuge = [codice: "Compilare_campi_obbligatori_coniuge", defaultValue: "Generalità del coniuge incomplete"]

    public static final Map<String, String> Compilare_campi_obbligatori_intestatario = [codice: "Compilare_campi_obbligatori_intestatario", defaultValue: "Compilare i campi obbligatori dell'intestatario"]

    public static final Map<String, String> Compilare_campi_obbligatori_atto_nascita_sposo = [codice: "Compilare_campi_obbligatori_atto_nascita_sposo", defaultValue: "Dati incompleti per la registrazione dell'annotazione sull'atto di nascita dello sposo.\n Assicurarsi di aver selezionato la formula dell'annotazione e di aver inserito tutti i dati dell'atto di nascita"]

    public static final Map<String, String> Compilare_campi_obbligatori_atto_nascita_sposa = [codice: "Compilare_campi_obbligatori_atto_nascita_sposa", defaultValue: "Dati incompleti per la registrazione dell'annotazione sull'atto di nascita della sposa.\n Assicurarsi di aver selezionato la formula dell'annotazione e di aver inserito tutti i dati dell'atto di nascita"]

    public static final Map<String, String> Compilare_campi_obbligatori_atto_nascita_contraente_1 = [codice: "Compilare_campi_obbligatori_atto_nascita_contraente_1", defaultValue: "Dati incompleti per la registrazione dell'annotazione sull'atto di nascita del contraente 1.\n Assicurarsi di aver selezionato la formula dell'annotazione e di aver inserito tutti i dati dell'atto di nascita"]

    public static final Map<String, String> Compilare_campi_obbligatori_atto_nascita_contraente_2 = [codice: "Compilare_campi_obbligatori_atto_nascita_contraente_2", defaultValue: "Dati incompleti per la registrazione dell'annotazione sull'atto di nascita del contraente 2.\n Assicurarsi di aver selezionato la formula dell'annotazione e di aver inserito tutti i dati dell'atto di nascita"]

    public static final Map<String, String> Compilare_campi_obbligatori_atto_nascita_deceduto_a = [codice: "Compilare_campi_obbligatori_atto_nascita_deceduto_a", defaultValue: "Dati incompleti per la registrazione dell'annotazione sull'atto di nascita del deceduto/a.\n Assicurarsi di aver selezionato la formula dell'annotazione e di aver inserito tutti i dati dell'atto di nascita"]

    public static final Map<String, String> Compilare_campi_obbligatori_atto_nascita_intestatario = [codice: "Compilare_campi_obbligatori_atto_nascita_intestatario", defaultValue: "Dati incompleti per la registrazione dell'annotazione sull'atto di nascita dell'intestatario.\n Assicurarsi di aver selezionato la formula dell'annotazione e di aver inserito tutti i dati dell'atto di nascita"]

    public static final Map<String, String> Compilare_campi_obbligatori_atto_matrimonio = [codice: "Compilare_campi_obbligatori_atto_matrimonio", defaultValue: "Dati incompleti per la registrazione dell'annotazione sull'atto di matrimonio.\n Assicurarsi di aver selezionato la formula dell'annotazione e di aver inserito tutti i dati dell'atto di matrimonio"]

    public static final Map<String, String> Compilare_campi_obbligatori_atto_unione_civile = [codice: "Compilare_campi_obbligatori_atto_unione_civile", defaultValue: "Dati incompleti per la registrazione dell'annotazione sull'atto di unione civile.\n Assicurarsi di aver selezionato la formula dell'annotazione e di aver inserito tutti i dati dell'atto di unione civile"]

    public static final Map<String, String> Compilare_campi_obbligatori_convenzioni_patrimoniali = [codice: "Compilare_campi_obbligatori_convenzioni_patrimoniali", defaultValue: "Indicare il tipo di convenzioni patrimoniali adottate"]

    public static final Map<String, String> Compilare_campi_obbligatori_trasporto = [codice: "Compilare_campi_obbligatori_trasporto", defaultValue: "Compilare i campi relativi agli estremi del trasporto "]

    public static final Map<String, String> Compilare_campi_documenti_presentati = [codice: "Compilare_campi_documenti_presentati", defaultValue: "Compilare i campi comune/data noti della sezione 'Documenti Presentati' "]

    //public static final Map<String, String> Compilare_campi_obbligatori_dichiarante = [codice: "Compilare_campi_obbligatori_dichiarante", defaultValue: "Dati del dichiarante incompleti"]

    public static final Map<String, String> Compilare_campo_dichiarante = [codice: "Compilare_campo_dichiarante", defaultValue: "Selezionare il dichiarante"]

    public static final Map<String, String> Compilare_campo_comparente = [codice: "Compilare_campo_comparente", defaultValue: "Selezionare il comparente"]

    public static final Map<String, String> Compilare_campo_firmatario = [codice: "Compilare_campo_firmatario", defaultValue: "Selezionare il firmatario"]

    public static final Map<String, String> Compilare_campi_obbligatori_tipo_accordo = [codice: "Compilare_campi_obbligatori_tipo_accordo", defaultValue: "Selezionare il tipo di accordo"]

    public static final Map<String, String> Compilare_campi_obbligatori_tipo_divorzio = [codice: "Compilare_campi_obbligatori_tipo_divorzio", defaultValue: "Selezionare il tipo di divorzio"]

    public static final Map<String, String> Compilare_tipo_divorzio_altro_scioglimento = [codice: "Compilare_tipo_divorzio_altro_scioglimento", defaultValue: "Selezionare il caso specifico di scioglimento indicando se l'atto che si sta registrando è o meno una 'Mancata conferma accordo'"]

    public static final Map<String, String> Compilare_tipo_divorzio_altro_divorzio = [codice: "Compilare_tipo_divorzio_altro_divorzio", defaultValue: "Selezionare il caso specifico di divorzio che si sta registrando"]

    public static final Map<String, String> Compilare_tipo_atto = [codice: "Compilare_tipo_atto", defaultValue: "Selezionare il tipo di atto di riferimento"]

    public static final Map<String, String> Compilare_campi_ANPR = [codice: "Compilare_campi_ANPR", defaultValue: "Compilare cognome e nome o in alternativa il codice fiscale "]

    public static final Map<String, String> Compilare_campi_ricerca_individuo = [codice: "Compilare_campi_ricerca_individuo", defaultValue: "Compilare il cognome e il nome oppure, in alternativa, fornire almeno uno dei seguenti dati: Codice Fiscale, Matricola, Identificativo scheda ANPR o Identificativo unico nazionale."]

    public static final Map<String, String> Compilare_campi_ricerca_famiglia = [codice: "Compilare_campi_ricerca_famiglia", defaultValue: "Compilare Indirizzo e Numero Civico"]

    public static final Map<String, String> Compilare_genere_annotazione = [codice: "Compilare_genere_annotazione", defaultValue: "Selezionare il genere dell'annotazione ai fini della redazione del modello ISTAT SDSU"]

    public static final Map<String, String> Compilare_formula_e_tipo_atto_annotazione = [codice: "Compilare_formula_e_tipo_atto_annotazione", defaultValue: "Selezionare la formula e il tipo di atto cui l'annotazione è associata"]

    public static final Map<String, String> Compilare_tipo_certificato_categoria = [codice: "Compilare_tipo_certificato_categoria", defaultValue: "Selezionare la categoria del certificato"]

    //////////////////////////////////////* SEGNALAZIONI GENERICHE *//////////////////////////////////////

    public static final Map<String, String> CIA_fascicolata = [codice: "CIA_fascicolata", defaultValue: "La copia conforme dell'atto è stata inserita nel fascicolo"]

    public static final Map<String, String> Salvataggio_Completato = [codice: "Salvataggio_Completato", defaultValue: "Salvataggio Completato"]

    //////////////////////////////////////////////////* DOMANDONI *////////////////////////////////////////

    public static final Map<String, String> Ask_Sbustamento_File = [codice: "Ask_Sbustamento_File", defaultValue: "Il file risulta firmato. Si vuole procedere allo sbustamento?"]

    public static final Map<String, String> Ask_Aggiornamento_Testo = [codice: "Ask_Aggiornamento_Testo", defaultValue: "L'anteprima dell'atto è già stata generata.\n" +
            "Si vuole aprire il testo già elaborato oppure generare una nuova anteprima con i frammenti sopra visualizzati?"]

    public static final Map<String, String> Ask_Modifiche_In_Sospeso = [codice: "Ask_Modifiche_In_Sospeso", defaultValue: "Attenzione: eventuali modifiche in sospeso andranno perse.\n Proseguire?"]

    public static final Map<String, String> Ask_Chiusura_Atto = [codice: "Ask_Chiusura_Atto", defaultValue: "Attenzione: con l'operazione di chiusura l'atto verrà consolidato e, se richiesto, anche bloccato. Come si vuole procedere?"]

    public static final Map<String, String> Ask_Blocco_Atto = [codice: "Ask_Blocco_Atto", defaultValue: "Si vuole procedere con il blocco dell'atto?"]

    public static final Map<String, String> Ask_Annullamento_Atto = [codice: "Ask_Annullamento_Atto", defaultValue: "Attenzione: l'atto verrà annullato.\n Proseguire?"]

    public static final Map<String, String> Ask_Cancellazione_Record = [codice: "Ask_Cancellazione_Record", defaultValue: "Cancellare il record selezionato?"]

    public static final Map<String, String> Ask_Cancellazione_Fascicolo = [codice: "Ask_Cancellazione_Fascicolo", defaultValue: "Eliminare il documento selezionato dal fascicolo?"]

    public static final Map<String, String> Ask_Cancellazione_Annotazione = [codice: "Ask_Cancellazione_Annotazione", defaultValue: "Si vuole procedere con la cancellazione dell'annotazione selezionata e delle eventuali comunicazioni collegate?"]

    public static final Map<String, String> Ask_Cancellazione_associazione_formula = [codice: "Ask_Cancellazione_associazione_formula", defaultValue: "Cancellare l'associazione con la formula \n%s?"]

    public static final Map<String, String> Ask_Invio_Pec = [codice: "Ask_Invio_Pec", defaultValue: "Si vuole procedere con l'invio della pec al destinatario selezionato?"]

    public static final Map<String, String> Ask_Numerazione_Record = [codice: "Ask_Numerazione_Record", defaultValue: "Attenzione: si sta tentando di assegnare un numero definitivo all'atto corrente.\n" +
            "Il nuovo numero sarà il primo disponibile nel registro degli atti dell'anno in corso\n" +
            "Si vuole procedere?\n\n(Se sì, controllare il margine di stampa e la data redazione)"]

    public static final Map<String, String> Ask_Aggiornamento_Testo_Comunicazione = [codice: "Ask_Aggiornamento_Testo_Comunicazione", defaultValue: "La comunicazione selezionata risulta già elaborata. Si vuole rigenerare il testo?"]

    public static final Map<String, String> Ask_Aggiornamento_Annotazione = [codice: "Ask_Aggiornamento_Annotazione", defaultValue: "Attenzione! La modifica impatterà su tutte le annotazioni pregresse. Si vuole procedere con il salvataggio?"]

    public static final Map<String, String> Ask_Inserimento_Annotazione = [codice: "Ask_Inserimento_Annotazione", defaultValue: "La ricerca non ha restituito alcun risultato.\n Si vuole procedere comunque alla registrazione dell'annotazione?"]

    public static final Map<String, String> Ask_Comunicazioni_Atto = [codice: "Ask_Comunicazioni_Atto", defaultValue: "Attenzione! Sono presenti nuove comunicazioni automatiche da elaborare. \n Si desidera uscire comunque?"]

    public static final Map<String, String> Ask_Inserimento_Annotazione_Su_Atto = [codice: "Ask_Inserimento_Annotazione_Su_Atto", defaultValue: "Attenzione! Gli estremi dell'atto indicati corrispondono ad un atto presente in archivio.\n Si vuole procedere comunque alla registrazione dell'annotazione?"]

    public static final Map<String, String> Ask_Gestione_Minorenni = [codice: "Ask_Gestione_Minorenni", defaultValue: "Esistono soggetti minorenni nel nucleo familiare di %s.\nSi vuole verificare la presenza dei figli per la generazione dei conseguenti atti di acquisto cittadinanza?"]

    public static final Map<String, String> Ask_Formato_etichette = [codice: "Ask_Formato_etichette", defaultValue: "Per quale formato si vuole stampare l'etichetta?"]

    public static final Map<String, String> Ask_Conferma_Salvataggio = [codice: "Ask_Conferma_Salvataggio", defaultValue: "Si vuole procedere comunque al salvataggio dei dati?"]

    public static final Map<String, String> Ask_Conferma_Salvataggio_Documento = [codice: "Ask_Conferma_Salvataggio_Documento", defaultValue: "Si vuole procedere comunque al salvataggio del documento?"]

    public static final Map<String, String> Ask_Collegamento_Anagrafe = [codice: "Ask_Collegamento_Anagrafe", defaultValue: "Sono stati modificati i dati del soggetto: \n mantenere il collegamento con l'anagrafe"]
    public static final Map<String, String> Ask_Nuova_Ricerca_Anagrafe = [codice: "Ask_Nuova_Ricerca_Anagrafe", defaultValue: "Nessun collegamento con l'anagrafe: attivare ricerca soggetto con generalità modificate?"]

    public static final Map<String, String> Ask_Estremi_Protocollo_Incompleti = [codice: "Ask_Estremi_Protocollo_Incompleti", defaultValue: "Attenzione! Gli estremi del protocollo sono incompleti e non saranno compilati correttamente nel file.\n Si vuole procedere comunque?"]

    public static final Map<String, String> Ask_tipo_file_ANSC = [codice: "Ask_tipo_file_ANSC", defaultValue: "Il tipo di file che si sta caricando non risulta fra quelli ammessi ai fini dell'integrazione con ANSC.\nSi vuole procedere comunque?"]

    public static final Map<String, String> Ask_conferma_notifica_ANSC = [codice: "Ask_conferma_notifica_ANSC", defaultValue: "Si vuole procedere con la conferma della notifica selezionata?"]

    public static final Map<String, String> Ask_salvataggio_dati_firmatari_incompleti_ANSC = [codice: "Ask_salvataggio_dati_firmatari_incompleti_ANSC", defaultValue: "I dati relativi al tipo di firma da utilizzare risultano incompleti/non salvati!\n Si vuole passare comunque alla pagina di riepilogo per l'invio ad ANSC?"]

    public static final Map<String, String> Ask_salvataggio_allegati_obbligatori_incompleti_ANSC = [codice: "Ask_salvataggio_allegati_obbligatori_incompleti_ANSC", defaultValue: "Attenzione: allegati obbligatori non completi.\n Si vuole passare comunque alla pagina per l'invio ad ANSC?"]

    public static final Map<String, String> Ask_salvataggio_allegati_non_obbligatori_incompleti_ANSC = [codice: "Ask_salvataggio_allegati_non_obbligatori_incompleti_ANSC", defaultValue: "Attenzione: nessun allegato caricato.\n Si vuole passare comunque alla pagina per l'invio ad ANSC?"]

    public static final Map<String, String> Ask_salvataggio_otp_ANSC = [codice: "Ask_salvataggio_otp_ANSC", defaultValue: "Si desidera salvare l'otp ANSC per il suo periodo di validità in modo da non doverlo reinserire ad ogni invio?"]

    public static final Map<String, String> Ask_Cancellazione_associazione_servizio_ANSC = [codice: "Ask_Cancellazione_associazione_servizio_ANSC", defaultValue: "Cancellare l'associazione con il servizio \n%s?"]

    public static final Map<String, String> Ask_annotazione_nascita_mancante = [codice: "Ask_annotazione_nascita_mancante", defaultValue: "Attenzione: Atto di nascita dell'intestatario non presente in archivio.\n Come si vuole procedere?"]

    public static final Map<String, String> Ask_ANPR_generazione_cer_forzata = [codice: "Ask_ANPR_generazione_cer_forzata", defaultValue: "Si vuole riprovare ignorando gli errori sull'anagrafica?"]

    public static final Map<String, String> Ask_Ripristino_Certificato = [codice: "Ask_Ripristino_Certificato", defaultValue: "Attenzione: il certificato è annullato.\nSi vuole procedere con il ripristino?"]

    public static final Map<String, String> Ask_Annulla_pagamento = [codice: "Ask_Annulla_pagamento", defaultValue: "Attenzione: l'annullamento sarà eseguito solo se il pagamento non è già stato effettuato.\nIn tal caso il pagamento verrà eliminato e non sarà possibile inviarlo nuovamente.\nSi vuole procedere con l'annullamento?"]

    public static final Map<String, String> Ask_Modifica_fondo_cassa = [codice: "Ask_Modifica_fondo_cassa", defaultValue: "Si vuole confermare la modifica del fondo cassa già inserito?"]

    public static final Map<String, String> Ask_Archiviazione_Documento_Individuo = [codice: "Ask_Archiviazione_Documento_Individuo", defaultValue: "Si vuole procedere con l'archiviazione del certificato collegandolo al documento individuo %s numero %s?"]

    public static final Map<String, String> Ask_Caricamento_Logo = [codice: "Ask_Caricamento_Logo", defaultValue: "Si vuole procedere con il caricamento del nuovo logo?"]

    public static final Map<String, String> Ask_Cancellazione_Logo = [codice: "Ask_Cancellazione_Logo", defaultValue: "Si vuole procedere con la cancellazione del logo?"]

    //////////////////////////////////////////////////* WARNINGS *////////////////////////////////////////

    public static final Map<String, String> Warn_comunicazione_fascicolata = [codice: "Warn_comunicazione_fascicolata", defaultValue: "La comunicazione risulta già inserita nel fascicolo con tutti i suoi allegati"]

    public static final Map<String, String> Warn_file_modello_comunicazione = [codice: "Warn_file_modello_comunicazione", defaultValue: "Attenzione! Nome modello non coerente con la comunicazione selezionata"]

    public static final Map<String, String> Warn_dati_protocollo_incompleti = [codice: "Warn_dati_protocollo_incompleti", defaultValue: "Attenzione! Estremi protocollo incompleti"]

    public static final Map<String, String> Warn_Dati_Occhiello = [codice: "Warn_Dati_Occhiello", defaultValue: "Attenzione!\n" +
            "I dati dell'occhiello potrebbero non rientrare nello spazio previsto.\n" +
            "Lanciare l'anteprima e, in caso di blocco, riaprire l'anteprima e modificare i dati dell'occhiello di maggiore lunghezza passando al minuscolo o troncandoli per recuperare spazio."]

    public static final Map<String, String> Warn_Data_Nascita_Anni_Alternativi = [codice: "Warn_Data_Nascita_Anni_Alternativi", defaultValue: "ATTENZIONE! Sono stati indicati sia la data di nascita che gli anni"]

    public static final Map<String, String> Warn_Trattamento_Dati = [codice: "Warn_Trattamento_Dati", defaultValue: "Attenzione: non è stato dato il consenso al Trattamento dei Dati (%s)"]

    public static final Map<String, String> Warn_Matricola_Richiedente_nulla = [codice: "Warn_Matricola_Richiedente_nulla", defaultValue: "Attenzione: la matricola del richiedente non risulta valorizzata."]
    public static final Map<String, String> Warn_Matricola_Richiedente_nulla_ma_soggetto_in_anagrafe = [codice: "Warn_Matricola_Richiedente_nulla_ma_soggetto_in_anagrafe", defaultValue: "Attenzione: la matricola del richiedente non risulta valorizzata, ma esiste in anagrafe un soggetto residente con le stesse generalità del richiedente"]
    public static final Map<String, String> Warn_Residenza_Richiedente_Cambiata = [codice: "Warn_Residenza_Richiedente_Cambiata", defaultValue: "Attenzione: il comune di residenza del richiedente è cambiato"]

    public static final Map<String, String> Warn_Matricola_Contraente_2_nulla = [codice: "Warn_Matricola_Contraente_2_nulla", defaultValue: "Attenzione: la matricola del contraente 2 non risulta valorizzata."]
    public static final Map<String, String> Warn_Matricola_Contraente_2_nulla_ma_soggetto_in_anagrafe = [codice: "Warn_Matricola_Contraente_2_nulla_ma_soggetto_in_anagrafe", defaultValue: "Attenzione: la matricola del contraente 2 non risulta valorizzata, ma esiste in anagrafe un soggetto residente con le stesse generalità del contraente 2"]
    public static final Map<String, String> Warn_Residenza_Contraente_2_Cambiata = [codice: "Warn_Residenza_Contraente_2_Cambiata", defaultValue: "Attenzione: il comune di residenza del contraente 2 è cambiato"]

    public static final Map<String, String> Warn_Matricola_Contraente_1_nulla = [codice: "Warn_Matricola_Contraente_1_nulla", defaultValue: "Attenzione: la matricola del contraente 1 non risulta valorizzata."]
    public static final Map<String, String> Warn_Matricola_Contraente_1_nulla_ma_soggetto_in_anagrafe = [codice: "Warn_Matricola_Contraente_1_nulla_ma_soggetto_in_anagrafe", defaultValue: "Attenzione: la matricola del contraente 1 non risulta valorizzata, ma esiste in anagrafe un soggetto residente con le stesse generalità del contraente 1"]
    public static final Map<String, String> Warn_Residenza_Contraente_1_Cambiata = [codice: "Warn_Residenza_Contraente_1_Cambiata", defaultValue: "Attenzione: il comune di residenza del contraente 1 è cambiato"]

    public static final Map<String, String> Warn_Matricola_Sposa_nulla = [codice: "Warn_Matricola_Sposa_nulla", defaultValue: "Attenzione: la matricola dello sposa non risulta valorizzata."]
    public static final Map<String, String> Warn_Matricola_Sposa_nulla_ma_soggetto_in_anagrafe = [codice: "Warn_Matricola_Sposa_nulla_ma_soggetto_in_anagrafe", defaultValue: "Attenzione: la matricola dello sposa non risulta valorizzata ma esiste in anagrafe un soggetto residente con le stesse generalità della sposa"]
    public static final Map<String, String> Warn_Residenza_Sposa_Cambiata = [codice: "Warn_Residenza_Sposa_Cambiata", defaultValue: "Attenzione: il comune di residenza della sposa è cambiato"]

    public static final Map<String, String> Warn_Matricola_Sposo_nulla = [codice: "Warn_Matricola_Sposo_nulla", defaultValue: "Attenzione: la matricola dello sposo non risulta valorizzata"]
    public static final Map<String, String> Warn_Matricola_Sposo_nulla_ma_soggetto_in_anagrafe = [codice: "Warn_Matricola_Sposo_nulla_ma_soggetto_in_anagrafe", defaultValue: "Attenzione: la matricola dello sposo non risulta valorizzata, ma esiste in anagrafe un soggetto residente con le stesse generalità dello sposo"]
    public static final Map<String, String> Warn_Residenza_Sposo_Cambiata = [codice: "Warn_Residenza_Sposo_Cambiata", defaultValue: "Attenzione: il comune di residenza dello sposo è cambiato"]

    public static final Map<String, String> Warn_Estremi_Atto_Parziali = [codice: "Warn_Estremi_Atto_Parziali", defaultValue: "Gli estremi dell'atto risultano già parzialmente o completamente indicati"]

    public static final Map<String, String> Warn_Inserimento_In_Anagrafe = [codice: "Warn_Inserimento_In_Anagrafe", defaultValue: "Soggetto già presente in anagrafe. L'atto non verrà passato in anagrafe"]

    public static final Map<String, String> Warn_Nessuna_comunicazione_da_inviare_albo = [codice: "Warn_Nessuna_comunicazione_da_inviare_albo", defaultValue: "Nessuna comunicazione da inviare all'albo"]

    public static final Map<String, String> Warn_Nessuna_comunicazione_da_protocollare = [codice: "Warn_Nessuna_comunicazione_da_protocollare", defaultValue: "Nessuna comunicazione da protocollare"]

    public static final Map<String, String> Warn_Nessuna_comunicazione_selezionata = [codice: "Warn_Nessuna_comunicazione_selezionata", defaultValue: "Nessuna comunicazione da elaborare"]

    public static final Map<String, String> Warn_Aggiornamento_Formule = [codice: "Warn_Aggiornamento_Formule", defaultValue: "Attenzione!\n" +
            "Qualora siano stati modificati dati che incidano\n" +
            "sul corpo dell'atto, procedere con l'aggiornamento delle\n" +
            "singole formule o dell'intero testo."]

    public static final Map<String, String> Warn_ricerca_in_anagrafe = [codice: "Warn_ricerca_in_anagrafe", defaultValue: "Per soggetto residente, eseguire la ricerca in anagrafe tramite la lentina e verificare la correttezza dei dati"]

    public static final Map<String, String> Warn_verifica_in_anagrafe = [codice: "Warn_verifica_in_anagrafe", defaultValue: "Per conferma, eseguire la ricerca tramite la lentina e verificare la correttezza dei dati"]

    public static final Map<String, String> Warn_Cambio_Caso_Uso_Allegati = [codice: "Warn_Cambio_Caso_Uso_Allegati", defaultValue: "Attenzione: il caso d'uso ANSC è stato modificato. Si consiglia di verificare nuovamente gli allegati."]

    public static final Map<String, String> Warn_Categoria_obsoleta_ANSC = [codice: "Warn_Categoria_obsoleta_ANSC", defaultValue: "Attenzione: categoria non valida per ANSC"]

    public static final Map<String, String> Warn_Caso_Uso_non_implementato_ANSC = [codice: "Warn_Caso_Uso_non_implementato_ANSC", defaultValue: "Attenzione: caso d'uso %s non configurato"]

    public static final Map<String, String> Warn_annullamento_certificato_esterno = [codice: "Warn_annullamento_certificato_esterno", defaultValue: "Attenzione: il certificato è collegato ad un certificato esterno. Verrà annullato solo il certificato locale."]

    public static final Map<String, String> Warn_Sincronizzazione_nessun_elemento = [codice: "Warn_Sincronizzazione_nessun_elemento", defaultValue: "Attenzione: nessun nuovo elemento è stato inserito"]

    public static final Map<String, String> Warn_Nessun_elemento_selezionato = [codice: "Warn_Nessuna_comunicazione_selezionata", defaultValue: "Nessun elemento selezionato"]

    public static final Map<String, String> Warn_Data_Riepilogo_Non_Valida = [codice: "Warn_Data_Riepilogo_Non_Valida", defaultValue: "Attenzione: riepilogo non valido per le date emissione indicate"]

    //////////////////////////////////////////////////* MESSAGGI DI ERRORE *////////////////////////////////////////

    public static final Map<String, String> Errore_serie = [codice: "Errore_serie", defaultValue: "Valore serie inammissibile"]

    public static final Map<String, String> Errore_parte = [codice: "Errore_parte", defaultValue: "Valore parte inammissibile"]

    public static final Map<String, String> Errore_parametro = [codice: "Errore_parametro", defaultValue: "Errore in recupero parametro di configurazione"]

    public static final Map<String, String> Errore_valore_ora = [codice: "Errore_valore_ora", defaultValue: "Ora non valida. Inserire un valore compreso nell'intervallo 0-24."]

    public static final Map<String, String> Errore_ora_imprecisata = [codice: "Errore_ora_imprecisata", defaultValue: "Ora non valida: impostare un valore per l'ora o valorizzarla come imprecisata"]

    public static final Map<String, String> Errore_valore_minuti = [codice: "Errore_valore_minuti", defaultValue: "Minuti non validi. Inserire un valore compreso nell'intervallo 0-59."]

    public static final Map<String, String> Errore_minuti_imprecisati = [codice: "Errore_minuti_imprecisati", defaultValue: "Minuti non validi: impostare un valore per i minuti o valorizzarli come imprecisati"]

    public static final Map<String, String> Errore_Lunghezza_Campo = [codice: "Errore_Lunghezza_Campo", defaultValue: "Errore in validazione: valore troppo grande per il campo"]

    public static final Map<String, String> Errore_Comune = [codice: "Errore_Comune", defaultValue: "Comune non valido"]

    public static final Map<String, String> Errore_Via = [codice: "Errore_Via", defaultValue: "Via non valida"]

    public static final Map<String, String> Errore_carattere_a_capo_non_ammesso = [codice: "Errore_carattere_a_capo_non_ammesso", defaultValue: "Il testo contiene il carattere 'a capo' non ammesso"]

    public static final Map<String, String> Errore_data_futura = [codice: "Errore_data_futura", defaultValue: "Data futura non ammessa"]

    public static final Map<String, String> Errore_data_nascita_vs_1A = [codice: "Errore_data_nascita_vs_1A", defaultValue: "Data di nascita non compatibile con il tipo di atto selezionato: non deve essere inferiore a 10 giorni dalla data odierna"]

    public static final Map<String, String> Errore_data_nascita_vs_1B = [codice: "Errore_data_nascita_vs_1B", defaultValue: "Data di nascita non compatibile con il tipo di atto selezionato: la data inserita non risulta antecedente di 10 giorni rispetto alla data odierna"]

    public static final Map<String, String> Errore_comune_nascita_vs_parte_serie = [codice: "Errore_comune_nascita_vs_parte_serie", defaultValue: "Comune nascita non compatibile con parte e serie"]

    public static final Map<String, String> Errore_comune_residenza_vs_parte_serie = [codice: "Errore_comune_residenza_vs_parte_serie", defaultValue: "Comune residenza non compatibile con parte e serie"]

    public static final Map<String, String> Errore_stato_civile_genitori = [codice: "Errore_stato_civile_genitori", defaultValue: "Attenzione: risulta un'incongruenza nello stato civile dei genitori."]

    public static final Map<String, String> Errore_dati_parto_plurimo = [codice: "Errore_dati_parto_plurimo", defaultValue: "Dati sul parto gemellare incompleti"]

    public static final Map<String, String> Errore_formula_libretto_internazionale = [codice: "Errore_formula_libretto_internazionale", defaultValue:"Errore in compilazione dati sul libretto internazionale di famiglia:\nl'atto deve essere originale o trascritto e almeno uno degli sposi deve essere di nazionalità italiana"]

    public static final Map<String, String> Errore_sesso_contraenti = [codice: "Errore_sesso_contraenti", defaultValue: "Errore in validazione: i contraenti non risultano dello stesso sesso"]

    public static final Map<String, String> Errore_tipo_divorzio = [codice: "Errore_tipo_divorzio", defaultValue: "Il tipo di divorzio selezionato non è compatibile con il tipo di atto selezionato"]

    public static final Map<String, String> Errore_natura_vs_categoria = [codice: "Errore_natura_vs_categoria", defaultValue: "Natura non compatibile con la categoria selezionata"]

    public static final Map<String, String> Errore_natura_vs_certificazione = [codice: "Errore_natura_vs_certificazione", defaultValue: "Atto non certificabile"]

    public static final Map<String, String> Errore_natura_vs_tipo_atto = [codice: "Errore_natura_vs_tipo_atto", defaultValue: "Natura non compatibile con il tipo di atto selezionato"]

    public static final Map<String, String> Errore_creazione_frammenti_formula = [codice: "Errore_creazione_frammenti_formula", defaultValue: "Operazione non consentita: alla formula è possibile associare al massimo 30 frammenti."]

    public static final Map<String, String> Errore_caricamento_formule = [codice: "Errore_caricamento_formule", defaultValue: "Errore in caricamento formule."]

    public static final Map<String, String> Errore_cancellazione_tipo_atto = [codice: "Errore_cancellazione_tipo_atto", defaultValue: "Operazione non consentita: \ncancellazione permessa per i soli tipi di atto associati a testo libero e NON referenziati da alcun atto"]

    public static final Map<String, String> Errore_modifica_tipo_documento_x_fascicolazione = [codice: "Errore_modifica_tipo_documento_x_fascicolazione", defaultValue: "Modifica non consentita: esistono fascicoli associati a questa tipologia di documento"]

    public static final Map<String, String> Errore_no_tipo_documento_x_fascicolazione = [codice: "Errore_no_tipo_documento_x_fascicolazione", defaultValue: "Errore in fase di fascicolazione:\n non è stato possibile inserire la comunicazione nel fascicolo dell'atto poiché non è stato indicato il tipo documento cui associarla ai fini della fascicolazione nella corrispondente maschera di configurazione"]

    public static final Map<String, String> Errore_Db_Integrity = [codice: "Errore_Db_Integrity", defaultValue: "Oggetto non modificabile o eliminabile: esistono dipendenze"]

    public static final Map<String, String> Errore_Db_Constraint_Violation = [codice: "Errore_Db_Constraint_Violation", defaultValue: "Salvataggio non consentito: \nla registrazione risulta associata ad estremi (valori identificativi) già in uso"]

    public static final Map<String, String> Errore_Db_Modifiche_Concorrenti = [codice: "Errore_Db_Modifiche_Concorrenti", defaultValue: "Errore in fase di salvataggio. Record modificato da altro utente."]

    public static final Map<String, String> Errore_Operazione_non_consentita = [codice: "Errore_Operazione_non_consentita", defaultValue: "Operazione non consentita"]

    public static final Map<String, String> Errore_apertura_record = [codice: "Errore_apertura_record", defaultValue: "Errore in visualizzazione dati."]

    public static final Map<String, String> Errore_Inserimento_Record_Rubrica_Duplicato = [codice: "Errore_Inserimento_Rubrica", defaultValue: "Registrazione con gli stessi estremi atto già presente in rubrica!"]

    public static final Map<String, String> Errore_Inserimento_Minuta_Duplicata = [codice: "Errore_Inserimento_Minuta_Duplicata", defaultValue: "Minuta già presente!"]

    public static final Map<String, String> Errore_Inserimento_Ente_Duplicato = [codice: "Errore_Inserimento_Ente_Duplicato", defaultValue: "Ente già presente!"]

    public static final Map<String, String> Errore_Inserimento_Registro_Duplicato = [codice: "Errore_Inserimento_Registro_Duplicato", defaultValue: "Registro già presente!"]

    public static final Map<String, String> Errore_Inserimento_Relazione_Duplicata = [codice: "Errore_Inserimento_Relazione_Duplicata", defaultValue: "Relazione duplicata!"]

    public static final Map<String, String> Errore_Inserimento_Record_duplicato = [codice: "Errore_Inserimento_Record_duplicato", defaultValue: "Esiste già una registrazione associata agli stessi valori!"]

    public static final Map<String, String> Errore_Inserimento_Comunicazione_Duplicata = [codice: "Errore_Inserimento_Comunicazione_Duplicata", defaultValue: "Comunicazione già presente!"]

    public static final Map<String, String> Errore_Inserimento_Formula_Duplicata = [codice: "Errore_Inserimento_Formula_Duplicata", defaultValue: "Formula già presente!"]

    public static final Map<String, String> Errore_Protocollo_TC = [codice: "Errore_Protocollo_TC", defaultValue: "Attenzione! Sono stati indica indicati numeri di protocollo differenti per lo stesso registro e lo stesso anno nelle sezioni Trasporto e Cremazione"]
    public static final Map<String, String> Errore_Protocollo_TS = [codice: "Errore_Protocollo_TS", defaultValue: "Attenzione! Sono stati indica indicati numeri di protocollo differenti per lo stesso registro e lo stesso anno nelle sezioni Trasporto e Seppellimento"]
    public static final Map<String, String> Errore_Protocollo_CS = [codice: "Errore_Protocollo_CS", defaultValue: "Attenzione! Sono stati indica indicati numeri di protocollo differenti per lo stesso registro e lo stesso anno nelle sezioni Cremazione e Seppellimento"]

    public static final Map<String, String> Errore_Numero_Protocollo = [codice: "Errore_Numero_Protocollo", defaultValue: "Protocollo già assegnato per l'anno e il registro selezionati"]

    public static final Map<String, String> Errore_atto_nascita_sposo_non_presente_in_archivio = [codice: "Errore_atto_nascita_sposo_non_presente_in_archivio", defaultValue:"Atto di nascita dello sposo non presente in archivio!"]

    public static final Map<String, String> Errore_atto_nascita_sposa_non_presente_in_archivio = [codice: "Errore_atto_nascita_sposa_non_presente_in_archivio", defaultValue:"Atto di nascita dello sposa non presente in archivio!"]

    public static final Map<String, String> Errore_atto_nascita_contraente_1_non_presente_in_archivio = [codice: "Errore_atto_nascita_contraente_1_non_presente_in_archivio", defaultValue:"Atto di nascita del primo contraente non presente in archivio!"]

    public static final Map<String, String> Errore_atto_nascita_contraente_2_non_presente_in_archivio = [codice: "Errore_atto_nascita_contraente_2_non_presente_in_archivio", defaultValue:"Atto di nascita del secondo contraente non presente in archivio!"]

    public static final Map<String, String> Errore_atto_nascita_deceduto_non_presente_in_archivio = [codice: "Errore_atto_nascita_deceduto_non_presente_in_archivio", defaultValue:"Atto di nascita del deceduto non presente in archivio!"]

    public static final Map<String, String> Errore_atto_nascita_intestatario_non_presente_in_archivio = [codice: "Errore_atto_nascita_intestatario_non_presente_in_archivio", defaultValue:"Atto di nascita dell'intestatario non presente in archivio!"]

    public static final Map<String, String> Errore_atto_nascita_soggetto_non_compatibile = [codice: "Errore_atto_nascita_soggetto_non_compatibile", defaultValue: "Intestatario dell'atto di nascita non compatibile con il soggetto indicato!"]

    public static final Map<String, String> Errore_atto_matrimonio_non_presente_in_archivio = [codice: "Errore_atto_matrimonio_non_presente_in_archivio", defaultValue:"Atto di matrimonio non presente in archivio!"]

    public static final Map<String, String> Errore_atto_unione_civile_non_presente_in_archivio = [codice: "Errore_atto_unione_civile_non_presente_in_archivio", defaultValue:"Atto di unione civile non presente in archivio!"]

    public static final Map<String, String> Errore_creazione_atto_cittadinanza_minorenne = [codice: "Errore_creazione_atto_cittadinanza_minorenne", defaultValue:"Errore in fase di generazione dell'atto di cittadinanza per il minore %s "]

    public static final Map<String, String> Errore_salvataggio = [codice: "Errore_salvataggio", defaultValue: "Errore in fase di salvataggio"]

    public static final Map<String, String> Errore_nome_file =  [codice: "Errore_nome_file", defaultValue:"Nome file non accettabile: contiene caratteri non ammessi"]

    public static final Map<String, String> Errore_file = [codice: "Errore_file", defaultValue: "File non accettabile"]

    public static final Map<String, String> Errore_file_formato = [codice: "Errore_file_formato", defaultValue: "File in formato non accettabile"]

    public static final Map<String, String> Errore_recupero_file_documentale =  [codice: "Errore_recupero_file_documentale", defaultValue:"Impossibile accedere al file: documento non presente sul documentale"]

    public static final Map<String, String> Errore_cancellazione_file_documentale =  [codice: "Errore_cancellazione_file_documentale", defaultValue:"Impossibile cancellare il file: documento non presente sul documentale"]

    public static final Map<String, String> Errore_salvataggio_file_documentale = [codice: "Errore_salvataggio_file_documentale", defaultValue: "Errore in fase di salvataggio: impossibile registrare il documento su sistema documentale"]

    public static final Map<String, String> Errore_salvataggio_file_documentale_individuo = [codice: "Errore_salvataggio_file_documentale_individuo", defaultValue: "Errore in fase di salvataggio: impossibile registrare il Documento Individuo su sistema documentale"]

    public static final Map<String, String> Errore_sbustamento_file =  [codice: "Errore_sbustamento_file", defaultValue:"Operazione non consentita: il file risulta firmato"]

    public static final Map<String, String> Errore_file_vuoto = [codice: "Errore_file_vuoto", defaultValue: "Operazione non consentita: il file risulta vuoto"]

    public static final Map<String, String> Errore_file_nome_vuoto = [codice: "Errore_file_nome_vuoto", defaultValue:"Operazione non consentita: il nome del file risulta vuoto"]

    public static final Map<String, String> Errore_nome_allegato_esistente = [codice: "Errore_nome_allegato_esistente", defaultValue: "Nome allegato già presente per il documento indicato"]

    public static final Map<String, String> Errore_natura_stampa_CIA = [codice: "Errore_natura_stampa_CIA", defaultValue: "Operazione non consentita: non è possibile generare la copia conforme di atti non originali"]

    public static final Map<String, String> Errore_fascicolazione_CIA = [codice: "Errore_fascicolazione_CIA", defaultValue: "Non è stato possibile inserire la copia conforme nel fascicolo dell'atto"]

    public static final Map<String, String> Errore_no_tipo_documento_fascicolazione_CIA = [codice: "Errore_no_tipo_documento_fascicolazione_CIA", defaultValue: "Non è stata definito il tipo di documento al quale associare la copia conforme nel fascicolo dell'atto.\nLa copia conforme NON è stata inserita nel fascicolo"]

    public static final Map<String, String> Errore_modifica_tipo_documento_fascicolo_atto = [codice: "Errore_modifica_tipo_documento_fascicolo_atto", defaultValue: "Operazione non consentita: esistono comunicazioni ad ANSC collegate a documenti del fascicolo selezionato"]

    public static final Map<String, String> Errore_cancellazione_allegato_fascicolo_atto = [codice: "Errore_cancellazione_allegato_fascicolo_atto", defaultValue: "Cancellazione non consentita: esistono comunicazioni ad ANSC collegate al documento selezionato"]

    public static final Map<String, String> Errore_cancellazione_fascicolo_atto = [codice: "Errore_cancellazione_fascicolo_atto", defaultValue: "Cancellazione non consentita: il fascicolo dell'atto contiene degli allegati"]

    public static final Map<String, String> Errore_inserimento_nome_allegato_fascicolo_atto = [codice: "Errore_inserimento_nome_allegato_fascicolo_atto", defaultValue: "Non è possibile procedere con il salvataggio dell'allegato:\n esiste già un allegato con lo stesso nome associato al tipo documento selezionato"]

    public static final Map<String, String> Errore_ISTAT_chiusura_atto_provvisorio = [codice: "Errore_ISTAT_chiusura_atto_provvisorio", defaultValue: "Non è consentito impostare come 'completo' il modello di un atto con numerazione provvisoria"]

    public static final Map<String, String> Errore_consolidamento_atto_provvisorio = [codice: "Errore_consolidamento_atto_provvisorio", defaultValue: "Operazione non consentita. Non è possibile consolidare (o bloccare) atti provvisori"]

    public static final Map<String, String> Errore_modifica_comunicazione = [codice: "Errore_modifica_comunicazione", defaultValue: "Errore in fase di salvataggio: comunicazione non modificabile"]

    public static final Map<String, String> Errore_selezione_comunicazione = [codice: "Errore_selezione_comunicazione", defaultValue: "Comunicazione già associata all'atto selezionato nella stessa data"]

    public static final Map<String, String> Errore_protocollazione_comunicazioni_provvisorie = [codice: "Errore_protocollazione_comunicazioni_provvisorie", defaultValue: "Non è consentito protocollare/inviare all'albo comunicazioni di atti con numerazione provvisoria"]

    public static final Map<String, String> Errore_esecuzione_comunicazioni_protocollate = [codice: "Errore_esecuzione_comunicazioni_protocollate", defaultValue: "Non è consentito elaborare comunicazioni già protocollate"]

    public static final Map<String, String> Errore_esecuzione_comunicazioni_inviate_albo = [codice: "Errore_esecuzione_comunicazioni_inviate_albo", defaultValue: "Non è consentito elaborare comunicazioni già inviate all'albo"]

    public static final Map<String, String> Errore_modifica_comunicazioni_protocollate = [codice: "Errore_modifica_comunicazioni_protocollate", defaultValue: "Non è consentito modificare comunicazioni protocollate"]

    public static final Map<String, String> Errore_modifica_comunicazioni_inviate_albo = [codice: "Errore_modifica_comunicazioni_inviate_albo", defaultValue: "Non è consentito modificare comunicazioni inviate all'albo"]

    public static final Map<String, String> Errore_modifica_comunicazioni_eseguite = [codice: "Errore_modifica_comunicazioni_eseguite", defaultValue: "Non è consentito modificare/cancellare comunicazioni già eseguite"]

    public static final Map<String, String> Errore_inserimento_nome_allegato_comunicazione = [codice: "Errore_inserimento_nome_allegato_comunicazione", defaultValue: "Non è possibile procedere con il salvataggio dell'allegato:\n esiste già un allegato con lo stesso nome associato alla comunicazione selezionata"]

    public static final Map<String, String> Errore_invio_pec_comunicazione_non_protocollata = [codice: "Errore_invio_pec_comunicazione_non_protocollata", defaultValue: "Operazione non consentita:\nNon è consentito inviare pec di comunicazioni non protocollate"]

    public static final Map<String, String> Errore_testo_principale_comunicazione = [codice: "Errore_testo_principale_comunicazione", defaultValue: "Errore in fase di elaborazione: allegato principale della comunicazione non trovato"]

    public static final Map<String, String> Errore_salvataggio_testo_comunicazione = [codice: "Errore_salvataggio_testo_comunicazione", defaultValue: "Errore in fase di salvataggio del testo della comunicazione:\nNon è possibile cancellare/modificare il testo principale di una comunicazione"]

    public static final Map<String, String> Errore_inserimento_annotazione_su_provvisorio = [codice: "Errore_inserimento_annotazione_su_provvisorio", defaultValue: "Operazione non consentita: non è possibile associare annotazioni ad atti provvisori."]

    public static final Map<String, String> Errore_stampa_provvisorio = [codice: "Errore_stampa_provvisorio", defaultValue: "Operazione non consentita.\n Non è possibile effettuare la stampa di un atto provvisorio."]

    public static final Map<String, String> Errore_formato_export = [codice: "Errore_formato_export", defaultValue: "Formato di esportazione dati non supportato"]

    public static final Map<String, String> Errore_funzionalita_export = [codice: "Errore_funzionalita_export", defaultValue: "Funzionalità non attiva per pubblicazioni e processi verbali"]

    public static final Map<String, String> Errore_report_vuoto =  [codice: "Errore_report_vuoto", defaultValue: "Documento vuoto!"]

    public static final Map<String, String> Errore_report_troppo_lungo =  [codice: "Errore_report_troppo_lungo", defaultValue:"Il testo è troppo lungo, per questa tipologia di atto è ammessa la stampa su una sola pagina"]

    public static final Map<String, String> Errore_testo_atto = [codice: "Errore_testo_atto", defaultValue: "Errore in fase di elaborazione: il testo dell'atto non è ancora stato generato"]

    public static final Map<String, String> Errore_generazione_testo = [codice: "Errore_generazione_testo", defaultValue: "Errore in fase di generazione testo"]

    public static final Map<String, String> Errore_modello_testo_non_trovato = [codice: "Errore_modello_testo_non_trovato", defaultValue: "Modello testo non trovato"]

    public static final Map<String, String> Errore_modello_etichetta_non_trovato = [codice: "Errore_modello_etichetta_non_trovato", defaultValue: "Modello etichetta non trovato"]

    public static final Map<String, String> Errore_Competenze = [codice: "Errore_Competenze", defaultValue:"Operazione non consentita. Utente non abilitato"]

    public static final Map<String, String> Errore_Competenze_Modifica_Atto = [codice: "Errore_Competenze_Modifica_Atto", defaultValue:"Operazione non consentita. Utente non abilitato alla modifica dell'atto"]

    public static final Map<String, String> Errore_Competenze_Cancellazione_Atto = [codice: "Errore_Competenze_Cancellazione_Atto", defaultValue:"Operazione non consentita. Utente non abilitato alla cancellazione dell'atto"]

    public static final Map<String, String> Errore_Competenze_Invio_ANSC = [codice: "Errore_Competenze_Invio_ANSC", defaultValue:"Operazione non consentita. Utente non abilitato all'invio ad ANSC"]

    public static final Map<String, String> Errore_Competenze_Comunicazioni =  [codice: "Errore_Competenze_Comunicazioni", defaultValue:"Utente non abilitato alla gestione delle comunicazioni"]

    public static final Map<String, String> Errore_Competenze_Ufficio_Utente =  [codice: "Errore_Competenze_Ufficio_Utente", defaultValue:"Impossibile recuperare ufficio di competenza per l'utente corrente"]

    //public static final Map<String, String> Errore_Competenze_Protocollazione =  [codice: "Errore_Competenze_Protocollazione", defaultValue:"Utente non abilitato alla protocollazione/invio all'albo delle comunicazioni"]

    public static final Map<String, String> Errore_Disponente_DAT = [codice: "Errore_Disponente_DAT", defaultValue: "Compilare i dati del disponente"]
    public static final Map<String, String> Errore_Consenso_Invio_DAT = [codice: "Errore_Consenso_Invio_DAT", defaultValue: "Non è stato compilato il consenso all'invio della DAT!"]
    public static final Map<String, String> Errore_Reperibilita_DAT = [codice: "Errore_Reperibilita_DAT", defaultValue: "Attenzione: non è stato dato il consenso all'invio della DAT alla Banca Dati Nazionale.\nE' obbligatorio indicare la reperibilità DAT."]

    public static final Map<String, String> Errore_Consenso_Disponente = [codice: "Errore_Consenso_Disponente", defaultValue: "Attenzione: Non è stato dato il Consenso al Trattamento dei Dati (Disponente)"]
    public static final Map<String, String> Errore_Consenso_Fiduciario_1 = [codice: "Errore_Consenso_Fiduciario_1", defaultValue: "Attenzione: Non è stato dato il Consenso al Trattamento dei Dati (Fiduciario 1)"]
    public static final Map<String, String> Errore_Consenso_Fiduciario_2 = [codice: "Errore_Consenso_Fiduciario_2", defaultValue: "Attenzione: Non è stato dato il Consenso al Trattamento dei Dati (Fiduciario 2)"]

    public static final Map<String, String> Errore_Sottoscrizione_DAT_Fiduciario_1 = [codice: "Errore_Sottoscrizione_DAT_Fiduciario_1", defaultValue: "Attenzione: Non è stato indicato il flag di Sottoscrizione del Documento Acquisito (Fiduciario 1)"]
    public static final Map<String, String> Errore_Sottoscrizione_DAT_Fiduciario_2 = [codice: "Errore_Sottoscrizione_DAT_Fiduciario_2", defaultValue: "Attenzione: Non è stato indicato il flag di Sottoscrizione del Documento Acquisito (Fiduciario 2)"]

    public static final Map<String, String> Errore_Ricerca_Archivio_Soggetto = [codice: "Errore_Ricerca_Archivio_Soggetto", defaultValue: "Impossibile procedere:\nricerca non compatibile con l'archivio selezionato"]

    public static final Map<String, String> Errore_Ricerca_ANPR_No_Result = [codice: "Errore_Ricerca_ANPR_No_Result", defaultValue: "Messaggio da ANPR:\nLa richiesta effettuata non produce alcun risultato;\nverificare i parametri di ricerca e/o integrarli in modo completo"]
    public static final Map<String, String> Errore_Ricerca_ANPR_Soggetto_Non_presente = [codice: "Errore_Ricerca_ANPR_Soggetto_Non_presente", defaultValue: "Messaggio da ANPR:\nSoggetto non presente in ANPR"]
    public static final Map<String, String> Errore_Ricerca_ANPR_Down = [codice: "Errore_Ricerca_ANPR_Down", defaultValue: "Servizio ANPR non disponibile."]
    public static final Map<String, String> Errore_Ricerca_ANPR = [codice: "Errore_Ricerca_ANPR", defaultValue: "Errore in ricerca/recupero dati da ANPR"]

    public static final Map<String, String> Errore_ANPR_generazione_cer = [codice: "Errore_ANPR_generazione_cer", defaultValue: "Errore in generazione certificato ANPR"]

    public static final Map<String, String> Errore_ANSC_generazione_cer = [codice: "Errore_ANSC_generazione_cer", defaultValue: "Errore in generazione certificato ANSC"]

    public static final Map<String, String> Errore_GTE_generazione_cer = [codice: "Errore_GTE_generazione_cer", defaultValue: "Errore in generazione certificato ADS"]

    public static final Map<String, String> Errore_ANSC_Down = [codice: "Errore_ANSC_Down", defaultValue: "Messaggio da ANSC:\nNessuna risposta dal web service"]

    //public static final Map<String, String> Errore_ANSC_Consultazione_soggetto = [codice: "Errore_ANSC_Consultazione_soggetto", defaultValue: "Errore in fase di consultazione soggetto/i"]

    public static final Map<String, String> Errore_ANSC_Annullamento_link = [codice: "Errore_ANSC_Annullamento_link", defaultValue: "Impossibile effettuare l'annullamento del link per la presa visione o la verifica dell'invio. Per il firmatario selezionato non è stato effettuato l'invio mail"]

    public static final Map<String, String> Errore_ANSC_invio_atto_firmato = [codice: "Errore_ANSC_invio_atto_firmato", defaultValue: "Operazione non consentita. L'atto risulta già inviato ad ANSC e firmato dall'Ufficiale di Stato Civile"]

    public static final Map<String, String> Errore_ANSC_servizio_notifica = [codice: "Errore_ANSC_servizio_notifica", defaultValue: "Servizio di ricerca-download-conferma-rifiuto notifica non correttamente configurato"]

    public static final Map<String, String> Errore_ANSC_servizio_verifica_presa_visione = [codice: "Errore_ANSC_servizio_verifica_presa_visione", defaultValue: "Impossibile procedere:\nil servizio di verifica presa visione non risulta configurato"]

    public static final Map<String, String> Errore_ANSC_modifica_cdu = [codice: "Errore_ANSC_modifica_cdu", defaultValue: "Errore in fase di salvataggio. L'atto risulta già inviato ad ANSC con associazione a caso d'uso differente"]

    public static final Map<String, String> Errore_ANSC_abilitazione_utente = [codice: "Errore_ANSC_abilitazione_utente", defaultValue: "Utente non abilitato all'invio ad ANSC"]

    public static final Map<String, String> Errore_ANSC_cancellazione_entita = [codice: "Errore_ANSC_cancellazione_entita", defaultValue: "Cancellazione non consetita. Documento inviato ad ANSC"]

    public static final Map<String, String> Errore_Certificazioni_nessun_firmatario = [codice: "Errore_Certificazioni_nessun_firmatario", defaultValue: "Nessun utente configurato per la firma remota"]

    public static final Map<String, String> Errore_Certificazioni_utente_non_firmatario = [codice: "Errore_Certificazioni_utente_non_firmatario", defaultValue: "Utente non configurato per la firma remota"]

    public static final Map<String, String> Errore_Certificazioni_certificato_annullato = [codice: "Errore_Certificazioni_modifica_certificato_annullato", defaultValue: "Impossibile procedere: il certificato risulta annullato"]

    public static final Map<String, String> Errore_Sincronizzazione_errore = [codice: "Warn_Sincronizzazione_nessun_elemento", defaultValue: "Impossibile procedere: errore in fase di sincronizzazione"]

    public static final Map<String, String> Errore_Invio_pagamento = [codice: "Errore_Invio_pagamento", defaultValue: "Impossibile inviare pagamento.\n(%s)"]

    public static final Map<String, String> Errore_Invio_pagamento_servizi_non_coerenti = [codice: "Errore_Invio_pagamento_servizi_non_coerenti", defaultValue: "Impossibile inviare pagamento:\ni documenti selezionati contengono servizi non coerenti tra loro"]

    public static final Map<String, String> Errore_Verifica_pagamento = [codice: "Errore_Verifica_pagamento", defaultValue: "Impossibile verificare pagamento.\n(%s)"]

    public static final Map<String, String> Errore_Annulla_pagamento = [codice: "Errore_Annulla_pagamento", defaultValue: "Impossibile annullare pagamento.\n(%s)"]

    public static final Map<String, String> Errore_Utente_non_terminalista = [codice: "Errore_Utente_non_terminalista", defaultValue: "Utente non presente nel Dizionario - Terminalisti"]

    public static final Map<String, String> Errore_Ana_filtro_non_trovato = [codice: "Errore_Ana_filtro_non_trovato", defaultValue:"Per l'anagrafica selezionata non risulta disponibile alcuna categoria di certificazione"]

    public static final Map<String, String> Errore_Tariffa_diritto_associata_a_categoria = [codice: "Errore_Tariffa_diritto_associata_a_categoria", defaultValue: "La Categoria '%s' è gia associata a Tariffe/Diritti con Codice diritto '%s'"]

    public static final Map<String, String> Errore_Request_Id_non_esistente = [codice: "Errore_Request_Id_non_esistente", defaultValue: "Request Id non esistente"]

    //////////////////////////////////////////////////* INFO *////////////////////////////////////////

    public static final Map<String, String> Info_Sincronizzazione_successo = [codice: "Info_Sincronizzazione_successo", defaultValue: "Sincronizzazione completata correttamente"]

    public static final Map<String, String> Info_Invio_pagamento_successo = [codice: "Info_Invio_pagamento_successo", defaultValue: "Pagamento completato correttamente"]

    public static final Map<String, String> Info_Verifica_pagamento_successo = [codice: "Info_Verifica_pagamento_successo", defaultValue: "Verifica completata correttamente"]

    public static final Map<String, String> Info_Annullamento_pagamento_successo = [codice: "Info_Annullamento_pagamento_successo", defaultValue: "Annullamento completato correttamente"]

    public static final Map<String, String> Info_Archiviazione_Documento_Individuo = [codice: "Info_Archiviazione_Documento_Individuo", defaultValue: "Allegato acquisito su documento individuo %s numero %s"]

    public static final Map<String, String> Info_Cambio_Password = [codice: "Info_Cambio_Password", defaultValue: "Password aggiornata con successo."]

    public static final Map<String, String> Errore_atto_analogico_digitale = [codice: "Errore_atto_analogico_digitale", defaultValue: "Errore in validazione: indicare solo un atto, analogico o digitale."]
}
